module uart_tx(
input   clk, reset ,
input   UART_en , 
input   tx_en ,
input   fifo_empty ,
input   [7:0] fifo_data,
input   baud_tick,
output reg  tx , tx_busy , fifo_rd_en  
);
reg [7:0] tx_data;
reg [1:0] status; 
reg [3:0] tick_count;
reg [3:0] bit_count;

parameter IDLE= 2'b00;
parameter START= 2'b01;
parameter DATA= 2'b10;
parameter STOP= 2'b11;

always @ (posedge clk)
	begin
	if(reset)
		begin
		tx<=1;
		tx_busy<=0;
		fifo_rd_en<=0;
		status<=IDLE;
		bit_count<=4'b0;
		tick_count <= 4'b0;
		end
	
	else
		begin
		case(status)
		IDLE:
			begin
			bit_count <= 0;
			if(!fifo_empty && UART_en && tx_en)
				begin
				status<=START;
				tx_busy<=1;
				fifo_rd_en<=1;
				tx_data <= fifo_data;
				end
			else
				begin
				status<=IDLE;
				tx_busy<=0;				
				end
			end
			
		START:
			begin
				tx<=0;
				fifo_rd_en<=0;
				if (baud_tick)
					begin 
					tick_count<=tick_count+1;
					if(tick_count==4'd15)
						begin
						tx <= tx_data[0];
						status<=DATA;
						tick_count<=0;
						end
					else
						status<=START;
					end
				else
					status<=START;
			end
				
				
		DATA: 
			begin
					fifo_rd_en<=0;
					if (baud_tick)
						begin 
						tick_count<=tick_count+1;
							if (tick_count==4'd15)
								begin
								if(bit_count==7)
									begin
									status<=STOP;
									tick_count<=0;
									end
								else
									begin
									bit_count<=bit_count+1;
									tx <= tx_data[bit_count + 1];
									tick_count <= 0;
									end
								end
						end
			end
			
		STOP:
			begin
				tx <= 1;
				if(baud_tick)
				begin
					tick_count <= tick_count + 1;
					if(tick_count == 4'd15)
					begin
						status <= IDLE;
						tick_count <= 0;
					end
					else
						status <= STOP;
				end
			end
		endcase
		
		end
	
	
	end
endmodule