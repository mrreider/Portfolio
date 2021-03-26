/**
Writeback module
**/
module wb (clk, rst, memOut, aluOut, controlSignals, PCplusTwo, imm_8_sext, slbi, btr, Sinstr, regData, ror);
   
   //INPUTS
   input clk, rst;
   input [15:0]  memOut, aluOut, PCplusTwo, imm_8_sext, slbi, btr, Sinstr, ror;
   input [22:0] controlSignals;

   //OUTPUTS
   output[15:0] regData;

   //INTERMEDIATES
   wire [2:0] regDataSel;

   assign regDataSel = controlSignals[21:19];
   assign regWrite = controlSignals[22];
   assign regDst = controlSignals[18:17];

   //select register data
   assign regData = (regDataSel == 3'b000) ? memOut :
                    (regDataSel == 3'b001) ? aluOut :
                    (regDataSel == 3'b010) ? PCplusTwo :
                    (regDataSel == 3'b011) ? imm_8_sext :
                    (regDataSel == 3'b100) ? slbi :
                    (regDataSel == 3'b101) ? btr :
                    (regDataSel == 3'b110) ? Sinstr : ror;

   
   
endmodule
