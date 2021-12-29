#include "pack.h"
#include "sim.h"

namespace CloudDesign{
	CPack pack; // not thread safe
	unsigned InstructionHCBLength;
	unsigned char* DoPackInstructionHCB(InstructionHCB *pi)
	{
		static bool reported = false;
		pack.Reset();
		//pack.DoPack(pi->Maddr);
		//pack.DoPack(pi->Oaddr);

		//pack.DoPack(pi->isWeightMaster , 1);


		pack.DoPack(pi->totalRes, res_size_t);
		//pack.DoPack(pi->totalBM, bm_size_t);
		pack.DoPack(pi->wlenk_nLast2 , weight_bus_size_t);
		pack.DoPack(pi->wlenk_nLast , weight_bus_size_t);
		pack.DoPack(pi->wlenk_regular , weight_bus_size_t);  //4
		pack.DoPack(pi->wtotalLast , cg_addr_t);
		pack.DoPack(pi->wtotal_n , cg_addr_t);
		pack.DoPack(pi->kCurLast , layer_addr_t);
		pack.DoPack(pi->volumeSize , input_addr_t);  //17
		pack.DoPack(pi->pfs , loc_frame_t);
		pack.DoPack(pi->resLenLast , res_len_t);
		pack.DoPack(pi->resLen , res_len_t); //5
		pack.DoPack(pi->resSizeLast , res_size_t);
		pack.DoPack(pi->resSize , res_size_t);  //16
		pack.DoPack(pi->gu , cg_addr_t);
		pack.DoPack(pi->ng , cg_addr_t); //4
		pack.DoPack(pi->outkh, mem_addr_t);// , mem_addr_t);
		pack.DoPack(pi->outputAddrGap , output_gap_t); //24
		pack.DoPack(pi->outyx , frame_t);
		pack.DoPack(pi->ofsize , frame_t); //18
		pack.DoPack(pi->outbufsize , loc_frame_t); //8
		pack.DoPack(pi->newWriteInst , 1);
		pack.DoPack(pi->doUpSample , 1);
		pack.DoPack(pi->doBM , 1);
		pack.DoPack(pi->doLRelu , 1);
		pack.DoPack(pi->doRelu , 1);
		pack.DoPack(pi->doRes , 1);
		pack.DoPack(pi->isRaddr_a , 1); //for Res
		pack.DoPack(pi->isProgressMaster , 1);
		pack.DoPack(pi->isResMaster , 1);
		pack.DoPack(pi->mode, 2); //2
		pack.DoPack(pi->maxpool_stride , pad_t);
		pack.DoPack(pi->maxpool_size , pad_t);
		pack.DoPack(pi->weightToken , token_t);  //2
		pack.DoPack(pi->wLRelu, FEATURE_BIT_SIZE);  //12?
		//pack.DoPack(pi->BM_addr, mem_addr_t);
		pack.DoPack(pi->fScale , scale_t);
		pack.DoPack(pi->wScale , scale_t); //4
		pack.DoPack(pi->Res_addr, mem_addr_t);
		pack.DoPack(pi->Kt , layer_addr_t); // start, stride, and tail(inclusive)
		pack.DoPack(pi->Ks , layer_addr_t);
		pack.DoPack(pi->Kh , layer_addr_t);
		pack.DoPack(pi->M , layer_addr_t); // filter size, filter layers
		pack.DoPack(pi->K , k_t); //3
		pack.DoPack(pi->rPad , pad_t);
		pack.DoPack(pi->lPad , pad_t);
		pack.DoPack(pi->S , pad_t); //2
		pack.DoPack(pi->Y , out_width_t); //maxval for read, write, weight, ext token gen
		pack.DoPack(pi->X , out_width_t);
		pack.DoPack(pi->H1 , width_t);
		pack.DoPack(pi->W1 , width_t); //4
		pack.DoPack(pi->ResPos , mem_bus_addr_t);
		pack.DoPack(pi->ReadPos , mem_bus_addr_t);
		pack.DoPack(pi->weightPos , mem_bus_addr_t); //5
		pack.DoPack(pi->WEnd, mem_addr_t);
		pack.DoPack(pi->Waddr, mem_addr_t);
		pack.DoPack(pi->C , layer_addr_t); //11
		pack.DoPack(pi->H , out_width_t);
		pack.DoPack(pi->W , out_width_t); //9
		pack.DoPack(pi->seqNum , seq_t);
		pack.DoPack(pi->reqProgressW , seq_t);
		pack.DoPack(pi->reqSeqNumW , seq_t);
		pack.DoPack(pi->reqProgress , seq_t);
		pack.DoPack(pi->reqSeqNum , seq_t); //11
		pack.DoPack(pi->type , 4);
		pack.DoPack(pi->Id , bank_num_t);  //2

		InstructionHCBLength = pack.GetByteLength();
		if (!reported){
			printf("InstructionHCB total bits : %d\n", pack.GetBitLength());
			reported = true;
		}
		return pack.GetBuffer();
	}

