package FIFO_write_sequencer_pkg;
    `include "uvm_macros.svh"
    import uvm_pkg::*;
    import FIFO_write_sequence_item_pkg::*;

    class FIFO_write_sequencer extends uvm_sequencer #(FIFO_write_sequence_item);
        `uvm_component_utils(FIFO_write_sequencer)

        function new(string name = "FIFO_write_sequencer", uvm_component parent = null);
            super.new(name, parent);
        endfunction
    endclass
endpackage