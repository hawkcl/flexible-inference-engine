#ifndef RV_FILE_H
#define RV_FILE_H

#define	O_RDONLY	0x0000
#define	O_WRONLY	0x0001
#define	O_RDWR		0x0002
#define	O_ACCMODE	0x0003
//#define O_CREAT         0x0100
#define	O_CREAT		0x0200
#define	S_IRWXU	0000700	

extern int  open(  char  *filename,  int  access,  int  permission  );
extern int  read(  int  handle,  void  *buffer,  int  nbyte );
extern int  write(  int  handle,  void  *buffer,  int  nbyte  );
extern int  close(  int  handle  );
extern void printstr(const char* s);
extern void print_int1(const char* s, int v1);
extern void print_int2(const char* s, int v1, int v2);
extern void printhex(uint64_t x);
#endif
