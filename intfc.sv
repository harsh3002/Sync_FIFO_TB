`ifndef INTERFACE_SV
`define INTERFACE_SV

interface fifo_ifc;
      
      logic clk, rst;
      logic wr, rd;
      logic [7:0]din, dout;
	  logic empty, full;
      
      modport fifo_design( input clk,
                          	input rst,
                         	input wr,
                          	input rd,
                         	input din,
                         	output dout,
                         	output empty,
                         	output full);
      
 	 clocking drv_cb @(negedge clk);
        	output #2 rst,wr,rd,din;
      endclocking
      
      clocking mon_cb @(posedge clk);
        	input  dout, empty, full;
      endclocking
  
  
  property wr_rd_excl;
    @(posedge clk) disable iff(rst) !(wr && rd) ;
  endproperty
  
  assert property (wr_rd_excl)
    else $info("At time %0t property rd_wr_excl failed",$time);
  
    endinterface

`endif