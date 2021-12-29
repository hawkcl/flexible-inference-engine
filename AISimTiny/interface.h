#pragma once



#include <queue>
#include <map>
#include <vector>
#include <string>
#include "assert.h"
#include "sim.h"

namespace CloudDesign {
#define ROUNDROBIN	true
#ifdef yolo
#define DDR_BANDWIDTH		32
#else
#define DDR_BANDWIDTH		64
#endif
#define MAX_DATA_LOAD_SIZE (MAX_LOAD_WIDTH * sizeof(DTYPE))
	struct DDR_Load_Data{
		int id;
		unsigned addr;
		unsigned char data[DDR_DATAWIDTH];
		bool isLast;
	};
	struct DDR_Load_Info{
		int id;
		int addr;
		int len;
	};
	struct DDR_Write_Info{
		unsigned adr;
		unsigned long long strobe;
		unsigned char data[DDR_DATAWIDTH];
	};
	template <int DATAWIDTH>
	class CDDR :public CSimNode { // just use as a regular MEM, this class is just for debugging purpose
		unsigned char *buf;
		bool wrValid;
		int wrAddr;
		int wrLen;
		unsigned char wrtmp[INTERFACE_LEN];
		unsigned char loadtmp[INTERFACE_LEN];
		
		DDR_Load_Data delayData[DDR_LANTENCY];
		DDR_Load_Info linfo;
		std::queue<DDR_Load_Info> loadQueue;
		std::queue<DDR_Write_Info> writeQueue;
		int saveCount;
		int loadHolding;
		int writeHolding;
		bool nextWrite;
		bool frozeTick;
		unsigned next_load_addr;
		unsigned base_load_addr;
		int load_id;
		
		int size;
		
		FILE *fp;
		int debugLevel;
		unsigned char save_load_data[INTERFACE_LEN];
		bool		  save_load_enable;
		int			  save_load_addr;
		int			  save_load_len;

		unsigned char save_write_data[INTERFACE_LEN];
		bool		  save_write_enable;
		int			  save_write_addr;
		int			  save_write_len;

		FILE *fvi, *fvo1, *fvo2;
		bool read_pending1;
		int read_rid1;
		int read_addr1;
		int read_len1;
		//int read_freeze;

		bool write_pending1;
		int   write_addr1;
		unsigned write_strobe1;
		unsigned char  write_data1[INTERFACE_LEN];

		bool read_pending2;
		int read_rid2;
		int read_addr2;
		int read_len2;
		//int read_freeze;

		bool write_pending2;
		int   write_addr2;
		unsigned write_strobe2;
		unsigned char  write_data2[INTERFACE_LEN];

	public:
		CDDR() :size(0), wrValid(false), fp(NULL) {}
		~CDDR() { if (size) delete[]buf; }
		void Init(int s){
			Init();
			size = s;
			buf = new unsigned char[s];
			debugLevel = DEFAULT_DEBUG_LEVEL;
			ResetSaved();
		}
		unsigned char *GetAddress(int a) { return buf + a; }
		//void DumpState();
		//void DumpVerificationInput(int num);
		//void DumpVerificationOutput(int num);
		bool LoadOverFull() { return loadQueue.size() > DDR_LANTENCY; }
		bool readReady() { return loadQueue.size() < DDR_LANTENCY; }
		bool writeReady() { return writeQueue.size() < DDR_LANTENCY; }
		void SetDebugLevel(int l) { debugLevel = l; }
		//void Init();
		void progress(int num){};
		//void latch(int num);
		//void reset();
		//void Load(unsigned char *out, int addr, int len, bool save = DEFAULT_DDR_SAVE);
		//void DelayLoad(int id, int addr, int len, bool save = DEFAULT_DDR_SAVE);
		//bool DataValid(int id);
		int  GetDDRID(void) { return delayData[DDR_LANTENCY - 1].id; }
		//unsigned char *DelayData();
		//void Write(int adr, int len, unsigned char *data, bool save = DEFAULT_DDR_SAVE);
		//void DelayWrite(unsigned adr, unsigned strobe, unsigned char *data, bool save = DEFAULT_DDR_SAVE);
		void SetDebug(FILE *f) { fp = f; }
		//void decodeMask(unsigned strobe, unsigned &start, unsigned &len);
		bool IsSaveLoadEnable()		{ return save_load_enable; }
		int  GetSaveLoadLen()		{ return save_load_len; }
		int  GetSaveLoadAddr()		{ return save_load_addr; }
		unsigned char *GetSaveLoadData()	{ return save_load_data; }
		bool IsSaveWriteEnable()		{ return save_write_enable; }
		int  GetSaveWriteLen()		{ return save_write_len; }
		int  GetSaveWriteAddr()		{ return save_write_addr; }
		unsigned char *GetSaveWriteData()	{ return save_write_data; }
		void ResetSaved() { save_load_enable = save_write_enable = false; }
		void FrozeTick() { frozeTick = true; }
		bool IsLast() { return delayData[DDR_LANTENCY - 1].isLast; }
		unsigned GetReqAddr() { return delayData[DDR_LANTENCY - 1].addr; }

