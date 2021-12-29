//#include "interface.h"
//#include <assert.h>
//
//namespace CloudDesign{
//
//	template <int DATAWIDTH> export void CDDR<DATAWIDTH>::Init()
//	{ 
//		buf = 0; 
//		size = 0; 
//		write_pending1 = false;
//		read_pending1 = false;
//		write_pending2 = false;
//		read_pending2 = false;
//		if (DUMP_VERIFICATION_DDR){
//			char filename[100];
//			sprintf(filename, "d:/aidata/ddr1_%s_input.txt", name.c_str());
//			fvi = fopen(filename, "wt");
//			assert(fvi);
//			sprintf(filename, "d:/aidata/ddr1_%s_output1.txt", name.c_str());
//			fvo1 = fopen(filename, "wt");
//			assert(fvo1);
//			sprintf(filename, "d:/aidata/ddr1_%s_output2.txt", name.c_str());
//			fvo2 = fopen(filename, "wt");
//			assert(fvo2);
//		}
//		else
//			fvi = fvo1 = fvo2 = NULL;
//	}
//
//	
//	template <int DATAWIDTH> export void CDDR<DATAWIDTH>::reset()
//	{
//		wrValid = false;
//		size = 0;
//		saveCount = 0;
//		delete[]buf;
//		loadHolding = 0;
//		writeHolding = 0;
//		linfo.id = 0;
//		linfo.addr = 0;
//		linfo.len = 0;
//		nextWrite = false;
//		for (int i = 0; i < DDR_LANTENCY; i++){
//			delayData[i].id = 0;
//			delayData[i].isLast = false;
//		}
//	}
//
//	template <int DATAWIDTH> export void CDDR<DATAWIDTH>::DumpState()
//	{
//		if (!fp)
//			return;
//		//fprintf(fp, "Dump for %s\n", name.c_str());
//		
//	}
//	template <int DATAWIDTH> export void CDDR<DATAWIDTH>::decodeMask(unsigned strobe, unsigned &start, unsigned &len)
//	{
//		start = 0;
//		len = 0;
//		assert(strobe != 0);
//		while ((strobe & 1) == 0){
//			strobe >>= 1;
//			start++;
//		}
//		while (strobe != 0){
//			assert((strobe & 1) == 1);
//			strobe >>= 1;
//			len++;
//		}
//	}
//
//	template <int DATAWIDTH> export void CDDR<DATAWIDTH>::DumpVerificationInput(int num)
//	{
//		if (!fvi)
//			return;
//		fprintf(fvi, "%d %d %d %d %d %d", num, read_pending1, write_pending1, read_pending2, write_pending2, frozeTick);
//		
//		//if (read_pending1 && read_pending2)
//		//	fprintf(fp, "%d two_reading\n", num);
//		if (!read_pending1 && !write_pending1 && !read_pending2 && !write_pending2)
//			fprintf(fvi, "\n");
//		if (read_pending1){
//			fprintf(fvi, " %d %d %d\n", read_rid1, read_addr1, read_len1);
//			read_pending1 = false;
//		}
//		if (write_pending1){
//			fprintf(fvi, " %d %u", write_addr1, write_strobe1);
//			for (int i = 0; i < DATAWIDTH; i++)
//				fprintf(fvi, " %d", write_data1[i]);
//			write_pending1 = false;
//			fprintf(fvi, "\n");
//		}
//		if (read_pending2){
//			fprintf(fvi, " %d %d %d\n", read_rid2, read_addr2, read_len2);
//			read_pending2 = false;
//		}
//		if (write_pending2){
//			fprintf(fvi, " %d %u", write_addr2, write_strobe2);
//			for (int i = 0; i < DATAWIDTH; i++)
//				fprintf(fvi, " %d", write_data2[i]);
//			write_pending2 = false;
//			fprintf(fvi, "\n");
//		}
//	}
//
//	template <int DATAWIDTH> export void CDDR<DATAWIDTH>::DumpVerificationOutput(int num)
//	{
//		if (!fvo1)
//			return;
//
//		if (delayData[DDR_LANTENCY - 1].id == 0)
//			return;
//		assert(delayData[DDR_LANTENCY - 1].id == 1);
//		fprintf(fvo1, "%d %d %d", num, delayData[DDR_LANTENCY - 1].id, delayData[DDR_LANTENCY - 1].isLast);
//		for (int i = 0; i < DATAWIDTH; i++)
//			fprintf(fvo1, " %d", delayData[DDR_LANTENCY - 1].data[i]);
//		fprintf(fvo1, "\n");
//	}
//
//	template <int DATAWIDTH> export void CDDR<DATAWIDTH>::latch(int num)
//	{
//		DumpVerificationInput(num);
//		if (wrValid){
//			wrValid = false;
//			memcpy(buf + wrAddr, wrtmp, wrLen);
//		}
//		if (frozeTick){
//			frozeTick = false;
//			return;
//		}
//		frozeTick = false;
//		ResetSaved();
//		if (delayData[DDR_LANTENCY - 1].id != 0 && delayData[DDR_LANTENCY - 1].isLast)
//			saveCount--;
//		for (int i = DDR_LANTENCY - 1; i > 0; i--){
//			delayData[i] = delayData[i - 1];
//		}
//		delayData[0].id = 0;
//		delayData[0].isLast = false;
//		if(!ROUNDROBIN)
//			assert(saveCount >= 0);
//		
//		bool doWriting = false;
//		if (ROUNDROBIN){
//			if (nextWrite && loadHolding == 0 && !writeQueue.empty() || writeHolding > 0)
//				doWriting = true;
//			if (!nextWrite && loadHolding == 0 && loadQueue.empty() && saveCount == 0)
//				doWriting = true;
//		}
//		else
//			if (writeHolding > 0 || loadQueue.empty() && loadHolding == 0 && saveCount == 0)
//				doWriting = true;
//		
//		if (doWriting){
//			if (writeHolding > 0)
//				writeHolding--;
//			else if(!writeQueue.empty()){
//				DDR_Write_Info &winfo = writeQueue.front();
//				unsigned start, len;
//				decodeMask(winfo.strobe, start, len);
//				memcpy(buf + winfo.adr + start, winfo.data + start, len);
//				/*if (winfo.len % DDR_BANDWIDTH == 0)
//					writeHolding = winfo.len / DDR_BANDWIDTH - 1;
//				else
//					writeHolding = winfo.len / DDR_BANDWIDTH;*/
//				writeQueue.pop();
//			}
//			if (ROUNDROBIN)
//				nextWrite = false;
//		}
//		else{
//			if (loadHolding > 0){
//				if (loadHolding)
//					loadHolding--;
//				if (!loadHolding)
//					delayData[0].isLast = true;
//				delayData[0].id = load_id;
//				for (int i = 0; i < DATAWIDTH; i++){
//					delayData[0].data[i] = buf[next_load_addr + i];
//				}
//				next_load_addr += DATAWIDTH;
//			}
//			else if(!loadQueue.empty()){
//				DDR_Load_Info info = loadQueue.front();
//				loadQueue.pop();
//				saveCount++;
//				delayData[0].id = info.id;
//				load_id = info.id;
//				next_load_addr = info.addr + DATAWIDTH;
//				loadHolding = info.len;
//				if (loadHolding == 0)
//					delayData[0].isLast = true;
//				else
//					delayData[0].isLast = false;
//				for (int i = 0; i < DATAWIDTH; i++){
//					delayData[0].data[i] = buf[info.addr + i];
//				}
//			}
//			if (ROUNDROBIN)
//				nextWrite = true;
//		}
//		DumpVerificationOutput(num);
//	}
//
//	template <int DATAWIDTH> export void CDDR<DATAWIDTH>::Write(int adr, int len, unsigned char *data, bool save)
//	{
//		if (len + adr > size){
//			printf("len %d adr %d > size %d\n", len, adr, size);
//			assert(false);
//		}
//		assert(!wrValid);
//		wrValid = true;
//		wrAddr = adr;
//		wrLen = len;
//		memcpy(wrtmp, data, len);
//		if (save){
//			save_write_enable = true;
//			save_write_addr = adr;
//			save_write_len = len;
//			memcpy(save_write_data, data, len);
//			//if (fp && debugLevel <= 1)
//			//	fprintf(fp, "DDR save %d (%d)\n",  adr, len);
//		}
//		if (fvi){
//			write_pending2 = true;
//			write_addr2 = adr;
//			if (len == 32)
//				write_strobe2 = 0xffffffff;
//			else
//				write_strobe2 = ((1u << len) - 1u);
//			memcpy(write_data2, data, len);
//		}
//	}
//
//	template <int DATAWIDTH> export void CDDR<DATAWIDTH>::DelayWrite(unsigned adr, unsigned strobe, unsigned char *data, bool save)
//	{
//		assert(adr % DATAWIDTH == 0);
//		DDR_Write_Info winfo;
//		winfo.adr = adr;
//		winfo.strobe = strobe;
//		memcpy(winfo.data, data, DATAWIDTH);
//		writeQueue.push(winfo);
//		if (save){
//			save_write_enable = true;
//			unsigned start, len;
//			decodeMask(winfo.strobe, start, len);
//			//memcpy(buf + winfo.adr + start, winfo.data + start, len);
//
//			save_write_addr = adr + start;
//			save_write_len = len;
//			memcpy(save_write_data, data + start, len);
//			//if (fp && debugLevel <= 1)
//			//	fprintf(fp, "DDR save %d (%d)\n",  adr, len);
//		}
//		if (fvi){
//			write_pending1 = true;
//			write_addr1 = adr;
//			write_strobe1 = strobe;
//			memcpy(write_data1, data, DATAWIDTH);
//		}
//		/*if (fp){
//		fprintf(fp, "# DDRW%9d %08x", adr, strobe);
//		unsigned start, len;
//		decodeMask(winfo.strobe, start, len);
//		memcpy(buf + winfo.adr + start, winfo.data + start, len);
//		for (int i = 0; i < len; i++)
//		fprintf(fp, " %d", data[start+i]);
//		fprintf(fp, "\n");
//		}*/
//	}
//
//	template <int DATAWIDTH> export void CDDR<DATAWIDTH>::Load(unsigned char *out, int addr, int len, bool save){
//		for (int i = 0; i < len; i++){
//			out[i] = buf[addr + i];
//		}
//
//		if (save){
//			save_load_enable = true;
//			save_load_addr = addr;
//			save_load_len = len;
//			for (int i = 0; i < len; i++)
//				save_load_data[i] = buf[addr + i];
//			//memcpy(save_load_data, buf + addr, len);
//		}
//		if (fvi){
//			assert(len <= 32);
//			read_pending2 = true;
//			read_rid2 = 2;
//			read_addr2 = addr;
//			read_len2 = 0;
//		}
//		if (!fvo2)
//			return;
//		assert(len <= DATAWIDTH);
//		if ((addr & 0x1f) != 0){
//			printf("addr violate %d\n", addr);
//			assert(0);
//		}
//		fprintf(fvo2, "%d %d %d", 0, 2, 1);
//		for (int i = 0; i < DATAWIDTH; i++)
//			fprintf(fvo2, " %d", buf[addr + i]);
//		fprintf(fvo2, "\n");
//	}
//
//	template <int DATAWIDTH> export void CDDR<DATAWIDTH>::DelayLoad(int id, int addr, int len, bool save)
//	{
//		assert(len <= MAX_DATA_LOAD_SIZE);
//		assert(addr % DATAWIDTH == 0);
//		linfo.id = id;
//		linfo.addr = addr;
//		linfo.len = len;
//		loadQueue.push(linfo);
//		assert(!LoadOverFull());
//		if (save){
//			save_load_enable = true;
//			save_load_addr = addr;
//			save_load_len = len;
//			for (int i = 0; i < len; i++)
//				save_load_data[i] = buf[addr + i];
//			//memcpy(save_load_data, buf + addr, len);
//		}
//		if (fvi){
//			assert(id == 1);
//			read_pending1 = true;
//			read_rid1 = id;
//			read_addr1 = addr;
//			read_len1 = len;
//		}
//	}
//	template <int DATAWIDTH> export bool CDDR<DATAWIDTH>::DataValid(int id)
//	{
//		return delayData[DDR_LANTENCY - 1].id == id;
//	}
//	template <int DATAWIDTH> export unsigned char *CDDR<DATAWIDTH>::DelayData()
//	{
//		return delayData[DDR_LANTENCY - 1].data;
//		/*DDR_Load_Info tmp = delayData[DDR_LANTENCY - 1];
//		for (int i = 0; i < tmp.len; i++){
//			loadtmp[i] = buf[tmp.addr + i];
//		}
//		return loadtmp;*/
//	}
//
//}
