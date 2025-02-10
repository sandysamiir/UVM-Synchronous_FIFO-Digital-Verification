`include "uvm_macros.svh"
import uvm_pkg::*;
import FIFO_test_pkg::*;

module FIFO_top();
    bit clk;

    initial begin
        forever 
         #1 clk = ~clk;
    end
    
    FIFO_if fifoif (clk);
    FIFO dut (
        clk,
        fifoif.rst_n, 
        fifoif.wr_en, 
        fifoif.rd_en, 
        fifoif.wr_ack, 
        fifoif.overflow, 
        fifoif.full, 
        fifoif.empty, 
        fifoif.almostfull, 
        fifoif.almostempty, 
        fifoif.underflow, 
        fifoif.data_in, 
        fifoif.data_out
    );
    bind FIFO FIFO_SVA fifo_sva_inst (
        clk,
        fifoif.rst_n, 
        fifoif.wr_en, 
        fifoif.rd_en, 
        fifoif.wr_ack, 
        fifoif.overflow, 
        fifoif.full, 
        fifoif.empty, 
        fifoif.almostfull, 
        fifoif.almostempty, 
        fifoif.underflow, 
        fifoif.data_in, 
        fifoif.data_out
    );

    initial begin
        uvm_config_db#(virtual FIFO_if)::set(null, "uvm_test_top", "FIFO_IF", fifoif);
        run_test("FIFO_test");
    end
endmodule