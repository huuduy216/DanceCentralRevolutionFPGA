module randomArrowGenerator(input clk,input [4:0]GSensor, output reg [4:0]arrowData);

	integer counter, i;
	reg [4:0] randomNumber;
	initial
	begin
		counter = 0;
		randomNumber = 1;
		i = 1;
	end
	
	always @ (posedge clk)
	begin
		//delay to generate new data every 0.5 second
		counter = counter + 1;
		if(counter > 25000000)
		begin
			counter = 0;
			
			randomNumber <= { randomNumber[3:0], randomNumber[4] ^ randomNumber[1] };

			
			if(randomNumber == 4'b1110 | randomNumber == 4'b1011 | randomNumber == 4'b1101 | randomNumber == 4'b0111)
			begin
				randomNumber <= 2;
			end
			
			
			
			arrowData = GSensor;
		end
	end
endmodule
 