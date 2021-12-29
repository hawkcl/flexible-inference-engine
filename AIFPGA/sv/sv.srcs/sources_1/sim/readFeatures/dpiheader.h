/* MTI_DPI */

/*
 * Copyright 2002-2013 Mentor Graphics Corporation.
 *
 * Note:
 *   This file is automatically generated.
 *   Please do not edit this file - you will lose your edits.
 *
 * Settings when this file was generated:
 *   PLATFORM = 'win64'
 */
#ifndef INCLUDED_DPIHEADER
#define INCLUDED_DPIHEADER

#ifdef __cplusplus
#define DPI_LINK_DECL  extern "C" 
#else
#define DPI_LINK_DECL 
#endif

#include "svdpi.h"


#ifndef MTI_INCLUDED_TYPEDEF_Instruction
#define MTI_INCLUDED_TYPEDEF_Instruction

typedef struct {
    svLogicVecVal reqSeqNum[SV_PACKED_DATA_NELEMS(11)];
    svLogicVecVal reqProgress[SV_PACKED_DATA_NELEMS(11)];
    svLogicVecVal reqSeqNumW[SV_PACKED_DATA_NELEMS(11)];
    svLogicVecVal reqProgressW[SV_PACKED_DATA_NELEMS(11)];
    svLogicVecVal seqNum[SV_PACKED_DATA_NELEMS(11)];
    svLogicVecVal fScale[SV_PACKED_DATA_NELEMS(4)];
    svLogicVecVal wScale[SV_PACKED_DATA_NELEMS(4)];
    svLogicVecVal W[SV_PACKED_DATA_NELEMS(9)];
    svLogicVecVal H[SV_PACKED_DATA_NELEMS(9)];
    svLogicVecVal C[SV_PACKED_DATA_NELEMS(11)];
    svLogicVecVal W1[SV_PACKED_DATA_NELEMS(4)];
    svLogicVecVal H1[SV_PACKED_DATA_NELEMS(4)];
    svLogicVecVal batch12[SV_PACKED_DATA_NELEMS(5)];
    svLogicVecVal batch9[SV_PACKED_DATA_NELEMS(5)];
    svLogicVecVal batch0[SV_PACKED_DATA_NELEMS(4)];
    svLogicVecVal Maddr[SV_PACKED_DATA_NELEMS(26)];
    svLogicVecVal Waddr[SV_PACKED_DATA_NELEMS(26)];
    svLogicVecVal Oaddr[SV_PACKED_DATA_NELEMS(26)];
    svLogicVecVal WSize[SV_PACKED_DATA_NELEMS(26)];
    svLogicVecVal WEnd[4][SV_PACKED_DATA_NELEMS(26)];
    svLogicVecVal S[SV_PACKED_DATA_NELEMS(2)];
    svLogicVecVal lPad[SV_PACKED_DATA_NELEMS(2)];
    svLogicVecVal rPad[SV_PACKED_DATA_NELEMS(2)];
    svLogicVecVal K[SV_PACKED_DATA_NELEMS(3)];
    svLogicVecVal M[SV_PACKED_DATA_NELEMS(11)];
    svLogicVecVal Kh[4][SV_PACKED_DATA_NELEMS(11)];
    svLogicVecVal Ks[4][SV_PACKED_DATA_NELEMS(11)];
    svLogicVecVal Kt[4][SV_PACKED_DATA_NELEMS(11)];
    svLogicVecVal Kbh[4][SV_PACKED_DATA_NELEMS(11)];
    svLogicVecVal Kbe[4][SV_PACKED_DATA_NELEMS(11)];
    svLogicVecVal Res_addr[SV_PACKED_DATA_NELEMS(26)];
    svLogicVecVal BM_addr[SV_PACKED_DATA_NELEMS(26)];
    svLogicVecVal wLRelu[SV_PACKED_DATA_NELEMS(8)];
    svLogicVecVal mode[SV_PACKED_DATA_NELEMS(2)];
    svLogicVecVal progressMaster[SV_PACKED_DATA_NELEMS(2)];
    svLogicVecVal wDropSize[SV_PACKED_DATA_NELEMS(2)];
    svLogic doBatch3;
    svLogic isUseWRam;
    svLogic isMaddr_a;
    svLogic isMaddr_b;
    svLogic isOaddr_a;
    svLogic isOaddr_b;
    svLogic isRaddr_a;
    svLogic doRes;
    svLogic doRelu;
    svLogic doLRelu;
    svLogic doBM;
    svLogic doUpSample;
    svLogic isConv;
}  Instruction;

