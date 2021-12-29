#pragma once



#include <queue>
#include <map>
#include <vector>
#include <string>
#include "assert.h"
#include "sim.h"
#include "interface.h"

using namespace CloudDesign;
struct DumpInfo{
	std::string name;
	int reqSeq;
	bool isA;
	bool isB;
	int start;
	int len;
	DumpInfo *next;
};
class CModel{
	CAddrBuffer *paddrBuf;
	CBRAM *prama;
	CBRAM *pramb;
	CBRAM *pramw;
	CGlobalInstructionBuffer *pgib;
	CTokenGen *ptkn;
	CTokenGen *ptknw;
	CReadController *pcread;
	CWeightController *pcweight;
	CWriteController *pcwrite;
	CAllocAssist<MAX_LOAD_WIDTH * sizeof(DTYPE)> *palloc;

	CHomoGeneousComputingBank banks[BANK_NUM];

	std::vector<CSimNode *> operations;
	
public:
	CModel(){}
	~CModel();
	void BuildModel(int numBanks = 1, int numCGs = 3);
	void Setup();
	void Reset();
	void Run(GlobalInstruction *p, bool isDebug = false, DumpInfo * head = NULL, int debugLevel = 1);
	GlobalInstruction * ExpandInstructions(GlobalInstruction *p);
	void GetWLenKs(unsigned &wlenk1, unsigned &wlenk2, unsigned wtotal, unsigned k);
	void processInstExt(InstructionHCB &inst);
	int getTotalFrames(int kh, int ks, int kt, int ng);
	void PrintGInsts(GlobalInstruction *pp, char *filename);
	void Dump(DumpInfo *pdi, int i);
	void SetDebug(char *file);
	void CloseDebug();
};

class CModelIF{
	CAddrBuffer *paddrBuf;
	CBRAM *prama;
	CBRAM *pramb;
	CBRAM *pramw;
	CDDR<PS_DDR_DATAWIDTH> *pddrw;
	CDDR<DDR_DATAWIDTH> *pddrd;
	CDDRReadAssist<PS_DDR_DATAWIDTH> *pddrw_read;
	CDDRReadAssist<DDR_DATAWIDTH> *pddrd_read;
	CDDRWriteAssist *pddr_write;
	CInterface *pif;
	CGlobalInstructionBuffer *pgib;
	CTokenGen *ptkn;
	CTokenGen *ptknw;
	CReadController *pcread;
	CWeightController *pcweight;
	CWriteController *pcwrite;
	CAllocAssist<MAX_LOAD_WIDTH * sizeof(DTYPE)> *palloc;

	CHomoGeneousComputingBank banks[BANK_NUM];

	std::vector<CSimNode *> operations;

	FILE *ffi, *fwi, *fii;
	FILE *ffro, *ffwo, *fwro, *fio;
	unsigned inst_addr;

public:
	CModelIF(){}
	~CModelIF();
	void BuildModel(int numBanks = 1, int numCGs = 3);
	void Setup();
	void Reset();
	std::string GetMode(DATA_MODE mode);
	void dump_axi(int i);
	unsigned char * EncodeInstructions(GlobalInstruction *p, int &len);
	void ReRun(int iter, std::map<unsigned, void *> &out_mp, int osize
		, unsigned char *data, int dsize, bool isDebug, int debugLevel);
	void Run(GlobalInstruction *p, std::map<unsigned, void *> &out_mp, int osize, unsigned char * wt, int wsize, unsigned char *data, int dsize
		, bool isDebug = false, DumpInfo * head = NULL, int debugLevel = 1, unsigned baseWAddr = 0);
	GlobalInstruction * ExpandInstructions(GlobalInstruction *p);
	void GetWLenKs(unsigned &wlenk1, unsigned &wlenk2, unsigned wtotal, unsigned k);
	void processInstExt(InstructionHCB &inst);
	int getTotalFrames(int kh, int ks, int kt, int ng);
	void PrintGInsts(GlobalInstruction *pp, char *filename);
	void Dump(DumpInfo *pdi, int i);
	void SetDebug(char *file);
	void CloseDebug();
};

extern DTYPE GetRand();// {  return DTYPE(rand() % 200 - 100); }