		void Init()
		{
			buf = 0;
			size = 0;
			write_pending1 = false;
			read_pending1 = false;
			write_pending2 = false;
			read_pending2 = false;
			if (DUMP_VERIFICATION_DDR){
				char filename[100];
				sprintf(filename, "%s/ddr1_%s_input.txt", OUTPUT_DIR, name.c_str());
				fvi = fopen(filename, "wt");
				assert(fvi);
				sprintf(filename, "%s/ddr1_%s_output1.txt", OUTPUT_DIR, name.c_str());
				fvo1 = fopen(filename, "wt");
				assert(fvo1);
				sprintf(filename, "%s/ddr1_%s_output2.txt", OUTPUT_DIR, name.c_str());
				fvo2 = fopen(filename, "wt");
				assert(fvo2);
			}
			else
				fvi = fvo1 = fvo2 = NULL;
		}


		void reset()
		{
			wrValid = false;
			size = 0;
			saveCount = 0;
			delete[]buf;
			loadHolding = 0;
			writeHolding = 0;
			linfo.id = 0;
			linfo.addr = 0;
			linfo.len = 0;
			nextWrite = false;
			for (int i = 0; i < DDR_LANTENCY; i++){
				delayData[i].id = 0;
				delayData[i].isLast = false;
			}
		}

		void DumpState()
		{
			if (!fp)
				return;
			//fprintf(fp, "Dump for %s\n", name.c_str());

		}
		void decodeMask(unsigned long long strobe, unsigned &start, unsigned &len)
		{
			start = 0;
			len = 0;
			assert(strobe != 0);
			while ((strobe & 1) == 0){
				strobe >>= 1;
				start++;
			}
			while (strobe != 0){
				assert((strobe & 1) == 1);
				strobe >>= 1;
				len++;
			}
		}

		void dump_axi(int i, FILE *fpr, FILE *fpw, FILE *fii, unsigned ia)
		{
			if (read_pending1){
				if (fii && (read_addr1 >= ia))
					fprintf(fii, "%d %d %d %d\n", i, read_rid1, read_addr1, read_len1);
				else
					fprintf(fpr, "%d %d %d %d\n", i, read_rid1, read_addr1, read_len1);
				read_pending1 = false;
			}
			if (write_pending1 && fpw){
				fprintf(fpw, "%d %d %u", i, write_addr1, write_strobe1);
				for (int i = 0; i < DATAWIDTH; i++)
					fprintf(fpw, " %d", write_data1[i]);
				write_pending1 = false;
				fprintf(fpw, "\n");
			}
		}

		void DumpVerificationInput(int num)
		{
			if (!fvi)
				return;
			fprintf(fvi, "%d %d %d %d %d %d", num, read_pending1, write_pending1, read_pending2, write_pending2, frozeTick);

			//if (read_pending1 && read_pending2)
			//	fprintf(fp, "%d two_reading\n", num);
			if (!read_pending1 && !write_pending1 && !read_pending2 && !write_pending2)
				fprintf(fvi, "\n");
			if (read_pending1){
				fprintf(fvi, " %d %d %d\n", read_rid1, read_addr1, read_len1);
				read_pending1 = false;
			}
			if (write_pending1){
				fprintf(fvi, " %d %u", write_addr1, write_strobe1);
				for (int i = 0; i < DATAWIDTH; i++)
					fprintf(fvi, " %d", write_data1[i]);
				write_pending1 = false;
				fprintf(fvi, "\n");
			}
			if (read_pending2){
				fprintf(fvi, " %d %d %d\n", read_rid2, read_addr2, read_len2);
				read_pending2 = false;
			}
			if (write_pending2){
				fprintf(fvi, " %d %u", write_addr2, write_strobe2);
				for (int i = 0; i < DATAWIDTH; i++)
					fprintf(fvi, " %d", write_data2[i]);
				write_pending2 = false;
				fprintf(fvi, "\n");
			}
		}

