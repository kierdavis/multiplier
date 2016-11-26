`timescale 1ms / 1ms

module test_freq_divider;
  localparam BITS = 8;

  logic in_clock, out_clock, reset_n;
  logic [BITS-1:0] counter;
  int i;

  freq_divider #(.BITS(BITS)) freq_divider (.*);

  initial begin
    // Initialise inputs.
    in_clock = 1'd1;
    reset_n = 1'd0; // Start in the reset state
    #18 reset_n = 1'd1; // Exit reset
    for (i = 0; i < 64; i++) begin
      // in_clock has period 20 (half-period 10)
      // out_clock has period 20*256=5120 (half-period 2560)
      #2560 assert (out_clock == 1'd1);
      #2560 assert (out_clock == 1'd0);
    end
    $stop;
  end

  always #10 in_clock = ~in_clock;
endmodule
