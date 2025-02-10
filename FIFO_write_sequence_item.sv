package FIFO_write_sequence_item_pkg;
    `include "uvm_macros.svh"
    import uvm_pkg::*;
    import shared_pkg::*;
    class FIFO_write_sequence_item extends uvm_sequence_item;
        `uvm_object_utils(FIFO_write_sequence_item)

        rand bit rst_n, wr_en;
        rand bit [FIFO_WIDTH-1:0] data_in;
        bit wr_ack, overflow, full, almostfull;

        // Distribution variable
        int WR_EN_ON_DIST;

        function new(string name = "FIFO_write_sequence_item", int wr_dist = 70);
            super.new(name);
            WR_EN_ON_DIST = wr_dist;
            rst_n = 1;
            wr_en = 0;
            data_in = 0;
        endfunction

        function string convert2string();
            return $sformatf("%s reset = 0b%0b, wr_en = 0b%0b, data_in = 0x%0h, wr_ack = 0b%0b, overflow = 0b%0b, full = 0b%0b, almostfull = 0b%0b", super.convert2string(),
            rst_n, wr_en, data_in, wr_ack, overflow, full, almostfull);
        endfunction

        function string convert2string_stimulus();
            return $sformatf("reset = 0b%0b, wr_en = 0b%0b, data_in = 0x%0h", rst_n, wr_en, data_in);
        endfunction

        // Constraint for reset signal
        constraint reset_c {
            rst_n  dist {1 := 98, 0 := 1};  //Reset is deactivated most of the time
        }
        //  Constraint for write enable signal
        constraint write_en_c {
            wr_en dist {1 := WR_EN_ON_DIST, 0 := (100 - WR_EN_ON_DIST)};
        }
        constraint data_in_c {
            if (!wr_en) data_in == 0;  // Set data_in to zero when wr_en is not active
        }
    endclass
endpackage