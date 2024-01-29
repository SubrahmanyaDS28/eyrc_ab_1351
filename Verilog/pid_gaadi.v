module pid_gaadi (
    input clk,    input rst,
    input [11:0] left_sensor,
    input [11:0] center_sensor,
    input [11:0] right_sensor,
    output reg M1_A_1A_right,   // Forward motion signal
    output reg M1_A_1B,   // Backward motion signal
	 output reg M2_A_1A_left,   // Forward motion signal
    output reg M2_A_1B,   // Backward motion signal
	 output reg led
);

	reg pwm_signal;
	reg [3:0]counter;
	reg [3:0]nodecount;
	wire [4:0]node;
//	reg [25:0]delay;
//	reg [25:0]delay1;
	reg [32:0]timer;
	initial counter =0;
	always@(posedge clk )
	begin
		pwm_signal <= (counter < 5'b1000) ? 1 : 0; 
		counter <= counter+1;
	
	end
//// PID controller parameters
//parameter signed [15:0] Kp = 50;  // Proportional gain
//parameter signed [15:0] Ki = 1;   // Integral gain
//parameter signed [15:0] Kd = 10;  // Derivative gain
//
//// Motor driver parameters
//parameter MAX_PWM = 8'b1111_1111; // Maximum PWM value for motor control
//
//// PID controller variables
//reg signed [31:0] integral = 0;   // Integral term
//reg signed [15:0] prev_error = 0;  // Previous error
//reg signed [15:0] error;
//reg signed [31:0] proportional;
//reg signed [31:0] derivative;
//reg signed [15:0] control_signal;
//
//
//// Time step for derivative term (you may need to adjust this based on your system)
//parameter DT = 1;
//
//always @(posedge clk or posedge rst) begin
//    if (rst) begin
//        // Reset the controller
//        M2_A_1A_left <= 8'b0000_0000;
//        M1_A_1A_right <= 8'b0000_0000;
//        integral <= 0;
//        prev_error <= 0;
//    end 
//	 else begin
//        // Calculate position error
////        reg signed [15:0] error;
//        error = center_sensor - ((left_sensor + right_sensor) / 2);
//
//        // Proportional term
////        reg signed [31:0] proportional;
//        proportional = Kp * error;
//
//        // Integral term
//        integral = integral + Ki * error;
//
//        // Derivative term
////        reg signed [31:0] derivative;
//        derivative = Kd * (error - prev_error) / DT;
//
//        // Calculate motor control signals
////        reg signed [15:0] control_signal;
//        control_signal = proportional + integral + derivative;
//
//        // Update motor control signals
//        M2_A_1A_left = MAX_PWM - control_signal;
//        M2_A_1A_left = MAX_PWM + control_signal;
//
//        // Update previous error
//        prev_error = error;
//    end
//end

always @(posedge clk) begin
/*	
		 if(center_sensor > 450 && left_sensor < 500 && right_sensor < 500)
	begin
	  M1_A_1A_right <= pwm_signal;   // Forward motion signal
     M1_A_1B <= 0;   // Backward motion signal
	  M2_A_1A_left <= pwm_signal;   // Forward motion signal
     M2_A_1B <= 0;  // Backward motion signal
	end
	
	else if( (center_sensor > 500 && left_sensor > 500 && right_sensor > 500)||(center_sensor < 500 && left_sensor < 500 && right_sensor < 500)) 
	begin
		M1_A_1A_right <= pwm_signal;   // Forward motion signal
		M1_A_1B <= 0 ;   // Backward motion signal
		M2_A_1A_left <= 0;   // Forward motion signal
		M2_A_1B <= pwm_signal;  // Backward motion signal
	end
		else if( (center_sensor > 500 && right_sensor > 500)||(center_sensor < 500 && left_sensor > 500 && right_sensor < 500)) 
	begin
		M1_A_1A_right <= pwm_signal;   // Forward motion signal
		M1_A_1B <= 0 ;   // Backward motion signal
		M2_A_1A_left <= 0;   // Forward motion signal
		M2_A_1B <= pwm_signal;  // Backward motion signal
	end
			else if(center_sensor < 500 && left_sensor < 500 && right_sensor > 500)
	begin
	  M1_A_1A_right <= pwm_signal;   // Forward motion signal
     M1_A_1B <= 0;   // Backward motion signal
	  M2_A_1A_left <= pwm_signal;   // Forward motion signal
     M2_A_1B <= 0;  // Backward motion signal
	end
	
		M2_A_1A_left <= 0;   // Forward motion signal
*/

 if(node == 6)
	begin
	  M1_A_1A_right <= pwm_signal;   // Forward motion signal
     M1_A_1B <= 0;   // Backward motion signal
	  M2_A_1A_left <=0 ;   // Forward motion signal
     M2_A_1B <= pwm_signal;  // Backward motion signal
	  
	end
 else if(node >= 13)
	begin
	  M1_A_1A_right <= 0;   // Forward motion signal
     M1_A_1B <= 0;   // Backward motion signal
	  M2_A_1A_left <=0 ;   // Forward motion signal
     M2_A_1B <= 0;  // Backward motion signal
	end
	else 
begin

		 if(left_sensor < 500 && right_sensor < 500)
	begin
	  M1_A_1A_right <= pwm_signal;   // Forward motion signal
     M1_A_1B <= 0;   // Backward motion signal
	  M2_A_1A_left <= pwm_signal;   // Forward motion signal
     M2_A_1B <= 0;  // Backward motion signal
	end
	
		if(left_sensor > 500 && right_sensor > 500)
	begin
	  M1_A_1A_right <= pwm_signal;   // Forward motion signal
     M1_A_1B <= 0;   // Backward motion signal
	  M2_A_1A_left <=0 ;   // Forward motion signal
     M2_A_1B <= pwm_signal;  // Backward motion signal

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
	
	else begin
		M1_A_1A_right <= pwm_signal;   // Forward motion signal
		M1_A_1B <= 0;   // Backward motion signal
		M2_A_1A_left <= pwm_signal;   // Forward motion signal
		M2_A_1B <= 0;  // Backward motion signal
	end
  
  
 end
	
end

always@(posedge clk)
	begin
		if(left_sensor > 500 && right_sensor > 500 && center_sensor > 500 && timer == 0)
		begin
			 
//			if(1) begin
//				nodecount <= nodecount + 1;
//				delay <= delay + 1;
//			end
//				
//			
//			else if(delay <= 25'd15_350_000)
//				begin
//				end
//			else 
//				delay=0;
//			end
			
			//delay = delay + 1;
			nodecount <= nodecount + 1;
			led = led + 1;
			timer <= 3_125_000;
			//nodecount <= nodecount + 1;
		end
		//else delay = 0;
		
		
		if(timer > 0) begin
//			nodecount <= nodecount + 1;
//			if(delay1 <= 25'd10_350_000) begin
//				delay1 = delay1 + 1;
//			end
//			else delay1 = 0;
			timer <= timer - 1;
	end
end
assign node = nodecount;
	
endmodule
