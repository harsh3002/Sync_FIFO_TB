`include "transaction.sv"
`include "intfc.sv"

`ifndef MONITOR_SV
`define MONITOR_SV

import transaction_pkg::*;

class monitor;
  
  transaction tr;
  virtual fifo_ifc ifc;
  
  mailbox #(transaction) mbx;  		//To scoreboard
  
  function new(mailbox #(transaction) mbx, virtual fifo_ifc ifc);		//Constructor method
    this.mbx = mbx;
    this.ifc = ifc;
    fifo_cover=new;
  endfunction
  
  
  task run;			//Sample the result from DUT and send to scoreboard     //Coverage sampling included
    tr = new;
    forever begin
      repeat(2) @( ifc.mon_cb);
      fifo_cover.sample();			//sample coverage 
      
      if(ifc.rst)begin
        $display("[MON] : RESET APPLIED TO THE DESIGN SUCCESSFULL");
        tr.rst = ifc.rst;
        mbx.put(tr);
      end
      else begin
      if(ifc.rd) begin
        tr.dout = ifc.dout;
        tr.empty = ifc.empty;
        tr.full = ifc.full;
        tr.rd = ifc.rd;
        $display("[MON] : dout : %0d",ifc.dout);
        $display("[MON] : READ OPERATION");
        mbx.put(tr);
      end
      else if(ifc.wr) begin
        $display("[MON] : WRITE OPERATION");
        $display("[MON] : din : %0d",ifc.din);
        tr.empty = ifc.empty;
        tr.full = ifc.full;
        mbx.put(tr);
      end
      end
    end
  endtask
  
  covergroup fifo_cover;			// Defining the cover group
    
    option.per_instance = 1;
    
    wr_bin : coverpoint ifc.wr iff(~ifc.rst);
    rd_bin : coverpoint ifc.rd iff(~ifc.rst);
    
    data_in_bin : coverpoint ifc.din iff(~ifc.rst && ifc.wr){
      bins legal_din_bin = {0,85,170,255};
      illegal_bins dc_din_bin = default;
    }
    
    data_out_bin : coverpoint ifc.dout iff(~ifc.rst && ifc.rd){
      bins legal_dout_bin = {0,85,170,255};
      illegal_bins dc_dout_bin = default;
    }
    
    empty_bin : coverpoint ifc.empty iff(~ifc.rst);
    full_bin : coverpoint ifc.full iff(~ifc.rst);
    
  endgroup
  
endclass

`endif