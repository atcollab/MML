/* $Id: ezcaSciCint.c,v 1.27 2007/10/14 03:28:04 strauman Exp $ */

/* SCILAB C-interface to ezca / multiEzca */
#include <mex.h>
#include "stack-c.h"
#include <string.h>
#include <cadef.h>
#include <ezca.h>

#include <sciclean.h>

#define epicsExportSharedSymbols
#include <shareLib.h>

#include <multiEzca.h>
#include <multiEzcaCtrlC.h>

epicsShareFunc int epicsShareAPI C2F(ezca)();

/* Note about cleanup and errors:
 *
 * A lot of scilab macros (e.g., CreateVar()) expand
 * to a check and return immediately from the current
 * subroutine
 *
 *    if ( !C2F(createvar)() ) return 0;
 *
 * so that we don't get a chance to cleanup resources
 * that we allocate.
 *
 * We employ the 'sciclean' facility to work around
 * this problem.
 */

/* Define a macro to cleanup memory obtained
 * via 'lcaMalloc' & friends.
 */

#define LCACLEAN(var) sciclean_push(sciclean, (var), lcaFree)
static void
lca_free_strings(void *x)
{
char **strs = x;
	if ( strs ) {
		while ( *strs ) {
			lcaFree(*strs);
			strs++;
		}
		lcaFree(x);
	}
}
#define LCACLEAN_SVAR(var) sciclean_push(sciclean, (var), lca_free_strings)

/* We get a lot of 'type-punned' pointer warnings, mostly
 * because the scilab header doesn't properly declare things
 * (using integer* or double* where a void* would be more
 * appropriate). In fact, we can probably expect that the
 * pointers in question are eventually accessing data objects
 * of the correct type.
 * Nevertheless, in order to silence warnings (and avoid possible
 * problems) we declare all such pointers with the attribute
 * 'may_alias' [gnu only].
 */
#ifdef __GNUC__
#define MAY_ALIAS __attribute__((may_alias))
#else
#define MAY_ALIAS
#endif

#if 0
#define getRhsVar(n,ct,mx,nx,lx) \
	( C2F(getrhsvar)((c_local=n,&c_local),ct,mx,nx,(integer *) lx,1L) )
#define checkRhs(minrhs,maxrhs)  \
	( C2F(checkrhs)(fname,(c_local = minrhs,&c_local),(c1_local=maxrhs,&c1_local),\
              strlen(fname)) )
#define checkLhs(minlhs,maxlhs)  \
	( C2F(checklhs)(fname,(c_local = minlhs,&c_local),(c1_local=maxlhs,&c1_local),\
              strlen(fname)) )
#define checkRow(pos,m,n) \
	( check_row(pos,m,n) )
#define checkColumn(pos,m,n) \
	( check_column(pos,m,n) )
#endif

/* there's a typo in the scilab header :-( */
#define check_column check_col

/* convert a short array into an int array */
static void
s2iInPlace(void *buf, int m)
{
int i;
	for (i = m-1; i>=0; i--) {
		((int*)buf)[i] = (int) ((short*)buf)[i];
	}
}

static int
arg2ezcaType(char *pt, int idx, LcaError *pe)
{
int m,n,s;

	if ( Rhs < idx )
		return 0;

	GetRhsVar(idx, "c", &m, &n, &s);
	CheckColumn(idx, m, n);

	switch ( toupper( *(cstk(s)) ) ) {
			case 'D': *pt = ezcaDouble; break;
			case 'F': *pt = ezcaFloat;  break;
			case 'L': *pt = ezcaLong;   break;
			case 'S': *pt = ezcaShort;  break;
			case 'B': *pt = ezcaByte;   break;
			case 'C': *pt = ezcaString; break;
			case 'N': *pt = ezcaNative; break;
                                                                                            
			default:
					lcaSetError(pe, EZCA_INVALIDARG, "Invalid type - must be 'byte', 'short', 'long', 'float', 'double' or 'char'");
			return 0;
	}

	return 1;
}

