import shared_pkg::*;
module FIFO_SVA(clk, rst_n, wr_en, rd_en, wr_ack, overflow, full, empty, almostfull, almostempty, underflow, data_in, data_out);
    input logic clk, rst_n, wr_en, rd_en, wr_ack, overflow, full, empty, almostfull, almostempty, underflow;
    input logic [FIFO_WIDTH-1:0] data_in, data_out;

    always_comb begin 
        if(!rst_n) begin
        a_reset: assert final(!FIFO_top.dut.wr_ptr && !FIFO_top.dut.rd_ptr && !FIFO_top.dut.count && !wr_ack && !overflow && !underflow) 
                        else $error("reset assertion failed"); 
        c_reset: cover final(!FIFO_top.dut.wr_ptr && !FIFO_top.dut.rd_ptr && !FIFO_top.dut.count && !wr_ack && !overflow && !underflow); 
        end
        if(FIFO_top.dut.count == FIFO_DEPTH) begin
        a_full: assert (full) 
                        else $error("full assertion failed"); 
        c_full: cover (full); 
        end
        if(FIFO_top.dut.count == 0) begin
        a_empty: assert (empty) 
                        else $error("empty assertion failed"); 
        c_empty: cover (empty); 
        end
        if(FIFO_top.dut.count == FIFO_DEPTH-1) begin
        a_almostfull: assert (almostfull) 
                        else $error("almostfull assertion failed"); 
        c_almostfull: cover (almostfull); 
        end
        if(FIFO_top.dut.count == 1) begin
        a_almostempty: assert (almostempty) 
                        else $error("almostempty assertion failed"); 
        c_almostempty: cover (almostempty); 
        end        
    end 

    property a_wr_ack;
        @(posedge clk) disable iff(!rst_n) (wr_en && !full) |=> wr_ack
    endproperty
    assert property (a_wr_ack) else $error("wr_ack assertion failed");
    cover property (a_wr_ack);

    property a_overflow;
        @(posedge clk) disable iff(!rst_n) (wr_en && full) |=> overflow
    endproperty
    assert property (a_overflow) else $error("overflow Assertion failed");
    cover property (a_overflow);

    property a_underflow;
        @(posedge clk) disable iff(!rst_n) (rd_en && empty) |=> underflow
    endproperty
    assert property (a_underflow) else $error("underflow Assertion failed");
    cover property (a_underflow);

    // Corner Case Assertions
    // 1. Prevent Write Acknowledge on Full
    property wr_ack_not_on_full;
        @(posedge clk) disable iff(!rst_n) full |=> !wr_ack;
    endproperty
    assert property (wr_ack_not_on_full) else $error("write acknowledge on full assertion failed");
    cover property (wr_ack_not_on_full);

    // 2. No Write Acknowledge or Overflow when Write Enable is Deasserted
    property no_wr_en;
        @(posedge clk) disable iff(!rst_n) (!wr_en) |=> (!wr_ack && !overflow);
    endproperty
    assert property (no_wr_en) else $error("Write acknowledge or overflow on wr_en deassertion failed");
    cover property (no_wr_en);

    // 3. No Underflow when Read Enable is Deasserted
    property no_rd_en;
        @(posedge clk) disable iff(!rst_n) (!rd_en) |=> (!underflow);
    endproperty
    assert property (no_rd_en) else $error("Underflow on rd_en deassertion failed");
    cover property (no_rd_en);

    // 4. Prevent Full Assertion on Read Enable
    property no_full_on_rd_en;
        @(posedge clk) disable iff(!rst_n) (rd_en) |=> (!full);
    endproperty
    assert property (no_full_on_rd_en) else $error("Full on rd_en assertion failed");
    cover property (no_full_on_rd_en);

       
endmodule