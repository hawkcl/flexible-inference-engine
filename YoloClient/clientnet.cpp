extern "C"{
#include "box.h"
};
#include <stdio.h>
#include <assert.h>
#include <string>
#include "clientnet.h"
#include <math.h>
#include <windows.h>
#include <cfloat>
#include <boost/thread.hpp>
#include <boost/bind.hpp>
#include <boost/array.hpp>
#include <boost/asio.hpp>
#include "boost/lexical_cast.hpp"
#include "udp.h"
#include <pcap.h>

void SLayer::AddMem(int start, int len)
{
	MemUsed *pm = new MemUsed;
	pm->len = len;
	pm->start = start;
	if (mem == NULL|| mem->start > pm->start){
		pm->next = mem;
		mem = pm;
		return;
	}
	MemUsed *p = mem;
	for (; p->next && p->next->start < start; p = p->next);
	assert(p->next == NULL || start + len <= p->next->start);
	pm->next = p->next;
	p->next = pm;
}

void CClientNetwork::LoadNet(char *cfg)
{
	FILE *fp = fopen(cfg, "rt");
	assert(fp);
	fscanf(fp, "%d %d %d %d", &numLayers, &width, &height, &fscale0);
	layers = new SLayer[numLayers];
	numYolos = 0;
	int yoloSize = 0;
	int prev_fscale = fscale0;
	for (int i = 0; i < numLayers; i++){
		char t[100];
		fscanf(fp, "%d %s", &(layers[i].id), t);
		std::string  tp = t;
		if (tp == "CONV"){
			layers[i].type = LT_CONV;
			char tmp[100];
			int bm;
			fscanf(fp, "%d %d %d %d %d %d %d %d %s %d %d", &layers[i].l.conv.W
				, &layers[i].l.conv.H, &layers[i].l.conv.C, &layers[i].l.conv.M
				, &layers[i].l.conv.S, &layers[i].l.conv.pad, &layers[i].l.conv.K
				, &bm, tmp, &layers[i].l.conv.fscale, &layers[i].l.conv.fscale_bm);
			layers[i].l.conv.fscale_diff = prev_fscale - layers[i].l.conv.fscale;
			prev_fscale = layers[i].l.conv.fscale_bm;
			layers[i].l.conv.doBM = (bm != 0);
			layers[i].l.conv.isRelu = false;
			layers[i].l.conv.isLRelu = false;
			layers[i].l.conv.isLinear = false;
			layers[i].l.conv.wrelui = 0;
			layers[i].l.conv.quant_bias = NULL;
			if (std::string(tmp) == "relu")
				layers[i].l.conv.isRelu = true;
			else if (std::string(tmp) == "lrelu"){
				layers[i].l.conv.isLRelu = true;
				layers[i].l.conv.wrelu = 0.1;
				layers[i].l.conv.lr_scale = 9;
				layers[i].l.conv.wrelui = int(0.1 * (1 << layers[i].l.conv.lr_scale));
			}
			else if (std::string(tmp) == "linear")
				layers[i].l.conv.isLinear = true;
			else
				assert(false);
			layers[i].outSize = layers[i].l.conv.M * layers[i].l.conv.W * layers[i].l.conv.H 
				/ layers[i].l.conv.S / layers[i].l.conv.S;
		}
		else if (tp == "RES"){
			layers[i].type = LT_RES;
			layers[i].outSize = layers[i - 1].outSize;
			char tmp[100];
			fscanf(fp, "%d %s", &layers[i].l.res.idx, tmp);
		}
		else if (tp == "ROUTE"){
			layers[i].type = LT_ROUTE;
			fscanf(fp, "%d", &layers[i].l.route.num);
			assert(layers[i].l.route.num < MAXROUTESIZE);
			layers[i].outSize = 0;
			for (int k = 0; k < layers[i].l.route.num; k++){
				fscanf(fp, "%d", layers[i].l.route.layers + k);
				layers[i].outSize += layers[layers[i].l.route.layers[k]].outSize;
			}
		}
		else if (tp == "UPS"){
			layers[i].type = LT_UPS;
			fscanf(fp, "%d", &layers[i].l.ups.stride);
			layers[i].outSize = layers[i - 1].outSize * layers[i].l.ups.stride * layers[i].l.ups.stride;
		}
		else if (tp == "MAXPOOL"){
			layers[i].type = LT_MAXPOOL;
			fscanf(fp, "%d %d", &layers[i].l.maxpool.stride, &layers[i].l.maxpool.size);
			assert(layers[i].l.maxpool.size == 2);
			assert(layers[i].l.maxpool.stride <= 2);
			layers[i].outSize = layers[i - 1].outSize / layers[i].l.maxpool.stride / layers[i].l.maxpool.stride;
		}
		else if (tp == "YOLO"){
			layers[i].type = LT_YOLO;
			fscanf(fp, "%d %d %d %d %d %d", &layers[i].l.yolo.numClasses
				, &layers[i].l.yolo.outputSize, &layers[i].l.yolo.w
				, &layers[i].l.yolo.h, &layers[i].l.yolo.n, &layers[i].l.yolo.total);
			layers[i].l.yolo.mask = new int[layers[i].l.yolo.n];
			for (int k = 0; k < layers[i].l.yolo.n; k++)
				fscanf(fp, "%d", layers[i].l.yolo.mask + k);
			layers[i].l.yolo.biases = new float[layers[i].l.yolo.total * 2];
			for (int k = 0; k < layers[i].l.yolo.total * 2; k++)
				fscanf(fp, "%f", layers[i].l.yolo.biases + k);
			numClasses = layers[i].l.yolo.numClasses;
			layers[i].outSize = layers[i - 1].outSize;
			//int size = layers[i].outSize;
			layers[i].outputs = new float[layers[i].outSize];
			numYolos++;
			yoloSize += layers[i].outSize;
			layers[i].l.yolo.fscale = prev_fscale;
		}
		else
			assert(false);
	}
	fclose(fp);
	yolodata = new FEATURE_TYPE[yoloSize + 32 * NUM_YOLOS];
}

void CClientNetwork::AnalysisWeights(int layer, float *weights, int num, ConvLayer &l)
{
	static FILE *fa = NULL;
	if (fa == NULL)
		fa = fopen("wts.txt", "wt");
	double mx, mn;
	const int len = 100;
	int sizes[len];
	double span;
	mx = mn = weights[0];
	int i;
	for (i = 1; i < num; i++){
		if (mx < weights[i])
			mx = weights[i];
		if (mn > weights[i])
			mn = weights[i];
	}
	span = (mx - mn) / len;
	fprintf(fa,"Layer %d, %f -> %f, %f (%d)\n", layer, mn, mx, span, num);
	memset(sizes, 0, len *sizeof(sizes[0]));
	for (i = 0; i < num; i++){
		int id = int((weights[i] - mn) / span);
		if (id >= len)
			id = len - 1;
		sizes[id]++;
	}
	int sum = 0;
	for (i = 0; i < len; i++){
		sum += sizes[i];
		fprintf(fa, "\t%d (%f -> %f) : %d (%d , %.2f%% , %.2f%%)\n", i, (mn + i * span) * 128, (mn + (i + 1)*span) * 128, sizes[i], sum, 100.0*sizes[i] / num, 100.0*sum / num);
	}
	mx = mn = l.bms[0];
	for (int i = 1; i < l.M ; i++){
		if (mx < l.bms[i * 2])
			mx = l.bms[i * 2];
		if (mn > l.bms[i * 2])
			mn = l.bms[i * 2];
	}
	fprintf(fa, "bm0 %f -> %f\n", mn, mx);

	mx = mn = l.bms[1];
	for (int i = 1; i < l.M; i++){
		if (mx < l.bms[i * 2 + 1])
			mx = l.bms[i * 2 + 1];
		if (mn > l.bms[i * 2 + 1])
			mn = l.bms[i * 2 + 1];
	}
	fprintf(fa, "bm1 %f -> %f\n", mn, mx);
	fflush(fa);
}

int compare(const void * a, const void * b)
{
	if ((*(float*)a < *(float*)b - FLT_EPSILON))
		return -1;
	if ((*(float*)a > *(float*)b + FLT_EPSILON))
		return 1;
	return 0;
	return (*(float*)a - *(float*)b);
}


void CClientNetwork::QuantizeWeights(int layer, float *dst, float *src, int num)
{
	const int qs = 1 << 12;
	float mx, mn;
	mx = mn = src[0];
	int i;
	for (i = 1; i < num; i++){
		if (mx < src[i])
			mx = src[i];
		if (mn > src[i])
			mn = src[i];
	}
	//float Z = (qs - 1) / (1 - mx / mn);
	float Z = 0;
	int iZ = int(Z +0.5);
	//float S = -mn / Z;
	double S = (-mn > mx ? -mn : mx) / qs * 2;
	double diffs = 0;
	double sum = 0;
	for (i = 0; i < num; i++){
		int q = src[i] / S + Z;
		assert(q >= -qs/2 && q <= qs/2);
		dst[i] = S * (q - iZ);
		float diff = dst[i] - src[i];
		diffs += (diff > 0 ? diff : -diff);
		sum += (src[i] > 0 ? src[i] : -src[i]);
	}
	printf("layer %d, diffs %lf, ave %lf (%.2lf%%), Z %f, S %f\n",layer , diffs, diffs/num, diffs * 100 / sum, Z, S);

	return;

	float *st = new float[num];
	memcpy(st, src, sizeof(src[0]) * num);
	qsort(st, num, sizeof(st[0]), compare);
	assert(st[0] == mn);
	assert(st[num - 1] == mx);
	int N1 = num / 4;
	int N3 = N1;
	int N2 = num - N1 - N3;
	while (fabs(st[N1 - 1] - st[N1]) <= FLT_EPSILON){
		N1--;
		N2++;
		assert(N1 > 0);
	}
	while (fabs(st[N2 - 1] - st[N2]) <= FLT_EPSILON){
		N3--;
		N2++;
		assert(N3 > 0);
	}
	float x = st[N1];
	float y = st[N1 + N2];
	float val = (2 * N1 - N2) * x + (N2 - 2 * N3) *y;
	printf("val %f\n", val);
	for (i = 0; i < 100; i++){
		int N;
		bool found = false;
		bool progress = false;
		for (N = N1 - 1; N > 0; N--){
			float newx = st[N];
			float nval = (2 * N - (num - N - N3)) * newx + ((num - N - N3) - 2 * N3) *y;
			if (fabs(nval - val) <= FLT_EPSILON)
				continue;
			if (nval < val){
				N1 = N;
				val = nval;
				found = true;
				x = newx;
				progress = true;
			}
			break;
		}
		if (!found){
			for (N = N1 + 1; N < num / 2; N++){
				float newx = st[N];
				float nval = (2 * N - (num - N - N3)) * newx + ((num - N - N3) - 2 * N3) *y;
				if (fabs(nval - val) <= FLT_EPSILON)
					continue;
				if (nval < val){
					N1 = N;
					val = nval;
					x = newx;
					progress = true;
				}
				break;
			}
		}
		found = false;
		for (N = N3 - 1; N > 0; N--){
			float newy = st[num - N];
			float nval = (2 * N1 - (num - N - N1)) * x + ((num - N - N1) - 2 * N) *newy;
			if (fabs(nval - val) <= FLT_EPSILON)
				continue;
			if (nval < val){
				N3 = N;
				val = nval;
				found = true;
				y = newy;
				progress = true;
			}
			break;
		}
		if (!found){
			for (N = N3 + 1; N < num/2; N++){
				float newy = st[num - N];
				float nval = (2 * N1 - (num - N - N1)) * x + ((num - N - N1) - 2 * N) *newy;
				if (fabs(nval - val) <= FLT_EPSILON)
					continue;
				if (nval < val){
					N3 = N;
					val = nval;
					found = true;
					y = newy;
					progress = true;
				}
				break;
			}
		}
		if (!progress)
			break;

	}
	printf("new val %f N (%d %d %d)\n", val, N1, num - N1 - N3, N3);
	float Z1 = 63 / (1 - x / mn);
	int iZ1 = int(Z1);
	float S1 = -mn / Z1;
	float Z2 = 127 / (1 - y / x);
	int iZ2 = int(Z2);
	float S2 = -x / Z2;
	float Z3 = 63 / (1 - mx / y);
	int iZ3 = int(Z3);
	float S3 = -y / Z3;


	diffs = 0;
	double diffs1 = 0;
	double sum1 = 0;
	double diffs2 = 0;
	double sum2 = 0; 
	double diffs3 = 0;
	double sum3 = 0; 
	for (i = 0; i < num; i++){
		if (src[i] < x){
			int q = src[i] / S1 + Z1;
			assert(q >= 0 && q < 64);
			dst[i] = S1 * (q - iZ1);
			float diff = dst[i] - src[i];
			diffs1 += (diff > 0 ? diff : -diff);
			sum1 += (src[i] > 0 ? src[i] : -src[i]);
		}
		else if (src[i] < y){
			int q = src[i] / S2 + Z2;
			assert(q >= 0 && q < 128);
			dst[i] = S2 * (q - iZ2);
			float diff = dst[i] - src[i];
			diffs2 += (diff > 0 ? diff : -diff);
			sum2 += (src[i] > 0 ? src[i] : -src[i]);
		}
		else{
			int q = src[i] / S3 + Z3;
			assert(q >= 0 && q < 64);
			dst[i] = S3 * (q - iZ3);
			float diff = dst[i] - src[i];
			diffs3 += (diff > 0 ? diff : -diff);
			sum3 += (src[i] > 0 ? src[i] : -src[i]);
		}
		float diff = dst[i] - src[i];
		diffs += (diff > 0 ? diff : -diff);
	}
	printf("diffs2 %lf, ave %lf (%.2lf%%)\n", diffs, diffs / num, diffs * 100 / sum);
	printf("diff1 %lf (%.2lf%%), diff2 %lf (%.2lf%%), diff3 %lf (%.2lf%%)\n"
		, diffs1 / N1, diffs1 * 100 / sum1, diffs2 / (num - N3 - N1), diffs2 * 100 / sum2, diffs3 / N3, diffs3 * 100 / sum3);
	delete[]st;
}