	void UnPackInstructionHCB(unsigned char *buf, InstructionHCB *pi)
	{
		pack.Reset();
		//pi->Maddr = pack.UnPack(buf);
		//pi->Oaddr = pack.UnPack(buf);

		//pi->isWeightMaster = pack.UnPack(buf, 1);


		pi->totalRes = pack.UnPack(buf, res_size_t);
		//pi->totalBM = pack.UnPack(buf, bm_size_t);
		pi->wlenk_nLast2 = pack.UnPack(buf, weight_bus_size_t);
		pi->wlenk_nLast = pack.UnPack(buf, weight_bus_size_t);
		pi->wlenk_regular = pack.UnPack(buf, weight_bus_size_t);  //4
		pi->wtotalLast = pack.UnPack(buf, cg_addr_t);
		pi->wtotal_n = pack.UnPack(buf, cg_addr_t);
		pi->kCurLast = pack.UnPack(buf, layer_addr_t);
		pi->volumeSize = pack.UnPack(buf, input_addr_t);  //17
		pi->pfs = pack.UnPack(buf, loc_frame_t);
		pi->resLenLast = pack.UnPack(buf, res_len_t);
		pi->resLen = pack.UnPack(buf, res_len_t); //5
		pi->resSizeLast = pack.UnPack(buf, res_size_t);
		pi->resSize = pack.UnPack(buf, res_size_t);  //16
		pi->gu = pack.UnPack(buf, cg_addr_t);
		pi->ng = pack.UnPack(buf, cg_addr_t); //4
		pi->outkh = pack.UnPack(buf, mem_addr_t);// , mem_addr_t);
		pi->outputAddrGap = pack.UnPack(buf, output_gap_t); //24
		pi->outyx = pack.UnPack(buf, frame_t);
		pi->ofsize = pack.UnPack(buf, frame_t); //18
		pi->outbufsize = pack.UnPack(buf, loc_frame_t); //8
		pi->newWriteInst = pack.UnPack(buf, 1);
		pi->doUpSample = pack.UnPack(buf, 1);
		pi->doBM = pack.UnPack(buf, 1);
		pi->doLRelu = pack.UnPack(buf, 1);
		pi->doRelu = pack.UnPack(buf, 1);
		pi->doRes = pack.UnPack(buf, 1);
		pi->isRaddr_a = pack.UnPack(buf, 1); //for Res
		pi->isProgressMaster = pack.UnPack(buf, 1);
		pi->isResMaster = pack.UnPack(buf, 1);
		pi->mode = (DATA_MODE)pack.UnPack(buf, 2); //2
		pi->maxpool_stride = pack.UnPack(buf, pad_t);
		pi->maxpool_size = pack.UnPack(buf, pad_t);
		pi->weightToken = pack.UnPack(buf, token_t);  //2
		pi->wLRelu = pack.UnPack(buf, FEATURE_BIT_SIZE);  //12?
		//pi->BM_addr = pack.UnPack(buf, mem_addr_t);
		pi->fScale = pack.UnPack(buf, scale_t);
		pi->wScale = pack.UnPack(buf, scale_t); //4
		pi->Res_addr = pack.UnPack(buf, mem_addr_t);
		pi->Kt = pack.UnPack(buf, layer_addr_t); // start, stride, and tail(inclusive)
		pi->Ks = pack.UnPack(buf, layer_addr_t);
		pi->Kh = pack.UnPack(buf, layer_addr_t);
		pi->M = pack.UnPack(buf, layer_addr_t); // filter size, filter layers
		pi->K = pack.UnPack(buf, k_t); //3
		pi->rPad = pack.UnPack(buf, pad_t);
		pi->lPad = pack.UnPack(buf, pad_t);
		pi->S = pack.UnPack(buf, pad_t); //2
		pi->Y = pack.UnPack(buf, out_width_t); //maxval for read, write, weight, ext token gen
		pi->X = pack.UnPack(buf, out_width_t);
		pi->H1 = pack.UnPack(buf, width_t);
		pi->W1 = pack.UnPack(buf, width_t); //4
		pi->ResPos = pack.UnPack(buf, mem_bus_addr_t);
		pi->ReadPos = pack.UnPack(buf, mem_bus_addr_t);
		pi->weightPos = pack.UnPack(buf, mem_bus_addr_t); //5
		pi->WEnd = pack.UnPack(buf, mem_addr_t);
		pi->Waddr = pack.UnPack(buf, mem_addr_t);
		pi->C = pack.UnPack(buf, layer_addr_t); //11
		pi->H = pack.UnPack(buf, out_width_t);
		pi->W = pack.UnPack(buf, out_width_t); //9
		pi->seqNum = pack.UnPack(buf, seq_t);
		pi->reqProgressW = pack.UnPack(buf, seq_t);
		pi->reqSeqNumW = pack.UnPack(buf, seq_t);
		pi->reqProgress = pack.UnPack(buf, seq_t);
		pi->reqSeqNum = pack.UnPack(buf, seq_t); //11
		pi->type = pack.UnPack(buf, 4);
		pi->Id = pack.UnPack(buf, bank_num_t);  //2
	}

