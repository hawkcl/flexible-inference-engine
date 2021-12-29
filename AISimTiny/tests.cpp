#include "model.h"
#include <stdio.h>
#include <stdlib.h> 
using namespace CloudDesign;
bool Is_equal(DTYPE v1, DTYPE v2)
{
	if (IS_EQUAL(v1, 0))
		return IS_EQUAL(v2, 0);
	return IS_EQUAL2(v1, v2);
}

const int dH1 = COMPUTING_UNIT_OUTPUT_SIZE;
const int bsz = COMPUTING_GROUP_SIZE;

void testFeatures1()
{
	DTYPE features[10][10][10]; //channel, height, width
	DTYPE weights[10][10];// M = 10, output channels, 1x1x10
	DTYPE outputs[10][10][10];// suppose 0(2468).. = 55, 1.. = 220 
	int i, j, k;
	for (i = 0; i < 10; i++)
		for (j = 0; j < 10; j++)
			for (k = 0; k < 10; k++)
				features[i][j][k] = DTYPE(i + 1);
	for (i = 0; i < 10; i++)
		for (int j = 0; j < 10; j++){
			if (j %2 == 0)
				weights[i][j] = DTYPE(1); // output 55
			else
				weights[i][j] = DTYPE(10 - i); // output 220
		}
	int start[5];
	memset(start, 0, sizeof(start[0]) * 5);
	start[1] = 100;
	int dropSize;
	int wSize;
	DTYPE *weights3 = transformWeights2((DTYPE *)weights, MODE_FOUR, start, &dropSize, &wSize);
	GlobalInstruction insts[7];
	int idx = 0;
	
	insts[idx].type = CONV;
	insts[idx].i.inst.maxpool_stride = 1;
	insts[idx].i.inst.maxpool_size = 1;
	insts[idx].i.inst.W2 = 10;
	insts[idx].i.inst.mode = MODE_FOUR;
#ifdef BATCH1_OPTIMIZE
	insts[idx].i.inst.doBatch3 = 0;
#endif
	insts[idx].i.inst.reqSeqNum = 0;
	insts[idx].i.inst.reqSeqNumW = 1;
	insts[idx].i.inst.reqProgressW = 42;
	insts[idx].i.inst.seqNum = 2;
	insts[idx].i.inst.fScale = 0;
	insts[idx].i.inst.wScale = 0;
	insts[idx].i.inst.W = 10;
	insts[idx].i.inst.H = 10;
	insts[idx].i.inst.C = 10;
	insts[idx].i.inst.W1 = 10;
	insts[idx].i.inst.H1 = 10;
	insts[idx].i.inst.Maddr = (ADDR_TYPE)features;
	insts[idx].i.inst.Waddr = (ADDR_TYPE)weights3;
	insts[idx].i.inst.isUseWRam = 0;
	insts[idx].i.inst.wDropSize = dropSize;
	insts[idx].i.inst.WSize = wSize;
	insts[idx].i.inst.Oaddr = (ADDR_TYPE)outputs;
	insts[idx].i.inst.WEnd[0] = 100;
	insts[idx].i.inst.WEnd[1] = 0;
	insts[idx].i.inst.WEnd[2] = 0;
	insts[idx].i.inst.WEnd[3] = 0;
	insts[idx].i.inst.S = 1;
	insts[idx].i.inst.lPad = 0;
	insts[idx].i.inst.rPad = 0;
	insts[idx].i.inst.K = 1;
	insts[idx].i.inst.M = 10; // filter size, filter layers
	insts[idx].i.inst.Kh[0] = 0;
	insts[idx].i.inst.Ks[0] = 0;
	insts[idx].i.inst.Kt[0] = 9; // start, stride, and tail(inclusive)
	insts[idx].i.inst.Res_addr = 0;
	//insts[idx].i.inst.BM_addr = 0;
	insts[idx].i.inst.wLRelu = 0;
	insts[idx].i.inst.isMaddr_a = 0;
	insts[idx].i.inst.isMaddr_b = 0;
	insts[idx].i.inst.isOaddr_a = 0;
	insts[idx].i.inst.isOaddr_b = 0;
	insts[idx].i.inst.isRaddr_a = 0; //for Res
	insts[idx].i.inst.doRes = 0;
	insts[idx].i.inst.doRelu = 0;
	insts[idx].i.inst.doLRelu = 0;
	insts[idx].i.inst.doBM = 0;
	insts[idx].i.inst.doUpSample = 0;
	insts[idx].i.inst.isConv = 1;

	idx++;
	insts[idx].type = END;
	insts[idx].i.end.hasMore = 0;
	insts[idx].i.end.isRamA = 0;
	insts[idx].i.end.isRamB = 0;
	insts[idx].i.end.reqSeqNum = 2;

	CModel model;
	model.BuildModel(1, 1);
	model.Run(insts, true);
	for (k = 0; k < 10; k++)
	for (i = 0; i < 10; i++)
		for (j = 0; j < 10; j++){
			DTYPE val;
			if (k %2 == 0)
				val = 55;
			else
				val = 220;
			if (outputs[k][i][j] != val){
				printf("testFeatures1 error %d, %d, %d\n", k, i, j);
				delete[]weights3;
				return;
			}
		}
	printf("testFeatures1 pass\n");
	delete []weights3;
}

void testFeatures1bm()
{
	DTYPE features[10][10][10]; //channel, height, width
	DTYPE weights[10][10];// M = 10, output channels, 1x1x10
	DTYPE bms[10][2];
	DTYPE outputs[10][10][10];// suppose 0(2468).. = 55, 1.. = 220 
	int i, j, k;
	for (i = 0; i < 10; i++){
		bms[i][0] = DTYPE(-i - 1);
		bms[i][1] = DTYPE(i + 2);
	}
	for (i = 0; i < 10; i++)
		for (j = 0; j < 10; j++)
			for (k = 0; k < 10; k++)
				features[i][j][k] = DTYPE(i + 1);
	for (i = 0; i < 10; i++)
		for (int j = 0; j < 10; j++){
			if (j % 4 == 0)
				weights[i][j] = DTYPE(1); // output 55
			else if (j % 4 == 2)
				weights[i][j] = DTYPE(-1); // output -55
			else if (j % 4 == 1)
				weights[i][j] = DTYPE(10 - i); // output 220
			else
				weights[i][j] = DTYPE(i - 10); // output -220
		}

	int start[5];
	memset(start, 0, sizeof(start[0]) * 5);
	start[1] = 100;
	int dropSize;
	int wSize;
	DTYPE *weights3 = transformWeights2((DTYPE *)weights, MODE_FOUR, start, &dropSize, &wSize);
	GlobalInstruction insts[7];
	int idx = 0;
	insts[idx].type = CONV;
	insts[idx].i.inst.maxpool_stride = 1;
	insts[idx].i.inst.maxpool_size = 1;
	insts[idx].i.inst.W2 = 10;
	insts[idx].i.inst.mode = MODE_FOUR;
#ifdef BATCH1_OPTIMIZE
	insts[idx].i.inst.doBatch3 = 0;
#endif
	insts[idx].i.inst.reqSeqNum = 0;
	insts[idx].i.inst.reqSeqNumW = 1;
	insts[idx].i.inst.reqProgressW = 42;
	insts[idx].i.inst.seqNum = 2;
	insts[idx].i.inst.fScale = 0;
	insts[idx].i.inst.wScale = 0;
	insts[idx].i.inst.W = 10;
	insts[idx].i.inst.H = 10;
	insts[idx].i.inst.C = 10;
	insts[idx].i.inst.W1 = 10;
	insts[idx].i.inst.H1 = 10;
	insts[idx].i.inst.Maddr = (ADDR_TYPE)features;
	insts[idx].i.inst.Waddr = (ADDR_TYPE)weights3;
	insts[idx].i.inst.isUseWRam = 0;
	insts[idx].i.inst.wDropSize = dropSize;
	insts[idx].i.inst.WSize = wSize;
	insts[idx].i.inst.Oaddr = (ADDR_TYPE)outputs;
	insts[idx].i.inst.WEnd[0] = 100;
	insts[idx].i.inst.WEnd[1] = 0;
	insts[idx].i.inst.WEnd[2] = 0;
	insts[idx].i.inst.WEnd[3] = 0;
	insts[idx].i.inst.S = 1;
	insts[idx].i.inst.lPad = 0;
	insts[idx].i.inst.rPad = 0;
	insts[idx].i.inst.K = 1;
	insts[idx].i.inst.M = 10; // filter size, filter layers
	insts[idx].i.inst.Kh[0] = 0;
	insts[idx].i.inst.Ks[0] = 0;
	insts[idx].i.inst.Kt[0] = 9; // start, stride, and tail(inclusive)
	insts[idx].i.inst.Res_addr = 0;
	//insts[idx].i.inst.BM_addr = (ADDR_TYPE)bms;
	insts[idx].i.inst.wLRelu = 2;
	insts[idx].i.inst.isMaddr_a = 0;
	insts[idx].i.inst.isMaddr_b = 0;
	insts[idx].i.inst.isOaddr_a = 0;
	insts[idx].i.inst.isOaddr_b = 0;
	insts[idx].i.inst.isRaddr_a = 0; //for Res
	insts[idx].i.inst.doRes = 0;
	insts[idx].i.inst.doRelu = 0;
	insts[idx].i.inst.doLRelu = 1;
	insts[idx].i.inst.doBM = 1;
	insts[idx].i.inst.doUpSample = 0;
	insts[idx].i.inst.isConv = 1;

	idx++;
	insts[idx].type = END;
	insts[idx].i.end.hasMore = 0;
	insts[idx].i.end.isRamA = 0;
	insts[idx].i.end.isRamB = 0;
	insts[idx].i.end.reqSeqNum = 2;

	CModel model;
	model.BuildModel(1, 1);
	model.Run(insts, true);
	for (k = 0; k < 10; k++)
		for (i = 0; i < 10; i++)
			for (j = 0; j < 10; j++){
				DTYPE val;
				if (k % 4 == 0)
					val = 55;
				else if (k % 4 == 1)
					val = 220;
				else if (k % 4 == 2)
					val = -55;
				else if (k % 4 == 3)
					val = -220;
				val = k + 2 - val *(k + 1);
				val = val < 0 ? 2 * val : val;
				//val += 10 * k;
				assert(val == outputs[k][i][j]);
				if (outputs[k][i][j] != val){
					printf("testFeatures1bm error %d, %d, %d\n", k, i, j);
					return;
				}
			}
	delete[]weights3;
	printf("testFeatures1bm pass\n");
}


void testFeatures1bm_rand()
{
	bool doBM = false;
	bool doRelu = false;
	bool doLRelu = false;
	bool doRes = false;
	const int CHANNEL = 10;
	const int OUTSIZE = 10;
	const int WIDTH = 10;
	const int HEIGHT = 10;
	const int KERNEL = 1;
	DTYPE wrelu = 2;
	DTYPE weights2[KERNEL * KERNEL * CHANNEL * OUTSIZE];
	CDataSet<CHANNEL, HEIGHT, WIDTH, KERNEL, OUTSIZE, 1, 1, 1> *ds = new CDataSet<CHANNEL, HEIGHT, WIDTH, KERNEL, OUTSIZE, 1, 1, 1>();
	ds->GenData(wrelu, doBM, doRelu, doLRelu, doRes);
	int start[5];
	memset(start, 0, sizeof(start[0]) * 5);
	transformWeights((DTYPE *)weights2, start, (DTYPE *)ds->weights, (DTYPE *)ds->bms, doBM ? BM_NUM : 0, OUTSIZE, CHANNEL, KERNEL, 10);
	{
		FILE *fp = fopen("data.txt", "wt");
		fprintf(fp, "weight :\n");
		for (int i = 0; i < OUTSIZE; i++){
			fprintf(fp, "\t%d :", i);
			for (int j = 0; j < CHANNEL; j++)
				fprintf(fp, " "DFMT, ds->weights[i][j][0][0]);
			fprintf(fp, "\n");
		}

		fprintf(fp, "features :\n");
		for (int i = 0; i < CHANNEL; i++){
			fprintf(fp, "\t%d :\n", i);
			for (int j = 0; j < 10; j++){
				fprintf(fp, "\t\t");
				for (int k = 0; k < 10; k++)
					fprintf(fp, " "DFMT, ds->features[i][j][k]);
				fprintf(fp, "\n");
			}
		}
		fclose(fp);

	}
	start[1] = KERNEL * KERNEL * CHANNEL * OUTSIZE;
	int dropSize;
	int wSize;
	DTYPE *weights3 = transformWeights2((DTYPE *)weights2, MODE_FOUR, start, &dropSize, &wSize);

	GlobalInstruction insts[7];
	int idx = 0;
	insts[idx].type = CONV;
	insts[idx].i.inst.maxpool_stride = 1;
	insts[idx].i.inst.maxpool_size = 1;
	insts[idx].i.inst.W2 = 10;
	insts[idx].i.inst.mode = MODE_FOUR;
#ifdef BATCH1_OPTIMIZE
	insts[idx].i.inst.doBatch3 = 0;
#endif
	insts[idx].i.inst.reqSeqNum = 0;
	insts[idx].i.inst.reqSeqNumW = 1;
	insts[idx].i.inst.reqProgressW = 42;
	insts[idx].i.inst.seqNum = 2;
	insts[idx].i.inst.fScale = 0;
	insts[idx].i.inst.wScale = 0;
	insts[idx].i.inst.W = WIDTH;
	insts[idx].i.inst.H = HEIGHT;
	insts[idx].i.inst.C = CHANNEL;
	insts[idx].i.inst.Maddr = (ADDR_TYPE)ds->features;
	insts[idx].i.inst.Waddr = (ADDR_TYPE)weights3;
	insts[idx].i.inst.isUseWRam = 0;
	insts[idx].i.inst.wDropSize = dropSize;
	insts[idx].i.inst.WSize = wSize;
	insts[idx].i.inst.Oaddr = (ADDR_TYPE)ds->outputs;
	insts[idx].i.inst.WEnd[0] = 100;
	insts[idx].i.inst.WEnd[1] = 0;
	insts[idx].i.inst.WEnd[2] = 0;
	insts[idx].i.inst.WEnd[3] = 0;
	insts[idx].i.inst.W1 = 10;
	insts[idx].i.inst.H1 = 10;
	insts[idx].i.inst.S = 1;
	insts[idx].i.inst.lPad = 0;
	insts[idx].i.inst.rPad = 0;
	insts[idx].i.inst.K = 1;
	insts[idx].i.inst.M = OUTSIZE; // filter size, filter layers
	insts[idx].i.inst.Kh[0] = 0;
	insts[idx].i.inst.Ks[0] = 0;
	insts[idx].i.inst.Kt[0] = 9; // start, stride, and tail(inclusive)
	insts[idx].i.inst.Res_addr = 0;
	//insts[idx].i.inst.BM_addr = (ADDR_TYPE)ds->bms;
	insts[idx].i.inst.wLRelu = 2;
	insts[idx].i.inst.isMaddr_a = 0;
	insts[idx].i.inst.isMaddr_b = 0;
	insts[idx].i.inst.isOaddr_a = 0;
	insts[idx].i.inst.isOaddr_b = 0;
	insts[idx].i.inst.isRaddr_a = 0; //for Res
	insts[idx].i.inst.doRes = doRes ? 1 : 0;
	insts[idx].i.inst.doRelu = doRelu ? 1 : 0;
	insts[idx].i.inst.doLRelu = doLRelu ? 1 : 0;
	insts[idx].i.inst.doBM = doBM ? 1 : 0;
	insts[idx].i.inst.doUpSample = 0;
	insts[idx].i.inst.isConv = 1;

	idx++;
	insts[idx].type = END;
	insts[idx].i.end.hasMore = 0;
	insts[idx].i.end.isRamA = 0;
	insts[idx].i.end.isRamB = 0;
	insts[idx].i.end.reqSeqNum = 2;

	CModel model;
	model.BuildModel(1, 1);
	model.Run(insts, true);
	for (int k = 0; k < OUTSIZE; k++)
		for (int i = 0; i < HEIGHT; i++)
			for (int j = 0; j < WIDTH; j++){
				if (ds->outputs[k][i][j] != ds->expected[k][i][j]) {
					printf("testFeatures1bm_rand error %d, %d, %d\n", k, i, j);
					return;
				}
			}
	printf("testFeatures1bm_rand pass\n");
	delete[]weights3;
}

void testFeatures1relu()
{
	DTYPE features[10][10][10]; //channel, height, width
	DTYPE weights[10][10];// M = 10, output channels, 1x1x10
	DTYPE outputs[10][10][10];// suppose 0(2468).. = 55, 1.. = 220 
	int i, j, k;
	for (i = 0; i < 10; i++)
		for (j = 0; j < 10; j++)
			for (k = 0; k < 10; k++)
				features[i][j][k] = DTYPE(i + 1);
	for (i = 0; i < 10; i++)
		for (int j = 0; j < 10; j++){
			if (j % 4 == 0)
				weights[i][j] = DTYPE(1); // output 55
			else if (j % 4 == 2)
				weights[i][j] = DTYPE(-1); // output -55
			else if (j % 4 == 1)
				weights[i][j] = DTYPE(10 - i); // output 220
			else
				weights[i][j] = DTYPE(i - 10); // output -220
		}
	int start[5];
	memset(start, 0, sizeof(start[0]) * 5);
	start[1] = 100;
	int dropSize;
	int wSize;
	DTYPE *weights3 = transformWeights2((DTYPE *)weights, MODE_FOUR, start, &dropSize, &wSize);

	GlobalInstruction insts[7];
	int idx = 0;
	insts[idx].type = CONV;
	insts[idx].i.inst.maxpool_stride = 1;
	insts[idx].i.inst.maxpool_size = 1;
	insts[idx].i.inst.W2 = 10;
	insts[idx].i.inst.mode = MODE_FOUR;
#ifdef BATCH1_OPTIMIZE
	insts[idx].i.inst.doBatch3 = 0;
#endif
	insts[idx].i.inst.reqSeqNum = 0;
	insts[idx].i.inst.reqSeqNumW = 1;
	insts[idx].i.inst.reqProgressW = 42;
	insts[idx].i.inst.seqNum = 2;
	insts[idx].i.inst.fScale = 0;
	insts[idx].i.inst.wScale = 0;
	insts[idx].i.inst.W = 10;
	insts[idx].i.inst.H = 10;
	insts[idx].i.inst.C = 10;
	insts[idx].i.inst.W1 = 10;
	insts[idx].i.inst.H1 = 10;
	insts[idx].i.inst.Maddr = (ADDR_TYPE)features;
	insts[idx].i.inst.Waddr = (ADDR_TYPE)weights3;
	insts[idx].i.inst.isUseWRam = 0;
	insts[idx].i.inst.wDropSize = dropSize;
	insts[idx].i.inst.WSize = wSize;
	insts[idx].i.inst.Oaddr = (ADDR_TYPE)outputs;
	insts[idx].i.inst.WEnd[0] = 100;
	insts[idx].i.inst.WEnd[1] = 0;
	insts[idx].i.inst.WEnd[2] = 0;
	insts[idx].i.inst.WEnd[3] = 0;
	insts[idx].i.inst.S = 1;
	insts[idx].i.inst.lPad = 0;
	insts[idx].i.inst.rPad = 0;
	insts[idx].i.inst.K = 1;
	insts[idx].i.inst.M = 10; // filter size, filter layers
	insts[idx].i.inst.Kh[0] = 0;
	insts[idx].i.inst.Ks[0] = 0;
	insts[idx].i.inst.Kt[0] = 9; // start, stride, and tail(inclusive)
	insts[idx].i.inst.Res_addr = 0;
	//insts[idx].i.inst.BM_addr = 0;
	insts[idx].i.inst.wLRelu = 2;
	insts[idx].i.inst.isMaddr_a = 0;
	insts[idx].i.inst.isMaddr_b = 0;
	insts[idx].i.inst.isOaddr_a = 0;
	insts[idx].i.inst.isOaddr_b = 0;
	insts[idx].i.inst.isRaddr_a = 0; //for Res
	insts[idx].i.inst.doRes = 0;
	insts[idx].i.inst.doRelu = 0;
	insts[idx].i.inst.doLRelu = 1;
	insts[idx].i.inst.doBM = 0;
	insts[idx].i.inst.doUpSample = 0;
	insts[idx].i.inst.isConv = 1;

	idx++;
	insts[idx].type = END;
	insts[idx].i.end.hasMore = 0;
	insts[idx].i.end.isRamA = 0;
	insts[idx].i.end.isRamB = 0;
	insts[idx].i.end.reqSeqNum = 2;

	CModel model;
	model.BuildModel(1, 1);
	model.Run(insts);
	for (k = 0; k < 10; k++)
		for (i = 0; i < 10; i++)
			for (j = 0; j < 10; j++){
				DTYPE val;
				if (k % 4 == 0)
					val = 55;
				else if (k % 4 == 1)
					val = 220;
				else if (k % 4 == 2)
					val = -110;
				else if (k % 4 == 3)
					val = -440;
				if (outputs[k][i][j] != val){
					printf("testFeatures1relu error %d, %d, %d\n", k, i, j);
					return;
				}
			}
	printf("testFeatures1relu pass\n");
	delete[]weights3;
}

void testFeatures1bmres()
{
	DTYPE features[10][10][10]; //channel, height, width
	DTYPE weights[10][10];// M = 10, output channels, 1x1x10
	DTYPE bms[10][2];
	DTYPE outputs[10][10][10];// suppose 0(2468).. = 55, 1.. = 220 
	DTYPE res[10][10][10];
	int i, j, k;
	for (i = 0; i < 10; i++){
		bms[i][0] = DTYPE(-i - 1);
		bms[i][1] = DTYPE(i + 2);
	}
	for (i = 0; i < 10; i++)
		for (j = 0; j < 10; j++)
			for (k = 0; k < 10; k++)
				features[i][j][k] = DTYPE(i + 1);
	for (i = 0; i < 10; i++)
		for (int j = 0; j < 10; j++){
			if (j % 4 == 0)
				weights[i][j] = DTYPE(1); // output 55
			else if (j % 4 == 2)
				weights[i][j] = DTYPE(-1); // output -55
			else if (j % 4 == 1)
				weights[i][j] = DTYPE(10 - i); // output 220
			else
				weights[i][j] = DTYPE(i - 10); // output -220
		}
	for (i = 0; i < 10; i++)
		for (j = 0; j < 10; j++)
			for (k = 0; k < 10; k++)
				res[i][j][k] = DTYPE(10 * i);

	int start[5];
	memset(start, 0, sizeof(start[0]) * 5);
	start[1] = 100;
	int dropSize;
	int wSize;
	DTYPE *weights3 = transformWeights2((DTYPE *)weights, MODE_FOUR, start, &dropSize, &wSize);


	GlobalInstruction insts[8];
	int idx = 0;
	
	insts[idx].type = MEM;
	insts[idx].i.mem.isRamA = 0;
	insts[idx].i.mem.isRead = 1;
	insts[idx].i.mem.len = 1000;
	insts[idx].i.mem.isFast = 1;
	insts[idx].i.mem.Oaddr = (ADDR_TYPE)res;
	insts[idx].i.mem.Maddr = 0;
	insts[idx].i.mem.reqSeqNum = 0;
	insts[idx].i.mem.seqNum = 1;
	idx++;
	insts[idx].type = CONV;
	insts[idx].i.inst.maxpool_stride = 1;
	insts[idx].i.inst.maxpool_size = 1;
	insts[idx].i.inst.W2 = 10;
	insts[idx].i.inst.mode = MODE_FOUR;
#ifdef BATCH1_OPTIMIZE
	insts[idx].i.inst.doBatch3 = 0;
#endif
	insts[idx].i.inst.reqSeqNum = 0;
	insts[idx].i.inst.reqSeqNumW = 1;
	insts[idx].i.inst.reqProgressW = 42;
	insts[idx].i.inst.seqNum = 2;
	insts[idx].i.inst.fScale = 0;
	insts[idx].i.inst.wScale = 0;
	insts[idx].i.inst.W = 10;
	insts[idx].i.inst.H = 10;
	insts[idx].i.inst.C = 10;
	insts[idx].i.inst.W1 = 10;
	insts[idx].i.inst.H1 = 10;
	insts[idx].i.inst.Maddr = (ADDR_TYPE)features;
	insts[idx].i.inst.Waddr = (ADDR_TYPE)weights3;
	insts[idx].i.inst.isUseWRam = 0;
	insts[idx].i.inst.wDropSize = dropSize;
	insts[idx].i.inst.WSize = wSize;
	insts[idx].i.inst.Oaddr = (ADDR_TYPE)outputs;
	insts[idx].i.inst.WEnd[0] = 100;
	insts[idx].i.inst.WEnd[1] = 0;
	insts[idx].i.inst.WEnd[2] = 0;
	insts[idx].i.inst.WEnd[3] = 0;
	insts[idx].i.inst.S = 1;
	insts[idx].i.inst.lPad = 0;
	insts[idx].i.inst.rPad = 0;
	insts[idx].i.inst.K = 1;
	insts[idx].i.inst.M = 10; // filter size, filter layers
	insts[idx].i.inst.Kh[0] = 0;
	insts[idx].i.inst.Ks[0] = 0;
	insts[idx].i.inst.Kt[0] = 9; // start, stride, and tail(inclusive)
	insts[idx].i.inst.Res_addr = 0;
	//insts[idx].i.inst.BM_addr = (ADDR_TYPE)bms;
	insts[idx].i.inst.wLRelu = 2;
	insts[idx].i.inst.isMaddr_a = 0;
	insts[idx].i.inst.isMaddr_b = 0;
	insts[idx].i.inst.isOaddr_a = 0;
	insts[idx].i.inst.isOaddr_b = 0;
	insts[idx].i.inst.isRaddr_a = 0; //for Res
	insts[idx].i.inst.doRes = 1;
	insts[idx].i.inst.doRelu = 0;
	insts[idx].i.inst.doLRelu = 1;
	insts[idx].i.inst.doBM = 1;
	insts[idx].i.inst.doUpSample = 0;
	insts[idx].i.inst.isConv = 1;

	idx++;
	insts[idx].type = END;
	insts[idx].i.end.hasMore = 0;
	insts[idx].i.end.isRamA = 0;
	insts[idx].i.end.isRamB = 0;
	insts[idx].i.end.reqSeqNum = 2;

	CModel model;
	model.BuildModel(1, 1);
	model.Run(insts, true);
	for (k = 0; k < 10; k++)
		for (i = 0; i < 10; i++)
			for (j = 0; j < 10; j++){
				DTYPE val;
				if (k % 4 == 0)
					val = 55;
				else if (k % 4 == 1)
					val = 220;
				else if (k % 4 == 2)
					val = -55;
				else if (k % 4 == 3)
					val = -220;
				val = k + 2 - val *(k + 1);
				val = val < 0 ? 2 * val : val;
				val += 10 * k;
				assert(val == outputs[k][i][j]);
				if (outputs[k][i][j] != val){
					printf("testFeatures1bmres error %d, %d, %d\n", k, i, j);
					return;
				}
			}
	printf("testFeatures1bmres pass\n");
	delete[]weights3;
}

