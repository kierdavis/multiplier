module freq_divider(in_clock, out_clock, reset_n, counter);
  parameter BITS = 8;

  input logic in_clock;
  output logic out_clock;
  input logic reset_n;
  output logic [BITS-1:0] counter;

  always_ff @(posedge in_clock or negedge reset_n) begin
    if (~reset_n) begin
      counter <= 0;
    end
    else begin
      counter <= counter + 1;
    end
  end

  assign out_clock = counter[BITS-1];
endmodule