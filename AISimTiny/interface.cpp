#include "interface.h"

namespace CloudDesign{
	FILE *fcvi, *fcvo;

	void CInterface::Init(){
		debugLevel = DEFAULT_DEBUG_LEVEL;
		storages.push_back(&state);
		storages.push_back(&weight_len);
		storages.push_back(&weight_addr);
		storages.push_back(&weight_start);
		storages.push_back(&weight_size);
		storages.push_back(&feature_len);
		storages.push_back(&feature_addr);
		storages.push_back(&feature_start);
		storages.push_back(&feature_size);
		storages.push_back(&instruction_len);
		storages.push_back(&instruction_addr);
		storages.push_back(&instruction_start);
		storages.push_back(&instruction_size);
		storages.push_back(&new_weight);
		storages.push_back(&new_instruction);
		storages.push_back(&new_feature);

		storages.push_back(&out_len);
		storages.push_back(&out_addr);
		storages.push_back(&out_size);

		storages.push_back(&instruction_start_addr);
		storages.push_back(&new_instruction_addr);

		std::vector<CSimNode *>::const_iterator p = storages.begin();
		for (; p != storages.end(); p++)
			(*p)->Init();

		buf_received = false;
		add_output = false;
		addrbuf_enable = false;
		if (DUMP_VERIFICATION_INTERFACE){
			char filename[100];
			sprintf(filename, "%s/interface_input.txt", OUTPUT_DIR);
			fvi = fopen(filename, "wt");
			assert(fvi);
			sprintf(filename, "%s/interface_output.txt", OUTPUT_DIR);
			fvo = fopen(filename, "wt");
			assert(fvo);
		}
		else
			fvi = fvo = NULL;

		if (DUMP_VERIFICATION_CLOUD){
			char filename[100];
			sprintf(filename, "%s/cloud_input.txt", OUTPUT_DIR);
			fcvi = fopen(filename, "wt");
			assert(fcvi);
			sprintf(filename, "%s/cloud_output.txt", OUTPUT_DIR);
			fcvo = fopen(filename, "wt");
			assert(fcvo);
		}
		else
			fcvi = fcvo = NULL;

		if (DUMP_VERIFICATION_CLOUDSV){
			char filename[100];
			sprintf(filename, "%s/cloud_sv_input.txt", OUTPUT_DIR);
			fsvi = fopen(filename, "wt");
			assert(fsvi);
			sprintf(filename, "%s/cloud_sv_output.txt", OUTPUT_DIR);
			fsvo = fopen(filename, "wt");
			assert(fsvo);

			sprintf(filename, "%s/cloud_sv_outputx.txt", OUTPUT_DIR);
			fsvo2 = fopen(filename, "wt");
			assert(fsvo2);
		}
		else
			fsvi = fsvo = fsvo2 = NULL;

		if (DUMP_VERIFICATION_CLOUDSVDebug){
			char filename[100];
			sprintf(filename, "%s/cloud_sv_output_debug.txt", OUTPUT_DIR);
			fsvo3 = fopen(filename, "wt");
			assert(fsvo3);
		}
		else
			fsvo3 = NULL;
	}
	void CInterface::latch(int num)
	{
		
		std::vector<CSimNode *>::const_iterator p = storages.begin();
		for (; p != storages.end(); p++)
			(*p)->latch(num);
		if (add_output){
			out_addrs.push(add_output_address);
			out_sizes.push(add_output_size);
		}
		buf_received = false;
		add_output = false;
		addrbuf_enable = false;
	}

	void CInterface::reset()
	{
		std::vector<CSimNode *>::const_iterator p = storages.begin();
		for (; p != storages.end(); p++)
			(*p)->reset();
	}

