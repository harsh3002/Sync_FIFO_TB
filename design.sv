`include "intfc.sv"

module FIFO(fifo_ifc ifc);
  
  
  // Pointers for write and read operations
  reg [3:0] wptr = 0, rptr = 0;
  
  // Counter for tracking the number of elements in the FIFO
  reg [4:0] cnt = 0;
  
  // Memory array to store data
  reg [7:0] mem [15:0];
  
 
  always @(posedge ifc.clk)
    begin
      if (ifc.rst == 1'b1)
        begin
          // Reset the pointers and counter when the reset signal is asserted
          wptr <= 0;
          rptr <= 0;
          cnt  <= 0;
          mem[0] = 0;
          mem[1] = 0;
          mem[2] = 0;
          mem[3] = 0;
          mem[4] = 0;
          mem[5] = 0;
          mem[6] = 0;
          mem[7] = 0;
          mem[8] = 0;
          mem[9] = 0;
          mem[10] = 0;
          mem[11] = 0;
          mem[12] = 0;
          mem[13] = 0;
          mem[14] = 0;
          mem[15] = 0;
          
          
        end
      else begin 
        if (ifc.wr && !ifc.full)
        begin
          // Write data to the FIFO if it's not full
          mem[wptr] <= ifc.din;
          wptr      <= wptr + 1;
          cnt       <= cnt + 1;
        end
      else if (ifc.rd && !ifc.empty)
        begin
          // Read data from the FIFO if it's not empty
          ifc.dout <= mem[rptr];
          rptr <= rptr + 1;
          cnt  <= cnt - 1;
        end
      end
    end
 
  // Determine if the FIFO is empty or full
  assign ifc.empty = (cnt == 0 ) ? 1'b1 : 1'b0;
  assign ifc.full  = (cnt == 16) ? 1'b1 : 1'b0;
 
endmodule
 