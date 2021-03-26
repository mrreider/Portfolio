module or2 (in1,in2,out);
    input in1,in2;
    output out;
    
    wire n1, n2;

    not1 not1(in1, n1);
    not1 not2(in2, n2);
    nand2 nand1(n1, n2, out);


endmodule
