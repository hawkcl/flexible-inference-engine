`ifndef CR_PORTS_SV
`define CR_PORTS_SV

`timescale 1ns / 1ns
interface ctrlread_ports 
import definitions_pkg::*;
(
    input logic clock, 
    output logic resetN,
    output logic 		crinst_enable,
    output InstructionRead 	crinst,

    output logic         cb_isRunning[BANK_NUM],
    output logic         cb_isReadingFeatures[BANK_NUM],
    output logic         cb_isLoadingFroze[BANK_NUM],
    output seq_t         cb_ReqFeature[BANK_NUM],
    output seq_t         cb_FinishedSeq[BANK_NUM],
    output seq_t         cb_WorkingSeq[BANK_NUM],
    output seq_t         cb_WorkingProgress[BANK_NUM],

    output logic         ddr_read_ready,
    output logic         [BANK_NUM - 1:0]requestValid,
    output RequestItem_t ritem[BANK_NUM],
    output logic         reqGIBValid,
    output RequestItem_t reqGIB,

    output ddr_id_t                              ddr_data_id,
    output s_feature_t  	[MAX_LOAD_WIDTH - 1 : 0]ddr_data,
    output s_feature_t  	[MAX_LOAD_WIDTH - 1 : 0]rama_data,
    output s_feature_t  	[MAX_LOAD_WIDTH - 1 : 0]ramb_data,


    input logic        ddr_enable,
    input mem_addr_t   ddr_addr,
    input ctrl_width_t ddr_len,
    input ddr_id_t     ddr_id,
    input logic        rama_ren,
    input logic        ramb_ren,
    input mem_addr_t   ram_addr,
    input ctrl_width_t ram_len,

    input logic         pread_waitForSeq,
    input logic 	    pread_busValid,
    input logic 		pread_isFeature,
    input logic         pread_RequestFull,
    input logic         isStopable,
    input seq_t         pread_SeqNum,
    input s_feature_t 	[MAX_LOAD_WIDTH - 1 : 0]data_bus,
    ReturnData_t        data_bus_ret
);
endinterface



`endif
