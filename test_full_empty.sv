`include "base_test.sv"

`ifndef TEST_FULL_EMPTY
`define TEST_FULL_EMPTY

class full_empty_test extends base_test;
  
  environment e;
  
  task set_read_write;
    e.g.tr.wr.rand_mode(0);
    e.g.tr.rd.rand_mode(0);
    repeat(17) begin
    	e.g.tr.wr = 1;
    	e.g.tr.rd = 0;
      @(e.sco_done);
    end
    repeat(17) begin
    	e.g.tr.wr = 0;
    	e.g.tr.rd = 1;
      @(e.sco_done);
    end
  endtask

  task run(virtual fifo_ifc ifc);
    e = new(ifc,35);
    fork
    set_read_write;
    e.run;
    join_none
  endtask
  
endclass

`endif