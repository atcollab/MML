/* $Id: mglue.c,v 1.24 2007/10/14 03:28:04 strauman Exp $ */

/* MATLAB - EZCA interface glue utilites */

/* Author: Till Straumann <strauman@slac.stanford.edu>, 2003 */

/* LICENSE: EPICS open license, see ../LICENSE file */

#include <cadef.h>
#include <ezca.h>

#define epicsExportSharedSymbols
#include "shareLib.h"
#include "multiEzca.h"
#include "mglue.h"
#include "lcaError.h"

void epicsShareAPI
releasePVs(PVs *pvs)
{
int i;
	if ( pvs && pvs->names ) {
		for ( i=0; i<pvs->m; i++ ) {
			lcaFree(pvs->names[i]);
		}
		lcaFree( pvs->names );
		multi_ezca_ctrlC_epilogue( &pvs->ctrlc );	
	}
}

int epicsShareAPI
buildPVs(const mxArray *pin, PVs *pvs, LcaError *pe)
{
char	**mem = 0;
int     i,m,buflen;
const mxArray *tmp;
int	rval = -1;

	if ( !pvs )
		return -1;

	pvs->names = 0;
	pvs->m     = 0;

	if ( !pin )
		return -1;

	if ( mxIsCell(pin) &&  1 != mxGetN(pin) ) {
			lcaSetError(pe, EZCA_INVALIDARG, "Need a column vector of PV names\n");
			goto cleanup;
	}

	m = mxIsCell(pin) ? mxGetM(pin) : 1;

	if ( (! mxIsCell(pin) && ! mxIsChar(pin)) || m < 1 ) {
		lcaSetError(pe, EZCA_INVALIDARG, "Need a (column) cell array argument with PV names");
		/* GENERAL CLEANUP NOTE: as far as I understand, this is not necessary:
		 *                       in mex files, garbage is automatically collected;
		 *                       explicit cleanup works in standalong apps also, however.
		 */
		goto cleanup;
	}

	if ( ! (mem = lcaCalloc(m, sizeof(*mem))) ) {
		lcaSetError(pe, EZCA_FAILEDMALLOC, "No Memory\n");
		goto cleanup;
	}


	for ( i=buflen=0; i<m; i++ ) {
		tmp = mxIsCell(pin) ? mxGetCell(pin, i) : pin;		
		if ( !tmp || !mxIsChar(tmp) || 1 != mxGetM(tmp) ) {
			lcaSetError(pe, EZCA_INVALIDARG, "Not an vector of strings??");
			goto cleanup;
		}
		buflen = mxGetN(tmp) * sizeof(mxChar) + 1;
		if ( !(mem[i] = lcaMalloc(buflen)) ) {
			lcaSetError(pe, EZCA_FAILEDMALLOC, "No Memory\n");
			goto cleanup;
		}
		if ( mxGetString(tmp, mem[i], buflen) ) {
			lcaSetError(pe, EZCA_INVALIDARG, "not a PV name?");
			goto cleanup;
		}
	}

	pvs->names = mem;
	pvs->m     = m;
	rval       = 0;

	multi_ezca_ctrlC_prologue(&pvs->ctrlc);

	pvs        = 0;

cleanup:
	releasePVs(pvs);
	return rval;	
}

const char * epicsShareAPI
lcaErrorIdGet(int err)
{
	switch ( err ) {
		default: break;
		/* in case of EZCA_OK we really shouldn't get here... */
		case EZCA_OK:               return "labca:unexpectedOK";
		case EZCA_INVALIDARG:       return "labca:invalidArg";
		case EZCA_FAILEDMALLOC:     return "labca:noMemory";
		case EZCA_CAFAILURE:        return "labca:channelAccessFail";
		case EZCA_UDFREQ:           return "labca:udfCaReq";
		case EZCA_NOTCONNECTED:     return "labca:notConnected";
		case EZCA_NOTIMELYRESPONSE: return "labca:timedOut";
		case EZCA_INGROUP:          return "labca:inGroup";
		case EZCA_NOTINGROUP:       return "labca:notInGroup";

		case EZCA_NOMONITOR:        return "labca:noMonitor";
		case EZCA_NOCHANNEL:        return "labca:noChannel";
		case EZCA_ABORTED:          return "labca:usrAbort";
	}
	return "labca:unkownError";
}

char epicsShareAPI
marg2ezcaType(const mxArray *typearg, LcaError *pe)
{
char typestr[2] = { 0 };

	if ( ! mxIsChar(typearg) ) {
		lcaSetError(pe, EZCA_INVALIDARG, "(optional) type argument must be a string");
	} else {
		mxGetString( typearg, typestr, sizeof(typestr) );
		switch ( toupper(typestr[0]) ) {
			default:
 				break;

			case 'N':	return ezcaNative;
			case 'B':	return ezcaByte;
			case 'S':	return ezcaShort;
			case 'I':
			case 'L':	return ezcaLong;
			case 'F':	return ezcaFloat;
			case 'D':	return ezcaDouble;
			case 'C':	return ezcaString;
		}
	}
	lcaSetError(pe, EZCA_INVALIDARG, "argument specifies an invalid data type");
	return ezcaInvalid;
}

