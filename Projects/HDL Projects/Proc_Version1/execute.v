/**
Executes arithmetic and shifting operations from instruction
**/
module execute (instruction, PCplusTwo, rsData, rtData, imm_5_sext, imm_5_zext, imm_8_sext, imm_8_zext, imm_11_sext, controlSignals, nextPC, aluOut, slbiOut, SinstrOut, btrOut, rorOut, memDataIn, clk, rst);

   //INPUTS
   input [15:0] instruction, PCplusTwo, rsData, rtData, imm_5_sext, imm_5_zext, imm_8_sext, imm_8_zext, imm_11_sext;
   input [22:0] controlSignals;
   input clk, rst;

   //OUTPUTS
   output[15:0] aluOut, nextPC, slbiOut, SinstrOut, btrOut, memDataIn, rorOut;
   
   //ASSIGN FOR EASE OF ACCESS
   wire branch = controlSignals[10];
   wire jump = controlSignals[11];
   wire C_in = controlSignals[6];
   wire invA = controlSignals[7];
   wire invB = controlSignals[8];
   wire sign = controlSignals[9];
   wire exception = controlSignals[12];
   wire rti = controlSignals[13];
   wire [2:0] aluOp = controlSignals[2:0];
   wire [2:0] aluSrc = controlSignals[5:3];

   wire [15:0] PCAddA, PCAddB, target, inputB;

   wire branchCond, nextPCSel, zero, ofl, C_out;

   //figure out what input b is based on alusrc
   assign inputB = (aluSrc == 3'h0) ? rtData :
                   (aluSrc == 3'h1) ? imm_5_sext :
                   (aluSrc == 3'h2) ? imm_5_zext :
                   (aluSrc == 3'h3) ? imm_8_sext :
                   (aluSrc == 3'h4) ? imm_8_zext :
                   (aluSrc == 3'h5) ? imm_11_sext :
                   (aluSrc == 3'h6) ? 16'b0 : 16'b0;

   //ALU INSTANTIATION
   alu ALU(.InA(rsData), .InB(inputB), .Cin(C_in), .Op(aluOp), .invA(invA), .invB(invB), .sign(sign), .Out(aluOut), .Zero(zero), .Ofl(ofl), .C_out(C_out));

   assign slbiOut = (rsData << 8) | imm_8_zext;
   
   assign PCAddA = jump & instruction[11] ? rsData : PCplusTwo;
   assign PCAddB = jump & ~instruction[11] ? imm_11_sext : imm_8_sext;
   
   //ADDER FOR PC
   cla_16 PCADDER(.A(PCAddA), .B(PCAddB), .Sum(target), .Cin(1'b0), .Cout());

   assign branchCond = (instruction[12:11] == 2'h0) ? zero :
                       (instruction[12:11] == 2'h1) ? ~zero :
                       (instruction[12:11] == 2'h2) ? ~aluOut[15] & ~zero : aluOut[15] | zero;

   assign nextPCSel = (branchCond & branch) | jump;

   assign nextPC = nextPCSel ? target : PCplusTwo;

   assign SinstrOut = (instruction[12:11] == 2'h0) ? zero :
                      (instruction[12:11] == 2'h1) ? (aluOut[15] & ~ofl) | (rsData[15] & ~inputB[15]) :
                      (instruction[12:11] == 2'h2) ? ((aluOut[15] & ~ofl) | (rsData[15] & ~inputB[15]) | zero) : C_out;

   //BTR LOGIC
   assign btrOut = {rsData[0], rsData[1], rsData[2], rsData[3], rsData[4], rsData[5], rsData[6], 
                    rsData[7], rsData[8], rsData[9], rsData[10], rsData[11], rsData[12], rsData[13], 
                    rsData[14], rsData[15]};

   //ROTATE LOGIC
   assign rorOut = inputB[3:0] == 4'h0 ? rsData :
                   inputB[3:0] == 4'h1 ? {rsData[0], rsData[15:1]} :
                   inputB[3:0] == 4'h2 ? {rsData[1:0], rsData[15:2]} :
                   inputB[3:0] == 4'h3 ? {rsData[2:0], rsData[15:3]} :
                   inputB[3:0] == 4'h4 ? {rsData[3:0], rsData[15:4]} :
                   inputB[3:0] == 4'h5 ? {rsData[4:0], rsData[15:5]} :
                   inputB[3:0] == 4'h6 ? {rsData[5:0], rsData[15:6]} :
                   inputB[3:0] == 4'h7 ? {rsData[6:0], rsData[15:7]} :
                   inputB[3:0] == 4'h8 ? {rsData[7:0], rsData[15:8]} :
                   inputB[3:0] == 4'h9 ? {rsData[8:0], rsData[15:9]} :
                   inputB[3:0] == 4'hA ? {rsData[9:0], rsData[15:10]} :
                   inputB[3:0] == 4'hB ? {rsData[10:0], rsData[15:11]} :
                   inputB[3:0] == 4'hC ? {rsData[11:0], rsData[15:12]} :
                   inputB[3:0] == 4'hD ? {rsData[12:0], rsData[15:13]} :
                   inputB[3:0] == 4'hE ? {rsData[13:0], rsData[15:14]} : {rsData[14:0], rsData[15]};

   assign memDataIn = rtData;
   
endmodule
