#include "sim.h"
#include <assert.h>
namespace CloudDesign{
	void CUnifiedComputingUnit::Init(){
		storages.push_back(&input);
		storages.push_back(&shift);
		storages.push_back(&backup);
#ifdef S2_OPTIMIZE
		storages.push_back(&backup2);
		storages.push_back(&S2);
#endif
		storages.push_back(&outputs0);
		storages.push_back(&outputs1);
		std::vector<CSimNode *>::const_iterator p = storages.begin();
		for (; p != storages.end(); p++)
			(*p)->Init();
		debugLevel = DEFAULT_DEBUG_LEVEL;
	}

	CUnifiedComputingUnit::~CUnifiedComputingUnit()
	{
		delete pucl;
	}

	void CUnifiedComputingUnit::ReadInput(INPUT_SOURCE is, int i, CHomoGeneousComputingBank *phcg)
	{
		if (is == INPUT_X){
			input.SetValue(phcg->GetBackUp(i));
		}
		else if (is == INPUT_BACKUP){
			input.SetValue(backup.GetValue());
			shift.SetValue(backup.GetValue());
#ifdef S2_OPTIMIZE
			S2.SetValue(backup2.GetValue());
#endif
		}
		else if (is == INPUT_E){
#ifdef S2_OPTIMIZE
			if (phcg->IsStride2()){
				input.SetValue(S2.GetValue());
				if (isLast)
					S2.SetValue(phcg->GetShiftInput(pscg->conv_idx.GetValue()));
				else
					S2.SetValue(right->GetInput());
			}
			else
#endif
			{
				if (isLast)
					input.SetValue(phcg->GetShiftInput(pscg->conv_idx.GetValue()));
				else
					input.SetValue(right->GetInput());
			}
		}
		else if (is == INPUT_S){
			input.SetValue(below->GetShift());
			shift.SetValue(below->GetShift());
		}
	}

	DTYPE CUnifiedComputingUnit::GetPreOutPut(int outputRows)
	{
		if (pscg->isOutput0.GetValue())
			return (DTYPE)outputs1.GetValue(outputRows);
		else
			return (DTYPE)outputs0.GetValue(outputRows);
	}

	void CUnifiedComputingUnit::progress(int num)
	{
		/*if (fp && debugLevel <= 1){
			fprintf(fp, "%s ucu progress\n", name.c_str());
			fflush(fp);
		}*/
		num = num;
		DTYPE2 o = pscg->isOutput0.GetValue() 
			? outputs0.GetValue(pscg->phcg->GetOutputReadPos())
			: outputs1.GetValue(pscg->phcg->GetOutputReadPos());
		if (pscg->phcg->GetState() == CONV_BM)
			o = o >> pscg->GetConvScale();
		DTYPE2 low = DTYPE(0);
		if (below)
			low = below->GetOutPut();
		bool debug = false;
		//if (pscg->phcg->GetName() == DEBUG_BANK_NAME)

		//if (name[4] == '0'&& name[8] >= '0' && name[8] <= '2' && name[12] == '0')
		if (name == DEBUG_CU_NAME)
			debug = true;
		
		out = pucl->eval(pscg, input.GetValue(), pscg->weight.GetValue(), o, low, debug);

		if (fp && debugLevel <= 1 && debug && (pscg->phcg->GetState() == CONV_MULT || pscg->phcg->GetState() == CONV_BM || pscg->phcg->GetState() == CONV_RELU)){
		//	fprintf(fp, "\tamux %d, sq_mux %d, iter %d\n", pscg->aMux, pscg->sqMux, pscg->phcg->GetIterCountDown());
		//	fprintf(fp, "\tmq %d, aq %d, sq %d, psumq %d\n", pucl->GetMQ(), pucl->GetAQ(), pucl->GetSQ(), pucl->GetPSUMQ());
			fprintf(fp, "\t%s rpos %d, o "DFMT", low "DFMT", input "DFMT", weight "DFMT", out "DFMT" to %d %s\n",
				name.c_str(), pscg->phcg->GetOutputReadPos(), o, low, input.GetValue(), pscg->weight.GetValue(),
				out, pscg->phcg->GetOutputWritePos(), pscg->phcg->IsOutputReady() ? "OUT" : "DISCARD");
		}

		if (pscg->phcg->IsOutputReady()){
			//if (pscg->phcg->DoOutScale())
			//	out >>= pscg->GetConvScale();
			if (pscg->isOutput0.GetValue())
				outputs0.SetValue(out, pscg->phcg->GetOutputWritePos());
			else
				outputs1.SetValue(out, pscg->phcg->GetOutputWritePos());
		}
		/*if (fp && debugLevel <= 1){
			fprintf(fp, "%s ucu progress2\n", name.c_str());
			fflush(fp);
		}
*/
	}

