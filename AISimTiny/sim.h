#pragma once


#include <queue>
#include <map>
#include <vector>
#include <string>
#include <assert.h>
#include <math.h>
#include <stdio.h>
#include <string.h>
#include "defines.h"

#ifdef linux
#define ADDR_TYPE unsigned long
#else
#define ADDR_TYPE unsigned
#endif

namespace CloudDesign{
#ifdef USE_FLOAT_TYPE
#define EPSILON  1e-4
#define EPSILON2  1e-3
#define DTYPE	float
#define DTYPE2	float
#define DFMT	"%.2f"
#define IS_EQUAL(x, y) (fabs((x) - (y)) < EPSILON)
#define IS_EQUAL2(x, y) fabs(((x) - (y))/( x)) < EPSILON2
#endif

#define OUTPUT_DIR	"d:/aidata"
#if FEATURE_BIT_SIZE ==8 
#define FEATURE_TYPE	char
#else
#define FEATURE_TYPE short
#endif

#ifdef USE_INT_TYPE
#define DTYPE	int
#define DTYPE2	int
#define DFMT	"%d"
#define IS_EQUAL(x, y) ((x) == (y))
#define IS_EQUAL2(x, y) ((x) == (y))
#endif

#ifdef YOLO
#define SZ_DTYPE	1
#else
#define SZ_DTYPE	sizeof(DTYPE)
#endif
#define BM_NUM	3
#define BM_SIZE	(BM_NUM * SZ_DTYPE)
#define DEFAULT_DEBUG_LEVEL	3

#define WORDSIZE 4 //change to 2 or 1.5 depending
#define BANK_NUM	4
#define CG_NUM	12
#define COMPUTING_GROUP_SIZE	7
#define ADDRESS_FIFOSIZE 10
#define BANK_INSTRUCTION_FIFOSIZE 4
#define INPUT_FEATURE_SIZE 101200  // max 7 * 14 * 1024
//#define INPUT_FEATURE_SIZE 98000 // max 7 * 13 * 1024
#define BRAM_SIZE 8000000
#define BRAM_BUS_WIDTH	(BANK_NUM * COMPUTING_GROUP_SIZE)
#define S2_BUFFER_SIZE	16  //k+1 is enough, 16 for fpga
#define BM_READ_WIDTH	6
	//((CG_NUM /BM_SIZE)*2) // 2 * ng

#define WEIGHT_BUFFER_SIZE_MULT	1

#define INPUT_MEM_WIDTH	(COMPUTING_GROUP_SIZE+5)
#define INPUT_FIFO_SIZE	16 //10 enough, 16 for fpga limit
#define COMPUTING_UNIT_OUTPUT_SIZE	16
#define WEIGHT_SIZE	18624		//32K weight
#define HCB_WEIGHT_SIZE	2048
#define EXT_WEIGHT_SIZE	256
#define WEIGHT_DATA_WIDTH	8  //adjustable depend on memory bandwidth
#define WEIGHT_BUFFER_SIZE	(WEIGHT_BUFFER_SIZE_MULT * WEIGHT_DATA_WIDTH)
#define WEIGHT_READ_WIDTH	(WEIGHT_DATA_WIDTH * BANK_NUM)
#define BRAM_LOAD_SIZE	(WORDSIZE * BRAM_BUS_WIDTH + 8) //500B per cycle memory bandwidth
#define TMP_BUF_SIZE	50
#define MAX_LOAD_WIDTH	(COMPUTING_GROUP_SIZE* BANK_NUM+5)
#define MAX_CTRL_BUF_SIZE 16  // was 12
#define MAX_INPUT_BUF_SIZE 64

#define WRITE_FIFO_SIZE 20
#define MAX_K	7
#define MAX_SHIFT_SIZE 6 //Lpad + rpad
#define WEIGHT_BUS_SIZE 8 // >= maxK ast least
#define DEBUG_BANK_NAME	"bank0"
#define DEBUG_CG_NAME	"bank0_CG0"
#define DEBUG_CU_NAME	"bank0_CG0_CU0"
#define DUMP_VERIFICATION_SCG			false
#define DUMP_VERIFICATION_BM			false
#define DUMP_VERIFICATION_WEIGHT		false
#define DUMP_VERIFICATION_READEXTRA		false
#define DUMP_VERIFICATION_SHIFTINPUT	false
#define DUMP_VERIFICATION_READFEATURES	false
#define DUMP_VERIFICATION_ASSEMBLEINPUT	false
#define DUMP_VERIFICATION_BUILDINPUTFIFO		false
#define DUMP_VERIFICATION_SENDBKPINPUT	false
#define DUMP_VERIFICATION_INPUT			false
#define DUMP_VERIFICATION_STARTCONVOUT	false
#define DUMP_VERIFICATION_PROCESSCONVOUT		false
#define DUMP_VERIFICATION_HCBCTRL		false
#define DUMP_VERIFICATION_PROCESSINSTRUCTION	false
#define DUMP_VERIFICATION_HCB			false
#define DUMP_VERIFICATION_HCB_DETAIL	false
#define DUMP_VERIFICATION_CTRLWEIGHT	false
#define DUMP_VERIFICATION_DDRREADASST	false
#define DUMP_VERIFICATION_DDRWRITEASST	false
#define DUMP_VERIFICATION_CTRLREAD		false
#define DUMP_VERIFICATION_CTRLWRITE		false
#define DUMP_VERIFICATION_GIB			false
#define DUMP_VERIFICATION_INTERFACE		false
#define DUMP_VERIFICATION_CLOUD			false
#define DUMP_VERIFICATION_CLOUDSV		false
#define DUMP_VERIFICATION_DDR			false
#define DUMP_VERIFICATION_AXI			false
#define DUMP_VERIFICATION_CLOUDSVDebug		false   //for manual compare
#define DEFAULT_DDR_SAVE	(DUMP_VERIFICATION_CLOUDSV || DUMP_VERIFICATION_CLOUD || DUMP_VERIFICATION_INTERFACE)

	extern int max_add1;
	extern int max_add2;
enum SEND_STATE { SEND_WEIGHT, SEND_FEATURE, SEND_INSTRUCTION, SEND_ADDRESS, SEND_DONE };
#define INTERFACE_LEN  DDR_DATAWIDTH
#define ALIGN_LEN  (INTERFACE_LEN > 32 ? INTERFACE_LEN : 32)

extern FILE *fcvi, *fcvo;

class CSimNode{
protected:
	std::string name;
public:
	CSimNode(){}
	virtual ~CSimNode(){}
	virtual void Init() = 0;
	virtual void progress(int num) = 0;
	virtual void latch(int num) = 0;
	virtual void reset() = 0;
	virtual void DumpState(){};
	virtual void SetDebug(FILE *fp){};
	virtual void SetDebugLevel(int){};
	virtual void SetName(std::string s) { name = s; }
	std::string GetName() { return name; }
};

template <int N>
class CAllocAssist{
	struct SItem{
		SItem *next;
		char buf[N];
	};
	struct SBlock{
		SBlock *next;
		SItem item[1000];
	};
	SBlock *pbs;
	SItem *free;
public:
	CAllocAssist():free(NULL),pbs(NULL){}
	~CAllocAssist(){
		int i = 0;
		for (SBlock *tmp = pbs; tmp;tmp = pbs, i++){
			pbs = pbs->next;
			delete pbs;
		}
		//printf("alloced %d blocks\n", i);
	}
	char *Alloc(){
		if (!free){
			SBlock *pt = new SBlock;
			pt->next = pbs;
			pbs = pt;
			for (int i = 0; i < 1000; i++){
				pt->item[i].next = free;
				free = pt->item +i;
			}
		}
		SItem *tmp = free;
		free = free->next;
		return (tmp->buf);
	}
	void Free(char *loc){
		SItem*tmp = (SItem *)(loc - sizeof(SItem *));
		tmp->next = free;
		free = tmp;
	}
};

template <class T, unsigned N = 0> class CFlop : public CSimNode{
	T cur_val;
	T next_val;
	bool setted;
	bool skipCheck;
	FILE *fp;
	std::string par;
public:
	CFlop(){}
	void Init() {
		fp = NULL;
		skipCheck = false;
		setted = false;
		cur_val = next_val = T(0);
	}
	void SetSkipCheck() { skipCheck = true; }
	virtual void progress(int num){
		//cur_val = prev_val;
	}
	void latch(int num){
		setted = false;
		if (fp && cur_val != next_val)
			fprintf(fp, "%s changed from %d to %d\n", par.c_str(), cur_val, next_val);
		cur_val = next_val;
		if (N > 0)
			assert(((unsigned)next_val) < (((unsigned)1)<<N));
	}
	virtual void reset(){ Init(); }
	T GetValue() { return cur_val; }
	T GetNextValue() { return next_val; }
	void CheckSetted(T v){ 
		if (N > 0)
			assert(((unsigned)v) < (((unsigned)1) << N));
		if (skipCheck) return; 
		if (setted){
			printf("var@%p %d -> %d\n", this, next_val, v); //TODO : comment this
			assert(false);
		}
		setted = true; 
	}
	bool IsSetted() { return setted; }
	void SetValue(T v) { CheckSetted(v);  next_val = v; }
	void SetDebug(FILE *f, std::string &pn) { fp = f; par = pn; }
	void operator=(T val) { CheckSetted(val); next_val = val; }
	bool operator==(T val) { return cur_val == val; }
	void operator++(int) { CheckSetted(cur_val + 1); next_val = cur_val + 1; } // return CFlop &
	void operator--(int) { CheckSetted(0); next_val = cur_val - 1; } // return CFlop &
	void operator+=(T val) { CheckSetted(cur_val + val); next_val = cur_val + val; } // return CFlop &
	void operator-=(T val) { CheckSetted(0); next_val = cur_val - val; } // return CFlop &
	// operator overloading for CFlop is confusing since the effect happens next clock
	// for example a++; b += a, in which the amount added to b is actually old a
	// one reason for not overloading too many.
};

template <class T> class CFlopLarge : public CSimNode{
	T cur_val;
	T next_val;
	FILE *fp;
	std::string par;
public:
	CFlopLarge(){}
	void Init() {
		fp = NULL;
		//cur_val = next_val = T(0);
	}
	virtual void progress(int num){
		//cur_val = prev_val;
	}
	void latch(int num){
		//if (fp && cur_val != next_val)
		//	fprintf(fp, "%s changed from %d to %d\n", cur_val, next_val);
		cur_val = next_val;
	}
	virtual void reset(){ }//cur_val = next_val = (T)0;}
	T& GetValue() { return cur_val; }
	T& GetNextValue() { return next_val; }
	void SetValue(T v) { next_val = v; }
	void SetDebug(FILE *f, std::string &pn) { fp = f; par = pn; }
	void operator=(T val) { next_val = val; }
	bool operator==(T val) { return cur_val == val; }
	void operator++(int) { next_val = cur_val + 1; } // return CFlop &
	void operator--(int) { next_val = cur_val - 1; } // return CFlop &
	void operator+=(T val) { next_val = cur_val + val; } // return CFlop &
	void operator-=(T val) { next_val = cur_val - val; } // return CFlop &
	// operator overloading for CFlop is confusing since the effect happens next clock
	// for example a++; b += a, in which the amount added to b is actually old a
	// one reason for not overloading too many.
};

template <class T, int Size, int BufSize> class CMem : public CSimNode{
	T *mem;
	T *buf;
	int addr;
	int len;
	bool isValid;
public:
	CMem(){}
	~CMem(){
		delete[]mem;
		delete[]buf;
	}
	void Init(){
		mem = new T[Size];
		buf = new T[BufSize];
		isValid = false;
	}
	virtual void progress(int num){
		//cur_val = prev_val;
	}
	void latch(int num){
		if (isValid){
			isValid = false;
			memcpy(mem + addr, buf, sizeof(T) * len);
		}
	}
	virtual void reset(){ isValid = false; }
	T GetValue(int a) { assert(a < Size); return mem[a]; }
	T* GetMem(void) { return mem; }
	void GetValue(T* out, int a, int l) {
		assert(a + l <= Size);
		memcpy(out, mem + a, l * sizeof(T));
	}
	void SetValue(T in, int a) {
		assert(a < Size);
		assert(!isValid);
		isValid = true;
		buf[0] = in;
		len = 1;
		addr = a;
	}
	void SetValue(T* in, int a, int l) { 
		assert(a + l <= Size);
		assert(l <= BufSize);
		isValid = true;
		memcpy(buf, in, sizeof(T)*l);
		len = l;
		addr = a;
	}
	int GetSize() { return Size; }
	int GetBufSize() { return BufSize; }
};

template <class T, int Size> class CFiFo : public CSimNode{
	std::queue<T> fifo;
	T value;
	bool isValid;
	unsigned last_size; // we do not want to pop and push at the same cycle when fifo is full
public:
	CFiFo(){}
	~CFiFo(){}
	void Init(){
		isValid = false;
		last_size = 0;
	}
	virtual void progress(int num){
		//cur_val = prev_val;
	}
	void latch(int num){
		if (isValid){
			isValid = false;
			fifo.push(value);
		}
		last_size = fifo.size();
	}
	virtual void reset(){ 
		isValid = false; 
		while (fifo.size() > 0)
			fifo.pop();
		last_size = 0;
	}
	T Pop() {
		T v = fifo.front();
		fifo.pop();
		return v;
	}
	T front() {
		T v = fifo.front();
		return v;
	}
	bool Push(T in) {
		if (fifo.size() >= Size){
			assert(false);
			return false;
		}
		if (isValid == true)
			fifo.push(value);// push multi value per cycle
		value = in;
		isValid = true;
		return true;
	}
	bool IsEmpty() { return last_size == 0; }
	bool IsFull() { return last_size >= Size; }
	bool IsFull(int sz) { 
		return last_size + sz >= Size;
	}
	unsigned size() { return fifo.size() + (isValid?1:0); }
};

template <int DATAWIDTH> class CDDR;

struct CReadAssistInfo{
	unsigned	saved_len : ddr_width_t;
	unsigned	saved_addr : ddr_width_t;
	bool		saved_only;
	unsigned	first_addr : ddr_width1_t;
	unsigned	last_len : ddr_width1_t;
	DDR_ID		id;
	unsigned	asked_addr; //debug only
};

/*
	CDDRReadAssist helps to make unaligned memory access into aligned access
	, and break large data read into multiple memory access, and also can help 
	with small read. It output AXI like signals.
*/
template <int DATAWIDTH>
class CDDRReadAssist :public CSimNode {
	FILE *fp;
	int debugLevel;
	int cid;
	CDDR<DATAWIDTH> *pddr;
	DDR_ID vid;
	std::queue<CReadAssistInfo> infos;
	CFlop<unsigned char, 0> saved_buf[DATAWIDTH];
	CFlop<unsigned, mem_addr_t> next_addr;
	CFlop<unsigned, 0> buf_addr; //next addr for data

