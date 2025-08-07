module router_fsm_tb();
    // Inputs
    reg clock, resetn, pkt_valid, parity_done;
    reg soft_reset_0, soft_reset_1, soft_reset_2;
    reg fifo_full, low_pkt_valid;
    reg fifo_empty_0, fifo_empty_1, fifo_empty_2;
    reg [1:0] data_in;
    
    // Outputs
    wire detect_add, ld_state, laf_state, full_state;
    wire write_enb_reg, rst_int_reg, lfd_state, busy;

    // Instantiation of the DUT
    router_fsm DUT (
        .clock(clock), .resetn(resetn), .pkt_valid(pkt_valid),
        .parity_done(parity_done), .soft_reset_0(soft_reset_0), .soft_reset_1(soft_reset_1),
        .soft_reset_2(soft_reset_2), .fifo_full(fifo_full), .low_pkt_valid(low_pkt_valid),
        .fifo_empty_0(fifo_empty_0), .fifo_empty_1(fifo_empty_1), .fifo_empty_2(fifo_empty_2),
        .data_in(data_in), .detect_add(detect_add), .ld_state(ld_state),
        .laf_state(laf_state), .full_state(full_state), .write_enb_reg(write_enb_reg),
        .rst_int_reg(rst_int_reg), .lfd_state(lfd_state), .busy(busy)
    );

    // Clock Generation
    initial begin
        clock = 1'b0;
        forever #5 clock = ~clock;
    end

    // Reset Task
    task reset();
        begin
            @(negedge clock)
            resetn = 1'b0;
            @(negedge clock)
            resetn = 1'b1;
        end
    endtask

    // Soft Reset Task
    task softreset();
        begin
            @(negedge clock)
            soft_reset_1 = 1'b1;
            @(negedge clock)
            soft_reset_1 = 1'b0;
        end
    endtask

    // Task 1
    task t1;
        begin
            @(negedge clock)
            pkt_valid = 1'b1;
            data_in = 2'b01;
            fifo_empty_1 = 1'b1;
            @(negedge clock)
            @(negedge clock)
            fifo_full = 1'b0;
            pkt_valid = 1'b0;
            @(negedge clock)
            @(negedge clock)
            fifo_full = 1'b0;
        end
    endtask

    // Task 2
    task t2;
        begin
            @(negedge clock)
            pkt_valid = 1'b1;
            data_in = 2'b01;
            fifo_empty_1 = 1'b1;
            @(negedge clock)
            @(negedge clock)
            fifo_full = 1'b1;
            @(negedge clock)
            fifo_full = 1'b0;
            @(negedge clock)
            parity_done = 1'b0;
            low_pkt_valid = 1'b1;
            @(negedge clock)
            @(negedge clock)
            fifo_full = 1'b0;
        end
    endtask

    // Task 3
    task t3;
        begin
            @(negedge clock)
            pkt_valid = 1'b1;
            data_in = 2'b01;
            fifo_empty_1 = 1'b1;
            @(negedge clock)
            @(negedge clock)
            fifo_full = 1'b1;
            @(negedge clock)
            fifo_full = 1'b0;
            @(negedge clock)
            parity_done = 1'b0;
            low_pkt_valid = 1'b0;
            @(negedge clock)
            fifo_full = 1'b0;
            pkt_valid = 1'b0;
            @(negedge clock)
            @(negedge clock)
            fifo_full = 1'b0;
        end
    endtask

    // Task 4
    task t4;
        begin
            @(negedge clock)
            pkt_valid = 1'b1;
            data_in = 2'b01;
            fifo_empty_1 = 1'b1;
            @(negedge clock)
            @(negedge clock)
            fifo_full = 1'b0;
            pkt_valid = 1'b0;
            @(negedge clock)
            @(negedge clock)
            fifo_full = 1'b1;
            @(negedge clock)
            fifo_full = 1'b0;
            @(negedge clock)
            parity_done = 1'b1;
        end
    endtask

    // Calling Tasks in Sequence
    initial begin
        // Initialize Inputs
        resetn = 1'b1;
        pkt_valid = 1'b0;
        parity_done = 1'b0;
        soft_reset_0 = 1'b0;
        soft_reset_1 = 1'b0;
        soft_reset_2 = 1'b0;
        fifo_full = 1'b0;
        low_pkt_valid = 1'b0;
        fifo_empty_0 = 1'b0;
        fifo_empty_1 = 1'b0;
        fifo_empty_2 = 1'b0;
        data_in = 2'b00;

        // Test Sequence
        reset;
        softreset;
        t1;
        #100;
        t2;
        #100;
        t3;
        #100;
        t4;
        #10000 $finish;
    end
endmodule