	DTYPE CUnifiedComputingLogic::eval(CShiftComputingGroup *pscg, DTYPE x, DTYPE w
		, DTYPE2 psum, DTYPE2 low, bool debug)
	{
		DTYPE m1;
		DTYPE psum_1 = psum;
#ifdef YOLO
		if (psum_1 < -((1 << (FEATURE_BIT_SIZE - 1)))){
			psum_1 = -((1 << (FEATURE_BIT_SIZE - 1)));
			//if (fp)
			//	fprintf(fp, "psum underflow %d\n", psum);
		}
		if (psum_1 >(((1 << (FEATURE_BIT_SIZE - 1))) - 1)){
			psum_1 = (((1 << (FEATURE_BIT_SIZE - 1))) - 1);
			//if (fp)
				//fprintf(fp, "psum overflow %d\n", psum);
		}
#endif
		if (pscg->mMux == UCLM_X)
			m1 = x;
		else{
#ifdef YOLO
			m1 = psum_1 ;
#else
			m1 = psum;
#endif

		}
		DTYPE2 mul = m1 * w;
		if (IS_EQUAL(m1, 0))
			mul = 0;
		else if (IS_EQUAL(w, 0))
			mul = 0;
#ifdef YOLO
		if (mul > ((1 << (MULT_BIT_SIZE-1)) - 1)){
			if (debug && fp)
				fprintf(fp, "\t\tmq overflow %d\n", mul);
			mul = ((1 << (MULT_BIT_SIZE - 1)) - 1);
		}
		else if (mul < -((1 << (MULT_BIT_SIZE - 1)))){
			if (debug && fp)
				fprintf(fp, "\t\tmq underflow %d\n", mul);
			mul = -((1 << (MULT_BIT_SIZE - 1)));
			
		}
#endif
		mq.SetValue(mul);
		//if (debug && fp)
		//	fprintf(fp, "\t\tmq %d %d , ", mq.GetValue(), mq.GetNextValue());

		DTYPE2 a0m;
		if (pscg->a0Mux == UCLA0_MUL)
			a0m = mq.GetValue();
		else if (pscg->a0Mux == UCLA0_MS)
			a0m = mq.GetValue() >> pscg->GetBMScale();
		else
			a0m = x;// intend for Res layer, may not need anymore


		DTYPE2 am;
		if (pscg->aMux == UCLA_W)
			am = w;
		else if (pscg->aMux == UCLA_PSUM)
			am = psum;
		else if (pscg->aMux == UCLA_AQ)
			am = aq.GetValue();
		else
			am = 0;

		DTYPE2 add1 = a0m + am;
#ifdef YOLO
		int mask = (add1 >> (MULT_BIT_SIZE - 1)) & 3;
		if (mask == 1){
			add1 = ((1 << (MULT_BIT_SIZE - 1)) - 1);
		}
		else if (mask == 2){
			add1 = -((1 << (MULT_BIT_SIZE - 1)));

		}
#endif
		if (add1 > max_add1)
			max_add1 = add1;
		if (-add1 > max_add1)
			max_add1 = -add1;

		if (IS_EQUAL(a0m, 0))
			add1 = am;
		else if (IS_EQUAL(am, 0))
			add1 = a0m;

		/*DTYPE2 c0;
		if (pscg->c0Mux == UCLC0_X)
			c0 = x;
		else if (pscg->c0Mux == UCLC0_LOW)
			c0 = low;
		else
			c0 = psum;
		DTYPE2 c1;
		if (pscg->c1Mux == UCLC1_W)
			c1 = w;
		else
			c1 = sq.GetValue();
		bool cmp = (c0 > c1);
		DTYPE2 cmux = cmp ? c0 : c1;
		cmpQ.SetValue(cmp);
		cmpQ1.SetValue((!cmpQ.GetValue()) && cmp);
		cmpQ2.SetValue(cmpQ1.GetValue());*/

		/*DTYPE aqm;
		if (pscg->aqMux == UCLAQ_PLUS)
		aqm = add1;
		else
		aqm = aq.GetValue();
		aq.SetValue(aqm);
		*/
		DTYPE2 aqm = add1;
		//if (pscg->isAct.GetValue()){ //activation
		//	if (cmpQ2.GetValue())
		//		aqm = add1;
		//	else
		//		aqm = aq.GetValue();
		//}
		//else{
		//	if (pscg->aqMux == UCLAQ_PLUS)
		//		aqm = add1;
		//	else
		//		aqm = aq.GetValue();
		//}
#ifdef YOLO
		if (aqm > ((1 << (MULT_BIT_SIZE - 1)) - 1)){
			aqm = ((1 << (MULT_BIT_SIZE - 1)) - 1);
			assert(false);
		}
		else if (aqm < -((1 << (MULT_BIT_SIZE - 1)))){
			aqm = -((1 << (MULT_BIT_SIZE - 1)));
			assert(false);

		}
#endif
		aq.SetValue(aqm);
		//if (debug && fp)
		//	fprintf(fp, "aq %d %d , ", aq.GetValue(), aq.GetNextValue());


		DTYPE2 sam = low;
		/*if (pscg->saMux == UCLSA_X)
			sam = x;
		else
			sam = low;*/
		DTYPE2 add2 = sam + sq.GetValue();
#ifdef YOLO
	    mask = (add2 >> (MULT_BIT_SIZE - 1)) & 3;
		if (mask == 1){
			add2 = ((1 << (MULT_BIT_SIZE - 1)) - 1);
		}
		else if (mask == 2){
			add2 = -((1 << (MULT_BIT_SIZE - 1)));

		}
#endif
		if (add2 > max_add2)
			max_add2 = add2;
		if (-add2 > max_add2)
			max_add2 = -add2;

		if (IS_EQUAL(sam, 0))
			add2 = sq.GetValue();
		else if (IS_EQUAL(sq.GetValue(), 0))
			add2 = sam;
		DTYPE2 sqm;
		if (pscg->sqMux == UCLSQ_AQ)
			sqm = aq.GetValue();
		else if (pscg->sqMux == UCLSQ_PLUS)
			sqm = add2;
		else
			sqm = sq.GetValue();
#ifdef YOLO
		if (sqm > ((1 << (MULT_BIT_SIZE - 1)) - 1)){
			printf("add2 %d, mask %d, sqm %d, sqmux %d, aq %d, sq %d\n"
				, add2, mask, sqm, pscg->sqMux, aq.GetValue(), sq.GetValue());
			sqm = ((1 << (MULT_BIT_SIZE - 1)) - 1);
			assert(false);
		}
		else if (sqm < -((1 << (MULT_BIT_SIZE - 1)))){
			printf("add2 %d, mask %d, sqm %d, sqmux %d, aq %d, sq %d\n"
				, add2, mask, sqm, pscg->sqMux, aq.GetValue(), sq.GetValue());
			sqm = -((1 << (MULT_BIT_SIZE - 1)));
			assert(false);
		}
#endif
		sq.SetValue(sqm);
		//if (debug && fp)
		//fprintf(fp, "sq %d %d\n", sq.GetValue(), sq.GetNextValue());
		psumq.SetValue(psum_1);

		DTYPE2 lky;
		if (pscg->lMux == UCLL_0)
			lky = 0;
		else{
			lky = (mq.GetValue() >> pscg->phcg->GetOutWScale());
		}
		DTYPE2 relu;
		if (psumq.GetValue() > 0)
			relu = psumq.GetValue();
		else
			relu = lky;


		switch (pscg->oMux){
		case UCLO_AQ: return aq.GetValue();
		case UCLO_RELU: 
			if (relu < -((1 << (FEATURE_BIT_SIZE - 1)))){
				if (fp)
					fprintf(fp, "relu underflow %d\n", relu);
			}
			if (relu >(((1 << (FEATURE_BIT_SIZE - 1))) - 1)){
				if (fp)
				fprintf(fp, "relu overflow %d\n", relu);
			}
			return relu;
		case UCLO_SQ: return sq.GetValue();
		default:assert(false); return 0;
		}
	}

	void CUnifiedComputingLogic::Init(){
		storages.push_back(&mq);
		storages.push_back(&psumq);
		storages.push_back(&aq);
		storages.push_back(&sq);
		//storages.push_back(&cmpQ);
		//storages.push_back(&cmpQ1);
		//storages.push_back(&cmpQ2);
		debugLevel = DEFAULT_DEBUG_LEVEL;
		std::vector<CSimNode *>::const_iterator p = storages.begin();
		for (; p != storages.end(); p++)
			(*p)->Init();
	}
}