`include "base_test.sv"


`ifndef FULL_TEST
`define FULL_TEST

class full_test extends base_test;
  
  task set_read_write;
    e.g.tr.wr.rand_mode(0);
    e.g.tr.rd.rand_mode(0);
    e.g.tr.wr = 1;
    e.g.tr.rd = 0;
  endtask
  
  task run(virtual fifo_ifc ifc);
    e = new(ifc,17);
    set_read_write;
    e.run;
  endtask
  
endclass


`endif