// AstroTinker Bot : Task 2A : UART Receiver
/*
Instructions
-------------------
Students are not allowed to make any changes in the Module declaration.

This file is used to receive UART Rx data packet from receiver line and then update the rx_msg and rx_complete data lines.

Recommended Quartus Version : 20.1
The submitted project file must be 20.1 compatible as the evaluation will be done on Quartus Prime Lite 20.1.

Warning: The error due to compatibility will not be entertained.
-------------------
*/

/*
Module UART Receiver

Input:  clk_50M - 50 MHz clock
        rx      - UART Receiver

Output: rx_msg      - read incoming message
        rx_complete - message received flag
*/

// module declaration
module uart_rx (
  input clk_50M, rx,
  output reg [7:0] rx_msg,
  output reg rx_complete
);

//////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE//////////////////

////////////////////////// Add your code here


initial begin

rx_msg = 0; rx_complete = 0;

end

reg [2:0] state;
reg [7:0] data;
reg [3:0] count, count_1;
reg [13:0] baud_counter, baud_counter_1;
reg a;

initial begin 
	state = 0;
	baud_counter = 0;
	data = 0;
	rx_complete = 0;
	count = 0;
	baud_counter_1 = 0;
	count_1 = 0;
	a = 0;
end

always @(posedge clk_50M) begin

  case (state)
	 0: begin // Idle state
//      if (~rx) begin // Check for start bit
        state <= 1;
		  baud_counter = 0;
		  baud_counter_1 = 0;
        count <= 0;
        //data <= 0;
		  rx_complete <= 0;
		  //count_1 = 0;
//      end else begin
//        state <= 0;
//      end
    end

//	 0: begin
//			if (baud_counter < 434) begin
//				baud_counter = baud_counter + 1;
//			end
//			else begin
//				state <= 1;
//				baud_counter = 1;
//			end
//		end


	 1: begin
		if (count < 8) begin
			if(baud_counter < 433) begin
				baud_counter = baud_counter + 1;
			end
			else begin
				data <= ((data << 1) | rx);
				count = count + 1;
				baud_counter = 0;
			end
		end
		else begin
			state <= 3;
			count <= 0;
		end
	 end
	 

	 2: begin
		if (baud_counter > 433) begin
			baud_counter = baud_counter + 1;
		end
		else
			state <= 3;
			baud_counter <= 0;
	 end


	 
    3: begin // Check for valid data packet
	 if(baud_counter < 430) begin
		baud_counter = baud_counter + 1;
	 end
	 else begin
		if(data == 0) begin
			if(baud_counter_1 > (434 - count_1)) begin
				rx_msg = data;
				state = 3;
				count_1 = count_1 + 1;
			end
			else begin
				baud_counter_1 = baud_counter_1 + 1;
			end
		end
		else if (count == 0) begin
		if(a == 0) begin
			if(baud_counter_1 > (435 - count_1)) begin
				rx_msg <= data;
				rx_complete <= 1;
				
//				count <= count + 1;
				state <= 0;
				baud_counter = 0;
				a = 1;
			end
			else begin
				baud_counter_1 = baud_counter_1 + 1;
			end
			
		end
		else begin
			if(baud_counter_1 > (434 - count_1)) begin
				rx_msg <= data;
				rx_complete <= 1;
				
//				count <= count + 1;
				state <= 0;
				baud_counter = 0;
			end
			else begin
				baud_counter_1 = baud_counter_1 + 1;
			end
		end
		end
//      else if (count == 1) begin // Received stop bit
//
//      end 
//		else begin
//			rx_complete <= 0;
//			
//      end
    end
	 end
  endcase
end



