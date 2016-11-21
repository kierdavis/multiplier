`timescale 1ms / 1ms

// Wrapper for interfacing with the RCQ208's hardware.
module rcq208_frontend(
  // Master clock
  fast_clock, // Pin 24
  // Buttons
  reset_n, // Pin 130
  start_button_n, // Pin 76
  // LEDs
  led0_n, // Pin 70
  led1_n, // Pin 72
  led2_n, // Pin 69
  led3_n, // Pin 68
  led4_n, // Pin 67
  led5_n, // Pin 64
  // Seven-segment display
  segment_a_n, // Pin 168
  segment_b_n, // Pin 165
  segment_c_n, // Pin 164
  segment_d_n, // Pin 163
  segment_e_n, // Pin 162
  segment_f_n, // Pin 161
  segment_g_n, // Pin 160
  display0_enable_n, // Pin 176
  display1_enable_n, // Pin 179
  display2_enable_n, // Pin 180
  display3_enable_n // Pin 181
);

  localparam FREQ_DIVIDER_BITS = 25;

  input logic fast_clock; // approx 40 MHz
  input logic reset_n, start_button_n;
  output logic led0_n, led1_n, led2_n, led3_n, led4_n, led5_n;
  output logic segment_a_n, segment_b_n, segment_c_n, segment_d_n;
  output logic segment_e_n, segment_f_n, segment_g_n;
  output logic display0_enable_n, display1_enable_n;
  output logic display2_enable_n, display3_enable_n;

  logic slow_clock; // approx 1.19 Hz, generated from fast_clock by frequency divider.
  logic start_button, start, ready;
  logic [3:0] multiplicand, multiplier;
  logic [7:0] product;

  assign start_button = ~start_button_n;

  assign led0_n = ~ready;
  assign led1_n = ~start;
  assign led2_n = ~1'd0;
  assign led3_n = ~1'd0;
  assign led4_n = ~1'd0;
  assign led5_n = ~1'd0;

  // Start button debouncer.
  debouncer start_debouncer (
    .clock(fast_clock),
    .reset_n(reset_n),
    .in(start_button),
    .out(start)
  );

  // Frequency divider to reduce fast 40 MHz clock to slow 1.19 Hz clock.
  freq_divider #(.BITS(FREQ_DIVIDER_BITS)) freq_divider (
    .in_clock(fast_clock),
    .out_clock(slow_clock),
    .reset_n(reset_n),
    .counter() // unused
  );

  // The actual 4-bit multiplier.
  multiplier #(.N(4)) multiplier (
    .clock(slow_clock),
    .reset_n(reset_n),
    .start(start),
    .ready(ready),
    .multiplicand(multiplicand),
    .multiplier(multiplier),
    .product(product)
  );

  sevenseg_driver sevenseg_driver (
    .clock(fast_clock),
    .reset_n(reset_n),
    .value({4'd0, product, 4'd0}),
    .digit_enable(4'b0110),
    .segment_a_n(segment_a_n),
    .segment_b_n(segment_b_n),
    .segment_c_n(segment_c_n),
    .segment_d_n(segment_d_n),
    .segment_e_n(segment_e_n),
    .segment_f_n(segment_f_n),
    .segment_g_n(segment_g_n),
    .display0_enable_n(display0_enable_n),
    .display1_enable_n(display1_enable_n),
    .display2_enable_n(display2_enable_n),
    .display3_enable_n(display3_enable_n)
  );
endmodule


module sevenseg_driver(
  // Global synchronisation signals
  clock,
  reset_n,
  // Data input
  value,
  digit_enable,
  // Seven-segment display control signals
  segment_a_n,
  segment_b_n,
  segment_c_n,
  segment_d_n,
  segment_e_n,
  segment_f_n,
  segment_g_n,
  display0_enable_n,
  display1_enable_n,
  display2_enable_n,
  display3_enable_n
);

  localparam FREQ_DIVIDER_BITS = 19;

  input logic clock, reset_n;
  input logic [15:0] value;
  input logic [3:0] digit_enable;
  output logic segment_a_n, segment_b_n, segment_c_n, segment_d_n;
  output logic segment_e_n, segment_f_n, segment_g_n;
  output logic display0_enable_n, display1_enable_n;
  output logic display2_enable_n, display3_enable_n;

  logic [FREQ_DIVIDER_BITS-1:0] freq_divider_counter;
  logic [1:0] current_display_num;
  logic [3:0] current_digit;
  logic current_digit_enable;
  logic [6:0] segments;

  // Frequency divider to reduce fast 40 MHz clock to slow 76.3 Hz clock.
  freq_divider #(.BITS(FREQ_DIVIDER_BITS)) freq_divider (
    .in_clock(clock),
    .out_clock(), // unused
    .reset_n(reset_n),
    .counter(freq_divider_counter)
  );

  assign current_display_num = freq_divider_counter[FREQ_DIVIDER_BITS-1:FREQ_DIVIDER_BITS-2];

  always_comb begin
    current_digit = 4'd0;
    current_digit_enable = 1'd0;
    display0_enable_n = 1'd1;
    display1_enable_n = 1'd1;
    display2_enable_n = 1'd1;
    display3_enable_n = 1'd1;
    case (current_display_num)
      2'd0: begin
        current_digit = value[15:12];
        current_digit_enable = digit_enable[3];
        display0_enable_n = 1'd0;
      end
      2'd1: begin
        current_digit = value[11:8];
        current_digit_enable = digit_enable[2];
        display1_enable_n = 1'd0;
      end
      2'd2: begin
        current_digit = value[7:4];
        current_digit_enable = digit_enable[1];
        display2_enable_n = 1'd0;
      end
      2'd3: begin
        current_digit = value[3:0];
        current_digit_enable = digit_enable[0];
        display3_enable_n = 1'd0;
      end
    endcase
  end

  always_comb begin
    segments = 7'd0;
    if (current_digit_enable) begin
      case (current_digit)
        4'h0: segments = 7'b1111110;
        4'h1: segments = 7'b0110000;
        4'h2: segments = 7'b1101101;
        4'h3: segments = 7'b1111001;
        4'h4: segments = 7'b0110011;
        4'h5: segments = 7'b1011011;
        4'h6: segments = 7'b1011111;
        4'h7: segments = 7'b1110000;
        4'h8: segments = 7'b1111111;
        4'h9: segments = 7'b1111011;
        4'hA: segments = 7'b1110111;
        4'hB: segments = 7'b0011111;
        4'hC: segments = 7'b0001101;
        4'hD: segments = 7'b0111101;
        4'hE: segments = 7'b1001111;
        4'hF: segments = 7'b1000111;
      endcase
    end
  end

  assign segment_a_n = ~segments[6];
  assign segment_b_n = ~segments[5];
  assign segment_c_n = ~segments[4];
  assign segment_d_n = ~segments[3];
  assign segment_e_n = ~segments[2];
  assign segment_f_n = ~segments[1];
  assign segment_g_n = ~segments[0];
endmodule
