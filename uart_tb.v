`timescale 1ns/1ps
module uart_tb;

reg clk, reset;
reg [3:0] addr;
reg wr_en, rd_en;
reg rx;
reg [7:0] wdata;
reg loopback;

wire [7:0] rdata;
wire tx;
wire irq;
wire rx_loopback;

assign rx_loopback = loopback ? tx : rx;


// For Testing
reg T1_pass, T2_pass, T3_pass, T4_pass;
reg T5_pass, T6_pass, T7_pass, T8_pass;
reg T9_pass, T10_pass, T11_pass;
reg T8_error_seen;
reg T9_control_ok;
reg T9_baud_ok;
reg T9_status_ok;

uart_top uut(
.clk(clk) , .reset(reset),
.addr(addr) , .wdata(wdata),
.wr_en(wr_en) , .rx(rx_loopback) ,  .rd_en(rd_en),
.rdata(rdata) , .tx(tx) , .irq(irq)
);

reg [7:0] rx_mem [0:15];
integer i;


always @(uut.fifo_tx.count)
begin
    if (uut.fifo_tx.count == 5'd16)
        T4_pass = 1;
end

initial clk = 0;
always #100 clk=~clk;

always @(posedge clk)
	begin
		if (uut.rx_frame_error)
			T8_error_seen = 1;
	end
	


initial 
	begin
		// Initialization
		addr = 0;
		wr_en = 0;
		rd_en = 0;
		rx = 1;
		wdata = 0;
		T1_pass = 0;
		T2_pass = 0;
		T3_pass = 0;
		T4_pass = 0;
		T5_pass = 0;
		T6_pass = 0;
		T7_pass = 0;
		T8_pass = 0;
		T9_pass = 0;
		T10_pass = 0;
		T11_pass = 0;
		T8_error_seen = 0;
		T9_control_ok = 0;
		T9_baud_ok = 0;
		T9_status_ok = 0;
		loopback = 0;
		
		// T1 
		reset=1;
		@(negedge clk) reset=0;
		if (uut.tx_fifo_empty && uut.rx_fifo_empty && tx == 1'b1)
        T1_pass = 1;
		
		
		// T2
		#100 
			addr=4'h0;
			wdata = 8'hA5;
			wr_en=1;
		
		@(negedge clk) wr_en=0;
		
		#15000000;
		if (uut.tx_fifo_empty && !uut.tx_busy)
		T2_pass = 1;

		
		// T3
		#100 
			addr=4'h0;
			wdata = 8'h07;
			wr_en=1;
		@(negedge clk) wr_en=0;
		
		#100 
			addr=4'h0;
			wdata = 8'hB9;
			wr_en=1;
		@(negedge clk) wr_en=0;
		
		#100 
			addr=4'h0;
			wdata = 8'hFF;
			wr_en=1;
		@(negedge clk) wr_en=0;
		
		#100 
			addr=4'h0;
			wdata = 8'hAB;
			wr_en=1;
		@(negedge clk) wr_en=0;
		
		#60000000;
		if (uut.tx_fifo_empty && !uut.tx_busy)
		T3_pass = 1;
		
		#50 reset=1;
		@(negedge clk) reset=0;
		

		
		
		// T4
		#100 addr=4'h0; wdata=8'h01; wr_en=1; 
		@(negedge clk) wr_en=0;
		#100 addr=4'h0; wdata=8'h02; wr_en=1; 
		@(negedge clk) wr_en=0;
		#100 addr=4'h0; wdata=8'h03; wr_en=1;
		@(negedge clk) wr_en=0;
		#100 addr=4'h0; wdata=8'h04; wr_en=1;
		@(negedge clk) wr_en=0;
		#100 addr=4'h0; wdata=8'h05; wr_en=1;
		@(negedge clk) wr_en=0;
		#100 addr=4'h0; wdata=8'h06; wr_en=1; 
		@(negedge clk) wr_en=0;
		#100 addr=4'h0; wdata=8'h07; wr_en=1; 
		@(negedge clk) wr_en=0;
		#100 addr=4'h0; wdata=8'h08; wr_en=1;
		@(negedge clk) wr_en=0;
		#100 addr=4'h0; wdata=8'h09; wr_en=1;
		@(negedge clk) wr_en=0;
		#100 addr=4'h0; wdata=8'h0A; wr_en=1; 
		@(negedge clk) wr_en=0;
		#100 addr=4'h0; wdata=8'h0B; wr_en=1;
		@(negedge clk) wr_en=0;
		#100 addr=4'h0; wdata=8'h0C; wr_en=1;
		@(negedge clk) wr_en=0;
		#100 addr=4'h0; wdata=8'h0D; wr_en=1;
		@(negedge clk) wr_en=0;
		#100 addr=4'h0; wdata=8'h0E; wr_en=1; 
		@(negedge clk) wr_en=0;
		#100 addr=4'h0; wdata=8'h0F; wr_en=1;
		@(negedge clk) wr_en=0;
		#100 addr=4'h0; wdata=8'h10; wr_en=1;
		@(negedge clk) wr_en=0;
		#100 addr=4'h0; wdata=8'hFF; wr_en=1;
		@(negedge clk) wr_en=0;
		#1000;
		reset = 1;
		@(negedge clk) reset = 0;
		
		
		// T5
		#100;
		rx=1;                    // Idle
		#1382400; rx=0;          // Start
		#1382400; rx=0;          // D0
		#1382400; rx=0;          // D1
		#1382400; rx=1;          // D2
		#1382400; rx=1;          // D3
		#1382400; rx=0;          // D4
		#1382400; rx=1;          // D5
		#1382400; rx=0;          // D6
		#1382400; rx=1;          // D7
		#1382400; rx=1;          // Stop
		#1382400;
		#3000000;

		addr=4'h4;
		rd_en=1;
		#1;

		if (rdata == 8'hAC)
			T5_pass = 1;

		rd_en=0;
		reset = 1;
		@(posedge clk);
		reset = 0;

		
		
		// T6
		// AC
		#1382400;#1382400; rx=1;   // Idle
		#1382400; rx=0;   // Start
		#1382400; rx=0;   // D0
		#1382400; rx=0;   // D1
		#1382400; rx=1;   // D2
		#1382400; rx=1;   // D3
		#1382400; rx=0;   // D4
		#1382400; rx=1;   // D5
		#1382400; rx=0;   // D6
		#1382400; rx=1;   // D7
		#1382400; rx=1;   // Stop
	    
		// 35
		#1382400; rx=0;   // Start
		#1382400; rx=1;   // D0
		#1382400; rx=0;   // D1
		#1382400; rx=1;   // D2
		#1382400; rx=0;   // D3
		#1382400; rx=1;   // D4
		#1382400; rx=1;   // D5
		#1382400; rx=0;   // D6
		#1382400; rx=0;   // D7
		#1382400; rx=1;   // Stop

		// 7F
		#1382400; rx=0;   // Start
		#1382400; rx=1;   // D0
		#1382400; rx=1;   // D1
		#1382400; rx=1;   // D2
		#1382400; rx=1;   // D3
		#1382400; rx=1;   // D4
		#1382400; rx=1;   // D5
		#1382400; rx=1;   // D6
		#1382400; rx=0;   // D7
		#1382400; rx=1;   // Stop
		
		// 12
		#1382400; rx=0;   // Start
		#1382400; rx=0;   // D0
		#1382400; rx=1;   // D1
		#1382400; rx=0;   // D2
		#1382400; rx=0;   // D3
		#1382400; rx=1;   // D4
		#1382400; rx=0;   // D5
		#1382400; rx=0;   // D6
		#1382400; rx=0;   // D7
		#1382400; rx=1;   // Stop
		#3000000;

		// READ 1
		addr = 4'h4;
		rd_en = 1;
		#1;
		if (rdata == 8'hAC)
			T6_pass = 1;
		else
			T6_pass = 0;

		@(posedge clk);
		rd_en = 0;


		// READ 2
		addr = 4'h4;
		rd_en = 1;
		#1;
		if (rdata == 8'h35)
			T6_pass = T6_pass;
		else
			T6_pass = 0;

		@(posedge clk);
		rd_en = 0;


		// READ 3
		addr = 4'h4;
		rd_en = 1;
		#1;
		if (rdata == 8'h7F)
			T6_pass = T6_pass;
		else
			T6_pass = 0;

		@(posedge clk);
		rd_en = 0;


		// READ 4
		addr = 4'h4;
		rd_en = 1;
		#1;
		if (rdata == 8'h12)
			T6_pass = T6_pass;
		else
			T6_pass = 0;

		@(posedge clk);
		rd_en = 0;
		
		reset = 1;
		@(posedge clk);
		reset = 0;

		
		// T7
		$readmemh("rx_data.txt", rx_mem);
		for(i=0; i<16; i=i+1)
				begin
					// Start bit
					rx = 0;
					#1382400;
					// 8 data bits
					rx = rx_mem[i][0];
					#1382400;
					rx = rx_mem[i][1];
					#1382400;
					rx = rx_mem[i][2];
					#1382400;
					rx = rx_mem[i][3];
					#1382400;
					rx = rx_mem[i][4];
					#1382400;
					rx = rx_mem[i][5];
					#1382400;
					rx = rx_mem[i][6];
					#1382400;
					rx = rx_mem[i][7];
					#1382400;
					// Stop bit
					rx = 1;
					#1382400;
				end
			
			// 17th byte
			rx = 0;       // Start
			#1382400;
			rx = 1;       // D0
			#1382400;
			rx = 1;       // D1
			#1382400;
			rx = 1;       // D2
			#1382400;
			rx = 1;       // D3
			#1382400;
			rx = 1;       // D4
			#1382400;
			rx = 1;       // D5
			#1382400;
			rx = 1;       // D6
			#1382400;
			rx = 1;       // D7
			#1382400;
			rx = 1;       // Stop
			#1382400;
			#3000000;
			
			if (uut.rx_fifo_full)
			T7_pass = 1;

			
		// T8
			rx = 0;       // Start
			#1382400;
			rx = 1;       // D0
			#1382400;
			rx = 1;       // D1
			#1382400;
			rx = 1;       // D2
			#1382400;
			rx = 0;       // D3
			#1382400;
			rx = 0;       // D4
			#1382400;
			rx = 1;       // D5
			#1382400;
			rx = 1;       // D6
			#1382400;
			rx = 1;       // D7
			#1382400;
			rx = 0;       // Stop
			#1382400;
			
			#3000000;
			if (T8_error_seen)
			T8_pass = 1;
			
			reset = 1;
			@(posedge clk);
			reset = 0;
		
			
		// T9
		rx = 1;
		reset = 1;
		repeat(2) @(posedge clk);
		reset = 0;
		
		// CONTROL
		addr = 4'hC;
		wdata = 8'h07;
		wr_en = 1;
		@(posedge clk);
		#1;
		wr_en = 0;
		addr = 4'hC;
		rd_en = 1;
		#1;
		if (rdata == 8'h07)
			T9_control_ok = 1;

		rd_en = 0;

		// BAUD_DIV
		addr = 4'hD;
		wdata = 8'h14;
		wr_en = 1;
		@(posedge clk);
		#1;
		wr_en = 0;
		addr = 4'hD;
		rd_en = 1;
		#1;
		if (rdata == 8'h14)
			T9_baud_ok = 1;

		rd_en = 0;


		// STATUS
		addr = 4'h8;
		rd_en = 1;
		#1;
		if (rdata == 8'h14)
			T9_status_ok = 1;
		rd_en = 0;


		if (T9_control_ok && T9_baud_ok && T9_status_ok)
			T9_pass = 1;
			
		reset = 1;
		@(posedge clk);
		reset = 0;
			
		
		// T10
		// BAUD_DIV = 10
		addr = 4'hD;
		wdata = 8'd10;
		wr_en = 1;
		@(posedge clk);
		#1;
		wr_en = 0;

		addr = 4'h0;
		wdata = 8'hA5;
		wr_en = 1;
		@(posedge clk);
		#1;
		wr_en = 0;

		#320000;


		// BAUD_DIV = 20
		addr = 4'hD;
		wdata = 8'd20;
		wr_en = 1;
		@(posedge clk);
		#1;
		wr_en = 0;

		addr = 4'h0;
		wdata = 8'hA5;
		wr_en = 1;
		@(posedge clk);
		#1;
		wr_en = 0;

		#640000;

		if (uut.baud_div == 8'd20)
			T10_pass = 1;
			
		reset = 1;
		@(posedge clk);
		reset = 0;

			
		// T11 FULL-DUPLEX

		rx = 1;
		loopback = 1;

		// Reset while loopback is already active
		reset = 1;
		repeat(2) @(posedge clk);
		reset = 0;

		// Make sure bus is idle
		addr = 4'h0;
		wdata = 8'h00;
		wr_en = 0;
		rd_en = 0;

		#100;

		// Send A5
		addr = 4'h0;
		wdata = 8'hA5;
		wr_en = 1;

		@(posedge clk);
		#1;
		wr_en = 0;

		// Wait for complete TX + RX
		#15000000;

		// Read RX_DATA
		addr = 4'h4;
		rd_en = 1;
		#1;

	

		if (rdata == 8'hA5)
		begin
			T11_pass = 1;
		end
		else
		begin
			T11_pass = 0;
		end

		rd_en = 0;
		loopback = 0;





///////////////////////////////////////////////////////////////////////
		
		$display("======================================");
		$display("        UART TESTBENCH RESULTS");
		$display("======================================");

		if (T1_pass)
			$display("T1  RESET            : PASS");
		else
			$display("T1  RESET            : FAIL");

		if (T2_pass)
			$display("T2  SINGLE-BYTE TX   : PASS");
		else
			$display("T2  SINGLE-BYTE TX   : FAIL");

		if (T3_pass)
			$display("T3  MULTIPLE-BYTE TX : PASS");
		else
			$display("T3  MULTIPLE-BYTE TX : FAIL");

		if (T4_pass)
			$display("T4  TX FIFO FULL     : PASS");
		else
			$display("T4  TX FIFO FULL     : FAIL");

		if (T5_pass)
			$display("T5  SINGLE-BYTE RX   : PASS");
		else
			$display("T5  SINGLE-BYTE RX   : FAIL");

		if (T6_pass)
			$display("T6  MULTIPLE-BYTE RX : PASS");
		else
			$display("T6  MULTIPLE-BYTE RX : FAIL");

		if (T7_pass)
			$display("T7  RX FIFO FULL     : PASS");
		else
			$display("T7  RX FIFO FULL     : FAIL");

		if (T8_pass)
			$display("T8  BAD STOP BIT     : PASS");
		else
			$display("T8  BAD STOP BIT     : FAIL");

		if (T9_pass)
			$display("T9  REGISTER ACCESS  : PASS");
		else
			$display("T9  REGISTER ACCESS  : FAIL");

		if (T10_pass)
			$display("T10 BAUD SCALING     : PASS");
		else
			$display("T10 BAUD SCALING     : FAIL");

		if (T11_pass)
			$display("T11 FULL-DUPLEX      : PASS");
		else
			$display("T11 FULL-DUPLEX      : FAIL");

		$display("======================================");

		$finish;
			
	end
endmodule