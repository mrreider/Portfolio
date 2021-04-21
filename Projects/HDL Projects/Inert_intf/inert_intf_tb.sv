module inert_intf_tb();

logic clk, rst_n, MISO, strt_cal; // inputs of dut

logic [15:0] ptch, roll, yaw; // outputs of dut
logic vld, SS_n, SCLK, MOSI, cal_done; 


logic INT; // output from the iNEMO

// instantiate the DUT
inert_intf iINT(.clk(clk), .rst_n(rst_n), .MISO(MISO), .strt_cal(strt_cal), 
				.ptch(ptch), .roll(roll), .yaw(yaw), .vld(vld), .SS_n(SS_n),
				.SCLK(SCLK), .MOSI(MOSI), .cal_done(cal_done), .INT(INT));
SPI_iNEMO2 iSPI(.SS_n(SS_n), .MOSI(MOSI), .INT(INT), .SCLK(SCLK), .MISO(MISO));

initial begin
	//start by asserting the reset signal
	clk = 0;
	rst_n = 0;
	strt_cal = 0;
	iINT.wrt = 0;
	@(posedge clk); // pass a clock cycle
	// @(negedge clk);
	@(posedge iSPI.POR_n);
    rst_n = 1;

    fork
        begin : timeout1
            repeat(1000000) @(posedge clk); // wait a million clock cycles
            $display("Timeout occured waiting for the NEMO setup pin");
        end
        begin : wait_NEMO_setup
            @(posedge iSPI.NEMO_setup);
                disable timeout1;
        end
    join

    //assert strt_cal and pulse wrt 
    strt_cal = 1;
	@(posedge clk);
	strt_cal = 0;

	fork
		begin : timeout2
			repeat(1000000) @(posedge clk); // wait a million clock cycles
			$display("Timeout occured waiting for the cal_done signal");
		
		end
		begin : wait_cal_done
			@(posedge cal_done);
				disable timeout2;
		end
	join

    // let program run for 8 million more clock cycles to allow plotting of ptch/roll/yaw

    repeat(8000000)
		@(posedge clk);


	$display("All setups complete. Inertial data being read. Yahoo!");
	$stop;
end

always
    #5 clk = ~clk;

task pulseWrt();
	iINT.wrt = 1'b1;
	@(posedge clk);
	iINT.wrt = 1'b0;
	@(posedge iINT.done);
endtask

endmodule