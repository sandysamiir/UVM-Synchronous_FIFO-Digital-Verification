package FIFO_read_sequencer_pkg;
    `include "uvm_macros.svh"
    import uvm_pkg::*;
    import FIFO_read_sequence_item_pkg::*;

    class FIFO_read_sequencer extends uvm_sequencer #(FIFO_read_sequence_item);
        `uvm_component_utils(FIFO_read_sequencer)

        function new(string name = "FIFO_read_sequencer", uvm_component parent = null);
            super.new(name, parent);
        endfunction
    endclass
endpackage