	unsigned char data[MAX_LOAD_WIDTH * SZ_DTYPE];
	std::vector<CSimNode *> storages;

	FILE *fvi;
	FILE *fvo;
	bool start_dump;
	int  out_len;
	bool req_valid;
	bool read_request;
	bool read_freeze;
public:
	CDDRReadAssist() :fp(NULL), cid(0) {}
	~CDDRReadAssist() {  }
	//void DumpState();
	//void DumpVerificationStart(int);
	//void DumpVerificationFinish(int);
	void SetDDR(CDDR<DATAWIDTH> *p) { pddr = p; }
	bool readReady() { return infos.size() < DDR_LANTENCY; }
	void SetDebugLevel(int l) { debugLevel = l; }
	//void Init();
	void SetCid(int i) { cid = i; }
	//void progress(int num);
	//void latch(int num);
	//void reset();
	//void DelayLoad(DDR_ID id, int addr, int len);
	bool DataValid(DDR_ID id) { return vid == id; }
	int  GetDDRID(void) { return vid; }
	unsigned char *DelayData() { return data; }
	void SetDebug(FILE *f) { fp = f; }

	void Init()
	{
		debugLevel = DEFAULT_DEBUG_LEVEL;
		storages.push_back(&next_addr);
		storages.push_back(&buf_addr);
		for (int i = 0; i < DATAWIDTH; i++){
			storages.push_back(saved_buf + i);
		}
		reset();

		if (DUMP_VERIFICATION_DDRREADASST){
			char filename[100];
			sprintf(filename, "%s/ddrread_%s_input.txt", OUTPUT_DIR, name.c_str());
			fvi = fopen(filename, "wt");
			assert(fvi);
			sprintf(filename, "%s/ddrread_%s_output.txt", OUTPUT_DIR, name.c_str());
			fvo = fopen(filename, "wt");
			assert(fvo);
		}
		else
			fvi = fvo = NULL;
		req_valid = false;
		read_request = false;
		read_freeze = false;
		start_dump = false;
		out_len = 0;
	}
	void reset()
	{
		std::vector<CSimNode *>::const_iterator p = storages.begin();
		for (int i = 0; p != storages.end(); p++, i++)
			(*p)->reset();
	}

	void DumpState()
	{
		if (!fp)
			return;
		//fprintf(fp, "Dump for %s\n", name.c_str());

	}

	void latch(int num)
	{
		DumpVerificationFinish(num);
		std::vector<CSimNode *>::const_iterator p = storages.begin();
		for (int i = 0; p != storages.end(); p++, i++)
			(*p)->latch(num);
		vid = DDR_NOID;
	}

	void DumpVerificationFinish(int)
	{
		if (!fvi || !fvo)
			return;
		if (!start_dump)
			return;

		if (!req_valid)
			fprintf(fvi, " 0\n");
		req_valid = false;

		if (!read_request)
			fprintf(fvo, " 0");
		fprintf(fvo, " %d", read_freeze);
		read_freeze = false;
		read_request = false;

		fprintf(fvo, " %d", vid);
		if (vid != DDR_NOID){
			fprintf(fvo, " %d", out_len);
			for (int i = 0; i < out_len; i++)
				fprintf(fvo, " %d", data[i]);
		}
		fprintf(fvo, "\n");
		fprintf(fvo, " %d %d %d", next_addr.GetValue(), buf_addr.GetValue(), buf_addr.GetNextValue());
		for (int i = 0; i < DATAWIDTH; i++)
			fprintf(fvo, " %d", saved_buf[i].GetValue());
		fprintf(fvo, "\n");
		if (buf_addr.GetNextValue() > 0)
			for (unsigned i = 0; i < buf_addr.GetNextValue(); i++)
				fprintf(fvo, " %d", data[i]);
		fprintf(fvo, "\n");
	}

	void DumpVerificationStart(int num)
	{
		if (!fvi || !fvo)
			return;
		if (num > 72600)
			start_dump = true;
		if (!start_dump)
			return;
		fprintf(fvi, "%d %d", num, pddr->GetDDRID());
		if (pddr->GetDDRID() != 0){
			fprintf(fvi, " %d", pddr->IsLast());
			unsigned char *pbuf = pddr->DelayData();
			for (int i = 0; i < DATAWIDTH; i++)
				fprintf(fvi, " %d", pbuf[i]);
		}
		fprintf(fvi, "\n");

		fprintf(fvo, "%d %d", num, this->readReady());
	}

	void progress(int num)
	{
		DumpVerificationStart(num);
		if (infos.size() == 0)
			return;
		CReadAssistInfo info = infos.front();
		if (info.saved_len > 0 && info.saved_only){
			infos.pop();
			vid = info.id;
			for (unsigned i = 0; i < info.saved_len; i++)
				data[i] = saved_buf[info.saved_addr + i].GetValue();
			pddr->FrozeTick();
			read_freeze = true;
			out_len = info.saved_len;
		}
		else if (pddr->DataValid(cid)){
			unsigned char *pbuf = pddr->DelayData();
			/*if (fp){
				fprintf(fp, "%s ddr return ", name.c_str());
				for (int i = 0; i < 32; i++)
					fprintf(fp, " (%d)", (char)pbuf[i]);
				fprintf(fp, "\n");
			}*/
			int adr;
			int read_len = DATAWIDTH;
			if (buf_addr.GetValue() == 0 && !pddr->IsLast())
				read_len = DATAWIDTH - info.first_addr;
			//islast not relevent for read_len, only for verification
			if (buf_addr.GetValue() == 0 && pddr->IsLast())
				read_len = info.last_len - info.first_addr;
			else if (pddr->IsLast())
				read_len = info.last_len;


			if (buf_addr.GetValue() == 0 && info.saved_len > 0)
				adr = info.saved_len;
			else
				adr = buf_addr.GetValue();

			int faddr = 0;
			if (buf_addr.GetValue() == 0)
				faddr = info.first_addr;
			for (unsigned i = 0; i < MAX_LOAD_WIDTH * SZ_DTYPE; i++){
				if (/*pddr->IsLast() && */i < info.saved_len)
					data[i] = saved_buf[i + info.saved_addr].GetValue();
				else if (i >= adr)
					data[i] = pbuf[(faddr + i - adr) % DATAWIDTH];
				/*else if (pddr->IsLast() && buf_addr.GetValue() == 0){
				if (i >= adr && i < adr + info.last_len - info.first_addr)
				data[i] = pbuf[info.first_addr + i - adr];
				}
				else if (pddr->IsLast()){
				if (i >= adr && i < adr + info.last_len) // only need i >= adr
				data[i] = pbuf[i - adr];
				}
				else if (adr == 0){ // first receive no saved
				read_len = DDR_DATAWIDTH - info.first_addr;
				if (i < DDR_DATAWIDTH - info.first_addr) // no need
				data[i] = pbuf[i + info.first_addr];
				}
				else{
				if (i >= adr && i < adr + DDR_DATAWIDTH) // only need i >= adr
				data[i] = pbuf[i - adr];
				}*/

			}
			if (0 && fp){
				fprintf(fp, "rass %d (ask %d), slen %d, saddr %d, sonly?(%s), faddr %d, llen %d\n", num, info.asked_addr, info.saved_len
					, info.saved_addr, info.saved_only ? "Y" : "N", info.first_addr, info.last_len);
				for (unsigned i = 0; i < MAX_LOAD_WIDTH * SZ_DTYPE; i++)
					fprintf(fp, " %d", data[i]);
				fprintf(fp, "\n");
			}
			if (pddr->IsLast()){
				infos.pop();
				vid = info.id;
				buf_addr = 0;
				out_len = adr + read_len;
				for (int i = 0; i < DATAWIDTH; i++)
					saved_buf[i] = pbuf[i];
			}
			else
				buf_addr = adr + read_len;
		}
	}
	void DelayLoad(DDR_ID id, int addr, int len)
	{
		if (fvi && start_dump)
			fprintf(fvi, " 1 %d %d %d\n", id, addr, len);
		req_valid = true;
		CReadAssistInfo info;
		info.id = id;
		int axi_len;
		int saddr = (addr / DATAWIDTH) * DATAWIDTH;
		int eaddr = addr + len;
		if (eaddr % DATAWIDTH != 0){
			int eaddr0 = (eaddr / DATAWIDTH) * DATAWIDTH;
			info.last_len = eaddr - eaddr0;
			eaddr = eaddr0 + DATAWIDTH;
		}
		else
			info.last_len = DATAWIDTH;
		if (saddr + DATAWIDTH == next_addr.GetValue()){
			info.saved_addr = addr - saddr;
			if ((next_addr.GetValue() - addr) >= len){
				info.saved_len = len;
				info.saved_only = true;
				//axi_len = 0;
			}
			else{
				info.saved_len = (next_addr.GetValue() - addr);
				info.saved_only = false;
			}
			saddr = next_addr.GetValue();
			info.first_addr = 0;
		}
		else{
			info.saved_addr = 0;
			info.saved_len = 0;
			info.saved_only = false;
			info.first_addr = addr - saddr;
		}
		axi_len = (eaddr - saddr) / DATAWIDTH;
		info.asked_addr = addr;
		infos.push(info);
		
		if (fp && debugLevel <= 1){
			fprintf(fp, "dass(%d) ask %d %d, saddr %d, llen %d axilen %d\n", DATAWIDTH, addr, len, info.saved_addr, info.last_len, axi_len);
		}
		if (axi_len > 0){
			pddr->DelayLoad(cid, saddr, axi_len - 1);
			next_addr = eaddr;
			read_request = true;
			if (fvo && start_dump)
				fprintf(fvo, " 1 %d %d %d", cid, saddr, axi_len - 1);
		}

	}

};

struct CWriteAssistInfo{
	unsigned	addr : mem_addr_t;
#ifdef YOLO
	unsigned	len : ctrl_width_t;
#else
	unsigned	len : ctrl_width_t * 2;
#endif
	unsigned char	data[BRAM_BUS_WIDTH *SZ_DTYPE];
};

class CDDRWriteAssist :public CSimNode {
	FILE *fp;
	int debugLevel;
	int cid;
	CDDR<DDR_DATAWIDTH> *pddr;
	CWriteAssistInfo winfo;
	bool info_valid;
	CFlop<unsigned, mem_addr_t> buf_addr;
	CFlop<unsigned, ddr_width_t> buf_start;
	CFlop<unsigned, ddr_width1_t> buf_end; // 1 after last ocupied pos
	CFlop<unsigned, 3> idle_count;
	CFlop<unsigned, mem_addr_t> next_fifo_addr;
	CFlop<bool, 0> busy_state;
	CFlop<bool, 0> buf_used;
	unsigned char saved_buf[DDR_DATAWIDTH];
	std::queue<CWriteAssistInfo> winfos;
	std::vector<CSimNode *> storages;