int epicsShareAPI
flagError(int nlhs, mxArray *plhs[])
{
int i;
	if ( nlhs ) {
		for ( i=0; i<nlhs; i++ ) {
			mxDestroyArray(plhs[i]);
			/* hope this doesn't fail... */
			plhs[i] = 0;
		}
		return -1;
	}
	return 0;
}

int epicsShareAPI
theLcaPutMexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[], int doWait, LcaError *pe)
{
char	**pstr = 0;
int     i, m = 0, n = 0;
int		rval;
const	mxArray *tmp, *strval;
PVs     pvs = { {0}, };
char	type = ezcaNative;
mxArray *dummy = 0;
	
#ifdef LCAPUT_RETURNS_VALUE
	if ( nlhs == 0 )
		nlhs = 1;

	if ( nlhs > 1 ) {
		lcaSetError(pe, EZCA_INVALIDARG, "Too many output args");
		goto cleanup;
	}
#else
	if ( nlhs ) {
		lcaSetError(pe, EZCA_INVALIDARG, "Too many output args");
		goto cleanup;
	}
	nlhs = -1;
#endif

	if ( nrhs < 2 || nrhs > 3 ) {
		lcaSetError(pe, EZCA_INVALIDARG, "Expected 2..3 rhs argument");
		goto cleanup;
	}

	n = mxGetN( tmp = prhs[1] );
    m = mxGetM( tmp );

	if ( mxIsChar( tmp ) ) {
		/* a single string; create a dummy cell matrix */
		m = n = 1;
		if ( !(dummy = mxCreateCellMatrix( m, n )) ) {
			lcaSetError(pe, EZCA_FAILEDMALLOC, "Not Enough Memory");
			goto cleanup;
		}
		mxSetCell(dummy, 0, (mxArray*)mxDuplicateArray((mxArray*)tmp));
		tmp = dummy;
	}

	if ( mxIsCell( tmp ) ) {
		if ( !(pstr = lcaCalloc( m * n, sizeof(*pstr) )) ) {
			lcaSetError(pe, EZCA_FAILEDMALLOC, "Not Enough Memory");
			goto cleanup;
		}
		for ( i = 0; i < m * n; i++ ) {
			int len;
			if ( !mxIsChar( (strval = mxGetCell(tmp, i)) ) || 1 != mxGetM( strval ) ) {
				lcaSetError(pe, EZCA_INVALIDARG, "Value argument must be a cell matrix of strings");
				goto cleanup;
			}
			len = mxGetN(strval) * sizeof(mxChar) + 1;
			if ( !(pstr[i] = lcaMalloc(len)) ) {
				lcaSetError(pe, EZCA_FAILEDMALLOC, "Not Enough Memory");
				goto cleanup;
			}
			if ( mxGetString(strval, pstr[i], len) ) {
				lcaSetError(pe, EZCA_INVALIDARG, "Value still not a string (after all those checks) ???");
				goto cleanup;
			}
		}
		type = ezcaString;
	} else if ( ! mxIsDouble(tmp) ) {
			lcaSetError(pe, EZCA_INVALIDARG, "2nd argument must be a double matrix");
			goto cleanup;
	} else {
		/* is a DOUBLE matrix */
	}

	if ( nrhs > 2 ) {
		char tmptype;
		if ( ezcaInvalid == (tmptype = marg2ezcaType(prhs[2], pe)) ) {
			goto cleanup;
		}
		if ( (ezcaString == type) != (ezcaString == tmptype) ) {
			lcaSetError(pe, EZCA_UDFREQ, "string value type conversion not implemented, sorry");
			goto cleanup;
		}
		type = tmptype;
	}

	if ( buildPVs(prhs[0], &pvs, pe) )
		goto cleanup;

	assert( (pstr != 0) == (ezcaString ==  type) );

	rval = multi_ezca_put( pvs.names, pvs.m, type, (pstr ? (void*)pstr : (void*)mxGetPr(prhs[1])), m, n, doWait, pe);

	if ( rval > 0 ) {
#ifdef LCAPUT_RETURNS_VALUE
		if ( !(plhs[0] = mxCreateDoubleMatrix(1,1,mxREAL)) ) {
			lcaSetError(pe, EZCA_FAILEDMALLOC, "No Memory\n");
			goto cleanup;
		}
		*mxGetPr(plhs[0]) = (double)rval;
#endif
		nlhs = 0;
	}

cleanup:
	if ( pstr ) {
		/* free string elements also */
		for ( i=0; i<m*n; i++ ) {
			lcaFree( pstr[i] );
		}
		lcaFree( pstr );
	}
	if ( dummy ) {
		mxDestroyArray( dummy );
	}
	releasePVs(&pvs);
	return nlhs;
}