static void errRaiseClean(void *obj)
{
LcaError *theErr = obj;
	LCA_RAISE_ERROR(theErr);
	lcaFree( theErr );
}

static LcaError *errCreate(Sciclean sciclean)
{
LcaError *theErr = lcaMalloc(sizeof(*theErr));
	lcaErrorInit(theErr);
	sciclean_push(sciclean, theErr, errRaiseClean);
	return theErr;
}

static int intsezcaGet(char *fname, int namlen, Sciclean sciclean)
{
int mpvs, mtmp, ntmp, itmp, jtmp, status;
char     **pvs MAY_ALIAS = 0;
void      *buf MAY_ALIAS = 0;
int	      n              = 0;
char      type           = ezcaNative;
TS_STAMP  *ts            = 0;
LcaError  *theErr        = errCreate(sciclean);

	CheckRhs(1,3);
	CheckLhs(1,2);

 	GetRhsVar(1,"S",&mpvs,&ntmp,&pvs);
	SCICLEAN_SVAR(pvs);
 	CheckColumn(1,mpvs,ntmp);

	if ( Rhs > 1 ) {
		GetRhsVar(2, "i", &mtmp, &ntmp, &itmp);
		CheckScalar(2, mtmp, ntmp);
		n = *istk(itmp);
		if ( Rhs > 2 && !arg2ezcaType(&type,3, theErr) )
			goto bail;
	}

	ntmp = 1;
	CreateCVar(Rhs + 1,"d",&ntmp,&mpvs,&ntmp,&itmp,&jtmp);

	/* we can't preallocate the result matrix -- n is unknown at this point */
	status = multi_ezca_get( pvs, &type, &buf, mpvs, &n, &ts, theErr );

	/* register cleanups for memory allocated by multi_ezca_get */
	LCACLEAN(ts);
	if ( ezcaString == type ) {
		LCACLEAN_SVAR(buf);
	} else {
		LCACLEAN(buf);
	}

	if ( !status ) {
		for ( itmp = 1; itmp <= Lhs; itmp++ )
			LhsVar(itmp) = 0; 
		goto bail;
	}

	/* NOTE: if CreateVarxxx fails, there is a memory leak
	 *       (macro returns without chance to clean up)
	 */
	if ( Lhs >= 1 ) {
		if ( ezcaString == type ) {
			CreateVarFromPtr(Rhs + 2, "S", &mpvs, &n, buf);
		} else {
			CreateVarFromPtr(Rhs + 2, "d", &mpvs, &n, &buf);
		}
		LhsVar(1)=Rhs + 2;

		if ( Lhs >= 2 ) {
			multi_ezca_ts_cvt( mpvs, ts, stk(itmp), stk(jtmp) );
			LhsVar(2)=Rhs + 1;
		}
	}

bail:

	return 0;
}

static int dosezcaPut(char *fname, int doWait, Sciclean sciclean)
{
int       mpvs, mval, ntmp, n, i;
void     *buf MAY_ALIAS;
char    **pvs MAY_ALIAS;
char      type   = ezcaNative;
LcaError *theErr = errCreate(sciclean);

	CheckRhs(2,3);
	CheckLhs(1,1);

	GetRhsVar(1,"S",&mpvs,&ntmp,&pvs);
	SCICLEAN_SVAR(pvs);
	CheckColumn(1,mpvs,ntmp);

	if ( 10 == VarType(2) ) {
		GetRhsVar(2,"S",&mval,&n,&buf);
		SCICLEAN_SVAR(buf);
		type = ezcaString;
	} else {
		GetRhsVar(2,"d",&mval,&n,&i);
		buf = stk(i);
	}

	if ( Rhs > 2 ) {
		char t;
		if ( !arg2ezcaType( &t, 3, theErr ) )
			goto bail;
		if ( (ezcaString == type) != (ezcaString == t) )  {
			lcaSetError(theErr, EZCA_INVALIDARG, "string value type conversion not implemented, sorry");
			goto bail;
		}
		type = t;
	}

#ifdef LCAPUT_RETURNS_VALUE
	{ int one=1;
	CreateVar(4,"r",&one,&one,&i);
	}
	LhsVar(1) = 4;
	/* default value to optional argument type */
	/* cross variable size checking */
	*sstk(i) =
#endif
		multi_ezca_put(pvs, mpvs, type, buf, mval, n, doWait, theErr);

bail:
	return 0;
}