	unsigned char save_write_data[BRAM_BUS_WIDTH *SZ_DTYPE];
	bool		  save_write_enable;
	int			  save_write_addr;
	int			  save_write_len;

	FILE *fvi;
	FILE *fvo;
	bool start_dump;
	bool write_request;
	bool flash_saved;
	bool do_process;
	unsigned saved_pos;
	unsigned saved_start;
	unsigned data_pos;
	unsigned saddr;
public:
	CDDRWriteAssist() :fp(NULL), cid(0) {}
	~CDDRWriteAssist() {  }
	void DumpState();
	void DumpVerificationStart(int);
	void DumpVerificationFinish(int);
	void DumpDDRWrite(unsigned adr, unsigned long long strobe, unsigned char *data);
	void SetDDR(CDDR<DDR_DATAWIDTH> *p) { pddr = p; }
	bool writeReady() { return winfos.size() < DDR_LANTENCY; }
	void SetDebugLevel(int l) { debugLevel = l; }
	void Init();
	void SetCid(int i) { cid = i; }
	void progress(int num);
	void latch(int num);
	void reset();
	void DelayWrite(int adr, int len, unsigned char *data, bool save = DEFAULT_DDR_SAVE);
	void SetDebug(FILE *f) { fp = f; }
	unsigned long long GetStrobe(unsigned start, unsigned end);
	bool IsSaveWriteEnable()		{ return save_write_enable; }
	int  GetSaveWriteLen()		{ return save_write_len; }
	int  GetSaveWriteAddr()		{ return save_write_addr; }
	unsigned char *GetSaveWriteData()	{ return save_write_data; }
};

//program addresses
class CAddrBuffer :public CSimNode {
	ADDR_TYPE s;
	bool valid;
	std::queue<ADDR_TYPE> fifo;
	FILE *fp;
public:
	CAddrBuffer() :valid(false), fp(NULL) {}
	void Init(){
		valid = false;
	}
	void progress(int num){};
	void latch(int num);
	void DumpState();
	void reset() { while (!fifo.empty()) fifo.pop(); valid = false; }
	void Push(ADDR_TYPE ad){
		if (fifo.size() == ADDRESS_FIFOSIZE)
			return;
		assert(!valid);
		s = ad;
		valid = true;
	}
	bool Pop(ADDR_TYPE &ad);
	size_t Size() { return fifo.size(); }
	ADDR_TYPE Top() { return fifo.front(); }
	void SetDebug(FILE *f) { fp = f; }
};


enum InstructionType { CONV, OPTIONS, POOL, END, MEM, LOADWEIGHT, HCB, CREAD, CWRITE};
enum DATA_MODE { MODE_ONE, MODE_TWO, MODE_FOUR };
enum DATA_TYPE { TYPE_BM, TYPE_RES, TYPE_GIB };
struct InstructionHCBWt{
	unsigned type;
	ADDR_TYPE Waddr, WEnd;
	unsigned weightPos;
	unsigned seqNum;
};

//To use this, we need to seperate assignment parameters from both type of instructions
//struct InstructionHCBNF {
//	unsigned type;
//	unsigned seqNum;
//	unsigned W, H, C;
//	unsigned ReadPos;
//	unsigned W1, H1, X, Y; //maxval for read, write, weight, ext token gen
//	unsigned lPad, rPad;
//};

struct InstructionHCB {
	unsigned Id : bank_num_t;  //2
	unsigned type : 4;
	unsigned reqSeqNum : seq_t; //11
	unsigned reqProgress : seq_t;
	unsigned reqSeqNumW : seq_t;
	unsigned reqProgressW : seq_t;
	unsigned seqNum : seq_t;
	unsigned W : out_width_t; //9
	unsigned H : out_width_t;
	unsigned C : layer_addr_t; //11
	unsigned Waddr : mem_addr_t;
	unsigned WEnd : mem_addr_t;
	unsigned weightPos : mem_bus_addr_t; //5
	unsigned ReadPos : mem_bus_addr_t;
	unsigned ResPos : mem_bus_addr_t;
	unsigned W1 : width_t; //4
	unsigned H1 : width_t;
	unsigned X : out_width_t;
	unsigned Y : out_width_t; //maxval for read, write, weight, ext token gen
	unsigned S : pad_t; //2
	unsigned lPad : pad_t;
	unsigned rPad : pad_t;
	unsigned K : k_t; //3
	unsigned M : layer_addr_t; // filter size, filter layers
	unsigned Kh : layer_addr_t;
	unsigned Ks : layer_addr_t;
	unsigned Kt : layer_addr_t; // start, stride, and tail(inclusive)
	unsigned Res_addr : mem_addr_t;
	unsigned wScale : scale_t; //4
	unsigned fScale : scale_t;
	//unsigned BM_addr : mem_addr_t;
	unsigned    wLRelu : FEATURE_BIT_SIZE;  //12?
	unsigned weightToken : token_t;  //2
	
	unsigned maxpool_size : pad_t;
	unsigned maxpool_stride : pad_t;
	DATA_MODE mode; //2
	unsigned isResMaster : 1;
	//unsigned isWeightMaster : 1;
	unsigned isProgressMaster : 1;
	unsigned isRaddr_a : 1; //for Res
	
	unsigned doRes : 1;
	unsigned doRelu : 1;
	unsigned doLRelu : 1;
	unsigned doBM : 1;
	unsigned doUpSample : 1;
	unsigned newWriteInst : 1;
	unsigned outbufsize : loc_frame_t; //8
	unsigned ofsize : frame_t; //18
	unsigned outyx : frame_t;
	unsigned outputAddrGap : output_gap_t; //24
	unsigned outkh : mem_addr_t;
	unsigned ng : cg_addr_t; //4
	unsigned gu : cg_addr_t;
	unsigned resSize : res_size_t;  //16
	unsigned resSizeLast : res_size_t;
	unsigned resLen : res_len_t; //5
	unsigned resLenLast : res_len_t;
	unsigned pfs : loc_frame_t;
	unsigned volumeSize : input_addr_t;  //17
	unsigned kCurLast : layer_addr_t;
	unsigned wtotal_n : cg_addr_t;
	unsigned wtotalLast : cg_addr_t;
	unsigned wlenk_regular : weight_bus_size_t;  //4
	unsigned wlenk_nLast : weight_bus_size_t;
	unsigned wlenk_nLast2 : weight_bus_size_t;	
	//unsigned totalBM : bm_size_t;
	unsigned totalRes : res_size_t;

#ifdef BATCH1_OPTIMIZE
	unsigned Kbh : layer_addr_t;
	unsigned Kbe : layer_addr_t;// start end for batched K1
	unsigned doBatch3 : 1;
	unsigned resSizeBatch : res_size_t;
	unsigned resLenBatch : res_len_t;
	unsigned ug_batch : cg_addr_t;
	unsigned ug_batchLast : cg_addr_t;
	unsigned wlenk_bLast : weight_bus_size_t;
	unsigned wlenk_bLast2 : weight_bus_size_t;
	unsigned batch_1group : 1;
	unsigned kbe_1 : layer_addr_t;
	unsigned outkhb;// : mem_addr_t;
	unsigned readRowCount3 : width_t;
	unsigned lastRowLen3 : width_t;
	unsigned batchSize : batch_t;
#endif
};
extern unsigned InstructionHCBLength;
extern unsigned char* DoPackInstructionHCB(InstructionHCB *pi);
extern void UnPackInstructionHCB(unsigned char *buf, InstructionHCB *pi);

struct Instruction {
	
	unsigned reqSeqNum;
	unsigned reqProgress;
	unsigned reqSeqNumW;
	unsigned reqProgressW;
	unsigned seqNum;
	unsigned fScale;
	unsigned wScale;
	unsigned W, H, C;
	unsigned W1, H1, W2;
	
	ADDR_TYPE Maddr, Waddr, Oaddr;
	unsigned WSize;
	int WEnd[BANK_NUM];
	unsigned S, lPad, rPad;
	unsigned K, M; // filter size, filter layers
	unsigned Kh[BANK_NUM], Ks[BANK_NUM], Kt[BANK_NUM]; // start, stride, and tail(inclusive)

#ifdef BATCH1_OPTIMIZE
	unsigned Kbh[BANK_NUM], Kbe[BANK_NUM];//start end of the batch for k1
	unsigned batch15, batch12, batch0;
	unsigned doBatch3 : 1;
#endif

	unsigned Res_addr;
	//ADDR_TYPE BM_addr;
	DTYPE    wLRelu;
	unsigned maxpool_size : pad_t;
	unsigned maxpool_stride : pad_t;
	DATA_MODE mode;
	int progressMaster; // last bank
	unsigned wDropSize : 2;
	
	unsigned isUseWRam : 1;
	unsigned isMaddr_a : 1;
	unsigned isMaddr_b : 1;
	unsigned isOaddr_a : 1;
	unsigned isOaddr_b : 1;
	unsigned isRaddr_a : 1; //for Res
	unsigned doRes : 1;
	unsigned doRelu : 1;
	unsigned doLRelu : 1;
	unsigned doBM : 1;
	unsigned doUpSample : 1;
	unsigned isConv : 1;
//	Instruction(int i){}
//	Instruction(){}
};
class CHomoGeneousComputingBank;

struct InstructionMem{
	bool isRamA;
	bool isRead;
	bool isFast; // for res simulation
	unsigned len;
	unsigned Maddr;
	ADDR_TYPE Oaddr;
	unsigned reqSeqNum;
	unsigned seqNum;
	unsigned segments[BANK_NUM + 1];
};

class CBRAM :public CSimNode { // just use as a regular MEM, this class is just for debugging purpose
	DTYPE *buf;
	DTYPE tmp[TMP_BUF_SIZE];
	DTYPE wrtmp[TMP_BUF_SIZE];
	bool wrValid;
	int wrAddr;
	int wrLen;

	int size;
	//int busWidth;
	int dataLen;
	unsigned finishSeq;
	unsigned workingSeq;
	InstructionMem inst;
	int ioLen;
	int segPos[BANK_NUM];
	bool ioDone[BANK_NUM];
	int progressNum;
	int idx;
	int idxSize;

	bool valid;
	bool ioValid;
	bool isReading;
	bool isWriting;
	bool isDebug;
	InstructionMem ioInst;
	std::queue<InstructionMem> fifo;
	std::vector<CHomoGeneousComputingBank*> cbInsts;
	FILE *fp;
	int debugLevel;

public:
	CBRAM() :size(0), dataLen(0), finishSeq(0), workingSeq(0), wrValid(false), valid(false), ioValid(false), fp(NULL) {}
	~CBRAM() { if (size) delete[]buf; }
	void Init(int s, int bw){
		size = s;
		//busWidth = bw;
		buf = new DTYPE[s];
		valid = 0;
		ioValid = 0;
		isReading = false;
		isWriting = false;
		progressNum = 0;
		debugLevel = DEFAULT_DEBUG_LEVEL;
		//printf("%s Buf address %p\n", name.c_str(), buf);
	}
	void DumpState();
	void SetDebugLevel(int l) { debugLevel = l; }
	void Init() { buf = 0; size = 0; }
	void progress(int num){};
	void latch(int num);
	void reset();
	void PushInst(InstructionMem &i) { inst = i; valid = true; }
	void Prepare(int addr, int len){
		assert(dataLen + len <= TMP_BUF_SIZE);
		for (int i = 0; i < len; i++){
			tmp[dataLen++] = buf[addr + i];
		}
	}
	void Load(DTYPE *out, int addr, int len){
		for (int i = 0; i < len; i++){
			out[i] = buf[addr + i];
		}
		// memcpy(out, buf + addr, len * sizeof(DTYPE));
	}
	DTYPE *GetAddress(int a) { return buf + a; }
	void Write(int adr, int len, DTYPE *data, bool rightnow = false);
	int DataLen() { return dataLen; }
	DTYPE GetData(int i) { return tmp[i]; }
	unsigned GetFinishedSeq() { return finishSeq; }
	unsigned GetWorkingSeq() { return workingSeq; }
	unsigned GetWorkingProgress() { return progressNum; }
	void AddCBIB(CHomoGeneousComputingBank* pib) { cbInsts.push_back(pib); }
	void SetDebug(FILE *f) { fp = f; }
	bool IsReadingFeatures();
};

class CGlobalInstructionBuffer;
struct InstructionWeight{
	bool isReadRam;
	bool isWriteRam;
	DATA_MODE mode; // for res simulation
	unsigned dropSize : 2;
	//unsigned readWidth;
	//unsigned dataWidth;
	unsigned seqNum : seq_t;
	unsigned Oaddr : mem_addr_t;
	unsigned size : mem_addr_t;
};
extern unsigned InstructionWeightLength;
extern unsigned char* DoPackInstructionWeight(InstructionWeight *pi);
extern void UnPackInstructionWeight(unsigned char *buf, InstructionWeight *pi);

class CWeightController :public CSimNode {
	std::queue<InstructionWeight> fifo;
	std::vector<CHomoGeneousComputingBank*> cbInsts;
	FILE *fp;
	int debugLevel;
	CFlop<bool, 0> isReadRam;
	CFlop<bool, 0> isWriteRam;
	CFlop<bool, 0> hasMoreData;
	CFlop<bool, 0> readMoreData;
	CBRAM *ramw;
	CDDRReadAssist<PS_DDR_DATAWIDTH> *pddr;
	CFlop<DATA_MODE, 0> mode;
	CFlop<unsigned, mem_addr_t> Oaddr;
	CFlop<unsigned, seq_t> seqNum;
	CFlop<unsigned, 2> dropSize;
	//CFlop<int> readWidth;
	unsigned dataWidth : ctrl_width_t;
	CFlop<unsigned, mem_addr_t> nextReadAddr;
	CFlop<unsigned, mem_addr_t> nextReceiveAddr;
	//CFlop<int, 0> nextWriteAddr;
	CFlop<unsigned, mem_addr_t> lastAddr;
	CFlop<unsigned, data_fifo_t> liveCount;
	InstructionWeight inst;
	bool valid;
	bool data_fifo_full;
	
