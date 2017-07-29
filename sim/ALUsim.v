`timescale 1ns/1ns

module ALU_sim;

reg [31:0] A;
reg [31:0] B;
reg [5:0] ALUFun;
reg Sign;
wire [31:0] S;

ALU ALU0(A,B,ALUFun,Sign,S);

initial begin
	A <= 32'b0;
	B <= 32'b0;
	ALUFun <= 6'b0;
	Sign <= 0;
	#100
	A <= 32'd12345;
	B <= 32'd54321;
	ALUFun <= 6'b0;
	Sign <= 0;	
	#100
	ALUFun <= 6'b000001;
	Sign <= 0;	
	#100
	ALUFun <= 6'b011000;
	Sign <= 0;		
	#100
	ALUFun <= 6'b011110;
	Sign <= 0;		
	#100
	ALUFun <= 6'b010110;
	Sign <= 0;		
	#100
	ALUFun <= 6'b010001;
	Sign <= 0;		
	#100
	ALUFun <= 6'b011010;
	Sign <= 0;		
	#100
	A <= 32'd4;
	ALUFun <= 6'b100000;
	Sign <= 0;
	#100
	ALUFun <= 6'b100001;
	Sign <= 0;		
	#100
	ALUFun <= 6'b100011;
	Sign <= 0;	
	#100
	A <= 32'd54321;
	ALUFun <= 6'b110011;
	Sign <= 0;		
	#100
	A <= 32'd12345;
	ALUFun <= 6'b110001;
	Sign <= 0;	
	#100
	ALUFun <= 6'b110101;
	Sign <= 0;		
	#100
	ALUFun <= 6'b111101;
	Sign <= 0;	
	#100
	ALUFun <= 6'b111011;
	Sign <= 0;	
	#100
	ALUFun <= 6'b111111;
	Sign <= 0;	
end

endmodule