static int intsezcaPutNoWait(char *fname, int namlen, Sciclean sciclean)
{
	return dosezcaPut(fname, 0, sciclean);
}

static int intsezcaPut(char *fname, int namlen, Sciclean sciclean)
{
	return dosezcaPut(fname, 1, sciclean);
}


static int intsezcaGetNelem(char *fname, int namlen, Sciclean sciclean)
{
int       m,n,i;
char    **pvs MAY_ALIAS;
LcaError *theErr = errCreate(sciclean);

	CheckRhs(1,1);
	CheckLhs(1,1);

	GetRhsVar(1,"S",&m,&n,&pvs);
	SCICLEAN_SVAR(pvs);
	CheckColumn(1,m,n);

	CreateVar(2,"i",&m,&n,&i);

	if ( !multi_ezca_get_nelem(pvs, m, istk(i), theErr) )
 		LhsVar(1)=2;

 	return 0;
}

static int intsezcaGetControlLimits(char *fname, int namlen, Sciclean sciclean)
{
int m,n,d1,d2;
char **pvs MAY_ALIAS;
MultiArgRec args[2];
LcaError *theErr = errCreate(sciclean);

	CheckRhs(1,1);
	CheckLhs(1,2);

	GetRhsVar(1,"S",&m,&n,&pvs);
	SCICLEAN_SVAR(pvs);
	CheckColumn(1,m,n);

	CreateVar(2, "d", &m, &n, &d1);
	CreateVar(3, "d", &m, &n, &d2);

	MSetArg(args[0], sizeof(double), stk(d1), 0); 
	MSetArg(args[1], sizeof(double), stk(d2), 0); 

	if ( multi_ezca_get_misc(pvs, m, (MultiEzcaFunc)ezcaGetControlLimits, NumberOf(args), args, theErr) ) {
		for ( n=1; n<=Lhs; n++ )
			LhsVar(n) = Rhs + n;
	}
	
	return 0;
}

static int intsezcaGetGraphicLimits(char *fname, int namlen, Sciclean sciclean)
{
int m,n,d1,d2;
char **pvs MAY_ALIAS;
MultiArgRec args[2];
LcaError *theErr = errCreate(sciclean);

	CheckRhs(1,1);
	CheckLhs(1,2);

	GetRhsVar(1,"S",&m,&n,&pvs);
	SCICLEAN_SVAR(pvs);
	CheckColumn(1,m,n);

	CreateVar(2, "d", &m, &n, &d1);
	CreateVar(3, "d", &m, &n, &d2);

	MSetArg(args[0], sizeof(double), stk(d1), 0); 
	MSetArg(args[1], sizeof(double), stk(d2), 0); 

	if ( multi_ezca_get_misc(pvs, m, (MultiEzcaFunc)ezcaGetGraphicLimits, NumberOf(args), args, theErr) ) {
		for ( n=1; n<=Lhs; n++ )
			LhsVar(n) = Rhs + n;
	}
	
	return 0;
}

