/**
Increments PC and handles instruction memory
**/
module fetch (nextPC, PCplusTwo, instruction, en, clk, rst, createDump);

    input [15:0] nextPC;
    input en, clk, rst, createDump;
    output [15:0] PCplusTwo, instruction;
    
    wire [15:0] addr;
    wire C_out;

    //DUT INSTANTIATION
    cla_16 pcplustwo(.A(addr), .B(16'h0002), .Sum(PCplusTwo), .Cin(1'b0), .Cout(C_Out));

    pc fetchPC(.nextPC(nextPC), .en(en), .clk(clk), .rst(rst), .addr(addr));

    memory2c instrMem(.data_out(instruction), .data_in(16'h0), .addr(addr), .enable(1'b1), .wr(1'b0), .createdump(1'b0), .clk(clk), .rst(rst));
   
endmodule
