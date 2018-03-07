`timescale 1ns/1ps

module Peripheral (reset,sysclk,clk,rd,wr,addr,wdata,rdata,led,switch,digi,irqout,UART_TX,UART_RX);

input reset,sysclk,clk;
input rd,wr;
input [31:0] addr;
input [31:0] wdata;

output [31:0] rdata;
reg [31:0] rdata;

output [7:0] led;
reg [7:0] led;

input [7:0] switch;
output [11:0] digi;
reg [11:0] digi;
output irqout;

reg [31:0] TH,TL;
reg [2:0] TCON;

input UART_RX;
output UART_TX;

wire [7:0] RX_DATA;
reg [7:0] TX_DATA;
wire TX_STATUS,RX_STATUS;
reg RX_GET;
reg TX_SEND;

assign irqout = TCON[2];

UART UART0(sysclk,clk,reset,TX_STATUS,RX_STATUS,TX_DATA,RX_DATA,UART_TX,UART_RX,TX_SEND);

initial begin
	RX_GET = 0;
	digi = 12'b0;
end

always@(*) begin
	if(rd) begin
		case(addr)
			32'h40000000: rdata <= TH;			
			32'h40000004: rdata <= TL;			
			32'h40000008: rdata <= {29'b0,TCON};				
			32'h4000000C: rdata <= {24'b0,led};			
			32'h40000010: rdata <= {24'b0,switch};
			32'h40000014: rdata <= {20'b0,digi};
			32'h40000018: rdata <= {24'b0,TX_DATA};
			32'h4000001C: begin
				rdata <= {24'b0,RX_DATA};	
				RX_GET <= 0;
			end
			32'h40000020: rdata <= {30'b0,RX_GET,TX_STATUS};
			default: rdata <= 32'b0;
		endcase
	end
	else
		rdata <= 32'b0;
	if (RX_STATUS == 1) RX_GET<=1;
end


always@(negedge reset or posedge clk) begin
	if(~reset) begin
		TH <= 32'b0;
		TL <= 32'b0;
		TCON <= 3'b0;	
		TX_SEND <= 0;
		led <= 8'b0;
	end
	else begin
		if(TCON[0]) begin	//timer is enabled
			if(TL==32'hffffffff) begin
				TL <= TH;
				if(TCON[1]) TCON[2] <= 1'b1;		//irq is enabled
			end
			else TL <= TL + 1;
		end
		
		if(wr) begin
			case(addr)
				32'h40000000: TH <= wdata;
				32'h40000004: TL <= wdata;
				32'h40000008: TCON <= wdata[2:0];		
				32'h4000000C: led <= wdata[7:0];			
				32'h40000014: digi <= wdata[11:0];
				32'h40000018: begin
					TX_DATA <= wdata[7:0];
					TX_SEND <= 1;
				end
				default:;
			endcase
		end
		if (TX_SEND == 1) TX_SEND <= 0;
	end
end
endmodule


