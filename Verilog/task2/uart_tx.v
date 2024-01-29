// AstroTinker Bot : Task 2A : UART Transmitter
/*
Instructions
-------------------
Students are not allowed to make any changes in the Module declaration.

This file is used to generate UART Tx data packet to transmit the messages based on the input data.

Recommended Quartus Version : 20.1
The submitted project file must be 20.1 compatible as the evaluation will be done on Quartus Prime Lite 20.1.

Warning: The error due to compatibility will not be entertained.
-------------------
*/

/*
Module UART Transmitter

Input:  clk_50M - 50 MHz clock
        data    - 8-bit data line to transmit
Output: tx      - UART Transmission Line
*/

// module declaration



// module declaration
/*
module uart_tx(
	 input reset,
    input clk_50M,
 //   input [7:0] data,
    output reg tx
);

//////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE//////////////////

//initial begin
//	 tx = 0;
//end

////////// Add your code here ///////////////////
parameter START_BIT_STATE = 2'b00;
parameter DATA_BITS_STATE = 2'b01;
parameter STOP_BIT_STATE = 2'b10;
//parameter SPECIAL_STATE = 2'b11;

reg [1:0] state;            // FSM state
reg [3:0] bit_count;    // Bit counter
reg [10:0] baud_counter;  // Counter for Baud Rate generation
reg [3:0] d_count;
reg x;
wire [7:0] data ;
//parameter [7:0] data =8'b01000010 ;
//
//reg [7:0] data [0:11];
//assign data[0]  = "H";
//assign data[1]  = "e";
//assign data[2]  = "l";
//assign data[3]  = "l";
//assign data[4]  = "o";
//assign data[5]  = " ";
//assign data[6]  = "W";
//assign data[7]  = "o";
//assign data[8]  = "r";
//assign data[9]  = "l";
//assign data[10] = "d";
//assign data[11] = "!";


initial begin
	state = START_BIT_STATE;
	tx = 0;
	bit_count = 0;
	baud_counter = 1;
	x = 0;
	//data = 8'h41;  // ASCII value for 'A'
	//data = 8'b01000010;
end

assign data = 8'b1111111;

always @(posedge clk_50M) begin
	if(reset == 0) x = 1;
	if(x == 1) begin
	case(state)
		START_BIT_STATE:
		if(data == 8'b00000000)
		begin
			tx = 1;
		end
		else begin
			if(baud_counter < 434) begin
				tx = 0;
				
			end
			else begin
				state = DATA_BITS_STATE;
				baud_counter = 0;
				bit_count = 0;
			end
		end
		
				

		DATA_BITS_STATE:

			if(bit_count <= 7)
			begin 

					if(baud_counter < 434)
							tx = data[bit_count];
					else 
						begin
							bit_count = bit_count + 1;
							baud_counter = 0;
						end			
			end
			
			else 
				begin
					state = STOP_BIT_STATE;
					bit_count = 0;
				end	
				
		STOP_BIT_STATE:

			if(baud_counter < 434)
				begin
					tx = 1;
				end
			else
				begin
					baud_counter = 0;
					state = START_BIT_STATE;
				end
	endcase
end
	baud_counter = baud_counter + 1;

end
endmodule
*/



module uart_tx(
    input clk,
//    input [7:0] data,
    input transmit,
    input reset,
    output reg TxD
    );
    
    //internal variables
reg [3:0] bit_counter;//Counter to count the 10 bits
reg [13:0] baudrate_counter; //10,415, counter=clock(100 Mhz) / BR (9600)  //433
reg [9:0] shiftright_register; //10 bits that will be serially transmitted through UART to the Basys 3 Board
reg state, next_state; //idle mode and transmitting mode
reg shift; //shift signal to start shifting the bits in the UART
reg load;// load signal to start loading the data into the shiftright register, and add start and stop bits
reg clear;//reset the bit_counter for UART transmission
wire [7:0]data = "Q";    
//UART transmission
    
always @(posedge clk)
begin
	if (reset)
		begin
			state<=0; //state is idle
			bit_counter<=0; //counter for bit transmission is reset to 0
			baudrate_counter<=0;
		end
   else 
		begin
			baudrate_counter<=baudrate_counter+1;
			if (baudrate_counter==433)    //433
				begin
					state<=next_state; //state changes from idle to transmitting
					baudrate_counter<=0;//resetting counter
					if (load) //if load is asserted
						shiftright_register<={1'b1, data,1'b0};//the data is loaded into the register, 10-bits
					if (clear)//if clear is asserted
						bit_counter<=0;
					if (shift)//if shift signal is asserted
						begin
							shiftright_register<=shiftright_register>>1;//start shifting the data and transmitting bit by bit
							bit_counter<=bit_counter+1;
						end
				end
		end
end
  //Mealy Machine, State Machine
always @(posedge clk)
	begin
		load<=0; //setting load equal to 0
		shift<=0; //initially 0
		clear<=0; //initially 0
		TxD<=1; //when set to 1, there is no transmission in progress
    
    case(state) //idle state
    0: begin
		if (transmit) //transmit button is pressed
			begin 
				next_state<=1; //it moves/swtcihes to transmission state
				load<=1; //start loading the bits
				shift<=0; //no shift at this point;
				clear<=0; // to avoid any clearing of any counter
			end
	
		else 
			begin //if transmit button is not asserted/pressed
				next_state<=0; //stays at the idle mode
				TxD <= 1; //no transmission
			end
    end
    
    1: begin //transmitting state
		if (bit_counter==10)
			begin
			next_state<=0; //it should switch from transmission mode to idle mode
			clear<=1; //clear all the counters
			end
		else begin
			next_state<=1; //stay in the transmit state
			TxD<=shiftright_register[0];
			shift<=1;//continue shifting the data, new bit arrives at the RMB
		end
    end
    default: next_state<=0;
    endcase
          
     end
endmodule
