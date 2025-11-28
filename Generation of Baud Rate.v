module baud_rate_generator (input clk, output tx_enb, rx_enb);
 reg [12:0] rx_counter; 
 reg [10:0] tx_counter; 

 always @(posedge clk) begin
    if(tx_counter == 5208 )
     tx_counter = 0;
    else
        tx_counter = tx_counter + 1'b1;

 end

 always @(posedge clk) begin
    if(rx_counter == 325 )
     rx_counter = 0;
    else
        rx_counter = rx_counter + 1'b1;

 end

    assign tx_enb = (tx_counter == 0) ? 1'b1 : 1'b0;
    assign rx_enb = (rx_counter == 0) ? 1'b1 : 1'b0;
endmodule
