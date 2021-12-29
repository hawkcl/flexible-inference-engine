//`timescale 1ns / 1ps
`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/02/13 11:16:38
// Design Name: 
// Module Name: pkg
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


package definitions_pkg;
//`define S2_OPTIMIZE
// `define IN_SIMULATION
 parameter XLEN = 64;
 parameter INSTRUCTION_FIFO_SIZE = 4;
 parameter AXI4_ADDR_WIDTH = 32;
 parameter AXI4_LEN_WIDTH  = 8;
 parameter AXI4_SIZE_WIDTH = 3;
 parameter INTERFACE_LEN = 8;
 parameter DDR_DATA_WIDTH = 8;
 parameter DDR_RAM_DEPTH  = 40000000;
 parameter DDR_LEN_SIZE   = INTERFACE_LEN;
 parameter DDR_LEN_WIDTH  = 16;//$clog2(DDR_LEN_SIZE);
 parameter DDR_ADDR_WIDTH = $clog2(DDR_RAM_DEPTH); //26
 parameter WEIGHT_DDR_BASE  = 32'h82000000;
 parameter FEATURE_DDR_BASE  = 32'h81000000;

 parameter BANK_NUM = 4;
 parameter OUT_BUFFER_COUNT = 2;
 parameter BM_SIZE  = 3;
 parameter WEIGHT_BIT_SIZE = 8;
 parameter BANK_NUM_BIT_SIZE = 2; //$bits(BANK_NUM);
 parameter WIDTH_BIT_SIZE = 4;
 parameter WEIGHT_MEM_BUS_SIZE = 32;
 parameter WEIGHT_BUFFER_SIZE = 8;
 parameter WEIGHT_DATA_WIDTH = 8;
 parameter WEIGHT_FIFO_DEPTH = 256;
 parameter WEIGHT_NUM_BIT_SIZE = 27;
 parameter FEATURE_BIT_SIZE = 8;
 parameter FEATURE_BYTE_SIZE = FEATURE_BIT_SIZE / 8;
 parameter MULT_BIT_SIZE = 20; // try 27
 parameter BM_BIT_SIZE = 11;
 parameter DATAFIFO_BIT_SIZE = 7;
 parameter RES_BIT_SIZE = 16;
 parameter SCALE_BIT_SIZE = 4;
 parameter OUTPUT_BIT_SIZE = 4;
 parameter LAYER_BIT_SIZE = 11;
 parameter OUTPUT_GAP_BIT_SIZE = 24;
 parameter OUTPUT_WIDTH_BIT_SIZE = 9;
 parameter MEM_BUS_BYTE_BIT_SIZE = 5;
 parameter MEM_BIT_SIZE = DDR_ADDR_WIDTH;
 parameter K_BIT_SIZE = 3;
 parameter DIM_BIT_SIZE = OUTPUT_WIDTH_BIT_SIZE;
 parameter TOKEN_BIT_SIZE = BANK_NUM_BIT_SIZE;
 parameter SEQ_BIT_SIZE = 11;
 parameter WEIGHT_BUS_BIT_SIZE = 3;
 parameter WEIGHT_BUS_SIZE = (1 << WEIGHT_BUS_BIT_SIZE);
 parameter MAX_K = 7;
 parameter CG_NUM = 12; //define CG_NUM_SMALL if <12
 //`define CG_NUM_SMALL
 parameter COMPUTING_UNIT_OUTPUT_SIZE	= 16;
 parameter CG_BIT_SIZE = $clog2(CG_NUM);
 parameter COMPUTING_GROUP_SIZE = 7;
 parameter GROUP_BIT_SIZE = 10;
 parameter INPUT_BIT_SIZE = 17;
 parameter MAX_CTRL_BUF_SIZE = 16;
 parameter MAX_INPUT_BUF_SIZE = 64;
 parameter WRITE_FIFO_SIZE = 20;
 //`ifdef S2_OPTIMIZE
 parameter INPUT_MEM_WIDTH = (COMPUTING_GROUP_SIZE+5);
 //`else
 //parameter INPUT_MEM_WIDTH = (COMPUTING_GROUP_SIZE);
 //`endif
 parameter INPUT_ADDR_WIDTH = 14;
 parameter INPUT_MEM_DEPTH = 8500;
 parameter MAX_READ_WIDTH = (COMPUTING_GROUP_SIZE*4+5); //make sure large enough for returndata
 parameter MAX_LOAD_WIDTH = MAX_READ_WIDTH;
 parameter S2_BUFFER_SIZE = 16;
 parameter MAX_SHIFT_SIZE = 6;
 parameter BRAM_BUS_WIDTH = (BANK_NUM * COMPUTING_GROUP_SIZE);
 parameter BM_READ_WIDTH  = 6; //((CG_NUM /3)*2);
 parameter BM_FIFO_DEPTH  = 42; //42 for 9 CGs
 //parameter RES_FIFO_DEPTH  = 1000;
 parameter RES_FIFO_DEPTH  = 12 * COMPUTING_UNIT_OUTPUT_SIZE; //TODO change 12 to 48
 parameter WEIGHT_READ_WIDTH = (WEIGHT_DATA_WIDTH * BANK_NUM);
 parameter WEIGHT_BRAM_DEPTH = 584;
 parameter WEIGHT_ADDR_WIDTH = $clog2(WEIGHT_BRAM_DEPTH);
 parameter WEIGHT_BRAM_WIDTH = WEIGHT_READ_WIDTH * WEIGHT_BIT_SIZE;

 parameter DDR_DATA_ID = 1;
 parameter DDR_EXT_ID  = 2;
 parameter DDR_DATAWIDTH  = 8;
 parameter PS_DDR_DATAWIDTH  = 8;
 parameter MAX_WRITE_IDLE_COUNT = 5;
 parameter DDR_FEATURE_ID = 1;
 parameter DDR_NETIF_ID = 2;
 parameter DDR_WEIGHT_ID = 3;

 parameter C_M_AXI_ID_WIDTH	= 4;
 parameter C_M_AXI_ADDR_WIDTH	= AXI4_ADDR_WIDTH;
 parameter C_M_AXI_ARUSER_WIDTH	= 4;
 //parameter C_M_AXI_DATA_WIDTH	= 8 * DDR_DATAWIDTH; //256 
 parameter C_M_AXI_RUSER_WIDTH	= 4;
 parameter C_M_AXI_AWUSER_WIDTH = 1;
 parameter C_M_AXI_BUSER_WIDTH = 1;
 parameter C_M_AXI_WUSER_WIDTH = 1;

