module router_top_tb();
reg clock,resetn,read_enb_0,read_enb_1,read_enb_2,pkt_valid;
reg [7:0]data_in;
wire vld_out_0,vld_out_1,vld_out_2,error,busy;
wire [7:0]data_out_0,data_out_1,data_out_2;
event e1,e2;
integer i;

router_top DUT ( clock,resetn,read_enb_0,read_enb_1,read_enb_2,pkt_valid,data_in, vld_out_0,vld_out_1,vld_out_2,error,busy,data_out_0,data_out_1,data_out_2);

//clock generation

initial
begin
	clock<=1'b0;
	forever #10 clock=~clock;
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

//initialization task
task initialize;
begin
@(negedge clock)
read_enb_0=1'b0;
read_enb_1=1'b0;
read_enb_2=1'b0;
end
endtask
/*
//task for payloadlength = 14

task pkt_gen_14_1;
	reg [7:0]payload_data,parity,header;
	reg [5:0] payload_len;
	reg[1:0]addr;
	integer i; 
	
	begin
		@(negedge clock);
		payload_len=6'd14;
		addr=2'b01;
		header ={payload_len,addr};
		parity=8'b0;
		data_in = header;
		pkt_valid=1'b1;
		parity=parity^header;
		@(negedge clock)
		wait(~busy)
		for (i=0;i<payload_len;i=i+1)
		begin
			@(negedge clock)
			wait(~busy)
			payload_data={$random}%256;
			data_in=payload_data;
			parity=parity^payload_data;
		end
		@(negedge clock)
		wait(~busy)
		pkt_valid=1'b0;
		data_in=parity;
	end
endtask

 
//task for payloadlength = 16

task pkt_gen_16_1;
	reg [7:0]payload_data,parity,header;
	reg [5:0] payload_len;
	reg[1:0]addr;
	integer i;
	
	begin
		@(negedge clock);
		payload_len=6'd16;
		addr=2'b01;
		header ={payload_len,addr};
		parity=8'b0;
		data_in = header;
		pkt_valid=1'b1;
		parity=parity^header;
		@(negedge clock)
		wait(~busy)
		for (i=0;i<payload_len;i=i+1)
		begin
			@(negedge clock)
			wait(~busy)
			payload_data={$random}%256;
			data_in=payload_data;
			parity=parity^payload_data;
		end
		@(negedge clock)
		wait(~busy)
		pkt_valid=1'b0;
		data_in=parity;
	end
endtask 

//task for payloadlength = 17
task pkt_gen_17_1;
	reg [7:0]payload_data,parity,header;
	reg [5:0] payload_len;
	reg[1:0]addr;
	integer i;
	
	begin
	@(negedge clock)
	wait(~busy)
	@(negedge clock)
	payload_len = 6'd17;
	addr =2'b01;
	header={payload_len,addr};
	parity=0;
	data_in=header;
	pkt_valid=1;
	parity=parity^header;
	@(negedge clock)
	wait(~busy)
	for (i=0;i<payload_len;i=i+1)
	begin
	@(negedge clock)
	wait(~busy)
	payload_data={$random}%256;
	data_in=payload_data;
	parity=parity^payload_data;
	end
	//-> e1;
	begin
	@(negedge clock)
	wait(~busy)
	pkt_valid=0;
	data_in=parity;
	end
	end
	
endtask


//task for payloadlength < 14

task pkt_gen_12_1;
	reg [7:0]payload_data,parity,header;
	reg [5:0] payload_len;
	reg[1:0]addr;
	integer i; 
	
	begin
		@(negedge clock);
		payload_len=6'd12;
		addr=2'b01;
		header ={payload_len,addr};
		parity=8'b0;
		data_in = header;
		pkt_valid=1'b1;
		parity=parity^header;
		@(negedge clock)
		wait(~busy)
		for (i=0;i<payload_len;i=i+1)
		begin
			@(negedge clock)
			wait(~busy)
			payload_data={$random}%256;
			data_in=payload_data;
			parity=parity^payload_data;
		end
		@(negedge clock)
		wait(~busy)
		pkt_valid=1'b0;
		data_in=parity;
	end
endtask*/

