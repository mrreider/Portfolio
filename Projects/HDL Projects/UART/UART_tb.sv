module UART_tb();

    //clock and reset
    logic clk, rst_n;

    //Transmit
    logic TX, trmt;
    logic [7:0] tx_data;
    logic tx_done;

    //Recieve
    logic clr_rdy;
    logic [7:0] rx_data;
    logic rdy;

    //Testing
    logic fail;
    logic [7:0] randVal;

    Uart_tx TRANSMIT(.clk(clk), .rst_n(rst_n), .trmt(trmt), .tx_data(tx_data), .tx_done(tx_done), .TX(TX));
    Uart_rcv RECIEVE(.clk(clk), .rst_n(rst_n), .RX(TX), .clr_rdy(clr_rdy), .rx_data(rx_data), .rdy(rdy));

    initial begin
        clk = 0;
        trmt = 0;
        fail = 0;
        clr_rdy = 0;
    end

    always begin

        //TEST 1
        tx_data = 8'b10101010;
        rst_n = 0; //assert reset

        @(posedge clk);
        rst_n = 1;
        @(posedge clk);

        //Pulse transmit
        trmt = 1'b1;
        @(posedge clk);
        trmt = 1'b0;


        @(posedge clk);

        while (!rdy) begin
            //wait
            @(posedge clk);
        end

        //RECIEVE DATA CHECK
        if (rx_data !== 8'b10101010) begin
            $display("Error failed on test 1, rx_data should be 10101010 but it is %b", rx_data);
            fail = 1;
        end

        //TEST 2
        tx_data = 8'b10011000;
        trmt = 1'b1;

        @(posedge clk);
        trmt = 1'b0;

        repeat (5)@(posedge clk); // 5 clocks to let double flopped RX stabilize
        while (!rdy) begin
            //wait
            @(posedge clk);
        end

        //RECIEVE DATA CHECK
        if (rx_data !== 8'b10011000)begin
            $display("Error failed on test 2, rx_data should be 10011000 but it is %b", rx_data);
            fail = 1;
        end

        //TEST 3
        tx_data = 8'b00000000;
        trmt = 1'b1;

        @(posedge clk);
        trmt = 1'b0;

        repeat (5)@(posedge clk);
        while (!rdy) begin
            //wait
            @(posedge clk);
        end

        if (rx_data !== 8'b00000000)begin
            $display("Error failed on test 3, rx_data should be 00000000 but it is %b", rx_data);
            fail = 1;
        end

        //TEST 4
        tx_data = 8'hFF;
        trmt = 1'b1;

        @(posedge clk);
        trmt = 1'b0;

        repeat (5)@(posedge clk);
        while (!rdy) begin
            //wait
            @(posedge clk);
        end

        if (rx_data !== 8'hFF)begin
            $display("Error failed on test 4, rx_data should be 11111111 but it is %b", rx_data);
            fail = 1;
        end

        //TEST 5 **RANDOM**

        randVal = $urandom; //generate unsigned random number
        tx_data = randVal;
        
         trmt = 1'b1;

        @(posedge clk);
        trmt = 1'b0;

        repeat (5)@(posedge clk);
        while (!rdy) begin
            //wait
            @(posedge clk);
        end

        if (rx_data !== randVal) begin
            $display("Error failed on test 5, rx_data should be %b but it is %b", randVal, rx_data);
            fail = 1;
        end

        

        if (fail) $display("Error, one or more test failed");
        else $display("Yahoo! All tests passed");
        $stop;
        
    end

    always #5 clk = ~clk;
endmodule