int CClientNetwork::getBestScale(int scale, int num, float *data, float &err)
{
	err = -1;
	int bs = -1;
	float mn, mx;
	mn = mx = data[0];
	for (int i = 1; i < num; i++){
		if (mn > data[i])
			mn = data[i];
		if (mx < data[i])
			mx = data[i];
	}
	if (mx < -mn)
		mx = -mn;
	int starts = 0;
	if (mx > 1){
		int mxi = int(mx + 0.9999);
		while (mxi){
			starts++;
			mxi >>= 1;
		}
		starts = scale - starts - 1;
	}
	else {
		while (mx * (1 << starts) < 1)
			starts++;
		starts = scale + starts - 2;
	}
	for (int k = 0; k < 8; k++){
		bool caped = false;
		float er = 0;
		for (int i = 0; i < num; i++){
			int wt = int(data[i] * (1 << (starts + k)));
			if (wt >= (1 << (wScale - 1))){
				wt = (1 << (wScale - 1)) - 1;
				caped = true;
			}
			if (wt < -(1 << (wScale - 1))){
				wt = -(1 << (wScale - 1));
				caped = true;
			}
			float e = data[i] - float(wt) / float(1 << (starts + k));
			er += e * e;
		}
		if (k == 0){
			assert(!caped);
			bs = starts + k;
			err = er;
		}
		else {
			//if (k > 1)
			//assert(caped);
			if (er < err){
				bs = starts + k;
				err = er;
			}
		}
	}
	return bs;
}

void CClientNetwork::loadConvolutionalWeights(int ilayer, ConvLayer &l, FILE *fp)
{
	int num = l.C * l.M * l.K * l.K;
	int numw = l.C * l.K * l.K;
	l.biases = new float[l.M];
	l.scales = new float[l.M];
	l.rolling_mean = new float[l.M];
	l.rolling_variance = new float[l.M];
	l.weights = new float[num];
	l.weightsi = new WTYPE[num];
	l.weights0 = new float[num];

	fread(l.biases, sizeof(float), l.M, fp);
	if (l.doBM){
		fread(l.scales, sizeof(float), l.M, fp);
		fread(l.rolling_mean, sizeof(float), l.M, fp);
		fread(l.rolling_variance, sizeof(float), l.M, fp);
	}
	fread(l.weights, sizeof(float), num, fp);
	
	//QuantizeWeights(i, l.weights, l.weights0, num);
	l.bms = new float[l.M * 2];
	l.bmsi = new int[l.M * 2];
	l.wscale = new int[l.M];
	l.bmscale = new int[l.M];
	l.conv_scale = new int[l.M];
	int widx = 0;
	int k = 0;
	float terr = 0;
	for (int i = 0; i < num; i += numw, widx++){
		float err;
		assert(widx < l.M);
		l.wscale[widx] = getBestScale(wScale, numw, l.weights + i, err);
		if (l.wscale[widx] + l.fscale_diff > 15)
			l.wscale[widx] = 15 - l.fscale_diff;
		l.conv_scale[widx] = l.wscale[widx] + l.fscale_diff;
		assert(l.conv_scale[widx] <= 15);
		//fprintf(fout, "\t%d : %d %f\n", widx, l.wscale[widx], err);
		terr += err;
		for (int k = 0; k < numw; k++){
			int wt = int(l.weights[i + k] * (1 << l.wscale[widx]));
			if (wt >= (1 << (wScale - 1)))
				wt = (1 << (wScale - 1)) - 1;
			if (wt < -(1 << (wScale - 1)))
				wt = -(1 << (wScale - 1));
			l.weightsi[i + k] = wt;
		}
	}

	for (int i = 0; i < l.M; i++){
		if (l.doBM){
			l.bms[2 * i] = l.scales[i] / (sqrt(l.rolling_variance[i]) + .000001f);
			l.bms[2 * i + 1] = l.biases[i] - l.scales[i]*l.rolling_mean[i] / (sqrt(l.rolling_variance[i]) + .000001f);
		}
		else{
			l.bms[2 * i] = 1;
			l.bms[2 * i + 1] = l.biases[i];
		}
		if (l.bms[2 * i] < 0.5){
			int starts = 0;
			while (l.bms[2 * i] * (1 << starts) < 1)
				starts++;
			assert(starts > 1);
			l.bmscale[i] = fScale + starts - 2;
			if (l.bmscale[i] > 15)
				l.bmscale[i] = 15;
		}
		else{
			int k = int(l.bms[2 * i] + 0.9999);
			int s = 0;
			while (k > 0){ s++; k >>= 1; }
			l.bmscale[i] = fScale - 1 - s;
		}
		assert(l.fscale + l.bmscale[i] - l.fscale_bm >= 0);
		assert(l.fscale + l.bmscale[i] - l.fscale_bm <= 15);
		l.bmsi[2 * i] = int(l.bms[2 * i] * (1 << l.bmscale[i]));
		l.bmsi[2 * i + 1] = int((l.bms[2 * i + 1] + (l.quant_bias ? l.quant_bias[i] : 0))  * (1 << l.fscale_bm));
		l.bmscale[i] = l.fscale + l.bmscale[i] - l.fscale_bm;
	}
	AnalysisWeights(ilayer, l.weights, num, l);
}
void CClientNetwork::LoadWeight(char *wf)
{
	FILE *fp = fopen(wf, "rb");
	assert(fp);

	int major;
	int minor;
	int revision;
	fread(&major, sizeof(int), 1, fp);
	fread(&minor, sizeof(int), 1, fp);
	fread(&revision, sizeof(int), 1, fp);
	if ((major * 10 + minor) >= 2 && major < 1000 && minor < 1000){
		char seen[8];
		fread(&seen, 8 /*sizeof(size_t)*/, 1, fp); // size_t 8 bytes on linux 4 on windows
	}
	else {
		int iseen = 0;
		fread(&iseen, sizeof(int), 1, fp);
	}
	int transpose = (major > 1000) || (minor > 1000);
	assert(transpose == 0);
	int i;
	for (i = 0; i < numLayers; ++i){
		if (layers[i].type == LT_CONV){
			loadConvolutionalWeights(i, layers[i].l.conv, fp);
		}
	}
	fclose(fp);
}

int CClientNetwork::size_network()
{
	int i;
	int count = 0;
	for (i = 0; i < numLayers; ++i){
		if (layers[i].type == LT_YOLO){
			count += layers[i].outSize;
		}

	}
	return count;
}

void CClientNetwork::LoadQuantBias(char *q_bias)
{
	FILE *fp = fopen(q_bias, "rt");
	assert(fp);
	int idx, num;
	while (fscanf(fp, "%d%d", &idx, &num) != EOF){
		assert(layers[idx].type == LT_CONV);
		ConvLayer &conv = layers[idx].l.conv;
		assert(num == conv.M);
		conv.quant_bias = new float[num];
		for (int i = 0; i < num; i++)
			fscanf(fp, "%f", conv.quant_bias + i);
	}
	fclose(fp);
}
void CClientNetwork::Init(char *cfg, char *weights, char *bias_file, char **names, image **alphabet, char *video, int cidx, int bw, int bh)
{
	demo_names = names;
	demo_alphabet = alphabet;
	buff_index = 0;
	demo_thresh = 0.5;
	demo_hier = .5;
	demo_index = 0;
	demo_done = 0;
	demo_total = 0;
	strcpy(video_file, video);
	cam_index = cidx;
	prefix = NULL;
	frames = 0;
	baseSizeW = bw;
	baseSizeH = bh;
	send_feature_time = 0;
	out1_compute_time = 0;
	out1_receive_time = 0;
	out2_compute_time = 0;
	out2_receive_time = 0;
	draw_time = 0;
	process_time = 0;
	time_count = 0;
	fetch_time = 0;
	fetch_count = 0;
	display_count = 0;
	display_time = 0;

	LoadNet(cfg);
	LoadQuantBias(bias_file);
	LoadWeight(weights);

	demo_total = size_network();
	demo_classes = GetNumClasses();
	//predictions = new (float*)[demo_frame];
	for (int i = 0; i < demo_frame; ++i){
		predictions[i] = new FEATURE_TYPE[demo_total];
	}
	avg = new float[demo_total];
	::QueryPerformanceFrequency(&li);
	//DumpWeights();
	//AnalyzeNet();
}

double CClientNetwork::what_time_is_it_now()
{
	LARGE_INTEGER sli;
	::QueryPerformanceCounter(&sli);
	//::QueryPerformanceFrequency(&li);
	return (double(sli.QuadPart)) / li.QuadPart;
}

void CClientNetwork::fetch_in_thread()
{
	double start = what_time_is_it_now();
	char *names[] = { "cap0", "cap1", "cap2" };
	int status = fill_image_from_stream(cap, buff[buff_index]);
	//save_image(buff_letter[buff_index], names[buff_index]);
	letterbox_image_into(buff[buff_index], width, height, buff_letter[buff_index]);
	double end = what_time_is_it_now();
	fetch_time += end - start;
	fetch_count++;
	//save_image(buff_letter[buff_index], "cap.png");
	if (status == 0) 
		demo_done = 1;
}

void CClientNetwork::display_in_thread()
{
	double start = what_time_is_it_now();
	show_image_cv(buff[(buff_index + 1) % 3], "Demo", ipl);
	int c = cvWaitKey(1);
	if (c != -1) c = c % 256;
	if (c == 27) {
		demo_done = 1;
		return;
	}
	else if (c == 82) {
		demo_thresh += .02;
	}
	else if (c == 84) {
		demo_thresh -= .02;
		if (demo_thresh <= .02) demo_thresh = .02;
	}
	else if (c == 83) {
		demo_hier += .02;
	}
	else if (c == 81) {
		demo_hier -= .02;
		if (demo_hier <= .0) demo_hier = .0;
	}
	double end = what_time_is_it_now();
	display_time += end - start;
	display_count++;
	return;
}

void CClientNetwork::remember_network()
{
	memcpy(predictions[demo_index], yolodata, TYPE_SIZE * demo_total);
}

detection *CClientNetwork::avg_predictions(int *nboxes)
{
	int i, j;
	int count = 0;
	fill_cpu(demo_total, 0, avg, 1);
	for (j = 0; j < demo_frame; ++j){
		//axpy_cpu(demo_total, 1. / demo_frame, predictions[j], 1, avg, 1);
	}
	//memcpy(yolodata, predictions[demo_index], TYPE_SIZE * demo_total);
	detection *dets = GetNetworkBoxes(buff[0].w, buff[0].h, demo_thresh, demo_hier, 0, 1, nboxes);
	//detection *dets = GetNetworkBoxes(width, height, demo_thresh, demo_hier, 0, 1, nboxes);
	return dets;
}