#endif

#ifndef MTI_INCLUDED_TYPEDEF_InstructionHCB_unpack
#define MTI_INCLUDED_TYPEDEF_InstructionHCB_unpack

typedef struct {
    svLogicVecVal Id[SV_PACKED_DATA_NELEMS(2)];
    svLogicVecVal itype[SV_PACKED_DATA_NELEMS(4)];
    svLogicVecVal reqSeqNum[SV_PACKED_DATA_NELEMS(11)];
    svLogicVecVal reqProgress[SV_PACKED_DATA_NELEMS(11)];
    svLogicVecVal reqSeqNumW[SV_PACKED_DATA_NELEMS(11)];
    svLogicVecVal reqProgressW[SV_PACKED_DATA_NELEMS(11)];
    svLogicVecVal seqNum[SV_PACKED_DATA_NELEMS(11)];
    svLogicVecVal W[SV_PACKED_DATA_NELEMS(9)];
    svLogicVecVal H[SV_PACKED_DATA_NELEMS(9)];
    svLogicVecVal C[SV_PACKED_DATA_NELEMS(11)];
    svLogicVecVal Waddr[SV_PACKED_DATA_NELEMS(26)];
    svLogicVecVal WEnd[SV_PACKED_DATA_NELEMS(26)];
    svLogicVecVal weightPos[SV_PACKED_DATA_NELEMS(5)];
    svLogicVecVal ReadPos[SV_PACKED_DATA_NELEMS(5)];
    svLogicVecVal ResPos[SV_PACKED_DATA_NELEMS(5)];
    svLogicVecVal W1[SV_PACKED_DATA_NELEMS(4)];
    svLogicVecVal H1[SV_PACKED_DATA_NELEMS(4)];
    svLogicVecVal X[SV_PACKED_DATA_NELEMS(9)];
    svLogicVecVal Y[SV_PACKED_DATA_NELEMS(9)];
    svLogicVecVal S[SV_PACKED_DATA_NELEMS(2)];
    svLogicVecVal lPad[SV_PACKED_DATA_NELEMS(2)];
    svLogicVecVal rPad[SV_PACKED_DATA_NELEMS(2)];
    svLogicVecVal K[SV_PACKED_DATA_NELEMS(3)];
    svLogicVecVal M[SV_PACKED_DATA_NELEMS(11)];
    svLogicVecVal Kh[SV_PACKED_DATA_NELEMS(11)];
    svLogicVecVal Ks[SV_PACKED_DATA_NELEMS(11)];
    svLogicVecVal Kt[SV_PACKED_DATA_NELEMS(11)];
    svLogicVecVal Res_addr[SV_PACKED_DATA_NELEMS(26)];
    svLogicVecVal wScale[SV_PACKED_DATA_NELEMS(4)];
    svLogicVecVal fScale[SV_PACKED_DATA_NELEMS(4)];
    svLogicVecVal BM_addr[SV_PACKED_DATA_NELEMS(26)];
    svLogicVecVal wLRelu[SV_PACKED_DATA_NELEMS(8)];
    svLogicVecVal weightToken[SV_PACKED_DATA_NELEMS(2)];
    svLogicVecVal maxpool_size[SV_PACKED_DATA_NELEMS(2)];
    svLogicVecVal maxpool_stride[SV_PACKED_DATA_NELEMS(2)];
    svLogicVecVal mode[SV_PACKED_DATA_NELEMS(2)];
    svLogic isResMaster;
    svLogic isProgressMaster;
    svLogic isRaddr_a;
    svLogic doRes;
    svLogic doRelu;
    svLogic doLRelu;
    svLogic doBM;
    svLogic doUpSample;
    svLogic newWriteInst;
    svLogicVecVal outbufsize[SV_PACKED_DATA_NELEMS(8)];
    svLogicVecVal ofsize[SV_PACKED_DATA_NELEMS(18)];
    svLogicVecVal outyx[SV_PACKED_DATA_NELEMS(18)];
    svLogicVecVal outputAddrGap[SV_PACKED_DATA_NELEMS(24)];
    svLogicVecVal outkh[SV_PACKED_DATA_NELEMS(26)];
    svLogicVecVal ng[SV_PACKED_DATA_NELEMS(4)];
    svLogicVecVal gu[SV_PACKED_DATA_NELEMS(4)];
    svLogicVecVal resSize[SV_PACKED_DATA_NELEMS(16)];
    svLogicVecVal resSizeLast[SV_PACKED_DATA_NELEMS(16)];
    svLogicVecVal resLen[SV_PACKED_DATA_NELEMS(5)];
    svLogicVecVal resLenLast[SV_PACKED_DATA_NELEMS(5)];
    svLogicVecVal pfs[SV_PACKED_DATA_NELEMS(8)];
    svLogicVecVal volumeSize[SV_PACKED_DATA_NELEMS(17)];
    svLogicVecVal kCurLast[SV_PACKED_DATA_NELEMS(11)];
    svLogicVecVal wtotal_n[SV_PACKED_DATA_NELEMS(4)];
    svLogicVecVal wtotalLast[SV_PACKED_DATA_NELEMS(4)];
    svLogicVecVal wlenk_regular[SV_PACKED_DATA_NELEMS(4)];
    svLogicVecVal wlenk_nLast[SV_PACKED_DATA_NELEMS(4)];
    svLogicVecVal wlenk_nLast2[SV_PACKED_DATA_NELEMS(4)];
    svLogicVecVal totalBM[SV_PACKED_DATA_NELEMS(11)];
    svLogicVecVal totalRes[SV_PACKED_DATA_NELEMS(16)];
}  InstructionHCB_unpack;

