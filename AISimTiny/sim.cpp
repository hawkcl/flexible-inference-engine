#include "sim.h"
#include <assert.h>

namespace CloudDesign{
	void CAddrBuffer::latch(int num)
	{
		num = num;
		if (valid){
			//assert(fifo.size() < ADDRESS_FIFOSIZE);
			if (fp)
				fprintf(fp, "AddrBuffer adding %u (%d)\n", s, num);
			fifo.push(s);
			valid = false;
		}
	}
	void CAddrBuffer::DumpState()
	{
		if (fp)
				fprintf(fp, "AddrBuffer queue size %d\n", fifo.size());
	}
	bool CAddrBuffer::Pop(ADDR_TYPE &ad)
	{
		if (fifo.size() == 0)
			return false;

		ad = fifo.front();
		fifo.pop();
		return true;
	}

}