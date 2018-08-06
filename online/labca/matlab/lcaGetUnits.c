/* $Id: lcaGetUnits.c,v 1.2 2007/10/14 03:28:04 strauman Exp $ */

/* matlab wrapper for ezcaGetUnits */

/* Author: Till Straumann <strauman@slac.stanford.edu>, 2002-2007  */

/* LICENSE: EPICS open license, see ../LICENSE file */

#include "mglue.h"
#include "multiEzca.h"

#include <cadef.h>
#include <ezca.h>

#include <ctype.h>

typedef char units_string[EZCA_UNITS_SIZE];

#ifdef __GNUC__
#define MAY_ALIAS __attribute__((may_alias))
#else
#define MAY_ALIAS
#endif

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
PVs     pvs = { {0} };
int     i,j;
LcaError theErr;
MultiArgRec	args[1];
units_string *strbuf MAY_ALIAS = 0;
mxArray *tmp;

	lcaErrorInit(&theErr);

	LHSCHECK(nlhs, plhs);

	if ( nlhs > 1 ) {
		lcaSetError(&theErr, EZCA_INVALIDARG, "Too many output args");
		goto cleanup;
	}

	if ( nrhs < 1 || nrhs > 1 ) {
		lcaSetError(&theErr, EZCA_INVALIDARG, "Expected 1 rhs argument");
		goto cleanup;
	}

	if ( buildPVs(prhs[0], &pvs, &theErr) )
		goto cleanup;

	MSetArg(args[0], sizeof(units_string), 0, &strbuf);

	if ( !multi_ezca_get_misc(pvs.names, pvs.m, (MultiEzcaFunc)ezcaGetUnits, NumberOf(args), args, &theErr) )
		goto cleanup;

	/* convert string array to a matlab cell array of matlab strings */
	if ( !(plhs[0] = mxCreateCellMatrix(pvs.m, 1)) ) {
		lcaSetError(&theErr, EZCA_FAILEDMALLOC, "Not enough memory");
		goto cleanup;
	}
	for ( i = 0; i < pvs.m; i++ ) {
		if ( !(tmp = mxCreateString((char*)&strbuf[i])) ) {
			for ( j=0; j<i; j++ ) {
				mxDestroyArray(mxGetCell(plhs[0],i));
			}
			mxDestroyArray(plhs[0]);
			plhs[0] = 0;
			lcaSetError(&theErr, EZCA_FAILEDMALLOC, "Not enough memory");
			goto cleanup;
		}
		mxSetCell(plhs[0], i, (mxArray*)tmp);
	}

	nlhs = 0;

cleanup:
	if ( strbuf )
		lcaFree( strbuf );
	releasePVs(&pvs);
	/* do this LAST (in case mexErrMsgTxt is called) */
	ERR_CHECK(nlhs, plhs, &theErr);
}
