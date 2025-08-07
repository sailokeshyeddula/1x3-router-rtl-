module router_reg(input clock,resetn,pkt_valid,fifo_full,rst_int_reg,detect_add,ld_state,laf_state,full_state,lfd_state,input [7:0]data_in,output reg parity_done,low_pkt_valid,err,output reg [7:0]dout);

reg [7:0]full_state_byte;
reg [7:0]header,packet_parity,internal_parity;

//dout logic

always@(posedge clock)
begin
	if(!resetn)
		dout<=8'b0;
	else if (detect_add && pkt_valid && data_in[1:0] !=3)
		dout<=dout;
	else if (lfd_state)
		dout<=header;
	else if(ld_state && ~fifo_full)
		dout<=data_in;
	else if(ld_state && fifo_full)
		dout<=dout;
	else if (laf_state)
		dout<=full_state_byte;
end

//register header logic

always@(posedge clock)
begin
	if(!resetn)
		header<=8'b0;
	else if(detect_add && pkt_valid && data_in[1:0]!=3)
		header<=data_in;
end

//register full stage logic

always@(posedge clock)
begin
	if(!resetn)
		internal_parity<=0;
	else if(detect_add)
		internal_parity<=0;
	else if(lfd_state)
		internal_parity<=internal_parity ^ header;
	else if(pkt_valid && ld_state && ~full_state)
		internal_parity<=internal_parity^ data_in;
end

//packet_parity calculation

always@(posedge clock)
begin
	if(!resetn)
		packet_parity<=8'b0;
	else if(detect_add)
		packet_parity<=8'b0;
	else if(ld_state && ~pkt_valid)
		packet_parity <= data_in;
end

//parity_done

always@(posedge clock)
begin
	if(!resetn)
		parity_done<=0;
	else if(ld_state == 1'b1 && fifo_full==1'b0 && pkt_valid==0)
		parity_done <= 1'b1;
	else if (laf_state == 1'b1 && low_pkt_valid == 1'b1 && parity_done == 1'b0)
		parity_done <= 1'b1;
end

//low_pkt_valid

always@(posedge clock)
begin
	if(!resetn)
		low_pkt_valid <=1'b0;
	else if (rst_int_reg)
		low_pkt_valid<=1'b0;
	else if (ld_state==1'b1 && pkt_valid == 1'b0)
		low_pkt_valid <= 1'b0;
end

//err

always@(posedge clock)
begin
	if(!resetn)
		err<=1'b0;
	else if(packet_parity && ~internal_parity)
		err<=1'b1;
end

//full state byte

always@(posedge clock)
begin
	if (!resetn)
		full_state_byte<=8'b0;
	else if(full_state ==1'b1)
		full_state_byte<=data_in;
end

endmodule
