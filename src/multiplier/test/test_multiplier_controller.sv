`timescale 1ms / 1ms

module test_multiplier_controller;
  logic clock, reset_n, start, ready, counter_is_zero;
  logic datapath_do_init, datapath_do_shift;
  logic counter_do_preset, counter_do_decrement;
  logic [4:0] outputs;

  multiplier_controller multiplier_controller (.*);

  assign outputs = {ready, datapath_do_init, datapath_do_shift, counter_do_preset, counter_do_decrement};

  initial begin
    // Initialise inputs
    clock = 1'd1;
    reset_n = 1'd0; // Start in the reset state
    start = 1'd0;
    counter_is_zero = 1'd0;

    #100 assert (outputs == 5'b00000); // t=100 check outputs are reset
    #800 reset_n = 1'd1;               // t=900 exit reset
    #100;                              // t=1000 clock posedge
    #100 assert (outputs == 5'b00000); // t=1100 check outputs unchanged
    #900;                              // t=2000 clock posedge
    #100 assert (outputs == 5'b00000); // t=2100 check outputs unchanged
    #700 start = 1'd1;                 // t=2800 assert start
    #100 assert (outputs == 5'b01010); // t=2900 check datapath_do_init and counter_do_preset are asserted
    #100;                              // t=3000 clock posedge
    #800 start = 1'd0;                 // t=3800 deassert start
    #100 assert (outputs == 5'b00101); // t=3900 check datapath_do_shift and counter_do_decrement are asserted
    #100;                              // t=4000 clock posedge
    #900 assert (outputs == 5'b00101); // t=4900 check datapath_do_shift and counter_do_decrement are asserted
    #100;                              // t=5000 clock posedge
    #800 counter_is_zero = 1'd1;       // t=5800 assert counter_is_zero
    #100 assert (outputs == 5'b00100); // t=5900 check only datapath_do_shift is asserted
    #100;                              // t=6000 clock posedge
    #100 assert (outputs == 5'b10000); // t=6100 check ready asserted
    #900;                              // t=7000 clock posedge
    #100 assert (outputs == 5'b10000); // t=7100 check outputs unchanged
    $stop;
  end

  always #500 clock = ~clock;
endmodule
