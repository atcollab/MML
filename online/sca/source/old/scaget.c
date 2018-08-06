#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include "mex.h"
#include "matrix.h"
#include "gpfunc.h"
#include "scalib.h"


/* Input Arguments */
#define	INPUT1  prhs[0]
#define	INPUT2  prhs[1]
#define	INPUT3  prhs[2]
#define	INPUT4  prhs[3]


/* Output Arguments */
#define	OUTPUT1 plhs[0]
#define	OUTPUT2 plhs[1]
#define	OUTPUT3 plhs[2]



/*  MATLAB TO C-CALL LINKING FUNCTION  */
void mexFunction( int nlhs, mxArray *plhs[],
int nrhs, const mxArray *prhs[] )
{
    char     *ChannelNames, NameBuffer[50];
    int      i, j, m, n, Device, buflen, NumberOfAverages, NumberOfErrors, AverageLoop, Status, SleepTimeInt;
    int      Rows, Cols, trows, tcols;
    double   *AM, *SectorNum, *DeviceNum, *t, *tout, *ErrorFlag, t0, Time0Avg, AveragingSamplingPeriod, SleepTime, Time0, max_wait;
    
    
    /*  SCAIII Arrays */
    int *StatusArray;
    double *DataArray;

    
    /*  Maximum time to wait to get a EPICS PV */
    max_wait = 5.0;

    
    /* Get/Check Inputs */
    if (nrhs < 1)
        mexErrMsgTxt("Channelname input required (scaget.c).");
    
    /* Input 1: Channel names (Matrix of strings) */
	if (mxIsChar(INPUT1) != 1)
	    mexErrMsgTxt("ChannelName input must be a string");

	    
	/* get the length of the input string */
    buflen = (mxGetM(prhs[0]) * mxGetN(prhs[0])) + 1;

    
    /* allocate memory for input string */
    ChannelNames = mxCalloc(buflen, sizeof(char));
    Status = mxGetString(prhs[0], ChannelNames, buflen);
    if(Status != 0)
        mexWarnMsgTxt("Not enough space to read in the ChannelName string.  ChannelName is truncated.");

    Rows = (int) mxGetM(prhs[0]);
    Cols = (int) mxGetN(prhs[0]);

    StatusArray = mxCalloc(Rows, sizeof(int));
    DataArray = mxCalloc(Rows, sizeof(double));
        

    /* Input 2 */
    if (nrhs >= 2) {
        trows = (int) mxGetM(INPUT2);
        tcols = (int) mxGetN(INPUT2);
        if (!mxIsNumeric(INPUT2) || mxIsComplex(INPUT2) || !mxIsDouble(INPUT2) || (trows != 1))
            mexErrMsgTxt("t must be a row vector.");
        
        t = mxGetPr(INPUT2);
    } else {
        trows = 1;
        tcols = 1;
        t = &t0;
    }
    
    
    
    /* Input 3: NumberOfAverages (int, scalar) */
    if (nrhs >= 3) {
        m = mxGetM(INPUT3);
        n = mxGetN(INPUT3);
        if (!mxIsNumeric(INPUT3) || mxIsComplex(INPUT3) || !mxIsDouble(INPUT3) || (max(m,n) != 1) || (min(m,n) != 1)) {
            mexErrMsgTxt("INPUT #3 must be a 1 x 1 scalar!");
        }
        NumberOfAverages = (int) mxGetScalar(INPUT3);
    } else {
        NumberOfAverages = 1;
    }
    
    /* Input 4: Sample Period when Averaging (scalar) */
    if (nrhs >= 4) {
        m = mxGetM(INPUT4);
        n = mxGetN(INPUT4);
        if (!mxIsNumeric(INPUT4) || mxIsComplex(INPUT4) || !mxIsDouble(INPUT4) || (max(m,n) != 1) || (min(m,n) != 1)) {
            mexErrMsgTxt("INPUT #4 must be a 1 x 1 scalar!");
        }
        AveragingSamplingPeriod = mxGetScalar(INPUT4);
    } else {
        AveragingSamplingPeriod = .1;
    }
      
      
    /* Create output vectors */
    OUTPUT1 = mxCreateDoubleMatrix((unsigned int) Rows, (unsigned int) tcols, mxREAL);
    AM = mxGetPr(OUTPUT1);
    
    
    /* Initialize output array 
    for (i=0; i<tcols; i++) {
        for (Device=0; Device<Rows; Device++) {
            AM[i*Rows+Device] = (double) 0.0;
        }
    } */

    
    if (nlhs >= 2) {
        OUTPUT2 = mxCreateDoubleMatrix((unsigned int) trows, (unsigned int) tcols, mxREAL);
        tout = mxGetPr(OUTPUT2);
    }
    
    
    set_min_time_between_do_gets(0.0);
    
    
    /* Build channel list */
    for (Device=0; Device<Rows; Device++) {
        for (j=0; j<Cols; j++) {
            if (ChannelNames[Device + j*Rows] == ' ') {
                NameBuffer[j] = '\0';
                break;
            } else {
                NameBuffer[j] = ChannelNames[Device + j*Rows];
            }
        }
	    NameBuffer[Cols] = '\0';
        /* mexPrintf("Names:  |%s|\n", NameBuffer); */
    
        Status = que_get(NameBuffer, SCA_DOUBLE, 1, &DataArray[Device], &StatusArray[Device]);
               
        if (sca_error(Status)) {
            print_sca_status(Status);
            mexErrMsgTxt("   QUE_GET error in GetChannels (scaget.c).\n");
            Status = -1;
        }
    }
    
    

    /* Data Loop */
    Time0 = GetTime();
    for (i=0; i<tcols; i++) {
        /* Delay between sample points */
        SleepTime = t[i] - (GetTime()-Time0) - .002;
        if (SleepTime > 0) {
            SleepTimeInt = (int)  (1000 * SleepTime);
            /*printf(" SleepTime = %f %d\n", SleepTime, SleepTimeInt);*/
            sca_sleep(SleepTimeInt, 100000);
            /*Sleep(SleepTime);*/
        }
        /*printf(" Time0=%f GetTime=%f  GetTime-Time0=%f\n", Time0, GetTime(), GetTime()-Time0); */
        
                
        /* Get data */
        for (AverageLoop=1; AverageLoop<=NumberOfAverages; AverageLoop++) {
            Time0Avg = GetTime();
            NumberOfErrors = do_get(max_wait);
            if (NumberOfErrors > 0) {
                printf(" NumberOfErrors=%d\n", NumberOfErrors);
                for (Device=0; Device<Rows; Device++) {
                    if (sca_error(StatusArray[Device])) {
                        print_sca_status(StatusArray[Device]);
                        Status = -1;
                    }
                }
                if (Status)
                    mexErrMsgTxt("   DO_GET error in GetChannels (scaget.c).\n");
                
            } else {
                for (Device=0; Device<Rows; Device++) {
                    AM[i*Rows+Device] = AM[i*Rows+Device] + DataArray[Device]/(double) NumberOfAverages;
                    /* printf("   Device #%d  AM=%f  DataArray=%f\n", Device, AM[i*Rows+Device], DataArray[Device]); */
                }
                
                /* Average data at AveragingSamplingPeriod */
                if (AverageLoop < NumberOfAverages) {
                    SleepTime = AveragingSamplingPeriod - (GetTime()-Time0Avg) - .002;
                    if (SleepTime > 0) {
                        SleepTimeInt = (int)  (1000 * SleepTime);
                        /* printf(" SleepTime = %f %d\n", SleepTime, SleepTimeInt); */
                        sca_sleep(SleepTimeInt, 100000);
                    }
                }
            }
        }

        /* Output time if output exists */
        if (nlhs >= 2)
            tout[i] = GetTime() - Time0;
        
        /* Output time stamp if output exists */
        /* if (nlhs >= 3)
            TimeStamp[i] = ;  */
    
    }
    
    
    if (nlhs >= 3) {
        OUTPUT3 = mxCreateDoubleMatrix((unsigned int) 1, (unsigned int) 1, mxREAL);
        ErrorFlag = mxGetPr(OUTPUT3);
        *ErrorFlag = (double) Status;
    }
    
    
    mxFree(ChannelNames);
    mxFree(StatusArray);
    mxFree(DataArray);
}

