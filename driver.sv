`include "transaction.sv"
`include "intfc.sv"


`ifndef DRIVER_SV
`define DRIVER_SV

import transaction_pkg::*;

class driver ;
  
  transaction tr;
  virtual fifo_ifc ifc;		//Apply atimulus to DUT
  
  mailbox #(transaction) mbx;	//From generator
  
  function new(mailbox #(transaction) mbx, virtual fifo_ifc ifc);		//contructor method
    this.mbx = mbx;
    this.ifc = ifc;
  endfunction
  
  task pre_reset;  		//Apply initial stimulus to move design into reset mode
    @(ifc.drv_cb);
    ifc.drv_cb.rst <= 1'b1;
    ifc.drv_cb.wr <= 1'b0;
    ifc.drv_cb.rd <= 1'b0;
    $display("[DRV] : APPLYING INITIAL RESET");
    repeat (2)@(ifc.drv_cb);
    ifc.drv_cb.rst <= 1'b0;
    $display("[DRV] : RESET DONE");
    $display("-----------------------------------------------------------------");
    @(ifc.drv_cb);
  endtask
  
  
  task write();			//Write stimulus driving task
    ifc.drv_cb.din <= tr.din;
    @(ifc.drv_cb);
    ifc.drv_cb.wr <= tr.wr;
    ifc.drv_cb.rd <= tr.rd;
    
    @(ifc.drv_cb);
    ifc.drv_cb.wr <= 1'b0;    
  endtask
  
  task read();			//Read stimulus driving task
    @(ifc.drv_cb);
    ifc.drv_cb.rd <= tr.rd;
    ifc.drv_cb.wr <= tr.wr;
    @(ifc.drv_cb);
    ifc.drv_cb.rd <= 1'b0;
  endtask
  
  task reset();			// Apply generated reset stimulus
    $display("[DRV] : RESET APPLYING TO DUT");
        @(ifc.drv_cb);
        ifc.drv_cb.rst <= tr.rst;
        ifc.drv_cb.wr <= 1'b0;
        ifc.drv_cb.rd <= 1'b0;
        @(ifc.drv_cb);
        ifc.drv_cb.rst <= 1'b0;
  endtask
  
  task run;			//Apply generated stimulus to DUT
    forever begin
      mbx.get(tr);
      $display("[DRV] : DATA RECEIVED FROM MAILBOX");
      $display("[DRV] : RESET=%0d  WRITE_EN=%0d  RD_ENA=%0d  DATA_IN=%0d",tr.rst,tr.wr,tr.rd,tr.din);
      if(tr.rst) 
        reset;
        else begin
      if(tr.rd)
        read;
      else if(tr.wr)
        write;
        end
      $display("[DRV] : APPLIED DATA TO DUT");
    end
  endtask
  
endclass

`endif
  
  