void testFeaturesk3s1b1p1()
{
	DTYPE features[10][10][10]; //channel, height, width
	DTYPE weights[10][10][3][3];// M = 10, output channels, 3x3x10
	DTYPE weights2[900];
	DTYPE outputs[10][10][10];// suppose 0(2468).. = 495, 1.. = 1980 
	int i, j, k;
	for (i = 0; i < 10; i++)
		for (j = 0; j < 10; j++)
			for (k = 0; k < 10; k++)
				features[i][j][k] = DTYPE(i + 1);
	for (i = 0; i < 10; i++)
		for (int j = 0; j < 10; j++)
			for (k = 0; k < 3; k++)
				for (int l = 0; l < 3; l++){
					if (i % 2 == 0)
						weights[i][j][k][l] = DTYPE(1); // output 55
					else
						weights[i][j][k][l] = DTYPE(10 - j); // output 220
				}
	int start[5];
	memset(start, 0, sizeof(start[0]) * 5);

	transformWeights((DTYPE *)weights2, start, (DTYPE *)weights, (DTYPE *)NULL,  0, 10, 10, 3, 30);
	start[1] = 900;
	int dropSize;
	int wSize;
	DTYPE *weights3 = transformWeights2((DTYPE *)weights2, MODE_FOUR, start, &dropSize, &wSize);


	
	GlobalInstruction insts[7];
	int idx = 0;
	
	insts[idx].type = CONV;
	insts[idx].i.inst.maxpool_stride = 1;
	insts[idx].i.inst.maxpool_size = 1;
	insts[idx].i.inst.W2 = 10;
	insts[idx].i.inst.mode = MODE_FOUR;
#ifdef BATCH1_OPTIMIZE
	insts[idx].i.inst.doBatch3 = 0;
#endif
	insts[idx].i.inst.reqSeqNum = 0;
	insts[idx].i.inst.reqSeqNumW = 1;
	insts[idx].i.inst.reqProgressW = 42;
	insts[idx].i.inst.seqNum = 2;
	insts[idx].i.inst.fScale = 0;
	insts[idx].i.inst.wScale = 0;
	insts[idx].i.inst.W = 10;
	insts[idx].i.inst.H = 10;
	insts[idx].i.inst.C = 10;
	insts[idx].i.inst.W1 = 10;
	insts[idx].i.inst.H1 = 10;
	insts[idx].i.inst.Maddr = (ADDR_TYPE)features;
	insts[idx].i.inst.Waddr = (ADDR_TYPE)weights3;
	insts[idx].i.inst.isUseWRam = 0;
	insts[idx].i.inst.wDropSize = dropSize;
	insts[idx].i.inst.WSize = wSize;
	insts[idx].i.inst.Oaddr = (ADDR_TYPE)outputs;
	insts[idx].i.inst.WEnd[0] = 900;
	insts[idx].i.inst.WEnd[1] = 0;
	insts[idx].i.inst.WEnd[2] = 0;
	insts[idx].i.inst.WEnd[3] = 0;
	insts[idx].i.inst.S = 1;
	insts[idx].i.inst.lPad = 1;
	insts[idx].i.inst.rPad = 1;
	insts[idx].i.inst.K = 3;
	insts[idx].i.inst.M = 10; // filter size, filter layers
	insts[idx].i.inst.Kh[0] = 0;
	insts[idx].i.inst.Ks[0] = 0;
	insts[idx].i.inst.Kt[0] = 9; // start, stride, and tail(inclusive)
	insts[idx].i.inst.Res_addr = 0;
	//insts[idx].i.inst.BM_addr = 0;
	insts[idx].i.inst.wLRelu = 0;
	insts[idx].i.inst.isMaddr_a = 0;
	insts[idx].i.inst.isMaddr_b = 0;
	insts[idx].i.inst.isOaddr_a = 0;
	insts[idx].i.inst.isOaddr_b = 0;
	insts[idx].i.inst.isRaddr_a = 0; //for Res
	insts[idx].i.inst.doRes = 0;
	insts[idx].i.inst.doRelu = 0;
	insts[idx].i.inst.doLRelu = 0;
	insts[idx].i.inst.doBM = 0;
	insts[idx].i.inst.doUpSample = 0;
	insts[idx].i.inst.isConv = 1;

	
	idx++;
	insts[idx].type = END;
	insts[idx].i.end.hasMore = 0;
	insts[idx].i.end.isRamA = 0;
	insts[idx].i.end.isRamB = 0;
	insts[idx].i.end.reqSeqNum = 2;

	CModel model;
	model.BuildModel(1, 6);
	model.Run(insts, true);
	for (k = 0; k < 10; k++)
		for (i = 0; i < 10; i++)
			for (j = 0; j < 10; j++){
				DTYPE val;
				if (k % 2 == 0){
					if (i == 0 || i == 9){
						if (j == 0 || j == 9)
							val = 220;
						else
							val = 330;
					}
					else{
						if (j == 0 || j == 9)
							val = 330;
						else
							val = 495;
					}
				}
				//* 220 330 220
				//330 495 330
				//220 330 220*
				else{
					if (i == 0 || i == 9){
						if (j == 0 || j == 9)
							val = 880;
						else
							val = 1320;
					}
					else{
						if (j == 0 || j == 9)
							val = 1320;
						else
							val = 1980;
					}
				}
				//*880  1320 880
				//1320 1980 1320
				//880  1320 880
				if (outputs[k][i][j] != val){
					printf("testFeaturesk3s1b1p1 error %d, %d, %d\n", k, i, j);
					return;
				}
			}
	printf("testFeaturesk3s1b1p1 pass\n");
	delete[]weights3;
}

void testFeaturesk3s1b1()
{
	DTYPE features[10][11][11]; //channel, height, width
	DTYPE weights[16][10][3][3];// M = 10, output channels, 3x3x10
	DTYPE weights2[1440];
	DTYPE outputs[16][9][9];// suppose 0(2468).. = 495, 1.. = 1980 
	int i, j, k;
	for (i = 0; i < 10; i++)
		for (j = 0; j < 11; j++)
			for (k = 0; k < 11; k++)
				features[i][j][k] = DTYPE(i + 1);
	for (i = 0; i < 16; i++)
		for (int j = 0; j < 10; j++)
			for (k = 0; k < 3; k++)
				for (int l = 0; l < 3; l++){
					if (i % 2 == 0)
						weights[i][j][k][l] = DTYPE(1); // output 55
					else
						weights[i][j][k][l] = DTYPE(10 - j); // output 220
				}
	int start[5];
	memset(start, 0, sizeof(start[0]) * 5);
	transformWeights((DTYPE *)weights2,start, (DTYPE *)weights, (DTYPE *)0, 0, 16, 10, 3, CG_NUM);
	start[1] = 1440;
	int dropSize;
	int wSize;
	DTYPE *weights3 = transformWeights2((DTYPE *)weights2, MODE_FOUR, start, &dropSize, &wSize);

	GlobalInstruction insts[7];
	int idx = 0;
	insts[idx].type = CONV;
	insts[idx].i.inst.maxpool_stride = 1;
	insts[idx].i.inst.maxpool_size = 1;
	insts[idx].i.inst.W2 = 11;
	insts[idx].i.inst.mode = MODE_FOUR;
#ifdef BATCH1_OPTIMIZE
	insts[idx].i.inst.doBatch3 = 0;
#endif
	insts[idx].i.inst.reqSeqNum = 0;
	insts[idx].i.inst.reqSeqNumW = 1;
	insts[idx].i.inst.reqProgressW = 42;
	insts[idx].i.inst.seqNum = 2;
	insts[idx].i.inst.fScale = 0;
	insts[idx].i.inst.wScale = 0;
	insts[idx].i.inst.W = 11;
	insts[idx].i.inst.H = 11;
	insts[idx].i.inst.C = 10;
	insts[idx].i.inst.W1 = 11;
	insts[idx].i.inst.H1 = 11;
	insts[idx].i.inst.Maddr = (ADDR_TYPE)features;
	insts[idx].i.inst.Waddr = (ADDR_TYPE)weights3;
	insts[idx].i.inst.isUseWRam = 0;
	insts[idx].i.inst.wDropSize = dropSize;
	insts[idx].i.inst.WSize = wSize;
	insts[idx].i.inst.Oaddr = (ADDR_TYPE)outputs;
	insts[idx].i.inst.WEnd[0] = 1440;
	insts[idx].i.inst.WEnd[1] = 0;
	insts[idx].i.inst.WEnd[2] = 0;
	insts[idx].i.inst.WEnd[3] = 0;
	insts[idx].i.inst.S = 1;
	insts[idx].i.inst.lPad = 0;
	insts[idx].i.inst.rPad = 0;
	insts[idx].i.inst.K = 3;
	insts[idx].i.inst.M = 16; // filter size, filter layers
	insts[idx].i.inst.Kh[0] = 0;
	insts[idx].i.inst.Ks[0] = 0;
	insts[idx].i.inst.Kt[0] = 15; // start, stride, and tail(inclusive)
	insts[idx].i.inst.Res_addr = 0;
	//insts[idx].i.inst.BM_addr = 0;
	insts[idx].i.inst.wLRelu = 0;
	insts[idx].i.inst.isMaddr_a = 0;
	insts[idx].i.inst.isMaddr_b = 0;
	insts[idx].i.inst.isOaddr_a = 0;
	insts[idx].i.inst.isOaddr_b = 0;
	insts[idx].i.inst.isRaddr_a = 0; //for Res
	insts[idx].i.inst.doRes = 0;
	insts[idx].i.inst.doRelu = 0;
	insts[idx].i.inst.doLRelu = 0;
	insts[idx].i.inst.doBM = 0;
	insts[idx].i.inst.doUpSample = 0;
	insts[idx].i.inst.isConv = 1;

	idx++;
	insts[idx].type = END;
	insts[idx].i.end.hasMore = 0;
	insts[idx].i.end.isRamA = 0;
	insts[idx].i.end.isRamB = 0;
	insts[idx].i.end.reqSeqNum = 2;

	CModel model;
	model.BuildModel(1, 3);
	model.Run(insts, true);
	for (k = 0; k < 16; k++)
		for (i = 0; i < 9; i++)
			for (j = 0; j < 9; j++){
				DTYPE val;
				if (k % 2 == 0)
					val = 495;
				else
					val = 1980;
				if (outputs[k][i][j] != val){
					printf("testFeaturesk3s1b1 error %d, %d, %d\n", k, i, j);
					return;
				}
			}
	printf("testFeaturesk3s1b1 pass\n");
	delete[]weights3;
}

void testFeaturesk3s2()
{
	DTYPE features[10][9][9]; //channel, height, width
	DTYPE weights[16][10][3][3];// M = 10, output channels, 3x3x10
	DTYPE weights2[1440];
	DTYPE outputs[16][5][5];// suppose 0(2468).. = 495, 1.. = 1980 
	int i, j, k;
	for (i = 0; i < 10; i++)
		for (j = 0; j < 9; j++)
			for (k = 0; k < 9; k++)
				features[i][j][k] = DTYPE(i + 1);
	for (i = 0; i < 16; i++)
		for (int j = 0; j < 10; j++)
			for (k = 0; k < 3; k++)
				for (int l = 0; l < 3; l++){
					if (i % 2 == 0)
						weights[i][j][k][l] = DTYPE(1); // output 55
					else
						weights[i][j][k][l] = DTYPE(10 - j); // output 220
				}

	int start[5];
	memset(start, 0, sizeof(start[0]) * 5);
	transformWeights((DTYPE *)weights2, start, (DTYPE *)weights, (DTYPE *)0, 0, 16, 10, 3, CG_NUM);
	start[1] = 1440;
	int dropSize;
	int wSize;
	DTYPE *weights3 = transformWeights2((DTYPE *)weights2, MODE_FOUR, start, &dropSize, &wSize);

	GlobalInstruction insts[7];
	int idx = 0;
	insts[idx].type = CONV;
	insts[idx].i.inst.maxpool_stride = 1;
	insts[idx].i.inst.maxpool_size = 1;
	insts[idx].i.inst.W2 = 9;
	insts[idx].i.inst.mode = MODE_FOUR;
#ifdef BATCH1_OPTIMIZE
	insts[idx].i.inst.doBatch3 = 0;
#endif
	insts[idx].i.inst.reqSeqNum = 0;
	insts[idx].i.inst.reqSeqNumW = 1;
	insts[idx].i.inst.reqProgressW = 42;
	insts[idx].i.inst.seqNum = 2;
	insts[idx].i.inst.fScale = 0;
	insts[idx].i.inst.wScale = 0;
	insts[idx].i.inst.W = 9;
	insts[idx].i.inst.H = 9;
	insts[idx].i.inst.C = 10;
	insts[idx].i.inst.W1 = 9;
	insts[idx].i.inst.H1 = 9;
	insts[idx].i.inst.Maddr = (ADDR_TYPE)features;
	insts[idx].i.inst.Waddr = (ADDR_TYPE)weights3;
	insts[idx].i.inst.isUseWRam = 0;
	insts[idx].i.inst.wDropSize = dropSize;
	insts[idx].i.inst.WSize = wSize;
	insts[idx].i.inst.Oaddr = (ADDR_TYPE)outputs;
	insts[idx].i.inst.WEnd[0] = 1440;
	insts[idx].i.inst.WEnd[1] = 0;
	insts[idx].i.inst.WEnd[2] = 0;
	insts[idx].i.inst.WEnd[3] = 0;
	insts[idx].i.inst.S = 2;
	insts[idx].i.inst.lPad = 1;
	insts[idx].i.inst.rPad = 1;
	insts[idx].i.inst.K = 3;
	insts[idx].i.inst.M = 16; // filter size, filter layers
	insts[idx].i.inst.Kh[0] = 0;
	insts[idx].i.inst.Ks[0] = 0;
	insts[idx].i.inst.Kt[0] = 15; // start, stride, and tail(inclusive)
	insts[idx].i.inst.Res_addr = 0;
	//insts[idx].i.inst.BM_addr = 0;
	insts[idx].i.inst.wLRelu = 0;
	insts[idx].i.inst.isMaddr_a = 0;
	insts[idx].i.inst.isMaddr_b = 0;
	insts[idx].i.inst.isOaddr_a = 0;
	insts[idx].i.inst.isOaddr_b = 0;
	insts[idx].i.inst.isRaddr_a = 0; //for Res
	insts[idx].i.inst.doRes = 0;
	insts[idx].i.inst.doRelu = 0;
	insts[idx].i.inst.doLRelu = 0;
	insts[idx].i.inst.doBM = 0;
	insts[idx].i.inst.doUpSample = 0;
	insts[idx].i.inst.isConv = 1;

	idx++;
	insts[idx].type = END;
	insts[idx].i.end.hasMore = 0;
	insts[idx].i.end.isRamA = 0;
	insts[idx].i.end.isRamB = 0;
	insts[idx].i.end.reqSeqNum = 2;

	CModel model;
	model.BuildModel(1, 6);
	model.Run(insts, true);
	for (k = 0; k < 16; k++)
		for (i = 0; i < 5; i++)
			for (j = 0; j < 5; j++){
				DTYPE val;
				if (k % 2 == 0){
					if (i == 0 || i == 4){
						if (j == 0 || j == 4)
							val = 220;
						else
							val = 330;
					}
					else{
						if (j == 0 || j == 4)
							val = 330;
						else
							val = 495;
					}
				}
				// 220 330 220
				//330 495 330
				//220 330 220
				else{
					if (i == 0 || i == 4){
						if (j == 0 || j == 4)
							val = 880;
						else
							val = 1320;
					}
					else{
						if (j == 0 || j == 4)
							val = 1320;
						else
							val = 1980;
					}
				}
				//*880  1320 880
				//1320 1980 1320
				//880  1320 880
				if (outputs[k][i][j] != val){
					printf("testFeaturesk3s2 error %d, %d, %d\n", k, i, j);
					return;
				}
			}
	printf("testFeaturesk3s2 pass\n");
	delete[]weights3;
}


void testFeaturesk1b2()
{
	DTYPE features[10][10][10]; //channel, height, width
	DTYPE weights[12][10];// M = 10, output channels, 1x1x10
	DTYPE weights2[120];
	DTYPE outputs[12][10][10];// suppose 0(2468).. = 55, 1.. = 220 
	int i, j, k;
	for (i = 0; i < 10; i++)
		for (j = 0; j < 10; j++)
			for (k = 0; k < 10; k++)
				features[i][j][k] = DTYPE(i + 1);
	for (i = 0; i < 12; i++)
		for (int j = 0; j < 10; j++){
			if (i % 2 == 0)
				weights[i][j] = DTYPE(1); // output 55
			else
				weights[i][j] = DTYPE(10 - j); // output 220
		}
	int start[5], Kh[2], Ks[2], Kt[2];
	memset(start, 0, sizeof(start[0]) * 5);
	transformWeights((DTYPE *)weights2, start, Kh, Ks, Kt, (DTYPE *)weights, (DTYPE *)0, 0, 12, 10, 1, 6, 6);
	start[2] = 120;
	int dropSize;
	int wSize;
	DTYPE *weights3 = transformWeights2((DTYPE *)weights2, MODE_FOUR, start, &dropSize, &wSize);

	GlobalInstruction insts[8];
	int idx = 0;
	
	insts[idx].type = CONV;
	insts[idx].i.inst.maxpool_stride = 1;
	insts[idx].i.inst.maxpool_size = 1;
	insts[idx].i.inst.W2 = 10;

	insts[idx].i.inst.mode = MODE_FOUR;
#ifdef BATCH1_OPTIMIZE
	insts[idx].i.inst.doBatch3 = 0;
#endif
	insts[idx].i.inst.reqSeqNum = 0;
	insts[idx].i.inst.reqSeqNumW = 1;
	insts[idx].i.inst.reqProgressW = 84;
	insts[idx].i.inst.seqNum = 2;
	insts[idx].i.inst.fScale = 0;
	insts[idx].i.inst.wScale = 0;
	insts[idx].i.inst.W = 10;
	insts[idx].i.inst.H = 10;
	insts[idx].i.inst.C = 10;
	insts[idx].i.inst.W1 = 10;
	insts[idx].i.inst.H1 = 10;
	insts[idx].i.inst.Maddr = (ADDR_TYPE)features;
	insts[idx].i.inst.Waddr = (ADDR_TYPE)weights3;
	insts[idx].i.inst.isUseWRam = 0;
	insts[idx].i.inst.wDropSize = dropSize;
	insts[idx].i.inst.WSize = wSize;
	insts[idx].i.inst.Oaddr = (ADDR_TYPE)outputs;
	insts[idx].i.inst.WEnd[0] = start[1];
	insts[idx].i.inst.WEnd[1] = 120;
	insts[idx].i.inst.WEnd[2] = 0;
	insts[idx].i.inst.WEnd[3] = 0;
	
	insts[idx].i.inst.S = 1;
	insts[idx].i.inst.lPad = 0;
	insts[idx].i.inst.rPad = 0;
	insts[idx].i.inst.K = 1;
	insts[idx].i.inst.M = 12; // filter size, filter layers
	insts[idx].i.inst.Kh[0] = Kh[0];
	insts[idx].i.inst.Ks[0] = Ks[0];
	insts[idx].i.inst.Kt[0] = Kt[0]; // start, stride, and tail(inclusive)
	insts[idx].i.inst.Kh[1] = Kh[1];
	insts[idx].i.inst.Ks[1] = Ks[1];
	insts[idx].i.inst.Kt[1] = Kt[1]; // start, stride, and tail(inclusive)

	insts[idx].i.inst.Res_addr = 0;
	//insts[idx].i.inst.BM_addr = 0;
	insts[idx].i.inst.wLRelu = 0;
	insts[idx].i.inst.isMaddr_a = 0;
	insts[idx].i.inst.isMaddr_b = 0;
	insts[idx].i.inst.isOaddr_a = 0;
	insts[idx].i.inst.isOaddr_b = 0;
	insts[idx].i.inst.isRaddr_a = 0; //for Res
	insts[idx].i.inst.doRes = 0;
	insts[idx].i.inst.doRelu = 0;
	insts[idx].i.inst.doLRelu = 0;
	insts[idx].i.inst.doBM = 0;
	insts[idx].i.inst.doUpSample = 0;
	insts[idx].i.inst.isConv = 1;

	idx++;
	insts[idx].type = END;
	insts[idx].i.end.hasMore = 0;
	insts[idx].i.end.isRamA = 0;
	insts[idx].i.end.isRamB = 0;
	insts[idx].i.end.reqSeqNum = 2;

	CModel model;
	model.BuildModel(2, 3);
	//model.
	model.Run(insts, true);
	for (k = 0; k < 12; k++)
		for (i = 0; i < 10; i++)
			for (j = 0; j < 10; j++){
				DTYPE val;
				if (k % 2 == 0)
					val = 55;
				else
					val = 220;
				if (outputs[k][i][j] != val){
					printf("testFeaturesk1b2 error %d, %d, %d\n", k, i, j);
					return;
				}
			}
	printf("testFeaturesk1b2 pass\n");
	delete[]weights3;
}

void testFeaturesk3s1b2p1()
{
	DTYPE features[10][10][10]; //channel, height, width
	DTYPE weights[12][10][3][3];// M = 10, output channels, 3x3x10
	DTYPE weights2[1080];
	DTYPE outputs[12][10][10];// suppose 0(2468).. = 495, 1.. = 1980 
	int i, j, k;
	for (i = 0; i < 10; i++)
		for (j = 0; j < 10; j++)
			for (k = 0; k < 10; k++)
				features[i][j][k] = DTYPE(i + 1);
	for (i = 0; i < 12; i++)
		for (int j = 0; j < 10; j++)
			for (k = 0; k < 3; k++)
				for (int l = 0; l < 3; l++){
					if (i % 2 == 0)
						weights[i][j][k][l] = DTYPE(1); // output 55
					else
						weights[i][j][k][l] = DTYPE(10 - j); // output 220
				}
	int start[5], Kh[2], Ks[2], Kt[2];
	memset(start, 0, sizeof(start[0]) * 5);
	transformWeights((DTYPE *)weights2, start, Kh, Ks, Kt, (DTYPE *)weights, (DTYPE *)0,  0, 12, 10, 3, 18, 18);
	start[2] = 1080;
	int dropSize;
	int wSize;
	DTYPE *weights3 = transformWeights2((DTYPE *)weights2, MODE_FOUR, start, &dropSize, &wSize);
	GlobalInstruction insts[8];
	int idx = 0;
	insts[idx].type = CONV;
	insts[idx].i.inst.maxpool_stride = 1;
	insts[idx].i.inst.maxpool_size = 1;
	insts[idx].i.inst.W2 = 10;
	insts[idx].i.inst.mode = MODE_FOUR;
#ifdef BATCH1_OPTIMIZE
	insts[idx].i.inst.doBatch3 = 0;
#endif
	insts[idx].i.inst.reqSeqNum = 0;
	insts[idx].i.inst.reqSeqNumW = 1;
	insts[idx].i.inst.reqProgressW = 84;
	insts[idx].i.inst.seqNum = 2;
	insts[idx].i.inst.fScale = 0;
	insts[idx].i.inst.wScale = 0;
	insts[idx].i.inst.W = 10;
	insts[idx].i.inst.H = 10;
	insts[idx].i.inst.C = 10;
	insts[idx].i.inst.W1 = 10;
	insts[idx].i.inst.H1 = 10;
	insts[idx].i.inst.Maddr = (ADDR_TYPE)features;
	insts[idx].i.inst.Waddr = (ADDR_TYPE)weights3;
	insts[idx].i.inst.isUseWRam = 0;
	insts[idx].i.inst.wDropSize = dropSize;
	insts[idx].i.inst.WSize = wSize;
	insts[idx].i.inst.Oaddr = (ADDR_TYPE)outputs;
	insts[idx].i.inst.WEnd[0] = start[1];
	insts[idx].i.inst.WEnd[1] = 1080;
	insts[idx].i.inst.WEnd[2] = 0;
	insts[idx].i.inst.WEnd[3] = 0;
	insts[idx].i.inst.S = 1;
	insts[idx].i.inst.lPad = 1;
	insts[idx].i.inst.rPad = 1;
	insts[idx].i.inst.K = 3;
	insts[idx].i.inst.M = 12; // filter size, filter layers
	insts[idx].i.inst.Kh[0] = Kh[0];
	insts[idx].i.inst.Ks[0] = Ks[0];
	insts[idx].i.inst.Kt[0] = Kt[0]; // start, stride, and tail(inclusive)
	insts[idx].i.inst.Kh[1] = Kh[1];
	insts[idx].i.inst.Ks[1] = Ks[1];
	insts[idx].i.inst.Kt[1] = Kt[1]; // start, stride, and tail(inclusive)
	insts[idx].i.inst.Res_addr = 0;
	//insts[idx].i.inst.BM_addr = 0;
	insts[idx].i.inst.wLRelu = 0;
	insts[idx].i.inst.isMaddr_a = 0;
	insts[idx].i.inst.isMaddr_b = 0;
	insts[idx].i.inst.isOaddr_a = 0;
	insts[idx].i.inst.isOaddr_b = 0;
	insts[idx].i.inst.isRaddr_a = 0; //for Res
	insts[idx].i.inst.doRes = 0;
	insts[idx].i.inst.doRelu = 0;
	insts[idx].i.inst.doLRelu = 0;
	insts[idx].i.inst.doBM = 0;
	insts[idx].i.inst.doUpSample = 0;
	insts[idx].i.inst.isConv = 1;

	idx++;
	insts[idx].type = END;
	insts[idx].i.end.hasMore = 0;
	insts[idx].i.end.isRamA = 0;
	insts[idx].i.end.isRamB = 0;
	insts[idx].i.end.reqSeqNum = 2;

	CModel model;
	model.BuildModel(2, 15);
	model.Run(insts, true);
	for (k = 0; k < 12; k++)
		for (i = 0; i < 10; i++)
			for (j = 0; j < 10; j++){
				int val;
				if (k % 2 == 0){
					if (i == 0 || i == 9){
						if (j == 0 || j == 9)
							val = 220;
						else
							val = 330;
					}
					else{
						if (j == 0 || j == 9)
							val = 330;
						else
							val = 495;
					}
				}
				//* 220 330 220
				//330 495 330
				//220 330 220
				else{
					if (i == 0 || i == 9){
						if (j == 0 || j == 9)
							val = 880;
						else
							val = 1320;
					}
					else{
						if (j == 0 || j == 9)
							val = 1320;
						else
							val = 1980;
					}
				}
				//*880  1320 880
				//1320 1980 1320
				//880  1320 880
				if (outputs[k][i][j] != val){
					printf("testFeaturesk3s1b2p1 error %d, %d, %d\n", k, i, j);
					return;
				}
			}
	printf("testFeaturesk3s1b2p1 pass\n");
	delete[]weights3;
}