	unsigned InstructionWeightLength;
	unsigned char* DoPackInstructionWeight(InstructionWeight *pi)
	{
		static bool reported = false;
		pack.Reset();

		pack.DoPack(pi->size, mem_addr_t);
		pack.DoPack(pi->Oaddr, mem_addr_t);
		pack.DoPack(pi->seqNum, seq_t);
		pack.DoPack(pi->dropSize, 2);
		pack.DoPack(pi->mode, 2); //11
		pack.DoPack(pi->isWriteRam, 1);
		pack.DoPack(pi->isReadRam, 1);  //2
		InstructionWeightLength = pack.GetByteLength();
		if (!reported){
			printf("InstructionWeight total bits : %d\n", pack.GetBitLength());
			reported = true;
		}
		return pack.GetBuffer();
	}
	void UnPackInstructionWeight(unsigned char *buf, InstructionWeight *pi)
	{
		pack.Reset();

		pi->size = pack.UnPack(buf, mem_addr_t);
		pi->Oaddr = pack.UnPack(buf, mem_addr_t);
		pi->seqNum = pack.UnPack(buf, seq_t);
		pi->dropSize = pack.UnPack(buf, 2);
		pi->mode = (DATA_MODE)pack.UnPack(buf, 2); //11
		pi->isWriteRam = pack.UnPack(buf, 1);
		pi->isReadRam = pack.UnPack(buf, 1);  //2
	}

	unsigned InstructionReadLength;
	unsigned char* DoPackInstructionRead(InstructionRead *pi)
	{
		static bool reported = false;
		pack.Reset();


		pack.DoPack(pi->isRes_a , 1);
		pack.DoPack(pi->isMaddr_b , 1);
		pack.DoPack(pi->isMaddr_a , 1);
		pack.DoPack(pi->rPad , pad_t);
		pack.DoPack(pi->lPad , pad_t);
		pack.DoPack(pi->S , pad_t);
		pack.DoPack(pi->Y , out_width_t);
		pack.DoPack(pi->X , out_width_t);
		pack.DoPack(pi->H1 , width_t);
		pack.DoPack(pi->W2 , width_t);
		pack.DoPack(pi->W1 , width_t);
		pack.DoPack(pi->Maddr, mem_addr_t);
		pack.DoPack(pi->C , layer_addr_t);
		pack.DoPack(pi->H , out_width_t);
		pack.DoPack(pi->W , out_width_t);
		pack.DoPack(pi->seqNum , seq_t);
		pack.DoPack(pi->reqProgress, seq_t); //11
		pack.DoPack(pi->reqSeqNum, seq_t);
		pack.DoPack(pi->mode, 2);  //2

		InstructionReadLength = pack.GetByteLength();
		if (!reported){
			printf("InstructionRead total bits : %d\n", pack.GetBitLength());
			reported = true;
		}
		return pack.GetBuffer();

	}
	void UnPackInstructionRead(unsigned char *buf, InstructionRead *pi)
	{
		pack.Reset();

		pi->isRes_a = pack.UnPack(buf, 1);
		pi->isMaddr_b = pack.UnPack(buf, 1);
		pi->isMaddr_a = pack.UnPack(buf, 1);  //2
		pi->rPad = pack.UnPack(buf, pad_t);
		pi->lPad = pack.UnPack(buf, pad_t);
		pi->S = pack.UnPack(buf, pad_t);
		pi->Y = pack.UnPack(buf, out_width_t);
		pi->X = pack.UnPack(buf, out_width_t);
		pi->H1 = pack.UnPack(buf, width_t);
		pi->W2 = pack.UnPack(buf, width_t);
		pi->W1 = pack.UnPack(buf, width_t);
		pi->Maddr = pack.UnPack(buf, mem_addr_t);
		pi->C = pack.UnPack(buf, layer_addr_t);
		pi->H = pack.UnPack(buf, out_width_t);
		pi->W = pack.UnPack(buf, out_width_t);
		pi->seqNum = pack.UnPack(buf, seq_t);
		pi->reqProgress = pack.UnPack(buf, seq_t);
		pi->reqSeqNum = pack.UnPack(buf, seq_t);
		pi->mode = (DATA_MODE)pack.UnPack(buf, 2); //11
	}

