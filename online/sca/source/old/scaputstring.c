#include <stdio.h>
#include <string.h>
#include <math.h>
#include "matrix.h"
#include "mex.h"
#include "mexfunc.h"

/* prototypes for channel access III calls */
#include "scalib.h"


/* Input Arguments */
#define	INPUT1  prhs[0]
#define	INPUT2  prhs[1]

/* Output Arguments */
#define	OUTPUT1 plhs[0]


/*  MATLAB TO C-CALL LINKING FUNCTION  */
void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[] )
{
	char     *InName, *InString;
	int      num_values, outputdim=1, status, NumberOfErrors;
	double   *Out1, *magAM, Value;

	/* Check for proper number of arguments */
	if (nrhs != 2) {
		mexErrMsgTxt("requires 2 input arguments.");
	}

	InName = mxCalloc(50, sizeof(char));
	mxChkGetString(INPUT1, InName);

	InString = mxCalloc(51, sizeof(char));
	mxChkGetString(INPUT2, InString);
	
	/* strcpy(DeviceName, "SR01C   QF1*DV"); */
	/* printf("\n%s\n", DeviceName);         */


	/* Change channel (string) */
	set_min_time_between_do_puts(0.0);
	
	/* Build setpoint channel list */
	status = que_put(InName, SCA_STRING, 1, InString, &status);
	if (sca_error(status)) {
		mexPrintf(" Channel Name: %s, String=%s, status=%x\n", InName, InString, status);
		print_sca_status(status);
		mxFree(InName);
		mxFree(InString);
		mexErrMsgTxt("    QUE_PUT error in scaputstring.\n");
	}

	NumberOfErrors = do_put(-1.0);  /* Do puts without callbacks */
	if (NumberOfErrors > 0) {
		if (sca_error(status)) {
			mexPrintf(" Channel Name: %s, String=%s, status=%x\n", InName, InString, status);
			print_sca_status(status);
			mxFree(InName);
			mxFree(InString);
			mexErrMsgTxt("    DO_PUT error in scaputstring.\n");
		}
	}

	if (nlhs >= 1) {
		OUTPUT1 = mxCreateDoubleMatrix((unsigned int) 1, (unsigned int) 1, mxREAL);
		Out1 = mxGetPr(OUTPUT1);
		*Out1 = (double) sca_error(status);	
	}
		
	mxFree(InName);
	mxFree(InString);
}