//////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE//////////////////
endmodule
/*
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/04/2015 12:03:40 PM
// Design Name: 
// Module Name: receiver
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module uart_rx(

input clk_50M,//100100MHz FPGA Basys 3 Board Clock
//input reset, //reset button
input rx, //input signal wire
output [7:0] rx_msg //data that we receive at the receiving end, using 8 right most leds on the basys 3 board
    );
    
//Internal Variables
reg shift; //triggering the shifting of data.
reg state, nextstate; //initial state abd next variable state
reg [3:0] bit_counter; //total length of the bits is 10, 1 byte of data
reg [1:0] sample_counter; //frequency = 4 times the BR
reg [13:0] baudrate_counter; //for setting up a BR of 9600
reg [9:0] rxshift_reg; //data byte (10 bits) [8:1] --> data byte
reg clear_bitcounter,inc_bitcounter,inc_samplecounter,clear_samplecounter; //to clear and increment the bit counter and sample counter

// Constants
parameter clk_freq = 50_000_000; 
parameter baud_rate = 115200; 
parameter div_sample = 4;
parameter div_counter = clk_freq/(baud_rate*div_sample);  //this is the frequency we have to divide the system clock frequency to get a frequency (div_sample) time higher than the baudrate
parameter mid_sample = (div_sample/2);  //this is the middle point of a bit where you want to sample the data
parameter div_bit = 10; //1 start, 1 stop, 8 buts of data


assign rx_msg = rxshift_reg [8:1]; //assigning the rx_msg from the shift register

//UART //Receiver Logic
always @ (posedge clk_50M)
    begin 
        if (1)begin //if reset button is pressed, all counters are rset
            state <=0; //idle
            bit_counter <=0;
            baudrate_counter <=0; 
            sample_counter <=0; 
        end else begin 
            baudrate_counter <= baudrate_counter +1; 
            if (baudrate_counter >= div_counter-1) begin //if the counter reach the BR with sampling
                baudrate_counter <=0; //reset counter
                state <= nextstate; //it should be ready to receive the data/switch to receiving state
                if (shift)rxshift_reg <= {rx,rxshift_reg[9:1]}; //if shift is asserted , then load the receiving data
                if (clear_samplecounter) sample_counter <=0; //if clear asserted, then reset the sample counter
                if (inc_samplecounter) sample_counter <= sample_counter +1; //if inc_samplecounter is asserted, increment by 1
                if (clear_bitcounter) bit_counter <=0; //if clear_bitcounter, it should rset itself
                if (inc_bitcounter)bit_counter <= bit_counter +1; //bitcounter goes up by 1.
            end
        end
    end
   
//State Machine

always @ (posedge clk_50M) //trigger by clock
begin 
    shift <= 0; //set shift to 0 to avoid any shifting, this is an idle state
    clear_samplecounter <=0; 
    inc_samplecounter <=0; 
    clear_bitcounter <=0; 
    inc_bitcounter <=0; 
    nextstate <=0; //idle state
    case (state)
        0: begin //Idle State
            if (rx) //if input rx line is asserted
              begin
              nextstate <=0; //stay in the idle state, rx needs to be low to start the transmission
              end
            else begin 
                nextstate <=1; //receiving state
                clear_bitcounter <=1; //trigger ti clear the bitcounter
                clear_samplecounter <=1; //triggerto clear the sample counter.
            end
        end
        1: begin // Receiving State
            nextstate <= 1; // DEFAULT 
            if (sample_counter== mid_sample - 1) shift <= 1; //if the sample counter is 1, trigger shit
                if (sample_counter== div_sample - 1) begin //if the sample counter us 3 as the sample rate used is 4
                    if (bit_counter == div_bit - 1) begin //chec k if the bit counter is9 or not (0-9)
                nextstate <= 0; //idle state
                end 
                inc_bitcounter <=1; //trigger the increment bit counter if bit count is not 9,
                clear_samplecounter <=1; //trigger the sample counter to reset the sample counter
            end else inc_samplecounter <=1; //if the sample counter is not 4, or not equal to 3 (0-3)
        end
       default: nextstate <=0; //idle state
     endcase
end         
endmodule
*/
