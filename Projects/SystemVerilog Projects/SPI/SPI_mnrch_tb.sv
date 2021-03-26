module SPI_mnrch_tb ();

    logic clk, rst_n, wrt, MISO, SS_n, SCLK, MOSI, INT, done;
    logic [15:0] wt_data, rd_data;

    SPI_mnrch MONARCH(.clk(clk), .rst_n(rst_n), .wrt(wrt), .MISO(MISO),
    .wt_data(wt_data), .done(done), .SS_n(SS_n), .SCLK(SCLK), .MOSI(MOSI), .rd_data(rd_data));

    SPI_iNEMO1 NEMO(.SS_n(SS_n), .SCLK(SCLK), 
    .MOSI(MOSI), .MISO(MISO), .INT(INT));

    initial begin
        clk = 0;
        rst_n = 0;
        wrt = 0;
    end

    always #5 clk = ~clk;

    initial begin
        wt_data = 16'h8F00;
        @(posedge clk);
        rst_n = 1;
        wrt= 1;
        @(posedge clk);
        @(posedge clk);
        wrt = 0;

        while(!done) begin
            @(posedge clk);
        end

        if (rd_data !== 16'h006a) begin
            $display("Error rd_data should be 6A but it is %h", rd_data);
            $stop;
        end
        @(posedge clk);
        wt_data = 16'h0D02;
        wrt = 1;
        @(posedge clk);
        @(posedge clk);
        wrt= 0;

        while(!done) begin
            @(posedge clk);
        end

        if (!NEMO.NEMO_setup) begin
            $display("Error NEMO_setup should be high");
            $stop;
        end


        $stop;


    end



endmodule
