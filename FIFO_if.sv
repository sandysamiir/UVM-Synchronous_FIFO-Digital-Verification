import shared_pkg::*;
interface FIFO_if (clk);
    input clk;
    logic rst_n, wr_en, rd_en, wr_ack, overflow, full, empty, almostfull, almostempty, underflow;
    logic [FIFO_WIDTH-1:0] data_in, data_out;
endinterface