	std::queue<DTYPE *> data;
	std::queue<DTYPE *> inputs_data;
	bool weight_ram_request;
	CFlop<bool, 0> weight_ram_valid;
	int ram_addr;
	int ram_len;
	DTYPE *saveData;
	int dataIdx;
	DTYPE *dataBus;
	bool busValid;
	
	CAllocAssist<MAX_LOAD_WIDTH * sizeof(DTYPE)> *palloc;
	std::vector<CSimNode *> storages;

	bool start_dump;
	bool cwinst_enable;
	bool weight_ram_enable;
	bool saved_enable;
	bool read_mem;
	bool data_fifo_ren; // busValid
	bool data_fifo_wen;
	bool weight_mem_ren;
	bool weight_mem_wen;
	//std::queue<int> dly_num_v;
	//std::queue<DTYPE *> dly_data_v;
	FILE *fvi, *fvo;

	int totalAdd, totalDec;

public:
	CWeightController() :fp(NULL),dataIdx(0) {}
	~CWeightController() {}

	void Init();
	void DumpState();
	void convertYoloWeights(DTYPE *buf, char *bufs, int len);
	void SetAlloc(CAllocAssist<MAX_LOAD_WIDTH * sizeof(DTYPE)> *p) { palloc = p; }
	void SetDebugLevel(int l) { debugLevel = l; }
	unsigned GetSeqNum() { return seqNum.GetValue(); }
	unsigned GetDataSize() { return data.size(); }
	void ResetVerify();
	void StartDumpVerify(int num);
	void FinishDumpVerify();
	void progress(int num);
	void ReceiveWeights(int);
	void ReadWeights(int);
	void AskWeights(int);
	void ProduceWeights();
	void latch(int num);
	void reset();
	void processInstruction();
	bool IsStopable() { 
		return (fifo.size() == 0) && (hasMoreData == false);
			//&& data.size() == 0 && !busValid;
	}
	bool InstFull() { return fifo.size() >= BANK_INSTRUCTION_FIFOSIZE; }
	void PushInst(InstructionWeight &i) { inst = i; valid = true; start_dump = true; }
	bool Full() { return data.size() >= MAX_CTRL_BUF_SIZE; }
	bool Full(int sz) { return data.size() + sz >= MAX_CTRL_BUF_SIZE; }
	void AddCBIB(CHomoGeneousComputingBank* pib) { cbInsts.push_back(pib); }
	void SetDebug(FILE *f) { fp = f; }
	void SetRam(CBRAM *w) { ramw = w;}
	void SetDDRRead(CDDRReadAssist<PS_DDR_DATAWIDTH> *p) { pddr = p; }

	friend CHomoGeneousComputingBank;
	friend CGlobalInstructionBuffer;
};


struct RequestItem{
	ADDR_TYPE addr;
	unsigned seq : 8;
	unsigned len : 8;
	unsigned token : 8;
	DATA_TYPE type;
	bool isRamA;
	bool isRamB;
	//bool isLast;
};
struct ReturnData{
	DTYPE data[BRAM_BUS_WIDTH]; //40 
	unsigned seq : 8;
	unsigned len : 8;
	unsigned token : 8;
	DATA_TYPE type;
	//bool isLast;
};

struct InstructionRead {
	DATA_MODE mode;
	unsigned reqSeqNum : seq_t;
	unsigned reqProgress : seq_t;
	unsigned seqNum : seq_t;
	unsigned W : out_width_t;
	unsigned H : out_width_t;
	unsigned C : layer_addr_t;
	unsigned Maddr : mem_addr_t;
	unsigned W1 : width_t;
	unsigned W2 : width_t;
	unsigned H1 : width_t;
	unsigned X : out_width_t;
	unsigned Y : out_width_t; //maxval for read, write, weight, ext token gen
	unsigned S : pad_t;
	unsigned lPad : pad_t;
	unsigned rPad : pad_t;
	unsigned isMaddr_a : 1;
	unsigned isMaddr_b : 1;
	unsigned isRes_a : 1;
	//unsigned isMaddr_b : 1;
};

extern unsigned InstructionReadLength;
extern unsigned char* DoPackInstructionRead(InstructionRead *pi);
extern void UnPackInstructionRead(unsigned char *buf, InstructionRead *pi);
class CInterface;
struct SDelayReadInfo{
	bool hasMoreData;
	bool setup_saved;
	//unsigned dataIdx : 4;
	unsigned len : ctrl_width_t;
};
class CReadController :public CSimNode {
	std::queue<InstructionRead> fifo;
	std::vector<CHomoGeneousComputingBank*> cbInsts;
	FILE *fp;
	int debugLevel;
	CFlop<bool, 0> isReadA;
	//CFlop<bool, 0> isResA;
	CFlop<bool, 0> isReadB;
#ifdef S2_OPTIMIZE
	CFlop<bool, 0> isStride2;
#endif
	CFlop<bool, 0> hasMoreData;
	CFlop<bool, 0> readMoreData;
	CFlop<unsigned, data_fifo_t> liveCount;
	CFlop<bool, 0> newReqSeq;
	CBRAM *rama, *ramb;
	CDDRReadAssist<DDR_DATAWIDTH> *pddr;
	CFlop<DATA_MODE, 0> mode;
	CFlop<unsigned, mem_addr_t> Oaddr;
	CFlop<unsigned, seq_t> reqSeq;
	CFlop<unsigned, seq_t> seqNum;
	CFlop<unsigned, seq_t> seqNumNew;
	//CFlop<unsigned> reqSeqNew;
	CFlop<unsigned, seq_t> reqProgress;
	CFlop<unsigned, ctrl_width_t> readWidth;
	CFlop<unsigned, ctrl_width_t> dataWidth;
	CFlop<unsigned, MEM_BIT_SIZE> nextReadPos;
	CFlop<unsigned, MEM_BIT_SIZE> lastPos;
	CFlop<unsigned, out_width_t> nextReadY; 
	CFlop<unsigned, out_width_t> readYLast;
	CFlop<unsigned, out_width_t> w;
	CFlop<unsigned, layer_addr_t> nextReadC; 
	CFlop<unsigned, layer_addr_t> readCLast;
	CFlop<unsigned, MEM_BIT_SIZE> frameReadStart; 
	CFlop<unsigned, outframe_addr_t> frameSize;
	CFlop<unsigned, out_width_t> readYStart;
	CFlop<unsigned, 0> dataRead;
	CFlop<unsigned, 0> dataAsk;
	RequestItem last_ri;
	InstructionRead inst;
	bool valid;
	
	RequestItem ritem[BANK_NUM];
	bool reqValid[BANK_NUM];

	CFiFo<RequestItem, 40> reqq_ddr;
	CFiFo<RequestItem, 40> reqq;
	CFiFo<ReturnData *, 40> retq;
	RequestItem reqGIB;
	CFlop<bool, 0> reqGIBValid;

	std::queue<DTYPE *> data_fifo;
	DTYPE *saveData;
	int dataIdx;
	DTYPE *dataBus;
	bool busValid;
	bool isFeature;
	CAllocAssist<MAX_LOAD_WIDTH * sizeof(DTYPE)> *palloc;
	std::vector<CSimNode *> storages;
	bool data_fifo_empty;
	bool data_fifo_progfull;

	bool req_ram_request;
	bool data_ram_request;
	CFlop<bool, 0> req_ram_valid;
	CFlop<bool, 0> data_ram_valid;
	SDelayReadInfo ramDelay;
	std::queue<DTYPE *> input_data;
	std::queue<SDelayReadInfo> dly_info;
	int cnt_inc;


	FILE *fvi, *fvo;
	bool start_dump;
	bool ddr_enable;
	unsigned  ddr_addr;
	unsigned ddr_len;
	bool  rama_ren;
	bool ramb_ren;
	unsigned ram_addr;
	unsigned ram_len;
	int ddr_id;
	bool input_data_ren;
	bool input_data_wen;
	bool data_fifo_ren;
	bool data_fifo_wen;
	std::map<DTYPE *, unsigned> len_mp;

public:
	CReadController() :fp(NULL) {}
	~CReadController() {}
	
	void Init();
	void SetAlloc(CAllocAssist<MAX_LOAD_WIDTH * sizeof(DTYPE)> *p) { palloc = p; }
	void DumpState();
	bool waitForSeq();
	bool waitingFeature();
	void resetVerify();
	void SetDebugLevel(int l) { debugLevel = l; }
	unsigned GetSeqNum() { return seqNum.GetValue(); }
	void StartDumpVerify(int num);
	void FinishDumpVerify();
	void FinishDumpVerify2();
	void dumpGIBData(DTYPE *data, int clen);
	void DumpVerifyReturnData(ReturnData *rd);
	//bool HasNewReq() { return newReqSeq.GetValue(); }
	//unsigned GetDataSize() { return data_fifo.size(); }
	void progress(int num);
	void ReadData(int);
	void ReceiveData(int);
	void AskData(int);
	void ReadExtData(int);
	void AskExtData(int);
	void ProduceInputs();
	void latch(int num);
	void reset();
	void processInstruction(int);
	void Request(RequestItem &rq, int id) { 
		assert(!reqValid[id]); ritem[id] = rq; reqValid[id] = true;
	}
	bool RequestGIBValid() { return reqGIBValid.GetValue(); }
	void RequestGIB(RequestItem &rq);
	void PushInst(InstructionRead &i) { inst = i; valid = true; }
	bool InstFull() { return fifo.size() >= BANK_INSTRUCTION_FIFOSIZE; }
	bool IsStopable() {
		return (fifo.size() == 0) && (hasMoreData == false);
		//&& data.size() == 0 && !busValid;
	}
	bool Full() { return data_fifo.size() >= MAX_INPUT_BUF_SIZE; }
	bool Full(int sz) { return data_fifo.size() + sz >= MAX_INPUT_BUF_SIZE; }
	bool RequestFull() { return reqq.IsFull(); }
	void AddCBIB(CHomoGeneousComputingBank* pib) { cbInsts.push_back(pib); }
	void SetDebug(FILE *f) { fp = f; }
	void SetDDRRead(CDDRReadAssist<DDR_DATAWIDTH> *p) { pddr = p; }