typedef enum  logic [3:0] {COUNT[0:15]} states_enum_t;

typedef enum  logic {UCLM_X, UCLM_PSUM} UCL_M_MUX;
typedef enum  logic [1:0]{ UCLA0_MUL, UCLA0_MS, UCLA0_X} UCL_A0_MUX;  //X for res operation
typedef enum  logic [1:0]  {UCLA_W, UCLA_PSUM, UCLA_AQ, UCLA_0} UCL_A_MUX;
typedef enum  logic   {UCLAQ_PLUS, UCLAQ_AQ} UCL_AQ_MUX;
typedef enum  logic   {UCLSA_X, UCLSA_LOW} UCL_SA_MUX;
typedef enum  logic [2:0]  {UCLSQ_AQ, UCLSQ_PLUS, UCLSQ_SQ } UCL_SQ_MUX;
typedef enum  logic [1:0]  {UCLO_RELU, UCLO_AQ, UCLO_SQ} UCL_OUT_MUX;
typedef enum  logic [1:0]  {UCLC0_X, UCLC0_LOW, UCLC0_PSUM} UCL_C0_MUX;
typedef enum  logic   {UCLC1_W, UCLC1_SQ } UCL_C1_MUX;
typedef enum  logic   { UCLL_0, UCLL_MUL } UCL_L_MUX;
typedef enum  logic [2:0]  {INPUT_NON, INPUT_X, INPUT_BACKUP, INPUT_E, INPUT_S } INPUT_SOURCE;
typedef enum  logic [3:0] { IDLE, CONV_INIT, CONV_START, CONV_MULT, CONV_BM, CONV_RELU, CONV_OUT, CONV_DONE} HCB_STATE;
typedef enum  logic [2:0] { TYPE_BM, TYPE_RES, TYPE_GIB } DATA_TYPE;
typedef enum  logic [1:0] { MODE_ONE, MODE_TWO, MODE_FOUR } DATA_MODE;
typedef enum  logic [3:0] { CONV, OPTIONS, POOL, TEND, MEM, LOADWEIGHT, HCB, CREAD, CWRITE} InstructionType;
typedef enum  logic [2:0] { SEND_WEIGHT, SEND_FEATURE, SEND_INSTRUCTION, SEND_ADDRESS, SEND_DONE, SEND_NONE } SEND_STATE;