	unsigned InstructionWriteLength;
	unsigned char* DoPackInstructionWrite(InstructionWrite *pi)
	{
		static bool reported = false;
		pack.Reset();

		pack.DoPack(pi->maxpool_size, pad_t);
		pack.DoPack(pi->maxpool_stride, pad_t);
		pack.DoPack(pi->isMaddr_b, 1);
		pack.DoPack(pi->isMaddr_a, 1);
		pack.DoPack(pi->isUpsample, 1);
		pack.DoPack(pi->outH1, width_t);
		pack.DoPack(pi->Oaddr, mem_addr_t);
		pack.DoPack(pi->dataWidth2, width_t);
		pack.DoPack(pi->dataWidth, width_t);
		pack.DoPack(pi->mode, 2); //11
		
		InstructionWriteLength = pack.GetByteLength();
		if (!reported){
			printf("InstructionWrite total bits : %d\n", pack.GetBitLength());
			reported = true;
		}
		return pack.GetBuffer();
	}
	void UnPackInstructionWrite(unsigned char *buf, InstructionWrite *pi)
	{
		pack.Reset();
		
		pi->maxpool_size = pack.UnPack(buf, pad_t);
		pi->maxpool_stride = pack.UnPack(buf, pad_t);
		pi->isMaddr_b = pack.UnPack(buf, 1);
		pi->isMaddr_a = pack.UnPack(buf, 1);
		pi->isUpsample = pack.UnPack(buf, 1);
		pi->outH1 = pack.UnPack(buf, width_t);
		pi->Oaddr = pack.UnPack(buf, mem_addr_t);
		pi->dataWidth2 = pack.UnPack(buf, width_t);
		pi->dataWidth = pack.UnPack(buf, width_t);
		pi->mode = (DATA_MODE)pack.UnPack(buf, 2); //11
	}

	unsigned InstructionEndLength;
	unsigned char* DoPackInstructionEnd(InstructionEnd *pi)
	{
		static bool reported = false;
		pack.Reset();
		
		pack.DoPack(pi->oAddr, mem_addr_t);
		pack.DoPack(pi->oSize, mem_addr_t);
		pack.DoPack(pi->reqSeqNum, seq_t);
		pack.DoPack(pi->hasMore, 1); //11
		pack.DoPack(pi->isRamB, 1);
		pack.DoPack(pi->isRamA, 1);  //2

		InstructionEndLength = pack.GetByteLength();
		if (!reported){
			printf("InstructionEnd total bits : %d\n", pack.GetBitLength());
			reported = true;
		}
		return pack.GetBuffer();
	}
	void UnPackInstructionEnd(unsigned char *buf, InstructionEnd *pi)
	{
		pack.Reset();
		
		pi->oAddr = pack.UnPack(buf, mem_addr_t);
		pi->oSize = pack.UnPack(buf, mem_addr_t);
		pi->reqSeqNum = pack.UnPack(buf, seq_t);
		pi->hasMore = pack.UnPack(buf, 1);
		pi->isRamB = pack.UnPack(buf, 1);
		pi->isRamA = pack.UnPack(buf, 1);
	}

	unsigned InstructionOptionLength;
	unsigned char* DoPackInstructionOption(InstructionOption *pi)
	{
		static bool reported = false;
		pack.Reset();
		
		pack.DoPack(pi->stop, 1);
		pack.DoPack(pi->start, 1);  //2
		InstructionOptionLength = pack.GetByteLength();
		if (!reported){
			printf("InstructionOption total bits : %d\n", pack.GetBitLength());
			reported = true;
		}
		return pack.GetBuffer();
	}
	void UnPackInstructionOption(unsigned char *buf, InstructionOption *pi)
	{
		pack.Reset();
		
		pi->stop = pack.UnPack(buf, 1);
		pi->start = pack.UnPack(buf, 1);  //2
	}
}
