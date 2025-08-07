module router_sync_tb();
reg clock,resetn,detect_add,write_enb_reg,read_enb_0,read_enb_1,read_enb_2,full_0,full_1,full_2,empty_0,empty_1,empty_2;
reg [1:0]data_in;
wire fifo_full,soft_reset_0,soft_reset_1,soft_reset_2;
wire vld_out_0,vld_out_1,vld_out_2;
wire [2:0]write_enb;

//reg [1:0]temp;
//reg [5:0]count_0,count_1,count_2;

router_sync DUT(clock,resetn,detect_add,write_enb_reg,read_enb_0,read_enb_1,read_enb_2,full_0,full_1,full_2,empty_0,empty_1,empty_2, data_in,fifo_full,soft_reset_0,soft_reset_1,soft_reset_2,vld_out_0,vld_out_1,vld_out_2,write_enb);

//clock generation
initial
begin
	clock=1'b0;
	forever 
	#10
	clock=~clock;
end

//rst task 

task rst;
	begin
		@(negedge clock)
		resetn<=1'b0;
		@(negedge clock)
		resetn<=1'b1;
	end
endtask

//generation of inputs

initial
begin
	rst;
	@(negedge clock)
	detect_add <=1'b1;
	data_in<=2'b10;
	@(negedge clock)
	detect_add <=1'b0;
	write_enb_reg <=1'b1;
	@(negedge clock)
	{full_0,full_1,full_2}=3'b001;
	@(negedge clock)
	{empty_0,empty_1,empty_2}<=3'b110;
	#700;
	@(negedge clock)
	{read_enb_0,read_enb_1,read_enb_2}<=3'b001;
end
initial
begin
	$monitor("fifo_full = %b, soft_reset_0 = %b ,soft_reset_1 = %b, soft_reset_2= %b ,vld_out_0= %b ,vld_out_1 = %b,vld_out_2 = %b ,write_enb = %b ",fifo_full,soft_reset_0,soft_reset_1,soft_reset_2,vld_out_0,vld_out_1,vld_out_2,write_enb);
end
endmodule
