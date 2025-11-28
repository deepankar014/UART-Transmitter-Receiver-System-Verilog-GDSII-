module rec(input clk, input rst,input enb, input rx, outpur reg[7:0]data_out,output rdy);
localparam[2:0] idle_state = 3'b000, start_state = 3'b001,
                data_state = 3'b010, stop_state = 3'b011, done_state = 3'b100;
                reg [2:0] state;
                reg [2:0] index;
                reg [7:0] data;

always @(posedge clk) begin
    if(rst)
    begin
        state<=idle_state;
        rdy<=1'b0;
        index<=3'b000;
    end
    else
    case(state)
    idle_state: begin
        rdy<=1b'0;
        if(rx ==1b'0);
        state <= start_state;
    end
    start_state: begin
        if(enb)
        begin
            if(rx==1b'0);
            state<=data_state;
            else
            state<=idle_state;
        end
    
    end
    data_state:begin
       data[index]<=rx;
        if(index == 1'd7)
        state<=done_state;
        else
        index<=index+1'b1;
    end
    stop_state: begin
        if(enb)

        if(rx==1b'1);
        state<=done_state;
    end
    done_state: begin
        rdy<=1b'1;
        data_out <=data;
        state<=idle_state;
    end
    endcase
end
endmodule