#endif

#ifndef MTI_INCLUDED_TYPEDEF_InstructionRead_unpack
#define MTI_INCLUDED_TYPEDEF_InstructionRead_unpack

typedef struct {
    svLogicVecVal mode[SV_PACKED_DATA_NELEMS(2)];
    svLogicVecVal reqSeqNum[SV_PACKED_DATA_NELEMS(11)];
    svLogicVecVal reqProgress[SV_PACKED_DATA_NELEMS(11)];
    svLogicVecVal seqNum[SV_PACKED_DATA_NELEMS(11)];
    svLogicVecVal W[SV_PACKED_DATA_NELEMS(9)];
    svLogicVecVal H[SV_PACKED_DATA_NELEMS(9)];
    svLogicVecVal C[SV_PACKED_DATA_NELEMS(11)];
    svLogicVecVal Maddr[SV_PACKED_DATA_NELEMS(26)];
    svLogicVecVal W1[SV_PACKED_DATA_NELEMS(4)];
    svLogicVecVal W2[SV_PACKED_DATA_NELEMS(4)];
    svLogicVecVal H1[SV_PACKED_DATA_NELEMS(4)];
    svLogicVecVal X[SV_PACKED_DATA_NELEMS(9)];
    svLogicVecVal Y[SV_PACKED_DATA_NELEMS(9)];
    svLogicVecVal S[SV_PACKED_DATA_NELEMS(2)];
    svLogicVecVal lPad[SV_PACKED_DATA_NELEMS(2)];
    svLogicVecVal rPad[SV_PACKED_DATA_NELEMS(2)];
    svLogic isMaddr_a;
    svLogic isMaddr_b;
    svLogic isRes_a;
}  InstructionRead_unpack;

#endif

#ifndef MTI_INCLUDED_TYPEDEF_InstructionWeight_unpack
#define MTI_INCLUDED_TYPEDEF_InstructionWeight_unpack

typedef struct {
    svLogic isReadRam;
    svLogic isWriteRam;
    svLogicVecVal mode[SV_PACKED_DATA_NELEMS(2)];
    svLogicVecVal dropSize[SV_PACKED_DATA_NELEMS(2)];
    svLogicVecVal seqNum[SV_PACKED_DATA_NELEMS(11)];
    svLogicVecVal Oaddr[SV_PACKED_DATA_NELEMS(26)];
    svLogicVecVal size[SV_PACKED_DATA_NELEMS(26)];
}  InstructionWeight_unpack;

#endif

#ifndef MTI_INCLUDED_TYPEDEF_InstructionWrite_unpack
#define MTI_INCLUDED_TYPEDEF_InstructionWrite_unpack

typedef struct {
    svLogicVecVal mode[SV_PACKED_DATA_NELEMS(2)];
    svLogicVecVal dataWidth[SV_PACKED_DATA_NELEMS(4)];
    svLogicVecVal dataWidth2[SV_PACKED_DATA_NELEMS(4)];
    svLogicVecVal Oaddr[SV_PACKED_DATA_NELEMS(26)];
    svLogicVecVal outH1[SV_PACKED_DATA_NELEMS(4)];
    svLogic isUpsample;
    svLogic isMaddr_a;
    svLogic isMaddr_b;
    svLogicVecVal maxpool_stride[SV_PACKED_DATA_NELEMS(2)];
    svLogicVecVal maxpool_size[SV_PACKED_DATA_NELEMS(2)];
}  InstructionWrite_unpack;