typedef struct packed{
    UCL_M_MUX  mMux;
	UCL_A0_MUX a0Mux;
	UCL_A_MUX  aMux;
	//UCL_AQ_MUX aqMux;
	//UCL_SA_MUX saMux;
	UCL_SQ_MUX sqMux;
	UCL_L_MUX  lMux;
	UCL_OUT_MUX oMux;
	//UCL_C0_MUX c0Mux;
	//UCL_C1_MUX c1Mux;
	//logic isAct;
  } ucl_config_t;
 
 typedef logic unsigned [SEQ_BIT_SIZE - 1 : 0] seq_t;
 typedef logic unsigned [WIDTH_BIT_SIZE - 1 : 0] width_t;
 typedef logic unsigned [WIDTH_BIT_SIZE : 0] width1_t;
 typedef logic signed [WIDTH_BIT_SIZE + 1 : 0] s_row_addr_t;  
 typedef logic unsigned [GROUP_BIT_SIZE - 1 : 0] group_t;
 typedef logic unsigned [BM_BIT_SIZE - 1 : 0] bm_size_t;
 typedef logic unsigned [RES_BIT_SIZE - 1 : 0] res_size_t;
 typedef logic unsigned [4 : 0] res_len_t;
 typedef logic unsigned [TOKEN_BIT_SIZE - 1 : 0] token_t;
 typedef logic unsigned [BANK_NUM_BIT_SIZE - 1 : 0] bank_num_t;
 typedef logic signed [WEIGHT_BIT_SIZE - 1 : 0] s_weight_t;
 typedef logic unsigned [WEIGHT_NUM_BIT_SIZE - 1 : 0] weight_addr_t;
 typedef logic signed [FEATURE_BIT_SIZE - 1 : 0] s_feature_t;
 typedef logic signed [MULT_BIT_SIZE - 1 : 0] s_mult_t;
 typedef logic unsigned [SCALE_BIT_SIZE - 1 : 0] scale_t;
 typedef logic unsigned [K_BIT_SIZE - 1 : 0] k_t;
 typedef logic unsigned [OUTPUT_BIT_SIZE - 1 : 0] output_addr_t;
 typedef logic unsigned [INPUT_BIT_SIZE - 1 : 0] input_addr_t;
 typedef logic unsigned [OUTPUT_GAP_BIT_SIZE - 1 : 0] output_gap_t;
 typedef logic unsigned [OUTPUT_WIDTH_BIT_SIZE * 2 - 1 : 0] outframe_addr_t;
 typedef logic unsigned [OUTPUT_WIDTH_BIT_SIZE - 1 : 0] out_width_t;
 typedef logic unsigned [CG_BIT_SIZE - 1 : 0] cg_addr_t;
 typedef logic unsigned [WEIGHT_BUS_BIT_SIZE-1 : 0] weight_bus_addr_t;
 typedef logic unsigned [WEIGHT_BUS_BIT_SIZE : 0] weight_bus_size_t;
 typedef logic unsigned [MEM_BUS_BYTE_BIT_SIZE - 1 : 0] mem_bus_addr_t;
 typedef logic unsigned [MEM_BIT_SIZE - 1 : 0] mem_addr_t;
 typedef logic unsigned [LAYER_BIT_SIZE - 1 : 0] layer_addr_t;
 typedef logic unsigned [DIM_BIT_SIZE - 1 : 0] dim_t;
 typedef logic unsigned [DATAFIFO_BIT_SIZE - 1 : 0] data_fifo_t;
 typedef logic unsigned [DIM_BIT_SIZE*2 - 1 : 0] frame_t;
 typedef logic unsigned [WIDTH_BIT_SIZE*2 - 1 : 0] loc_frame_t;
 typedef logic unsigned [3 : 0] fpga_min_addr_t;
 typedef logic unsigned [1 : 0] pad_t;
 typedef logic unsigned [2 : 0] batch_t;
 typedef logic unsigned [$clog2(MAX_READ_WIDTH) - 1 : 0] ctrl_width_t;
 parameter CTRL_WIDTH_SIZE = $clog2(MAX_READ_WIDTH);
 typedef logic unsigned [$clog2(MAX_READ_WIDTH) : 0] ctrl_width2_t;
 typedef logic unsigned [7 : 0] ubyte_t;
 typedef logic unsigned [C_M_AXI_ID_WIDTH - 1 : 0] ddr_id_t;
 typedef logic unsigned [DDR_LEN_WIDTH - 1 : 0] ddr_len_t;
 typedef logic unsigned [4 : 0] ddr_width_t;
 typedef logic unsigned [5 : 0] ddr_width1_t;

 typedef struct packed {
    ddr_id_t id;
    mem_addr_t addr;
    ddr_width_t len;
} DDR_Load_Info_t;