void CClientNetwork::detect_in_thread()
{
	char *outnames[] = { "out0", "out1", "out2" };
	char *feanames[] = { "f0", "f1", "f2" };
	char *datanames[] = { "data0.txt", "data1.txt", "data2.txt" };
	float nms = .4;
	static int iter = 0;
#if TEST_IMG == 1
	for (;;){
#endif
		//printf("iter %d\n", iter);
		stop_receive = false;
		//if(TEST_IMG)
		//	net_receive_thread = boost::shared_ptr<boost::thread>(
		//	new boost::thread(boost::bind(
		//	&CClientNetwork::net_receive_in_thread, this)));
		while (input_queue.size() != 0){
			unsigned char *ptr;
			{
				boost::lock_guard<boost::mutex> lock(receive_mutex);
				ptr = input_queue.front().second;
				input_queue.pop_front();
			}
			//delete[]ptr;
			{
				boost::lock_guard<boost::mutex> lock(ptr_mutex);
				palloc->Free((char *)ptr);
			}
		}
		float *X;

		image im;
		if (TEST_IMG){
			im = load_image_color("dog.jpg", 0, 0);
			image sized = letterbox_image(im, width, height);
			X = sized.data;
		}
		else{
			X = buff_letter[(buff_index + 2) % 3].data;
		}

		GetFeatures(X);
		int dsize = cur_data_size * TYPE_SIZE;
		FILE *ff = NULL;
		if(0)
			ff = fopen(feanames[(buff_index + 2) % 3], "wt");
		unsigned char *data = (unsigned char *)features_data;
		unsigned char buf[DDRLEN];
		unsigned outlen;
		/*
		int wsize = cur_weight_size;
		printf("sending weights(%p %d)...\n", weights_data, wsize);
		for (outlen = 0;;){
			unsigned len = SEND_LEN;
			if (outlen + len > wsize)
				len = wsize - outlen;
			buf[0] = SEND_WEIGHT;
			buf[1] = len & 0xff;
			buf[2] = len >> 8;
			unsigned addr = baseWaddr + outlen;
			memcpy(buf + 3, &addr, 4);
			memcpy(buf + 7, weights_data + outlen, len);
			client->send(buf, len + 7);
			outlen += len;
			if (outlen >= wsize)
				break;
		}
		printf("sending instructions(%p %d)...\n", instbuf, inst_len);
		for (outlen = 0;;){
			unsigned len = SEND_LEN;
			if (outlen + len > inst_len)
				len = inst_len - outlen;
			buf[0] = SEND_INSTRUCTION;
			buf[1] = len & 0xff;
			buf[2] = len >> 8;
			unsigned addr = inst_addr + outlen;
			memcpy(buf + 3, &addr, 4);
			memcpy(buf + 7, instbuf + outlen, len);
			client->send(buf, len + 7);
			outlen += len;
			if (outlen >= inst_len)
				break;
		}
		//send BM Weights;
		printf("sending BM weights(%p %d)...\n", bm_data, bmSize * TYPE_SIZE);
		for (outlen = 0;;){
			unsigned len = SEND_LEN;
			if (outlen + len > bmSize * TYPE_SIZE)
				len = bmSize * TYPE_SIZE - outlen;
			buf[0] = SEND_FEATURE;
			buf[1] = len & 0xff;
			buf[2] = len >> 8;
			unsigned addr = bmAddr + outlen;
			memcpy(buf + 3, &addr, 4);
			memcpy(buf + 7, bm_data + outlen, len);
			client->send(buf, len + 7);
			outlen += len;
			if (outlen >= bmSize * TYPE_SIZE)
				break;
		}*/

		//char filename[200];
		//sprintf(filename, "dataout%d.txt", iter);
		//ff = fopen(filename, "wt");
		//printf("sending featuress(%d)...\n", dsize);
		double time0 = what_time_is_it_now();
		for (outlen = 0;;){
			unsigned len = SEND_LEN;
			if (outlen + len > dsize)
				len = dsize - outlen;
			buf[0] = SEND_FEATURE;
			buf[1] = len & 0xff;
			buf[2] = len >> 8;
			unsigned addr = feature_addr + outlen;
			memcpy(buf + 3, &addr, 4);
			memcpy(buf + 7, data + outlen, len);
			client->send(buf, len + 7);
			outlen += len;
			if (ff){
				fprintf(ff, "%d", len + 7);
				for (int i = 0; i < len + 7; i++)
					fprintf(ff, " %d", buf[i]);
				fprintf(ff, "\n");
			}
			if (outlen >= dsize)
				break;
		}
		buf[0] = SEND_ADDRESS;
		buf[1] = 0;
		buf[2] = 0;
		memcpy(buf + 3, &inst_addr, 4);
		client->send(buf, 7);
		if (ff){
			fprintf(ff, "%d", 7);
			for (int i = 0; i < 7; i++)
				fprintf(ff, " %d", buf[i]);
			fprintf(ff, "\n");
			fclose(ff);
		}
		double time1 = what_time_is_it_now();
		double time2 = -1;
		double time3 = -1;
		double time4 = -1;
		double time5 = -1;
		int yolo_pass = 0;
		int totalrec = 0;
		int totalrec2 = 0;
		unsigned char *rec_addr = (unsigned char *)(yolodata + yolo_addr[yolo_pass]);
		//sprintf(filename, "datain%d.txt", iter++);
		//FILE *fp = fopen(filename, "wt");
		int idlecnt=0;
		bool idleExit = false;
		for (; yolo_pass < NUM_YOLOS;){
			while (input_queue.size() == 0){
				if (totalrec > 0){
					idlecnt++;
					if (idlecnt > 100000000){
						idleExit = true;
						break;
					}
					{
						if (totalrec2 != totalrec && (totalrec == 43104 || totalrec == 215488)){
							if (yolo_pass == 0 && time3 < 0)
								time3 = what_time_is_it_now();
							if (yolo_pass == 1 && time5 < 0)
								time5 = what_time_is_it_now();

							totalrec2 = totalrec;
							//printf("received %d\n", totalrec);
							yolo_pass++;
							rec_addr = (unsigned char *)(yolodata + yolo_addr[yolo_pass]);
							if (yolo_pass >= NUM_YOLOS)
								break;
							//totalrec = 0;
						}
					}
				}
				
			}
			if (yolo_pass >= NUM_YOLOS || idleExit)
				break;
			{
				if (yolo_pass == 0 && time2 < 0)
					time2 = what_time_is_it_now();
				if (yolo_pass == 1 && time4 < 0)
					time4 = what_time_is_it_now();
				int len;
				unsigned char *ptr;
				{
					boost::lock_guard<boost::mutex> lock(receive_mutex);
					len = input_queue.front().first;
					ptr = input_queue.front().second;
					input_queue.pop_front();
				}
				//for (int i = 0; i < len; i++)
				//	fprintf(fp, " %d%s", ptr[i], ((i % 32) == 31) ? "\n" : "");
				//fprintf(fp, "\n");
				//fflush(fp);
				memcpy(rec_addr, ptr, len);
				rec_addr += len;
				totalrec += len;
				//printf("part received %d\n", totalrec);
				{
					boost::lock_guard<boost::mutex> lock(ptr_mutex);
					palloc->Free((char *)ptr);
				}
				idlecnt = 0;
				//delete[]ptr;
			}
		}
		send_feature_time += time1 - time0;
		out1_compute_time += time2 - time1;
		out1_receive_time += time3 - time2;
		out2_compute_time += time4 - time3;
		out2_receive_time += time5 - time4;
		//fclose(fp);
		remember_network();
		detection *dets = 0;
		int nboxes = 0;
		if (TEST_IMG)
			dets = GetNetworkBoxes(im.w, im.h, demo_thresh, demo_hier, 0, 1, &nboxes);
		else
			dets = avg_predictions(&nboxes);

		if (nboxes != 3)
			nboxes = nboxes;
	
		if (nms > 0)
			//do_nms_obj(dets, nboxes, GetNumClasses(), nms);
			do_nms_sort(dets, nboxes, GetNumClasses(), nms);
		double time6 = what_time_is_it_now();
		process_time += time6 - time5;
		

		//printf("\nFPS:%.1f\n", fps);
		if (TEST_IMG){
			draw_detections(im, dets, nboxes, demo_thresh, demo_names, demo_alphabet, demo_classes);
			save_image(im, "test.jpg");
			free_detections(dets, nboxes);
			//show_image_cv(im, "Demo", ipl);
			free_image(im);
		}
		else{
			image display = buff[(buff_index + 2) % 3];
			draw_detections(display, dets, nboxes, demo_thresh, demo_names, demo_alphabet, demo_classes);
			free_detections(dets, nboxes);

			//save_image(display, outnames[(buff_index + 2) % 3]);

			demo_index = (demo_index + 1) % demo_frame;
		}
		double time7 = what_time_is_it_now();
		draw_time += time7 - time6;
		time_count++;
		if ((time_count & 0xff) == 0){
			printf("fps %.2f, send %lf, out1_comp %lf, out1_rec %lf, out2_comp %lf, out2_rec %lf, process %lf, draw %lf, fetch %lf, display %lf\n"
				, fps , send_feature_time / time_count, out1_compute_time / time_count
				, out1_receive_time / time_count, out2_compute_time / time_count
				, out2_receive_time / time_count, process_time / time_count, draw_time / time_count
				, fetch_time / fetch_count, display_time / display_count);
		}
		//if (TEST_IMG){
		//	stop_receive = true;
		//	net_receive_thread->join();
		//}
#if TEST_IMG == 1
	}
#endif
}

void CClientNetwork::free_detections(detection *dets, int n)
{
	int i;
	for (i = 0; i < n; ++i){
		//delete [](dets[i].prob);
		if (dets[i].mask)
			assert(false);
	}
	delete[](dets);
}


void CClientNetwork::send_in_thread()
{
	
}
CClientNetwork *pnet;
void CClientNetwork::EnqueueNetData(const unsigned char*data, unsigned len)
{
	assert(len < 1700);
	if (len > 1500)
		printf("size too large###################$$$$$$$$$$$\n");
	unsigned char * ptr;
	{
		boost::lock_guard<boost::mutex> lock(ptr_mutex);
		ptr = (unsigned char *)palloc->Alloc();
	}
	//unsigned char * ptr = new unsigned char[len + 1];
	memcpy(ptr, data, len);
	{
		boost::lock_guard<boost::mutex> lock(receive_mutex);
		input_queue.push_back(std::pair<int, unsigned char*>(len, ptr));
	}
}
void packet_handler(u_char *param, const struct pcap_pkthdr *header, const u_char *pkt_data)
{
	if (header->len > 42 && pkt_data[34] == 0x74 && pkt_data[35] == 0x59 && pkt_data[36] == 0x74 && pkt_data[37] == 0x59)
		pnet->EnqueueNetData(pkt_data + 42, header->len - 42);

}
void CClientNetwork::net_receive_in_thread()
{
	pcap_if_t *alldevs;
	pcap_if_t *d;
	int inum;
	int i = 0;
	pcap_t *adhandle;
	char errbuf[PCAP_ERRBUF_SIZE];
	pnet = this;
	/* Retrieve the device list */
	if (pcap_findalldevs(&alldevs, errbuf) == -1)
	{
		fprintf(stderr, "Error in pcap_findalldevs: %s\n", errbuf);
		exit(1);
	}

	/* Print the list */
	for (d = alldevs; d; d = d->next)
	{
		printf("%d. %s", ++i, d->name);
		if (d->description)
			printf(" (%s)\n", d->description);
		else
			printf(" (No description available)\n");
	}

	if (i == 0)
	{
		printf("\nNo interfaces found! Make sure Npcap is installed.\n");
		return;
	}

	printf("Enter the interface number (1-%d):", i);
	//scanf("%d", &inum);
	inum = 7;

	if (inum < 1 || inum > i)
	{
		printf("\nInterface number out of range.\n");
		/* Free the device list */
		pcap_freealldevs(alldevs);
		return;
	}

	/* Jump to the selected adapter */
	for (d = alldevs, i = 0; i< inum - 1; d = d->next, i++);

	/* Open the device */
	/* Open the adapter */
	if ((adhandle = pcap_open_live(d->name,	// name of the device
		65536,			// portion of the packet to capture. 
		// 65536 grants that the whole packet will be captured on all the MACs.
		1,				// promiscuous mode (nonzero means promiscuous)
		1000,			// read timeout
		errbuf			// error buffer
		)) == NULL)
	{
		fprintf(stderr, "\nUnable to open the adapter. %s is not supported by Npcap\n", d->name);
		/* Free the device list */
		pcap_freealldevs(alldevs);
		return;
	}

	printf("\nlistening on %s...\n", d->description);

	/* At this point, we don't need any more the device list. Free it */
	pcap_freealldevs(alldevs);

	/* start the capture */
	pcap_loop(adhandle, 0, packet_handler, NULL);

	pcap_close(adhandle);
}

void CClientNetwork::net_receive_in_thread_boost()
{
	boost::asio::io_service io_service1;
	//UDPClientSend client1(io_service1, "192.168.0.3", "29785"); //'h7459

	udp::socket sock(io_service1);
	udp::endpoint endpoint_ = boost::asio::ip::udp::endpoint(
		boost::asio::ip::address::from_string("192.168.0.3"), 29785);
	sock.open(udp::v4());
	sock.bind(endpoint_);
	boost::asio::socket_base::debug option(true);
	sock.set_option(option);


	udp::endpoint sender_endpoint;
	boost::array<unsigned char, 2550> recv_buf;
	for (;!stop_receive;){
		int len = sock.receive_from(
			boost::asio::buffer(recv_buf), sender_endpoint);
		//if(len == 1208)
		{
			unsigned char * ptr;
			{
				boost::lock_guard<boost::mutex> lock(ptr_mutex);
				ptr = (unsigned char *)palloc->Alloc();
			}
			memcpy(ptr, recv_buf.data(), len);
			{
				boost::lock_guard<boost::mutex> lock(receive_mutex);
				input_queue.push_back(std::pair<int, unsigned char*>(len, ptr));
			}
			//printf("pushed! %d\n", que.size());
		}
	}
}
void CClientNetwork::netSetup()
{
	palloc = new CAllocAssist<MAX_NET_LEN>;
	do_send_data = false;
	weights_data = new unsigned char[16000000];
	features_data = new char[16000000];
	client = new UDPClient(io_service, "192.168.0.2", "29785"); //'h7459
	//net_receive_thread = boost::shared_ptr<boost::thread>(
	//	new boost::thread(&CClientNetwork::net_receive_in_thread, this));
	//if (!TEST_IMG)
	net_receive_thread = boost::shared_ptr<boost::thread>(
		new boost::thread(boost::bind(
		&CClientNetwork::net_receive_in_thread_boost, this)));

	std::map<unsigned, void *> out_mp;
	DumpInfo * head = GenInsts(baseSizeW, baseSizeH, out_mp);
	CModelIF model;

	//model.BuildModel(12, 15);
	cur_data_size = (cur_data_size & (~(INTERFACE_LEN - 1))) + (INTERFACE_LEN );
	cur_weight_size = (cur_weight_size & (~(INTERFACE_LEN - 1))) + (INTERFACE_LEN );
	int osize = max_memory_size * TYPE_SIZE;
	int wsize = cur_weight_size;
	bm_data = new unsigned char[bmSize * TYPE_SIZE];
	memcpy(bm_data, features_data, bmSize * TYPE_SIZE);
	//unsigned char *data = (unsigned char *)features_data;
	int dsize = cur_data_size * TYPE_SIZE;

	GlobalInstruction *pp = model.ExpandInstructions(pinsts);
	
	instbuf = model.EncodeInstructions(pp, inst_len);
	inst_len = (inst_len & (~(INTERFACE_LEN - 1))) + (INTERFACE_LEN );
	delete[]pp;
		
	inst_addr = osize + dsize;
	bmAddr = osize;
	unsigned outlen = 0;
	unsigned char buf[DDRLEN];
	//send weight;
	
	FILE *fnet = fopen("net.txt", "wt");
	printf("sending weights...\n");
	for (outlen = 0;;){
		unsigned len = SEND_LEN;
		if (outlen + len > wsize)
			len = wsize - outlen;
		buf[0] = SEND_WEIGHT;
		buf[1] = len & 0xff;
		buf[2] = len >> 8;
		unsigned addr = baseWaddr + outlen;
		memcpy(buf + 3, &addr, 4);
		memcpy(buf + 7, weights_data + outlen, len);
		client->send(buf, len + 7);
		outlen += len;
		fprintf(fnet, "%d", len + 7);
		for (int k = 0; k < len+7; k++)
			fprintf(fnet, " %d", buf[k]);
		fprintf(fnet, "\n");
		if (outlen >= wsize)
			break;
	}
	//send instructions;
	printf("sending instructions...\n");
	for (outlen = 0;;){
		unsigned len = SEND_LEN;
		if (outlen + len > inst_len)
			len = inst_len - outlen;
		buf[0] = SEND_INSTRUCTION;
		buf[1] = len & 0xff;
		buf[2] = len >> 8;
		unsigned addr = inst_addr + outlen;
		memcpy(buf + 3, &addr, 4);
		memcpy(buf + 7, instbuf + outlen, len);
		client->send(buf, len + 7);
		fprintf(fnet, "%d", len + 7);
		for (int k = 0; k < len + 7; k++)
			fprintf(fnet, " %d", buf[k]);
		fprintf(fnet, "\n");
		outlen += len;
		if (outlen >= inst_len)
			break;
	}
	//send BM Weights;
	printf("sending BM weights...\n");
	for (outlen = 0;;){
		unsigned len = SEND_LEN;
		if (outlen + len > bmSize * TYPE_SIZE)
			len = bmSize * TYPE_SIZE - outlen;
		buf[0] = SEND_FEATURE;
		buf[1] = len & 0xff;
		buf[2] = len >> 8;
		unsigned addr = bmAddr + outlen;
		memcpy(buf + 3, &addr, 4);
		memcpy(buf + 7, bm_data + outlen, len);
		client->send(buf, len + 7);
		fprintf(fnet, "%d", len + 7);
		for (int k = 0; k < len + 7; k++)
			fprintf(fnet, " %d", buf[k]);
		fprintf(fnet, "\n");
		outlen += len;
		if (outlen >= bmSize * TYPE_SIZE)
			break;
	}
	fclose(fnet);
	
	printf("setup finished.\n");
	size = layers[0].l.conv.C * layers[0].l.conv.W * layers[0].l.conv.H;
	datai = new int[size];
}