		void DumpVerificationOutput(int num)
		{
			if (!fvo1)
				return;

			if (delayData[DDR_LANTENCY - 1].id == 0)
				return;
			assert(delayData[DDR_LANTENCY - 1].id == 1);
			fprintf(fvo1, "%d %d %d", num, delayData[DDR_LANTENCY - 1].id, delayData[DDR_LANTENCY - 1].isLast);
			for (int i = 0; i < DATAWIDTH; i++)
				fprintf(fvo1, " %d", delayData[DDR_LANTENCY - 1].data[i]);
			fprintf(fvo1, "\n");
		}

		void latch(int num)
		{
			DumpVerificationInput(num);
			if (wrValid){
				wrValid = false;
				memcpy(buf + wrAddr, wrtmp, wrLen);
			}
			if (frozeTick){
				frozeTick = false;
				return;
			}
			frozeTick = false;
			ResetSaved();
			if (delayData[DDR_LANTENCY - 1].id != 0 && delayData[DDR_LANTENCY - 1].isLast)
				saveCount--;
			for (int i = DDR_LANTENCY - 1; i > 0; i--){
				delayData[i] = delayData[i - 1];
			}
			delayData[0].id = 0;
			delayData[0].isLast = false;
			if (!ROUNDROBIN)
				assert(saveCount >= 0);

			bool doWriting = false;
			if (ROUNDROBIN){
				if (nextWrite && loadHolding == 0 && !writeQueue.empty() || writeHolding > 0)
					doWriting = true;
				if (!nextWrite && loadHolding == 0 && loadQueue.empty() && saveCount == 0)
					doWriting = true;
			}
			else
				if (writeHolding > 0 || loadQueue.empty() && loadHolding == 0 && saveCount == 0)
					doWriting = true;

			if (doWriting){
				if (writeHolding > 0)
					writeHolding--;
				else if (!writeQueue.empty()){
					DDR_Write_Info &winfo = writeQueue.front();
					unsigned start, len;
					decodeMask(winfo.strobe, start, len);
					memcpy(buf + winfo.adr + start, winfo.data + start, len);
					/*if (winfo.len % DDR_BANDWIDTH == 0)
					writeHolding = winfo.len / DDR_BANDWIDTH - 1;
					else
					writeHolding = winfo.len / DDR_BANDWIDTH;*/
					writeQueue.pop();
				}
				if (ROUNDROBIN)
					nextWrite = false;
			}
			else{
				if (loadHolding > 0){
					if (loadHolding)
						loadHolding--;
					if (!loadHolding)
						delayData[0].isLast = true;
					delayData[0].id = load_id;
					delayData[0].addr = base_load_addr;
					for (int i = 0; i < DATAWIDTH; i++){
						delayData[0].data[i] = buf[next_load_addr + i];
					}
					next_load_addr += DATAWIDTH;
				}
				else if (!loadQueue.empty()){
					DDR_Load_Info info = loadQueue.front();
					loadQueue.pop();
					saveCount++;
					delayData[0].id = info.id;
					delayData[0].addr = info.addr;
					load_id = info.id;
					base_load_addr = info.addr;
					next_load_addr = info.addr + DATAWIDTH;
					loadHolding = info.len;
					if (loadHolding == 0)
						delayData[0].isLast = true;
					else
						delayData[0].isLast = false;
					for (int i = 0; i < DATAWIDTH; i++){
						delayData[0].data[i] = buf[info.addr + i];
					}
				}
				if (ROUNDROBIN)
					nextWrite = true;
			}
			DumpVerificationOutput(num);
		}

