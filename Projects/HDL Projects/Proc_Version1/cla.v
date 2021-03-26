/**
4 Bit CLA
**/
module cla(A, B, Cin, Cout, Sum);
    input [3:0] A, B;
    input Cin;
    output Cout;
    output [3:0] Sum;

    wire [3:0] prop, gen, n1;

	// generate if A&B produces 1
    assign gen = A & B;
	// propogate if A|B
    assign prop = A ^ B;

    //CLA LOGIC
    assign n1[0] = Cin;
    assign n1[1] = gen[0] | (prop[0] & n1[0]);
    assign n1[2] = gen[1] | (prop[1] & gen[0]) | (&prop[1:0] & n1[0]);
    assign n1[3] = gen[2] | (prop[2] & gen[1]) | (&prop[2:1] & gen[0]) | (&prop[2:0] & n1[0]);

    assign Cout = gen[3] | (prop[3] & gen[2]) | (&prop[3:2] & gen[1]) | (&prop[3:1] & gen[0]) |(&prop[3:0] & n1[0]);
    assign Sum =  prop ^ n1;
endmodule
