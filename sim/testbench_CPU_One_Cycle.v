module CPU_sim;
reg clk,reset;
wire [6:0] digi_out1;
wire [6:0] digi_out2;
wire [6:0] digi_out3;
wire [6:0] digi_out4;
wire [7:0] led;
wire [7:0] switch;
wire tx;
reg rx;
CPU CPU0(clk,reset,digi_out1,digi_out2,digi_out3,digi_out4,led,switch,rx,tx);


initial begin
	clk <= 0;
	reset <= 0;
	rx <= 1;
	#10 reset <= 1;
end

always #10 begin
	clk <= ~clk;
end

always #10 clk <= ~clk;

always begin
	#104166 rx <= 0;
	#104166 rx <= 0;
	#104166 rx <= 0;
	#104166 rx <= 1;
	#104166 rx <= 0;
	#104166 rx <= 0;
	#104166 rx <= 1;
	#104166 rx <= 0;
	#104166 rx <= 0;
	#104166 rx <= 1;
	
	#200000 rx <= 0;
	#104166 rx <= 0;
	#104166 rx <= 0;
	#104166 rx <= 1;
	#104166 rx <= 1;
	#104166 rx <= 0;
	#104166 rx <= 0;
	#104166 rx <= 0;
	#104166 rx <= 0;
	#104166 rx <= 1;
	#104166 rx <= 1;
	#104166 rx <= 1;
end
endmodule