void CClientNetwork::Run()
{
	boost::shared_ptr<boost::thread> detect_thread;
	boost::shared_ptr<boost::thread> fetch_thread;

	srand(2222222);

	netSetup();
	if(cam_index >= 0){
		cap = cvCaptureFromCAM(cam_index);

		if (width){
			cvSetCaptureProperty(cap, CV_CAP_PROP_FRAME_WIDTH, width);
		}
		if (height){
			cvSetCaptureProperty(cap, CV_CAP_PROP_FRAME_HEIGHT, height);
		}
		if (frames){
			cvSetCaptureProperty(cap, CV_CAP_PROP_FPS, frames);
		}
	}else{
		printf("video file: %s\n", video_file);
		cap = cvCaptureFromFile(video_file);
	}

	if (!cap){
		printf("Couldn't connect to webcam.\n");
		return;
	}
	Sleep(1000);
	buff[0] = get_image_from_stream(cap);
	buff[1] = copy_image(buff[0]);
	buff[2] = copy_image(buff[0]);
	buff_letter[0] = letterbox_image(buff[0], width, height);
	buff_letter[1] = letterbox_image(buff[0], width, height);
	buff_letter[2] = letterbox_image(buff[0], width, height);
	if (TEST_IMG){
		image im = load_image_color("dog.jpg", 0, 0);
		ipl = cvCreateImage(cvSize(im.w, im.h), IPL_DEPTH_8U, im.c);
		free_image(im);
	}
	else
 		ipl = cvCreateImage(cvSize(buff[0].w, buff[0].h), IPL_DEPTH_8U, buff[0].c);

	int count = 0;
	if (!prefix)
	{
		bool fullscreen = false;
		cvNamedWindow("Demo", CV_WINDOW_NORMAL);
		if (fullscreen){
			cvSetWindowProperty("Demo", CV_WND_PROP_FULLSCREEN, CV_WINDOW_FULLSCREEN);
		}
		else {
			cvMoveWindow("Demo", 0, 0);
			cvResizeWindow("Demo", 1352, 1013);
		}
	}

	demo_time = what_time_is_it_now();

	while (!demo_done){
		buff_index = (buff_index + 1) % 3;
		if (!TEST_IMG)
		fetch_thread = boost::shared_ptr<boost::thread>(
			new boost::thread(boost::bind(
			&CClientNetwork::fetch_in_thread, this)));
		detect_thread = boost::shared_ptr<boost::thread>(
			new boost::thread(boost::bind(
			&CClientNetwork::detect_in_thread, this)));

		if (!prefix)
		{
			fps = 1. / (what_time_is_it_now() - demo_time);
			demo_time = what_time_is_it_now();
			if (!TEST_IMG)
				display_in_thread();
		}
		else{
			char name[256];
			sprintf(name, "%s_%08d", prefix, count);
			save_image(buff[(buff_index + 1) % 3], name);
		}
		if (!TEST_IMG)
			fetch_thread->join();
		detect_thread->join();
		++count;
	}
}

int CClientNetwork::GetW2(CloudDesign::DATA_MODE mode, int W, int& w1)
{
	if (mode == CloudDesign::MODE_FOUR)
		return 0;
	if (mode == CloudDesign::MODE_TWO){
		if (W == w1 * 2)
			return 0;
		else
			return W - w1;
	}
	/*
	W = W % (4 * w1);
	if (W == 0)
		return 0;
		
	if (W % 4 == 0){
		w1 = W / 4;
		return 0;
	}*/
	if (W >= 4 * w1)
		return 0;
	assert(W - 3 * w1 > 0);
	return W - 3 * w1;
}

//memcpy(weights_data + cur_weight_size, weights3, wSize * sizeof(weights3[0]));
//cur_weight_size += wSize;
void CClientNetwork::copyWeights(DTYPE *weights3, int wSize)
{
	assert((wSize & 1) == 0);
	for (int i = 0; i < wSize; i++){
		int v = weights3[i];
		if (v < -128)
			v = -128;
		if (v > 127)
			v = 127;
		weights_data[cur_weight_size++] = v;
	}
	return;
	for (int i = 0; i < wSize; i += 2){
		int v1 = weights3[i];
		int v2 = weights3[i+1];
		if (v1 < -(1 << 11))
			v1 = -(1 << 11);
		if (v1 > ((1 << 11) - 1))
			v1 = ((1 << 11) - 1);
		if (v2 < -(1 << 11))
			v2 = -(1 << 11);
		if (v2 >((1 << 11) - 1))
			v2 = ((1 << 11) - 1);

		
		weights_data[cur_weight_size] = v1 & 0xff;
		weights_data[cur_weight_size+1] = ((v1>>8) & 0xf) | ((v2 &0xf)<<4);
		weights_data[cur_weight_size+2] = v2 >> 4;
		
		int buf1 = ((weights_data[cur_weight_size] & 0xff) | ((weights_data[cur_weight_size + 1] & 0xf) << 8));
		int buf2 = ((weights_data[cur_weight_size + 1] >> 4) & 0xf) | (unsigned(weights_data[cur_weight_size + 2]) << 4);
		if (buf1 & (1 << 11))
			buf1 |= 0xfffff << 12;
		if (buf2 & (1 << 11))
			buf2 |= 0xfffff << 12;
		assert(buf1 == v1);
		assert(buf2 == v2);
		
		cur_weight_size += 3;


	}
}


