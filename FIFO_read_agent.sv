package FIFO_read_agent_pkg;
    `include "uvm_macros.svh"
    import uvm_pkg::*;
    import FIFO_config_obj_pkg::*;
    import FIFO_read_sequence_item_pkg::*;
    import FIFO_read_sequencer_pkg::*;
    import FIFO_read_driver_pkg::*;
    import FIFO_read_monitor_pkg::*;

    class FIFO_read_agent extends uvm_agent;
        `uvm_component_utils(FIFO_read_agent)
        FIFO_read_sequencer sqr_rd;
        FIFO_read_driver drv_rd;
        FIFO_read_monitor mon_rd;
        FIFO_config_obj config_obj_rd_agent;
        uvm_analysis_port #(FIFO_read_sequence_item) agt_ap_rd;

        function new(string name = "FIFO_read_agent", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            if (!uvm_config_db #(FIFO_config_obj)::get(this, "", "fifo_vif", config_obj_rd_agent)) begin
                `uvm_fatal("build_phase", "Read Agent - Unable to get the virtual interface of the FIFO from the uvm_config_db");
            end
            sqr_rd = FIFO_read_sequencer::type_id::create("sqr_rd", this);
            drv_rd = FIFO_read_driver::type_id::create("drv_rd", this);
            mon_rd = FIFO_read_monitor::type_id::create("mon_rd", this);
            agt_ap_rd = new("agt_ap_rd", this);
        endfunction

        function void connect_phase (uvm_phase phase);
            super.connect_phase(phase);
            drv_rd.read_driver_vif = config_obj_rd_agent.fifo_config_vif;
            mon_rd.read_monitor_vif = config_obj_rd_agent.fifo_config_vif;
            drv_rd.seq_item_port.connect(sqr_rd.seq_item_export);
            mon_rd.mon_ap_rd.connect(agt_ap_rd);
        endfunction
    endclass
endpackage