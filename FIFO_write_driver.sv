package FIFO_write_driver_pkg;
    `include "uvm_macros.svh"
    import uvm_pkg::*;
    import shared_pkg::*;
    import FIFO_config_obj_pkg::*;
    import FIFO_write_sequence_item_pkg::*;

    class FIFO_write_driver extends uvm_driver #(FIFO_write_sequence_item);
        `uvm_component_utils(FIFO_write_driver)
        virtual FIFO_if write_driver_vif;
        FIFO_write_sequence_item stim_seq_item_wr;

        function new(string name = "FIFO_write_driver", uvm_component parent = null);
            super.new(name, parent);
        endfunction
        
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                stim_seq_item_wr = FIFO_write_sequence_item::type_id::create("stim_seq_item_wr");
                seq_item_port.get_next_item(stim_seq_item_wr);
                write_driver_vif.rst_n = stim_seq_item_wr.rst_n; 
                write_driver_vif.wr_en = stim_seq_item_wr.wr_en; 
                write_driver_vif.data_in = stim_seq_item_wr.data_in; 
                @(negedge write_driver_vif.clk);
                seq_item_port.item_done();
                `uvm_info("run_phase", stim_seq_item_wr.convert2string_stimulus(), UVM_HIGH)
            end
        endtask: run_phase
    endclass
endpackage