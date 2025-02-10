package FIFO_coverage_pkg;
    `include "uvm_macros.svh"
    import uvm_pkg::*;
    import shared_pkg::*;
    import FIFO_write_sequence_item_pkg::*;
    import FIFO_read_sequence_item_pkg::*;

    class FIFO_coverage extends uvm_component;
        `uvm_component_utils(FIFO_coverage)
        uvm_analysis_export #(FIFO_write_sequence_item) cov_export_wr;
        uvm_tlm_analysis_fifo #(FIFO_write_sequence_item) cov_fifo_wr;
        FIFO_write_sequence_item seq_item_cov_wr;
        uvm_analysis_export #(FIFO_read_sequence_item) cov_export_rd;
        uvm_tlm_analysis_fifo #(FIFO_read_sequence_item) cov_fifo_rd;
        FIFO_read_sequence_item seq_item_cov_rd;

        //////////////////////////////// Covergroups /////////////////////////////////
        covergroup fifo_cvg;
         // Coverpoints 
            wr_en_cp: coverpoint seq_item_cov_wr.wr_en {
                bins wr_en_0 = {0};
                bins wr_en_1 = {1};
            } 
            rd_en_cp: coverpoint seq_item_cov_rd.rd_en {
                bins rd_en_0 = {0};
                bins rd_en_1 = {1};
            } 
            wr_ack_cp: coverpoint seq_item_cov_wr.wr_ack {
                bins wr_ack_0 = {0};
                bins wr_ack_1 = {1};
            } 
            overflow_cp: coverpoint seq_item_cov_wr.overflow {
                bins overflow_0 = {0};
                bins overflow_1 = {1};
            } 
            underflow_cp: coverpoint seq_item_cov_rd.underflow {
                bins underflow_0 = {0};
                bins underflow_1 = {1};
            }
            full_cp: coverpoint seq_item_cov_wr.full {
                bins full_0 = {0};
                bins full_1 = {1};
            }  
            empty_cp: coverpoint seq_item_cov_rd.empty {
                bins empty_0 = {0};
                bins empty_1 = {1};
            } 
            almostfull_cp: coverpoint seq_item_cov_wr.almostfull {
                bins almostfull_0 = {0};
                bins almostfull_1 = {1};
            }
            almostempty_cp: coverpoint seq_item_cov_rd.almostempty {
                bins almostempty_0 = {0};
                bins almostempty_1 = {1};
            }
         // cross coverage 
            WR_ACK_CX: cross wr_en_cp, rd_en_cp, wr_ack_cp {
                ignore_bins wr_en_0_wr_ack_1_rd_en_0 = binsof(wr_en_cp.wr_en_0) && binsof(rd_en_cp.rd_en_0) && binsof(wr_ack_cp.wr_ack_1);
                ignore_bins wr_en_0_wr_ack_1_rd_en_1 = binsof(wr_en_cp.wr_en_0) && binsof(rd_en_cp.rd_en_1) && binsof(wr_ack_cp.wr_ack_1);
            }
            OVERFLOW_CX: cross wr_en_cp, rd_en_cp, overflow_cp {
                ignore_bins wr_en_0_overflow_1_rd_en_0 = binsof(wr_en_cp.wr_en_0) && binsof(rd_en_cp.rd_en_0) && binsof(overflow_cp.overflow_1);
                ignore_bins wr_en_0_overflow_1_rd_en_1 = binsof(wr_en_cp.wr_en_0) && binsof(rd_en_cp.rd_en_1) && binsof(overflow_cp.overflow_1);
            }
            UNDERFLOW_CX: cross wr_en_cp, rd_en_cp, underflow_cp {
                ignore_bins wr_en_0_underflow_1_rd_en_0 = binsof(wr_en_cp.wr_en_0) && binsof(rd_en_cp.rd_en_0) && binsof(underflow_cp.underflow_1);
                ignore_bins wr_en_1_underflow_1_rd_en_0 = binsof(wr_en_cp.wr_en_1) && binsof(rd_en_cp.rd_en_0) && binsof(underflow_cp.underflow_1);
            } 
            FULL_CX: cross wr_en_cp, rd_en_cp, full_cp {
                ignore_bins wr_en_0_full_1_rd_en_1 = binsof(wr_en_cp.wr_en_0) && binsof(rd_en_cp.rd_en_1) && binsof(full_cp.full_1);
                ignore_bins wr_en_1_full_1_rd_en_1 = binsof(wr_en_cp.wr_en_1) && binsof(rd_en_cp.rd_en_1) && binsof(full_cp.full_1);
            }
            EMPTY_CX: cross wr_en_cp, rd_en_cp, empty_cp; 
            ALMOSTFULL_CX: cross wr_en_cp, rd_en_cp, almostfull_cp; 
            ALMOSTEMPTY_CX: cross wr_en_cp, rd_en_cp, almostempty_cp; 
        endgroup


        function new(string name = "FIFO_coverage", uvm_component parent = null);
            super.new(name, parent);
            fifo_cvg = new();
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            cov_export_wr = new("cov_export_wr", this);
            cov_fifo_wr = new("cov_fifo_wr", this);
            cov_export_rd = new("cov_export_rd", this);
            cov_fifo_rd = new("cov_fifo_rd", this);
        endfunction

        function void connect_phase (uvm_phase phase);
            super.connect_phase(phase);
            cov_export_wr.connect(cov_fifo_wr.analysis_export);
            cov_export_rd.connect(cov_fifo_rd.analysis_export);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                cov_fifo_wr.get(seq_item_cov_wr);
                cov_fifo_rd.get(seq_item_cov_rd);
                fifo_cvg.sample();
            end
        endtask
    endclass
endpackage