module bot_run(input clk,    input rst,
    input [11:0] left_sensor,
    input [11:0] center_sensor,
    input [11:0] right_sensor,
	 input start,
	 input [21:0]distance,
    output reg M1_A_1A_right,   // Forward motion signal
    output reg M1_A_1B,   		  // Backward motion signal
	 output reg M2_A_1A_left,    // Forward motion signal
    output reg M2_A_1B,   		  // Backward motion signal
	 output reg led
);
	reg pwm_signal;
	reg [3:0]counter;
	reg [3:0]nodecount;
	wire [4:0]node;
	reg [32:0]timer;
	reg a;
	reg state;
	reg [32:0] delay_counter;
	
	initial counter =0;
	initial state = 0;
	
	always@(posedge clk )
	begin
		pwm_signal <= (counter < 5'b1000) ? 1 : 0; 
		counter <= counter+1;
	end
	
	
always @(posedge clk) 
begin
	if(start == 1) 
		state = 1;
		
		
	case(state)
	0: begin
			M1_A_1A_right <= 0;   // Forward motion signal
			M1_A_1B <= 0;   // Backward motion signal
			M2_A_1A_left <=0 ;   // Forward motion signal
			M2_A_1B <= 0;  // Backward motion signal
	  	end
	1: begin
//		if(node == 6)
//		begin
//			M1_A_1A_right <= pwm_signal;   // Forward motion signal
//			M1_A_1B <= 0;   // Backward motion signal
//			M2_A_1A_left <=0 ;   // Forward motion signal
//			M2_A_1B <= pwm_signal;  // Backward motion signal  
//		end
//		else if(node >= 13)
//		begin
//			M1_A_1A_right <= 0;   // Forward motion signal
//			M1_A_1B <= 0;   // Backward motion signal
//			M2_A_1A_left <=0 ;   // Forward motion signal
//			M2_A_1B <= 0;  // Backward motion signal
//		end
//		else 
//		begin
			if(left_sensor < 500 && right_sensor < 500 && center_sensor > 500)
			begin
				M1_A_1A_right <= pwm_signal;   // Forward motion signal
				M1_A_1B <= 0;   // Backward motion signal
				M2_A_1A_left <= pwm_signal;   // Forward motion signal
				M2_A_1B <= 0;  // Backward motion signal
			end
	
			if(left_sensor > 500 && right_sensor > 500) 
			begin
				if(delay_counter <= 3_125_000) begin
					M1_A_1A_right <= 0;   // Forward motion signal
					M1_A_1B <= 0;   // Backward motion signal
					M2_A_1A_left <=0 ;   // Forward motion signal
					M2_A_1B <= 0;  // Backward motion signal
	  
					a <= 1;
				end
				else if(delay_counter == 3_125_000) begin
					a <= 0;
					delay_counter = 0;
				end
	
				delay_counter = delay_counter + 1;
				if(a != 1) 
				begin
					M1_A_1A_right <= pwm_signal;   // Forward motion signal
					M1_A_1B <= 0;   // Backward motion signal
					M2_A_1A_left <=0 ;   // Forward motion signal
					M2_A_1B <= pwm_signal;  // Backward motion signal
// here bot have to take dicision to turn right or left of go straight
				end
			end
			
			else if(left_sensor > 500 && right_sensor < 500)
			begin
				M1_A_1A_right <= pwm_signal;   // Forward motion signal
				M1_A_1B <= 0;   // Backward motion signal
				M2_A_1A_left <=0 ;   // Forward motion signal
				M2_A_1B <= pwm_signal;  // Backward motion signal
			end
	
			else if(left_sensor < 500 && right_sensor > 500)
			begin
				M1_A_1A_right <=0 ;   // Forward motion signal
				M1_A_1B <= pwm_signal;   // Backward motion signal
				M2_A_1A_left <=pwm_signal ;   // Forward motion signal
				M2_A_1B <= 0;  // Backward motion signal
			end
			
			else if(left_sensor < 200 && right_sensor < 200 && center_sensor < 200)
			begin
				M1_A_1A_right <=0 ;   // Forward motion signal
				M1_A_1B <= pwm_signal;   // Backward motion signal
				M2_A_1A_left <=0 ;   // Forward motion signal
				M2_A_1B <= pwm_signal;  // Backward motion signal
			end
	
			else 
			begin
				M1_A_1A_right <= pwm_signal;   // Forward motion signal
				M1_A_1B <= 0;   // Backward motion signal
				M2_A_1A_left <= pwm_signal;   // Forward motion signal
				M2_A_1B <= 0;  // Backward motion signal
			end
		end
	endcase
end

always@(posedge clk)
begin
	if(left_sensor > 500 && right_sensor > 500 && center_sensor > 500 && timer == 0)
	begin
		nodecount <= nodecount + 1;
		led = led + 1;
		timer <= 6_250_000;
	end
	if(timer > 0) 
		timer <= timer - 1;
end

assign node = nodecount;
	
endmodule
