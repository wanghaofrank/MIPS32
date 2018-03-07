module UART(clk_50M,sysclk,reset,TX_STATUS,RX_STATUS,TX_DATA,RX_DATA,UART_TX,UART_RX,TX_SEND);

input clk_50M,sysclk,reset,UART_RX,TX_SEND;
input [7:0] TX_DATA;
output TX_STATUS,RX_STATUS,UART_TX;
output [7:0] RX_DATA;

wire baudclk,baudsendclk;
reg TX_EN;

always @(posedge sysclk or negedge reset) begin
	if (~reset) begin
		TX_EN <= 0;
	end
	else begin
	if (TX_SEND == 1) TX_EN <= 1;
	else TX_EN <= 0;
	end
end


BaudRateGenerator BaudRateGenerator0(clk_50M,reset,baudclk,baudsendclk);
UARTReceiver UARTReceiver0(UART_RX,sysclk,reset,baudclk,RX_DATA,RX_STATUS);
UARTSender UARTSender0(sysclk,reset,baudsendclk,TX_DATA,TX_EN,TX_STATUS,UART_TX);
endmodule


module BaudRateGenerator(sysclk,reset,baudclk,baudsendclk); // generate clock used for UART sending and receiving

input sysclk,reset;
output baudclk,baudsendclk;

reg baudclk,baudsendclk;
reg [7:0] count;
reg [11:0] count1;

initial begin
	baudclk <= 1'b0;
	baudsendclk <= 1'b0;
	count <= 8'b0;
	count1 <= 12'b0;
end

always @(posedge sysclk or negedge reset) begin
	if (~reset) begin
		baudclk <= 1'b0;
		count <= 8'b0;
		count1 <= 12'b0;
		baudsendclk <= 1'b0;
	end
	else begin
		if (count == 8'd162) count <= 0;
		else count <= count + 8'b1;
		baudclk <= (count == 0)?~baudclk:baudclk;

		if (count1 == 12'd2603) count1 <= 0;
		else count1 <= count1 + 12'b1;
		baudsendclk <= (count1 == 0)?~baudsendclk:baudsendclk;
	end
end
endmodule


module UARTReceiver(UART_RX,sysclk,reset,baudclk,RX_DATA,RX_STATUS);
input UART_RX,sysclk,baudclk,reset;
output [7:0] RX_DATA;
output RX_STATUS;

reg RX_STATUS;
reg [1:0] status;
reg [4:0] count;
reg [7:0] RX_DATA;
reg [7:0] RX_DATA_SAVE;
reg [3:0] i;
reg sample;
reg RECEIVE_FLAG;

initial begin
	status <= 2'b0;
	count <= 5'b0;
	sample <= 1'b0;
	i <= 4'b0;
	RX_STATUS <= 0;
	RECEIVE_FLAG <= 0;
end

always @(posedge baudclk or negedge reset) begin
	if (~reset) begin
		status <= 2'b0;
		count <= 5'b0;
		sample <= 1'b0;	
		i <= 4'b0;
	end
	else if (status == 2'b0 && UART_RX == 0) begin
		status <= 2'b1;
		count <= 5'b0;
		sample <= 1'b0;
	end
	else if (status == 2'b01) begin
		if (count <= 5'd20) count <= count + 5'b1;
		else begin
			count <= 5'b0;
			status <= 2'b10;
		end
	end
	else if (status == 2'b10) begin
		if (count == 5'd15) count <=0;
		else begin
			count <= count + 5'b1;			
		end

		if (count == 5'b0 && i <= 4'd7) begin 
			sample <= 1;
			RX_DATA_SAVE[i] <= UART_RX;
			i <= i + 4'b1;
		end 
		else if (count == 5'b0 && i == 4'd8)begin
			sample <= 1;
			if (UART_RX == 1) begin
				status <= 2'b11;
				i <= 4'b0;
			end			
			else begin
				status <= 2'b0;
				i <= 4'b0;
			end
		end	
		else if (count != 5'b0) begin
			sample <= 0;
		end	
	end
	else if (status == 2'b11) begin
		status <= 2'b00;
	end
end

always @(posedge sysclk or negedge reset) begin
	if (~reset) begin
		RX_STATUS <= 0;
	end
	else begin
		if (status == 2'b10) begin
			RECEIVE_FLAG <= 1;
		end
		else if (status == 2'b11 && RECEIVE_FLAG == 1) begin
			RX_STATUS <= 1;
			RX_DATA <= RX_DATA_SAVE;
		end
		
		if (RX_STATUS == 1) begin
			RX_STATUS <= 0;
			RECEIVE_FLAG <= 0;
		end
	end
end
endmodule

module UARTSender(sysclk,reset,baudclk,TX_DATA,TX_EN,TX_STATUS,UART_TX);
input sysclk,baudclk,TX_EN,reset;
input [7:0]TX_DATA;
output UART_TX,TX_STATUS;

reg UART_TX,TX_STATUS;
reg [1:0] statu;
reg [2:0] i;
reg SENDER_FLAG;

initial begin
	UART_TX <= 1'b1;
	TX_STATUS <= 1'b1;
	statu <= 2'b0;
	i <= 3'b0;
	SENDER_FLAG <= 1'b0;
end

always @(posedge sysclk or negedge reset) begin
	if (~reset) begin
		TX_STATUS <= 1'b1;
	end 
	else begin
		if (statu == 2'b00) begin
			TX_STATUS <= 1;
		end
		else begin
			TX_STATUS <= 0;
		end

		if (TX_STATUS == 1 && SENDER_FLAG == 0 && TX_EN == 1) begin
			SENDER_FLAG <= 1;
		end
		else if (statu == 2'b11) begin
			SENDER_FLAG <= 0;
		end		
	end
end

always @(posedge baudclk or negedge reset) begin
	if (~reset) begin
		i <= 3'b0;
		statu <= 2'b00;
		UART_TX <= 1'b1;
	end
	else begin
		if (statu == 2'b00 && SENDER_FLAG == 1) begin
			UART_TX <= 0;
			statu <= 2'b10;
		end

		else if(statu == 2'b10) begin
			UART_TX <= TX_DATA[i];
			i <= i+ 3'b1;
			if (i == 3'b111) statu <= 2'b11;
		end 
		else if(statu == 2'b11) begin
			UART_TX <= 1;
			i <= 3'b0;
			statu <= 2'b00;
		end		
	end
end

endmodule