	void SetRam(CBRAM *a, CBRAM*b) { rama = a; ramb = b; }
	//bool IsReadResSameRam() { return isResA.GetValue() ? isReadA.GetValue() : isReadB.GetValue(); }
	friend CHomoGeneousComputingBank;
	friend CGlobalInstructionBuffer;
	friend CInterface;
};

struct InstructionWrite {
	DATA_MODE mode;
	//int outLen;
	unsigned dataWidth : width_t;
	unsigned dataWidth2 : width_t;
	unsigned Oaddr : mem_addr_t;
	unsigned outH1 : width_t;
	unsigned isUpsample : 1;
	unsigned isMaddr_a : 1;
	unsigned isMaddr_b : 1;
	unsigned maxpool_stride : pad_t;
	unsigned maxpool_size : pad_t;
};

extern unsigned InstructionWriteLength;
extern unsigned char* DoPackInstructionWrite(InstructionWrite *pi);
extern void UnPackInstructionWrite(unsigned char *buf, InstructionWrite *pi);

class CWriteController :public CSimNode {
	std::queue<InstructionWrite> fifo;
	std::vector<CHomoGeneousComputingBank*> cbInsts;
	FILE *fp;
	CAllocAssist<MAX_LOAD_WIDTH * sizeof(DTYPE)> *palloc;
	int debugLevel;
	CFlop<bool, 0> isWriteA;
	CFlop<bool, 0> isWriteB;
	CFlop<bool, 0> isUpsample;
	CFlop<unsigned, mem_addr_t> Oaddr;
	CFlop<unsigned, pad_t> maxpool_stride;
	CFlop<unsigned, pad_t> maxpool_size;
	CFlop<unsigned, width_t> H1_last;
	CFlop<unsigned, width_t> curH01, curH23;
	CFlop<unsigned, width_t> pool_width_01;
	CFlop<unsigned, width_t> pool_width_23;
	CFlop<bool, 0> pool_flush_01; // write out pool max of last row for stride = 1;
	CFlop<bool, 0> pool_flush_23;
	CFlop<unsigned, mem_addr_t> addr_pool_01, addr_pool_23;
	CFlop<DTYPE, 0> pool_max_01[COMPUTING_GROUP_SIZE * 2];
	CFlop<DTYPE, 0> pool_max_23[COMPUTING_GROUP_SIZE * 2];
	
	CBRAM *rama, *ramb;
	CDDRWriteAssist *pddr;
	CFlop<DATA_MODE, 0> mode;
	InstructionWrite inst;
	bool valid;

	//CFlop<int, 0> outLen;
	CFlop<unsigned, width_t> dataWidth;
	CFlop<unsigned, width_t> dataWidth2; // last width of mode four and two
	CFlop<unsigned, 2> idx;
	CFlop<bool, 0> nextInst[BANK_NUM];
	CFlop<unsigned, seq_t> finishedSeq;

	bool outValid[BANK_NUM];
	DTYPE *outBus[BANK_NUM];
	unsigned outAddr[BANK_NUM];
	std::queue<DTYPE *> dataFifo[BANK_NUM];
	std::queue<unsigned> dataAddr[BANK_NUM];
	bool		fifo_empty[BANK_NUM];
	std::vector<CSimNode *> storages;

	FILE		*fvo, *fvi;
	
	bool		start_dump;
	bool		ddr_write_enable;
	unsigned	ddr_write_addr;
	unsigned	ddr_write_len;
	bool		rama_write_enable;
	bool		ramb_write_enable;
	unsigned	ram_write_addr;
	unsigned	ram_write_len;
	bool		data_ren[BANK_NUM];
	

public:
	CWriteController() :fp(NULL) {}
	~CWriteController() {}

	void Init();
	void SetAlloc(CAllocAssist<MAX_LOAD_WIDTH * sizeof(DTYPE)> *p) { palloc = p; }
	void DumpState();
	void progress(int num);
	void latch(int num);
	void StartDumpVerify(int num);
	void FinishDumpVerify();
	void processInstruction(int);
	void SetDebugLevel(int l) { debugLevel = l; }
	void reset();
	void ProduceOutputsx4(int);
	void ProduceOutputs(int);
	unsigned GetFinishedSeq();
	bool IsStopable() {
		return (fifo.size() == 0);
	}
	void AddCBIB(CHomoGeneousComputingBank* pib) { cbInsts.push_back(pib); }
	void SetDebug(FILE *f) { fp = f; }
	void WriteData(DTYPE *buf, int idx, unsigned addr);
	bool IsFetchNextInst();
	bool IsWritable(int idx);
	void SetDDRWrite(CDDRWriteAssist *p) { pddr = p; }
	void SetRam(CBRAM *a, CBRAM*b) { rama = a; ramb = b; }
	void SetNextInst(int i) { nextInst[i] = true; }
	void PushInst(InstructionWrite &i) { inst = i; valid = true; start_dump = true; }
};
struct InstructionOption{
	//unsigned weight_token_max;
	unsigned start : 1;
	unsigned stop : 1;
};

extern unsigned InstructionOptionLength;
extern unsigned char* DoPackInstructionOption(InstructionOption *pi);
extern void UnPackInstructionOption(unsigned char *buf, InstructionOption *pi);

struct InstructionEnd{
	bool isRamA;
	bool isRamB;
	bool hasMore;
	unsigned reqSeqNum : seq_t;
	unsigned oSize : mem_addr_t;
	unsigned oAddr : mem_addr_t;
};

extern unsigned InstructionEndLength;
extern unsigned char* DoPackInstructionEnd(InstructionEnd *pi);
extern void UnPackInstructionEnd(unsigned char *buf, InstructionEnd *pi);

struct GlobalInstruction{
	InstructionType type;
	union{
		InstructionOption co;
		InstructionMem mem;
		InstructionWeight wt;
		InstructionHCB hcb;
		InstructionRead rd;
		InstructionWrite wr;
		Instruction inst;
		InstructionEnd end;
	} i;
};

enum GlobalInstructionBufferState {GIB_IDLE, GIB_CONV, GIB_POOL};
class CComputationBankInstructionBuffer;
class CTokenGen;
class CInterface;
class CGlobalInstructionBuffer :public CSimNode {
	CFlop<unsigned, mem_addr_t> address;
	CFlop<bool, 0> addressValid;
	CFlop<bool, 0> fetchMore;
	
	CFlop<bool, 0> endValid;
	CFlop<unsigned, MAX_INST_BIT_SIZE> readLen;
	CFlop<unsigned, MAX_INST_BIT_SIZE> requestLen;
	CFlop<unsigned, MAX_INST_BIT_SIZE> maxLen;
	CFlop<InstructionType, 0> type;
	CFlop<bool, 0> pendingRequest;
	CFlop<bool, 0> stopRequest;
	InstructionEnd endInst;

	unsigned char instBuf[MAX_INST_LEN];
	std::queue<InstructionEnd> fifo;

	//CFlop<bool, 0> outValid;
	//CFlop<bool, 0> newWctrl;
	//CFlop<GlobalInstructionBufferState, 0> gstate;
	//CFlopLarge<Instruction> inst;
	//CFlop<unsigned, 0> curX;
	//CFlop<unsigned, 0> curH;
	//CFlop<unsigned, 0> curW;
#ifdef BATCH1_OPTIMIZE
	CFlop<unsigned, 0> b15;
	CFlop<unsigned, 0> b12;
	CFlop<unsigned, 0> H1;
#endif
	//CFlop<unsigned, 0> curY;
	//CFlop<unsigned, 0> curSeq;
	CFlop<bool, 0> processEnd;
	FILE *fp;
	int debugLevel;
	
	CBRAM *rama, *ramb, *ramw;
	class CTokenGen *ptoken;
	CWeightController *pcweight;
	CReadController *pcread;
	CWriteController *pcwrite;
	CInterface *pif;
	
	//std::queue<Instruction> instFifo;
	std::vector<CHomoGeneousComputingBank*> cbInsts;
	CAddrBuffer *adrBuf;
	std::vector<CSimNode *> storages;

	FILE *fvi, *fvo;
	bool start_dump;
	bool addressBuffer_ren;
	bool pif_AddOutput;
	bool reqGIBValid;
	bool send_inst;
	
	//unsigned char instBuf[sizeof(GlobalInstruction) + 10];
	
public:
	CGlobalInstructionBuffer():fp(NULL){}
	void Init();
#ifdef BATCH1_OPTIMIZE
	void GetBatchSize(int h, int &b1);
#endif
	void progress(int num);
	void latch(int num);
	void DumpState();
	void dumpReqGIB(RequestItem &ri);
	void dumpWeight(InstructionWeight &pi);
	void dumpRead(InstructionRead &pi);
	void dumpWrite(InstructionWrite &pi);
	void dumpHCB(InstructionHCB &pi);
	//void processInst();
	//void processConvInst();
	//void GetWLenKs(unsigned &wlenk1, unsigned &wlenk2, unsigned wtotal, unsigned k);
	//void processInstExt(InstructionHCB &inst);
	//void processPoolInst();
	void StartDumpVerify(int num);
	void FinishDumpVerify();
	void processEndInst();
	void processStopRequest();
	void ReadInstruction(int);
	void DecodeInstruction(int);
	void SetDebugLevel(int l) { debugLevel = l; }
	void reset();
	/*void Push(GlobalInstruction& ad){
		//if (fifo.size() == ADDRESS_FIFOSIZE)
		//	return;
		inst = ad;
		valid = true;
	}*/
	//bool Pop(GlobalInstruction &ad);
	size_t Size() { return fifo.size(); }
	void AddCBIB(CHomoGeneousComputingBank* pib) { cbInsts.push_back(pib); }
	void SetRam(CBRAM *a, CBRAM*b, CBRAM* w) { rama = a; ramb = b; ramw = w; }
	void SetCtrl(CReadController *r, CWriteController *w, CWeightController *wt) 
	{
		pcread = r; pcwrite = w; pcweight = wt;
	}
	void SetTokenGen(CTokenGen *pr/*, CTokenGen *pw, CTokenGen *pwt, CTokenGen *pe*/){
		ptoken = pr;
		//pwrite = pw;
		//pweight = pwt;
		//pext = pe;
	}
	//bool IsOutValid() { return outValid.GetValue(); }
	bool IsProcessEnd() { return processEnd.GetValue(); }
	//void ResetOutValid() { outValid = false; }
	void SetAddrBuf(CAddrBuffer *pab) { adrBuf = pab; }
	void SetInterface(CInterface *p) { pif = p; }
	void SetDebug(FILE *f) { fp = f; }
};

template <class T> class CCBInstructionBuffer :public CSimNode {
	bool valid;
	T inst;
	std::queue<T> fifo;
	//CGlobalInstructionBuffer *gBuf;

public:
	CCBInstructionBuffer() :valid(false){}
	void Init() { valid = false; }
	void progress(int num){}
	void latch(int num){
		if (valid){
			fifo.push(inst);
			valid = false;
		}
	}
	void reset() { while (!fifo.empty()) fifo.pop(); valid = false; }
	void Push(T& ad){
		if (fifo.size() == BANK_INSTRUCTION_FIFOSIZE)
			return;
		inst = ad;
		valid = true;
	}
	bool Pop(T &ad){
		if (fifo.size() == 0)
			return false;
		ad = fifo.front();
		fifo.pop();
		return true;
	}
	bool Top(T &ad){
		if (fifo.size() == 0)
			return false;
		ad = fifo.front();
		return true;
	}
	size_t Size() { return fifo.size(); }
	bool IBFull() { return Size() == BANK_INSTRUCTION_FIFOSIZE; }
	bool IBEmpty() { return Size() == 0; }
	//void SetGIB(CGlobalInstructionBuffer *pib) { gBuf = pib; }
};



class CTokenGen :public CSimNode {
	int token; // correspond to HCB id
	bool isFroze;
	int maxVal;
	int maxTmp;
	bool newValid;
	bool next;
	FILE *fp;
	//std::vector<CSimNode *> clients;
public:
	CTokenGen() :isFroze(false), token(0), newValid(false), fp(NULL) {}
	void Init(){
		isFroze = false;
		token = 0;
		maxVal = 0;
		newValid = false;
		next = false;
		fp = NULL;
	}
	void latch(int num){
		if (!isFroze){
			if (newValid){
				maxVal = maxTmp;
				newValid = false;
				token = 0;
			}
			else{
				//if (next)
				{
					if (token == maxVal)
						token = 0;
					else
						token++;
					next = false;
				}
			}
		}
	}
	void Next() { next = true; }
	void progress(int num) {}
	void DumpState(){
		if (fp)
			fprintf(fp, "Dump %s, token %d (%d), froze?(%s)\n"
			, name.c_str(), token, maxVal, isFroze?"Y":"N");
	}
	void SetDebug(FILE *f){ fp = f; };
	int GetToken() { return token; }
	void reset() { isFroze = false; token = 0; newValid = false; }
	void SetMaxVal(int m) { maxTmp = m; newValid = true; }
	void Freeze() { isFroze = true; }
	void Free() { isFroze = false; }
	//void AddClient(CSimNode *p) { clients.push_back(p); }
};

template <class T, int Size, int BufSize> class CFiFoOutBuf : public CSimNode{
	CFiFo<T, Size> *pfifo;
	T buffer[BufSize];
	CFlop<unsigned, 0> numBuf;
public:
	CFiFoOutBuf(){}
	~CFiFoOutBuf(){}
	void Init(){
		numBuf.Init();
	}
	void SetFifo(CFiFo<T, Size> *p) { pfifo = p; }
	virtual void progress(int num){
		//cur_val = prev_val;
	}
	void latch(int num){
		numBuf.latch(num);
	}
	virtual void reset(){
		//numBuf.reset();
		numBuf = 0;
	}
	unsigned GetNumBuf() { return numBuf.GetValue(); }
	bool HasEnough(unsigned i) { return pfifo->size() > 0 || numBuf.GetValue() >= i; }
	unsigned size() { return numBuf.GetValue() + pfifo->size(); }
	bool GetData(T *buf, unsigned len){
		assert(size() >= len);
		if (numBuf.GetValue() >= len){
			memcpy(buf, buffer, sizeof(T) * len);
			numBuf = numBuf.GetValue() - len;
			for (unsigned i = 0; i < numBuf.GetNextValue(); i++)
				buffer[i] = buffer[i + len];
			return false;
		}
		else{
			T buf2[BufSize];
			unsigned i;
			unsigned bufSize = BufSize; // do not need bufSize in real implementation
			if (bufSize > pfifo->size())
				bufSize = pfifo->size();
			for (i = 0; i < bufSize; i++){ // one pop in hardware
				buf2[i] = pfifo->Pop();
			}
			memcpy(buf, buffer, sizeof(T) * numBuf.GetValue());
			memcpy(buf + numBuf.GetValue(), buf2, sizeof(T) * (len - numBuf.GetValue()));
			numBuf = bufSize - (len - numBuf.GetValue());
			for (i = 0; i < numBuf.GetNextValue(); i++)
				buffer[i] = buf2[len - numBuf.GetValue() + i];
			return true;
		}
	}
};
//
//class CHomoGeneousComputingBank;
//class CGetTotalFrames :public CSimNode{
//	CFlop<bool, 0> fc_computing, fc_done;
//	CFlop<int, 0> fc_kh, fc_ks, fc_kt, fc_num;
//	CFlop<int, 0> fc_ng;
//	CHomoGeneousComputingBank *p;
//	std::vector<CSimNode *> storages;
//public:
//	void Init();
//	void SetP(CHomoGeneousComputingBank *ph) { p = ph; }
//	void progress(int num);
//	void latch(int num);
//	void reset();
//	void Start(int kh, int ks, int kt, int ng);
//};

class CShiftComputingGroup;
enum HCB_STATE { IDLE, CONV_INIT, CONV_START, CONV_MULT, CONV_BM, CONV_RELU, CONV_OUT, CONV_DONE};
enum INPUT_SOURCE {INPUT_NON, INPUT_X, INPUT_BACKUP, INPUT_E, INPUT_S };
enum EXT_WEIGHT_READ_STATE {EWRS_NON, EWRS_BM, EWRS_RES};


class CHomoGeneousComputingBank :public CSimNode {
	CCBInstructionBuffer<InstructionHCB> *pib;
	CCBInstructionBuffer<InstructionHCBWt> *pibw;
	//CCBInstructionBuffer<InstructionHCBNF> *pibf;
	CTokenGen *ptoken;
	CTokenGen *ptokenw;
	CReadController *pread;
	CWriteController *pwrite;
	CWeightController *pcweight;
	//CGetTotalFrames *pfc;
	CAllocAssist<MAX_LOAD_WIDTH * sizeof(DTYPE)> *palloc;
	//CBRAM  *ramw;
	CMem<DTYPE, INPUT_FEATURE_SIZE, TMP_BUF_SIZE> inputs;
	CMem<DTYPE, INPUT_MEM_WIDTH, INPUT_MEM_WIDTH> input_buffer;
	CFiFo<DTYPE, 12 * COMPUTING_UNIT_OUTPUT_SIZE * COMPUTING_GROUP_SIZE> resBuf; //change 12 to 48 
	CMem<DTYPE, 2 * COMPUTING_GROUP_SIZE, 2 * COMPUTING_GROUP_SIZE> resOutBuf;
	CFiFo<DTYPE, HCB_WEIGHT_SIZE> weights; // 1 to 2 FIFO, read 10, output 20
	//CFiFo<DTYPE, EXT_WEIGHT_SIZE> extWeights; // 2 to 1 FIFO, read 40 , output 20
	CFiFoOutBuf<DTYPE, HCB_WEIGHT_SIZE, WEIGHT_BUFFER_SIZE> weightOutBuf;
	//CFiFoOutBuf<DTYPE, EXT_WEIGHT_SIZE, BM_READ_WIDTH> extWeightOutBuf;
	//CFlop<unsigned, data_fifo_t> liveBM;
	CFlop<unsigned, 10> liveRes;
	int reqBM;
	int reqRes;
	bool popRes;
	bool popBM;
	//
	
	
	std::vector<CShiftComputingGroup*>  cgs; //eval from bottom to top for output propogation
	INPUT_SOURCE input_src;
	//CFlop<EXT_WEIGHT_READ_STATE> ext_state;
	CFlop<int, 0> shiftBuf[MAX_K][MAX_SHIFT_SIZE];
	CFlop<int, 0> shiftBufBackup[MAX_K][MAX_SHIFT_SIZE];
	CFlop<int, 0> shiftBufShift[MAX_K][MAX_SHIFT_SIZE];
	
