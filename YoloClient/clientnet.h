#ifndef CLIENTNETWORK_H
#define CLIENTNETWORK_H
#include <sim.h>
#include <model.h>
#include <map>
#include <boost/thread.hpp>
#include "udp.h"
extern "C"{
#include "image.h"
};
#define MAXROUTESIZE	4
enum Layer_Type { LT_CONV, LT_RES, LT_ROUTE, LT_UPS, LT_MAXPOOL, LT_YOLO };

#define USE_INT_YOLO
#define WTYPE int
#define TEST_IMG	0

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
	void AddMem(int start, int len);

};
struct detection;


class CClientNetwork{
	//const unsigned baseWaddr = 17635456;
	//const unsigned baseWaddr = 524288; // PS memory error below this address 0x80000
	const unsigned baseWaddr = 0;
	const int wScale = 8;
	const int fScale = 8;
	const int wScale0 = 8; //try 7,6 for 8 bits weight
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
	int cur_data_size;
	int max_memory_size;
	int numYolos;
	unsigned char *instbuf;
	int inst_len;
	
	char **demo_names;
	image **demo_alphabet;
	int demo_classes;
	image buff[3];
	image buff_letter[3];
	int buff_index;
	CvCapture * cap;
	IplImage  * ipl;
	float fps = 0;
	float demo_thresh;
	float demo_hier;
	char video_file[200];
	int cam_index;
	int baseSizeW, baseSizeH;
#define NUM_YOLOS	2
	unsigned yolo_addr[NUM_YOLOS];	// assume 5 yolo at most
	unsigned yolo_size[NUM_YOLOS];
	#define demo_frame  3
	int demo_index;

	FEATURE_TYPE *predictions[demo_frame];

	float *avg;
	int demo_done;
	int demo_total;
	double demo_time;
	char *prefix;
	int frames;
	unsigned inst_addr;
	unsigned feature_addr;
	unsigned bmSize;
	unsigned bmAddr;
	unsigned char *bm_data;
	bool	stop_receive;
	LARGE_INTEGER li;
	double send_feature_time;
	double out1_compute_time;
	double out1_receive_time;
	double out2_compute_time;
	double out2_receive_time;
	double draw_time;
	double process_time;
	double fetch_time;
	double display_time;
	int time_count;
	int fetch_count;
	int display_count;

#define DDRLEN		1500
#define SEND_LEN	1280
#define MAX_NET_LEN	1788
	bool do_send_data;
	UDPClient *client;
	boost::asio::io_service io_service;
	//boost::mutex cond_mutex;
	boost::mutex receive_mutex;
	boost::mutex ptr_mutex;
	CAllocAssist<MAX_NET_LEN> *palloc;
	std::deque<std::pair<int, unsigned char *> > input_queue;
	boost::shared_ptr<boost::thread> net_send_thread;
	boost::shared_ptr<boost::thread> net_receive_thread;
	std::map<int, std::pair<int, unsigned> >seqYoloMp;
	CloudDesign::GlobalInstruction *pinsts;
public:
	CClientNetwork() : numLayers(0), layers(NULL), features_data(NULL), weights_data(NULL){}
	~CClientNetwork(){
		if (numLayers > 0)
			delete[]layers;
		delete[]weights_data;
		delete[]features_data;
	}
	void LoadNet(char *cfg);
	void LoadWeight(char *wf);
	void DumpWeights();
	void EnqueueNetData(const unsigned char*data, unsigned len);
	void QuantizeWeights(int layer, float *dst, float *src, int num);
	void AnalysisWeights(int layer, float *weights, int num, ConvLayer &l);
	void loadConvolutionalWeights(int i, ConvLayer &l, FILE *fp);
	void Init(char *cfg, char *weights, char *bias_file, char **names, image **alphabet
		, char *video, int cidx, int bw, int bh);
	int size_network();
	//void LoadQuantBias(char *q_bias);
	int getBestScale(int scale, int num, float *data, float &err);
	void LoadQuantBias(char *q_bias);
	void remember_network();
	detection *avg_predictions(int *nboxes);
	void Run();
	void send_in_thread();
	void net_receive_in_thread();
	void net_receive_in_thread_boost();
	void netSetup();
	void GetFeatures(float *X);
	void fetch_in_thread();
	void detect_in_thread();
	void display_in_thread();
	void free_detections(detection *dets, int n);
	double what_time_is_it_now();
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
	void ConvForwardi(int i);
	void ResForward(int i);
	void ResForwardi(int i);
	void RouteForward(int i);
	void UPSForward(int i);
	void MaxPoolForward(int i);
	void MaxPoolForwardi(int i);
	void YoloForward(int i);
	void RouteForwardi(int i);
	void UPSForwardi(int i);
	void YoloForwardi(int i);
	void dumpData(int i);
	void dumpDatai(int i);
	void logisticActivateArray(float *x, const int n);
	void YoloProcess(int i);
	void AnalyzeNet();
	void updateLifeSpan();
	void assignMemory();
	void allocMemory();
	void allocMemoryDDR();
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