typedef struct packed {
    ddr_id_t id;
    ubyte_t [DDR_DATAWIDTH-1 : 0] data;
    logic isLast;
} DDR_Load_Data_t;

typedef struct packed {
	ddr_width_t	    saved_len;
	ddr_width_t	    saved_addr;
	logic		    saved_only;
	ddr_width1_t	first_addr;
	ddr_width1_t	last_len;
	ddr_id_t		id; 
} CReadAssistInfo_t;

typedef struct packed {
	mem_addr_t	addr;
    ddr_len_t	len;
	ubyte_t	[BRAM_BUS_WIDTH * FEATURE_BYTE_SIZE - 1 : 0] data;
} CWriteAssistInfo_t;

typedef struct packed {
	DATA_TYPE dtype;
	logic unsigned [7 : 0] seq;
	logic unsigned [7 : 0]  len;
	logic unsigned [7 : 0]  token;
	s_feature_t [BRAM_BUS_WIDTH-1:0] data; 
} ReturnData_t;
parameter ReturnData_t_Size	= $bits(ReturnData_t);
/* 
  typedef struct  {
	DATA_TYPE dtype;
	logic unsigned [7 : 0] seq;
	logic unsigned [7 : 0]  len;
	logic unsigned [7 : 0]  token;
	s_feature_t  data[BRAM_BUS_WIDTH]; 
} ReturnData_t_unpack;
 */
 typedef struct packed {
	mem_addr_t addr;
	logic unsigned [7 : 0] seq;
	logic unsigned [7 : 0]  len;
	logic unsigned [7 : 0]  token;
	DATA_TYPE dtype;
	logic isRamA;
	logic isRamB;
	//bool isLast;
} RequestItem_t;

 typedef struct {
	mem_addr_t addr;
	logic unsigned [7 : 0] seq;
	logic unsigned [7 : 0]  len;
	logic unsigned [7 : 0]  token;
	DATA_TYPE dtype;
	logic isRamA;
	logic isRamB;
	//bool isLast;
} RequestItem_t_unpack;

