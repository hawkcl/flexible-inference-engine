#include "sim.h"
#include <assert.h>
namespace CloudDesign{
	void CShiftComputingGroup::SetDebug(FILE *f)
	{
		fp = f;
		std::vector<CUnifiedComputingUnit *>::const_iterator p = UCUs.begin();
		for (; p != UCUs.end(); p++)
			(*p)->SetDebug(f);
	}
	void CShiftComputingGroup::SetName(std::string s)
	{
		name = s;
		int i = 0;
		std::vector<CUnifiedComputingUnit *>::const_iterator p = UCUs.begin();
		for (; p != UCUs.end(); p++, i++){
			char tmp[100];
			sprintf(tmp, "%s_CU%d", s.c_str(), i);
			(*p)->SetName(tmp);
		}
	}
	void CShiftComputingGroup::latch(int num){
		std::vector<CSimNode *>::const_iterator p = storages.begin();
		for (; p != storages.end(); p++)
			(*p)->latch(num);
		for (int i = 0; i < COMPUTING_GROUP_SIZE; i++)
			UCUs[i]->latch(num);
		mMux = UCLM_X;
		a0Mux = UCLA0_MUL;
		aMux = UCLA_W;
		//aqMux = UCLAQ_PLUS;
		//saMux = UCLSA_X;
		sqMux = UCLSQ_AQ;
		lMux = UCLL_0;
		oMux = UCLO_RELU;
	}
	void CShiftComputingGroup::Init(int num)
	{
		CUnifiedComputingUnit *prev = NULL;
		for (int i = 0; i < num; i++){
			CUnifiedComputingUnit *pu = new CUnifiedComputingUnit();
			UCUs.push_back(pu);
			pu->SetSCG(this);
			CUnifiedComputingLogic *pl = new CUnifiedComputingLogic;
			pu->SetUCL(pl);
			pl->Init();
			pu->Init();

			if (i == num - 1)
				pu->SetLast();
			if (prev)
				prev->SetRight(pu);
			prev = pu;
		}
		prev->SetRight(NULL);
		//fetchAddr.SetValue(0);
		//useAddr.SetValue(10);
	}

	CShiftComputingGroup::~CShiftComputingGroup()
	{
		//return;
		std::vector<CUnifiedComputingUnit *>::const_iterator p = UCUs.begin();
		for (; p != UCUs.end(); p++){
			delete *p;
		}
		if (fvi)
			fclose(fvi);
		if (fvo)
			fclose(fvo);
	}

	void CShiftComputingGroup::Init()
	{
		if (name == DEBUG_CG_NAME)
			name = name;
		
		//storages.push_back(&id);
		storages.push_back(&conv_idx);
		storages.push_back(&conv_scale);
		storages.push_back(&bm_scale);
		storages.push_back(&weights0);
		storages.push_back(&weights1);
		storages.push_back(&weightId);
		storages.push_back(&readWeights0);
		storages.push_back(&weight);
		storages.push_back(&isOutput0);
		storages.push_back(&isAct);
		//weights.Init();
		debugLevel = DEFAULT_DEBUG_LEVEL;
		std::vector<CSimNode *>::const_iterator p = storages.begin();
		for (; p != storages.end(); p++)
			(*p)->Init();

		weightId.SetValue(0);
		mMux = UCLM_X;
		a0Mux = UCLA0_MUL;
		aMux = UCLA_W;
		//aqMux = UCLAQ_PLUS;
		//saMux = UCLSA_X;
		sqMux = UCLSQ_AQ;
		lMux = UCLL_0;
		oMux = UCLO_RELU;
		
		//c0Mux = UCLC0_X;
		//c1Mux = UCLC1_W;

		if (DUMP_VERIFICATION_SCG && phcg->id.GetNextValue() == 0 && (id == 0 || id == 1 || id == 2)){
			char filename[100];
			sprintf(filename, "%s/bank%d_SCG%d_input.txt", OUTPUT_DIR, phcg->id.GetNextValue(), id);
			//sprintf(filename, "verify/bank%d_SCG%d_input.txt", phcg->id.GetNextValue(), id);
			fvi = fopen(filename, "wt");
			assert(fvi);

			sprintf(filename, "%s/bank%d_SCG%d_output.txt", OUTPUT_DIR, phcg->id.GetNextValue(), id);
			//sprintf(filename, "verify/bank%d_SCG%d_output.txt", phcg->id.GetNextValue(), id);
			fvo = fopen(filename, "wt");
			assert(fvo);
		}
		else
			fvi = fvo = NULL;
	}

