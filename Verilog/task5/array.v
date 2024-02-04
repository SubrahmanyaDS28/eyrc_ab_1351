module array(
	//input clk_3125k,
	input wire [7:0] node_count,
	output reg [4:0]previous_node,
	output reg [4:0]next_node,
	output reg [4:0]node_state

);

//module array;

parameter n = 30;
wire [4:0] node [0:n];

//[0,1,29,20,24,25,26,27,26,28,29,20,21,22]

assign  node[0] = 0;
assign  node[1] = 1;
assign  node[2] = 29;
assign  node[3] = 20;
assign  node[4] = 24;
assign  node[5] = 25;
assign  node[6] = 26;
assign  node[7] = 27;
assign  node[8] = 26;
assign  node[9] = 28;
assign  node[10] = 29;
assign  node[11] = 20;
assign  node[12] = 21;
assign  node[13] = 22;

always@*
	begin
		node_state <= node[node_count];
		previous_node <= node[node_count-1];
		next_node <= node[node_count+1];
	
	end

endmodule