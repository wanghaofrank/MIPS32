`timescale 1ns/1ns

module UART_tb;

reg UART_RX,clk,reset;
reg rd;
reg wr;
reg [31:0] addr;
reg [31:0] wdata;
wire UART_TX;
wire [7:0] led;
wire [7:0] switch;
wire [11:0] digi;
wire [31:0] rdata;

Peripheral Peripheral0(reset,clk,rd,wr,addr,wdata,rdata,led,switch,digi,irqout,UART_TX,UART_RX);

initial begin
	UART_RX <= 0;
	clk <= 0;
	reset <= 1;
	rd <= 0;
	wr <= 0;
	#5 reset <= ~reset;
	#5 reset <= ~reset;
	#20 begin
		wr <= 1;
		rd <= 0;
		addr <= 32'h40000018;
		wdata <= {23'b0,8'b10101111};
	end

	#20 begin
		wr <= 0;
		rd <= 0;
		addr <= 32'h40000018;
		wdata <= {23'b0,8'b10101111};	
	end
end



always #10 clk <= ~clk;

always begin
	#104166 UART_RX <= 1;
	#104166 UART_RX <= 0;
	#104166 UART_RX <= 1;
	#104166 UART_RX <= 0;
	#104166 UART_RX <= 1;
	#104166 UART_RX <= 1;
	#104166 UART_RX <= 0;
	#104166 UART_RX <= 0;
	#104166 UART_RX <= 1;
	
	#200000 UART_RX <= 0;
	#104166 UART_RX <= 1;
	#104166 UART_RX <= 1;
	#104166 UART_RX <= 1;
	#104166 UART_RX <= 0;
	#104166 UART_RX <= 1;
	#104166 UART_RX <= 1;
	#104166 UART_RX <= 1;
	#104166 UART_RX <= 1;
	#104166 UART_RX <= 1;
	#104166 UART_RX <= 1;
	#104166 UART_RX <= 0;
end



endmodule