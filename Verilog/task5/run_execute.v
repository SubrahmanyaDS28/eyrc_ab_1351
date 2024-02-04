module run_execute(
	input clk,    
	input rst,
   input [11:0] left_sensor,
   input [11:0] center_sensor,
   input [11:0] right_sensor,
	input [9:0]distance,
	input start,
	output reg led,
	output reg [1:0]send_tx,
   output reg M1_A_1A_right,   // Forward motion signal
   output reg M1_A_1B,   		  // Backward motion signal
	output reg M2_A_1A_left,    // Forward motion signal
   output reg M2_A_1B,   		  // Backward motion signal
	output reg [7:0] nodecount,
	input [4:0] previous_state,
	input [4:0] next_state,
	input wire [4:0]node_state
);
	reg pwm_signal;
	reg [3:0]counter;
//	reg [3:0]nodecount;
	wire [4:0]node;
	reg [32:0]timer;
	reg a;
	reg [1:0] state;
	reg [32:0] delay_counter;
	
	initial counter =0;
	initial state = 2'b00;
//	reg [4:0]node_state;
	reg [3:0]turn_dec;
	parameter move_st = 1;
	parameter turn_right = 2;
	parameter turn_left = 3;
	parameter move_back = 4;
	parameter delay = 5;
	parameter u_turn = 6;
	
	always@(posedge clk )
	begin
		pwm_signal <= (counter < 5'b1000) ? 1 : 0; 
		counter <= counter+1;
	end
	
	
always@(posedge clk)
begin
 case(turn_dec)
	move_st:
		begin
			if(left_sensor < 500 && right_sensor < 500)begin
				M1_A_1A_right <= pwm_signal;   
				M1_A_1B <= 0;   					 
				M2_A_1A_left <= pwm_signal;    
				M2_A_1B <= 0;  					 
			end
			
			if(left_sensor > 500 && right_sensor < 500)begin
					M1_A_1A_right <= pwm_signal;   
					M1_A_1B <= 0;   					 
					M2_A_1A_left <= 0;    
					M2_A_1B <= pwm_signal;  					 
			end
			
			if(left_sensor < 500 && right_sensor > 500)begin
				M1_A_1A_right <= 0;   
				M1_A_1B <= pwm_signal;   					 
				M2_A_1A_left <= pwm_signal;    
				M2_A_1B <= 0;  					 
			end
		end
		
	turn_right:
		begin
//			if(delay_counter <= 1_125_000) begin
//				M1_A_1A_right <= pwm_signal;   // Forward motion signal
//				M1_A_1B <= 0;   		 // Backward motion signal
//				M2_A_1A_left <=pwm_signal ;    // Forward motion signal
//				M2_A_1B <= 0;  		 // Backward motion signal
//  
//				a <= 1; 
//			end
//			else if(delay_counter == 1_125_000) begin
//				a <= 0;
//				delay_counter = 0;
//			end
//
//			delay_counter = delay_counter + 1;
//			if(a != 1) 
//			begin
			if(left_sensor > 500 && center_sensor>500 &&right_sensor > 500)begin
				M1_A_1A_right <= 0;   
				M1_A_1B <= pwm_signal;   					 
				M2_A_1A_left <= pwm_signal;    
				M2_A_1B <= 0;  					 
			end
			if(left_sensor < 500 && right_sensor < 500)begin
				M1_A_1A_right <= pwm_signal;   
				M1_A_1B <= 0;   					 
				M2_A_1A_left <= pwm_signal;    
				M2_A_1B <= 0;  					 
			end
			if(left_sensor > 500 && right_sensor < 500)begin
				M1_A_1A_right <= pwm_signal;   
				M1_A_1B <= 0;   					 
				M2_A_1A_left <= 0;    
				M2_A_1B <= pwm_signal;  					 
			end
	
			if(left_sensor < 500 && right_sensor > 500)begin
				M1_A_1A_right <= 0;   
				M1_A_1B <= pwm_signal;   					 
				M2_A_1A_left <= pwm_signal;    
				M2_A_1B <= 0;  					 
			end
		end
			//end
//		end
	
	turn_left:
//		begin
//			if(delay_counter <= 1_125_000) begin
//				M1_A_1A_right <= pwm_signal;   // Forward motion signal
//				M1_A_1B <= 0;   		 // Backward motion signal
//				M2_A_1A_left <=pwm_signal ;    // Forward motion signal
//				M2_A_1B <= 0;  		 // Backward motion signal
//  
//				a <= 1; 
//			end
//			else if(delay_counter == 1_125_000) begin
//				a <= 0;
//				delay_counter = 0;
//			end
//
//			delay_counter = delay_counter + 1;
//			if(a != 1) 
		begin
			if(left_sensor > 500 &&center_sensor>500 &&  right_sensor > 500)begin
				M1_A_1A_right <= pwm_signal;   
				M1_A_1B <= 0;   					 
				M2_A_1A_left <= 0;    
				M2_A_1B <= pwm_signal;  					 
			end
			if(left_sensor < 500 && right_sensor < 500)begin
				M1_A_1A_right <= pwm_signal;   
				M1_A_1B <= 0;   					
				M2_A_1A_left <= pwm_signal;   
				M2_A_1B <= 0;  					
			end
			if(left_sensor > 500 && right_sensor < 500)begin
				M1_A_1A_right <= pwm_signal;   
				M1_A_1B <= 0;   					 
				M2_A_1A_left <= 0;    
				M2_A_1B <= pwm_signal;  					 
			end
		
			if(left_sensor < 500 && right_sensor > 500)begin
				M1_A_1A_right <= 0;   
				M1_A_1B <= pwm_signal;   					 
				M2_A_1A_left <= pwm_signal;    
				M2_A_1B <= 0;  					 
			end
		end
//		end
	

	move_back:
		begin
			if(left_sensor > 500 && right_sensor > 500)begin
				M1_A_1A_right <= 0;  
				M1_A_1B <= pwm_signal;   					 
				M2_A_1A_left <= 0;    
				M2_A_1B <= pwm_signal;  					 
			end
		end
	
	delay:
		begin
			M1_A_1A_right <= 0;  
			M1_A_1B <= 0;   				
			M2_A_1A_left <= 0;    
			M2_A_1B <= 0;  				
		end
		
 endcase

end
	
//[0,1,29,20,24,25,26,27,26,28,29,20,21,22]
always@(posedge clk)
	begin
	if(start == 1)
		state = 0;
	/////////////////////////
	
	///////////////
	case(node_state)
		0:if(next_state == 1 )
			begin
				turn_dec = move_st;

			end
				
		1:begin
			if(previous_state == 0 && next_state == 29)
				turn_dec = turn_right;
			if(previous_state == 0 && next_state == 2)
				turn_dec = turn_right;
			end
			
		29:begin
			if(previous_state == 1 && next_state == 20)
				turn_dec = turn_left;
			if(previous_state == 1 && next_state == 28)
				turn_dec = turn_right;
		end
		
		20:begin
			if(previous_state == 29 && next_state == 24)
				turn_dec = turn_right;
			if(previous_state == 29 && next_state == 21)
				turn_dec = turn_left;
				
			if(previous_state == 24 && next_state == 21)
				turn_dec = move_st;
			if(previous_state == 24 && next_state == 29)
				turn_dec = turn_left;
		end
		
		
		24:begin
			if(previous_state == 20 && next_state == 25)
				turn_dec = turn_right;
			if(previous_state == 25 && next_state == 20)
				turn_dec = turn_left;
		end
		
		25:begin
			if(previous_state == 24 && next_state == 26)
				turn_dec = move_st;
			if(previous_state == 26 && next_state == 24)
				turn_dec = move_st;
		end
		
		26:begin
			if(previous_state == 25 && next_state == 27)
				turn_dec = turn_right;
			if(previous_state == 25 && next_state == 28)
				turn_dec = move_st;
				
			if(previous_state == 28 && next_state == 27)
				turn_dec = turn_left;
			if(previous_state == 28 && next_state == 25)
				turn_dec = move_st;
				
			if(previous_state == 27 && next_state == 28)
				turn_dec = turn_right;
			if(previous_state == 27 && next_state == 25)
				turn_dec = turn_left;
		end
		
		27:
			if(previous_state == 26 && next_state == 26)
				turn_dec = u_turn;
		
		28:begin
			if(previous_state == 26 && next_state == 29)
				turn_dec = turn_right;
				
			if(previous_state == 29 && next_state == 26)
				turn_dec = turn_left;
			end
		21:begin
			if(previous_state == 20 && next_state == 22)
				turn_dec = turn_left;
			if(previous_state == 20 && next_state == 23)
				turn_dec = turn_right;
			
			if(previous_state == 23 && next_state == 20)
				turn_dec = turn_left;
				
			if(previous_state == 22 && next_state == 20)
				turn_dec = turn_right;
		end
	endcase		
end
	

always@(posedge clk) begin
//	case(state)
//	0:begin
//		nodecount <= nodecount;
//	end
//	1:begin
		if(left_sensor > 500 && right_sensor > 500 && center_sensor > 500 && timer == 0)
		begin
			nodecount <= nodecount + 1;
			led = led + 1;
			timer <= 6_250_000;
		end
		if(timer > 0) 
			timer <= timer - 1;
//	end
//  endcase
end

assign node = nodecount;
	
initial send_tx = 0;
always@(posedge clk)
	begin
		if(distance <= 9)
				send_tx = 1;
		else if(distance <=5)
			send_tx = 2;
		else 
			send_tx = 0;
	end
	
endmodule