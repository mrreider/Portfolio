/* $Author: karu $ */
/* $LastChangedDate: 2009-03-04 23:09:45 -0600 (Wed, 04 Mar 2009) $ */
/* $Rev: 45 $ */
module rf (
           // Outputs
           read1data, read2data, err,
           // Inputs
           clk, rst, read1regsel, read2regsel, writeregsel, writedata, write
           );
   input clk, rst;
   input [2:0] read1regsel;
   input [2:0] read2regsel;
   input [2:0] writeregsel;
   input [15:0] writedata;
   input        write;

   output [15:0] read1data;
   output [15:0] read2data;
   output        err;

   wire [15:0] reg_1_out, reg_2_out, reg_3_out, reg_4_out, reg_5_out, reg_6_out, reg_7_out, reg_8_out;

   reg_16 REG1(.write(write && !(|writeregsel)), .write_val(writedata), .out_val(reg_1_out), .rst(rst), .clk(clk));
   reg_16 REG2(.write(write && (!(|writeregsel[2:1]) && writeregsel[0]) ), .write_val(writedata), .out_val(reg_2_out), .rst(rst), .clk(clk));
   reg_16 REG3(.write(write && !writeregsel[2] && !writeregsel[0] && writeregsel[1]), .write_val(writedata), .out_val(reg_3_out), .rst(rst), .clk(clk));
   reg_16 REG4(.write(write && !writeregsel[2] && &writeregsel[1:0]), .write_val(writedata), .out_val(reg_4_out), .rst(rst), .clk(clk));
   reg_16 REG5(.write(write && writeregsel[2] && !(|writeregsel[1:0])), .write_val(writedata), .out_val(reg_5_out), .rst(rst), .clk(clk));
   reg_16 REG6(.write(write && writeregsel[2] && writeregsel[0] && !writeregsel[1]), .write_val(writedata), .out_val(reg_6_out), .rst(rst), .clk(clk));
   reg_16 REG7(.write(write && &writeregsel[2:1] && !writeregsel[0]), .write_val(writedata), .out_val(reg_7_out), .rst(rst), .clk(clk));
   reg_16 REG8(.write(write && &writeregsel[2:0]), .write_val(writedata), .out_val(reg_8_out), .rst(rst), .clk(clk));

   assign read1data = 
        read1regsel[2] ?
                read1regsel[1] ?
                        read1regsel[0] ?
                        reg_8_out : reg_7_out
                        :
                        read1regsel[0] ?
                        reg_6_out : reg_5_out
        :
                read1regsel[1] ?
                        read1regsel[0] ?
                        reg_4_out : reg_3_out
                        :
                        read1regsel[0] ?
                        reg_2_out : reg_1_out;
   assign read2data = 
        read2regsel[2] ?
                read2regsel[1] ?
                        read2regsel[0] ?
                        reg_8_out : reg_7_out
                        :
                        read2regsel[0] ?
                        reg_6_out : reg_5_out
        :
                read2regsel[1] ?
                        read2regsel[0] ?
                        reg_4_out : reg_3_out
                        :
                        read2regsel[0] ?
                        reg_2_out : reg_1_out;

endmodule
// DUMMY LINE FOR REV CONTROL :1:
