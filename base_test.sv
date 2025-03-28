`include "environment.sv"
`include "intfc.sv"

`ifndef TEST1
`define TEST1

class base_test;
  
  environment e;

  task run(virtual fifo_ifc ifc);
    e = new(ifc,20);
    e.run;
  endtask
  
endclass


`endif