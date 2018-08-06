/* $Id: lcaGet.c,v 1.12 2007/10/14 03:28:04 strauman Exp $ */

/* matlab wrapper for ezcaGet */

/* Author: Till Straumann <strauman@slac.stanford.edu>, 2002-2003  */

/* LICENSE: EPICS open license, see ../LICENSE file */

#include "mglue.h"
#include "multiEzca.h"

#include <cadef.h>
#include <ezca.h>

#include <ctype.h>

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
void	*pres = 0;
int     i,n = 0;
const mxArray *tmp;
mxArray *clean0 = 0, *clean1 = 0;
PVs     pvs = { {0} };
char	type = ezcaNative;
TS_STAMP *ts = 0;
LcaError theErr;

	lcaErrorInit(&theErr);

	LHSCHECK(nlhs, plhs);

	if ( nlhs > 2 ) {
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

    multi_ezca_get( pvs.names, &type, &pres, pvs.m, &n, &ts, &theErr );

	if ( !pres )
		goto cleanup;

	/* if pres != NULL, we have a valid reply... */
	if ( ezcaString == type ) {
		/* convert string array to a matlab cell array of matlab strings */
		if ( !(clean0 = plhs[0] = mxCreateCellMatrix(pvs.m, n)) ) {
			lcaSetError(&theErr, EZCA_FAILEDMALLOC, "Not enough memory");
			goto cleanup;
		}
		for ( i = 0; i < pvs.m * n; i++ ) {
			if ( !(tmp = mxCreateString(((const char**)pres)[i])) ) {
				lcaSetError(&theErr, EZCA_FAILEDMALLOC, "Not enough memory");
				goto cleanup;
			}
			mxSetCell(plhs[0], i, (mxArray*)tmp);
		}
	} else {
		/* create a double matrix and copy (we don't know the dimension
		 * prior to calling multi_ezca_get() - otherwise we could directly
		 * pass the mxGetPr() handle to multi_ezca_get()...
		 */

		if ( !(clean0 = plhs[0] = mxCreateDoubleMatrix(pvs.m,n,mxREAL)) ) {
			lcaSetError(&theErr, EZCA_FAILEDMALLOC, "Not enough memory");
			goto cleanup;
		}
		memcpy(mxGetPr(plhs[0]), pres, sizeof(double) * pvs.m * n);
	}

	/* If requested, generate the timestamp matrix */
	if ( nlhs > 1 ) {
		/* give them the time stamps */
		if ( !(clean1 = plhs[1] = mxCreateDoubleMatrix(pvs.m,1,mxCOMPLEX)) ) {
			lcaSetError(&theErr, EZCA_FAILEDMALLOC, "Not enough memory");
			goto cleanup;
		}
		multi_ezca_ts_cvt( pvs.m, ts, mxGetPr(plhs[1]), mxGetPi(plhs[1]) );
	}
	clean0 = clean1 = 0;
	nlhs = 0;

cleanup:
	if ( clean0 ) {
		mxDestroyArray( clean0 );
		plhs[0] = 0;
	}
	if ( clean1 ) {
		mxDestroyArray( clean1 );
		plhs[1] = 0;
	}
	if ( ezcaString == type && pres ) {
		/* free string elements also */
		for ( i=0; i<pvs.m*n; i++ ) {
			lcaFree( ((char**)pres)[i] );
		}
	}
	lcaFree(pres);
	lcaFree(ts);
	releasePVs(&pvs);
	/* do this LAST (in case mexErrMsgTxt is called) */
	ERR_CHECK(nlhs, plhs, &theErr);
}
