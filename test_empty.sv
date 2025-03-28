`include "base_test.sv"


`ifndef EMPTY_TEST
`define EMPTY_TEST

class empty_test extends base_test;
  
  task set_read_write;
    e.g.tr.wr.rand_mode(0);
    e.g.tr.rd.rand_mode(0);
    e.g.tr.wr = 0;
    e.g.tr.rd = 1;
  endtask
  
  task run(virtual fifo_ifc ifc);
    e = new(ifc,5);
    set_read_write;
    e.run;
  endtask
  
endclass


`endif