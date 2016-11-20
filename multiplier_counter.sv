module multiplier_counter(
  // Global synchronisation signals
  clock,
  n_reset,

  // Internal control signals
  do_preset, // Asserted when we want to set the counter to its maximum value.
  do_decrement, // Asserted when we want to decrement the counter by one.

  // Outputs
  is_zero // Asserted when the counter value equals zero.
);

  // Width of datapath in bits.
  parameter N = 4;
  // Width of counter register in bits.
  localparam C = $clog2(N);

  input logic clock;
  input logic n_reset;
  input logic do_preset;
  input logic do_decrement;
  output logic is_zero;


  //// Node definitions ////

  logic [C-1:0] count, count_next;


  //// Register clock logic ////

  always_ff @(posedge clock or negedge n_reset) begin
    if (~n_reset) begin
      count <= 0;
    end
    else begin
      count <= count_next;
    end
  end


  //// Register input logic ////

  always_comb begin
    count_next = count;

    if (do_preset) begin
      count_next = N-1;
    end

    if (do_decrement) begin
      count_next = count - 1;
    end
  end


  //// Zero logic ////

  assign is_zero = ~|count;
endmodule
