package FIFO_config_obj_pkg;
    `include "uvm_macros.svh"
    import uvm_pkg::*;

    class FIFO_config_obj extends uvm_object;
        `uvm_object_utils(FIFO_config_obj)
        virtual FIFO_if fifo_config_vif;

        function new(string name = "FIFO_config_obj");
            super.new(name);
        endfunction  
    endclass
endpackage