package FIFO_write_agent_pkg;
    `include "uvm_macros.svh"
    import uvm_pkg::*;
    import FIFO_config_obj_pkg::*;
    import FIFO_write_sequence_item_pkg::*;
    import FIFO_write_sequencer_pkg::*;
    import FIFO_write_driver_pkg::*;
    import FIFO_write_monitor_pkg::*;

    class FIFO_write_agent extends uvm_agent;
        `uvm_component_utils(FIFO_write_agent)
        FIFO_write_sequencer sqr_wr;
        FIFO_write_driver drv_wr;
        FIFO_write_monitor mon_wr;
        FIFO_config_obj config_obj_wr_agent;
        uvm_analysis_port #(FIFO_write_sequence_item) agt_ap_wr;

        function new(string name = "FIFO_write_agent", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            if (!uvm_config_db #(FIFO_config_obj)::get(this, "", "fifo_vif", config_obj_wr_agent)) begin
                `uvm_fatal("build_phase", "Write Agent - Unable to get the virtual interface of the FIFO from the uvm_config_db");
            end
            sqr_wr = FIFO_write_sequencer::type_id::create("sqr_wr", this);
            drv_wr = FIFO_write_driver::type_id::create("drv_wr", this);
            mon_wr = FIFO_write_monitor::type_id::create("mon_wr", this);
            agt_ap_wr = new("agt_ap_wr", this);
        endfunction

        function void connect_phase (uvm_phase phase);
            super.connect_phase(phase);
            drv_wr.write_driver_vif = config_obj_wr_agent.fifo_config_vif;
            mon_wr.write_monitor_vif = config_obj_wr_agent.fifo_config_vif;
            drv_wr.seq_item_port.connect(sqr_wr.seq_item_export);
            mon_wr.mon_ap_wr.connect(agt_ap_wr);
        endfunction
    endclass
endpackage