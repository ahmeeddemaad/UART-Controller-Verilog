module uart_rx(
input       clk, reset,
input       rx,
input       UART_en,
input       rx_en,
input       baud_tick,
output reg  fifo_wr_en,
output reg  [7:0] rx_data,
output reg  rx_frame_error
);

parameter IDLE  = 2'b00;
parameter START = 2'b01;
parameter DATA  = 2'b10;
parameter STOP  = 2'b11;

reg rx_prev;
reg [7:0] uart_data;
reg [1:0] status;
reg [3:0] tick_count;
reg [3:0] bit_count;

reg write_pending;


always @(posedge clk)
begin

    if(reset)
    begin
        uart_data      <= 8'b0;
        rx_frame_error <= 0;
        bit_count      <= 0;
        tick_count     <= 0;
        rx_prev        <= 1'b1;
        rx_data        <= 8'b0;
        status         <= IDLE;
        fifo_wr_en     <= 0;
        write_pending  <= 0;
    end

    else
    begin

        rx_prev <= rx;

        if(write_pending)
			begin
				fifo_wr_en <= 1;
				write_pending <= 0;
			end
		else
			begin
				fifo_wr_en <= 0;
			end

        case(status)

        IDLE:
        begin
            rx_frame_error <= 0;
            bit_count <= 0;

            if(rx_prev && !rx && UART_en && rx_en)
            begin
                status <= START;
                tick_count <= 0;
            end
            else
            begin
                status <= IDLE;
            end
        end


        START:
        begin
            if(baud_tick)
            begin

                if(tick_count == 7)
                begin
                    if(rx == 0)
                    begin
                        status <= DATA;
                        tick_count <= 0;
                        bit_count <= 0;
                    end

                    else
                    begin
                        status <= IDLE;
                        tick_count <= 0;
                    end
                end

                else
                begin
                    tick_count <= tick_count + 1;
                    status <= START;
                end

            end
        end


        DATA:
        begin
            if(baud_tick)
            begin
                tick_count <= tick_count + 1;

                if(tick_count == 15)
                begin

                    // LSB first
                    uart_data[bit_count] <= rx;

                    if(bit_count == 7)
                    begin
                        status <= STOP;
                        tick_count <= 0;
                    end

                    else
                    begin
                        bit_count <= bit_count + 1;
                        status <= DATA;
                        tick_count <= 0;
                    end

                end
            end
        end


        STOP:
        begin
            if(baud_tick)
            begin
                tick_count <= tick_count + 1;

                if(tick_count == 15)
                begin

                    if(rx == 1)
                    begin
                        // Valid stop bit
                        rx_data <= uart_data;
                        write_pending <= 1;
                    end

                    else
                    begin
                        rx_frame_error <= 1;
                    end

                    status <= IDLE;
                    tick_count <= 0;

                end
            end
        end

        endcase
    end

end

endmodule