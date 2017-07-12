module CPU(sysclk,reset,digi_out1,digi_out2,digi_out3,digi_out4,led,switch,rx,tx);
input sysclk,reset,rx;
output [6:0] digi_out1;
output [6:0] digi_out2;
output [6:0] digi_out3;
output [6:0] digi_out4;
output [7:0] led;
input [7:0] switch;
output tx;
// dive clk
wire clk;
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
//IF_ID
reg [31:0] IF_ID_PC;
reg [31:0] IF_ID_PC4;
reg [31:0] IF_ID_ins;
//ID_EX
reg [31:0] ID_EX_DATA_1;
reg [31:0] ID_EX_DATA_2;
reg [31:0] ID_EX_PC4;
reg [25:0] ID_EX_PC_JUMP;
reg [31:0] ID_EX_CONBA;
reg [31:0] ID_EX_IMM;
reg [4:0] ID_EX_shamt;
reg [2:0] ID_EX_PCSrc;
reg [4:0] ID_EX_AddrC;
reg [4:0] ID_EX_Rs;
reg [4:0] ID_EX_Rt;
reg [1:0] ID_EX_MemToReg;
reg [5:0] ID_EX_ALUFun;
reg ID_EX_is_Jump;
reg [31:0] ID_EX_Jump_Addr;
reg ID_EX_RegWr,ID_EX_ALUSrc1,ID_EX_ALUsrc2,ID_EX_Sign,ID_EX_MemWr,ID_EX_MemRd;
//EX_MEM
reg [31:0] EX_MEM_PC4;
reg [31:0] EX_MEM_ALUOUT;
reg [31:0] EX_MEM_DATA2;
reg [4:0] EX_MEM_AddrC;
reg [1:0] EX_MEM_MemToReg;
reg [31:0] EX_MEM_Branch_Addr;
reg EX_MEM_is_branch;
reg EX_MEM_RegWr,EX_MEM_MemWr,EX_MEM_MemRd;
//MEM_WB
reg [31:0] MEM_WB_PC4;
reg [31:0] MEM_WB_READ_DATA;
reg [31:0] MEM_WB_DATAOUT;
reg [1:0] MEM_WB_MemToReg;
reg [4:0] MEM_WB_AddrC;
reg MEM_WB_RegWr;

wire is_load_use;
wire is_jump;
wire is_jump_r;
wire is_ILLOP;
wire is_XADR;
wire is_branch;
assign clk=sysclk;