	void CShiftComputingGroup::DumpVerificationFile(int num)
	{
		//if (debugLevel > 1)
		//	return;
		//return;
		//assert(fvi);
		//assert(fvo);
		int i;
		fprintf(fvi, "%d %d %d %d %d %d %d %d %d %d %d %d %d %d\n"
			, num+1, phcg->IsCycleFroze(), phcg->state.GetValue(), phcg->state.GetNextValue(), phcg->wScale.GetValue()
			, phcg->k.GetValue(), phcg->isInitLayer.GetValue(), phcg->doLRelu.GetValue(), phcg->doRelu.GetValue()
			, phcg->bmPhase.GetValue(), phcg->isLReluWeight.GetValue(), phcg->cgSwitchOutput
			, phcg->nextWeight, phcg->new_conv_inst);

		fprintf(fvi, "   %d %d %d %d %d %d %d %d %d %d %d %d %d\n"
			, phcg->isBMWeightValid.GetValue(), phcg->isWeightValid.GetValue(), phcg->wLRelu.GetValue(), phcg->weightId.GetValue()
			, phcg->k.GetNextValue(), phcg->iterCountDown.GetValue(), phcg->input_src, phcg->isOutputReady
			, phcg->backupId, phcg->isBackupValid, phcg->outputReadPos.GetValue()
			, phcg->outputWritePos.GetValue(), phcg->outputRows.GetValue());

		for (i = 0; i < WEIGHT_BUS_SIZE; i++)
			fprintf(fvi, " %d", phcg->weightBus[i].GetValue());
		fprintf(fvi, "\n");
		for (i = 0; i < WEIGHT_BUS_SIZE; i++)
			fprintf(fvi, " %d", phcg->weightBus[i].GetValue());
		fprintf(fvi, "\n");
		for (i = 0; i < MAX_K; i++)
			fprintf(fvi, " %d", phcg->shiftInputs[i]);
		fprintf(fvi, "\n");
		for (i = 0; i < COMPUTING_GROUP_SIZE; i++)
			fprintf(fvi, " %d", UCUs[i]->GetShiftS());
		fprintf(fvi, "\n");
		for (i = 0; i < COMPUTING_GROUP_SIZE; i++)
			fprintf(fvi, " %d", UCUs[i]->GetPSumLow());
		fprintf(fvi, "\n");
#ifdef S2_OPTIMIZE
		fprintf(fvi, " %d", phcg->isStride2.GetValue());
		for (i = 0; i < COMPUTING_GROUP_SIZE * 2; i++)
			fprintf(fvi, " %d", phcg->backupBus[i]);
#else
		fprintf(fvi, " %d", phcg->stride.GetValue());
		for (i = 0; i < COMPUTING_GROUP_SIZE; i++)
			fprintf(fvi, " %d", phcg->backupBus[i]);
#endif
		fprintf(fvi, "\n");
		fflush(fvi);


		fprintf(fvo, "%d %d %d %d %d %d %d %d %d\n", num, conv_idx.GetValue(), weightId.GetValue()
			, readWeights0.GetValue(), weight.GetValue(), isOutput0.GetValue(), phcg->isOutputReady
			, phcg->on_output * (phcg->outputCGIdx.GetValue() == id), phcg->outputBufW1_out.GetValue());
		for (i = 0; i < COMPUTING_GROUP_SIZE; i++)
			fprintf(fvo, " %d", UCUs[i]->GetShift());
		fprintf(fvo, "\n");
		for (i = 0; i < COMPUTING_GROUP_SIZE; i++)
			fprintf(fvo, " %d", UCUs[i]->GetInput());
		fprintf(fvo, "\n");
		for (i = 0; i < COMPUTING_GROUP_SIZE; i++)
			fprintf(fvo, " %d", UCUs[i]->GetBackup());
		fprintf(fvo, "\n");
		for (i = 0; i < COMPUTING_GROUP_SIZE; i++)
			fprintf(fvo, " %d", UCUs[i]->GetMQ());
		fprintf(fvo, "\n");
		for (i = 0; i < COMPUTING_GROUP_SIZE; i++)
			fprintf(fvo, " %d", UCUs[i]->GetAQ());
		fprintf(fvo, "\n");
		for (i = 0; i < COMPUTING_GROUP_SIZE; i++)
			fprintf(fvo, " %d", UCUs[i]->GetSQ());
		fprintf(fvo, "\n");
		for (i = 0; i < COMPUTING_GROUP_SIZE; i++)
			fprintf(fvo, " %d", UCUs[i]->GetPSUMQ());
		fprintf(fvo, "\n");
		DTYPE bus[COMPUTING_GROUP_SIZE];
		GetOutput(bus, phcg->outputBufW1_out.GetValue(), phcg->outputRows.GetValue());
		for (i = 0; i < COMPUTING_GROUP_SIZE; i++)
			fprintf(fvo, " %d", bus[i]); // in iter num+1 likely
		fprintf(fvo, "\n");
		//for (i = 0; i < COMPUTING_GROUP_SIZE; i++)
		//	fprintf(fvo, " %d", UCUs[i]->GetOutPut()); // in iter num+1 likely
		//fprintf(fvo, "\n");
		//fflush(fvo);
	}
	void CShiftComputingGroup::FinishDumpVerificationFile(int num)
	{
		//if (debugLevel > 1)
		//	return;

		int i;
		fprintf(fvo, " %d %d %d %d %d %d\n", mMux, a0Mux, aMux, sqMux, lMux, oMux);
		for (i = 0; i < COMPUTING_GROUP_SIZE; i++)
			fprintf(fvo, " %d", UCUs[i]->GetOutPut()); // in iter num+1 likely
		fprintf(fvo, "\n");
		fflush(fvo);
	}

