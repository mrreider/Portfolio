module SPI_mnrch(
    //INPUTS
    input clk, rst_n, wrt, MISO,
    input [15:0] wt_data,

    //OUTPUTS
    output reg SS_n, SCLK,
    output MOSI,
    output reg done,
    output [15:0] rd_data
    );

    //INTERMEDIATES
    reg [15:0] shft_reg;
    reg [3:0] SCLK_cnt;
    reg [4:0] bit_cnt;
    reg ld_SCLK, shift, done16, init, set_done;

    //STATE DEFINITION
    typedef enum reg[1:0] {IDLE, TRANSMIT, PULL_DOWN} state;

    //FLOPPED SS_N AND SCLK
    logic ssn_flop, sclk_flop;

    //STATE DEFINITIONS
    state currentState, nxt_state;

    //CONTINUOUS ASSIGNMENT 
    assign ld_SCLK = (currentState == IDLE && wrt);
    assign init = ld_SCLK; //same thing as ld_SCLK
    assign shift = (currentState == TRANSMIT && SCLK_cnt == 4'hA);
    assign done16 = bit_cnt[4];
    assign rd_data = shft_reg;
    assign MOSI = shft_reg[15];

    //FLOPPED SCLK
    always_ff@(posedge clk, negedge rst_n) begin
        if (!rst_n)
            SCLK <= 1'b1;
        else
            SCLK <= sclk_flop;
    end

    //FLOPPED SS_N
    always_ff@(posedge clk, negedge rst_n) begin
        if (!rst_n)
            SS_n <= 1'b1;
        else
            SS_n <= ssn_flop;
    end



    //STATE FLIP FLOPS
    always_ff @(posedge clk, negedge rst_n) begin
        if (!rst_n)
            currentState <= IDLE;
        else
            currentState <= nxt_state;
    end

    //SCLK FLOP
    always_ff @(posedge clk) begin
        if (ld_SCLK)
            SCLK_cnt <= 4'b1011;
        else begin
            SCLK_cnt <= SCLK_cnt + 1;
        end 
    end

    //BIT COUNTER
    always_ff @(posedge clk) begin
        if (currentState == IDLE)
            bit_cnt <= 5'b00000;
        else if (currentState == TRANSMIT && shift)
            bit_cnt <= bit_cnt + 1;
    end

    //DONE FLOP
    always_ff @(posedge clk, negedge rst_n) begin
        if (!rst_n)
            done <= 1'b0;
        else if (init)
            done <= 1'b0;
        else if (set_done)
            done <= 1'b1;
    end

    //SHIFT REGISTER FLOPS
    always_ff @(posedge clk) begin
        if (init)
            shft_reg <= wt_data;
        else if (shift)
            shft_reg <= {shft_reg[14:0], MISO};
    end

    //STATE LOGIC
    always_comb begin
        set_done = 1'b0;
        nxt_state = IDLE;
        ssn_flop = 1'b0;
        sclk_flop = SCLK_cnt[3]; //default to this value, also high when state is IDLE
        case (currentState)
            //IDLE STATE LOGIC. CHANGES AT WRT
            IDLE: begin
                sclk_flop = 1'b1;
                ssn_flop = 1'b1;
                if (wrt) nxt_state = TRANSMIT;
            end
            //TRANSMIT STATE LOGIC
            TRANSMIT: begin
                if (bit_cnt[4]) nxt_state = PULL_DOWN;
                else nxt_state = TRANSMIT;
            end
            //PULL_DOWN STATE LOGIC
            PULL_DOWN: begin
                if (SCLK_cnt == 4'hF)begin //maybe set one bit before to avoid glitch
                    nxt_state = IDLE;
                    set_done = 1'b1;
                end 
                else nxt_state = PULL_DOWN;
            end
            //ILLEGAL STATE
            default: begin
                nxt_state = IDLE;
            end
        endcase
    end





endmodule
