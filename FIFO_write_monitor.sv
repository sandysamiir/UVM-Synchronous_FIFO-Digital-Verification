package FIFO_write_monitor_pkg;
    `include "uvm_macros.svh"
    import uvm_pkg::*;
    import shared_pkg::*;
    import FIFO_write_sequence_item_pkg::*;

    class FIFO_write_monitor extends uvm_monitor;
        `uvm_component_utils(FIFO_write_monitor)
        virtual FIFO_if write_monitor_vif;
        FIFO_write_sequence_item rsp_seq_item_wr;
        uvm_analysis_port #(FIFO_write_sequence_item) mon_ap_wr;

        function new(string name = "FIFO_write_monitor", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            mon_ap_wr = new("mon_ap_wr", this);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                rsp_seq_item_wr = FIFO_write_sequence_item::type_id::create("rsp_seq_item_wr");
                @(negedge write_monitor_vif.clk);
                rsp_seq_item_wr.rst_n = write_monitor_vif.rst_n;
                rsp_seq_item_wr.wr_en = write_monitor_vif.wr_en;
                rsp_seq_item_wr.data_in = write_monitor_vif.data_in;
                rsp_seq_item_wr.wr_ack = write_monitor_vif.wr_ack;
                rsp_seq_item_wr.overflow = write_monitor_vif.overflow;
                rsp_seq_item_wr.full = write_monitor_vif.full;
                rsp_seq_item_wr.almostfull = write_monitor_vif.almostfull;
                mon_ap_wr.write(rsp_seq_item_wr);
                `uvm_info("run_phase", rsp_seq_item_wr.convert2string(), UVM_HIGH);
            end
        endtask
    endclass
endpackage