	void CShiftComputingGroup::progress(int num)
	{
		//if (phcg->usedCG.GetValue() <= id.GetValue())
		//	return;
		if (name == DEBUG_CG_NAME)
			name = name;
		if (fvi && fvo)
			DumpVerificationFile(num);
		processConv();
		ReadInput();
		ReadBackUp();
		ReadWeight();
		ReadBMWeight();
		processWeights();
		if (phcg->cgSwitchOutput && !phcg->IsCycleFroze()){
			isOutput0 = !isOutput0.GetValue();
		}
		for (int i = 0; i < COMPUTING_GROUP_SIZE; i++){
			/*if (fp && debugLevel <= 1){
				fprintf(fp, "%s ucu %d %p\n", name.c_str(), i, UCUs[i]);
				fflush(fp);
			}*/
			if (!phcg->IsCycleFroze())
				UCUs[i]->progress(num);
		}
		if (fvi && fvo)
			FinishDumpVerificationFile(num);

	}
	void CShiftComputingGroup::processWeights()
	{
		if (phcg->IsCycleFroze())
			return;
		if (phcg->isLReluWeight.GetValue()){
			weightId.SetValue(0);
			weight.SetValue(phcg->wLRelu.GetValue());
			return;
		}
		if (phcg->state == CONV_INIT){
			// so we fill 0 first
			//fetchAddr.SetValue(0);
			//useAddr.SetValue(10);
		}
		if ((name == DEBUG_CG_NAME))
			name = name;
		if (phcg->nextWeight){
			readWeights0 = !readWeights0.GetValue();
			//weightId.SetValue(0);
			if (fp && debugLevel <= 1 && (name == DEBUG_CG_NAME)){
				fprintf(fp, "\t\t%s readWeights0 %s flipped\n", name.c_str(), readWeights0.GetValue()?"T":"F");
			}
		}
		if (phcg->state == CONV_MULT /*&& phcg->state.GetNextValue() == CONV_MULT*/ || phcg->state == CONV_START){
			unsigned idx = weightId.GetValue();
			assert(phcg->state == CONV_START || idx < phcg->k.GetValue());
			weight.SetValue(GetWeight());// weights[weightSet][weightId];
			if (fp && debugLevel <= 1 && (name == DEBUG_CG_NAME)){
				fprintf(fp, "\t\t%s weightId  %d useweight0? %s\n", name.c_str(), weightId.GetValue(), readWeights0.GetValue() ? "Y" : "N");
			}
			if (phcg->state == CONV_START && phcg->nextWeight && phcg->k.GetValue() != 1)
				weightId = 1;
			else if (phcg->state.GetNextValue() == CONV_BM)
				weightId = 0;
			else if (idx == phcg->k.GetValue() - 1 || phcg->k.GetValue() == 1)
				weightId.SetValue(0);
			else
				weightId.SetValue(idx + 1);

		}
		else if (phcg->state == CONV_BM){
			if (fp && debugLevel <= 1 && (name == DEBUG_CG_NAME))
				name = name;
			int idx = weightId.GetValue();
			assert(idx < 2);
			weight.SetValue(GetWeight());
			if (fp && debugLevel <= 1 && (name == DEBUG_CG_NAME)){
				fprintf(fp, "\t\t%s weightId  %d useweight0? %s\n", name.c_str(), weightId.GetValue(), readWeights0.GetValue() ? "Y" : "N");
			}
			if (!phcg->nextWeight){
				if (idx == 0)
					weightId.SetValue(1);
				else
					weightId.SetValue(0);
			}
			else
				weightId.SetValue(0);
		}
		else if (phcg->state == CONV_RELU || phcg->state == CONV_OUT || phcg->nextWeight){
			weightId.SetValue(0);
		}
		//if (fp && debugLevel <=1)
		//	fprintf(fp, "%s next weightId %d\n", name.c_str(), weightId.GetNextValue());

	}