static int intsezcaGetStatus(char *fname, int namlen, Sciclean sciclean)
{
TS_STAMP *ts MAY_ALIAS;
int      hasImag, m,n,i,j, status;
char     **pvs MAY_ALIAS;
LcaError *theErr = errCreate(sciclean);

MultiArgRec args[3];

	CheckRhs(1,1);
	CheckLhs(1,3);
	GetRhsVar(1,"S",&m,&n,&pvs);
	SCICLEAN_SVAR(pvs);
	CheckColumn(1,m,n);

	MSetArg(args[0], sizeof(TS_STAMP), 0,       &ts); /* timestamp */

 	CreateVar(2,"i",&m,&n,&i);
	MSetArg(args[1], sizeof(short),    istk(i), 0  ); /* status    */

 	CreateVar(3,"i",&m,&n,&i);
	MSetArg(args[2], sizeof(short),    istk(i), 0  ); /* severity  */

	hasImag = 1;
 	CreateCVar(4,"d",&hasImag,&m,&n,&i,&j);

	status = multi_ezca_get_misc(pvs, m, (MultiEzcaFunc)ezcaGetStatus, NumberOf(args), args, theErr);

	/* If ts was created then register a cleanup */
	LCACLEAN(ts);

	if ( status ) {

		s2iInPlace(args[2].buf, m);
 		LhsVar(1)=3;

		if ( Lhs >= 2 ) {
			s2iInPlace(args[1].buf, m);
 			LhsVar(2)=2;
			
			if ( Lhs >= 3 ) {
				LhsVar(3)=4;
				multi_ezca_ts_cvt( m, ts, stk(i), stk(j) );
			}
		}
	}

 	return 0;
}

static int intsezcaGetPrecision(char *fname, int namlen, Sciclean sciclean)
{
int m,n,i;
char  **pvs MAY_ALIAS;
MultiArgRec	args[1];
LcaError *theErr = errCreate(sciclean);

	CheckRhs(1,1);
	CheckLhs(1,1);
	GetRhsVar(1,"S",&m,&n,&pvs);
	SCICLEAN_SVAR(pvs);
	CheckColumn(1,m,n);

	CreateVar(2,"i",&m,&n,&i);

	MSetArg(args[0], sizeof(short), istk(i), 0);

	if ( multi_ezca_get_misc(pvs, m, (MultiEzcaFunc)ezcaGetPrecision, NumberOf(args), args, theErr) ) {
		s2iInPlace(istk(i),m);
		LhsVar(1) = 2;
	}
 	return 0;
}

typedef char units_string[EZCA_UNITS_SIZE];

static int intsezcaGetUnits(char *fname, int namlen, Sciclean sciclean)
{
int  m,n,i,status;
char **pvs MAY_ALIAS,**tmp;
units_string *strbuf MAY_ALIAS = 0;
MultiArgRec  args[1];
LcaError *theErr = errCreate(sciclean);

	CheckRhs(1,1);
	CheckLhs(1,1);
	GetRhsVar(1,"S",&m,&n,&pvs);
	SCICLEAN_SVAR(pvs);
	CheckColumn(1,m,n);

	MSetArg(args[0], sizeof(units_string), 0, &strbuf);

	status = multi_ezca_get_misc(pvs, m, (MultiEzcaFunc)ezcaGetUnits, NumberOf(args), args, theErr);

	/* if strbuf was created register a cleanup */
	LCACLEAN(strbuf);

	if ( status && 
		 /* scilab expects NULL terminated char** list */
		 (tmp = lcaMalloc(sizeof(char*) * (m+1))) ) {
		for ( i=0; i<m; i++ ) {
			tmp[i] = strbuf[i];
		}
		tmp[m] = 0;
		LCACLEAN(tmp); /* register cleanup; CreateVarFromPtr may fail and execute 'return 0' */
 		CreateVarFromPtr(2, "S",&m,&n,tmp);
 		LhsVar(1)= 2;
	}

 	return 0;
}


