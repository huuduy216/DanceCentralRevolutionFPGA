module display(input clk, input go_switch, input [3:0]pad, input [3:0]testsignal, output [7:0]VGA_R, output [7:0]VGA_G, output [7:0]VGA_B, output VGA_HS, output VGA_VS, output VGA_BLANK_N, output VGA_CLK);

reg [9:0] mRed, mGreen, mBlue;

reg [3:0] testsig;
reg [3:0] testsig2;
reg [31:0] testsigcount;

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

reg [31:0] counterl0;
reg [31:0] counterl1;
reg [31:0] counterl2;
reg [31:0] counterd0;
reg [31:0] counterd1;
reg [31:0] counterd2;
reg [31:0] counteru0;
reg [31:0] counteru1;
reg [31:0] counteru2;
reg [31:0] counterr0;
reg [31:0] counterr1;
reg [31:0] counterr2;



reg [2:0] left_active;
reg [2:0] down_active;
reg [2:0] up_active;
reg [2:0] right_active;

reg [31:0] flash_countl;
reg [31:0] flash_countd;
reg [31:0] flash_countu;
reg [31:0] flash_countr;


reg [2:0] arrowgo_left;	//decides which of the three arrows should move upwards
reg [2:0] arrowgo_down;
reg [2:0] arrowgo_up;
reg [2:0] arrowgo_right;

reg [31:0] deltay_left0;
reg [31:0] deltay_left1;
reg [31:0] deltay_left2;
reg [31:0] deltay_down0;
reg [31:0] deltay_down1;
reg [31:0] deltay_down2;
reg [31:0] deltay_up0;
reg [31:0] deltay_up1;
reg [31:0] deltay_up2;
reg [31:0] deltay_right0;
reg [31:0] deltay_right1;
reg [31:0] deltay_right2;

reg [3:0] flash_valuel;
reg [3:0] flash_valued;
reg [3:0] flash_valueu;
reg [3:0] flash_valuer;

reg [31:0] vposframe;	// vertical coordinate for the arrow frames
reg [31:0] hpos3frame;	// horizontal coordinate for the leftmost arrow frame
reg [31:0] hpos2frame;	// horizontal coordinate for the left arrow frame
reg [31:0] hpos1frame;	// horizontal coordinate for the right arrow frame
reg [31:0] hpos0frame;	// horizontal coordinate for the rightmost arrow frame

