package FIFO_env_pkg;
    `include "uvm_macros.svh"
    import uvm_pkg::*;
    import FIFO_write_agent_pkg::*;
    import FIFO_read_agent_pkg::*;
    import FIFO_scoreboard_pkg::*;
    import FIFO_coverage_pkg::*;

    class FIFO_env extends uvm_env;
        `uvm_component_utils(FIFO_env)
        FIFO_write_agent agt_wr;
        FIFO_read_agent agt_rd;
        FIFO_scoreboard sb;
        FIFO_coverage cov;

        function new(string name = "FIFO_env", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            agt_wr = FIFO_write_agent::type_id::create("agt_wr",this);
            agt_rd = FIFO_read_agent::type_id::create("agt_rd",this);
            sb = FIFO_scoreboard::type_id::create("sb",this);
            cov = FIFO_coverage::type_id::create("cov",this);
        endfunction 

        function void connect_phase(uvm_phase phase);
            agt_wr.agt_ap_wr.connect(sb.sb_export_wr);
            agt_wr.agt_ap_wr.connect(cov.cov_export_wr);
            agt_rd.agt_ap_rd.connect(sb.sb_export_rd);
            agt_rd.agt_ap_rd.connect(cov.cov_export_rd);
        endfunction
    endclass
endpackage