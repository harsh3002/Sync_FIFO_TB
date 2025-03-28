`include "base_test.sv"
`include "test_full.sv"
`include "test_empty.sv"
`include "test_full_empty.sv"
`include "test_reset.sv"
`include "test_read_write_altrnt.sv"

module tb;
  
  base_test t_base;
  full_test t_full;
  empty_test t_empty;
  full_empty_test t_full_empty;
  reset_test t_reset;
  r_wr_altrnt_test t_altrnt;
  fifo_ifc ifc();
  
  FIFO dut(.ifc(ifc));
  
  initial begin
    ifc.clk = 0;
  end
  
  always #5 ifc.clk = ~ifc.clk;
  
  initial begin
    
    t_full_empty = new;
    t_full_empty.run(ifc);
    
//     t_base = new;
//     t_base.run(ifc);
    
//     t_full = new;
//     t_full.run(ifc);
    
//     t_empty = new;
//     t_empty.run(ifc);
    
//     t_reset = new;
//     t_reset.run(ifc);
    
//     t_altrnt = new;
//     t_altrnt.run(ifc);
    
  end
  
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars;
  end
  
endmodule
