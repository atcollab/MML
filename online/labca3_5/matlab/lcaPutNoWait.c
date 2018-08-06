/* $Id: lcaPutNoWait.c,v 1.5 2007/06/04 18:56:18 guest Exp $ */

/* matlab wrapper for ezcaPutOldCa */

/* Author: Till Straumann <strauman@slac.stanford.edu>, 2002-2003  */

/* LICENSE: EPICS open license, see ../LICENSE file */

#include "mglue.h"

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
LcaError theErr;
int      onlhs = nlhs;

	lcaErrorInit(&theErr);

	LHSCHECK(nlhs, plhs);
	if ( 0 == onlhs )
		nlhs = 0;

	nlhs = theLcaPutMexFunction(nlhs,plhs,nrhs,prhs,0,&theErr);
	ERR_CHECK(nlhs, plhs, &theErr);
}
