//`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/02/18 05:53:43
// Design Name: 
// Module Name: weightFifo
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module GIB
import definitions_pkg::*;
(
    input logic 		clock, resetN,
    input seq_t 		rama_finishedSeq,
    input seq_t 		ramb_finishedSeq,
    input seq_t 		pcwrite_finishedSeq,
    input logic         addressBuffer_empty,
    input mem_addr_t    addressBuffer_rdata,
    input logic         pcread_busValid,
    input logic         pcread_isFeature,
    input logic		pcread_RequestGIBValid,
    input ReturnData_t 	pread_dataBus,
    input logic         [BANK_NUM+1 : 0]cb_ibfull,
    input logic             hcb_isStopable[BANK_NUM],
    input logic             read_isStopable,
    input logic             write_isStopable,
    input logic             weight_isStopable,



    output logic            pif_AddOutput,
    output mem_addr_t       endInst_oAddr,
    output mem_addr_t       endInst_oSize,
    output logic            addressBuffer_ren,
    output logic            reqGIBValid,
    output RequestItem_t    reqGIB,
    output logic            cb_start[BANK_NUM],
    output logic            cb_stop[BANK_NUM],
    output logic 		    inst_enable[BANK_NUM],
    output InstructionHCB 	cb_inst[BANK_NUM],
    output logic 		    cwtinst_enable,
    output InstructionWeight    cwtinst,
    output logic 		    crinst_enable,
    output InstructionRead 	crinst,
    output logic 		    cwinst_enable,
    output InstructionWrite cwinst
);
parameter       REQUEST_SIZE = BRAM_BUS_WIDTH;
logic           fifo_srst;
mem_addr_t      address, address_next;
logic           addressValid;
logic           fetchMore, fetchMore_next;
logic           endValid;
gib_len_t       readLen, readLen_next;
gib_len_t       requestLen, requestLen_next;
gib_len_t       maxLen, maxLen_next;
InstructionType itype, itype_next;
logic           pendingRequest, pendingRequest_next;
logic           stopRequest, stopRequest_next;
InstructionEnd  endInst;
logic		data_received;
logic unsigned         [MAX_INST_LEN-1:0] [GIB_WIDTH-1:0]instBuf;
logic unsigned         [MAX_INST_LEN-1:0] [GIB_WIDTH-1:0]instBuf_next;
logic unsigned         [MAX_INST_LEN-2:0] [GIB_WIDTH-1:0]instBuf1;
seq_t           seq;
logic           output_ready;
logic           pi_noMore;
logic           doDecodeInstruction;
ReturnData_t    data;
logic unsigned         [REQUEST_SIZE / GIB_MULTI  - 1 : 0] [GIB_WIDTH-1:0] input_data;
//ubyte_t         [MAX_LOAD_WIDTH * FEATURE_BYTE_SIZE - 1 : 0]input_data;
InstructionOption       inst_option;
InstructionHCB  inst_hcb;
logic           inst_fifo_ren;
logic           inst_fifo_wen;
logic           inst_fifo_full;
logic           inst_fifo_empty;
InstructionEnd  inst_fifo_rdata;
InstructionEnd  inst_fifo_wdata;

assign inst_hcb = instBuf1;
assign inst_option = instBuf1;
assign instBuf1 = instBuf_next[MAX_INST_LEN-1:1];
assign data = pread_dataBus;
assign input_data = data.data;
assign output_ready  = endValid && seq >= endInst.reqSeqNum;
assign pif_AddOutput = output_ready;
assign endInst_oAddr = endInst.oAddr;
assign endInst_oSize = endInst.oSize;
assign inst_fifo_ren = !endValid && !inst_fifo_empty;
assign addressBuffer_ren = (~addressValid) && (~addressBuffer_empty);
always_ff @(posedge clock)
if (inst_fifo_ren) 
    endInst <= inst_fifo_rdata;

always_ff @(posedge clock)
if (!resetN)
    endValid <= 0;
else if(inst_fifo_ren)
    endValid <= 1;
else if(output_ready)
    endValid <= 0;

always_ff @(posedge clock)
if (!resetN)
    addressValid <= 0;
else if(addressBuffer_ren)
    addressValid <= 1;
else if(pi_noMore)
    addressValid <= 0;

always_comb
begin
    seq = 0;
    if(endValid) begin
        if(endInst.isRamA)
            seq = rama_finishedSeq;
        else if(endInst.isRamB)
            seq = ramb_finishedSeq;
        else
            seq = pcwrite_finishedSeq;
    end
end

always_ff @(posedge clock)
if (!resetN) begin
    {address, fetchMore, readLen, maxLen} <= '0;
    {itype, pendingRequest, instBuf, requestLen} <= '0;
    stopRequest <= 0;
end
else begin
    address <= address_next;
    fetchMore <= fetchMore_next;
    readLen <= readLen_next;
    requestLen <= requestLen_next;
    maxLen <= maxLen_next;
    itype <= itype_next;
    pendingRequest <= pendingRequest_next;
    stopRequest <= stopRequest_next;
    instBuf <= instBuf_next;
end

