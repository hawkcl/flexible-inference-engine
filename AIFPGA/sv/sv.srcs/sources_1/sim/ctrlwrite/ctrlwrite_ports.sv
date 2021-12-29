`ifndef Cw_PORTS_SV
`define Cw_PORTS_SV

`timescale 1ns / 1ns
interface ctrlwrite_ports 
import definitions_pkg::*;
(
    input logic clock, 
    output logic resetN,
    output logic 		cwinst_enable,
    output InstructionWrite 	cwinst,
    output seq_t         cb0_finishedSeq,
    output logic         [BANK_NUM - 1: 0]cb_isFetchNextInst,
    output logic         pwrite_setNextInst[BANK_NUM],

    output s_feature_t 	[COMPUTING_GROUP_SIZE-1:0] pwrite_data[BANK_NUM],
    output logic 		[BANK_NUM-1:0] pwrite_enable,
    output mem_addr_t 	pwrite_addr[BANK_NUM],
    output logic        ddr_write_ready,

    input seq_t        pwrite_finishedSeq,
    input logic        pwrite_isFetchNextInst,
    input logic        pwrite_isWritable[BANK_NUM],

    input logic        ddr_write_enable,
    input mem_addr_t   ddr_write_addr,
    input logic   [DDR_LEN_WIDTH-1 : 0]    ddr_write_len,
    input logic        rama_write_enable,
    input logic        ramb_write_enable,
    input logic         isStopable,
    input mem_addr_t   ram_write_addr,
    input ctrl_width_t    ram_write_len,
    input s_feature_t  [BRAM_BUS_WIDTH - 1 : 0] outbuf
);
endinterface



`endif
