`timescale 1ms / 1ms

module test_multiplier_counter;
  // width of datapath in bits.
  parameter N = 4;

  logic clock, n_reset, do_preset, do_decrement, is_zero;

  multiplier_counter #(.N(N)) multiplier_counter (.*);

  initial begin
    // Initialise inputs
    clock = 1'd1;
    n_reset = 1'd0; // Start in the reset state]
    do_preset = 1'd0;
    do_decrement = 1'd0;

    #100 assert (is_zero);  // t=100 check counter = 0
    #800 n_reset = 1'd1;    // t=900 exit reset
    #100;                   // t=1000 clock posedge
    #100 assert (is_zero);  // t=1100 check counter unchanged
    #800 do_preset = 1'd1;  // t=1900 do_preset = 1
    #100;                   // t=2000 clock posedge
    #100 assert (~is_zero); // t=2100 check counter != 0 (= 3)
    #800 do_preset = 1'd0;  // t=2900 do_preset = 0
    do_decrement = 1'd1;    // t=2900 do_decrement = 1
    #100;                   // t=3000 clock posedge
    #100 assert (~is_zero); // t=3100 check counter != 0 (= 2)
    #900;                   // t=4000 clock posedge
    #100 assert (~is_zero); // t=4100 check counter != 0 (= 1)
    #900;                   // t=5000 clock posedge
    #100 assert (is_zero);  // t=5100 check counter = 0
    $stop;
  end

  always #500 clock = ~clock;
endmodule
