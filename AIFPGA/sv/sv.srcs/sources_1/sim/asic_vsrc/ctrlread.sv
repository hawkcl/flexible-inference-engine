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
module ProcessReadInstruction
import definitions_pkg::*;
(
input logic 		clock, resetN,
input logic         inst_fifo_ren,
input InstructionRead   inst,

output seq_t           reqSeq,
output seq_t           seqNumNew,
output seq_t           reqProgress,
output out_width_t     w,
output DATA_MODE 	   mode,
output layer_addr_t    readCLast,
output outframe_addr_t     frameSize,
output mem_addr_t      Oaddr,
output logic           isReadA,
output logic           isReadB,
output mem_addr_t 	   lastPos,
`ifdef S2_OPTIMIZE
output logic           isStride2,
`endif

output ctrl_width_t    readWidth,
output ctrl_width_t    dataWidth,
output out_width_t     readYLast,
output out_width_t     readYStart
);
/*
seq_t           reqSeq;
seq_t           seqNumNew;
seq_t           reqProgress;
out_width_t     w;
DATA_MODE 		mode;
layer_addr_t    readCLast;
outframe_addr_t     frameSize;
mem_addr_t      Oaddr;
logic           isReadA;
logic           isReadB;
mem_addr_t 		lastPos;
`ifdef S2_OPTIMIZE
logic           isStride2;
`endif

ctrl_width_t    readWidth, readWidth_next;
ctrl_width_t    dataWidth, dataWidth_next;
out_width_t     readYLast, readYLast_next;
out_width_t     readYStart, readYStart_next;
*/
ctrl_width_t    readWidth_next;
ctrl_width_t    dataWidth_next;
out_width_t     readYLast_next;
out_width_t     readYStart_next;

always_ff @(posedge clock)
if (!resetN) begin
    {reqSeq, seqNumNew, reqProgress, w, mode, readCLast} <= '0;
    {frameSize, Oaddr, isReadA, isReadB, lastPos} <= '0;
`ifdef S2_OPTIMIZE
    isStride2 <= 1'b0;
`endif
end
else if(inst_fifo_ren) 
begin
    reqSeq <= inst.reqSeqNum;
	seqNumNew <= inst.seqNum;
    reqProgress <= inst.reqProgress;
	w <= inst.W;
	mode <= inst.mode;
    readCLast <= inst.C - 1;
    frameSize <= inst.W * inst.H;
    Oaddr <= inst.Maddr;
    isReadA <= inst.isMaddr_a;
	isReadB <= inst.isMaddr_b;
    lastPos <= inst.W * inst.H * inst.C;
`ifdef S2_OPTIMIZE
    isStride2 <= (inst.S == 2);
`endif
end
  
always_ff @(posedge clock)
if (!resetN) 
    {readWidth, dataWidth, readYLast, readYStart} <= '0;
else
    {readWidth, dataWidth, readYLast, readYStart} <= 
    {readWidth_next, dataWidth_next, readYLast_next, readYStart_next};
always_comb
begin
    readWidth_next = readWidth;
    dataWidth_next = dataWidth;
    readYLast_next = readYLast;
    readYStart_next = readYStart;
    if(inst_fifo_ren) begin
        automatic ctrl_width_t  rw;
        automatic out_width_t   nextx; 
        automatic out_width_t   ys; 
        automatic out_width_t   yl; 
		if (inst.mode == MODE_FOUR)
			rw = inst.W1;
		else if (inst.mode == MODE_TWO)
			rw = (inst.W1 + inst.W2);
		else
			rw = (inst.W1 * 3 + inst.W2);
`ifdef S2_OPTIMIZE
		if (inst.S == 2)
			rw = rw * 2;
`endif
		nextx = inst.X;
		
		//if (inst.lPad > 0)
            if (inst.X > 0) begin
				rw = rw + inst.lPad;
				nextx = nextx - inst.lPad;
            end
		
		//if (inst.rPad > 0)
			if (inst.X + rw < inst.W)
				rw = rw + inst.rPad;
		
		dataWidth_next = rw;
