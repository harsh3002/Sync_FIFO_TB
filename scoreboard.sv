`include "transaction.sv"

`ifndef SCOREBOARD_SV
`define SCOREBOARD_SV

import transaction_pkg::*;


class scoreboard;
  
  transaction tr;
  transaction tr_gen;
  event sco_done;
  bit empty, full;	
  
  int err_count;
  
  bit [7:0] mem [$];
  bit [7:0] temp;
  
  mailbox #(transaction) mmbx;		//from monitor
  mailbox #(transaction) gmbx;		//from scoreboard
  
  function new(mailbox #(transaction) mmbx, gmbx, event sco_done);		//constructor method
    this.mmbx = mmbx;
    this.gmbx = gmbx;
    this.sco_done = sco_done;
  endfunction
  
  task write_op;		//write operation comparision
    if(mem.size >= 15)
      full = 1;
    else 
      full = 0;
      
    if({tr.full, full} == 2'b11)
        $display("[SCO] : FIFO FULL MATCHED");
    else if(tr.full ^ full)
      err_count++;
    
    if(mem.size() < 16) begin 
        mem.push_front(tr_gen.din);
        $display("[SCO] : DATA WRITTEN INTO THE MEM : %0d",tr.din);
    end
    $display(mem);
  endtask
  
  task read_op;		//read operation comparision
    if(mem.size <= 1)
	  empty = 1;
    else 
      empty = 0;
        
    if({tr.empty, empty} == 2'b11)
          $display("[SCO] : FIFO EMPTY MATCHED");
    else if(tr.empty ^ empty)
       err_count++;
    
    if(~empty | mem.size == 1) 
        temp = mem.pop_back();
    
    $display("[SCO] : DATA READ is %0d",temp);
        
    if(temp == tr.dout)
       $display("[SCO] : DATA MATCHED");
	else begin
       $display("[SCO] : DATA MISMATCHED");
      err_count++;
    end
  endtask
  
  
  task compare;		//compare the results 
    if(tr_gen.wr) 
      write_op;
    else if(tr_gen.rd)
      read_op;
  endtask
  
  
  task reset_mem;		//reset queue if applied
    mem = {};
    $display("[SCO] : FIFO RESET DONE");
  endtask
  
  
  task run();		//run the scoreboard 
    forever begin
      gmbx.get(tr_gen);
      mmbx.get(tr);
      if(tr_gen.rst)
        reset_mem;
      else
      	compare;
      ->sco_done;		//trigger the scoreboard event indicating next completion of transaction
      $display("----------------------------------------------------");
    end
  endtask
  
endclass

`endif