initial 
begin
	left_active = 3'b000;
	
	flash_countl = 0;
	flash_countd = 0;
	flash_countu = 0;
	flash_countr = 0;

	testsig = 0;
	testsigcount = 0;
	
	CLKHALF = 0;
	
	counterl0 = 0;
	counterl1 = 0;
	counterl2 = 0;
	counterd0 = 0;
	counterd1 = 0;
	counterd2 = 0;
	counteru0 = 0;
	counteru1 = 0;
	counteru2 = 0;
	counterr0 = 0;
	counterr1 = 0;
	counterr2 = 0;
	
	arrowgo_left[2:0] = 3'b000;
	arrowgo_down[2:0] = 3'b000;
	arrowgo_up[2:0] = 3'b000;
	arrowgo_right[2:0] = 3'b000;
	
	deltay_left0 = 336;	// vertical displacement for how far down the arrows start moving from
	deltay_left1 = 336;
	
	vposframe = 36;	// reference points for where each arrow is on the screen
	hpos3frame = 146;
	hpos2frame = 238;
	hpos1frame = 330;
	hpos0frame = 422;
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
		
			testsigcount = testsigcount + 1;
			
			if(testsigcount >= 62500000) begin	// 62500000 short, 250000000 long
			
				testsig2 = testsig2 + 1;
				//testsig = testsig2;
				testsig = 4'b1111;
				testsigcount = 0;
				
			end
			
			
			
			//initializing background shapes like arrows
			mRed   = 10'b1111111111;
			mGreen = 10'b1111111111;
			mBlue  = 10'b1111111111;
			
			//LEFTMOST 'left' ARROW, outer color
			//	triangle of the arrow
			if	((VGA_Y >= (vposframe - (VGA_X - hpos3frame)) + 30) && (VGA_Y <= (vposframe + (VGA_X - hpos3frame)) + 42) &&	// upper/lower bounds of the triangle
				(VGA_X >= (hpos3frame - 8)) && (VGA_X <= (hpos3frame + 40)))	// left/right bounds of the triangle
			begin
				mRed = 10'b1010101000;
				mGreen = 10'b1010101000;
				mBlue = 10'b1010101000;
			end
			// square of the arrow
			if	((VGA_Y >= (vposframe + 14)) && (VGA_Y <= (vposframe + 58)) &&	// upper/lower bounds of the square
				(VGA_X >= (hpos3frame + 36)) && (VGA_X <= (hpos3frame + 76)))	// left/right bounds of the square
			begin
				mRed = 10'b1010101000;
				mGreen = 10'b1010101000;
				mBlue = 10'b1010101000;
			end
			
			//LEFTMOST 'left' ARROW, inner color
			//	triangle of the arrow
			if	((VGA_Y >= (vposframe - (VGA_X - hpos3frame)) + 36) && (VGA_Y <= (vposframe + (VGA_X - hpos3frame)) + 36) &&	// upper/lower bounds of the triangle
				(VGA_X >= (hpos3frame)) && (VGA_X <= (hpos3frame + 36)))	// left/right bounds of the triangle
			begin
				mRed = 10'b1111111111;
				mGreen = 10'b1111111111;
				mBlue = 10'b1111111111;
			end
			// square of the arrow
			if	((VGA_Y >= (vposframe + 18)) && (VGA_Y <= (vposframe + 54)) &&	// upper/lower bounds of the square
				(VGA_X >= (hpos3frame + 36)) && (VGA_X <= (hpos3frame + 72)))	// left/right bounds of the square
			begin
				mRed = 10'b1111111111;
				mGreen = 10'b1111111111;
				mBlue = 10'b1111111111;
			end
			
			
			//LEFT 'down' ARROW, outer color
			//	triangle of the arrow
			if	((VGA_Y >= (vposframe + 32)) && (VGA_Y <= (vposframe + 80)) &&	// upper/lower bounds of the triangle
				(VGA_X >= (hpos2frame - (vposframe + 72 - VGA_Y) + 30)) && (VGA_X <= (hpos2frame + (vposframe + 72 - VGA_Y)) + 42))	// left/right bounds of the triangle
			begin
				mRed = 10'b1010101000;
				mGreen = 10'b1010101000;
				mBlue = 10'b1010101000;
			end
			// square of the arrow
			if	((VGA_Y >= (vposframe - 4)) && (VGA_Y <= (vposframe + 40)) &&	// upper/lower bounds of the square
				(VGA_X >= (hpos2frame + 14)) && (VGA_X <= (hpos2frame + 58)))	// left/right bounds of the square
			begin
				mRed = 10'b1010101000;
				mGreen = 10'b1010101000;
				mBlue = 10'b1010101000;
			end
			
			//LEFT 'down' ARROW, inner color
			//	triangle of the arrow
			if	((VGA_Y >= (vposframe + 36)) && (VGA_Y <= (vposframe + 72)) &&	// upper/lower bounds of the triangle
				(VGA_X >= (hpos2frame - (vposframe + 72 - VGA_Y) + 36)) && (VGA_X <= (hpos2frame + (vposframe + 72 - VGA_Y)) + 36))	// left/right bounds of the triangle
			begin
				mRed = 10'b1111111111;
				mGreen = 10'b1111111111;
				mBlue = 10'b1111111111;
			end
			// square of the arrow
			if	((VGA_Y >= (vposframe)) && (VGA_Y <= (vposframe + 36)) &&	// upper/lower bounds of the square
				(VGA_X >= (hpos2frame + 18)) && (VGA_X <= (hpos2frame + 54)))	// left/right bounds of the square
			begin
				mRed = 10'b1111111111;
				mGreen = 10'b1111111111;
				mBlue = 10'b1111111111;
			end
			
			
			//RIGHT 'up' ARROW, outer color
			//	triangle of the arrow
			if	((VGA_Y >= (vposframe - 8)) && (VGA_Y <= (vposframe + 40)) &&	// upper/lower bounds of the triangle
				(VGA_X >= (hpos1frame - (VGA_Y - vposframe) + 30)) && (VGA_X <= (hpos1frame + (VGA_Y - vposframe) + 42)))	// left/right bounds of the triangle
			begin
				mRed = 10'b1010101000;
				mGreen = 10'b1010101000;
				mBlue = 10'b1010101000;
			end
			// square of the arrow
			if	((VGA_Y >= (vposframe + 36)) && (VGA_Y <= (vposframe + 76)) &&	// upper/lower bounds of the square
				(VGA_X >= (hpos1frame + 14)) && (VGA_X <= (hpos1frame + 58)))	// left/right bounds of the square
			begin
				mRed = 10'b1010101000;
				mGreen = 10'b1010101000;
				mBlue = 10'b1010101000;
			end
			
			//RIGHT 'up' ARROW, inner color
			//	triangle of the arrow
			if	((VGA_Y >= (vposframe)) && (VGA_Y <= (vposframe + 36)) &&	// upper/lower bounds of the triangle
				(VGA_X >= (hpos1frame - (VGA_Y - vposframe) + 36)) && (VGA_X <= (hpos1frame + (VGA_Y - vposframe) + 36)))	// left/right bounds of the triangle
			begin
				mRed = 10'b1111111111;
				mGreen = 10'b1111111111;
				mBlue = 10'b1111111111;
			end
			// square of the arrow
			if	((VGA_Y >= (vposframe + 36)) && (VGA_Y <= (vposframe + 72)) &&	// upper/lower bounds of the square
				(VGA_X >= (hpos1frame + 18)) && (VGA_X <= (hpos1frame + 54)))	// left/right bounds of the square
			begin
				mRed = 10'b1111111111;
				mGreen = 10'b1111111111;
				mBlue = 10'b1111111111;
			end
			
			// RIGHTMOST 'right' ARROW, outer color
			//	triangle of the arrow
			if	((VGA_Y >= (vposframe - (hpos0frame + 72 - VGA_X)) + 30) && (VGA_Y <= (vposframe + (hpos0frame + 72 - VGA_X)) + 42) &&	// upper/lower bounds of the triangle
				(VGA_X >= (hpos0frame + 32)) && (VGA_X <= (hpos0frame + 80)))	// left/right bounds of the triangle
			begin
				mRed = 10'b1010101000;
				mGreen = 10'b1010101000;
				mBlue = 10'b1010101000;
			end
			// square of the arrow
			if	((VGA_Y >= (vposframe + 14)) && (VGA_Y <= (vposframe + 58)) &&	// upper/lower bounds of the square
				(VGA_X >= (hpos0frame - 4)) && (VGA_X <= (hpos0frame + 36)))	// left/right bounds of the square
			begin
				mRed = 10'b1010101000;
				mGreen = 10'b1010101000;
				mBlue = 10'b1010101000;
			end
			
			// RIGHTMOST 'right' ARROW, inner color
			//	triangle of the arrow
			if	((VGA_Y >= (vposframe - (hpos0frame + 72 - VGA_X)) + 36) && (VGA_Y <= (vposframe + (hpos0frame + 72 - VGA_X)) + 36) &&	// upper/lower bounds of the triangle
				(VGA_X >= (hpos0frame + 36)) && (VGA_X <= (hpos0frame + 72)))	// left/right bounds of the triangle
			begin
				mRed = 10'b1111111111;
				mGreen = 10'b1111111111;
				mBlue = 10'b1111111111;
			end
			// square of the arrow
			if	((VGA_Y >= (vposframe + 18)) && (VGA_Y <= (vposframe + 54)) &&	// upper/lower bounds of the square
				(VGA_X >= (hpos0frame)) && (VGA_X <= (hpos0frame + 36)))	// left/right bounds of the square
			begin
				mRed = 10'b1111111111;
				mGreen = 10'b1111111111;
				mBlue = 10'b1111111111;
			end
			
			

			if(!(flash_valuel == 4'b0000)) begin	//flashes for a certain duration if a button is pressed
			
				flash_countl = flash_countl + 1;
				
				if(flash_valuel == 4'b0001) begin 
				
					if	((VGA_Y > 0) && (VGA_Y < 20) && (VGA_X > 130) && (VGA_X < 236)) begin
						mRed = 10'b1111111111;
						mGreen = 10'b1111111111;
						mBlue = 10'b0000000000;
					end
				
					flash_countl = flash_countl + 1;
					
					if(flash_countl >= 30000000) begin
					
						flash_valuel = 4'b0000;
						flash_countl = 0;
						
					end
					
				end
				
				else if(flash_valuel == 4'b0010) begin 
				
					if	((VGA_Y > 0) && (VGA_Y < 20) && (VGA_X > 130) && (VGA_X < 236)) begin
						mRed = 10'b0000000000;
						mGreen = 10'b1111111111;
						mBlue = 10'b0000000000;
					end
				
					flash_countl = flash_countl + 1;
					
					if(flash_countl >= 30000000) begin
					
						flash_valuel = 4'b0000;
						flash_countl = 0;
						
					end
					
				end
			
			end
			
			
			

			if(arrowgo_left[0] & ((deltay_left0 < deltay_left1) & (deltay_left0 < deltay_left2)) & (flash_valuel == 4'b0000)) begin	// waits for the first Left arrow to trigger color flash
																																											// and for this arrow to be the closest to the frame
																																											// and for the previous flash to be done flashing
				if(left_active[0]) begin
				
					
					if((deltay_left0 < 300 && deltay_left0 >= 60) & !pad[3]) begin	// early, missed note
					
						if	((VGA_Y > 0) && (VGA_Y < 20) && (VGA_X > 130) && (VGA_X < 236)) begin
							mRed = 10'b1111111111;
							mGreen = 10'b0000000000;
							mBlue = 10'b0000000000;
						end
						
						
					end
					else if((deltay_left0 < 60 && deltay_left0 >= 20) & !pad[3]) begin	// early note
						
						left_active[0] = 1'b0;
						flash_valuel = 4'b0001;
						
					end
					else if((deltay_left0 < 20) & !pad[3]) begin	// on time note
						
						left_active[0] = 1'b0;
						flash_valuel = 4'b0010;
						
					end
					
				end
				
			end
			
			
			
			if(arrowgo_left[1] & ((deltay_left1 < deltay_left0) & (deltay_left1 < deltay_left2)) & (flash_valuel == 4'b0000)) begin	// waits for a second Left arrow to trigger color flash
	
				
				if(left_active[1]) begin
				
					
					if((deltay_left1 < 300 && deltay_left1 >= 60) & !pad[3]) begin	// early, missed note
					
						if	((VGA_Y > 0) && (VGA_Y < 20) && (VGA_X > 130) && (VGA_X < 236)) begin
							mRed = 10'b1111111111;
							mGreen = 10'b0000000000;
							mBlue = 10'b0000000000;
						end
						
						
					end
					else if((deltay_left1 < 60 && deltay_left1 >= 20) & !pad[3]) begin	// early note
						
						left_active[1] = 1'b0;
						flash_valuel = 4'b0001;
						
					end
					else if((deltay_left1 < 20) & !pad[3]) begin	// on time note
						
						left_active[1] = 1'b0;
						flash_valuel = 4'b0010;
						
					end
					
				end
				
			end
			
			
			
			
			
			if(arrowgo_left[2] & ((deltay_left2 < deltay_left0) & (deltay_left0 < deltay_left1)) & (flash_valuel == 4'b0000)) begin	// waits for a third Left arrow to trigger color flash
	
				
				if(left_active[2]) begin
				
					
					if((deltay_left2 < 300 && deltay_left2 >= 60) & !pad[3]) begin	// early, missed note
					
						if	((VGA_Y > 0) && (VGA_Y < 20) && (VGA_X > 130) && (VGA_X < 236)) begin
							mRed = 10'b1111111111;
							mGreen = 10'b0000000000;
							mBlue = 10'b0000000000;
						end
						
						
					end
					else if((deltay_left2 < 60 && deltay_left2 >= 20) & !pad[3]) begin	// early note
						
						left_active[2] = 1'b0;
						flash_valuel = 4'b0001;
						
					end
					else if((deltay_left2 < 20) & !pad[3]) begin	// on time note
						
						left_active[2] = 1'b0;
						flash_valuel = 4'b0010;
						
					end
					
				end
				
			end
			
			
			////////START
			
			if(!(flash_valued == 4'b0000)) begin	//flashes for a certain duration if a button is pressed
			
				flash_countd = flash_countd + 1;
				
				if(flash_valued == 4'b0001) begin 
				
					if	((VGA_Y > 0) && (VGA_Y < 20) && (VGA_X > 228) && (VGA_X < 321)) begin
						mRed = 10'b1111111111;
						mGreen = 10'b1111111111;
						mBlue = 10'b0000000000;
					end
				
					flash_countd = flash_countd + 1;
					
					if(flash_countd >= 30000000) begin
					
						flash_valued = 4'b0000;
						flash_countd = 0;
						
					end
					
				end
				
				else if(flash_valued == 4'b0010) begin 
				
					if	((VGA_Y > 0) && (VGA_Y < 20) && (VGA_X > 228) && (VGA_X < 321)) begin
						mRed = 10'b0000000000;
						mGreen = 10'b1111111111;
						mBlue = 10'b0000000000;
					end
				
					flash_countd = flash_countd + 1;
					
					if(flash_countd >= 30000000) begin
					
						flash_valued = 4'b0000;
						flash_countd = 0;
						
					end
					
				end
			
			end
			
			
			
			

			if(arrowgo_down[0] & ((deltay_down0 < deltay_down1) & (deltay_down0 < deltay_down2)) & (flash_valued == 4'b0000)) begin	// waits for the first Left arrow to trigger color flash
																																											// and for this arrow to be the closest to the frame
																																											// and for the previous flash to be done flashing
				if(down_active[0]) begin
				
					
					if((deltay_down0 < 300 && deltay_down0 >= 60) & !pad[2]) begin	// early, missed note
					
						if	((VGA_Y > 0) && (VGA_Y < 20) && (VGA_X > 228) && (VGA_X < 321)) begin
							mRed = 10'b1111111111;
							mGreen = 10'b0000000000;
							mBlue = 10'b0000000000;
						end
						
						
					end
					else if((deltay_down0 < 60 && deltay_down0 >= 20) & !pad[2]) begin	// early note
						
						down_active[0] = 1'b0;
						flash_valued = 4'b0001;
						
					end
					else if((deltay_down0 < 20) & !pad[2]) begin	// on time note
						
						down_active[0] = 1'b0;
						flash_valued = 4'b0010;
						
					end
					
				end
				
			end
			
			
			
			if(arrowgo_down[1] & ((deltay_down1 < deltay_down0) & (deltay_down1 < deltay_down2)) & (flash_valued == 4'b0000)) begin	// waits for a second Left arrow to trigger color flash
	
				
				if(down_active[1]) begin
				
					
					if((deltay_down1 < 300 && deltay_down1 >= 60) & !pad[2]) begin	// early, missed note
					
						if	((VGA_Y > 0) && (VGA_Y < 20) && (VGA_X > 228) && (VGA_X < 321)) begin
							mRed = 10'b1111111111;
							mGreen = 10'b0000000000;
							mBlue = 10'b0000000000;
						end
						
						
					end
					else if((deltay_down1 < 60 && deltay_down1 >= 20) & !pad[2]) begin	// early note
						
						down_active[1] = 1'b0;
						flash_valued = 4'b0001;
						
					end
					else if((deltay_down1 < 20) & !pad[2]) begin	// on time note
						
						down_active[1] = 1'b0;
						flash_valued = 4'b0010;
						
					end
					
				end
				
			end
			
			
			
			
			
			if(arrowgo_down[2] & ((deltay_down2 < deltay_down0) & (deltay_down0 < deltay_down1)) & (flash_valued == 4'b0000)) begin	// waits for a third Left arrow to trigger color flash
	
				
				if(down_active[2]) begin
				
					
					if((deltay_down2 < 300 && deltay_down2 >= 60) & !pad[2]) begin	// early, missed note
					
						if	((VGA_Y > 0) && (VGA_Y < 20) && (VGA_X > 228) && (VGA_X < 321)) begin
							mRed = 10'b1111111111;
							mGreen = 10'b0000000000;
							mBlue = 10'b0000000000;
						end
						
						
					end
					else if((deltay_down2 < 60 && deltay_down2 >= 20) & !pad[2]) begin	// early note
						
						down_active[2] = 1'b0;
						flash_valued = 4'b0001;
						
					end
					else if((deltay_down2 < 20) & !pad[2]) begin	// on time note
						
						down_active[2] = 1'b0;
						flash_valued = 4'b0010;
						
					end
					
				end
				
			end
			
			
			
			
			//////////////////////
			
			
			
			if(!(flash_valueu == 4'b0000)) begin	//flashes for a certain duration if a button is pressed
			
				flash_countu = flash_countu + 1;
				
				if(flash_valueu == 4'b0001) begin 
				
					if	((VGA_Y > 0) && (VGA_Y < 20) && (VGA_X > 320) && (VGA_X < 413)) begin
						mRed = 10'b1111111111;
						mGreen = 10'b1111111111;
						mBlue = 10'b0000000000;
					end
				
					flash_countu = flash_countu + 1;
					
					if(flash_countu >= 30000000) begin
					
						flash_valueu = 4'b0000;
						flash_countu = 0;
						
					end
					
				end
				
				else if(flash_valueu == 4'b0010) begin 
				
					if	((VGA_Y > 0) && (VGA_Y < 20) && (VGA_X > 320) && (VGA_X < 413)) begin
						mRed = 10'b0000000000;
						mGreen = 10'b1111111111;
						mBlue = 10'b0000000000;
					end
				
					flash_countu = flash_countu + 1;
					
					if(flash_countu >= 30000000) begin
					
						flash_valueu = 4'b0000;
						flash_countu = 0;
						
					end
					
				end
			
			end
			
			
			
			

			if(arrowgo_up[0] & ((deltay_up0 < deltay_up1) & (deltay_up0 < deltay_up2)) & (flash_valueu == 4'b0000)) begin	// waits for the first Left arrow to trigger color flash
																																											// and for this arrow to be the closest to the frame
																																											// and for the previous flash to be done flashing
				if(up_active[0]) begin
				
					
					if((deltay_up0 < 300 && deltay_up0 >= 60) & !pad[1]) begin	// early, missed note
					
						if	((VGA_Y > 0) && (VGA_Y < 20) && (VGA_X > 320) && (VGA_X < 413)) begin
							mRed = 10'b1111111111;
							mGreen = 10'b0000000000;
							mBlue = 10'b0000000000;
						end
						
						
					end
					else if((deltay_up0 < 60 && deltay_up0 >= 20) & !pad[1]) begin	// early note
						
						up_active[0] = 1'b0;
						flash_valueu = 4'b0001;
						
					end
					else if((deltay_up0 < 20) & !pad[1]) begin	// on time note
						
						up_active[0] = 1'b0;
						flash_valueu = 4'b0010;
						
					end
					
				end
				
			end
			
			
			
			if(arrowgo_up[1] & ((deltay_up1 < deltay_up0) & (deltay_up1 < deltay_up2)) & (flash_valueu == 4'b0000)) begin	// waits for a second Left arrow to trigger color flash
	
				
				if(up_active[1]) begin
				
					
					if((deltay_up1 < 300 && deltay_up1 >= 60) & !pad[1]) begin	// early, missed note
					
						if	((VGA_Y > 0) && (VGA_Y < 20) && (VGA_X > 320) && (VGA_X < 413)) begin
							mRed = 10'b1111111111;
							mGreen = 10'b0000000000;
							mBlue = 10'b0000000000;
						end
						
						
					end
					else if((deltay_up1 < 60 && deltay_up1 >= 15) & !pad[1]) begin	// early note
						
						up_active[1] = 1'b0;
						flash_valueu = 4'b0001;
						
					end
					else if((deltay_up1 < 15) & !pad[1]) begin	// on time note
						
						up_active[1] = 1'b0;
						flash_valueu = 4'b0010;
						
					end
					
				end
				
			end
			
			
			
			
			
			if(arrowgo_up[2] & ((deltay_up2 < deltay_up0) & (deltay_up0 < deltay_up1)) & (flash_valueu == 4'b0000)) begin	// waits for a third Left arrow to trigger color flash
	
				
				if(up_active[2]) begin
				
					
					if((deltay_up2 < 300 && deltay_up2 >= 60) & !pad[1]) begin	// early, missed note
					
						if	((VGA_Y > 0) && (VGA_Y < 20) && (VGA_X > 320) && (VGA_X < 413)) begin
							mRed = 10'b1111111111;
							mGreen = 10'b0000000000;
							mBlue = 10'b0000000000;
						end
						
						
					end
					else if((deltay_up2 < 60 && deltay_up2 >= 20) & !pad[1]) begin	// early note
						
						up_active[2] = 1'b0;
						flash_valueu = 4'b0001;
						
					end
					else if((deltay_up2 < 20) & !pad[1]) begin	// on time note
						
						up_active[2] = 1'b0;
						flash_valueu = 4'b0010;
						
					end
					
				end
				
			end
			
			
			
			
			///////////////
			
			
			
			if(!(flash_valuer == 4'b0000)) begin	//flashes for a certain duration if a button is pressed
			
				flash_countr = flash_countr + 1;
				
				if(flash_valuer == 4'b0001) begin 
				
					if	((VGA_Y > 0) && (VGA_Y < 20) && (VGA_X > 412) && (VGA_X < 504)) begin
						mRed = 10'b1111111111;
						mGreen = 10'b1111111111;
						mBlue = 10'b0000000000;
					end
				
					flash_countr = flash_countr + 1;
					
					if(flash_countr >= 30000000) begin
					
						flash_valuer = 4'b0000;
						flash_countr = 0;
						
					end
					
				end
				
				else if(flash_valuer == 4'b0010) begin 
				
					if	((VGA_Y > 0) && (VGA_Y < 20) && (VGA_X > 412) && (VGA_X < 504)) begin
						mRed = 10'b0000000000;
						mGreen = 10'b1111111111;
						mBlue = 10'b0000000000;
					end
				
					flash_countr = flash_countr + 1;
					
					if(flash_countr >= 30000000) begin
					
						flash_valuer = 4'b0000;
						flash_countr = 0;
						
					end
					
				end
			
			end
			
			
			
			

			if(arrowgo_right[0] & ((deltay_right0 < deltay_right1) & (deltay_right0 < deltay_right2)) & (flash_valuer == 4'b0000)) begin	// waits for the first Left arrow to trigger color flash
																																											// and for this arrow to be the closest to the frame
																																											// and for the previous flash to be done flashing
				if(right_active[0]) begin
				
					
					if((deltay_right0 < 300 && deltay_right0 >= 60) & !pad[0]) begin	// early, missed note
					
						if	((VGA_Y > 0) && (VGA_Y < 20) && (VGA_X > 412) && (VGA_X < 504)) begin
							mRed = 10'b1111111111;
							mGreen = 10'b0000000000;
							mBlue = 10'b0000000000;
						end
						
						
					end
					else if((deltay_right0 < 60 && deltay_right0 >= 20) & !pad[0]) begin	// early note
						
						right_active[0] = 1'b0;
						flash_valuer = 4'b0001;
						
					end
					else if((deltay_right0 < 20) & !pad[0]) begin	// on time note
						
						right_active[0] = 1'b0;
						flash_valuer = 4'b0010;
						
					end
					
				end
				
			end
			
			
			
			if(arrowgo_right[1] & ((deltay_right1 < deltay_right0) & (deltay_right1 < deltay_right2)) & (flash_valuer == 4'b0000)) begin	// waits for a second Left arrow to trigger color flash
	
				
				if(right_active[1]) begin
				
					
					if((deltay_right1 < 300 && deltay_right1 >= 60) & !pad[0]) begin	// early, missed note
					
						if	((VGA_Y > 0) && (VGA_Y < 20) && (VGA_X > 412) && (VGA_X < 504)) begin
							mRed = 10'b1111111111;
							mGreen = 10'b0000000000;
							mBlue = 10'b0000000000;
						end
						
						
					end
					else if((deltay_right1 < 60 && deltay_right1 >= 20) & !pad[0]) begin	// early note
						
						right_active[1] = 1'b0;
						flash_valuer = 4'b0001;
						
					end
					else if((deltay_right1 < 20) & !pad[0]) begin	// on time note
						
						right_active[1] = 1'b0;
						flash_valuer = 4'b0010;
						
					end
					
				end
				
			end
			
			
			
			
			
			if(arrowgo_right[2] & ((deltay_right2 < deltay_right0) & (deltay_right0 < deltay_right1)) & (flash_valuer == 4'b0000)) begin	// waits for a third Left arrow to trigger color flash
	
				
				if(right_active[2]) begin
				
					
					if((deltay_right2 < 300 && deltay_right2 >= 60) & !pad[0]) begin	// early, missed note
					
						if	((VGA_Y > 0) && (VGA_Y < 20) && (VGA_X > 412) && (VGA_X < 504)) begin
							mRed = 10'b1111111111;
							mGreen = 10'b0000000000;
							mBlue = 10'b0000000000;
						end
						
						
					end
					else if((deltay_right2 < 60 && deltay_right2 >= 20) & !pad[0]) begin	// early note
						
						right_active[2] = 1'b0;
						flash_valuer = 4'b0001;
						
					end
					else if((deltay_right2 < 20) & !pad[0]) begin	// on time note
						
						right_active[2] = 1'b0;
						flash_valuer = 4'b0010;
						
					end
					
				end
				
			end
			
			
			
			
			//////END
			
			
			
			if(testsig[3]) begin	// sends out the correct arrow depending on which ones are already active
				
				if(!arrowgo_left[0]) begin
					arrowgo_left[0] = 1'b1; // starts the arrow going upwards
					left_active[0] = 1;		// begins to listen to button presses
				end
				else if(!arrowgo_left[1]) begin
					arrowgo_left[1] = 1'b1;
					left_active[1] = 1;
				end
				else if(!arrowgo_left[2]) begin
					arrowgo_left[2] = 1'b1;
					left_active[2] = 1;
				end
			
				testsig[3] = 1'b0;
				
			end
			
	
			if(testsig[2]) begin
				
				if(!arrowgo_down[0]) begin
					arrowgo_down[0] = 1'b1;
					down_active[0] = 1;
				end
				else if(!arrowgo_down[1]) begin
					arrowgo_down[1] = 1'b1;
					down_active[1] = 1;
				end
				else if(!arrowgo_down[2]) begin
					arrowgo_down[2] = 1'b1;
					down_active[1] = 1;
				end
			
				testsig[2] = 1'b0;
				
			end
			
			
			if(testsig[1]) begin
				
				if(!arrowgo_up[0]) begin
					arrowgo_up[0] = 1'b1;
					up_active[0] = 1;
				end
				else if(!arrowgo_up[1]) begin
					arrowgo_up[1] = 1'b1;
					up_active[1] = 1;
				end
				else if(!arrowgo_up[2]) begin
					arrowgo_up[2] = 1'b1;
					up_active[2] = 1;
				end
			
				testsig[1] = 1'b0;
				
			end
			
			
			if(testsig[0]) begin
				
				if(!arrowgo_right[0]) begin
					arrowgo_right[0] = 1'b1;
					right_active[0] = 1;
				end
				else if(!arrowgo_right[1]) begin
					arrowgo_right[1] = 1'b1;
					right_active[1] = 1;
				end
				else if(!arrowgo_right[2]) begin
					arrowgo_right[2] = 1'b1;
					right_active[2] = 1;
				end
			
				testsig[0] = 1'b0;
				
			end
			
			
			
			
			
			
			
			
			
			if(arrowgo_left[0]) begin	// sends an arrow upwards
			
				counterl0 = counterl0 + 1;
				
				if(counterl0 >= 500000)
				begin
				
					counterl0 = 0;
					deltay_left0 = deltay_left0 - 1;
					
				end
				
				if(deltay_left0 <= 0)
				begin
				
					deltay_left0 = 336;
					arrowgo_left[0] = 1'b0;
					
				end
			
				// LEFTMOST 'left' arrow moving upwards
				// triangle of the arrow
				if	((VGA_Y >= (vposframe - (VGA_X - hpos3frame)) + 36 + deltay_left0) && (VGA_Y <= (vposframe + (VGA_X - hpos3frame)) + 36 + deltay_left0) &&	// upper/lower bounds of the triangle
					(VGA_X >= (hpos3frame)) && (VGA_X <= (hpos3frame + 36)))	// left/right bounds of the triangle
				begin
					mRed = 10'b1111111111;
					mGreen = 10'b0000000000;
					mBlue = 10'b0000000000;
				end
				// square of the arrow
				if	((VGA_Y >= (vposframe + 18 + deltay_left0)) && (VGA_Y <= (vposframe + 54 + deltay_left0)) &&	// upper/lower bounds of the square
					(VGA_X >= (hpos3frame + 36)) && (VGA_X <= (hpos3frame + 72)))	// left/right bounds of the square
				begin
					mRed = 10'b1111111111;
					mGreen = 10'b0000000000;
					mBlue = 10'b0000000000;
				end
				
			end	
			
			
			
			if(arrowgo_left[1]) begin
			
				counterl1 = counterl1 + 1;
				
				if(counterl1 >= 500000)
				begin
				
					counterl1 = 0;
					deltay_left1 = deltay_left1 - 1;
					
				end
				
				if(deltay_left1 <= 0)
				begin
				
					deltay_left1 = 336;
					arrowgo_left[1] = 1'b0;
					
				end
				
				
				// LEFTMOST 'left' arrow moving upwards
				// triangle of the arrow
				if	((VGA_Y >= (vposframe - (VGA_X - hpos3frame)) + 36 + deltay_left1) && (VGA_Y <= (vposframe + (VGA_X - hpos3frame)) + 36 + deltay_left1) &&	// upper/lower bounds of the triangle
					(VGA_X >= (hpos3frame)) && (VGA_X <= (hpos3frame + 36)))	// left/right bounds of the triangle
				begin
					mRed = 10'b1111111111;
					mGreen = 10'b0000000000;
					mBlue = 10'b0000000000;
				end
				// square of the arrow
				if	((VGA_Y >= (vposframe + 18 + deltay_left1)) && (VGA_Y <= (vposframe + 54 + deltay_left1)) &&	// upper/lower bounds of the square
					(VGA_X >= (hpos3frame + 36)) && (VGA_X <= (hpos3frame + 72)))	// left/right bounds of the square
				begin
					mRed = 10'b1111111111;
					mGreen = 10'b0000000000;
					mBlue = 10'b0000000000;
				end
				
			end
			
			
			if(arrowgo_left[2]) begin
			
				counterl2 = counterl2 + 1;
				
				if(counterl2 >= 500000)
				begin
				
					counterl2 = 0;
					deltay_left2 = deltay_left2 - 1;
					
				end
				
				if(deltay_left2 <= 0)
				begin
				
					deltay_left2 = 336;
					arrowgo_left[2] = 1'b0;
					
				end
				
				
				// LEFTMOST 'left' arrow moving upwards
				// triangle of the arrow
				if	((VGA_Y >= (vposframe - (VGA_X - hpos3frame)) + 36 + deltay_left2) && (VGA_Y <= (vposframe + (VGA_X - hpos3frame)) + 36 + deltay_left2) &&	// upper/lower bounds of the triangle
					(VGA_X >= (hpos3frame)) && (VGA_X <= (hpos3frame + 36)))	// left/right bounds of the triangle
				begin
					mRed = 10'b1111111111;
					mGreen = 10'b0000000000;
					mBlue = 10'b0000000000;
				end
				// square of the arrow
				if	((VGA_Y >= (vposframe + 18 + deltay_left2)) && (VGA_Y <= (vposframe + 54 + deltay_left2)) &&	// upper/lower bounds of the square
					(VGA_X >= (hpos3frame + 36)) && (VGA_X <= (hpos3frame + 72)))	// left/right bounds of the square
				begin
					mRed = 10'b1111111111;
					mGreen = 10'b0000000000;
					mBlue = 10'b0000000000;
				end
				
			end
			
			
			
			

			if(arrowgo_down[0]) begin
			
				counterd0 = counterd0 + 1;
				
				if(counterd0 >= 500000)
				begin
				
					counterd0 = 0;
					deltay_down0 = deltay_down0 - 1;
					
				end
				
				if(deltay_down0 <= 0)
				begin
				
					deltay_down0 = 336;
					arrowgo_down[0] = 1'b0;
					
				end
			
				//LEFT 'down' ARROW, inner color
				//	triangle of the arrow
				if	((VGA_Y >= (vposframe + 36 + deltay_down0)) && (VGA_Y <= (vposframe + 72 + deltay_down0)) &&	// upper/lower bounds of the triangle
					(VGA_X >= (hpos2frame - (vposframe + deltay_down0 + 72 - VGA_Y) + 36)) && (VGA_X <= (hpos2frame + (vposframe + deltay_down0 + 72 - VGA_Y)) + 36))	// left/right bounds of the triangle
				begin
					mRed = 10'b1111111111;
					mGreen = 10'b1111111111;
					mBlue = 10'b0000000000;
				end
				// square of the arrow
				if	((VGA_Y >= (vposframe + deltay_down0)) && (VGA_Y <= (vposframe + 36 + deltay_down0)) &&	// upper/lower bounds of the square
					(VGA_X >= (hpos2frame + 18)) && (VGA_X <= (hpos2frame + 54)))	// left/right bounds of the square
				begin
					mRed = 10'b1111111111;
					mGreen = 10'b1111111111;
					mBlue = 10'b0000000000;
				end
				
			end	
			
	
			if(arrowgo_down[1]) begin
			
				counterd1 = counterd1 + 1;
				
				if(counterd1 >= 500000)
				begin
				
					counterd1 = 0;
					deltay_down1 = deltay_down1 - 1;
					
				end
				
				if(deltay_down1 <= 0)
				begin
				
					deltay_down1 = 336;
					arrowgo_down[1] = 1'b0;
					
				end
				
				
				//LEFT 'down' ARROW, inner color
				//	triangle of the arrow
				if	((VGA_Y >= (vposframe + 36 + deltay_down1)) && (VGA_Y <= (vposframe + 72 + deltay_down1)) &&	// upper/lower bounds of the triangle
					(VGA_X >= (hpos2frame - (vposframe + deltay_down1 + 72 - VGA_Y) + 36)) && (VGA_X <= (hpos2frame + (vposframe + deltay_down1 + 72 - VGA_Y)) + 36))	// left/right bounds of the triangle
				begin
					mRed = 10'b1111111111;
					mGreen = 10'b1111111111;
					mBlue = 10'b0000000000;
				end
				// square of the arrow
				if	((VGA_Y >= (vposframe + deltay_down1)) && (VGA_Y <= (vposframe + 36 + deltay_down1)) &&	// upper/lower bounds of the square
					(VGA_X >= (hpos2frame + 18)) && (VGA_X <= (hpos2frame + 54)))	// left/right bounds of the square
				begin
					mRed = 10'b1111111111;
					mGreen = 10'b1111111111;
					mBlue = 10'b0000000000;
				end
				
			end
			
			
			if(arrowgo_down[2]) begin
			
				counterd2 = counterd2 + 1;
				
				if(counterd2 >= 500000)
				begin
				
					counterd2 = 0;
					deltay_down2 = deltay_down2 - 1;
					
				end
				
				if(deltay_down2 <= 0)
				begin
				
					deltay_down2 = 336;
					arrowgo_down[2] = 1'b0;
					
				end
				
				
				//LEFT 'down' ARROW, inner color
				//	triangle of the arrow
				if	((VGA_Y >= (vposframe + 36 + deltay_down2)) && (VGA_Y <= (vposframe + 72 + deltay_down2)) &&	// upper/lower bounds of the triangle
					(VGA_X >= (hpos2frame - (vposframe + deltay_down2 + 72 - VGA_Y) + 36)) && (VGA_X <= (hpos2frame + (vposframe + deltay_down2 + 72 - VGA_Y)) + 36))	// left/right bounds of the triangle
				begin
					mRed = 10'b1111111111;
					mGreen = 10'b1111111111;
					mBlue = 10'b0000000000;
				end
				// square of the arrow
				if	((VGA_Y >= (vposframe + deltay_down2)) && (VGA_Y <= (vposframe + 36 + deltay_down2)) &&	// upper/lower bounds of the square
					(VGA_X >= (hpos2frame + 18)) && (VGA_X <= (hpos2frame + 54)))	// left/right bounds of the square
				begin
					mRed = 10'b1111111111;
					mGreen = 10'b1111111111;
					mBlue = 10'b0000000000;
				end
				
			end
			
			
			
			
			
			
			
			
			if(arrowgo_up[0]) begin
			
				counteru0 = counteru0 + 1;
				
				if(counteru0 >= 500000)
				begin
				
					counteru0 = 0;
					deltay_up0 = deltay_up0 - 1;
					
				end
				
				if(deltay_up0 <= 0)
				begin
				
					deltay_up0 = 336;
					arrowgo_up[0] = 1'b0;
					
				end
			
				//RIGHT 'up' ARROW, inner color
				//	triangle of the arrow
				if	((VGA_Y >= (vposframe + deltay_up0)) && (VGA_Y <= (vposframe + 36 + deltay_up0)) &&	// upper/lower bounds of the triangle
					(VGA_X >= (hpos1frame - (VGA_Y - vposframe - deltay_up0) + 36)) && (VGA_X <= (hpos1frame + (VGA_Y - vposframe - deltay_up0) + 36)))	// left/right bounds of the triangle
				begin
					mRed = 10'b0000000000;
					mGreen = 10'b1111111111;
					mBlue = 10'b0000000000;
				end
				// square of the arrow
				if	((VGA_Y >= (vposframe + 36 + deltay_up0)) && (VGA_Y <= (vposframe + 72 + deltay_up0)) &&	// upper/lower bounds of the square
					(VGA_X >= (hpos1frame + 18)) && (VGA_X <= (hpos1frame + 54)))	// left/right bounds of the square
				begin
					mRed = 10'b0000000000;
					mGreen = 10'b1111111111;
					mBlue = 10'b0000000000;
				end
				
			end	
			
			
			
			if(arrowgo_up[1]) begin
			
				counteru1 = counteru1 + 1;
				
				if(counteru1 >= 500000)
				begin
				
					counteru1 = 0;
					deltay_up1 = deltay_up1 - 1;
					
				end
				
				if(deltay_up1 <= 0)
				begin
				
					deltay_up1 = 336;
					arrowgo_up[1] = 1'b0;
					
				end
				
				
				//RIGHT 'up' ARROW, inner color
				//	triangle of the arrow
				if	((VGA_Y >= (vposframe + deltay_up1)) && (VGA_Y <= (vposframe + 36 + deltay_up1)) &&	// upper/lower bounds of the triangle
					(VGA_X >= (hpos1frame - (VGA_Y - vposframe - deltay_up1) + 36)) && (VGA_X <= (hpos1frame + (VGA_Y - vposframe - deltay_up1) + 36)))	// left/right bounds of the triangle
				begin
					mRed = 10'b0000000000;
					mGreen = 10'b1111111111;
					mBlue = 10'b0000000000;
				end
				// square of the arrow
				if	((VGA_Y >= (vposframe + 36 + deltay_up1)) && (VGA_Y <= (vposframe + 72 + deltay_up1)) &&	// upper/lower bounds of the square
					(VGA_X >= (hpos1frame + 18)) && (VGA_X <= (hpos1frame + 54)))	// left/right bounds of the square
				begin
					mRed = 10'b0000000000;
					mGreen = 10'b1111111111;
					mBlue = 10'b0000000000;
				end
				
			end
			
			
			if(arrowgo_up[2]) begin
			
				counteru2 = counteru2 + 1;
				
				if(counteru2 >= 500000)
				begin
				
					counteru2 = 0;
					deltay_up2 = deltay_up2 - 1;
					
				end
				
				if(deltay_up2 <= 0)
				begin
				
					deltay_up2 = 336;
					arrowgo_up[2] = 1'b0;
					
				end
				
				
				//RIGHT 'up' ARROW, inner color
				//	triangle of the arrow
				if	((VGA_Y >= (vposframe + deltay_up2)) && (VGA_Y <= (vposframe + 36 + deltay_up2)) &&	// upper/lower bounds of the triangle
					(VGA_X >= (hpos1frame - (VGA_Y - vposframe - deltay_up2) + 36)) && (VGA_X <= (hpos1frame + (VGA_Y - vposframe - deltay_up2) + 36)))	// left/right bounds of the triangle
				begin
					mRed = 10'b0000000000;
					mGreen = 10'b1111111111;
					mBlue = 10'b0000000000;
				end
				// square of the arrow
				if	((VGA_Y >= (vposframe + 36 + deltay_up2)) && (VGA_Y <= (vposframe + 72 + deltay_up2)) &&	// upper/lower bounds of the square
					(VGA_X >= (hpos1frame + 18)) && (VGA_X <= (hpos1frame + 54)))	// left/right bounds of the square
				begin
					mRed = 10'b0000000000;
					mGreen = 10'b1111111111;
					mBlue = 10'b0000000000;
				end
				
			end
			
			
			
			
			
			
			
			
			
			if(arrowgo_right[0]) begin
			
				counterr0 = counterr0 + 1;
				
				if(counterr0 >= 500000)
				begin
				
					counterr0 = 0;
					deltay_right0 = deltay_right0 - 1;
					
				end
				
				if(deltay_right0 <= 0)
				begin
				
					deltay_right0 = 336;
					arrowgo_right[0] = 1'b0;
					
				end
			
				// RIGHTMOST 'right' ARROW, inner color
				//	triangle of the arrow
				if	((VGA_Y >= (vposframe - (hpos0frame + 72 - VGA_X) + deltay_right0) + 36) && (VGA_Y <= (vposframe + (hpos0frame + 72 - VGA_X) + deltay_right0) + 36) &&	// upper/lower bounds of the triangle
					(VGA_X >= (hpos0frame + 36)) && (VGA_X <= (hpos0frame + 72)))	// left/right bounds of the triangle
				begin
					mRed = 10'b0000000000;
					mGreen = 10'b0000000000;
					mBlue = 10'b1111111111;
				end
				// square of the arrow
				if	((VGA_Y >= (vposframe + 18 + deltay_right0)) && (VGA_Y <= (vposframe + 54 + deltay_right0)) &&	// upper/lower bounds of the square
					(VGA_X >= (hpos0frame)) && (VGA_X <= (hpos0frame + 36)))	// left/right bounds of the square
				begin
					mRed = 10'b0000000000;
					mGreen = 10'b0000000000;
					mBlue = 10'b1111111111;
				end
				
			end	
			
			
			if(arrowgo_right[1]) begin
			
				counterr1 = counterr1 + 1;
				
				if(counterr1 >= 500000)
				begin
				
					counterr1 = 0;
					deltay_right1 = deltay_right1 - 1;
					
				end
				
				if(deltay_right1 <= 0)
				begin
				
					deltay_right1 = 336;
					arrowgo_right[1] = 1'b0;
					
				end
				
				
				// RIGHTMOST 'right' ARROW, inner color
				//	triangle of the arrow
				if	((VGA_Y >= (vposframe - (hpos0frame + 72 - VGA_X) + deltay_right1) + 36) && (VGA_Y <= (vposframe + (hpos0frame + 72 - VGA_X) + deltay_right1) + 36) &&	// upper/lower bounds of the triangle
					(VGA_X >= (hpos0frame + 36)) && (VGA_X <= (hpos0frame + 72)))	// left/right bounds of the triangle
				begin
					mRed = 10'b0000000000;
					mGreen = 10'b0000000000;
					mBlue = 10'b1111111111;
				end
				// square of the arrow
				if	((VGA_Y >= (vposframe + 18 + deltay_right1)) && (VGA_Y <= (vposframe + 54 + deltay_right1)) &&	// upper/lower bounds of the square
					(VGA_X >= (hpos0frame)) && (VGA_X <= (hpos0frame + 36)))	// left/right bounds of the square
				begin
					mRed = 10'b0000000000;
					mGreen = 10'b0000000000;
					mBlue = 10'b1111111111;
				end
				
			end
			
			
			if(arrowgo_right[2]) begin
			
				counterr2 = counterr2 + 1;
				
				if(counterr2 >= 500000)
				begin
				
					counterr2 = 0;
					deltay_right2 = deltay_right2 - 1;
					
				end
				
				if(deltay_right2 <= 0)
				begin
				
					deltay_right2 = 336;
					arrowgo_right[2] = 1'b0;
					
				end
				
				
				// RIGHTMOST 'right' ARROW, inner color
				//	triangle of the arrow
				if	((VGA_Y >= (vposframe - (hpos0frame + 72 - VGA_X) + deltay_right2) + 36) && (VGA_Y <= (vposframe + (hpos0frame + 72 - VGA_X) + deltay_right2) + 36) &&	// upper/lower bounds of the triangle
					(VGA_X >= (hpos0frame + 36)) && (VGA_X <= (hpos0frame + 72)))	// left/right bounds of the triangle
				begin
					mRed = 10'b0000000000;
					mGreen = 10'b0000000000;
					mBlue = 10'b1111111111;
				end
				// square of the arrow
				if	((VGA_Y >= (vposframe + 18 + deltay_right2)) && (VGA_Y <= (vposframe + 54 + deltay_right2)) &&	// upper/lower bounds of the square
					(VGA_X >= (hpos0frame)) && (VGA_X <= (hpos0frame + 36)))	// left/right bounds of the square
				begin
					mRed = 10'b0000000000;
					mGreen = 10'b0000000000;
					mBlue = 10'b1111111111;
				end
				
			end
			
			
			
			
		
			
			
		end
			
			
			
			
							
endmodule

