`timescale 1ns / 1ns
module HCBCtrl_tb
import definitions_pkg::*;
();

logic clock, resetN;
logic enable;
logic stop;
logic waiting_out;
k_t k;
pad_t stride;
logic doBM;
logic doRelu;
logic doLRelu; 
logic doRes;
logic isOnOutput;
logic reset_isOnOutput; // finished one output
logic BM_enough_data;
logic w_enough_data;
res_size_t receivedRes;
res_size_t totalRes;
logic input_fifo_empty;
layer_addr_t readCLast;
logic new_conv_inst;
layer_addr_t Ks;
layer_addr_t kt;
cg_addr_t new_wtotal;
cg_addr_t numGroups;
logic reset_state;
logic resetLoadingNextFeatures;
logic resetReadingFeatures;
logic new_params_prefetch;
logic setLoadingFroze;
logic resetLoadingFroze;
width_t writeWidth;
logic resetAssemble;
width_t new_readWidth;
width_t new_outputBufH1;
s_row_addr_t new_rowNum;
loc_frame_t prefetchFrameSize;
layer_addr_t new_kCur;
cg_addr_t new_usedGroups;
k_t inst_k;
layer_addr_t kOut;
layer_addr_t kCurLast;
cg_addr_t usedGroupsLast;
cg_addr_t wtotal_n;
weight_bus_size_t wlenk_nLast;
cg_addr_t wtotalLast;
weight_bus_size_t wlenk_nLast2;
weight_bus_size_t wlenk_regular;
weight_bus_size_t wlen_regular;
weight_bus_size_t new_wlenk;
weight_bus_size_t new_wlenk_last;
layer_addr_t kCurLast_1;
width1_t new_maxRowCount;
width_t new_lastLen;

logic startPrefetching;
logic startConvOut; 
weight_bus_size_t BMlen; 
weight_bus_size_t wlenk;
logic enSendBMWeights;
logic enSendWeights;
logic isBMWeightValid;
logic isWeightValid;
cg_addr_t weightId;
logic sendBackUpInput_valid;
k_t backupId;
logic isOutputReady;
logic nextWeight;
width_t readWidth;
s_row_addr_t rowNum;
logic reset_iLayers;
logic loadNextInst;
logic isPrefetchNextVolume_next;
logic isPrefetchNextVolume;
layer_addr_t workingProgress_o;
logic doAssemble_o;
input_addr_t usedWords_o;
logic isInitLayer_o;
logic isReadingFeatures_o;
logic isLoadingFroze_o;
logic hasNextFeatureParams_o;
logic isLoadingNextFeatures_o;
logic isLReluWeight_o;
k_t iterCountDown_o;
width_t outputReadPos_o;
width_t outputWritePos_o;
HCB_STATE state_o;
HCB_STATE state_next_o;
width_t outputBufH1_o;
logic isNextVolumeReady_o;
logic bmPhase_o;
logic isRunning_o;
logic is_cycle_froze;
width1_t maxRowCount;
width_t lastLen;
INPUT_SOURCE input_src;
 

HCBCtrl_ports ports(.*);
HCBCtrl_top top(ports);

HCBCtrl HCBCtrl(.*);
  
initial begin
  //$dumpfile("fifo.vcd");
  //$dumpvars();
  clock = 0;
end

always #10 clock  = ~clock;

endmodule
