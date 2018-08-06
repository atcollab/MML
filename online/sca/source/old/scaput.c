#include <stdio.h>
#include <string.h>
#include "mex.h"
#include "mexfunc.h"
#include "matrix.h"
#include "gpfunc.h"
#include "gplink.h"
#include "scalib.h"

/* Input Arguments */
#define	INPUT1  prhs[0]
#define	INPUT2  prhs[1]
#define	INPUT3  prhs[2]
#define	INPUT4  prhs[3]
#define	INPUT5  prhs[4]
#define	INPUT6  prhs[5]
#define	INPUT7  prhs[6]
#define	INPUT8  prhs[7]

/* Output Arguments */
#define	OUTPUT1 plhs[0]
#define	OUTPUT2 plhs[1]
#define	OUTPUT3 plhs[2]


/*  MATLAB TO C-CALL LINKING FUNCTION  */
void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[] )
{
	char     *Family;
	int      i, FunctionType, NumberOfAverages, ChanTypeFlag, WaitOnSPFlag, status, SleepTimeInt;
	int      nrowsDeviceNum, ncolsDeviceNum;
	int      nrowsSectorNum, ncolsSectorNum;
	int      nrowsNewSP, ncolsNewSP;
	int      nrowst, ncolst;
	double   *AM, *SectorNum, *DeviceNum, *NewSP, *t, *tout, *ErrorFlag, t0=0, SleepTime, Time0;


	/* Check Inputs */
	if (nrhs < 4)
		mexErrMsgTxt("More input arguments needed (4 to get a channel, 5 to set a channel) (alslink.c).");

	/* Input 1: Function type (int, scalar) */
	/* 0 -> GetChannels                     */
	/* 1 -> SetChannels                     */
	FunctionType = (int) mxChkGetScalar(INPUT1);


	/* Input 2: Family name (string) */	
	Family = mxCalloc(50, sizeof(char));
	mxChkGetString(INPUT2, Family);  

	
	/* Input 3: Sector (column vector) */
	nrowsSectorNum = (int) mxGetM(INPUT3);
	ncolsSectorNum = (int) mxGetN(INPUT3);
	if (!mxIsNumeric(INPUT3) || mxIsComplex(INPUT3) || 
		!mxIsDouble(INPUT3) ||
		ncolsSectorNum != 1)
		mexErrMsgTxt("SectorNum must be a column vector equal to DeviceNum.");
	SectorNum = mxGetPr(INPUT3); 
	

	/* Input 4: Magnet Numbers (column vector) */
	nrowsDeviceNum = (int) mxGetM(INPUT4);
	ncolsDeviceNum = (int) mxGetN(INPUT4);
	if (!mxIsNumeric(INPUT4) || mxIsComplex(INPUT4) || 
		!mxIsDouble(INPUT4) ||
		ncolsDeviceNum != 1 || nrowsSectorNum != nrowsDeviceNum)
		mexErrMsgTxt("DeviceNum must be a column vector equal to SectorNum.");
	DeviceNum = mxGetPr(INPUT4);  


	if (FunctionType == 0) {      /* Get channels */
		/* Input 5: NumberOfAverages (int, scalar) */
		if (nrhs >= 5)
			NumberOfAverages = (int) mxChkGetScalar(INPUT5);
		else
			NumberOfAverages = 1;	


		/* Input 6: ChanTypeFlag (int, scalar) */
		if (nrhs >= 6)
			ChanTypeFlag = (int) mxChkGetScalar(INPUT6);
		else
			ChanTypeFlag = 0;	/* Default: AM */

		/* Input 7 */
		if (nrhs >= 7) {
			nrowst = (int) mxGetM(INPUT7);
			ncolst = (int) mxGetN(INPUT7);
			if (!mxIsNumeric(INPUT7) || mxIsComplex(INPUT7) || 
				!mxIsDouble(INPUT7) ||
				(nrowst != 1))
				mexErrMsgTxt("t must be a row vector.");
			t = mxGetPr(INPUT7);
		} else {
			nrowst = 1;
			ncolst = 1;
			t = &t0;
  		}



		/* Create output vectors */
		OUTPUT1 = mxCreateDoubleMatrix((unsigned int) nrowsDeviceNum, (unsigned int) ncolst, mxREAL);
		AM = mxGetPr(OUTPUT1);

		if (nlhs >= 2) {
			OUTPUT2 = mxCreateDoubleMatrix((unsigned int) nrowst, (unsigned int) ncolst, mxREAL);
			tout = mxGetPr(OUTPUT2);
		}


		/* Data Loop */
		Time0 = GetTime(); 
		for (i=0; i<ncolst; i++) {
			/* Delay between sample points */
			SleepTime = t[i] - (GetTime()-Time0) - .002;
			if (SleepTime > 0) {
				SleepTimeInt = (int)  (1000 * SleepTime);
				/* printf(" SleepTime = %f %d\n", SleepTime, SleepTimeInt); */
				sca_sleep(SleepTimeInt, 100000);
			}
			
			/* Get outputs */
			status = GetChannels(Family, SectorNum, DeviceNum, &(AM[i*nrowsDeviceNum]), nrowsDeviceNum, NumberOfAverages, ChanTypeFlag);

			if (nlhs >= 2)
				tout[i] = GetTime() - Time0;  
		}

		if (nlhs >= 3) {
			OUTPUT3 = mxCreateDoubleMatrix((unsigned int) 1, (unsigned int) 1, mxREAL);
			ErrorFlag = mxGetPr(OUTPUT3);
			*ErrorFlag = (double) status;
		}

	} else if (FunctionType == 1) {       /* Set channels */
		if (nrhs < 5)
			mexErrMsgTxt("Atleast 5 input arguments needed for setting channels (alslink.c).");

		/* Input 5: Magnet Numbers (column vector) */
		nrowsNewSP = (int) mxGetM(INPUT5);
		ncolsNewSP = (int) mxGetN(INPUT5);
		if (!mxIsNumeric(INPUT5) || mxIsComplex(INPUT5) || 
			!mxIsDouble(INPUT5) ||
			ncolsDeviceNum != 1 || nrowsNewSP != nrowsDeviceNum)
			mexErrMsgTxt("NewSP must be a column vector equal to SectorNum & DeviceNum.");
		NewSP = mxGetPr(INPUT5);  


		/* Input 6: ChanTypeFlag (int, scalar) */
		if (nrhs >= 6)
			ChanTypeFlag = (int) mxChkGetScalar(INPUT6);
		else
			ChanTypeFlag = 1;	/* Default: AC */


		/* Input 7: WaitOnSPFlag (int, scalar) */
		if (nrhs >= 7)
			WaitOnSPFlag = (int) mxChkGetScalar(INPUT7);
		else
			WaitOnSPFlag = 1;	/* Default: wait */


		/* Create output vectors */
		if (nlhs >= 1) {
			OUTPUT1 = mxCreateDoubleMatrix((unsigned int) nrowsDeviceNum, (unsigned int) 1, mxREAL);
			AM = mxGetPr(OUTPUT1);
		}

		if (nlhs >= 2) {
			OUTPUT2 = mxCreateDoubleMatrix((unsigned int) 1, (unsigned int) 1, mxREAL);
			tout = mxGetPr(OUTPUT2);
		}


		/* Data Loop */
		Time0 = GetTime(); 

		status = SetChannels(Family, SectorNum, DeviceNum, NewSP, nrowsDeviceNum, ChanTypeFlag, WaitOnSPFlag);
			
		if (nlhs >= 3) {
			OUTPUT3 = mxCreateDoubleMatrix((unsigned int) 1, (unsigned int) 1, mxREAL);
			ErrorFlag = mxGetPr(OUTPUT3);
			*ErrorFlag = (double) status;
		}
		
		if (nlhs >= 1)
			status = GetChannels(Family, SectorNum, DeviceNum, AM, nrowsDeviceNum, 1, 0);

		if (nlhs >= 2)
			*tout = GetTime() - Time0;  


	} else
		mexErrMsgTxt("No function type defined.");
	

	mxFree(Family);
}