DumpInfo * CClientNetwork::GenInsts(int baseSizeW, int baseSizeH, std::map<unsigned, void *>& out_mp)
{
	AnalyzeNet();
	int yoloPos = 0;
	int yolo_pass = 0;
	pinsts = new CloudDesign::GlobalInstruction[numLayers * 2];
	memset(pinsts, 0, sizeof(CloudDesign::GlobalInstruction) *(numLayers * 2));
	int idx = 0;
	int seqNum = 0;
	int reqNum = 0;
	FILE *fp = fopen("insts.txt", "wt");
	assert(fp);
	DumpInfo *head = NULL;
	DumpInfo *prev = NULL;
	cur_weight_size = 0;
	cur_data_size = 0;
	std::map<int, int> seqmp;
	unsigned yoloStart = max_memory_size;
	unsigned yolosize = 0;
	for (int i = 0; i < numLayers; ++i){
		if (layers[i].type != LT_YOLO)
			continue;
		yolosize += (layers[i].outSize & (~(INTERFACE_LEN - 1))) + (INTERFACE_LEN );
	}
	max_memory_size += yolosize;
	max_memory_size = (max_memory_size & (~(INTERFACE_LEN - 1))) + (INTERFACE_LEN );
	fprintf(fp, "YoloStart %d, BM start %d\n", yoloStart * TYPE_SIZE, max_memory_size * TYPE_SIZE);
	for (int i = 0; i < numLayers; ++i){
		if (layers[i].type != LT_CONV)
			continue;
		fprintf(fp, "i = %d\n", i);
		ConvLayer &conv = layers[i].l.conv;
		CloudDesign::DATA_MODE mode;
		int w1 = baseSizeW;
		int h1 = baseSizeH;
#ifdef S2_OPTIMIZE
		if (conv.S == 2){
			w1 *= 2;
			h1 *= 2;
			if (conv.W == 2 * baseSizeW)
				mode = CloudDesign::MODE_FOUR;
			else
				mode = CloudDesign::MODE_TWO;
		}
		else
#endif
			if (conv.W <= baseSizeW)
				mode = CloudDesign::MODE_FOUR;
			else if (conv.W <= 2 * baseSizeW)
				mode = CloudDesign::MODE_TWO;
			else
				mode = CloudDesign::MODE_ONE;


			int wreq, numSegs;
			bool weightRam = false;
			if (mode == CloudDesign::MODE_ONE){
				wreq = 42;
				int len = conv.H / h1;
				if (conv.H % h1)
					len++;
				int len1 = conv.W / (w1 * 4);
				if (conv.W % (w1 * 4))
					len1++;
				numSegs = len * len1;
				if (conv.M * conv.C * conv.K * conv.K < WEIGHT_SIZE)
					weightRam = true;
				fprintf(fp, "\tMode_One");
			}
			else if (mode == CloudDesign::MODE_TWO){
				wreq = 84;
				int len = conv.H / h1;
				if (conv.H % h1)
					len++;
				int len1 = conv.W / (w1 * 2);
				if (conv.W % (w1 * 2))
					len1++;
				numSegs = len * len1;
				fprintf(fp, "\tMode_Two");
#ifdef S2_OPTIMIZE
				if (conv.S == 2)
					if (conv.M * conv.C * conv.K * conv.K < WEIGHT_SIZE)
						weightRam = true;
#endif
			}
			else {
				numSegs = 1;
				wreq = 168;
				fprintf(fp, "\tMode_Four");
			}
#ifdef BATCH1_OPTIMIZE
			int b12 = 0, b9 = 0, b0 = h1;
			bool doBatch3 = false;


			if (conv.K == 1){
				if (mode == CloudDesign::MODE_ONE){
					if (conv.M > 48){
						doBatch3 = true;
						GetBatchNum(conv.H, b12, b9, b0);
						numSegs = conv.W / 4 / w1 * (b12 + b9 + (b0 == 0 ? 0 : 1));
					}

				}
				else if (mode == CloudDesign::MODE_TWO){
					if (conv.M > 96){
						doBatch3 = true;
						GetBatchNum(conv.H, b12, b9, b0);
					}
				}
				else {
					if (conv.M > 192){
						doBatch3 = true;
					}
				}
			}
#endif
			DTYPE * bms = new DTYPE[conv.M * BM_NUM];
			for (int j = 0, pos = 0; j < conv.M; j++){
				DTYPE v = conv.bmsi[j * 2];
				if (v < -(1 << 7))
					v = -(1 << 7);
				else if (v >((1 << 7) - 1))
					v = ((1 << 7) - 1);
				bms[pos++] = v;
				v = conv.bmsi[j * 2 + 1];
				if (v < -(1 << 7))
					v = -(1 << 7);
				else if (v >((1 << 7) - 1))
					v = ((1 << 7) - 1);
				bms[pos++] = v;
				unsigned char s = (conv.conv_scale[j] << 4) | conv.bmscale[j];
				bms[pos++] = char(s);
			}
			conv.weights2 = new DTYPE[conv.K * conv.K * conv.C * conv.M + conv.M * BM_NUM];
			//conv.weights2 = new DTYPE[conv.K * conv.K * conv.C * conv.M];
			int start[5], Kh[4], Ks[4], Kt[4], Kbh[4], Kbe[4];
			Kbh[0] = 0;
			memset(start, 0, sizeof(start[0]) * 5);
			memset(Kh, 0, sizeof(Kh[0]) * 4);
			memset(Ks, 0, sizeof(Ks[0]) * 4);
			memset(Kt, 0, sizeof(Kt[0]) * 4);

			if (mode == CloudDesign::MODE_FOUR){
#ifdef BATCH1_OPTIMIZE
				if (doBatch3)
					transformWeightsBatch(conv.weights2, start, Kh, Ks, Kt, Kbh, Kbe, conv.weightsi, conv.M, conv.C, conv.K, 4, 48);
				else
#endif
					transformWeights(conv.weights2, start, Kh, Ks, Kt, conv.weightsi, bms, BM_NUM, conv.M, conv.C, conv.K
					, CG_NUM, CG_NUM, CG_NUM, CG_NUM);
				//start[4] = conv.K * conv.K * conv.C * conv.M;
			}
			else if (mode == CloudDesign::MODE_TWO){
#ifdef BATCH1_OPTIMIZE
				if (doBatch3)
					transformWeightsBatch(conv.weights2, start, Kh, Ks, Kt, Kbh, Kbe, conv.weightsi, conv.M, conv.C, conv.K, 2, 48);
				else
#endif
					transformWeights(conv.weights2, start, Kh, Ks, Kt, conv.weightsi, bms, BM_NUM, conv.M, conv.C, conv.K, CG_NUM
					, conv.M * conv.K - CG_NUM > CG_NUM ? CG_NUM : conv.M * conv.K - CG_NUM);
				//start[2] = conv.K * conv.K * conv.C * conv.M;
			}
			else{
				Kt[0] = conv.M - 1;
#ifdef BATCH1_OPTIMIZE
				if (doBatch3)
					transformWeightsBatch(conv.weights2, start, Kh, Ks, Kt, Kbh, Kbe, conv.weightsi, conv.M, conv.C, conv.K, 1, 48);
				else
#endif
					transformWeights(conv.weights2, start, conv.weightsi, bms, BM_NUM, conv.M, conv.C, conv.K
					, conv.M * conv.K > CG_NUM ? CG_NUM : conv.M * conv.K);
				//start[1] = conv.K * conv.K * conv.C * conv.M;
			}
			delete[]bms;
			int dropSize;
			int wSize;
			DTYPE *weights3 = transformWeights2((DTYPE *)conv.weights2, mode, start, &dropSize, &wSize);
			int reqN = reqNum;

			int rpad = conv.pad;
			if (((h1 - conv.K + 2 * conv.pad) % conv.S) != 0)
				rpad--;
			int w2 = GetW2(mode, conv.W, w1);

			pinsts[idx].type = CloudDesign::CONV;
			pinsts[idx].i.inst.mode = mode;
			pinsts[idx].i.inst.W2 = w2;
			pinsts[idx].i.inst.reqSeqNum = reqN;
			pinsts[idx].i.inst.reqSeqNumW = reqNum + 1;
			pinsts[idx].i.inst.reqProgressW = wreq;// KERNEL * KERNEL * CHANNEL * OUTSIZE;
			pinsts[idx].i.inst.seqNum = seqNum + 2;
			pinsts[idx].i.inst.reqProgress = 0;
			//pinsts[idx].i.inst.wScale = wScale;
			pinsts[idx].i.inst.fScale = fScale;
			pinsts[idx].i.inst.W = conv.W;
			pinsts[idx].i.inst.H = conv.H;
			pinsts[idx].i.inst.C = conv.C;
			pinsts[idx].i.inst.W1 = w1;
			pinsts[idx].i.inst.H1 = h1;
#ifdef BATCH1_OPTIMIZE
			if (!doBatch3)
				pinsts[idx].i.inst.doBatch3 = 0;
			else{
				pinsts[idx].i.inst.doBatch3 = 1;
				pinsts[idx].i.inst.Kbh[0] = Kbh[0];
				pinsts[idx].i.inst.Kbh[1] = Kbh[1];
				pinsts[idx].i.inst.Kbh[2] = Kbh[2];
				pinsts[idx].i.inst.Kbh[3] = Kbh[3];
				pinsts[idx].i.inst.Kbe[0] = Kbe[0];
				pinsts[idx].i.inst.Kbe[1] = Kbe[1];
				pinsts[idx].i.inst.Kbe[2] = Kbe[2];
				pinsts[idx].i.inst.Kbe[3] = Kbe[3];
				pinsts[idx].i.inst.batch12 = b12;
				pinsts[idx].i.inst.batch9 = b9;
				pinsts[idx].i.inst.batch0 = b0;
			}
#endif
			pinsts[idx].i.inst.Waddr = cur_weight_size + baseWaddr;
			copyWeights(weights3, wSize);
			//memcpy(weights_data + cur_weight_size, weights3, wSize * sizeof(weights3[0]));
			//cur_weight_size += wSize;

			pinsts[idx].i.inst.isUseWRam = weightRam ? 1 : 0;
			pinsts[idx].i.inst.wDropSize = dropSize;
			pinsts[idx].i.inst.WSize = wSize;
			pinsts[idx].i.inst.WEnd[0] = start[1];
			pinsts[idx].i.inst.WEnd[1] = start[2];
			pinsts[idx].i.inst.WEnd[2] = start[3];
			pinsts[idx].i.inst.WEnd[3] = start[4];
			pinsts[idx].i.inst.S = conv.S;
			pinsts[idx].i.inst.lPad = conv.pad;
			pinsts[idx].i.inst.rPad = rpad;
			pinsts[idx].i.inst.K = conv.K;
			pinsts[idx].i.inst.M = conv.M; // filter size, filter layers
			pinsts[idx].i.inst.Kh[0] = Kh[0];
			pinsts[idx].i.inst.Ks[0] = Ks[0];
			pinsts[idx].i.inst.Kt[0] = Kt[0]; // start, stride, and tail(inclusive)
			pinsts[idx].i.inst.Kh[1] = Kh[1];
			pinsts[idx].i.inst.Ks[1] = Ks[1];
			pinsts[idx].i.inst.Kt[1] = Kt[1]; // start, stride, and tail(inclusive)
			pinsts[idx].i.inst.Kh[2] = Kh[2];
			pinsts[idx].i.inst.Ks[2] = Ks[2];
			pinsts[idx].i.inst.Kt[2] = Kt[2]; // start, stride, and tail(inclusive)
			pinsts[idx].i.inst.Kh[3] = Kh[3];
			pinsts[idx].i.inst.Ks[3] = Ks[3];
			pinsts[idx].i.inst.Kt[3] = Kt[3]; // start, stride, and tail(inclusive)
			
			//memcpy(features_data + cur_data_size, conv.bmsi, conv.M * 2 * sizeof(features_data[0]));
			//cur_data_size += conv.M * 2;

			pinsts[idx].i.inst.wLRelu = conv.wrelui;
			pinsts[idx].i.inst.wScale = conv.lr_scale;
			pinsts[idx].i.inst.doRelu = conv.isRelu ? 1 : 0;
			pinsts[idx].i.inst.doLRelu = conv.isLRelu ? 1 : 0;
			pinsts[idx].i.inst.doBM = 1;
			pinsts[idx].i.inst.doUpSample = layers[i + 1].type == LT_UPS;
			pinsts[idx].i.inst.progressMaster = (mode == MODE_ONE ? 3 : 0);
			pinsts[idx].i.inst.isConv = 1;

			fprintf(fp, "\tCONV seq %d, req %d, reqw %d, progw %d, W %d, H %d, C %d, W1 %d, H1 %d, S %d, k %d, M %d, p %d\n"
				, pinsts[idx].i.inst.seqNum, pinsts[idx].i.inst.reqSeqNum, pinsts[idx].i.inst.reqSeqNumW, pinsts[idx].i.inst.reqProgressW
				, pinsts[idx].i.inst.W, pinsts[idx].i.inst.H, pinsts[idx].i.inst.C, pinsts[idx].i.inst.W1, pinsts[idx].i.inst.H1
				, pinsts[idx].i.inst.S, pinsts[idx].i.inst.K, pinsts[idx].i.inst.M, pinsts[idx].i.inst.lPad);
			fprintf(fp, "\tWa %d, we0 %d, we1 %d, we2 %d, we3 %d, wrelu %d, %s %s %s weightram?(%s)\n"
				, pinsts[idx].i.inst.Waddr, pinsts[idx].i.inst.WEnd[0], pinsts[idx].i.inst.WEnd[1], pinsts[idx].i.inst.WEnd[2]
				, pinsts[idx].i.inst.WEnd[3], pinsts[idx].i.inst.wLRelu
				, pinsts[idx].i.inst.doRelu ? "Relu" : "", pinsts[idx].i.inst.doLRelu ? "LRelu" : "", pinsts[idx].i.inst.doUpSample ? "UP" : ""
				, pinsts[idx].i.inst.isUseWRam ? "Y" : "N");
			fprintf(fp, "\t Kh Ks Kt : (%d, %d, %d) (%d, %d, %d) (%d, %d, %d) (%d, %d, %d)\n"
				, pinsts[idx].i.inst.Kh[0], pinsts[idx].i.inst.Ks[0], pinsts[idx].i.inst.Kt[0]
				, pinsts[idx].i.inst.Kh[1], pinsts[idx].i.inst.Ks[1], pinsts[idx].i.inst.Kt[1]
				, pinsts[idx].i.inst.Kh[2], pinsts[idx].i.inst.Ks[2], pinsts[idx].i.inst.Kt[2]
				, pinsts[idx].i.inst.Kh[3], pinsts[idx].i.inst.Ks[3], pinsts[idx].i.inst.Kt[3]);
			if (i == 0){
				pinsts[idx].i.inst.Maddr = 0;
				pinsts[idx].i.inst.isMaddr_a = 0;
				pinsts[idx].i.inst.isMaddr_b = 0;
			}
			else{
				pinsts[idx].i.inst.Maddr = (layers[i - 1].memStart) * TYPE_SIZE;
				if (layers[i - 1].isDDR){
					pinsts[idx].i.inst.isMaddr_a = 0;
					pinsts[idx].i.inst.isMaddr_b = 0;
				}
				else if (layers[i - 1].isRamA){
					pinsts[idx].i.inst.isMaddr_a = 1;
					pinsts[idx].i.inst.isMaddr_b = 0;
				}
				else{
					pinsts[idx].i.inst.isMaddr_a = 0;
					pinsts[idx].i.inst.isMaddr_b = 1;
				}
			}
			fprintf(fp, "\tfeature %d %s", pinsts[idx].i.inst.Maddr
				, pinsts[idx].i.inst.isMaddr_a ? "A" : (pinsts[idx].i.inst.isMaddr_b ? "B" : "M"));
			if (layers[i + 1].type == LT_RES){
				int ridx = layers[i + 1].l.res.idx;
				pinsts[idx].i.inst.Res_addr = (layers[ridx].memStart) * TYPE_SIZE;
				pinsts[idx].i.inst.isRaddr_a = layers[ridx].isRamA; //for Res do not care
				pinsts[idx].i.inst.doRes = 1;
				fprintf(fp, " Res %d %s", pinsts[idx].i.inst.Res_addr, pinsts[idx].i.inst.isRaddr_a ? "A" : "B");
			}
			else
				pinsts[idx].i.inst.doRes = 0;

			if (layers[i + 1].type == LT_YOLO){
				pinsts[idx].i.inst.Oaddr = (yoloStart + yoloPos) * TYPE_SIZE;// unsigned(yolodata + yoloPos);
				out_mp[pinsts[idx].i.inst.Oaddr] = yolodata + yoloPos;
				yolo_addr[yolo_pass] = yoloPos;
				yolo_size[yolo_pass] = layers[i + 1].outSize;
				yolo_pass++;
				pinsts[idx].i.inst.isOaddr_a = 0;
				pinsts[idx].i.inst.isOaddr_b = 0;
				pinsts[idx].i.inst.maxpool_stride = 1;
				pinsts[idx].i.inst.maxpool_size = 1;
				fprintf(fp, " Out %d, M\n", pinsts[idx].i.inst.Oaddr);
				//if ((i + 1) == (numLayers - 1)){
				idx++;
				pinsts[idx].type = CloudDesign::END;
				pinsts[idx].i.end.isRamA = 0;
				pinsts[idx].i.end.isRamB = 0;
				pinsts[idx].i.end.hasMore = ((i + 1) != (numLayers - 1));
				pinsts[idx].i.end.reqSeqNum = seqNum + numSegs + 1;
				pinsts[idx].i.end.oAddr = pinsts[idx - 1].i.inst.Oaddr;
				pinsts[idx].i.end.oSize = layers[i + 1].outSize * TYPE_SIZE;
				//}
				seqYoloMp[seqNum + numSegs + 1] = std::pair<int, unsigned>(i + 1, yoloPos);
				layers[i + 1].outputss = yolodata + yoloPos;
				layers[i + 1].outputsi = 0;
				yoloPos += (layers[i + 1].outSize & (~(INTERFACE_LEN - 1))) + (INTERFACE_LEN );
				fprintf(fp, "\tYolo end req %d, addr %d, %d\n", pinsts[idx].i.end.reqSeqNum, pinsts[idx].i.end.oAddr, pinsts[idx].i.end.oSize);

			}
			else if (layers[i + 1].type == LT_MAXPOOL){
				pinsts[idx].i.inst.Oaddr = (layers[i + 1].memStart) * TYPE_SIZE;
				if (layers[i + 1].isDDR){
					pinsts[idx].i.inst.isOaddr_a = 0;
					pinsts[idx].i.inst.isOaddr_b = 0;
				}
				else if (layers[i + 1].isRamA){
					pinsts[idx].i.inst.isOaddr_a = 1;
					pinsts[idx].i.inst.isOaddr_b = 0;
				}
				else{
					pinsts[idx].i.inst.isOaddr_a = 0;
					pinsts[idx].i.inst.isOaddr_b = 1;
				}
				fprintf(fp, " Out %d, %s Maxpool\n", pinsts[idx].i.inst.Oaddr, pinsts[idx].i.inst.isOaddr_a ? "A" : "B");
				pinsts[idx].i.inst.maxpool_stride = layers[i + 1].l.maxpool.stride;
				pinsts[idx].i.inst.maxpool_size = layers[i + 1].l.maxpool.size;
			}
			else{
				pinsts[idx].i.inst.Oaddr = (layers[i].memStart) * TYPE_SIZE;
				if (layers[i].isDDR){
					pinsts[idx].i.inst.isOaddr_a = 0;
					pinsts[idx].i.inst.isOaddr_b = 0;
				}
				else if (layers[i].isRamA){
					pinsts[idx].i.inst.isOaddr_a = 1;
					pinsts[idx].i.inst.isOaddr_b = 0;
				}
				else{
					pinsts[idx].i.inst.isOaddr_a = 0;
					pinsts[idx].i.inst.isOaddr_b = 1;
				}
				fprintf(fp, " Out %d, %s\n", pinsts[idx].i.inst.Oaddr, pinsts[idx].i.inst.isOaddr_a ? "A" : "B");
				pinsts[idx].i.inst.maxpool_stride = 1;
				pinsts[idx].i.inst.maxpool_size = 1;
			}

			seqNum += numSegs + 1;
			seqmp[i] = seqNum;
			DumpInfo *pdi = new DumpInfo;
			if (layers[i + 1].type == LT_YOLO){
				pdi->isA = pinsts[idx - 1].i.inst.isOaddr_a;
				pdi->isB = pinsts[idx - 1].i.inst.isOaddr_b;
				pdi->reqSeq = seqNum;
				pdi->start = pinsts[idx - 1].i.inst.Oaddr;
			}
			else{
				pdi->isA = pinsts[idx].i.inst.isOaddr_a;
				pdi->isB = pinsts[idx].i.inst.isOaddr_b;
				pdi->reqSeq = seqNum;
				pdi->start = pinsts[idx].i.inst.Oaddr;
			}
			if (pinsts[idx].i.inst.doRes || pinsts[idx].i.inst.doUpSample || layers[i + 1].type == LT_MAXPOOL){
				pdi->len = layers[i + 1].outSize;
				char name[100];
				sprintf(name, "inputs1_%d.txt", i + 2);
				pdi->name = name;
			}
			else {
				pdi->len = layers[i].outSize;
				char name[100];
				sprintf(name, "inputs1_%d.txt", i + 1);
				pdi->name = name;
			}
			pdi->next = NULL;
			if (prev == NULL)
				prev = head = pdi;
			else{
				prev->next = pdi;
				prev = pdi;
			}
			idx++;
			reqNum = seqNum;
			if (layers[i + 1].type == LT_MAXPOOL && layers[i].lastUsed > layers[i + 1].lastUsed){
				pinsts[idx] = pinsts[idx - 1];
				pinsts[idx].i.inst.Oaddr = (layers[i].memStart) * TYPE_SIZE;
				if (layers[i].isDDR){
					pinsts[idx].i.inst.isOaddr_a = 0;
					pinsts[idx].i.inst.isOaddr_b = 0;
				}
				else if (layers[i].isRamA){
					pinsts[idx].i.inst.isOaddr_a = 1;
					pinsts[idx].i.inst.isOaddr_b = 0;
				}
				else{
					pinsts[idx].i.inst.isOaddr_a = 0;
					pinsts[idx].i.inst.isOaddr_b = 1;
				}
				fprintf(fp, " Out %d, %s\n", pinsts[idx].i.inst.Oaddr, pinsts[idx].i.inst.isOaddr_a ? "A" : "B");
				pinsts[idx].i.inst.maxpool_stride = 1;
				pinsts[idx].i.inst.maxpool_size = 1;
				pinsts[idx].i.inst.seqNum = seqNum + 2;

				seqNum += numSegs + 1;
				seqmp[i + 1] = seqNum;
				DumpInfo *pdi = new DumpInfo;
				pdi->isA = pinsts[idx].i.inst.isOaddr_a;
				pdi->isB = pinsts[idx].i.inst.isOaddr_b;
				pdi->reqSeq = seqNum;
				pdi->start = pinsts[idx].i.inst.Oaddr;
				pdi->len = layers[i].outSize;
				char name[100];
				sprintf(name, "inputs1_%d.txt", i + 3);
				pdi->name = name;
				pdi->next = NULL;
				if (prev == NULL)
					prev = head = pdi;
				else{
					prev->next = pdi;
					prev = pdi;
				}
				idx++;

			}
			delete[]weights3;
	}
	//align memory address for input data
	cur_data_size = (cur_data_size & (~(INTERFACE_LEN - 1))) + (INTERFACE_LEN );
	feature_addr = (max_memory_size + cur_data_size) * TYPE_SIZE;
	pinsts[0].i.inst.Maddr = feature_addr;// conv.bmsi;
	bmSize = cur_data_size;
	int sz = layers[0].l.conv.C * layers[0].l.conv.W * layers[0].l.conv.H;
	cur_data_size += sz;
	fprintf(fp, "input data address %d\n", pinsts[0].i.inst.Maddr);
	fclose(fp);
	return head;
}