static int intsezcaGetRetryCount(char *fname, int namlen, Sciclean sciclean)
{
int m=1,i;

	CheckRhs(0,0);
	CheckLhs(1,1);
	CreateVar(1,"i",&m,&m,&i);
	*istk(i) = ezcaGetRetryCount();
	LhsVar(1)= 1;
	return 0;
}

static int intsezcaSetRetryCount(char *fname, int namlen, Sciclean sciclean)
{
int m,n,i;
LcaError *theErr = errCreate(sciclean);

	CheckRhs(1,1);
	CheckLhs(1,1);
	GetRhsVar(1,"i",&m,&n,&i);
	CheckScalar(1,m,n);

	if ( (int)*istk(i) < 1 ) {
		lcaSetError(theErr, EZCA_INVALIDARG, "lcaSetRetryCount(): arg >= 1 expected");
		goto cleanup;
	}
	ezcaSetRetryCount(*istk(i));

cleanup:
	LhsVar(1)=0;
	return 0;
}

static int intsezcaGetTimeout(char *fname, int namlen, Sciclean sciclean)
{
int m=1,i;

	CheckRhs(0,0);
	CheckLhs(1,1);
	CreateVar(1,"r",&m,&m,&i);/* named: res */
	*sstk(i) = ezcaGetTimeout();
	LhsVar(1)= 1;
	return 0;
}

static int intsezcaSetTimeout(char *fname, int namlen, Sciclean sciclean)
{
int m,n,i;
LcaError *theErr = errCreate(sciclean);
float timeout;

	CheckRhs(1,1);
	CheckLhs(1,1);
	GetRhsVar(1,"r",&m,&n,&i);
	CheckScalar(1,m,n);
	timeout = *sstk(i);

	if ( timeout < 0.001 ) {
		lcaSetError(theErr, EZCA_INVALIDARG, "Timeout arg must be >= 0.001");
		goto cleanup;
	}
	ezcaSetTimeout(timeout);

cleanup:
	LhsVar(1)=0;
	return 0;
}

static int intsezcaDelay(char *fname, int namlen, Sciclean sciclean)
{
int m,n,i,rc;
	CheckRhs(1,1);
	CheckLhs(1,1);
	GetRhsVar(1,"r",&m,&n,&i);
	CheckScalar(1,m,n);
	if ( (rc = ezcaDelay(*sstk(i))) ) {
		char *msg="lcaDelay";
		LcaError *theErr = errCreate(sciclean);
		switch ( rc ) {
			case EZCA_INVALIDARG: msg = "lcaDelay: need 1 timeout arg > 0";
			break;
			case EZCA_ABORTED:    msg = "lcaDelay: usr abort";
			break;
			default:
			break;
		}
		lcaSetError(theErr, rc, msg);
	}
	LhsVar(1)=0;
	return 0;
}


static int intsezcaLastError(char *fname, int namlen, Sciclean sciclean)
{
int m, ntmp, i, *src;
LcaError *ple = lcaGetLastError();

	CheckRhs(0,0);
	CheckLhs(1,1);

	ntmp = 1;

	if ( ! (src = ple->errs) ) {
		/* single error */
		m   = 1;
		src = & ple->err;
	} else {
		m   = ple->nerrs;
	}
	CreateVar(1,"i",&m,&ntmp,&i);

	if ( sizeof(*istk(i)) != sizeof(*src) ) {
		mexPrintf("FATAL ERROR -- type size mismatch: %s - %i",__FILE__, __LINE__);
	}
	memcpy(istk(i), src, m*sizeof(*istk(i)));

	LhsVar(1) = 1;

	return 0;
}

static int intsezcaDebugOn(char *fname, int namlen, Sciclean sciclean)
{
	CheckRhs(0,0);
	CheckLhs(1,1);
	ezcaDebugOn();
	LhsVar(1)=0;
	return 0;
}

static int intsezcaDebugOff(char *fname, int namlen, Sciclean sciclean)
{
	CheckRhs(0,0);
	CheckLhs(1,1);
	ezcaDebugOff();
	LhsVar(1)=0;
	return 0;
}

