module Uart_rcv(clk, rst_n, RX, rx_data, clr_rdy, rdy);

    input clk, rst_n, clr_rdy, RX;
    output reg [7:0] rx_data;
    output reg rdy;

    typedef enum reg [1:0] {IDLE, RECEIVING} state;

    state currentState, nextState;

    reg [3:0] bit_cnt;
    reg [8:0] rx_shift_reg;
    reg [11:0] baud_cnt;
    logic shift, is_done, init, isReady;
    reg flop_RX, double_flopped_RX;

    assign is_done = (bit_cnt == 4'b1010);
    assign shift = (baud_cnt == 12'h0000);
    assign init = (!double_flopped_RX && currentState == IDLE);
    assign rx_data = rdy ? rx_shift_reg[7:0] : 8'h00;

    always_ff @( posedge clk, negedge rst_n) begin
        if (!rst_n)
            currentState <= IDLE;
        else 
            currentState <= nextState;
    end
    
    always_comb begin
        if (currentState == IDLE) begin
            if (init) begin //when RX goes low and it isnt in the middle of recieving it is a start bit
                nextState = RECEIVING;
            end
        end
    else if (currentState == RECEIVING) begin
        if (rdy) begin
            nextState = IDLE;
                end
        end
    else nextState = IDLE;
    end
   

    //baud rate counter
    always_ff @(posedge clk) begin
        if(init) baud_cnt <= 12'h516;
        else if(shift) baud_cnt <= 12'hA2C;
        else if (currentState == RECEIVING) baud_cnt <= baud_cnt - 1;
    end

    //bit counter and 
    always_ff@(posedge clk) begin
        if (init) bit_cnt <= 4'b0;
        else if (shift) begin
             bit_cnt <= bit_cnt + 1;
        end
    end

    always_ff@(posedge clk) begin
        if (!rst_n) begin
            flop_RX <= 1'b1;
            double_flopped_RX <= 1'b1;
        end
        else begin
            flop_RX <= RX;
            double_flopped_RX <= flop_RX;
        end
            
    end

    always_ff@(posedge clk) begin
         if (shift) rx_shift_reg <= {double_flopped_RX, rx_shift_reg[8:1]};
    end
    

    always_ff@(posedge clk, negedge rst_n) begin
        if (!rst_n || clr_rdy || init) rdy <= 1'b0;
        else if (is_done) rdy <= 1'b1; 
    end




endmodule

