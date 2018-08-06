/* $Id: lcaSetSeverityWarnLevel.c,v 1.5 2007/05/31 21:16:45 till Exp $ */

/* matlab wrapper for ezcaSetSeverityWarnLevel */

/* Author: Till Straumann <strauman@slac.stanford.edu>, 2002-2003  */

/* LICENSE: EPICS open license, see ../LICENSE file */

#include "mglue.h"
#include "multiEzca.h"

#include <cadef.h>
#include <ezca.h>

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
LcaError theErr;
	
	lcaErrorInit(&theErr);

	LHSCHECK(nlhs, plhs);

	if ( 1 < nlhs ) {
		lcaSetError(&theErr, EZCA_INVALIDARG, "Need one output arg");
		goto cleanup;
	}

	if ( 1 != nrhs ) {
		lcaSetError(&theErr, EZCA_INVALIDARG, "Expected one rhs argument");
		goto cleanup;
	}

	if ( !mxIsNumeric(prhs[0]) || 1 != mxGetM(prhs[0]) || 1 != mxGetN(prhs[0]) ) {
		lcaSetError(&theErr, EZCA_FAILEDMALLOC, "Need a single numeric argument");
		goto cleanup;
	}
	ezcaSetSeverityWarnLevel((int)mxGetScalar(prhs[0]));

	nlhs = 0;

cleanup:
	ERR_CHECK(nlhs, plhs, &theErr);
}
