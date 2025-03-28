`include "transaction.sv"

`ifndef GENERATOR_SV
`define GENERATOR_SV

import transaction_pkg::*;

class generator;
  
  transaction tr;
  event gen_done,sco_done;  //Synchronisation of generated values
  int count;				// Count the number of times value generated
  
  mailbox #(transaction) mbx; 	//Mailbox to driver
  mailbox #(transaction) smbx;	//Mailbox to scoreboard (NOT MANDATORY)
  
  function new(event sco_done, mailbox #(transaction) mbx, smbx , int count);  	//Constructor method definition
    tr=new;
    this.gen_done = gen_done;
    this.mbx = mbx;
    this.smbx = smbx;
    this.count = count;
    this.sco_done = sco_done;
  endfunction
  
  task run;
    repeat(count) begin		//Execute specified number of times
      assert(tr.randomize);		//Randomize according to constraints
      $display("[GEN] : RESET=%0d  WRITE_EN=%0d  RD_ENA=%0d  DATA_IN=%0d",tr.rst,tr.wr,tr.rd,tr.din);
      mbx.put(tr.copy);		// Send to driver
      smbx.put(tr.copy);	// Send to scoreboard
      @(sco_done);		//wait for scoreboard event to generate next stimulus
    end
    -> gen_done;		//Indicate stimulus generation complete
  endtask
  
endclass

`endif