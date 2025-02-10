package FIFO_read_sequence_item_pkg;
    `include "uvm_macros.svh"
    import uvm_pkg::*;
    import shared_pkg::*;
    class FIFO_read_sequence_item extends uvm_sequence_item;
        `uvm_object_utils(FIFO_read_sequence_item)

        rand bit rst_n, rd_en;
        bit [FIFO_WIDTH-1:0] data_out;
        bit underflow, empty, almostempty;

        // Distribution variables
        int RD_EN_ON_DIST;
        int WR_EN_ON_DIST;

        function new(string name = "FIFO_read_sequence_item", int rd_dist = 30);
            super.new(name);
            RD_EN_ON_DIST = rd_dist;
            rst_n = 1;
            rd_en = 0;
        endfunction

        function string convert2string();
            return $sformatf("%s reset = 0b%0b, rd_en = 0b%0b, underflow = 0b%0b, empty = 0b%0b, almostempty = 0b%0b, data_out = 0x%0h", super.convert2string(),
            rst_n, rd_en, underflow, empty, almostempty, data_out);
        endfunction

        function string convert2string_stimulus();
            return $sformatf("reset = 0b%0b, rd_en = 0b%0b", rst_n, rd_en);
        endfunction

        // Constraint for reset signal
        constraint reset_c {
            rst_n  dist {1 := 98, 0 := 1};  //Reset is deactivated most of the time
        }
        // Constraint for read enable signal
        constraint read_en_c {
            rd_en dist {1 := RD_EN_ON_DIST, 0 := (100 - RD_EN_ON_DIST)};
        }
    endclass
endpackage