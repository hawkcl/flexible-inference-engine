//*****************************************************************************
// (c) Copyright 2009 - 2010 Xilinx, Inc. All rights reserved.
//
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
//
//*****************************************************************************
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor             : Xilinx
// \   \   \/     Version            : 4.2
//  \   \         Application        : MIG
//  /   /         Filename           : sim_tb_top.v
// /___/   /\     Date Last Modified : $Date: 2011/06/07 13:45:16 $
// \   \  /  \    Date Created       : Tue Sept 21 2010
//  \___\/\___\
//
// Device           : 7 Series
// Design Name      : DDR3 SDRAM
// Purpose          :
//                   Top-level testbench for testing DDR3.
//                   Instantiates:
//                     1. IP_TOP (top-level representing FPGA, contains core,
//                        clocking, built-in testbench/memory checker and other
//                        support structures)
//                     2. DDR3 Memory
//                     3. Miscellaneous clock generation and reset logic
//                     4. For ECC ON case inserts error on LSB bit
//                        of data from DRAM to FPGA.
// Reference        :
// Revision History :
//*****************************************************************************

`timescale 1ps/1ps

module sim_tb_top
import definitions_pkg::*;
();


   //***************************************************************************
   // Traffic Gen related parameters
   //***************************************************************************
   parameter SIMULATION            = "TRUE";
   parameter PORT_MODE             = "BI_MODE";
   //parameter DATA_MODE             = 4'b0010;
   parameter TST_MEM_INSTR_MODE    = "R_W_INSTR_MODE";
   parameter EYE_TEST              = "FALSE";
                                     // set EYE_TEST = "TRUE" to probe memory
                                     // signals. Traffic Generator will only
                                     // write to one single location and no
                                     // read transactions will be generated.
   parameter DATA_PATTERN          = "DGEN_ALL";
                                      // For small devices, choose one only.
                                      // For large device, choose "DGEN_ALL"
                                      // "DGEN_HAMMER", "DGEN_WALKING1",
                                      // "DGEN_WALKING0","DGEN_ADDR","
                                      // "DGEN_NEIGHBOR","DGEN_PRBS","DGEN_ALL"
   parameter CMD_PATTERN           = "CGEN_ALL";
                                      // "CGEN_PRBS","CGEN_FIXED","CGEN_BRAM",
                                      // "CGEN_SEQUENTIAL", "CGEN_ALL"
   parameter BEGIN_ADDRESS         = 32'h00000000;
   parameter END_ADDRESS           = 32'h00000fff;
   parameter PRBS_EADDR_MASK_POS   = 32'hff000000;

   //***************************************************************************
   // The following parameters refer to width of various ports
   //***************************************************************************
   parameter COL_WIDTH             = 10;
                                     // # of memory Column Address bits.
   parameter CS_WIDTH              = 1;
                                     // # of unique CS outputs to memory.
   parameter DM_WIDTH              = 4;
                                     // # of DM (data mask)
   parameter DQ_WIDTH              = 32;
                                     // # of DQ (data)
   parameter DQS_WIDTH             = 4;
   parameter DQS_CNT_WIDTH         = 2;
                                     // = ceil(log2(DQS_WIDTH))
   parameter DRAM_WIDTH            = 8;
                                     // # of DQ per DQS
   parameter ECC                   = "OFF";
   parameter RANKS                 = 1;
                                     // # of Ranks.
   parameter ODT_WIDTH             = 1;
                                     // # of ODT outputs to memory.
   parameter ROW_WIDTH             = 15;
                                     // # of memory Row Address bits.
   parameter ADDR_WIDTH            = 29;
                                     // # = RANK_WIDTH + BANK_WIDTH
                                     //     + ROW_WIDTH + COL_WIDTH;
                                     // Chip Select is always tied to low for
                                     // single rank devices
   //***************************************************************************
   // The following parameters are mode register settings
   //***************************************************************************
   parameter BURST_MODE            = "8";
                                     // DDR3 SDRAM:
                                     // Burst Length (Mode Register 0).
                                     // # = "8", "4", "OTF".
                                     // DDR2 SDRAM:
                                     // Burst Length (Mode Register).
                                     // # = "8", "4".
   parameter CA_MIRROR             = "OFF";
                                     // C/A mirror opt for DDR3 dual rank
   
   //***************************************************************************
   // The following parameters are multiplier and divisor factors for PLLE2.
   // Based on the selected design frequency these parameters vary.
   //***************************************************************************
   parameter CLKIN_PERIOD          = 5000;
   parameter CLKIN_PERIOD_NET      = 6666;
                                     // Input Clock Period


   //***************************************************************************
   // Simulation parameters
   //***************************************************************************
   parameter SIM_BYPASS_INIT_CAL   = "FAST";
                                     // # = "SIM_INIT_CAL_FULL" -  Complete
                                     //              memory init &
                                     //              calibration sequence
                                     // # = "SKIP" - Not supported
                                     // # = "FAST" - Complete memory init & use
                                     //              abbreviated calib sequence

   //***************************************************************************
   // IODELAY and PHY related parameters
   //***************************************************************************
   parameter TCQ                   = 100;
   //***************************************************************************
   // IODELAY and PHY related parameters
   //***************************************************************************
   parameter RST_ACT_LOW           = 1;
                                     // =1 for active low reset,
                                     // =0 for active high.

   //***************************************************************************
   // Referece clock frequency parameters
   //***************************************************************************
   parameter REFCLK_FREQ           = 200.0;
                                     // IODELAYCTRL reference clock frequency
   //***************************************************************************
   // System clock frequency parameters
   //***************************************************************************
   parameter tCK                   = 1250;
                                     // memory tCK paramter.
                     // # = Clock Period in pS.
   parameter nCK_PER_CLK           = 4;
                                     // # of memory CKs per fabric CLK

   

   //***************************************************************************
   // Debug and Internal parameters
   //***************************************************************************
   parameter DEBUG_PORT            = "OFF";
                                     // # = "ON" Enable debug signals/controls.
                                     //   = "OFF" Disable debug signals/controls.
   //***************************************************************************
   // Debug and Internal parameters
   //***************************************************************************
   parameter DRAM_TYPE             = "DDR3";

    

  //**************************************************************************//
  // Local parameters Declarations
  //**************************************************************************//

  localparam real TPROP_DQS          = 0.00;
                                       // Delay for DQS signal during Write Operation
  localparam real TPROP_DQS_RD       = 0.00;
                       // Delay for DQS signal during Read Operation
  localparam real TPROP_PCB_CTRL     = 0.00;
                       // Delay for Address and Ctrl signals
  localparam real TPROP_PCB_DATA     = 0.00;
                       // Delay for data signal during Write operation
  localparam real TPROP_PCB_DATA_RD  = 0.00;
                       // Delay for data signal during Read operation

  localparam MEMORY_WIDTH            = 16;
  localparam NUM_COMP                = DQ_WIDTH/MEMORY_WIDTH;
  localparam ECC_TEST 		   	= "OFF" ;
  localparam ERR_INSERT = (ECC_TEST == "ON") ? "OFF" : ECC ;
  

  localparam real REFCLK_PERIOD = (1000000.0/(2*REFCLK_FREQ));
  localparam RESET_PERIOD = 200000; //in pSec  
  localparam real SYSCLK_PERIOD = tCK;
    
  //PS ports
  wire [14:0]DDR_PS_addr;
  wire [2:0]DDR_PS_ba;
  wire  DDR_PS_ck_n;
  wire DDR_PS_ck_p;
  wire DDR_PS_cke;
  wire DDR_PS_cs_n;
  wire [3:0]DDR_PS_dm;
  wire [31:0]DDR_PS_dq;
  wire [3:0]DDR_PS_dqs_n;
  wire [3:0]DDR_PS_dqs_p;
  wire DDR_PS_odt;
  wire DDR_PS_ras_n;
  wire DDR_PS_reset_n;
  wire DDR_PS_we_n;
  wire FIXED_IO_ddr_vrn;
  wire FIXED_IO_ddr_vrp;
  wire [53:0]FIXED_IO_mio;
  wire FIXED_IO_ps_clk;
  wire FIXED_IO_ps_porb;
  wire FIXED_IO_ps_srstb;
  
  logic fan_pwm;

  //**************************************************************************//
  // Wire Declarations
  //**************************************************************************//
  reg                                sys_rst_n;
  logic                               sys_rst;


  reg                     sys_clk_i;
  logic                               sys_clk_p;
  logic                               sys_clk_n;
  logic      e_reset;
  logic      e_mdc;
  //logic       e_mdio;
  logic[3:0] rgmii_txd;
  logic      rgmii_txctl;
  logic      rgmii_txc;
  logic[3:0]  rgmii_rxd;
  logic       rgmii_rxctl;
  logic       rgmii_rxc;
  logic arp_request;

  reg clk_ref_i;

  
  logic                               ddr3_reset_n;
  wire [DQ_WIDTH-1:0]                ddr3_dq_fpga;
  wire [DQS_WIDTH-1:0]               ddr3_dqs_p_fpga;
  wire [DQS_WIDTH-1:0]               ddr3_dqs_n_fpga;
  logic [ROW_WIDTH-1:0]               ddr3_addr_fpga;
  logic [3-1:0]              ddr3_ba_fpga;
  logic                               ddr3_ras_n_fpga;
  logic                               ddr3_cas_n_fpga;
  logic                               ddr3_we_n_fpga;
  logic [1-1:0]               ddr3_cke_fpga;
  logic [1-1:0]                ddr3_ck_p_fpga;
  logic [1-1:0]                ddr3_ck_n_fpga;
    
  
  logic                               init_calib_complete;
  logic                               tg_compare_error;
  logic [(CS_WIDTH*1)-1:0] ddr3_cs_n_fpga;
    
  logic [DM_WIDTH-1:0]                ddr3_dm_fpga;
    
  logic [ODT_WIDTH-1:0]               ddr3_odt_fpga;
    
  
  reg [(CS_WIDTH*1)-1:0] ddr3_cs_n_sdram_tmp;
    
  reg [DM_WIDTH-1:0]                 ddr3_dm_sdram_tmp;
    
  reg [ODT_WIDTH-1:0]                ddr3_odt_sdram_tmp;
    

  
  wire [DQ_WIDTH-1:0]                ddr3_dq_sdram;
  reg [ROW_WIDTH-1:0]                ddr3_addr_sdram [0:1];
  reg [3-1:0]               ddr3_ba_sdram [0:1];
  reg                                ddr3_ras_n_sdram;
  reg                                ddr3_cas_n_sdram;
  reg                                ddr3_we_n_sdram;
  logic [(CS_WIDTH*1)-1:0] ddr3_cs_n_sdram;
  logic [ODT_WIDTH-1:0]               ddr3_odt_sdram;
  reg [1-1:0]                ddr3_cke_sdram;
  wire [DM_WIDTH-1:0]                ddr3_dm_sdram;
  wire [DQS_WIDTH-1:0]               ddr3_dqs_p_sdram;
  wire [DQS_WIDTH-1:0]               ddr3_dqs_n_sdram;
  reg [1-1:0]                 ddr3_ck_p_sdram;
  reg [1-1:0]                 ddr3_ck_n_sdram;
  logic [3:0]                   led;
  
    logic  s_axi_txn_done;

    logic ui_clk;
    logic ui_clk_sync_rst;

//**************************************************************************//
cloud_ports ports(.clock(ui_clk), .resetN(~ui_clk_sync_rst) , .*);
    cloud_top top(ports);
  //**************************************************************************//
  // Reset Generation
  //**************************************************************************//
  initial begin
    sys_rst_n = 1'b0;
    #RESET_PERIOD
      sys_rst_n = 1'b1;
   end

   assign sys_rst = RST_ACT_LOW ? sys_rst_n : ~sys_rst_n;

  //**************************************************************************//
  // Clock Generation
  //**************************************************************************//

  initial
    rgmii_rxc = 1'b0;
  always
    rgmii_rxc = #(CLKIN_PERIOD_NET/2.0) ~rgmii_rxc;


  initial
    sys_clk_i = 1'b0;
  always
    sys_clk_i = #(CLKIN_PERIOD/2.0) ~sys_clk_i;

  assign sys_clk_p = sys_clk_i;
  assign sys_clk_n = ~sys_clk_i;

  initial
    clk_ref_i = 1'b0;
  always
    clk_ref_i = #REFCLK_PERIOD ~clk_ref_i;




  always @( * ) begin
    ddr3_ck_p_sdram      <=  #(TPROP_PCB_CTRL) ddr3_ck_p_fpga;
    ddr3_ck_n_sdram      <=  #(TPROP_PCB_CTRL) ddr3_ck_n_fpga;
    ddr3_addr_sdram[0]   <=  #(TPROP_PCB_CTRL) ddr3_addr_fpga;
    ddr3_addr_sdram[1]   <=  #(TPROP_PCB_CTRL) (CA_MIRROR == "ON") ?
                                                 {ddr3_addr_fpga[ROW_WIDTH-1:9],
                                                  ddr3_addr_fpga[7], ddr3_addr_fpga[8],
                                                  ddr3_addr_fpga[5], ddr3_addr_fpga[6],
                                                  ddr3_addr_fpga[3], ddr3_addr_fpga[4],
                                                  ddr3_addr_fpga[2:0]} :
                                                 ddr3_addr_fpga;
    ddr3_ba_sdram[0]     <=  #(TPROP_PCB_CTRL) ddr3_ba_fpga;
    ddr3_ba_sdram[1]     <=  #(TPROP_PCB_CTRL) (CA_MIRROR == "ON") ?
                                                 {ddr3_ba_fpga[3-1:2],
                                                  ddr3_ba_fpga[0],
                                                  ddr3_ba_fpga[1]} :
                                                 ddr3_ba_fpga;
    ddr3_ras_n_sdram     <=  #(TPROP_PCB_CTRL) ddr3_ras_n_fpga;
    ddr3_cas_n_sdram     <=  #(TPROP_PCB_CTRL) ddr3_cas_n_fpga;
    ddr3_we_n_sdram      <=  #(TPROP_PCB_CTRL) ddr3_we_n_fpga;
    ddr3_cke_sdram       <=  #(TPROP_PCB_CTRL) ddr3_cke_fpga;
  end
    

  always @( * )
    ddr3_cs_n_sdram_tmp   <=  #(TPROP_PCB_CTRL) ddr3_cs_n_fpga;
  assign ddr3_cs_n_sdram =  ddr3_cs_n_sdram_tmp;
    

  always @( * )
    ddr3_dm_sdram_tmp <=  #(TPROP_PCB_DATA) ddr3_dm_fpga;//DM signal generation
  assign ddr3_dm_sdram = ddr3_dm_sdram_tmp;
    

  always @( * )
    ddr3_odt_sdram_tmp  <=  #(TPROP_PCB_CTRL) ddr3_odt_fpga;
  assign ddr3_odt_sdram =  ddr3_odt_sdram_tmp;
    

// Controlling the bi-directional BUS

  genvar dqwd;
  generate
    for (dqwd = 1;dqwd < DQ_WIDTH;dqwd = dqwd+1) begin : dq_delay
      WireDelay #
       (
        .Delay_g    (TPROP_PCB_DATA),
        .Delay_rd   (TPROP_PCB_DATA_RD),
        .ERR_INSERT ("OFF")
       )
      u_delay_dq
       (
        .A             (ddr3_dq_fpga[dqwd]),
        .B             (ddr3_dq_sdram[dqwd]),
        .reset         (sys_rst_n),
        .phy_init_done (init_calib_complete)
       );
    end
          WireDelay #
       (
        .Delay_g    (TPROP_PCB_DATA),
        .Delay_rd   (TPROP_PCB_DATA_RD),
        .ERR_INSERT ("OFF")
       )
      u_delay_dq_0
       (
        .A             (ddr3_dq_fpga[0]),
        .B             (ddr3_dq_sdram[0]),
        .reset         (sys_rst_n),
        .phy_init_done (init_calib_complete)
       );
  endgenerate

  genvar dqswd;
  generate
    for (dqswd = 0;dqswd < DQS_WIDTH;dqswd = dqswd+1) begin : dqs_delay
      WireDelay #
       (
        .Delay_g    (TPROP_DQS),
        .Delay_rd   (TPROP_DQS_RD),
        .ERR_INSERT ("OFF")
       )
      u_delay_dqs_p
       (
        .A             (ddr3_dqs_p_fpga[dqswd]),
        .B             (ddr3_dqs_p_sdram[dqswd]),
        .reset         (sys_rst_n),
        .phy_init_done (init_calib_complete)
       );

      WireDelay #
       (
        .Delay_g    (TPROP_DQS),
        .Delay_rd   (TPROP_DQS_RD),
        .ERR_INSERT ("OFF")
       )
      u_delay_dqs_n
       (
        .A             (ddr3_dqs_n_fpga[dqswd]),
        .B             (ddr3_dqs_n_sdram[dqswd]),
        .reset         (sys_rst_n),
        .phy_init_done (init_calib_complete)
       );
    end
  endgenerate
    

    

  //===========================================================================
  //                         FPGA Memory Controller
  //===========================================================================

  top 
   u_ip_top
     (

     .ddr3_dq              (ddr3_dq_fpga),
     .ddr3_dqs_n           (ddr3_dqs_n_fpga),
     .ddr3_dqs_p           (ddr3_dqs_p_fpga),

     .ddr3_addr            (ddr3_addr_fpga),
     .ddr3_ba              (ddr3_ba_fpga),
     .ddr3_ras_n           (ddr3_ras_n_fpga),
     .ddr3_cas_n           (ddr3_cas_n_fpga),
     .ddr3_we_n            (ddr3_we_n_fpga),
     .ddr3_reset_n         (ddr3_reset_n),
     .ddr3_ck_p            (ddr3_ck_p_fpga),
     .ddr3_ck_n            (ddr3_ck_n_fpga),
     .ddr3_cke             (ddr3_cke_fpga),
     .ddr3_cs_n            (ddr3_cs_n_fpga),
    
     .ddr3_dm              (ddr3_dm_fpga),
    
     .ddr3_odt             (ddr3_odt_fpga),

     .e_reset,
     .e_mdc,
     //.e_mdio,
     .rgmii_txd,
     .rgmii_txctl,
     .rgmii_txc,
     .rgmii_rxd,
     .rgmii_rxctl,
     .rgmii_rxc,
    
     .ui_clk_sync_rst,
     .ui_clk,
    .arp_request,
     .fan_pwm,
     .sys_clk_p            (sys_clk_p),
     .sys_clk_n            (sys_clk_n),
     .sys_rst              (sys_rst),
     .led                   (led)
    
     );

  //**************************************************************************//
  // Memory Models instantiations
  //**************************************************************************//

  genvar r,i;
  generate
    for (r = 0; r < CS_WIDTH; r = r + 1) begin: mem_rnk
      if(DQ_WIDTH/16) begin: mem
        for (i = 0; i < NUM_COMP; i = i + 1) begin: gen_mem
          ddr3_model u_comp_ddr3
            (
             .rst_n   (ddr3_reset_n),
             .ck      (ddr3_ck_p_sdram),
             .ck_n    (ddr3_ck_n_sdram),
             .cke     (ddr3_cke_sdram[r]),
             .cs_n    (ddr3_cs_n_sdram[r]),
             .ras_n   (ddr3_ras_n_sdram),
             .cas_n   (ddr3_cas_n_sdram),
             .we_n    (ddr3_we_n_sdram),
             .dm_tdqs (ddr3_dm_sdram[(2*(i+1)-1):(2*i)]),
             .ba      (ddr3_ba_sdram[r]),
             .addr    (ddr3_addr_sdram[r]),
             .dq      (ddr3_dq_sdram[16*(i+1)-1:16*(i)]),
             .dqs     (ddr3_dqs_p_sdram[(2*(i+1)-1):(2*i)]),
             .dqs_n   (ddr3_dqs_n_sdram[(2*(i+1)-1):(2*i)]),
             .tdqs_n  (),
             .odt     (ddr3_odt_sdram[r])
             );
        end
      end
      if (DQ_WIDTH%16) begin: gen_mem_extrabits
        ddr3_model u_comp_ddr3
          (
           .rst_n   (ddr3_reset_n),
           .ck      (ddr3_ck_p_sdram),
           .ck_n    (ddr3_ck_n_sdram),
           .cke     (ddr3_cke_sdram[r]),
           .cs_n    (ddr3_cs_n_sdram[r]),
           .ras_n   (ddr3_ras_n_sdram),
           .cas_n   (ddr3_cas_n_sdram),
           .we_n    (ddr3_we_n_sdram),
           .dm_tdqs ({ddr3_dm_sdram[DM_WIDTH-1],ddr3_dm_sdram[DM_WIDTH-1]}),
           .ba      (ddr3_ba_sdram[r]),
           .addr    (ddr3_addr_sdram[r]),
           .dq      ({ddr3_dq_sdram[DQ_WIDTH-1:(DQ_WIDTH-8)],
                      ddr3_dq_sdram[DQ_WIDTH-1:(DQ_WIDTH-8)]}),
           .dqs     ({ddr3_dqs_p_sdram[DQS_WIDTH-1],
                      ddr3_dqs_p_sdram[DQS_WIDTH-1]}),
           .dqs_n   ({ddr3_dqs_n_sdram[DQS_WIDTH-1],
                      ddr3_dqs_n_sdram[DQS_WIDTH-1]}),
           .tdqs_n  (),
           .odt     (ddr3_odt_sdram[r])
           );
      end
    end
  endgenerate
    
  initial
  begin : Logging
        begin : calibration_done
           wait (init_calib_complete);
           $display("Calibration Done");
        end  
  end


endmodule
