#include "rocc.h"
#include "file.h"

static inline void accum_write(int idx, unsigned long data)
{
	ROCC_INSTRUCTION_SS(0, data, idx, 0);
}

static inline unsigned long accum_read(int idx)
{
	unsigned long value;
	ROCC_INSTRUCTION_DSS(0, value, 0, idx, 1);
	return value;
}

static inline void accum_load(int idx, void *ptr)
{
	asm volatile ("fence");
	ROCC_INSTRUCTION_SS(0, (uintptr_t) ptr, idx, 2);
}

static inline void accum_add(int idx, unsigned long addend)
{
	ROCC_INSTRUCTION_SS(0, addend, idx, 3);
}

unsigned long data = 0x3421L;

int main(void)
{
	unsigned long result;
    //FILE *fp;
    int tmp = 2;
    int fd;

    fd = open("td", O_RDONLY, 0);
    printstr("file id : ");
    printhex(fd);
    printstr("\n");
    read(fd, (void *)&tmp, sizeof(fd));
    print_int1("read tmp : ", tmp);
    //fp = fopen("in.txt", "rt");
//    fscanf(fp, "%d", &tmp);
	accum_load(0, &data);
	accum_add(0, 2);
	result = accum_read(0);

    print_int1("result : ", result);
    //printf("result %d\n", result);
	if (result != data + 2)
		return 1;

	accum_write(0, 3);
	accum_add(0,tmp);
	result = accum_read(0);

    print_int2("tmp result : ", tmp, result);
    //printf("tmp %d, result %d\n", tmp, result);
	if (result != 3+tmp)
		return 2;

	return 0;
}
