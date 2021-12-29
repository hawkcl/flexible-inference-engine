#include "sim.h"
#include "interface.h"
#include <assert.h>

namespace CloudDesign{

	void CDDRWriteAssist::Init()
	{ 
		debugLevel = DEFAULT_DEBUG_LEVEL;
		storages.push_back(&buf_addr);
		storages.push_back(&buf_start);
		storages.push_back(&buf_end);
		storages.push_back(&idle_count);
		storages.push_back(&busy_state);
		storages.push_back(&buf_used);
		storages.push_back(&next_fifo_addr);
		for (int i = 0; i < DDR_DATAWIDTH; i++){
			//storages.push_back(saved_buf + i);
		}
		reset();

		if (DUMP_VERIFICATION_DDRWRITEASST){
			char filename[100];
			sprintf(filename, "%s/ddrwrite_%s_input.txt", OUTPUT_DIR, name.c_str());
			fvi = fopen(filename, "wt");
			assert(fvi);
			sprintf(filename, "%s/ddrwrite_%s_output.txt", OUTPUT_DIR, name.c_str());
			fvo = fopen(filename, "wt");
			assert(fvo);
		}
		else
			fvi = fvo = NULL;
		write_request = false;
	}
	void CDDRWriteAssist::reset()
	{
		info_valid = false;
		std::vector<CSimNode *>::const_iterator p = storages.begin();
		for (int i = 0; p != storages.end(); p++, i++)
			(*p)->reset();
		memset(saved_buf, 0, DDR_DATAWIDTH);
		save_write_enable = false;
	}

	void CDDRWriteAssist::DumpState()
	{
		if (!fp)
			return;
		//fprintf(fp, "Dump for %s\n", name.c_str());
		
	}

	void CDDRWriteAssist::DumpVerificationStart(int num)
	{
		if (!fvi || !fvo)
			return;
		if (num > 73560)
			start_dump = true;
		if (!start_dump)
			return;
		fprintf(fvi, "%d %d", num, pddr->writeReady());
		fprintf(fvo, "%d %d", num, this->writeReady());
	}

	void CDDRWriteAssist::DumpVerificationFinish(int)
	{
		if (!fvi || !fvo)
			return;
		if (!start_dump)
			return;

		fprintf(fvi, " %d", info_valid);
		if (info_valid){
			fprintf(fvi, " %d %d", winfo.addr, winfo.len);
			for (unsigned i = 0; i < winfo.len; i++)
				fprintf(fvi, " %d", winfo.data[i]);
		}
		fprintf(fvi, "\n");

		if (!write_request)
			fprintf(fvo, " 0\n");
		write_request = false;
		fprintf(fvo, " %d %d %d %d %d %d %d\n", buf_addr.GetValue()
			, buf_start.GetValue(), buf_end.GetValue(), idle_count.GetValue()
			, next_fifo_addr.GetValue(), busy_state.GetValue(), buf_used.GetValue());
		for (int i = 0; i < DDR_DATAWIDTH; i++)
			fprintf(fvo, " %d", saved_buf[i]);
		fprintf(fvo, "\n");

		fprintf(fvo, " %d %d %d %d %d %d\n", flash_saved
			, do_process, saved_pos, saved_start
			, data_pos, saddr);
	}

	
	void CDDRWriteAssist::DumpDDRWrite(unsigned adr, unsigned long long strobe, unsigned char *data)
	{
		if (!start_dump)
			return;
		fprintf(fvo, " 1 %d %d %u", cid, adr, strobe);
		for (int i = 0; i < DDR_DATAWIDTH; i++)
			fprintf(fvo, " %d", data[i]);
		fprintf(fvo, "\n");
		write_request = true;
	}