`ifdef S2_OPTIMIZE
        if (inst.S == 2) begin
			if(inst.mode == MODE_FOUR)
				readWidth_next = rw * 2;
			else
				readWidth_next = rw;
        end else
`endif
		if (inst.mode == MODE_TWO) // assert( W == 20) for yolo
			readWidth_next = rw << 1;
		else if (inst.mode == MODE_FOUR) // assert( W == 10)
			readWidth_next = rw << 2;
		else
			readWidth_next = rw;
		
		ys = inst.Y;
		yl = inst.Y + inst.H1;

		if (inst.lPad > 0)
			if (inst.Y > 0)
				ys = ys - inst.lPad;
			
		if (inst.rPad > 0)
			if (inst.Y + inst.H1 != inst.H - 1)
				yl = yl + inst.rPad;
		
		readYStart_next = ys;
		readYLast_next = yl;
    end
end
endmodule

module ProduceInputs
import definitions_pkg::*;
(
    input logic 		retq_fifo_empty,
    ReturnData_t  	    retq_fifo_rdata,
    input logic 		data_fifo_empty,
    input s_feature_t  	[MAX_LOAD_WIDTH - 1 : 0] data_fifo_rdata,
    input seq_t         seqNum,
    input logic         waiting_feature,

    input logic         cb_isRunning[BANK_NUM],
    input seq_t         cb_ReqFeature[BANK_NUM],
    //input logic         cb_isReadingFeatures[BANK_NUM],
    //input logic         cb_isLoadingFroze[BANK_NUM],

    output logic        retq_fifo_ren,
    output logic 		data_fifo_ren,
    output logic 		pread_busValid,
    output logic 		pread_isFeature,
    output s_feature_t 	[MAX_LOAD_WIDTH - 1 : 0]data_bus
);
logic                     enable_retq;
logic                     enable_data_fifo;
logic [BANK_NUM - 1:0]    skip_hcb;
logic                     do_skip;

assign enable_retq = (do_skip || waiting_feature || data_fifo_empty) && (!retq_fifo_empty);
assign enable_data_fifo = !(do_skip || waiting_feature || data_fifo_empty);
assign retq_fifo_ren = enable_retq;
assign data_fifo_ren = enable_data_fifo;
assign pread_busValid = enable_retq | enable_data_fifo;
assign pread_isFeature = !enable_retq;
assign data_bus = enable_retq ? retq_fifo_rdata : data_fifo_rdata;

always_comb
begin
    for(int i =0; i < BANK_NUM; i++)
        skip_hcb[i] = !(cb_isRunning[i] && (cb_ReqFeature[i] == seqNum));
end
assign do_skip = | skip_hcb;


always_comb
begin
    if(pread_busValid && pread_isFeature)
        $write("data bus %d %d %d %d\n", data_bus[0], data_bus[1], data_bus[2], data_bus[3]);
end
endmodule

module ReadExtData
import definitions_pkg::*;
(
    input logic 		clock, resetN,
    input logic         fifo_srst,
    input logic 		reqq_fifo_empty,
    input logic         reqGIBValid0,
    input RequestItem_t reqGIB0,
    input RequestItem_t  	reqq_fifo_rdata,
    input logic            ddr_enable_data,
    input logic         ddr_read_ready,

    input logic                                 ext_ddr_data_valid,
    input s_feature_t  	[MAX_LOAD_WIDTH - 1 : 0]ddr_data,
    input s_feature_t  	[MAX_LOAD_WIDTH - 1 : 0]rama_data,
    input s_feature_t  	[MAX_LOAD_WIDTH - 1 : 0]ramb_data,

    output logic        reset_reqGIBValid,
    output logic        ddr_enable_ext,
    output mem_addr_t   ddr_addr_ext,
    output ctrl_width2_t ddr_len_ext,
    output logic        rama_ren_ext,
    output logic        ramb_ren_ext,
    output mem_addr_t   ram_addr_ext,
    output ctrl_width_t ram_len_ext,
    output logic 		retq_fifo_wen,
    output ReturnData_t    retq_fifo_wdata,
    output logic 			reqq_fifo_ren
);
logic                   enable_GIB;
logic                   enable_req;
logic                   req_ram_valid_A;
logic                   req_ram_valid_B;
logic                   req_ram_valid;
RequestItem_t           last_ri;

