#ifndef NETWORK_H
#define NETWORK_H
#include <sim.h>
#include <model.h>
#include <map>
extern "C"{
#include "box.h"
};
#define MAXROUTESIZE	4
enum Layer_Type { LT_CONV, LT_RES, LT_ROUTE, LT_UPS, LT_MAXPOOL, LT_YOLO };

#define USE_INT_YOLO
#define QUANT_WEIGHT
#define WTYPE int
#define QUANT_LOOP_MAX	8
#define BM_NEG_WEIGHT	0.01

struct ConvLayer{
	int W, H, C, M, S, K, pad;
	int fscale, fscale_diff, fscale_bm;
	float wrelu;
	int wrelui;
	float *biases;
	float *scales;
	float * rolling_mean;
	float * rolling_variance;
	float * weights;
	WTYPE * weightsi;
	float * weights0;
	DTYPE * weights2;
	float * bms;
	int * bmsi;
	int * wscale;
	int * conv_scale;
	int lr_scale;
	//int * bmscale;
	int * bmscale;
	float*quant_bias;
	bool doBM;
	bool isRelu;
	bool isLRelu;
	bool isLinear;
#ifdef QUANT_WEIGHT
	float **conv_data;
	int layer_scale;
	int layer_scale_conv;
	int *cscale;
	int *cscale_conv;

#endif
	/*~ConvLayer(){
		delete[]biases;
		delete[]scales;
		delete[]rolling_mean;
		delete[]rolling_variance;
		delete[]weights;
	}*/
};
struct ResLayer{
	int idx;
};
struct MaxPoolLayer{
	int size;
	int stride;
};
struct RouteLayer{
	int num;
	int layers[MAXROUTESIZE];
};
struct UpSampleLayer{
	int stride;
};
struct YoloLayer
{
	int numClasses;
	int outputSize;
	int fscale;
	int w, h;
	int n;
	int total;
	int *mask;
	float *biases;
};
struct MemUsed{
	MemUsed *next;
	int start;
	int len;
};
struct SLayer{
	int id;
	Layer_Type type;
	float *outputs;
	int *outputsi;
	FEATURE_TYPE *outputss;
	int outSize;
	int lastUsed;
	MemUsed *mem;
	int memStart;
	int fscale;
	bool isRamA;
	bool isDDR;
	bool isSet;
	union{
		ConvLayer conv;
		ResLayer res;
		RouteLayer route;
		UpSampleLayer ups;
		YoloLayer yolo;
		MaxPoolLayer maxpool;
	}l;
#ifdef QUANT_WEIGHT
	float ** saved_data; //input data of the current layer
#endif
	void AddMem(int start, int len);

};
struct detection;
struct quant_err{
	double totalerr;
	double aveerror; 
	double totalerr_mse;
	double aveerror_mse;
	double totalerr_per;
	double aveerror_per;
	double totalerr_abs;
	double aveerror_abs;
	double totalerr_perabs;
	double aveerror_perabs;
};
const unsigned max_layer_size = 50;
class CNetwork{
	//const unsigned baseWaddr = 17635456;
	//const unsigned baseWaddr = 524288; // PS memory error below this address 0x80000
	const unsigned baseWaddr = 0;
	
