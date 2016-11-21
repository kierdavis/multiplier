`timescale 1ms / 1ms

module multiplier_controller(
  // Global synchronisation signals:
  clock,
  reset_n,
  // Multiplier control signals:
  start,
  ready,
  // Internal control signals:
  counter_is_zero,
  datapath_do_init,
  datapath_do_shift,
  counter_do_preset,
  counter_do_decrement
);

  //// Ports ////
  input logic clock;
  input logic reset_n;
  input logic start;
  output logic ready;
  input logic counter_is_zero;
  output logic datapath_do_init;
  output logic datapath_do_shift;
  output logic counter_do_preset;
  output logic counter_do_decrement;

  //// Internal nodes ////
  enum {IDLE, WORKING, DONE} state, next_state;

  //// Register clock logic ////
  always_ff @(posedge clock or negedge reset_n) begin
    if (~reset_n) begin
      state <= IDLE;
    end
    else begin
      state <= next_state;
    end
  end

  //// Next state & output logic ////
  always_comb begin
    next_state = IDLE;
    datapath_do_init = 1'd0;
    datapath_do_shift = 1'd0;
    counter_do_preset = 1'd0;
    counter_do_decrement = 1'd0;
    ready = 1'd0;

    case (state)
      IDLE: begin
        // Wait for start signal.
        if (start) begin
          // Set A to 0 and Q to the multiplier.
          datapath_do_init = 1'd1;
          // Set the counter to its maximum value.
          counter_do_preset = 1'd1;
          // Go to the "working" state.
          next_state = WORKING;
        end
        else begin
          next_state = IDLE;
        end
      end

      WORKING: begin
        // Perform the shift-and-add operation on A and Q.
        datapath_do_shift = 1'd1;
        // If the counter is zero, move to the "done" state (but still do the shift-and-add operation as well).
        if (counter_is_zero) begin
          next_state = DONE;
        end
        else begin
          // Otherwise, decrement the counter and repeat.
          counter_do_decrement = 1'd1;
          next_state = WORKING;
        end
      end

      DONE: begin
        // Assert the ready signal and stay in this state forever.
        ready = 1'd1;
        next_state = DONE;
      end
    endcase
  end
endmodule