void testFeaturesk3s1b2p1relu()
{
	const int outSize = 12;
	DTYPE features[10][10][10]; //channel, height, width
	DTYPE weights[outSize][10][3][3];// M = 10, output channels, 3x3x10
	DTYPE weights2[90 * outSize];
	DTYPE outputs[outSize][10][10];// suppose 0(2468).. = 495, 1.. = 1980 
	int i, j, k;
	for (i = 0; i < 10; i++)
		for (j = 0; j < 10; j++)
			for (k = 0; k < 10; k++)
				features[i][j][k] = DTYPE(i + 1);
	for (i = 0; i < outSize; i++)
		for (int j = 0; j < 10; j++)
			for (k = 0; k < 3; k++)
				for (int l = 0; l < 3; l++){
					if (i % 4 == 0)
						weights[i][j][k][l] = DTYPE(1); // output 55
					else if (i % 4 == 2)
						weights[i][j][k][l] = DTYPE(-1); // output -55
					else if (i % 4 == 1)
						weights[i][j][k][l] = DTYPE(10 - j); // output 220
					else
						weights[i][j][k][l] = DTYPE(j - 10); // output -220
				}
	int start[5], Kh[2], Ks[2], Kt[2];
	memset(start, 0, sizeof(start[0]) * 5);
	transformWeights((DTYPE *)weights2, start, Kh, Ks, Kt, (DTYPE *)weights, (DTYPE *)0, 0, outSize, 10, 3, outSize * 3 / 2, outSize * 3 / 2);
	start[2] = 90 * outSize;
	int dropSize;
	int wSize;
	DTYPE *weights3 = transformWeights2((DTYPE *)weights2, MODE_FOUR, start, &dropSize, &wSize);
	GlobalInstruction insts[8];
	int idx = 0;
	insts[idx].type = CONV;
	insts[idx].i.inst.maxpool_stride = 1;
	insts[idx].i.inst.maxpool_size = 1;
	insts[idx].i.inst.W2 = 10;
	insts[idx].i.inst.mode = MODE_FOUR;
#ifdef BATCH1_OPTIMIZE
	insts[idx].i.inst.doBatch3 = 0;
#endif
	insts[idx].i.inst.reqSeqNum = 0;
	insts[idx].i.inst.reqSeqNumW = 1;
	insts[idx].i.inst.reqProgressW = 84;
	insts[idx].i.inst.seqNum = 2;
	insts[idx].i.inst.fScale = 0;
	insts[idx].i.inst.wScale = 0;
	insts[idx].i.inst.W = 10;
	insts[idx].i.inst.H = 10;
	insts[idx].i.inst.C = 10;
	insts[idx].i.inst.W1 = 10;
	insts[idx].i.inst.H1 = 10;
	insts[idx].i.inst.Maddr = (ADDR_TYPE)features;
	insts[idx].i.inst.Waddr = (ADDR_TYPE)weights3;
	insts[idx].i.inst.isUseWRam = 0;
	insts[idx].i.inst.wDropSize = dropSize;
	insts[idx].i.inst.WSize = wSize;
	insts[idx].i.inst.Oaddr = (ADDR_TYPE)outputs;
	insts[idx].i.inst.WEnd[0] = start[1];
	insts[idx].i.inst.WEnd[1] = 90 * outSize;
	insts[idx].i.inst.WEnd[2] = 0;
	insts[idx].i.inst.WEnd[3] = 0;
	insts[idx].i.inst.S = 1;
	insts[idx].i.inst.lPad = 1;
	insts[idx].i.inst.rPad = 1;
	insts[idx].i.inst.K = 3;
	insts[idx].i.inst.M = outSize; // filter size, filter layers
	insts[idx].i.inst.Kh[0] = Kh[0];
	insts[idx].i.inst.Ks[0] = Ks[0];
	insts[idx].i.inst.Kt[0] = Kt[0]; // start, stride, and tail(inclusive)
	insts[idx].i.inst.Kh[1] = Kh[1];
	insts[idx].i.inst.Ks[1] = Ks[1];
	insts[idx].i.inst.Kt[1] = Kt[1]; // start, stride, and tail(inclusive)
	insts[idx].i.inst.Res_addr = 0;
	//insts[idx].i.inst.BM_addr = 0;
	insts[idx].i.inst.wLRelu = 2;
	insts[idx].i.inst.isMaddr_a = 0;
	insts[idx].i.inst.isMaddr_b = 0;
	insts[idx].i.inst.isOaddr_a = 0;
	insts[idx].i.inst.isOaddr_b = 0;
	insts[idx].i.inst.isRaddr_a = 0; //for Res
	insts[idx].i.inst.doRes = 0;
	insts[idx].i.inst.doRelu = 0;
	insts[idx].i.inst.doLRelu = 1;
	insts[idx].i.inst.doBM = 0;
	insts[idx].i.inst.doUpSample = 0;
	insts[idx].i.inst.isConv = 1;

	idx++;
	insts[idx].type = END;
	insts[idx].i.end.hasMore = 0;
	insts[idx].i.end.isRamA = 0;
	insts[idx].i.end.isRamB = 0;
	insts[idx].i.end.reqSeqNum = 2;

	CModel model;
	model.BuildModel(2, 15);
	model.Run(insts);
	for (k = 0; k < outSize; k++)
		for (i = 0; i < 10; i++)
			for (j = 0; j < 10; j++){
				DTYPE val;
				if (k % 2 == 0){
					if (k % 4 == 2){
						if (i == 0 || i == 9){
							if (j == 0 || j == 9)
								val = -440;
							else
								val = -660;
						}
						else{
							if (j == 0 || j == 9)
								val = -660;
							else
								val = -990;
						}
					}
					else{
						if (i == 0 || i == 9){
							if (j == 0 || j == 9)
								val = 220;
							else
								val = 330;
						}
						else{
							if (j == 0 || j == 9)
								val = 330;
							else
								val = 495;
						}
					}
				}
				//* 220 330 220
				//330 495 330
				//220 330 220*
				else{
					if (k % 4 == 3)
					{
						if (i == 0 || i == 9){
							if (j == 0 || j == 9)
								val = -1760;
							else
								val = -2640;
						}
						else{
							if (j == 0 || j == 9)
								val = -2640;
							else
								val = -3960;
						}
					}
					else{
						if (i == 0 || i == 9){
							if (j == 0 || j == 9)
								val = 880;
							else
								val = 1320;
						}
						else{
							if (j == 0 || j == 9)
								val = 1320;
							else
								val = 1980;
						}
					}
				}
				//*880  1320 880
				//1320 1980 1320
				//880  1320 880
				if (outputs[k][i][j] != val){
					printf("testFeaturesk3s1b2p1relu error %d, %d, %d\n", k, i, j);
					return;
				}
			}
	printf("testFeaturesk3s1b2p1relu pass\n");
	delete[]weights3;
}


void testFeaturesk3s1b2p1relubm()
{
	const int outSize = 12;
	DTYPE features[10][10][10]; //channel, height, width
	DTYPE weights[outSize][10][3][3];// M = 10, output channels, 3x3x10
	DTYPE weights2[90 * outSize];
	DTYPE bms[outSize][BM_NUM];
	DTYPE outputs[outSize][10][10];// suppose 0(2468).. = 495, 1.. = 1980 
	int i, j, k;
	for (i = 0; i < outSize; i++){
		bms[i][0] = DTYPE(-i - 1);
		bms[i][1] = DTYPE(i + 2);
		bms[i][2] = 0;
	}
	for (i = 0; i < 10; i++)
		for (j = 0; j < 10; j++)
			for (k = 0; k < 10; k++)
				features[i][j][k] = DTYPE(i + 1);
	for (i = 0; i < outSize; i++)
		for (int j = 0; j < 10; j++)
			for (k = 0; k < 3; k++)
				for (int l = 0; l < 3; l++){
					if (i % 4 == 0)
						weights[i][j][k][l] = DTYPE(1); // output 55
					else if (i % 4 == 2)
						weights[i][j][k][l] = DTYPE(-1); // output -55
					else if (i % 4 == 1)
						weights[i][j][k][l] = DTYPE(10 - j); // output 220
					else
						weights[i][j][k][l] = DTYPE(j - 10); // output -220
				}

	int start[5], Kh[2], Ks[2], Kt[2];
	memset(start, 0, sizeof(start[0]) * 5);
	transformWeights((DTYPE *)weights2, start, Kh, Ks, Kt, (DTYPE *)weights, (DTYPE *)bms, BM_NUM , outSize, 10, 3, outSize * 3 / 2, outSize * 3 / 2);
	start[2] = 90 * outSize;
	int dropSize;
	int wSize;
	DTYPE *weights3 = transformWeights2((DTYPE *)weights2, MODE_FOUR, start, &dropSize, &wSize);
	GlobalInstruction insts[8];
	int idx = 0;
	insts[idx].type = CONV;
	insts[idx].i.inst.maxpool_stride = 1;
	insts[idx].i.inst.maxpool_size = 1;
	insts[idx].i.inst.W2 = 10;
	insts[idx].i.inst.mode = MODE_FOUR;
#ifdef BATCH1_OPTIMIZE
	insts[idx].i.inst.doBatch3 = 0;
#endif
	insts[idx].i.inst.reqSeqNum = 0;
	insts[idx].i.inst.reqSeqNumW = 1;
	insts[idx].i.inst.reqProgressW = 84;
	insts[idx].i.inst.seqNum = 2;
	insts[idx].i.inst.fScale = 0;
	insts[idx].i.inst.wScale = 0;
	insts[idx].i.inst.W = 10;
	insts[idx].i.inst.H = 10;
	insts[idx].i.inst.C = 10;
	insts[idx].i.inst.W1 = 10;
	insts[idx].i.inst.H1 = 10;
	insts[idx].i.inst.Maddr = (ADDR_TYPE)features;
	insts[idx].i.inst.Waddr = (ADDR_TYPE)weights3;
	insts[idx].i.inst.isUseWRam = 0;
	insts[idx].i.inst.wDropSize = dropSize;
	insts[idx].i.inst.WSize = wSize;
	insts[idx].i.inst.Oaddr = (ADDR_TYPE)outputs;
	insts[idx].i.inst.WEnd[0] = start[1];
	insts[idx].i.inst.WEnd[1] = 90 * outSize;
	insts[idx].i.inst.WEnd[2] = 0;
	insts[idx].i.inst.WEnd[3] = 0;
	insts[idx].i.inst.S = 1;
	insts[idx].i.inst.lPad = 1;
	insts[idx].i.inst.rPad = 1;
	insts[idx].i.inst.K = 3;
	insts[idx].i.inst.M = outSize; // filter size, filter layers
	insts[idx].i.inst.Kh[0] = Kh[0];
	insts[idx].i.inst.Ks[0] = Ks[0];
	insts[idx].i.inst.Kt[0] = Kt[0]; // start, stride, and tail(inclusive)
	insts[idx].i.inst.Kh[1] = Kh[1];
	insts[idx].i.inst.Ks[1] = Ks[1];
	insts[idx].i.inst.Kt[1] = Kt[1]; // start, stride, and tail(inclusive)
	insts[idx].i.inst.Res_addr = 0;
	//insts[idx].i.inst.BM_addr = (ADDR_TYPE)bms;
	insts[idx].i.inst.wLRelu = 2;
	insts[idx].i.inst.isMaddr_a = 0;
	insts[idx].i.inst.isMaddr_b = 0;
	insts[idx].i.inst.isOaddr_a = 0;
	insts[idx].i.inst.isOaddr_b = 0;
	insts[idx].i.inst.isRaddr_a = 0; //for Res
	insts[idx].i.inst.doRes = 0;
	insts[idx].i.inst.doRelu = 0;
	insts[idx].i.inst.doLRelu = 1;
	insts[idx].i.inst.doBM = 1;
	insts[idx].i.inst.doUpSample = 0;
	insts[idx].i.inst.isConv = 1;

	

	idx++;
	insts[idx].type = END;
	insts[idx].i.end.hasMore = 0;
	insts[idx].i.end.isRamA = 0;
	insts[idx].i.end.isRamB = 0;
	insts[idx].i.end.reqSeqNum = 2;

	CModel model;
	model.BuildModel(2, 15);
	model.Run(insts);
	for (k = 0; k < outSize; k++)
		for (i = 0; i < 10; i++)
			for (j = 0; j < 10; j++){
				DTYPE val;
				if (k % 2 == 0){
					if (k % 4 == 2){
						if (i == 0 || i == 9){
							if (j == 0 || j == 9)
								val = -220;
							else
								val = -330;
						}
						else{
							if (j == 0 || j == 9)
								val = -330;
							else
								val = -495;
						}
					}
					else{
						if (i == 0 || i == 9){
							if (j == 0 || j == 9)
								val = 220;
							else
								val = 330;
						}
						else{
							if (j == 0 || j == 9)
								val = 330;
							else
								val = 495;
						}
					}
				}
				//* 220 330 220
				//330 495 330
				//220 330 220
				else{
					if (k % 4 == 3)
					{
						if (i == 0 || i == 9){
							if (j == 0 || j == 9)
								val = -880;
							else
								val = -1320;
						}
						else{
							if (j == 0 || j == 9)
								val = -1320;
							else
								val = -1980;
						}
					}
					else{
						if (i == 0 || i == 9){
							if (j == 0 || j == 9)
								val = 880;
							else
								val = 1320;
						}
						else{
							if (j == 0 || j == 9)
								val = 1320;
							else
								val = 1980;
						}
					}
				}
				//*880  1320 880
				//1320 1980 1320
				//880  1320 880
				val = k + 2 - val * (k + 1);
				val = val < 0 ? 2 * val : val;
				if (outputs[k][i][j] != val){
					printf("testFeaturesk3s1b2p1relubm error %d, %d, %d\n", k, i, j);
					return;
				}
			}
	printf("testFeaturesk3s1b2p1relubm pass\n");
	delete[]weights3;
}


void testFeaturesk3s1b2p1relubmres()
{
	const int outSize = 12;
	DTYPE features[10][10][10]; //channel, height, width
	DTYPE weights[outSize][10][3][3];// M = 10, output channels, 3x3x10
	DTYPE weights2[90 * outSize];
	DTYPE bms[outSize][BM_NUM];
	DTYPE outputs[outSize][10][10];// suppose 0(2468).. = 495, 1.. = 1980 
	DTYPE res[outSize][10][10];
	DTYPE wrelu = 2;
	int i, j, k;
	for (i = 0; i < outSize; i++){
		bms[i][0] = DTYPE(-i - 1);
		bms[i][1] = DTYPE(i + 2);
		bms[i][2] = 0;
	}
	for (i = 0; i < 10; i++)
		for (j = 0; j < 10; j++)
			for (k = 0; k < 10; k++)
				features[i][j][k] = DTYPE(i + 1);
	for (i = 0; i < outSize; i++)
		for (int j = 0; j < 10; j++)
			for (k = 0; k < 3; k++)
				for (int l = 0; l < 3; l++){
					if (i % 4 == 0)
						weights[i][j][k][l] = DTYPE(1); // output 55
					else if (i % 4 == 2)
						weights[i][j][k][l] = DTYPE(-1); // output -55
					else if (i % 4 == 1)
						weights[i][j][k][l] = DTYPE(10 - j); // output 220
					else
						weights[i][j][k][l] = DTYPE(j - 10); // output -220
				}
	for (i = 0; i < outSize; i++)
		for (j = 0; j < 10; j++)
			for (k = 0; k < 10; k++)
				res[i][j][k] = DTYPE(10 * i);

	int start[5], Kh[2], Ks[2], Kt[2];
	memset(start, 0, sizeof(start[0]) * 5);
	transformWeights((DTYPE *)weights2, start, Kh, Ks, Kt, (DTYPE *)weights, (DTYPE *)bms, BM_NUM , outSize, 10, 3, outSize * 3 / 2, outSize * 3 / 2);
	start[2] = 90 * outSize;
	int dropSize;
	int wSize;
	DTYPE *weights3 = transformWeights2((DTYPE *)weights2, MODE_FOUR, start, &dropSize, &wSize);
	GlobalInstruction insts[9];
	int idx = 0;
	insts[idx].type = MEM;
	insts[idx].i.mem.isRamA = 0;
	insts[idx].i.mem.isRead = 1;
	insts[idx].i.mem.isFast = 1;
	insts[idx].i.mem.len = 100 * outSize;
	insts[idx].i.mem.Oaddr = (ADDR_TYPE)res;
	insts[idx].i.mem.Maddr = 0;
	insts[idx].i.mem.reqSeqNum = 0;
	insts[idx].i.mem.seqNum = 1;
	

	idx++;
	insts[idx].type = CONV;
	insts[idx].i.inst.maxpool_stride = 1;
	insts[idx].i.inst.maxpool_size = 1;
	insts[idx].i.inst.W2 = 10;
	insts[idx].i.inst.mode = MODE_FOUR;
#ifdef BATCH1_OPTIMIZE
	insts[idx].i.inst.doBatch3 = 0;
#endif
	insts[idx].i.inst.reqSeqNum = 0;
	insts[idx].i.inst.reqSeqNumW = 1;
	insts[idx].i.inst.reqProgressW = 84;
	insts[idx].i.inst.seqNum = 2;
	insts[idx].i.inst.fScale = 0;
	insts[idx].i.inst.wScale = 0;
	insts[idx].i.inst.W = 10;
	insts[idx].i.inst.H = 10;
	insts[idx].i.inst.C = 10;
	insts[idx].i.inst.W1 = 10;
	insts[idx].i.inst.H1 = 10;
	insts[idx].i.inst.Maddr = (ADDR_TYPE)features;
	insts[idx].i.inst.Waddr = (ADDR_TYPE)weights3;
	insts[idx].i.inst.isUseWRam = 0;
	insts[idx].i.inst.wDropSize = dropSize;
	insts[idx].i.inst.WSize = wSize;
	insts[idx].i.inst.Oaddr = (ADDR_TYPE)outputs;
	insts[idx].i.inst.WEnd[0] = start[1];
	insts[idx].i.inst.WEnd[1] = 90 * outSize;
	insts[idx].i.inst.WEnd[2] = 0;
	insts[idx].i.inst.WEnd[3] = 0;
	insts[idx].i.inst.S = 1;
	insts[idx].i.inst.lPad = 1;
	insts[idx].i.inst.rPad = 1;
	insts[idx].i.inst.K = 3;
	insts[idx].i.inst.M = outSize; // filter size, filter layers
	insts[idx].i.inst.Kh[0] = Kh[0];
	insts[idx].i.inst.Ks[0] = Ks[0];
	insts[idx].i.inst.Kt[0] = Kt[0]; // start, stride, and tail(inclusive)
	insts[idx].i.inst.Kh[1] = Kh[1];
	insts[idx].i.inst.Ks[1] = Ks[1];
	insts[idx].i.inst.Kt[1] = Kt[1]; // start, stride, and tail(inclusive)
	insts[idx].i.inst.Res_addr = 0;
	//insts[idx].i.inst.BM_addr = (ADDR_TYPE)bms;
	insts[idx].i.inst.wLRelu = 2;
	insts[idx].i.inst.isMaddr_a = 0;
	insts[idx].i.inst.isMaddr_b = 0;
	insts[idx].i.inst.isOaddr_a = 0;
	insts[idx].i.inst.isOaddr_b = 0;
	insts[idx].i.inst.isRaddr_a = 0; //for Res
	insts[idx].i.inst.doRes = 1;
	insts[idx].i.inst.doRelu = 0;
	insts[idx].i.inst.doLRelu = 1;
	insts[idx].i.inst.doBM = 1;
	insts[idx].i.inst.doUpSample = 0;
	insts[idx].i.inst.isConv = 1;

	
	idx++;
	insts[idx].type = END;
	insts[idx].i.end.hasMore = 0;
	insts[idx].i.end.isRamA = 0;
	insts[idx].i.end.isRamB = 0;
	insts[idx].i.end.reqSeqNum = 2;

	CModel model;
	model.BuildModel(2, 15);
	model.Run(insts, true);
	for (k = 0; k < outSize; k++)
		for (i = 0; i < 10; i++)
			for (j = 0; j < 10; j++){
				DTYPE val;
				if (k % 2 == 0){
					if (k % 4 == 2){
						if (i == 0 || i == 9){
							if (j == 0 || j == 9)
								val = -220;
							else
								val = -330;
						}
						else{
							if (j == 0 || j == 9)
								val = -330;
							else
								val = -495;
						}
					}
					else{
						if (i == 0 || i == 9){
							if (j == 0 || j == 9)
								val = 220;
							else
								val = 330;
						}
						else{
							if (j == 0 || j == 9)
								val = 330;
							else
								val = 495;
						}
					}
				}
				//* 220 330 220
				//330 495 330
				//220 330 220
				else{
					if (k % 4 == 3)
					{
						if (i == 0 || i == 9){
							if (j == 0 || j == 9)
								val = -880;
							else
								val = -1320;
						}
						else{
							if (j == 0 || j == 9)
								val = -1320;
							else
								val = -1980;
						}
					}
					else{
						if (i == 0 || i == 9){
							if (j == 0 || j == 9)
								val = 880;
							else
								val = 1320;
						}
						else{
							if (j == 0 || j == 9)
								val = 1320;
							else
								val = 1980;
						}
					}
				}
				//*880  1320 880
				//1320 1980 1320
				//880  1320 880
				val = k + 2 - val * (k + 1);
				val = val < 0 ? 2 * val : val;
				val = val + 10 * k;
				assert(outputs[k][i][j] == val);
				if (outputs[k][i][j] != val){
					printf("testFeaturesk3s1b2p1relubmres error %d, %d, %d\n", k, i, j);
					return;
				}
			}
	printf("testFeaturesk3s1b2p1relubmres pass\n");
	delete[]weights3;
}