		void Write(int adr, int len, unsigned char *data, bool save = DEFAULT_DDR_SAVE)
		{
			if (len + adr > size){
				printf("len %d adr %d > size %d\n", len, adr, size);
				assert(false);
			}
			assert(!wrValid);
			wrValid = true;
			wrAddr = adr;
			wrLen = len;
			memcpy(wrtmp, data, len);
			if (save){
				save_write_enable = true;
				save_write_addr = adr;
				save_write_len = len;
				memcpy(save_write_data, data, len);
				//if (fp && debugLevel <= 1)
				//	fprintf(fp, "DDR save %d (%d)\n",  adr, len);
			}
			if (fvi){
				write_pending2 = true;
				write_addr2 = adr;
				if (len == 32)
					write_strobe2 = 0xffffffff;
				else
					write_strobe2 = ((1u << len) - 1u);
				memcpy(write_data2, data, len);
			}
		}

		void DelayWrite(unsigned adr, unsigned long long strobe, unsigned char *data, bool save = DEFAULT_DDR_SAVE)
		{
			assert(adr % DATAWIDTH == 0);
			DDR_Write_Info winfo;
			winfo.adr = adr;
			winfo.strobe = strobe;
			memcpy(winfo.data, data, DATAWIDTH);
			writeQueue.push(winfo);
			if (save){
				save_write_enable = true;
				unsigned start, len;
				decodeMask(winfo.strobe, start, len);
				//memcpy(buf + winfo.adr + start, winfo.data + start, len);

				save_write_addr = adr + start;
				save_write_len = len;
				memcpy(save_write_data, data + start, len);
				//if (fp && debugLevel <= 1)
				//	fprintf(fp, "DDR save %d (%d)\n",  adr, len);
			}
			if (fvi || DUMP_VERIFICATION_AXI){
				write_pending1 = true;
				write_addr1 = adr;
				write_strobe1 = strobe;
				memcpy(write_data1, data, DATAWIDTH);
			}
			/*if (fp){
				fprintf(fp, "#%s %9d %016x", name.c_str(), adr, strobe);
				unsigned start, len;
				decodeMask(winfo.strobe, start, len);
				//memcpy(buf + winfo.adr + start, winfo.data + start, len);
				for (int i = 0; i < len; i++)
					fprintf(fp, " %d", data[start+i]);
				fprintf(fp, "\n");
			}*/
		}

		void Load(unsigned char *out, int addr, int len, bool save = DEFAULT_DDR_SAVE){
			for (int i = 0; i < len; i++){
				out[i] = buf[addr + i];
			}

			if (save){
				save_load_enable = true;
				save_load_addr = addr;
				save_load_len = len;
				for (int i = 0; i < len; i++)
					save_load_data[i] = buf[addr + i];
				//memcpy(save_load_data, buf + addr, len);
			}
			if (fvi){
				assert(len <= 32);
				read_pending2 = true;
				read_rid2 = 2;
				read_addr2 = addr;
				read_len2 = 0;
			}
			if (!fvo2)
				return;
			assert(len <= DATAWIDTH);
			if ((addr & 0x1f) != 0){
				printf("addr violate %d\n", addr);
				assert(0);
			}
			fprintf(fvo2, "%d %d %d", 0, 2, 1);
			for (int i = 0; i < DATAWIDTH; i++)
				fprintf(fvo2, " %d", buf[addr + i]);
			fprintf(fvo2, "\n");
		}

		void DelayLoad(int id, int addr, int len, bool save = DEFAULT_DDR_SAVE)
		{
			assert(len <= MAX_DATA_LOAD_SIZE);
			assert(addr % DATAWIDTH == 0);
			linfo.id = id;
			linfo.addr = addr;
			linfo.len = len;
			loadQueue.push(linfo);
			assert(!LoadOverFull());
			if (save){
				save_load_enable = true;
				save_load_addr = addr;
				save_load_len = len;
				for (int i = 0; i < len; i++)
					save_load_data[i] = buf[addr + i];
				//memcpy(save_load_data, buf + addr, len);
			}
			if (fvi || DUMP_VERIFICATION_AXI){
				assert(id == 1);
				read_pending1 = true;
				read_rid1 = id;
				read_addr1 = addr;
				read_len1 = len;
			}
		}
		bool DataValid(int id)
		{
			return delayData[DDR_LANTENCY - 1].id == id;
		}
		unsigned char *DelayData()
		{
			return delayData[DDR_LANTENCY - 1].data;
			/*DDR_Load_Info tmp = delayData[DDR_LANTENCY - 1];
			for (int i = 0; i < tmp.len; i++){
			loadtmp[i] = buf[tmp.addr + i];
			}
			return loadtmp;*/
		}
	};