assign PCp4=PC+32'd4;
always @(posedge clk or negedge reset)
begin
	if(~reset)
		PC<=32'd0;
	else if(is_ILLOP&&~is_branch)
		PC<=32'h80000004;
	else if(is_XADR&&~is_branch)
		PC<=32'h80000008;
	else if(~is_load_use) begin
		if(is_branch)
			PC<=ID_EX_CONBA;
		else if(is_jump)
			PC<={IF_ID_PC4[31:28],IF_ID_ins[25:0],2'd0};
		else if(is_jump_r)
			PC<=DataBusA;	
		else
			PC<=PCp4;
	end
end
//Instruct Mem
ROM rom({1'b0,PC[30:0]},Instruct);
//IF_ID
always @(posedge clk or negedge reset) begin
	if(~reset) begin
		IF_ID_ins<=32'd0;
		IF_ID_PC4<=32'd0;
		IF_ID_PC<=32'd0;
	end
	else if(is_XADR||is_ILLOP) begin
		IF_ID_PC<=32'h80000000;
		IF_ID_PC4<=32'h80000000;
		IF_ID_ins<=32'h00000000;
	end
	else if(is_branch||is_jump||is_jump_r) begin
		IF_ID_PC<=IF_ID_PC[31]?32'h80000000:32'd0;
		IF_ID_PC4<=IF_ID_PC4[31]?32'h80000000:32'd0;
		IF_ID_ins<=32'd0;
	end
	else if(~is_load_use) begin
		IF_ID_PC<=PC;
		IF_ID_PC4<=PCp4;
		IF_ID_ins<=Instruct;
	end
end
//ID
assign JT=IF_ID_ins[25:0];
assign Imm16=IF_ID_ins[15:0];
assign Shamt=IF_ID_ins[10:6];
assign Rd=IF_ID_ins[15:11];
assign Rt=IF_ID_ins[20:16];
assign Rs=IF_ID_ins[25:21];
//Control
Control ctrl(IF_ID_ins[31:26],IF_ID_ins[5:0],IRQ,IF_ID_PC4[31],PCSrc,RegDst,RegWr,ALUSrc1,ALUSrc2,ALUFun,Sign,MemWr,MemRd,MemToReg,EXTOp,Interrupt,LUOp);
//RegFile
wire [4:0] AddrC;
wire [31:0] DataC;

assign AddrC=(RegDst==2'd0)?Rd:
			(RegDst==2'd1)?Rt:
			(RegDst==2'd2)?5'd31:5'd26;
assign DataC=MEM_WB_DATAOUT;
assign is_load_use=(ID_EX_MemRd&&(ID_EX_Rt==Rs||ID_EX_Rt==Rt));
assign is_jump=(PCSrc==3'd2);
assign is_jump_r=(PCSrc==3'd3);
assign is_ILLOP=(PCSrc==3'd4);
assign is_XADR=(PCSrc==3'd5);

RegFile regfile(reset,clk,Rs,DataBusA,Rt,DataBusB,MEM_WB_RegWr,MEM_WB_AddrC,DataC);
//ID_EX
wire [31:0] ExtImm;
wire [31:0] Lu_ext_Imm;

assign ExtImm=EXTOp?{{16{Imm16[15]}},Imm16}:{16'd0,Imm16};
assign Lu_ext_Imm=LUOp?{Imm16,16'd0}:ExtImm;
always @(posedge clk or negedge reset) begin
	if (~reset) begin
		ID_EX_DATA_1<=32'd0;
		ID_EX_DATA_2<=32'd0;
		ID_EX_PC4<=32'd0;
		ID_EX_PC_JUMP<=26'd0;
		ID_EX_CONBA<=32'd0;
		ID_EX_IMM<=32'd0;
		ID_EX_shamt<=5'd0;
		ID_EX_PCSrc<=3'd0;
		ID_EX_AddrC<=5'd0;
		ID_EX_Rs<=5'd0;
		ID_EX_Rt<=5'd0;
		ID_EX_MemToReg<=2'd0;
		ID_EX_ALUFun<=6'd0;
		ID_EX_RegWr<=1'd0;
		ID_EX_ALUSrc1<=1'd0;
		ID_EX_ALUsrc2<=1'd0;
		ID_EX_Sign<=1'd0;
		ID_EX_MemWr<=1'd0;
		ID_EX_MemRd<=1'd0;
		ID_EX_is_Jump <= 1'd0;
		ID_EX_Jump_Addr <= 32'b0;
	end
	else begin
		ID_EX_DATA_1<=
					(EX_MEM_RegWr&&(EX_MEM_AddrC!=0)&&(EX_MEM_AddrC==Rs)&&(ID_EX_AddrC!=Rs||~ID_EX_RegWr))?DataBusC:
			  		(ID_EX_RegWr&&(ID_EX_AddrC!=0)&&(ID_EX_AddrC==Rs))?ALUOut:
			  		(MEM_WB_RegWr&&(MEM_WB_AddrC!=0)&&(MEM_WB_AddrC==Rs))?MEM_WB_DATAOUT:DataBusA;
		ID_EX_DATA_2<=
					(EX_MEM_RegWr&&(EX_MEM_AddrC!=0)&&(EX_MEM_AddrC==Rt)&&(ID_EX_AddrC!=Rt||~ID_EX_RegWr))?DataBusC:
			  		(ID_EX_RegWr&&(ID_EX_AddrC!=0)&&(ID_EX_AddrC==Rt))?ALUOut:
			  		(MEM_WB_RegWr&&(MEM_WB_AddrC!=0)&&(MEM_WB_AddrC==Rt))?MEM_WB_DATAOUT:DataBusB;
		//ID_EX_PC4<=(ID_EX_is_Jump == 1)?ID_EX_Jump_Addr:((IF_ID_ins[31:26] == 6'b000011)?IF_ID_PC4:((is_branch)?ID_EX_CONBA:(EX_MEM_is_branch)?EX_MEM_Branch_Addr:IF_ID_PC));
		ID_EX_PC4<=(ID_EX_is_Jump == 1)?ID_EX_Jump_Addr:((IF_ID_ins[31:26] == 6'b000011)?IF_ID_PC4:IF_ID_PC);
		ID_EX_PC_JUMP<=JT;
		ID_EX_CONBA<=ConBA;
		ID_EX_IMM<=Lu_ext_Imm;
		ID_EX_shamt<=Shamt;
		ID_EX_Rs<=Rs;
		ID_EX_Rt<=Rt;
		ID_EX_PCSrc<=PCSrc;

		if((is_load_use||is_branch)&&~is_XADR&&~is_ILLOP) begin
			ID_EX_AddrC<=5'd0;
			ID_EX_MemToReg<=2'd0;
			ID_EX_ALUFun<=6'd0;
			ID_EX_RegWr<=1'd0;
			ID_EX_ALUSrc1<=1'd0;
			ID_EX_ALUsrc2<=1'd0;
			ID_EX_Sign<=1'd0;
			ID_EX_MemWr<=1'd0;
			ID_EX_MemRd<=1'd0;
			ID_EX_is_Jump<=1'd0;
			ID_EX_Jump_Addr<=32'b0;
		end
		else begin
			ID_EX_AddrC<=AddrC;
			ID_EX_MemToReg<=MemToReg;
			ID_EX_ALUFun<=ALUFun;
			ID_EX_RegWr<=RegWr;
			ID_EX_ALUSrc1<=ALUSrc1;
			ID_EX_ALUsrc2<=ALUSrc2;
			ID_EX_Sign<=Sign;
			ID_EX_MemWr<=MemWr;
			ID_EX_MemRd<=MemRd;
			ID_EX_is_Jump<=is_jump;
			ID_EX_Jump_Addr<={IF_ID_PC4[31:28],IF_ID_ins[25:0],2'd0};
		end
	end
end
//ALU & Branches
wire [31:0] ALUInA;
wire [31:0] ALUInB;
wire [31:0] ALU_DATA_1;
wire [31:0] ALU_DATA_2;
/*
assign ALU_DATA_1=(MEM_WB_RegWr&&(MEM_WB_AddrC!=0)&&(MEM_WB_AddrC==ID_EX_Rs)&&(EX_MEM_AddrC!=ID_EX_Rs||~EX_MEM_RegWr))?DataBusC:
			  (EX_MEM_RegWr&&(EX_MEM_AddrC!=0)&&(EX_MEM_AddrC==ID_EX_Rs))?EX_MEM_ALUOUT:
			  ID_EX_DATA_1;
assign ALU_DATA_2=(MEM_WB_RegWr&&(MEM_WB_AddrC!=0)&&(MEM_WB_AddrC==ID_EX_Rt)&&(EX_MEM_AddrC!=ID_EX_Rt||~EX_MEM_RegWr))?DataBusC:
			  (EX_MEM_RegWr&&(EX_MEM_AddrC!=0)&&(EX_MEM_AddrC==ID_EX_Rt))?EX_MEM_ALUOUT:
		      ID_EX_DATA_2;			
assign ALUInA=ID_EX_ALUSrc1?{27'd0,ID_EX_shamt}:ALU_DATA_1;
assign ALUInB=ID_EX_ALUsrc2?ID_EX_IMM:ALU_DATA_2;
*/
assign ALUInA=ID_EX_ALUSrc1?{27'd0,ID_EX_shamt}:ID_EX_DATA_1;
assign ALUInB=ID_EX_ALUsrc2?ID_EX_IMM:ID_EX_DATA_2;

assign ConBA=(ExtImm<<2)+IF_ID_PC4;
ALU alu(ALUInA,ALUInB,ID_EX_ALUFun,ID_EX_Sign,ALUOut);
assign is_branch=(ID_EX_PCSrc==3'd1&&ALUOut[0]);
//EX_MEM
always @(posedge clk or negedge reset) begin
	if (~reset) begin
		EX_MEM_PC4<=31'd0;
		EX_MEM_ALUOUT<=31'd0;
		EX_MEM_DATA2<=31'd0;
		EX_MEM_AddrC<=5'd0;
		EX_MEM_MemToReg<=2'd0;
		EX_MEM_RegWr<=1'd0;
		EX_MEM_MemWr<=1'd0;
		EX_MEM_MemRd<=1'd0;
		EX_MEM_is_branch<=1'b0;
		EX_MEM_Branch_Addr<=32'b0;
	end
	else begin
		EX_MEM_PC4<=ID_EX_PC4;
		EX_MEM_ALUOUT<=ALUOut;
		EX_MEM_DATA2<=ID_EX_DATA_2;
		EX_MEM_AddrC<=ID_EX_AddrC;
		EX_MEM_MemToReg<=ID_EX_MemToReg;
		EX_MEM_RegWr<=ID_EX_RegWr;
		EX_MEM_MemWr<=ID_EX_MemWr;
		EX_MEM_MemRd<=ID_EX_MemRd;
		EX_MEM_is_branch<=is_branch;
		EX_MEM_Branch_Addr<=ID_EX_CONBA;
	end
end
//DataMem & Peripheral
wire [31:0] rdatam;
wire [31:0] rdatap;
wire [31:0] rdata;
wire [11:0] digi;

DataMem datamem(reset,clk,EX_MEM_MemRd&(~EX_MEM_ALUOUT[30]),EX_MEM_MemWr&(~EX_MEM_ALUOUT[30]),EX_MEM_ALUOUT,EX_MEM_DATA2,rdatam);
Peripheral peripheral(reset,sysclk,clk,EX_MEM_MemRd&EX_MEM_ALUOUT[30],EX_MEM_MemWr&EX_MEM_ALUOUT[30],EX_MEM_ALUOUT,EX_MEM_DATA2,rdatap,led,switch,digi,IRQ,tx,rx);
digitube_scan digi_scan(digi,digi_out1,digi_out2,digi_out3,digi_out4);
assign rdata=EX_MEM_ALUOUT[30]?rdatap:rdatam;
assign DataBusC=(EX_MEM_MemToReg==2'd0)?EX_MEM_ALUOUT:
				(EX_MEM_MemToReg==2'd1)?rdata:
				(EX_MEM_MemToReg==2'd2)?EX_MEM_PC4:32'd0;
//MEM_WB
always @(posedge clk or negedge reset) begin
	if (~reset) begin
		MEM_WB_READ_DATA<=32'd0;
		MEM_WB_PC4<=32'd0;
		MEM_WB_DATAOUT<=32'd0;
		MEM_WB_MemToReg<=2'd0;
		MEM_WB_AddrC<=5'd0;
		MEM_WB_RegWr<=1'd0;
	end
	else begin
		MEM_WB_READ_DATA<=rdata;
		MEM_WB_PC4<=EX_MEM_PC4;
		MEM_WB_DATAOUT<=DataBusC;
		MEM_WB_MemToReg<=EX_MEM_MemToReg;
		MEM_WB_AddrC<=EX_MEM_AddrC;
		MEM_WB_RegWr<=EX_MEM_RegWr;
	end
end

endmodule


