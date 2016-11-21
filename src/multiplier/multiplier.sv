`timescale 1ms / 1ms

module multiplier(
  // Global synchronisation signals
  clock,
  reset_n,
  // Control signals
  start,
  ready,
  // Data inputs/outputs
  multiplicand,
  multiplier,
  product
);

  // Width of datapath in bits.
  parameter N = 4;

  input logic clock;
  input logic reset_n;
  input logic start;
  output logic ready;
  input logic [N-1:0] multiplicand;
  input logic [N-1:0] multiplier;
  output logic [N*2-1:0] product;

  logic counter_is_zero;
  logic datapath_do_init;
  logic datapath_do_shift;
  logic counter_do_preset;
  logic counter_do_decrement;

  multiplier_datapath #(.N(N)) datapath (
    .clock(clock),
    .reset_n(reset_n),
    .do_init(datapath_do_init),
    .do_shift(datapath_do_shift),
    .multiplicand(multiplicand),
    .multiplier(multiplier),
    .product(product)
  );

  multiplier_counter #(.N(N)) counter (
    .clock(clock),
    .reset_n(reset_n),
    .do_preset(counter_do_preset),
    .do_decrement(counter_do_decrement),
    .is_zero(counter_is_zero)
  );

  multiplier_controller controller (
    .clock(clock),
    .reset_n(reset_n),
    .start(start),
    .ready(ready),
    .counter_is_zero(counter_is_zero),
    .datapath_do_init(datapath_do_init),
    .datapath_do_shift(datapath_do_shift),
    .counter_do_preset(counter_do_preset),
    .counter_do_decrement(counter_do_decrement)
  );
endmodule
