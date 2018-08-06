#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include "mex.h"
#include "matrix.h"
#include "gpfunc.h"
#include "scalib.h"


/* Output Arguments */
#define	OUTPUT1 plhs[0]
#define	OUTPUT2 plhs[1]
#define	OUTPUT3 plhs[2]
#define	OUTPUT4 plhs[3]


/*  Type is form in which caller wants SCAget to return the value(s) or
    form in which caller is supplying value(s) to SCAput
#define SCA_STRING	100
#define	SCA_SHORT	101
#define	SCA_FLOAT	102
#define	SCA_ENUM	103
#define	SCA_CHAR	104
#define	SCA_LONG	105
#define	SCA_DOUBLE	106
#define	SCA_INT		107
*/
#define SCA_MAX_STRING	40	/* longest string SCAget will return */


#define max(a, b)  (((a) > (b)) ? (a) : (b)) 
#define min(a, b)  (((a) < (b)) ? (a) : (b)) 


/* TO-DO LIST
 * If EPICSType then add Number of outputs to input line?
 * Compile and run from ML path only ("scalib.h", libraries, etc) change cc.m
 * EPICS time stamps
 * Get EPICS Waveforms
 * Get/Set other EPICS types, like strings (not just SCA_DOUBLE)
 * Compile on PC and Linux
 */


