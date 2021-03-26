module and2 (in1,in2,out);
    input in1,in2;
    output out;
    
    wire n1_out;

    nand2 n1(in1, in2, n1_out);
    nand2 n2(n1_out, n1_out, out);

endmodule
