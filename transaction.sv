`ifndef TRANSACTION_SV
`define TRANSACTION_SV

package transaction_pkg;

 class transaction;
  
  //Input signals
  rand bit rst;
  rand bit wr, rd;
  randc bit [7:0] din;
  
  //Output signals
  bit [7:0] dout;
  bit empty, full;
  
  //Constraint declaration
  constraint c_rst { soft rst dist {1:= 3 , 0:= 97}; }  // Reset constraint
  
  constraint c_din { soft din inside {8'h0, 8'haa, 8'h55, 8'hff}; } // Data constraint
  
  constraint c_wr_rd_exclusive { soft (wr ^ rd) ; }  // Read- write mutually exclusive
  
//    constraint c_wr { wr dist {1:=70 , 0:=30}; } 
//   constraint c_rd { rd dist {1:=70 , 0:=30}; }
  
	 function transaction copy;    // Deep copy object
    	copy=new;
    	copy.rst = this.rst;
    	copy.wr = this.wr;
    	copy.rd = this.rd;
    	copy.din = this.din;
    	copy.dout = this.dout;
    	copy.empty = this.empty;
    	copy.full = this.full;
    
  endfunction
  
endclass

endpackage

`endif