	const int wScale = 8;
	const int fScale = 8;
	const int wScale0 = 10; //try 7,6 for 8 bits weight
	const unsigned BRAM_SZ = 0x100000;
	const unsigned DDR_BASE = 0x200000;
	int width;
	int height;
	int numClasses;
	int numLayers;
	int fscale0;
	SLayer *layers;
	float *data;
	int *datai;
	int size;
	FEATURE_TYPE *yolodata;
	unsigned char *weights_data;
	FILE *fdebug;
#define TYPE_SIZE 1
	char *features_data;
	int cur_weight_size;
	int weight_sizes[max_layer_size];
	int cur_data_size;
	int max_memory_size;
	int numYolos;
	FILE *fout;
	char imgName[100];
	char *outdir;
#ifdef QUANT_WEIGHT
	float ** last_data;
	int num_img;
	int **iter_datai;
	int iter_size;
	float *weights2;
#endif
	std::map<int, std::pair<int, unsigned> >seqYoloMp;
	CloudDesign::GlobalInstruction *pinsts;
public:
	CNetwork() : numLayers(0), layers(NULL), features_data(NULL), weights_data(NULL){}
	~CNetwork(){
		if (numLayers > 0)
			delete[]layers;
		delete[]weights_data;
		delete[]features_data;
	}
	void quant_read();
	void quantize_features(int iter, bool beforeBM);
	void balance_weight4feature();
	void generate_quant_bias();
	void generate_layer_bias(int iter, FILE *fp, FILE *fpp, FILE *fpe);
	void free_balance_input_data(int iter);
	void compute_balance_input_data(int iter, int conv_step);
	void balance_weight(int iter, int conv_step);
	quant_err evaluate_change(int iter, int* scale_change, int conv_step, bool is_init);
	void LoadNet(char *cfg);
	void LoadWeight(char *wf);
	void DumpWeights();
	void QuantizeWeights(int layer, float *dst, float *src, int num);
	void AnalysisWeights(int layer, float *weights, int num, ConvLayer &l);
	void loadConvolutionalWeights(int i, ConvLayer &l, FILE *fp);
	int getBestScale(int scale, int num, float *data, float &err);
	void LoadQuantBias(char *q_bias);
	void Init(char *cfg, char *weights);
	void Init(char *cfg, char *weights, char *q_bias);
	void setOutFIle(FILE *f, char *o) { fout = f; outdir = o; }
	void setImgName(char *n) { strcpy(imgName, n); }
	void copyWeights(DTYPE *weights3, int wSize);
	DumpInfo * GenInsts(int baseSizeW, int baseSizeH, std::map<unsigned, void *>& out_mp);
	int GetWidth() { return width; }
	int GetHeight() { return height; }
	int GetNumClasses() { return numClasses; }
	void Forward(float *input);
	void Forwardi(float *input);
	void Forward2(float *input, int baseSizeW, int baseSizeH);
	int GetW2(CloudDesign::DATA_MODE mode, int W, int& w1);
	void ConvForward(int i);
	void ConvForwardi(int i, FILE *fd, bool alloc_data = true);
	void ResForward(int i);
	void ResForwardi(int i);
	void RouteForward(int i);
	void UPSForward(int i);
	void MaxPoolForward(int i);
	void MaxPoolForwardi(int i, bool alloc_data = true);
	void YoloForward(int i);
	void RouteForwardi(int i);
	void UPSForwardi(int i);
	void YoloForwardi(int i);
	void dumpData(int i, int M);
	void dumpDatai(int i);
	void logisticActivateArray(float *x, const int n);
	void YoloProcess(int i);
	void AnalyzeNet();
	void updateLifeSpan();
	void assignMemory();
	void allocMemory();
	void allocMemoryDDR();
	void allocMemoryDDRBram(unsigned bramSz, unsigned mem_start);
	void allocMemoryDDRDebug();
	MemUsed *MergeMem(MemUsed *head, MemUsed *pm);

	detection *GetNetworkBoxes(int w, int h, float thresh, float hier, int *map, int relative, int *num);
	detection *makeNetworkBoxes(float thresh, int *num);
	int numDetections(float thresh);
	int yoloNumDetections(int l, float thresh);
	int entryIndexYolo(YoloLayer &l, int location, int entry);
	void fillNetworkBoxes(int w, int h, float thresh, float hier, int *map, int relative, detection *dets);
	int getYoloDetections(int l, int w, int h, int netw, int neth, float thresh, int *map, int relative, detection *dets);
	box getYoloBox(float *x, float *biases, int n, int index, int i, int j, int lw, int lh, int w, int h, int stride);
	void correctYoloBoxes(detection *dets, int n, int w, int h, int netw, int neth, int relative);
};

#endif