#include <stdio.h>
#include <string.h>
#include <math.h>
#include "mex.h"
#include "mexfunc.h"
#include "scalib.h"


/* Input Arguments */
#define	INPUT1  prhs[0]



/*  MATLAB TO C-CALL LINKING FUNCTION  */
void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[] )
{
	int Time;
	double   Value;

	/* Check for proper number of arguments */
	if (nrhs != 1) {
		mexErrMsgTxt("requires 1 input argument (seconds).");
	}

	Value = mxChkGetScalar(INPUT1);

	Time =  (int) (1000*Value);

	/* printf(" Time  = %Ld\n", Time); */

	sca_sleep(Time,100000);

} 