	void CShiftComputingGroup::processConv()
	{
		if (phcg->state == CONV_MULT){
			if (phcg->k.GetValue() == 1){
				mMux = UCLM_X;
				a0Mux = UCLA0_MUL;
				//aqMux = UCLAQ_PLUS;
				oMux = UCLO_AQ;
				if (!phcg->isInitLayer.GetValue())// move to k - 1 is needed
					aMux = UCLA_PSUM;
				else
					aMux = UCLA_0;
			}
			else{
				mMux = UCLM_X;
				//aqMux = UCLAQ_PLUS;
				//saMux = UCLSA_LOW;
				oMux = UCLO_SQ;
				a0Mux = UCLA0_MUL;
				if (phcg->iterCountDown.GetValue() == phcg->k.GetValue() - 1){
					aMux = UCLA_AQ;
					if (conv_idx.GetValue() == 0)
						sqMux = UCLSQ_PLUS;
				}
				else if (phcg->iterCountDown.GetValue() == phcg->k.GetValue() - 2){
					sqMux = UCLSQ_AQ;
					if (!phcg->isInitLayer.GetValue() && conv_idx.GetValue() == 0)// move to k - 1 is needed
						aMux = UCLA_PSUM;
					else
						aMux = UCLA_0;
				}
				else{
					aMux = UCLA_AQ;
					if (conv_idx.GetValue() <= phcg->iterCountDown.GetValue()){
						sqMux = UCLSQ_SQ;
					}
					else if (conv_idx.GetValue() == phcg->iterCountDown.GetValue() + 1){ // condition not really needed
						sqMux = UCLSQ_PLUS;
					}
				}
			}
			return;
		}

		if (phcg->state == CONV_BM){
			//aqMux = UCLAQ_PLUS;
			oMux = UCLO_AQ;

			//if (phcg->bmPhase.GetValue() == 0)
				mMux = UCLM_PSUM;
			//else{
				a0Mux = UCLA0_MS;
				aMux = UCLA_W;
			//}
			return;
		}
		if (phcg->state == CONV_RELU){
			if (phcg->doRelu.GetValue()){
				lMux = UCLL_0;
			}
			else if (phcg->doLRelu.GetValue()){
				lMux = UCLL_MUL;
				mMux = UCLM_PSUM;
			}
			oMux = UCLO_RELU;
			return;
		}
	}

