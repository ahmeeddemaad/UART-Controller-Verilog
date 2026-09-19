module uart_top(
input        clk,reset,
input  [3:0] addr,
input        wr_en, rd_en,
input        rx,
input  [7:0] wdata,
output wire [7:0] rdata,
output       tx,
output       irq  // Interrupt Request output 
);
assign irq = 1'b0;


wire  [7:0]  baud_div;
wire  [7:0]  rx_data;
wire  [7:0]  rx_fifo_data;
wire  [7:0]  tx_fifo_data;
wire  [7:0]  tx_fifo_data_out;
wire  		 baud_tick;
wire  	   	 uart_enable;
wire  		 tx_enable;
wire		 rx_fifo_empty;
wire 		 rx_fifo_full;
wire		 tx_fifo_empty;
wire 		 tx_fifo_full;
wire	     tx_busy;
wire	     rx_enable;
wire 		 rx_frame_error;
wire 		 tx_fifo_wr_en;
wire		 tx_fifo_rd_en;
wire 		 rx_fifo_rd_en;
wire		 rx_fifo_wr_en;


FIFO fifo_rx(
.clk(clk) , .reset(reset) , .wr_en(rx_fifo_wr_en),
.rd_en(rx_fifo_rd_en) ,
.data_in(rx_data),
.data_out(rx_fifo_data),
.full_flag(rx_fifo_full) , 
.empty_flag(rx_fifo_empty)
);


FIFO fifo_tx(
.clk(clk) , .reset(reset) , .wr_en(tx_fifo_wr_en),
.rd_en(tx_fifo_rd_en),
.data_in(tx_fifo_data),
.data_out(tx_fifo_data_out),
.full_flag(tx_fifo_full) , 
.empty_flag(tx_fifo_empty)
);

uart_tx uart_tx(
.clk(clk) , .reset(reset) ,
.UART_en(uart_enable), .tx_en(tx_enable),
.fifo_empty(tx_fifo_empty) , .fifo_data(tx_fifo_data_out) ,
.baud_tick(baud_tick) , .tx(tx),
.tx_busy(tx_busy) , .fifo_rd_en(tx_fifo_rd_en)
);


uart_rx uart_rx(
.clk(clk) , .reset(reset) ,
.rx(rx) , .UART_en(uart_enable) ,
.rx_en(rx_enable) , .baud_tick(baud_tick),
.fifo_wr_en(rx_fifo_wr_en) , .rx_data(rx_data) , 
.rx_frame_error(rx_frame_error)
);


uart_regs regs(
.clk(clk) , .reset(reset) ,
.addr(addr) , .wr_en(wr_en) , .rd_en(rd_en),
.wdata(wdata) , .rx_fifo_data(rx_fifo_data),
.rx_fifo_full(rx_fifo_full) , .rx_fifo_empty(rx_fifo_empty),
.tx_fifo_full(tx_fifo_full) , .tx_fifo_empty(tx_fifo_empty),
.rx_frame_error(rx_frame_error), .tx_busy(tx_busy) ,
.tx_fifo_data(tx_fifo_data), .rdata(rdata),
.rx_fifo_rd_en(rx_fifo_rd_en) , .tx_fifo_wr_en(tx_fifo_wr_en),
.uart_enable(uart_enable) , .tx_enable(tx_enable) ,
.rx_enable(rx_enable), .baud_div(baud_div)
);



baud_gen baudgenerator(
.clk(clk) , .reset(reset) ,
.baud_div(baud_div) , 
.baud_tick(baud_tick)
);

endmodule

