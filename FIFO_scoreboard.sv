package FIFO_scoreboard_pkg;
    `include "uvm_macros.svh"
    import uvm_pkg::*;
    import shared_pkg::*;
    import FIFO_write_sequence_item_pkg::*;
    import FIFO_read_sequence_item_pkg::*;

    class FIFO_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(FIFO_scoreboard)
        uvm_analysis_export #(FIFO_write_sequence_item) sb_export_wr;
        uvm_tlm_analysis_fifo #(FIFO_write_sequence_item) sb_fifo_wr;
        FIFO_write_sequence_item seq_item_sb_wr;
        uvm_analysis_export #(FIFO_read_sequence_item) sb_export_rd;
        uvm_tlm_analysis_fifo #(FIFO_read_sequence_item) sb_fifo_rd;
        FIFO_read_sequence_item seq_item_sb_rd;
        // Reference model variables
        bit [FIFO_WIDTH-1:0] data_out_ref;
        // FIFO memory and pointers
        bit [FIFO_WIDTH-1:0] ref_mem [0:FIFO_DEPTH-1];  // FIFO reference
        bit [$clog2(FIFO_DEPTH)-1:0] wr_ptr, rd_ptr;
        bit [$clog2(FIFO_DEPTH):0] count;
        int error_count = 0;
        int correct_count = 0;

        function new(string name = "FIFO_scoreboard", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            sb_export_wr = new("sb_export_wr", this);
            sb_fifo_wr = new("sb_fifo_wr", this);
            sb_export_rd = new("sb_export_rd", this);
            sb_fifo_rd = new("sb_fifo_rd", this);
        endfunction

        function void connect_phase (uvm_phase phase);
            super.connect_phase(phase);
            sb_export_wr.connect(sb_fifo_wr.analysis_export);
            sb_export_rd.connect(sb_fifo_rd.analysis_export);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                sb_fifo_wr.get(seq_item_sb_wr);
                sb_fifo_rd.get(seq_item_sb_rd);
                ref_model(seq_item_sb_wr, seq_item_sb_rd);
                if(seq_item_sb_rd.data_out != data_out_ref) begin
                    `uvm_error("run_phase", $sformatf("Time: %0t: Comparison failed, Transaction received by the DUT: %s 
                    While the reference out: 0x%0h", $time, seq_item_sb_rd.convert2string(), data_out_ref));
                    error_count++;
                end
                else begin
                    `uvm_info("run_phase", $sformatf("Correct ALSU out: %s", seq_item_sb_rd.convert2string()), UVM_HIGH);
                    correct_count++;
                end  
            end
        endtask

        task ref_model(FIFO_write_sequence_item seq_item_chk_wr, FIFO_read_sequence_item seq_item_chk_rd);
            // Compute reference output
            if (!seq_item_chk_rd.rst_n || !seq_item_chk_wr.rst_n) begin
                wr_ptr = 0;
                rd_ptr = 0;
                count = 0;
            end else begin
                // Write operation
                if (seq_item_chk_wr.wr_en && !seq_item_chk_wr.overflow) begin
                    ref_mem[wr_ptr] = seq_item_chk_wr.data_in;
                    wr_ptr++;
                end 
                // Read operation
                if (seq_item_chk_rd.rd_en && !seq_item_chk_rd.underflow) begin
                    data_out_ref = ref_mem[rd_ptr];
                    rd_ptr++;
                end
                // Counter update
                if	(seq_item_chk_wr.wr_en && !seq_item_chk_rd.rd_en && !seq_item_chk_wr.full) 
                    count = count + 1;
                else if (!seq_item_chk_wr.wr_en && seq_item_chk_rd.rd_en && !seq_item_chk_rd.empty)
                    count = count - 1;
                else if (seq_item_chk_wr.wr_en && seq_item_chk_rd.rd_en && seq_item_chk_rd.empty)
                    count = count + 1;	
                else if (seq_item_chk_wr.wr_en && seq_item_chk_rd.rd_en && seq_item_chk_wr.full)
                    count = count - 1;	
            end
        endtask

        function void report_phase(uvm_phase phase);
            super.report_phase(phase);
            `uvm_info("run_phase", $sformatf("Total successful transactions: %0d", correct_count), UVM_MEDIUM)
            `uvm_info("run_phase", $sformatf("Total failed transactions: %0d", error_count), UVM_MEDIUM)
        endfunction
    endclass
endpackage

