module DanceCentralRevolution(input clk, input go_switch, input [3:0]pad, output [7:0]VGA_R, output [7:0]VGA_G, output [7:0]VGA_B, output VGA_HS, output VGA_VS, output VGA_BLANK_N, output VGA_CLK);




display mainDisplay(clk, VGA_R, VGA_G, VGA_B,VGA_HS, VGA_VS, VGA_BLANK_N, VGA_CLK);
						
							
endmodule