void testFeaturesk3s2b2()
{
	const int outSize = 16;
	DTYPE features[10][11][11]; //channel, height, width
	DTYPE weights[outSize][10][3][3];// M = 10, output channels, 3x3x10
	DTYPE weights2[90 * outSize];
	DTYPE outputs[outSize][5][5];// suppose 0(2468).. = 495, 1.. = 1980 
	int i, j, k;
	for (i = 0; i < 10; i++)
		for (j = 0; j < 11; j++)
			for (k = 0; k < 11; k++)
				features[i][j][k] = DTYPE(i + 1);
	for (i = 0; i < outSize; i++)
		for (int j = 0; j < 10; j++)
			for (k = 0; k < 3; k++)
				for (int l = 0; l < 3; l++){
					if (i % 2 == 0)
						weights[i][j][k][l] = DTYPE(1); // output 55
					else
						weights[i][j][k][l] = DTYPE(10 - j); // output 220
				}

	int start[5], Kh[2], Ks[2], Kt[2];
	memset(start, 0, sizeof(start[0]) * 5);
	transformWeights((DTYPE *)weights2, start, Kh, Ks, Kt, (DTYPE *)weights, (DTYPE *)0, 0, outSize, 10, 3, outSize * 3 / 2, outSize * 3 / 2);
	start[2] = 90 * outSize;
	int dropSize;
	int wSize;
	DTYPE *weights3 = transformWeights2((DTYPE *)weights2, MODE_FOUR, start, &dropSize, &wSize);
	GlobalInstruction insts[8];
	int idx = 0;
	
	insts[idx].type = CONV;
	insts[idx].i.inst.maxpool_stride = 1;
	insts[idx].i.inst.maxpool_size = 1;
	insts[idx].i.inst.W2 = 11;
	insts[idx].i.inst.mode = MODE_FOUR;
#ifdef BATCH1_OPTIMIZE
	insts[idx].i.inst.doBatch3 = 0;
#endif
	insts[idx].i.inst.reqSeqNum = 0;
	insts[idx].i.inst.reqSeqNumW = 1;
	insts[idx].i.inst.reqProgressW = 84;
	insts[idx].i.inst.seqNum = 2;
	insts[idx].i.inst.fScale = 0;
	insts[idx].i.inst.wScale = 0;
	insts[idx].i.inst.W = 11;
	insts[idx].i.inst.H = 11;
	insts[idx].i.inst.C = 10;
	insts[idx].i.inst.W1 = 11;
	insts[idx].i.inst.H1 = 11;
	insts[idx].i.inst.Maddr = (ADDR_TYPE)features;
	insts[idx].i.inst.Waddr = (ADDR_TYPE)weights3;
	insts[idx].i.inst.isUseWRam = 0;
	insts[idx].i.inst.wDropSize = dropSize;
	insts[idx].i.inst.WSize = wSize;
	insts[idx].i.inst.Oaddr = (ADDR_TYPE)outputs;
	insts[idx].i.inst.WEnd[0] = start[1];
	insts[idx].i.inst.WEnd[1] = 90 * outSize;
	insts[idx].i.inst.WEnd[2] = 0;
	insts[idx].i.inst.WEnd[3] = 0;
	insts[idx].i.inst.S = 2;
	insts[idx].i.inst.lPad = 0;
	insts[idx].i.inst.rPad = 0;
	insts[idx].i.inst.K = 3;
	insts[idx].i.inst.M = outSize; // filter size, filter layers
	insts[idx].i.inst.Kh[0] = Kh[0];
	insts[idx].i.inst.Ks[0] = Ks[0];
	insts[idx].i.inst.Kt[0] = Kt[0]; // start, stride, and tail(inclusive)
	insts[idx].i.inst.Kh[1] = Kh[1];
	insts[idx].i.inst.Ks[1] = Ks[1];
	insts[idx].i.inst.Kt[1] = Kt[1]; // start, stride, and tail(inclusive)
	insts[idx].i.inst.Res_addr = 0;
	//insts[idx].i.inst.BM_addr = 0;
	insts[idx].i.inst.wLRelu = 0;
	insts[idx].i.inst.isMaddr_a = 0;
	insts[idx].i.inst.isMaddr_b = 0;
	insts[idx].i.inst.isOaddr_a = 0;
	insts[idx].i.inst.isOaddr_b = 0;
	insts[idx].i.inst.isRaddr_a = 0; //for Res
	insts[idx].i.inst.doRes = 0;
	insts[idx].i.inst.doRelu = 0;
	insts[idx].i.inst.doLRelu = 0;
	insts[idx].i.inst.doBM = 0;
	insts[idx].i.inst.doUpSample = 0;
	insts[idx].i.inst.isConv = 1;
	


	idx++;
	insts[idx].type = END;
	insts[idx].i.end.hasMore = 0;
	insts[idx].i.end.isRamA = 0;
	insts[idx].i.end.isRamB = 0;
	insts[idx].i.end.reqSeqNum = 2;

	CModel model;
	model.BuildModel(2, 6);
	model.Run(insts);
	for (k = 0; k < outSize; k++)
		for (i = 0; i < 5; i++)
			for (j = 0; j < 5; j++){
				DTYPE val;
				if (k % 2 == 0)
					val= 495;
				else
					val= 1980;
				if (outputs[k][i][j] != val){
					printf("testFeaturesk3s2b2 error %d, %d, %d\n", k, i, j);
					return;
				}
			}
	printf("testFeaturesk3s2b2 pass\n");
	delete[]weights3;
}

void testFeaturesk3s2b2_rand()
{
	bool doBM = false;
	bool doRelu = false;
	bool doLRelu = false;
	bool doRes = false;
	const int CHANNEL = 8;
	const int OUTSIZE = 120;
	const int WIDTH = 10;
	const int HEIGHT = 10;
	const int KERNEL = 3;
	DTYPE wrelu = 2;
	CDataSet<CHANNEL, HEIGHT, WIDTH, KERNEL, OUTSIZE, 2, 1, 1> *ds = new CDataSet<CHANNEL, HEIGHT, WIDTH, KERNEL, OUTSIZE, 2, 1, 1>();
	ds->GenData(wrelu, doBM, doRelu, doLRelu, doRes);
	ds->Dump(64, 0, 0, wrelu, doBM, doRelu, doLRelu, doRes);

	DTYPE weights2[KERNEL * KERNEL * CHANNEL * OUTSIZE];
	int start[5], Kh[4], Ks[4], Kt[4];
	transformWeights((DTYPE *)weights2, start, Kh, Ks, Kt, (DTYPE *)ds->weights, (DTYPE *)ds->bms, doBM ? BM_NUM : 0, OUTSIZE, CHANNEL, KERNEL, CG_NUM, CG_NUM, CG_NUM, CG_NUM);
	start[4] = KERNEL * KERNEL * CHANNEL * OUTSIZE;
	int dropSize;
	int wSize;
	DTYPE *weights3 = transformWeights2((DTYPE *)weights2, MODE_FOUR, start, &dropSize, &wSize);

	GlobalInstruction insts[8];
	int idx = 0;
	insts[idx].type = CONV;
	insts[idx].i.inst.maxpool_stride = 1;
	insts[idx].i.inst.maxpool_size = 1;
	insts[idx].i.inst.W2 = WIDTH;
	insts[idx].i.inst.mode = MODE_FOUR;
#ifdef BATCH1_OPTIMIZE
	insts[idx].i.inst.doBatch3 = 0;
#endif
	insts[idx].i.inst.reqSeqNum = 0;
	insts[idx].i.inst.reqSeqNumW = 1;
	insts[idx].i.inst.reqProgressW = 168;
	insts[idx].i.inst.seqNum = 2;
	insts[idx].i.inst.fScale = 0;
	insts[idx].i.inst.wScale = 0;
	insts[idx].i.inst.W = WIDTH;
	insts[idx].i.inst.H = HEIGHT;
	insts[idx].i.inst.C = CHANNEL;
	insts[idx].i.inst.W1 = WIDTH;
	insts[idx].i.inst.H1 = HEIGHT;
	insts[idx].i.inst.Maddr = (ADDR_TYPE)ds->features;
	insts[idx].i.inst.Waddr = (ADDR_TYPE)weights3;
	insts[idx].i.inst.isUseWRam = 0;
	insts[idx].i.inst.wDropSize = dropSize;
	insts[idx].i.inst.WSize = wSize;
	insts[idx].i.inst.Oaddr = (ADDR_TYPE)ds->outputs;
	insts[idx].i.inst.WEnd[0] = start[1];
	insts[idx].i.inst.WEnd[1] = start[2];
	insts[idx].i.inst.WEnd[2] = start[3];
	insts[idx].i.inst.WEnd[3] = KERNEL * KERNEL * CHANNEL * OUTSIZE;;
	insts[idx].i.inst.S = 2;
	insts[idx].i.inst.lPad = 1;
	insts[idx].i.inst.rPad = 1;
	insts[idx].i.inst.K = KERNEL;
	insts[idx].i.inst.M = OUTSIZE; // filter size, filter layers
	insts[idx].i.inst.Kh[0] = Kh[0];
	insts[idx].i.inst.Ks[0] = Ks[0];
	insts[idx].i.inst.Kt[0] = Kt[0]; // start, stride, and tail(inclusive)
	insts[idx].i.inst.Kh[1] = Kh[1];
	insts[idx].i.inst.Ks[1] = Ks[1];
	insts[idx].i.inst.Kt[1] = Kt[1]; // start, stride, and tail(inclusive)
	insts[idx].i.inst.Kh[2] = Kh[2];
	insts[idx].i.inst.Ks[2] = Ks[2];
	insts[idx].i.inst.Kt[2] = Kt[2]; // start, stride, and tail(inclusive)
	insts[idx].i.inst.Kh[3] = Kh[3];
	insts[idx].i.inst.Ks[3] = Ks[3];
	insts[idx].i.inst.Kt[3] = Kt[3]; // start, stride, and tail(inclusive)
	insts[idx].i.inst.Res_addr = 0;
	//insts[idx].i.inst.BM_addr = 0;
	insts[idx].i.inst.wLRelu = 0;
	insts[idx].i.inst.isMaddr_a = 0;
	insts[idx].i.inst.isMaddr_b = 0;
	insts[idx].i.inst.isOaddr_a = 0;
	insts[idx].i.inst.isOaddr_b = 0;
	insts[idx].i.inst.isRaddr_a = 0; //for Res
	insts[idx].i.inst.doRes = 0;
	insts[idx].i.inst.doRelu = 0;
	insts[idx].i.inst.doLRelu = 0;
	insts[idx].i.inst.doBM = 0;
	insts[idx].i.inst.doUpSample = 0;
	insts[idx].i.inst.isConv = 1;

	idx++;
	insts[idx].type = END;
	insts[idx].i.end.hasMore = 0;
	insts[idx].i.end.isRamA = 0;
	insts[idx].i.end.isRamB = 0;
	insts[idx].i.end.reqSeqNum = 2;

	CModel model;
	model.BuildModel(2, 6);
	model.Run(insts, true);
	for (int k = 0; k < OUTSIZE; k++)
		for (int i = 0; i < HEIGHT / 2; i++)
			for (int j = 0; j < WIDTH / 2; j++){
				if (!Is_equal(ds->outputs[k][i][j], ds->expected[k][i][j])) {
					printf("@#!ERROR@#! %d %d %d ("DFMT", "DFMT")\n", k, i, j, ds->outputs[k][i][j], ds->expected[k][i][j]);
					delete ds; return;
				}
				//assert(outputs[k][i][j] == expected[k][i][j]);
			}
	printf("testFeaturesk3s2b2_rand pass.  all equal ("DFMT", "DFMT", "DFMT", "DFMT", "DFMT")\n", ds->outputs[0][0][0], ds->outputs[0][0][1]
		, ds->outputs[0][0][2], ds->outputs[0][0][3], ds->outputs[0][0][4]);
	delete ds;
	delete[]weights3;
}

void testFeaturesk3s2b2bmreluup()
{
	const int outSize = 12;
	DTYPE features[10][11][11]; //channel, height, width
	DTYPE weights[outSize][10][3][3];// M = 10, output channels, 3x3x10
	DTYPE weights2[90 * outSize];
	DTYPE bms[outSize][BM_NUM];
	DTYPE outputs[outSize][10][10];// suppose 0(2468).. = 495, 1.. = 1980 
	int i, j, k;
	for (i = 0; i < 10; i++)
		for (j = 0; j < 11; j++)
			for (k = 0; k < 11; k++)
				features[i][j][k] = DTYPE(i + 1);
	for (i = 0; i < outSize; i++){
		bms[i][0] = DTYPE(-i - 1);
		bms[i][1] = DTYPE(i + 2);
		bms[i][2] = 0;
	}
	for (i = 0; i < outSize; i++)
		for (int j = 0; j < 10; j++)
			for (k = 0; k < 3; k++)
				for (int l = 0; l < 3; l++){
					if (i % 2 == 0)
						weights[i][j][k][l] = DTYPE(1); // output 55
					else
						weights[i][j][k][l] = DTYPE(10 - j); // output 220
				}

	int start[5], Kh[2], Ks[2], Kt[2];
	memset(start, 0, sizeof(start[0]) * 5);
	transformWeights((DTYPE *)weights2, start, Kh, Ks, Kt, (DTYPE *)weights, (DTYPE *)bms, BM_NUM , outSize, 10, 3, outSize * 3 / 2, outSize * 3 / 2);
	start[2] = 90 * outSize;
	int dropSize;
	int wSize;
	DTYPE *weights3 = transformWeights2((DTYPE *)weights2, MODE_FOUR, start, &dropSize, &wSize);
	GlobalInstruction insts[8];
	int idx = 0;
	
	insts[idx].type = CONV;
	insts[idx].i.inst.maxpool_stride = 1;
	insts[idx].i.inst.maxpool_size = 1;
	insts[idx].i.inst.W2 = 11;
	insts[idx].i.inst.mode = MODE_FOUR;
#ifdef BATCH1_OPTIMIZE
	insts[idx].i.inst.doBatch3 = 0;
#endif
	insts[idx].i.inst.reqSeqNum = 0;
	insts[idx].i.inst.reqSeqNumW = 1;
	insts[idx].i.inst.reqProgressW = 84;
	insts[idx].i.inst.seqNum = 2;
	insts[idx].i.inst.fScale = 0;
	insts[idx].i.inst.wScale = 0;
	insts[idx].i.inst.W = 11;
	insts[idx].i.inst.H = 11;
	insts[idx].i.inst.C = 10;
	insts[idx].i.inst.W1 = 11;
	insts[idx].i.inst.H1 = 11;
	insts[idx].i.inst.Maddr = (ADDR_TYPE)features;
	insts[idx].i.inst.Waddr = (ADDR_TYPE)weights3;
	insts[idx].i.inst.isUseWRam = 0;
	insts[idx].i.inst.wDropSize = dropSize;
	insts[idx].i.inst.WSize = wSize;
	insts[idx].i.inst.Oaddr = (ADDR_TYPE)outputs;
	insts[idx].i.inst.WEnd[0] = start[1];
	insts[idx].i.inst.WEnd[1] = 90 * outSize;
	insts[idx].i.inst.WEnd[2] = 0;
	insts[idx].i.inst.WEnd[3] = 0;
	insts[idx].i.inst.S = 2;
	insts[idx].i.inst.lPad = 0;
	insts[idx].i.inst.rPad = 0;
	insts[idx].i.inst.K = 3;
	insts[idx].i.inst.M = outSize; // filter size, filter layers
	insts[idx].i.inst.Kh[0] = Kh[0];
	insts[idx].i.inst.Ks[0] = Ks[0];
	insts[idx].i.inst.Kt[0] = Kt[0]; // start, stride, and tail(inclusive)
	insts[idx].i.inst.Kh[1] = Kh[1];
	insts[idx].i.inst.Ks[1] = Ks[1];
	insts[idx].i.inst.Kt[1] = Kt[1]; // start, stride, and tail(inclusive)
	insts[idx].i.inst.Res_addr = 0;
	//insts[idx].i.inst.BM_addr = (ADDR_TYPE)bms;
	insts[idx].i.inst.wLRelu = 2;
	insts[idx].i.inst.isMaddr_a = 0;
	insts[idx].i.inst.isMaddr_b = 0;
	insts[idx].i.inst.isOaddr_a = 0;
	insts[idx].i.inst.isOaddr_b = 0;
	insts[idx].i.inst.isRaddr_a = 0; //for Res
	insts[idx].i.inst.doRes = 0;
	insts[idx].i.inst.doRelu = 0;
	insts[idx].i.inst.doLRelu = 1;
	insts[idx].i.inst.doBM = 1;
	insts[idx].i.inst.doUpSample = 1;
	insts[idx].i.inst.isConv = 1;

	idx++;
	insts[idx].type = END;
	insts[idx].i.end.hasMore = 0;
	insts[idx].i.end.isRamA = 0;
	insts[idx].i.end.isRamB = 0;
	insts[idx].i.end.reqSeqNum = 2;

	CModel model;
	model.BuildModel(2, 6);
	model.Run(insts);
	for (k = 0; k < outSize; k++)
		for (i = 0; i < 10; i++)
			for (j = 0; j < 10; j++){
				DTYPE val;
				if (k % 2 == 0)
					val = 495;
				else
					val = 1980;
				val = k + 2 - val * (k + 1);
				val = val < 0 ? 2 * val : val;
				assert(outputs[k][i][j] == val);
				if (outputs[k][i][j] != val){
					printf("testFeaturesk3s2b2bmreluup error %d, %d, %d\n", k, i, j);
					return;
				}
			}
	printf("testFeaturesk3s2b2bmreluup pass\n");
	delete[]weights3;
}

void testFeatures10xup_rand()
{
	printf("10x10 k1s1 upsample\n");
	bool doBM = false;
	bool doRelu = false;
	bool doLRelu = false;
	bool doRes = false;
	const bool doUpsample = true;
	const int CHANNEL = 512;
	const int OUTSIZE = 256;
	const int WIDTH = 10;
	const int HEIGHT = 10;
	const int KERNEL = 1;
	const int STRIDE = 1;
	DTYPE wrelu = 2;
	CDataSet<CHANNEL, HEIGHT, WIDTH, KERNEL, OUTSIZE, STRIDE, doUpsample ? 2 : 1, 1> *ds
		= new CDataSet<CHANNEL, HEIGHT, WIDTH, KERNEL, OUTSIZE, STRIDE, doUpsample ? 2 : 1, 1>();
	ds->GenData(wrelu, doBM, doRelu, doLRelu, doRes);

	DTYPE weights2[KERNEL * KERNEL * CHANNEL * OUTSIZE];
	int start[5], Kh[4], Ks[4], Kt[4];
	transformWeights((DTYPE *)weights2, start, Kh, Ks, Kt, (DTYPE *)ds->weights, (DTYPE *)ds->bms, doBM ? BM_NUM : 0, OUTSIZE, CHANNEL, KERNEL, CG_NUM, CG_NUM, CG_NUM, CG_NUM);
	start[4] = KERNEL * KERNEL * CHANNEL * OUTSIZE;
	int dropSize;
	int wSize;
	DTYPE *weights3 = transformWeights2((DTYPE *)weights2, MODE_FOUR, start, &dropSize, &wSize);

	GlobalInstruction insts[8];
	int idx = 0;
	insts[idx].type = CONV;
	insts[idx].i.inst.maxpool_stride = 1;
	insts[idx].i.inst.maxpool_size = 1;
	insts[idx].i.inst.W2 = WIDTH;
	insts[idx].i.inst.mode = MODE_FOUR;
#ifdef BATCH1_OPTIMIZE
	insts[idx].i.inst.doBatch3 = 0;
#endif
	insts[idx].i.inst.reqSeqNum = 0;
	insts[idx].i.inst.reqSeqNumW = 1;
	insts[idx].i.inst.reqProgressW = 168;
	insts[idx].i.inst.seqNum = 2;
	insts[idx].i.inst.fScale = 0;
	insts[idx].i.inst.wScale = 0;
	insts[idx].i.inst.W = WIDTH;
	insts[idx].i.inst.H = HEIGHT;
	insts[idx].i.inst.C = CHANNEL;
	insts[idx].i.inst.W1 = WIDTH;
	insts[idx].i.inst.H1 = HEIGHT;
	insts[idx].i.inst.Maddr = (ADDR_TYPE)ds->features;
	insts[idx].i.inst.Waddr = (ADDR_TYPE)weights3;
	insts[idx].i.inst.isUseWRam = 0;
	insts[idx].i.inst.wDropSize = dropSize;
	insts[idx].i.inst.WSize = wSize;
	insts[idx].i.inst.Oaddr = (ADDR_TYPE)ds->outputs;
	insts[idx].i.inst.WEnd[0] = start[1];
	insts[idx].i.inst.WEnd[1] = start[2];
	insts[idx].i.inst.WEnd[2] = start[3];
	insts[idx].i.inst.WEnd[3] = KERNEL * KERNEL * CHANNEL * OUTSIZE;;
	insts[idx].i.inst.S = STRIDE;
	insts[idx].i.inst.lPad = 0;
	insts[idx].i.inst.rPad = 0;
	insts[idx].i.inst.K = KERNEL;
	insts[idx].i.inst.M = OUTSIZE; // filter size, filter layers
	insts[idx].i.inst.Kh[0] = Kh[0];
	insts[idx].i.inst.Ks[0] = Ks[0];
	insts[idx].i.inst.Kt[0] = Kt[0]; // start, stride, and tail(inclusive)
	insts[idx].i.inst.Kh[1] = Kh[1];
	insts[idx].i.inst.Ks[1] = Ks[1];
	insts[idx].i.inst.Kt[1] = Kt[1]; // start, stride, and tail(inclusive)
	insts[idx].i.inst.Kh[2] = Kh[2];
	insts[idx].i.inst.Ks[2] = Ks[2];
	insts[idx].i.inst.Kt[2] = Kt[2]; // start, stride, and tail(inclusive)
	insts[idx].i.inst.Kh[3] = Kh[3];
	insts[idx].i.inst.Ks[3] = Ks[3];
	insts[idx].i.inst.Kt[3] = Kt[3]; // start, stride, and tail(inclusive)
	insts[idx].i.inst.Res_addr = 0;
	//insts[idx].i.inst.BM_addr = (ADDR_TYPE)ds->bms;
	insts[idx].i.inst.wLRelu = wrelu;
	insts[idx].i.inst.isMaddr_a = 0;
	insts[idx].i.inst.isMaddr_b = 0;
	insts[idx].i.inst.isOaddr_a = 0;
	insts[idx].i.inst.isOaddr_b = 0;
	insts[idx].i.inst.isRaddr_a = 0; //for Res
	insts[idx].i.inst.doRes = doRes?1:0;
	insts[idx].i.inst.doRelu = doRelu?1:0;
	insts[idx].i.inst.doLRelu = doLRelu?1:0;
	insts[idx].i.inst.doBM = doBM?1:0;
	insts[idx].i.inst.doUpSample = doUpsample?1:0;
	insts[idx].i.inst.isConv = 1;

	idx++;
	insts[idx].type = END;
	insts[idx].i.end.hasMore = 0;
	insts[idx].i.end.isRamA = 0;
	insts[idx].i.end.isRamB = 0;
	insts[idx].i.end.reqSeqNum = 2;

	CModel model;
	model.BuildModel(2, 6);
	model.Run(insts, true);
	for (int k = 0; k < OUTSIZE; k++)
		for (int i = 0; i < HEIGHT * 2; i++)
			for (int j = 0; j < WIDTH * 2; j++){
				if (ds->outputs[k][i][j] != ds->expected[k][i][j]) {
					printf("@#!ERROR@#! %d %d %d\n", k, i, j);
					delete ds; return;
				}
				//assert(outputs[k][i][j] == expected[k][i][j]);
			}
	printf("testFeatures10xup_rand pass.  all equal ("DFMT", "DFMT", "DFMT", "DFMT", "DFMT")\n", ds->outputs[0][0][0], ds->outputs[0][0][1]
		, ds->outputs[0][0][2], ds->outputs[0][0][3], ds->outputs[0][0][4]);
	delete ds;
	delete[]weights3;
}

