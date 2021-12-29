#include <assert.h>
extern "C"{
#include "list.h"
#include "option_list.h"
#include "utils.h"
#include "image.h"
};
#include "net.h"
#include "windows.h"
void free_detections(detection *dets, int n)
{
	int i;
	for (i = 0; i < n; ++i){
		//delete [](dets[i].prob);
		if (dets[i].mask)
			assert(false);
	}
	delete [](dets);
}

void main(int argc, char * argv[])
{
	printf("%d %d\n", sizeof(int), sizeof(size_t));
	assert(argc == 2);
	FILE *fp = fopen(argv[1], "rt");
	int baseSizeW, baseSizeH;
	char datacfg[100], namelists[100], netfile[100], weightsfile[100], indir[100], outfile[100];
	fscanf(fp, "%s%s%s%s%s%d%d", datacfg, namelists, netfile, weightsfile, indir, &baseSizeW, &baseSizeH);
	char outdir[200];
	sprintf(outdir, "%s/yolodata/output/", OUTPUT_DIR);
	//char *img_names[] = { "alan.jpg", "cap0.png", "dog.jpg", "duan.jpg", "eagle.jpg", "giraffe.jpg", "horses.jpg", "kite.jpg", "person.jpg", "scream.jpg" };
	char *img_names[] = {"person.jpg"};
	max_add1 = 0;
	max_add2 = 0;
	for (int k = 0; k < sizeof(img_names) / sizeof(img_names[0]); k++)
	{
		char infile[200];
		sprintf(infile, "%s%s", indir, img_names[k]);
		char outfilename[200], imgname[100];
		char *pos = strchr(img_names[k], '.');
		strncpy(imgname, img_names[k], pos - img_names[k]);
		imgname[pos - img_names[k]] = 0;
		printf("processing %s\n", imgname);
		sprintf(outfilename, "%s%s.txt", outdir, imgname);
		FILE *fout = fopen(outfilename, "wt");
		assert(fout);
		sprintf(outfile, "%s/%s.out", outdir, imgname);
		list *options = read_data_cfg(datacfg);
		char *name_list = option_find_str(options, "names", "data/names.list");
		char **names = get_labels(name_list);

		image **alphabet = load_alphabet();
		CNetwork net;
		net.setOutFIle(fout, outdir);
		net.setImgName(imgname);
		net.Init(netfile, weightsfile, "quant_bias_pos.txt");
#ifdef QUANT_WEIGHT
		//net.balance_weight4feature();
		//net.generate_quant_bias();
		//return;
#endif
		//net.GenInsts(baseSize);
		srand(2222222);
		double time;
		float nms = .45;
		float thresh = 0.5;
		float hier_thresh = 0.5;
		image im = load_image_color(infile, 0, 0);
		image sized = letterbox_image(im, net.GetWidth(), net.GetHeight());
		save_image(sized, outfile);

		float *X = sized.data;
		time = what_time_is_it_now();
		//net.Forward(X);
		net.Forward2(X, baseSizeW, baseSizeH);
		//net.Forwardi(X);
		//printf("%s: Predicted in %f seconds.\n", infile, what_time_is_it_now() - time);
		int nboxes = 0;

		detection *dets = net.GetNetworkBoxes(im.w, im.h, thresh, hier_thresh, 0, 1, &nboxes);
		fprintf(fout, "%d predictions\n", nboxes);

		if (nms) {
			LARGE_INTEGER li, sli, eli;
			::QueryPerformanceCounter(&sli);
			do_nms_sort(dets, nboxes, net.GetNumClasses(), nms);
			::QueryPerformanceCounter(&eli);
			::QueryPerformanceFrequency(&li);
			double elapsedMilliseconds = ((eli.QuadPart - sli.QuadPart) * 1000.0) / li.QuadPart;
			fprintf(fout, "nms sort took %lf msec\n", elapsedMilliseconds);
		}
		{
			LARGE_INTEGER li, sli, eli;
			::QueryPerformanceCounter(&sli);
			draw_detections(im, dets, nboxes, thresh, names, alphabet, net.GetNumClasses());
			::QueryPerformanceCounter(&eli);
			::QueryPerformanceFrequency(&li);
			double elapsedMilliseconds = ((eli.QuadPart - sli.QuadPart) * 1000.0) / li.QuadPart;
			fprintf(fout, "draw_detections took %lf msec\n", elapsedMilliseconds);
		}
		free_detections(dets, nboxes);
		save_image(im, outfile);
		fclose(fout);
		free_image(im);
		free_image(sized);
		printf("max1 %x, max2 %x\n", max_add1, max_add2);
	}
	printf("\7\7\7");
}
