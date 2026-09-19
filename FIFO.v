module FIFO(
    input clk,
    input reset,
    input [7:0] data_in,
    output reg [7:0] data_out,
    input wr_en,
    input rd_en,
    output reg full_flag,
    output reg empty_flag
);

reg [4:0] count;
reg [3:0] wr_ptr;
reg [3:0] rd_ptr;
reg [7:0] mem [0:15];

always @(posedge clk)
begin
    if (reset)
		begin
			count      <= 5'd0;
			wr_ptr     <= 4'd0;
			rd_ptr     <= 4'd0;
		end
    else
			begin
			if(wr_en && !rd_en && !full_flag)
				begin
				mem[wr_ptr]<=data_in;
				count<=count+1;
				wr_ptr<=wr_ptr+1;
				end
			else if (rd_en && !wr_en && !empty_flag)
				begin
				count<=count-1;
				rd_ptr<=rd_ptr+1;
				end
					
			else if(rd_en == 1 && wr_en== 1 && !full_flag && !empty_flag)
				begin
				mem[wr_ptr]<=data_in;
				rd_ptr<=rd_ptr+1;
				wr_ptr<=wr_ptr+1;
				end
			end
end
	
always @ (*)
	begin
			data_out = mem[rd_ptr];
			
			// Update flags
			if (count == 5'd16)
			begin
				full_flag  = 1'b1;
				empty_flag = 1'b0;
			end
			else if (count == 5'd0)
			begin
				full_flag  = 1'b0;
				empty_flag = 1'b1;
			end
			else
			begin
				full_flag  = 1'b0;
				empty_flag = 1'b0;
			end
	end
    

endmodule