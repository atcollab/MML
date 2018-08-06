/* $Id: lcaNewMonitorWait.c,v 1.2 2007/05/31 21:16:45 till Exp $ */

/* matlab wrapper for ezcaNewMonitorWait */

/* Author: Till Straumann <strauman@slac.stanford.edu>, 2007 */

/* LICENSE: EPICS open license, see ../LICENSE file */

#include "mglue.h"
#include "multiEzca.h"

#include <cadef.h>
#include <ezca.h>

#include <ctype.h>

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
int     i   = 0;
PVs     pvs = { {0} };
char	type = ezcaNative;
LcaError theErr;

	lcaErrorInit(&theErr);

	LHSCHECK(nlhs, plhs);

	if ( nlhs > 1 ) {
		lcaSetError(&theErr, EZCA_INVALIDARG, "Too many output args");
		goto cleanup;
	}

	if ( nrhs < 1 || nrhs > 2 ) {
		lcaSetError(&theErr, EZCA_INVALIDARG, "Expected 1..2 rhs argument");
		goto cleanup;
	}

	/* check for an optional data type argument */
	if ( nrhs > 1 ) {
		if ( ezcaInvalid == (type = marg2ezcaType( prhs[1], &theErr )) ) {
			goto cleanup;
		}
	}

	if ( buildPVs(prhs[0], &pvs, &theErr) )
		goto cleanup;

    if ( 0 == multi_ezca_wait_mon( pvs.names, pvs.m, type, &theErr ) ) {
		nlhs = 0;
	}

cleanup:
	releasePVs(&pvs);
	/* do this LAST (in case mexErrMsgTxt is called) */
	ERR_CHECK(nlhs, plhs, &theErr);
}
