 `timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/02/2019 12:17:37 AM
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0_01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module rv_top_wrapper
import definitions_pkg::*;
(
    input  logic                            clock,
    input  logic                            reset,
    input  logic                            addrbuf_enable,
    input  logic [XLEN-1 :0 ]               inst_address,
    input  logic                            set_base_addr_enable,
    input  logic [XLEN-1 :0 ]               new_base_feature_address,
    input  logic [XLEN-1 :0 ]               new_base_weight_address,
    output logic                            interrupt,
    output logic [DDR_ADDR_WIDTH-1:0]       interrupt_address,


    input  logic                            weight_axi_aw_ready,
    output logic                            weight_axi_aw_valid,
    output logic [C_M_AXI_ID_WIDTH-1:0]     weight_axi_aw_bits_id,
    output logic [AXI4_ADDR_WIDTH-1:0]      weight_axi_aw_bits_addr,
    output logic [AXI4_LEN_WIDTH-1:0]       weight_axi_aw_bits_len,
    output logic [AXI4_SIZE_WIDTH-1:0]      weight_axi_aw_bits_size,
    output logic [1:0]                      weight_axi_aw_bits_burst,
    output logic [0:0]                      weight_axi_aw_bits_lock,
    output logic [3:0]                      weight_axi_aw_bits_cache,
    output logic [2:0]                      weight_axi_aw_bits_prot,
    output logic [3:0]                      weight_axi_aw_bits_qos,

    input  logic                            weight_axi_w_ready,
    output logic                            weight_axi_w_valid,
    output logic [DDR_DATAWIDTH*8 - 1:0]    weight_axi_w_bits_data,
    output logic [DDR_DATAWIDTH - 1:0]      weight_axi_w_bits_strb,
    output logic                            weight_axi_w_bits_last,

    output logic                            weight_axi_b_ready,
    input  logic                            weight_axi_b_valid,
    input  logic [C_M_AXI_ID_WIDTH-1:0]     weight_axi_b_bits_id,
    input  logic [1:0]                      weight_axi_b_bits_resp,
    
    input  logic                            weight_axi_ar_ready,
    output logic                            weight_axi_ar_valid,
    output logic [C_M_AXI_ID_WIDTH-1:0]     weight_axi_ar_bits_id,
    output logic [AXI4_ADDR_WIDTH-1:0]      weight_axi_ar_bits_addr,
    output logic [AXI4_LEN_WIDTH-1:0]       weight_axi_ar_bits_len,
    output logic [AXI4_SIZE_WIDTH-1:0]      weight_axi_ar_bits_size,
    output logic [1:0]                      weight_axi_ar_bits_burst,
    output logic [0:0]                      weight_axi_ar_bits_lock,
    output logic [3:0]                      weight_axi_ar_bits_cache,
    output logic [2:0]                      weight_axi_ar_bits_prot,
    output logic [3:0]                      weight_axi_ar_bits_qos,

    output logic                            weight_axi_r_ready,
    input  logic                            weight_axi_r_valid,
    input  logic [C_M_AXI_ID_WIDTH-1:0]     weight_axi_r_bits_id,
    input  logic [DDR_DATAWIDTH*8 - 1:0]    weight_axi_r_bits_data,
    input  logic [1:0]                      weight_axi_r_bits_resp,
    input  logic                            weight_axi_r_bits_last,
 
  
    input  logic                            feature_axi_aw_ready,
    output logic                            feature_axi_aw_valid,
    output logic [C_M_AXI_ID_WIDTH-1:0]     feature_axi_aw_bits_id,
    output logic [AXI4_ADDR_WIDTH-1:0]      feature_axi_aw_bits_addr,
    output logic [AXI4_LEN_WIDTH-1:0]       feature_axi_aw_bits_len,
    output logic [AXI4_SIZE_WIDTH-1:0]      feature_axi_aw_bits_size,
    output logic [1:0]                      feature_axi_aw_bits_burst,
    output logic [0:0]                      feature_axi_aw_bits_lock,
    output logic [3:0]                      feature_axi_aw_bits_cache,
    output logic [2:0]                      feature_axi_aw_bits_prot,
    output logic [3:0]                      feature_axi_aw_bits_qos,

    input  logic                            feature_axi_w_ready,
    output logic                            feature_axi_w_valid,
    output logic [DDR_DATAWIDTH*8 - 1:0]    feature_axi_w_bits_data,
    output logic [DDR_DATAWIDTH - 1:0]      feature_axi_w_bits_strb,
    output logic                            feature_axi_w_bits_last,

    output logic                            feature_axi_b_ready,
    input  logic                            feature_axi_b_valid,
    input  logic [C_M_AXI_ID_WIDTH-1:0]     feature_axi_b_bits_id,
    input  logic [1:0]                      feature_axi_b_bits_resp,
    
    input  logic                            feature_axi_ar_ready,
    output logic                            feature_axi_ar_valid,
    output logic [C_M_AXI_ID_WIDTH-1:0]     feature_axi_ar_bits_id,
    output logic [AXI4_ADDR_WIDTH-1:0]      feature_axi_ar_bits_addr,
    output logic [AXI4_LEN_WIDTH-1:0]       feature_axi_ar_bits_len,
    output logic [AXI4_SIZE_WIDTH-1:0]      feature_axi_ar_bits_size,
    output logic [1:0]                      feature_axi_ar_bits_burst,
    output logic [0:0]                      feature_axi_ar_bits_lock,
    output logic [3:0]                      feature_axi_ar_bits_cache,
    output logic [2:0]                      feature_axi_ar_bits_prot,
    output logic [3:0]                      feature_axi_ar_bits_qos,

    output logic                            feature_axi_r_ready,
    input  logic                            feature_axi_r_valid,
    input  logic [C_M_AXI_ID_WIDTH-1:0]     feature_axi_r_bits_id,
    input  logic [DDR_DATAWIDTH*8 - 1:0]    feature_axi_r_bits_data,
    input  logic [1:0]                      feature_axi_r_bits_resp,
    input  logic                            feature_axi_r_bits_last
);

rv_top axi_top
(
    .ui_clk(clock),
    .aresetn(~reset),
        
    .addrbuf_enable(addrbuf_enable),
    .inst_address(inst_address),

    .set_base_addr_enable(set_base_addr_enable),
    .new_base_feature_address(new_base_feature_address),
    .new_base_weight_address(new_base_weight_address),

    .add_output(interrupt),
    .add_output_address(interrupt_address),
    .add_output_size(),

    //axi0
    .s_axi0_awid(feature_axi_aw_bits_id),
    .s_axi0_awaddr(feature_axi_aw_bits_addr),
    .s_axi0_awlen(feature_axi_aw_bits_len),
    .s_axi0_awsize(feature_axi_aw_bits_size),
    .s_axi0_awburst(feature_axi_aw_bits_burst),
    .s_axi0_awlock(feature_axi_aw_bits_lock),
    .s_axi0_awcache(feature_axi_aw_bits_cache),
    .s_axi0_awprot(feature_axi_aw_bits_prot),
    .s_axi0_awqos(feature_axi_aw_bits_qos),
    .s_axi0_awvalid(feature_axi_aw_valid),
    .s_axi0_awready(feature_axi_aw_ready),
    .s_axi0_wdata(feature_axi_w_bits_data),
    .s_axi0_wstrb(feature_axi_w_bits_strb),
    .s_axi0_wlast(feature_axi_w_bits_last),
    .s_axi0_wvalid(feature_axi_w_valid),
    .s_axi0_wready(feature_axi_w_ready),
    .s_axi0_bready(feature_axi_b_ready),
    .s_axi0_bresp(feature_axi_b_bits_resp),
    .s_axi0_bvalid(feature_axi_b_valid),
    .s_axi0_arid(feature_axi_ar_bits_id),
    .s_axi0_araddr(feature_axi_ar_bits_addr),
    .s_axi0_arlen(feature_axi_ar_bits_len),
    .s_axi0_arsize(feature_axi_ar_bits_size),
    .s_axi0_arburst(feature_axi_ar_bits_burst),
    .s_axi0_arlock(feature_axi_ar_bits_lock),
    .s_axi0_arcache(feature_axi_ar_bits_cache),
    .s_axi0_arprot(feature_axi_ar_bits_prot),
    .s_axi0_arqos(feature_axi_ar_bits_qos),
    .s_axi0_arvalid(feature_axi_ar_valid),
    .s_axi0_arready(feature_axi_ar_ready),
    .s_axi0_rready(feature_axi_r_ready),
    .s_axi0_rdata(feature_axi_r_bits_data),
    .s_axi0_rresp(feature_axi_r_bits_resp),
    .s_axi0_rlast(feature_axi_r_bits_last),
    .s_axi0_rvalid(feature_axi_r_valid),
    .s_axi0_arregion(),
    .s_axi0_awregion(),

    //ps_axi
    .ps_axi_awid(weight_axi_aw_bits_id),
    .ps_axi_awaddr(weight_axi_aw_bits_addr),
    .ps_axi_awlen(weight_axi_aw_bits_len),
    .ps_axi_awsize(weight_axi_aw_bits_size),
    .ps_axi_awburst(weight_axi_aw_bits_burst),
    .ps_axi_awlock(weight_axi_aw_bits_lock),
    .ps_axi_awcache(weight_axi_aw_bits_cache),
    .ps_axi_awprot(weight_axi_aw_bits_prot),
    .ps_axi_awqos(weight_axi_aw_bits_qos),
    .ps_axi_awvalid(weight_axi_aw_valid),
    .ps_axi_awready(weight_axi_aw_ready),
    .ps_axi_wdata(weight_axi_w_bits_data),
    .ps_axi_wstrb(weight_axi_w_bits_strb),
    .ps_axi_wlast(weight_axi_w_bits_last),
    .ps_axi_wvalid(weight_axi_w_valid),
    .ps_axi_wready(weight_axi_w_ready),
    .ps_axi_bready(weight_axi_b_ready),
    .ps_axi_bresp(weight_axi_b_bits_resp),
    .ps_axi_bvalid(weight_axi_b_valid),
    .ps_axi_arid(weight_axi_ar_bits_id),
    .ps_axi_araddr(weight_axi_ar_bits_addr),
    .ps_axi_arlen(weight_axi_ar_bits_len),
    .ps_axi_arsize(weight_axi_ar_bits_size),
    .ps_axi_arburst(weight_axi_ar_bits_burst),
    .ps_axi_arlock(weight_axi_ar_bits_lock),
    .ps_axi_arcache(weight_axi_ar_bits_cache),
    .ps_axi_arprot(weight_axi_ar_bits_prot),
    .ps_axi_arqos(weight_axi_ar_bits_qos),
    .ps_axi_arvalid(weight_axi_ar_valid),
    .ps_axi_arready(weight_axi_ar_ready),
    .ps_axi_rready(weight_axi_r_ready),
    .ps_axi_rdata(weight_axi_r_bits_data),
    .ps_axi_rresp(weight_axi_r_bits_resp),
    .ps_axi_rlast(weight_axi_r_bits_last),
    .ps_axi_rvalid(weight_axi_r_valid),
    .ps_axi_arregion(),
    .ps_axi_awregion()
);

endmodule
