#include <stdio.h>
#include <string.h>
#include "mex.h"
#include "matrix.h"
#include <nslsc.h>
#include <ucode_def.h>
#include <umacro_v2.h>
#include <time.h>


#define N_MAX 256


/* Input Arguments */
#define	INPUT1  prhs[0]
#define	INPUT2  prhs[1]



/* Output Arguments */
#define	OUTPUT1 plhs[0]
#define	OUTPUT2 plhs[1]
#define	OUTPUT3 plhs[2]


int uget(int ndev, DEV_NAME devnames[], double setp[], double rdbk[])
{
  int       i, setp_cnts[N_MAX], rdbk_cnts[N_MAX], status;
  float     gain[N_MAX], offset[N_MAX];

  if (ndev < 1) {
    printf("*** No of devices = %d\n", ndev); exit(0);
  }
  for(i = 0; i < ndev; i++) {
    ugddr_getcalib_data(devnames[i], &gain[i], &offset[i]);
  }

  if (uidopen("Ctest")) {
    ucdperror(); exit(1);
  }
  status = ureadsetp(ndev, devnames, setp_cnts) ||
           ureadmag(ndev, devnames, rdbk_cnts);
  if (status) {
    fprintf(stderr, "*** ");
    ucdperror();
  } else {
    for(i = 0; i < ndev; i++) {
      setp[i] = (double) setp_cnts[i] * (double) gain[i]; 
      rdbk[i] = (double) rdbk_cnts[i] * (double) gain[i];
      /*mexPrintf("devnames:  |%s|\n", devnames[i]);*/
   }
  }
  uclose();
  return(status);
}


/*  MATLAB TO C-CALL LINKING FUNCTION  */
void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[] )
{
	char *ChannelNames, Names[200][16];
    int   i, j, buflen, status, UcodeStatus, Rows, Cols;
    double *Setpoint, *ReadBack, *ErrorFlag;

	
	/* Check Inputs */
	if (nrhs < 1 || nrhs > 1)
		mexErrMsgTxt("requires 1 input argument.");


	/* Input 1: Channel names (Matrix of strings) */
	if (mxIsChar(INPUT1) != 1)
	    mexErrMsgTxt("ChannelName input must be a string");

	    
	/* get the length of the input string */
    buflen = (mxGetM(prhs[0]) * mxGetN(prhs[0])) + 1;

    
    /* allocate memory for input string */
    ChannelNames = mxCalloc(buflen, sizeof(char));

    
	/* copy the string data from prhs[0] into a C string input_ buf.
     * If the string array contains several rows, they are copied,
     * one column at a time, into one long string array.
     */
    status = mxGetString(prhs[0], ChannelNames, buflen);
    if(status != 0) 
      mexWarnMsgTxt("Not enough space to read in the ChannelName string.  ChannelName is truncated.");

    Rows = (int) mxGetM(prhs[0]);
    Cols = (int) mxGetN(prhs[0]);


	/* Input 2 */
	/*if (nrhs >= 5) {
		nrowst = (int) mxGetM(INPUT5);
		ncolst = (int) mxGetN(INPUT5);
		if (!mxIsNumeric(INPUT5) || mxIsComplex(INPUT5) || 
			 !mxIsDouble(INPUT5) ||
			(nrowst != 1))
			mexErrMsgTxt("INPUT5 (t) must be a row vector!");
		t = mxGetPr(INPUT5);
	} else {
		nrowst = 1;
		ncolst = 1;
		t = &t0;
  	}
  	*/
  	

	/* End input checking */


	/* Create output vectors */
	OUTPUT1 = mxCreateDoubleMatrix((unsigned int) Rows, (unsigned int) 1, mxREAL);
	ReadBack = mxGetPr(OUTPUT1);

	OUTPUT2 = mxCreateDoubleMatrix((unsigned int) Rows, (unsigned int) 1, mxREAL);
	Setpoint = mxGetPr(OUTPUT2);
	
	OUTPUT3 = mxCreateDoubleMatrix((unsigned int) 1, (unsigned int) 1, mxREAL);
	ErrorFlag = mxGetPr(OUTPUT3);


	/* Get ucode data */
	
	for (i=0; i<Rows; i++) { 
	    for (j=0; j<Cols; j++) { 
	        Names[i][j] = ChannelNames[i + j*Rows];
	        /*mexPrintf("Names:  %c\n", ChannelNames[i + j*Rows]); */
	    }
	    Names[i][Cols] = '\0';
	    /*mexPrintf("Names:  |%s|\n", Names[i]);*/
	}

	/*mexPrintf(" Rows = %d   Cols = %d\n",  Rows, Cols);*/
	UcodeStatus = uget(Rows, Names, Setpoint, ReadBack);
	*ErrorFlag = UcodeStatus;

	
	/* for (i=0; i<ncolst; i++) { */
		/* VecGetAM(Family, SectorNum, DeviceNum, &(AM[i*nrowsDeviceNum]), nrowsDeviceNum, NumberOfAverages, ErrStr);
	}
	*/


	if (UcodeStatus != 0)
	mexPrintf("WARNING: getpvucode() problem\n");
    

 }