	void CInterface::VerifyDump(int num)
	{
		if (fvi && fvo){
			fprintf(fvi, "%d %d %d %d %d\n", num + 1, buf_received
				, add_output, add_output_address, add_output_size);
			if (buf_received){
				for (int i = 0; i < INTERFACE_LEN + 8; i++)
					fprintf(fvi, " %d", buffer[i]);
				fprintf(fvi, "\n");
			}
			fprintf(fvi, " %d %d %d\n", pddrw->IsSaveLoadEnable()
				, pddrd->IsSaveLoadEnable(), pddrd->IsSaveWriteEnable());
			if (pddrw->IsSaveLoadEnable()){
				fprintf(fvi, " %d %d\n", pddrw->GetSaveLoadAddr(), pddrw->GetSaveLoadLen());
			}
			if (pddrd->IsSaveLoadEnable()){
				fprintf(fvi, " %d %d\n", pddrd->GetSaveLoadAddr(), pddrd->GetSaveLoadLen());
			}
			if (pddrd->IsSaveWriteEnable()){
				fprintf(fvi, " %d %d", pddrd->GetSaveWriteAddr(), pddrd->GetSaveWriteLen());
				for (int i = 0; i < pddrd->GetSaveWriteLen(); i++)
					fprintf(fvi, " %d", pddrd->GetSaveWriteData()[i]);
				fprintf(fvi, "\n");
				//if (fp && debugLevel <= 1)
				//	fprintf(fp, "Interface saved ddr %d (%d)\n", pddrd->GetSaveWriteAddr(), pddrd->GetSaveWriteLen());
			}

			fprintf(fvo, "%d %d %d %d %d %d\n", num, addrbuf_enable, inst_address
				, hasOutput, out_addr.GetValue() + out_len.GetValue(), GetOutLen());
			if (hasOutput){
				for (unsigned i = 0; i < GetOutLen(); i++)
					fprintf(fvo, " %d", out_buf[i]);
				fprintf(fvo, "\n");
			}
			fprintf(fvo, " %d %d\n", pddrw->IsSaveLoadEnable(), pddrd->IsSaveLoadEnable());
			if (pddrw->IsSaveLoadEnable()){
				fprintf(fvo, " %d", pddrw->GetSaveLoadLen());
				for (int i = 0; i < pddrw->GetSaveLoadLen(); i++)
					fprintf(fvo, " %d", pddrw->GetSaveLoadData()[i]);
				fprintf(fvo, "\n");
			}
			if (pddrd->IsSaveLoadEnable()){
				fprintf(fvo, " %d", pddrd->GetSaveLoadLen());
				for (int i = 0; i < pddrd->GetSaveLoadLen(); i++)
					fprintf(fvo, " %d", pddrd->GetSaveLoadData()[i]);
				fprintf(fvo, "\n");
			}
			fprintf(fvo, " %d %d %d %d\n", state == IF_OUTPUT
				, out_addr.GetValue(), out_len.GetValue(), out_size.GetValue());
		}

		if (fcvi && fcvo){
			fprintf(fcvi, "%d %d\n", num + 1, buf_received);
			if (buf_received){
				for (int i = 0; i < INTERFACE_LEN + 8; i++)
					fprintf(fcvi, " %d", buffer[i]);
				fprintf(fcvi, "\n");
			}

			fprintf(fcvo, "%d %d %d %d %d %d\n", num, addrbuf_enable, inst_address
				, hasOutput, out_addr.GetValue() + out_len.GetValue(), GetOutLen());
			if (hasOutput){
				for (unsigned i = 0; i < GetOutLen(); i++)
					fprintf(fcvo, " %d", out_buf[i]);
				fprintf(fcvo, "\n");
			}
			fprintf(fcvo, " %d %d %d\n", pddrw->IsSaveLoadEnable()
				, pddrd->IsSaveLoadEnable(), pddrd->IsSaveWriteEnable());
			if (pddrw->IsSaveLoadEnable()){
				fprintf(fcvo, " %d %d", pddrw->GetSaveLoadAddr(), pddrw->GetSaveLoadLen());
				for (int i = 0; i < pddrw->GetSaveLoadLen(); i++)
					fprintf(fcvo, " %d", pddrw->GetSaveLoadData()[i]);
				fprintf(fcvo, "\n");
			}
			if (pddrd->IsSaveLoadEnable()){
				fprintf(fcvo, " %d %d", pddrd->GetSaveLoadAddr(), pddrd->GetSaveLoadLen());
				for (int i = 0; i < pddrd->GetSaveLoadLen(); i++)
					fprintf(fcvo, " %d", pddrd->GetSaveLoadData()[i]);
				fprintf(fcvo, "\n");
			}
			if (pddrd->IsSaveWriteEnable()){
				fprintf(fcvo, " %d %d", pddrd->GetSaveWriteAddr(), pddrd->GetSaveWriteLen());
				for (int i = 0; i < pddrd->GetSaveWriteLen(); i++)
					fprintf(fcvo, " %d", pddrd->GetSaveWriteData()[i]);
				fprintf(fcvo, "\n");
				//if (fp && debugLevel <= 1)
				//	fprintf(fp, "Interface saved ddr %d (%d)\n", pddrd->GetSaveWriteAddr(), pddrd->GetSaveWriteLen());
			}
		}

		if (fsvi && fsvo){
			if (buf_received){
				for (int i = 0; i < INTERFACE_LEN + 8; i++)
					fprintf(fsvi, " %d", buffer[i]);
				fprintf(fsvi, "\n");
			}

			if (hasOutput){
				char *pdata = (char *)out_buf;
				for (unsigned i = 0; i < GetOutLen(); i++){
					fprintf(fsvo, " %d", pdata[i]);
				}
				fprintf(fsvo, "\n");
			}

			if (pddrd_ass->IsSaveWriteEnable()){
				char *pdata = (char *)(pddrd_ass->GetSaveWriteData());
				fprintf(fsvo2, " %d %d %d", num, pddrd_ass->GetSaveWriteAddr(), pddrd_ass->GetSaveWriteLen());
				for (int i = 0; i < pddrd_ass->GetSaveWriteLen(); i++){
					fprintf(fsvo2, " %d", pdata[i]);
				}
				fprintf(fsvo2, "\n");
				//if (fp && debugLevel <= 1)
				//	fprintf(fp, "Interface saved ddr %d (%d)\n", pddrd->GetSaveWriteAddr(), pddrd->GetSaveWriteLen());
			}
		}

		if (fsvo3)
		{
			for (int i = 0; i < BANK_NUM; i++)
				if (pread->reqValid[i]){
					fprintf(fsvo3, "req_enque %d %d %d %d %d %d %d\n", pread->ritem[i].addr
						, pread->ritem[i].seq, pread->ritem[i].len, pread->ritem[i].token
						, pread->ritem[i].type, pread->ritem[i].isRamA, pread->ritem[i].isRamB);
				}
			if (pread->busValid && !pread->isFeature){
				ReturnData *rd = (ReturnData *)pread->dataBus;
				fprintf(fsvo3, "ret_deque %d %d %d %d", rd->type, rd->seq, rd->len, rd->token);
				if (rd->type == TYPE_GIB){
					int slen = rd->len / 2;
					unsigned short *pdata = (unsigned short *)rd->data;
					for (int i = 0; i < slen; i++)
						fprintf(fsvo3, " %d", pdata[i]);
				}
				else
					for (unsigned i = 0; i < rd->len; i++)
						fprintf(fsvo3, " %d", rd->data[i]);
				fprintf(fsvo3, "\n");

			}
		}
	}

