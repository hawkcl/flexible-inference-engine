#include "sim.h"
#include <assert.h>
namespace CloudDesign{
void CHomoGeneousComputingBank::AddSCG(CShiftComputingGroup* pcg)
{
	pcg->setId(cgs.size());
	cgs.push_back(pcg);
}

void CHomoGeneousComputingBank::Init(int cgNum)
{
	assert(WEIGHT_BUFFER_SIZE >= WEIGHT_BUS_SIZE);
	pib = new CCBInstructionBuffer<InstructionHCB>;
	pibw = new CCBInstructionBuffer<InstructionHCBWt>;
	//pfc = new CGetTotalFrames;
	//pfc->SetP(this);
	//pibf = new CCBInstructionBuffer<InstructionHCBNF>;
	for (int i = 0; i < cgNum; i++){
		CShiftComputingGroup *pcg = new CShiftComputingGroup;
		AddSCG(pcg);
		pcg->SetHCG(this);
		pcg->Init(COMPUTING_GROUP_SIZE);
		pcg->Init();
		if (i > 0){
			for (int j = 0; j < COMPUTING_GROUP_SIZE; j++)
				cgs[i - 1]->GetUCU(j)->SetBelow(pcg->GetUCU(j));
		}
	}
}
void CHomoGeneousComputingBank::SetDebugLevel(int l)
{
	debugLevel = l;
	std::vector<CShiftComputingGroup*>::const_iterator p = cgs.begin();
	for (; p != cgs.end(); p++)
		(*p)->SetDebugLevel(l);
}
void CHomoGeneousComputingBank::SetName(std::string s)
{
	name = s;
	std::vector<CShiftComputingGroup*>::const_iterator p = cgs.begin();
	int i = 0;
	for (; p != cgs.end(); p++, i++){
		char tmp[100];
		sprintf(tmp, "%s_CG%d", s.c_str(), i);
		(*p)->SetName(tmp);
	}
}

void CHomoGeneousComputingBank::SetDebug(FILE *f)
{
	fp = f;
	std::vector<CShiftComputingGroup*>::const_iterator p = cgs.begin();
	for (; p != cgs.end(); p++)
		(*p)->SetDebug(f);
}

CHomoGeneousComputingBank::~CHomoGeneousComputingBank()
{
	delete pib;
	delete pibw;
	//delete pibf;
	//return;
	std::vector<CShiftComputingGroup*>::const_iterator p = cgs.begin();
	for (; p != cgs.end(); p++)
		delete *p;
}

void CHomoGeneousComputingBank::NewVerificationFiles()
{
	if (DUMP_VERIFICATION_BM){
		char filename[100];
		sprintf(filename, "%s/bank%d_bmweight_input.txt", OUTPUT_DIR, id.GetNextValue());
		fbmi = fopen(filename, "wt");
		assert(fbmi);
		sprintf(filename, "%s/bank%d_bmweight_output.txt", OUTPUT_DIR, id.GetNextValue());
		fbmo = fopen(filename, "wt");
		assert(fbmo);
	}
	else
		fbmi = fbmo = NULL;

	if (DUMP_VERIFICATION_WEIGHT){
		char filename[100];
		sprintf(filename, "%s/bank%d_weight_input.txt", OUTPUT_DIR, id.GetNextValue());
		fwti = fopen(filename, "wt");
		assert(fwti);
		sprintf(filename, "%s/bank%d_weight_output.txt", OUTPUT_DIR, id.GetNextValue());
		fwto = fopen(filename, "wt");
		assert(fwto);
	}
	else
		fwti = fwto = NULL;

	if (DUMP_VERIFICATION_READEXTRA){
		char filename[100];
		sprintf(filename, "%s/bank%d_readextra_input.txt", OUTPUT_DIR, id.GetNextValue());
		fexi = fopen(filename, "wt");
		assert(fexi);
		sprintf(filename, "%s/bank%d_readextra_output.txt", OUTPUT_DIR, id.GetNextValue());
		fexo = fopen(filename, "wt");
		assert(fexo);
	}
	else
		fexi = fexo = NULL;

	if (DUMP_VERIFICATION_SHIFTINPUT){
		char filename[100];
		sprintf(filename, "%s/bank%d_shiftinput_input.txt", OUTPUT_DIR, id.GetNextValue());
		fsii = fopen(filename, "wt");
		assert(fsii);
		sprintf(filename, "%s/bank%d_shiftinput_output.txt", OUTPUT_DIR, id.GetNextValue());
		fsio = fopen(filename, "wt");
		assert(fsio);
	}
	else
		fsii = fsio = NULL;

	if (DUMP_VERIFICATION_READFEATURES){
		char filename[100];
		sprintf(filename, "%s/bank%d_readfeature_input.txt", OUTPUT_DIR, id.GetNextValue());
		frfi = fopen(filename, "wt");
		assert(frfi);
		sprintf(filename, "%s/bank%d_readfeature_output.txt", OUTPUT_DIR, id.GetNextValue());
		frfo = fopen(filename, "wt");
		assert(frfo);
	}
	else
		frfi = frfo = NULL;

	if (DUMP_VERIFICATION_ASSEMBLEINPUT){
		char filename[100];
		sprintf(filename, "%s/bank%d_assembleinput_input.txt", OUTPUT_DIR, id.GetNextValue());
		faii = fopen(filename, "wt");
		assert(faii);
		sprintf(filename, "%s/bank%d_assembleinput_output.txt", OUTPUT_DIR, id.GetNextValue());
		faio = fopen(filename, "wt");
		assert(faio);
	}
	else
		faii = faio = NULL;

	if (DUMP_VERIFICATION_BUILDINPUTFIFO){
		char filename[100];
		sprintf(filename, "%s/bank%d_buildinputfifo_input.txt", OUTPUT_DIR, id.GetNextValue());
		fbii = fopen(filename, "wt");
		assert(fbii);
		sprintf(filename, "%s/bank%d_buildinputfifo_output.txt", OUTPUT_DIR, id.GetNextValue());
		fbio = fopen(filename, "wt");
		assert(fbio);
	}
	else
		fbii = fbio = NULL;
	if (DUMP_VERIFICATION_SENDBKPINPUT){
		char filename[100];
		sprintf(filename, "%s/bank%d_sendbackupinput_input.txt", OUTPUT_DIR, id.GetNextValue());
		fsbi = fopen(filename, "wt");
		assert(fsbi);
		sprintf(filename, "%s/bank%d_sendbackupinput_output.txt", OUTPUT_DIR, id.GetNextValue());
		fsbo = fopen(filename, "wt");
		assert(fsbo);
	}
	else
		fsbi = fsbo = NULL;

	if (DUMP_VERIFICATION_INPUT){
		char filename[100];
		sprintf(filename, "%s/bank%d_input_input.txt", OUTPUT_DIR, id.GetNextValue());
		fini = fopen(filename, "wt");
		assert(fini);
		sprintf(filename, "%s/bank%d_input_output.txt", OUTPUT_DIR, id.GetNextValue());
		fino = fopen(filename, "wt");
		assert(fino);
	}
	else
		fini = fino = NULL;

	if (DUMP_VERIFICATION_STARTCONVOUT){
		char filename[100];
		sprintf(filename, "%s/bank%d_startconvout_input.txt", OUTPUT_DIR, id.GetNextValue());
		fsoi = fopen(filename, "wt");
		assert(fsoi);
		sprintf(filename, "%s/bank%d_startconvout_output.txt", OUTPUT_DIR, id.GetNextValue());
		fsoo = fopen(filename, "wt");
		assert(fsoo);
	}
	else
		fsoi = fsoo = NULL;

	if (DUMP_VERIFICATION_PROCESSCONVOUT){
		char filename[100];
		sprintf(filename, "%s/bank%d_processconvout_input.txt", OUTPUT_DIR, id.GetNextValue());
		fpoi = fopen(filename, "wt");
		assert(fpoi);
		sprintf(filename, "%s/bank%d_processconvout_output.txt", OUTPUT_DIR, id.GetNextValue());
		fpoo = fopen(filename, "wt");
		assert(fpoo);
	}
	else
		fpoi = fpoo = NULL;

	if (DUMP_VERIFICATION_HCBCTRL){
		char filename[100];
		sprintf(filename, "%s/bank%d_hcbctrl_input.txt", OUTPUT_DIR, id.GetNextValue());
		fhci = fopen(filename, "wt");
		assert(fhci);
		sprintf(filename, "%s/bank%d_hcbctrl_output.txt", OUTPUT_DIR, id.GetNextValue());
		fhco = fopen(filename, "wt");
		assert(fhco);
	}
	else
		fhci = fhco = NULL;

	if (DUMP_VERIFICATION_PROCESSINSTRUCTION){
		char filename[100];
		sprintf(filename, "%s/bank%d_processinstruction_input.txt", OUTPUT_DIR, id.GetNextValue());
		fpii = fopen(filename, "wt");
		assert(fpii);
		sprintf(filename, "%s/bank%d_processinstruction_output.txt", OUTPUT_DIR, id.GetNextValue());
		fpio = fopen(filename, "wt");
		assert(fpio);
	}
	else
		fpii = fpio = NULL;

	if (DUMP_VERIFICATION_HCB){
		char filename[100];
		sprintf(filename, "%s/bank%d_hcb_input.txt", OUTPUT_DIR, id.GetNextValue());
		fhcbi = fopen(filename, "wt");
		assert(fhcbi);
		sprintf(filename, "%s/bank%d_hcb_output.txt", OUTPUT_DIR, id.GetNextValue());
		fhcbo = fopen(filename, "wt");
		assert(fhcbo);
	}
	else
		fhcbi = fhcbo = NULL;
}
void CHomoGeneousComputingBank::Init(){
	weightUsed = 0;
	storages.push_back(&inputs);
	storages.push_back(&input_buffer);
	storages.push_back(&ibSize);
	storages.push_back(&resBuf);
	storages.push_back(&resOutBuf);
	storages.push_back(&weights);
	//storages.push_back(&extWeights);
	storages.push_back(&weightOutBuf);
	//storages.push_back(&extWeightOutBuf);
	storages.push_back(&id);
	storages.push_back(&curSeq);
	storages.push_back(&workingProgress);
	storages.push_back(&reqSeq);
	storages.push_back(&reqSeqF);
	storages.push_back(&reqProgress);
	storages.push_back(&reqSeqW);
	//storages.push_back(&reqProgressW);
	storages.push_back(&isProgressMaster);
	storages.push_back(&finishSeq);
	storages.push_back(&k);
	//storages.push_back(&w);
	//storages.push_back(&h);
	//storages.push_back(&c);
	storages.push_back(&stride);
	storages.push_back(&outW);
	//storages.push_back(&outH);
	//storages.push_back(&outC);
	//storages.push_back(&outX);
	//storages.push_back(&outY);
	storages.push_back(&outW1);
	//storages.push_back(&outH1);
	storages.push_back(&resSize);
	storages.push_back(&resSize0);
	storages.push_back(&resSizeLast);
	storages.push_back(&resLen0);
	storages.push_back(&resLen);
	storages.push_back(&resLenLast);
	storages.push_back(&resReadSize);
	storages.push_back(&outFrameSize);
	storages.push_back(&outFrameGapSize);
	storages.push_back(&outResGapSize);
	storages.push_back(&outBufFrameSize);
	storages.push_back(&outputAddrGap);
	storages.push_back(&outputAddr);
	storages.push_back(&outputFrameStart);
	storages.push_back(&outputCGIdx);
	storages.push_back(&outputCGIdx0);
	storages.push_back(&outputRows);
	storages.push_back(&outputUPSteps);
	storages.push_back(&outputBufH1);
	storages.push_back(&outputBufH1Orig);
	storages.push_back(&outputBufH1Relu);
	storages.push_back(&outputBufW1);
	storages.push_back(&numGroups);
	storages.push_back(&leftPad);
	storages.push_back(&rightPad);
	storages.push_back(&topPad);
	storages.push_back(&downPad);
	//storages.push_back(&paddingStartPos);
	//storages.push_back(&paddingShiftPos);
	//storages.push_back(&paddingShiftRowStart);
	//storages.push_back(&shiftTopPaddings);
	storages.push_back(&token);
	//storages.push_back(&wtoken);
	//storages.push_back(&readRowCount);
	storages.push_back(&maxRowCount);
	storages.push_back(&curRowCount);
	storages.push_back(&lastLen);
	storages.push_back(&readWidth);
	storages.push_back(&writeWidth);
	storages.push_back(&readCLast);
	storages.push_back(&wScale);
	storages.push_back(&fScale);
	storages.push_back(&outLayerCount);
	storages.push_back(&doOutScale);
#if WEIGHT_BUFFER_SIZE_MULT == 2
	storages.push_back(&idxWeightBuffer);
#endif
	storages.push_back(&weightReadPos);
	storages.push_back(&nextWeightRead);
	storages.push_back(&endWeightRead);
	storages.push_back(&kCur);
	storages.push_back(&kRes);
	storages.push_back(&kOut);
	storages.push_back(&Ks);
	storages.push_back(&kt);
	storages.push_back(&mode);
	storages.push_back(&outBufferUseCount);
	storages.push_back(&convBuffers);
	storages.push_back(&outBuffers);
	storages.push_back(&frameCountDown);

#ifdef BATCH1_OPTIMIZE
	storages.push_back(&outBatch3);
	storages.push_back(&resSizeBatch);
	storages.push_back(&resLenBatch);
	storages.push_back(&readRowCount3);
	storages.push_back(&lastRowLen3);
	storages.push_back(&doBatch3K1);
	storages.push_back(&doBatch3K1_cur);
	storages.push_back(&doBatch3K1_out);
	storages.push_back(&batchIdx);
	storages.push_back(&batchSize);
	storages.push_back(&wlenk_bLast);
	storages.push_back(&wlenk_bLast2);

	storages.push_back(&batchAddr);
	storages.push_back(&kbe);
	storages.push_back(&kbe_1);
	storages.push_back(&kbh);
	storages.push_back(&resBatchStart);
	storages.push_back(&bmBatchStart);
	storages.push_back(&wtotal_bn);
	storages.push_back(&wlenk_bn);
	storages.push_back(&wtotalbLast);
	storages.push_back(&batch_only_1group);
	storages.push_back(&wlenkbLast);
	storages.push_back(&bmBatchEnd);
	storages.push_back(&outputRowsBatch);
#endif
	//storages.push_back(&frameSize); //W * H
	storages.push_back(&volumeSize);
	storages.push_back(&curVolumeSize);
	//storages.push_back(&frameReadStart);
	//storages.push_back(&nextReadPos);
	storages.push_back(&nextWritePos);
	storages.push_back(&usedWords);
	storages.push_back(&usedWords_inc);
	storages.push_back(&usedWords_reset);

	storages.push_back(&prefetchFrameSize);

	storages.push_back(&initFSteps);
	storages.push_back(&initWSteps);
	storages.push_back(&initBMWSteps);
	//storages.push_back(&nextBackupAddr);
	//storages.push_back(&prefetchAddr);
	storages.push_back(&outputCountDown);
	storages.push_back(&outputReadPos);
	storages.push_back(&outputWritePos);
	storages.push_back(&iterCountDown);
	//storages.push_back(&nextFrameAddr);
	storages.push_back(&layerCount);
	//storages.push_back(&usedCG);
	storages.push_back(&usedGroups);
	storages.push_back(&outputIdxMax);
	storages.push_back(&isLastOutput);
	storages.push_back(&loadNextInst);
	storages.push_back(&doRes_out);
	storages.push_back(&outputBufW1_out);
	storages.push_back(&outW_out2);
	storages.push_back(&doUpSample_out);
	//storages.push_back(&outW1_out);
	storages.push_back(&outputAddr_out);
	storages.push_back(&outputBufH1_out);
	storages.push_back(&outputFrameStart_out);
	storages.push_back(&outFrameSize_out);
	storages.push_back(&outW_out);
	storages.push_back(&outputAddrGap_out);
	storages.push_back(&k_out);
	storages.push_back(&curSeq_out);
	storages.push_back(&newWriteInst);
	storages.push_back(&newWriteInst_out);

	storages.push_back(&nextResAddr);
	storages.push_back(&frameResAddr);
	storages.push_back(&resRowCount);
	storages.push_back(&resFrameCount);
	storages.push_back(&totalRes);
	storages.push_back(&askedRes);
	storages.push_back(&receivedRes);
	storages.push_back(&idxRes);
	storages.push_back(&idxResMax);
	storages.push_back(&resFrameMax);
	
	/*storages.push_back(&bmBlockSize);
	storages.push_back(&bmLastAddr);
	storages.push_back(&bmNextAddr);
	storages.push_back(&bmEndAddr);
	storages.push_back(&bmSkipSize);*/
	//storages.push_back(&isbmBatch);
	storages.push_back(&wLRelu);
	storages.push_back(&bmPhase);
	/*storages.push_back(&totalBM);
	storages.push_back(&askedBM);
	storages.push_back(&receivedBM);
	storages.push_back(&requestingBM);*/
	storages.push_back(&maxpool_stride);
	storages.push_back(&maxpool_stride_out);
	storages.push_back(&liveRes);
	//storages.push_back(&liveBM);
	storages.push_back(&requestingRes);
	storages.push_back(&res_received_live);

	storages.push_back(&isReadResA);
	storages.push_back(&isResMaster);
	//storages.push_back(&isWeightMaster);
	storages.push_back(&isInitLayer);
	storages.push_back(&isRunning);
	storages.push_back(&isLastLayer);
	storages.push_back(&isPrefetchNext);
	//storages.push_back(&outputAfterLast);
	storages.push_back(&isReadingFeatures);
	storages.push_back(&isReadingWeights);
	storages.push_back(&isPrefetchWeight);
	storages.push_back(&isPrefetchBMWeight);
	storages.push_back(&doRes);
	storages.push_back(&doRelu);
	storages.push_back(&doLRelu);
	storages.push_back(&isLReluInit);
	storages.push_back(&readPos);
	storages.push_back(&resPos);
	storages.push_back(&isLoadingNextFeatures);
	storages.push_back(&isLoadingFroze);
	storages.push_back(&hasNextFeatureParams);
	storages.push_back(&isLoadingNextWeights);
	//storages.push_back(&hasNextWeightParams);
	storages.push_back(&doBM);
	storages.push_back(&doUpSample);
	storages.push_back(&isLReluWeight);
	storages.push_back(&isPrefetchNextVolume);
	storages.push_back(&isNextVolumeReady);
	storages.push_back(&isOnOutput);
	storages.push_back(&waiting_out);
	//storages.push_back(&waiting_res);
	//storages.push_back(&waiting_res_for_out);
	//storages.push_back(&waitPrefetching);
	//storages.push_back(&assemble_buffer0_m);
	//storages.push_back(&assemble_buffer1_m);
	//storages.push_back(&assemble_buffer0);
	//storages.push_back(&assemble_buffer1);
	storages.push_back(&assemble_buffer);
	storages.push_back(&inputs_buffer);
	storages.push_back(&assemble_tmp);
	storages.push_back(&atmpSize);
	storages.push_back(&addrNextAssemble);
	storages.push_back(&addrCurAssemble);
	//storages.push_back(&ab0Filled);
	//storages.push_back(&ab1Filled);
	//storages.push_back(&ab0Write);
	//storages.push_back(&ab0Read);
	storages.push_back(&addrNextFrame);
	storages.push_back(&doAssemble);
	storages.push_back(&input_requested);

	storages.push_back(&input_fifo);
	storages.push_back(&iLayers);
	storages.push_back(&rowNum);
	storages.push_back(&rowAddr);
	storages.push_back(&isWeightValid);
	storages.push_back(&isBMWeightValid);
	storages.push_back(&weightId);
	storages.push_back(&wlen);
	storages.push_back(&wlen_regular);
	storages.push_back(&wlenk_regular);
	storages.push_back(&wlenk_last);
	storages.push_back(&wlenk_nLast);
	storages.push_back(&wlenk_nLast2);
	storages.push_back(&wlenk);

	storages.push_back(&BMlen);
	storages.push_back(&wtotal);
	storages.push_back(&wtotal_n);
	storages.push_back(&wlenk_n);
	storages.push_back(&wtotalLast);
	storages.push_back(&wlenkLast);
	storages.push_back(&kCurLast);
	storages.push_back(&kCurLast_1);
	storages.push_back(&usedGroupsLast);
	storages.push_back(&usedCGLast);
	storages.push_back(&usedCG0);
	
	storages.push_back(&state);
#ifdef S2_OPTIMIZE
	storages.push_back(&isStride2);
	storages.push_back(&s2_buffer);
	storages.push_back(&rowCounts);
	storages.push_back(&nextRowStart);
	storages.push_back(&kIter);
	storages.push_back(&s2b_start);
	storages.push_back(&s2b_end);
	storages.push_back(&s2b_lastAddr);
	storages.push_back(&s2b_cur);

#endif
	//storages.push_back(&isPreferRes);
	storages.push_back(pib);
	storages.push_back(pibw);

	storages.push_back(&weights_len);
	storages.push_back(&bmweights_len);

	//storages.push_back(pfc);
	//storages.push_back(pibf);
	for (int i = 0; i < WEIGHT_BUS_SIZE; i++){
		storages.push_back(weightBus + i);
		//storages.push_back(bmWeightBus + i);
	}
	for (int i = 0; i < MAX_K; i++)
		for (int j = 0; j < MAX_SHIFT_SIZE; j++){
			storages.push_back(shiftBuf[i] + j);
			storages.push_back(shiftBufBackup[i] + j);
			storages.push_back(shiftBufShift[i] + j);
		}

	NewVerificationFiles();

	reset();
	weightOutBuf.SetFifo(&weights);
	//extWeightOutBuf.SetFifo(&extWeights);
	inputs.Init();
	input_buffer.Init();
	assemble_buffer.Init();
	inputs_buffer.Init();
	//assemble_buffer0.Init();
	//assemble_buffer1.Init();
	//assemble_buffer0_m.Init();
	//assemble_buffer1_m.Init();
	//pfc->Init();
	assemble_tmp.Init();
	input_fifo.Init();
#ifdef S2_OPTIMIZE
	s2_buffer.Init();
#endif
	resBuf.Init();
	resOutBuf.Init();
	//extWeights.Init();
#ifdef BATCH1_OPTIMIZE
	outBatch3.Init();
#endif
	weights.Init();
	usedWords_inc.SetSkipCheck();
	usedWords_reset.SetSkipCheck();
	isBMWeightValid.SetSkipCheck();
	isWeightValid.SetSkipCheck();
	wlen_regular.SetSkipCheck();
	debugLevel = DEFAULT_DEBUG_LEVEL;
	pib_Size = 0;
	
}
void CHomoGeneousComputingBank::reset() {
	
	std::vector<CSimNode *>::const_iterator p = storages.begin();
	for (int i = 0; p != storages.end(); p++, i++)
		(*p)->reset();
	popBM = false;
	popRes = false;
	
	isBackupValid = false;
	//isWeightValid = false;
	//isBMWeightValid = false;
	isOutputReady = false;
	nextWeight = false;
	cgSwitchOutput = false;
	new_conv_inst = false;
	startprefetching = false;
	reset_iLayers = false;
	new_weight_params = false;
	on_output = false;
	rf_new_params = false;
	input_wen = false;
	is_assemble_buff_full = false; 
	is_assemble_buff_empty = false;
	is_input_fifo_full = false; 
	is_input_fifo_empty = false; 
	inputfifo_ren = false;
	sendBackUpInput_valid = false;
	reset_isOnOutput = false;
	start_conv_out = false;
	set_out_params = false;
	set_LastOutput = false;
	resfifo_ren = false;
	pwrite_enable = false;
	pwrite_setNextInst = false;
	reset_state = false;
	new_params_prefetch = false;
	pib_ren = false;
	token_set = false;
	receive_inst = false;
	dump_start = false;
	max_token = 0;
	pread_RequestValid = false;
	
	for (int i = 0; i < MAX_K; i++)
		for (int j = 0; j < MAX_SHIFT_SIZE; j++)
			shiftBufBackup[i][j] = 0;

}

void CHomoGeneousComputingBank::latch(int num){
	isBackupValid = false;
	//isWeightValid = false;
	//isBMWeightValid = false;
	isOutputReady = false;
	nextWeight = false;
	cgSwitchOutput = false;
	new_conv_inst = false;
	startprefetching = false;
	reset_iLayers = false;
	new_weight_params = false;
	rf_new_params = false;
	on_output = false;
	input_wen = false;
	is_assemble_buff_full = false;
	is_assemble_buff_empty = false;
	is_input_fifo_full = false;
	is_input_fifo_empty = false;
	inputfifo_ren = false;
	sendBackUpInput_valid = false;
	reset_isOnOutput = false;
	start_conv_out = false;
	set_out_params = false;
	set_LastOutput = false;
	resfifo_ren = false;
	pwrite_enable = false;
	pwrite_setNextInst = false;
	reset_state = false;
	new_params_prefetch = false;
	pib_ren = false;
	token_set = false;
	receive_inst = false;
	max_token = 0;
	pread_RequestValid = false;
	input_src = INPUT_NON;
	if (!isRunning.GetValue() && num > 100){
		pib->latch(num);
		pibw->latch(num);
		isRunning.latch(num);
		return;
	}
	if (isResMaster.GetValue()){
		if (popRes)
			assert(liveRes.GetValue() > 0);
		//if (popBM)
		//	assert(liveBM.GetValue() > 0);
	}
	popRes = false;
	popBM = false;
	bool wv = isWeightValid.GetValue();
	bool bwv = isBMWeightValid.GetValue();
	if (is_cycle_froze){
		isWeightValid = wv;
		isBMWeightValid = bwv;
	}
#ifdef BATCH1_OPTIMIZE
	memset(backupBus, 0, sizeof(DTYPE) * COMPUTING_GROUP_SIZE * 3);
#elif defined(S2_OPTIMIZE)
	memset(backupBus, 0, sizeof(DTYPE) * COMPUTING_GROUP_SIZE * 2);
#else
	memset(backupBus, 0, sizeof(DTYPE) * COMPUTING_GROUP_SIZE);
#endif
	memset(shiftInputs, 0, sizeof(DTYPE) * MAX_K);
	std::vector<CSimNode *>::const_iterator p = storages.begin();
	for (int i = 0; p != storages.end(); p++, i++)
		(*p)->latch(num);

	for (int i = cgs.size() - 1; i >= 0; i--)
		cgs[i]->latch(num);
	//if (!is_cycle_froze){
		isWeightValid = false;
		isBMWeightValid = false;
	//}
	pib_Size = pib->Size();
}



std::string CHomoGeneousComputingBank::GetStateName()
{
	switch (state.GetValue()){
	case IDLE: return "IDLE";
	case CONV_INIT: return "CONV_INIT";
	case CONV_START: return "CONV_START";
	case  CONV_MULT: return "CONV_MULT";
	case  CONV_BM: return "CONV_BM";
	case  CONV_RELU: return "CONV_RELU";
	case  CONV_OUT: return "CONV_OUT";
	case  CONV_DONE: return "CONV_DONE";
	}
	return "NON";
}

std::string CHomoGeneousComputingBank::GetInputSourceName()
{
	switch (input_src){
	case INPUT_X: return "INPUT_X";
	case INPUT_BACKUP: return "INPUT_BACKUP";
	case  INPUT_S: return "INPUT_S";
	case  INPUT_E: return "INPUT_E";
	}
	return "INPUT_NON";
}

std::string CHomoGeneousComputingBank::GetModeName()
{
	if (mode == MODE_FOUR)
		return "mFOUR";
	if (mode == MODE_TWO)
		return "mTWO";
	return "mONE";

}

void CHomoGeneousComputingBank::DumpState()
{
	if (!fp)
		return;
	fprintf(fp, "\nDump %s, id %d, %s %s, groups %d, token %d, PM?(%s), running?(%s), nextInst?(%s)\n"
		, name.c_str(), id.GetValue(), GetModeName().c_str(), GetStateName().c_str()
		, numGroups.GetValue(), token.GetValue(), isProgressMaster.GetValue() ? "Y" : "N"
		, isRunning.GetValue() ? "Y" : "N", loadNextInst.GetValue() ? "Y" : "N");

	fprintf(fp, "\treqseqw %d, reqseqF %d, reqseq %d reqprog %d, fseq %d, seq %d prog %d\n"
		, reqSeqW.GetValue(), reqSeqF.GetValue()
		, reqSeq.GetValue(), reqProgress.GetValue(), finishSeq.GetValue()
		, curSeq.GetValue(), workingProgress.GetValue());
	fprintf(fp, "\twscale %d, fscale %d\n"
		, wScale.GetValue(), fScale.GetValue());

	// input
	fprintf(fp, "\n\tInput:\n");
	fprintf(fp, "\tfRead?(%s) width %d pos %d, nextwrite %d, volume %d\n"
		, isReadingFeatures.GetValue()?"Y":"N", writeWidth.GetValue(), readPos.GetValue()
		, nextWritePos.GetValue(), volumeSize.GetValue());
	fprintf(fp, "\tLoadNext?(%s), nextParam?(%s), froze?(%s), usedWords %d\n"
		, isLoadingNextFeatures.GetValue() ? "Y" : "N", hasNextFeatureParams.GetValue() ? "Y" : "N"
		, isLoadingFroze.GetValue() ? "Y" : "N", usedWords.GetValue());

	// weight
	fprintf(fp, "\n\tWeight:\n");
	fprintf(fp, "\twRead?(%s), pos %d, next %d, end %d, size %d, next?(%s)\n"
		, isReadingWeights.GetValue() ? "Y" : "N" //isWeightMaster.GetValue() ? "Y" : "N"
		, weightReadPos.GetValue(), nextWeightRead.GetValue()
		, endWeightRead.GetValue(), weights.size(), isLoadingNextWeights.GetValue() ? "Y" : "N");
		//, hasNextWeightParams.GetValue()?"Y":"N");

	//conv
	fprintf(fp, "\n\tConv:\n");
	fprintf(fp, "\tK %d, S %d , uGrp %d, KCur %d Ks %d Kt %d\n"
		, k.GetValue(), stride.GetValue()
		, usedGroups.GetValue(), kCur.GetValue(), Ks.GetValue(), kt.GetValue());
	fprintf(fp, "\tConvBuff %d, lPad %d, rpad %d, tpad %d, dpad %d\n"
		, convBuffers.GetValue(), leftPad.GetValue(), rightPad.GetValue(), topPad.GetValue(), downPad.GetValue());
		//, paddingStartPos.GetValue(), paddingShiftPos.GetValue()
		//, paddingShiftRowStart.GetValue(), shiftTopPaddings.GetValue());
#ifdef BATCH1_OPTIMIZE
	if (doBatch3K1.GetValue()){
		fprintf(fp, "\tBatchSize %d\n", batchSize.GetValue());
	}
#endif
	fprintf(fp, "\tOutput layer count %d, outscale?(%s)\n"
		, outLayerCount.GetValue(), doOutScale.GetValue()?"Y":"N");
	fprintf(fp, "\tInputSrc %s, readCLast %d, readWidth %d, initF %d, initW %d, prefcFrameSize %d\n"
		,GetInputSourceName().c_str(), readCLast.GetValue(), readWidth.GetValue(), initFSteps.GetValue(), initWSteps.GetValue()
		, prefetchFrameSize.GetValue());
	
	fprintf(fp, "\tlayerC %d, outRead %d, outWrite %d, iter %d, outCountDown %d\n"
		, layerCount.GetValue(), outputReadPos.GetValue(), outputWritePos.GetValue(), iterCountDown.GetValue()
		, outputCountDown.GetValue());
	fprintf(fp, "\tInitL?(%s), lastL?(%s), prefcNxt?(%s), prefcW?(%s), prefcBMW?(%s), prefcNF?(%s), nVolRdy?(%s)\n"
		, isInitLayer.GetValue() ? "Y" : "N", isLastLayer.GetValue() ? "Y" : "N", isPrefetchNext.GetValue() ? "Y" : "N"
		, isPrefetchWeight.GetValue() ? "Y" : "N", isPrefetchBMWeight.GetValue() ? "Y" : "N"
		, isPrefetchNextVolume.GetValue() ? "Y" : "N", isNextVolumeReady.GetValue() ? "Y" : "N");
	
	//bm
	fprintf(fp, "\n\tBm:\n");
	fprintf(fp, "\tBM?(%s), phase %d\n"
		, doBM.GetValue() ? "Y" : "N",  bmPhase.GetValue());
		//, totalBM.GetValue(), receivedBM.GetValue(), askedBM.GetValue());
		//, isbmBatch.GetValue()?"Y":"N"
		//, bmBatchStart.GetValue(), bmBatchEnd.GetValue());
	/*fprintf(fp, "\tBlockSz %d, SkipSz %d, nxtA %d, EndA %d, LastA %d, ReluInit?(%s)"
		, bmBlockSize.GetValue(), bmSkipSize.GetValue(), bmNextAddr.GetValue()
		, bmEndAddr.GetValue(), bmLastAddr.GetValue(), isLReluInit.GetValue()?"Y":"N");
*/
	//relu
	fprintf(fp, "\t%s %s "DFMT" ReluW?(%s)\n"
		, doRelu.GetValue()?"Relu":"", doLRelu.GetValue()?"LRelu":"", wLRelu.GetValue(), isLReluWeight.GetValue()?"Y":"N");
	
	//res
	fprintf(fp, "\n\tRes:\n");
	fprintf(fp, "\tRes?(%s)  RM?(%s) readA?(%s), size %d, K %d, total %d, asked %d, received %d\n"
		, doRes.GetValue()?"Y":"N"
		, isResMaster.GetValue()?"Y":"N", isReadResA.GetValue()?"Y":"N", resBuf.size()
		, kRes.GetValue(), totalRes.GetValue(), askedRes.GetValue(), receivedRes.GetValue());
	fprintf(fp, "\tPos %d, nxtResA %d, fResA %d, row %d, resSize %d, readSz %d, frameC %d frameMax %d\n"
		, resPos.GetValue(), nextResAddr.GetValue(), frameResAddr.GetValue(), resRowCount.GetValue()
		, resSize.GetValue(), resReadSize.GetValue(), resFrameCount.GetValue(), resFrameMax.GetValue());

	//out
	fprintf(fp, "\n\tOutput:\n");
	fprintf(fp, "\tOnOutput?(%s) waiting?(%s), outBufUseC %d, OutBuffers %d, idxMax %d, last?(%s), %s %s\n"
		,isOnOutput.GetValue()?"Y":"N", waiting_out.GetValue()?"Y":"N", outBufferUseCount.GetValue()
		, outBuffers.GetValue(), outputIdxMax.GetValue(), isLastOutput.GetValue()?"Y":"N"
		, doRes_out.GetValue()?"Res":"", doUpSample_out.GetValue()?"UPS":"");
	fprintf(fp, "\tAddr %d, bufW1 %d, bufH1 %d, AGap %d, Kout %d, seq %d, W %d, frameStart %d, fSz %d\n"
		, outputAddr_out.GetValue() , outputBufW1_out.GetValue() , outputBufH1_out.GetValue()
		, outputAddrGap_out.GetValue() , k_out.GetValue() , curSeq_out.GetValue()
		, outW_out.GetValue() , outputFrameStart_out.GetValue(), outFrameSize_out.GetValue());
	
	fprintf(fp, "\tCGIdx %d, Row %d, Ups %d, W %d\n"
		, outputCGIdx.GetValue(), outputRows.GetValue(), outputUPSteps.GetValue(), outW.GetValue());
		//, outH.GetValue(), outC.GetValue(), outX.GetValue(), outY.GetValue());

	fprintf(fp, "\tNew Addr %d, bufW1 %d, bufH1 %d, W1 %d, AGap %d, Kout %d, frameStart %d, fSz %d Ups?(%s)\n"
		, outputAddr.GetValue(), outputBufW1.GetValue(), outputBufH1.GetValue()
		, outW1.GetValue(), outputAddrGap.GetValue(), kOut.GetValue()
		, outputFrameStart.GetValue(), outFrameSize.GetValue(), doUpSample.GetValue()?"Y":"N");
}

void CHomoGeneousComputingBank::processUsedWords(int num)
{
	if (usedWords_reset.GetValue())
		usedWords = 0;
	else
		usedWords = usedWords.GetValue() + usedWords_inc.GetValue();
	usedWords_inc = 0;
	usedWords_reset = false;
}

void CHomoGeneousComputingBank::progress(int num)
{
	StartDumpVerifyHCB(num);
	if (!isRunning.GetValue())
		return;
	processUsedWords(num);
	if (fsbo && fsbi){
		
		fprintf(fsbi, "%d %d %d", num + 1, readWidth.GetValue(), leftPad.GetValue());
		fprintf(fsbo, "%d", num);
	}
	processNextFeatureLoading(num);

	StartDumpVerifyProcessInstruction(num);
	processInstruction(num);
	FinishDumpVerifyProcessInstruction();

	StartDumpVerifyHCBCtrl(num);
	processConvInit(num);
	
	if (fsoo && fsoi){
		fprintf(fsoi, "%d %d %d", num + 1, new_conv_inst, kOut.GetNextValue());
		fprintf(fsoo, "%d", num);
	}
	processConvCompute(num);
	
	processConvStart(num);
	if (fsbo && fsbi){
		if (!sendBackUpInput_valid){
			fprintf(fsbi, " 0 0");
			fprintf(fsbo, " 0 0");
		}
		fprintf(fsbi, "\n");
		fprintf(fsbo, "\n");
	}
	
	StartDumpVerifyProcessConvOut(num);
	processConvOut(num);
	FinishDumpVerifyProcessConvOut();
	
	FinishDumpVerifyStartConvOut();
	processBMWeights(num);
	if (fwti && fwto)
		writeVerificationWeight(num);
	//ReceiveExtraWeights();
	ReadResData(num);
	ReceiveResData(num);
	ReadExtraWeights(num);
	processNextWeightLoading(num);
	ReadWeights(num);
	

	StartDumpVerifyInput(num);
	ReadFeatures(num);

	SetupShiftInputs(num);
	
	
	buildInputFifo(num);
	AssembleInput(num);
	AssembleInputBuffer(num);
	FinishDumpVerifyInput(num);
	FinishDumpVerifyHCBCtrl();
	//pfc->progress(num);
	for (int i = cgs.size() - 1; i >= 0; i--)
		cgs[i]->progress(num);
	if (isResMaster.GetValue()){
		liveRes = liveRes.GetValue() + reqRes - (popRes ? 1 : 0);
		//liveBM = liveBM.GetValue() + reqBM - (popBM ? 1 : 0);
		if (fp && debugLevel <= 1)
			fprintf(fp, "liveRes %d\n", liveRes.GetNextValue());
	}
	if (isResMaster.GetValue()){
		res_received_live = res_received_live.GetValue() + res_asked - res_received;
		if (fp && debugLevel <= 1)
		fprintf(fp, "%s next live_ResReceived %d\n", name.c_str(), res_received_live.GetNextValue());
	}
	FinishDumpVerifyHCB();
}

void CHomoGeneousComputingBank::StartDumpVerifyHCB(int num)
{
	if (!dump_start)
		return;
	if (!fhcbi || !fhcbo)
		return;

	if (!receive_inst)
		fprintf(fhcbi, "%d 0\n", num + 1);

	fprintf(fhcbi, " %d %d %d %d %d %d"
		, (isRunning.GetNextValue() == isRunning.GetValue()) ? 0 : isRunning.GetNextValue()
		, (isRunning.GetNextValue() == isRunning.GetValue()) ? 0 : !isRunning.GetNextValue() //start, stop
		, pwrite->IsFetchNextInst() , pread->busValid
		, pread->isFeature , pread->GetSeqNum());

	fprintf(fhcbi, " %d %d %d %d %d\n", pcweight->GetSeqNum(), pcweight->busValid
		, pread->RequestFull(), ptoken->GetToken(), pwrite->IsWritable(id.GetValue()));

	if (pcweight->busValid){
		for (int i = 0; i < WEIGHT_DATA_WIDTH * 4; i++)
			fprintf(fhcbi, " %d", pcweight->dataBus[i]);
		fprintf(fhcbi, "\n");
	}
	if (pread->busValid){
		if (pread->isFeature){
			for (int i = 0; i < MAX_LOAD_WIDTH; i++)
				fprintf(fhcbi, " %d", pread->dataBus[i]);
			fprintf(fhcbi, "\n");
		}
		else{
			ReturnData * data = (ReturnData *)pread->dataBus;
			fprintf(fhcbi, " %d %d %d %d", data->seq, data->len, data->token, data->type);
			for (unsigned i = 0; i < data->len; i++)
				fprintf(fhcbi, " %d", data->data[i]);
			fprintf(fhcbi, "\n");
		}
	}

	fprintf(fhcbo, "%d %d %d %d", num, isRunning.GetValue()
		, IsWeightFull(), pib->IBFull()); //weights_almost_full instfifo_full
	if (!isRunning.GetValue())
		fprintf(fhcbo, "\n");
}
void CHomoGeneousComputingBank::FinishDumpVerifyHCB()
{
	if (!fhcbi || !fhcbo)
		return;

	if (!pwrite_enable)
		fprintf(fhcbo, " 0\n");
	fprintf(fhcbo, " %d %d %d %d %d\n %d %d", token_set, max_token
		, pwrite_setNextInst, IsFetchNextInst()
		, workingProgress.GetValue(), pread_RequestValid, this->IsStopable());

	if (pread_RequestValid){
		fprintf(fhcbo, " %d %d %d %d %d %d %d", pread_request.addr, pread_request.seq
			, pread_request.len, pread_request.token, pread_request.type
			, pread_request.isRamA, pread_request.isRamB);
	}
	fprintf(fhcbo, "\n");

	fprintf(fhcbo, " %d %d %d %d %d %d %d %d\n", isRunning.GetValue()
		, isReadingFeatures.GetValue(), GetReqFeature(), GetFinishedSeq()
		, GetWorkingSeq(), isReadingWeights.GetValue()
		, GetReqWeight(), isLoadingFroze.GetValue());

	if (DUMP_VERIFICATION_HCB_DETAIL){
		fprintf(fhcbo, " %d %d %d %d %d %d %d\n", new_conv_inst
			, state.GetValue(), input_src, isWeightValid.GetValue()
			, isBMWeightValid.GetValue(), isInitLayer.GetValue(), isLastLayer.GetValue());

		fprintf(fhcbo, " %d %d %d %d %d\n", isPrefetchWeight.GetValue()
			, isPrefetchBMWeight.GetValue(), isLoadingNextFeatures.GetValue()
			, nextWeight, cgSwitchOutput);

		fprintf(fhcbo, " %d %d %d %d %d %d %d %d\n", isPrefetchNextVolume.GetValue(), isOnOutput.GetValue()
			, waiting_out.GetValue(), isNextVolumeReady.GetValue(), startprefetching
			, rf_new_params, start_conv_out, sendBackUpInput_valid);

		fprintf(fhcbo, " %d %d %d %d %d %d %d\n", initWSteps.GetValue(), initFSteps.GetValue()
			, weightId.GetValue(), k.GetNextValue(), iterCountDown.GetValue()
			, isOutputReady, backupId);

		fprintf(fhcbo, " %d %d %d %d\n", isBackupValid, outputReadPos.GetValue()
			, outputWritePos.GetValue(), outputRows.GetValue());
		if (isWeightValid.GetValue()){
			fprintf(fhcbo, " %d", weights_len.GetValue());
			for (int i = 0; i < weights_len.GetValue(); i++)
				fprintf(fhcbo, " %d", weightBus[i].GetValue());
			fprintf(fhcbo, "\n");
		}

		if (isBMWeightValid.GetValue()){
			fprintf(fhcbo, " %d", bmweights_len.GetValue());
			for (int i = 0; i < bmweights_len.GetValue(); i++)
				fprintf(fhcbo, " %d", weightBus[i].GetValue());
			fprintf(fhcbo, "\n");
		}

		if (isBackupValid){
			for (int i = 0; i < COMPUTING_GROUP_SIZE; i++)
				fprintf(fhcbo, " %d", backupBus[i]);
			fprintf(fhcbo, "\n");
		}

		bool cmp = (state.GetValue() != IDLE) && (state.GetValue() != CONV_INIT) && (state.GetValue() != CONV_START);
		if (cmp){
			unsigned len = k.GetValue(); // leftPad.GetValue() + rightPad.GetValue();
			fprintf(fhcbo, " %d", len);
			for (unsigned i = 0; i < len; i++)
				fprintf(fhcbo, " %d", shiftInputs[i]);
		}
		else
			fprintf(fhcbo, " 0");
		fprintf(fhcbo, "\n");
		if (state == CONV_MULT){
			fprintf(fhcbo, " 1 %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n"
				, cgs[0]->GetUCU(0)->GetAQ(), cgs[0]->GetUCU(0)->GetSQ(), cgs[0]->GetUCU(0)->GetMQ(), cgs[0]->GetUCU(0)->GetPSUMQ()
				, cgs[1]->GetUCU(0)->GetAQ(), cgs[1]->GetUCU(0)->GetSQ(), cgs[1]->GetUCU(0)->GetMQ(), cgs[1]->GetUCU(0)->GetPSUMQ()
				, cgs[2]->GetUCU(0)->GetAQ(), cgs[2]->GetUCU(0)->GetSQ(), cgs[2]->GetUCU(0)->GetMQ(), cgs[2]->GetUCU(0)->GetPSUMQ()
				, cgs[0]->GetUCU(0)->GetOutPut(), cgs[1]->GetUCU(0)->GetOutPut(), cgs[2]->GetUCU(0)->GetOutPut());
		}
		else
			fprintf(fhcbo, " 0\n");
	}	
}


void CHomoGeneousComputingBank::StartDumpVerifyHCBCtrl(int num)
{
	if (!fhci || !fhco)
		return;
	fprintf(fhci, "%d", num + 1);
	fprintf(fhco, "%d", num);

	fprintf(fhci, " %d %d %d %d %d %d %d %d\n", isRunning.GetNextValue(), !isRunning.GetNextValue()
		, waiting_out.GetValue(), k.GetValue(), stride.GetValue()
		, doBM.GetValue(), doRelu.GetValue(), doLRelu.GetValue());

	fprintf(fhci, " %d %d %d %d\n", doRes.GetValue(), isOnOutput.GetValue(), receivedRes.GetValue(), totalRes.GetValue()); //w_enough_data
	
	fprintf(fhci, " %d %d %d %d %d %d %d %d\n", input_fifo.size() == 0, readCLast.GetValue()
		, new_conv_inst, Ks.GetValue(), kt.GetValue()
		, wtotal.GetNextValue(), numGroups.GetValue(), writeWidth.GetValue());
	
	fprintf(fhci, " %d %d %d %d %d %d %d %d\n", readWidth.GetNextValue(), outputBufH1.GetNextValue()
		, rowNum.GetNextValue(), prefetchFrameSize.GetValue(), kCur.GetNextValue()
		, usedGroups.GetNextValue(), k.GetNextValue(), kOut.GetValue());

	fprintf(fhci, " %d %d %d %d %d %d %d %d", kCurLast.GetValue(), usedGroupsLast.GetValue()
		, wtotal_n.GetValue(), wlenk_nLast.GetValue(), wtotalLast.GetValue()
		, wlenk_nLast2.GetValue(), wlenk_regular.GetValue(), wlen_regular.GetValue());

	fprintf(fhci, " %d %d %d %d %d\n", wlenk.GetNextValue(), wlenk_last.GetNextValue()
		, kCurLast_1.GetValue(), maxRowCount.GetNextValue(), lastLen.GetNextValue());
}
void CHomoGeneousComputingBank::FinishDumpVerifyHCBCtrl()
{
	if (!fhci || !fhco)
		return;
	fprintf(fhci, " %d %d %d %d %d %d %d %d %d %d\n"
		, reset_isOnOutput, reset_state
		, isBMWeightValid.GetNextValue() //BM_enough_data
		, isWeightValid.GetNextValue()
		, resetLoadingNextFeatures, resetReadingFeatures, new_params_prefetch
		, setLoadingFroze, resetLoadingFroze, resetAssemble);

	fprintf(fhco, " %d %d %d %d %d %d %d %d %d\n"
		, is_cycle_froze, startprefetching, start_conv_out
		, BMlen.GetValue(), wlenk.GetValue(), isBMWeightValid.GetNextValue()//	logic enSendBMWeights;
		, isWeightValid.GetNextValue(), isBMWeightValid.GetValue(), isWeightValid.GetValue());

	fprintf(fhco, " %d %d %d %d %d %d %d %d %d\n", weightId.GetValue(), sendBackUpInput_valid
		, isBackupValid, backupId, isOutputReady, nextWeight
		, readWidth.GetValue(), rowNum.GetValue(), reset_iLayers);

	fprintf(fhco, " %d %d %d %d %d %d %d %d\n", loadNextInst.GetValue(), isPrefetchNextVolume.GetNextValue()
		, isPrefetchNextVolume.GetValue(), workingProgress.GetValue(), doOutScale.GetValue()
		, doAssemble.GetValue(), usedWords.GetValue(), isInitLayer.GetValue());

	fprintf(fhco, " %d %d %d %d %d %d %d %d\n", isReadingFeatures.GetValue(), isLoadingFroze.GetValue()
		, hasNextFeatureParams.GetValue(), isLoadingNextFeatures.GetValue(), isLReluWeight.GetValue()
		, iterCountDown.GetValue(), outputReadPos.GetValue(), outputWritePos.GetValue());

	fprintf(fhco, " %d %d %d %d %d %d %d %d\n", state.GetValue(), state.GetNextValue()
		, outputBufH1.GetValue(), isNextVolumeReady.GetValue(), bmPhase.GetValue()
		, isRunning.GetValue(), maxRowCount.GetValue(), lastLen.GetValue());

	fprintf(fhco, " %d %d %d %d %d %d %d %d %d\n", input_src, outLayerCount.GetValue(), initFSteps.GetValue()
		, initWSteps.GetValue(), initBMWSteps.GetValue(), layerCount.GetValue()
		, usedGroups.GetValue(), wtotal.GetValue(), wlen.GetValue());
}


void CHomoGeneousComputingBank::FinishDumpVerifyStartConvOut()
{
	if (!fsoo || !fsoi)
		return;

	if (!start_conv_out)
		fprintf(fsoi, " 0");
	fprintf(fsoi, " %d\n", reset_isOnOutput);

	fprintf(fsoo, " %d %d %d %d %d %d %d", isOnOutput.GetValue(), waiting_out.GetValue()
		, cgSwitchOutput, doRes_out.GetValue(), doUpSample_out.GetValue()
		, outputBufW1_out.GetValue(), outFrameSize_out.GetValue());

	fprintf(fsoo, " %d %d %d %d %d %d %d", outW_out.GetValue(), outW_out2.GetValue()
		, maxpool_stride_out.GetValue(), outputAddrGap_out.GetValue()
		, k_out.GetValue(), curSeq_out.GetValue(), newWriteInst_out.GetValue());

	fprintf(fsoo, " %d %d %d %d %d %d %d\n", outputBufH1_out.GetValue(), set_out_params
		, outputAddr_out.GetNextValue(), outputFrameStart_out.GetNextValue()
		, set_LastOutput, outputIdxMax.GetValue(), kOut.GetValue());
}

void CHomoGeneousComputingBank::StartDumpVerifyInput(int num)
{
	if (!fini || !fino)
		return;
	fprintf(fini, "%d", num + 1);
	fprintf(fino, "%d", num);

	fprintf(fini, " %d %d %d %d %d %d", pread->busValid, pread->isFeature, isReadingFeatures.GetValue()
		, isLoadingFroze.GetValue(), isLoadingNextFeatures.GetValue(), pread->GetSeqNum());
	fprintf(fini, " %d %d %d %d %d %d\n", reqSeqF.GetValue(), writeWidth.GetValue(), rf_new_params
		, readPos.GetValue(), volumeSize.GetValue(), usedWords.GetValue());
//AssembleInput
	fprintf(fini, " %d %d", doAssemble.GetValue(), readWidth.GetValue());
	fprintf(fini, " %d %d %d %d %d %d %d\n", prefetchFrameSize.GetValue(), new_conv_inst, startprefetching
		, addrNextFrame.GetNextValue(), curVolumeSize.GetValue()
		, maxRowCount.GetValue(), lastLen.GetValue());
	
	//BuildInputFifo
	fprintf(fini, " %d %d %d %d %d %d", state.GetValue(), readCLast.GetValue()
		, outputBufH1.GetValue(), downPad.GetValue(), topPad.GetValue(), k.GetValue());
	fprintf(fini, " %d %d %d %d\n", stride.GetValue(), rowNum.GetValue()
		,reset_iLayers, rowAddr.GetNextValue());

	//SendBackUpInput
	fprintf(fini, " %d %d %d", sendBackUpInput_valid, backupId, leftPad.GetValue());
	
	//SetupShiftInputs
	fprintf(fini, " %d", input_src);
	inputs_buffer_progfull = inputs_buffer.IsFull(INPUT_MEM_WIDTH);
	inputs_buffer_empty = inputs_buffer.IsEmpty();
	inputs_buffer_wen = inputs_buffer_ren = false;
}
void CHomoGeneousComputingBank::FinishDumpVerifyInput(int num)
{
	if (!fini || !fino)
		return;

	if (pread->busValid && pread->isFeature && isReadingFeatures.GetValue())
		for (int i = 0; i < MAX_LOAD_WIDTH; i++)
			fprintf(fini, " %d", pread->dataBus[i]);
	fprintf(fini, "\n");

	if (!input_wen)
		fprintf(fino, " 0");
	fprintf(fino, "\n");
	fprintf(fino, " %d %d %d %d %d %d %d %d %d", input_ren
		, assemble_buff_wen, assemble_buff_ren, is_assemble_buff_full, is_assemble_buff_empty
		, inputfifo_wen, inputfifo_ren, is_input_fifo_full, is_input_fifo_empty);
	fprintf(fino, " %d %d %d %d %d %d\n", setLoadingFroze, resetLoadingFroze, resetLoadingNextFeatures
		, resetReadingFeatures, ibSize.GetValue(), nextWritePos.GetValue());

	fprintf(fino, " %d %d %d %d %d\n", resetAssemble, atmpSize.GetValue(), curRowCount.GetValue()
		, addrCurAssemble.GetValue(), addrNextFrame.GetValue());

	fprintf(fino, " %d %d\n", iLayers.GetValue(), rowAddr.GetValue());

	fprintf(fino, " %d %d %d %d %d %d %d\n", inputs_buffer_progfull, inputs_buffer_wen
		, inputs_buffer_ren, inputs_buffer_empty, addrNextAssemble.GetNextValue()
		, input_requested.GetValue(), addrNextAssemble.GetValue());
	bool cmp = (state.GetValue() != IDLE) && (state.GetValue() != CONV_INIT) && (state.GetValue() != CONV_START);
	if (cmp){
		unsigned len = k.GetValue(); // leftPad.GetValue() + rightPad.GetValue();
		fprintf(fino, " %d", len);
		for (unsigned i = 0; i < len; i++)
			fprintf(fino, " %d", shiftInputs[i]);
	}
	else
		fprintf(fino, " 0");

	if (isBackupValid){
		unsigned arraySize = COMPUTING_GROUP_SIZE;
		fprintf(fino, " 1 %d", arraySize);
		for (unsigned i = 0; i < arraySize; i++)
			fprintf(fino, " %d", backupBus[i]);
	}
	else
		fprintf(fino, " 0");
	fprintf(fino, "\n");
}


void CHomoGeneousComputingBank::PushInst(int num, InstructionHCB &inst)
{
	assert(!pib->IBFull());
	pib->Push(inst);
	
	InstructionHCBWt inst2;
	inst2.seqNum = inst.seqNum;
	inst2.type = inst.type;
	inst2.Waddr = inst.Waddr;
	inst2.weightPos = inst.weightPos;
	inst2.WEnd = inst.WEnd;
	pibw->Push(inst2);

	receive_inst = true;
	dump_start = true;
	if (fhcbi){
		fprintf(fhcbi, "%d 1", num + 1);
		fprintf(fhcbi, " %d %d %d %d %d %d %d %d\n", inst.Id, inst.type
			, inst.reqSeqNum, inst.reqProgress, inst.reqSeqNumW
			, inst.reqProgressW, inst.seqNum, inst.W);

		fprintf(fhcbi, " %d %d %d %d %d %d %d %d\n", inst.H, inst.C
			, inst.Waddr, inst.WEnd, inst.weightPos
			, inst.ReadPos, inst.ResPos, inst.W1);
		fprintf(fhcbi, " %d %d %d %d %d %d %d %d\n", inst.H1, inst.X
			, inst.Y, inst.S, inst.lPad
			, inst.rPad, inst.K, inst.M);
		fprintf(fhcbi, " %d %d %d %d %d %d %d\n", inst.Kh, inst.Ks
			, inst.Kt, inst.Res_addr, inst.wScale
			, inst.fScale, inst.wLRelu);
		fprintf(fhcbi, " %d %d %d %d %d %d %d\n", inst.weightToken, inst.maxpool_size
			, inst.maxpool_stride, inst.mode, inst.isResMaster
			, inst.isProgressMaster, inst.isRaddr_a);
		fprintf(fhcbi, " %d %d %d %d %d %d %d %d\n", inst.doRes, inst.doRelu
			, inst.doLRelu, inst.doBM, inst.doUpSample
			, inst.newWriteInst, inst.outbufsize, inst.ofsize);
		fprintf(fhcbi, " %d %d %d %d %d %d %d %d\n", inst.outyx, inst.outputAddrGap
			, inst.outkh, inst.ng, inst.gu
			, inst.resSize, inst.resSizeLast, inst.resLen);
		fprintf(fhcbi, " %d %d %d %d %d %d %d %d", inst.resLenLast, inst.pfs
			, inst.volumeSize, inst.kCurLast, inst.wtotal_n
			, inst.wtotalLast, inst.wlenk_regular, inst.wlenk_nLast);
		fprintf(fhcbi, " %d %d\n", inst.wlenk_nLast2, inst.totalRes);
	}

	/*InstructionHCBNF inst3;
	inst3.seqNum = inst.seqNum;
	inst3.ReadPos = inst.ReadPos;
	inst3.lPad = inst.lPad;
	inst3.rPad = inst.rPad;
	inst3.W = inst.W;
	inst3.H = inst.H;
	inst3.C = inst.C;
	inst3.W1 = inst.W1;
	inst3.H1 = inst.H1;
	inst3.X = inst.X;
	inst3.Y = inst.Y;
	pibf->Push(inst3);*/
}


void CHomoGeneousComputingBank::processNextWeightLoading(int num)
{
	if (isReadingWeights.GetValue())// || hasNextWeightParams.GetValue())
		return;
	if (pibw->Size() == 0)
		return;
	InstructionHCBWt inst;
	pibw->Pop(inst);
	if (inst.type == CONV){
		new_weight_params = true;
		nextWeightRead = inst.Waddr;
		endWeightRead = inst.WEnd;
		weightReadPos = inst.weightPos;
		isReadingWeights = true;
		//hasNextWeightParams = true;
		reqSeqW = inst.seqNum;
		//reqProgressW = inst.reqProgressW;
		//isLoadingNextWeights = false;
		if (fp && debugLevel <= 3)
			fprintf(fp, "%d : %s processNextWeightLoading seq %d, addr %d %d\n", num, name.c_str(), inst.seqNum, inst.Waddr, inst.WEnd);
	}
}

void CHomoGeneousComputingBank::processNextFeatureLoading(int num)
{
	if (isLoadingNextFeatures.GetNextValue() && hasNextFeatureParams.GetValue()){ //isLoadingNextFeatures could be change by readfeature the cycle
		if ( (!doRes.GetValue() || receivedRes.GetValue() >= totalRes.GetValue())){//|| !pread->IsReadResSameRam()){
			isReadingFeatures = true;
		}
	}
	if (!isLoadingNextFeatures.GetValue() || hasNextFeatureParams.GetValue())
		return;
	if (pwrite->IsFetchNextInst()){
		return;
	}
	if (pib->Size() == 0)
		return;
	InstructionHCB inst;
	pib->Top(inst);
	if (inst.type == CONV){
		new_params_prefetch = true;
		readPos = inst.ReadPos;
		int rw = inst.W1;
		if (inst.lPad > 0){
			if (inst.X > 0){
				rw += inst.lPad;
			}
		}
		if (inst.rPad > 0){
			if (inst.X + inst.W1 != inst.W)
				rw += inst.rPad;
		}
		writeWidth = rw;
		
		//rowNum = yl;
		//frameSize = inst.W * inst.H;
		volumeSize = inst.volumeSize;

		//frameReadStart = inst.W * ys + nextx + inst.Maddr;
		//nextReadPos = inst.W * ys + nextx + inst.Maddr;  //frameReadStart;
		nextWritePos = 0;
		ibSize = 0;
		reqSeqF = inst.seqNum;
		rf_new_params = true;
		if ((!doRes.GetValue() || receivedRes.GetValue() >= totalRes.GetValue())){//|| !pread->IsReadResSameRam()){
			isReadingFeatures = true;
			if (usedWords.GetValue() < writeWidth.GetValue()) 
				isLoadingFroze = true;
			else
				isLoadingFroze = false;
			//isLoadingNextFeatures = false;
		}
		hasNextFeatureParams = true;
		if (fp && debugLevel <=3)
			fprintf(fp, "%d : %s processNextFeatureLoading req %d, writewidth %d, volsize %d, rpos %d, seq %d\n"
			, num, name.c_str(), inst.reqSeqNum, rw, inst.volumeSize, inst.ReadPos, inst.seqNum);
	}
}


//void CGetTotalFrames::Init()
//{
//	storages.push_back(&fc_computing);
//	storages.push_back(&fc_done);
//	storages.push_back(&fc_kh);
//	storages.push_back(&fc_ks);
//	storages.push_back(&fc_kt);
//	storages.push_back(&fc_num);
//	storages.push_back(&fc_ng);	
//	reset();
//	fc_done.SetSkipCheck();
//}
//void CGetTotalFrames::reset()
//{
//	std::vector<CSimNode *>::const_iterator p = storages.begin();
//	for (; p != storages.end(); p++)
//		(*p)->reset();
//}
//void CGetTotalFrames::latch(int num)
//{
//	std::vector<CSimNode *>::const_iterator p = storages.begin();
//	for (; p != storages.end(); p++)
//		(*p)->latch(num);
//}
//void CGetTotalFrames::Start(int kh, int ks, int kt, int ng)
//{
//	fc_kh = kh;
//	fc_ks = ks;
//	fc_kt = kt;
//	fc_ng = ng;
//	fc_computing = true;
//	fc_num = 0;
//	fc_done = false;
//}
//void CGetTotalFrames::progress(int num)
//{
//	if (fc_done.GetValue()){
//		p->SetFC(fc_num.GetValue());
//	}
//	if (fc_computing.GetValue()){
//		int fc_end = fc_kh.GetValue() + fc_ng.GetValue() - 1;
//		if (fc_end >= fc_kt.GetValue()){
//			fc_done = true;
//			fc_computing = 0;
//			fc_num = fc_num.GetValue() + fc_kt.GetValue() - fc_kh.GetValue() + 1;
//		} else
//			fc_num = fc_num.GetValue() + fc_ng.GetValue();
//		fc_kh = fc_end + 1 + fc_ks.GetValue();
//	}
//	else
//		fc_done = false;
//}
//

void CHomoGeneousComputingBank::SetFC(int fc_count)
{

	if (doRes.GetValue()){
#ifdef BATCH1_OPTIMIZE
		if (doBatch3K1.GetValue())
			totalRes = outBufFrameSize.GetValue() * (kbe.GetValue() + 1 - kbh.GetValue() + fc_count);
		else
#endif
			totalRes = outBufFrameSize.GetValue() * fc_count;
		if (fp && debugLevel <= 3)
			fprintf(fp, "%s set totalRes %d, count %d\n", name.c_str(), totalRes.GetNextValue(), fc_count);
	}
}

void CHomoGeneousComputingBank::StartDumpVerifyProcessInstruction(int num)
{
	if (!fpii || !fpio)
		return;
	fprintf(fpii, "%d", num+1);
	fprintf(fpio, "%d", num);

	fprintf(fpii, " %d %d %d", isRunning.GetValue(), pwrite->IsFetchNextInst(), pib->Size() == 0);
	fprintf(fpii, " %d %d %d %d %d %d", hasNextFeatureParams.GetValue(), new_params_prefetch
		, readPos.GetNextValue(), writeWidth.GetNextValue()
		, volumeSize.GetNextValue(), reqSeqF.GetNextValue());
}
void CHomoGeneousComputingBank::FinishDumpVerifyProcessInstruction()
{
	if (!fpii || !fpio)
		return;
	if (!new_conv_inst)
		fprintf(fpii, " 0");
	fprintf(fpii, "\n");

	fprintf(fpio, " %d %d %d %d %d %d %d %d\n", pib_ren, new_conv_inst
		, k.GetNextValue(), curSeq.GetValue(), reqSeq.GetValue()
		, reqProgress.GetValue(), isProgressMaster.GetValue(), token_set);
	fprintf(fpio, " %d %d %d %d %d %d %d %d\n", k.GetValue(), stride.GetValue()
		, outW.GetValue(), outputBufH1Orig.GetValue(), outputBufW1.GetValue()
		, outBufFrameSize.GetValue(), outFrameSize.GetValue(), outputAddrGap.GetValue());
	
	fprintf(fpio, " %d %d %d %d %d %d %d %d\n", outFrameGapSize.GetValue(), maxpool_stride.GetValue()
		, numGroups.GetValue(), token.GetValue(), isResMaster.GetValue()
		, readPos.GetValue(), resPos.GetValue(), leftPad.GetValue());
	fprintf(fpio, " %d %d %d %d %d %d %d %d\n", writeWidth.GetValue(), readCLast.GetValue()
		, topPad.GetValue(), downPad.GetValue(), reqSeqF.GetValue()
		, Ks.GetValue(), kt.GetValue(), doRes.GetValue());
	fprintf(fpio, " %d %d %d %d %d %d %d %d\n", doRelu.GetValue(), doLRelu.GetValue()
		, doBM.GetValue(), doUpSample.GetValue(), newWriteInst.GetValue()
		, wLRelu.GetValue(), prefetchFrameSize.GetValue(), volumeSize.GetValue());
	fprintf(fpio, " %d %d %d %d %d %d %d\n", curVolumeSize.GetValue(), mode.GetValue()
		, fScale.GetValue(), wScale.GetValue()
		, totalRes.GetValue(), usedGroupsLast.GetValue(), usedCGLast.GetValue());
	fprintf(fpio, " %d %d %d %d %d %d %d %d\n", usedCG0.GetValue(), kCurLast.GetValue()
		, resSize0.GetValue(), resSizeLast.GetValue(), resLen0.GetValue()
		, resLenLast.GetValue(), wtotal_n.GetValue(), wlenk_nLast.GetValue());
	fprintf(fpio, " %d %d %d %d %d", wtotalLast.GetValue(), wlenk_nLast2.GetValue()
		, wlenk_regular.GetValue(), wlen_regular.GetValue(), kCurLast_1.GetValue()); 
#ifdef S2_OPTIMIZE
	fprintf(fpio, " %d", isStride2.GetValue());
	if(new_conv_inst)
		fprintf(fpio, " %d %d", nextRowStart.GetNextValue(), kIter.GetNextValue());
#endif
	fprintf(fpio, "\n");
	if (new_conv_inst){
		fprintf(fpio, " %d %d %d %d %d %d %d %d\n", wlenk.GetNextValue(), wlenk_last.GetNextValue()
			, maxRowCount.GetNextValue(), lastLen.GetNextValue(), outputBufH1.GetNextValue()
			, outputAddr.GetNextValue(), outputFrameStart.GetNextValue(), readWidth.GetNextValue());
		fprintf(fpio, " %d %d %d %d %d %d %d %d\n", rowAddr.GetNextValue(), rowNum.GetNextValue()
			, kCur.GetNextValue(), kOut.GetNextValue(), usedGroups.GetNextValue()
			, resSize.GetNextValue(), resReadSize.GetNextValue(), resFrameMax.GetNextValue());
		fprintf(fpio, " %d %d %d\n"
			, wtotal.GetNextValue(), resFrameCount.GetNextValue(), resRowCount.GetNextValue());
		fprintf(fpio, " %d %d %d %d %d %d %d\n", isReadResA.GetNextValue(), nextResAddr.GetNextValue()
			, frameResAddr.GetNextValue(), resLen.GetNextValue(), outResGapSize.GetNextValue()
			, kRes.GetNextValue(), addrNextFrame.GetNextValue());

	}
}

void CHomoGeneousComputingBank::dumpVerifyInstruction(InstructionHCB &inst)
{
	new_conv_inst = true;
	if (!fpii)
		return;
	fprintf(fpii, " 1\n");

	fprintf(fpii, " %d %d %d %d %d %d %d %d\n", inst.Id, inst.type
		, inst.reqSeqNum, inst.reqProgress, inst.reqSeqNumW
		, inst.reqProgressW, inst.seqNum, inst.W);

	fprintf(fpii, " %d %d %d %d %d %d %d %d\n", inst.H, inst.C
		, inst.Waddr, inst.WEnd, inst.weightPos
		, inst.ReadPos, inst.ResPos, inst.W1);
	fprintf(fpii, " %d %d %d %d %d %d %d %d\n", inst.H1, inst.X
		, inst.Y, inst.S, inst.lPad
		, inst.rPad, inst.K, inst.M);
	fprintf(fpii, " %d %d %d %d %d %d %d\n", inst.Kh, inst.Ks
		, inst.Kt, inst.Res_addr, inst.wScale
		, inst.fScale, inst.wLRelu);
	fprintf(fpii, " %d %d %d %d %d %d %d\n", inst.weightToken, inst.maxpool_size
		, inst.maxpool_stride, inst.mode, inst.isResMaster
		, inst.isProgressMaster, inst.isRaddr_a);
	fprintf(fpii, " %d %d %d %d %d %d %d %d\n", inst.doRes, inst.doRelu
		, inst.doLRelu, inst.doBM, inst.doUpSample
		, inst.newWriteInst, inst.outbufsize, inst.ofsize);
	fprintf(fpii, " %d %d %d %d %d %d %d %d\n", inst.outyx, inst.outputAddrGap
		, inst.outkh, inst.ng, inst.gu
		, inst.resSize, inst.resSizeLast, inst.resLen);
	fprintf(fpii, " %d %d %d %d %d %d %d %d\n", inst.resLenLast, inst.pfs
		, inst.volumeSize, inst.kCurLast, inst.wtotal_n
		, inst.wtotalLast, inst.wlenk_regular, inst.wlenk_nLast);
	fprintf(fpii, " %d %d", inst.wlenk_nLast2, inst.totalRes);

}

void CHomoGeneousComputingBank::processInstruction(int num)
{
	//if (state.GetValue() != IDLE)
	//return;
	if (!pwrite->IsFetchNextInst())
		return;
	if (pib->Size() == 0)
		return;
	pib_ren = true;
	InstructionHCB inst;
	pib->Pop(inst);

	if (inst.type == CONV){
		input_src = INPUT_NON;
		dumpVerifyInstruction(inst);
		setCGConvRows(inst);
		curSeq = inst.seqNum;
		//workingProgress = 0;
		reqSeq = inst.reqSeqNum;
		reqProgress = inst.reqProgress;

		isProgressMaster = inst.isProgressMaster;
		if (id == 0){
			token_set = true;
			if (inst.mode == MODE_FOUR)
				max_token = 3;
			else if (inst.mode == MODE_TWO)
				max_token = 1;
			else
				max_token = 0;
			ptoken->SetMaxVal(max_token);
		}
		k = inst.K;
		stride = inst.S;
		assert(inst.S <=2 ); // >2 not supported by sv in CShiftComputingGroup::GetOutput
#ifdef S2_OPTIMIZE
		isStride2 = (inst.S == 2);
#endif
		//c = inst.C;
		//h = inst.H;
		//w = inst.W;
		//outC = inst.M;
		if (inst.maxpool_stride > 1)
			assert(inst.doRes == 0 && inst.doUpSample == 0);
		maxpool_stride = inst.maxpool_stride;
		int outwidth;
		
		outwidth = (inst.W - inst.K + inst.lPad + inst.rPad) / inst.S + 1;
		if (inst.maxpool_stride == 2)
			outwidth /= 2;
		if (inst.doUpSample){
			outwidth *= 2;
		}
		outW = outwidth;
		
		int outbufh1 = ((inst.H1 - inst.K + 1 + inst.lPad + inst.rPad) / inst.S);
		outputBufH1 = outbufh1;
		outputBufH1Orig = outbufh1;
		int outbufw1 = ((inst.W1 - inst.K + inst.lPad + inst.rPad) / inst.S + 1);
		outputBufW1 = outbufw1;
		outBufFrameSize = inst.outbufsize;
		if (outputBufH1.GetNextValue() <= 5)
			isPrefetchWeight.SetSkipCheck();
		outBufferUseCount.SetSkipCheck();

		outFrameSize = inst.ofsize;

		outputAddrGap = inst.outputAddrGap;
		outFrameGapSize = inst.ofsize * SZ_DTYPE + inst.outputAddrGap * SZ_DTYPE;
		//int outaddr = inst.Oaddr + inst.outkh;
		int outaddr = inst.outkh;
		outputAddr = outaddr;
		outputFrameStart = outaddr;
#ifdef BATCH1_OPTIMIZE
		batchAddr = inst.Oaddr + inst.outkhb;
#endif
		numGroups = inst.ng;
		token = inst.weightToken;

		isResMaster = inst.isResMaster;

		readPos = inst.ReadPos;
		resPos = inst.ResPos;
		int rw = inst.W1;
		int nextx = inst.X;
		//nextReadX = inst.X;
		int lp = 0;
		//leftPad = 0;
		int rp = 0;
		if (inst.lPad > 0){
			if (inst.X > 0){
				rw += inst.lPad;
				nextx -= inst.lPad;
			}
			else{

				lp = inst.lPad;
			}
		}
		if (inst.rPad > 0){
			if (inst.X + inst.W1 == inst.W)
				rp = inst.rPad;
			else{
				rw += inst.rPad;
			}
		}
		leftPad = lp;
		//rightPad = rp;
		readWidth = rw;
		writeWidth = rw;
		
		int ys = inst.Y;
		int yl = inst.Y + inst.H1;
		readCLast = inst.C - 1;
		int tp, dp;
		if (inst.lPad > 0){
			if (inst.Y > 0){
				ys -= inst.lPad;
				tp = 0;
			}
			else{
				tp = inst.lPad;
			}
		}
		else
			tp = 0;
		topPad = tp;
		rowAddr = -tp;
		if (inst.rPad > 0){
			if (inst.Y + inst.H1 + 1 == inst.H)
				dp = inst.rPad;
			else{
				yl += inst.rPad;
				dp = 0;
			}
		}
		else
			dp = 0;
		downPad = dp;
		rowNum = yl - ys + 1;
		
		if (hasNextFeatureParams.GetValue()){
			if (isLoadingNextFeatures.GetValue() && !isReadingFeatures.GetValue())
				if (isReadingFeatures.GetNextValue() != true)
					isReadingFeatures = true; // have not read until now
			
		}
		else{
			//frameReadStart = inst.W * ys + nextx + inst.Maddr;
			//nextReadPos = inst.W * ys + nextx + inst.Maddr;  //frameReadStart;
			nextWritePos = 0;
			ibSize = 0;
			isReadingFeatures = true;
			reqSeqF = inst.seqNum;
			rf_new_params = true;
		}
		isLoadingNextFeatures = false;
		hasNextFeatureParams = false;

		kCur = inst.Kh;
		kOut = inst.Kh;
		Ks = inst.Ks;
		kt = inst.Kt;
		
		usedGroups = inst.gu;
		//usedCG = inst.usedCG;
		resSize = inst.resSize;
		resSize0 = inst.resSize;
		resSizeLast = inst.resSizeLast;
		resLen = inst.resLen;
		resLen0 = inst.resLen;
		resLenLast = inst.resLenLast;
		outResGapSize = inst.resLen * SZ_DTYPE + inst.outputAddrGap * SZ_DTYPE;

		resReadSize = 0;
		resFrameMax = inst.gu - 1;

		doRes = inst.doRes;
		doRelu = inst.doRelu;
		doLRelu = inst.doLRelu;
		wLRelu = inst.wLRelu;
		doBM = inst.doBM;
		doUpSample = inst.doUpSample;
		newWriteInst = inst.newWriteInst;
		
		//isbmBatch = false;
		if (inst.doRes){
			resFrameCount = 0;
			resRowCount = 0;
			isReadResA = inst.isRaddr_a;
			int fa = inst.Res_addr + inst.outkh * SZ_DTYPE;
			nextResAddr = fa;
			frameResAddr = fa;
			kRes = inst.Kh;
			//if (inst.doBatch3){
			//	totalRes = outbufsize * (inst.Kbe + 1 - inst.Kbh + getTotalFrames(inst.Kh, inst.Ks, inst.Kt, ng)); // ok to be done in multiple clocks;
			//}else
			//	totalRes = outbufsize * getTotalFrames(inst.Kh, inst.Ks, inst.Kt, ng); // ok to be done in multiple clocks;
			//resBuf.reset();
		}
		//else
		totalRes = inst.totalRes;;
		
		/*if (inst.doBatch3){
			assert(inst.K == 1);
			doBatch3K1 = true;
			batchSize = inst.batchSize;
		}
		else
			doBatch3K1 = false;*/
		maxRowCount = yl - ys;
		lastLen = rw;
		assert(curRowCount == 0);
		if (fp && debugLevel <= 1 && name == DEBUG_BANK_NAME)
			fprintf(fp, "%s maxRowCount %d (%d)\n", name.c_str(), maxRowCount.GetNextValue(), lastLen.GetNextValue());

		state = CONV_INIT;
		initFSteps = 0;
		initWSteps = 0;

		if (inst.K == 1)
			wlen_regular = 8;
		else if (inst.K <= 4)
			wlen_regular = 2;
		else
			wlen_regular = 1;
		wlenk_regular = inst.wlenk_regular;
		wlenk_nLast = inst.wlenk_nLast;
		wlenk_nLast2 = inst.wlenk_nLast2;
		if (inst.gu == inst.ng){
			wtotal = inst.wtotal_n;
			wlen = GetWLen(inst.wtotal_n, 0, inst.K);
			if (wlen.GetNextValue() == wlen_regular.GetNextValue())
				wlenk = inst.wlenk_regular;
			else
				wlenk = inst.wlenk_nLast;
			wlenk_last = inst.wlenk_nLast;
		}
		else{
			wtotal = inst.wtotalLast;
			if (wlen_regular.GetNextValue() > inst.wtotalLast)
				wlen_regular = inst.wtotalLast;
			wlen = GetWLen(inst.wtotalLast, 0, inst.K);
			if (wlen.GetNextValue() == wlen_regular.GetNextValue())
				wlenk = inst.wlenk_regular;
			else
				wlenk = inst.wlenk_nLast2;
			wlenk_last = inst.wlenk_nLast2;
		}
		
		assert(wlenk.GetNextValue() == wlen.GetNextValue() * inst.K);
		wtotal_n = inst.wtotal_n;
		wtotalLast = inst.wtotalLast;
		wlenk_n = GetWLen(inst.wtotal_n, 0, inst.K) * inst.K;
		wlenkLast = GetWLen(inst.wtotalLast, 0, inst.K) * inst.K;

#ifdef BATCH1_OPTIMIZE
		kbh = inst.Kbh;
		kbe = inst.Kbe;
		kbe_1 = inst.kbe_1;
		resSizeBatch = inst.resSizeBatch;
		resLenBatch = inst.resLenBatch;
		bmBatchStart = inst.BM_addr + 2 * sizeof(DTYPE) * (inst.Kbh);
		bmBatchEnd = inst.BM_addr + 2 * sizeof(DTYPE) * (inst.Kbe + 1);
		resBatchStart = inst.Res_addr + inst.outkhb;
		doBatch3K1 = inst.doBatch3;
		batchSize = inst.batchSize;
		doBatch3K1_cur = false;

		readRowCount3 = inst.readRowCount3;
		lastRowLen3 = inst.lastRowLen3;
		wlenk_bLast = inst.wlenk_bLast;
		wlenk_bLast2 = inst.wlenk_bLast2;
		batch_only_1group = inst.batch_1group;
		wtotal_bn = inst.ug_batch;
		wtotalbLast = inst.ug_batchLast;
		wlenk_bn = GetWLen(inst.ug_batch, 0, inst.K) * inst.K;
		wlenkbLast = GetWLen(inst.ug_batchLast, 0, inst.K) * inst.K;
#endif
		//isReadingWeights = true;
		//nextBackupAddr = 0;
		prefetchFrameSize = inst.pfs;
		volumeSize = inst.volumeSize;
		curVolumeSize = inst.volumeSize;
		mode = inst.mode;
		askedRes = 0;
		receivedRes = 0;
		loadNextInst = false;
		wScale = inst.wScale;
		fScale = inst.fScale;
		doAssemble = true;
		addrNextFrame = inst.pfs;
		iLayers = 0;
#ifdef S2_OPTIMIZE	
		s2b_lastAddr = -1;
		kIter = inst.K - 1;
		nextRowStart = inst.S - topPad.GetNextValue();
#endif
		kCurLast = inst.kCurLast;
		if (inst.kCurLast > inst.ng + inst.Ks) //no need for sv
			kCurLast_1 = inst.kCurLast - inst.ng - inst.Ks;
		else
			kCurLast_1 = 0;
		usedGroupsLast = inst.Kt + 1 - inst.kCurLast;
		usedCGLast = usedGroupsLast.GetNextValue() * inst.K;
		usedCG0 = inst.ng * inst.K;
		if (fp && debugLevel <=1)
			fprintf(fp, "prev Weight Use Count %d\n", weightUsed);
		weightUsed = 0;
		weightOutBuf.reset();
		//extWeightOutBuf.reset();
		assert(inputs_buffer.IsEmpty());
		addrNextAssemble = 0;
		//fprintf(fp, "rbm %d, rr %d, lbm %d\n", requestingBM.GetValue(), requestingRes.GetValue(), liveBM.GetValue()); fflush(fp);
		//assert(requestingBM == false);
		assert(requestingRes == false);
		//assert(liveBM == 0);
		//assert(liveRes == 0);
		if (fp && debugLevel <=3)
			fprintf(fp, "%d : %s pop CONV (x=%d , y=%d) W(%d), H(%d), C(%d), M(%d), K(%d), S(%d), W1(%d), H1(%d), K=(%d,%d,%d), req %d, seq %d, %s %s %s %s %s %s %s\n"
			, num, name.c_str(), inst.X, inst.Y
			, inst.W, inst.H, inst.C, inst.M, inst.K, inst.S, inst.W1, inst.H1
			, inst.Kh, inst.Ks, inst.Kt, inst.reqSeqNum, inst.seqNum
			, inst.isProgressMaster ? "PM" : "", inst.isResMaster ? "RM" : ""//, inst.isWeightMaster ? "WM" : ""
			, inst.doBM ? "BM" : "", inst.doRelu ? "Relu" : ""
			, inst.doLRelu ? "LRelu" : "", inst.doRes ? "Res" : "", inst.doUpSample ? "UpSample" : "");
		/*if (name == DEBUG_BANK_NAME)
			printf("pop seq %d %d\n", inst.seqNum, num);*/
		return;
	}

	if (inst.type == POOL){
		return;
	}
}

void CHomoGeneousComputingBank::setCGConvRows(InstructionHCB &inst)
{
	for (unsigned i = 0; i < cgs.size(); i++)
		//cgs[i]->setConvIndex(inst.cg_conv_index[i].i);
#ifdef BATCH1_OPTIMIZE
		cgs[i]->setConvIndex(inst.doBatch3? 3 : inst.K);
#else
		cgs[i]->setConvIndex(inst.K);
#endif
}
unsigned CHomoGeneousComputingBank::GetWLen(unsigned wtotal, unsigned initw, unsigned k)
{
	int len;
	if (initw < wtotal){
		if (k == 1)
			len = 8;
		else if (k <= 4)
			len = 2;
		else
			len = 1;
		if (initw + len > wtotal)
			len = wtotal - initw;
	}
	else
		len = 0;
	return len;
}
void CHomoGeneousComputingBank::processConvInit(int num)
{
	if (state.GetValue() != CONV_INIT && !isPrefetchNextVolume.GetValue())
		return;
	bool FDone = false;
	bool WDone = false;
	FDone = (initFSteps.GetValue() == k.GetValue()) || (initFSteps.GetValue() == (k.GetValue() - 1) && input_fifo.size() != 0);// &&
		//(/*nextWritePos.GetValue() >= volumeSize.GetValue() / 2 ||*/ !(/*k == 1 && */isReadingFeatures.GetValue() && !isLoadingNextFeatures.GetValue())// && mode.GetValue() == MODE_ONE
		//));
	if (initFSteps.GetValue() < k.GetValue())// && (/*nextWritePos.GetValue() >= volumeSize.GetValue()/2 ||*/ !(/*k == 1 && */isReadingFeatures.GetValue() && !isLoadingNextFeatures.GetValue()
		//&& mode.GetValue() == MODE_ONE
//		)))
	{
		if (input_fifo.size() == 0){
			is_input_fifo_empty = true;
			return;
		}
		sendBackUpInput(initFSteps.GetValue());				
		initFSteps++;
	}
	//FDone = initFSteps.GetNextValue() == k.GetValue();
	if (initWSteps.GetValue() < wtotal.GetValue()/* && !isPrefetchBMWeight.GetValue()*/){

		if (weightOutBuf.HasEnough(wlenk.GetValue())){
			sendWeights(initWSteps.GetValue(), wlenk.GetValue());
			initWSteps += wlen.GetValue();
			wlen = GetWLen(wtotal.GetValue(), initWSteps.GetNextValue(), k.GetValue());
			if (wlen.GetNextValue() == 0)
				wlenk = 0;
			else if (wlen.GetNextValue() == wlen_regular.GetValue())
				wlenk = wlenk_regular.GetValue();
			else
				wlenk = wlenk_last.GetValue();
			assert(wlenk.GetNextValue() == wlen.GetNextValue() * k.GetValue());
		}
		//else{//donot care
		//	wlen = 0;
		//	wlenk = 0;
		//}
		//if (initWSteps.GetNextValue() == wtotal)
		//	WDone = true;
	}
	//else
	//	WDone = true;
	//WDone = initWSteps.GetNextValue() == wtotal;
	WDone = initWSteps.GetValue() == wtotal.GetValue();
	if (FDone && WDone){
		if (state == CONV_INIT && isReadingFeatures.GetValue() && pread->waitForSeq()){
			if (fp && debugLevel <= 1)
				fprintf(fp, "%d : %s CONV START waiting for feature data\n", num, name.c_str());
			printf("%d : %s CONV START waiting for feature data\n", num, name.c_str());
			assert(false);
			return;
		}
		if (state == CONV_INIT || state == CONV_OUT)
			state = CONV_START;
		if (isPrefetchNextVolume.GetValue()){
			isPrefetchNextVolume = false;
			isNextVolumeReady = true;
		}
		if (name == DEBUG_BANK_NAME)
			name = name;
		if (fp && debugLevel <= 3)
			fprintf(fp, "%d : %s CONV START\n", num, name.c_str());
	}
}


void CHomoGeneousComputingBank::processConvStart(int num)
{
	num = num;
	if (state == CONV_START && outBufferUseCount.GetValue() < 2 && input_fifo.size() != 0){
#ifdef BATCH1_OPTIMIZE
		outBatch3.Push(doBatch3K1_cur.GetValue());
#endif
		outBufferUseCount++;
		if (fp && debugLevel <=3)
			fprintf(fp, "%d : %s MULT started, seq %d, buffer count %d, convbuffer %d\n", num, name.c_str()
			, curSeq.GetValue() , outBufferUseCount.GetNextValue(), convBuffers.GetValue());
		convBuffers++;
		input_src = INPUT_BACKUP;
		state = CONV_MULT;
		nextWeight = true;
		if (k == 1)
			outputCountDown = 2;
		else
			outputCountDown = k.GetValue() + k.GetValue() + 1;
		if (name == DEBUG_BANK_NAME)
			name = name;
		outputWritePos = 0;
		outputReadPos = 0;
		layerCount = 0;
		isInitLayer = true;
		isLastLayer = false;//assume more than one layer
		isPrefetchWeight = true;
		wlen = GetWLen(wtotal.GetValue(), 0, k.GetValue());
		if (wlen.GetNextValue() == wlen_regular.GetValue())
			wlenk = wlenk_regular.GetValue();
		else
			wlenk = wlenk_last.GetValue();
		assert(wlenk.GetNextValue() == wlen.GetNextValue() * k.GetValue());
		initWSteps = 0;
		//outputAfterLast = false;
		isNextVolumeReady = false;
		doOutScale = false;
		outLayerCount = 0;
		iterCountDown = k.GetValue() - 1;
		assert(outputBufH1.GetValue() >= 3);
		frameCountDown = outputBufH1.GetValue() - 2;
		if (stride == 1){
			sendBackUpInput(k.GetValue() - 1);
		}
		else{
			sendBackUpInput(0);
		}

		return;
	}
}

unsigned CHomoGeneousComputingBank::GetBMWLen(unsigned ug, unsigned initw)
{
	int len = 2;
    //if(CG_NUM <12) 
	//	len = 3;
	if (initw + len > ug)
		len = (ug - initw);
	return len;
}

void CHomoGeneousComputingBank::processBMWeights(int num)
{
	bool enabled = false;
	bool isEmpty = weights.IsEmpty();
	int size = weights.size();
	if (isPrefetchBMWeight.GetValue() && !is_cycle_froze){
		if (initBMWSteps.GetValue() >= usedGroups.GetValue()){

			isPrefetchBMWeight = false;
			if (state.GetValue() == CONV_BM || state.GetNextValue() == CONV_BM){
				//	isLReluInit = false;
				if (name == DEBUG_BANK_NAME)
					name = name;
				nextWeight = true; // start BM weight
			}
		}
		else{
			if (name == DEBUG_BANK_NAME)
				name = name;
			
			if (weightOutBuf.HasEnough(BMlen.GetValue() * BM_NUM)){
				if (fbmi)
					fprintf(fbmi, "%d 1 %d", num + 1, BMlen.GetValue());
				bool rd_en = sendBMWeights(initBMWSteps.GetValue(), BMlen.GetValue());
				initBMWSteps += BMlen.GetValue();
				BMlen = GetBMWLen(usedGroups.GetValue(), initBMWSteps.GetNextValue());
				enabled = true;
				if (fbmo){
					fprintf(fbmo, "%d %d %d %d %d %d %d", num, 1, isEmpty, size, weightOutBuf.GetNumBuf(), rd_en, BMlen.GetValue() * 2);
					for (unsigned i = 0; i < BMlen.GetValue() * 2; i++)
						fprintf(fbmo, " %d", weightBus[i].GetNextValue());
				}

			}
			//else
			//	BMlen = 0; //donot care
			
		}
	}
	
	if (!enabled && fbmi)
		fprintf(fbmi, "%d 0 %d", num + 1, BMlen.GetValue());
	if (!enabled && fbmo)
		fprintf(fbmo, "%d %d %d %d %d 0 0", num, weightOutBuf.HasEnough(BMlen.GetValue() * 2), isEmpty, size, weightOutBuf.GetNumBuf());

}

void CHomoGeneousComputingBank::computeCycleFroze(int num)
{
	is_cycle_froze = false;
	if (state == CONV_MULT&& !waiting_out.GetValue()){
		if (isPrefetchWeight.GetValue()){
			if (initWSteps.GetValue() != wtotal.GetValue())
			{
				if (!weightOutBuf.HasEnough(wlenk.GetValue())){
					is_cycle_froze = true;
					if (fp && debugLevel <= 3)
						fprintf(fp, "%d : %s cycle weight froze\n", num, name.c_str());
				}
			}

		}
		bool is_send_backup = false;
		if (k.GetValue() == 1){
			if (outputReadPos.GetValue() < outputBufH1.GetValue() - 1){
				if (!isLastLayer.GetValue() && (layerCount.GetValue() != readCLast.GetValue() || outputReadPos.GetValue() < outputBufH1.GetValue() - 2))
					is_send_backup = true;
			}
			else if (outputReadPos == outputBufH1.GetValue() - 1){//starting next frame
				if (layerCount.GetValue() < readCLast.GetValue()){
					is_send_backup = true;
				}
			}
			else if (outputReadPos == outputBufH1.GetValue()){//starting next frame
				if (!isLastLayer.GetValue()){
					is_send_backup = true;
				}
			}
		}
		else{ //k > 1
			if (stride == 1){
				if (iterCountDown == 0){
					{
						if (outputReadPos == outputBufH1.GetValue() - 1){//starting next frame
							if (layerCount.GetValue() < readCLast.GetValue()){
								is_send_backup = true;
							}
						}
						else if (outputReadPos == outputBufH1.GetValue()){//starting next frame
							if (layerCount.GetValue() < readCLast.GetValue()){
								is_send_backup = true;
							}
						}
						else{
							if (!isLastLayer.GetValue())
								is_send_backup = true;
						}

					}
				}
				else{//iterCountDown > 0
					if (isPrefetchNext.GetValue()){
						is_send_backup = true;
					}
				}
			}
			else{ //stride > 1
				if (iterCountDown == 0){
					if (outputReadPos == outputBufH1.GetValue() - 1){//starting next frame
						if (layerCount.GetValue() < readCLast.GetValue()){
							is_send_backup = true;
						}
					}
					else if (outputReadPos == outputBufH1.GetValue()){//starting next frame
						if (layerCount.GetValue() < readCLast.GetValue()){
							is_send_backup = true;
						}
					}
					else{
						if (!isLastLayer.GetValue()){
							is_send_backup = true;
						}
					}
				}
				else{ //iterCountDown != 0
					if (!isLastLayer.GetValue()){
						is_send_backup = true;
					}
				}
			}
		}
		if (is_send_backup && input_fifo.size() == 0){
			is_cycle_froze = true;
			if (fp && debugLevel <= 3)
				fprintf(fp, "%d : %s cycle feature froze\n", num, name.c_str());
		}
	}
}
void CHomoGeneousComputingBank::processConvCompute(int num)
{
	//if (waitPrefetching.GetValue())// && ext_state.GetValue() != EWRS_BM)
	//	startPrefetching(num);
	computeCycleFroze(num);
	
	if (!is_cycle_froze && state == CONV_MULT&& !waiting_out.GetValue()){
			if (isPrefetchWeight.GetValue()){
				if (initWSteps.GetValue() == wtotal.GetValue())
					isPrefetchWeight = false;// low priority compare the other assignments
				else{
					
					if (weightOutBuf.HasEnough(wlenk.GetValue())){
						sendWeights(initWSteps.GetValue(), wlenk.GetValue());
						initWSteps += wlen.GetValue();
						wlen = GetWLen(wtotal.GetValue(), initWSteps.GetNextValue(), k.GetValue());
						if (wlen.GetNextValue() == 0)
							wlenk = 0;
						else if (wlen.GetNextValue() == wlen_regular.GetValue())
							wlenk = wlenk_regular.GetValue();
						else
							wlenk = wlenk_last.GetValue();
						assert(wlenk.GetNextValue() == wlen.GetNextValue() * k.GetValue());
					}
					else{
						if (fp && debugLevel <= 3)
							fprintf(fp, "%d : %s waiting for weights %d (%d)\n"
							, num, name.c_str(), wlenk.GetValue(), weightOutBuf.GetNumBuf());
					}
					//else{//donot care
					//	wlen = 0;
					//	wlenk = 0;
					//}
					/*else
						assert(false);*/
				}

			}

			if (outputCountDown == 0){
				outputCountDown = k.GetValue() - 1;
				isOutputReady = true;
				if (isLastLayer.GetValue()){
					if (outputWritePos == outputBufH1.GetValue()){
						//outputIdxMax = usedCG.GetValue();
						doOutScale = false;
						if (name == DEBUG_BANK_NAME)
							name = name;
						if (doBM.GetValue()){
							if (!isPrefetchBMWeight.GetValue())
								nextWeight = true; // start BM weight
							//outputReadPos = 0;
							//outputWritePos = 0;
							bmPhase = 0;
							state = CONV_BM;
							isLReluInit = true;
							if (fp && debugLevel <=3)
								fprintf(fp, "%d : %s start bm, convbuf %d\n", num, name.c_str(), convBuffers.GetValue());
							
						}
						else if (doRelu.GetValue() || doLRelu.GetValue()){
							startPrefetching(num);
							state = CONV_RELU;
							//outputReadPos = 0;
							//outputWritePos = 0;
							if (doLRelu.GetValue()){
								isLReluWeight = true;
								//isLReluInit = true;
							}
							//else
								isLReluInit = true;
							if (fp && debugLevel <=3)
								fprintf(fp, "%d : %s start relu\n", num, name.c_str());
						}
						else{
							if (name == DEBUG_BANK_NAME)
								name = name;
							//state = CONV_OUT;
							startPrefetching(num);
							/*if (waiting_res.GetValue())
								waiting_res_for_out = true;
							else*/
								startConvOut(num);
						}
					}
					/*else
						outputAfterLast = true;*/
				}
				if (outputWritePos == outputBufH1.GetValue()){ //TODO: move this to latches after outputCountDown 0
					outputWritePos = 0;
					if (outLayerCount == readCLast.GetValue() - 1)
						doOutScale = true;
					outLayerCount++;

				}
				else
					outputWritePos = outputWritePos.GetValue() + 1;

			}
			else{
				//isOutputReady = false;
				outputCountDown = outputCountDown.GetValue() - 1;
			}
			if (k.GetValue() == 1){
				/*if (isLoadingNextFeatures.GetValue())
					usedWords += readWidth.GetValue();*/
				if (outputReadPos.GetValue() < outputBufH1.GetValue() - 1){
					input_src = INPUT_BACKUP;
					if (!isLastLayer.GetValue() && (layerCount.GetValue() != readCLast.GetValue() || outputReadPos.GetValue() < outputBufH1.GetValue() - 2))
						sendBackUpInput(0);
					if (fp && name == DEBUG_BANK_NAME && debugLevel <= 1)
						fprintf(fp, "%s rp %d, wp %d fcd %d\n", name.c_str(), outputReadPos.GetValue(), outputWritePos.GetValue(), frameCountDown.GetValue());
					if (frameCountDown == 0){
						frameCountDown = outputBufH1.GetValue();
						if (isLoadingNextFeatures.GetValue())
							usedWords_inc = prefetchFrameSize.GetValue();
					}
					else{
						frameCountDown = frameCountDown.GetValue() - 1;
					}
					if (outputCountDown.GetValue() != 2)//skip the first cycle for reading psum
						outputReadPos = outputReadPos.GetValue() + 1;
				}
				else if (outputReadPos == outputBufH1.GetValue() - 1){//starting next frame
					if (layerCount.GetValue() < readCLast.GetValue()){
						sendBackUpInput(0);
						
						if (isPrefetchWeight.GetValue()){
							printf("isPrefetchWeight is true! %s initstep %d", name.c_str(), initWSteps.GetNextValue());
							assert(false);
						}
						if (isPrefetchBMWeight.GetValue()){
							printf("isPrefetchBMWeight is true! %s initstep %d", name.c_str(), initWSteps.GetNextValue());
							assert(false);
						}
						initWSteps = 0;
						initBMWSteps = 0;
						input_src = INPUT_BACKUP;
						nextWeight = true;

						if (layerCount == readCLast.GetValue() - 1){
							isPrefetchWeight = false;
							if (doBM.GetValue()){
								isPrefetchBMWeight = true;
								BMlen = GetBMWLen(usedGroups.GetValue(), 0);
							}
						}
						else{
							isPrefetchWeight = true;
							wlen = GetWLen(wtotal.GetValue(),0, k.GetValue());
							if (wlen.GetNextValue() == wlen_regular.GetValue())
								wlenk = wlenk_regular.GetValue();
							else
								wlenk = wlenk_last.GetValue();
							assert(wlenk.GetNextValue() == wlen.GetNextValue() * k.GetValue());
						}
					}
					else if (layerCount == readCLast.GetValue()){
						isLastLayer = true;
						if (fp && debugLevel <= 2)
							fprintf(fp, "%d : %s set LastLayer\n", num, name.c_str());
						//outputAfterLast = true;
					}
					assert(frameCountDown.GetValue() != 0);
					frameCountDown = frameCountDown.GetValue() - 1;
					layerCount = layerCount.GetValue() + 1;
					if (fp && debugLevel <=2)
						fprintf(fp, "%d : %s increase layercount %d\n", num, name.c_str(), layerCount.GetValue());

					input_src = INPUT_BACKUP;

					outputReadPos = outputReadPos.GetValue() + 1;
				}
				else if (outputReadPos == outputBufH1.GetValue()){//starting next frame
					outputReadPos = 0;
					isInitLayer = false;
					//frameCountDown = frameCountDown.GetValue() - 1;
					//assert(!isPrefetchWeight.GetValue());
					if (!isLastLayer.GetValue()){
						if (frameCountDown == 0){
							frameCountDown = outputBufH1.GetValue();
							if (isLoadingNextFeatures.GetValue())
								usedWords_inc = prefetchFrameSize.GetValue();
						}
						else{
							frameCountDown = frameCountDown.GetValue() - 1;
						}
						sendBackUpInput(0);
						input_src = INPUT_BACKUP;
					}
				}
			}
			else{ //k > 1
				if (stride == 1){
					if (iterCountDown == 0){
						iterCountDown = k.GetValue() - 1;
						{
							if (outputReadPos == outputBufH1.GetValue() - 1){//starting next frame
								if (layerCount.GetValue() < readCLast.GetValue()){
									sendBackUpInput(0);
									isPrefetchNext = true;
								}
								input_src = INPUT_S;
								outputReadPos = outputReadPos.GetValue() + 1;
							}
							else if (outputReadPos == outputBufH1.GetValue()){//starting next frame
								isInitLayer = false;
								if (isLoadingNextFeatures.GetValue())
									usedWords_inc = prefetchFrameSize.GetValue();

								if (layerCount.GetValue() < readCLast.GetValue()){
									sendBackUpInput(k.GetValue() - 1);
									initWSteps = 0;
									initBMWSteps = 0;
									input_src = INPUT_BACKUP;
									nextWeight = true;

									if (layerCount == readCLast.GetValue() - 1){
										isPrefetchWeight = false;
										if (doBM.GetValue()){
											isPrefetchBMWeight = true;
											BMlen = GetBMWLen(usedGroups.GetValue(), 0);
										}
									}
									else{
										isPrefetchWeight = true;
										wlen = GetWLen(wtotal.GetValue(), 0, k.GetValue());
										if (wlen.GetNextValue() == wlen_regular.GetValue())
											wlenk = wlenk_regular.GetValue();
										else
											wlenk = wlenk_last.GetValue();
										assert(wlenk.GetNextValue() == wlen.GetNextValue() * k.GetValue());
									}
								}
								else if (layerCount == readCLast.GetValue()){
									isLastLayer = true;
									input_src = INPUT_NON;
								}
								layerCount = layerCount.GetValue() + 1;
								if (fp && debugLevel <=2)
									fprintf(fp, "%d : %s increase layercount %d (%d)\n", num, name.c_str(), layerCount.GetValue());
								outputReadPos = 0;
								isPrefetchNext = false;
							}
							else{
								input_src = INPUT_S;
								if (!isLastLayer.GetValue())
									sendBackUpInput(k.GetValue() - 1);
								outputReadPos++;
							}

						}
					}
					else{//iterCountDown > 0
						if (isPrefetchNext.GetValue()){
							int id = k.GetValue() - iterCountDown.GetValue();
							sendBackUpInput(id);
						}
						if (!isLastLayer.GetValue())
							input_src = INPUT_E;
						iterCountDown--;
					}
					return;
				}
				else{ //stride > 1
					if (iterCountDown == 0){
						iterCountDown = k.GetValue() - 1;
						input_src = INPUT_BACKUP;
						if (outputReadPos == outputBufH1.GetValue() - 1){//starting next frame
							if (layerCount.GetValue() < readCLast.GetValue()){
								sendBackUpInput(0);
							}
							else if (layerCount == readCLast.GetValue()){
								isLastLayer = true;
							}
							outputReadPos++;
						}
						else if (outputReadPos == outputBufH1.GetValue()){//starting next frame
							isInitLayer = false;
							if (isLoadingNextFeatures.GetValue())
								usedWords_inc = prefetchFrameSize.GetValue();
							if (this->name == DEBUG_BANK_NAME && layerCount == 6)
								name = name;
							if (layerCount.GetValue() < readCLast.GetValue()){
								sendBackUpInput(0);
							
								initWSteps = 0;
								initBMWSteps = 0;
								nextWeight = true;

								if (layerCount == readCLast.GetValue() - 1){
									isPrefetchWeight = false;
									if (doBM.GetValue()){
										isPrefetchBMWeight = true;
										BMlen = GetBMWLen(usedGroups.GetValue(), 0);
									}
								}
								else{
									isPrefetchWeight = true;
									wlen = GetWLen(wtotal.GetValue(), 0, k.GetValue());
									if (wlen.GetNextValue() == wlen_regular.GetValue())
										wlenk = wlenk_regular.GetValue();
									else
										wlenk = wlenk_last.GetValue();
									assert(wlenk.GetNextValue() == wlen.GetNextValue() * k.GetValue());
								}
							}
							else if (layerCount == readCLast.GetValue()){
								isLastLayer = true;
							}
							layerCount++;
							if (fp && debugLevel <=2)
								fprintf(fp, "%d : %s increase layercount %d (%d)\n", num, name.c_str(), layerCount.GetValue());
							outputReadPos = 0;
						}
						else{
							if (!isLastLayer.GetValue()){
								sendBackUpInput(0);
							}
							outputReadPos++;
						}
					}
					else{ //iterCountDown != 0
						if (!isLastLayer.GetValue()){
							int id = k.GetValue() - iterCountDown.GetValue();
							sendBackUpInput(id);
						}							
						input_src = INPUT_E;
						iterCountDown--;
					}
					return;
				}
			}
		}
		if (state == CONV_BM && !waiting_out.GetValue()){// after BM, start waiting out, and do not want to do BM again.
			if (/*ext_state == EWRS_BM ||*/ isPrefetchBMWeight.GetValue())
				return;
			if (name == DEBUG_BANK_NAME)
				name = name;
			if (isLReluInit.GetValue()){
				outputReadPos = 0;
				outputWritePos = 0;
				isLReluInit = false;
				startPrefetching(num);
				//assert(outputReadPos == 0);
				return;
			}
			if (bmPhase == 0){
				bmPhase = 1;
				if (outputReadPos.GetValue() != 0 || outputWritePos.GetValue() != 0){
					isOutputReady = true;
					
					if (outputWritePos == outputBufH1.GetValue()){
						//startPrefetching(num);
						if (doRelu.GetValue() || doLRelu.GetValue()){
							state = CONV_RELU;

							if (doLRelu.GetValue()){
								isLReluWeight = true;
							}
							isLReluInit = true;
							if (fp && debugLevel <= 3)
								fprintf(fp, "%d : %s start relu convbuffer(%d)\n", num, name.c_str(), convBuffers.GetValue());
						}
						else{
							if (name == DEBUG_BANK_NAME)
								name = name;
							startConvOut(num);
						}
						outputWritePos = 0;
					}
					else
						outputWritePos++;
				}
			}
			else{
				
				bmPhase = 0;
				if (outputReadPos == outputBufH1.GetValue()){
					outputReadPos = 0;
				}
				else{
					outputReadPos++;
				}
			}
			return;
		}
		if (state == CONV_RELU && !waiting_out.GetValue()){
			if (isLReluInit.GetValue()){
				isLReluInit = false;
				outputReadPos = 0;
				outputWritePos = 0;
				return;
			}
			//if (fp && debugLevel <=1)
			//	fprintf(fp, "%s start relu %d\n", name.c_str(), outputReadPos.GetValue());
			
			if (outputReadPos.GetValue() != 0){
				isOutputReady = true;
			}

			if (outputWritePos == outputBufH1Relu.GetValue()){
				startConvOut(num);
				isLReluWeight = false;
			}
			else if (outputReadPos.GetValue() != 0){
				outputWritePos++; // at latch stage
			}
			if (outputReadPos.GetValue() < outputBufH1Relu.GetValue() ) // not really needed
				outputReadPos++;
			return;
		}
	
}


void CHomoGeneousComputingBank::startPrefetching(int num)
{
	startprefetching = true;
	initWSteps = 0;
	initFSteps = 0;
	if (name == DEBUG_BANK_NAME)
		name = name;
	outputBufH1Relu = outputBufH1.GetValue();
	addrNextAssemble = 0;
	addrNextFrame = prefetchFrameSize.GetValue();
	addrCurAssemble = 0;
	atmpSize = 0;
	//ab0Filled = 0;
	//ab1Filled = 0;
	assemble_buffer.reset();
	assert(inputs_buffer.IsEmpty());
	//inputs_buffer.reset();
	//assemble_buffer0.reset();
	//assemble_buffer1.reset();
	//ab0Write = 0;
	//ab0Read = 0;
	rowAddr = -int(topPad.GetValue());
#ifdef S2_OPTIMIZE	
	kIter == k.GetValue() - 1;
	s2b_start = 0;
	s2b_end = 0;
	s2b_cur = 0;
	s2b_lastAddr = -1;
	rowCounts = 0;
	nextRowStart = stride.GetValue() - topPad.GetValue();
#endif
	assert(input_fifo.size() == 0);

	//outputIdxMax = usedCG.GetValue();
	if (kCur.GetValue() < kCurLast.GetValue()){
		kCur += numGroups.GetValue() + Ks.GetValue();
		if (kCur.GetValue() == kCurLast_1.GetValue()){
			usedGroups = usedGroupsLast.GetValue();
			wtotal = wtotalLast.GetValue();
			wlenk_last = wlenk_nLast2.GetValue();
			wlen = GetWLen(wtotalLast.GetValue(), 0, k.GetValue());
			if (wlen.GetNextValue() == wlen_regular.GetValue())
				wlenk = wlenk_regular.GetValue();
			else
				wlenk = wlenk_nLast2.GetValue();
			assert(wlenk.GetNextValue() == wlenkLast.GetValue());
#ifdef BATCH1_OPTIMIZE
			if (!doBatch3K1.GetValue())
#endif
			{
				isLoadingNextFeatures = true;
				isLoadingFroze = true;
				usedWords_reset = true;
				assert(!hasNextFeatureParams.GetValue());
			}
		}
		else{
			usedGroups = numGroups.GetValue();
			wtotal = wtotal_n.GetValue();
			wlen = GetWLen(wtotal_n.GetValue(), 0, k.GetValue());
			wlenk_last = wlenk_nLast.GetValue();
			if (wlen.GetNextValue() == wlen_regular.GetValue())
				wlenk = wlenk_regular.GetValue();
			else
				wlenk = wlenk_nLast.GetValue();
			assert(wlenk.GetNextValue() == wlenk_n.GetValue());
			assert(wlenk_last.GetValue() == wlenk_last.GetNextValue());
		}
		
		isPrefetchNextVolume = true;
		doAssemble = true;
		assert(isNextVolumeReady == false);

		iLayers = 0;
		reset_iLayers = true;
		if (fp && debugLevel <=3)
			fprintf(fp, "%d : %s next Kh %d weight used %d\n", num, name.c_str(), kCur.GetNextValue(), weightUsed);
		//ext_state = EWRS_BM;
		//assert(resFrameCount == 0);
		//assert(resRowCount == 0);
		
	}
#ifdef BATCH1_OPTIMIZE
	else if (doBatch3K1.GetValue()){
		if (!doBatch3K1_cur.GetValue()){
			doBatch3K1_cur = true;
			kCur = kbh.GetValue();
			readWidth = readWidth.GetValue() * 3;
			maxRowCount = readRowCount3.GetValue();
			lastLen = lastRowLen3.GetValue();
			if (fp && debugLevel <= 1 && name == DEBUG_BANK_NAME)
				fprintf(fp, "%s maxRowCount %d (%d)\n", name.c_str(), maxRowCount.GetNextValue(), lastLen.GetNextValue());

			assert(curRowCount == 0);
		}
		else
			kCur += numGroups.GetValue() / 3;
		
		outputBufH1 = batchSize.GetValue() - 1;
		rowNum = batchSize.GetValue();
		if (batch_only_1group.GetValue() && !doBatch3K1_cur.GetValue() 
			|| !batch_only_1group.GetValue() && kCur.GetValue() <= kbe_1.GetValue()){
			//if ((kbe.GetValue() + 1 - kCur.GetNextValue()) <= numGroups.GetValue()/3){
			if (batch_only_1group.GetValue() || kCur.GetValue() == kbe_1.GetValue()){
				isLoadingNextFeatures = true;
				isLoadingFroze = true;
				usedWords_reset = true;
				assert(!hasNextFeatureParams.GetValue());
				usedGroups = wtotalbLast.GetValue();
				wtotal = wtotalbLast.GetValue();
				wlen = GetWLen(wtotalbLast.GetValue(), 0, k.GetValue());
				wlenk_last = wlenk_bLast2.GetValue();
				if (wlen.GetNextValue() == wlen_regular.GetValue())
					wlenk = wlenk_regular.GetValue();
				else
					wlenk = wlenk_bLast2.GetValue();

				assert(wlenk.GetNextValue() == wlenkbLast.GetValue());
			}
			else{
				usedGroups = wtotal_bn.GetValue();
				wtotal = wtotal_bn.GetValue();
				wlen = GetWLen(wtotal_bn.GetValue(), 0, k.GetValue());
				wlenk_last = wlenk_bLast.GetValue();
				if (wlen.GetNextValue() == wlen_regular.GetValue())
					wlenk = wlenk_regular.GetValue();
				else
					wlenk = wlenk_bLast.GetValue();

				assert(wlenk.GetNextValue() == wlenk_bn.GetValue());
			}

			isPrefetchNextVolume = true;
			doAssemble = true;
			assert(isNextVolumeReady == false);
			iLayers = 0;
			if (fp && debugLevel <= 3)
				fprintf(fp, "%d : %s next Kh %d weight used %d b3\n", num, name.c_str(), kCur.GetNextValue(), weightUsed);
			//ext_state = EWRS_BM;
			//assert(resFrameCount == 0);
			//assert(resRowCount == 0);

		}

	}
#endif
}

void CHomoGeneousComputingBank::StartDumpVerifyStartConvOut()
{
	start_conv_out = true;
	if (!fsoi)
		return;
	fprintf(fsoi, " 1 %d %d %d %d %d %d %d", isNextVolumeReady.GetValue(), isPrefetchNextVolume.GetNextValue()
		, isPrefetchNextVolume.GetValue(), kt.GetValue(), Ks.GetValue()
		, numGroups.GetValue(), k.GetValue());
	fprintf(fsoi, " %d %d %d %d %d %d %d", doRes.GetValue(), doUpSample.GetValue()
		, outputBufW1.GetValue(), outFrameSize.GetValue(), outW.GetValue()
		, outputAddrGap.GetValue(), maxpool_stride.GetValue());
	fprintf(fsoi, " %d %d %d %d %d", curSeq.GetValue(), newWriteInst.GetValue()
		, outputBufH1Orig.GetValue(), outputAddr.GetValue()
		, outputFrameStart.GetValue());
	fprintf(fsoi, " %d %d %d", usedCGLast.GetValue(), usedCG0.GetValue(), kCurLast.GetValue());
}

void CHomoGeneousComputingBank::startConvOut(int num)
{// handle res(shortcut) and upsample
	StartDumpVerifyStartConvOut();
	if (isOnOutput.GetValue()){// || resBuf.size() < resSize.GetValue()){
		if (name == DEBUG_BANK_NAME)
			name = name;
		waiting_out = true;
	}
	else{
		waiting_out = false;
		if (isNextVolumeReady.GetValue()){
			if (state.GetValue() != CONV_START)
				state = CONV_START;
		}
		else{
			if (!isPrefetchNextVolume.GetValue() && !isPrefetchNextVolume.GetNextValue()){ // prefetch may start same cycle
				if (name == DEBUG_BANK_NAME)
					name = name;
				isLastOutput = true;
				set_LastOutput = true;
				loadNextInst = true;
				assert(outBufferUseCount == 1);
			}
			state = CONV_OUT;
		}
		if (name == DEBUG_BANK_NAME)
			name = name;
		if (fp && debugLevel <=3)
			fprintf(fp, "%d : switchout %s outbuffers %d\n", num, name.c_str(), outBuffers.GetValue());
		
		cgSwitchOutput = true;
		isOnOutput = true;
#ifdef BATCH1_OPTIMIZE
		doBatch3K1_out = outBatch3.Pop();
		if (doBatch3K1_out.GetNextValue()){
			if (!doBatch3K1_out.GetValue())
				kOut = kbh.GetValue();
			else
				kOut += numGroups.GetValue() / 3;
			//if ((kbe.GetValue() + 1 - kOut.GetNextValue()) <= numGroups.GetValue()/3){
			if (batch_only_1group.GetValue() && !doBatch3K1_out.GetValue()
				|| !batch_only_1group.GetValue() && kOut.GetValue() == kbe_1.GetValue())
			{
				outputIdxMax = wtotalbLast.GetValue() * 3;
			}
			else{
				outputIdxMax = numGroups.GetValue() ;
			}

		}
		else
#endif
		{
			if (kOut.GetValue() == kCurLast.GetValue()){
				//outputIdxMax = usedGroupsLast.GetValue() * k.GetValue();
				outputIdxMax = usedCGLast.GetValue();
			}
			else{
				//outputIdxMax = numGroups.GetValue() * k.GetValue();
				outputIdxMax = usedCG0.GetValue();
			}
			kOut += numGroups.GetValue() + Ks.GetValue();
		}
		set_out_params = true;
		doRes_out = doRes.GetValue();
		outputBufW1_out = outputBufW1.GetValue();
		if (doUpSample.GetValue())
			outW_out2 = outW.GetValue() - outputBufW1.GetValue();
		doUpSample_out = doUpSample.GetValue();
		//outW1_out = outW1.GetValue();
		
		outFrameSize_out = outFrameSize.GetValue();
		outW_out = outW.GetValue();
		outputAddrGap_out = outputAddrGap.GetValue();
		k_out = k.GetValue();
		curSeq_out = curSeq.GetValue();
		
		newWriteInst_out = newWriteInst.GetValue();
		outputBufH1_out = outputBufH1Orig.GetValue();
		maxpool_stride_out = maxpool_stride.GetValue();
#ifdef BATCH1_OPTIMIZE
		batchIdx = 0;
		assert(outputRowsBatch == 0);

		if (doBatch3K1_out.GetNextValue() && !doBatch3K1_out.GetValue()){
			outputAddr_out = batchAddr.GetValue();
			outputFrameStart_out = batchAddr.GetValue();
		}
		else

#endif
		{
			outputAddr_out = outputAddr.GetValue();
			outputFrameStart_out = outputFrameStart.GetValue();
		}
		assert(outputCGIdx0 == 0);
		assert(outputRows == 0);
		assert(outputCGIdx == 0);
		assert(outputUPSteps == 0);
	}
}

void CHomoGeneousComputingBank::StartDumpVerifyProcessConvOut(int num)
{
	if (!fpoi || !fpoo)
		return;
	fprintf(fpoi, "%d", num + 1);
	fprintf(fpoo, "%d", num);

	fprintf(fpoi, " %d %d %d %d %d %d %d", state.GetValue(), isRunning.GetValue()
		, isOnOutput.GetValue(), pwrite->IsWritable(id.GetValue())
		, resBuf.size() < outputBufW1_out.GetValue()
		, doRes_out.GetValue(), doUpSample_out.GetValue());

	fprintf(fpoi, " %d %d %d %d %d %d %d", outputBufW1_out.GetValue(), outFrameSize_out.GetValue()
		, outW_out.GetValue(), outW_out2.GetValue(), maxpool_stride_out.GetValue()
		, outputAddrGap_out.GetValue(), k_out.GetValue());

	fprintf(fpoi, " %d %d %d %d %d %d %d\n", curSeq_out.GetValue(), newWriteInst_out.GetValue()
		, outputBufH1_out.GetValue(), outputIdxMax.GetValue()
		, new_conv_inst, outputAddr.GetNextValue(), outputFrameStart.GetNextValue());

	if (isOnOutput.GetValue()){
		for (int i = 0; i < CG_NUM; i++){
			DTYPE bus[COMPUTING_GROUP_SIZE];
			cgs[i]->GetOutput(bus, outputBufW1_out.GetValue(), outputRows.GetValue());
			for (int j = 0; j < COMPUTING_GROUP_SIZE; j++)
				fprintf(fpoi, " %d", bus[j]);
			fprintf(fpoi, "\n");
		}
	}
	
}
void CHomoGeneousComputingBank::FinishDumpVerifyProcessConvOut()
{
	if (!fpoi || !fpoo)
		return;
	if (!resfifo_ren)
		fprintf(fpoi, " 0");
	fprintf(fpoi, " %d %d %d %d\n", set_LastOutput, set_out_params
		, outputAddr_out.GetNextValue(), outputFrameStart_out.GetNextValue());

	if (!pwrite_enable)
		fprintf(fpoo, " 0");

	fprintf(fpoo, "\n %d %d %d %d", outputCGIdx.GetValue(), outputCGIdx0.GetValue()
		, outputFrameStart_out.GetValue(), outputUPSteps.GetValue());
	fprintf(fpoo, " %d %d %d %d %d %d %d\n", resfifo_ren, pwrite_setNextInst
		, outputRows.GetValue(), reset_state, outputAddr.GetValue()
		, outputFrameStart.GetValue(), reset_isOnOutput);
}

void CHomoGeneousComputingBank::dumpVerifyProcessConvOutData(DTYPE *buf, unsigned addr)
{
	pwrite_enable = true;
	if (fpoo){
		fprintf(fpoo, " 1 %d %d", addr, outputBufW1_out.GetValue());
		for (int i = 0; i < COMPUTING_GROUP_SIZE; i++)
			fprintf(fpoo, " %d", buf[i]);
	}
	else if (fhcbo){
		fprintf(fhcbo, " 1 %d %d", addr, outputBufW1_out.GetValue());
		for (int i = 0; i < COMPUTING_GROUP_SIZE; i++)
			fprintf(fhcbo, " %d", buf[i]);
		fprintf(fhcbo, "\n");
	}
}
void CHomoGeneousComputingBank::dumpVerifyProcessConvOutRes(DTYPE *buf)
{
	resfifo_ren = true;
	if (!fpoi)
		return;
	fprintf(fpoi, " %d", COMPUTING_GROUP_SIZE);
	for (int i = 0; i < COMPUTING_GROUP_SIZE; i++)
		fprintf(fpoi, " %d", buf[i]);
}

void CHomoGeneousComputingBank::processConvOut(int num)
{// handle res(shortcut) and upsample
	if (!isOnOutput.GetValue()){
		if(waiting_out.GetValue())
			startConvOut(num);
		return;
	}
	if (isNextVolumeReady.GetValue()){
		if (state == CONV_OUT)
			state = CONV_START;
	}
	//if (pwr->GetToken() != id.GetValue())
	//	return;
	if (!pwrite->IsWritable(id.GetValue()))
		return;
	if (doRes_out.GetValue() && resBuf.size() < outputBufW1_out.GetValue())
		return;
	if (name == DEBUG_BANK_NAME)
		name = name;
	on_output = true;
	DTYPE bus[COMPUTING_GROUP_SIZE];
	//if (outputUPSteps == 0){
#ifdef BATCH1_OPTIMIZE
		if (doBatch3K1_out.GetValue())
			cgs[outputCGIdx.GetValue()]->GetOutput(bus, outputBufW1_out.GetValue(), outputRowsBatch.GetValue());
		else
#endif
			cgs[outputCGIdx.GetValue()]->GetOutput(bus, outputBufW1_out.GetValue(), outputRows.GetValue());
		//toDo : move to latch		
	//}
	if (fp && debugLevel <=1)
		fprintf(fp, "%s output cg %d, row %d, ups %d\n", name.c_str(), outputCGIdx.GetValue(),
#ifdef BATCH1_OPTIMIZE
		doBatch3K1_out.GetValue()?outputRowsBatch.GetValue(): 
#endif
		outputRows.GetValue(), outputUPSteps.GetValue());
	if (doUpSample_out.GetValue()){
		DTYPE bufsave[2 * COMPUTING_GROUP_SIZE];
		if (outputUPSteps == 0){

			for (int i = 0; i < 2 * COMPUTING_GROUP_SIZE; i++){
				bufsave[i] = bus[i >> 1];
			}
			resOutBuf.SetValue(bufsave, 0, 2 * COMPUTING_GROUP_SIZE);
		}
		if (outputUPSteps == 0){
			pwrite->WriteData(bufsave, id.GetValue(), outputAddr_out.GetValue());
			dumpVerifyProcessConvOutData(bufsave, outputAddr_out.GetValue());
			outputAddr_out += outputBufW1_out.GetValue();
			if (fp && debugLevel <= 1){
				fprintf(fp, "  output addr %d, len %d, (", outputAddr_out.GetValue(), outputBufW1_out.GetValue());
				for (unsigned j = 0; j < outputBufW1_out.GetValue(); j++)
					fprintf(fp, "%s"DFMT, j == 0 ? "" : ", ", bufsave[j]);
				fprintf(fp, ")\n");
			
			}
		}
		else if (outputUPSteps == 2){
			DTYPE buf[COMPUTING_GROUP_SIZE];
			resOutBuf.GetValue(buf, 0, outputBufW1_out.GetValue());
			pwrite->WriteData(buf, id.GetValue(), outputAddr_out.GetValue());
			dumpVerifyProcessConvOutData(buf, outputAddr_out.GetValue());
			outputAddr_out += outputBufW1_out.GetValue();
			if (fp && debugLevel <= 1){
				fprintf(fp, "  output addr %d, len %d, (", outputAddr_out.GetValue(), outputBufW1_out.GetValue());
				for (unsigned j = 0; j < outputBufW1_out.GetValue(); j++)
					fprintf(fp, "%s"DFMT, j == 0 ? "" : ", ", buf[j]);
				fprintf(fp, ")\n");

			}
		}
		else{
			DTYPE buf[COMPUTING_GROUP_SIZE];
			resOutBuf.GetValue(buf, outputBufW1_out.GetValue(), outputBufW1_out.GetValue());
			pwrite->WriteData(buf, id.GetValue(), outputAddr_out.GetValue());
			dumpVerifyProcessConvOutData(buf, outputAddr_out.GetValue());
			if (fp && debugLevel <= 1){
				fprintf(fp, "  output addr %d, len %d, (", outputAddr_out.GetValue(), outputBufW1_out.GetValue());
				for (unsigned j = 0; j < outputBufW1_out.GetValue(); j++)
					fprintf(fp, "%s"DFMT, j == 0 ? "" : ", ", buf[j]);
				fprintf(fp, ")\n");

			}
			if (outputRows == outputBufH1_out.GetValue() && outputUPSteps == 3 ){//toDo : move to latch
				//&& (!doBatch3K1_out.GetValue() || batchIdx == 0)){
					outputAddr_out = outputFrameStart_out.GetValue() + outFrameSize_out.GetValue();
					outputFrameStart_out += outFrameSize_out.GetValue();
			}else
				//outputAddr_out += outW_out.GetValue() - outputBufW1_out.GetValue();
				outputAddr_out += outW_out2.GetValue();
		}
		
		
	}
	else{
		if (doRes_out.GetValue()){
			DTYPE buf[COMPUTING_GROUP_SIZE];
			popRes = true;
			for (unsigned i = 0; i < outputBufW1_out.GetValue(); i++)
				buf[i] = resBuf.Pop();
			dumpVerifyProcessConvOutRes(buf);
			for (unsigned i = 0; i < outputBufW1_out.GetValue(); i++)
				bus[i] += buf[i];
		}
		pwrite->WriteData(bus, id.GetValue(), outputAddr_out.GetValue());
		dumpVerifyProcessConvOutData(bus, outputAddr_out.GetValue());
		if (fp && debugLevel <= 1){
			fprintf(fp, "  output addr %d, len %d, (", outputAddr_out.GetValue(), outputBufW1_out.GetValue());
			for (unsigned j = 0; j < outputBufW1_out.GetValue(); j++)
				fprintf(fp, "%s"DFMT, j == 0 ? "" : ", ", bus[j]);
			fprintf(fp, ")\n");
			/*fprintf(fp, "# outputs %s %d", name.c_str(), outputAddr_out.GetValue());
			for (unsigned j = 0; j < outputBufW1_out.GetValue(); j++)
				fprintf(fp, " "DFMT, bus[j]);
			fprintf(fp, "\n");*/

		}
		if (outputRows == outputBufH1_out.GetValue() ){//toDo : move to latch
			//&& (!doBatch3K1_out.GetValue() || batchIdx == 0)){
				outputAddr_out = outputFrameStart_out.GetValue() + outFrameSize_out.GetValue();
				outputFrameStart_out += outFrameSize_out.GetValue();
		}
		else if ((maxpool_stride_out.GetValue() != 2) || (outputRows.GetValue() & 1))
			outputAddr_out += outW_out.GetValue();
	}
	if (!doUpSample_out.GetValue() || outputUPSteps == 3){
		if (outputRows == outputBufH1_out.GetValue() ){
			outputRows = 0;
			int ek;
#ifdef BATCH1_OPTIMIZE
			ek = (doBatch3K1_out.GetValue() ? 3 : k_out.GetValue());
#else
			ek = k_out.GetValue();
#endif
			if (outputCGIdx0.GetValue() + ek >= outputIdxMax.GetValue()){
				outputCGIdx = 0;
				outputCGIdx0 = 0;
#ifdef BATCH1_OPTIMIZE
				outputRowsBatch = 0;
#endif
				workingProgress = kOut.GetValue();
				//if (!doBatch3K1_out.GetValue() || batchIdx == 0)
					assert(outputAddr_out.GetNextValue() == outputFrameStart_out.GetNextValue());

				if (isLastOutput.GetValue()){
					if (state == CONV_OUT && !state.IsSetted()){ 
						//!new_conv_inst, if res data is a bottleneck, we will reach here the same time as new_conv_inst
						state = IDLE;
						reset_state = true;
					}
					finishSeq = curSeq_out.GetValue();
					isLastOutput = false;
					//if (isProgressMaster.GetValue())
					if (newWriteInst_out.GetValue()){
						pwrite_setNextInst = true;
						pwrite->SetNextInst(id.GetValue());
					}
					if (fp && debugLevel <=3)
						fprintf(fp, "%d : %s finishseq %d\n", num, name.c_str(), finishSeq.GetNextValue());
					/*if (name == DEBUG_BANK_NAME)
						printf("finish seq %d %d\n", curSeq_out.GetValue(), num);*/
				}
#ifdef BATCH1_OPTIMIZE
				else if (doBatch3K1_out.GetValue()){
					outputAddr = outputFrameStart_out.GetNextValue();
					outputFrameStart = outputFrameStart_out.GetNextValue();
				}
#endif
				else{
					outputAddr = outputFrameStart_out.GetNextValue() + outputAddrGap_out.GetValue();
					outputFrameStart = outputFrameStart_out.GetNextValue() + outputAddrGap_out.GetValue();
				}

				//else
				//	ext_state = EWRS_BM;
				isOnOutput = false;
				reset_isOnOutput = true;
				outBufferUseCount = outBufferUseCount.GetNextValue() - 1; //may change same cycle
				if (fp && debugLevel <=3)
					fprintf(fp, "%d : output done, buffer count %d, %s outbuffers %d\n", num
					, outBufferUseCount.GetNextValue(), name.c_str(), outBuffers.GetValue());
				outBuffers++;
				if (name == DEBUG_BANK_NAME)
					name = name;
			}
			else{
				outputCGIdx0 = outputCGIdx0.GetValue() + ek;
				outputCGIdx  = outputCGIdx0.GetValue() + ek;
#ifdef BATCH1_OPTIMIZE
				outputRowsBatch = 0;
				batchIdx = 0;
#endif
			}
		}
		else{
			outputRows++;
#ifdef BATCH1_OPTIMIZE
			if (doBatch3K1_out.GetValue()){
				if (batchIdx == 2){
					batchIdx = 0;
					outputCGIdx = outputCGIdx0.GetValue();
					outputRowsBatch++;
				}
				else{
					batchIdx++;
					outputCGIdx++;
				}
			}
#endif
		}

	}
	if (doUpSample_out.GetValue()){//toDo : move to latch
		if (outputUPSteps == 3)
			outputUPSteps = 0;
		else
			outputUPSteps++;
	}
}
void CHomoGeneousComputingBank::SetupShiftInputs(int num)
{
	if (fsii){
		fprintf(fsii, "%d %d %d", num + 1, input_src, k.GetValue());
		for (unsigned i = 0; i < MAX_K; i++){
			for (int j = 0; j < MAX_SHIFT_SIZE; j++){
				fprintf(fsii, " %d", shiftBufBackup[i][j].GetValue());
			}
		}
		fprintf(fsii, "\n");
	}
	for (unsigned i = 0; i < k.GetValue(); i++){
		shiftInputs[i] = shiftBuf[i][0].GetValue();
	}
	if (fsio){
		bool cmp = (state.GetValue() != IDLE) && (state.GetValue() != CONV_INIT) && (state.GetValue() != CONV_START);
		unsigned len = k.GetValue(); // leftPad.GetValue() + rightPad.GetValue();
		fprintf(fsio, "%d %d %d", num, cmp, len);
		for (unsigned i = 0; i < len; i++)
			fprintf(fsio, " %d", shiftInputs[i]);
		fprintf(fsio, "\n");
	}
	if (input_src == INPUT_BACKUP){
		for (unsigned i = 0; i < k.GetValue(); i++){
			for (int j = 0; j < MAX_SHIFT_SIZE; j++){
				shiftBuf[i][j] = shiftBufBackup[i][j].GetValue();
				shiftBufShift[i][j] = shiftBufBackup[i][j].GetValue();
			}
		}
		if (fp && debugLevel <= 1 && name == DEBUG_BANK_NAME){
			fprintf(fp, "INPUT_BACKUP %s\n", name.c_str());
		}
	}
	else if (input_src == INPUT_S){
		for (int i = 0; i < MAX_K; i++){
			for (int j = 0; j < MAX_SHIFT_SIZE; j++){
				if (i == k.GetValue() - 1){
					shiftBuf[i][j] = shiftBufBackup[i][j].GetValue();
					shiftBufShift[i][j] = shiftBufBackup[i][j].GetValue();
				}
				else{
					shiftBuf[i][j] = shiftBufShift[i + 1 < MAX_K ? i + 1 : 0][j].GetValue();
					shiftBufShift[i][j] = shiftBufShift[i + 1 < MAX_K ? i + 1 : 0][j].GetValue();
				}
			}
		}
		if (fp && debugLevel <= 1 && name == DEBUG_BANK_NAME){
			fprintf(fp, "INPUT_S %s\n", name.c_str());
		}
	}
	else if (input_src == INPUT_E){
		for (unsigned i = 0; i < k.GetValue(); i++){
			//shiftInputs[i] = shiftBuf[i][0].GetValue();
			for (int j = 0; j < MAX_SHIFT_SIZE - 1; j++)
				shiftBuf[i][j] = shiftBuf[i][j + 1].GetValue();
		}
		if (fp && debugLevel <= 1 && name == DEBUG_BANK_NAME){
			for (unsigned i = 0; i < k.GetValue(); i++){
				fprintf(fp, "\t"DFMT"", shiftInputs[i]);
			}
			fprintf(fp, "shift %s\n", name.c_str());
		}
		
	}
}

//void CHomoGeneousComputingBank::sendBackUpInput0(int id)
//{
//	//if (nextBackupAddr.GetValue() >= volumeSize.GetValue())
//	//	return;
//	memset(backupBus, 0, sizeof(DTYPE) * COMPUTING_GROUP_SIZE * 2);
//	isBackupValid = true;
//	backupId = id;
//	//if (leftPad.GetValue() + rightPad.GetValue() > 0)
//	for (int i = 0; i < MAX_SHIFT_SIZE; i++)
//		shiftBufBackup[id][i] = 0;
//
//	assert(input_fifo.size() > 0);
//	DTYPE *buf = input_fifo.Pop();
//	for (int i = 0; i < COMPUTING_GROUP_SIZE * 2; i++)
//		if (buf[i] != 0 && i <readWidth.GetValue()){
//			fprintf(fp, "%s", name.c_str());
//			for (int j = 0; j < readWidth.GetValue(); j++)
//				fprintf(fp, " "DFMT"", buf[j]);
//			fprintf(fp, " supposed to be all 0, s %d\n", input_fifo.size());
//			fflush(fp);
//			assert(false);
//		}
//	palloc->Free((char *)buf);
//	
//	if (fp && debugLevel <=1)
//		fprintf(fp, "\t%s send backup 0 %d\n", name.c_str(), id);
//}
void CHomoGeneousComputingBank::sendBackUpInput(int id)
{
	sendBackUpInput_valid = true;
	if (input_fifo.size() == 0){
		is_input_fifo_empty = true;
		if (fp && debugLevel <= 1){
			fprintf(fp, "%s no data for id %d\n", name.c_str(), id);
		}
		if (fsbo && fsbi){
			fprintf(fsbi, " 1 1");
			fprintf(fsbo, " 0 0");
		}
		return;
	}

	unsigned arraySize =  COMPUTING_GROUP_SIZE;
	if (fsbi)
		fprintf(fsbi, " 1 0 %d", id);
	if(fsbo)
		fprintf(fsbo, " 1 1");
#ifdef S2_OPTIMIZE
	if (isStride2.GetValue())
		arraySize = 2 * COMPUTING_GROUP_SIZE;
#endif
#ifdef BATCH1_OPTIMIZE
	if (doBatch3K1_cur.GetValue()){
		arraySize = 3 * COMPUTING_GROUP_SIZE;
	}
#endif
	DTYPE *buf = input_fifo.Pop();
	inputfifo_ren = true;
	if (fsbi)
		for (int i = 0; i < INPUT_MEM_WIDTH; i++)
			fprintf(fsbi, " %d", buf[i]);
	unsigned len;
	unsigned limit;
	if (readWidth.GetValue() + leftPad.GetValue() <= arraySize){
		len = readWidth.GetValue() + leftPad.GetValue();
		limit = 0;
	}
	else{
		len = arraySize;
		limit = readWidth.GetValue() + leftPad.GetValue() - arraySize;
	}
	//for (int i = 0; i < arraySize; i++)
	for (unsigned i = 0; i < arraySize; i++)
		if (i < len && i >= leftPad.GetValue())
			backupBus[i] = buf[i - leftPad.GetValue()];
		else 
			backupBus[i] = 0;


	for (unsigned i = 0; i < MAX_SHIFT_SIZE; i++)
		if (i < limit)
			shiftBufBackup[id][i] = buf[i + arraySize - leftPad.GetValue()];
		else
			shiftBufBackup[id][i] = 0;

	palloc->Free((char *)buf);

	if (fp && debugLevel <= 1){
		if (name == DEBUG_BANK_NAME){
			fprintf(fp, "\t%s backup id %d:", name.c_str(), id);
			for (unsigned i = 0; i < arraySize; i++)
				fprintf(fp, " "DFMT"", backupBus[i]);
			fprintf(fp, "\n");
		}
		else
			fprintf(fp, "\t%s send Backup %d, ("DFMT", "DFMT")\n", name.c_str(),
			id, backupBus[0], backupBus[1]);
	}
	if (fsbo){
		fprintf(fsbo, " %d", arraySize);
		unsigned i, j;
		for (i = 0; i < arraySize; i++)
			fprintf(fsbo, " %d", backupBus[i]);
		for (i = 0; i < MAX_K; i++)
			for (j = 0; j < MAX_SHIFT_SIZE; j++)
				fprintf(fsbo, " %d", shiftBufBackup[i][j].GetValue());
	}

	isBackupValid = true;
	backupId = id;
}

bool CHomoGeneousComputingBank::sendBMWeights(int id, int len)
{
	assert(WEIGHT_BUS_SIZE >= len * BM_NUM);
	//extWeightOutBuf.GetData(bmWeightBus, len * 2);
	DTYPE bus[WEIGHT_BUS_SIZE];
	bool ret = weightOutBuf.GetData(bus, len * BM_NUM);
	popBM = ret;
	for (int i = 0; i < len * BM_NUM; i++)
		weightBus[i] = bus[i];
	weightUsed += len * BM_NUM;
	isBMWeightValid = true;
	weightId = id;
	bmweights_len = len * BM_NUM;
	if (fp && debugLevel <=1)
		fprintf(fp, "\t%s send BMWeight %d(%d), ("DFMT", "DFMT") ("DFMT", "DFMT") \n", name.c_str(),
		id, len, weightBus[0].GetNextValue(), weightBus[1].GetNextValue()
		, weightBus[2].GetNextValue() >> 4, weightBus[2].GetNextValue() & 0xf);
	return ret;
}

void CHomoGeneousComputingBank::writeVerificationWeight(int num)
{
	fprintf(fwti, "%d %d %d %d %d", num + 1, isWeightValid.GetNextValue(), wlenk.GetValue(), isBMWeightValid.GetNextValue(), BMlen.GetValue());

	fprintf(fwto, "%d %d %d %d %d %d %d", num, isWeightValid.GetNextValue(), isBMWeightValid.GetNextValue(), weightOutBuf.GetNumBuf()
		, 0, wlenk.GetValue(), BMlen.GetValue() * BM_NUM);
	if (isWeightValid.GetNextValue())
		for (unsigned i = 0; i < wlenk.GetValue() ; i++)
			fprintf(fwto, " %d", weightBus[i].GetNextValue());
	if (isBMWeightValid.GetNextValue())
		for (unsigned i = 0; i < BMlen.GetValue() * BM_NUM; i++)
			fprintf(fwto, " %d", weightBus[i].GetNextValue());
	assert(!(isWeightValid.GetNextValue() && isBMWeightValid.GetNextValue()));
}

void CHomoGeneousComputingBank::sendWeights(int id, int len)
{
	if (fp && debugLevel <=1)
		fprintf(fp, "\t%s send Weight %d(%d) ", name.c_str(), id, len);
	assert(WEIGHT_BUS_SIZE >= len);
	DTYPE bus[WEIGHT_BUS_SIZE];
	weightOutBuf.GetData(bus, len);
	for (int i = 0; i < len; i++){
		weightBus[i] = bus[i];
		assert((bus[i] < (1 << 11)) && (bus[i] >= -(1 << 11)));

	}
	if (fp && debugLevel <= 1){
		for (int i = 0; i < len; i++){ // or 4
			fprintf(fp, " "DFMT"", weightBus[i].GetNextValue());
		}
		fprintf(fp, " nb %d\n", weightOutBuf.GetNumBuf());
	}
	weightUsed += len;
	isWeightValid = true;
	weightId = id;
	weights_len = len;
	if (fp && debugLevel <=1)
		fprintf(fp, "\n");
}


void CHomoGeneousComputingBank::ReadResData(int num)
{
	num = num;
	if (idxRes.GetValue() != 0){//assume C*H%4 = 0 for MODE_FOUR
		DTYPE *ptr = resReceiveBuf + outputBufW1.GetValue() * (idxRes.GetValue() - 1);
		for (unsigned i = 0; i < outputBufW1.GetValue(); i++, ptr++){
			resBuf.Push(*ptr);
			if (name == DEBUG_BANK_NAME && fp && debugLevel <= 1)
				fprintf(fp, " "DFMT"", *ptr);
		}
		receivedRes += outputBufW1.GetValue();
		if (mode == MODE_TWO || idxRes.GetValue() == idxResMax.GetValue())
			idxRes = 0;
		else
			idxRes++;
		if (name == DEBUG_BANK_NAME && fp && debugLevel <= 1)
			fprintf(fp, " Res (%d)\n", receivedRes.GetNextValue());
	}
	else
	{
		if (!res_received_data.empty()){
			DTYPE *buf = res_received_data.front();
			res_received_data.pop();
			unsigned len = res_received_len.front();
			res_received_len.pop();
			requestingRes = false;
			if (mode == MODE_ONE){
				DTYPE *ptr = buf + resPos.GetValue();
				for (unsigned i = 0; i < outputBufW1.GetValue(); i++, ptr++){
					resBuf.Push(*ptr);
					if (name == DEBUG_BANK_NAME && fp && debugLevel <= 1)
						fprintf(fp, " "DFMT"", *ptr);
				}
				receivedRes += outputBufW1.GetValue();
			}
			else if (mode == MODE_TWO){
				DTYPE *ptr = buf + resPos.GetValue();
				for (unsigned i = 0; i < outputBufW1.GetValue(); i++, ptr++){
					resBuf.Push(*ptr);
					if (name == DEBUG_BANK_NAME && fp && debugLevel <= 1)
						fprintf(fp, " "DFMT"", *ptr);
				}

				if (len == outputBufW1.GetValue() * 4){
					ptr = buf + outputBufW1.GetValue() * 2 + resPos.GetValue();
					for (unsigned i = 0; i < outputBufW1.GetValue(); i++, ptr++){
						resReceiveBuf[i] = *ptr;
					}
					idxRes = 1;
				}
				receivedRes += outputBufW1.GetValue();
			}
			else{
				DTYPE *ptr = buf;
				for (unsigned i = 0; i < outputBufW1.GetValue(); i++, ptr++){
					resBuf.Push(*ptr);
					if (name == DEBUG_BANK_NAME && fp && debugLevel <= 1)
						fprintf(fp, " "DFMT"", *ptr);
				}

				ptr = buf + outputBufW1.GetValue();
				for (unsigned i = 0; i < outputBufW1.GetValue() * 3; i++, ptr++){
					resReceiveBuf[i] = *ptr;
				}
				if (len > outputBufW1.GetValue()){
					idxRes = 1;
					if ((len>>1) == outputBufW1.GetValue())
						idxResMax = 1;
					else if ((len >> 2) == outputBufW1.GetValue())
						idxResMax = 3;
					else
						idxResMax = 2;
				}
				receivedRes += outputBufW1.GetValue();

			}
			palloc->Free((char*)buf);
			if (name == DEBUG_BANK_NAME && fp && debugLevel <= 1)
				fprintf(fp, " Res (%d)\n", receivedRes.GetNextValue());
		}
	}
}
void CHomoGeneousComputingBank::ReceiveResData(int num)
{
	num = num;
	res_received = false;
	if (!pread->busValid || pread->isFeature)
		return;
	if (name == DEBUG_BANK_NAME)
		name = name;
	ReturnData * data = (ReturnData *)pread->dataBus;
	if (data->type == TYPE_RES && data->token == token.GetValue() && data->seq == (curSeq.GetValue() & 0xff)){
		res_received = true;
		DTYPE *buf = (DTYPE*)palloc->Alloc();
		memcpy(buf, data->data, sizeof(DTYPE) * BANK_NUM * COMPUTING_GROUP_SIZE);
		res_received_data.push(buf);
		res_received_len.push(data->len);
		if (fp && debugLevel <= 1)
			fprintf(fp, "%s receive %d Res fsize %d\n", name.c_str(), data->len, res_received_data.size());
	}
}

void CHomoGeneousComputingBank::writeRequest(int num, RequestItem &ri)
{
	fprintf(fexo, "%d 1 %d %d %d %d %d %d %d", num
		, ri.addr
		, ri.seq
		, ri.len
		, ri.token
		, ri.type
		, ri.isRamA
		, ri.isRamB);
	
}

void CHomoGeneousComputingBank::dumpReadExtraVerify(int num)
{
	fprintf(fexi, "%d", num + 1);
#ifdef S2_OPTIMIZE
	fprintf(fexi, " %d", isStride2->GetValue());
#endif
	fprintf(fexi, " %d", isReadingFeatures.GetValue());
	fprintf(fexi, " %d", pread->RequestFull());
	fprintf(fexi, " %d", isResMaster.GetValue());
	fprintf(fexi, " %d", token.GetValue());
	fprintf(fexi, " %d", ptoken->GetToken());
	//fprintf(fexi, " %d", extWeights.IsFull(BM_READ_WIDTH));
	fprintf(fexi, " %d", resBuf.IsFull(outputBufW1.GetValue() << 2));
	fprintf(fexi, " %d", doRes.GetValue());
	fprintf(fexi, " %d", mode.GetValue());
	fprintf(fexi, " %d", outputBufW1.GetValue());
	fprintf(fexi, " %d", outputBufH1Orig.GetValue());
	fprintf(fexi, " %d", outW.GetValue());
	fprintf(fexi, " %d", outFrameSize.GetValue());
	fprintf(fexi, " %d", outputAddrGap.GetValue());
	fprintf(fexi, " %d", outFrameGapSize.GetValue());
	fprintf(fexi, " %d", curSeq.GetValue());
	fprintf(fexi, " %d", Ks.GetValue());
	fprintf(fexi, " %d", numGroups.GetValue());
	fprintf(fexi, " %d", kCurLast.GetValue());
	fprintf(fexi, " %d", resSize0.GetValue());
	fprintf(fexi, " %d", resSizeLast.GetValue());
	fprintf(fexi, " %d", resLen0.GetValue());
	fprintf(fexi, " %d", resLenLast.GetValue());
	fprintf(fexi, " %d", usedGroupsLast.GetValue());
	fprintf(fexi, " %d", new_conv_inst);
	fprintf(fexi, " %d", kRes.GetNextValue());
	/*fprintf(fexi, " %d", totalBM.GetValue());
	fprintf(fexi, " %d", bmLastAddr.GetNextValue());
	fprintf(fexi, " %d", bmNextAddr.GetNextValue());
	fprintf(fexi, " %d", bmEndAddr.GetNextValue());
	fprintf(fexi, " %d", bmBlockSize.GetNextValue());
	fprintf(fexi, " %d", bmSkipSize.GetNextValue());*/
	fprintf(fexi, " %d", isReadResA.GetNextValue());
	fprintf(fexi, " %d", nextResAddr.GetNextValue());
	fprintf(fexi, " %d", frameResAddr.GetNextValue());
	fprintf(fexi, " %d", resRowCount.GetNextValue());
	fprintf(fexi, " %d", resSize.GetNextValue());
	fprintf(fexi, " %d", resReadSize.GetNextValue());
	fprintf(fexi, " %d", resFrameCount.GetNextValue());
	fprintf(fexi, " %d", resFrameMax.GetNextValue());
	fprintf(fexi, " %d", resLen.GetNextValue());
	fprintf(fexi, " %d", outResGapSize.GetNextValue());
	fprintf(fexi, " %d", totalRes.GetValue());
	fprintf(fexi, " %d", kCurLast_1.GetValue());
	//fprintf(fexi, " %d", requestingBM.GetNextValue() == false);
	fprintf(fexi, " %d", requestingRes.GetNextValue() == false);
	fprintf(fexi, " %d %d\n", popBM, popRes);
}

void CHomoGeneousComputingBank::ReadExtraWeights(int num)
{
	reqBM = reqRes = 0;
	res_asked = 0;
	//if (state == IDLE)
	//	return;
	if (fexi)
		dumpReadExtraVerify(num);
	if (isReadingFeatures.GetValue()){
		if (fexo) fprintf(fexo, "%d 0\n", num);
		return;
	}
	if (name == DEBUG_BANK_NAME)
		name = name;
	//if (!isResMaster.GetValue())
	//	ptoken->Next();
	if (pread->RequestFull()){
		if (fp && debugLevel <=1){
			fprintf(fp, "%s request full\n", name.c_str());
		}
		if (fexo) fprintf(fexo, "%d 0\n", num);
		return;
	}
	//if (token.GetValue() == ptoken->GetToken())
	//	ptoken->Next();
	if (token.GetValue() == ptoken->GetToken() && isResMaster.GetValue()){
		/*if (!isPreferRes.GetValue() && askedBM.GetValue() < totalBM.GetValue() 
			&& (liveBM.GetValue() < EXT_WEIGHT_SIZE / BM_READ_WIDTH))
		{
			ADDR_TYPE next = bmNextAddr.GetValue() + BM_READ_WIDTH* SZ_DTYPE;
			reqBM = 1;
			int len = BM_READ_WIDTH * SZ_DTYPE;
			if (next >= bmEndAddr.GetValue()){
				len = bmEndAddr.GetValue() - bmNextAddr.GetValue();
			}
			RequestItem ri;
			ri.addr = bmNextAddr.GetValue();
			ri.seq = (curSeq.GetValue() & 0xff);
			ri.isRamA = false;
			ri.isRamB = false;
			ri.len = len / SZ_DTYPE;
			ri.token = token.GetValue();
			ri.type = TYPE_BM;
			//requestingBM = true;

			if (next >= bmEndAddr.GetValue()){
				if (name == DEBUG_BANK_NAME)
					name = name;
#ifdef BATCH1_OPTIMIZE
				if (bmEndAddr == bmLastAddr.GetValue() && doBatch3K1.GetValue()){
					bmNextAddr = bmBatchStart.GetValue();
					bmEndAddr = bmBatchEnd.GetValue();
				}
				else
#endif
				{
					bmNextAddr = bmEndAddr.GetValue() + bmSkipSize.GetValue();
					ADDR_TYPE ea = bmEndAddr.GetValue() + bmSkipSize.GetValue() + bmBlockSize.GetValue();
					if (ea > bmLastAddr.GetValue())
						bmEndAddr = bmLastAddr.GetValue();
					else
						bmEndAddr = ea;
				}
				if (doRes.GetValue())
					isPreferRes = true;
				//ri.isLast = true;
			}
			else{
				bmNextAddr = next;
				//ri.isLast = false;
			}
			pread->Request(ri, id.GetValue());
			pread_RequestValid = true;
			pread_request = ri;
			if (fexo)
				writeRequest(num, ri);
			askedBM += ri.len;
			if (fp && debugLevel <=1)
				fprintf(fp, "\t%s read %d BM weight size %d, nadr %d, liveBM %d\n"
				, name.c_str(), len, extWeights.size(), bmNextAddr.GetNextValue(), liveBM.GetValue());
			return;
		}
		else*/
		if (askedRes.GetValue() < totalRes.GetValue() && res_received_live.GetValue() < MAX_CTRL_BUF_SIZE
			&& (liveRes.GetValue() + 4 <= 12 * COMPUTING_UNIT_OUTPUT_SIZE)) /*&& !requestingRes.GetValue()*/
			//change 12 to 48
		{
			// TODO : try requestingRes.GetNextValue()
			if (name == DEBUG_BANK_NAME)
				name = name;
			RequestItem ri;
			bool resDone = false;
			res_asked = true;
			//requestingRes = true;
			ri.addr = nextResAddr.GetValue();
			ri.isRamA = false;
			ri.isRamB = false;
			/*if (isReadResA.GetValue()){
				ri.isRamA = true;
				ri.isRamB = false;
			}
			else{
				ri.isRamA = false;
				ri.isRamB = true;
			}*/
			ri.token = token.GetValue();
			ri.seq = (curSeq.GetValue() & 0xff);
			ri.type = TYPE_RES;
			if (fp && name == DEBUG_BANK_NAME && debugLevel <= 1)
				fprintf(fp, "%s res request %d, liveRes %d\n", name.c_str(), ri.addr, liveRes.GetValue());
			if (mode == MODE_ONE
#ifdef S2_OPTIMIZE
				|| mode == MODE_TWO && isStride2.GetValue()
#endif		
				){
#ifdef S2_OPTIMIZE
				if (mode == MODE_ONE)
					ri.len = outputBufW1.GetValue() << 2;
				else
					ri.len = outputBufW1.GetValue() << 1;
#else
				ri.len = outputBufW1.GetValue() << 2;
#endif
				reqRes = 1;
				askedRes += outputBufW1.GetValue();
				if (resRowCount.GetValue() == outputBufH1Orig.GetValue()){
					resRowCount = 0;
					int fa;
					if (resFrameCount.GetValue() == resFrameMax.GetValue()){
						resDone = true;
						resFrameCount = 0;
						fa = frameResAddr.GetValue() + outFrameGapSize.GetValue();
					}
					else{
						resFrameCount++;
						fa = frameResAddr.GetValue() + outFrameSize.GetValue() * SZ_DTYPE;
					}
					//if (!(resDone && (kt.GetValue() + 1 - kRes.GetValue()) <= numGroups.GetValue())){
#ifdef BATCH1_OPTIMIZE
					if (!(resDone && (kRes.GetValue() + numGroups.GetValue() + Ks.GetValue()) > kt.GetValue() && doBatch3K1.GetValue()))
#endif
					{
						nextResAddr = fa;
						frameResAddr = fa;
					}
				}
				else{
					resRowCount++;
					nextResAddr += outW.GetValue() * SZ_DTYPE;
				}
			}
			else if (mode == MODE_TWO){
				if (resRowCount.GetValue() == outputBufH1Orig.GetValue()){
					ri.len = outputBufW1.GetValue() << 1;
					askedRes += outputBufW1.GetValue();
					reqRes = 1;
				}
				else{
					ri.len = outputBufW1.GetValue() << 2;
					askedRes += outputBufW1.GetValue() * 2;
					reqRes = 2;
				}

				if (resRowCount.GetValue() == outputBufH1Orig.GetValue() || resRowCount.GetValue() == outputBufH1Orig.GetValue() - 1){
					resRowCount = 0;
					int fa;
					if (resFrameCount.GetValue() == resFrameMax.GetValue()){
						resDone = true;
						resFrameCount = 0;
						fa = frameResAddr.GetValue() + outFrameGapSize.GetValue();
					}
					else{
						resFrameCount++;
						fa = frameResAddr.GetValue() + outFrameSize.GetValue() * SZ_DTYPE;
					}
					//if (!(resDone && (kt.GetValue() + 1 - kRes.GetValue()) <= numGroups.GetValue())){
#ifdef BATCH1_OPTIMIZE
					if (!(resDone && (kRes.GetValue() + numGroups.GetValue() + Ks.GetValue()) > kt.GetValue() && doBatch3K1.GetValue()))
#endif
					{
						nextResAddr = fa;
						frameResAddr = fa;
					}
				}
				else{
					resRowCount += 2;;
					nextResAddr += outW.GetValue() * 2 * SZ_DTYPE;
				}
			}
			else{
				if (resReadSize.GetValue() == resSize.GetValue()){
					//ri.len = resSize.GetValue() - resReadSize.GetValue();
					ri.len = resLen.GetValue();
					if (!(ri.len == outputBufW1.GetValue() || ri.len == 4 * outputBufW1.GetValue()
						|| ri.len == 2 * outputBufW1.GetValue() || ri.len == 3 * outputBufW1.GetValue())){
						printf("ri.len %d, outputW1 %d\n", ri.len, outputBufW1.GetValue()); fflush(stdout);
						assert(false);
					}
					//reqRes = ri.len / outputBufW1.GetValue();
					//resReadSize += ri.len;// can remove this line
					resDone = true;
					//if (!doBatch3K1.GetValue() && (kt.GetValue() + 1 - kRes.GetValue()) > numGroups.GetValue())
#ifdef BATCH1_OPTIMIZE
					if (!((kRes.GetValue() + numGroups.GetValue() + Ks.GetValue()) > kt.GetValue() && doBatch3K1.GetValue()))
#endif
						nextResAddr += outResGapSize.GetValue();
					askedRes += resLen.GetValue();
				}
				else{
					//reqRes = 4;
					ri.len = outputBufW1.GetValue() << 2;
					resReadSize += outputBufW1.GetValue() * 4;
					nextResAddr += ri.len * SZ_DTYPE;
					askedRes += outputBufW1.GetValue() * 4;
				}
				reqRes = 4;
			}
			//askedRes += ri.len;
			if (resDone){
				if (fp && debugLevel <= 3)
					fprintf(fp, "%s resDone\n", name.c_str());
				kRes += numGroups.GetValue() + Ks.GetValue();
				if (kRes.GetValue() < kCurLast.GetValue()){
					if (kRes.GetValue() == kCurLast_1.GetValue()){
						resFrameMax = usedGroupsLast.GetValue() - 1;
						resSize = resSizeLast.GetValue();
						resLen = resLenLast.GetValue();
						outResGapSize = resLenLast.GetValue() * SZ_DTYPE + outputAddrGap.GetValue() * SZ_DTYPE;
					}
					else{
						resFrameMax = numGroups.GetValue() - 1;
						resSize = resSize0.GetValue();
						resLen = resLen0.GetValue();
						outResGapSize = resLen0.GetValue() * SZ_DTYPE + outputAddrGap.GetValue() * SZ_DTYPE;
					}
				}
#ifdef BATCH1_OPTIMIZE
				else if (doBatch3K1.GetValue()){
					resFrameMax = kbe.GetValue() - kbh.GetValue(); 
					resSize = resSizeBatch.GetValue();
					resLen = resLenBatch.GetValue();
					outResGapSize = resLenBatch.GetValue() + outputAddrGap.GetValue();
					//resFrameMax = 0;
					nextResAddr = resBatchStart.GetValue();
					frameResAddr = resBatchStart.GetValue();
				}
#endif
				else{
					resFrameMax = numGroups.GetValue() - 1; // do not care
					resSize = resSize0.GetValue();
					resLen = resLen0.GetValue();
					outResGapSize = resLen0.GetValue() * SZ_DTYPE + outputAddrGap.GetValue() * SZ_DTYPE;
				}
				//resSize = outBufFrameSize.GetValue() * (resFrameMax.GetNextValue() + 1);
				//ri.isLast = true;
				//isPreferRes = false;
				resReadSize = 0;
			}
			//else
			//	ri.isLast = false;
			pread->Request(ri, id.GetValue());
			pread_RequestValid = true;
			pread_request = ri;
			if(fexo)
				writeRequest(num, ri);
			return;
		}
		
	}
	if (fexo) fprintf(fexo, "%d 0\n", num);
}

void CHomoGeneousComputingBank::dumpBuildInputFifoVerify(int num)
{
	if (!fbii || !fbio)
		return;

	fprintf(fbii, "%d", num + 1);
	fprintf(fbii, " %d %d %d %d %d %d", state.GetValue(), readCLast.GetValue()
		, outputBufH1.GetValue(), downPad.GetValue(), topPad.GetValue(), k.GetValue());
	fprintf(fbii, " %d %d %d %d %d %d %d %d", stride.GetValue(), rowNum.GetValue()
		, startprefetching, new_conv_inst, reset_iLayers, rowAddr.GetNextValue()
		, input_fifo.IsFull(), assemble_buffer.IsEmpty());

	fprintf(fbio, "%d %d", num, readWidth.GetValue());

}
void CHomoGeneousComputingBank::dumpBuildInputFifoVerify_inputfifo(DTYPE *buf)
{
	inputfifo_wen = true;
	if (!fbio)
		return;
	fprintf(fbio, " 1");
	for (int i = 0; i < INPUT_MEM_WIDTH; i++)
		fprintf(fbio, " %d", buf[i]);
}
void CHomoGeneousComputingBank::dumpBuildInputFifoVerify_buffer(DTYPE *buf)
{
	assemble_buff_ren = true;
	if (!fbii)
		return;
	fprintf(fbii, " 1");
	for (int i = 0; i < INPUT_MEM_WIDTH; i++)
		fprintf(fbii, " %d", buf[i]);
}
void CHomoGeneousComputingBank::buildInputFifo(int num)
{
	dumpBuildInputFifoVerify(num);
	assemble_buff_ren = false;
	inputfifo_wen = false;
	buildInputFifoCore(num);
	if (!fbii || !fbio)
		return;
	if (!inputfifo_wen)
		fprintf(fbio, " 0");
	if (assemble_buff_ren)
		fprintf(fbio, " 1"); //ab_rd_en
	else{
		fprintf(fbio, " 0");
		fprintf(fbii, " 0");
	}
	fprintf(fbii, "\n");
	fprintf(fbio, " %d %d\n", iLayers.GetValue(), rowAddr.GetValue());
}

void CHomoGeneousComputingBank::buildInputFifoCore(int num)
{
	num = num;
	if (input_fifo.IsFull()){
		is_input_fifo_full = true;
		return;
	}
	if (state == IDLE)
		return;
	if (iLayers.GetValue() > readCLast.GetValue())
		return;
#ifdef S2_OPTIMIZE
	if (isStride2.GetValue()){
		DTYPE *buf;
		if (rowAddr.GetValue() < 0 || rowAddr.GetValue() >= rowNum.GetValue()){
			buf = (DTYPE*)palloc->Alloc();
			memset(buf, 0, sizeof(buf[0]) * INPUT_MEM_WIDTH);
		}
		else if(s2b_lastAddr.GetValue() >= rowAddr.GetValue()){
			buf = (DTYPE*)palloc->Alloc();
			s2_buffer.GetValue(buf, s2b_cur.GetValue() * INPUT_MEM_WIDTH, INPUT_MEM_WIDTH);
			if (kIter.GetValue() != 0 || rowCounts.GetValue() != (outputBufH1.GetValue())){
				if (rowAddr.GetValue() < nextRowStart.GetValue()){
					if (s2b_start.GetValue() == S2_BUFFER_SIZE - 1)
						s2b_start = 0;
					else
						s2b_start++;
				}
				if (s2b_cur.GetValue() == S2_BUFFER_SIZE - 1)
					s2b_cur = 0;
				else
					s2b_cur++;
			}
		}
		else{
			if (assemble_buffer.IsEmpty())
				return;
			buf = (DTYPE*)palloc->Alloc();
			for (int i = 0; i < INPUT_MEM_WIDTH; i++)
				buf[i] = assemble_buffer.Pop();
			if (rowAddr.GetValue() >= nextRowStart.GetValue()){
				s2_buffer.SetValue(buf, s2b_end.GetValue() * INPUT_MEM_WIDTH, INPUT_MEM_WIDTH);
				if (kIter.GetValue() != 0 || rowCounts.GetValue() != (outputBufH1.GetValue())){
					if (s2b_end.GetValue() == S2_BUFFER_SIZE - 1)
						s2b_end = 0;
					else
						s2b_end++;
					assert(s2b_end.GetNextValue() != s2b_start.GetValue());
					s2b_lastAddr = rowAddr.GetValue();
				}
			}
		}
		input_fifo.Push(buf);
		if (kIter == 0){
			kIter = k.GetValue() - 1;
			if (rowCounts == outputBufH1.GetValue()){
				rowCounts = 0;
				rowAddr = -int(topPad.GetValue());
				nextRowStart = stride.GetValue() - topPad.GetValue();
				s2b_lastAddr = -1;
				s2b_end = 0;
				s2b_cur = 0;
				s2b_start = 0;
				iLayers++;
			}
			else{
				rowCounts++;
				rowAddr = nextRowStart.GetValue();
				nextRowStart += stride.GetValue();
				s2b_cur = s2b_start.GetValue();
			}
		}
		else{
			kIter = kIter.GetValue() - 1;
			rowAddr++;
		}
		if (fp && debugLevel <= 1){
			if (name == DEBUG_BANK_NAME){
				fprintf(fp, "\t%s push input fifo buf, ", name.c_str());
				for (unsigned i = 0; i < readWidth.GetValue(); i++)
					fprintf(fp, " "DFMT"", buf[i]);
				fprintf(fp, "(rowC %d, iter %d, rowAddr %d, nRowStart %d, s2b_laddr %d, s2b_end %d, s2b_cur %d, s2b_start %d, l %d, s %d)\n"
					, rowCounts.GetNextValue(), kIter.GetNextValue(), rowAddr.GetNextValue(), nextRowStart.GetNextValue()
					, s2b_lastAddr.GetNextValue(), s2b_end.GetNextValue(), s2b_cur.GetNextValue()
					, s2b_start.GetNextValue(), iLayers.GetNextValue(), input_fifo.size());
			}
		}
	}
	else
#endif
	{
		DTYPE *buf;
		if (rowAddr.GetValue() < 0 || rowAddr.GetValue() >= rowNum.GetValue()){
			buf = (DTYPE*)palloc->Alloc();
			memset(buf, 0, sizeof(buf[0]) * INPUT_MEM_WIDTH);
		}
		else{
			if (assemble_buffer.IsEmpty()){
				is_assemble_buff_empty = true;
				return;
			}
			buf = (DTYPE*)palloc->Alloc();
			for (int i = 0; i < INPUT_MEM_WIDTH; i++)
				buf[i] = assemble_buffer.Pop();
			dumpBuildInputFifoVerify_buffer(buf);
		}
		input_fifo.Push(buf);
		dumpBuildInputFifoVerify_inputfifo(buf);
		if (rowAddr.GetValue() < rowNum.GetValue() + int(downPad.GetValue()) - 1)
			rowAddr++;
		else{
			rowAddr = -int(topPad.GetValue());
			iLayers++;
		}
		if (fp && debugLevel <= 1){
			if (name == DEBUG_BANK_NAME){
				fprintf(fp, "\t%s push input fifo buf, ", name.c_str() );
				for (unsigned i = 0; i < readWidth.GetValue(); i++)
					fprintf(fp, " "DFMT"", buf[i]);
				fprintf(fp, "(row %d, layer %d, s %d)\n", rowAddr.GetNextValue(), iLayers.GetNextValue(), input_fifo.size());
			}
		}

	}
}

void CHomoGeneousComputingBank::dumpAssembleInputVerify(int num)
{
	if (!faii)
		return;

	fprintf(faii, "%d", num + 1);
	fprintf(faii, " %d %d %d %d"
		, doAssemble.GetValue(), assemble_buffer.IsFull(), inputs_buffer.IsEmpty(), readWidth.GetValue());
	fprintf(faii, " %d %d %d %d %d %d %d", prefetchFrameSize.GetValue(), new_conv_inst, startprefetching
		, addrNextFrame.GetNextValue(), curVolumeSize.GetValue()
		, maxRowCount.GetValue(), lastLen.GetValue());
}

void CHomoGeneousComputingBank::dumpAssembleInputVerify_inputs(DTYPE *buf2, int addr)
{
	input_ren = true;
	if (!faii || !faio)
		return;
	fprintf(faii, " 1");
	for (int i = 0; i < INPUT_MEM_WIDTH; i++)
		fprintf(faii, " %d", buf2[i]);

	input_addr = addr;
	//fprintf(faio, " 1 %d", addr);
}

void CHomoGeneousComputingBank::dumpAssembleInputVerify_buffer(DTYPE *buf)
{
	assemble_buff_wen = true;
	if (!faio)
		return;

	fprintf(faio, " 1");
	for (int i = 0; i < INPUT_MEM_WIDTH; i++)
		fprintf(faio, " %d", buf[i]);
}

void CHomoGeneousComputingBank::AssembleInput(int num)
{
	dumpAssembleInputVerify(num);
	input_ren = false;
	resetAssemble = false;
	assemble_buff_wen = false;
	inputs_buffer_ren = false;
	if(faio)
		fprintf(faio, "%d %d", num, readWidth.GetValue());
	AssembleInputCore(num);
	if (!faio || !faii)
		return;
	if (!assemble_buff_wen)
		fprintf(faio, " 0");
	if (!inputs_buffer_ren){
		fprintf(faii, " 0");
		fprintf(faio, " 0 0");
	}
	else
		fprintf(faio, " 1 %d", input_addr);
	fprintf(faio, " %d %d %d %d %d\n", resetAssemble, atmpSize.GetValue(), curRowCount.GetValue()
		, addrCurAssemble.GetValue(), addrNextFrame.GetValue());
	fprintf(faii, "\n");
}

void CHomoGeneousComputingBank::AssembleInputCore(int num)
{
	num = num;
	if (!doAssemble.GetValue())
		return;
	if (assemble_buffer.IsFull()){
		is_assemble_buff_full = true;
		return;
	}
	//bool lastRow = (atmpSize.GetValue() <= readWidth.GetValue()) 
	//	&& ((atmpSize.GetValue() + addrCurAssemble.GetValue()) >= addrNextFrame.GetValue());
	bool lastRow = (curRowCount.GetValue() == maxRowCount.GetValue()) && (atmpSize.GetValue() >= lastLen.GetValue());
	if ((atmpSize.GetValue() >= readWidth.GetValue()) || lastRow){
		DTYPE *buf = assemble_tmp.GetMem();
		//int len = lastRow ? (addrNextFrame.GetValue() - addrCurAssemble.GetValue()) : readWidth.GetValue();
		int len = lastRow ? lastLen.GetValue() : readWidth.GetValue();
		for (int i = 0; i < INPUT_MEM_WIDTH; i++)
			assemble_buffer.Push(buf[i]);
		dumpAssembleInputVerify_buffer(buf);
		addrCurAssemble += len;
		atmpSize = atmpSize.GetValue() - len;
		assemble_tmp.SetValue(buf + len, 0, atmpSize.GetNextValue());
		//if (addrCurAssemble.GetNextValue() >= addrNextFrame.GetValue()) //lastRow?
		//	addrNextFrame += prefetchFrameSize.GetValue();
		if (lastRow)
			curRowCount = 0;
		else
			curRowCount++;

		if (fp && debugLevel <= 1){
			if (name == DEBUG_BANK_NAME){
				fprintf(fp, "\t%s assembleinput old buf, ", name.c_str());
				for (int i = 0; i < len; i++)
					fprintf(fp, " "DFMT"", buf[i]);
				fprintf(fp, "(len %d, pos %d, rc %d)\n", len, atmpSize.GetNextValue(), curRowCount.GetNextValue());
			}
		}
	}
	else{
		/*if (!isLoadingNextFeatures.GetValue() && isReadingFeatures.GetValue() 
			&& addrNextAssemble.GetValue() >= nextWritePos.GetValue())
		{
			assert(addrCurAssemble.GetNextValue() < addrNextFrame.GetValue());
			assert(addrCurAssemble.GetNextValue() < curVolumeSize.GetValue());
			return;
		}*/
		if (inputs_buffer.IsEmpty())
			return;
		DTYPE *buf = assemble_tmp.GetMem();
		DTYPE buf2[INPUT_MEM_WIDTH];
		for (int i = 0; i < INPUT_MEM_WIDTH; i++)
			buf2[i] = inputs_buffer.Pop();
		inputs_buffer_ren = true;
		//inputs.GetValue(buf2, addrNextAssemble.GetValue(), INPUT_MEM_WIDTH);
		dumpAssembleInputVerify_inputs(buf2, addrNextAssemble.GetValue());

		//bool lastRow2 = ((addrCurAssemble.GetValue() + readWidth.GetValue()) >= addrNextFrame.GetValue());
		bool lastRow2 = curRowCount.GetValue() == maxRowCount.GetValue();
		//int len = lastRow2 ? (addrNextFrame.GetValue() - addrCurAssemble.GetValue()) : readWidth.GetValue();
		int len = lastRow2 ? lastLen.GetValue() : readWidth.GetValue();
		//addrNextAssemble += INPUT_MEM_WIDTH;
		if (lastRow2)
			curRowCount = 0;
		else
			curRowCount++;

		//if (lastRow2)
		//	addrNextFrame += prefetchFrameSize.GetValue();
		
		DTYPE buf3[INPUT_MEM_WIDTH];
		unsigned i;
		for (i = 0; i < atmpSize.GetValue(); i++)
			buf3[i] = buf[i];
		for (; i < INPUT_MEM_WIDTH; i++) //change INPUT_MEM_WIDTH to len, unused extra, hardware implementation
			buf3[i] = buf2[i - atmpSize.GetValue()];
		atmpSize = INPUT_MEM_WIDTH + atmpSize.GetValue() - len;
		assemble_tmp.SetValue(buf2 - atmpSize.GetValue() + len, 0, atmpSize.GetNextValue());
		
		for (int i = 0; i < INPUT_MEM_WIDTH; i++)
			assemble_buffer.Push(buf3[i]);
		dumpAssembleInputVerify_buffer(buf3);
		addrCurAssemble += len;
		//if (addrCurAssemble.GetNextValue() >= addrNextFrame.GetValue()) //lastRow?
		//	addrNextFrame += prefetchFrameSize.GetValue();

		if (fp && debugLevel <= 1){
			if (name == DEBUG_BANK_NAME){
				fprintf(fp, "\t%s assembleinput new buf , ", name.c_str());
				for (int i = 0; i < len; i++)
					fprintf(fp, " "DFMT"", buf3[i]);
				fprintf(fp, "(len %d, pos %d, n %d, rc %d)\n", len, atmpSize.GetNextValue(), addrNextAssemble.GetNextValue(), curRowCount.GetNextValue());
			}
		}
	}
	if (addrCurAssemble.GetNextValue() >= addrNextFrame.GetValue()) //lastRow?
		addrNextFrame += prefetchFrameSize.GetValue();
	if (addrCurAssemble.GetNextValue() >= curVolumeSize.GetValue()){
		doAssemble = false;
		resetAssemble = true;
		if (fp && debugLevel <= 1){
			if (name == DEBUG_BANK_NAME){
				fprintf(fp, "\t%s assembleinput done", name.c_str());
			}
		}
	}
}

void CHomoGeneousComputingBank::AssembleInputBuffer(int num)
{
	if (!doAssemble.GetValue())
		return;
	if (input_requested.GetValue()){
		assert(!(!isLoadingNextFeatures.GetValue() && isReadingFeatures.GetValue()
			&& addrNextAssemble.GetValue() >= nextWritePos.GetValue()));
		assert(addrNextAssemble.GetValue() < curVolumeSize.GetValue());
		DTYPE buf[INPUT_MEM_WIDTH];
		inputs.GetValue(buf, addrNextAssemble.GetValue(), INPUT_MEM_WIDTH);
		for (int i = 0; i < INPUT_MEM_WIDTH; i++)
			inputs_buffer.Push(buf[i]);
		inputs_buffer_wen = true;
		if (fp && debugLevel <= 1){
			if (name == DEBUG_BANK_NAME){
				fprintf(fp, "\t%s push inputs_buffer addr %d\n", name.c_str(), addrNextAssemble.GetValue());
			}
		}
		addrNextAssemble += INPUT_MEM_WIDTH;
	}
	if (inputs_buffer.IsFull(INPUT_MEM_WIDTH) || (addrNextAssemble.GetNextValue()) >= curVolumeSize.GetValue() 
		|| !isLoadingNextFeatures.GetValue() && isReadingFeatures.GetValue()
		&& (addrNextAssemble.GetNextValue()) >= nextWritePos.GetValue() || inputs_write)
	{
		input_requested = 0;
	}
	else{
		input_requested = 1;
		input_ren = true;
		//addrNextAssemble += INPUT_MEM_WIDTH;
	}
}

void CHomoGeneousComputingBank::dumpReadFeaturesVerify(int num)
{
	if (!frfi)
		return;
	fprintf(frfi, "%d %d %d %d %d %d %d", num + 1, pread->busValid, pread->isFeature, isReadingFeatures.GetValue()
		, isLoadingFroze.GetValue(), isLoadingNextFeatures.GetValue(), pread->GetSeqNum());

	fprintf(frfi, " %d %d %d %d %d %d", reqSeqF.GetValue(), writeWidth.GetValue(), rf_new_params
		, readPos.GetValue(), volumeSize.GetValue(), usedWords.GetValue());
	if (pread->busValid)
		for (int i = 0; i < MAX_LOAD_WIDTH; i++)
			fprintf(frfi, " %d", pread->dataBus[i]);
	fprintf(frfi, "\n");

}

void CHomoGeneousComputingBank::dumpReadFeaturesInputVerify(DTYPE *buf2, unsigned addr, unsigned len)
{
	input_wen = true;
	if (frfo){
		fprintf(frfo, " %d %d", len, addr);
		for (unsigned i = 0; i < len; i++)
			fprintf(frfo, " %d", buf2[i]);
	}
	if (fino){
		fprintf(fino, " %d %d", len, addr);
		for (unsigned i = 0; i < len; i++)
			fprintf(fino, " %d", buf2[i]);
	}
}

void CHomoGeneousComputingBank::ReadFeatures(int num)
{
	dumpReadFeaturesVerify(num);
	inputs_write = false;
	setLoadingFroze = false;
	resetLoadingFroze = false;
	resetLoadingNextFeatures = false;
	resetReadingFeatures = false;
	if (frfo)
		fprintf(frfo, "%d", num);
	ReadFeaturesCore(num);
	if (!frfo)
		return;
	if (!input_wen)
		fprintf(frfo, " 0");
	fprintf(frfo, " %d %d %d %d %d %d\n", setLoadingFroze, resetLoadingFroze, resetLoadingNextFeatures
		, resetReadingFeatures, ibSize.GetValue(), nextWritePos.GetValue());
}

void CHomoGeneousComputingBank::ReadFeaturesCore(int num)
{
	if (!isReadingFeatures.GetValue()){
		if (pread->busValid && pread->isFeature && pread->GetSeqNum() == reqSeqF.GetValue())
			assert(false);
		return;
	}
	if (name == DEBUG_BANK_NAME)
		name = name;
	if (isLoadingFroze.GetValue())
		if (!(isLoadingNextFeatures.GetValue() && nextWritePos.GetValue() + INPUT_MEM_WIDTH >= usedWords.GetValue())){
			isLoadingFroze = false;
			resetLoadingFroze = true;
		}
	
	if (!pread->busValid || !pread->isFeature){
		if (nextWritePos.GetValue() + ibSize.GetValue()>= volumeSize.GetValue()){
			DTYPE buf2[INPUT_MEM_WIDTH];
			memcpy(buf2, input_buffer.GetMem(), sizeof(buf2[0]) * ibSize.GetValue());
			inputs.SetValue(buf2, nextWritePos.GetValue(), ibSize.GetValue());
			inputs_write = true;
			dumpReadFeaturesInputVerify(buf2, nextWritePos.GetValue(), ibSize.GetValue());
			//nextWritePos += ibSize.GetValue(); //test
			nextWritePos += INPUT_MEM_WIDTH;
			ibSize = 0;
			if (fp && debugLevel <= 1){
				if (name == DEBUG_BANK_NAME){
					fprintf(fp, "\t%s writeinput, ", name.c_str());
					for (unsigned i = 0; i < ibSize.GetValue(); i++)
						fprintf(fp, " "DFMT"", buf2[i]);
					fprintf(fp, "  (%d, %d)\n", ibSize.GetValue(), nextWritePos.GetNextValue());
				}
			}
		}
		else return;
	}
	else{
		if (pread->GetSeqNum() != reqSeqF.GetValue())
			return;
		int readStart = -1;
		int bufPos;
		//DTYPE buf[BANK_READ_WIDTH * 2];
		//memcpy(buf, pread->dataBus + readPos.GetValue(), sizeof(buf[0]) * writeWidth.GetValue());
		if (ibSize.GetValue() + writeWidth.GetValue() >= INPUT_MEM_WIDTH){
			DTYPE buf2[INPUT_MEM_WIDTH];
			//memcpy(buf2, input_buffer.GetMem(), sizeof(buf2[0]) * ibSize.GetValue());
			//memcpy(buf2 + ibSize.GetValue(), buf, sizeof(buf[0]) * (INPUT_MEM_WIDTH - ibSize.GetValue()));
			
			for (unsigned i = 0; i < INPUT_MEM_WIDTH; i++)
				if (i < ibSize.GetValue())
					buf2[i] = input_buffer.GetMem()[i];
				else if (readPos.GetValue() + i - ibSize.GetValue() < MAX_LOAD_WIDTH)
					buf2[i] = pread->dataBus[readPos.GetValue() + i - ibSize.GetValue()];
				else
					buf2[i] = input_buffer.GetMem()[i];

			inputs.SetValue(buf2, nextWritePos.GetValue(), INPUT_MEM_WIDTH);
			inputs_write = true;
			dumpReadFeaturesInputVerify(buf2, nextWritePos.GetValue(), INPUT_MEM_WIDTH);
			nextWritePos += INPUT_MEM_WIDTH;
			ibSize = ibSize.GetValue() + writeWidth.GetValue() - INPUT_MEM_WIDTH;
			
			//if (ibSize.GetNextValue() > 0)
			//	input_buffer.SetValue(pread->dataBus + readPos.GetValue() + INPUT_MEM_WIDTH - ibSize.GetValue(), 0, ibSize.GetNextValue());
			readStart = readPos.GetValue() + INPUT_MEM_WIDTH - ibSize.GetValue();
			bufPos = 0;

			if (fp && debugLevel <= 1){
				if (name == DEBUG_BANK_NAME){
					fprintf(fp, "\t%s writeinput, ", name.c_str());
					for (int i = 0; i < INPUT_MEM_WIDTH; i++)
						fprintf(fp, " "DFMT"", buf2[i]);
					fprintf(fp, "  (%d, %d)\n", INPUT_MEM_WIDTH, nextWritePos.GetNextValue());
				}
			}
		}
		else if (nextWritePos.GetValue() + ibSize.GetValue() + writeWidth.GetValue() >= volumeSize.GetValue()){
			DTYPE buf2[INPUT_MEM_WIDTH];
			//memcpy(buf2, input_buffer.GetMem(), sizeof(buf2[0]) * ibSize.GetValue());
			//memcpy(buf2 + ibSize.GetValue(), buf, sizeof(buf[0]) * writeWidth.GetValue());

			for (unsigned i = 0; i < INPUT_MEM_WIDTH; i++)
				if (i < ibSize.GetValue())
					buf2[i] = input_buffer.GetMem()[i];
				else if (readPos.GetValue() + i - ibSize.GetValue() < MAX_LOAD_WIDTH)
					buf2[i] = pread->dataBus[readPos.GetValue() + i - ibSize.GetValue()];
				else
					buf2[i] = input_buffer.GetMem()[i];

			inputs.SetValue(buf2, nextWritePos.GetValue(), ibSize.GetValue() + writeWidth.GetValue());
			inputs_write = true;
			dumpReadFeaturesInputVerify(buf2, nextWritePos.GetValue(), ibSize.GetValue() + writeWidth.GetValue());
			//nextWritePos += ibSize.GetValue() + writeWidth.GetValue(); //test
			nextWritePos += INPUT_MEM_WIDTH;
			ibSize = 0;

			if (fp && debugLevel <= 1){
				if (name == DEBUG_BANK_NAME){
					fprintf(fp, "\t%s writeinput, ", name.c_str());
					for (unsigned i = 0; i < ibSize.GetValue() + writeWidth.GetValue(); i++)
						fprintf(fp, " "DFMT"", buf2[i]);
					fprintf(fp, "  (%d, %d)\n", ibSize.GetValue() + writeWidth.GetValue(), nextWritePos.GetNextValue());
				}
			}
		}
		else{
			//input_buffer.SetValue(pread->dataBus + readPos.GetValue(), ibSize.GetValue(), writeWidth.GetValue());
			readStart = readPos.GetValue();
			bufPos = ibSize.GetValue();
			ibSize += writeWidth.GetValue();
		}
		if (readStart >= 0){
			DTYPE buf[INPUT_MEM_WIDTH];
			for (int i = 0; i < INPUT_MEM_WIDTH; i++)
				if (i < bufPos)
					buf[i] = input_buffer.GetValue(i);
				else if (readStart + i - bufPos < MAX_LOAD_WIDTH)
					buf[i] = pread->dataBus[readStart + i - bufPos];
				else
					buf[i] = input_buffer.GetValue(i);
				input_buffer.SetValue(buf, 0, INPUT_MEM_WIDTH);
		}
		if (fp && debugLevel <= 1){
			DTYPE *buf = pread->dataBus + readPos.GetValue();
			if (name == DEBUG_BANK_NAME){
				fprintf(fp, "\t%s readdata, ibs %d, ", name.c_str(), ibSize.GetNextValue());
				for (unsigned i = 0; i < writeWidth.GetValue(); i++)
					fprintf(fp, " "DFMT"", buf[i]);
				fprintf(fp, "  (%d, %d)\n", writeWidth.GetValue(), nextWritePos.GetNextValue());
			}
			else
				fprintf(fp, "\t%s read %d (%d), data ("DFMT", "DFMT")\n", name.c_str(), writeWidth.GetValue(), nextWritePos.GetNextValue(),
				buf[0], buf[1]);
		}
		if (isLoadingNextFeatures.GetValue() && nextWritePos.GetNextValue() + INPUT_MEM_WIDTH >= usedWords.GetValue()){
			isLoadingFroze = true;
			setLoadingFroze = true;
		}
		else{
			isLoadingFroze = false;
			resetLoadingFroze = true;
		}
	}
	if (nextWritePos.GetNextValue() >= volumeSize.GetValue()){
		isReadingFeatures = false;
		resetReadingFeatures = true;
		if (isLoadingNextFeatures.GetValue()){
			isLoadingNextFeatures = false;
			resetLoadingNextFeatures = true;
		}
		if (fp && debugLevel <= 3)
			if (name == DEBUG_BANK_NAME)
				fprintf(fp, "%d : %s reading feature done (%d)\n", num, name.c_str(), volumeSize.GetValue());
	}
}

void CHomoGeneousComputingBank::ReadWeights(int num)
{
	if (fwto)
		fprintf(fwto, " %d %d %d %d", isReadingWeights.GetValue()
		, weightReadPos.GetValue(), nextWeightRead.GetValue(), endWeightRead.GetValue());
	if (fwti){
		fprintf(fwti, " %d %d %d %d %d %d", isRunning.GetValue(), is_cycle_froze, pcweight->busValid, pcweight->GetSeqNum(), new_weight_params, new_conv_inst);
		fprintf(fwti, " %d %d %d %d", weightReadPos.GetNextValue(), nextWeightRead.GetNextValue()
			, endWeightRead.GetNextValue(), reqSeqW.GetNextValue());
		if (pcweight->busValid)
			for (int i = 0; i < WEIGHT_READ_WIDTH; i++)
				fprintf(fwti, " %d", pcweight->dataBus[i]);
		fprintf(fwti, "\n");

	}
	if (!isReadingWeights.GetValue()){
		if (fwto) fprintf(fwto, " 0\n");
		return;
	}
	if (pcweight->GetSeqNum() != reqSeqW.GetValue()){
		if (fwto) fprintf(fwto, " 0\n");
		return;
	}
	if (!pcweight->busValid){
		if (fwto) fprintf(fwto, " 0\n");
		return;
	}
	assert(!IsWeightFull());
	
	int len = WEIGHT_DATA_WIDTH;
#if WEIGHT_BUFFER_SIZE_MULT == 2 
	//save the first cycle bus data to weightBuffer, combine with the second bus data for weights
	if (idxWeightBuffer == 0)
		for (int i = 0; i < len; i++)
			weightBuffer[i] = pcweight->dataBus[weightReadPos.GetValue() + i];
		
#endif
	bool done = nextWeightRead.GetValue() + len >= endWeightRead.GetValue();
	if (done){
		isReadingWeights = false;
		if (fp && debugLevel <= 3)
			fprintf(fp, "%d : %s readweight done\n", num, name.c_str());
	}
#if WEIGHT_BUFFER_SIZE_MULT == 2
	if (done || idxWeightBuffer.GetValue()){
		for (int i = 0; i < WEIGHT_DATA_WIDTH; i++)
			if (idxWeightBuffer.GetValue())
				weights.Push(weightBuffer[i]);
			else
				weights.Push(pcweight->dataBus[weightReadPos.GetValue() + i]);
#endif
		if (fwto) fprintf(fwto, " %d", WEIGHT_DATA_WIDTH);
		for (int i = 0; i < WEIGHT_DATA_WIDTH; i++){
			weights.Push(pcweight->dataBus[weightReadPos.GetValue() + i]);
			if (fwto) fprintf(fwto, " %d", pcweight->dataBus[weightReadPos.GetValue() + i]);
		}
		if (fwto) fprintf(fwto, " \n");
#if WEIGHT_BUFFER_SIZE_MULT == 2
		idxWeightBuffer = false; //0

	}
	else
		idxWeightBuffer = true; //1
#endif
	nextWeightRead += WEIGHT_DATA_WIDTH;
	
	
	if (name == DEBUG_BANK_NAME && fp && debugLevel <= 1){
		for (int i = 0; i < len; i++){
			DTYPE v = pcweight->dataBus[weightReadPos.GetValue() + i];
			fprintf(fp, " "DFMT"%s", v, i % 5 == 4 ? "," : "");
		}
		//fprintf(fp, "\n");
	}
	if (fp && debugLevel <=1)
		fprintf(fp, "\t%s readweight %d data addr %d from weight\n", name.c_str(), len, nextWeightRead.GetValue());
	
}

}
