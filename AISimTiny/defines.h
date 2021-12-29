#pragma once
//#define S2_OPTIMIZE
//#define BATCH1_OPTIMIZE

//#define WEIGHT_BIT_SIZE  12
#define BANK_NUM_BIT_SIZE  2
#define WIDTH_BIT_SIZE  4 //try 4 readwidth need to chane type, H1 for S2
//#define WEIGHT_NUM_BIT_SIZE  27

#ifdef YOLO
#define FEATURE_BIT_SIZE  8
#define MULT_BIT_SIZE  20
#else
#define MULT_BIT_SIZE  32
#define FEATURE_BIT_SIZE  32
#endif
#define BM_BIT_SIZE  11
#define RES_BIT_SIZE  16
#define SCALE_BIT_SIZE  4
#define OUTPUT_BIT_SIZE  4
#define LAYER_BIT_SIZE  11
#define OUTPUT_GAP_BIT_SIZE  24
#define OUTPUT_WIDTH_BIT_SIZE  9
#define MEM_BUS_BYTE_BIT_SIZE  5
#define MEM_BIT_SIZE  26
#define K_BIT_SIZE  3
#define DIM_BIT_SIZE  OUTPUT_WIDTH_BIT_SIZE
#define TOKEN_BIT_SIZE  BANK_NUM_BIT_SIZE
#define SEQ_BIT_SIZE  11
#define WEIGHT_BUS_BIT_SIZE  3
#define CG_BIT_SIZE  4
//#define GROUP_BIT_SIZE  10
#define INPUT_BIT_SIZE  17 //16 may work as well
#define MAX_INST_LEN		80  //$bits(InstructionHCB)/8 + 1	
#define MAX_INST_BIT_SIZE	7	//$clog2(MAX_INST_LEN)

#define seq_t SEQ_BIT_SIZE
#define width_t WIDTH_BIT_SIZE
#define width1_t (WIDTH_BIT_SIZE + 1)
//#define group_t GROUP_BIT_SIZE
#define bm_size_t BM_BIT_SIZE
#define res_size_t RES_BIT_SIZE
#define res_len_t 5
#define data_fifo_t 7
#define token_t TOKEN_BIT_SIZE
#define bank_num_t BANK_NUM_BIT_SIZE
#define DDR_LANTENCY	20
//#define weight_addr_t WEIGHT_NUM_BIT_SIZE
#define scale_t SCALE_BIT_SIZE
#define k_t K_BIT_SIZE
#define output_addr_t OUTPUT_BIT_SIZE
#define input_addr_t INPUT_BIT_SIZE
#define output_gap_t OUTPUT_GAP_BIT_SIZE
#define outframe_addr_t OUTPUT_WIDTH_BIT_SIZE * 2
#define out_width_t OUTPUT_WIDTH_BIT_SIZE
#define cg_addr_t CG_BIT_SIZE
#define weight_bus_addr_t WEIGHT_BUS_BIT_SIZE
#define weight_bus_size_t (WEIGHT_BUS_BIT_SIZE+1)
#define mem_bus_addr_t MEM_BUS_BYTE_BIT_SIZE
#define mem_addr_t MEM_BIT_SIZE
//#define mem_addr_t 0
#define layer_addr_t LAYER_BIT_SIZE
#define dim_t DIM_BIT_SIZE
#define frame_t (DIM_BIT_SIZE * 2)
#define loc_frame_t (WIDTH_BIT_SIZE * 2)
#define fpga_min_addr_t 4
#define pad_t 2
#define batch_t 3

#define ibSize_t 5
#define ctrl_width_t	6
// need to change GetStrobe for 64bit
#define DDR_DATAWIDTH	8
#define PS_DDR_DATAWIDTH	8

#if DDR_DATAWIDTH == 8
#define ddr_width_t 5
#define ddr_width1_t 6
#elif DDR_DATAWIDTH == 32
#define ddr_width_t 5
#define ddr_width1_t 6
#elif DDR_DATAWIDTH == 64
#define ddr_width_t 6
#define ddr_width1_t 7
#endif

#define DDR_FEATURE_ID  1
#define DDR_WEIGHT_ID   1
#define MAX_WRITE_IDLE_COUNT	5

enum DDR_ID { DDR_NOID = 0, DDR_DATA_ID = 1, DDR_EXT_ID = 2 };