	void CInterface::DumpState()
	{
		if (!fp)
			return;
		fprintf(fp, "Dump %s, state %d\n"
			, name.c_str(), state.GetValue());
		fprintf(fp, "\tnew weight?(%s), weight addr %p, start %d, size %d, len %d\n"
			, new_weight.GetValue() ? "Y" : "N", weight_addr.GetValue()
			, weight_start.GetValue(), weight_size.GetValue(), weight_len.GetValue());
		fprintf(fp, "\tnew feature?(%s), feature addr %p, start %d, size %d, len %d\n"
			, new_feature.GetValue() ? "Y" : "N", feature_addr.GetValue(), feature_start.GetValue()
			, feature_size.GetValue(), feature_len.GetValue());
		fprintf(fp, "\tnew instruction?(%s), weight addr %p, start %d, size %d, len %d\n"
			, new_instruction.GetValue() ? "Y" : "N", instruction_addr.GetValue(), instruction_start.GetValue()
			, instruction_size.GetValue(), instruction_len.GetValue());

	}

	void CInterface::AddOutput(unsigned addr, unsigned sz)
	{
		//out_addrs.push(addr);
		//out_sizes.push(sz);
		add_output = true;
		add_output_address = addr;
		add_output_size = sz;
	}
	/*void CInterface::SetStartInstruction(unsigned addr)
	{
		instruction_start_addr = addr;
		new_instruction_addr = true;
	}*/

	/*void CInterface::SetWeights(unsigned char *addr, unsigned start, unsigned size)
	{
		weight_addr = addr;
		weight_start = start;
		weight_size = size;
		new_weight = true;
	}
	void CInterface::SetFeatures(unsigned char *addr, unsigned start, unsigned size)
	{
		feature_addr = addr;
		feature_start = start;
		feature_size = size;
		new_feature = true;
	}
	void CInterface::SetInstructions(unsigned char *addr, unsigned start, unsigned size)
	{
		instruction_addr = addr;
		instruction_start = start;
		instruction_size = size;
		new_instruction = true;
	}*/

