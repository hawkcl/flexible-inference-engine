#include <sys/types.h>
#include <sys/stat.h>
#include <sys/ioctl.h>
#include <fcntl.h>
#include <stdio.h>

#define	FLAG_WEIGHT		0
#define	FLAG_INSTRUCTION	1
#define	FLAG_FEATURE		2
#define	FLAG_OUTPUTS		3
#define	FLAG_START		4

#define DEEPRV_CMD_ALLOC_FEATURE    1
#define DEEPRV_CMD_ALLOC_WEIGHT     2
#define DEEPRV_CMD_SEND_WEIGHT      3
#define DEEPRV_CMD_SEND_FEATURE     4
#define DEEPRV_CMD_START_COMPUTE    5
#define DEEPRV_CMD_SEND_BASE_ADDR   6
#define DEEPRV_CMD_START_READ       7

#define FEATURE_SIZE    (3003040+1000)
#define WEIGHT_SIZE     (8871552+384)

#define io_sz 		32
#define MAX_OUTPUTS_SIZE	5
unsigned output_addrs[MAX_OUTPUTS_SIZE];
unsigned output_sizes[MAX_OUTPUTS_SIZE];

int main()
{
    int fd, fd2;
    int feature_started;
    int num_outputs;
    unsigned start_addr;
	unsigned char flag;
	unsigned addr, sz;
	int num;
	unsigned char tmp[io_sz];
    fd = open("deep.rv", O_RDONLY);
    fd2 = open("/dev/deeprv", O_RDWR);
	printf("fd : %d, fd2 %d\n", fd, fd2);
    ioctl(fd2, DEEPRV_CMD_ALLOC_FEATURE, FEATURE_SIZE);
    ioctl(fd2, DEEPRV_CMD_ALLOC_WEIGHT , WEIGHT_SIZE);
    ioctl(fd2, DEEPRV_CMD_SEND_BASE_ADDR , 0);
    feature_started = 0;
    num_outputs = 0;
	for(;;){
		read(fd, (void *)&flag, sizeof(flag));
		read(fd, (void *)&addr, sizeof(addr));
		read(fd, (void *)&sz,   sizeof(sz));
		if(flag == FLAG_WEIGHT){
			printf("weight : %d %d\n", addr, sz);
            ioctl(fd2, DEEPRV_CMD_SEND_WEIGHT , 0);
            lseek(fd2, 0, addr);
			for(int i = 0; i < sz; i+= io_sz){
				if(i % (io_sz * 10000) ==  0)
					printf("     progress : %d\n", i);
				//read(fd, (void *)(weight_addr + addr + i), io_sz);
				read(fd, (void *)(tmp), io_sz);
                write(fd2, tmp, io_sz);
			}
		}
		else if(flag == FLAG_INSTRUCTION || flag == FLAG_FEATURE){
			printf("feature : %d %d\n", addr, sz);
            ioctl(fd2, DEEPRV_CMD_SEND_FEATURE , 0);
            lseek(fd2, 0, addr);
			for(int i = 0; i < sz; i+= num){
				if(i % (io_sz * 1000) ==  0)
					printf("     progress : %d\n", i);
				num = read(fd, (void *)(tmp), io_sz);
				if(num != io_sz)
					printf("     wrong size at : %d, %d", i, num);
                else
                    write(fd2, tmp, io_sz);

			}
		}
		else if(flag == FLAG_OUTPUTS){
			printf("output : %d %d\n", addr, sz);
			output_addrs[num_outputs] = addr;
			output_sizes[num_outputs] = sz;
			num_outputs++;
		}else if(flag == FLAG_START){
			printf("start : %d\n", addr);
			start_addr = addr;
			break;
		}
	}
	close(fd);

    ioctl(fd2, DEEPRV_CMD_START_COMPUTE , start_addr);
    fd = open("deep.ot", O_WRONLY, S_IRWXU);
	printf("out file id : %d\n", fd);
    for(int i = 0; i < num_outputs; i++){
        int read_size = 0;
        int num;
        ioctl(fd2, DEEPRV_CMD_START_READ , output_addrs[i]);
        lseek(fd2, 0, 0);
        write(fd, (void *)&(output_addrs[i]), sizeof(output_addrs[i]));
        write(fd, (void *)&(output_sizes[i]), sizeof(output_sizes[i]));
        while(read_size < output_sizes[i]){
            num = read(fd2, tmp, io_sz);
            if(num != io_sz)
                printf(" wrong read size %d\n", num);
            else
                write(fd, tmp, io_sz);
            read_size += num;
        }
    }
    close(fd);
    close(fd2);
    return 0;
}
