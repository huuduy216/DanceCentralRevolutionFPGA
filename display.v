module display(input clk, output [7:0]VGA_R, output [7:0]VGA_G, output [7:0]VGA_B, output VGA_HS, output VGA_VS, output VGA_BLANK_N, output VGA_CLK);
// testing git

reg [9:0] mRed, mGreen, mBlue;

reg CLKHALF;
wire [10:0] VGA_X, VGA_Y;
//	VGA Controller
wire [9:0] vga_r10;
wire [9:0] vga_g10;
wire [9:0] vga_b10;
wire dummyWire;
assign VGA_R = vga_r10[9:2];
assign VGA_G = vga_g10[9:2];
assign VGA_B = vga_b10[9:2];

reg [31:0] counter, movecounter;
reg up;
reg [7:0] delta_y;

initial 
begin
	CLKHALF = 0;
	counter = 0;
	delta_y = 0;
	up = 1;
	movecounter = 0;
end


VGA_Ctrl	controller	(	//	Host Side
							.iRed(mRed),
							.iGreen(mGreen),
							.iBlue(mBlue),
							.oCurrent_X(VGA_X),
							.oCurrent_Y(VGA_Y),
							.oRequest(),
							//	VGA Side
							.oVGA_R(vga_r10 ),
							.oVGA_G(vga_g10 ),
							.oVGA_B(vga_b10 ),
							.oVGA_HS(VGA_HS),
							.oVGA_VS(VGA_VS),
							.oVGA_BLANK(VGA_BLANK_N),
							.oVGA_CLOCK(VGA_CLK),
							//	Control Signal
							.iCLK(CLKHALF),
							.iRST_N(1)	);
							
		always @(posedge clk) 
		begin
			CLKHALF = ~CLKHALF;
		end
							
		always @(posedge clk) 
		begin
			mRed   = 10'b1111111111;
			mGreen = 10'b1111111111;
			mBlue  = 10'b1111111111;
			
			counter = counter + 1;
			if (counter >= 1250000) 
			begin
				counter = 0;
				
				if (up == 1'b1) 
				begin
				   delta_y = delta_y + 1;
					movecounter = movecounter + 1'b1;
					if (movecounter >= 100) 
					begin
					   up = 1'b0;
					end

				end
				
				else if (up == 1'b0) 
				begin
				   delta_y = delta_y - 1;
					movecounter = movecounter - 1'b1;
					if (movecounter == 0) 
					begin
					   up = 1'b1;
					end
			
				end							
				
			end	
			//Green arrow
			if ((VGA_X >= 300) && (VGA_X <= 350) && (VGA_Y >= 200 ) && (VGA_Y <= 325 ))
			begin
				mRed   = 10'b0000000000;
				mGreen = 10'b1111111111;
				mBlue  = 10'b0000000000;
			end 
			
			
			if ((VGA_X >= 325) && (VGA_X <=375) && (VGA_Y >= (VGA_X - 360 )) && (VGA_Y <= 165 ))
			begin
				mRed   = 10'b0000000000;
				mGreen = 10'b1111111111;
				mBlue  = 10'b0011001100;
			end 
			if ((VGA_X >= 325) && (VGA_X <=375) && (VGA_Y >= (590 - (VGA_X) ) && (VGA_Y <= 165 )))
			begin
				mRed   = 10'b0000000000;
				mGreen = 10'b1111111111;
				mBlue  = 10'b0000000000;
			end 
			
			//Green arrow
			if ((VGA_X >= 450) && (VGA_X <= 500) && (VGA_Y >= 165 + delta_y) && (VGA_Y <= 325 + delta_y))
			begin
				mRed   = 10'b0000000000;
				mGreen = 10'b1111111111;
				mBlue  = 10'b0000000000;
			end 
			
			
			if ((VGA_X >= 475) && (VGA_X <=525) && (VGA_Y >= (VGA_X - 360 + delta_y)) && (VGA_Y <= 165 + delta_y))
			begin
				mRed   = 10'b0000000000;
				mGreen = 10'b1111111111;
				mBlue  = 10'b0011001100;
			end 
			if ((VGA_X >= 425) && (VGA_X <=475) && (VGA_Y >= (590 - (VGA_X) + delta_y) && (VGA_Y <= 165 + delta_y)))
			begin
				mRed   = 10'b0000000000;
				mGreen = 10'b1111111111;
				mBlue  = 10'b0000000000;
			end 
			
		end 						
							
endmodule