void testFeatures20xup_rand()
{
	printf("20x20 k1s1 upsample\n");
	bool doBM = true;
	bool doRelu = false;
	bool doLRelu = true;
	bool doRes = false;
	const bool doUpsample = true;
	const int CHANNEL = 8;
	const int OUTSIZE = 96;
	const int WIDTH = 20;
	const int HEIGHT = 20;
	const int KERNEL = 1;
	const int STRIDE = 1;
	DTYPE wrelu = 2;
	CDataSet<CHANNEL, HEIGHT, WIDTH, KERNEL, OUTSIZE, STRIDE, doUpsample ? 2 : 1, 1> *ds
		= new CDataSet<CHANNEL, HEIGHT, WIDTH, KERNEL, OUTSIZE, STRIDE, doUpsample ? 2 : 1, 1>();
	ds->GenData(wrelu, doBM, doRelu, doLRelu, doRes);
	{
		FILE *fp = fopen("data.txt", "wt");
		fprintf(fp, "weight :\n");
		for (int i = 0; i < OUTSIZE; i++){
			fprintf(fp, "\t%d :", i);
			for (int j = 0; j < CHANNEL; j++)
				fprintf(fp, " "DFMT, ds->weights[i][j][0][0]);
			fprintf(fp, "\n");
		}

		fprintf(fp, "features :\n");
		for (int i = 0; i < CHANNEL; i++){
			fprintf(fp, "\t%d :\n", i);
			for (int j = 0; j < HEIGHT; j++){
				fprintf(fp, "\t\t");
				for (int k = 0; k < WIDTH; k++)
					fprintf(fp, " "DFMT, ds->features[i][j][k]);
				fprintf(fp, "\n");
			}
		}
		fclose(fp);

	}

	DTYPE weights2[KERNEL * KERNEL * CHANNEL * OUTSIZE];
	int start[5], Kh[4], Ks[4], Kt[4];
	memset(start, 0, sizeof(start[0]) * 5);
	transformWeights((DTYPE *)weights2, start, Kh, Ks, Kt, (DTYPE *)ds->weights, (DTYPE *)ds->bms, doBM ? BM_NUM : 0, OUTSIZE, CHANNEL, KERNEL, CG_NUM, CG_NUM);
	start[2] = KERNEL * KERNEL * CHANNEL * OUTSIZE;
	int dropSize;
	int wSize;
	DTYPE *weights3 = transformWeights2((DTYPE *)weights2, MODE_TWO, start, &dropSize, &wSize);

	GlobalInstruction insts[8];
	int idx = 0;
	
	insts[idx].type = CONV;
	insts[idx].i.inst.maxpool_stride = 1;
	insts[idx].i.inst.maxpool_size = 1;
	insts[idx].i.inst.W2 = WIDTH / 2;
	insts[idx].i.inst.mode = MODE_TWO;
#ifdef BATCH1_OPTIMIZE
	insts[idx].i.inst.doBatch3 = 0;
#endif
	insts[idx].i.inst.reqSeqNum = 0;
	insts[idx].i.inst.reqSeqNumW = 1;
	insts[idx].i.inst.reqProgressW = 84;
	insts[idx].i.inst.seqNum = 2;
	insts[idx].i.inst.fScale = 0;
	insts[idx].i.inst.wScale = 0;
	insts[idx].i.inst.W = WIDTH;
	insts[idx].i.inst.H = HEIGHT;
	insts[idx].i.inst.C = CHANNEL;
	insts[idx].i.inst.W1 = WIDTH/2;
	insts[idx].i.inst.H1 = HEIGHT/2;
	insts[idx].i.inst.Maddr = (ADDR_TYPE)ds->features;
	insts[idx].i.inst.Waddr = (ADDR_TYPE)weights3;
	insts[idx].i.inst.isUseWRam = 0;
	insts[idx].i.inst.wDropSize = dropSize;
	insts[idx].i.inst.WSize = wSize;
	insts[idx].i.inst.Oaddr = (ADDR_TYPE)ds->outputs;
	insts[idx].i.inst.WEnd[0] = start[1];
	insts[idx].i.inst.WEnd[1] = KERNEL * KERNEL * CHANNEL * OUTSIZE;;
	insts[idx].i.inst.WEnd[2] = 0;
	insts[idx].i.inst.WEnd[3] = 0;
	insts[idx].i.inst.S = STRIDE;
	insts[idx].i.inst.lPad = 0;
	insts[idx].i.inst.rPad = 0;
	insts[idx].i.inst.K = KERNEL;
	insts[idx].i.inst.M = OUTSIZE; // filter size, filter layers
	insts[idx].i.inst.Kh[0] = Kh[0];
	insts[idx].i.inst.Ks[0] = Ks[0];
	insts[idx].i.inst.Kt[0] = Kt[0]; // start, stride, and tail(inclusive)
	insts[idx].i.inst.Kh[1] = Kh[1];
	insts[idx].i.inst.Ks[1] = Ks[1];
	insts[idx].i.inst.Kt[1] = Kt[1]; // start, stride, and tail(inclusive)
	insts[idx].i.inst.Kh[2] = Kh[2];
	insts[idx].i.inst.Ks[2] = Ks[2];
	insts[idx].i.inst.Kt[2] = Kt[2]; // start, stride, and tail(inclusive)
	insts[idx].i.inst.Kh[3] = Kh[3];
	insts[idx].i.inst.Ks[3] = Ks[3];
	insts[idx].i.inst.Kt[3] = Kt[3]; // start, stride, and tail(inclusive)
	insts[idx].i.inst.Res_addr = 0;
	//insts[idx].i.inst.BM_addr = (ADDR_TYPE)ds->bms;
	insts[idx].i.inst.wLRelu = wrelu;
	insts[idx].i.inst.isMaddr_a = 0;
	insts[idx].i.inst.isMaddr_b = 0;
	insts[idx].i.inst.isOaddr_a = 0;
	insts[idx].i.inst.isOaddr_b = 0;
	insts[idx].i.inst.isRaddr_a = 0; //for Res
	insts[idx].i.inst.doRes = doRes ? 1 : 0;
	insts[idx].i.inst.doRelu = doRelu ? 1 : 0;
	insts[idx].i.inst.doLRelu = doLRelu ? 1 : 0;
	insts[idx].i.inst.doBM = doBM ? 1 : 0;
	insts[idx].i.inst.doUpSample = doUpsample ? 1 : 0;
	insts[idx].i.inst.isConv = 1;

	idx++;
	insts[idx].type = END;
	insts[idx].i.end.hasMore = 0;
	insts[idx].i.end.isRamA = 0;
	insts[idx].i.end.isRamB = 0;
	insts[idx].i.end.reqSeqNum = 3;

	CModel model;
	model.BuildModel(2, 6);
	model.Run(insts, true);
	int sz = doUpsample ? 2 : 1;
	for (int k = 0; k < OUTSIZE; k++)
		for (int i = 0; i < HEIGHT * sz; i++)
			for (int j = 0; j < WIDTH * sz; j++){
				if (ds->outputs[k][i][j] != ds->expected[k][i][j]) {
					printf("@#!ERROR@#! %d %d %d\n", k, i, j);
					delete ds; return;
				}
				//assert(outputs[k][i][j] == expected[k][i][j]);
			}
	printf("testFeatures20xup_rand pass.  all equal ("DFMT", "DFMT", "DFMT", "DFMT", "DFMT")\n", ds->outputs[0][0][0], ds->outputs[0][0][1]
		, ds->outputs[0][0][2], ds->outputs[0][0][3], ds->outputs[0][0][4]);
	delete ds;
	delete[]weights3;
}
void testFeatures40xup_rand()
{
	printf("40x40 k1s1 upsample\n");
	bool doBM = true;
	bool doRelu = false;
	bool doLRelu = true;
	bool doRes = false;
	const bool doUpsample = true;
	const int CHANNEL = 8;
	const int OUTSIZE = 96;
	const int WIDTH = 40;
	const int HEIGHT = 40;
	const int KERNEL = 1;
	const int STRIDE = 1;
	DTYPE wrelu = 2;
	CDataSet<CHANNEL, HEIGHT, WIDTH, KERNEL, OUTSIZE, STRIDE, doUpsample ? 2 : 1, 1> *ds
		= new CDataSet<CHANNEL, HEIGHT, WIDTH, KERNEL, OUTSIZE, STRIDE, doUpsample ? 2 : 1, 1>();
	ds->GenData(wrelu, doBM, doRelu, doLRelu, doRes);
	{
		FILE *fp = fopen("data.txt", "wt");
		fprintf(fp, "weight :\n");
		for (int i = 0; i < OUTSIZE; i++){
			fprintf(fp, "\t%d :", i);
			for (int j = 0; j < CHANNEL; j++)
				fprintf(fp, " "DFMT, ds->weights[i][j][0][0]);
			fprintf(fp, "\n");
		}

		fprintf(fp, "features (20, 10) :\n");
		for (int i = 0; i < CHANNEL; i++){
			fprintf(fp, " "DFMT"", ds->features[i][20][10]);
		}
		fprintf(fp, "\n");

		fprintf(fp, "features :\n");
		for (int i = 0; i < CHANNEL; i++){
			fprintf(fp, "\t%d :\n", i);
			for (int j = 0; j < HEIGHT; j++){
				fprintf(fp, "\t\t");
				for (int k = 0; k < WIDTH; k++)
					fprintf(fp, " "DFMT"", ds->features[i][j][k]);
				fprintf(fp, "\n");
			}
		}
		fclose(fp);

	}

	DTYPE weights2[KERNEL * KERNEL * CHANNEL * OUTSIZE];
	int start[5];
	memset(start, 0, sizeof(start[0]) * 5);
	transformWeights((DTYPE *)weights2, start, (DTYPE *)ds->weights, (DTYPE *)ds->bms, doBM ? BM_NUM : 0, OUTSIZE, CHANNEL, KERNEL, CG_NUM);
	int dropSize;
	int wSize;
	DTYPE *weights3 = transformWeights2((DTYPE *)weights2, MODE_ONE, start, &dropSize, &wSize);

	GlobalInstruction insts[8];
	int idx = 0;
	insts[idx].type = CONV;
	insts[idx].i.inst.mode = MODE_ONE;
	insts[idx].i.inst.maxpool_stride = 1;
	insts[idx].i.inst.maxpool_size = 1;
	insts[idx].i.inst.W2 = WIDTH / 4;
#ifdef BATCH1_OPTIMIZE
	insts[idx].i.inst.doBatch3 = 0;
#endif
	insts[idx].i.inst.progressMaster = 3;
	insts[idx].i.inst.reqSeqNum = 0;
	insts[idx].i.inst.reqSeqNumW = 1;
	insts[idx].i.inst.reqProgressW = 42;
	insts[idx].i.inst.seqNum = 2;
	insts[idx].i.inst.fScale = 0;
	insts[idx].i.inst.wScale = 0;
	insts[idx].i.inst.W = WIDTH;
	insts[idx].i.inst.H = HEIGHT;
	insts[idx].i.inst.C = CHANNEL;
	insts[idx].i.inst.W1 = WIDTH / 4;
	insts[idx].i.inst.H1 = HEIGHT / 4;
	insts[idx].i.inst.Maddr = (ADDR_TYPE)ds->features;
	insts[idx].i.inst.Waddr = (ADDR_TYPE)weights3;
	insts[idx].i.inst.isUseWRam = 0;
	insts[idx].i.inst.wDropSize = dropSize;
	insts[idx].i.inst.WSize = wSize;
	insts[idx].i.inst.Oaddr = (ADDR_TYPE)ds->outputs;
	insts[idx].i.inst.WEnd[0] = KERNEL * KERNEL * CHANNEL * OUTSIZE;;
	insts[idx].i.inst.WEnd[1] = 0;
	insts[idx].i.inst.WEnd[2] = 0;
	insts[idx].i.inst.WEnd[3] = 0;
	insts[idx].i.inst.S = STRIDE;
	insts[idx].i.inst.lPad = 0;
	insts[idx].i.inst.rPad = 0;
	insts[idx].i.inst.K = KERNEL;
	insts[idx].i.inst.M = OUTSIZE; // filter size, filter layers
	insts[idx].i.inst.Kh[0] = 0;
	insts[idx].i.inst.Ks[0] = 0;
	insts[idx].i.inst.Kt[0] = OUTSIZE - 1; // start, stride, and tail(inclusive)
	insts[idx].i.inst.Res_addr = 0;
	//insts[idx].i.inst.BM_addr = (ADDR_TYPE)ds->bms;
	insts[idx].i.inst.wLRelu = wrelu;
	insts[idx].i.inst.isMaddr_a = 0;
	insts[idx].i.inst.isMaddr_b = 0;
	insts[idx].i.inst.isOaddr_a = 0;
	insts[idx].i.inst.isOaddr_b = 0;
	insts[idx].i.inst.isRaddr_a = 0; //for Res
	insts[idx].i.inst.doRes = doRes ? 1 : 0;
	insts[idx].i.inst.doRelu = doRelu ? 1 : 0;
	insts[idx].i.inst.doLRelu = doLRelu ? 1 : 0;
	insts[idx].i.inst.doBM = doBM ? 1 : 0;
	insts[idx].i.inst.doUpSample = doUpsample ? 1 : 0;
	insts[idx].i.inst.isConv = 1;

	idx++;
	insts[idx].type = END;
	insts[idx].i.end.hasMore = 0;
	insts[idx].i.end.isRamA = 0;
	insts[idx].i.end.isRamB = 0;
	insts[idx].i.end.reqSeqNum = 5;

	CModel model;
	model.BuildModel(2, 6);
	model.Run(insts, true);
	int sz = doUpsample ? 2 : 1;
	for (int k = 0; k < OUTSIZE; k++)
		for (int i = 0; i < HEIGHT * sz; i++)
			for (int j = 0; j < WIDTH * sz; j++){
				if (ds->outputs[k][i][j] != ds->expected[k][i][j]) {
					printf("@#!ERROR@#! %d %d %d\n", k, i, j);
					delete ds; return;
				}
				//assert(outputs[k][i][j] == expected[k][i][j]);
			}
	printf("testFeatures40xup_rand pass.  all equal ("DFMT", "DFMT", "DFMT", "DFMT", "DFMT")\n", ds->outputs[0][0][0], ds->outputs[0][0][1]
		, ds->outputs[0][0][2], ds->outputs[0][0][3], ds->outputs[0][0][4]);
	delete ds;
	delete[]weights3;
}
template <int CHANNEL, int OUTSIZE, int WIDTH, int HEIGHT, int KERNEL, int STRIDE>
bool testFeaturesModeFour(int i, DTYPE wrelu)
{
	assert(OUTSIZE * KERNEL >= 48);
	bool doBM = i & 1;
	bool doRelu = i & 8;
	bool doLRelu = i & 2;
	if (doLRelu)
		doRelu = false;
	bool doRes = i & 4;
	const bool doUpsample = false;
	int PAD = KERNEL == 1 ? 0 : 1;
	printf("random test for %dx%d K%d C(%d) O(%d) %s %s %s %s\n",
		WIDTH, HEIGHT, KERNEL, CHANNEL, OUTSIZE, doBM ? "bm" : "", doRelu ? "Relu" : "", doLRelu ? "LRelu" : "", doRes ? "Res" : "");
	CDataSet<CHANNEL, HEIGHT, WIDTH, KERNEL, OUTSIZE, STRIDE, 1, 1> *ds = new CDataSet<CHANNEL, HEIGHT, WIDTH, KERNEL, OUTSIZE, STRIDE, 1, 1>();
	ds->GenData(wrelu, doBM, doRelu, doLRelu, doRes);
	ds->Dump(3, 5, 0, wrelu, doBM, doRelu, doLRelu, doRes); // k, i, j

	DTYPE *weights2 = new DTYPE[KERNEL * KERNEL * CHANNEL * OUTSIZE + OUTSIZE * BM_NUM];
	int start[5], Kh[4], Ks[4], Kt[4], Kbh[4], Kbe[4];
	Kbh[0] = 0;
#ifdef BATCH1_OPTIMIZE
	if (KERNEL == 1 && OUTSIZE > 192)
		transformWeightsBatch((DTYPE *)weights2, start, Kh, Ks, Kt, Kbh, Kbe, (DTYPE *)ds->weights, OUTSIZE, CHANNEL, KERNEL, 4, CG_NUM);
	else
#endif
		transformWeights((DTYPE *)weights2, start, Kh, Ks, Kt, (DTYPE *)ds->weights, (DTYPE *)ds->bms, doBM ? BM_NUM : 0, OUTSIZE, CHANNEL, KERNEL, CG_NUM, CG_NUM, CG_NUM, CG_NUM);
	//start[4] = KERNEL * KERNEL * CHANNEL * OUTSIZE + (OUTSIZE * BM_NUM);
	//printf("start4 %d\n", start[4]);
	int dropSize;
	int wSize;
	DTYPE *weights3 = transformWeights2((DTYPE *)weights2, MODE_FOUR, start, &dropSize, &wSize);

	int rpad = PAD;
	if (((HEIGHT - KERNEL + 2 * PAD) % STRIDE) != 0)
		rpad--;

	GlobalInstruction insts[9];
	int idx = 0;
	insts[idx].type = CONV;
	insts[idx].i.inst.maxpool_stride = 1;
	insts[idx].i.inst.maxpool_size = 1;
	insts[idx].i.inst.W2 = WIDTH;
	insts[idx].i.inst.mode = MODE_FOUR;
	insts[idx].i.inst.fScale = 0;
	insts[idx].i.inst.wScale = 0;
	insts[idx].i.inst.reqSeqNum = 0;
	insts[idx].i.inst.reqSeqNumW = 1;
	insts[idx].i.inst.reqProgressW = 168;// KERNEL * KERNEL * CHANNEL * OUTSIZE;
	insts[idx].i.inst.seqNum = 2;
	insts[idx].i.inst.W = WIDTH;
	insts[idx].i.inst.H = HEIGHT;
	insts[idx].i.inst.C = CHANNEL;
	insts[idx].i.inst.W1 = WIDTH;
	insts[idx].i.inst.H1 = HEIGHT;
#ifdef BATCH1_OPTIMIZE
	if (Kbh[0] == 0)
		insts[idx].i.inst.doBatch3 = 0;
	else{
		insts[idx].i.inst.doBatch3 = 1;
		insts[idx].i.inst.Kbh[0] = Kbh[0];
		insts[idx].i.inst.Kbh[1] = Kbh[1];
		insts[idx].i.inst.Kbh[2] = Kbh[2];
		insts[idx].i.inst.Kbh[3] = Kbh[3];
		insts[idx].i.inst.Kbe[0] = Kbe[0];
		insts[idx].i.inst.Kbe[1] = Kbe[1];
		insts[idx].i.inst.Kbe[2] = Kbe[2];
		insts[idx].i.inst.Kbe[3] = Kbe[3];
		insts[idx].i.inst.batch15 = 0;
		insts[idx].i.inst.batch12 = 0;
		insts[idx].i.inst.batch0 = HEIGHT;
	}
#endif
	insts[idx].i.inst.Maddr = ds->oSize;
	insts[idx].i.inst.Waddr = 0;
	insts[idx].i.inst.isUseWRam = 0;
	insts[idx].i.inst.wDropSize = dropSize;
	insts[idx].i.inst.WSize = wSize;
	insts[idx].i.inst.Oaddr = 0;
	insts[idx].i.inst.WEnd[0] = start[1];
	insts[idx].i.inst.WEnd[1] = start[2];
	insts[idx].i.inst.WEnd[2] = start[3];
	insts[idx].i.inst.WEnd[3] = start[4];
	insts[idx].i.inst.S = STRIDE;
	insts[idx].i.inst.lPad = PAD;
	insts[idx].i.inst.rPad = rpad;
	insts[idx].i.inst.K = KERNEL;
	insts[idx].i.inst.M = OUTSIZE; // filter size, filter layers
	insts[idx].i.inst.Kh[0] = Kh[0];
	insts[idx].i.inst.Ks[0] = Ks[0];
	insts[idx].i.inst.Kt[0] = Kt[0]; // start, stride, and tail(inclusive)
	insts[idx].i.inst.Kh[1] = Kh[1];
	insts[idx].i.inst.Ks[1] = Ks[1];
	insts[idx].i.inst.Kt[1] = Kt[1]; // start, stride, and tail(inclusive)
	insts[idx].i.inst.Kh[2] = Kh[2];
	insts[idx].i.inst.Ks[2] = Ks[2];
	insts[idx].i.inst.Kt[2] = Kt[2]; // start, stride, and tail(inclusive)
	insts[idx].i.inst.Kh[3] = Kh[3];
	insts[idx].i.inst.Ks[3] = Ks[3];
	insts[idx].i.inst.Kt[3] = Kt[3]; // start, stride, and tail(inclusive)
	insts[idx].i.inst.Res_addr = (ADDR_TYPE)(ds->oSize + ds->fSize + ds->bmSize);
	//insts[idx].i.inst.BM_addr = (ADDR_TYPE)(ds->oSize + ds->fSize);
	insts[idx].i.inst.wLRelu = wrelu;
	insts[idx].i.inst.isMaddr_a = 0;
	insts[idx].i.inst.isMaddr_b = 0;
	insts[idx].i.inst.isOaddr_a = 0;
	insts[idx].i.inst.isOaddr_b = 0;
	insts[idx].i.inst.isRaddr_a = 0; //for Res
	
	insts[idx].i.inst.doRes = doRes ? 1 : 0;
	insts[idx].i.inst.doRelu = doRelu ? 1 : 0;
	insts[idx].i.inst.doLRelu = doLRelu ? 1 : 0;
	insts[idx].i.inst.doBM = doBM ? 1 : 0;
	insts[idx].i.inst.doUpSample =  0;
	insts[idx].i.inst.isConv = 1;

	idx++;
	insts[idx].type = END;
	insts[idx].i.end.hasMore = 0;
	insts[idx].i.end.isRamA = 0;
	insts[idx].i.end.isRamB = 0;
	insts[idx].i.end.reqSeqNum = 2;
	insts[idx].i.end.oAddr = 0;
	insts[idx].i.end.oSize = ds->oSize;

	CModelIF model;
	model.BuildModel(2, 15);
	std::map<unsigned, void *> out_mp;
	out_mp[0] = (DTYPE *)ds->outputs;
	model.Run(insts, out_mp, ds->oSize, (unsigned char *)weights3, wSize * sizeof(DTYPE)
		, ds->buf, ds->fSize + ds->bmSize + ds->rSize, true);
	for (int k = 0; k < OUTSIZE; k++)
		for (int i = 0; i < HEIGHT/STRIDE; i++)
			for (int j = 0; j < WIDTH/STRIDE; j++){
				if (!Is_equal(ds->outputs[k][i][j], ds->expected[k][i][j])) {
					printf("@#!ERROR@#! %d %d %d ("DFMT", "DFMT")\n", k, i, j, ds->outputs[k][i][j], ds->expected[k][i][j]);
					delete ds; return false;
				}
				//assert(outputs[k][i][j] == expected[k][i][j]);
			}
	printf("testFeaturesModeFour pass. all equal ("DFMT", "DFMT", "DFMT", "DFMT", "DFMT")\n", ds->outputs[0][0][0], ds->outputs[0][0][1]
		, ds->outputs[0][0][2], ds->outputs[0][0][3], ds->outputs[0][0][4]);
	delete ds;
	delete[]weights2;
	delete[]weights3;
	return true;
}

template <int CHANNEL, int OUTSIZE, int WIDTH, int HEIGHT, int KERNEL, int STRIDE, int WIDTH1, int HEIGHT1>
void testFeaturesModeTwoK7(int i, DTYPE wrelu)
{
	assert(OUTSIZE * KERNEL > CG_NUM);
	bool doBM = i & 1;
	bool doRelu = i & 8;
	bool doLRelu = i & 2;
	if (doLRelu)
		doRelu = false;
	bool doRes = i & 4;
	const bool doUpsample = false;
	int PAD = KERNEL == 1 ? 0 : 1;
	printf("random test for %dx%d K%d C(%d) O(%d) %s %s %s %s\n",
		WIDTH, HEIGHT, KERNEL, CHANNEL, OUTSIZE, doBM ? "bm" : "", doRelu ? "Relu" : "", doLRelu ? "LRelu" : "", doRes ? "Res" : "");
	CDataSet<CHANNEL, HEIGHT, WIDTH, KERNEL, OUTSIZE, STRIDE, 1, 1> *ds = new CDataSet<CHANNEL, HEIGHT, WIDTH, KERNEL, OUTSIZE, STRIDE, 1, 1>();
	ds->GenData(wrelu, doBM, doRelu, doLRelu, doRes);
	ds->Dump(0, 8, 98, wrelu, doBM, doRelu, doLRelu, doRes); // k, i, j

	DTYPE *weights2 = new DTYPE[KERNEL * KERNEL * CHANNEL * OUTSIZE];
	int start[5], Kh[4], Ks[4], Kt[4];
	transformWeights((DTYPE *)weights2, start, Kh, Ks, Kt, (DTYPE *)ds->weights, OUTSIZE, CHANNEL, KERNEL, CG_NUM
		, OUTSIZE * KERNEL - CG_NUM > CG_NUM ? CG_NUM : OUTSIZE * KERNEL - CG_NUM);
	start[2] = KERNEL * KERNEL * CHANNEL * OUTSIZE;
	int dropSize;
	int wSize;
	DTYPE *weights3 = transformWeights2((DTYPE *)weights2, MODE_TWO, start, &dropSize, &wSize);


	GlobalInstruction insts[19];
	int idx = 0;
	insts[idx].type = MEM;
	insts[idx].i.mem.isRamA = 0;
	insts[idx].i.mem.isRead = 1;
	insts[idx].i.mem.len = HEIGHT * WIDTH * OUTSIZE / STRIDE / STRIDE;;
	insts[idx].i.mem.Oaddr = (ADDR_TYPE)ds->res;
	insts[idx].i.mem.Maddr = 0;
	insts[idx].i.mem.reqSeqNum = 0;
	insts[idx].i.mem.isFast = 1;
	insts[idx].i.mem.seqNum = 1;



	idx++;
	insts[idx].type = CONV;
	insts[idx].i.inst.maxpool_stride = 1;
	insts[idx].i.inst.maxpool_size = 1;
	insts[idx].i.inst.W2 = WIDTH1;
	insts[idx].i.inst.mode = MODE_TWO;
#ifdef BATCH1_OPTIMIZE
	insts[idx].i.inst.doBatch3 = 0;
#endif
	insts[idx].i.inst.reqSeqNum = 0;
	insts[idx].i.inst.reqSeqNumW = 1;
	insts[idx].i.inst.reqProgressW = 84;
	insts[idx].i.inst.seqNum = 2;
	insts[idx].i.inst.fScale = 0;
	insts[idx].i.inst.wScale = 0;
	insts[idx].i.inst.W = WIDTH;
	insts[idx].i.inst.H = HEIGHT;
	insts[idx].i.inst.C = CHANNEL;
	insts[idx].i.inst.W1 = WIDTH1;
	insts[idx].i.inst.H1 = HEIGHT1;
	insts[idx].i.inst.Maddr = (ADDR_TYPE)ds->features;
	insts[idx].i.inst.Waddr = (ADDR_TYPE)weights3;
	insts[idx].i.inst.isUseWRam = 0;
	insts[idx].i.inst.wDropSize = dropSize;
	insts[idx].i.inst.WSize = wSize;
	insts[idx].i.inst.Oaddr = (ADDR_TYPE)ds->outputs;
	insts[idx].i.inst.WEnd[0] = start[1];
	insts[idx].i.inst.WEnd[1] = KERNEL * KERNEL * CHANNEL * OUTSIZE;;
	insts[idx].i.inst.WEnd[2] = 0;
	insts[idx].i.inst.WEnd[3] = 0;
	insts[idx].i.inst.S = STRIDE;
	insts[idx].i.inst.lPad = 3;// PAD;
	insts[idx].i.inst.rPad = 2;// PAD;
	insts[idx].i.inst.K = KERNEL;
	insts[idx].i.inst.M = OUTSIZE; // filter size, filter layers
	insts[idx].i.inst.Kh[0] = Kh[0];
	insts[idx].i.inst.Ks[0] = Ks[0];
	insts[idx].i.inst.Kt[0] = Kt[0]; // start, stride, and tail(inclusive)
	insts[idx].i.inst.Kh[1] = Kh[1];
	insts[idx].i.inst.Ks[1] = Ks[1];
	insts[idx].i.inst.Kt[1] = Kt[1]; // start, stride, and tail(inclusive)
	insts[idx].i.inst.Res_addr = 0;
	//insts[idx].i.inst.BM_addr = (ADDR_TYPE)ds->bms;
	insts[idx].i.inst.wLRelu = wrelu;
	insts[idx].i.inst.isMaddr_a = 0;
	insts[idx].i.inst.isMaddr_b = 0;
	insts[idx].i.inst.isOaddr_a = 0;
	insts[idx].i.inst.isOaddr_b = 0;
	insts[idx].i.inst.isRaddr_a = 0; //for Res
	insts[idx].i.inst.doRes = doRes ? 1 : 0;
	insts[idx].i.inst.doRelu = doRelu ? 1 : 0;
	insts[idx].i.inst.doLRelu = doLRelu ? 1 : 0;
	insts[idx].i.inst.doBM = doBM ? 1 : 0;
	insts[idx].i.inst.doUpSample = 0;
	insts[idx].i.inst.isConv = 1;
	insts[idx].i.inst.progressMaster = 0;

	idx++;
	insts[idx].type = END;
	insts[idx].i.end.hasMore = 0;
	insts[idx].i.end.isRamA = 0;
	insts[idx].i.end.isRamB = 0;
	int len = 0;
	len += HEIGHT / HEIGHT1;
	if (HEIGHT % HEIGHT1)
		len++;

	int len1 = WIDTH / WIDTH1;
	if (WIDTH % WIDTH1)
		len1++; 
	insts[idx].i.end.reqSeqNum = 1 + len * len1 / 2;


	CModel model;
	model.BuildModel(12, 15);
	model.Run(insts, true);
	for (int k = 0; k < OUTSIZE; k++)
		for (int i = 0; i < HEIGHT / STRIDE; i++)
			for (int j = 0; j < WIDTH / STRIDE; j++){
				if (!Is_equal(ds->outputs[k][i][j], ds->expected[k][i][j])) {
					printf("@#!ERROR@#! %d %d %d "DFMT" != "DFMT"\n", k, i, j, ds->outputs[k][i][j], ds->expected[k][i][j]);
					{
						FILE *fp = fopen("outputs.txt", "wt");
						for (int k1 = 0; k1 < OUTSIZE; k1++){
							fprintf(fp, "layer %d : \n", k1);
							for (int i1 = 0; i1 < HEIGHT / STRIDE; i1++){
								for (int j1 = 0; j1 < WIDTH / STRIDE; j1++){
									fprintf(fp, "%s"DFMT"", j1 == 0 ? "\t" : " ", ds->outputs[k1][i1][j1]);
								}
								fprintf(fp, "\n");
							}
						}
						fclose(fp);
					}
					delete ds; return;
				}
				//assert(outputs[k][i][j] == expected[k][i][j]);
			}
	printf("testFeaturesModeTwoK7 pass.  all equal ("DFMT", "DFMT", "DFMT", "DFMT", "DFMT")\n", ds->outputs[0][0][0], ds->outputs[0][0][1]
		, ds->outputs[0][0][2], ds->outputs[0][0][3], ds->outputs[0][0][4]);
	delete ds;
	delete[]weights2;
	delete[]weights3;
}

