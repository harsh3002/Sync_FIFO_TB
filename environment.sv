`include "include_pkg.sv"

`ifndef ENV_SV
`define ENV_SV

class environment;
  
  generator g;
  driver d;
  monitor m;
  scoreboard s;
  
  event sco_done;
  
  mailbox #(transaction) gd_mbx;
  mailbox #(transaction) ms_mbx;
  mailbox #(transaction) gs_mbx;
  
  function new(virtual fifo_ifc ifc, int count);	//constructor method
    gd_mbx = new(1);
    ms_mbx = new(1);
    gs_mbx = new(1);
    
    g = new(sco_done, gd_mbx, gs_mbx, count);		//construc	generator
    d = new(gd_mbx, ifc);					//construct driver
    m = new(ms_mbx, ifc);					//construct monitor
    s = new(ms_mbx, gs_mbx, sco_done);				//construct scoreboard
    
  endfunction
  
  task pre_test();	//Apply initial reset
    d.pre_reset;
  endtask
  
  task test();		//Run the testcase
    fork
      g.run;
      d.run;
      m.run;
      s.run;
    join_none
  endtask
  
  task post_test;	//display error count and functional coverage
    wait(g.gen_done.triggered);
    if(s.err_count == 0) begin
      $display("[SCO] : NO DATA MISMATCHES");	
      $display("[SCO] : TEST CASE SUCCESSFUL");
    end
    else begin
      $display("[SCO] : DATA MISMATCHES CAUGHT");	
      $display("[SCO] : NUMBER OF MISMATCHES : %0d",s.err_count);
    end
    
    $display("[ENV] : Coverage percentage %0f",m.fifo_cover.get_coverage());
    $finish;
  endtask
  
  task run;			//run the environment
    pre_test;
    test;
    post_test;
  endtask
  
endclass

`endif

