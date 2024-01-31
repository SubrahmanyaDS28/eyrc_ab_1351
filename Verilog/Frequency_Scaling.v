module Frequency_Scaling(
    input clk_50M,
    output reg adc_clk_out
);

// Declaring registers
reg [2:0] s_clk_counter = 0;

// For ADC Module 50Mhz to 3.125Mhz
always @(negedge clk_50M) begin
    if (s_clk_counter == 7) adc_clk_out = ~adc_clk_out;
    s_clk_counter = s_clk_counter + 1'b1;
end

endmodule