	void CDDRWriteAssist::latch(int num)
	{
		DumpVerificationFinish(num);
		if (info_valid)
		{
			info_valid = false;
			winfos.push(winfo);
		}
		save_write_enable = false;
		std::vector<CSimNode *>::const_iterator p = storages.begin();
		for (int i = 0; p != storages.end(); p++, i++)
			(*p)->latch(num);
	}
	void CDDRWriteAssist::progress(int num)
	{
		DumpVerificationStart(num);
		flash_saved = false;
		do_process = false;
		saved_pos = 0;
		saved_start = 0;
		data_pos = 0;
		saddr = 0;

		if (!pddr->writeReady())
			return;
		if (buf_used.GetValue()){
			assert(!busy_state.GetValue());
			assert(buf_end.GetValue() > buf_start.GetValue());
			if (winfos.size() == 0){
				if (idle_count.GetValue() < MAX_WRITE_IDLE_COUNT)
					idle_count++;
				else
					flash_saved = true;
			}
			else{
				CWriteAssistInfo &info = winfos.front();
				if (buf_addr.GetValue() + buf_end.GetValue() != info.addr){
					flash_saved = true;
				}
				else{
					do_process = true;
					saddr = buf_addr.GetValue();
					saved_pos = buf_end.GetValue();
					data_pos = 0;
					saved_start = buf_start.GetValue();
				}
			}
		}
		else{
			if (busy_state.GetValue()){
				assert(winfos.size() > 0);
				CWriteAssistInfo &info = winfos.front();
				do_process = true;
				saddr = next_fifo_addr.GetValue();
				saved_pos = 0;
				data_pos = next_fifo_addr.GetValue() - info.addr;
				saved_start = 0;
			}
			else if (winfos.size() > 0){
				CWriteAssistInfo &info = winfos.front();
				do_process = true;
				saddr = (info.addr / DDR_DATAWIDTH) * DDR_DATAWIDTH;
				//saved_pos = info.addr - saddr;
				saved_pos = info.addr & (DDR_DATAWIDTH - 1);
				data_pos = 0;
				saved_start = saved_pos;
			}
		}
		if (flash_saved){
			unsigned long long mask = GetStrobe(buf_start.GetValue(), buf_end.GetValue());
			pddr->DelayWrite(buf_addr.GetValue(), mask, saved_buf);
			DumpDDRWrite(buf_addr.GetValue(), mask, saved_buf);
			buf_used = false;
		}
		else if (do_process){
			assert(winfos.size() > 0);
			CWriteAssistInfo &info = winfos.front();
			if (info.addr + info.len < saddr + DDR_DATAWIDTH){
				//int len = info.addr + info.len - saddr - saved_pos;
				//for (unsigned i = 0; i < len; i++)
				//	saved_buf[saved_pos + i] = info.data[data_pos + i];
				//unsigned len = info.addr + info.len - saddr;
				unsigned len = (info.addr + info.len) & (DDR_DATAWIDTH - 1);
				for (unsigned i = 0; i < DDR_DATAWIDTH; i++)
					if (i >= saved_pos && i < len)
						saved_buf[i] = info.data[data_pos + i - saved_pos];
				buf_end = saved_pos + len - saved_pos;
				buf_start = saved_start;
				busy_state = false;
				buf_used = true;
				buf_addr = saddr;
				idle_count = 0;
				winfos.pop();
			}
			else{
				//for (int i = 0; i < DDR_DATAWIDTH - saved_pos; i++)
				//	saved_buf[saved_pos + i] = info.data[data_pos + i];
				for (unsigned i = 0; i < DDR_DATAWIDTH; i++)
					if (i >= saved_pos)
						saved_buf[i] = info.data[data_pos + i - saved_pos];
				unsigned long long mask = GetStrobe(saved_start, DDR_DATAWIDTH);
				pddr->DelayWrite(saddr, mask, saved_buf);
				DumpDDRWrite(saddr, mask, saved_buf);
				buf_used = false;
				if (info.addr + info.len == saddr + DDR_DATAWIDTH){
					winfos.pop();
					busy_state = false;
				}
				else{
					busy_state = true;
					next_fifo_addr = saddr + DDR_DATAWIDTH;
				}
			}
		}
	}
	/* original
	void CDDRWriteAssist::progress(int num)
	{
		if (buf_used.GetValue()){
			assert(!busy_state.GetValue());
			assert(buf_end.GetValue() > buf_start.GetValue());
			if (winfos.size() == 0){
				if (idle_count.GetValue() < MAX_WRITE_IDLE_COUNT){
					idle_count++;
				}
				else{
					unsigned mask = GetStrobe(buf_start.GetValue(), buf_end.GetValue());
					pddr->DelayWrite(buf_addr.GetValue(), mask, saved_buf);
					buf_used = false;
				}
			}
			else{
				CWriteAssistInfo &info = winfos.front();
				if (buf_addr.GetValue() + buf_end.GetValue() != info.addr){
					unsigned mask = GetStrobe(buf_start.GetValue(), buf_end.GetValue());
					pddr->DelayWrite(buf_addr.GetValue(), mask, saved_buf);
					buf_used = false;
				}
				else{
					if (info.addr + info.len < buf_addr.GetValue() + DDR_DATAWIDTH){
						for (unsigned i = 0; i < info.len; i++)
							saved_buf[buf_end.GetValue() + i] = info.data[i];
						buf_end = buf_end.GetValue() + info.len;
						winfos.pop();
					}
					else{
						for (unsigned i = 0; i < DDR_DATAWIDTH - buf_end.GetValue(); i++)
							saved_buf[buf_end.GetValue() + i] = info.data[i];
						unsigned mask = GetStrobe(buf_start.GetValue(), DDR_DATAWIDTH);
						pddr->DelayWrite(buf_addr.GetValue(), mask, saved_buf);
						buf_used = false;
						if (info.addr + info.len == buf_addr.GetValue() + DDR_DATAWIDTH)
							winfos.pop();
						else{
							busy_state = true;
							next_fifo_addr = buf_addr.GetValue() + DDR_DATAWIDTH;
						}
					}
				}
			}
		}
		else{
			if (busy_state.GetValue()){
				assert(winfos.size() > 0);
				CWriteAssistInfo &info = winfos.front();
				if (info.addr + info.len < next_fifo_addr.GetValue() + DDR_DATAWIDTH){
					int len = info.addr + info.len - next_fifo_addr.GetValue();
					for (int i = 0; i < len ; i++)
						saved_buf[i] = info.data[next_fifo_addr.GetValue() - info.addr + i];
					buf_end = len;
					buf_start = 0;
					busy_state = false;
					buf_used = true;
					buf_addr = next_fifo_addr.GetValue();
					idle_count = 0;
					winfos.pop();
				}
				else{
					for (int i = 0; i < DDR_DATAWIDTH; i++)
						saved_buf[i] = info.data[next_fifo_addr.GetValue() - info.addr + i];
					unsigned mask = GetStrobe(0, DDR_DATAWIDTH);
					pddr->DelayWrite(next_fifo_addr.GetValue(), mask, saved_buf);
					buf_used = false;
					if (info.addr + info.len == next_fifo_addr.GetValue() + DDR_DATAWIDTH){
						winfos.pop();
						busy_state = false;
					}
					else{
						next_fifo_addr = next_fifo_addr.GetValue() + DDR_DATAWIDTH;
					}
				}
			}
			else if (winfos.size() > 0){
				CWriteAssistInfo &info = winfos.front();
				unsigned saddr = (info.addr / DDR_DATAWIDTH) * DDR_DATAWIDTH;
				int start = info.addr - saddr;
				if (info.addr + info.len < saddr + DDR_DATAWIDTH){
					for (unsigned i = 0; i < info.len; i++)
						saved_buf[start + i] = info.data[i];
					buf_end = start + info.len;
					buf_start = start;
					buf_used = true;
					buf_addr = saddr;
					idle_count = 0;
					winfos.pop();
				}
				else{
					for (int i = 0; i < DDR_DATAWIDTH - start; i++)
						saved_buf[start + i] = info.data[i];
					unsigned mask = GetStrobe(start, DDR_DATAWIDTH);
					pddr->DelayWrite(saddr, mask, saved_buf);
					//buf_used = false;
					if (info.addr + info.len == saddr + DDR_DATAWIDTH){
						winfos.pop();
						//busy_state = false;
					}
					else{
						busy_state = true;
						next_fifo_addr = saddr + DDR_DATAWIDTH;
					}
				}
			}
		}
	}
	*/
unsigned long long CDDRWriteAssist::GetStrobe(unsigned start, unsigned end)
	{
		/*unsigned num = end - start;
		unsigned i;
		unsigned ret = 0;
		for (i = 0; i < num; i++)
			ret = (ret << 1) + 1;
		for (i = 0; i < start; i++)
			ret = (ret << 1);*/

		unsigned long long ret0, ret1;
		if (DDR_DATAWIDTH == 64){
			if (end == 64)
				ret1 = 0xffffffffffffffff;
			else
				ret1 = (1ull << end) - 1;
		}
		else/* if (DDR_DATAWIDTH == 32)*/
		{
			if (end == 32)
				ret1 = 0xffffffff;
			else
				ret1 = (1 << end) - 1;
		}
		ret0 = (1ull << start) - 1;

		//assert(ret == (ret0 ^ ret1));
		return ret0 ^ ret1;
	}
	void CDDRWriteAssist::DelayWrite(int adr, int len, unsigned char *data, bool save)
	{
		assert(winfos.size() < DDR_LANTENCY);
		winfo.addr = adr;
		winfo.len = len;
		assert(len <= BRAM_BUS_WIDTH *SZ_DTYPE);
		memcpy(winfo.data, data, len);
		info_valid = true;
		//winfos.push(info);
		if (save){
			save_write_enable = true;
			save_write_addr = adr;
			save_write_len = len;
			memcpy(save_write_data, data, len);
			//if (fp && debugLevel <= 1)
			//	fprintf(fp, "DDR save %d (%d)\n",  adr, len);
		}
	}
	
}