static int intsezcaClearChannels(char *fname, int namlen, Sciclean sciclean)
{
int m,n;
char **s MAY_ALIAS;
LcaError *theErr = errCreate(sciclean);

	CheckRhs(0,1);
	CheckLhs(1,1);
	if ( Rhs > 0 ) {
		GetRhsVar(1, "S", &m, &n, &s);
		SCICLEAN_SVAR(s);
		CheckColumn(1,m,n);
		if ( 1 == m && 0 == *s[0] ) {
			s = 0;
			m = 0;
		}
	} else {
		s = 0;
		m = -1;
	}

	if ( multi_ezca_clear_channels(s,m,theErr) ) {
		/* error */
		return 0;
	}
		
	return 0;
}

static int intsezcaSetSeverityWarnLevel(char *fname, int namlen, Sciclean sciclean)
{
int m,n,i;
	CheckRhs(1,1);
	CheckLhs(1,1);
	GetRhsVar(1,"i",&m,&n,&i);
	CheckScalar(1,m,n);
	ezcaSetSeverityWarnLevel(*istk(i));
	LhsVar(1)=0;
	return 0;
}

static int intsezcaSetMonitor(char *fname, int namlen, Sciclean sciclean)
{
int mpvs, mtmp, ntmp, itmp, n = 0;
char     **pvs MAY_ALIAS;
char      type  = ezcaNative;
LcaError *theErr = errCreate(sciclean);

	CheckRhs(1,3);
	CheckLhs(1,1);
	LhsVar(1) = 0;

 	GetRhsVar(1,"S",&mpvs,&ntmp,&pvs);
	SCICLEAN_SVAR(pvs);
 	CheckColumn(1,mpvs,ntmp);

	if ( Rhs > 1 ) {
		GetRhsVar(2, "i", &mtmp, &ntmp, &itmp);
		CheckScalar(2, mtmp, ntmp);
		n = *istk(itmp);
		if ( Rhs > 2 && !arg2ezcaType(&type,3, theErr) )
			goto cleanup;
	}

	(void) multi_ezca_set_mon(pvs, mpvs, type, n, theErr);

cleanup:
	return 0;
}

static int intsezcaNewMonitorValue(char *fname, int namlen, Sciclean sciclean)
{
int mpvs, ntmp, i;
char     **pvs MAY_ALIAS;
char      type  = ezcaNative;
LcaError *theErr = errCreate(sciclean);

	CheckRhs(1,2);
	CheckLhs(1,1);

 	GetRhsVar(1,"S",&mpvs,&ntmp,&pvs);
	SCICLEAN_SVAR(pvs);
 	CheckColumn(1,mpvs,ntmp);

	if ( Rhs > 1 && !arg2ezcaType(&type,2,theErr) )
		goto cleanup;

	ntmp = 1;
	CreateVar(Rhs+1,"i",&mpvs,&ntmp,&i);
 		
	(void) multi_ezca_check_mon(pvs, mpvs, type, istk(i), theErr);

	LhsVar(1) = Rhs+1;

cleanup:
	return 0;
}

static int intsezcaNewMonitorWait(char *fname, int namlen, Sciclean sciclean)
{
int mpvs, ntmp;
char     **pvs MAY_ALIAS;
char      type  = ezcaNative;
LcaError *theErr = errCreate(sciclean);

	CheckRhs(1,2);
	CheckLhs(1,1);

 	GetRhsVar(1,"S",&mpvs,&ntmp,&pvs);
	SCICLEAN_SVAR(pvs);
 	CheckColumn(1,mpvs,ntmp);

	if ( Rhs > 1 && !arg2ezcaType(&type,2,theErr) )
		goto cleanup;

	(void) multi_ezca_wait_mon(pvs, mpvs, type, theErr);

cleanup:
	return 0;
}

