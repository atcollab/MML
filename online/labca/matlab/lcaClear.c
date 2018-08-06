/* $Id: lcaClear.c,v 1.6 2007/05/31 21:16:44 till Exp $ */

/* matlab wrapper for ezcaClearChannel / ezcaPurge */

/* Author: Till Straumann <strauman@slac.stanford.edu>, 2002-2003  */

/* LICENSE: EPICS open license, see ../LICENSE file */

#include "mglue.h"
#include "multiEzca.h"

#include <cadef.h>
#include <ezca.h>

#include <ctype.h>

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
PVs     pvs = { {0} };
char	**s;
int		m = -1;
LcaError theErr;

	lcaErrorInit(&theErr);

	LHSCHECK(nlhs, plhs);

	if ( 1 < nlhs ) {
		lcaSetError(&theErr, EZCA_INVALIDARG, "Too many lhs args");
		goto cleanup;
	}

	if ( 1 < nrhs ) {
		lcaSetError(&theErr, EZCA_INVALIDARG, "Too many rhs args");
		goto cleanup;
	}

	if ( nrhs > 0 && buildPVs(prhs[0],&pvs, &theErr) )
		goto cleanup;

	if ( (s = pvs.names) )
		m = pvs.m;

#if 0 /* lcaClear('') or lcaClear({''}) do not pass buildPVs() ;=( */
	if ( 1 == m  && 0 == *s[0] ) {
		/* special case: lcaClear('') clears only disconnected channels */
		s = 0;
		m = 0;
	}
#endif

    if ( multi_ezca_clear_channels( s, m, &theErr ) )
		goto cleanup;

	nlhs = 0;

cleanup:
	releasePVs(&pvs);
	/* do this LAST (in case mexErrMsgTxt is called) */
	ERR_CHECK(nlhs, plhs, &theErr);
}
