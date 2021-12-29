#include "init.h"
#include "rocc.h"
#include "file.h"

const unsigned char *feature_addr  = (unsigned char *)0x82000000;
const unsigned char *weight_addr   = (unsigned char *)0x83000000;
static int idx_outputs ;
static int num_outputs ;
static volatile int has_interrupt ;

#define MAX_OUTPUTS_SIZE	5
unsigned output_addrs[MAX_OUTPUTS_SIZE];
unsigned output_sizes[MAX_OUTPUTS_SIZE];

static inline void send_reset_cmd(void)
{
	asm volatile("fence");
	ROCC_INSTRUCTION_SS(2, 0, 0, 0);
	printstr("reset cmd sent\n");
}
static inline void send_base_cmd(const unsigned char *f_adr, const unsigned char *w_adr)
{
	asm volatile("fence");
	ROCC_INSTRUCTION_SS(2, f_adr, w_adr, 2);
	///	printstr("cmd sent\n");
}
static inline void send_cmd(int adr)
{
	asm volatile("fence");
	ROCC_INSTRUCTION_SS(2, adr, 0, 1);
	///	printstr("cmd sent\n");
}

void *handler(unsigned hartid, unsigned mcause, void *mepc, void *sp)
{
	print_int1("interrupt received ", mcause);
	has_interrupt = 1;
	return mepc;
}

#define	FLAG_WEIGHT		0
#define	FLAG_INSTRUCTION	1
#define	FLAG_FEATURE		2
#define	FLAG_OUTPUTS		3
#define	FLAG_START		4

#define io_sz 		32

int main(void)
{
	int fd;
	unsigned start_addr;
	unsigned char flag;
	unsigned addr, sz;
	int num;
	unsigned char tmp[io_sz];
	/*fd = open("deep.ot", O_WRONLY, S_IRWXU);
	print_int1("out file id : ", fd);
	close(fd);
	return 0;
	*/
	send_reset_cmd();
	idx_outputs = 0;
	num_outputs = 0;
	has_interrupt = 0;
	fd = open("deep.rv", O_RDONLY, 0);
	print_int1("in file id : ", fd);
	for(;;){
		read(fd, (void *)&flag, sizeof(flag));
		read(fd, (void *)&addr, sizeof(addr));
		read(fd, (void *)&sz,   sizeof(sz));
		if(flag == FLAG_WEIGHT){
			print_int2("weight : ", addr, sz);
			for(int i = 0; i < sz; i+= io_sz){
				if(i % (io_sz * 10000) ==  0)
					print_int1("     progress : ", i);
				read(fd, (void *)(weight_addr + addr + i), io_sz);
				//read(fd, (void *)(tmp), io_sz);
			}
		}
		else if(flag == FLAG_INSTRUCTION || flag == FLAG_FEATURE){
			print_int2("feature : ", addr, sz);
			for(int i = 0; i < sz; i+= num){
				if(i % (io_sz * 1000) ==  0)
					print_int1("     progress : ", i);
				num = read(fd, (void *)(feature_addr + addr + i), io_sz);
				if(num == 0)
					print_int1("     zero at : ", i);
				if(i % (io_sz * 1000) ==  0)
					print_int1("     data : ", feature_addr[addr+i]);
			}
		}
		else if(flag == FLAG_OUTPUTS){
			print_int2("output : ", addr, sz);
			output_addrs[num_outputs] = addr;
			output_sizes[num_outputs] = sz;
			num_outputs++;
		}else if(flag == FLAG_START){
			start_addr = addr;
			break;
		}
	}
	close(fd);
	send_base_cmd(feature_addr, weight_addr);
	//print_addr("main ", main);
	//printstr("started\n");
	print_int1("start address : ", start_addr);
	print_int1("num outputs : ", num_outputs);
	print_int2("   outputs0 : ", output_addrs[0], output_sizes[0]);
	print_int2("   outputs1 : ", output_addrs[1], output_sizes[1]);
	set_trap_handler(handler);
	enable_interrupts();
	send_cmd(start_addr);
	//send_cmd((int *)start_addr);
	fd = open("deep.ot", O_WRONLY, S_IRWXU);
	print_int1("out file id : ", fd);
	while (idx_outputs < num_outputs) {
		//print_int2("    local start ", local, start_int);
		if(has_interrupt){
			asm volatile("fence");
			addr = output_addrs[idx_outputs];
			sz   = output_sizes[idx_outputs];
			write(fd, (void *)&addr, sizeof(addr));
			write(fd, (void *)&sz, sizeof(sz));
			for(int i = 0; i < sz; i+= io_sz)
				write(fd, (void *)(feature_addr + addr + i), io_sz);

			clear_interrupts();
			enable_interrupts();
			idx_outputs++;
			has_interrupt = 0;
		}
	}
	close(fd);
	return 0;
}
