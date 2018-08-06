#include <stdio.h>
#include <string.h>
#include <math.h>
#include "mex.h"
#include "mexfunc.h"
#include "scalib.h"


/* Input Arguments */
#define	INPUT1  prhs[0]


/* Output Arguments */
#define	OUTPUT1 plhs[0]
#define	OUTPUT2 plhs[1]



/*  MATLAB TO C-CALL LINKING FUNCTION  */
void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[] )
{
	char   *DeviceName;
	char   *pvalue;
	int    Outputdim=1, status, num_errors;
	double *Out2;


	/* Check for proper number of arguments */
	if (nrhs != 1) {
		mexErrMsgTxt("Requires 1 input argument.");
	}


	DeviceName = mxCalloc(50, sizeof(char));
	mxChkGetString(INPUT1, DeviceName);

	pvalue = mxCalloc(51, sizeof(char));


/*	status = SCAget( DeviceName, 0, 0, SCA_STRING, SCA_MAX_GET_COUNT, pvalue );
*/

	set_min_time_between_do_gets(0.0);


	status = que_get(DeviceName, SCA_STRING, 50, pvalue, &status);
	if (sca_error(status)) {
		print_sca_status(status);
		mexPrintf(" Channel Name: %s, status=%x\n", DeviceName, status);
		print_sca_status(status);
		mxFree(pvalue);
		mxFree(DeviceName);
		mexErrMsgTxt("    QUE_GET error (scaget.c).");
	}
		
	num_errors = do_get(10.0);
	if (sca_error(status)) {
		mexPrintf(" Channel Name: %s, status=%x\n", DeviceName, status);
		print_sca_status(status);
		mxFree(pvalue);
		mxFree(DeviceName);
		mexErrMsgTxt("    DO_GET error (scaget.c)");
	}
		

	/* Create output vectors */
	OUTPUT1 = mxCreateString(pvalue);
		
	if (nlhs >= 2) {
		OUTPUT2 = mxCreateDoubleMatrix((unsigned int) Outputdim, (unsigned int) 1, mxREAL);
		Out2 = mxGetPr(OUTPUT2);
		*Out2 = (double) sca_error(status);	
	}

	
	/*
	printf("%d, %d \n", SCA_MAX_GET_COUNT , SCA_MAX_STRING);
	printf("%s", DeviceName);
	printf("\t%s\n", pvalue);
	printf("%d\n", status);  
	*/
	

	mxFree(pvalue);
	mxFree(DeviceName);
} 