	void CInterface::progress(int num)
	{
		/*startInstruction();
		loadWeights();
		loadFeatures();
		loadInstructions();
		loadOutput();
		nextState();*/
		loadOutput();
		nextState();
		VerifyDump(num);
	}

	void CInterface::nextState()
	{
		// one IDLE cycle between each transition
		if (state == IF_IDLE){
			if (new_weight.GetValue()){
				state = IF_LOAD_WEIGHT;
				new_weight = false;
				if (fp)
					fprintf(fp, "enter IF_LOAD_WEIGHT %d %d\n", weight_start.GetValue(), weight_size.GetValue());
				//weight_len = 0;
			}
			else if (new_instruction.GetValue()){
				state = IF_LOAD_INSTRUCTION;
				new_instruction = false;
				if (fp)
					fprintf(fp, "enter IF_LOAD_INSTRUCTION %d %d\n", instruction_start.GetValue(), instruction_size.GetValue());
				//instruction_len = 0;
			}
			else if (new_feature.GetValue()){
				state = IF_LOAD_FEATURE;
				new_feature = false;
				if (fp)
					fprintf(fp, "enter IF_LOAD_FEATURE %d %d\n", feature_start.GetValue(), feature_size.GetValue());
				//feature_len = 0;
			}
			else if (out_addrs.size() > 0){
				state = IF_OUTPUT;
				//out_len = 0;
				out_addr = out_addrs.front();
				out_size = out_sizes.front();
				out_addrs.pop();
				out_sizes.pop();
				if (fp)
					fprintf(fp, "enter IF_OUTPUT %d %d\n", out_addr.GetValue(), out_size.GetNextValue());
			}
		}
		else if (state == IF_LOAD_WEIGHT){
			if (weight_len.GetValue() + MAX_LOAD_WIDTH  >= weight_size.GetValue()){
				/*if (new_instruction.GetValue()){
					state = IF_LOAD_INSTRUCTION;
					new_instruction = false;
					instruction_len = 0;
				}
				else if (new_feature.GetValue()){
					state = IF_LOAD_FEATURE;
					new_feature = false;
					feature_len = 0;
				}
				else if (out_addrs.size() > 0){
					state = IF_OUTPUT;
					out_len = 0;
					out_addr = out_addrs.front();
					out_size = out_sizes.front();
					out_addrs.pop();
					out_sizes.pop();
				}
				else*/
					state = IF_IDLE;
					if (fp)
						fprintf(fp, "enter IF_IDLE\n");
			}
		}
		else if (state == IF_LOAD_INSTRUCTION){
			if (instruction_len.GetValue() + MAX_LOAD_WIDTH >= instruction_size.GetValue()){
				/*if (new_feature.GetValue()){
					state = IF_LOAD_FEATURE;
					new_feature = false;
					feature_len = 0;
				}
				else if (out_addrs.size() > 0){
					state = IF_OUTPUT;
					out_len = 0;
					out_addr = out_addrs.front();
					out_size = out_sizes.front();
					out_addrs.pop();
					out_sizes.pop();
				}
				else*/
					state = IF_IDLE;
					if (fp)
						fprintf(fp, "enter IF_IDLE\n");
			}
		}
		else if (state == IF_LOAD_FEATURE){
			if (feature_len.GetValue() + MAX_LOAD_WIDTH >= feature_size.GetValue()){
				/*if (out_addrs.size() > 0){
					state = IF_OUTPUT;
					out_len = 0;
					out_addr = out_addrs.front();
					out_size = out_sizes.front();
					out_addrs.pop();
					out_sizes.pop();
				}
				else*/
					state = IF_IDLE;
					if (fp)
						fprintf(fp, "enter IF_IDLE\n");
			}
		}
		else if (state == IF_OUTPUT){
			if (out_len.GetValue() + INTERFACE_LEN >= out_size.GetValue()){
				state = IF_IDLE;
				if (fp)
					fprintf(fp, "enter IF_IDLE\n");
			}
		}

	}