template <int CHANNEL, int OUTSIZE, int WIDTH, int HEIGHT, int KERNEL, int STRIDE, int WIDTH1, int HEIGHT1, int poolStride>
bool testFeaturesModeTwoMaxPool(int i, DTYPE wrelu)
{
	assert(OUTSIZE * KERNEL > CG_NUM);
	bool doBM = i & 1;
	bool doRelu = i & 8;
	bool doLRelu = i & 2;
	if (doLRelu)
		doRelu = false;
	bool doRes = false;// i & 4;
	const bool doUpsample = false;
	int PAD = KERNEL == 1 ? 0 : 1;
	printf("random test for maxpool (s%d) %dx%d K%d C(%d) O(%d) %s %s %s %s\n",
		poolStride, WIDTH, HEIGHT, KERNEL, CHANNEL, OUTSIZE, doBM ? "bm" : "", doRelu ? "Relu" : "", doLRelu ? "LRelu" : "", doRes ? "Res" : "");
	CDataSet<CHANNEL, HEIGHT, WIDTH, KERNEL, OUTSIZE, STRIDE, 1, poolStride> *ds = new CDataSet<CHANNEL, HEIGHT, WIDTH, KERNEL, OUTSIZE, STRIDE, 1, poolStride>();
	ds->GenData(wrelu, doBM, doRelu, doLRelu, doRes, 2);
	ds->Dump(0, 0, 0, wrelu, doBM, doRelu, doLRelu, doRes); // k, i, j

	DTYPE *weights2 = new DTYPE[KERNEL * KERNEL * CHANNEL * OUTSIZE + OUTSIZE * BM_NUM];
	int start[5], Kh[4], Ks[4], Kt[4], Kbh[4], Kbe[4];
	Kbh[0] = 0;
	memset(start, 0, sizeof(start[0]) * 5);
#ifdef BATCH1_OPTIMIZE
	if (KERNEL == 1 && OUTSIZE > 96)
		transformWeightsBatch((DTYPE *)weights2, start, Kh, Ks, Kt, Kbh, Kbe, (DTYPE *)ds->weights, OUTSIZE, CHANNEL, KERNEL, 2, CG_NUM);
	else
#endif
		transformWeights((DTYPE *)weights2, start, Kh, Ks, Kt, (DTYPE *)ds->weights, (DTYPE *)ds->bms, doBM ? BM_NUM : 0, OUTSIZE, CHANNEL, KERNEL, CG_NUM
		, OUTSIZE * KERNEL - CG_NUM > CG_NUM ? CG_NUM : OUTSIZE * KERNEL - CG_NUM);
	//start[2] = KERNEL * KERNEL * CHANNEL * OUTSIZE;
	int dropSize;
	int wSize;
	DTYPE *weights3 = transformWeights2((DTYPE *)weights2, MODE_TWO, start, &dropSize, &wSize);
	int b15, b12, b0;
	GetBatchNum(HEIGHT, b15, b12, b0);

	int rpad = PAD;
	if (((HEIGHT1 - KERNEL + 2 * PAD) % STRIDE) != 0)
		rpad--;

	GlobalInstruction insts[19];
	int idx = 0;
	
	insts[idx].type = CONV;
	insts[idx].i.inst.maxpool_stride = poolStride;
	insts[idx].i.inst.maxpool_size = 2;
	insts[idx].i.inst.W2 = WIDTH - WIDTH1;
	insts[idx].i.inst.mode = MODE_TWO;
	insts[idx].i.inst.reqSeqNum = 0;
	insts[idx].i.inst.reqSeqNumW = 1;
	insts[idx].i.inst.reqProgressW = 84;
	insts[idx].i.inst.seqNum = 2;
	insts[idx].i.inst.fScale = 0;
	insts[idx].i.inst.wScale = 0;
	insts[idx].i.inst.W = WIDTH;
	insts[idx].i.inst.H = HEIGHT;
	insts[idx].i.inst.C = CHANNEL;
	insts[idx].i.inst.W1 = WIDTH1;
	insts[idx].i.inst.H1 = HEIGHT1;
#ifdef BATCH1_OPTIMIZE
	if (Kbh[0] == 0)
		insts[idx].i.inst.doBatch3 = 0;
	else{
		insts[idx].i.inst.doBatch3 = 1;
		insts[idx].i.inst.Kbh[0] = Kbh[0];
		insts[idx].i.inst.Kbh[1] = Kbh[1];
		//insts[idx].i.inst.Kbh[2] = Kbh[2];
		//insts[idx].i.inst.Kbh[3] = Kbh[3];
		insts[idx].i.inst.Kbe[0] = Kbe[0];
		insts[idx].i.inst.Kbe[1] = Kbe[1];
		//insts[idx].i.inst.Kbe[2] = Kbe[2];
		//insts[idx].i.inst.Kbe[3] = Kbe[3];
		insts[idx].i.inst.batch15 = b15;
		insts[idx].i.inst.batch12 = b12;
		insts[idx].i.inst.batch0 = b0;
	}
#endif
	insts[idx].i.inst.Maddr = ds->oSize;;
	insts[idx].i.inst.Waddr = 0;// (ADDR_TYPE)weights3;
	insts[idx].i.inst.isUseWRam = 0;
	insts[idx].i.inst.wDropSize = dropSize;
	insts[idx].i.inst.WSize = wSize;
	insts[idx].i.inst.Oaddr = 0;
	insts[idx].i.inst.WEnd[0] = start[1];
	insts[idx].i.inst.WEnd[1] = start[2];
	insts[idx].i.inst.WEnd[2] = 0;
	insts[idx].i.inst.WEnd[3] = 0;
	insts[idx].i.inst.S = STRIDE;
	insts[idx].i.inst.lPad = PAD;
	insts[idx].i.inst.rPad = rpad;
	insts[idx].i.inst.K = KERNEL;
	insts[idx].i.inst.M = OUTSIZE; // filter size, filter layers
	insts[idx].i.inst.Kh[0] = Kh[0];
	insts[idx].i.inst.Ks[0] = Ks[0];
	insts[idx].i.inst.Kt[0] = Kt[0]; // start, stride, and tail(inclusive)
	insts[idx].i.inst.Kh[1] = Kh[1];
	insts[idx].i.inst.Ks[1] = Ks[1];
	insts[idx].i.inst.Kt[1] = Kt[1]; // start, stride, and tail(inclusive)
	insts[idx].i.inst.Res_addr = (ADDR_TYPE)(ds->oSize + ds->fSize + ds->bmSize);
	//insts[idx].i.inst.BM_addr = (ADDR_TYPE)(ds->oSize + ds->fSize);
	insts[idx].i.inst.wLRelu = wrelu;
	insts[idx].i.inst.isMaddr_a = 0;
	insts[idx].i.inst.isMaddr_b = 0;
	insts[idx].i.inst.isOaddr_a = 0;
	insts[idx].i.inst.isOaddr_b = 0;
	insts[idx].i.inst.isRaddr_a = 0; //for Res
	insts[idx].i.inst.doRes = doRes ? 1 : 0;
	insts[idx].i.inst.doRelu = doRelu ? 1 : 0;
	insts[idx].i.inst.doLRelu = doLRelu ? 1 : 0;
	insts[idx].i.inst.doBM = doBM ? 1 : 0;
	insts[idx].i.inst.doUpSample = 0;
	insts[idx].i.inst.isConv = 1;
	insts[idx].i.inst.progressMaster = 0;

	idx++;
	insts[idx].type = END;
	insts[idx].i.end.hasMore = 0;
	insts[idx].i.end.isRamA = 0;
	insts[idx].i.end.isRamB = 0;
	insts[idx].i.end.oAddr = 0;
	insts[idx].i.end.oSize = ds->oSize;

	int len = 0;
	len += HEIGHT / HEIGHT1;
	if (HEIGHT % HEIGHT1)
		len++;
	int len1 = WIDTH / WIDTH1;
	if (WIDTH % WIDTH1)
		len1++;
	insts[idx].i.end.reqSeqNum = 1 + len * len1 / 2;


	CModelIF model;
	model.BuildModel(12, 15);
	std::map<unsigned, void *> out_mp;
	out_mp[0] = (DTYPE *)ds->outputs;
	model.Run(insts, out_mp, ds->oSize, (unsigned char *)weights3, wSize * sizeof(DTYPE)
		, ds->buf, ds->fSize + ds->bmSize, true);
	for (int k = 0; k < OUTSIZE; k++)
		for (int i = 0; i < HEIGHT / STRIDE / poolStride; i++)
			for (int j = 0; j < WIDTH / STRIDE / poolStride; j++){
				if (!Is_equal(ds->outputs[k][i][j], ds->expected[k][i][j])) {
					printf("@#!ERROR@#! %d %d %d "DFMT" != "DFMT"\n", k, i, j, ds->outputs[k][i][j], ds->expected[k][i][j]);
					{
						FILE *fp = fopen("outputs.txt", "wt");
						for (int k1 = 0; k1 < OUTSIZE; k1++){
							fprintf(fp, "layer %d : \n", k1);
							for (int i1 = 0; i1 < HEIGHT / STRIDE; i1++){
								for (int j1 = 0; j1 < WIDTH / STRIDE; j1++){
									fprintf(fp, "%s"DFMT"", j1 == 0 ? "\t" : " ", ds->outputs[k1][i1][j1]);
								}
								fprintf(fp, "\n");
							}
						}
						fclose(fp);
					}
					delete ds; return false;
				}
				//assert(outputs[k][i][j] == expected[k][i][j]);
			}
	printf("testFeaturesModeTwo pass.  all equal ("DFMT", "DFMT", "DFMT", "DFMT", "DFMT")\n", ds->outputs[0][0][0], ds->outputs[0][0][1]
		, ds->outputs[0][0][2], ds->outputs[0][0][3], ds->outputs[0][0][4]);
	delete ds;
	delete[]weights2;
	delete[]weights3;
	return true;
}

template <int CHANNEL, int OUTSIZE, int WIDTH, int HEIGHT, int KERNEL, int STRIDE, int WIDTH1, int HEIGHT1, bool doUpsample>
bool testFeaturesModeTwo(int i, DTYPE wrelu, bool ups = false)
{
	assert(OUTSIZE * KERNEL > CG_NUM);
	bool doBM = i & 1;
	bool doRelu = i & 8;
	bool doLRelu = i & 2;
	if (doLRelu)
		doRelu = false;
	bool doRes = i & 4;
	//const bool doUpsample = false;
	int PAD = KERNEL == 1 ? 0 : 1;
	printf("random test for %dx%d K%d C(%d) O(%d) %s %s %s %s\n",
		WIDTH, HEIGHT, KERNEL, CHANNEL, OUTSIZE, doBM ? "bm" : "", doRelu ? "Relu" : "", doLRelu ? "LRelu" : "", doRes ? "Res" : "");
	CDataSet<CHANNEL, HEIGHT, WIDTH, KERNEL, OUTSIZE, STRIDE, doUpsample ? 2 : 1, 1> *ds = new CDataSet<CHANNEL, HEIGHT, WIDTH, KERNEL, OUTSIZE, STRIDE, doUpsample ? 2 : 1, 1>();
	ds->GenData(wrelu, doBM, doRelu, doLRelu, doRes);
	ds->Dump(0, 0, 0, wrelu, doBM, doRelu, doLRelu, doRes); // k, i, j
	
	DTYPE *weights2 = new DTYPE[KERNEL * KERNEL * CHANNEL * OUTSIZE + OUTSIZE * BM_NUM];
	int start[5], Kh[4], Ks[4], Kt[4], Kbh[4], Kbe[4];
	Kbh[0] = 0;
	memset(start, 0, sizeof(start[0]) * 5);
#ifdef BATCH1_OPTIMIZE
	if (KERNEL == 1 && OUTSIZE > 96)
		transformWeightsBatch((DTYPE *)weights2, start, Kh, Ks, Kt, Kbh, Kbe, (DTYPE *)ds->weights, OUTSIZE, CHANNEL, KERNEL, 2, CG_NUM);
	else
#endif
		transformWeights((DTYPE *)weights2, start, Kh, Ks, Kt, (DTYPE *)ds->weights, (DTYPE *)ds->bms, doBM ? BM_NUM : 0, OUTSIZE, CHANNEL, KERNEL, CG_NUM
		, OUTSIZE * KERNEL - CG_NUM > CG_NUM ? CG_NUM : OUTSIZE * KERNEL - CG_NUM);
	//start[2] = KERNEL * KERNEL * CHANNEL * OUTSIZE;
	int dropSize;
	int wSize;
	DTYPE *weights3 = transformWeights2((DTYPE *)weights2, MODE_TWO, start, &dropSize, &wSize);
	int b15, b12, b0;
	GetBatchNum(HEIGHT, b15, b12, b0);
	
	int rpad = PAD;
	if (((HEIGHT1 - KERNEL + 2 * PAD) % STRIDE) != 0)
		rpad--;

	GlobalInstruction insts[19];
	int idx = 0;
	
	insts[idx].type = CONV;
	insts[idx].i.inst.maxpool_stride = 1;
	insts[idx].i.inst.maxpool_size = 1;
	insts[idx].i.inst.W2 = WIDTH - WIDTH1;
	insts[idx].i.inst.mode = MODE_TWO;
	insts[idx].i.inst.reqSeqNum = 0;
	insts[idx].i.inst.reqSeqNumW = 1;
	insts[idx].i.inst.reqProgressW = 84;
	insts[idx].i.inst.seqNum = 2;
	insts[idx].i.inst.fScale = 0;
	insts[idx].i.inst.wScale = 0;
	insts[idx].i.inst.W = WIDTH;
	insts[idx].i.inst.H = HEIGHT;
	insts[idx].i.inst.C = CHANNEL;
	insts[idx].i.inst.W1 = WIDTH1;
	insts[idx].i.inst.H1 = HEIGHT1;
#ifdef BATCH1_OPTIMIZE
	if (Kbh[0] == 0)
		insts[idx].i.inst.doBatch3 = 0;
	else{
		insts[idx].i.inst.doBatch3 = 1;
		insts[idx].i.inst.Kbh[0] = Kbh[0];
		insts[idx].i.inst.Kbh[1] = Kbh[1];
		//insts[idx].i.inst.Kbh[2] = Kbh[2];
		//insts[idx].i.inst.Kbh[3] = Kbh[3];
		insts[idx].i.inst.Kbe[0] = Kbe[0];
		insts[idx].i.inst.Kbe[1] = Kbe[1];
		//insts[idx].i.inst.Kbe[2] = Kbe[2];
		//insts[idx].i.inst.Kbe[3] = Kbe[3];
		insts[idx].i.inst.batch15 = b15;
		insts[idx].i.inst.batch12 = b12;
		insts[idx].i.inst.batch0 = b0;
	}
#endif
	insts[idx].i.inst.Maddr = ds->oSize;// (ADDR_TYPE)ds->buf;
	insts[idx].i.inst.Waddr = 0;
	insts[idx].i.inst.isUseWRam = 0;
	insts[idx].i.inst.wDropSize = dropSize;
	insts[idx].i.inst.WSize = wSize;
	insts[idx].i.inst.Oaddr = 0;
	insts[idx].i.inst.WEnd[0] = start[1];
	insts[idx].i.inst.WEnd[1] = start[2];
	insts[idx].i.inst.WEnd[2] = 0;
	insts[idx].i.inst.WEnd[3] = 0;
	insts[idx].i.inst.S = STRIDE;
	insts[idx].i.inst.lPad = PAD;
	insts[idx].i.inst.rPad = rpad;
	insts[idx].i.inst.K = KERNEL;
	insts[idx].i.inst.M = OUTSIZE; // filter size, filter layers
	insts[idx].i.inst.Kh[0] = Kh[0];
	insts[idx].i.inst.Ks[0] = Ks[0];
	insts[idx].i.inst.Kt[0] = Kt[0]; // start, stride, and tail(inclusive)
	insts[idx].i.inst.Kh[1] = Kh[1];
	insts[idx].i.inst.Ks[1] = Ks[1];
	insts[idx].i.inst.Kt[1] = Kt[1]; // start, stride, and tail(inclusive)
	insts[idx].i.inst.Res_addr = (ADDR_TYPE)(ds->oSize + ds->fSize + ds->bmSize);
	//insts[idx].i.inst.BM_addr = (ADDR_TYPE)(ds->oSize + ds->fSize);
	insts[idx].i.inst.wLRelu = wrelu;
	insts[idx].i.inst.isMaddr_a = 0;
	insts[idx].i.inst.isMaddr_b = 0;
	insts[idx].i.inst.isOaddr_a = 0;
	insts[idx].i.inst.isOaddr_b = 0;
	insts[idx].i.inst.isRaddr_a = 0; //for Res
	insts[idx].i.inst.doRes = doRes ? 1 : 0;
	insts[idx].i.inst.doRelu = doRelu ? 1 : 0;
	insts[idx].i.inst.doLRelu = doLRelu ? 1 : 0;
	insts[idx].i.inst.doBM = doBM ? 1 : 0;
	insts[idx].i.inst.doUpSample = doUpsample;
	insts[idx].i.inst.isConv = 1;
	insts[idx].i.inst.progressMaster = 0;

	idx++;
	insts[idx].type = END;
	insts[idx].i.end.hasMore = 0;
	insts[idx].i.end.isRamA = 0;
	insts[idx].i.end.isRamB = 0;
	insts[idx].i.end.oAddr = 0;
	insts[idx].i.end.oSize = ds->oSize;
	int len = 0;
	len += HEIGHT / HEIGHT1;
	if (HEIGHT % HEIGHT1)
		len++;
	int len1 = WIDTH / WIDTH1;
	if (WIDTH % WIDTH1)
		len1++;
	insts[idx].i.end.reqSeqNum = 1 + len * len1 / 2;


	CModelIF model;
	model.BuildModel(12, 15);
	std::map<unsigned, void *> out_mp;
	out_mp[0] = (DTYPE *)ds->outputs;
	model.Run(insts, out_mp, ds->oSize, (unsigned char *)weights3, wSize * sizeof(DTYPE)
		, ds->buf, ds->fSize + ds->bmSize + ds->rSize, true);
	int sz = doUpsample ? 2 : 1;
	for (int k = 0; k < OUTSIZE; k++)
		for (int i = 0; i < HEIGHT*sz/STRIDE; i++)
			for (int j = 0; j < WIDTH*sz / STRIDE; j++){
				if (!Is_equal(ds->outputs[k][i][j], ds->expected[k][i][j])) {
					printf("@#!ERROR@#! %d %d %d "DFMT" != "DFMT"\n", k, i, j, ds->outputs[k][i][j], ds->expected[k][i][j]);
					{
						FILE *fp = fopen("outputs.txt", "wt");
						for (int k1 = 0; k1 < OUTSIZE; k1++){
							fprintf(fp, "layer %d : \n", k1);
							for (int i1 = 0; i1 < HEIGHT / STRIDE; i1++){
								for (int j1 = 0; j1 < WIDTH / STRIDE; j1++){
									fprintf(fp, "%s"DFMT"", j1 == 0 ? "\t" : " ", ds->outputs[k1][i1][j1]);
								}
								fprintf(fp, "\n");
							}
						}
						fclose(fp);
					}
					delete ds; return false;
				}
				//assert(outputs[k][i][j] == expected[k][i][j]);
			}
	printf("testFeaturesModeTwo pass.  all equal ("DFMT", "DFMT", "DFMT", "DFMT", "DFMT")\n", ds->outputs[0][0][0], ds->outputs[0][0][1]
		, ds->outputs[0][0][2], ds->outputs[0][0][3], ds->outputs[0][0][4]);
	delete ds;
	delete[]weights2;
	delete[]weights3;
	return true;
}