#ifdef WITH_ECDRGET
#include <ecget.h>

static int intsecdrGet(char *fname, int namlen, Sciclean sciclean)
{
long *buf;

int m,n,nord;
char **s;

	CheckRhs(1,1);
	CheckLhs(1,1);
	GetRhsVar(1, "S", &m, &n, &s);
	SCICLEAN_SVAR(s);
#if 0 /* storage of a string -> matrix is strange:
       * I get 'blah' m:1/n:4...
	   */
	GetRhsVar(1,"c",&m,&n,&i);
#endif
	CheckRow(1,m,n);
	ecdrget(s[0], &n,&buf,&nord);
	LCACLEAN(buf);
	CreateVarFromPtr(2,"i",&m,&nord,&buf);
	if (buf) {
 		LhsVar(1)=2;
	}
 return 0;
}
#endif

static GenericTable Tab[]={
  {(Myinterfun)sciclean_gateway, intsezcaGet,					"lcaGet"},
  {(Myinterfun)sciclean_gateway, intsezcaPut,					"lcaPut"},
  {(Myinterfun)sciclean_gateway, intsezcaPutNoWait,				"lcaPutNoWait"},
  {(Myinterfun)sciclean_gateway, intsezcaGetNelem,				"lcaGetNelem"},
  {(Myinterfun)sciclean_gateway, intsezcaGetControlLimits,		"lcaGetControlLimits"},
  {(Myinterfun)sciclean_gateway, intsezcaGetGraphicLimits,		"lcaGetGraphicLimits"},
  {(Myinterfun)sciclean_gateway, intsezcaGetStatus,				"lcaGetStatus"},
  {(Myinterfun)sciclean_gateway, intsezcaGetPrecision,			"lcaGetPrecision"},
  {(Myinterfun)sciclean_gateway, intsezcaGetUnits,				"lcaGetUnits"},
  {(Myinterfun)sciclean_gateway, intsezcaGetRetryCount,			"lcaGetRetryCount"},
  {(Myinterfun)sciclean_gateway, intsezcaSetRetryCount,			"lcaSetRetryCount"},
  {(Myinterfun)sciclean_gateway, intsezcaGetTimeout,			"lcaGetTimeout"},
  {(Myinterfun)sciclean_gateway, intsezcaSetTimeout,			"lcaSetTimeout"},
  {(Myinterfun)sciclean_gateway, intsezcaDebugOn,				"lcaDebugOn"},
  {(Myinterfun)sciclean_gateway, intsezcaDebugOff,				"lcaDebugOff"},
  {(Myinterfun)sciclean_gateway, intsezcaSetSeverityWarnLevel,	"lcaSetSeverityWarnLevel"},
  {(Myinterfun)sciclean_gateway, intsezcaClearChannels,			"lcaClear"},
  {(Myinterfun)sciclean_gateway, intsezcaSetMonitor,		    "lcaSetMonitor"},
  {(Myinterfun)sciclean_gateway, intsezcaNewMonitorValue,	    "lcaNewMonitorValue"},
  {(Myinterfun)sciclean_gateway, intsezcaNewMonitorWait,	    "lcaNewMonitorWait"},
  {(Myinterfun)sciclean_gateway, intsezcaDelay,	    			"lcaDelay"},
  {(Myinterfun)sciclean_gateway, intsezcaLastError,    			"lcaLastError"},
#ifdef WITH_ECDRGET
  {(Myinterfun)sciclean_gateway, intsecdrGet,					"lecdrGet"},
#endif
};

int epicsShareAPI
C2F(ezca)()
{
CtrlCStateRec save;

	multi_ezca_ctrlC_prologue(&save);

	Rhs = Max(0, Rhs);
	(*(Tab[Fin-1].f))(Tab[Fin-1].name, Tab[Fin-1].F);

	multi_ezca_ctrlC_epilogue(&save);
  return 0;
}
