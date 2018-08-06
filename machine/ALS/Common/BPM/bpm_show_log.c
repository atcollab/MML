#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <bzlib.h>
#include <string.h>
#include "bpm_show_log.h"

#define GRAIN_TRIM (1.0 / (1 << 24))
#define RMS_MOTION (1.0e-3)
#define EVG_FREQUENCY (499.64e6 / 4.0)

int main (int argc, const char **argv){
    // test # of args
    if (argc < 3)
    {
        printf("Usage:infile.bz2 useMATLAB [1|0] duration\n");
        exit(1);
    }

    // intput args
    const char *infile = argv[1];
    unsigned int useMATLAB = atoi(argv[2]);
    time_t duration_req = atoi(argv[3]);

    // program var
    FILE *fp;
    int bzerror = 0;

    long double sample_seconds_init, sample_seconds, agg_seconds=0, prev_sample_seconds;

    unsigned int btyes_read;
    BZFILE *bzfp;
    BPM_DATA_Struct data;

    fp = fopen(infile, "rb");

    // perform one pass outside loop to init sample time
    bzfp = BZ2_bzReadOpen(&bzerror, fp, 0, 0, NULL, 0);
    btyes_read = BZ2_bzRead(&bzerror, bzfp, &data, sizeof(data));
    sample_seconds_init = (long double)(data.buf1[2]) + (data.buf1[3] / EVG_FREQUENCY);
    prev_sample_seconds = sample_seconds_init;

    print_data(data, sample_seconds_init, 0, useMATLAB);

    while (bzerror == 0 || bzerror == -5 || bzerror == -7){
        btyes_read = BZ2_bzRead(&bzerror, bzfp, &data, sizeof(data));
        sample_seconds = (long double)(data.buf1[2]) + (data.buf1[3] / EVG_FREQUENCY);
        agg_seconds += (sample_seconds - prev_sample_seconds);

        if (sample_seconds - sample_seconds_init >= duration_req)
            exit(0);

        print_data(data, sample_seconds, agg_seconds, useMATLAB);
        prev_sample_seconds = sample_seconds;
    }

BZ2_bzReadClose(&bzerror, bzfp);
fclose(fp);
return 0;
}

void print_matlab(long double seconds, long double agg_seconds){
    time_t int_seconds = seconds; // cast and drop fraction
    struct tm * date_obj;
    char buffer[80];

    date_obj = localtime(&int_seconds);
    strftime(buffer, sizeof(buffer), "%Y-%m-%d %H:%M:%S", date_obj);

    //printf("%.6Lf,%.6Lf,", seconds, agg_seconds);
    printf("%s,%.6Lf,", buffer, agg_seconds);
}

void print_data(BPM_DATA_Struct data, long double sample_seconds, long double agg_seconds, unsigned int useMATLAB){
        // time epoch
        if (useMATLAB == 1)
            print_matlab(sample_seconds, agg_seconds);
        else
            printf("%.6Lf,", sample_seconds);

        // X, Y, Q, S
        printf("%.6f,%.6f,%i,%i,", data.buf5[16] / 1.0e6,
                                   data.buf5[17] / 1.0e6,
                                   data.buf5[18],
                                   data.buf5[19]);

        // ADC peaks
        printf("%i,%i,%i,%i,", data.buf4[0], data.buf4[1], data.buf4[2], data.buf4[3]);

        // RF magnitude
        printf("%d,%d,%d,%d,", data.buf5[0], data.buf5[1], data.buf5[2], data.buf5[3]);

        // Low pilot tone magnitude
        printf("%d,%d,%d,%d,", data.buf5[4], data.buf5[5], data.buf5[6], data.buf5[7]);

        // High pilot tone magnitude
        printf("%d,%d,%d,%d,", data.buf5[8], data.buf5[9], data.buf5[10], data.buf5[11], data.buf5[12]);

        printf("%.5g,%.5g,%.5g,%.5g,", data.buf5[12] * GRAIN_TRIM,
                                       data.buf5[13] * GRAIN_TRIM,
                                       data.buf5[14] * GRAIN_TRIM,
                                       data.buf5[15] * GRAIN_TRIM);

        printf("%.5g,%.5g,%.5g,%.5g\n", data.buf5[20] * RMS_MOTION,
                                        data.buf5[21] * RMS_MOTION,
                                        data.buf5[22] * RMS_MOTION,
                                        data.buf5[23] * RMS_MOTION);
}