	//CMem<DTYPE, INPUT_MEM_WIDTH, INPUT_MEM_WIDTH> assemble_buffer0_m;
	//CMem<DTYPE, INPUT_MEM_WIDTH, INPUT_MEM_WIDTH> assemble_buffer1_m;
	//CFiFo<DTYPE, INPUT_MEM_WIDTH> assemble_buffer0; // depth of 1
	//CFiFo<DTYPE, INPUT_MEM_WIDTH> assemble_buffer1; // depth of 1
	CFiFo<DTYPE, INPUT_MEM_WIDTH * 16> assemble_buffer; // depth of 2, 16 for fpga implementation
	CFiFo<DTYPE, INPUT_MEM_WIDTH * 16> inputs_buffer;
	CMem<DTYPE, INPUT_MEM_WIDTH, INPUT_MEM_WIDTH> assemble_tmp;
	CFlop<unsigned, mem_bus_addr_t> atmpSize;
	CFlop<unsigned, input_addr_t> addrNextFrame;
	CFlop<unsigned, input_addr_t> addrNextAssemble;
	CFlop<unsigned, input_addr_t> addrCurAssemble;
	//CFlop<bool> ab0Filled;
	//CFlop<bool> ab1Filled;
	//CFlop<bool> ab0Write;
	//CFlop<bool> ab0Read;
	CFlop<bool, 0> doAssemble;
	CFlop<bool, 0> input_requested; // simulate one cycle delay of bram read.

	CFiFo<DTYPE*, INPUT_FIFO_SIZE> input_fifo;
	
	CFlop<unsigned, layer_addr_t> iLayers;
	
	CFlop<int, 0> rowAddr;
	CFlop<int, 0> rowNum;
	


	CFlop<unsigned, ibSize_t> ibSize;
	CFlop<int, 0> id;
	CFlop<unsigned, scale_t> wScale;
	CFlop<unsigned, scale_t> fScale;
	CFlop<unsigned, layer_addr_t> outLayerCount;
	CFlop<bool, 0> doOutScale;
	CFlop<DATA_MODE, 0> mode;
	CFlop<unsigned, seq_t> finishSeq;
	CFlop<unsigned, seq_t> curSeq; // working seq
	CFlop<unsigned, layer_addr_t> workingProgress; // output done for current seq
	CFlop<unsigned, seq_t> reqSeq;
	CFlop<unsigned, seq_t> reqProgress;
	CFlop<unsigned, seq_t> reqSeqW;
	CFlop<unsigned, seq_t> reqSeqF;
	//CFlop<int> reqProgressW;
	CFlop<unsigned, k_t> k;// , w, h, c;
	CFlop<unsigned, pad_t> stride;
	CFlop<unsigned, out_width_t> outW, outW1;// , outC, outW1;
	//CFlop<int> outX, outY, outW1;// , outH1;
	CFlop<unsigned, outframe_addr_t> outFrameSize;
	CFlop<unsigned, loc_frame_t> outBufFrameSize;
	CFlop<unsigned, output_gap_t> outputAddrGap;
	CFlop<unsigned, output_gap_t> outFrameGapSize;
	CFlop<unsigned, output_gap_t> outResGapSize;
	CFlop<ADDR_TYPE, 0> outputAddr, outputFrameStart;
	CFlop<unsigned, cg_addr_t> outputCGIdx;
	CFlop<unsigned, cg_addr_t> outputCGIdx0;
	CFlop<unsigned, output_addr_t> outputRows;
	
	CFlop<unsigned, 2> outputUPSteps;
	CFlop<unsigned, width_t> outputBufH1;
	CFlop<unsigned, width_t> outputBufH1Orig;
	CFlop<unsigned, width_t> outputBufH1Relu;
	CFlop<unsigned, width_t> outputBufW1;
	CFlop<unsigned, cg_addr_t> numGroups;
	CFlop<unsigned, cg_addr_t> usedGroupsLast;
	CFlop<unsigned, cg_addr_t> usedCGLast;
	CFlop<unsigned, cg_addr_t> usedCG0;
	CFlop<unsigned, pad_t> leftPad, rightPad;
	CFlop<unsigned, pad_t> topPad, downPad;
	//CFlop<int> paddingStartPos;
	//CFlop<int> paddingShiftPos; //*
	//CFlop<int> paddingShiftRowStart; //*
	//CFlop<int> shiftTopPaddings; //*
	CFlop<unsigned, token_t> token;
	//CFlop<int> wtoken;
	//CFlop<unsigned, width_t> readRowCount;
	CFlop<unsigned, width1_t> maxRowCount;
	CFlop<unsigned, width1_t> curRowCount;
	CFlop<unsigned, width_t> lastLen;
	CFlop<unsigned, width_t> readWidth;
	CFlop<unsigned, width_t> writeWidth;
	CFlop<unsigned, mem_bus_addr_t> readPos;
	CFlop<unsigned, mem_bus_addr_t> resPos;
	CFlop<unsigned, layer_addr_t> readCLast;
	CFlop<unsigned, width_t> frameCountDown;//*

#ifdef BATCH1_OPTIMIZE
	CFlop<unsigned, mem_addr_t> batchAddr;
	CFiFo<bool, 2> outBatch3;
	CFlop<unsigned, output_addr_t> outputRowsBatch;
	CFlop<unsigned, width_t> readRowCount3;
	CFlop<unsigned, width_t> lastRowLen3;
	CFlop<unsigned, layer_addr_t> kbh; //batch start
	CFlop<unsigned, layer_addr_t> kbe, kbe_1; // batch end
	CFlop<bool, 0> batch_only_1group;
	CFlop<unsigned, cg_addr_t> wtotal_bn;
	CFlop<unsigned, weight_bus_size_t> wlenk_bn;
	CFlop<unsigned, weight_bus_size_t> wlenk_bLast;
	CFlop<unsigned, weight_bus_size_t> wlenk_bLast2;
	CFlop<unsigned, cg_addr_t> wtotalbLast;
	CFlop<unsigned, weight_bus_size_t> wlenkbLast;
	CFlop<bool, 0> doBatch3K1;
	CFlop<bool, 0> doBatch3K1_cur;
	CFlop<bool, 0> doBatch3K1_out;
	CFlop<unsigned, batch_t> batchSize;
	CFlop<unsigned, 2> batchIdx;
	CFlop<unsigned, mem_addr_t> resBatchStart;
	CFlop<unsigned, res_size_t> resSizeBatch;
	CFlop<unsigned, res_len_t> resLenBatch;
	CFlop<ADDR_TYPE, 0> bmBatchStart;
	CFlop<ADDR_TYPE, 0> bmBatchEnd;

#endif

#if WEIGHT_BUFFER_SIZE_MULT == 2
	DTYPE weightBuffer[WEIGHT_DATA_WIDTH];
	CFlop<bool, 0> idxWeightBuffer;
#endif

	CFlop<unsigned, mem_bus_addr_t> weightReadPos;
	CFlop<ADDR_TYPE, 0> nextWeightRead;
	CFlop<ADDR_TYPE, 0> endWeightRead;
	CFlop<unsigned, layer_addr_t> kCur; //*
	CFlop<unsigned, layer_addr_t> kCurLast, kCurLast_1; //*
	CFlop<unsigned, layer_addr_t> kRes;
	CFlop<unsigned, layer_addr_t> kOut;
	CFlop<unsigned, layer_addr_t> Ks;
	CFlop<unsigned, layer_addr_t> kt;
	CFlop<unsigned, 2> outBufferUseCount;
	CFlop<int, 0> convBuffers;//debug
	CFlop<int, 0> outBuffers;//debug

