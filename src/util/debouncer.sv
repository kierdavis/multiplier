`timescale 1ms / 1ms

module debouncer(clock, reset_n, in, out);
  parameter COUNTER_BITS = 5;

  input logic clock;
  input logic reset_n;
  input logic in;
  output logic out;

  // Tracks the number of consecutive clock cycles
  // for which in has been different to out.
  logic [COUNTER_BITS-1:0] counter;

  always_ff @(posedge clock or negedge reset_n) begin
    if (~reset_n) begin
      counter <= 0;
      out <= 1'd0;
    end
    else begin
      if (in ^ out)
        counter <= counter + 1; // in and out differ, increment counter
      else
        counter <= 0; // in and out are the same, reset counter
      if (&counter) // all bits of counter are 1 (i.e. counter = max value)
        out <= in; // input is stable, so update output
    end
  end
endmodule