	void CShiftComputingGroup::ReadInput()
	{
		if (phcg->IsCycleFroze())
			return;
		INPUT_SOURCE is = phcg->input_src;
		if (phcg->input_src == INPUT_S && conv_idx.GetValue() == phcg->k.GetValue() - 1)
			is = INPUT_BACKUP;
		for (int i = 0; i < COMPUTING_GROUP_SIZE; i++)
			UCUs[i]->ReadInput(is, i, phcg);
	}

	void CShiftComputingGroup::ReadBackUp()
	{
		if (!phcg->isBackupValid)
			return;
		if (phcg->IsCycleFroze())
			return;
		if (
#ifdef BATCH1_OPTIMIZE
			phcg->k.GetValue() > 1 && 
#endif
			phcg->backupId != conv_idx.GetValue())
			return;
		for (int i = 0; i < COMPUTING_GROUP_SIZE; i++){
#ifdef BATCH1_OPTIMIZE
			if (phcg->doBatch3K1_cur.GetValue()){
				UCUs[i]->SetBackUp(phcg->backupBus[i + COMPUTING_GROUP_SIZE * conv_idx.GetValue()]);
			}else
#elif defined (S2_OPTIMIZE)
			if (phcg->isStride2.GetValue()){
				UCUs[i]->SetBackUp(phcg->backupBus[i * 2]);
				UCUs[i]->SetBackUp2(phcg->backupBus[i * 2 + 1]);
			}
			else
#endif
				UCUs[i]->SetBackUp(phcg->backupBus[i]);
		}
	}
	DTYPE CShiftComputingGroup::GetWeight()
	{
		if (phcg->nextWeight)
			if (readWeights0.GetNextValue())
				return weights0.GetValue(0); //use next because useAddr and fetchAddr switch already
			else
				return weights1.GetValue(0);
		else
			if (readWeights0.GetNextValue())
				return weights0.GetValue(weightId.GetValue()); //use next because useAddr and fetchAddr switch already
			else
				return weights1.GetValue(weightId.GetValue());
	}

