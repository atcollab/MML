/* $Id: lcaDebugOn.c,v 1.1 2015/06/04 19:45:30 strauman Exp $ */

/* matlab wrapper for ezcaDebugOn() */

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

	if ( 0 != nrhs ) {
		lcaSetError(&theErr, EZCA_INVALIDARG, "Expected no rhs argument");
		goto cleanup;
	}

	ezcaDebugOn();

	nlhs = 0;

cleanup:
	ERR_CHECK(nlhs, plhs, &theErr);
}
