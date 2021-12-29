#pragma once
#include <stdio.h>
#include <string.h>
#include <assert.h>

#define BUF_LEN	1000

class CPack{
	unsigned char buf[BUF_LEN];
	unsigned idx, pos;
	unsigned bitlen;
public:
	CPack(){ idx = 0; pos = 0; }
	void Reset() { 
		idx = 0; pos = 0; 
		bitlen = 0;
		memset(buf, 0, BUF_LEN);
	}
	unsigned char *GetBuffer() { return buf; }
	unsigned GetBitLength() { return idx * 8 + pos; }
	unsigned GetByteLength() { return pos == 0 ? idx : (idx + 1); }
	
	void DoPack(unsigned val, unsigned size)
	{
		bitlen += size;
		while (size > 0){
			int len;
			if (size + pos >= 8){
				len = 8 - pos;
			}
			else
				len = size;
			unsigned v = val & ((1 << len) - 1);
			val >>= len;
			buf[idx] |= v << pos;
			pos += len;
			assert(pos < 9);
			if (pos == 8){
				pos = 0;
				idx++;
				assert(idx < BUF_LEN);
			}
			size -= len;
		}
		assert(bitlen == GetBitLength());
	}
	unsigned UnPack(unsigned char *inbuf, unsigned size)
	{
		unsigned val = 0;
		unsigned vpos = 0;
		int len;
		while (size > 0){
			if (size + pos >= 8)
				len = 8 - pos;
			else
				len = size;
			unsigned v = (inbuf[idx] >> pos) & ((1 << len) - 1);
			val |= (v << vpos);
			vpos += len;
			pos += len;
			size -= len;
			if (pos == 8){
				pos = 0;
				idx++;
				assert(idx < BUF_LEN);
			}
		}
		return val;
	}
};
