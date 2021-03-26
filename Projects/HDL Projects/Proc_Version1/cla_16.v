/**
16 bit Carry Look Ahead adder made from 4 bit CLA implementation
**/
module cla_16(A, B, Cin, Cout, Sum);
    input [15:0] A, B;
    input Cin;
    output [15:0] Sum;
    output Cout;

	// Declare intermediate wires
	wire c1, c2, c3;

    // instantiate the CLAS
    cla cla1(.A(A[3:0]), .B(B[3:0]), .Cin(Cin), .Sum(Sum[3:0]), .Cout(c1));
    cla cla2(.A(A[7:4]), .B(B[7:4]), .Cin(c1), .Sum(Sum[7:4]), .Cout(c2));
    cla cla3(.A(A[11:8]), .B(B[11:8]), .Cin(c2), .Sum(Sum[11:8]), .Cout(c3));
    cla cla4(.A(A[15:12]), .B(B[15:12]), .Cin(c3), .Sum(Sum[15:12]), .Cout(Cout));
endmodule