template <int CHANNEL>
void test20x20K1S1(int i)
{
	bool doBM = i & 1;
	bool doRelu = i & 8;
	bool doLRelu = i & 2;
	if (doLRelu)
		doRelu = false;
	bool doRes = i & 4;
	printf("random test for 20x20 K1 C(%d) %s %s %s %s\n", CHANNEL, doBM ? "bm" : "", doRelu ? "Relu" : "", doLRelu ? "LRelu" : "", doRes ? "Res" : "");
	//const int CHANNEL = 10;
	const int OUTSIZE = 256;
	//const int OUTSIZE = 128;
	const int WIDTH = 20;
	const int HEIGHT = 20;
	const int KERNEL = 1;
	DTYPE wrelu = 2;
	CDataSet<CHANNEL, HEIGHT, WIDTH, KERNEL, OUTSIZE, 1, 1, 1> *ds = new CDataSet<CHANNEL, HEIGHT, WIDTH, KERNEL, OUTSIZE, 1, 1, 1>();
	ds->GenData(wrelu, doBM, doRelu, doLRelu, doRes);

	DTYPE *weights2 = new DTYPE[KERNEL * KERNEL * CHANNEL * OUTSIZE];
	int start[5], Kh[4], Ks[4], Kt[4];
	memset(start, 0, sizeof(start[0]) * 5);
	transformWeights((DTYPE *)weights2, start, Kh, Ks, Kt, (DTYPE *)ds->weights, OUTSIZE, CHANNEL, KERNEL, CG_NUM
		, OUTSIZE - CG_NUM > CG_NUM ? CG_NUM : OUTSIZE - CG_NUM);
	start[2] = KERNEL * KERNEL * CHANNEL * OUTSIZE;
	int dropSize;
	int wSize;
	DTYPE *weights3 = transformWeights2((DTYPE *)weights2, MODE_TWO, start, &dropSize, &wSize);

	{
		FILE *fp = fopen("data.txt", "wt");
		fprintf(fp, "weight :\n");
		for (int i = 0; i < OUTSIZE; i++){
			fprintf(fp, "\t%d :", i);
			for (int j = 0; j < CHANNEL; j++)
				fprintf(fp, " "DFMT"", ds->weights[i][j][0][0]);
			fprintf(fp, "\n");
		}

		fprintf(fp, "features :\n");
		for (int i = 0; i < CHANNEL; i++){
			fprintf(fp, "\t%d :\n", i);
			for (int j = 0; j < 10; j++){
				fprintf(fp, "\t\t");
				for (int k = 0; k < 10; k++)
					fprintf(fp, " "DFMT"", ds->features[i][j][k]);
				fprintf(fp, "\n");
			}
		}
		fclose(fp);

	}
	GlobalInstruction insts[19];
	int idx = 0;
	insts[idx].type = MEM;
	insts[idx].i.mem.isRamA = 0;
	insts[idx].i.mem.isRead = 1;
	insts[idx].i.mem.len = HEIGHT * WIDTH * OUTSIZE;;
	insts[idx].i.mem.Oaddr = (ADDR_TYPE)ds->res;
	insts[idx].i.mem.Maddr = 0;
	insts[idx].i.mem.reqSeqNum = 0;
	insts[idx].i.mem.isFast = 1;
	insts[idx].i.mem.seqNum = 1;
	


	idx++;
	insts[idx].type = CONV;
	insts[idx].i.inst.maxpool_stride = 1;
	insts[idx].i.inst.maxpool_size = 1;
	insts[idx].i.inst.W2 = WIDTH / 2;
	insts[idx].i.inst.mode = MODE_TWO;
#ifdef BATCH1_OPTIMIZE
	insts[idx].i.inst.doBatch3 = 0;
#endif
	insts[idx].i.inst.reqSeqNum = 0;
	insts[idx].i.inst.reqSeqNumW = 1;
	insts[idx].i.inst.reqProgressW = 84;
	insts[idx].i.inst.seqNum = 2;
	insts[idx].i.inst.fScale = 0;
	insts[idx].i.inst.wScale = 0;
	insts[idx].i.inst.W = WIDTH;
	insts[idx].i.inst.H = HEIGHT;
	insts[idx].i.inst.C = CHANNEL;
	insts[idx].i.inst.W1 = WIDTH / 2;
	insts[idx].i.inst.H1 = HEIGHT / 2;
	insts[idx].i.inst.Maddr = (ADDR_TYPE)ds->features;
	insts[idx].i.inst.Waddr = (ADDR_TYPE)weights3;
	insts[idx].i.inst.isUseWRam = 0;
	insts[idx].i.inst.wDropSize = dropSize;
	insts[idx].i.inst.WSize = wSize;
	insts[idx].i.inst.Oaddr = (ADDR_TYPE)ds->outputs;
	insts[idx].i.inst.WEnd[0] = start[1];
	insts[idx].i.inst.WEnd[1] = KERNEL * KERNEL * CHANNEL * OUTSIZE;;
	insts[idx].i.inst.WEnd[2] = 0;
	insts[idx].i.inst.WEnd[3] = 0;
	insts[idx].i.inst.S = 1;
	insts[idx].i.inst.lPad = 0;
	insts[idx].i.inst.rPad = 0;
	insts[idx].i.inst.K = KERNEL;
	insts[idx].i.inst.M = OUTSIZE; // filter size, filter layers
	insts[idx].i.inst.Kh[0] = Kh[0];
	insts[idx].i.inst.Ks[0] = Ks[0];
	insts[idx].i.inst.Kt[0] = Kt[0]; // start, stride, and tail(inclusive)
	insts[idx].i.inst.Kh[1] = Kh[1];
	insts[idx].i.inst.Ks[1] = Ks[1];
	insts[idx].i.inst.Kt[1] = Kt[1]; // start, stride, and tail(inclusive)
	insts[idx].i.inst.Res_addr = 0;
	//insts[idx].i.inst.BM_addr = (ADDR_TYPE)ds->bms;
	insts[idx].i.inst.wLRelu = wrelu;
	insts[idx].i.inst.isMaddr_a = 0;
	insts[idx].i.inst.isMaddr_b = 0;
	insts[idx].i.inst.isOaddr_a = 0;
	insts[idx].i.inst.isOaddr_b = 0;
	insts[idx].i.inst.isRaddr_a = 0; //for Res
	insts[idx].i.inst.doRes = doRes ? 1 : 0;
	insts[idx].i.inst.doRelu = doRelu ? 1 : 0;
	insts[idx].i.inst.doLRelu = doLRelu ? 1 : 0;
	insts[idx].i.inst.doBM = doBM ? 1 : 0;
	insts[idx].i.inst.doUpSample = 0;
	insts[idx].i.inst.isConv = 1;
	insts[idx].i.inst.progressMaster = 0;

	idx++;
	insts[idx].type = END;
	insts[idx].i.end.hasMore = 0;
	insts[idx].i.end.isRamA = 0;
	insts[idx].i.end.isRamB = 0;
	insts[idx].i.end.reqSeqNum = 3;


	CModel model;
	model.BuildModel(12, 15);
	model.Run(insts, true);
	for (int k = 0; k < OUTSIZE; k++)
		for (int i = 0; i < HEIGHT; i++)
			for (int j = 0; j < WIDTH; j++){
				if (ds->outputs[k][i][j] != ds->expected[k][i][j]) {
					printf("@#!ERROR@#! %d %d %d\n", k, i, j);
					delete ds; return;
				}
				//assert(outputs[k][i][j] == expected[k][i][j]);
			}
	printf("test20x20K1S1 pass.  all equal ("DFMT", "DFMT", "DFMT", "DFMT", "DFMT")\n", ds->outputs[0][0][0], ds->outputs[0][0][1]
		, ds->outputs[0][0][2], ds->outputs[0][0][3], ds->outputs[0][0][4]);
	delete ds;
	delete[]weights2;
	delete[]weights3;
}


void test20x20K3S1(int i)
{
	//const int CHANNEL = 8;
	//const int OUTSIZE = 512;
	const int CHANNEL = 256;
	const int OUTSIZE = 512;
	const int WIDTH = 20;
	const int HEIGHT = 20;
	const int KERNEL = 3;
	bool doBM = i & 1;
	bool doRelu = i & 8;
	bool doLRelu = i & 2;
	if (doLRelu)
		doRelu = false;
	bool doRes = i & 4;
	printf("random test for 20x20 K3S1  %s %s %s %s\n", doBM ? "bm" : "", doRelu ? "Relu" : "", doLRelu ? "LRelu" : "", doRes ? "Res" : "");
	DTYPE wrelu = 2;
	CDataSet<CHANNEL, HEIGHT, WIDTH, KERNEL, OUTSIZE, 1, 1, 1> *ds = new CDataSet<CHANNEL, HEIGHT, WIDTH, KERNEL, OUTSIZE, 1, 1, 1>();
	ds->GenData(wrelu, doBM, doRelu, doLRelu, doRes);
	
	DTYPE *weights2 = new DTYPE[KERNEL * KERNEL * CHANNEL * OUTSIZE];
	int start[5], Kh[3], Ks[3], Kt[3];
	memset(start, 0, sizeof(start[0]) * 5);
	transformWeights((DTYPE *)weights2, start, Kh, Ks, Kt, (DTYPE *)ds->weights, (DTYPE *)ds->bms, doBM ? BM_NUM : 0, OUTSIZE, CHANNEL, KERNEL, CG_NUM
		, OUTSIZE*3 - CG_NUM > CG_NUM ? CG_NUM : OUTSIZE*3 - CG_NUM);
	start[2] = KERNEL * KERNEL * CHANNEL * OUTSIZE;
	int dropSize;
	int wSize;
	DTYPE *weights3 = transformWeights2((DTYPE *)weights2, MODE_TWO, start, &dropSize, &wSize);


	GlobalInstruction insts[19];
	int idx = 0;
	insts[idx].type = MEM;
	insts[idx].i.mem.isRamA = 0;
	insts[idx].i.mem.isRead = 1;
	insts[idx].i.mem.len = HEIGHT * WIDTH * OUTSIZE;;
	insts[idx].i.mem.Oaddr = (ADDR_TYPE)ds->res;
	insts[idx].i.mem.Maddr = 0;
	insts[idx].i.mem.reqSeqNum = 0;
	insts[idx].i.mem.isFast = 1;
	insts[idx].i.mem.seqNum = 1;
	

	
	idx++;
	insts[idx].type = CONV;
	insts[idx].i.inst.maxpool_stride = 1;
	insts[idx].i.inst.maxpool_size = 1;
	insts[idx].i.inst.W2 = WIDTH / 2;
	insts[idx].i.inst.mode = MODE_TWO;
#ifdef BATCH1_OPTIMIZE
	insts[idx].i.inst.doBatch3 = 0;
#endif
	insts[idx].i.inst.reqSeqNum = 0;
	insts[idx].i.inst.reqSeqNumW = 1;
	insts[idx].i.inst.reqProgressW = 84;
	insts[idx].i.inst.seqNum = 2;
	insts[idx].i.inst.fScale = 0;
	insts[idx].i.inst.wScale = 0;
	insts[idx].i.inst.W = WIDTH;
	insts[idx].i.inst.H = HEIGHT;
	insts[idx].i.inst.C = CHANNEL;
	insts[idx].i.inst.W1 = WIDTH / 2;
	insts[idx].i.inst.H1 = HEIGHT / 2;
	insts[idx].i.inst.Maddr = (ADDR_TYPE)ds->features;
	insts[idx].i.inst.Waddr = (ADDR_TYPE)weights3;
	insts[idx].i.inst.isUseWRam = 0;
	insts[idx].i.inst.wDropSize = dropSize;
	insts[idx].i.inst.WSize = wSize;
	insts[idx].i.inst.Oaddr = (ADDR_TYPE)ds->outputs;
	insts[idx].i.inst.WEnd[0] = start[1];
	insts[idx].i.inst.WEnd[1] = KERNEL * KERNEL * CHANNEL * OUTSIZE;;
	insts[idx].i.inst.WEnd[2] = 0;
	insts[idx].i.inst.WEnd[3] = 0;
	insts[idx].i.inst.S = 1;
	insts[idx].i.inst.lPad = 1;
	insts[idx].i.inst.rPad = 1;
	insts[idx].i.inst.K = KERNEL;
	insts[idx].i.inst.M = OUTSIZE; // filter size, filter layers
	insts[idx].i.inst.Kh[0] = Kh[0];
	insts[idx].i.inst.Ks[0] = Ks[0];
	insts[idx].i.inst.Kt[0] = Kt[0]; // start, stride, and tail(inclusive)
	insts[idx].i.inst.Kh[1] = Kh[1];
	insts[idx].i.inst.Ks[1] = Ks[1];
	insts[idx].i.inst.Kt[1] = Kt[1]; // start, stride, and tail(inclusive)
	insts[idx].i.inst.Res_addr = 0;
	//insts[idx].i.inst.BM_addr = (ADDR_TYPE)ds->bms;
	insts[idx].i.inst.wLRelu = wrelu;
	insts[idx].i.inst.isMaddr_a = 0;
	insts[idx].i.inst.isMaddr_b = 0;
	insts[idx].i.inst.isOaddr_a = 0;
	insts[idx].i.inst.isOaddr_b = 0;
	insts[idx].i.inst.isRaddr_a = 0; //for Res
	insts[idx].i.inst.doRes = doRes ? 1 : 0;
	insts[idx].i.inst.doRelu = doRelu ? 1 : 0;
	insts[idx].i.inst.doLRelu = doLRelu ? 1 : 0;
	insts[idx].i.inst.doBM = doBM ? 1 : 0;
	insts[idx].i.inst.doUpSample = 0;
	insts[idx].i.inst.isConv = 1;
	insts[idx].i.inst.progressMaster = 0;

	idx++;
	insts[idx].type = END;
	insts[idx].i.end.hasMore = 0;
	insts[idx].i.end.isRamA = 0;
	insts[idx].i.end.isRamB = 0;
	insts[idx].i.end.reqSeqNum = 3;
	
	CModel model;
	model.BuildModel(12, 15);
	model.Run(insts, false);
	for (int k = 0; k < OUTSIZE; k++)
		for (int i = 0; i < HEIGHT; i++)
			for (int j = 0; j < WIDTH; j++){
				if (ds->outputs[k][i][j] != ds->expected[k][i][j]) {
					printf("@#!ERROR@#! %d %d %d "DFMT" != "DFMT"\n", k, i, j, ds->outputs[k][i][j], ds->expected[k][i][j]);
					delete ds; return;
				}
				//assert(outputs[k][i][j] == expected[k][i][j]);
			}
	printf("test20x20K3S1 pass.  all equal ("DFMT", "DFMT", "DFMT", "DFMT", "DFMT")\n", ds->outputs[0][0][0], ds->outputs[0][0][1]
		, ds->outputs[0][0][2], ds->outputs[0][0][3], ds->outputs[0][0][4]);
	delete ds;
	delete[]weights2;
	delete[]weights3;
}


void test20x20K3S2(int i)
{
	bool doBM = i & 1;
	bool doRelu = i & 8;
	bool doLRelu = i & 2;
	if (doLRelu)
		doRelu = false;
	bool doRes = i & 4;
	printf("random test 20x20 K3S2 %s %s %s %s\n", doBM ? "bm" : "", doRelu ? "Relu" : "", doLRelu ? "LRelu" : "", doRes ? "Res" : "");
	const int CHANNEL = 512;
	const int OUTSIZE = 1024;
	//const int CHANNEL = 8;
	//const int OUTSIZE = 128;
	const int WIDTH = 20;
	const int HEIGHT = 20;
	const int KERNEL = 3;
	DTYPE wrelu = 2;
	//printf("check1\n"); fflush(stdout);
	CDataSet<CHANNEL, HEIGHT, WIDTH, KERNEL, OUTSIZE, 2, 1, 1> *ds = new CDataSet<CHANNEL, HEIGHT, WIDTH, KERNEL, OUTSIZE, 2, 1, 1>();
	//printf("check2\n"); fflush(stdout);
	ds->GenData(wrelu, doBM, doRelu, doLRelu, doRes);
	//printf("check3\n"); fflush(stdout);
	DTYPE *weights2 = new DTYPE[KERNEL * KERNEL * CHANNEL * OUTSIZE];
	int start[5], Kh[3], Ks[3], Kt[3];
	memset(start, 0, sizeof(start[0]) * 5);
	transformWeights((DTYPE *)weights2, start, Kh, Ks, Kt, (DTYPE *)ds->weights, (DTYPE *)ds->bms, doBM ? BM_NUM : 0, OUTSIZE, CHANNEL, KERNEL, CG_NUM
		, OUTSIZE * 3 - CG_NUM > CG_NUM ? CG_NUM : OUTSIZE * 3 - CG_NUM);
	//printf("check4\n"); fflush(stdout);
	start[2] = KERNEL * KERNEL * CHANNEL * OUTSIZE;
	int dropSize;
	int wSize;
	DTYPE *weights3 = transformWeights2((DTYPE *)weights2, MODE_TWO, start, &dropSize, &wSize);

	{
		int M = 96, Y = 0, X = 4;
		Y *= 2;
		X *= 2;
		FILE *fp = fopen("data.txt", "wt");
		DTYPE o = 0;
		for (int c = 0; c < CHANNEL; c++){
			fprintf(fp, "c = %d :", c);
			DTYPE p = 0;
			for (int i = -1; i <= 1; i++){
				for (int j = -1; j <= 1; j++){
					int x = X + j;
					int y = Y + i;
					DTYPE val = 0;
					if (x >= 0 && x < WIDTH && y >= 0 && y < HEIGHT)
						val = ds->features[c][y][x];
					DTYPE w = ds->weights[M][c][i + 1][j + 1];
					fprintf(fp, " "DFMT"("DFMT")", val, w);
					p += val * w;
				}
				fprintf(fp, ",");
			}
			
			o += p;
			fprintf(fp, "   "DFMT" "DFMT"\n", p, o);
		}
		fclose(fp);
	}
	//printf("check5\n"); fflush(stdout);
	GlobalInstruction insts[19];
	int idx = 0;
	
	insts[idx].type = MEM;
	insts[idx].i.mem.isRamA = 0;
	insts[idx].i.mem.isRead = 1;
	insts[idx].i.mem.len = HEIGHT * WIDTH * OUTSIZE/2/2;
	insts[idx].i.mem.Oaddr = (ADDR_TYPE)ds->res;
	insts[idx].i.mem.Maddr = 0;
	insts[idx].i.mem.reqSeqNum = 0;
	insts[idx].i.mem.isFast = 1;
	insts[idx].i.mem.seqNum = 1;
	

	idx++;
	insts[idx].type = CONV;
	insts[idx].i.inst.maxpool_stride = 1;
	insts[idx].i.inst.maxpool_size = 1;
	insts[idx].i.inst.W2 = WIDTH / 2;
	insts[idx].i.inst.mode = MODE_TWO;
#ifdef BATCH1_OPTIMIZE
	insts[idx].i.inst.doBatch3 = 0;
#endif
	insts[idx].i.inst.reqSeqNum = 0;
	insts[idx].i.inst.reqSeqNumW = 1;
	insts[idx].i.inst.reqProgressW = 84;
	insts[idx].i.inst.seqNum = 2;
	insts[idx].i.inst.fScale = 0;
	insts[idx].i.inst.wScale = 0;
	insts[idx].i.inst.W = WIDTH;
	insts[idx].i.inst.H = HEIGHT;
	insts[idx].i.inst.C = CHANNEL;
	insts[idx].i.inst.W1 = WIDTH / 2;
	insts[idx].i.inst.H1 = HEIGHT / 2;
	insts[idx].i.inst.Maddr = (ADDR_TYPE)ds->features;
	insts[idx].i.inst.Waddr = (ADDR_TYPE)weights3;
	insts[idx].i.inst.isUseWRam = 0;
	insts[idx].i.inst.wDropSize = dropSize;
	insts[idx].i.inst.WSize = wSize;
	insts[idx].i.inst.Oaddr = (ADDR_TYPE)ds->outputs;
	insts[idx].i.inst.WEnd[0] = start[1];
	insts[idx].i.inst.WEnd[1] = KERNEL * KERNEL * CHANNEL * OUTSIZE;;
	insts[idx].i.inst.WEnd[2] = 0;
	insts[idx].i.inst.WEnd[3] = 0;
	insts[idx].i.inst.S = 2;
	insts[idx].i.inst.lPad = 1;
	insts[idx].i.inst.rPad = 0;
	insts[idx].i.inst.K = KERNEL;
	insts[idx].i.inst.M = OUTSIZE; // filter size, filter layers
	insts[idx].i.inst.Kh[0] = Kh[0];
	insts[idx].i.inst.Ks[0] = Ks[0];
	insts[idx].i.inst.Kt[0] = Kt[0]; // start, stride, and tail(inclusive)
	insts[idx].i.inst.Kh[1] = Kh[1];
	insts[idx].i.inst.Ks[1] = Ks[1];
	insts[idx].i.inst.Kt[1] = Kt[1]; // start, stride, and tail(inclusive)
	insts[idx].i.inst.Res_addr = 0;
	//insts[idx].i.inst.BM_addr = (ADDR_TYPE)ds->bms;
	insts[idx].i.inst.wLRelu = wrelu;
	insts[idx].i.inst.isMaddr_a = 0;
	insts[idx].i.inst.isMaddr_b = 0;
	insts[idx].i.inst.isOaddr_a = 0;
	insts[idx].i.inst.isOaddr_b = 0;
	insts[idx].i.inst.isRaddr_a = 0; //for Res
	insts[idx].i.inst.doRes = doRes ? 1 : 0;
	insts[idx].i.inst.doRelu = doRelu ? 1 : 0;
	insts[idx].i.inst.doLRelu = doLRelu ? 1 : 0;
	insts[idx].i.inst.doBM = doBM ? 1 : 0;
	insts[idx].i.inst.doUpSample = 0;
	insts[idx].i.inst.isConv = 1;
	insts[idx].i.inst.progressMaster = 0;

	idx++;
	insts[idx].type = END;
	insts[idx].i.end.hasMore = 0;
	insts[idx].i.end.isRamA = 0;
	insts[idx].i.end.isRamB = 0;
	insts[idx].i.end.reqSeqNum = 3;

	CModel model;
	//printf("check6\n"); fflush(stdout);
	model.BuildModel(12, 15);
	//printf("check7\n"); fflush(stdout);
	model.Run(insts, true);
	//printf("check8\n"); fflush(stdout);
	for (int k = 0; k < OUTSIZE; k++)
		for (int i = 0; i < HEIGHT / 2; i++)
			for (int j = 0; j < WIDTH / 2; j++){
				if (ds->outputs[k][i][j] != ds->expected[k][i][j]) {
					printf("@#!ERROR@#! %d %d %d\n", k, i, j); 
					delete ds; return;
				}
				//assert(outputs[k][i][j] == expected[k][i][j]);
			}
	printf("test20x20K3S2 pass.  all equal ("DFMT", "DFMT", "DFMT", "DFMT", "DFMT")\n", ds->outputs[0][0][0], ds->outputs[0][0][1]
		, ds->outputs[0][0][2], ds->outputs[0][0][3], ds->outputs[0][0][4]);
	delete ds;
	delete[]weights2;
}

template <int CHANNEL, int OUTSIZE, int WIDTH, int HEIGHT, int KERNEL, int STRIDE, int WIDTH1, int HEIGHT1, int poolStride>
bool testFeaturesModeOneMaxPool(int i, DTYPE wrelu, bool genW2 = false)
{
	bool doBM = i & 1;
	bool doRelu = i & 8;
	bool doLRelu = i & 2;
	if (doLRelu)
		doRelu = false;
	bool doRes = false;// i & 4;
	int PAD = KERNEL == 1 ? 0 : 1;
	printf("random test for maxpool %dx%d K%d C(%d) O(%d) %s %s %s %s\n",
		WIDTH, HEIGHT, KERNEL, CHANNEL, OUTSIZE, doBM ? "bm" : "", doRelu ? "Relu" : "", doLRelu ? "LRelu" : "", doRes ? "Res" : "");

	const bool doUpsample = false;
	//DTYPE wrelu = 2;
	CDataSet<CHANNEL, HEIGHT, WIDTH, KERNEL, OUTSIZE, STRIDE, doUpsample ? 2 : 1, poolStride> *ds
		= new CDataSet<CHANNEL, HEIGHT, WIDTH, KERNEL, OUTSIZE, STRIDE, doUpsample ? 2 : 1, poolStride>();
	ds->GenData(wrelu, doBM, doRelu, doLRelu, doRes, 2);
	ds->Dump(0, 0, 0, wrelu, doBM, doRelu, doLRelu, doRes); // k, i, j

	DTYPE *weights2 = new DTYPE[KERNEL * KERNEL * CHANNEL * OUTSIZE + OUTSIZE * BM_NUM];
	int start[5], Kh[4], Ks[4], Kt[4], Kbh[4], Kbe[4];
	Kbh[0] = 0;
	Kt[0] = OUTSIZE - 1;
	memset(start, 0, sizeof(start[0]) * 5);
#ifdef BATCH1_OPTIMIZE
	if (KERNEL == 1 && OUTSIZE > CG_NUM)
		transformWeightsBatch((DTYPE *)weights2, start, Kh, Ks, Kt, Kbh, Kbe, (DTYPE *)ds->weights, OUTSIZE, CHANNEL, KERNEL, 1, CG_NUM);
	else
#endif	
		transformWeights((DTYPE *)weights2, start, (DTYPE *)ds->weights, (DTYPE *)ds->bms, doBM ? BM_NUM : 0, OUTSIZE, CHANNEL, KERNEL, OUTSIZE * KERNEL > CG_NUM ? CG_NUM : OUTSIZE * KERNEL);
	
	//start[1] = KERNEL * KERNEL * CHANNEL * OUTSIZE;
	int dropSize;
	int wSize;
	DTYPE *weights3 = transformWeights2((DTYPE *)weights2, MODE_ONE, start, &dropSize, &wSize);
	int b15, b12, b0;
	GetBatchNum(HEIGHT, b15, b12, b0);

	int rpad = PAD;
	if (((HEIGHT1 - KERNEL + 2 * PAD) % STRIDE) != 0)
		rpad--;
	int w2 = WIDTH1 * 4;
	if (WIDTH % w2 == 0)
		w2 = WIDTH1;
	else
		w2 = (WIDTH % w2) - WIDTH1 * 3;
	
	if (!genW2)
		w2 = 0;
	else
		assert(w2 > 0);
	GlobalInstruction insts[8];
	int idx = 0;

	
	insts[idx].type = CONV;
	insts[idx].i.inst.maxpool_stride = poolStride;
	insts[idx].i.inst.maxpool_size = 2;
	insts[idx].i.inst.W2 = w2;
	insts[idx].i.inst.mode = MODE_ONE;
	insts[idx].i.inst.progressMaster = 3;
	insts[idx].i.inst.reqSeqNum = 0;
	insts[idx].i.inst.reqSeqNumW = 1;
	insts[idx].i.inst.reqProgressW = 42;
	insts[idx].i.inst.seqNum = 2;
	insts[idx].i.inst.fScale = 0;
	insts[idx].i.inst.wScale = 0;
	insts[idx].i.inst.W = WIDTH;
	insts[idx].i.inst.H = HEIGHT;
	insts[idx].i.inst.C = CHANNEL;
	insts[idx].i.inst.W1 = WIDTH1;
	insts[idx].i.inst.H1 = HEIGHT1;
#ifdef BATCH1_OPTIMIZE
	if (Kbh[0] == 0)
		insts[idx].i.inst.doBatch3 = 0;
	else{
		insts[idx].i.inst.doBatch3 = 1;
		insts[idx].i.inst.Kbh[0] = Kbh[0];
		insts[idx].i.inst.Kbe[0] = Kbe[0];
		insts[idx].i.inst.batch15 = b15;
		insts[idx].i.inst.batch12 = b12;
		insts[idx].i.inst.batch0 = b0;
	}
#endif
	insts[idx].i.inst.Maddr = ds->oSize;// (ADDR_TYPE)ds->buf;
	insts[idx].i.inst.Waddr = 0;// (ADDR_TYPE)weights3;
	insts[idx].i.inst.isUseWRam = 0;
	insts[idx].i.inst.wDropSize = dropSize;
	insts[idx].i.inst.WSize = wSize;
	insts[idx].i.inst.Oaddr = 0;// (ADDR_TYPE)ds->outputs;
	insts[idx].i.inst.WEnd[0] = start[1];
	insts[idx].i.inst.WEnd[1] = 0;
	insts[idx].i.inst.WEnd[2] = 0;
	insts[idx].i.inst.WEnd[3] = 0;
	insts[idx].i.inst.S = STRIDE;
	insts[idx].i.inst.lPad = PAD;
	insts[idx].i.inst.rPad = rpad;
	insts[idx].i.inst.K = KERNEL;
	insts[idx].i.inst.M = OUTSIZE; // filter size, filter layers
	insts[idx].i.inst.Kh[0] = 0;
	insts[idx].i.inst.Ks[0] = 0;
	insts[idx].i.inst.Kt[0] = Kt[0]; // start, stride, and tail(inclusive)
	insts[idx].i.inst.Res_addr = (ADDR_TYPE)(ds->oSize + ds->fSize + ds->bmSize);
	//insts[idx].i.inst.BM_addr = (ADDR_TYPE)(ds->oSize + ds->fSize);
	insts[idx].i.inst.wLRelu = wrelu;
	insts[idx].i.inst.isMaddr_a = 0;
	insts[idx].i.inst.isMaddr_b = 0;
	insts[idx].i.inst.isOaddr_a = 0;
	insts[idx].i.inst.isOaddr_b = 0;
	insts[idx].i.inst.isRaddr_a = 0; //for Res
	insts[idx].i.inst.doRes = doRes ? 1 : 0;
	insts[idx].i.inst.doRelu = doRelu ? 1 : 0;
	insts[idx].i.inst.doLRelu = doLRelu ? 1 : 0;
	insts[idx].i.inst.doBM = doBM ? 1 : 0;
	insts[idx].i.inst.doUpSample = doUpsample ? 1 : 0;
	insts[idx].i.inst.isConv = 1;
	insts[idx].i.inst.progressMaster = 3;

	idx++;
	insts[idx].type = END;
	insts[idx].i.end.hasMore = 0;
	insts[idx].i.end.isRamA = 0;
	insts[idx].i.end.isRamB = 0;
	insts[idx].i.end.oAddr = 0;
	insts[idx].i.end.oSize = ds->oSize;

	int len = b15 + b12;
	if (b0 == 16){
		len = HEIGHT / 16;
		if (HEIGHT % 16)
			len++;
	}
	else if (b0 > 0)
		len++;
	if (Kbh[0] == 0){
		int len = 0;
		len += HEIGHT / HEIGHT1;
		if (HEIGHT % HEIGHT1)
			len++;
		int len1 = WIDTH / (WIDTH1 *4);
		if (WIDTH % (WIDTH1*4))
			len1++;
		insts[idx].i.end.reqSeqNum = len * len1 + 1; // - 1 + CONV seqNum
	}
	else
		insts[idx].i.end.reqSeqNum = WIDTH / 4 / WIDTH1 * len + 1;

	//int wsize = KERNEL * KERNEL * CHANNEL * OUTSIZE * sizeof(DTYPE);
	CModelIF model;
	model.BuildModel(2, 6);
	std::map<unsigned, void *> out_mp;
	out_mp[0] = ds->outputs;
	model.Run(insts, out_mp, ds->oSize, (unsigned char *)weights3, wSize * sizeof(DTYPE)
		, ds->buf, ds->fSize + ds->bmSize, true);
	int sz = doUpsample ? 2 : 1;
	for (int k = 0; k < OUTSIZE; k++)
		for (int i = 0; i < HEIGHT * sz / STRIDE / poolStride; i++)
			for (int j = 0; j < WIDTH * sz / STRIDE / poolStride; j++){
				if (!Is_equal(ds->outputs[k][i][j], ds->expected[k][i][j])) {
					printf("@#!ERROR@#! %d %d %d ("DFMT" , "DFMT")\n", k, i, j, ds->outputs[k][i][j], ds->expected[k][i][j]);
					delete ds; delete[]weights2;  return false;
				}
				//assert(outputs[k][i][j] == expected[k][i][j]);
			}
	printf("testFeaturesModeOne pass.  all equal ("DFMT", "DFMT", "DFMT", "DFMT", "DFMT")\n", ds->outputs[0][0][0], ds->outputs[0][0][1]
		, ds->outputs[0][0][2], ds->outputs[0][0][3], ds->outputs[0][0][4]);
	delete ds;
	delete[]weights2;
	delete[]weights3;
	return true;
}

