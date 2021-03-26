/**
Data memory
**/
module memory (instruction, aluOut, controlSignals, memDataIn, clk, rst, memOut, halt, createDump);


   input[15:0] instruction, aluOut, memDataIn;
   input[22:0] controlSignals;
   input clk, rst, halt, createDump;
 
   output [15:0] memOut;

   wire enableMemory = controlSignals[14];
   wire writeToMem = controlSignals[15];

   memory2c dataMem(.data_out(memOut), .data_in(memDataIn), .addr(aluOut), .enable(enableMemory), .wr(writeToMem), .createdump(halt), .clk(clk), .rst(rst));
   
endmodule
