#include <stdio.h>
#include <string>
#include <assert.h>


void GenInputAssignments(char *inf, char *outf)
{
	FILE *fin = fopen(inf, "rt");
	FILE *fout = fopen(outf, "wt");
	char name[100];
	while (fscanf(fin, "%s", name) != EOF){
		fprintf(fout, "in_data->inst.%s->aval = %s;\n", name, name);
		fprintf(fout, "in_data->inst.%s->bval = 0;\n", name);
	}
	fclose(fin);
	fclose(fout);
}
void GenLogicCmp()
{
	//char *inf = "processInstruction/logic.txt";
	char *inf = "t.txt";
	char *outf = "out.txt";
	FILE *fin = fopen(inf, "rt");
	FILE *fout = fopen(outf, "wt");
	char name[100];
	while (fscanf(fin, "%s", name) != EOF){
		fprintf(fout, "if (out_data->%s != %s)\n", name, name);
		fprintf(fout, "\tprintf(\"\\t %s %%d vs %%d\\n\", out_data->%s, %s);\n", name, name, name);

		//if (out_data->res_en != res_en)
		//	printf("\t res_en %d vs %d\n", out_data->res_en, res_en);
	}
	fclose(fin);
	fclose(fout);
}
void GenLogicVecCmp()
{
	char *inf = "processInstruction/in.txt";
	char *outf = "out.txt";
	FILE *fin = fopen(inf, "rt");
	FILE *fout = fopen(outf, "wt");
	char name[100];
	while (fscanf(fin, "%s", name) != EOF){
		fprintf(fout, "in_data->inst.%s->aval = %s;\n", name, name);
		fprintf(fout, "in_data->inst.%s->bval = 0;\n", name);
	}
	fclose(fin);
	fclose(fout);
}
void GenLogicVecCmpOut()
{
	char *inf = "processInstruction/in.txt";
	char *outf = "out.txt";
	FILE *fin = fopen(inf, "rt");
	FILE *fout = fopen(outf, "wt");
	char name[100];
	while (fscanf(fin, "%s", name) != EOF){
		fprintf(fout, "if (out_data->cb_inst[Id].%s->aval != %s)\n", name, name);
		fprintf(fout, "\tprintf(\"\\t cb_inst_%%d.%s %%d vs %%d\\n\", Id, out_data->cb_inst[Id].%s->aval, %s);\n", name, name, name);

		//if (out_data->cb_inst[Id].seqNum->aval != seqNum)
		//	printf("\t crinst.cb_inst_%d %d vs %d\n", Id, out_data->cb_inst[Id].seqNum->aval, seqNum);
	}
	fclose(fin);
	fclose(fout);
}
void GenInputPortAssignments()
{
	char *inf = "processInstruction/in.txt";
	char *outf = "out.txt";
	FILE *fin = fopen(inf, "rt");
	FILE *fout = fopen(outf, "wt");
	char name[100];
	while (fscanf(fin, "%s", name) != EOF){
		fprintf(fout, "\tports.inst.%s = input_data.inst.%s;\n", name, name);

		//ports.inst.Id = input_data.inst.Id;
	}
	fclose(fin);
	fclose(fout);
}
int main(int argc, char * argv[])
{
	assert(argc == 3);
	//GenInputAssignments(argv[1], argv[2]);
	//GenLogicCmp();
	GenLogicVecCmpOut();
	//GenLogicVecCmp();
	//GenInputPortAssignments();
	return 0;
}