	//CFlop<int> frameSize; //W * H
	CFlop<unsigned, input_addr_t> volumeSize; //W * H * C 
	CFlop<unsigned, input_addr_t> curVolumeSize;
	//CFlop<int> frameReadStart;
	//CFlop<int> nextReadPos;
	CFlop<unsigned, input_addr_t> nextWritePos;
	CFlop<unsigned, input_addr_t> usedWords;//*
	CFlop<unsigned, loc_frame_t> usedWords_inc;//*
	CFlop<bool, 0> usedWords_reset;//*

	CFlop<unsigned, loc_frame_t> prefetchFrameSize;

	CFlop<unsigned, k_t> initFSteps;
	CFlop<unsigned, cg_addr_t> initWSteps; //*
	CFlop<unsigned, cg_addr_t> initBMWSteps;
	CFlop<unsigned, cg_addr_t> wtotal;
	CFlop<unsigned, weight_bus_size_t> wlen;
	CFlop<unsigned, weight_bus_size_t> wlen_regular;
	CFlop<unsigned, weight_bus_size_t> wlenk;
	CFlop<unsigned, cg_addr_t> wtotal_n;
	CFlop<unsigned, weight_bus_size_t> wlenk_n;
	CFlop<unsigned, cg_addr_t> wtotalLast;
	CFlop<unsigned, weight_bus_size_t> wlenkLast;
	
	CFlop<unsigned, weight_bus_size_t> wlenk_regular;
	CFlop<unsigned, weight_bus_size_t> wlenk_last;
	CFlop<unsigned, weight_bus_size_t> wlenk_nLast;
	CFlop<unsigned, weight_bus_size_t> wlenk_nLast2;
	
	
	CFlop<unsigned, weight_bus_size_t> BMlen;
	int backupId;
	CFlop<unsigned, cg_addr_t> weightId;
	//CFlop<int> nextBackupAddr; //**
	//CFlop<int> prefetchAddr; //*
	CFlop<unsigned, width_t> outputCountDown;
	CFlop<unsigned, width_t> outputReadPos;//*
	CFlop<unsigned, width_t> outputWritePos;//*
	CFlop<unsigned, k_t> iterCountDown;//*
	//CFlop<int> nextFrameAddr; //**
	CFlop<unsigned, layer_addr_t> layerCount; //*
	//CFlop<unsigned, cg_addr_t> usedCG; //*
	CFlop<unsigned, cg_addr_t> usedGroups;//*
	CFlop<unsigned, cg_addr_t> outputIdxMax;
	CFlop<unsigned, pad_t> maxpool_stride;
	CFlop<bool, 0> isLastOutput;
	CFlop<bool, 0> doRes_out;
	CFlop<unsigned, width_t> outputBufW1_out;
	CFlop<unsigned, out_width_t> outW_out2;
	CFlop<bool, 0> doUpSample_out;
	//CFlop<int> outW1_out;
	CFlop<ADDR_TYPE, 0> outputAddr_out;
	CFlop<unsigned, pad_t> maxpool_stride_out;
	CFlop<unsigned, width_t> outputBufH1_out;
	CFlop<ADDR_TYPE, 0> outputFrameStart_out;
	CFlop<unsigned, outframe_addr_t> outFrameSize_out;
	CFlop<unsigned, out_width_t> outW_out;
	CFlop<unsigned, output_gap_t> outputAddrGap_out;
	CFlop<unsigned, k_t> k_out;
	CFlop<unsigned, seq_t> curSeq_out;
	CFlop<bool, 0> newWriteInst;
	CFlop<bool, 0> newWriteInst_out;
	
	CFlop<unsigned, mem_addr_t> nextResAddr;
	CFlop<unsigned, mem_addr_t> frameResAddr;
	CFlop<unsigned, width_t> resRowCount;
	CFlop<unsigned, res_size_t> resSize;
	CFlop<unsigned, res_size_t> resSize0;
	CFlop<unsigned, res_size_t> resSizeLast;
	CFlop<unsigned, res_len_t> resLen0;
	CFlop<unsigned, res_len_t> resLen;
	CFlop<unsigned, res_len_t> resLenLast;
	CFlop<unsigned, res_size_t> resReadSize;
	CFlop<unsigned, layer_addr_t> resFrameCount;
	CFlop<unsigned, layer_addr_t> resFrameMax;
	CFlop<unsigned, res_size_t> totalRes;
	CFlop<unsigned, res_size_t> askedRes;
	CFlop<unsigned, res_size_t> receivedRes;
	CFlop<unsigned, res_size_t> receivedResStopSize;
	CFlop<bool, 0> receivedResStopValid;
	CFlop<unsigned, bank_num_t> idxRes;
	CFlop<unsigned, bank_num_t> idxResMax;
	DTYPE resReceiveBuf[COMPUTING_GROUP_SIZE * 3];
	std::queue<DTYPE *> res_received_data;
	std::queue<unsigned char> res_received_len;
	CFlop<unsigned, data_fifo_t> res_received_live;
	bool res_asked;
	bool res_received;
	
	//CFlop<unsigned, bm_size_t> bmBlockSize;
	//CFlop<ADDR_TYPE, 0> bmLastAddr;
	//CFlop<ADDR_TYPE, 0> bmNextAddr;
	//CFlop<ADDR_TYPE, 0> bmEndAddr;
	//CFlop<unsigned, bm_size_t> bmSkipSize;
	//CFlop<bool> isbmBatch;
	CFlop<DTYPE, 0> wLRelu;
	CFlop<unsigned, 1> bmPhase;
	//CFlop<unsigned, bm_size_t> totalBM;
	//CFlop<unsigned, bm_size_t> askedBM;
	//CFlop<unsigned, bm_size_t> receivedBM;
	//CFlop<bool, 0> requestingBM;
	CFlop<bool, 0> requestingRes;

	CFlop<bool, 0> isReadResA;
	CFlop<bool, 0> isResMaster;
	//CFlop<bool> isWeightMaster;
	CFlop<bool, 0> isProgressMaster;
	bool isBackupValid;
	CFlop<bool, 0> isWeightValid;
	CFlop<bool, 0> isBMWeightValid;
	bool isOutputReady;
	FILE *fp;
	int debugLevel;
	CFlop<bool, 0> isRunning;
	CFlop<bool, 0> isInitLayer;//*
	CFlop<bool, 0> isLastLayer;//*
	CFlop<bool, 0> isPrefetchNext;
	//CFlop<bool> outputAfterLast;
	CFlop<bool, 0> isReadingFeatures;
	CFlop<bool, 0> isReadingWeights;
	CFlop<bool, 0> isPrefetchWeight;//*
	CFlop<bool, 0> isPrefetchBMWeight;//*
	CFlop<bool, 0> isLReluInit;
	CFlop<bool, 0> isLoadingNextFeatures;//*
	CFlop<bool, 0> isLoadingNextWeights;
	CFlop<bool, 0> hasNextFeatureParams;
	//CFlop<bool> hasNextWeightParams;
	CFlop<bool, 0> isLoadingFroze;//*
	//CFlop<bool, 0> isPreferRes;
	CFlop<bool, 0> loadNextInst;

	bool is_cycle_froze;
	bool nextWeight;
	CFlop<bool, 0> doRes;
	CFlop<bool, 0> doRelu;
	CFlop<bool, 0> doLRelu;
	CFlop<bool, 0> doBM;
	CFlop<bool, 0> doUpSample;
	CFlop<bool, 0> isLReluWeight;
	bool cgSwitchOutput;
	CFlop<bool, 0> isPrefetchNextVolume;
	CFlop<bool, 0> isNextVolumeReady;
	CFlop<bool, 0> isOnOutput;
	CFlop<bool, 0> waiting_out;
	//CFlop<bool> waiting_res;
	//CFlop<bool> waiting_res_for_out; // when compute much faster than loading res data
	//CFlop<bool> waitPrefetching;
#ifdef S2_OPTIMIZE
	CFlop<bool, 0> isStride2;
	CFlop<unsigned, width_t> rowCounts;
	CFlop<int, 0> nextRowStart;
	CFlop<unsigned, k_t> kIter;
	CFlop<unsigned, fpga_min_addr_t> s2b_start;
	CFlop<unsigned, fpga_min_addr_t> s2b_end;
	CFlop<int, 0> s2b_lastAddr;
	CFlop<unsigned, fpga_min_addr_t> s2b_cur;
	CMem<DTYPE, INPUT_MEM_WIDTH * S2_BUFFER_SIZE, INPUT_MEM_WIDTH> s2_buffer;
#endif
#ifdef BATCH1_OPTIMIZE
	DTYPE backupBus[3 * COMPUTING_GROUP_SIZE];
#elif defined(S2_OPTIMIZE)
	DTYPE backupBus[2 * COMPUTING_GROUP_SIZE];
#else
	DTYPE backupBus[COMPUTING_GROUP_SIZE];
#endif
	CFlop<DTYPE, 0> weightBus[WEIGHT_BUS_SIZE];
	//CFlop<DTYPE, 0> bmWeightBus[WEIGHT_BUS_SIZE];
	DTYPE shiftInputs[MAX_K];
	CFlop<HCB_STATE, 0> state;
	std::vector<CSimNode *> storages;
	int pib_Size;

// Begin For Dump verification files
	bool inputs_write;
	bool on_output;
	bool new_conv_inst; // for verification only
	bool startprefetching;
	bool reset_iLayers;
	bool new_weight_params;
	bool rf_new_params;
	bool setLoadingFroze, resetLoadingFroze;
	bool resetLoadingNextFeatures, resetReadingFeatures;
	bool input_wen;
	bool input_ren;;
	bool resetAssemble;
	bool assemble_buff_wen;
	bool assemble_buff_ren;
	bool inputfifo_wen;
	int input_addr;
	bool sendBackUpInput_valid;
	bool is_assemble_buff_full, is_assemble_buff_empty;
	bool is_input_fifo_full, is_input_fifo_empty, inputfifo_ren;
	bool inputs_buffer_progfull, inputs_buffer_wen, inputs_buffer_ren;
	bool inputs_buffer_empty;
	bool reset_isOnOutput;
	bool start_conv_out;
	bool set_out_params;
	bool set_LastOutput;
	bool resfifo_ren;
	bool pwrite_enable;
	bool pwrite_setNextInst;
	bool reset_state;
	bool new_params_prefetch;
	bool pib_ren;
	bool token_set;
	int max_token;
	bool receive_inst;
	bool dump_start;
	bool pread_RequestValid;
	CFlop<int, 0> weights_len;
	CFlop<int, 0> bmweights_len;
	RequestItem 	pread_request;
	FILE *fbmi;
	FILE *fbmo;
	FILE *fwti;
	FILE *fwto;
	FILE *fexo;
	FILE *fexi;
	FILE *fsio;
	FILE *fsii;
	FILE *frfi;
	FILE *frfo;
	FILE *faio, *faii;
	FILE *fbio, *fbii;
	FILE *fsbo, *fsbi;
	FILE *fino, *fini;
	FILE *fsoo, *fsoi;
	FILE *fpoo, *fpoi;
	FILE *fhco, *fhci;
	FILE *fpio, *fpii;
	FILE *fhcbo, *fhcbi;
// End For Dump verification files

	int weightUsed;

