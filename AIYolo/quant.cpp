#include <map>
#include <assert.h>
#include <stdio.h>
#include "net.h"

void CNetwork::quant_read()
{
	char *outdir = "D:/aidata/yolodata/output/";
	char *img_names[] = { "alan" , "cap0", "dog", "duan", "eagle", "giraffe", "horses", "kite", "person", "scream"};
	num_img = sizeof(img_names) / sizeof(img_names[0]);
	float **data;
	FILE *fout = fopen("out.txt", "wt");
	for (int iter = 0; iter <= numLayers; iter++){
		int num, C, sz;
		data = new float *[num_img];
		if (iter == numLayers)
			last_data = data;
		else
			layers[iter].saved_data = data;
		for (int i = 0; i < num_img; i++){
			char filename[200];
			sprintf(filename, "%sfeature_%d/%s.txt", outdir, iter, img_names[i]);

			FILE *fp = fopen(filename, "rt");
			assert(fp);
			fscanf(fp, "%d %d", &num, &C);
			layers[iter].outSize = num;
			sz = num / C;
			if (num != sz *C)
				printf("iter %d, %s : %d %d %d\n", iter, img_names[i], num, C, sz);
			assert(num == sz*C);
			data[i] = new float[num];
			for (int j = 0; j < num; j++){
				fscanf(fp, "%f", data[i] + j);
			}
			fclose(fp);
		}
	}
	for (int iter = 0; iter < numLayers; ++iter){
		if (layers[iter].type != LT_CONV){
			continue;
		}
		int num, C, sz;
		data = new float *[num_img];
		layers[iter].l.conv.conv_data = data;
		for (int i = 0; i < num_img; i++){
			char filename[200];
			sprintf(filename, "%sfeature_%d/%sbm.txt", outdir, iter+1, img_names[i]);

			FILE *fp = fopen(filename, "rt");
			assert(fp);
			fscanf(fp, "%d %d", &num, &C);
			sz = num / C;
			if (num != sz *C)
				printf("iter %d, %s : %d %d %d\n", iter, img_names[i], num, C, sz);
			assert(num == sz*C);
			data[i] = new float[num];
			for (int j = 0; j < num; j++){
				fscanf(fp, "%f", data[i] + j);
			}
			fclose(fp);
		}
	}
	fclose(fout);
}
void CNetwork::quantize_features(int iter, bool beforeBM)
{
	int scale = fScale;
	fprintf(fout, "##########Layer %d###############\n", iter);
	fflush(fout);
	float ** data;
	if (beforeBM)
		data = layers[iter].l.conv.conv_data;
	else
		data = layers[iter + 1].saved_data;
	float mx = 0;
	int num = layers[iter+1].outSize;
	for (int i = 0; i < num_img; i++){
		for (int j = 0; j < num; j++){
			if (mx < data[i][j])
				mx = data[i][j];
			if (!beforeBM){
				if (mx < -data[i][j])
					mx = -data[i][j];
			}
			if (mx > 128)
				mx = mx;
		}
	}
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
	double err = 0;
	int bs;
	for (int k = 0; k < QUANT_LOOP_MAX; k++){
		bool caped = false;
		float er = 0;
		for (int i = 0; i < num_img; i++)
			for (int j = 0; j < num; j++){
				int wt = int(data[i][j] * (1 << (starts + k)));
				if (wt >= (1 << (fScale - 1))){
					wt = (1 << (fScale - 1)) - 1;
					caped = true;
				}
				if (wt < -(1 << (fScale - 1))){
					wt = -(1 << (fScale - 1));
					//caped = true;
				}
				float e = data[i][j] - float(wt) / float(1 << (starts + k));
				if (wt < 0 && beforeBM)
					er += e * e * BM_NEG_WEIGHT;
				else
					er += e*e;
			}
		if (k == 0){
			assert(!caped);
			bs = starts + k;
			err = er;
		}
		else {
			if (k > 1)
				assert(caped);
			if (er < err){
				bs = starts + k;
				err = er;
			}
		}
	}
	if (beforeBM)
		layers[iter].l.conv.layer_scale_conv = bs;
	else{ 
		layers[iter].fscale = bs;
		if (layers[iter].type == LT_CONV)
			layers[iter].l.conv.layer_scale = bs;
	}
	fprintf(fout, "%d : %d %f (%f) %lf\n", iter, bs, err, err / num_img / num, mx);
	if (layers[iter].type != LT_CONV)
		return;
	if (1){
		int C = layers[iter].l.conv.M;
		int sz = layers[iter].l.conv.H * layers[iter].l.conv.W;
		if (beforeBM)
			layers[iter].l.conv.cscale_conv = new int[C];
		else
			layers[iter].l.conv.cscale = new int[C];
		for (int l = 0; l < C; l++){
			mx = 0;
			float mn = 0, mx0 = 0;
			for (int i = 0; i < num_img; i++){
				for (int j = 0; j < sz; j++){
					if (mx < data[i][l * sz + j])
						mx = data[i][l * sz + j];
					if (!beforeBM){
						if (mx < -data[i][l * sz + j])
							mx = -data[i][l * sz + j];
					}
					if (i == 0 && j == 0)
						mn = mx0 = data[i][l * sz + j];
					else{
						if (mx0 < data[i][l * sz + j])
							mx0 = data[i][l * sz + j];
						if (mn > data[i][l * sz + j])
							mn = data[i][l * sz + j];
					}
				}
			}
			int starts = 0;
			if (mx < 0.00001)
				mx = -mn;
			if (mx >= (1 << (fScale - 1)))
				mx = (1 << (fScale - 1)) - 1;
			if (mx > 1){
				int mxi = int(mx + 0.9999);
				while (mxi){
					starts++;
					mxi >>= 1;
				}
				starts = scale - starts - 1;
			}
			else if(mx > 0.00001){
				while (mx * (1 << starts) < 1)
					starts++;
				starts = scale + starts - 2;
			}
			else
				starts = 0;
			double err = 0;
			int bs;
			for (int k = 0; k < QUANT_LOOP_MAX; k++){
				bool caped = false;
				float er = 0;
				for (int i = 0; i < num_img; i++)
					for (int j = 0; j < sz; j++){
						int wt = int(data[i][l * sz + j] * (1 << (starts + k)));
						if (wt >= (1 << (fScale - 1))){
							wt = (1 << (fScale - 1)) - 1;
							caped = true;
						}
						if (wt < -(1 << (fScale - 1))){
							wt = -(1 << (fScale - 1));
						//	caped = true;
						}
						float e = data[i][l * sz + j] - float(wt) / float(1 << (starts + k));
						if (wt < 0 && beforeBM)
							er += e * e * BM_NEG_WEIGHT;
						else
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
			if (beforeBM)
				layers[iter].l.conv.cscale_conv[l] = bs;
			else
				layers[iter].l.conv.cscale[l] = bs;
			fprintf(fout, "\t%d : %d %f (%f)\t%f %f (%f)\n", l, bs, err, err / num_img / sz, mn, mx0, mx0 - mn);
		}
	}

}
void CNetwork::balance_weight4feature()
{
	quant_read();
	int size = 0;
	for (int iter = 0; iter < numLayers; ++iter){
		if (layers[iter].type != LT_CONV){
			if(layers[iter].type != LT_YOLO)
				quantize_features(iter, false);
			if (layers[iter].type == LT_MAXPOOL){
				layers[iter].outSize = size / layers[iter].l.maxpool.stride / layers[iter].l.maxpool.stride;
				layers[iter].outputsi = new int[layers[iter].outSize];
			}
			continue;
		}
		quantize_features(iter, false);
		quantize_features(iter, true);
		ConvLayer &conv = layers[iter].l.conv;
		int ow = (conv.W + 2 * conv.pad - conv.K) / conv.S + 1;
		int oh = (conv.H + 2 * conv.pad - conv.K) / conv.S + 1;
		layers[iter].outSize = ow * oh * conv.M;
		layers[iter].outputsi = new int[layers[iter].outSize];
		size = layers[iter].outSize;
	}
	updateLifeSpan();
	
	for (int iter = 0; iter < numLayers; ++iter){
		if (layers[iter].type != LT_CONV){
			continue;
		}
		if (layers[iter].lastUsed == iter + 2 && layers[iter + 1].type == LT_CONV)
			balance_weight(iter, 1);
		else if (layers[iter].lastUsed == iter + 3 && layers[iter + 1].type == LT_MAXPOOL && layers[iter + 2].type == LT_CONV)
			balance_weight(iter, 2);
	}

}

void CNetwork::compute_balance_input_data(int iter, int conv_step)
{
	ConvLayer &conv = layers[iter].l.conv;
	ConvLayer &conv2 = layers[iter+conv_step].l.conv;
	int scale = fscale0;
	if (iter > 0)
		scale = layers[iter - 1].fscale;
	iter_size = conv.C* conv.H * conv.W;
	iter_datai = new int*[num_img];
	fprintf(fout, "init scale %d\n", scale);
	for (int i = 0; i < num_img; i++){
		iter_datai[i] = new int[iter_size];
		char *outdir = "D:/aidata/yolodata/output/";
		char filename[200];
		sprintf(filename, "%stmp/%d.txt", outdir, iter);
		FILE *fp = fopen(filename, "wt");
		fprintf(fp, "%d %d", iter_size, conv.C);
		for (int j = 0; j < iter_size; j++){
			fprintf(fp, " %f", layers[iter].saved_data[i][j]);
			iter_datai[i][j] = int(layers[iter].saved_data[i][j] * (1 << (scale)));
		}
		fclose(fp);
	}
	int num = conv2.C * conv2.M * conv2.K * conv2.K;
	weights2 = new float[num];
}

void CNetwork::free_balance_input_data(int iter)
{
	for (int i = 0; i < num_img; i++){
		delete[]iter_datai[i];
	}
	delete[]iter_datai;
	delete []weights2;
}

void CNetwork::balance_weight(int iter, int conv_step)
{
	fprintf(fout, "balance layer %d\n", iter);
	compute_balance_input_data(iter, conv_step);
	ConvLayer &conv = layers[iter].l.conv;
	int *scale_change = new int[conv.M];
	memset(scale_change, 0, conv.M * sizeof(scale_change[0]));
	quant_err init_err;
	init_err = evaluate_change(iter, scale_change, conv_step, true);
	printf("init err %f, %f errper %f, %f errabs %f, %f errperabs %f, %f\n", init_err.totalerr_mse, init_err.aveerror_mse
		, init_err.totalerr_per, init_err.aveerror_per
		, init_err.totalerr_abs, init_err.aveerror_abs
		, init_err.totalerr_perabs, init_err.aveerror_perabs);
	int cur_shift = 0;
	for (int i = 0; i < conv.M; i++)
		if (cur_shift < conv.cscale_conv[i])
			cur_shift = conv.cscale_conv[i];
	fprintf(fout, "layer scale %d, max scale %d, init err %lf\n", conv.layer_scale_conv, cur_shift, init_err);
	for (int i = 0; i < conv.M; i++)
	{
		int diff = 0;
		if (conv.layer_scale_conv > conv.cscale_conv[i])
			diff = -1;
		else if (conv.layer_scale_conv < conv.cscale_conv[i])
			diff = 1;
		if (diff){
			scale_change[i] += diff;
			fprintf(fout, "compute for %d : %d %d\n", i, diff, conv.cscale_conv[i]);
			quant_err err = evaluate_change(iter, scale_change, conv_step, false);
			printf("\t%d : %d, ", i, diff);
			printf(" err %f, %f errper %f, %f errabs %f, %f errperabs %f, %f\n", err.totalerr_mse, err.aveerror_mse
				, err.totalerr_per, err.aveerror_per
				, err.totalerr_abs, err.aveerror_abs
				, err.totalerr_perabs, err.aveerror_perabs);
			scale_change[i] -= diff;
		}
	}
	//for (; cur_shift > conv.layer_scale_conv; cur_shift--)
	//{
	
	//}
	free_balance_input_data(iter);
}

quant_err CNetwork::evaluate_change(int iter, int* scale_change, int conv_step, bool is_init)
{
	ConvLayer &conv = layers[iter].l.conv;
	ConvLayer &conv2 = layers[iter + conv_step].l.conv;
	assert(conv.M == conv2.C);
	fprintf(fout, "%d : %d %d %d %d %d\n", iter, conv.C, conv.M, conv.H, conv.W, conv.fscale_bm);
	int num = conv.C * conv.M * conv.K * conv.K;
	int numw = conv.C * conv.K * conv.K;
	int widx = 0;
	quant_err err;
	err.totalerr = 0;
	err.totalerr_mse = 0;
	err.totalerr_per = 0;
	err.totalerr_abs = 0;
	err.totalerr_perabs = 0;
	//conv weights, incremental change
	if (is_init){
		for (int i = 0; i < num; i += numw, widx++){
			float err;
			assert(widx < conv.M);
			conv.wscale[widx] = getBestScale(wScale, numw, conv.weights + i, err);
			fprintf(fout, "\t%d : %d %f\n", widx, conv.wscale[widx], err);
			for (int k = 0; k < numw; k++){
				int wt = int(conv.weights[i + k] * (1 << conv.wscale[widx]));
				if (wt >= (1 << (wScale - 1)))
					wt = (1 << (wScale - 1)) - 1;
				if (wt < -(1 << (wScale - 1)))
					wt = -(1 << (wScale - 1));
				conv.weightsi[i + k] = wt;
			}
		}
	}
	else
		for (int i = 0; i < conv.M; i++)
			conv.wscale[i] -= scale_change[i];

	//conv2 weights, full update
	num = conv2.C * conv2.M * conv2.K * conv2.K;
	numw = conv2.C * conv2.K * conv2.K;
	widx = 0;
	for (int i = 0; i < conv2.M; i++)
		for (int j = 0; j < conv2.C; j++)
			for (int k = 0; k < conv2.K * conv2.K; k++){
				int idx = ((i * conv2.C + j) * conv2.K) * conv2.K + k;
				if (scale_change[j]>=0)
					weights2[idx] = conv2.weights[idx] / (1<<scale_change[j]);
				else 
					weights2[idx] = conv2.weights[idx] * (1 << (-scale_change[j]));
			}
	float terr = 0;
	for (int i = 0; i < num; i += numw, widx++){
		float err;
		assert(widx < conv2.M);
		conv2.wscale[widx] = getBestScale(wScale, numw, weights2 + i, err);
		terr += err;
		fprintf(fout, "\t%d : %d %f\n", widx, conv2.wscale[widx], err);
		for (int k = 0; k < numw; k++){
			int wt = int(weights2[i + k] * (1 << conv2.wscale[widx]));
			if (wt >= (1 << (wScale - 1)))
				wt = (1 << (wScale - 1)) - 1;
			if (wt < -(1 << (wScale - 1)))
				wt = -(1 << (wScale - 1));
			conv2.weightsi[i + k] = wt;
		}
	}
	printf("wt err %f\n", terr);
	//compute
	int err_size = 0;
	for (int ig = 0; ig < num_img; ig++){
		datai = iter_datai[ig];
		size = iter_size;
		/*for (int j = 0; j < size; j++){
			float v = float(datai[j]) / (1 << (conv.fscale + conv.fscale_diff));
			float v2 = layers[iter].saved_data[ig][j];
			float diff = v2 - v;

			fprintf(fout, "%f %f\n", v, v2);
			if (fabs(v2) < 0.00001)
				v2 = 0.00001;
			//layers[i].outputs[j] = float(layers[i].outputss[j]) / (1 << fScale);
			err.totalerr += diff;
			err.totalerr_per += diff * 100 / v2;
			err.totalerr_abs += fabs(diff);
			err.totalerr_perabs += fabs(diff * 100 / v2);
		}
		err_size = num_img * size;
		*/
		ConvForwardi(iter, false);
		datai = layers[iter].outputsi;
		size = layers[iter].outSize;
		/*
		int ow = (conv.W + 2 * conv.pad - conv.K) / conv.S + 1;
		int oh = (conv.H + 2 * conv.pad - conv.K) / conv.S + 1;
		int ln = size /conv.M;
		for (int j = 0; j < size; j++){
			int k, h, w;
			k = j / ow / oh;
			h = (j - k * ow*oh) / ow;
			w = j %ow;
			assert(w + ow * (h + oh * k) == j);
			float v = float(datai[j]) / (1 << (conv.fscale_bm + scale_change[j/ln]));
			float v2 = layers[iter+1].saved_data[ig][j];
			float diff = v2 - v;
			if (fabs(v2) < 0.00001)
				v2 = 0.00001;
//			fprintf(fout, "%d %d %d : %d %f %f %f %f\n", k, h, w, datai[j], v, v2, fabs(diff), fabs(diff * 100 / v2));
			//layers[i].outputs[j] = float(layers[i].outputss[j]) / (1 << fScale);
			err.totalerr += diff;
			err.totalerr_mse += diff * diff;
			err.totalerr_per += diff * 100 / v2;
			err.totalerr_abs += fabs(diff);
			err.totalerr_perabs += fabs(diff * 100 / v2);
		}
		err_size = num_img * size;
	*/
		if (conv_step > 1){
			assert(conv_step == 2);
			assert(layers[iter + 1].type == LT_MAXPOOL);
			MaxPoolForwardi(iter + 1, false);
			datai = layers[iter + 1].outputsi;
			size = layers[iter + 1].outSize;
		}

		ConvForwardi(iter+conv_step, false);
		datai = layers[iter + conv_step].outputsi;
		size = layers[iter + conv_step].outSize;
		for (int j = 0; j < size; j++){
			float v = float(datai[j]) / (1 << (conv2.fscale_bm));
			float v2 = layers[iter + conv_step + 1].saved_data[ig][j];
			float diff = v2 - v;

			fprintf(fout, "%f %f\n", v, v2);
			if (fabs(v2) < 0.00001)
				v2 = 0.00001;
			//layers[i].outputs[j] = float(layers[i].outputss[j]) / (1 << fScale);
			err.totalerr += diff;
			err.totalerr_mse += diff * diff;
			err.totalerr_per += diff * 100 / v2;
			err.totalerr_abs += fabs(diff);
			err.totalerr_perabs += fabs(diff * 100 / v2);
		}
		err_size = num_img * size;
		
	}
	err.aveerror = err.totalerr / err_size;
	err.aveerror_mse = err.totalerr_mse / err_size;
	err.aveerror_per = err.totalerr_per / err_size;
	err.aveerror_abs = err.totalerr_abs / err_size;
	err.aveerror_perabs = err.totalerr_perabs / err_size;

	//restore conv weights
	if (!is_init)
		for (int i = 0; i < conv.M; i++)
			conv.wscale[i] += scale_change[i];

	return err;
}

void CNetwork::generate_quant_bias()
{
	quant_read();
	int size = 0;
	for (int iter = 0; iter < numLayers; ++iter){
		if (layers[iter].type != LT_CONV){
			if (layers[iter].type != LT_YOLO)
				quantize_features(iter, false);
			if (layers[iter].type == LT_MAXPOOL){
				layers[iter].outSize = size / layers[iter].l.maxpool.stride / layers[iter].l.maxpool.stride;
				layers[iter].outputsi = new int[layers[iter].outSize];
			}
			continue;
		}
		quantize_features(iter, false);
		quantize_features(iter, true);
		ConvLayer &conv = layers[iter].l.conv;
		int ow = (conv.W + 2 * conv.pad - conv.K) / conv.S + 1;
		int oh = (conv.H + 2 * conv.pad - conv.K) / conv.S + 1;
		layers[iter].outSize = ow * oh * conv.M;
		layers[iter].outputsi = new int[layers[iter].outSize];
		size = layers[iter].outSize;
	}
	updateLifeSpan();

	FILE *fp = fopen("quant_bias.txt", "wt");
	FILE *fpp = fopen("quant_bias_pos.txt", "wt");
	FILE *fpe = fopen("quant_bias_equal.txt", "wt");
	assert(fp);
	assert(fpp);
	assert(fpe);
	for (int iter = 0; iter < numLayers; ++iter){
		if (layers[iter].type != LT_CONV){
			continue;
		}
		generate_layer_bias(iter, fp, fpp, fpe);
	}
	fclose(fp);

}

void CNetwork::generate_layer_bias(int iter, FILE *fp, FILE *fpp, FILE *fpe)
{
	compute_balance_input_data(iter, 0);
	ConvLayer &conv = layers[iter].l.conv;
	float *bias = new float[conv.M];
	memset(bias, 0, sizeof(bias[0]) * conv.M);
	float *biasp = new float[conv.M];
	memset(biasp, 0, sizeof(biasp[0]) * conv.M);
	float *biase = new float[conv.M];
	memset(biase, 0, sizeof(biase[0]) * conv.M);
	int num = conv.C * conv.M * conv.K * conv.K;
	int numw = conv.C * conv.K * conv.K;
	int widx = 0;
	//conv weights, incremental change
	for (int i = 0; i < num; i += numw, widx++){
		float err;
		assert(widx < conv.M);
		conv.wscale[widx] = getBestScale(wScale, numw, conv.weights + i, err);
		fprintf(fout, "\t%d : %d %f\n", widx, conv.wscale[widx], err);
		for (int k = 0; k < numw; k++){
			int wt = int(conv.weights[i + k] * (1 << conv.wscale[widx]));
			if (wt >= (1 << (wScale - 1)))
				wt = (1 << (wScale - 1)) - 1;
			if (wt < -(1 << (wScale - 1)))
				wt = -(1 << (wScale - 1));
			conv.weightsi[i + k] = wt;
		}
	}
	//compute
	int *layer_sizep = new int[conv.M];
	memset(layer_sizep, 0, sizeof(layer_sizep[0]) * conv.M);
	int layer_size;
	for (int ig = 0; ig < num_img; ig++){
		datai = iter_datai[ig];
		size = iter_size;
		ConvForwardi(iter, false);
		datai = layers[iter].outputsi;
		size = layers[iter].outSize;
		
		int ow = (conv.W + 2 * conv.pad - conv.K) / conv.S + 1;
		int oh = (conv.H + 2 * conv.pad - conv.K) / conv.S + 1;
		int ln = size /conv.M;
		for (int j = 0; j < size; j++){
			float v = float(datai[j]) / (1 << (conv.fscale_bm));
			float v2 = layers[iter+1].saved_data[ig][j];
			float diff = v2 - v;
			fprintf(fout, "%f %f %f\n", v, v2, diff);
			bias[j / ln] += diff>=0?diff:(10*diff);
			biase[j / ln] += diff;
			biasp[j / ln] += diff >= 0 ? diff : 0;
			if (diff>0)
				layer_sizep[j / ln]++;
		}
		layer_size = num_img * ln;
	}
	fprintf(fp, "%d %d", iter, conv.M);
	for (int i = 0; i < conv.M; i++)
		fprintf(fp, " %f", (bias[i] / layer_size));
	fprintf(fp, "\n");

	fprintf(fpe, "%d %d", iter, conv.M);
	for (int i = 0; i < conv.M; i++)
		fprintf(fpe, " %f", (biase[i] / layer_size));
	fprintf(fpe, "\n");

	fprintf(fpp, "%d %d", iter, conv.M);
	for (int i = 0; i < conv.M; i++)
		fprintf(fpp, " %f", layer_sizep[i] ? (biasp[i] / layer_sizep[i]) : 0);
	fprintf(fpp, "\n");
	delete[]layer_sizep;
	delete[]bias;
	delete[]biasp;
	delete[]biase;
	free_balance_input_data(iter);
}