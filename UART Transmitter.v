module uart_tx(
    input  wire       clk,
    input  wire       rst,        
    input  wire       wr_enb,     
    input  wire [7:0] data_in,    
    output reg        tx,         
    output reg        busy        
);

    
    localparam [1:0] S_IDLE  = 2'd0,
                     S_START = 2'd1,
                     S_DATA  = 2'd2,
                     S_STOP  = 2'd3;

    reg [1:0] state;
    reg [2:0] bit_index;    
    reg [7:0] data;         

    
    always @(posedge clk) begin
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
                        if (bit_index == 3'd7) begin
                            state <= S_STOP;
                        end else begin
                            bit_index <= bit_index + 1'b1;
                        end
                    end
                end

                S_STOP: begin
                    if (enb) begin
                        tx <= 1'b1;          
                        state <= S_IDLE;
                        busy <= 1'b0;
                    end
                end

                default: begin
                    state <= S_IDLE;
                end
            endcase
        end
    end

endmodule