	/*void CInterface::startInstruction()
	{
		if (new_instruction_addr.GetValue() && state == IF_IDLE && !new_feature.GetValue()){
			new_instruction_addr = false;
			paddrBuf->Push(instruction_start_addr.GetValue());
		}
	}*/
	/*void CInterface::loadWeights()
	{
		if (state == IF_LOAD_WEIGHT){
			assert(weight_len.GetValue() < weight_size.GetValue());
			if (weight_len.GetValue() < weight_size.GetValue()){
				int len = MAX_LOAD_WIDTH;
				pddrw->Write(weight_start.GetValue() + weight_len.GetValue(), len, weight_addr.GetValue() + weight_len.GetValue());
				if (weight_len.GetValue() + MAX_LOAD_WIDTH >= weight_size.GetValue())
					weight_len = 0;
				else
					weight_len += len;
				if (fp && debugLevel <= 1)
					fprintf(fp, "\t%s load Weight %d\n", name.c_str(), weight_len.GetValue());
			}
		}
	}*/
	/*void CInterface::loadFeatures()
	{
		if (state == IF_LOAD_FEATURE){
			assert(feature_len.GetValue() < feature_size.GetValue());
			if (feature_len.GetValue() < feature_size.GetValue()){
				unsigned len = MAX_LOAD_WIDTH;
				if (len > feature_size.GetValue() - feature_len.GetValue())
					len = feature_size.GetValue() - feature_len.GetValue();
				pddrd->Write(feature_start.GetValue() + feature_len.GetValue(), len
					, feature_addr.GetValue() + feature_len.GetValue(), false);
				if (feature_len.GetValue() + MAX_LOAD_WIDTH >= feature_size.GetValue())
					feature_len = 0;
				else
					feature_len += len;
				if (fp && debugLevel <= 1)
					fprintf(fp, "\t%s load feature %d\n", name.c_str(), feature_start.GetValue() + feature_len.GetValue());
			}
		}
	}*/
	/*void CInterface::loadInstructions()
	{
		if (state == IF_LOAD_INSTRUCTION){
			assert(instruction_len.GetValue() < instruction_size.GetValue());
			if (instruction_len.GetValue() < instruction_size.GetValue()){
				int len = MAX_LOAD_WIDTH;
				pddrd->Write(instruction_start.GetValue() + instruction_len.GetValue(), len
					, instruction_addr.GetValue() + instruction_len.GetValue(), false);
				if (instruction_len.GetValue() + MAX_LOAD_WIDTH >= instruction_size.GetValue())
					instruction_len = 0;
				else
					instruction_len += len;
				if (fp && debugLevel <= 1)
					fprintf(fp, "\t%s load instruction %d\n", name.c_str(), instruction_len.GetValue());
			}
		}
	}*/

	void CInterface::SendData(unsigned char *state_buf)
	{
		if (state_buf[0] == SEND_ADDRESS){
			unsigned *paddr = (unsigned *)(state_buf + 3);
			paddrBuf->Push(*paddr);
			addrbuf_enable = true;
			inst_address = *paddr;
		}
		else if (state_buf[0] == SEND_WEIGHT){
			unsigned *paddr = (unsigned *)(state_buf + 3);
			unsigned short *plen = (unsigned short*)(state_buf + 1);
			pddrw->Write(*paddr, *plen, state_buf + 7, false);
		}
		else if (state_buf[0] == SEND_FEATURE || state_buf[0] == SEND_INSTRUCTION){
			unsigned *paddr = (unsigned *)(state_buf + 3);
			unsigned short *plen = (unsigned short*)(state_buf + 1);
			pddrd->Write(*paddr, *plen, state_buf + 7, false);
			if (fp && debugLevel <= 1)
				fprintf(fp, "\t%s write data %d (%d)\n", name.c_str(), *paddr, *plen);
		}
		buf_received = true;
		if (DEFAULT_DDR_SAVE || DUMP_VERIFICATION_CLOUDSV)
			memcpy(buffer, state_buf, INTERFACE_LEN + 8);
	}

	void CInterface::loadOutput()
	{
		hasOutput = false;
		if (state == IF_OUTPUT)
		{
			assert(out_len.GetValue() < out_size.GetValue());
			if (out_len.GetValue() < out_size.GetValue()){
				int len = INTERFACE_LEN;
				pddrd->Load(out_buf, out_addr.GetValue() + out_len.GetValue(), len, false);
				if (out_len.GetValue() + INTERFACE_LEN >= out_size.GetValue()){
					out_length = out_size.GetValue() - out_len.GetValue();
					out_len = 0;
				}
				else{
					out_length = len;
					out_len += len;
				}
				hasOutput = true;
				if (fp && debugLevel <= 1)
					fprintf(fp, "\t%s load output %d (%d)\n", name.c_str(), out_len.GetValue(), out_length);
			}
		}
	}
	/*bool CInterface::IsIdle()
	{
		return state == IF_IDLE && !new_weight.GetValue() && !new_instruction.GetValue()
			&& !new_feature.GetValue() && !new_instruction_addr.GetValue() && out_addrs.size() == 0;
	}*/
}
