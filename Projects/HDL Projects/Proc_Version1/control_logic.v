/**
Master Control of processor. Handles all signals depending on instruction.
**/
module control_logic (opCode, opExt, branch, jump, aluOp, aluSrc,  C_in, invA, invB, sign, memEn, memWr, halt, regDst, regDataSel, regWrite, exception, rti, createDump);

   //INPUTS
   input [4:0] opCode;
   input [1:0] opExt;

   //OUTPUTS ALL REGISTERS
   output reg branch, jump, C_in, invA, invB, sign, exception, rti;
   output reg [2:0] aluOp;
   output reg [2:0] aluSrc;

   output reg memEn, memWr, halt;
   output reg createDump;

   output reg [1:0] regDst;
   output reg [2:0] regDataSel;
   output reg regWrite;

   //LOCALPARAM DEFINES
   localparam rd = 2'h0;
   localparam rt = 2'h1;
   localparam rs = 2'h2;
   localparam r7 = 2'h3;
   
   localparam memOut = 3'h0;
   localparam aluOut = 3'h1;
   localparam PCplusTwo = 3'h2;
   localparam imm_8 = 3'h3;
   localparam slbi = 3'h4;
   localparam btr = 3'h5;
   localparam Sinstr = 3'h6;
   localparam ror = 3'h7;

   localparam reg2Data = 3'h0;
   localparam imm_5_sext = 3'h1;
   localparam imm_5_zext = 3'h2;
   localparam imm_8_sext = 3'h3;
   localparam imm_8_zext = 3'h4;
   localparam imm_11_sext = 3'h5;
   localparam zero = 3'h6;

   localparam rll = 3'h0;
   localparam sll = 3'h1;
   localparam sra = 3'h2;
   localparam srl = 3'h3;
   localparam ADD = 3'h4;
   localparam AND =  3'h5;
   localparam OR = 3'h6;
   localparam XOR = 3'h7;

   //STATE MACHINE
   always @(opCode, opExt) begin

       regDst = 2'b??;
       regDataSel = 3'b??x;
       regWrite = 1'b0;
       aluSrc = 3'b??x;
       aluOp = 3'b??x;
       C_in = 1'b0;
       invA = 1'b0;
       invB = 1'b0;
       sign = 1'b0;
       memEn = 1'b0;
       memWr = 1'b0;
       branch = 1'b0;
       jump = 1'b0;
       halt = 1'b0;
       exception = 1'b0;
       rti = 1'b0;
       createDump = 1'b0;

       casex({opCode, opExt})

            // HALT
            7'b00000_??: begin
               halt = 1'b1;
               createDump = 1'b1;
            end
            // NOP
            7'b00001??: begin
               regWrite = 1'b0;
               memEn = 1'b0;
            end

            // ADDI
            7'b01000??: begin
               regDst = rt;
               regDataSel = aluOut;
               regWrite = 1'b1;
               aluSrc = imm_5_sext;
               aluOp = ADD;
               sign = 1'b1;
            end
            // SUBI
            7'b01001??: begin
               regDst = rt;
               regDataSel = aluOut;
               regWrite = 1'b1;
               aluSrc = imm_5_sext;
               aluOp = ADD;
               C_in = 1'b1;
               invA = 1'b1;
               sign = 1'b1;
            end
            // XORI
            7'b01010??: begin
               regDst = rt;
               regDataSel = aluOut;
               regWrite = 1'b1;
               aluSrc = imm_5_zext;
               aluOp = XOR;
            end
            // ANDNI
            7'b01011??: begin
               regDst = rt;
               regDataSel = aluOut;
               regWrite = 1'b1;
               aluSrc = imm_5_zext;
               aluOp = AND;
               invB = 1'b1;
            end
            // ROLI
            7'b10100??: begin
               regDst = rt;
               regDataSel = aluOut;
               regWrite = 1'b1;
               aluSrc = imm_5_sext;
               aluOp = rll;
            end
            // SLLI
            7'b10101??: begin
               regDst = rt;
               regDataSel = aluOut;
               regWrite = 1'b1;
               aluSrc = imm_5_sext;
               aluOp = sll;
            end
            // RORI
            7'b10110??: begin
               regDst = rt;
               regDataSel = ror;
               regWrite = 1'b1;
               aluSrc = imm_5_zext;
            end
            // SRLI
            7'b10111??: begin
               regDst = rt;
               regDataSel = aluOut;
               regWrite = 1'b1;
               aluSrc = imm_5_sext;
               aluOp = srl;
            end
            // ST
            7'b10000??: begin
               aluSrc = imm_5_sext;
               aluOp = ADD;
               sign = 1'b1;
               memEn = 1'b1;
               memWr = 1'b1;
            end
            // LD
            7'b10001??: begin
               regDst = rt;
               regDataSel = memOut;
               regWrite = 1'b1;
               aluSrc = imm_5_sext;
               aluOp = ADD;
               sign = 1'b1;
               memEn = 1'b1;
            end
            // STU
            7'b10011??: begin
               regDst = rs;
               regDataSel = aluOut;
               regWrite = 1'b1;
               aluSrc = imm_5_sext;
               aluOp = ADD;
               sign = 1'b1;
               memEn = 1'b1;
               memWr = 1'b1;
            end
            // BTR
            7'b11001??: begin
               regDst = rd;
               regDataSel = btr;
               regWrite = 1'b1;
            end
            // ADD
            7'b1101100: begin
               regDst = rd;
               regDataSel = aluOut;
               regWrite = 1'b1;
               aluOp = ADD;
               sign = 1'b1;
               aluSrc = reg2Data;
            end
            // SUB
            7'b1101101: begin
               regDst = rd;
               regDataSel = aluOut;
               regWrite = 1'b1;
               aluOp = ADD;
               sign = 1'b1;
               C_in = 1'b1;
               invA = 1'b1;
               aluSrc = reg2Data;
            end
            // XOR
            7'b1101110: begin
               regDst = rd;
               regDataSel = aluOut;
               regWrite = 1'b1;
               aluOp = XOR;
               aluSrc = reg2Data;
            end
            // ANDN
            7'b1101111: begin
               regDst = rd;
               regDataSel = aluOut;
               regWrite = 1'b1;
               aluOp = AND;
               aluSrc = reg2Data;
               invB = 1'b1;
            end
            // ROL
            7'b1101000: begin
               regDst = rd;
               regDataSel = aluOut;
               regWrite = 1'b1;
               aluOp = rll;
               aluSrc = reg2Data;
            end
            // SLL
            7'b1101001: begin
               regDst = rd;
               regDataSel = aluOut;
               regWrite = 1'b1;
               aluOp = sll;
               aluSrc = reg2Data;
            end
            // ROR
            7'b1101010: begin
               regDst = rd;
               regDataSel = ror;
               regWrite = 1'b1;
               aluSrc = reg2Data;
            end
            // SRL
            7'b1101011: begin
               regDst = rd;
               regDataSel = aluOut;
               regWrite = 1'b1;
               aluOp = srl;
               aluSrc = reg2Data;
            end
            // SEQ
            7'b11100??: begin
               regDst = rd;
               regDataSel = Sinstr;
               regWrite = 1'b1;
               aluOp = ADD;
               aluSrc = reg2Data;
               C_in = 1'b1;
               invB = 1'b1;
               sign = 1'b1;
            end
            // SLT
            7'b11101??: begin
               regDst = rd;
               regDataSel = Sinstr;
               regWrite = 1'b1;
               aluOp = ADD;
               aluSrc = reg2Data;
               C_in = 1'b1;
               invB = 1'b1;
               sign = 1'b1;
            end
            // SLE
            7'b11110??: begin
               regDst = rd;
               regDataSel = Sinstr;
               regWrite = 1'b1;
               aluOp = ADD;
               aluSrc = reg2Data;
               C_in = 1'b1;
               invB = 1'b1;
               sign = 1'b1;
            end
            // SCO
            7'b11111??: begin
               regDst = rd;
               regDataSel = Sinstr;
               regWrite = 1'b1;
               aluOp = ADD;
               aluSrc = reg2Data;
               sign = 1'b1;
            end
            //BEQZ BNEZ BLTZ BGEZ
            7'b011????: begin
               aluOp = ADD;
               aluSrc = zero;
               sign = 1'b1;
               C_in = 1'b1;
               invA = 1'b1;
               branch = 1'b1;
            end
            // LBI
            7'b11000_??: begin
               regDst = rs;
               regDataSel = imm_8;
               regWrite = 1'b1;
            end
            // SLBI
            7'b10010??: begin
               regDst = rs;
               regDataSel = slbi;
               regWrite = 1'b1;
            end
            // J
            7'b00100??: begin
               jump = 1'b1;
            end
            // JR
            7'b00101??: begin
               jump = 1'b1;
               aluOp = ADD;
               aluSrc = imm_8_sext;
            end
            // JAL
            7'b00110??: begin
               regDst = r7;
               regDataSel = PCplusTwo;
               regWrite = 1'b1;
               jump = 1'b1;
            end
            // JALR
            7'b00111??: begin
               regDst = r7;
               regDataSel = PCplusTwo;
               regWrite = 1'b1;
               aluOp = ADD;
               aluSrc = imm_8_sext;
               jump = 1'b1;
            end


            // siic
            7'b00010??: begin
               exception = 1'b1;
            end
            // NOP
            7'b00011??: begin
               rti = 1'b1;
            end
            default : begin
               exception = 1'b1;
            end


      endcase
   end

endmodule
