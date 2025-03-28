`include "base_test.sv"

`ifndef TEST_RESET
`define TEST_RESET

class reset_test extends base_test;
  
  environment e;
  
  task set_read_write;
    e.g.tr.wr.rand_mode(0);
    e.g.tr.rd.rand_mode(0);
    e.g.tr.rst.rand_mode(0);

    repeat(5) begin
      e.g.tr.wr = 1;
      e.g.tr.rd = 0;
      @(e.sco_done);
    end
    e.g.tr.rst = 1;
    @(e.sco_done);
    e.g.tr.rst = 0;
    e.g.tr.wr = 0;
    e.g.tr.rd = 1;
    @(e.sco_done);
    repeat(17) begin
    	e.g.tr.wr = 1;
    	e.g.tr.rd = 0;
      @(e.sco_done);
    end
  endtask

  task run(virtual fifo_ifc ifc);
    e = new(ifc,25);
    fork
    set_read_write;
    e.run;
    join_none
  endtask
  
endclass

`endif