extern void testConv();
extern void GetBatchNum(int HEIGHT, int & b15, int &b12, int &b0);
extern void transformWeightsBatch(DTYPE *dst, int *start, int *Kh, int *Ks, int *Kt, int *Kbh, int *Kbe, DTYPE *src, int M, int C, int K, int bankNum, int bankSize);
extern void transformWeights(DTYPE *dst, int *start, int *Kh, int *Ks, int *Kt, DTYPE *src, DTYPE *ext, int ext_len, int M, int C, int K, int bankNum, int *bankSize);
extern void transformWeights(DTYPE *dst, int *start, DTYPE *src, DTYPE *ext, int ext_len, int M, int C, int K, int bankSize);
extern void transformWeights(DTYPE *dst, int *start, int *Kh, int *Ks, int *Kt, DTYPE *src, DTYPE *ext, int ext_len, int M, int C, int K, int bankSize1, int bankSize2);
extern void transformWeights(DTYPE *dst, int *start, int *Kh, int *Ks, int *Kt, DTYPE *src, DTYPE *ext, int ext_len, int M, int C, int K, int bankSize1, int bankSize2, int bankSize3);
extern void transformWeights(DTYPE *dst, int *start, int *Kh, int *Ks, int *Kt, DTYPE *src, DTYPE *ext, int ext_len, int M, int C, int K, int bankSize1, int bankSize2, int bankSize3, int bankSize4);

extern DTYPE* transformWeights2(DTYPE *src, CloudDesign::DATA_MODE mode, int *start, int *dropSize, int *wSize);

template<int C, int H, int W, int M, int K, int S, int upSize>
void GetConv(DTYPE expected[M][H * upSize / S][W * upSize / S], DTYPE features[C][H][W], DTYPE weights[M][C][K][K]
	, DTYPE bms[M][BM_NUM], DTYPE res[M][H / S][W / S]
	, DTYPE wrelu, bool doBM, bool doRelu, bool doLRelu, bool doRes, int poolS = 1, int poolSz = 1)
{
	for (int k = 0; k < M; k++)
		for (int i = 0; i < H / S; i++)
			for (int j = 0; j < W / S; j++){
				DTYPE2 val = 0;
				for (int l = 0; l < C; l++){
					for (int m = 0; m < K; m++)
						for (int n = 0; n < K; n++){
							int x = i * S + m - K / 2;
							int y = j * S + n - K / 2;
							if (!(x < 0 || x >= H || y < 0 || y >= W)){
								val += features[l][x][y] * weights[k][l][m][n];
							}
						}

				}
				if (doBM)
					val = bms[k][0] * val + bms[k][1];
				if (doRelu)
					val = val > 0 ? val : 0;
				else if (doLRelu)
					val = val > 0 ? val : val * wrelu;
				if (doRes)
					val += res[k][i][j];
				if (upSize == 1)
					expected[k][i][j] = val;
				else{
					assert(upSize == 2);
					expected[k][2*i][2*j] = val;
					expected[k][2 * i][2 * j+1] = val;
					expected[k][2 * i+1][2 * j] = val;
					expected[k][2 * i + 1][2 * j + 1] = val;
				}
			}
	if (poolSz != 1)
	for (int k = 0; k < M; k++)
		for (int i = 0; i < H / S/ poolS; i++)
			for (int j = 0; j < W / S / poolS; j++){
				DTYPE val;
				for (int m = 0; m < poolSz; m++)
					for (int n = 0; n < poolSz; n++){
						int x = j * poolS + m;
						int y = i * poolS + n;
						if (x >= W /S || y >= H/S)
							continue;
						if (m == 0 && n == 0 || expected[k][y][x] > val)
							val = expected[k][y][x];
					}
				expected[k][i][j] = val;
			}
}


template < int C, int H, int W, int K, int M, int S, int UpSize, int poolStride>
class CDataSet{
public:
	DTYPE features[C][H][W]; //channel, height, width
	DTYPE weights[M][C][K][K];// M = 10, output channels, 3x3x10
	DTYPE bms[M][BM_NUM];
	DTYPE outputs[M][H * UpSize / S / poolStride][W * UpSize / S / poolStride];// suppose 0(2468).. = 495, 1.. = 1980 
	DTYPE res[M][H/S][W/S];
	DTYPE expected[M][H * UpSize / S][W * UpSize / S];
	int fSize, bmSize, rSize, oSize;


