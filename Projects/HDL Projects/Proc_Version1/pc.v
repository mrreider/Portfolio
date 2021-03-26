//this module handles all pc operations ~reid
module pc (nextPC, en, clk, rst, addr);

    input [15:0] nextPC;
    input en;
    input clk;
    input rst;
    output[15:0] addr;

    //register holding pc
    reg_16 pcReg (.clk(clk), .rst(rst), .write_val(nextPC), .write(en), .out_val(addr));
   
endmodule
