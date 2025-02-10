package FIFO_read_driver_pkg;
    `include "uvm_macros.svh"
    import uvm_pkg::*;
    import shared_pkg::*;
    import FIFO_config_obj_pkg::*;
    import FIFO_read_sequence_item_pkg::*;

    class FIFO_read_driver extends uvm_driver #(FIFO_read_sequence_item);
        `uvm_component_utils(FIFO_read_driver)
        virtual FIFO_if read_driver_vif;
        FIFO_read_sequence_item stim_seq_item_rd;

        function new(string name = "FIFO_read_driver", uvm_component parent = null);
            super.new(name, parent);
        endfunction
        
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                stim_seq_item_rd = FIFO_read_sequence_item::type_id::create("stim_seq_item_rd");
                seq_item_port.get_next_item(stim_seq_item_rd);
                read_driver_vif.rst_n = stim_seq_item_rd.rst_n; 
                read_driver_vif.rd_en = stim_seq_item_rd.rd_en;  
                @(negedge read_driver_vif.clk);
                seq_item_port.item_done();
                `uvm_info("run_phase", stim_seq_item_rd.convert2string_stimulus(), UVM_HIGH)
            end
        endtask: run_phase
    endclass
endpackage