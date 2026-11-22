module uart_rx(
    input wire clk,
    input wire rst,
    input wire rx,
    output reg [7:0] rx_data,
    output reg rx_done
);
    parameter CLKS_PER_BIT = 868;
    reg [15:0] clk_count;
    reg [3:0] bit_index;
    reg [7:0] rx_shift_reg;
    reg rx_busy;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            rx_busy <= 0;
            clk_count <= 0;
            bit_index <= 0;
            rx_done <= 0;
            rx_shift_reg <= 8'h00;
            rx_data <= 8'h00;
        end else begin
            rx_done <= 0;
            if (!rx_busy && !rx) begin // Start bit detected
                rx_busy <= 1;
                clk_count <= 0; // Aligns sampling to the middle of each data bit
                bit_index <= 0;
            end else if (rx_busy) begin
                if (clk_count < CLKS_PER_BIT - 1) begin
                    clk_count <= clk_count + 1;
                end else begin
                    clk_count <= 0;
                    if (bit_index < 8) begin
                        rx_shift_reg[bit_index] <= rx;
                        bit_index <= bit_index + 1;
                    end else begin
                        rx_busy <= 0;
                        rx_done <= 1;
                        rx_data <= rx_shift_reg;
                    end
                end
            end
        end
    end
endmodule
