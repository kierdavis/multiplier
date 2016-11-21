`timescale 1ms / 1ms

module test_debouncer;
  logic clock, reset_n, in, out;

  // 3 counter bits => input needs to be high for 8*20=160 ms
  debouncer #(.COUNTER_BITS(3)) debouncer (.*);

  initial begin
    // Initialise inputs.
    clock = 1'd1;
    reset_n = 1'd0; // Start in the reset state
    in = 1'd0;

    #18 reset_n = 1'd1; // Exit reset state

    #50  assert (out == 1'd0); in = 1'd1;
    #1   assert (out == 1'd0); in = 1'd0;
    #1   assert (out == 1'd0); in = 1'd1;
    #2   assert (out == 1'd0); in = 1'd0;
    #3   assert (out == 1'd0); in = 1'd1;
    #5   assert (out == 1'd0); in = 1'd0;
    #8   assert (out == 1'd0); in = 1'd1;
    #13  assert (out == 1'd0); in = 1'd0;
    #21  assert (out == 1'd0); in = 1'd1;
    #34  assert (out == 1'd0); in = 1'd0;
    #55  assert (out == 1'd0); in = 1'd1;
    #89  assert (out == 1'd0); in = 1'd0;
    #144 assert (out == 1'd0); in = 1'd1;
    #160 assert (out == 1'd1);

    #50  assert (out == 1'd1); in = 1'd0;
    #1   assert (out == 1'd1); in = 1'd1;
    #1   assert (out == 1'd1); in = 1'd0;
    #2   assert (out == 1'd1); in = 1'd1;
    #3   assert (out == 1'd1); in = 1'd0;
    #5   assert (out == 1'd1); in = 1'd1;
    #8   assert (out == 1'd1); in = 1'd0;
    #13  assert (out == 1'd1); in = 1'd1;
    #21  assert (out == 1'd1); in = 1'd0;
    #34  assert (out == 1'd1); in = 1'd1;
    #55  assert (out == 1'd1); in = 1'd0;
    #89  assert (out == 1'd1); in = 1'd1;
    #144 assert (out == 1'd1); in = 1'd0;
    #160 assert (out == 1'd0);

    $stop;
  end

  always #10 clock = ~clock;
endmodule
