module CPU(clk,reset,digi_out1,digi_out2,digi_out3,digi_out4,led,switch,rx,tx);
input clk,reset,rx;
output [6:0] digi_out1;
output [6:0] digi_out2;
output [6:0] digi_out3;
output [6:0] digi_out4;
output [7:0] led;
input [7:0] switch;
output tx;
//Signals
wire [2:0] PCSrc;
wire [1:0] RegDst;
wire [1:0] MemToReg;
wire [5:0] ALUFun;
wire RegWr,ALUSrc1,ALUSrc2,Sign,MemWr,MemRd,EXTOp,Interrupt;
//wires
wire [31:0] Instruct;
wire [25:0] JT;
wire [15:0] Imm16;
wire [4:0] Shamt;
wire [4:0] Rd;
wire [4:0] Rt;
wire [4:0] Rs;
wire [31:0] ConBA;
wire [31:0] DataBusA;
wire [31:0] DataBusB;
wire [31:0] DataBusC;
wire [31:0] ALUOut;
wire IRQ;
//PC
reg [31:0] PC;
wire [31:0] PCp4;
assign PCp4=PC+32'd4;
always @(posedge clk or negedge reset)
begin
	if(~reset)
		PC<=32'd0;
	else 
		PC<=(PCSrc==3'd0)?PCp4:
			(PCSrc==3'd1)?(ALUOut[0]?ConBA:PCp4):
			(PCSrc==3'd2)?{PCp4[31:28],JT,2'd0}:
			(PCSrc==3'd3)?DataBusA:
			(PCSrc==3'd4)?32'h80000004:
			(PCSrc==3'd5)?32'h80000008:PCp4;
end
//Instruction Mem
ROM rom({1'b0,PC[30:0]},Instruct);
assign JT=Instruct[25:0];
assign Imm16=Instruct[15:0];
assign Shamt=Instruct[10:6];
assign Rd=Instruct[15:11];
assign Rt=Instruct[20:16];
assign Rs=Instruct[25:21];
//Control
Control ctrl(Instruct[31:26],Instruct[5:0],IRQ,PC[31],PCSrc,RegDst,RegWr,ALUSrc1,ALUSrc2,ALUFun,Sign,MemWr,MemRd,MemToReg,EXTOp,Interrupt);
//RegFile
wire [4:0] AddrC;
wire [31:0] DataC;
assign AddrC=(RegDst==2'd0)?Rd:
			(RegDst==2'd1)?Rt:
			(RegDst==2'd2)?5'd31:5'd26;
assign DataC=Interrupt?(DataBusC-32'd4):DataBusC;
RegFile regfile(reset,clk,Rs,DataBusA,Rt,DataBusB,RegWr,AddrC,DataC);
//ALU & Branches
wire [31:0] ExtImm;
wire [31:0] ALUInA;
wire [31:0] ALUInB;
assign ExtImm=EXTOp?{{16{Imm16[15]}},Imm16}:{16'd0,Imm16};
assign ALUInA=ALUSrc1?{27'd0,Shamt}:DataBusA;
assign ALUInB=ALUSrc2?ExtImm:DataBusB;
assign ConBA=(ExtImm<<2)+PCp4;
ALU alu(ALUInA,ALUInB,ALUFun,Sign,ALUOut);
//DataMem & Peripheral
wire [31:0] rdatam;
wire [31:0] rdatap;
wire [31:0] rdata;
wire [11:0] digi;
DataMem datamem(reset,clk,MemRd&(~ALUOut[30]),MemWr&(~ALUOut[30]),ALUOut,DataBusB,rdatam);
Peripheral peripheral(reset,clk,MemRd&ALUOut[30],MemWr&ALUOut[30],ALUOut,DataBusB,rdatap,led,switch,digi,IRQ,tx,rx);
digitube_scan digi_scan(digi,digi_out1,digi_out2,digi_out3,digi_out4);
assign rdata=ALUOut[30]?rdatap:rdatam;
assign DataBusC=(MemToReg==2'd0)?ALUOut:
				(MemToReg==2'd1)?rdata:
				(MemToReg==2'd2)?PCp4:{Imm16,16'd0};
endmodule