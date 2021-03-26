/* $Author: karu $ */
/* $LastChangedDate: 2009-03-04 23:09:45 -0600 (Wed, 04 Mar 2009) $ */
/* $Rev: 45 $ */
module proc (/*AUTOARG*/
   // Outputs
   err, 
   // Inputs
   clk, rst
   );

   input clk;
   input rst;

   output err;

   //INTERNAL SIGNALS
   wire[15:0] nextPC, instruction, PCplusTwo, regDataWrite, data1, data2, imm_5_sext, imm_5_zext, imm_8_sext, imm_8_zext, 
   imm_11_sext, aluOut, slbiOut, SinstrOut, btrOut, memDataIn, memOut, rorOut;
   wire[2:0] regDst;
   wire[22:0] controlSignals;
   wire createDump, regWrite, halt;

   //DUT INSTANTIATIONS
   fetch fetch0(.nextPC(nextPC), .en(~halt), .clk(clk), .rst(rst),
           .PCplusTwo(PCplusTwo), .instruction(instruction), .createDump(createDump));

   decode decode0(.instruction(instruction), .clk(clk), .rst(rst), .regDataWrite(regDataWrite),
            .data1(data1), .data2(data2), .imm_5_sext(imm_5_sext), .imm_5_zext(imm_5_zext), .imm_8_sext(imm_8_sext), .imm_8_zext(imm_8_zext), .imm_11_sext(imm_11_sext), .controlSignals(controlSignals), .err(err), .createDump(createDump), .halt(halt));
   
   execute execute0(.instruction(instruction), .PCplusTwo(PCplusTwo), .rsData(data1), .rtData(data2), .imm_5_sext(imm_5_sext), .imm_5_zext(imm_5_zext), .imm_8_sext(imm_8_sext), .imm_8_zext(imm_8_zext), .imm_11_sext(imm_11_sext), .controlSignals(controlSignals), .clk(clk), .rst(rst),
             .nextPC(nextPC), .aluOut(aluOut), .slbiOut(slbiOut), .SinstrOut(SinstrOut), .btrOut(btrOut), .memDataIn(memDataIn), .rorOut(rorOut));

   memory memory0(.instruction(instruction), .aluOut(aluOut), .controlSignals(controlSignals), .memDataIn(memDataIn), .clk(clk), .rst(rst),
            .memOut(memOut), .halt(halt), .createDump(createDump));

   wb w(.clk(clk), .rst(rst), .memOut(memOut), .aluOut(aluOut), .controlSignals(controlSignals), .PCplusTwo(PCplusTwo), .imm_8_sext(imm_8_sext), .slbi(slbiOut), .btr(btrOut), .Sinstr(SinstrOut), .ror(rorOut),
        .regData(regDataWrite));

endmodule // proc
// DUMMY LINE FOR REV CONTROL
