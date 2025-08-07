module router_fifo(clock,resetn,write_enb,soft_reset,read_enb,lfd_state,data_in,data_out,empty,full);
input clock,resetn,write_enb,soft_reset,read_enb,lfd_state;
input [7:0]data_in;
output reg[7:0]data_out;
output empty,full;
reg [8:0]fifo[15:0];
reg [3:0]r_ptr,w_ptr;
reg [7:0]count;
integer i;
reg temp_lfd;
//Write Logic
always@(posedge clock)
begin
	if(!resetn)
	begin
	w_ptr<=4'b0000;
		for(i=0;i<16;i=i+1)
			
			fifo[i]<=0;
	end
	else if(soft_reset)
	begin
	w_ptr<=4'b0000;
		for(i=0;i<16;i=i+1)
		fifo[i]<=0;
	end
	else if(write_enb && !full)
	begin
	//w_ptr<=4'b0000;
	//temp_lfd<=lfd_state;
		fifo[w_ptr[3:0]]<={temp_lfd,data_in};
		w_ptr<=w_ptr+4'b1;
	end
	else
		fifo[w_ptr[3:0]]<={fifo[w_ptr[3:0]][8],fifo[w_ptr[3:0]][7:0]};
		
end

//Read Logic
always@(posedge clock)
begin
	if(!resetn)
	begin
	r_ptr<=4'b0000;
		data_out<=8'b0;
	end
	else if(soft_reset)
	begin
	r_ptr<=4'b0000;
		data_out<=8'bzzzzzzzz;
	end
	//else if(count==0&&data_out!=0)
	//begin
	//r_ptr<=4'b0000;
		//data_out<=8'bzzzzzzzz;
	//end
	else if(read_enb && !empty)
	begin

	
		data_out<=fifo[r_ptr[3:0]];
		r_ptr<=r_ptr+1'b1;
	end
end
always@(posedge clock)
begin
if(!resetn)
temp_lfd<=0;
else if(soft_reset)
temp_lfd<=0;
else
temp_lfd<=lfd_state;
end

//Internal counter
always@(posedge clock)
begin
	if(!resetn)
		count<=7'b0;
	else if(soft_reset)
		count<=7'b0;
	else if(read_enb && ~empty)
		if(fifo[r_ptr[3:0]][8]==1'b1)
			count<=fifo[r_ptr[3:0]][7:2]+8'h1;
		else if(count!=4'h0)
				count<=count-8'b1;

end
assign full=(w_ptr==4'd15) && (r_ptr==0);
assign empty=(w_ptr==r_ptr);
endmodule
	





