/* $Id: lcaGetPrecision.c,v 1.1 2007/06/04 18:56:18 guest Exp $ */

/* matlab wrapper for ezcaGetPrecision */

/* Author: Till Straumann <strauman@slac.stanford.edu>, 2002-2007  */

/* LICENSE: EPICS open license, see ../LICENSE file */

#include "mglue.h"
#include "multiEzca.h"

#include <cadef.h>
#include <ezca.h>

#include <ctype.h>

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
int			i;
PVs			pvs = { {0} };
MultiArgRec	args[1];
mxArray		*res[1] = {0};
LcaError	theErr;

	lcaErrorInit(&theErr);

	LHSCHECK(nlhs, plhs);

	if ( nlhs > NumberOf(args) ) {
		lcaSetError(&theErr, EZCA_INVALIDARG, "Too many output args");
		goto cleanup;
	}

	if ( nrhs != 1 ) {
		lcaSetError(&theErr, EZCA_INVALIDARG, "Expected 1 rhs argument");
		goto cleanup;
	}

	if ( buildPVs(prhs[0], &pvs, &theErr) )
		goto cleanup;

	/* alloc matrices for status/severity; multi_ezca_get_misc can directly
	 * store results there...
	 */
	if ( !(res[0]=mxCreateNumericMatrix(pvs.m, 1, mxINT16_CLASS, mxREAL)) ) {
		lcaSetError(&theErr, EZCA_FAILEDMALLOC, "Not enough memory");
		goto cleanup;
	}

	MSetArg( args[0], sizeof(short),  mxGetData(res[0]), 0);	/* precision    */

    if ( !multi_ezca_get_misc( pvs.names, pvs.m, (MultiEzcaFunc)ezcaGetPrecision, NumberOf(args), args, &theErr) ) {
		goto cleanup;
	}

	/* set severity in result array */
	plhs[0] = res[0]; res[0] = 0;

	nlhs = 0;

cleanup:
	for ( i=0; i<NumberOf(res); i++ ) {
		if ( res[i] )
			mxDestroyArray( res[i] );
	}
	releasePVs(&pvs);
	/* do this LAST (in case mexErrMsgTxt is called) */
	ERR_CHECK(nlhs, plhs, &theErr);
}
