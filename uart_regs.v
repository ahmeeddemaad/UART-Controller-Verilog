module uart_regs(
// From Host
input        clk,
input        reset,
input [3:0]  addr,
input        wr_en,
input        rd_en,
input [7:0]  wdata,

// From UART
input [7:0]  rx_fifo_data,
input        rx_fifo_empty,
input        rx_fifo_full,
input        tx_fifo_full,
input        tx_fifo_empty,
input        tx_busy,
input        rx_frame_error,

// To Host
output reg [7:0] rdata,

// To TX FIFO
output reg [7:0] tx_fifo_data,
output reg       tx_fifo_wr_en,

// To RX FIFO
output reg       rx_fifo_rd_en,

// For TX/RX UART
output reg uart_enable,
output reg tx_enable,
output reg rx_enable,

// For Baud Generator
output reg [7:0] baud_div
);

reg [7:0] control;
reg [7:0] status;


parameter TX_DATA  = 4'h0;
parameter RX_DATA  = 4'h4;
parameter STATUS   = 4'h8;
parameter CONTROL  = 4'hC;
parameter BAUD_Div = 4'hD;

always@(posedge clk)
	begin
	if(reset)
		begin
		tx_fifo_wr_en <= 0;
		rx_fifo_rd_en <= 0;
		tx_fifo_data  <= 8'h00;
		control       <= 8'h07;
		baud_div      <= 8'd27;
		end
		
	else
		begin
		tx_fifo_wr_en<=0;
		rx_fifo_rd_en<=0;
		case(addr)
		TX_DATA:
			begin
			if(wr_en && !rd_en && !tx_fifo_full)
				begin
				tx_fifo_wr_en<=1;
				tx_fifo_data<=wdata;
				end
			end
			
		RX_DATA: 
			begin
			if(!wr_en && rd_en)
				rx_fifo_rd_en<=1;
			end

		CONTROL: 
			begin
			if (wr_en && !rd_en)
				begin
				control[0]   <=   wdata[0];
				control[1]   <=   wdata[1];
				control[2]   <=   wdata[2];
				control[7:3] <=   0;
				end			
			end
			
		BAUD_Div: 
			begin
			if (wr_en && !rd_en)
				begin
				if (wdata != 0)
					baud_div <=  wdata;
				end
			end
			
		endcase
		end
	end
	
always@(*)
	begin
	rdata  = 8'h00;
	status = 8'h00;
    uart_enable = control[0];
    tx_enable   = control[1];
    rx_enable   = control[2];
	
	case(addr)
	RX_DATA:
        begin
			if (rd_en && !wr_en)
			begin
				if(!rx_fifo_empty)
						rdata = rx_fifo_data;
					else
						rdata = 8'b0;
					end
			end
        
		
	STATUS:
	           begin
				status[0]=tx_busy;
				status[1]=tx_fifo_full;
				status[2]=tx_fifo_empty;
				status[3]=rx_fifo_full;
				status[4]=rx_fifo_empty;
				status[5]=!rx_fifo_empty;
				status[6]=rx_frame_error;
				status[7]=0;
				if (rd_en && !wr_en)
					rdata    =status;
	           end
	CONTROL:
		 begin
            if (rd_en && !wr_en)
                rdata = control;
		 end
		
	BAUD_Div:
        begin
            if (rd_en && !wr_en)
                rdata = baud_div;
        end
	endcase	
	end


endmodule