always_comb
begin
    doDecodeInstruction = 0;
    reqGIBValid = 0;
    address_next = address;
    fetchMore_next = fetchMore;
    readLen_next = readLen;
    requestLen_next = requestLen;
    maxLen_next = maxLen;
    itype_next = itype;
    instBuf_next = instBuf;
    pendingRequest_next = pendingRequest;
    reqGIB ='{default:0}; 
    if(!addressValid) begin
        if(!addressBuffer_empty)
            address_next = addressBuffer_rdata;
    end
    else if(pendingRequest) begin
	data_received = 0;
        if(pcread_busValid && !pcread_isFeature && data.dtype == TYPE_GIB) 
		data_received = 1;
	if(data_received)
	begin
            if (readLen == 0) begin
                itype_next = InstructionType'(data.data[0]);
                case (itype_next) 
                    OPTIONS: maxLen_next = (1 + InstructionOptionLength) * GIB_MULTI;
                    LOADWEIGHT: maxLen_next = (1 + InstructionWeightLength) * GIB_MULTI;
                    HCB: maxLen_next = (1 + InstructionHCBLength) * GIB_MULTI;
                    CREAD: maxLen_next = (1 + InstructionReadLength) * GIB_MULTI;
                    CWRITE: maxLen_next = (1 + InstructionWriteLength) * GIB_MULTI;
                    TEND: maxLen_next = (1 + InstructionEndLength) * GIB_MULTI;
                endcase
            end
            for(int i = 0; i < MAX_INST_LEN; i++) begin
                if(i >= readLen && i < readLen + data.len/GIB_MULTI)
                    instBuf_next[i] = input_data[i - readLen];
                else 
                    instBuf_next[i] = instBuf[i];
            end
            readLen_next = readLen + data.len/GIB_MULTI;
            if (readLen_next * GIB_MULTI == maxLen) begin
                doDecodeInstruction = 1;
                pendingRequest_next = 0;
                fetchMore_next = 0;
            end
        end
	if(data_received || readLen != 0)
	  if (requestLen * GIB_MULTI < maxLen_next && !pcread_RequestGIBValid)
            begin
                automatic logic unsigned [7 : 0] len;
                if (requestLen * GIB_MULTI + REQUEST_SIZE  > maxLen_next)
                    len = maxLen_next - requestLen * GIB_MULTI;
                else
                    len = REQUEST_SIZE ;
                reqGIBValid = 1;
                reqGIB.addr = address;
                reqGIB.isRamA = 0;
                reqGIB.isRamB = 0;
                reqGIB.len = len;
                reqGIB.seq = 0;
                reqGIB.token = 0;
                reqGIB.dtype = TYPE_GIB;
		address_next = address + len;
		requestLen_next = requestLen + len / GIB_MULTI; 
            end
    end 
    else begin
        if (fetchMore) begin
            reqGIB.addr = address;
            reqGIB.isRamA = 0;
            reqGIB.isRamB = 0;
            reqGIB.len = GIB_MULTI;
            reqGIB.seq = 0;
            reqGIB.token = 0;
            reqGIB.dtype = TYPE_GIB;
            reqGIBValid = 1;
            pendingRequest_next = 1;
            readLen_next = 0;
	    address_next = address + GIB_MULTI;
	    requestLen_next = 1; 
        end 
        else begin
            if((!stopRequest) && (!(|cb_ibfull)))
                fetchMore_next = 1;
        end
    end
end

always_comb
begin
    for(int i = 0; i < BANK_NUM; i++) begin
        cb_stop[i]  = 0;
    end
    stopRequest_next = stopRequest;
    if(stopRequest) begin
        if(read_isStopable && write_isStopable &&weight_isStopable &&  hcb_isStopable[0]
            &&  hcb_isStopable[1] &&  hcb_isStopable[2] &&  hcb_isStopable[3]) begin
                stopRequest_next = 0;
                cb_stop = '{default:1};

            end
    end
    else if(doDecodeInstruction) begin
        if(itype == OPTIONS && inst_option.stop)
                stopRequest_next = 1;
    end
end
//DecodeInstruction
always_comb
begin
    for(int i = 0; i < BANK_NUM; i++) begin
        cb_start[i] = 0;
        inst_enable[i] = 0;
        cb_inst[i] = '{default:0};
    end
    cwtinst_enable = 0;
    cwinst_enable = 0;
    crinst_enable = 0;
    pi_noMore = 0;
    cwtinst = '{default:0};
    cwinst = '{default:0};
    crinst = '{default:0};
    inst_fifo_wen = 0;
    inst_fifo_wdata = '{default:0};
    if(doDecodeInstruction) begin
        case (itype) 
            OPTIONS: begin
                if(inst_option.start)
                    cb_start = '{default:1};
            end
            LOADWEIGHT: begin
                cwtinst_enable = 1;
                cwtinst = instBuf1;
            end
            HCB: begin
                inst_enable[inst_hcb.Id] = 1;
                cb_inst[inst_hcb.Id] = instBuf1;
            end
            CREAD: begin 
                crinst_enable = 1;
                crinst = instBuf1;
            end

            CWRITE: begin
                cwinst_enable = 1;
                cwinst = instBuf1;
            end
            TEND: begin
                inst_fifo_wdata = instBuf1;
                inst_fifo_wen = 1;
                pi_noMore = !inst_fifo_wdata.hasMore;
            end
        endcase
    end
end

//End inst fifo
assign fifo_srst = ~resetN;
fifo_InstructionEnd fifo_einst(
    .clk(clock)	, 		    .srst(fifo_srst), 
    .din(inst_fifo_wdata), 	.wr_en(inst_fifo_wen), 
    .rd_en(inst_fifo_ren), 	.dout(inst_fifo_rdata), 
.full(inst_fifo_full), 	.empty(inst_fifo_empty));


endmodule