void CClientNetwork::GetFeatures(float *input)
{
	int sz = layers[0].l.conv.C * layers[0].l.conv.W * layers[0].l.conv.H;
	for (int i = 0; i < sz; i++)
		datai[i] = int(input[i] * (1 << fscale0));

	cur_data_size = 0;
	for (int j = 0; j < sz; j++){
		DTYPE v = datai[j];
		if (v < -(1 << 7))
			features_data[cur_data_size + j] = -(1 << 7);
		else if (v >((1 << 7) - 1))
			features_data[cur_data_size + j] = ((1 << 7) - 1);
		else
			features_data[cur_data_size + j] = v;
	}
	//memcpy(features_data + cur_data_size, datai, sz * sizeof(features_data[0]));
	cur_data_size += sz;
}
/*
   Compute lastUsed layer index for each layer
  , which indicate how long the layer output 
  must stay in memory
*/
void CClientNetwork::updateLifeSpan()
{
	int i;
	for (i = 0; i < numLayers; i++){
		layers[i].isSet = false;
	}
	for (i = numLayers - 1; i > 0; i--){
		if (layers[i].type == LT_CONV || layers[i].type == LT_YOLO){
			if (layers[i - 1].isSet)
				continue;
			layers[i - 1].lastUsed = i;
			layers[i - 1].isSet = true;
		}
		else if (layers[i].type == LT_UPS || layers[i].type == LT_MAXPOOL){
			if (layers[i - 1].isSet)
				continue;
			layers[i - 1].lastUsed = layers[i].lastUsed;
			layers[i - 1].isSet = true;
		}
		else if (layers[i].type == LT_RES){
			layers[i - 1].lastUsed = layers[i].lastUsed;
			layers[i - 1].isSet = true;
			layers[layers[i].l.res.idx].lastUsed = i;// layers[i].lastUsed;
			layers[layers[i].l.res.idx].isSet = true;
		}
		else if (layers[i].type == LT_ROUTE){
			for (int k = 0; k < layers[i].l.route.num; k++){
				layers[layers[i].l.route.layers[k]].lastUsed = layers[i].lastUsed;
				layers[layers[i].l.route.layers[k]].isSet = true;
			}
		}
		else
			assert(false);
	}
}

/*
Rules:
1. Route 2 outputs must be same bank
2. LT_RES 2 outputs different bank
3. LT_CONV input output could be same bank
4. LT_UPS, LT_YOLO no change

Three passes:
1. Determine the RAMs for multiple input ROUTE layers, and propagate through RES layer
2. Propagate back RAMs with known assignments
3. Forward pass, assign remains
*/
void CClientNetwork::assignMemory()
{
	int i;
	for (i = 0; i < numLayers; i++){
		layers[i].isSet = false;
	}
	bool isA = true;
	int lastRoute = -1;
	for (i = numLayers - 1; i > 0; i--){
		if (layers[i].type == LT_ROUTE && layers[i].l.route.num > 1){
			for (int k = 0; k < layers[i].l.route.num; k++){
				layers[layers[i].l.route.layers[k]].isRamA = isA;
				layers[layers[i].l.route.layers[k]].isSet = true;
			}
			layers[i].isRamA = isA;
			layers[i].isSet = true;
			isA = !isA;
			if (lastRoute == -1)
				lastRoute = i;
		}
		else if (layers[i].type == LT_RES && layers[i].isSet){
			layers[layers[i].l.res.idx].isRamA = !layers[i].isRamA;
			layers[layers[i].l.res.idx].isSet = true;
		}
	}

	for (i = lastRoute - 1; i > 0; i--){
		if (!layers[i].isSet)
			continue;
		if (layers[i].type == LT_UPS || layers[i].type == LT_MAXPOOL){
			layers[i - 1].isRamA = layers[i].isRamA;
			layers[i - 1].isSet = true;
		}
		else if (layers[i].type == LT_CONV){
			if (!layers[i - 1].isSet){
				layers[i - 1].isRamA = !layers[i].isRamA;
				layers[i - 1].isSet = true;
			}
		}
		else if (layers[i].type == LT_ROUTE){
			if (!layers[layers[i].l.route.layers[0]].isSet){
				layers[layers[i].l.route.layers[0]].isSet = true;
				layers[layers[i].l.route.layers[0]].isRamA = layers[i].isRamA;
			}
		}
		else if (layers[i].type == LT_RES){
			assert(!layers[i - 1].isSet);
			layers[i - 1].isRamA = layers[i].isRamA;
			layers[i - 1].isSet = true;
			if (!layers[layers[i].l.res.idx].isSet){
				layers[layers[i].l.res.idx].isRamA = !layers[i].isRamA;
				layers[layers[i].l.res.idx].isSet = true;
			}
		}
	}
	for (int i = 0; i < numLayers; i++){
		if (layers[i].isSet)
			continue;
		if (layers[i].type == LT_CONV){
			layers[i].isRamA = !layers[i - 1].isRamA;
		}
		else{
			assert(layers[i].type == LT_YOLO);
			layers[i].isRamA = layers[i - 1].isRamA;
		}
		layers[i].isSet = true;
	}
	for (int i = 0; i < numLayers; i++){
		assert(layers[i].isSet);
		printf("%d : %s -> %d\n", i, layers[i].isRamA?"A":"B", layers[i].lastUsed);
	}
}
/*
1. First pass assign memory related to ROUTE
2. Assignment others, 
    attention, if a MAXPOOL input is used by later layer, the MAXPOOL and its input must have different assignment, otherwise they overlap

Whenever a layer is assigned an address range, this range is updated to all layers in its life span by function AddMem
, and when we assign address to a layer, we need to assign a range not conflict with its current live memory use.
*/
void CClientNetwork::allocMemory()
{
	int i;
	for (i = 0; i < numLayers; i++){
		layers[i].isSet = false;
		layers[i].isDDR = false;
		layers[i].mem = NULL;
	}
	for (i = numLayers - 1; i > 0; i--){
		if (layers[i].type == LT_ROUTE && layers[i].l.route.num > 1){
			int start = 0;
			for (int j = 0; j < layers[i].l.route.num; j++){
				int idx = layers[i].l.route.layers[j];
				int sz = layers[idx].outSize;
				for (int k = idx; k <= layers[idx].lastUsed; k++){
					if (layers[k].isRamA == layers[i].isRamA)
						layers[k].AddMem(start, sz);
				}
				layers[idx].memStart = start;
				layers[idx].isSet = true;
				start += sz;
			}
			layers[i].isSet = true;
			layers[i].memStart = 0;
		}
		else if (layers[i].type == LT_UPS){
			assert(layers[i].isSet);
			layers[i - 1].AddMem(layers[i].memStart, layers[i].outSize);
			layers[i-1].memStart = layers[i].memStart;
			layers[i-1].isSet = true;
		}
		else if (layers[i].type == LT_RES){
			if (layers[i].isSet){
				layers[i - 1].AddMem(layers[i].memStart, layers[i].outSize);
				layers[i - 1].memStart = layers[i].memStart;
				layers[i - 1].isSet = true;
			}
		}
	}

	for (i = 0; i < numLayers; i++){
		if (layers[i].isSet)
			continue;
		if (layers[i].type == LT_CONV || layers[i].type == LT_MAXPOOL && (layers[i-1].lastUsed > layers[i].lastUsed)){
			int start = 0;
			int len = layers[i].outSize;
			MemUsed *head = NULL;
			for (int j = i; j <= layers[i].lastUsed; j++){
				if (layers[j].isRamA == layers[i].isRamA)
					head = MergeMem(head, layers[j].mem);
			}
			MemUsed *p;
			for (p = head; p; p = p->next){
				if (start + len <= p->start){
					for (int j = i; j <= layers[i].lastUsed; j++){
						if (layers[j].isRamA == layers[i].isRamA)
							layers[j].AddMem(start, len);
					}
					
					layers[i].memStart = start;
					break;
				}
				else
					start = p->start + p->len;
			}
			if (p == NULL){
				for (int j = i; j <= layers[i].lastUsed; j++){
					if (layers[j].isRamA == layers[i].isRamA)
						layers[j].AddMem(start, len);
				}
				layers[i].memStart = start;
			}
			layers[i].isSet = true;
			for (; head != NULL;){
				p = head;
				head = p->next;
				delete p;
			}
		}
		else if (layers[i].type == LT_RES || layers[i].type == LT_MAXPOOL){
			if (layers[i].isSet)
				continue;
			layers[i].memStart = layers[i - 1].memStart;
			layers[i].isSet = true;

		}
		else if (layers[i].type == LT_ROUTE){
			if (layers[i].isSet)
				continue;
			layers[i].memStart = layers[layers[i].l.route.layers[0]].memStart;
			layers[i].isSet = true;

		}
	}
	FILE *fp = fopen("mem.txt", "wt");
	for (i = 0; i < numLayers; i++){
		if (layers[i].isSet){
			fprintf(fp, "%d : %s %d-%d (%d), last %d ", i, layers[i].isRamA?"A":"B"
				, layers[i].memStart, layers[i].memStart + layers[i].outSize
				, layers[i].outSize, layers[i].lastUsed);
			
			for (MemUsed *p = layers[i].mem;; p = p->next){
				if (!p->next){
					fprintf(fp, "maxMem %dK\n", (p->start + p->len)*2 / 1024); // float is 2 bytes
					break;
				}
			}
			for (MemUsed *p = layers[i].mem;p; p = p->next){
				fprintf(fp, " %d(%d)", p->start, p->len);
			}
			if (layers[i].type == LT_CONV){
				fprintf(fp, " C(%d) WH(%d) M(%d) K(%d), S(%d)", layers[i].l.conv.C, layers[i].l.conv.W
					, layers[i].l.conv.M, layers[i].l.conv.K, layers[i].l.conv.S);
			}
			fprintf(fp, "\n");
		}
		else{
			fprintf(fp, "%d not set\n", i);
		}
	}
	fclose(fp);
}

/*
1. First pass assign memory related to ROUTE
2. Assignment others,
attention, if a MAXPOOL input is used by later layer, the MAXPOOL and its input must have different assignment, otherwise they overlap

Whenever a layer is assigned an address range, this range is updated to all layers in its life span by function AddMem
, and when we assign address to a layer, we need to assign a range not conflict with its current live memory use.
*/
void CClientNetwork::allocMemoryDDR()
{
	int i;
	for (i = 0; i < numLayers; i++){
		layers[i].isSet = false;
		layers[i].isDDR = true;
		layers[i].mem = NULL;
	}
	for (i = numLayers - 1; i > 0; i--){
		if (layers[i].type == LT_ROUTE && layers[i].l.route.num > 1){
			int start = 0;
			for (int j = 0; j < layers[i].l.route.num; j++){
				int idx = layers[i].l.route.layers[j];
				int sz = layers[idx].outSize;
				for (int k = idx; k <= layers[idx].lastUsed; k++){
					layers[k].AddMem(start, sz);
				}
				layers[idx].memStart = start;
				layers[idx].isSet = true;
				start += sz;
			}
			layers[i].isSet = true;
			layers[i].memStart = 0;
		}
		else if (layers[i].type == LT_UPS){
			assert(layers[i].isSet);
			layers[i - 1].AddMem(layers[i].memStart, layers[i].outSize);
			layers[i - 1].memStart = layers[i].memStart;
			layers[i - 1].isSet = true;
		}
		else if (layers[i].type == LT_RES){
			if (layers[i].isSet){
				layers[i - 1].AddMem(layers[i].memStart, layers[i].outSize);
				layers[i - 1].memStart = layers[i].memStart;
				layers[i - 1].isSet = true;
			}
		}
	}

	for (i = 0; i < numLayers; i++){
		if (layers[i].isSet)
			continue;
		if (layers[i].type == LT_CONV || layers[i].type == LT_MAXPOOL && (layers[i - 1].lastUsed > layers[i].lastUsed)){
			int start = 0;
			int len = layers[i].outSize;
			MemUsed *head = NULL;
			int last;
			if (layers[i+1].type == LT_YOLO)
				last = numLayers - 1;
			else
				last = layers[i].lastUsed;
			for (int j = i; j <= last; j++){
				head = MergeMem(head, layers[j].mem);
			}
			MemUsed *p;
			for (p = head; p; p = p->next){
				if (start + len <= p->start){
					for (int j = i; j <= last; j++){
						layers[j].AddMem(start, len);
					}

					layers[i].memStart = start;
					break;
				}
				else
					start = p->start + p->len;
			}
			if (p == NULL){
				for (int j = i; j <= last; j++){
					layers[j].AddMem(start, len);
				}
				layers[i].memStart = start;
			}
			layers[i].isSet = true;
			for (; head != NULL;){
				p = head;
				head = p->next;
				delete p;
			}
		}
		else if (layers[i].type == LT_RES || layers[i].type == LT_MAXPOOL){
			if (layers[i].isSet)
				continue;
			layers[i].memStart = layers[i - 1].memStart;
			layers[i].isSet = true;

		}
		else if (layers[i].type == LT_ROUTE){
			if (layers[i].isSet)
				continue;
			layers[i].memStart = layers[layers[i].l.route.layers[0]].memStart;
			layers[i].isSet = true;

		}
	}
	FILE *fp = fopen("mem.txt", "wt");
	max_memory_size = 0;
	for (i = 0; i < numLayers; i++){
		if (layers[i].isSet){
			fprintf(fp, "%d : %s %d-%d (%d), last %d ", i, layers[i].isRamA ? "A" : "B"
				, layers[i].memStart, layers[i].memStart + layers[i].outSize
				, layers[i].outSize, layers[i].lastUsed);

			for (MemUsed *p = layers[i].mem;; p = p->next){
				if (!p->next){
					fprintf(fp, "maxMem %dK\n", (p->start + p->len) * 2 / 1024); // float is 2 bytes
					if (p->start + p->len > max_memory_size)
						max_memory_size = p->start + p->len;

					break;
				}
			}
			for (MemUsed *p = layers[i].mem; p; p = p->next){
				fprintf(fp, " %d(%d)", p->start, p->len);
			}
			if (layers[i].type == LT_CONV){
				fprintf(fp, " C(%d) WH(%d) M(%d) K(%d), S(%d)", layers[i].l.conv.C, layers[i].l.conv.W
					, layers[i].l.conv.M, layers[i].l.conv.K, layers[i].l.conv.S);
			}
			fprintf(fp, "\n");
		}
		else{
			fprintf(fp, "%d not set\n", i);
		}
	}
	max_memory_size = (max_memory_size & (~(INTERFACE_LEN - 1))) + (INTERFACE_LEN );
	fclose(fp);
}