#endif

#ifndef MTI_INCLUDED_TYPEDEF_RequestItem_t_unpack
#define MTI_INCLUDED_TYPEDEF_RequestItem_t_unpack

typedef struct {
    svLogicVecVal addr[SV_PACKED_DATA_NELEMS(26)];
    svLogicVecVal seq[SV_PACKED_DATA_NELEMS(8)];
    svLogicVecVal len[SV_PACKED_DATA_NELEMS(8)];
    svLogicVecVal token[SV_PACKED_DATA_NELEMS(8)];
    svLogicVecVal dtype[SV_PACKED_DATA_NELEMS(3)];
    svLogic isRamA;
    svLogic isRamB;
}  RequestItem_t_unpack;

#endif

#ifndef MTI_INCLUDED_TYPEDEF_ReturnData_t_unpack
#define MTI_INCLUDED_TYPEDEF_ReturnData_t_unpack

typedef struct {
    svLogicVecVal dtype[SV_PACKED_DATA_NELEMS(3)];
    svLogicVecVal seq[SV_PACKED_DATA_NELEMS(8)];
    svLogicVecVal len[SV_PACKED_DATA_NELEMS(8)];
    svLogicVecVal token[SV_PACKED_DATA_NELEMS(8)];
    svLogicVecVal data[28][SV_PACKED_DATA_NELEMS(8)];
}  ReturnData_t_unpack;

#endif

#ifndef MTI_INCLUDED_TYPEDEF_readFeatures_inputs
#define MTI_INCLUDED_TYPEDEF_readFeatures_inputs

typedef struct {
    svLogic pread_busValid;
    svLogic pread_isFeature;
    svLogic isReadingFeatures;
    svLogic isLoadingFroze;
    svLogic isLoadingNextFeatures;
    svLogicVecVal pread_seqNum[SV_PACKED_DATA_NELEMS(11)];
    svLogicVecVal reqSeqF[SV_PACKED_DATA_NELEMS(11)];
    svLogicVecVal writeWidth[SV_PACKED_DATA_NELEMS(4)];
    svLogic new_params;
    svLogicVecVal readPos[SV_PACKED_DATA_NELEMS(5)];
    svLogicVecVal volumeSize[SV_PACKED_DATA_NELEMS(17)];
    svLogicVecVal usedWords[SV_PACKED_DATA_NELEMS(17)];
    svLogicVecVal dataBus[33][SV_PACKED_DATA_NELEMS(8)];
}  readFeatures_inputs;

#endif

#ifndef MTI_INCLUDED_TYPEDEF_readFeatures_outputs
#define MTI_INCLUDED_TYPEDEF_readFeatures_outputs

typedef struct {
    svLogic setLoadingFroze;
    svLogic resetLoadingFroze;
    svLogic resetLoadingNextFeatures;
    svLogic resetReadingFeatures;
    svLogic wen;
    svLogicVecVal addrOut[SV_PACKED_DATA_NELEMS(14)];
    svLogicVecVal dataOut[12][SV_PACKED_DATA_NELEMS(8)];
    svLogicVecVal nextWritePos[SV_PACKED_DATA_NELEMS(17)];
    svLogicVecVal ibSize[SV_PACKED_DATA_NELEMS(5)];
}  readFeatures_outputs;

#endif

#ifndef MTI_INCLUDED_TYPEDEF_ucl_config_t
#define MTI_INCLUDED_TYPEDEF_ucl_config_t

typedef struct {
    svLogic mMux;
    svLogicVecVal a0Mux[SV_PACKED_DATA_NELEMS(2)];
    svLogicVecVal aMux[SV_PACKED_DATA_NELEMS(2)];
    svLogicVecVal sqMux[SV_PACKED_DATA_NELEMS(3)];
    svLogic lMux;
    svLogicVecVal oMux[SV_PACKED_DATA_NELEMS(2)];
}  ucl_config_t;

#endif


DPI_LINK_DECL DPI_DLLESPEC
void
compare_outputs(
    const readFeatures_outputs* out_data);

DPI_LINK_DECL DPI_DLLESPEC
void
init_files();

DPI_LINK_DECL DPI_DLLESPEC
void
read_inputs(
    readFeatures_inputs* in_data);

#endif 