typedef struct  packed { //[84:0]
	InstructionType itype;
	mem_addr_t Waddr, WEnd;
	mem_bus_addr_t weightPos;
	seq_t seqNum;
} InstructionHCBWt;

typedef struct packed {  //[624,0]
	bank_num_t Id;
	InstructionType itype;
	seq_t reqSeqNum;
	seq_t reqProgress;
	seq_t reqSeqNumW;
	seq_t reqProgressW;
	seq_t seqNum;
	out_width_t W, H;
	layer_addr_t C;
	mem_addr_t Waddr;
	mem_addr_t WEnd;
	mem_bus_addr_t weightPos;
	mem_bus_addr_t ReadPos;
	mem_bus_addr_t ResPos;
	width_t W1, H1;
	out_width_t X, Y; //maxval for read, write, weight, ext token gen
	pad_t S, lPad, rPad;
	k_t K; 
	layer_addr_t M; // filter size, filter layers
	layer_addr_t Kh, Ks, Kt; // start, stride, and tail(inclusive)
	mem_addr_t Res_addr;
	scale_t wScale;
	scale_t fScale;
	//mem_addr_t BM_addr;
	s_feature_t    wLRelu;
	token_t weightToken;
	pad_t maxpool_size;
	pad_t maxpool_stride;
	DATA_MODE mode;
	logic isResMaster;
	//logic isWeightMaster;
	logic isProgressMaster;
	logic isRaddr_a; //for Res
	logic doRes;
	logic doRelu;
	logic doLRelu;
	logic doBM;
	logic doUpSample;
	logic newWriteInst;
	
	loc_frame_t outbufsize;
	frame_t ofsize;
	frame_t outyx;
	output_gap_t outputAddrGap;
	mem_addr_t outkh;
	cg_addr_t ng;
	cg_addr_t gu;
	res_size_t resSize;
	res_size_t resSizeLast;
	res_len_t resLen;
	res_len_t resLenLast;
	loc_frame_t pfs;
	input_addr_t volumeSize;
	layer_addr_t kCurLast;
	cg_addr_t wtotal_n;
	cg_addr_t wtotalLast;
	weight_bus_size_t wlenk_regular;
	weight_bus_size_t wlenk_nLast;
	weight_bus_size_t wlenk_nLast2;
	//bm_size_t totalBM;
	res_size_t totalRes;
} InstructionHCB;  //[624,0]

typedef struct {  //[624,0]
	bank_num_t Id;
	InstructionType itype;
	seq_t reqSeqNum;
	seq_t reqProgress;
	seq_t reqSeqNumW;
	seq_t reqProgressW;
	seq_t seqNum;
	out_width_t W, H;
	layer_addr_t C;
	mem_addr_t Waddr;
	mem_addr_t WEnd;
	mem_bus_addr_t weightPos;
	mem_bus_addr_t ReadPos;
	mem_bus_addr_t ResPos;
	width_t W1, H1;
	out_width_t X, Y; //maxval for read, write, weight, ext token gen
	pad_t S, lPad, rPad;
	k_t K; 
	layer_addr_t M; // filter size, filter layers
	layer_addr_t Kh, Ks, Kt; // start, stride, and tail(inclusive)
	mem_addr_t Res_addr;
	scale_t wScale;
	scale_t fScale;
//	mem_addr_t BM_addr;
	s_feature_t    wLRelu;
	token_t weightToken;
	pad_t maxpool_size;
	pad_t maxpool_stride;
	DATA_MODE mode;
	logic isResMaster;
	//logic isWeightMaster;
	logic isProgressMaster;
	logic isRaddr_a; //for Res
	logic doRes;
	logic doRelu;
	logic doLRelu;
	logic doBM;
	logic doUpSample;
	logic newWriteInst;
	
	loc_frame_t outbufsize;
	frame_t ofsize;
	frame_t outyx;
	output_gap_t outputAddrGap;
	mem_addr_t outkh;
	cg_addr_t ng;
	cg_addr_t gu;
	res_size_t resSize;
	res_size_t resSizeLast;
	res_len_t resLen;
	res_len_t resLenLast;
	loc_frame_t pfs;
	input_addr_t volumeSize;
	layer_addr_t kCurLast;
	cg_addr_t wtotal_n;
	cg_addr_t wtotalLast;
	weight_bus_size_t wlenk_regular;
	weight_bus_size_t wlenk_nLast;
	weight_bus_size_t wlenk_nLast2;
//	bm_size_t totalBM;
	res_size_t totalRes;
} InstructionHCB_unpack;  //[624,0]