void CClientNetwork::allocMemoryDDRDebug()
{
	int i;
	int start = 0;
	for (i = 0; i < numLayers; i++){
		layers[i].isSet = false;
		layers[i].isDDR = true;
		layers[i].mem = NULL;
		layers[i].memStart = start;
		start += layers[i].outSize;
	}
	
	FILE *fp = fopen("mem.txt", "wt");
	max_memory_size = start;
	max_memory_size = (max_memory_size & (~(INTERFACE_LEN - 1))) + (INTERFACE_LEN );
	for (i = 0; i < numLayers; i++){
		if (layers[i].isSet){
			fprintf(fp, "%d : %s %d-%d (%d), last %d ", i, layers[i].isRamA ? "A" : "B"
				, layers[i].memStart, layers[i].memStart + layers[i].outSize
				, layers[i].outSize, layers[i].lastUsed);

			for (MemUsed *p = layers[i].mem;; p = p->next){
				if (!p->next){
					fprintf(fp, "maxMem %dK\n", (p->start + p->len) * 2 / 1024); // float is 2 bytes
					if (p->start + p->len > max_memory_size)
						max_memory_size = p->start + p->len;

					break;
				}
			}
			for (MemUsed *p = layers[i].mem; p; p = p->next){
				fprintf(fp, " %d(%d)", p->start, p->len);
			}
			if (layers[i].type == LT_CONV){
				fprintf(fp, " C(%d) WH(%d) M(%d) K(%d), S(%d)", layers[i].l.conv.C, layers[i].l.conv.W
					, layers[i].l.conv.M, layers[i].l.conv.K, layers[i].l.conv.S);
			}
			fprintf(fp, "\n");
		}
		else{
			fprintf(fp, "%d not set\n", i);
		}
	}
	fclose(fp);
}


MemUsed *CClientNetwork::MergeMem(MemUsed *head, MemUsed *pm)
{
	if (!pm)
		return head;
	if (head == NULL){
		MemUsed *prev = NULL;
		for (; pm != NULL; pm = pm->next){
			MemUsed *p = new MemUsed;
			p->start = pm->start;
			p->len = pm->len;
			p->next = NULL;
			if (prev == NULL){
				head = prev = p;
			}
			else{
				prev->next = p;
				prev = p;
			}
		}
		return head;
	}
	MemUsed *prev = NULL;
	MemUsed *p1 = head;
	MemUsed *p2 = pm;
	for (;;){
		MemUsed *p = new MemUsed;
		p->next = NULL;
		if (p1->start < p2->start){
			p->len = p1->len;
			p->start = p1->start;
			MemUsed *pt = p1;
			p1 = p1->next;
			delete pt;
		}
		else{
			p->len = p2->len;
			p->start = p2->start;
			p2 = p2->next;
		}
		for (;;){
			if (p1 != NULL && p1->start <= p->start + p->len){
				if (p1->start + p1->len > p->start + p->len)
					p->len = p1->start + p1->len - p->start;
				MemUsed *pt = p1;
				p1 = p1->next;
				delete pt;
			}
			else if (p2 != NULL && p2->start <= p->start + p->len){
				if (p2->start + p2->len > p->start + p->len)
					p->len = p2->start + p2->len - p->start;
				p2 = p2->next;
			}
			else break;
		}
		if (prev == NULL){
			head = prev = p;
		}
		else{
			prev->next = p;
			prev = p;
		}
		if (p2 == NULL){
			prev->next = p1;
			break;
		}
		if (p1 == NULL){
			for (; p2 != NULL; p2 = p2->next){
				MemUsed *p = new MemUsed;
				p->start = p2->start;
				p->len = p2->len;
				p->next = NULL;
				prev->next = p;
				prev = p;
			}
			break;
		}
	}
	return head;
}
void CClientNetwork::AnalyzeNet()
{
	updateLifeSpan();
	assignMemory();
	//allocMemory();
	allocMemoryDDR();
	//allocMemoryDDRDebug();
}
void CClientNetwork::DumpWeights()
{
	int i;
	for (i = 0; i < numLayers; ++i){
		if (layers[i].type == LT_CONV){
			ConvLayer &l = layers[i].l.conv;
			char tmp[100];
			sprintf(tmp, "weights1_%d.txt", i);
			FILE *fp = fopen(tmp, "wt");
			int num = l.C *l.M*l.K*l.K;
			int j;
			fprintf(fp, "biases\n");
			for (j = 0; j < l.M; j++)
				fprintf(fp, " %.2f", l.biases[j]);
			fprintf(fp, "\n");
			if (l.doBM){
				fprintf(fp, "scales\n");
				for (j = 0; j < l.M; j++)
					fprintf(fp, " %.2f", l.scales[j]);
				fprintf(fp, "\n");
				fprintf(fp, "rolling_mean\n");
				for (j = 0; j < l.M; j++)
					fprintf(fp, " %.2f", l.rolling_mean[j]);
				fprintf(fp, "\n");
				fprintf(fp, "rolling_variance\n");
				for (j = 0; j < l.M; j++)
					fprintf(fp, " %.2f", l.rolling_variance[j]);
				fprintf(fp, "\n");
			}
			fprintf(fp, "weights\n");
			for (j = 0; j < num; j++)
				fprintf(fp, " %.2f", l.weights[j]);
			fprintf(fp, "\n");
			fclose(fp);
		}
	}
}
void CClientNetwork::ConvForward(int i)
{
	ConvLayer &conv = layers[i].l.conv;
	int ow = (conv.W + 2 * conv.pad - conv.K) / conv.S + 1;
	int oh = (conv.H + 2 * conv.pad - conv.K) / conv.S + 1;
	layers[i].outSize = ow * oh * conv.M;
	layers[i].outputs = new float[layers[i].outSize];
	

	for (int k = 0; k < conv.M; k++)
		for (int h = 0; h < oh; h++)
			for (int w = 0; w < ow; w++){
				float val = 0;
				for (int l = 0; l < conv.C; l++){
					for (int m = 0; m < conv.K; m++)
						for (int n = 0; n < conv.K; n++){
							int x = w * conv.S + n - conv.K / 2;
							int y = h * conv.S + m - conv.K / 2;
							if (!(x < 0 || x >= conv.H || y < 0 || y >= conv.W)){
								val += data[x + conv.W *(y + conv.H * l)] 
									* conv.weights[((k * conv.C + l) * conv.K +m) * conv.K + n];
							}
						}

				}
				/*if (conv.doBM){
					val = (val - conv.rolling_mean[k]) / (sqrt(conv.rolling_variance[k]) + .000001f);
					val *= conv.scales[k];
				}
				val += conv.biases[k];*/
				val = val * conv.bms[2 * k] + conv.bms[2 * k + 1];
				if (conv.isRelu){
					if (val < 0)
						val = 0;
				}
				else if (conv.isLRelu){
					if (val < 0)
						val *= conv.wrelu;
				}
				layers[i].outputs[w + ow * (h  +  oh * k)] = val;
			}
}
void CClientNetwork::ResForward(int i)
{
	ConvLayer &conv = layers[i - 1].l.conv;
	layers[i].outSize = layers[i - 1].outSize;
	int idx = layers[i].l.res.idx;
	assert(layers[i].outSize == layers[idx].outSize);
	layers[i].outputs = new float[layers[i].outSize];
	for (int k = 0; k < conv.M; k++){
		for (int h = 0; h < conv.H; h++)
			for (int w = 0; w < conv.W; w++){
				int index = w + conv.W * (h + conv.H * k);
				float val = layers[i - 1].outputs[index];
				val += layers[idx].outputs[index];
				//activation
				layers[i].outputs[index] = val;
			}
	}
}
void CClientNetwork::RouteForward(int i)
{
	int k;
	layers[i].outSize = 0;
	for (k = 0; k < layers[i].l.route.num; k++)
		layers[i].outSize += layers[layers[i].l.route.layers[k]].outSize;
	layers[i].outputs = new float[layers[i].outSize];
	int offset = 0;
	for (k = 0; k < layers[i].l.route.num; k++){
		int sz = layers[layers[i].l.route.layers[k]].outSize;
		memcpy(layers[i].outputs + offset, layers[layers[i].l.route.layers[k]].outputs, sz * sizeof(float));
		offset += sz;
	}
}
void CClientNetwork::UPSForward(int i)
{
	layers[i].outSize = size * layers[i].l.ups.stride * layers[i].l.ups.stride;
	layers[i].outputs = new float[layers[i].outSize];
	assert(layers[i - 1].type == LT_CONV);
	ConvLayer &conv = layers[i - 1].l.conv;
	int ow = conv.W * layers[i].l.ups.stride;
	int oh = conv.H * layers[i].l.ups.stride;
	for (int k = 0; k < conv.M; k++){
		for (int h = 0; h < conv.H; h++)
			for (int w = 0; w < conv.W; w++){
				int idx = w + conv.W * (h + conv.H * k);
				float val = layers[i-1].outputs[idx];
				idx = 2 * w + ow * (2 * h + oh *k);
				layers[i].outputs[idx] = val;
				layers[i].outputs[idx+1] = val;
				idx = 2 * w + ow * (2 * h + 1 + oh *k);
				layers[i].outputs[idx] = val;
				layers[i].outputs[idx + 1] = val;
			}
	}
}
void CClientNetwork::MaxPoolForwardi(int i)
{
	layers[i].outSize = size / layers[i].l.maxpool.stride / layers[i].l.maxpool.stride;
	layers[i].outputsi = new int[layers[i].outSize];
	assert(layers[i - 1].type == LT_CONV);
	ConvLayer &conv = layers[i - 1].l.conv;
	int ow = conv.W / layers[i].l.maxpool.stride;
	int oh = conv.H / layers[i].l.maxpool.stride;
	for (int k = 0; k < conv.M; k++){
		for (int h = 0; h < oh; h++)
			for (int w = 0; w < ow; w++){
				int idx = w + ow * (h + oh * k);
				int val;
				for (int m = 0; m < layers[i].l.maxpool.size; m++)
					for (int n = 0; n < layers[i].l.maxpool.size; n++){
						int x = w * layers[i].l.maxpool.stride + m;
						int y = h * layers[i].l.maxpool.stride + n;
						if (x >= conv.W || y >= conv.H)
							continue;
						int idx2 = x + conv.W * (y + conv.H * k);
						if (m == 0 && n == 0 || layers[i - 1].outputsi[idx2] > val)
							val = layers[i - 1].outputsi[idx2];
					}
				layers[i].outputsi[idx] = val;
			}
	}
}
void CClientNetwork::MaxPoolForward(int i)
{
	layers[i].outSize = size / layers[i].l.maxpool.stride / layers[i].l.maxpool.stride;
	layers[i].outputs = new float[layers[i].outSize];
	assert(layers[i - 1].type == LT_CONV);
	ConvLayer &conv = layers[i - 1].l.conv;
	int ow = conv.W / layers[i].l.maxpool.stride;
	int oh = conv.H / layers[i].l.maxpool.stride;
	for (int k = 0; k < conv.M; k++){
		for (int h = 0; h < oh; h++)
			for (int w = 0; w < ow; w++){
				int idx = w + ow * (h + oh * k);
				float val;
				for (int m = 0; m < layers[i].l.maxpool.size; m++)
					for (int n = 0; n < layers[i].l.maxpool.size; n++){
						int x = w * layers[i].l.maxpool.stride + m;
						int y = h * layers[i].l.maxpool.stride + n;
						if (x >= conv.W || y >= conv.H)
							continue;
						int idx2 = x + conv.W * (y + conv.H * k);
						if (m == 0 && n == 0 || layers[i - 1].outputs[idx2] > val)
							val = layers[i - 1].outputs[idx2];
					}
				layers[i].outputs[idx] = val;
			}
	}
}
void CClientNetwork::YoloForward(int i)
{
	layers[i].outSize = size;
	layers[i].outputs = new float[size];
	assert(size == layers[i].l.yolo.outputSize);
	memcpy(layers[i].outputs, data, sizeof(data[0]) * size);	
	//YoloProcess(i);
}
void CClientNetwork::logisticActivateArray(float *x, const int n)
{
	int i;
	for (i = 0; i < n; ++i){
		x[i] = 1. / (1. + exp(-x[i]));
	}
}
void CClientNetwork::YoloProcess(int i)
{
	LARGE_INTEGER li, sli, eli;
	//::QueryPerformanceCounter(&sli);
	YoloLayer &l = layers[i].l.yolo;
#ifdef USE_INT_YOLO
	int size = layers[i].outSize;
	//layers[i].outputs = new float[size];
	for (int j = 0; j < size; j++){
		if (fdebug)
			fprintf(fdebug, "%d\n", layers[i].outputss[j]);
		//layers[i].outputs[j] = float(layers[i].outputsi[j]) / (1 << fScale);
		layers[i].outputs[j] = float(layers[i].outputss[j]) / (1 << l.fscale);
	}
	/*char filename[100];
	sprintf(filename, "yoloi_%d.txt", i);
	FILE *fp = fopen(filename, "wt");
	fprintf(fp, "%d", size);
	for (int j = 0; j < size; j++)
		fprintf(fp, " %.2lf", layers[i].outputs[j]);
	fclose(fp);*/
#else
	int size = layers[i].outSize;
	char filename[100];
	sprintf(filename, "yolo_%d.txt", i);
	FILE *fp = fopen(filename, "wt");
	fprintf(fp, "%d", size);
	for (int j = 0; j < size; j++)
		fprintf(fp, " %.2lf", layers[i].outputs[j]);
	fclose(fp);
#endif
	for (int n = 0; n < l.n; ++n){
		int index = entryIndexYolo(l, n*l.w*l.h, 0);
		logisticActivateArray(layers[i].outputs + index, 2 * l.w*l.h);
		index = entryIndexYolo(l, n*l.w*l.h, 4);
		logisticActivateArray(layers[i].outputs + index, (1 + l.numClasses)*l.w*l.h);
	}
	//::QueryPerformanceCounter(&eli);
	//::QueryPerformanceFrequency(&li);
	//double elapsedMilliseconds = ((eli.QuadPart - sli.QuadPart) * 1000.0) / li.QuadPart;
	//printf("yolo act at %d : %d %lf millsec\n", i, (2 * l.w*l.h + (1 + l.numClasses)*l.w*l.h) * l.n, elapsedMilliseconds);

}
void CClientNetwork::dumpData(int i)
{
	char tmp[100];
	sprintf(tmp, "inputs1_%d.txt", i);
	FILE *fp = fopen(tmp, "wt");
	assert(fp);
	fprintf(fp, "%d", size);
	for (int k = 0; k < size; k++)
		fprintf(fp, " %.2f", data[k]);
	fclose(fp);
}
void CClientNetwork::dumpDatai(int i)
{
	char tmp[100];
	sprintf(tmp, "inputs0_%d.txt", i);
	FILE *fp = fopen(tmp, "wt");
	assert(fp);
	fprintf(fp, "%d", size);
	for (int k = 0; k < size; k++)
		fprintf(fp, " %d", datai[k]);
	fclose(fp);
}