	enum INTERFACE_STATE { IF_IDLE, IF_LOAD_WEIGHT, IF_LOAD_FEATURE, IF_LOAD_INSTRUCTION, IF_OUTPUT};

	class CInterface : public CSimNode {
		CAddrBuffer *paddrBuf;
		CDDR<PS_DDR_DATAWIDTH> *pddrw;
		CDDR<DDR_DATAWIDTH> *pddrd;
		CDDRWriteAssist *pddrd_ass;
		CReadController *pread;
		int debugLevel;
		FILE *fp;
		std::queue<unsigned> out_addrs;
		std::queue<unsigned> out_sizes;
		unsigned char out_buf[INTERFACE_LEN];

		CFlop<unsigned, 0> out_len;
		CFlop<unsigned, 0> out_addr;
		CFlop<unsigned, 0> out_size;

		CFlop<INTERFACE_STATE, 0> state;
		CFlop<unsigned, 0> weight_len;
		CFlop<unsigned char *, 0> weight_addr;
		CFlop<unsigned, 0> weight_start;
		CFlop<unsigned, 0> weight_size;
		CFlop<unsigned, 0> feature_len;
		CFlop<unsigned char *, 0> feature_addr;
		CFlop<unsigned, 0> feature_start;
		CFlop<unsigned, 0> feature_size;
		CFlop<unsigned, 0> instruction_len;
		CFlop<unsigned char *, 0> instruction_addr;
		CFlop<unsigned, 0> instruction_start;
		CFlop<unsigned, 0> instruction_size;

		CFlop<unsigned, 0> instruction_start_addr;

		CFlop<bool, 0> new_weight;
		CFlop<bool, 0> new_instruction;
		CFlop<bool, 0> new_feature;
		CFlop<bool, 0> new_instruction_addr;
		
		std::vector<CSimNode *> storages;
		bool hasOutput;
		unsigned out_length;

		FILE *fvi, *fvo;
		FILE *fsvi, *fsvo, *fsvo2, *fsvo3;
		bool						buf_received;
		unsigned char				buffer[INTERFACE_LEN + 8];

		bool						add_output;
		unsigned					add_output_address;
		unsigned					add_output_size;

		bool                        addrbuf_enable;
		unsigned					inst_address;

	public:
		CInterface(){}
		~CInterface(){};
		
		void SendData(unsigned char *state_buf);
		void SetAddrBuf(CAddrBuffer *pab) { paddrBuf = pab; }
		void SetDDRs(CDDR<PS_DDR_DATAWIDTH> *w, CDDR<DDR_DATAWIDTH> *d, CDDRWriteAssist *pa)
		{ pddrw = w; pddrd = d; pddrd_ass = pa;}
		void SetCtrlRead(CReadController *p) { pread = p; }
		/*void SetWeights(unsigned char *addr, unsigned start, unsigned size);
		void SetFeatures(unsigned char *addr, unsigned start, unsigned size);
		void SetInstructions(unsigned char *addr, unsigned start, unsigned size);*/
		//void SetStartInstruction(unsigned addr);
		bool IsAddressEnable() { return addrbuf_enable; }
		unsigned GetInstAddress() { return inst_address; }
		void AddOutput(unsigned addr, unsigned sz);
		void Init();
		void progress(int num);
		void latch(int num);
		void reset();
		void DumpState();
		void SetDebug(FILE *f) { fp = f; };
		void SetDebugLevel(int l) { debugLevel = l; }
		void VerifyDump(int num);

		//void startInstruction();
		void nextState();
		//void loadWeights();
		//void loadFeatures();
		//void loadInstructions();
		void loadOutput();
		//bool IsIdle();

		// application has to check for HasOuput 
		// and takes out the buf before it is overwriten
		// we will send add,size first for HW implementation
		bool HasOutput() { return hasOutput; }
		unsigned GetOutputAddr() { return out_addr.GetValue(); }
		unsigned GetOutputSize() { return out_size.GetValue(); }
		unsigned char *GetOutBuf() { return out_buf; }
		unsigned GetOutLen() { return out_length; }
	};
};