/*typedef struct  { //[711:0]
	
	seq_t reqSeqNum;
	seq_t reqProgress;
	seq_t reqSeqNumW;
	seq_t reqProgressW;
	seq_t seqNum;
	scale_t fScale;
	scale_t wScale;
	out_width_t W, H;
	layer_addr_t C;
	width_t W1, H1;
	logic unsigned [4:0] batch12, batch9;
	width_t batch0;
	mem_addr_t Maddr, Waddr, Oaddr;
	mem_addr_t WSize;
	mem_addr_t WEnd[BANK_NUM];
	pad_t S, lPad, rPad;
	k_t K;
	layer_addr_t M; // filter size, filter layers
	layer_addr_t Kh[BANK_NUM], Ks[BANK_NUM], Kt[BANK_NUM]; // start, stride, and tail(inclusive)
	layer_addr_t Kbh[BANK_NUM], Kbe[BANK_NUM];//start end of the batch for k1
	mem_addr_t Res_addr;
//	mem_addr_t BM_addr;
	s_feature_t    wLRelu;
	DATA_MODE mode;
	bank_num_t progressMaster; // last bank
	logic unsigned [1:0] wDropSize;
	logic doBatch3;
	logic isUseWRam;
	logic isMaddr_a;
	logic isMaddr_b;
	logic isOaddr_a;
	logic isOaddr_b;
	logic isRaddr_a; //for Res
	logic doRes;
	logic doRelu;
	logic doLRelu;
	logic doBM;
	logic doUpSample;
	logic isConv;
} Instruction; //[711:0]*/

typedef struct packed {
	logic isReadRam;
	logic isWriteRam;
	DATA_MODE mode; // for res simulation
	logic unsigned [1:0] dropSize;
	//unsigned readWidth;
	//unsigned dataWidth;
	seq_t seqNum;
	mem_addr_t Oaddr;
	mem_addr_t size;
} InstructionWeight; //[81:0]

typedef struct {
	logic isReadRam;
	logic isWriteRam;
	DATA_MODE mode; // for res simulation
	logic unsigned [1:0] dropSize;
	//unsigned readWidth;
	//unsigned dataWidth;
	seq_t seqNum;
	mem_addr_t Oaddr;
	mem_addr_t size;
} InstructionWeight_unpack; //[81:0]

typedef struct packed  {
	DATA_MODE mode;
	seq_t reqSeqNum;
	seq_t reqProgress;
	seq_t seqNum;
	out_width_t W, H;
	layer_addr_t C;
	mem_addr_t Maddr;
	width_t W1, W2, H1;
	out_width_t X, Y;
	pad_t S, lPad, rPad;
	logic isMaddr_a;
	logic isMaddr_b;
	logic isRes_a;
	//unsigned isMaddr_b : 1;
} InstructionRead; //[136:0]

