/* $Id: lcaDelay.c,v 1.7 2007/06/05 05:03:12 guest Exp $ */

/* matlab wrapper for ezcaDelay */

/* Author: Till Straumann <strauman@slac.stanford.edu>, 2002-2003  */

/* LICENSE: EPICS open license, see ../LICENSE file */

#include "mglue.h"

#include <cadef.h>
#include <ezca.h>

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
int      rc;
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

	if ( !mxIsDouble(prhs[0]) || 1 != mxGetM(prhs[0]) || 1 != mxGetN(prhs[0]) ) {
		lcaSetError(&theErr, EZCA_INVALIDARG, "Need a single numeric argument");
		goto cleanup;
	}

	rc = ezcaDelay((float)*mxGetPr(prhs[0]));

	if ( !rc ) {
		nlhs = 0;
	} else {
		char *msg = "lcaDelay";
		switch ( rc ) {
			case EZCA_INVALIDARG: msg = "lcaDelay: need 1 timeout arg > 0";
			break;
			case EZCA_ABORTED:    msg = "lcaDelay: usr abort";
			break;
			default:
			break;
		}
		lcaSetError(&theErr, rc, msg);
	}

cleanup:
	/* do this LAST (in case mexErrMsgTxt is called) */
	ERR_CHECK(nlhs, plhs, &theErr);
}
