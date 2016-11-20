`timescale 1ms / 1ms

module test_multiplier_datapath;
  // width of datapath in bits.
  parameter N = 4;

  logic clock, n_reset, do_init, do_shift;
  logic [N-1:0] multiplicand, multiplier;
  logic [N*2-1:0] product;

  multiplier_datapath #(.N(N)) multiplier_datapath (.*);

  initial begin
    // Initialise inputs
    clock = 1'd1;
    n_reset = 1'd0; // Start in the reset state
    do_init = 1'd0;
    do_shift = 1'd0;
    multiplicand = 4'd11;
    multiplier = 4'd6;

    #100 assert (product == {4'd0, 4'd0}); // t=100 check registers set to 0
    #900;                                  // t=1000 clock posedge
    #900 n_reset = 1'd1;                   // t=1900 exit reset state
    #100;                                  // t=2000 clock posedge
    #100 assert (product == {4'd0, 4'd0}); // t=2100 check registers unchanged
    
    #800 do_init = 1'd1;                   // t=2900 do_init = 1
    #100;                                  // t=3000 clock posedge
    #100 assert (product == {4'd0, 4'd6}); // t=3100 check registers set to initial values

    #800 do_init = 1'd0;                   // t=3900 do_init = 0
    #100;                                  // t=4000 clock posedge
    #100 assert (product == {4'd0, 4'd6}); // t=4100 check registers unchanged

    #800 do_shift = 1'd1;                  // t=4900 do_shift = 1
    #100;                                  // t=5000 clock posedge
    #100 assert (product == {4'd0, 4'd3}); // t=5100 check first stage of computation is completed

    #800 do_shift = 1'd0;                  // t=5900 do_shift = 0
    #100;                                  // t=6000 clock posedge
    #100 assert (product == {4'd0, 4'd3}); // t=6100 check registers unchanged

    #800 do_shift = 1'd1;                  // t=6900 do_shift = 1
    #100;                                  // t=7000 clock posedge
    #100 assert (product == {4'd5, 4'd9}); // t=7100 check second stage of computation is completed

    #900;                                  // t=8000 clock posedge
    #100 assert (product == {4'd8, 4'd4}); // t=8100 check third stage of computation is completed

    #900;                                  // t=9000 clock posedge
    #100 assert (product == 8'd66);        // t=9100 check final stage of computation is completed#

    #800 do_shift = 1'd0;                  // t=9900 do_shift = 0
    #100;                                  // t=10000 clock posedge
    #100 assert (product == 8'd66);        // t=11000 check registers unchanged
    $stop;
  end

  always #500 clock = ~clock;
endmodule
