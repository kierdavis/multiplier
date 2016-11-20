module multiplier_controller(
  // Global synchronisation signals
  clock,
  n_reset,

  // Multiplier control signals
  start,
  ready,

  // Internal control signals
  counter_is_zero,
  datapath_do_init,
  datapath_do_shift,
  counter_do_preset,
  counter_do_decrement
);

  input logic clock;
  input logic n_reset;
  input logic start;
  output logic ready;
  input logic counter_is_zero;
  output logic datapath_do_init;
  output logic datapath_do_shift;
  output logic counter_do_preset;
  output logic counter_do_decrement;

  enum {IDLE, WORKING, DONE} state, next_state;

  always_ff @(posedge clock or negedge n_reset) begin
    if (~n_reset) begin
      state <= IDLE;
    end
    else begin
      state <= next_state;
    end
  end

  always_comb begin
    next_state = state;
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
      end

      WORKING: begin
        // Perform the shift-and-add operation on A and Q.
        datapath_do_shift = 1'd1;
        // If the counter is zero, move to the "done" state (but still do the shift-and-add operation as well).
        if (counter_is_zero) begin
          next_state = DONE;
        end
        else begin
          // Otherwise, decrement the counter.
          counter_do_decrement = 1'd1;
        end
      end

      DONE: begin
        // Assert the ready signal and stay in this state forever.
        ready = 1'd1;
      end
    endcase
  end
endmodule
