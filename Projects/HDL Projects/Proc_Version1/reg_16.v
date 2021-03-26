/**
  This module represents a 16 bit register file
**/
module reg_16 (out_val,clk, rst, write_val, write);

   input        clk, rst;
   input[15:0]  write_val;
   input        write;

   output [15:0] out_val;

   wire[15:0] d_in;

   assign d_in = write ? write_val : out_val;
   
   dff dff1 [15:0] (.q(out_val), .d(d_in), .clk(clk), .rst(rst));

endmodule
