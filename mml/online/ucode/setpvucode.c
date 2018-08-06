#include <stdio.h>
#include <string.h>
#include "mex.h"
#include "matrix.h"


/* Input Arguments */
#define	INPUT1  prhs[0]
#define	INPUT2  prhs[1]
#define	INPUT3  prhs[2]
#define	INPUT4  prhs[3]


/* Output Arguments */
#define	OUTPUT1 plhs[0]
#define	OUTPUT2 plhs[1]


/*  MATLAB TO C-CALL LINKING FUNCTION  */
void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[] )
{
	char     ErrStr[ErrStrMaxLen], Family[26];
	int      ErrLen, i, NumberOfAverages;
	int      nrowsDeviceNum, ncolsDeviceNum;
	int      nrowsSectorNum, ncolsSectorNum;
	int      nrowst, ncolst;
	double   *AM, *SectorNum, *DeviceNum, *t, *tout, t0=0, Time0;

	
	/* Check Inputs */
	if (nrhs < 3 || nrhs > 5)
		mexErrMsgTxt("requires 3 to 5 input arguments.");

	if (mxGetN(INPUT1) > 25) {
		mexErrMsgTxt("Family name must be less than 25 characters.");
	}

	mxChkGetString(INPUT1, Family);  
	
	/* Input 3: Magnet Numbers (column vector) */
	nrowsDeviceNum = (int) mxGetM(INPUT3);
	ncolsDeviceNum = (int) mxGetN(INPUT3);
	if (!mxIsNumeric(INPUT3) || mxIsComplex(INPUT3) || 
		!mxIsDouble(INPUT3) ||
		ncolsDeviceNum != 1)
		mexErrMsgTxt("DeviceNum: must be a column vector (nx1)!");
	DeviceNum = mxGetPr(INPUT3);  
	
	/* Input 2: Sector (column vector) */
	nrowsSectorNum = (int) mxGetM(INPUT2);
	ncolsSectorNum = (int) mxGetN(INPUT2);
	if (!mxIsNumeric(INPUT2) || mxIsComplex(INPUT2) || 
		!mxIsDouble(INPUT2) ||
		ncolsSectorNum != 1 || nrowsSectorNum != nrowsDeviceNum)
		mexErrMsgTxt("SectorNum: must be a column vector equal to DeviceNum (nx1)!");
	SectorNum = mxGetPr(INPUT2); 

	/* Input 4: NumberOfAverages (scalar) */
	if (nrhs >= 4)
		NumberOfAverages = (int) mxChkGetScalar(INPUT4);
	else
		NumberOfAverages = 1;	
	
	/* Input 5 */
	if (nrhs >= 5) {
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

	/* End input checking */


	/* Create output vectors */
	strcpy(ErrStr,"");


	OUTPUT1 = mxCreateDoubleMatrix((unsigned int) nrowsDeviceNum, (unsigned int) ncolst, mxREAL);
	AM = mxGetPr(OUTPUT1);

	if (nlhs >= 2) {
		OUTPUT2 = mxCreateDoubleMatrix((unsigned int) nrowst, (unsigned int) ncolst, mxREAL);
		tout = mxGetPr(OUTPUT2);
	}


	/* Data Loop */
	Time0 = GetTime(); 
	for (i=0; i<ncolst; i++) {
		while ((GetTime()-Time0) < t[i])
			;  /* Delay between sample points */
			
		/* Get outputs */
		VecGetAM(Family, SectorNum, DeviceNum, &(AM[i*nrowsDeviceNum]), nrowsDeviceNum, NumberOfAverages, ErrStr);

		if (nlhs >= 2)
			tout[i] = GetTime() - Time0;  
	}


	if (ErrLen=strlen(ErrStr))
		mexPrintf("WARNING: VecGetAM()\n%s", ErrStr);

 }