//task for payloadlength = 14




	//task fot payload len<14
	task pkt_gen_14;
		reg[7:0]payload_data,parity,header;
		reg[5:0]payload_len;
		reg[1:0]addr;
		begin
			@(negedge clock)
			wait(~busy)
			@(negedge clock)
			payload_len=6'd3;
			addr=2'b00;//valid packet
			header={payload_len,addr};
			parity=1'b0;
			data_in=header;
			pkt_valid=1'b1;
			parity=parity^header;
			@(negedge clock)
			wait(~busy)
			for(i=0;i<payload_len;i=i+1)
			begin
			@(negedge clock)
			wait(~busy)
			payload_data={$random}%256;
			data_in=payload_data;
			parity=parity^payload_data;
			end
			@(negedge clock)
			wait(~busy)
			pkt_valid=1'b0;
			data_in=parity;
		end
	endtask       
    	//task for payload len =16	
	task pkt_gen_16;
                reg[7:0]payload_data,parity,header;
                reg[5:0]payload_len;
                reg[1:0]addr;
                begin
                        @(negedge clock)
                        wait(~busy)
                        @(negedge clock)
                        payload_len=6'd16;
                        addr=2'b01;//valid packet
                        header={payload_len,addr};
                        parity=1'b0;
                        data_in=header;
                        pkt_valid=1'b1;
								parity=parity^header;
                        @(negedge clock)
                        wait(~busy)
                        for(i=0;i<payload_len;i=i+1)
                        begin
                        @(negedge clock)
                        wait(~busy)
                        payload_data={$random}%256;
                        data_in=payload_data;
                        parity=parity^payload_data;
                        end
                        @(negedge clock)
                        wait(~busy)
                        pkt_valid=1'b0;
                        data_in=parity;
                end
        endtask      
	//task for payload len < 14       
	task pkt_gen_14_1;
                reg[7:0]payload_data,parity,header;
                reg[5:0]payload_len;
                reg[1:0]addr;
                begin
                        @(negedge clock)
                        wait(~busy)
                        @(negedge clock)
                        payload_len=6'd13;
                        addr=2'b01;//valid packet
                        header={payload_len,addr};
                        parity=1'b0;
                        data_in=header;
                        pkt_valid=1'b1;
								parity=parity^header;
                        @(negedge clock)
                        wait(~busy)
                        for(i=0;i<payload_len;i=i+1)
                        begin
                        @(negedge clock)
                        wait(~busy)
                        payload_data={$random}%256;
                        data_in=payload_data;
                        parity=parity^payload_data;
                        end
                        @(negedge clock)
                        wait(~busy)
                        pkt_valid=1'b0;
                        data_in=parity;
                end
        endtask
	//task for payload len =17
	task pkt_gen_17;
		reg[7:0]payload_data,parity,header;
                reg[5:0]payload_len;
                reg[1:0]addr;
                begin
                       @(negedge clock)
                        wait(~busy)
                        @(negedge clock)
                        payload_len=6'd17;
			addr=2'b10;
			header={payload_len,addr};
			parity=0;
			data_in=header;
			pkt_valid=1;
			parity=parity^header;
			@(negedge clock)
			wait(~busy)
			for(i=0;i<payload_len;i=i+1)
			begin
				@(negedge clock)
				wait(~busy)
				payload_data={$random}%256;
				data_in=payload_data;
				parity=parity^header;
			end
			->e1;
			@(negedge clock)
			wait(~busy)
			pkt_valid=0;
			data_in=parity;
		end
	endtask    

		//task for random  payload len      
	task pkt_gen_rand;
                reg[7:0]payload_data,parity,header;
                reg[5:0]payload_len;
                reg[1:0]addr;
                begin
								->e2;
                        @(negedge clock)
                        wait(~busy)
                        @(negedge clock)
                        payload_len={$random}%63;
                        addr=2'b10;
                        header={payload_len,addr};
                        parity=0;
                        data_in=header;
                        pkt_valid=1;
                        parity=parity^header;
                        @(negedge clock)
                        wait(~busy)
                        for(i=0;i<payload_len;i=i+1)
                        begin
                                @(negedge clock)
                                wait(~busy)
                                payload_data={$random}%256;
                                data_in=payload_data;
                                parity=parity^header;
                        end
                        @(negedge clock)
                        wait(~busy)
                        pkt_valid=0;
                        data_in=parity;
                end
        endtask



initial
begin
	rst;
	//repeat(3)
	initialize;
	//@(e1)
	@(negedge clock)
	pkt_gen_17;
	//pkt_gen_14_1;
	//pkt_gen_16_1;
	//pkt_gen_12_1;
	@(negedge clock)
	read_enb_1=1'b1;
	wait(~vld_out_1)
	@(negedge clock)
	read_enb_1=1'b0;
end

endmodule