	unsigned char buf[(C*H*W + BM_NUM*M + M * H * W  / S / S) * sizeof(DTYPE)];
	void GenData(DTYPE wrelu, bool doBM, bool doRelu, bool doLRelu, bool doRes, int poolSz = 1){
		int i, j, k;
		for (i = 0; i < M; i++){
			bms[i][0] = GetRand();
			bms[i][1] = GetRand();
			bms[i][2] = 0;
		}
		for (i = 0; i < C; i++)
			for (j = 0; j < H; j++)
				for (k = 0; k < W; k++)
					features[i][j][k] = GetRand();
		for (i = 0; i < M; i++)
			for (int j = 0; j < C; j++)
				for (k = 0; k < K; k++)
					for (int l = 0; l < K; l++)
						weights[i][j][k][l] = GetRand();

		for (i = 0; i < M; i++)
			for (j = 0; j < H/S; j++)
				for (k = 0; k < W/S; k++)
					res[i][j][k] = GetRand();
		fSize = C*H*W * sizeof(DTYPE);
		bmSize = BM_NUM * M * sizeof(DTYPE);
		rSize = (M * H * W  / S / S) * sizeof(DTYPE);
		oSize = (M * H * W * UpSize * UpSize / S / poolStride / S / poolStride) * sizeof(DTYPE);
		GetConv<C, H, W, M, K, S, UpSize>(expected, features, weights, bms, res, wrelu, doBM, doRelu, doLRelu, doRes, poolStride, poolSz);

		memcpy(buf, features, fSize);
		memcpy(buf + fSize, bms, bmSize);
		memcpy(buf + fSize + bmSize, res, rSize);

	}
	void Dump(int M0, int Y, int X, DTYPE wrelu, bool doBM, bool doRelu, bool doLRelu, bool doRes){
		{
			//M0 = X = Y = 0;
			FILE *fp = fopen("data.txt", "wt");
			fprintf(fp, "weight :\n");
			for (int i = 0; i < M; i++){
				fprintf(fp, "\t%d :", i);
				for (int j = 0; j < C; j++){
					for (int k1 = 0; k1 < K; k1++){
						for (int k2 = 0; k2 < K; k2++)
							fprintf(fp, " "DFMT"", weights[i][j][k1][k2]);
						fprintf(fp, ",");
					}
				}
				fprintf(fp, "\n");
			}
			if (doBM){
				fprintf(fp, "BM :\n");
				for (int i = 0; i < M; i++)
					fprintf(fp, "\t%d : %d %d\n", i, bms[i][0], bms[i][1]);
				fprintf(fp, "\n");
			}

			fprintf(fp, "features :\n");
			for (int i = 0; i < C; i++){
				fprintf(fp, "\t%d :\n", i);
				for (int j = 0; j < H; j++){
					fprintf(fp, "\t\t");
					for (int k = 0; k < W; k++)
						fprintf(fp, " "DFMT"", features[i][j][k]);
					fprintf(fp, "\n");
				}
			}
			fprintf(fp, "Res :\n");
			for (int i = 0; i < M; i++){
				fprintf(fp, "\t%d :\n", i);
				for (int j = 0; j < H; j++){
					fprintf(fp, "\t\t");
					for (int k = 0; k < W; k++)
						fprintf(fp, " "DFMT"", res[i][j][k]);
					fprintf(fp, "\n");
				}
			}
			fclose(fp);

		}
	{
		Y *= S;
		X *= S;
		FILE *fp = fopen("data1.txt", "wt");
		DTYPE o = 0;
		for (int c = 0; c < C; c++){
			fprintf(fp, "c = %d :\n", c);
			DTYPE p = 0;
			for (int i = -K/2; i <= K/2; i++){
				for (int j = -K/2; j <= K/2; j++){
					int x = X + j;
					int y = Y + i;
					DTYPE val = 0;
					if (x >= 0 && x < W && y >= 0 && y < H)
						val = features[c][y][x];
					DTYPE w = weights[M0][c][i + K / 2][j + K / 2];
					fprintf(fp, " "DFMT"("DFMT")", val, w);
					p += val * w;
				}
				fprintf(fp, "\n");
			}

			o += p;
			fprintf(fp, " \n  "DFMT" "DFMT"\n", p, o);
		}
		if (doBM){
			o = bms[M0][0] * o + bms[M0][1];
			fprintf(fp, "bm ("DFMT", "DFMT") : "DFMT"\n", bms[M0][0], bms[M0][1], o);
		}
		if (doLRelu){
			o = o>0 ? o : o*wrelu;
			fprintf(fp, "Relu ("DFMT") : "DFMT"\n", wrelu, o);
		}
		if (doRes){
			o = o + res[M0][Y][X];
			fprintf(fp, "Res ("DFMT") : "DFMT"\n", res[M0][Y][X], o);
		}
		fclose(fp);
	}
	}
};

