package FIFO_sequence_pkg;
    `include "uvm_macros.svh"
    import uvm_pkg::*;
    import shared_pkg::*;
    import FIFO_write_sequence_item_pkg::*;
    import FIFO_read_sequence_item_pkg::*;

    class write_sequence extends uvm_sequence #(FIFO_write_sequence_item);
        `uvm_object_utils(write_sequence)
        FIFO_write_sequence_item seq_item;

        function new(string name = "write_sequence");
            super.new(name);
        endfunction

        task body;
            seq_item = FIFO_write_sequence_item::type_id::create("seq_item");
            start_item(seq_item);
            seq_item.rst_n = 0;
            seq_item.wr_en = 0;
            seq_item.data_in = 0;
            finish_item(seq_item);
            repeat(9999) begin
                seq_item = FIFO_write_sequence_item::type_id::create("seq_item");
                start_item(seq_item);
                assert(seq_item.randomize());
                finish_item(seq_item);
            end
        endtask
    endclass

    class read_sequence extends uvm_sequence #(FIFO_read_sequence_item);
        `uvm_object_utils(read_sequence)
        FIFO_read_sequence_item seq_item;

        function new(string name = "read_sequence");
            super.new(name);
        endfunction

        task body;
            seq_item = FIFO_read_sequence_item::type_id::create("seq_item");
            start_item(seq_item);
            seq_item.rst_n = 0;
            seq_item.rd_en = 0;
            finish_item(seq_item);
            repeat(9999) begin
                seq_item = FIFO_read_sequence_item::type_id::create("seq_item");
                start_item(seq_item);
                assert(seq_item.randomize());
                finish_item(seq_item);
            end
        endtask
    endclass
endpackage