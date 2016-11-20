# multiplier

An implementaton of a 4-bit shift-and-add multiplier in SystemVerilog.
This was implemented as part of the D1 design exercise in the second year of my Electronic Engineering course.

## Contents

* Source code of the multiplier itself
  * `multiplier_datapath.sv`: data registers and ALU
  * `multiplier_counter.sv`: auxillary counter used to keep track of how many iterations have been performed so far.
  * `multiplier_controller.sv`: state machine that controls the other parts of the multiplier
  * `multiplier.sv`: links the above three modules together
* Frontends for various FPGA/CPLD boards
  * `machxo2_pico_frontend.sv`: interface for the MachXO2 Pico board's hardware (the board used during the lab session)
  * `rcq208_frontend.sv`: interface for the RCQ208 board's hardware (my own FPGA board)
* Auxillary modules to glue everything together
  * `debouncer.sv`: a simple mechanical switch debouncer
  * `freq_divider.sv`: a straightforward frequency divider, used for reducing the core clock (tens of MHz) to a "real-time" 1 Hz clock
