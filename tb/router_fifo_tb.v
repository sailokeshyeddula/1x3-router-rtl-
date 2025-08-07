module router_fifo_tb();
reg clock,resetn,write_enb,soft_reset,read_enb,lfd_state;
reg [7:0]data_in;
wire [7:0]data_out;
wire empty,full;


/*reg [3:0]w_ptr,r_ptr;
reg [8:0]fifo[15:0];
integer i;
reg [7:0]count;
*/

router_fifo DUT(clock,resetn,write_enb,soft_reset,read_enb,lfd_state,data_in,data_out,empty,full);

//clock generation
initial
begin
	clock=1'b0;
	forever
	#5
	clock=~clock;
end

//reset task

task rst;
	begin
		@(negedge clock)
		resetn<=1'b0;
		@(negedge clock)
		resetn<=1'b1;
	end
endtask

//soft_reset task

task sftrst;
	begin
		@(negedge clock)
		soft_reset<=1'b1;
		@(negedge clock)
		soft_reset<=1'b0;
	end
endtask

//write_task

task write;
	reg [7:0]payload_data,parity,header;
	reg [5:0]payload_len;
	reg [1:0]addr;
	integer k;
	begin
		@(negedge clock)
		payload_len=6'd14;
		addr=2'b01;
		header={payload_len,addr};
		data_in=header;
		lfd_state=1'b1;
		write_enb=1'b1;
		for(k=0;k<payload_len;k=k+1)
		begin
			@(negedge clock)
			lfd_state = 1'b0;
			payload_data={$random}%256;
			data_in=payload_data;
		end
		@(negedge clock)
		parity={$random}%256;
		data_in=parity;
	end
endtask

//read_task

task read;
begin
	@(negedge clock)
	read_enb<=1'b1;
end
endtask

initial
begin
	rst;
	sftrst;
	write;
	read;
	#30;
	write;
	read;
	write;
	read;
end

initial
$monitor("full=%b, empty=%b ",full,empty);
endmodule


