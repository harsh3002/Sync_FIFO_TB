`include "base_test.sv"

`ifndef TEST_READ_WRITE_ALTERNATE
`define TEST_READ_WRITE_ALTERNATE

class r_wr_altrnt_test extends base_test;
  
  environment e;
  
  task set_read_write;
    e.g.tr.wr.rand_mode(0);
    e.g.tr.rd.rand_mode(0);
	
    repeat(3) begin
      repeat(5) begin
        e.g.tr.wr = 1;
        e.g.tr.rd = 0;
        @(e.sco_done);
      end
      repeat(6) begin
          e.g.tr.wr = 0;
          e.g.tr.rd = 1;
        @(e.sco_done);
      end
    end
  endtask

  task run(virtual fifo_ifc ifc);
    e = new(ifc,34);
    fork
    set_read_write;
    e.run;
    join_none
  endtask
  
endclass

`endif