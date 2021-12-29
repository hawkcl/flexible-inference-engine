#include <assert.h>
extern "C"{
#include "list.h"
#include "option_list.h"
#include "utils.h"
#include "image.h"
};
#include "clientnet.h"
#include "windows.h"

void main(int argc, char * argv[])
{
	printf("%d %d\n", sizeof(int), sizeof(size_t));
	assert(argc == 2);
	FILE *fp = fopen(argv[1], "rt");
	int baseSizeW, baseSizeH;
	char datacfg[100], namelists[100], netfile[100], weightsfile[100], infile[100], outfile[100];
	char video_filename[200];
	int camIdx;
	fscanf(fp, "%s%s%s%s%s%s%d%d%s%d", datacfg, namelists, netfile, weightsfile, infile, outfile, &baseSizeW, &baseSizeH, video_filename, &camIdx);

	list *options = read_data_cfg(datacfg);
	char *name_list = option_find_str(options, "names", "data/names.list");
	char **names = get_labels(name_list);

	image **alphabet = load_alphabet();
	CClientNetwork net;
	net.Init(netfile, weightsfile, "quant_bias_pos.txt", names, alphabet, video_filename, camIdx, baseSizeW, baseSizeH);
	net.Run();
	
	
}
