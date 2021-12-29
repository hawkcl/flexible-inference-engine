#include "init.h"
#include "rocc.h"
#include "file.h"

static inline void send_cmd(unsigned long data)
{
	ROCC_INSTRUCTION_SS(2, data, data, 0);
}

unsigned long data = 0x3421L;
static volatile unsigned local;
void *handler(unsigned hartid, unsigned mcause, void *mepc, void *sp)
{
    int fd;
    printstr("interrupt received\n");
    fd = open("rec", O_WRONLY, S_IRWXU);
    print_int1("file id : ", fd);
    write(fd, (void *)&hartid, sizeof(hartid));
    write(fd, (void *)&mcause, sizeof(mcause));
    close(fd);
    print_int2("int hid, mcause : ", hartid, mcause);
    
    return mepc;
}

int main(void)
{
    local = 0;
    printstr("started\n");
    set_trap_handler(handler);
    enable_interrupts();
	send_cmd(data);
    while (1) {
        local++;
    }
	return 0;
}
