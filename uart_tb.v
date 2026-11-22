`timescale 1ns/1ps
module uart_tb;
    reg clk, rst;
    reg tx_start;
    reg [7:0] tx_data;
    wire tx;
    wire tx_busy;
    wire [7:0] rx_data;
    wire rx_done;

    uart_tx tx_unit(
        .clk(clk), 
        .rst(rst), 
        .tx_start(tx_start), 
        .tx_data(tx_data), 
        .tx(tx), 
        .tx_busy(tx_busy)
    );

    uart_rx rx_unit(
        .clk(clk), 
        .rst(rst), 
        .rx(tx), 
        .rx_data(rx_data), 
        .rx_done(rx_done)
    );

    initial begin
        clk = 0;
        forever #10 clk = ~clk; // 50MHz clock
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, uart_tb);

        rst = 1;
        tx_start = 0;
        tx_data = 8'h00;
        #100;
        rst = 0;
        
        #100;
        tx_data = 8'hA5; // Test byte: 10100101
        tx_start = 1;
        #20;
        tx_start = 0;
        
        #250000; // Wait 250,000 ns for full 10-bit frame reception
        $finish;
    end
endmodule
