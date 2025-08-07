module router_fsm(
    input clock,
    input resetn,
    input pkt_valid,
    input parity_done,
    input soft_reset_0,
    input soft_reset_1,
    input soft_reset_2,
    input fifo_full,
    input low_pkt_valid,
    input fifo_empty_0,
    input fifo_empty_1,
    input fifo_empty_2,
    input [1:0] data_in,
    output reg detect_add,
    output reg ld_state,
    output reg laf_state,
    output reg full_state,
    output reg write_enb_reg,
    output reg rst_int_reg,
    output reg lfd_state,
    output reg busy
);
    parameter DECODE_ADDRESS = 3'b000,
              LOAD_FIRST_DATA = 3'b001,
              LOAD_DATA = 3'b010,
              FIFO_FULL_STATE = 3'b011,
              LOAD_AFTER_FULL = 3'b100,
              LOAD_PARITY = 3'b101,
              CHECK_PARITY_ERROR = 3'b110,
              WAIT_TILL_EMPTY = 3'b111;
              
    reg [2:0] state, next_state;

    // State Register Logic
    always @(posedge clock or negedge resetn) begin
        if (!resetn )
		  state <= DECODE_ADDRESS;

		  else if(soft_reset_0 || soft_reset_1 || soft_reset_2)
            state <= DECODE_ADDRESS;
        else
            state <= next_state;
    end

    // Next State Logic
    always @(*) begin
        case (state)
            DECODE_ADDRESS:
				begin
					detect_add=1'b1;
					busy=1'b0;
					full_state=1'b0;
					rst_int_reg=1'b0;
					laf_state=1'b0;
					write_enb_reg=1'b0;
					ld_state=1'b0;
					lfd_state=1'b0;
                if ((pkt_valid && (data_in == 2'b00) && fifo_empty_0) ||
                    (pkt_valid && (data_in == 2'b01) && fifo_empty_1) ||
                    (pkt_valid && (data_in == 2'b10) && fifo_empty_2))
                    next_state = LOAD_FIRST_DATA;
                else if ((pkt_valid && (data_in == 2'b00) && !fifo_empty_0) ||
                         (pkt_valid && (data_in == 2'b01) && !fifo_empty_1) ||
                         (pkt_valid && (data_in == 2'b10) && !fifo_empty_2))
                    next_state = WAIT_TILL_EMPTY;
						  
                else
                    next_state = DECODE_ADDRESS;
			   end

            LOAD_FIRST_DATA:
				begin
				busy=1'b1;
				lfd_state=1'b1;
				detect_add=1'b0;
					full_state=1'b0;
					rst_int_reg=1'b0;
					laf_state=1'b0;
					write_enb_reg=1'b0;
					ld_state=1'b0;
                next_state = LOAD_DATA;
				end

            LOAD_DATA:
				begin
				ld_state=1'b1;
				write_enb_reg=1'b1;
				detect_add=1'b0;
					busy=1'b0;
					full_state=1'b0;
					rst_int_reg=1'b0;
					laf_state=1'b0;
					lfd_state=1'b0;
                if (fifo_full)
                    next_state = FIFO_FULL_STATE;
                else if (!fifo_full && !pkt_valid)
                    next_state = LOAD_PARITY;
                else
                    next_state = LOAD_DATA;
				end

            FIFO_FULL_STATE:
				begin
				busy=1'b1;
				full_state=1'b1;
				detect_add=1'b0;
					rst_int_reg=1'b0;
					laf_state=1'b0;
					write_enb_reg=1'b0;
					ld_state=1'b0;
					lfd_state=1'b0;
                if (!fifo_full)
                    next_state = LOAD_AFTER_FULL;
                else
                    next_state = FIFO_FULL_STATE;
				end

            LOAD_AFTER_FULL:
				begin
				busy=1'b1;
				laf_state=1'b1;
				write_enb_reg=1'b1;
				detect_add=1'b0;
					full_state=1'b0;
					rst_int_reg=1'b0;
					ld_state=1'b0;
					lfd_state=1'b0;
                if (!parity_done && low_pkt_valid)
                    next_state = LOAD_PARITY;
                else if (!parity_done && !low_pkt_valid)
                    next_state = LOAD_DATA;
                else if (parity_done)
                    next_state = DECODE_ADDRESS;
                else
                    next_state = LOAD_AFTER_FULL;
				end

            LOAD_PARITY:
				begin
				busy=1'b1;
				write_enb_reg=1'b1;
				detect_add=1'b0;
					full_state=1'b0;
					rst_int_reg=1'b0;
					laf_state=1'b0;
					ld_state=1'b0;
					lfd_state=1'b0;
                next_state = CHECK_PARITY_ERROR;
				end

            CHECK_PARITY_ERROR:
				begin
				busy=1'b1;
				rst_int_reg=1'b1;
				detect_add=1'b0;
					full_state=1'b0;
					laf_state=1'b0;
					write_enb_reg=1'b0;
					ld_state=1'b0;
					lfd_state=1'b0;
                if (fifo_full)
                    next_state = FIFO_FULL_STATE;
                else
                    next_state = DECODE_ADDRESS;
				end

            WAIT_TILL_EMPTY:
				begin
				busy=1'b1;
				detect_add=1'b0;
					full_state=1'b0;
					rst_int_reg=1'b0;
					laf_state=1'b0;
					write_enb_reg=1'b0;
					ld_state=1'b0;
					lfd_state=1'b0;
                if ((fifo_empty_0 && (data_in == 2'b00)) ||
                    (fifo_empty_1 && (data_in == 2'b01)) ||
                    (fifo_empty_2 && (data_in == 2'b10)))
                    next_state = LOAD_FIRST_DATA;
                else
                    next_state = WAIT_TILL_EMPTY;
				end

            default:
                next_state = DECODE_ADDRESS;
        endcase
    end

    // Output Logic
   /* assign detect_add = (state == DECODE_ADDRESS);
    assign lfd_state = (state == LOAD_FIRST_DATA);
    assign ld_state = (state == LOAD_DATA);
    assign write_enb_reg = (state == (LOAD_DATA || LOAD_AFTER_FULL || LOAD_PARITY));
    assign laf_state = (state == LOAD_AFTER_FULL);
    assign rst_int_reg = (state == CHECK_PARITY_ERROR);    
	 assign busy = (state == (LOAD_FIRST_DATA|| FIFO_FULL_STATE || LOAD_PARITY || CHECK_PARITY_ERROR || WAIT_TILL_EMPTY || LOAD_AFTER_FULL));
	 assign full_state = (state==FIFO_FULL_STATE);*/
endmodule


