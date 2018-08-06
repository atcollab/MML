/* $Id: lcaLastError.c,v 1.4 2007/06/01 21:36:53 guest Exp $ */

/* matlab wrapper for lcaGetLastError */

/* Author: Till Straumann <strauman@slac.stanford.edu>, 2007 */

/* LICENSE: EPICS open license, see ../LICENSE file */

#include "mglue.h"
#include "multiEzca.h"

#include <cadef.h>
#include <ezca.h>

#include <ctype.h>

#include <epicsTypes.h>

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
int        i;
int        *src;
epicsInt32 *dst;
LcaError   *ptheErr = lcaGetLastError();
LcaError   theErr;

	lcaErrorInit(&theErr);

	LHSCHECK(nlhs, plhs);

	if ( nlhs > 1 ) {
		lcaSetError(&theErr, EZCA_INVALIDARG, "Too many output args");
		goto cleanup;
	}

	if ( nrhs ) {
		lcaSetError(&theErr, EZCA_INVALIDARG, "Expected no rhs argument");
		goto cleanup;
	}

	if ( (i=ptheErr->nerrs) ) {
		src = ptheErr->errs;
	} else {
		i   = 1;
		src = &ptheErr->err;
	}

	if ( ! (plhs[0] = mxCreateNumericMatrix( i, 1, mxINT32_CLASS, mxREAL )) ) {
		lcaSetError(&theErr, EZCA_FAILEDMALLOC, "Not enough memory");
		goto cleanup;
	}

	dst = mxGetData(plhs[0]);

	while ( i-- ) {
		*dst++ = *src++;
	}

	nlhs = 0;

cleanup:

	/* do this LAST (in case mexErrMsgTxt is called) */
	ERR_CHECK(nlhs, plhs, &theErr);
}
