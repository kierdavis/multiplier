module multiplier_datapath(
  // Global synchronisation signals
  clock,
  n_reset,

  // Internal control signals
  do_init, // Asserted when we want to set 'a' to 0 and 'q' to the multiplier.
  do_shift, // Asserted when we want to perform the shift-and-add operation on 'a' and 'q'.

  // Multiplier data inputs (multiplicand and multiplier)
  multiplicand,
  multiplier,

  // Multiplier data outputs
  product
);

  // Width of datapath in bits.
  parameter N = 4;

  input logic clock;
  input logic n_reset;
  input logic do_init;
  input logic do_shift;
  input logic [N-1:0] multiplicand;
  input logic [N-1:0] multiplier;
  output logic [N*2-1:0] product;


  //// Node definitions ////

  // Register data outputs:
  logic [N-1:0] a, q;
  // Register data inputs:
  logic [N-1:0] a_next, q_next;
  // ALU outputs:
  logic [N-1:0] a_shifted, q_shifted;
  // ALU intermediate signals:
  logic [N-1:0] addend, sum;
  logic carry;


  //// Register clock logic ////

  always_ff @(posedge clock or negedge n_reset) begin
    if (~n_reset) begin
      a <= 0;
      q <= 0;
    end
    else begin
      a <= a_next;
      q <= q_next;
    end
  end


  //// Register input logic ////

  always_comb begin
    a_next = a;
    q_next = q;

    if (do_init) begin
      a_next = 0;
      q_next = multiplier;
    end

    if (do_shift) begin
      a_next = a_shifted;
      q_next = q_shifted;
    end
  end


  //// ALU ////

  // Decide whether we are adding m or 0, based on the LSB of q.
  assign addend = q[0] ? multiplicand : 0;
  // Add 'addend' to 'a'.
  assign {carry, sum} = {1'd0, a} + {1'd0, addend};
  // Perform the shift, by:
  // - moving the carry bit into the MSB of a
  // - moving the LSB of a into the MSB of q
  // - discarding the LSB of q
  assign {a_shifted, q_shifted} = {carry, sum, q[N-1:1]};


  //// Data output ////

  assign product = {a, q};
endmodule