typedef struct {
	DATA_MODE mode;
	seq_t reqSeqNum;
	seq_t reqProgress;
	seq_t seqNum;
	out_width_t W, H;
	layer_addr_t C;
	mem_addr_t Maddr;
	width_t W1, W2, H1;
	out_width_t X, Y;
	pad_t S, lPad, rPad;
	logic isMaddr_a;
	logic isMaddr_b;
	logic isRes_a;
	//unsigned isMaddr_b : 1;
} InstructionRead_unpack; //[136:0]


typedef struct  packed {
	DATA_MODE mode;
	width_t dataWidth;
	width_t dataWidth2;
	mem_addr_t Oaddr;
    width_t     outH1;
	logic isUpsample;
	logic isMaddr_a;
	logic isMaddr_b;
    pad_t maxpool_stride;
    pad_t maxpool_size;
} InstructionWrite; //[48:0]

typedef struct {
	DATA_MODE mode;
	width_t dataWidth;
	width_t dataWidth2;
	mem_addr_t Oaddr;
    width_t     outH1;
	logic isUpsample;
	logic isMaddr_a;
	logic isMaddr_b;
    pad_t maxpool_stride;
    pad_t maxpool_size;
} InstructionWrite_unpack; //[48:0]


typedef struct packed {
	logic start;
	logic stop;
} InstructionConfig;

typedef struct packed {
	logic isRamA;
	logic isRamB;
	logic hasMore;
	seq_t reqSeqNum;
    mem_addr_t  oSize;
    mem_addr_t  oAddr;
} InstructionEnd;

typedef struct packed {
	//unsigned weight_token_max;
	logic start;
	logic stop;
} InstructionOption;

parameter GIB_WIDTH     = 32;
parameter MAX_INST_LEN	= $bits(InstructionHCB)/GIB_WIDTH + 2 ;	
parameter MAX_INST_BIT_SIZE	= $clog2($bits(InstructionHCB)/8 + 2);
parameter GIB_MULTI     = GIB_WIDTH / 8;
typedef logic unsigned [MAX_INST_BIT_SIZE - 1 : 0] gib_len_t;

parameter InstructionHCBLength	= ($bits(InstructionHCB) + GIB_WIDTH - 1) / GIB_WIDTH;
parameter InstructionOptionLength	= ($bits(InstructionOption) + GIB_WIDTH - 1) / GIB_WIDTH;	
parameter InstructionWeightLength	= ($bits(InstructionWeight) + GIB_WIDTH - 1) / GIB_WIDTH;	
parameter InstructionReadLength	= ($bits(InstructionRead) + GIB_WIDTH - 1) / GIB_WIDTH;	
parameter InstructionWriteLength	= ($bits(InstructionWrite) + GIB_WIDTH - 1) / GIB_WIDTH;	
parameter InstructionEndLength	= ($bits(InstructionEnd) + GIB_WIDTH - 1) / GIB_WIDTH;	


    function automatic weight_bus_size_t GetBMWLen(cg_addr_t ug, cg_addr_t initw);
        GetBMWLen = 2;
        if (((CG_BIT_SIZE+1)'(initw)) + ((CG_BIT_SIZE+1)'(GetBMWLen)) > (CG_BIT_SIZE+1)'(ug))
            GetBMWLen = (ug - initw);
        return GetBMWLen;
    endfunction

    function automatic weight_bus_size_t GetWLen(cg_addr_t wtotal, cg_addr_t initw, k_t k);
        if (initw < wtotal) begin
            if (k == 1)
                GetWLen = 8;
            else if (k <= 4)
                GetWLen = 2;
            else
                GetWLen = 1;
            if (((CG_BIT_SIZE+1)'(initw)) + ((CG_BIT_SIZE+1)'(GetWLen)) > (CG_BIT_SIZE+1)'(wtotal))
                GetWLen = wtotal - initw;
        end
        else
            GetWLen = 0;
        return GetWLen;
    endfunction

endpackage: definitions_pkg
