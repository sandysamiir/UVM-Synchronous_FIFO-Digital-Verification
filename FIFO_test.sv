package FIFO_test_pkg;
    `include "uvm_macros.svh"
    import uvm_pkg::*;
    import FIFO_config_obj_pkg::*;
    import FIFO_env_pkg::*;
    import FIFO_sequence_pkg::*;

    class FIFO_test extends uvm_test;
        `uvm_component_utils(FIFO_test)
        FIFO_config_obj FIFO_config_obj_test;
        FIFO_env env;
        write_sequence wr_seq;
        read_sequence rd_seq;

        function new(string name = "FIFO_test", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            env = FIFO_env::type_id::create("env", this);
            FIFO_config_obj_test = FIFO_config_obj::type_id::create("FIFO_config_obj_test");
            wr_seq = write_sequence::type_id::create("wr_seq", this);
            rd_seq = read_sequence::type_id::create("rd_seq", this);
            // Retrieve the virtual interface from the configuration database
            if (!uvm_config_db #(virtual FIFO_if)::get(this, "", "FIFO_IF", FIFO_config_obj_test.fifo_config_vif))
                `uvm_fatal("build_phase", "Test - Unable to get the virtual interface of the FIFO from the uvm_config_db");
            // Set the virtual interface for other components    
            uvm_config_db#(FIFO_config_obj)::set(this, "*", "fifo_vif", FIFO_config_obj_test);    
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this);
            fork
                // Write sequence
                begin
                    `uvm_info("run_phase", "Write stimulus started", UVM_LOW)
                    wr_seq.start(env.agt_wr.sqr_wr);
                    `uvm_info("run_phase", "Write stimulus finished", UVM_LOW)
                end
                // Read sequence
                begin
                    `uvm_info("run_phase", "Read stimulus started", UVM_LOW)
                    rd_seq.start(env.agt_rd.sqr_rd);
                    `uvm_info("run_phase", "Read stimulus finished", UVM_LOW)
                end
            join
            phase.drop_objection(this);
        endtask
    endclass   
endpackage 