logic 			reqq_fifo_ddr_ren;
logic 			reqq_fifo_ddr_wen;
logic 			reqq_fifo_ddr_empty;
logic 			reqq_fifo_ddr_full;
RequestItem_t   reqq_fifo_ddr_wdata;
RequestItem_t  	reqq_fifo_ddr_rdata;

//ask
assign enable_req = !reqq_fifo_empty && !ddr_enable_data && 
(reqq_fifo_rdata.isRamA || reqq_fifo_rdata.isRamB ||(!reqq_fifo_ddr_full) && ddr_read_ready);// assume isRamA available without ren
assign enable_GIB =  reqq_fifo_empty && reqGIBValid0 && !ddr_enable_data && !reqq_fifo_ddr_full && ddr_read_ready;
assign reset_reqGIBValid = enable_GIB;
assign reqq_fifo_ren = enable_req;
assign ddr_enable_ext = enable_GIB || enable_req && !reqq_fifo_rdata.isRamA 
                        && !reqq_fifo_rdata.isRamB;
assign ramb_ren_ext = enable_req && !reqq_fifo_rdata.isRamA && reqq_fifo_rdata.isRamB;
assign rama_ren_ext = enable_req && reqq_fifo_rdata.isRamA;
assign ddr_addr_ext = enable_GIB ? reqGIB0.addr : reqq_fifo_rdata.addr;
assign ddr_len_ext  = enable_GIB ? reqGIB0.len : 
    ((($clog2(MAX_READ_WIDTH) + 1)'(reqq_fifo_rdata.len)) * FEATURE_BYTE_SIZE);
assign ram_addr_ext = reqq_fifo_rdata.addr;
assign ram_len_ext  = reqq_fifo_rdata.len;
assign reqq_fifo_ddr_wen = ddr_enable_ext;
assign reqq_fifo_ddr_wdata = enable_GIB ? reqGIB0 : reqq_fifo_rdata;

always_ff @(posedge clock)
if (!resetN)
    req_ram_valid_A <= '0;
else
    req_ram_valid_A <= rama_ren_ext;
always_ff @(posedge clock)
if (!resetN)
    req_ram_valid_B <= '0;
else
    req_ram_valid_B <= ramb_ren_ext;
always_ff @(posedge clock)
if (!resetN)
    last_ri <= '0;
else // enable to save power if(rama_ren_ext || ramb_ren_ext)
    last_ri <= reqq_fifo_rdata;


//read
assign req_ram_valid = req_ram_valid_A || req_ram_valid_B;
assign reqq_fifo_ddr_ren = (!req_ram_valid) && ext_ddr_data_valid;
assign retq_fifo_wen =  req_ram_valid || ext_ddr_data_valid;
assign retq_fifo_wdata.len = req_ram_valid ? last_ri.len : reqq_fifo_ddr_rdata.len;
assign retq_fifo_wdata.token = req_ram_valid ? last_ri.token : reqq_fifo_ddr_rdata.token;
assign retq_fifo_wdata.dtype = req_ram_valid ? last_ri.dtype : reqq_fifo_ddr_rdata.dtype;
assign retq_fifo_wdata.seq = req_ram_valid ? last_ri.seq : reqq_fifo_ddr_rdata.seq;
assign retq_fifo_wdata.data = req_ram_valid_A ? rama_data : 
                (req_ram_valid_B ? ramb_data : ddr_data );

fifo_ctrlread_req fifo_req_ddr(
	    .clk(clock)	, 		    .srst(fifo_srst), 
	    .din(reqq_fifo_ddr_wdata),  .wr_en(reqq_fifo_ddr_wen), 
	    .rd_en(reqq_fifo_ddr_ren), 	.dout(reqq_fifo_ddr_rdata), 
	    .full(reqq_fifo_ddr_full), 	.empty(reqq_fifo_ddr_empty));

endmodule

module ReadData
import definitions_pkg::*;
(
    input logic 		    clock, resetN,
    input logic             fifo_srst,
    //input seq_t             cb_FinishedSeq[BANK_NUM],
    //input seq_t             cb_WorkingSeq[BANK_NUM],
    //input seq_t             cb_WorkingProgress[BANK_NUM],
    input logic         waiting_feature,
    input logic             enable_readdata,
    input logic         ddr_read_ready,
    input InstructionRead   inst,
    input seq_t             reqSeq,
    input seq_t             reqProgress,
    input seq_t             seqNumNew,
    input out_width_t       w,
    input DATA_MODE 	    mode,
    input layer_addr_t      readCLast,
    input outframe_addr_t   frameSize,
    input mem_addr_t        Oaddr,
    input logic             isReadA,
    input logic             isReadB,
    input mem_addr_t	    lastPos,
`ifdef S2_OPTIMIZE
    input logic             isStride2,
`endif

    input ctrl_width_t      readWidth,
    input ctrl_width_t      dataWidth,
    input out_width_t       readYLast,
    input out_width_t       readYStart,
    input logic             inst_fifo_ren,
    input logic 			data_fifo_empty,
    input logic 			data_fifo_progfull,
    input logic 		    pread_busValid,
    input logic 		    pread_isFeature,

    input logic                                 input_ddr_data_valid,
    input s_feature_t  	[MAX_LOAD_WIDTH - 1 : 0]ddr_data,
    input s_feature_t  	[MAX_LOAD_WIDTH - 1 : 0]rama_data,
    input s_feature_t  	[MAX_LOAD_WIDTH - 1 : 0]ramb_data,

    output logic 			data_fifo_wen,
    output s_feature_t  	[MAX_LOAD_WIDTH - 1 : 0] data_fifo_wdata,
    output logic            ddr_enable_data,
    output mem_addr_t       ddr_addr_data,
    output ctrl_width2_t    ddr_len_data,
    output logic            rama_ren_data,
    output logic            ramb_ren_data,
    output mem_addr_t       ram_addr_data,
    output ctrl_width_t     ram_len_data,
    output logic unsigned [1:0] 	dataIdx, 
    output seq_t            seqNum,
    output logic            hasMoreData
);
logic               hasMoreData_next; //*
logic               readMoreData, readMoreData_next; //*
logic               newReqSeq; //*
mem_addr_t          nextReadPos, nextReadPos_next; //*
out_width_t         nextReadY, nextReadY_next; //*
layer_addr_t        nextReadC, nextReadC_next; //*
mem_addr_t          frameReadStart, frameReadStart_next; //*
ctrl_width_t        len;
logic unsigned [1:0] 	dataIdx_next;
s_feature_t  	[MAX_LOAD_WIDTH - 1 : 0]saveData;
s_feature_t  	[MAX_LOAD_WIDTH - 1 : 0]mem_data;
logic unsigned [1:0] 	cnt;
logic unsigned [2:0] 	cnt_inc;
data_fifo_t     liveCount;
logic           data_ram_valid_A;
logic           data_ram_valid_B;
logic           doSaveData;

logic           enable_saved;
logic           enable_data0;
logic           enable_data;
logic           setup_saved;

logic 			dly_info_fifo_ren;
logic 			dly_info_fifo_wen;
logic 			dly_info_fifo_empty;
logic 			dly_info_fifo_full;
logic  	[1 : 0] dly_info_fifo_wdata;
logic  	[1 : 0] dly_info_fifo_rdata;

logic 			input_data_fifo_ren;
logic 			input_data_fifo_wen;
logic 			input_data_fifo_empty;
logic 			input_data_fifo_full;
logic           input_data_fifo_progfull;
s_feature_t  	[MAX_LOAD_WIDTH - 1 : 0] input_data_fifo_wdata;
s_feature_t  	[MAX_LOAD_WIDTH - 1 : 0] input_data_fifo_rdata;

//Read
assign enable_saved = mode != MODE_ONE && dataIdx != 0;
assign enable_data0 = !enable_saved && !input_data_fifo_empty ;
assign data_fifo_wen = enable_saved || enable_data0;
assign input_data_fifo_ren = enable_data0;
assign dly_info_fifo_ren = enable_data0;

always_ff @(posedge clock)
if(doSaveData)
    saveData = input_data_fifo_rdata;

always_ff @(posedge clock)
if (!resetN) 
    hasMoreData <= 1'b0;
else if(inst_fifo_ren)
    hasMoreData <= 1'b1;
else if(enable_data0)
    hasMoreData <= dly_info_fifo_rdata[1];

always_ff @(posedge clock)
if (!resetN) 
    dataIdx <= '0;
else 
    dataIdx <= dataIdx_next;

always_comb
begin
    doSaveData = 0;
    data_fifo_wdata = '0;
    dataIdx_next = dataIdx;
    if(enable_saved) begin
        for(int i = 0; i < MAX_LOAD_WIDTH; i++)
            if(i < dataWidth)
                data_fifo_wdata[i] = saveData[dataIdx * dataWidth + i];
            else
                data_fifo_wdata[i] = 0;

`ifdef S2_OPTIMIZE
        if (mode == MODE_TWO || isStride2 || dataIdx == 3) begin
`else
        if (mode == MODE_TWO || dataIdx == 3) begin
`endif
				dataIdx_next = 0;
        end
        else
            dataIdx_next = dataIdx + 1;
    end
    else if(enable_data0) begin
        data_fifo_wdata = input_data_fifo_rdata;
        if(dly_info_fifo_rdata[0]) begin
            dataIdx_next = 1;
            doSaveData = 1;
        end
    end
end

//Receive

assign input_data_fifo_wen = data_ram_valid_A || data_ram_valid_B || input_ddr_data_valid;
assign input_data_fifo_wdata = data_ram_valid_A ? rama_data : 
            (data_ram_valid_B ? ramb_data : ddr_data);
fifo_ctrlread_data input_data(
	    .clk(clock), 		    .srst(fifo_srst), 
	    .din(input_data_fifo_wdata), 	.wr_en(input_data_fifo_wen), 
	    .rd_en(input_data_fifo_ren), 	.dout(input_data_fifo_rdata),
        .full(input_data_fifo_full),	.empty(input_data_fifo_empty),
	    .prog_full(input_data_fifo_progfull));
//Ask

assign enable_data  = enable_readdata && !waiting_feature && (isReadA || isReadB || ddr_read_ready) 
    && (liveCount + cnt < MAX_INPUT_BUF_SIZE) && readMoreData && !(newReqSeq && (liveCount>0));
assign ddr_enable_data = enable_data && !isReadA && !isReadB && ddr_read_ready;
assign rama_ren_data = enable_data && isReadA;
assign ramb_ren_data = enable_data && !isReadA && isReadB;
assign ddr_addr_data = Oaddr + nextReadPos * FEATURE_BYTE_SIZE;
assign ram_addr_data = Oaddr + nextReadPos;
assign ddr_len_data  = (($clog2(MAX_READ_WIDTH) + 1)'(len)) * FEATURE_BYTE_SIZE;
assign ram_len_data  = len;

always_ff @(posedge clock)
if (!resetN)
    data_ram_valid_A <= '0;
else
    data_ram_valid_A <= rama_ren_data;
always_ff @(posedge clock)
if (!resetN)
    data_ram_valid_B <= '0;
else
    data_ram_valid_B <= ramb_ren_data;

always_comb
begin
    if (mode == MODE_FOUR)
        cnt = 3;
    else if (mode == MODE_TWO)
        cnt = 1;
    else
        cnt = 0;
end

always_ff @(posedge clock)
    if (!resetN)
        liveCount <= '0;
    else
        liveCount <= liveCount + cnt_inc - ((pread_busValid && pread_isFeature) ? 1 : 0);

always_ff @(posedge clock)
if (!resetN) 
    readMoreData <= 1'b0;
else 
    readMoreData <= readMoreData_next;

always_ff @(posedge clock)
if (!resetN) 
    newReqSeq <= 1'b0;
else if(inst_fifo_ren)
    newReqSeq <= 1'b1;
else if(enable_data)
    newReqSeq <= 1'b0;

always_ff @(posedge clock)
if (!resetN) 
    seqNum <= 0;
else if(enable_data)
    seqNum <= seqNumNew;


always_comb
begin
    len = readWidth;
    if (mode == MODE_FOUR) begin
        if (nextReadPos + len > lastPos)
            len = lastPos - nextReadPos;
    end
    else if (mode == MODE_TWO)
        if (nextReadY == readYLast)
            len = dataWidth;
end

always_ff @(posedge clock)
if (!resetN) 
    {nextReadPos, nextReadY, nextReadC, frameReadStart} <= '0;
else begin
    nextReadPos <= nextReadPos_next;
    nextReadY <= nextReadY_next;
    nextReadC <= nextReadC_next;
    frameReadStart <= frameReadStart_next;
end

always_comb
begin
    setup_saved = 1'b0;
    readMoreData_next = readMoreData;
    nextReadPos_next = nextReadPos;
    nextReadY_next = nextReadY;
    nextReadC_next = nextReadC;
    frameReadStart_next = frameReadStart;
    cnt_inc = 0;
    if(inst_fifo_ren) begin
        automatic out_width_t   nextx; 
        automatic out_width_t   ys; 
        if (inst.X > 0)
            nextx = inst.X - inst.lPad;
        else
            nextx = inst.X;
        if (inst.Y > 0)
            ys = inst.Y - inst.lPad;
        else
            ys = inst.Y;
        readMoreData_next = 1'b1;
        nextReadPos_next = inst.W * ys + nextx;
        nextReadY_next = ys;
        nextReadC_next = 0;
        frameReadStart_next = inst.W * ys + nextx;
    end
    else if(enable_data) begin
        if (mode == MODE_ONE 
`ifdef S2_OPTIMIZE
				|| mode.GetValue == MODE_TWO && isStride2
`endif				
        ) begin
            if (nextReadY < readYLast) begin
                nextReadY_next = nextReadY + 1;
                nextReadPos_next = nextReadPos + w;
            end
            else if (nextReadC < readCLast) begin
                frameReadStart_next = frameReadStart + frameSize;
                nextReadPos_next = frameReadStart_next;
                nextReadC_next = nextReadC + 1;
                nextReadY_next = readYStart;
            end
            else
                readMoreData_next = 1'b0;
            cnt_inc = 1;
        end
        else if (mode == MODE_TWO) begin
            if (nextReadY == readYLast) begin
                if (nextReadC < readCLast) begin
                    frameReadStart_next = frameReadStart + frameSize;
                    nextReadPos_next = frameReadStart_next;
                    nextReadC_next = nextReadC + 1;
                    nextReadY_next = readYStart;
                end
                else
                    readMoreData_next = 1'b0;
                cnt_inc = 1;
            end
            else begin
                if (nextReadY < readYLast - 1) begin
                    nextReadY_next = nextReadY + 2;
                    nextReadPos_next = nextReadPos + w * 2;
                end
                else if (nextReadC < readCLast) begin
                    frameReadStart_next = frameReadStart + frameSize;
                    nextReadPos_next = frameReadStart_next;
                    nextReadC_next = nextReadC + 1;
                    nextReadY_next  = readYStart;
                end
                else
                    readMoreData_next = 1'b0;
                cnt_inc = 2;
                setup_saved = 1'b1;
            end

        end
        else begin
            cnt_inc = 4;
            setup_saved = 1'b1;
            nextReadPos_next = nextReadPos + len;
            if (nextReadPos_next >= lastPos)
                readMoreData_next = 1'b0;
        end
    
    end

end

assign dly_info_fifo_wen = ddr_enable_data;
assign dly_info_fifo_wdata = {readMoreData_next, setup_saved};
fifo_ctrlread_info dly_info(
	    .clk(clock), 		    .srst(fifo_srst), 
	    .din(dly_info_fifo_wdata), 	.wr_en(dly_info_fifo_wen), 
	    .rd_en(dly_info_fifo_ren), 	.dout(dly_info_fifo_rdata),
        .full(dly_info_fifo_full),	.empty(dly_info_fifo_empty));

endmodule

module CtrlRead
import definitions_pkg::*;
(
    input logic 		clock, resetN,
    input logic 		crinst_enable,
    input InstructionRead 	crinst,

    input logic         cb_isRunning[BANK_NUM],
    input logic         cb_isReadingFeatures[BANK_NUM],
    input logic         cb_isLoadingFroze[BANK_NUM],
    input seq_t         cb_ReqFeature[BANK_NUM],
    input seq_t         cb_FinishedSeq[BANK_NUM],
    input seq_t         cb_WorkingSeq[BANK_NUM],
    input seq_t         cb_WorkingProgress[BANK_NUM],

    input logic         [BANK_NUM - 1 : 0]requestValid,
    input RequestItem_t ritem[BANK_NUM],
    input logic         reqGIBValid,
    input RequestItem_t reqGIB,

    input logic         ddr_read_ready,
    input ddr_id_t                              ddr_data_id,
    input s_feature_t  	[MAX_LOAD_WIDTH - 1 : 0]ddr_data,
    input s_feature_t  	[MAX_LOAD_WIDTH - 1 : 0]rama_data,
    input s_feature_t  	[MAX_LOAD_WIDTH - 1 : 0]ramb_data,


    output logic        ddr_enable,
    output mem_addr_t   ddr_addr,
    output ctrl_width_t ddr_len,
    output ddr_id_t     ddr_id,
    output logic        rama_ren,
    output logic        ramb_ren,
    output mem_addr_t   ram_addr,
    output ctrl_width_t ram_len,

    output logic        pread_waitForSeq,
    output logic 		pread_busValid,
    output logic 		pread_isFeature,
    output logic        pcread_RequestGIBValid,
    output logic        pread_RequestFull,
    output seq_t        pread_SeqNum,
    output logic        rd_inst_fifo_full,
    output logic        isStopable,
    output s_feature_t 	[MAX_LOAD_WIDTH - 1 : 0]data_bus
);
parameter 		CRINST_BITS = $bits(InstructionRead);
seq_t           reqSeq;
seq_t           seqNumNew;
seq_t           reqProgress;
out_width_t     w;
DATA_MODE 		mode;
layer_addr_t    readCLast;
outframe_addr_t     frameSize;
mem_addr_t      Oaddr;
logic           isReadA;
logic           isReadB;
mem_addr_t 		lastPos;
`ifdef S2_OPTIMIZE
logic           isStride2;
`endif

ctrl_width_t    readWidth;
ctrl_width_t    dataWidth;
out_width_t     readYLast;
out_width_t     readYStart;
logic unsigned [1:0] 	dataIdx; 
logic           hasMoreData;
logic           ext_ddr_data_valid;
logic           input_ddr_data_valid;

seq_t           seqNum;
logic           reset_reqGIBValid;
logic           reqGIBValid0;
RequestItem_t   reqGIB0;
logic           fifo_srst;
logic           enable_readdata;
logic [BANK_NUM - 1:0]    waitForSeq_hcb;
logic [BANK_NUM - 1:0]    waiting_hcb;
logic                     waiting_feature;

logic 			reqq_fifo_ren;
logic 			reqq_fifo_wen;
logic 			reqq_fifo_empty;
logic 			reqq_fifo_full;
RequestItem_t   reqq_fifo_wdata;
RequestItem_t  	reqq_fifo_rdata;

logic 			retq_fifo_ren;
logic 			retq_fifo_wen;
logic 			retq_fifo_empty;
logic 			retq_fifo_full;
ReturnData_t    retq_fifo_wdata;
ReturnData_t  	retq_fifo_rdata;

logic 			data_fifo_ren;
logic 			data_fifo_wen;
logic 			data_fifo_empty;
logic 			data_fifo_full;
logic 			data_fifo_progfull;
s_feature_t  	[MAX_LOAD_WIDTH - 1 : 0] data_fifo_wdata;
s_feature_t  	[MAX_LOAD_WIDTH - 1 : 0] data_fifo_rdata;

logic			inst_fifo_ren;
logic 			inst_fifo_empty;
logic 			inst_fifo_full;
InstructionRead   inst;

logic            ddr_enable_data;
mem_addr_t       ddr_addr_data;
ctrl_width2_t    ddr_len_data;
logic            rama_ren_data;
logic            ramb_ren_data;
mem_addr_t       ram_addr_data;
ctrl_width_t     ram_len_data;
logic           ddr_enable_ext;
mem_addr_t      ddr_addr_ext;
ctrl_width2_t   ddr_len_ext;
logic           rama_ren_ext;
logic           ramb_ren_ext;
mem_addr_t      ram_addr_ext;
ctrl_width_t    ram_len_ext;

assign isStopable = inst_fifo_empty && (~hasMoreData);
assign pcread_RequestGIBValid = reqGIBValid0;
assign ext_ddr_data_valid = (ddr_data_id == DDR_EXT_ID);
assign input_ddr_data_valid = (ddr_data_id == DDR_DATA_ID);
assign rd_inst_fifo_full = inst_fifo_full;
assign ddr_enable = ddr_enable_data || ddr_enable_ext;
assign ddr_addr = ddr_enable_data ? ddr_addr_data : ddr_addr_ext;
assign ddr_len = ddr_enable_data ? ddr_len_data : ddr_len_ext;
assign ddr_id = ddr_enable_data ? DDR_DATA_ID : (ddr_enable_ext? DDR_EXT_ID : 0);
assign rama_ren = rama_ren_data || rama_ren_ext;
assign ramb_ren = ramb_ren_data || ramb_ren_ext;
assign ram_addr = (rama_ren_data || ramb_ren_data) ? ram_addr_data : ram_addr_ext;
assign ram_len  = (rama_ren_data || ramb_ren_data) ? ram_len_data  : ram_len_ext;

assign inst_fifo_ren = ~hasMoreData && (mode == MODE_ONE || dataIdx == 0) 
                    && ~inst_fifo_empty;
assign fifo_srst = ~resetN;
assign pread_SeqNum = seqNum;
assign pread_RequestFull = reqq_fifo_full;
assign pread_waitForSeq = | waitForSeq_hcb;
assign enable_readdata = !pread_waitForSeq;
always_comb
begin
    for(int i =0; i < BANK_NUM; i++)
        waitForSeq_hcb[i] = (cb_FinishedSeq[i] < reqSeq) && 
            (cb_WorkingSeq[i] < reqSeq || cb_WorkingProgress[i] < reqProgress);
end

always_comb
begin
    for(int i =0; i < BANK_NUM; i++)
        waiting_hcb[i] = (cb_isRunning[i] && (cb_ReqFeature[i] == seqNum))
             && (!cb_isReadingFeatures[i] || cb_isLoadingFroze[i]);
end
assign waiting_feature = | waiting_hcb;


always_ff @(posedge clock)
if (!resetN) 
    {reqGIBValid0, reqGIB0} <= '0;
else if(reqGIBValid)
    {reqGIBValid0, reqGIB0} <= {reqGIBValid, reqGIB};
else if (reset_reqGIBValid) 
    {reqGIBValid0, reqGIB0} <= '0;

ProduceInputs      produceInputs(.*);
ReadExtData        readExtData(.*);
ReadData           readData(.*);
ProcessReadInstruction processReadInstruction (.*);

// data fifo
fifo_ctrlread_data fifo_data(
	    .clk(clock), 		    .srst(fifo_srst), 
	    .din(data_fifo_wdata), 	.wr_en(data_fifo_wen), 
	    .rd_en(data_fifo_ren), 	.dout(data_fifo_rdata),
        .full(data_fifo_full),	.empty(data_fifo_empty),
	    .prog_full(data_fifo_progfull));

//reqq fifo
assign reqq_fifo_wen = (|requestValid);
//assign reqq_fifo_wdata = ritem;
always_comb
begin
    if(requestValid[0])
        reqq_fifo_wdata = ritem[0];
    else if(requestValid[1])
        reqq_fifo_wdata = ritem[1];
    else if(requestValid[2])
        reqq_fifo_wdata = ritem[2];
    else 
        reqq_fifo_wdata = ritem[3];
end
fifo_ctrlread_req fifo_req(
	    .clk(clock)	, 		    .srst(fifo_srst), 
	    .din(reqq_fifo_wdata),  .wr_en(reqq_fifo_wen), 
	    .rd_en(reqq_fifo_ren), 	.dout(reqq_fifo_rdata), 
	    .full(reqq_fifo_full), 	.empty(reqq_fifo_empty));

//retq fifo
fifo_ctrlread_ret fifo_ret(
	    .clk(clock)	, 		    .srst(fifo_srst), 
	    .din(retq_fifo_wdata),  .wr_en(retq_fifo_wen), 
	    .rd_en(retq_fifo_ren), 	.dout(retq_fifo_rdata), 
	    .full(retq_fifo_full), 	.empty(retq_fifo_empty));

//weight inst fifo
fifo_InstructionRead fifo_rcinst(
	    .clk(clock)	, 		    .srst(fifo_srst), 
	    .din(crinst), 		    .wr_en(crinst_enable), 
	    .rd_en(inst_fifo_ren), 	.dout(inst), 
	    .full(inst_fifo_full), 	.empty(inst_fifo_empty));

always_comb
begin
	if(ddr_data_id != 0) begin
    	$write("read data id %d\n" ,ddr_data_id);
    end
end
endmodule
