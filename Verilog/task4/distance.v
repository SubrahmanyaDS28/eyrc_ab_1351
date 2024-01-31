module distance #(parameter ten_us = 20'd2000) (
  input clk, // 50 MHz
  input rst,
  input measure,
  
  output ready,
  // HC-SR04 signals
  input echo, // JA1
  output trig, // JA2
  output reg [21:0] distanceRAW
);

 reg [1:0] state;
  localparam IDLE = 2'b00,
            TRIGGER = 2'b01,
            WAIT = 2'b11,
            COUNTECHO = 2'b10;

  wire inIDLE, inTRIGGER, inWAIT, inCOUNTECHO;
  reg [9:0] counter;
  wire trigcountDONE, counterDONE;

  // Ready
  assign ready = inIDLE;

  // Decode states
  assign inIDLE = (state == IDLE);
  assign inTRIGGER = (state == TRIGGER);
  assign inWAIT = (state == WAIT);
  assign inCOUNTECHO = (state == COUNTECHO);

  // State transactions
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      state <= IDLE;
    end else begin
      case(state)
        IDLE:
          begin
            state <= (measure & ready) ? TRIGGER : state;
          end
        TRIGGER:
          begin
            state <= (trigcountDONE) ? WAIT : state;
          end
        WAIT:
          begin
            state <= (echo) ? COUNTECHO : state;
          end
        COUNTECHO:
          begin
            state <= (echo) ? state : IDLE;
          end
      endcase
    end
  end

  // Trigger
  assign trig = inTRIGGER;

  // Counter
  always @(posedge clk) begin
    if (inIDLE) begin
      counter <= 10'd0;
    end else begin
      counter <= counter + (|counter | inTRIGGER);
    end
  end
  assign trigcountDONE = (counter == ten_us);

  // Get distance
  always @(posedge clk) begin
    if (inWAIT) begin
      distanceRAW <= 22'd0;
    end else begin
      distanceRAW <= distanceRAW + (21'd0 | inCOUNTECHO);
    end
  end
endmodule

module refresher250ms (
  input clk,
  input en,
  output measure
);
  reg [24:0] counter;

  assign measure = (counter == 25'd5_000_000); // 250ms for 50MHz clock

  always @(posedge clk) begin
    if (~en | (counter == 25'd5_000_000)) begin
      counter <= 25'd0;
    end else begin
      counter <= counter + 1;
    end
  end
endmodule