/*  MATLAB TO C-CALL LINKING FUNCTION  */
void mexFunction( int nlhs, mxArray *plhs[],
int nrhs, const mxArray *prhs[] )
{
    char     *ChannelNames, NameBuffer[51], EPICStypeString[25];
    int      i, j, k, trows, tcols, NumberOfAverages, AverageLoop, SleepTimeInt;
    int      FunctionType, nInputs=0, Rows, Cols, m, n, Device, NOutput=1, EPICStype, buflen, Status, NumberOfErrors;
    double   *AM, *SectorNum, *TimeStamp, *ErrorFlag, EPICS_Max_Wait;
    double   *t, *tout, t0[1], Time0, TimeAvg, Time0Avg, AveragingSamplingPeriod, SleepTime;

    /* Initialize EPICS Arrays */
    int *StatusArray;
    double *DataArray;
    char CharArray[SCA_MAX_STRING];

    
    /* Starting time */
    Time0 = GetTime();
    

    /* Input 1: Function type (int, scalar) */
    /* 0 -> SetChannels                     */
    /* 1 -> GetChannels - Output: 1 double per que   */
    /* 2 -> GetChannels - EPICS arrays?     */
	m = mxGetM(prhs[nInputs]);
	n = mxGetN(prhs[nInputs]);
	if (!mxIsNumeric(prhs[nInputs]) || mxIsComplex(prhs[nInputs]) || !mxIsDouble(prhs[nInputs]) || (max(m,n) != 1) || (min(m,n) != 1))
		mexErrMsgTxt("INPUT #1 must be a scalar");
        
    FunctionType = (int) mxGetScalar(prhs[nInputs]);
    nInputs = nInputs + 1;

    
    if (FunctionType == 0) {
        /* Set channels */


        /*  Status = scalink(0, ChannelNames, SP, EPICStypeString {opt.}, N {Opt.}) */
        /*  if EPICStypeString then add Number of outputs to input line ???  */
        

        /* Get/Check Inputs */
        if (nrhs < 3)
            mexErrMsgTxt("Channelname input and setpoints are required for puts (scalink.c).");
        
        
        set_min_time_between_do_puts(0.0);
        
        
        /* Allocate memory for input string */
        buflen = (mxGetM(prhs[nInputs]) * mxGetN(prhs[nInputs])) + 1;   /* length of input string */
        ChannelNames = mxCalloc(buflen, sizeof(char));
        Status = mxGetString(prhs[nInputs], ChannelNames, buflen);
        if(Status != 0)
            mexWarnMsgTxt("Not enough space to read in the ChannelName string.  ChannelName is truncated.");

        Rows = (int) mxGetM(prhs[nInputs]);
        Cols = (int) mxGetN(prhs[nInputs]);
        
        nInputs = nInputs + 1;
        /*  Input: Channel names complete */
        
        
        /* Allocate memory for EPICS data */
        StatusArray = mxCalloc(Rows, sizeof(int));

        
        /* Input: Setpoints */
        if (!mxIsNumeric(prhs[nInputs]) || mxIsComplex(prhs[nInputs]) || !mxIsDouble(prhs[nInputs]))
            mexErrMsgTxt("Setpoints must be a double (at the moment).");
        
        DataArray = mxGetPr(prhs[nInputs]);
        nInputs = nInputs + 1;
        /*  Input: Setpoints complete */

        
        /*  EPICS type could be the next input */
        EPICStype = SCA_DOUBLE;
        if (nrhs > nInputs) {
            if (mxIsChar(prhs[nInputs]) == 1) {
                buflen = (mxGetM(prhs[nInputs]) * mxGetN(prhs[nInputs])) + 1;
                Status = mxGetString(prhs[nInputs], EPICStypeString, buflen);
                nInputs = nInputs + 1;
                
                if (strcmp(EPICStypeString, "STRING")==0 || strcmp(EPICStypeString, "String")==0 || strcmp(EPICStypeString, "string")==0) {
                    EPICStype = SCA_STRING;
                }


                /* Number of outputs */
                if (nrhs > nInputs) {
                    m = mxGetM(prhs[nInputs]);
                    n = mxGetN(prhs[nInputs]);
                    if (!mxIsNumeric(prhs[nInputs]) || mxIsComplex(prhs[nInputs]) || !mxIsDouble(prhs[nInputs]) || (max(m,n) != 1) || (min(m,n) != 1))
                        mexErrMsgTxt("N (number of outputs) must be a scalar");
                    
                    NOutput = (int) mxGetScalar(prhs[nInputs]);
                    nInputs = nInputs + 1;
                }
            }
        }

        
        /* Build setpoint channel list */
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
            /* mexPrintf("Names: |%s|  N=%d  SP=%f\n", NameBuffer, NOutput, DataArray[Device]); */
            
            Status = que_put(NameBuffer, EPICStype, NOutput, &DataArray[Device], &StatusArray[Device]);
            if (sca_error(Status)) {
                mexPrintf("   Channel Name: %s, status=%x\n", NameBuffer, StatusArray[Device]);
                print_sca_status(Status);
                mexErrMsgTxt("QUE_PUT error (scalink.c).\n");
            }
        }
        
    
        NumberOfErrors = do_put(-1.0);  /* Do puts without callbacks */
        if (NumberOfErrors > 0) {
            mexPrintf("   Number of errors = %d\n", NumberOfErrors);
            for (Device=0; Device<Rows; Device++) {
                if (sca_error(StatusArray[Device])) {
                    print_sca_status(StatusArray[Device]);
                }
            }
        }
        if (NumberOfErrors > 0)
            mexErrMsgTxt("DO_PUT error (scalink.c).\n");
        

        /* Status flag output */
        if (nlhs >= 1) {
            OUTPUT1 = mxCreateDoubleMatrix((unsigned int) 1, (unsigned int) 1, mxREAL);
            ErrorFlag = mxGetPr(OUTPUT1);
            *ErrorFlag = (double) 0.0;  /* "Status" has an EPICS code */
        }

        mxFree(ChannelNames);
        mxFree(StatusArray);

        
    } else if (FunctionType == 1) {
        
        /* Get channels */
    
        /*  [AM, t, timestamp, Status] = scalink(1, ChannelNames, t, NumberOfAverages, AveragingSamplingPeriod) */
        /*  [AM, t, timestamp, Status] = scalink(1, ChannelNames, EPICStypeString, N, t, NumberOfAverages, AveragingSamplingPeriod) */
        /*  if EPICStypeString then add Number of outputs to input line ??? */
    

        /* Get/Check Inputs */
        if (nrhs < 2)
            mexErrMsgTxt("Channelname input required for gets (scalink.c).");

        
        /*  Maximum time to wait to get a EPICS PV */
        EPICS_Max_Wait = 5.0;
        
        set_min_time_between_do_gets(0.0);
        
        
        /* Input: Channel names (Matrix of strings) */
        if (mxIsChar(prhs[nInputs]) != 1)
            mexErrMsgTxt("ChannelName input must be a string");
        

        /* Allocate memory for input string */
        buflen = (mxGetM(prhs[nInputs]) * mxGetN(prhs[nInputs])) + 1;   /* length of input string */
        ChannelNames = mxCalloc(buflen, sizeof(char));
        Status = mxGetString(prhs[nInputs], ChannelNames, buflen);
        if(Status != 0)
            mexWarnMsgTxt("Not enough space to read in the ChannelName string.  ChannelName is truncated.");
        
        Rows = (int) mxGetM(prhs[nInputs]);
        Cols = (int) mxGetN(prhs[nInputs]);
        
        nInputs = nInputs + 1;
        /* Input: Channel names complete */
        

        /* EPICS type could be the next input */
        EPICStype = SCA_DOUBLE;
        if (nrhs > nInputs) {
            if (mxIsChar(prhs[nInputs]) == 1) {
                buflen = (mxGetM(prhs[nInputs]) * mxGetN(prhs[nInputs])) + 1;
                Status = mxGetString(prhs[nInputs], EPICStypeString, buflen);
                nInputs = nInputs + 1;
                
                if (strcmp(EPICStypeString, "STRING")==0 || strcmp(EPICStypeString, "String")==0 || strcmp(EPICStypeString, "string")==0) {
                    EPICStype = SCA_STRING;
                }
                
                /* Number of outputs */
                if (nrhs > nInputs) {
                    m = mxGetM(prhs[nInputs]);
                    n = mxGetN(prhs[nInputs]);
                    if (!mxIsNumeric(prhs[nInputs]) || mxIsComplex(prhs[nInputs]) || !mxIsDouble(prhs[nInputs]) || (max(m,n) != 1) || (min(m,n) != 1))
                        mexErrMsgTxt("N (number of outputs) must be a scalar");
                    
                    NOutput = (int) mxGetScalar(prhs[nInputs]);
                    nInputs = nInputs + 1;
                }
            }
        }
        
        
        /* Input: t */
        if (nrhs > nInputs) {
            trows = (int) mxGetM(prhs[nInputs]);
            tcols = (int) mxGetN(prhs[nInputs]);
            if (!mxIsNumeric(prhs[nInputs]) || mxIsComplex(prhs[nInputs]) || !mxIsDouble(prhs[nInputs]) || (trows != 1))
                mexErrMsgTxt("t must be a row vector.");
            
            t = mxGetPr(prhs[nInputs]);
        } else {
            trows = 1;
            tcols = 1;
            t0[0] = 0;
            t = &t0[0];
        }
        nInputs = nInputs + 1;
        /*  Input: t complete */
        

        /* Input: NumberOfAverages (int, scalar) */
        if (nrhs > nInputs) {
            m = mxGetM(prhs[nInputs]);
            n = mxGetN(prhs[nInputs]);
            if (!mxIsNumeric(prhs[nInputs]) || mxIsComplex(prhs[nInputs]) || !mxIsDouble(prhs[nInputs]) || (max(m,n) != 1) || (min(m,n) != 1)) {
                mexErrMsgTxt("NumberOfAverages must be a 1 x 1 scalar!");
            }
            NumberOfAverages = (int) mxGetScalar(prhs[nInputs]);
            if (NumberOfAverages == 0)
                NumberOfAverages = 1;
        } else {
            NumberOfAverages = 1;
        }
        if (NumberOfAverages < 1)
            NumberOfAverages = 1;
            
        nInputs = nInputs + 1;
        /*  Input: NumberOfAverages complete */
        
        
        /* Input: Sample Period when Averaging (scalar) */
        if (nrhs > nInputs) {
            m = mxGetM(prhs[nInputs]);
            n = mxGetN(prhs[nInputs]);
            if (!mxIsNumeric(prhs[nInputs]) || mxIsComplex(prhs[nInputs]) || !mxIsDouble(prhs[nInputs]) || (max(m,n) != 1) || (min(m,n) != 1)) {
                mexErrMsgTxt("AveragingSamplingPeriod must be a 1 x 1 scalar!");
            }
            AveragingSamplingPeriod = mxGetScalar(prhs[nInputs]);
        } else {
            AveragingSamplingPeriod = .1;
        }
        if (AveragingSamplingPeriod < 0)
            AveragingSamplingPeriod = -1 * AveragingSamplingPeriod;
            
        nInputs = nInputs + 1;
        /*  Input: AveragingSamplingPeriod complete */
            
       
            
        /* Create output vectors */
        if (EPICStype == SCA_STRING) {
            /* mexPrintf("   String output:  EPICStype=%d, N=%d, t=%f\n", EPICStype, NOutput, t[0]); */
                      
 
            /* Allocate memory for EPICS data */
            StatusArray = mxCalloc(1, sizeof(int));
            
            
            if (Rows > 1)
                mexPrintf("   Only the first channel name returned (%d ignored)\n", Rows-1);
            
            
            /* Time vector output */
            if (nlhs >= 2) {
                OUTPUT2 = mxCreateDoubleMatrix((unsigned int) 1, (unsigned int) 1, mxREAL);
                tout = mxGetPr(OUTPUT2);
            }
          
            /* TimeStamp vector output */
            if (nlhs >= 2) {
                OUTPUT3 = mxCreateDoubleMatrix((unsigned int) 1, (unsigned int) 1, mxREAL);
                TimeStamp = mxGetPr(OUTPUT3);
            }
 
 
            /* Que the channel list */
            for (Device=0; Device<1; Device++) {     /*  Row changes to 1 */
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
            
                Status = que_get(NameBuffer, SCA_STRING, NOutput, &CharArray[0], &StatusArray[0]);
                if (sca_error(Status)) {
                    mexPrintf("   Channel Name = %s, status=%x\n", NameBuffer, StatusArray[0]);
                    print_sca_status(Status);
                    mexErrMsgTxt("QUE_GET error (scalink.c).\n");
                }
            
                NumberOfErrors = do_get(EPICS_Max_Wait);

                if (NumberOfErrors > 0) {
                    if (sca_error(StatusArray[0])) {
                        mexPrintf("   Channel Name = %s, status=%x\n", NameBuffer, StatusArray[0]);
                        print_sca_status(StatusArray[0]);
                    }
                    mexErrMsgTxt("DO_GET error (scalink.c).\n");
                }
                 

                /* mexPrintf("   OutputString = |%s|\n", &CharArray[0]); */

            }
            
 
            /* String outputs */           
            OUTPUT1 = mxCreateString((char *) &CharArray[0]);
                     

            
            /* Output time if output exists */
            if (nlhs >= 2)
                tout[0] = GetTime() - Time0;
            
            /* Output time stamp if output exists */
            if (nlhs >= 3)
                TimeStamp[0] = tout[0];    /*  Get EPICS Time Stamp ??? */
            
            
        } else {
        
            /* mexPrintf("   Double output:  EPICStype=%d, N=%d, t=%f\n", EPICStype, NOutput, t[0]); */
     
            /* Allocate memory for EPICS data */
            StatusArray = mxCalloc(Rows, sizeof(int));
            DataArray   = mxCalloc(Rows, sizeof(double));

            
            OUTPUT1 = mxCreateDoubleMatrix((unsigned int) Rows, (unsigned int) tcols, mxREAL);
            AM = mxGetPr(OUTPUT1);
            
            
            /* Initialize output array
            for (i=0; i<tcols; i++) {
                for (Device=0; Device<Rows; Device++) {
                    AM[i*Rows+Device] = (double) 0.0;
                }
            } */
            
            
            
            /* Time vector output */
            if (nlhs >= 2) {
                OUTPUT2 = mxCreateDoubleMatrix((unsigned int) trows, (unsigned int) tcols, mxREAL);
                tout = mxGetPr(OUTPUT2);
            }
          
            /* TimeStamp vector output */
            if (nlhs >= 2) {
                OUTPUT3 = mxCreateDoubleMatrix((unsigned int) trows, (unsigned int) tcols, mxREAL);
                TimeStamp = mxGetPr(OUTPUT3);
            }
 


            /* Que the channel list */
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
                
                Status = que_get(NameBuffer, EPICStype, NOutput, &DataArray[Device], &StatusArray[Device]);
                if (sca_error(Status)) {
                    mexPrintf("   Channel Name: %s, status=%x\n", NameBuffer, StatusArray[Device]);
                    print_sca_status(Status);
                    mexErrMsgTxt("QUE_GET error (scalink.c).\n");
                }
            }
            
            
            /* Data Loop */
            for (i=0; i<tcols; i++) {
                /* Delay between sample points */
                SleepTime = t[i] - (GetTime()-Time0) - .002;        /* The extra time is for processing time */
                /* mexPrintf(" SleepTime = %f\n", SleepTime); */
                if (SleepTime > 0) {
                    SleepTimeInt = (int)  (1000 * SleepTime);
                    sca_sleep(SleepTimeInt, 100000);
                    /* Sleep(SleepTime); */
                }
                /* mexPrintf(" Time0=%f GetTime=%f  GetTime-Time0=%f\n", Time0, GetTime(), GetTime()-Time0); */
                
                
                /* Get data */
                for (AverageLoop=1; AverageLoop<=NumberOfAverages; AverageLoop++) {
                    Time0Avg = GetTime();
                    
                    NumberOfErrors = do_get(EPICS_Max_Wait);
                    /* mexPrintf("   do_get ProcessingTime = %f sec\n", GetTime() - Time0Avg); */
                    
                    if (NumberOfErrors > 0) {
                        mexPrintf("   Number of errors = %d\n", NumberOfErrors);
                        for (Device=0; Device<Rows; Device++) {
                            if (sca_error(StatusArray[Device])) {
                                print_sca_status(StatusArray[Device]);
                            }
                        }
                        mexErrMsgTxt("DO_GET error (scalink.c).\n");
                        
                    } else {
                        
                        
                        for (Device=0; Device<Rows; Device++) {
                            AM[i*Rows+Device] = AM[i*Rows+Device] + DataArray[Device]/(double) NumberOfAverages;
                            /* mexPrintf("   Device #%d  AM=%f  DataArray=%f\n", Device, AM[i*Rows+Device], DataArray[Device]); */
                        }
                        
                        /* Average data at AveragingSamplingPeriod */
                        if (AverageLoop < NumberOfAverages) {
                            SleepTime = AveragingSamplingPeriod - (GetTime()-Time0Avg) - .002;    /* The extra time is for processing time */
                            if (SleepTime > 0) {
                                SleepTimeInt = (int)  (1000 * SleepTime);
                                /*mexPrintf("   SleepTime = %f sec %d msec\n", SleepTime, SleepTimeInt);*/
                                sca_sleep(SleepTimeInt, 100000);
                            }
                        }
                        /*mexPrintf("   Time = %f sec\n", GetTime()-Time0);*/
                    }
                }
                            
                
                /* Output time if output exists */
                if (nlhs >= 2)
                    tout[i] = GetTime() - Time0;
                
                /* Output time stamp if output exists */
                if (nlhs >= 3)
                    TimeStamp[i] = tout[i];  /*  Get EPICS Time Stamp ??? */
                
            }
            mxFree(DataArray);
        }
        
        
        if (nlhs >= 4) {
            OUTPUT4 = mxCreateDoubleMatrix((unsigned int) 1, (unsigned int) 1, mxREAL);
            ErrorFlag = mxGetPr(OUTPUT4);
            *ErrorFlag = (double) 0.0;  /* "Status" has an EPICS code */
        }

        mxFree(ChannelNames);
        mxFree(StatusArray);

        
    } else {
        mexErrMsgTxt("Input #1: Action type unknown (scalink.c).\n");
    }
}

