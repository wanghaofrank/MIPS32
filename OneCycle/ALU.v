module ALU(A,B,ALUFun,Sign,Z)
input [31:0] A;
input [31:0] B;
input [5:0] ALUFun;
input Sign;
output [31:0] Z;
wire [31:0] SA;
wire [31:0] SC;
wire [31:0] SL;
wire [31:0] SS;
assign Z=(ALUFun[5:4]==2'b00)?SA:
		(ALUFun[5:4]==2'b01)?SL:
		(ALUFun[5:4]==2'b10)?SS:SC;
//Add & Sub
wire Z,V,N,lc;
wire [31:0] b;
assign b=ALUFun[3]?(ALUFun[0]?~B+32'd1):32'd0;
assign {lc,S0}={0,A}+{0,b};
assign V=Sign?(lc^A[31])&(~A[31]^b[31]):lc^ALUFun[0];
assign N=Sign?S0[31]&(~V):(~lc)&ALUFun[0];
assign Z=(&(~S0))&(~V);
//CMP
wire z;
assign z=(ALUFun[3:1]==3'b000)?~Z:
	(ALUFun[3:1]==3'b001)?Z:
	(ALUFun[3:1]==3'b010)?N:
	(ALUFun[3:1]==3'b101)?N:
	(ALUFun[3:1]==3'b110)?N|Z:
	(ALUFun[3:1]==3'b111)?~(N|Z):0;
assign SC={31'd0,z};
//shift
assign s0=ALUFun[0]?(ALUFun[1]?(A[0]?{B[31],B[31:1]}:B):(A[0]?B>>1:B)):(A[0]?B<<1:B);
assign s1=ALUFun[0]?(ALUFun[1]?(A[1]?{{2{s0[31]}},s0[31:2]}:s0):(A[1]?s0>>2:s0)):(A[1]?s0<<2:s0);
assign s2=ALUFun[0]?(ALUFun[1]?(A[2]?{{4{s1[31]}},s1[31:4]}:s1):(A[2]?s1>>4:s1)):(A[2]?s1<<4:s1);
assign s3=ALUFun[0]?(ALUFun[1]?(A[3]?{{8{s2[31]}},s2[31:8]}:s2):(A[3]?s2>>8:s2)):(A[3]?s2<<8:s2);
assign SS=ALUFun[0]?(ALUFun[1]?(A[4]?{{16{s3[31]}},s3[31:16]}:s3):(A[4]?s3>>16:s3)):(A[4]?s3<<16:s3);
//logic
assign SL=(ALUFun[3:0]==3'b0001)?~(A|B):
		(ALUFun[3:0]==3'b0110)?A^B:
		(ALUFun[3:0]==3'b1000)?A&B:
		(ALUFun[3:0]==3'b1010)?A:
		(ALUFun[3:0]==3'b1110)?A|B:A;
endmodule