#ifndef __SHOW_LOG_H__
#define __SHOW_LOG_H__

typedef struct{
// < 4I 5B 3B 4H 4i 4i 4i 4i 4i 4i
// `<` := little endian
    unsigned int buf1[4];
    unsigned char buf2[5];
    unsigned char buf3[3];
    unsigned short buf4[4];
    int buf5[24];
} BPM_DATA_Struct;

void print_data(BPM_DATA_Struct, long double, long double, unsigned int);

void print_matlab(long double, long double);

#endif
