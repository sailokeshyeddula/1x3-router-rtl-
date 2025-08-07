module router_sync(input clock,resetn,detect_add,write_enb_reg,read_enb_0,read_enb_1,read_enb_2,full_0,full_1,full_2,empty_0,empty_1,empty_2,input [1:0]data_in,output reg fifo_full,soft_reset_0,soft_reset_1,soft_reset_2,output vld_out_0,vld_out_1,vld_out_2,output reg [2:0]write_enb);
reg [1:0]temp;
reg [5:0]count_0,count_1,count_2;

//generating address

always@(posedge clock)
begin
	if(!resetn)
		temp <=  2'b0;
	else if(detect_add)
		temp <= data_in;
end

//generating write enable 

always@(*)
begin
	if(write_enb_reg)
	begin
		case(temp)
			2'b00:write_enb = 3'b001;
			2'b01:write_enb = 3'b010;
		        2'b10:write_enb = 3'b100;
		        2'b11:write_enb = 3'b000;
		endcase
	end
	else
		write_enb = 3'b000;
end

//generating fifo full
 

always@(*)
begin
	case(temp)
		2'b00:fifo_full = full_0;
		2'b01:fifo_full = full_1;
		2'b10:fifo_full = full_2;
		2'b11:fifo_full = 0;
	endcase
end

// generating valid signals

assign vld_out_0=~empty_0;
assign vld_out_1=~empty_1;
assign vld_out_2=~empty_2;

// generating soft_reset0 and count 30 cycles

always@(posedge clock)
begin
	if(!resetn)
	begin
		count_0 <=5'b00001;
		soft_reset_0 <= 1'b0;
	end	
	else if (!vld_out_0)
	begin
		count_0 <=5'b1;
		soft_reset_0 <= 1'b0;
	end
	else if (read_enb_0)
	begin
		count_0 <=5'b1;
		soft_reset_0 <= 1'b0;
	end
	else if (count_0 == 5'd30)
	begin
		count_0 <=5'b1;
		soft_reset_0 <= 1'b1;
	end
	else
	begin
		count_0 <= count_0 + 5'b1;
		soft_reset_0 <= 1'b0;
	end
end
 
// generating soft_reset_1 and count 30 cycles


always@(posedge clock)
begin
	if(!resetn)
	begin
		count_1 <=5'b1;
		soft_reset_1 <= 1'b0;
	end
	else if (!vld_out_1)
	begin
		count_1 <=5'b1;
		soft_reset_1 <= 1'b0;
	end
	else if (read_enb_1)
	begin
		count_1 <=5'b1;
		soft_reset_1 <= 1'b0;
	end
	else if (count_1 == 5'd30)
	begin
		count_1 <=5'b1;
		soft_reset_1 <= 1'b1;
	end
	else
	begin
		count_1 <= count_1 + 5'b1;
		soft_reset_1 <= 1'b0;
	end
end

// generating soft_reset_2 and count 30 cycles
 
always@(posedge clock)
begin
	if(!resetn)
	begin
		count_2 <=5'b1;
		soft_reset_2 <= 1'b0;
	end
	else if (!vld_out_2)
	begin
		count_2 <=5'b1;
		soft_reset_2 <= 1'b0;
	end
	else if (read_enb_2)
		begin
		count_2 <=5'b1;
		soft_reset_2 <= 1'b0;
	end
	else if (count_2 == 5'd30)
		begin
		count_2 <=5'b1;
		soft_reset_2 <= 1'b1;
		end
	else
	begin
		count_2 <= count_2 + 5'b1;
		soft_reset_2 <= 1'b0;
	end
end
endmodule


