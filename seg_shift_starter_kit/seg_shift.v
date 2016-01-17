/*
 * inputs:
 * 	KEY0		reset
 * 	KEY1		x2 the speed of shifting
 * 	KEY2		/2 the speed of shifting
 * 	SW[0]		enables shifting to the right
 * 	SW[1]		enables shifting to the left; SW[0] overrides SW[1]
 * 	SW[2]		shifts additional 1's into the HEX displays and LEDR
 * 	SW[3]		shifts additional 0's into the HEX displays and LEDR
 *
 * outputs:
 * 	LEDR		shifting lights
 * 	HEX7-0	shifting pattern
 * 	LEDG		shifting speed (from 0 to 9)
*/
module seg_shift (	CLOCK_50, KEY, SW, HEX3, HEX2, HEX1,
					HEX0, LEDR, LEDG);
	
	/*****************************************************************************
 	*                  Module Parameters, Inputs and Outputs                     *
 	*****************************************************************************/
				
	input CLOCK_50;
	input [2:0] KEY;
	input [3:0] SW; 
	output [6:0] HEX3, HEX2, HEX1, HEX0;
	output [9:0] LEDR;
	output [0:7] LEDG;

 	/*****************************************************************************
 	*                  Your implementation										*
 	*****************************************************************************/
	
	integer k;
	reg [2:0]speed;
	reg [26:0]count;
	reg [26:0]ref_speed;
	reg [9:0]LEDR;
	
	initial begin
		ref_speed <= 25'd500000000; // 1 seconds
		speed <= 1;
	end
	
	// speed control
	always @ (posedge CLOCK_50) 
	begin
		if (KEY[1] & speed < 2'd10) begin
			speed <= speed + 2'd1;
			ref_speed <= ref_speed * 2;
			end
		else if (KEY[2] & speed > 2'd1) begin
			speed <= speed - 2'd1;
			ref_speed <= ref_speed / 2;
			end
		end
		
		
	
	// red led shifter
	always @ (posedge CLOCK_50) begin
		if (~KEY[0])
			LEDR <= 10'b0000000000;
		else begin
			if (count >= ref_speed) begin
				if (SW[0] & ~SW[1]) begin
					for (k=0; k < 9; k=k+1)
						LEDR[k] = LEDR[k+1];
					LEDR[9] <= SW[2];
					count <= 1;
					end
				else if (~SW[0] & SW[1]) begin
					for (k=9; k > 0; k=k-1)
						LEDR[k] = LEDR[k-1];
					LEDR[0] <= SW[2];
					count <= 1;
					end
				end
			else 
				count <= count + 1;
			end
		end
 	
endmodule


