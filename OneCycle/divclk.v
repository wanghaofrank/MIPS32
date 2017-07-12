module divclk(sysclk,clk,reset);
input sysclk,reset;
output clk;
reg clk;
always @(posedge sysclk or negedge reset)
begin
	if(~reset) begin
		clk<=1'b0;
	end
	else begin
		clk<=~clk;
	end
end
endmodule