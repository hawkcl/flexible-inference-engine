`ifndef GIB_PORTS_SV
`define GIB_PORTS_SV

`timescale 1ns / 1ns
interface GIB_ports 
import definitions_pkg::*;
(
    input logic clock, 
    output logic resetN,
    output seq_t 		rama_finishedSeq,
    output seq_t 		ramb_finishedSeq,
    output seq_t 		pcwrite_finishedSeq,
    output logic         addressBuffer_empty,
    output mem_addr_t    addressBuffer_rdata,
    output logic         pcread_busValid,
    output logic         pcread_isFeature,
    output logic         pcread_RequestGIBValid,
    output ReturnData_t 	pread_dataBus,
    output logic         [BANK_NUM+1 : 0]cb_ibfull,
    output logic             hcb_isStopable[BANK_NUM],
    output logic             read_isStopable,
    output logic             write_isStopable,
    output logic             weight_isStopable,

    input logic            pif_AddOutput,
    input mem_addr_t       endInst_oAddr,
    input mem_addr_t       endInst_oSize,
    input logic            addressBuffer_ren,
    input logic            reqGIBValid,
    input RequestItem_t    reqGIB,
    input logic            cb_start[BANK_NUM],
    input logic            cb_stop[BANK_NUM],
    input logic 		    inst_enable[BANK_NUM],
    input InstructionHCB 	cb_inst[BANK_NUM],
    input logic 		    cwtinst_enable,
    input InstructionWeight    cwtinst,
    input logic 		    crinst_enable,
    input InstructionRead 	crinst,
    input logic 		    cwinst_enable,
    input InstructionWrite cwinst
);
endinterface



`endif
