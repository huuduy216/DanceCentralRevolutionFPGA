module DanceCentralRevolution(clk,dancePad, SW, ADC_DOUT, VGA_R, VGA_G, VGA_B, VGA_HS, VGA_VS, VGA_BLANK_N, VGA_CLK, arrowData, ADC_CS_N, ADC_SCLK, ADC_DIN,leds);
	
	input clk;
	input [3:0]dancePad;
	input [9:0]SW; 
	input ADC_DOUT; 
	output [7:0]VGA_R; 
	output [7:0]VGA_G; 
	output [7:0]VGA_B; 
	output VGA_HS; 
	output VGA_VS; 
	output VGA_BLANK_N; 
	output VGA_CLK;
	output reg [4:0]arrowData;
	output reg [9:0]leds;
	output ADC_CS_N; 
	output ADC_SCLK; 
	output ADC_DIN;
	
	reg [7:0][11:0]adc_data;
	integer i,count;
	initial
	begin
		count = 0;
		i = 0;
		leds = 0;
	end
	//randomArrowGenerator dataGenerator(clk,Gsensor,arrowData);
	ADC adc(clk, ADC_DOUT,ADC_CS_N,ADC_DIN,ADC_SCLK,adc_data);
	
	always @ (posedge clk)
	begin	
		if(count < 5000000)
			begin
				count = count + 1;
			end
		else
			begin
				count = 0;
				leds[3:0] = dancePad;
			end
	end
	
	
endmodule