template <int CHANNEL, int OUTSIZE, int WIDTH, int HEIGHT, int KERNEL, int STRIDE, int WIDTH1, int HEIGHT1>
bool testFeaturesModeOne(int i, DTYPE wrelu, bool genW2 = false)
{
	bool doBM = i & 1;
	bool doRelu = i & 8;
	bool doLRelu = i & 2;
	if (doLRelu)
		doRelu = false;
	bool doRes = i & 4;
	int PAD = KERNEL == 1 ? 0 : 1;
	printf("random test for %dx%d K%d C(%d) O(%d) %s %s %s %s\n", 
		WIDTH, HEIGHT, KERNEL, CHANNEL, OUTSIZE, doBM ? "bm" : "", doRelu ? "Relu" : "", doLRelu ? "LRelu" : "", doRes ? "Res" : "");

	const bool doUpsample = false;
	//DTYPE wrelu = 2;
	CDataSet<CHANNEL, HEIGHT, WIDTH, KERNEL, OUTSIZE, STRIDE, doUpsample ? 2 : 1, 1> *ds
		= new CDataSet<CHANNEL, HEIGHT, WIDTH, KERNEL, OUTSIZE, STRIDE, doUpsample ? 2 : 1, 1>();
	ds->GenData(wrelu, doBM, doRelu, doLRelu, doRes);
	ds->Dump(0, 16, 0, wrelu, doBM, doRelu, doLRelu, doRes); // k, i, j

	DTYPE *weights2 = new DTYPE[KERNEL * KERNEL * CHANNEL * OUTSIZE + OUTSIZE * BM_NUM];
	int start[5], Kh[4], Ks[4], Kt[4], Kbh[4], Kbe[4];
	Kbh[0] = 0;
	memset(start, 0, sizeof(start[0]) * 5);
#ifdef BATCH1_OPTIMIZE
	if (KERNEL == 1 && OUTSIZE > CG_NUM)
		transformWeightsBatch((DTYPE *)weights2, start, Kh, Ks, Kt, Kbh, Kbe, (DTYPE *)ds->weights, OUTSIZE, CHANNEL, KERNEL, 1, CG_NUM);
	else
#endif
	{
		Kt[0] = OUTSIZE - 1;
		transformWeights((DTYPE *)weights2, start, (DTYPE *)ds->weights, (DTYPE *)ds->bms, doBM ? BM_NUM : 0, OUTSIZE, CHANNEL, KERNEL, OUTSIZE * KERNEL > CG_NUM ? CG_NUM : OUTSIZE * KERNEL);
	}
	//start[1] = KERNEL * KERNEL * CHANNEL * OUTSIZE + (doBM?(OUTSIZE*BM_SIZE):0);
	int dropSize;
	int wSize;
	DTYPE *weights3 = transformWeights2((DTYPE *)weights2, MODE_ONE, start, &dropSize, &wSize);
	int b15, b12, b0;
	GetBatchNum(HEIGHT, b15, b12, b0);

	int rpad = PAD;
	
	if (((HEIGHT1 - KERNEL + 2 * PAD) % STRIDE) != 0)
		rpad--;
	int w2 = WIDTH1 * 4;
	if (WIDTH % w2 == 0)
		w2 = WIDTH1;
	else
		w2 = (WIDTH % w2) - WIDTH1 * 3;

	if (!genW2)
		w2 = 0;
	else
		assert(w2 > 0);

	GlobalInstruction insts[8];
	int idx = 0;

	
	insts[idx].type = CONV;
	insts[idx].i.inst.maxpool_stride = 1;
	insts[idx].i.inst.maxpool_size = 1;
	insts[idx].i.inst.W2 = w2;
	insts[idx].i.inst.mode = MODE_ONE;
	insts[idx].i.inst.progressMaster = 3;
	insts[idx].i.inst.reqSeqNum = 0;
	insts[idx].i.inst.reqSeqNumW = 1;
	insts[idx].i.inst.reqProgressW = 42;
	insts[idx].i.inst.seqNum = 2;
	insts[idx].i.inst.fScale = 0;
	insts[idx].i.inst.wScale = 0;
	insts[idx].i.inst.W = WIDTH;
	insts[idx].i.inst.H = HEIGHT;
	insts[idx].i.inst.C = CHANNEL;
	insts[idx].i.inst.W1 = WIDTH1;
	insts[idx].i.inst.H1 = HEIGHT1;
#ifdef BATCH1_OPTIMIZE
	if (Kbh[0] == 0)
		insts[idx].i.inst.doBatch3 = 0;
	else{
		insts[idx].i.inst.doBatch3 = 1;
		insts[idx].i.inst.Kbh[0] = Kbh[0];
		insts[idx].i.inst.Kbe[0] = Kbe[0];
		insts[idx].i.inst.batch15 = b15;
		insts[idx].i.inst.batch12 = b12;
		insts[idx].i.inst.batch0 = b0;
	}
#endif
	insts[idx].i.inst.Maddr = ds->oSize;// (ADDR_TYPE)ds->buf;
	insts[idx].i.inst.Waddr = 0;
	insts[idx].i.inst.isUseWRam = 0;
	insts[idx].i.inst.wDropSize = dropSize;
	insts[idx].i.inst.WSize = wSize;
	insts[idx].i.inst.Oaddr = 0;
	insts[idx].i.inst.WEnd[0] = start[1];
	insts[idx].i.inst.WEnd[1] = 0;
	insts[idx].i.inst.WEnd[2] = 0;
	insts[idx].i.inst.WEnd[3] = 0;
	insts[idx].i.inst.S = STRIDE;
	insts[idx].i.inst.lPad = PAD;
	insts[idx].i.inst.rPad = rpad;
	insts[idx].i.inst.K = KERNEL;
	insts[idx].i.inst.M = OUTSIZE; // filter size, filter layers
	insts[idx].i.inst.Kh[0] = 0;
	insts[idx].i.inst.Ks[0] = 0;
	insts[idx].i.inst.Kt[0] = Kt[0]; // start, stride, and tail(inclusive)
	insts[idx].i.inst.Res_addr = (ADDR_TYPE)(ds->oSize + ds->fSize + ds->bmSize);
	//insts[idx].i.inst.BM_addr = (ADDR_TYPE)(ds->oSize + ds->fSize);
	insts[idx].i.inst.wLRelu = wrelu;
	insts[idx].i.inst.isMaddr_a = 0;
	insts[idx].i.inst.isMaddr_b = 0;
	insts[idx].i.inst.isOaddr_a = 0;
	insts[idx].i.inst.isOaddr_b = 0;
	insts[idx].i.inst.isRaddr_a = 0; //for Res
	insts[idx].i.inst.doRes = doRes ? 1 : 0;
	insts[idx].i.inst.doRelu = doRelu ? 1 : 0;
	insts[idx].i.inst.doLRelu = doLRelu ? 1 : 0;
	insts[idx].i.inst.doBM = doBM ? 1 : 0;
	insts[idx].i.inst.doUpSample = doUpsample ? 1 : 0;
	insts[idx].i.inst.isConv = 1;
	insts[idx].i.inst.progressMaster = 3;

	idx++;
	insts[idx].type = END;
	insts[idx].i.end.hasMore = 0;
	insts[idx].i.end.isRamA = 0;
	insts[idx].i.end.isRamB = 0;
	insts[idx].i.end.oAddr = 0;
	insts[idx].i.end.oSize = ds->oSize;
	int len = b15 + b12;
	if (b0 == 16){
		len = HEIGHT / 16;
		if (HEIGHT % 16)
			len++;
	}
	else if (b0 > 0)
		len++;

	if (Kbh[0] == 0){
		int len = 0;
		len += HEIGHT / HEIGHT1;
		if (HEIGHT % HEIGHT1)
			len++;
		int len1 = WIDTH / WIDTH1;
		if (WIDTH % WIDTH1)
			len1++;
		insts[idx].i.end.reqSeqNum = len * len1 / 4  + 1; // - 1 + CONV seqNum
	}
	else
		insts[idx].i.end.reqSeqNum = WIDTH / 4 / WIDTH1 * len + 1;

	CModelIF model;
	model.BuildModel(2, 6);
	std::map<unsigned, void *> out_mp;
	out_mp[0] = (DTYPE *)ds->outputs;
	model.Run(insts, out_mp, ds->oSize, (unsigned char *)weights3, wSize * sizeof(DTYPE)
		, ds->buf, ds->fSize + ds->bmSize + ds->rSize, true);
	int sz = doUpsample ? 2 : 1;
	for (int k = 0; k < OUTSIZE; k++)
		for (int i = 0; i < HEIGHT * sz / STRIDE; i++)
			for (int j = 0; j < WIDTH * sz / STRIDE; j++){
				if (!Is_equal(ds->outputs[k][i][j], ds->expected[k][i][j])) {
					printf("@#!ERROR@#! %d %d %d ("DFMT" , "DFMT")\n", k, i, j, ds->outputs[k][i][j], ds->expected[k][i][j]);
					delete ds; delete []weights2;  return false;
				}
				//assert(outputs[k][i][j] == expected[k][i][j]);
			}
	printf("testFeaturesModeOne pass.  all equal ("DFMT", "DFMT", "DFMT", "DFMT", "DFMT")\n", ds->outputs[0][0][0], ds->outputs[0][0][1]
		, ds->outputs[0][0][2], ds->outputs[0][0][3], ds->outputs[0][0][4]);
	delete ds;
	delete[]weights2;
	delete[]weights3;
	return true;
}

bool testTiny()
{
	bool ret;
	ret = testFeaturesModeOneMaxPool<3, 16, 416, 416, 3, 1, 7, dH1, 2>(3, 2);
	if(!testFeaturesModeOneMaxPool<16, 32, 208, 208, 3, 1, 7, dH1, 2>(3, 2))
		ret = false;
	if(!testFeaturesModeOneMaxPool<32, 64, 104, 104, 3, 1, 7, dH1, 2>(3, 2))
		ret = false;
	if(!testFeaturesModeOneMaxPool<64, 128, 52, 52, 3, 1, 7, dH1, 2>(3, 2))
		ret = false;
	if(!testFeaturesModeOneMaxPool<128, 256, 26, 26, 3, 1, 7, dH1, 2>(3, 2, true))
		ret = false;
	if(!testFeaturesModeTwoMaxPool<256, 512, 13, 13, 3, 1, 7, 13, 1>(3, 2))
		ret = false;

	if(!testFeaturesModeTwo<512, 1024, 13, 13, 3, 1, 7, 13, false>(3, 2))
		ret = false;
	if(!testFeaturesModeTwo<1024, 256, 13, 13, 1, 1, 7, 13, false>(3, 2))
		ret = false;
	if(!testFeaturesModeTwo<256, 512, 13, 13, 3, 1, 7, 13, false>(3, 2))
		ret = false;
	if(!testFeaturesModeTwo<512, 255, 13, 13, 1, 1, 7, 13, false>(1, 2))
		ret = false;

	if(!testFeaturesModeTwo<256, 128, 13, 13, 1, 1, 7, 13, true>(3, 2)) // do ups
		ret = false;

	if(!testFeaturesModeOne<384, 256, 26, 26, 3, 1, 7, dH1>(3, 2, true))
		ret = false;
	if(!testFeaturesModeOne<256, 255, 26, 26, 1, 1, 7, dH1>(1, 2, true))
		ret = false;
	return ret;
}

#define SV_MASK(N) (~(-1 << (N)))

#define SV_GET_UNSIGNED_BITS(VALUE, N) \
    ((N) == 32 ? (VALUE) : ((VALUE) & SV_MASK(N)))

#define SV_GET_SIGNED_BITS(VALUE, N) \
    ((N) == 32 ? (VALUE) : \
    (((VALUE) & (1 << (N))) ? ((VALUE) | ~SV_MASK(N)) : ((VALUE) & SV_MASK(N))))

int main()
{
	bool ret;
	srand(0);

	if (!testFeaturesModeOne<4, 16, 4 * bsz, 4 * bsz, 3, 1, bsz, dH1>(1, 2))
			ret = false;
	testConv();
	
	//testFeaturesModeTwo<256, 512, 13, 13, 3, 1, 7, 13, false>(3, 2);
	//testFeaturesModeOne<128, 256, 4 * bsz, 4 * bsz, 3, 1, bsz, dH1>(4, 2);
	ret = testTiny();
	
	if(!testFeaturesModeOneMaxPool<16, 32, 12, 16, 3, 1, 3, dH1, 2>(3, 2))
		ret = false;
	if(!testFeaturesModeOneMaxPool<32, 64, 20, 16, 3, 1, 5, dH1, 2>(3, 2))
		ret = false;
	if(!testFeaturesModeTwoMaxPool<16, 32, 12, 16, 3, 1, 6, dH1, 2>(3, 2))
		ret = false;
	if(!testFeaturesModeOneMaxPool<3, 16, 24, 16, 3, 1, 6, dH1, 2>(3, 2))
		ret = false;
	if(!testFeaturesModeOneMaxPool<64, 128, 24, 16, 3, 1, 6, dH1, 2>(3, 2))
		ret = false;

	
	for (int i = 0; i < 10; i++){
		if(!testFeaturesModeTwoMaxPool<256, 512, 13, 13, 3, 1, 7, 13, 1>(i, 2))
			ret = false;
	}
	
	

	for (int i = 0; i < 10; i++){
		if(!testFeaturesModeOneMaxPool<128, 256, 4 * bsz, 4 * bsz, 3, 1, bsz, dH1, 2>(i, 2))
			ret = false;
	}
	for (int i = 0; i < 10; i++){
		if(!testFeaturesModeOneMaxPool<64, 128, 8 * bsz, 8 * bsz, 3, 1, bsz, dH1, 2>(i, 2))
			ret = false;
	}
	for (int i = 0; i < 10; i++){
		if(!testFeaturesModeOneMaxPool<32, 64, 16 * bsz, 16 * bsz, 3, 1, bsz, dH1, 2>(i, 2))
			ret = false;
	}
	for (int i = 0; i < 10; i++){
		if(!testFeaturesModeOneMaxPool<16, 32, 32 * bsz, 32 * bsz, 3, 1, bsz, dH1, 2>(i, 2))
			ret = false;
	}
	for (int i = 0; i < 10; i++){
		if(!testFeaturesModeOneMaxPool<3, 16, 64 * bsz, 64 * bsz, 3, 1, bsz, dH1, 2>(i, 2))
			ret = false;
	}
	
	
	

	for (int i = 0; i < 10; i++){
		if(!testFeaturesModeOne<128, 256, 4 * bsz, 4 * bsz, 3, 1, bsz, dH1>(i, 2))
			ret = false;
	}
	
	for (int i = 0; i < 10; i++){
		if(!testFeaturesModeFour<1024, 512, bsz, bsz, 1, 1>(i, 2))
			ret = false;
	}
	for (int i = 0; i < 10; i++){
		if(!testFeaturesModeFour<512, 1024, 1 * bsz, 1 * bsz, 3, 1>(i, 2))
			ret = false;
	}
	for (int i = 0; i < 10; i++){
		if(!testFeaturesModeTwo<512, 256, 2 * bsz, 2 * bsz, 1, 1, bsz, dH1, false>(i, 2))
			ret = false;
	}
	for (int i = 0; i < 10; i++){
		if(!testFeaturesModeTwo<256, 512, 2 * bsz, 2 * bsz, 3, 1, bsz, dH1, false>(i, 2))
			ret = false;
	}
	testFeaturesModeOne<3, 32, 32 * bsz, 32 * bsz, 3, 1, bsz, dH1>(4, 2);
	for (int i = 0; i < 10; i++){
		if(!testFeaturesModeOne<3, 32, 32 * bsz, 32 * bsz, 3, 1, bsz, dH1>(i, 2))
			ret = false;
	}
	
	for (int i = 0; i < 10; i++){
		if(!testFeaturesModeOne<64, 32, 16 * bsz, 16 * bsz, 1, 1, bsz, dH1>(i, 2))
			ret = false;
	}
	for (int i = 0; i < 10; i++){
		if(!testFeaturesModeOne<32, 64, 16 * bsz, 16 * bsz, 3, 1, bsz, dH1>(i, 2))
			ret = false;
	}
	
	for (int i = 0; i < 10; i++){
		if(!testFeaturesModeOne<128, 64, 8 * bsz, 8 * bsz, 1, 1, bsz, dH1>(i, 2))
			ret = false;
	}
	for (int i = 0; i < 10; i++){
		if(!testFeaturesModeOne<64, 128, 8 * bsz, 8 * bsz, 3, 1, bsz, dH1>(i, 2))
			ret = false;
	}
	
	for (int i = 0; i < 10; i++){
		if(!testFeaturesModeOne<256, 128, 4 * bsz, 4 * bsz, 1, 1, bsz, dH1>(i, 2))
			ret = false;
	}
	
	
	/*for (int i = 0; i < 10; i++){
	testFeaturesModeTwoMaxPool<256, 512, 2 * bsz, 2 * bsz, 3, 1, bsz, bsz, 2>(i, 2);
	}*/
	//for (int i = 0; i < 10; i++){
	//	testFeaturesModeTwo<64, 128, 160, 160, 3, 2, 20, 20>(i, 2);
	//}
	//
	//testFeatures40xup_rand();


	/*testFeatures1();
	testFeatures1bm();

	testFeaturesk3s1b1();
	testFeaturesk3s1b1p1();
	testFeaturesk3s2b2_rand();
	testFeaturesk3s1b2p1relubmres();
	testFeaturesk3s1b2p1relubm();
	testFeaturesk3s1b2p1relu();
	testFeaturesk3s1b2p1();

	testFeaturesk3s2b2();
	testFeaturesk1b2();

	testFeaturesk3s2();



	testFeatures10xup_rand();
	testFeaturesk3s2b2bmreluup();*/
	/*testFeatures20xup_rand();
	testFeatures1bm_rand();
	testFeatures40xup_rand();*/
	////
	//
	//for (int i = 0; i < 10; i++){
	//	testFeaturesModeTwo<512, 256, 2 * bsz, 2 * bsz, 1, 1, bsz, dH1>(i, 2);
	//}
	//for (int i = 0; i < 10; i++){
	//	testFeaturesModeOne<64, 32, 16 * bsz, 16 * bsz, 1, 1, bsz, dH1>(i, 2);
	//}
	//
	//for (int i = 0; i < 10; i++){
	//	testFeaturesModeOne<256, 255, bsz * 4, 4 * bsz, 1, 1, bsz, dH1>(i, 2);
	//	//return 0;
	//}
	//for (int i = 0; i < 10; i++){
	//	testFeaturesModeOne<128, 64, 8 * bsz, 8 * bsz, 1, 1, bsz, dH1>(i, 2);
	//}

	//for (int i = 0; i < 10; i++){
	//	testFeaturesModeOne<256, 128, 4 * bsz, 4 * bsz, 1, 1, bsz, dH1>(i, 2);
	//}
	//for (int i = 0; i < 10; i++){
	//	testFeaturesModeFour<1024, 512, bsz, bsz, 1, 1>(i, 2);
	//}
	//


	//
	//testFeaturesModeTwo<256, 128, 2 * bsz, 2 * bsz, 1, 1, bsz, dH1>(3, 2);
	//testFeaturesModeTwo<768, 256, 2 * bsz, 2 * bsz, 1, 1, bsz, dH1>(3, 2);
	//
	////
	////
	////testFeatures1();
	////testFeatures1relu();
	////testFeaturesModeOne<32, 64, 160, 160, 3, 1, 10, 10>(0, 2);
	//////testFeaturesModeTwoK7<3, 64, 224, 224, 7, 2, 14, 14>(1, 2);
	////
	////testFeaturesk3s1b2p1relubmres();
	////testFeaturesModeOne<8, 128, 40, 40, 1, 1, 10, 10>(3, 2);

	//
	//
	//for (int i = 0; i < 10; i++){
	//	testFeaturesModeTwoK7<3, 64, 224, 224, 7, 2, 14, dH1>(i, 2); //change pad to 3,2
	//}
	//return 0; 

	//for (int i = 0; i < 10; i++){
	//	testFeaturesModeTwo<8, 32, 4 * bsz, 4 * bsz, 3, 2, 2 * bsz, 2 * dH1>(i, 2);
	//	//testFeaturesModeTwo<256, 512, 4 * bsz, 4 * bsz, 3, 2, 2 * bsz, 2 * dH1>(i, 2);
	//}
	//for (int i = 0; i < 10; i++){
	//	testFeaturesModeTwo<64, 128, 16 * bsz, 16 * bsz, 3, 2, 2 * bsz, 2 * bsz>(i, 2);
	//}
	//for (int i = 0; i < 10; i++){
	//	testFeaturesModeFour<512, 1024, 2 * bsz, 2 * bsz, 3, 2>(i, 2);
	//}
	/*for (int i = 0; i < 10; i++){
	testFeaturesModeTwo<32, 64, 32 * bsz, 32 * bsz, 3, 2, 2 * bsz, 2 * dH1, false>(i, 2);
	}

	for (int i = 0; i < 10; i++){
	testFeaturesModeTwo<128, 256, 8 * bsz, 8 * bsz, 3, 2, 2 * bsz, 2 * dH1, false>(i, 2);
	}*/

	//testFeaturesModeOne<256, 512, 40, 40, 3, 2, 2, 10, 10>(9);
	//for (int i = 5; i < 10; i++){
	////	testFeaturesk3s1b2p1relubmres_rand(i);
	//	test20x20K1S1<768>(i);
	////	//test20x20K3S1(i);
	////	//test20x20K3S2(i);
	//}
	//return 0;
	//testFeaturesk3s2b2_rand();
	//testFeaturesk3s2b2();
	//testFeaturesk3s1b2p1relubmres();
	//testFeaturesk3s1b2p1relubm();
	//testFeaturesk3s1b2p1relu();
	//testFeaturesk3s1b2p1();
	//testFeaturesk1b2();
	//testFeatures1bm();
	//testFeaturesk3s2();
	//testFeaturesk3s1b1();
	//testFeaturesk3s1b1p1();
	//testFeatures1bmres();
	//testFeatures1();
	//testFeatures1relu();

	//testFeatures10xup_rand();
	//testFeaturesk3s2b2bmreluup();
	//testFeatures20xup_rand();
	//testFeatures1bm_rand();
	//testFeatures40xup_rand();

	//
	//	
	//for (int i = 0; i < 10; i++){
	//	test20x20K3S2(i);
	//	test20x20K1S1<768>(i);
	//	test20x20K1S1<512>(i);
	//	test20x20K3S1(i);
	//	
	//	//testFeaturesk3s1b2p1relubmres_rand(i);
	//}
	printf("%s\n", ret ? "All Good!" : "Failed!");
	printf("\7\7\7");
	return 0;
}
