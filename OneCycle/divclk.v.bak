module divclk(sysclk,clk,reset);
input sysclk,reset;
output reg clk;
reg [2:0] state;
always @(posedge sysclk or negedge reset)
begin
	if(~reset) begin
		clk<=1'b0;
		state<=3'd0;
	end
	else begin
		state<=(state==3'd4)?3'd0:state+3'd1;
		clk<=(state==3'd0)?~clk:clk;
	end
end
endmodule