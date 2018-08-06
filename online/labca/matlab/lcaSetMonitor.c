/* $Id: lcaSetMonitor.c,v 1.6 2007/05/31 21:16:45 till Exp $ */

/* matlab wrapper for ezcaSetMonitor */

/* Author: Till Straumann <strauman@slac.stanford.edu>, 2002-2003  */

/* LICENSE: EPICS open license, see ../LICENSE file */

#include "mglue.h"
#include "multiEzca.h"

#include <cadef.h>
#include <ezca.h>

#include <ctype.h>

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
int     i,n = 0;
const mxArray *tmp;
PVs     pvs = { {0} };
char	type = ezcaNative;
LcaError theErr;

	lcaErrorInit(&theErr);

	LHSCHECK(nlhs, plhs);

	if ( nlhs > 1 ) {
		lcaSetError(&theErr, EZCA_INVALIDARG, "Too many output args");
		goto cleanup;
	}

	if ( nrhs < 1 || nrhs > 3 ) {
		lcaSetError(&theErr, EZCA_INVALIDARG, "Expected 1..3 rhs argument");
		goto cleanup;
	}

	/* check for an optional 'column dimension' argument */
	if ( nrhs > 1 ) {
		if ( ! mxIsNumeric(tmp = prhs[1]) || 1 != mxGetM(tmp) || 1 != mxGetN(tmp) ) {
			lcaSetError(&theErr, EZCA_INVALIDARG, "2nd argument must be a numeric scalar");
			goto cleanup;
		}
		n = (int)mxGetScalar( tmp );
	}

	/* check for an optional data type argument */
	if ( nrhs > 2 ) {
		if ( ezcaInvalid == (type = marg2ezcaType( prhs[2], &theErr )) ) {
			goto cleanup;
		}
	}

	if ( buildPVs(prhs[0], &pvs, &theErr) )
		goto cleanup;

    if ( 0 == multi_ezca_set_mon( pvs.names, pvs.m, type, n, &theErr ) ) {
		nlhs = 0;
	}

cleanup:
	releasePVs(&pvs);
	/* do this LAST (in case mexErrMsgTxt is called) */
	ERR_CHECK(nlhs, plhs, &theErr);
}