	void CShiftComputingGroup::ReadWeight()
	{
		if (!phcg->isWeightValid.GetValue())
			return;
		if(phcg->IsCycleFroze())
			return;
		DTYPE bus[MAX_K];
		if (phcg->k.GetValue() == 1){//8
			int wid;
#ifdef BATCH1_OPTIMIZE
			if (phcg->doBatch3K1_cur.GetValue()){
				wid = id / 3;
			}
			else
#endif
				wid = id;
			if ((phcg->weightId.GetValue() >> 3) != (wid >> 3))
				return;
			
			for (unsigned i = 0; i < phcg->k.GetValue(); i++)
				bus[i] = phcg->weightBus[(wid & 7)  + i].GetValue();
			if (readWeights0.GetValue())
				weights1.SetValue(bus, 0, phcg->k.GetValue());
			else
				weights0.SetValue(bus, 0, phcg->k.GetValue());
		}
		else if (phcg->k.GetValue() <= 4){
			if ((phcg->weightId.GetValue() >> 1) != (id >> 1))
				return;
			for (unsigned i = 0; i < phcg->k.GetValue(); i++)
				bus[i] = phcg->weightBus[(id & 1) * phcg->k.GetValue() + i].GetValue();
			if (readWeights0.GetValue())
				weights1.SetValue(bus, 0, phcg->k.GetValue());
			else
				weights0.SetValue(bus, 0, phcg->k.GetValue());
		}
		else{
			if ((phcg->weightId.GetValue()) != (id ))
				return;
			for (unsigned i = 0; i < phcg->k.GetValue(); i++)
				bus[i] = phcg->weightBus[(id) * phcg->k.GetValue() + i].GetValue();
			if (readWeights0.GetValue())
				weights1.SetValue(bus, 0, phcg->k.GetValue());
			else
				weights0.SetValue(bus, 0, phcg->k.GetValue());

		}
	}

	void CShiftComputingGroup::ReadBMWeight()
	{
		if (phcg->IsCycleFroze())
			return;
		if (!phcg->isBMWeightValid.GetValue())
			return;
		int gid = id / phcg->k.GetValue();
#if CG_NUM < 12

		if (phcg->weightId.GetValue() / 3 != (gid /3))
			return;
		{
			int start = (gid % 3) * 2;
			DTYPE bus[2];
			bus[0] = phcg->weightBus[start].GetValue();
			bus[1] = phcg->weightBus[start + 1].GetValue();
			if (readWeights0.GetValue())
				weights1.SetValue(bus, 0, 2);
			else
				weights0.SetValue(bus, 0, 2);
		}
		return;
#endif
#ifdef BATCH1_OPTIMIZE
		if (phcg->doBatch3K1_cur.GetValue())
			gid = gid / 3;
#endif
		//if (id % phcg->k.GetValue() != 0)
		//	return;
		if ((phcg->weightId.GetValue() >> 1) != (gid >> 1))
			return;
		int start = (gid & 1) * BM_NUM;
		DTYPE bus[2];
		bus[0] = phcg->weightBus[start].GetValue();
		bus[1] = phcg->weightBus[start + 1].GetValue();
		if (readWeights0.GetValue())
			weights1.SetValue(bus, 0, 2);
		else
			weights0.SetValue(bus, 0, 2);
		unsigned s = ((unsigned)phcg->weightBus[start + 2].GetValue()) & 0xff;
		//fprintf(fp, "s %d sc %d sb %d\n", s, s >> 4, s & 0xf); fflush(fp);
		conv_scale = s>>4;
		bm_scale = s &0xf;
		if (name == DEBUG_CG_NAME && fp && debugLevel <= 1)
			fprintf(fp, "%s read BMWeights %d %d to %s\n", name.c_str(), phcg->weightBus[start].GetValue()
			, phcg->weightBus[start + 1].GetValue(), readWeights0.GetValue() ? "weights1" : "weights0");


	}

	void CShiftComputingGroup::GetOutput(DTYPE *bus, int w, int outputRows)
	{
		for (int i = 0; i < w; i++){
#ifdef S2_OPTIMIZE
			if (phcg->stride.GetValue() > 2)
				bus[i] = UCUs[i * phcg->stride.GetValue()]->GetPreOutPut(outputRows);
			else
				bus[i] = UCUs[i]->GetPreOutPut(outputRows);
#else
			bus[i] = UCUs[i * phcg->stride.GetValue()]->GetPreOutPut(outputRows);
			/*if (fp && abs(bus[i] > 1 << 15))
				fprintf(fp, "overflow %d %lf\n", bus[i], bus[i] / double(1<<15));
			if (bus[i] > ((1 << 15) - 1))
				bus[i] = ((1 << 15) - 1);
			else if (bus[i] < -((1 << 15)))
				bus[i] = -((1 << 15));*/
#endif
		}
	}
}