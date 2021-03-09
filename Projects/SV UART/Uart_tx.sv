module Uart_tx(clk, rst_n, TX, trmt, tx_data, tx_done);

    input clk, rst_n, trmt;
    input [7:0] tx_data;
    output reg tx_done;
    output TX;

    typedef enum reg [1:0] {IDLE, TRANSMITTING} state;

    state currentState, nextState;

    reg [3:0] bit_cnt;
    reg [11:0] baud_cnt;
    logic shift, is_done;

    reg [8:0] tx_shift_reg;

    assign shift = (baud_cnt == 12'hA2C);
    assign TX = tx_shift_reg[0];
    assign is_done = (bit_cnt == 4'b1010);

    always_ff @( posedge clk, negedge rst_n) begin
        if (!rst_n)
            currentState <= IDLE;
        else 
            currentState <= nextState;
    end
    
    always_comb begin
        if (currentState == IDLE) begin
            if (trmt) nextState = TRANSMITTING;
    end
    else if (currentState == TRANSMITTING) begin
        if (tx_done) nextState = IDLE;
    end
    else nextState = IDLE;
    end
    
    //baud rate counter
    always_ff @(posedge clk) begin
        if (trmt || shift) baud_cnt <= 12'h000;
        else if (currentState == TRANSMITTING) baud_cnt <= baud_cnt + 1;
    end

    //bit counter and 
    always_ff@(posedge clk) begin
        if (trmt) bit_cnt <= 4'h0;
        else if (shift) bit_cnt <= bit_cnt + 1;
    end

    always_ff@(posedge clk) begin
        if (!rst_n) tx_shift_reg <= 9'b111111111;
        else if (shift) tx_shift_reg <= {1'b1, tx_shift_reg[8:1]};
        else if (trmt) tx_shift_reg <= {tx_data, 1'b0};
        
    end

    always_ff @( posedge clk, negedge rst_n) begin
        if (!rst_n || trmt) tx_done <= 1'b0;
        else if (is_done) tx_done <= is_done;
    end




endmodule
