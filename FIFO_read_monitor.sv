package FIFO_read_monitor_pkg;
    `include "uvm_macros.svh"
    import uvm_pkg::*;
    import shared_pkg::*;
    import FIFO_read_sequence_item_pkg::*;

    class FIFO_read_monitor extends uvm_monitor;
        `uvm_component_utils(FIFO_read_monitor)
        virtual FIFO_if read_monitor_vif;
        FIFO_read_sequence_item rsp_seq_item_rd;
        uvm_analysis_port #(FIFO_read_sequence_item) mon_ap_rd;

        function new(string name = "FIFO_read_monitor", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            mon_ap_rd = new("mon_ap_rd", this);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                rsp_seq_item_rd = FIFO_read_sequence_item::type_id::create("rsp_seq_item_rd");
                @(negedge read_monitor_vif.clk);
                rsp_seq_item_rd.rst_n = read_monitor_vif.rst_n;
                rsp_seq_item_rd.rd_en = read_monitor_vif.rd_en;
                rsp_seq_item_rd.data_out = read_monitor_vif.data_out;
                rsp_seq_item_rd.underflow = read_monitor_vif.underflow;
                rsp_seq_item_rd.empty = read_monitor_vif.empty;
                rsp_seq_item_rd.almostempty = read_monitor_vif.almostempty;
                mon_ap_rd.write(rsp_seq_item_rd);
                `uvm_info("run_phase", rsp_seq_item_rd.convert2string(), UVM_HIGH);
            end
        endtask
    endclass
endpackage