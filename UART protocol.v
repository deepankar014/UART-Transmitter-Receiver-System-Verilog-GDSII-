module uart_top(input  wire clk,input  wire rst,input  wire [7:0] tx_data,input  wire tx_wr_enb,input  wire rx_in,output wire tx_out,output wire [7:0] rx_data,output wire rx_rdy,output wire tx_busy);

    wire tx_enb, rx_enb;

    // Baud Rate Generator
    baud_rate_generator BRG(.clk(clk),.rst(rst),.tx_enb(tx_enb),.rx_enb(rx_enb));

    // Transmitter
    uart_tx TX(.clk(clk),.rst(rst),.wr_enb(tx_wr_enb),.enb(tx_enb),.data_in(tx_data),.tx(tx_out),.busy(tx_busy) );

    // Receiver
    uart_rx RX(.clk(clk),.rst(rst),.enb(rx_enb),.rx(rx_in),.data_out(rx_data),.rdy(rx_rdy));

endmodule

module baud_rate_generator (input clk,input rst,output reg tx_enb,output reg rx_enb);
    reg [12:0] rx_counter; 
    reg [10:0] tx_counter; 

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            tx_counter <= 0;
            rx_counter <= 0;
            tx_enb <= 0;
            rx_enb <= 0;
        end else begin
            // TX counter
            if (tx_counter == 5208) begin
                tx_counter <= 0;
                tx_enb <= 1;
            end else begin
                tx_counter <= tx_counter + 1;
                tx_enb <= 0;
            end

            // RX counter
            if (rx_counter == 325) begin
                rx_counter <= 0;
                rx_enb <= 1;
            end else begin
                rx_counter <= rx_counter + 1;
                rx_enb <= 0;
            end
        end
    end
endmodule

module uart_tx(input  wire clk,input  wire rst,input  wire wr_enb,input  wire enb,input  wire [7:0] data_in,output reg tx, output reg busy);

    localparam [1:0] S_IDLE  = 2'd0,
                     S_START = 2'd1,
                     S_DATA  = 2'd2,
                     S_STOP  = 2'd3;

    reg [1:0] state;
    reg [2:0] bit_index;    
    reg [7:0] data;         

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state     <= S_IDLE;
            tx        <= 1'b1;    
            busy      <= 1'b0;
            bit_index <= 3'd0;
            data      <= 8'd0;
        end else begin
            case (state)
                S_IDLE: begin
                    tx <= 1'b1;
                    busy <= 1'b0;
                    if (wr_enb) begin
                        data <= data_in;   
                        bit_index <= 3'd0;
                        state <= S_START;
                        busy <= 1'b1;
                    end
                end

                S_START: begin
                    if (enb) begin
                        tx <= 1'b0;        
                        state <= S_DATA;
                    end
                end

                S_DATA: begin
                    if (enb) begin
                        tx <= data[bit_index];   
                        if (bit_index == 3'd7)
                            state <= S_STOP;
                        else
                            bit_index <= bit_index + 1'b1;
                    end
                end

                S_STOP: begin
                    if (enb) begin
                        tx <= 1'b1;          
                        state <= S_IDLE;
                        busy <= 1'b0;
                    end
                end
            endcase
        end
    end
endmodule

module uart_rx(input  wire clk,input  wire rst,input  wire enb,input  wire rx,output reg [7:0] data_out,output reg rdy);

    localparam [2:0] IDLE  = 3'b000,
                     START = 3'b001,
                     DATA  = 3'b010,
                     STOP  = 3'b011,
                     DONE  = 3'b100;

    reg [2:0] state;
    reg [2:0] bit_index;
    reg [7:0] data;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state     <= IDLE;
            bit_index <= 3'd0;
            rdy       <= 1'b0;
            data_out  <= 8'd0;
        end else begin
            case (state)
                IDLE: begin
                    rdy <= 1'b0;
                    if (rx == 1'b0) // start bit detected
                        state <= START;
                end

                START: begin
                    if (enb) begin
                        if (rx == 1'b0)
                            state <= DATA;
                        else
                            state <= IDLE;
                    end
                end

                DATA: begin
                    if (enb) begin
                        data[bit_index] <= rx;
                        if (bit_index == 3'd7)
                            state <= STOP;
                        else
                            bit_index <= bit_index + 1;
                    end
                end

                STOP: begin
                    if (enb) begin
                        if (rx == 1'b1)
                            state <= DONE;
                        else
                            state <= IDLE;
                    end
                end

                DONE: begin
                    rdy <= 1'b1;
                    data_out <= data;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule

