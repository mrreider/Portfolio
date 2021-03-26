/**
Instruction decoder. Assigns signals for execute, memory, and writeback.
**/
module decode (regDataWrite, instruction, clk, rst, data1, data2, imm_5_sext, imm_5_zext, imm_8_sext, imm_8_zext, imm_11_sext
, controlSignals, err, halt, createDump);

   //INPUTS
   input [15:0] instruction, regDataWrite;
   input clk, rst;

   //OUTPUTS
   output [15:0] data1, data2, imm_5_sext, imm_5_zext, imm_8_sext, imm_8_zext, imm_11_sext;
   output [22:0] controlSignals;
   output err, halt, createDump;

   //INTERMEDIATES
   wire branch, jump, C_in, invA, invB, sign, exception, rti, memEn, memWr, regWrite;
   wire [2:0] aluOp, aluSrc, regDataSel;
   wire [1:0] regDst;   

   //Using control_logic assigns necessary signals controlSignals wire to be accessed by
   //the entire processor.
   assign controlSignals[2:0] = aluOp;
   assign controlSignals[5:3] = aluSrc;
   assign controlSignals[6] = C_in;
   assign controlSignals[7] = invA;
   assign controlSignals[8] = invB;
   assign controlSignals[9] = sign;
   assign controlSignals[10] = branch;
   assign controlSignals[11] = jump;
   assign controlSignals[12] = exception;
   assign controlSignals[13] = rti;

   assign controlSignals[14] = memEn;
   assign controlSignals[15] = memWr;
   assign controlSignals[16] = halt;

   assign controlSignals[18:17] = regDst;
   assign controlSignals[21:19] = regDataSel;
   assign controlSignals[22] = regWrite;

   wire[4:0] opCode = instruction[15:11];
   wire[1:0] opExt = instruction[1:0];

   wire[2:0] rs = instruction[10:8];
   wire[2:0] rt = instruction[7:5];
   wire[2:0] rd = instruction[4:2];

   wire[4:0] imm_5 = instruction[4:0];
   wire[7:0] imm_8 = instruction[7:0];
   wire[10:0]imm_11 = instruction[10:0];

   assign imm_5_sext = imm_5[4] ? {11'b11111111111, imm_5} : {11'b00000000000, imm_5};
   assign imm_5_zext = {11'b00000000000, imm_5};
   assign imm_8_sext = imm_8[7] ? {8'b11111111, imm_8} : {8'b00000000, imm_8};
   assign imm_8_zext = {8'b00000000, imm_8};
   assign imm_11_sext = imm_11[10] ? {5'b11111, imm_11} : {5'b00000, imm_11};

   wire [2:0] regToWrite = regDst == 2'h0 ? rd :
                           regDst == 2'h1 ? rt :
                           regDst == 2'h2 ? rs : 3'h7;


   //MASTER CONTROL
   control_logic cl(.opCode(opCode), .opExt(opExt), .branch(branch), .jump(jump), .aluOp(aluOp), .aluSrc(aluSrc),  .C_in(C_in), .invA(invA), .invB(invB),
    .sign(sign), .exception(exception), .rti(rti), .memEn(memEn), .memWr(memWr), .halt(halt), .createDump(createDump),.regDst(regDst), .regDataSel(regDataSel), .regWrite(regWrite));

   //REGISTER FILE   
   rf regFile0(.read1data(data1), .read2data(data2), .err(err), .clk(clk), .rst(rst), .read1regsel(rs), .read2regsel(rt), .writeregsel(regToWrite), .writedata(regDataWrite), .write(regWrite));

   
endmodule
