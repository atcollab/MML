/* $Id: lcaGetEnumStrings.c,v 1.1 2015/06/05 01:50:15 strauman Exp $ */

/* matlab wrapper for ezcaGetEnumStrings */

/* Author: Till Straumann <strauman@slac.stanford.edu>, 2002-2007  */

/* LICENSE: EPICS open license, see ../LICENSE file */

#include "mglue.h"
#include "multiEzca.h"

#include <cadef.h>
#include <ezca.h>

#include <ctype.h>

typedef char enum_states[EZCA_ENUM_STATES][EZCA_ENUM_STRING_SIZE];

#ifdef __GNUC__
#define MAY_ALIAS __attribute__((may_alias))
#else
#define MAY_ALIAS
#endif

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
PVs     pvs = { {0} };
int     i,j,ij,n;
LcaError theErr;
MultiArgRec	args[1];
enum_states *strbuf MAY_ALIAS = 0;
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

	MSetArg(args[0], sizeof(*strbuf), 0, &strbuf);

	if ( !multi_ezca_get_misc(pvs.names, pvs.m, (MultiEzcaFunc)ezcaGetEnumStrings, NumberOf(args), args, &theErr) )
		goto cleanup;

	n = EZCA_ENUM_STATES;

	/* convert string array to a matlab cell array of matlab strings */
	if ( !(plhs[0] = mxCreateCellMatrix(pvs.m, n)) ) {
		lcaSetError(&theErr, EZCA_FAILEDMALLOC, "Not enough memory");
		goto cleanup;
	}
	ij = 0;
	for ( j = 0; j < n; j++ ) {
		for ( i = 0; i < pvs.m; i++ ) {
			if ( !(tmp = mxCreateString(strbuf[i][j])) ) {
				for ( j=0; j<ij; j++ ) {
					mxDestroyArray(mxGetCell(plhs[0],ij));
				}
				mxDestroyArray(plhs[0]);
				plhs[0] = 0;
				lcaSetError(&theErr, EZCA_FAILEDMALLOC, "Not enough memory");
				goto cleanup;
			}
			mxSetCell(plhs[0], ij, (mxArray*)tmp);
			ij++;
		}
	}

	nlhs = 0;

cleanup:
	if ( strbuf )
		lcaFree( strbuf );
	releasePVs(&pvs);
	/* do this LAST (in case mexErrMsgTxt is called) */
	ERR_CHECK(nlhs, plhs, &theErr);
}