	// write token is id
public:
	CHomoGeneousComputingBank():fp(NULL) {}
	~CHomoGeneousComputingBank();
	void SetDebug(FILE *f);
	std::string GetModeName();
	std::string GetInputSourceName();
	std::string GetStateName();
	void SetFC(int fc_count);
	void SetAlloc(CAllocAssist<MAX_LOAD_WIDTH * sizeof(DTYPE)> *p) { palloc = p; }
	unsigned GetReqNum() { return reqSeq.GetValue(); }
	unsigned GetReqWeight() { return reqSeqW.GetValue(); }
	unsigned GetReqFeature() { return curSeq.GetValue(); }
	bool IsRunning() { return isRunning.GetValue(); }
	void SetStart() { isRunning = true; }
	void SetStop() { isRunning = false; }
	void SetCtrl(CReadController *r, CWriteController *w, CWeightController *wt) 
	{ 
		pread = r; 
		pwrite = w; 
		pcweight = wt;
	}
	void StartDumpVerifyHCBCtrl(int num);
	void FinishDumpVerifyHCBCtrl();
	void StartDumpVerifyProcessConvOut(int num);
	void dumpVerifyProcessConvOutRes(DTYPE *buf);
	void dumpVerifyProcessConvOutData(DTYPE *buf, unsigned addr);
	void FinishDumpVerifyProcessConvOut();
	void StartDumpVerifyStartConvOut();
	void FinishDumpVerifyStartConvOut();
	void StartDumpVerifyInput(int num);
	void FinishDumpVerifyInput(int num);
	void NewVerificationFiles();
	void writeVerificationWeight(int num);
	void SetDebugLevel(int l);
	void progress(int num);
	void dumpBuildInputFifoVerify_buffer(DTYPE *buf);
	void dumpBuildInputFifoVerify_inputfifo(DTYPE *buf);
	void dumpBuildInputFifoVerify(int num);
	void buildInputFifo(int num);
	void buildInputFifoCore(int num);
	void AssembleInput(int num);
	void AssembleInputBuffer(int num);
	void dumpAssembleInputVerify(int num);
	void dumpAssembleInputVerify_inputs(DTYPE *buf2, int addr);
	void dumpAssembleInputVerify_buffer(DTYPE *buf);
	void AssembleInputCore(int num);
	bool DoOutScale() { return doOutScale.GetValue(); }
	int GetOutWScale() { return wScale.GetValue(); }
	int GetOutFScale() { return fScale.GetValue(); }
	int GetOutputReadPos() { return outputReadPos.GetValue(); }
	int GetOutputWritePos() { return outputWritePos.GetValue(); }
	int getTotalFrames(int kh, int ks, int kt, int ng);
	void latch(int num);
	void DumpState();
	void Init();
	void Init(int cgNum);
	void reset();
	void SetName(std::string s);
	void SetTokenGen(CTokenGen *r, CTokenGen *w/*, CTokenGen *wt, CTokenGen *ext*/) {
		ptoken = r;
		ptokenw = w;
		//pwt = wt;
		//pext = ext;
	}
	void SetID(int i) { id.SetValue(i); }
	void SetIB(CCBInstructionBuffer<InstructionHCB> * p) { pib = p; }
	//void SetRam(CBRAM*w) { ramw = w; }
	void AddSCG(CShiftComputingGroup* pcg);
	bool IBFull() { return pib->IBFull(); }
	bool GetIBSize() { return pib->Size(); }
	bool IsStopable() {
		return (pib->IBEmpty()) && (state == IDLE);
		//&& data.size() == 0 && !busValid;
	}
	unsigned  GetFinishedSeq() { return finishSeq.GetValue(); }
	unsigned  GetWorkingSeq() { return curSeq.GetValue(); }
	unsigned  GetWorkingProgress() { return workingProgress.GetValue(); }
	void PushInst(int num, InstructionHCB &inst);
	void writeRequest(int num, RequestItem &ri);
	void dumpReadExtraVerify(int num);
	void ReadExtraWeights(int num);
	//void ReceiveExtraWeights();
	void ReceiveResData(int num);
	void ReadResData(int num);
	void dumpReadFeaturesVerify(int num);
	void dumpReadFeaturesInputVerify(DTYPE *buf2, unsigned addr, unsigned len);
	void ReadFeatures(int num);
	void ReadFeaturesCore(int num);
	void StartDumpVerifyHCB(int num);
	void FinishDumpVerifyHCB();
	void dumpVerifyInstruction(InstructionHCB &inst);
	void StartDumpVerifyProcessInstruction(int num);
	void FinishDumpVerifyProcessInstruction();
	void processInstruction(int num);
	void processUsedWords(int num);
	void processConvInit(int num);
	bool IsCycleFroze()	{ return is_cycle_froze; }
	void processConvCompute(int num);
	void computeCycleFroze(int num);
	void processBMWeights(int num);
	void processConvStart(int num);
	void processConvOut(int);
	void processNextFeatureLoading(int);
	void processNextWeightLoading(int);
	void ReadWeights(int num);
	unsigned GetWLen(unsigned wtotal, unsigned initw, unsigned k);
	unsigned GetBMWLen(unsigned ug, unsigned initw);
	void SetupShiftInputs(int);
	//void sendBackUpInput0(int id);
	void sendBackUpInput(int id);
	//void sendBMWeights(int id);
	bool sendBMWeights(int id, int len);
	//void sendBMWeights1(int id); // send 2 at once
	//void sendWeights(int id);
	void sendWeights(int id, int len);
	//void sendWeights13(int id); // send 2 at once
	void setCGConvRows(InstructionHCB &inst);
	void startConvOut(int);
	HCB_STATE GetState() { return state.GetValue(); }
	DTYPE GetBackUp(int i) { return backupBus[i]; }
	DTYPE GetShiftInput(int i) { return shiftInputs[i]; }
	bool IsReadingWeights() { 
		return isReadingWeights.GetValue(); 
	}
	unsigned GetIterCountDown() { return iterCountDown.GetValue(); }
	bool IsOutputReady() { return isOutputReady; }
	bool IsWeightFull() { 
		return weights.IsFull(WEIGHT_DATA_WIDTH); 
	}
	bool IsProgressMaster() { return isProgressMaster.GetValue(); }
	bool IsReadingFeatures() { return isReadingFeatures.GetValue(); }
	bool IsLoadingFroze() { return isLoadingFroze.GetValue(); }
#ifdef S2_OPTIMIZE
	bool IsStride2() { return isStride2.GetValue(); }
#endif
	void startPrefetching(int num);
	bool IsFetchNextInst() { 
		return state == IDLE || 
			loadNextInst.GetValue()
			&& (!doRes.GetValue() || receivedRes.GetValue() >= totalRes.GetValue()) && pib_Size > 0;
	}
	friend CShiftComputingGroup;
};

enum UCL_M_MUX {UCLM_X, UCLM_PSUM};
enum UCL_A0_MUX { UCLA0_MUL, UCLA0_MS, UCLA0_X};  //X for res operation
enum UCL_A_MUX {UCLA_W, UCLA_PSUM, UCLA_AQ, UCLA_0};
enum UCL_AQ_MUX {UCLAQ_PLUS, UCLAQ_AQ};
enum UCL_SA_MUX {UCLSA_X, UCLSA_LOW};
enum UCL_SQ_MUX {UCLSQ_AQ, UCLSQ_PLUS, UCLSQ_SQ };
enum UCL_OUT_MUX {UCLO_RELU, UCLO_AQ, UCLO_SQ};
enum UCL_C0_MUX {UCLC0_X, UCLC0_LOW, UCLC0_PSUM};
enum UCL_C1_MUX {UCLC1_W, UCLC1_SQ };
enum UCL_L_MUX { UCLL_0, UCLL_MUL };

class CUnifiedComputingLogic :public CSimNode {
	CFlop<DTYPE2, 0> mq, aq, sq, psumq;
	//CFlop<unsigned char, 0> cmpQ, cmpQ1, cmpQ2;
	std::vector<CSimNode *> storages;
	FILE *fp;
	int debugLevel;
public:
	CUnifiedComputingLogic():fp(NULL) {}
	void SetDebug(FILE *f) { fp = f; }
	void Init();
	void progress(int num) {}
	void SetDebugLevel(int l) { debugLevel = l; }
	void latch(int num){
		std::vector<CSimNode *>::const_iterator p = storages.begin();
		for (; p != storages.end(); p++)
			(*p)->latch(num);
	}
	void reset() {}
	DTYPE GetPSUMQ() { return psumq.GetValue(); }
	DTYPE GetMQ() { return mq.GetValue(); }
	DTYPE GetAQ() { return aq.GetValue(); }
	DTYPE GetSQ() { return sq.GetValue(); }
	DTYPE eval(CShiftComputingGroup *pscg, DTYPE x, DTYPE w, DTYPE psum, DTYPE low, bool debug = false);
};

class CUnifiedComputingUnit :public CSimNode {
	CUnifiedComputingLogic *pucl;
	CFlop<DTYPE, 0> input, shift, backup
#ifdef S2_OPTIMIZE
		, backup2, S2
#endif
		;
	//DTYPE outputs[COMPUTING_UNIT_OUTPUT_SIZE * 2];
	CMem<DTYPE2, COMPUTING_UNIT_OUTPUT_SIZE, 1> outputs0;
	CMem<DTYPE2, COMPUTING_UNIT_OUTPUT_SIZE, 1> outputs1;
	CShiftComputingGroup *pscg;
	CUnifiedComputingUnit *right;
	CUnifiedComputingUnit *below;
	DTYPE2 out;
	bool isLast;
	FILE *fp;
	int debugLevel;
	std::vector<CSimNode *> storages;
public:
	CUnifiedComputingUnit() :isLast(false), below(NULL),fp(NULL) {}
	~CUnifiedComputingUnit();
	void SetDebug(FILE *f) { fp = f; pucl->SetDebug(f); }
	void Init();
	void progress(int num);
	void latch(int num){
		std::vector<CSimNode *>::const_iterator p = storages.begin();
		for (; p != storages.end(); p++)
			(*p)->latch(num);
		pucl->latch(num);
	}
	void SetDebugLevel(int l) { debugLevel = l; pucl->SetDebugLevel(l); }
	void reset() {}
	void SetRight(CUnifiedComputingUnit *pu) { right = pu; }
	void SetBelow(CUnifiedComputingUnit *pu) { below = pu; }
	DTYPE GetShiftS() { return below? below->GetShift():0; }
	DTYPE GetPSumLow() { return below ? below->GetOutPut() : 0; }
	void SetLast() { isLast = true; }
	void SetUCL(CUnifiedComputingLogic *p) { pucl = p; }
	void SetSCG(CShiftComputingGroup *p) { pscg = p; }
	void SetBackUp(DTYPE v) { backup.SetValue(v); }
#ifdef S2_OPTIMIZE
	void SetBackUp2(DTYPE v) { backup2.SetValue(v); }
#endif
	void ReadInput(INPUT_SOURCE is, int i, CHomoGeneousComputingBank *phcg);
	DTYPE GetInput() { return input.GetValue(); }
	DTYPE GetShift() { return shift.GetValue(); }
	DTYPE GetBackup() { return backup.GetValue(); }
	DTYPE GetMQ() { return pucl->GetMQ(); }
	DTYPE GetAQ() { return pucl->GetAQ(); }
	DTYPE GetSQ() { return pucl->GetSQ(); }
	DTYPE GetPSUMQ() { return pucl->GetPSUMQ(); }
	DTYPE GetOutPut() { return out; }
	DTYPE GetPreOutPut(int outputRows);

};

class CShiftComputingGroup :public CSimNode {
	std::vector<CUnifiedComputingUnit *> UCUs;
	int id;
	CHomoGeneousComputingBank *phcg;
	CMem<DTYPE, MAX_K, MAX_K> weights0;
	CMem<DTYPE, MAX_K, MAX_K> weights1;
	
	CFlop<unsigned, 0> conv_idx;
	CFlop<int, 0> weightId;
	CFlop<unsigned, scale_t> conv_scale;
	CFlop<unsigned, scale_t> bm_scale;
	CFlop<bool, 0> readWeights0;
	CFlop<DTYPE, 0> weight;
	CFlop<bool, 0> isOutput0;
	CFlop<bool, 0> isAct;

	UCL_M_MUX  mMux;
	UCL_A0_MUX a0Mux;
	UCL_A_MUX  aMux;
	//UCL_AQ_MUX aqMux;
	//UCL_SA_MUX saMux;
	UCL_SQ_MUX sqMux;
	UCL_L_MUX  lMux;
	UCL_OUT_MUX oMux;
	//UCL_C0_MUX c0Mux;
	//UCL_C1_MUX c1Mux;
	
	std::vector<CSimNode *> storages;
	FILE *fp;
	int debugLevel;
	FILE *fvi;
	FILE *fvo;

public:
	friend CUnifiedComputingUnit;
	friend CUnifiedComputingLogic;
	CShiftComputingGroup() :fp(NULL) {}
	~CShiftComputingGroup();
	int GetConvScale() { return conv_scale.GetValue(); }
	int GetBMScale() { return bm_scale.GetValue(); }
	void SetDebug(FILE *f);
	void SetName(std::string s);
	void Init();
	void Init(int num);
	void setId(int i) { id = i; }
	void setConvIndex(int i) { conv_idx = id % i; }// conv_idx.SetValue(i);}
	CUnifiedComputingUnit *GetUCU(int i) { return UCUs[i]; }
	void progress(int num);
	void SetDebugLevel(int l) { 
		debugLevel = l; 
		for (int i = 0; i < COMPUTING_GROUP_SIZE; i++)
			UCUs[i]->SetDebugLevel(l);
	}
	void latch(int num);
	void DumpVerificationFile(int num);
	void FinishDumpVerificationFile(int num);
	void processConv();
	void processWeights();
	void SetHCG(CHomoGeneousComputingBank *p) { phcg = p; }
	void reset() {}
	void ReadBackUp();
	void ReadInput();
	void ReadWeight();
	void ReadBMWeight();
	DTYPE GetWeight();
	void GetOutput(DTYPE *bus, int w, int outputRows);
};
};
