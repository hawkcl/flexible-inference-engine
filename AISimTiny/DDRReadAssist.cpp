//#include "sim.h"
//#include "interface.h"
//#include <assert.h>
//
//namespace CloudDesign{
//
//	template <int DATAWIDTH> void CDDRReadAssist<DATAWIDTH>::Init()
//	{ 
//		debugLevel = DEFAULT_DEBUG_LEVEL;
//		storages.push_back(&next_addr);
//		storages.push_back(&buf_addr);
//		for (int i = 0; i < DATAWIDTH; i++){
//			storages.push_back(saved_buf + i);
//		}
//		reset();
//
//		if (DUMP_VERIFICATION_DDRREADASST){
//			char filename[100];
//			sprintf(filename, "d:/aidata/ddrread_%s_input.txt", name.c_str());
//			fvi = fopen(filename, "wt");
//			assert(fvi);
//			sprintf(filename, "d:/aidata/ddrread_%s_output.txt", name.c_str());
//			fvo = fopen(filename, "wt");
//			assert(fvo);
//		}
//		else
//			fvi = fvo = NULL;
//		req_valid = false;
//		read_request = false;
//		read_freeze = false;
//		start_dump = false;
//		out_len = 0;
//	}
//	template <int DATAWIDTH> void CDDRReadAssist<DATAWIDTH>::reset()
//	{
//		std::vector<CSimNode *>::const_iterator p = storages.begin();
//		for (int i = 0; p != storages.end(); p++, i++)
//			(*p)->reset();
//	}
//
//	template <int DATAWIDTH> void CDDRReadAssist<DATAWIDTH>::DumpState()
//	{
//		if (!fp)
//			return;
//		//fprintf(fp, "Dump for %s\n", name.c_str());
//		
//	}
//
//	template <int DATAWIDTH> void CDDRReadAssist<DATAWIDTH>::latch(int num)
//	{
//		DumpVerificationFinish(num);
//		std::vector<CSimNode *>::const_iterator p = storages.begin();
//		for (int i = 0; p != storages.end(); p++, i++)
//			(*p)->latch(num);
//		vid = DDR_NOID;
//	}
//
//	template <int DATAWIDTH> void CDDRReadAssist<DATAWIDTH>::DumpVerificationFinish(int)
//	{
//		if (!fvi || !fvo)
//			return;
//		if (!start_dump)
//			return;
//
//		if (!req_valid)
//			fprintf(fvi, " 0\n");
//		req_valid = false;
//
//		if (!read_request)
//			fprintf(fvo, " 0");
//		fprintf(fvo, " %d", read_freeze);
//		read_freeze = false;
//		read_request = false;
//
//		fprintf(fvo, " %d", vid);
//		if (vid != DDR_NOID){
//			fprintf(fvo, " %d", out_len);
//			for (int i = 0; i < out_len; i++)
//				fprintf(fvo, " %d", data[i]);
//		}
//		fprintf(fvo, "\n");
//		fprintf(fvo, " %d %d %d", next_addr.GetValue(), buf_addr.GetValue(), buf_addr.GetNextValue());
//		for (int i = 0; i < DATAWIDTH; i++)
//			fprintf(fvo, " %d", saved_buf[i].GetValue());
//		fprintf(fvo, "\n");
//		if (buf_addr.GetNextValue() > 0)
//			for (unsigned i = 0; i < buf_addr.GetNextValue(); i++)
//				fprintf(fvo, " %d", data[i]);
//		fprintf(fvo, "\n");
//	}
//
//	template <int DATAWIDTH> void CDDRReadAssist<DATAWIDTH>::DumpVerificationStart(int num)
//	{
//		if (!fvi || !fvo)
//			return;
//		if (num > 72600)
//			start_dump = true;
//		if (!start_dump)
//			return;
//		fprintf(fvi, "%d %d", num, pddr->GetDDRID());
//		if (pddr->GetDDRID() != 0){
//			fprintf(fvi, " %d", pddr->IsLast());
//			unsigned char *pbuf = pddr->DelayData();
//			for (int i = 0; i < DATAWIDTH; i++)
//				fprintf(fvi, " %d", pbuf[i]);
//		}
//		fprintf(fvi, "\n");
//
//		fprintf(fvo, "%d %d", num, this->readReady());
//	}
//
//	template <int DATAWIDTH> void CDDRReadAssist<DATAWIDTH>::progress(int num)
//	{
//		DumpVerificationStart(num);
//		if (infos.size() == 0)
//			return;
//		CReadAssistInfo info = infos.front();
//		if (info.saved_len > 0 && info.saved_only){
//			infos.pop();
//			vid = info.id;
//			for (unsigned i = 0; i < info.saved_len; i++)
//				data[i] = saved_buf[info.saved_addr + i].GetValue();
//			pddr->FrozeTick();
//			read_freeze = true;
//			out_len = info.saved_len;
//		}
//		else if (pddr->DataValid(cid)){
//			unsigned char *pbuf = pddr->DelayData();
//			int adr;
//			int read_len = DATAWIDTH;
//			if (buf_addr.GetValue() == 0 && !pddr->IsLast())
//				read_len = DATAWIDTH - info.first_addr;
//			//islast not relevent for read_len, only for verification
//			if (buf_addr.GetValue() == 0 && pddr->IsLast())
//				read_len = info.last_len - info.first_addr;
//			else if (pddr->IsLast())
//				read_len = info.last_len;
//
//
//			if (buf_addr.GetValue() == 0 && info.saved_len > 0)
//				adr = info.saved_len;
//			else
//				adr = buf_addr.GetValue();
//			
//			int faddr = 0;
//			if (buf_addr.GetValue() == 0)
//				faddr = info.first_addr;
//			for (unsigned i = 0; i < MAX_LOAD_WIDTH * SZ_DTYPE; i++){
//				if (/*pddr->IsLast() && */i < info.saved_len)
//					data[i] = saved_buf[i + info.saved_addr].GetValue();
//				else if (i >= adr)
//					data[i] = pbuf[(faddr + i - adr) % DATAWIDTH];
//				/*else if (pddr->IsLast() && buf_addr.GetValue() == 0){
//					if (i >= adr && i < adr + info.last_len - info.first_addr)
//						data[i] = pbuf[info.first_addr + i - adr];
//				}
//				else if (pddr->IsLast()){
//					if (i >= adr && i < adr + info.last_len) // only need i >= adr
//						data[i] = pbuf[i - adr];
//				}
//				else if (adr == 0){ // first receive no saved
//					read_len = DDR_DATAWIDTH - info.first_addr;
//					if (i < DDR_DATAWIDTH - info.first_addr) // no need
//						data[i] = pbuf[i + info.first_addr];
//				}
//				else{
//					if (i >= adr && i < adr + DDR_DATAWIDTH) // only need i >= adr
//						data[i] = pbuf[i - adr];
//				}*/
//
//			}
//			if (fp){
//				fprintf(fp, "rass %d, slen %d, saddr %d, sonly?(%s), faddr %d, llen %d\n", num, info.saved_len
//					, info.saved_addr, info.saved_only ? "Y" : "N", info.first_addr, info.last_len);
//				for (unsigned i = 0; i < MAX_LOAD_WIDTH * SZ_DTYPE; i++)
//					fprintf(fp, " %d", data[i]);
//				fprintf(fp, "\n");
//			}
//			if (pddr->IsLast()){
//				infos.pop();
//				vid = info.id;
//				buf_addr = 0;
//				out_len = adr + read_len;
//				for (int i = 0; i < DATAWIDTH; i++)
//					saved_buf[i] = pbuf[i];
//			}
//			else
//				buf_addr = adr + read_len;
//		}
//	}
//	template <int DATAWIDTH> void CDDRReadAssist<DATAWIDTH>::DelayLoad(DDR_ID id, int addr, int len)
//	{
//		if (fvi && start_dump)
//			fprintf(fvi, " 1 %d %d %d\n", id, addr, len);
//		req_valid = true;
//		CReadAssistInfo info;
//		info.id = id;
//		int axi_len;
//		int saddr = (addr / DATAWIDTH) * DATAWIDTH;
//		int eaddr = addr + len;
//		if (eaddr % DATAWIDTH != 0){
//			int eaddr0 = (eaddr / DATAWIDTH) * DATAWIDTH;
//			info.last_len = eaddr - eaddr0;
//			eaddr = eaddr0 + DATAWIDTH;
//		}
//		else
//			info.last_len = DATAWIDTH;
//		if (saddr + DATAWIDTH == next_addr.GetValue()){
//			info.saved_addr = addr - saddr;
//			if ((next_addr.GetValue() - addr) >= len){
//				info.saved_len = len;
//				info.saved_only = true;
//				//axi_len = 0;
//			}
//			else{
//				info.saved_len = (next_addr.GetValue() - addr);
//				info.saved_only = false;
//			}
//			saddr = next_addr.GetValue();
//			info.first_addr = 0;
//		}
//		else{
//			info.saved_addr = 0;
//			info.saved_len = 0;
//			info.saved_only = false;
//			info.first_addr = addr - saddr;
//		}
//		axi_len = (eaddr - saddr) / DATAWIDTH;
//		infos.push(info);
//		if (fp){
//			fprintf(fp, "dass ask %d %d, saddr %d, llen %d\n", addr, len, info.saved_addr, info.last_len);
//		}
//		if (axi_len > 0){
//			pddr->DelayLoad(cid, saddr, axi_len - 1);
//			next_addr = eaddr;
//			read_request = true;
//			if (fvo && start_dump)
//				fprintf(fvo, " 1 %d %d %d", cid, saddr, axi_len-1);
//		}
//
//	}
//	
//}