void CClientNetwork::Forward2(float *input, int baseSizeW, int baseSizeH)
{
	LARGE_INTEGER li, sli, eli;
	::QueryPerformanceCounter(&sli);
	size = layers[0].l.conv.C * layers[0].l.conv.W * layers[0].l.conv.H;
	datai = new int[size];
	weights_data = new unsigned char[16000000];
	features_data = new char[16000000];
	int *pdata = datai;
	for (int i = 0; i < size; i++)
		datai[i] = int(input[i] * (1 << fScale));
	std::map<unsigned, void *> out_mp;
	DumpInfo * head = GenInsts(baseSizeW, baseSizeH, out_mp);
	CModelIF model;
	model.BuildModel(12, 15);
	//max_memory_size = (max_memory_size & (~0x1f)) + 32; 
	cur_data_size = (cur_data_size & (~(INTERFACE_LEN - 1))) + (INTERFACE_LEN );
	cur_weight_size = (cur_weight_size & (~(INTERFACE_LEN - 1))) + (INTERFACE_LEN);
	model.Run(pinsts, out_mp, max_memory_size * TYPE_SIZE, (unsigned char *)weights_data, cur_weight_size
		, (unsigned char *)features_data, cur_data_size * TYPE_SIZE, true, head, 1, baseWaddr);

	//model.Run(pinsts, true, head, 3);
	::QueryPerformanceCounter(&eli);
	::QueryPerformanceFrequency(&li);
	double elapsedMilliseconds = ((eli.QuadPart - sli.QuadPart) * 1000.0) / li.QuadPart;
	printf("inference took %lf sec\n", elapsedMilliseconds / 1000);
	delete[]pdata;
}
void CClientNetwork::Forward(float *input)
{
	data = input;
	size = layers[0].l.conv.C * layers[0].l.conv.W * layers[0].l.conv.H;
	dumpData(0);
	for (int i = 0; i < numLayers; ++i){
		if (layers[i].type == LT_CONV){
			ConvForward(i);
		}
		else if (layers[i].type == LT_RES){
			ResForward(i);
		}
		else if (layers[i].type == LT_ROUTE){
			RouteForward(i);
		}
		else if (layers[i].type == LT_UPS){
			UPSForward(i);
		}
		else if (layers[i].type == LT_MAXPOOL){
			MaxPoolForward(i);
		}
		else if (layers[i].type == LT_YOLO){
			YoloForward(i);
		}
		data = layers[i].outputs;
		size = layers[i].outSize;
		dumpData(i+1);
	}
}

void CClientNetwork::ResForwardi(int i)
{
	ConvLayer &conv = layers[i - 1].l.conv;
	layers[i].outSize = layers[i - 1].outSize;
	int idx = layers[i].l.res.idx;
	assert(layers[i].outSize == layers[idx].outSize);
	layers[i].outputsi = new int[layers[i].outSize];
	for (int k = 0; k < conv.M; k++){
		for (int h = 0; h < conv.H; h++)
			for (int w = 0; w < conv.W; w++){
				int index = w + conv.W * (h + conv.H * k);
				int val = layers[i - 1].outputsi[index];
				val += layers[idx].outputsi[index];
				//activation
				layers[i].outputsi[index] = val;
			}
	}
}
void CClientNetwork::RouteForwardi(int i)
{
	int k;
	layers[i].outSize = 0;
	for (k = 0; k < layers[i].l.route.num; k++)
		layers[i].outSize += layers[layers[i].l.route.layers[k]].outSize;
	layers[i].outputsi = new int[layers[i].outSize];
	int offset = 0;
	for (k = 0; k < layers[i].l.route.num; k++){
		int sz = layers[layers[i].l.route.layers[k]].outSize;
		memcpy(layers[i].outputsi + offset, layers[layers[i].l.route.layers[k]].outputsi, sz * sizeof(int));
		offset += sz;
	}
}
void CClientNetwork::UPSForwardi(int i)
{
	layers[i].outSize = size * layers[i].l.ups.stride * layers[i].l.ups.stride;
	layers[i].outputsi = new int[layers[i].outSize];
	assert(layers[i - 1].type == LT_CONV);
	ConvLayer &conv = layers[i - 1].l.conv;
	int ow = conv.W * layers[i].l.ups.stride;
	int oh = conv.H * layers[i].l.ups.stride;
	for (int k = 0; k < conv.M; k++){
		for (int h = 0; h < conv.H; h++)
			for (int w = 0; w < conv.W; w++){
				int idx = w + conv.W * (h + conv.H * k);
				int val = layers[i - 1].outputsi[idx];
				idx = 2 * w + ow * (2 * h + oh *k);
				layers[i].outputsi[idx] = val;
				layers[i].outputsi[idx + 1] = val;
				idx = 2 * w + ow * (2 * h + 1 + oh *k);
				layers[i].outputsi[idx] = val;
				layers[i].outputsi[idx + 1] = val;
			}
	}
}
void CClientNetwork::YoloForwardi(int i)
{
	layers[i].outSize = size;
	layers[i].outputsi = new int[size];
	assert(size == layers[i].l.yolo.outputSize);
	memcpy(layers[i].outputsi, datai, sizeof(datai[0]) * size);
	//YoloProcess(i);
}

void CClientNetwork::ConvForwardi(int i)
{
	ConvLayer &conv = layers[i].l.conv;
	int ow = (conv.W + 2 * conv.pad - conv.K) / conv.S + 1;
	int oh = (conv.H + 2 * conv.pad - conv.K) / conv.S + 1;
	layers[i].outSize = ow * oh * conv.M;
	layers[i].outputs = new float[layers[i].outSize];
	layers[i].outputsi = new int[layers[i].outSize];
	for (int k = 0; k < conv.M; k++)
		for (int h = 0; h < oh; h++)
			for (int w = 0; w < ow; w++){
				//long long  val = 0;
				int val = 0;
				for (int l = 0; l < conv.C; l++){
					for (int m = 0; m < conv.K; m++)
						for (int n = 0; n < conv.K; n++){
							int x = w * conv.S + n - conv.K / 2;
							int y = h * conv.S + m - conv.K / 2;
							if (!(x < 0 || x >= conv.H || y < 0 || y >= conv.W)){
								/*int w = int(conv.weights[((k * conv.C + l) * conv.K + m) * conv.K + n] * (1 << wScale));
								int f = int(data[x + conv.W *(y + conv.H * l)] * (1 << fScale));
								assert(abs(w) < (1<<7));
								val += w *f;*/
								val += /*(long long)*/(datai[x + conv.W *(y + conv.H * l)])
									* conv.weightsi[((k * conv.C + l) * conv.K + m) * conv.K + n];
							}
						}

				}
				/*if (conv.doBM){
				val = (val - conv.rolling_mean[k]) / (sqrt(conv.rolling_variance[k]) + .000001f);
				val *= conv.scales[k];
				}
				val += conv.biases[k];*/
				val >>= wScale;
				//int bm0 = int(conv.bms[2 * k] * (1 << fScale));
				//int bm1 = int(conv.bms[2 * k + 1] * (1 << fScale));
				val = ((val * conv.bmsi[2 * k]) >> fScale) + conv.bmsi[2 * k + 1];
				if (conv.isRelu){
					if (val < 0)
						val = 0;
				}
				else if (conv.isLRelu){
					if (val < 0){
						//int w = int(conv.wrelu * (1 << wScale));
						val *= conv.wrelui;
						val >>= wScale;
					}
				}
				layers[i].outputsi[w + ow * (h + oh * k)] = val;// float(val) / (1 << fScale);
			}
}
void CClientNetwork::Forwardi(float *input)
{
	size = layers[0].l.conv.C * layers[0].l.conv.W * layers[0].l.conv.H;
	datai = new int[size];
	int *pdata = datai;
	float mn, mx;
	for (int i = 0; i < size; i++){
		datai[i] = int(input[i] * (1 << (fScale + wScale - wScale0)));
		if (i == 0)
			mn = mx = input[0];
		else{
			if (mn > input[i])
				mn = input[i];
			if (mx < input[i])
				mx = input[i];
		}

	}
	printf("data range %f -> %f\n", mn, mx);
	dumpDatai(0);
	for (int i = 0; i < numLayers; ++i){
		if (layers[i].type == LT_CONV){
			ConvForwardi(i);
		}
		else if (layers[i].type == LT_RES){
			ResForwardi(i);
		}
		else if (layers[i].type == LT_ROUTE){
			RouteForwardi(i);
		}
		else if (layers[i].type == LT_UPS){
			UPSForwardi(i);
		}
		else if (layers[i].type == LT_YOLO){
			YoloForwardi(i);
		}
		else if (layers[i].type == LT_MAXPOOL){
			MaxPoolForwardi(i);
		}
		datai = layers[i].outputsi;
		size = layers[i].outSize;
		dumpDatai(i + 1);
		int mn, mx;
		for (int k = 0; k < layers[i].outSize; k++){
			if (k == 0)
				mn = mx = datai[0];
			else{
				if (mn > datai[k])
					mn = datai[k];
				if (mx < datai[k])
					mx = datai[k];
			}

		}
		printf("data range for layer %d :  %d -> %d\n", i, mn/512, mx/512);
	}
	delete[]pdata;
}
detection *CClientNetwork::GetNetworkBoxes(int w, int h, float thresh, float hier, int *map, int relative, int *num)
{
	/*static int cnt = 0;
	cnt++;
	if (cnt > 10){
		if (cnt & 1)
			fdebug = fopen("yolo1.txt", "wt");
		else
			fdebug = fopen("yolo0.txt", "wt");
	}
	else
		fdebug = fopen("yolo.txt", "wt");*/
	fdebug = NULL;
	LARGE_INTEGER li, sli, eli;
	//::QueryPerformanceCounter(&sli);
	detection *dets = makeNetworkBoxes(thresh, num);
	fillNetworkBoxes(w, h, thresh, hier, map, relative, dets);
	//::QueryPerformanceCounter(&eli);
	//::QueryPerformanceFrequency(&li);
	//double elapsedMilliseconds = ((eli.QuadPart - sli.QuadPart) * 1000.0) / li.QuadPart;
	//printf("getbox took %lf millisec\n", elapsedMilliseconds);
	if (fdebug)
		fclose(fdebug);
	return dets;
}
int CClientNetwork::entryIndexYolo(YoloLayer &l, int location, int entry)
{
	int n = location / (l.w*l.h);
	int loc = location % (l.w*l.h);
	return n*l.w*l.h*(4 + l.numClasses + 1) + entry*l.w*l.h + loc;
}
int CClientNetwork::yoloNumDetections(int l, float thresh)
{
	YoloLayer &yolo = layers[l].l.yolo;
	int i, n;
	int count = 0;
	for (i = 0; i < yolo.w*yolo.h; ++i){
		for (n = 0; n < yolo.n; ++n){
			int obj_index = entryIndexYolo(yolo, n*yolo.w*yolo.h + i, 4);
			if (layers[l].outputs[obj_index] > thresh){
				++count;
			}
		}
	}
	return count;
}

int CClientNetwork::numDetections(float thresh)
{
	int i;
	int s = 0;
	for (i = 0; i < numLayers; ++i){
		if (layers[i].type == LT_YOLO){
			YoloProcess(i);
			s += yoloNumDetections(i, thresh);
		}
		
	}
	return s;
}
detection *CClientNetwork::makeNetworkBoxes(float thresh, int *num)
{
	//layer l = net->layers[net->n - 1];
	int i;
	int nboxes = numDetections(thresh);
	if (num) *num = nboxes;
	detection *dets = new detection[nboxes];
	for (i = 0; i < nboxes; ++i){
		//dets[i].prob = new float[numClasses];
		dets[i].mask = NULL;
	}
	
	return dets;
}
box CClientNetwork::getYoloBox(float *x, float *biases, int n, int index, int i, int j, int lw, int lh, int w, int h, int stride)
{
	box b;
	b.x = (i + x[index + 0 * stride]) / lw;
	b.y = (j + x[index + 1 * stride]) / lh;
	b.w = exp(x[index + 2 * stride]) * biases[2 * n] / w;
	b.h = exp(x[index + 3 * stride]) * biases[2 * n + 1] / h;
	return b;
}
void CClientNetwork::correctYoloBoxes(detection *dets, int n, int w, int h, int netw, int neth, int relative)
{
	int i;
	int new_w = 0;
	int new_h = 0;
	if (((float)netw / w) < ((float)neth / h)) {
		new_w = netw;
		new_h = (h * netw) / w;
	}
	else {
		new_h = neth;
		new_w = (w * neth) / h;
	}
	for (i = 0; i < n; ++i){
		box b = dets[i].bbox;
		b.x = (b.x - (netw - new_w) / 2. / netw) / ((float)new_w / netw);
		b.y = (b.y - (neth - new_h) / 2. / neth) / ((float)new_h / neth);
		b.w *= (float)netw / new_w;
		b.h *= (float)neth / new_h;
		if (!relative){
			b.x *= w;
			b.w *= w;
			b.y *= h;
			b.h *= h;
		}
		dets[i].bbox = b;
		//printf("%d : (%f %f %f %f)\n", i, b.x, b.y, b.w, b.h);
	}
}
int CClientNetwork::getYoloDetections(int l, int w, int h, int netw, int neth, float thresh, int *map, int relative, detection *dets)
{
	int i, j, n;
	float *predictions = layers[l].outputs;
	int count = 0;
	YoloLayer &yolo = layers[l].l.yolo;
	for (i = 0; i < yolo.w*yolo.h; ++i){
		int row = i / yolo.w;
		int col = i % yolo.w;
		for (n = 0; n < yolo.n; ++n){
			int obj_index = entryIndexYolo(yolo, n*yolo.w*yolo.h + i, 4);
			float objectness = predictions[obj_index];
			if (objectness <= thresh) continue;
			
			int box_index = entryIndexYolo(yolo, n*yolo.w*yolo.h + i, 0);
			dets[count].bbox = getYoloBox(predictions, yolo.biases, yolo.mask[n], box_index, col, row
				, yolo.w, yolo.h, netw, neth, yolo.w*yolo.h);
			dets[count].objectness = objectness;
			dets[count].classes = yolo.numClasses;
			//printf("count %d, object %f (%f %f %f %f)\n", count, objectness, dets[count].bbox.x, dets[count].bbox.y, dets[count].bbox.w, dets[count].bbox.h);
			for (j = 0; j < yolo.numClasses; ++j){
				int class_index = entryIndexYolo(yolo, n*yolo.w*yolo.h + i, 4 + 1 + j);
				
				float prob = objectness*predictions[class_index];
				//printf(" %f(%f)", predictions[class_index], prob);
				//if (j % 10 == 9)
				//	printf("\n");
				dets[count].prob[j] = (prob > thresh) ? prob : 0;

			}
			++count;
		}
	}
	correctYoloBoxes(dets, count, w, h, netw, neth, relative);
	return count;
}

void CClientNetwork::fillNetworkBoxes(int w, int h, float thresh, float hier, int *map, int relative, detection *dets)
{
	int j;
	for (j = 0; j < numLayers; ++j){
		if (layers[j].type == LT_YOLO){
			int count = getYoloDetections(j, w, h, width, height, thresh, map, relative, dets);
			dets += count;
		}
	}
}