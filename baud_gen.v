module baud_gen(
    input clk,reset,
    input [7:0] baud_div,
    output reg baud_tick
);

reg [15:0] counter;

always@(posedge clk)
	begin
	if(reset)
		begin
		counter<=0;
		baud_tick<=0;
		end
	else
		if (baud_div==0)
			begin
				baud_tick<=0;
				counter<=0;
			end
			
		else
			begin
			counter<=counter+1;
			if(counter==(baud_div*16)-1)
				begin
					baud_tick<=1'b1;
					counter<=0;
				end
				
			else
				baud_tick<=1'b0;
			end	
		
	end
endmodule