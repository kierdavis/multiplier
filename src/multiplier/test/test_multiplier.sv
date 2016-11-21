`timescale 1ms / 1ms

module test_multiplier;
  // Width of datapath in bits.
  localparam N = 4;

  logic clock, reset_n, start, ready;
  logic [N-1:0] multiplicand, multiplier;
  logic [N*2-1:0] product;

  multiplier #(.N(N)) m (.*);

  initial begin
    // Initialise inputs.
    clock = 1'd1;
    reset_n = 1'd0;
    start = 1'd0;
    multiplicand = 4'd11;
    multiplier = 4'd6;

    #100 assert (product == 8'd0 & ready == 1'd0);   // t=100 check outputs are reset
    #800 reset_n = 1'd1;                             // t=900 exit reset
    #100;                                            // t=1000 clock posedge
    #100 assert (product == 8'd0 & ready == 1'd0);   // t=1100 check outputs unchanged
    #800 start = 1'd1;                               // t=1900 assert start
    #100;                                            // t=2000 clock posedge
    #100 assert (product == 8'd6 & ready == 1'd0);   // t=2100 check product set to initial value
    #800 start = 1'd0;                               // t=2900 deassert start
    #100;                                            // t=3000 clock posedge
    #100 assert (product == 8'd3 & ready == 1'd0);   // t=3100 check first stage of computation is complete
    #900;                                            // t=4000 clock posedge
    #100 assert (product == 8'd89 & ready == 1'd0);  // t=4100 check second stage of computation is complete
    #900;                                            // t=5000 clock posedge
    #100 assert (product == 8'd132 & ready == 1'd0); // t=5100 check third stage of computation is complete
    #900;                                            // t=6000 clock posedge
    #100 assert (product == 8'd66 & ready == 1'd1);  // t=6100 check final stage of computation is complete
                                                     //        and ready is asserted
    $stop;
  end

  always #500 clock = ~clock;
endmodule
