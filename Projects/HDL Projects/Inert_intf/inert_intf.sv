module inert_intf(clk,rst_n,ptch,roll,yaw,strt_cal,cal_done,vld,SS_n,SCLK,
                  MOSI,MISO,INT);
				  
  parameter FAST_SIM = 1;		// used to accelerate simulation
 
  input clk, rst_n;
  input MISO;					// SPI input from inertial sensor
  input INT;					// goes high when measurement ready
  input strt_cal;				// from comand config.  Indicates we should start calibration
  
  output signed [15:0] ptch,roll,yaw;	// fusion corrected angles
  output cal_done;						// indicates calibration is done
  output reg vld;						// goes high for 1 clock when new outputs available
  output SS_n,SCLK,MOSI;				// SPI outputs

  ////////////////////////////////////////////
  // Declare any needed internal registers //
  //////////////////////////////////////////
   reg intFlop1, intFlop2;

   //inertial data
   reg [7:0] pitchL, pitchH, rollL, rollH, yawL, 
   yawH, AXL, AXH, AYL, AYH;

  //////////////////////////////////////
  // Outputs of SM are of type logic //
  ////////////////////////////////////

  logic [15:0] cmd, inert_data; //cmd to write to registers
  logic done; //SPI done
  logic wrt; //SPI wrt
  
  //inertial data ready to be flopped
  logic pitchL_rdy, pitchH_rdy, rollL_rdy, rollH_rdy,
  yawL_rdy, yawH_rdy, AXL_rdy, AXH_rdy, AYL_rdy, AYH_rdy;

  //timer logic
  logic [15:0] timer;
  // logic timer_done;

  //////////////////////////////////////////////////////////////
  // Declare any needed internal signals that connect blocks //
  ////////////////////////////////////////////////////////////
  wire signed [15:0] ptch_rt,roll_rt,yaw_rt;	// feeds inertial_integrator
  wire signed [15:0] ax,ay;						// accel data to inertial_integrator
  wire transactionDone;
  
  
  ///////////////////////////////////////
  // Create enumerated type for state //
  /////////////////////////////////////
  typedef enum reg [3:0] {INIT0, INIT1, INIT2, INIT3, SPITCHL, SPITCHH, SROLLL, SROLLH, SYAWL, SYAWH, SAXL, SAXH, SAYL, SAYH, FIN} state;
  state currentState, nextState;
  
  
  ////////////////////////////////////////////////////////////
  // Instantiate SPI monarch for Inertial Sensor interface //
  //////////////////////////////////////////////////////////
  SPI_mnrch iSPI(.clk(clk),.rst_n(rst_n),.SS_n(SS_n),.SCLK(SCLK),.MISO(MISO),.MOSI(MOSI),
                 .wrt(wrt),.done(done),.rd_data(inert_data),.wt_data(cmd));
				  
  ////////////////////////////////////////////////////////////////////
  // Instantiate Angle Engine that takes in angular rate readings  //
  // and acceleration info and produces ptch,roll, & yaw readings //
  /////////////////////////////////////////////////////////////////
  inertial_integrator #(FAST_SIM) iINT(.clk(clk), .rst_n(rst_n), .strt_cal(strt_cal), .cal_done(cal_done),
                                       .vld(vld), .ptch_rt(ptch_rt), .roll_rt(roll_rt), .yaw_rt(yaw_rt), .ax(ax),
						               .ay(ay), .ptch(ptch), .roll(roll), .yaw(yaw));

  assign ptch_rt = {pitchH, pitchL};
  assign roll_rt = {rollH, rollL};
  assign yaw_rt = {yawH, yawL};
  assign ax = {AXH, AXL};
  assign ay = {AYH, AYL};

  //State control :))))))))))
  always_ff @(posedge clk, negedge rst_n)
    if (!rst_n) currentState <= INIT0;
    else currentState <= nextState;

  //Interrupt Double Flop
  always_ff@(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
      intFlop1 <= 1'b0;
      intFlop2 <= 1'b0;
    end
    else begin
      intFlop1 <= INT; //store interrupt signal
      intFlop2 <= intFlop1;
    end
  end

  //Timer control

  always_ff@(posedge clk, negedge rst_n)
    if (!rst_n)
      timer <= 0;
    else
      timer <= timer + 1'b1; 

  //INTERTIAL READING FLOPS

  //pitchL
  always_ff@(posedge clk)
    if (pitchL_rdy)
      pitchL <= inert_data[7:0];

  //pitchH
  always_ff@(posedge clk)
    if (pitchH_rdy)
      pitchH <= inert_data[7:0];
  
  //rollL
  always_ff@(posedge clk)
    if (rollL_rdy)
      rollL <= inert_data[7:0];

  //rollH
  always_ff@(posedge clk)
    if (rollH_rdy)
      rollH <= inert_data[7:0];

  //yawL
  always_ff@(posedge clk)
    if (yawL_rdy)
      yawL <= inert_data[7:0];

  //yawH
  always_ff@(posedge clk)
    if (yawH_rdy)
      yawH <= inert_data[7:0];

  //AXL
  always_ff@(posedge clk)
    if (AXL_rdy)
      AXL <= inert_data[7:0];

  //AXH
  always_ff@(posedge clk)
    if (AXH_rdy)
      AXH <= inert_data[7:0];

  //AYL
  always_ff@(posedge clk)
    if (AYL_rdy)
      AYL <= inert_data[7:0];

  //AYH
  always_ff@(posedge clk)
    if (AYH_rdy)
      AYH <= inert_data[7:0];

  //use timer here
  always_comb begin
    cmd = 16'd0;
    nextState = SPITCHL; //default to recieving state
    pitchL_rdy = 1'b0;
    pitchH_rdy = 1'b0;
    rollL_rdy = 1'b0;
    rollH_rdy = 1'b0;
    yawL_rdy = 1'b0;
    yawH_rdy = 1'b0;
    AXL_rdy = 1'b0;
    AXH_rdy = 1'b0;
    AYL_rdy = 1'b0;
    AYH_rdy = 1'b0;
    vld = 1'b0;
    wrt = 1'b0;
    case(currentState)
      //INIT CASE NEED TO WRITE TO REGISTERS
      INIT0: begin
        //TRANSACTION 1
          nextState = INIT0;
          cmd = 16'h0D02;
          if (&timer) begin
            nextState = INIT1;
            wrt = 1'b1;
          end
      end
      INIT1: begin
        //TRANSACTION 2
        cmd = 16'h1062;
        nextState = INIT1;
        if (done && timer[9:0]) begin
          nextState = INIT2;
          wrt = 1'b1;
        end
      end
      INIT2: begin
        //TRANSACTION 3
        cmd = 16'h1162;
        nextState = INIT2;
        if (done && timer[9:0]) begin
          nextState = INIT3;
          wrt = 1'b1;
        end
      end
      INIT3: begin
        //TRANSACTION 4
        cmd = 16'h1460;
        nextState = INIT3;
        if (done && timer[9:0]) begin
          nextState = SPITCHL;
          wrt = 1'b1;
        end
      end
      //PITCH L
      SPITCHL: begin
        if (intFlop2) begin
          cmd = 16'hA2xx;
          wrt = 1'b1;
          nextState = SPITCHH;
        end
      end
      //PITCH H
      SPITCHH: begin
        nextState = SPITCHH;
        cmd = 16'hA3xx;
        if (done && timer[9:0]) begin
          pitchL_rdy = 1'b1;
          nextState = SROLLL;
          wrt = 1'b1;
        end
      end
      //ROLL L
      SROLLL: begin
        nextState = SROLLL;
        cmd = 16'hA4xx;
        if (done && timer[9:0]) begin
          nextState = SROLLH;
          wrt = 1'b1;
          pitchH_rdy = 1'b1;
        end
      end
      //ROLL H
      SROLLH: begin
        nextState = SROLLH;
        cmd = 16'hA5xx;
        if (done && timer[9:0]) begin
          nextState = SYAWL;
          rollL_rdy = 1'b1;
          wrt = 1'b1;
        end
      end
      //YAW L
      SYAWL: begin
        nextState = SYAWL;
        cmd = 16'hA6xx;
        if (done && timer[9:0]) begin
          nextState = SYAWH;
          wrt = 1'b1;
          rollH_rdy = 1'b1;
        end
      end
      //YAW H
      SYAWH: begin
        nextState = SYAWH;
        cmd = 16'hA7xx;
        if (done && timer[9:0]) begin
          nextState = SAXL;
          yawL_rdy = 1'b1;
          wrt = 1'b1;
        end
      end
      //AXL
      SAXL: begin
        nextState = SAXL;
        cmd = 16'hA8xx;
        if (done && timer[9:0]) begin
          nextState = SAXH;
          yawH_rdy = 1'b1;
          wrt = 1'b1;
        end
      end
      //AXH
      SAXH: begin
        nextState = SAXH;
        cmd = 16'hA9xx;
        if (done && timer[9:0]) begin
          nextState = SAYL;
          AXL_rdy = 1'b1;
          wrt = 1'b1;
        end
      end
      //AYL
      SAYL: begin
        nextState = SAYL;
        cmd = 16'hAAxx;
        if (done && timer[9:0]) begin
          nextState = SAYH;
          AXH_rdy = 1'b1;
          wrt = 1'b1;
        end
      end
      //AYH
      SAYH: begin
        nextState = SAYH;
        cmd = 16'hABxx;
        if (done && timer[9:0]) begin
          AYL_rdy = 1'b1;
          nextState = FIN;
          wrt = 1'b1;
        end
      end
      FIN: begin
        nextState = FIN;
        AYH_rdy = done;
        if (&timer[9:0]) begin
          vld = 1'b1;
          nextState = SPITCHL;
        end
      end
    endcase
         
  end
  
endmodule
	  