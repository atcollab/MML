/* $Id: multiEzca.c,v 1.39 2007/10/14 03:28:04 strauman Exp $ */

/* multi-PV EZCA calls */

/* Author: Till Straumann <strauman@slac.stanford.edu>, 2002-2003 */

/* LICENSE: EPICS open license, see ../LICENSE file */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <assert.h>
#include <math.h>
#include <time.h>
#ifdef TESTING
#include <inttypes.h>
#else
/* Stupid m$$ has no stdint.h/inttypes.h C99 headers */
#include <epicsTypes.h>
#endif

#if defined(WIN32) || defined(_WIN32)
#include <float.h>
#include <epicsStdio.h>
#define snprintf  epicsSnprintf
#define vsnprintf epicsVsnprintf
#define isnan _isnan
#else
#include <unistd.h> /* _POSIX_TIMERS */
#endif

#include <mex.h> /* fortran/C name conversion for scilab */

/* CA includes */
#include <tsDefs.h> 
#include <cadef.h> 
#include <ezca.h>
#include <alarm.h>
#include <alarmString.h>
#include <epicsVersion.h>

#define epicsExportSharedSymbols
#include "shareLib.h"
#include "multiEzca.h"
#include "lcaError.h"

#ifndef NAN
#if defined(WIN32) || defined(_WIN32) 
static unsigned long mynan[2] = { 0xffffffff, 0x7fffffff };
#define NAN (*(double*)mynan)
#else
#define NAN (0./0.)
#endif
#endif

/* GLOBAL VARIABLES */
static int ezcaSeverityWarnLevel   = INVALID_ALARM;
static int ezcaSeverityRejectLevel = INVALID_ALARM;

/* FWD DECLS        */
static char * my_strdup(const char *str);

#undef TESTING

/* ezca needs a bugfix for correctly reading Nelem in grouped mode */

#define EZCA_BUG_FIXED 1 /* patch applied */

#if EZCA_BUG_FIXED
#define EZCA_START_NELEM_GROUP()	ezcaStartGroup()
#define EZCA_END_NELEM_GROUP(m,pe)	do_end_group(0, m, pe)
#else
/* EZCA Bug: ezcaGetNelem() doesn't work in grouped mode :-( */
#define EZCA_START_NELEM_GROUP()	(0)
#define EZCA_END_NELEM_GROUP(m,pe)	(0)
#endif

/* in TESTING mode, we fake a couple of ezca routines for debugging
 * conversion and packing issues
 */
#ifdef TESTING
static int ezcaPut(char *name, char type, int nelms, void *bufp)
{
int j;
	printf("%30s:",name);
	for (j=0; j<nelms; j++)
			switch(type) {
				case ezcaByte:   printf(" %"PRIi8 , ((int8_t*)bufp)[j]); break;
				case ezcaShort:  printf(" %"PRIi16, ((int16_t*)bufp)[j]); break;
				case ezcaLong:   printf(" %"PRIi32, ((int32_t*)bufp)[j]); break;
				case ezcaFloat:  printf(" %g", ((float*)bufp)[j]); break;
				case ezcaDouble: printf(" %g", ((double*)bufp)[j]); break;
				case ezcaString: printf(" '%s'",&((dbr_string_t*)bufp)[j][0]); break;
			}
	printf("\n");
	return EZCA_OK;
}

typedef struct {
	char *name;
	short num[];
} TstShtRow;

typedef struct {
	char *name;
	long num[];
} TstLngRow;

typedef struct {
	char *name;
	float num[];
} TstFltRow;

static short tstSht[] = {
	10, 20, 30,
	-1, 0xdead, -1,
	-2, -3, -4,
	-5, -6, 0xdead
};

static long tstLng[] = {
	10, 20, 30,
	-1, 0xdead, -1,
	-2, -3, -4,
	-5, -6, 0xdead
};

static float tstFlt[] = {
	.1, .2, .3,
	-1., NAN, -1.,
	-2., -3., -4.,
	-5., -6., NAN
};

static double tstDbl[] = {
	.1, .2, .3,
	-1., NAN, -1.,
	-2., -3., -4.,
	-5., -6., NAN
};

static char *tstChr[] = {
	".1", ".2", ".3",
	"-1.", 0, "-1.",
	"-2.", "-3.", "-4.",
	"-5.", "-6.", 0
};

static int ezcaGetNelem(char *name, int *pn)
{
int t = toupper(*name);
int idx,i;

	while ( !isdigit(*name) && *name )
			name++;

	if (1!=sscanf(name,"%i",&idx) || idx >3) {
		printf("Invalid index\n");
		return -1;
	}

	for ( i=0; i<3; i++)
	switch ( t ) {
			case 'S': if ((short)0xdead == tstSht[3*idx+i]) { *pn = i; return 0; } break;
			case 'L': if (0xdead == tstLng[3*idx+i]) { *pn = i; return 0; } break;
			case 'F': if (isnan(tstFlt[3*idx+i])) { *pn = i; return 0; } break;
			case 'D': if (isnan(tstDbl[3*idx+i])) { *pn = i; return 0; } break;
			case 'C': if (!tstChr[3*idx+i])       { *pn = i; return 0; } break;
	default:
		printf("Invalid fake name \n");
		return -1;
	}
	*pn = 3;
	return 0;
}

static int ezcaGetWithStatus(char *name, char type, int nelms, void *bufp, TS_STAMP *pts, short *st, short *se)
{
unsigned idx,i;

	while ( !isdigit(*name) && *name )
			name++;

	if (1!=sscanf(name,"%i",&idx) || idx >3) {
		printf("Invalid index\n");
		return -1;
	}
	if ( nelms < 0 || nelms > 3 ) {
		printf("Invalid nelms\n");
		return -1;
	}
	for (i=0; i<nelms; i++)
	switch (type) {
		case ezcaByte:   ( (epicsInt8*)bufp)[i] = tstSht[3*idx+i]; break;
		case ezcaShort:  ((epicsInt16*)bufp)[i] = tstSht[3*idx+i]; break;
		case ezcaLong:   ((epicsInt32*)bufp)[i] = tstLng[3*idx+i]; break;
		case ezcaFloat:  (  (float*)bufp)[i] = tstFlt[3*idx+i]; break;
		case ezcaDouble: ( (double*)bufp)[i] = tstDbl[3*idx+i]; break;
		case ezcaString: strcpy(&((dbr_string_t*)bufp)[i][0], tstChr[3*idx+i] ? tstChr[3*idx+i]:""); break;

		default: printf("Invalid type\n"); return -1;

	}
	*st = *se = 0;
	return 0;
}

#endif

static int do_end_group(int *dims, int m, LcaError *pe)
{
int nrcs,i;
int rval = EZCA_OK;
	if ( pe ) {
		rval = ezcaEndGroupWithReport(&pe->errs, &nrcs);
		assert(nrcs == m);
		if ( EZCA_OK != rval && dims ) {
			for ( i=0; i<nrcs; i++ )
				dims[i] = 0;
		}

/* I believe there is no harm in just using free() as opposed
 * to ezcaFree...
 *
 * Update: there could be harm: under matlab, 'malloc' & friends
 *         map to mxMalloc() but ezca uses regular 'malloc'. Hence
 *         stuff allocatedd by ezca should be released with ezcaFree!
 */
#if 0
		{
			void *tmp = pe->errs;
			pe->errs = lcaMalloc(sizeof(*pe->errs)*m);
			memcpy(pe->errs, tmp);
			ezcaFree(tmp);
		}
#endif
		if ( EZCA_OK == rval ) {
			ezcaFree(pe->errs); pe->errs = 0;
		}
		if ( pe->errs )
			pe->nerrs = m;
	} else {
		rval = ezcaEndGroup();
	}
	return rval;
}


/* our 'strdup' implementation (*IMPORTANT*, in order for the matlab implementation using mxMalloc!!)
 * also, strdup is not POSIX...
 */
static char *
my_strdup(const char *str)
{
char *rval = 0;
	/* under matlab, 'malloc' will be replaced by mxMalloc by means of macro uglyness */ 
	if ( str && (rval = lcaMalloc(sizeof(*rval) * (strlen(str) + 1) )) ) {
		strcpy(rval, str);
	}
	return rval;
}

#if !BASE_IS_MIN_VERSION(3,14,0)


#if !defined(_POSIX_TIMERS)
/* compiler flags may need to define -D_POSIX_C_SOURCE=199506L */
struct timespec {
    time_t tv_sec; /* seconds since some epoch */
    long tv_nsec; /* nanoseconds within the second */
};
#endif

/* provide bogus epicsTimeToTimespec */
static void
epicsTimeToTimespec(struct timespec *tspec, TS_STAMP *tstamp)
{
	mexPrintf("WARNING: epicsTimeToTimespec not implemented\n");
	tspec->tv_sec = 0;
	tspec->tv_nsec = 0;
}

#endif

/* convert timestamps into complex array */

void epicsShareAPI
multi_ezca_ts_cvt(int m, TS_STAMP *pts, double *pre, double *pim)
{
int i;
struct timespec ts;
	for ( i=0; i<m; i++ ) {
		epicsTimeToTimespec( &ts, pts + i );
		pre[i] = ts.tv_sec;
		pim[i] = ts.tv_nsec;
	}
}

#define CHUNK 100

static void
ezErr(int rc, char *nm, LcaError *pe)
{
	char *msg,*b,*ok, *nl;
	int	 l;

	if ( pe )
		pe->err = rc;

	ezcaGetErrorString(nm,&msg);
	if (msg) {

#if 0   /* message is already reported in *pe; don't print twice */
		/* long strings passed to sciprint crash
		 * scilab :-(, so we break them up...
		 */
		for ( b=msg, l=strlen(msg); l > CHUNK; b+=CHUNK, l-=CHUNK ) {
			char ch = b[CHUNK];
			b[CHUNK]=0;
			mexPrintf(b);
			b[CHUNK]=ch;
		}
		mexPrintf(b);
#endif

		if ( pe ) {
			/* Look for first error */
			for ( b=msg; (nl = strchr(b,'\n')); ) { 
				/* if no "OK\n" is there, or it is found after the newline
				 * then an error message is there first
				 */
				if ( (ok = strstr(b,"OK\n")) && ok < nl ) {
					b = ok + 3;
				} else {
					break;
				}
			}
			l = sizeof(pe->msg) - 1;
			if ( nl ) {
				if ( l > (nl-b) )
					l = nl-b;
			}
			strncpy(pe->msg, b, l);
			pe->msg[l] = 0;
		}
		
	} else {
		if ( pe )
			strcpy(pe->msg,"Unknown Error\n");
	}
	ezcaFree(msg);
}

static void
ezErr1(int rc, char *msg, LcaError *pe)
{
	lcaSetError(pe, rc, msg);
}

/* determine the size of an ezcaXXX type */
static int typesize(char type)
{
	switch (type) {
		case ezcaByte:		return sizeof(epicsInt8);
		case ezcaShort:		return sizeof(epicsInt16);
		case ezcaLong:		return sizeof(epicsInt32);
		case ezcaFloat:		return sizeof(float);
		case ezcaDouble:	return sizeof(double);
		case ezcaString:	return sizeof(dbr_string_t);
		default: break;
	}
	assert(!"must never get here");
	return -1;
}

static char nativeType(char *pv, int acceptString, int acceptNotConn)
{
chid *pid;

	if ( EZCA_OK == ezcaPvToChid( pv, &pid ) && pid ) {
		switch( ca_field_type(*pid) ) {
			case TYPENOTCONN:
							 if ( !acceptNotConn )
								return -1;
							 /* else fall through and default to FLOAT */
			default:	
				             break;

			case DBF_CHAR:   return ezcaByte;

			/*	case DBF_INT: */
			case DBF_SHORT:  return ezcaShort;

			case DBF_LONG:   return ezcaLong;
			case DBF_FLOAT:  return ezcaFloat;
			case DBF_DOUBLE: return ezcaDouble;

			case DBF_STRING:
			case DBF_ENUM:
							 if ( acceptString )
									return ezcaString;
							 break;
		}
	}
	return ezcaFloat;
}

int epicsShareAPI
multi_ezca_get_nelem(char **nms, int m, int *dims, LcaError *pe)
{
int i, rc;

	EZCA_START_NELEM_GROUP();

		for ( i=0; i<m; i++) {
			if ( (rc = ezcaGetNelem( nms[i], dims+i )) ) {
				ezErr(rc, "multi_ezca_get_nelem - ", pe);
				return -1;
			}
		}

	if ( ( rc = EZCA_END_NELEM_GROUP(m, pe)) ) {
		ezErr(rc, "multi_ezca_get_nelem - ", pe);
		return -1;
	}

	return 0;
}

/* transpose and convert a matrix */
#define XPOSECVT(Forttyp,check,Ctyp,assign) \
	{ Ctyp *cpt; Forttyp *fpt; \
	for ( i=0, cpt=cbuf; i<m; i++ ) { \
		for ( j=0, fpt=(Forttyp*)fbuf+i; j<n; j++, fpt+=m) { \
			if ( check ) { \
				cpt += n-j; \
				break; \
			} else { \
				assign; \
				cpt++; \
			} \
		} \
		dims[i] = j; \
	} \
	}

/* for ( i=0, bufp = cbuf; i<m; i++, bufp+=rowsize) */
#define CVTVEC(Forttyp, check, Ctyp, assign)			\
	{ Ctyp *cpt = (Ctyp*)bufp; Forttyp *fpt = (Forttyp*)fbuf + (mo > 1 ? i : 0);	\
		for ( ; j<n && !(check) ; j++, cpt++, fpt+=mo ) { \
			assign;	\
		}	\
	}

int epicsShareAPI
multi_ezca_put(char **nms, int m, char type, void *fbuf, int mo, int n, int doWait4Callback, LcaError *pe)
{
void          *cbuf  = 0;
int           *dims  = 0;
char		  *types = 0;
int           rowsize,typesz;
int           rval = -1;
int           rc;

register int  i;
register char *bufp;

	if ( mo != 1 && mo != m ) {
		ezErr1(
			EZCA_FAILEDMALLOC,
			"multi_ezca_put: invalid dimension of 'value' matrix; must have 1 or m rows",
			pe);
		goto cleanup;
	}

	if ( !(dims  = lcaMalloc( m * sizeof(*dims) )) ||
	     !(types = lcaMalloc( m * sizeof(*types) )) ) {
		ezErr1(
			EZCA_FAILEDMALLOC,
			"multi_ezca_put: not enough memory",
			pe);
		goto cleanup;
	}


#if EZCA_BUG_FIXED
	/* PvToChid is non-groupable; hence we request all 'nelms'
     * hoping that batching ca connects is faster than looping
     * through a number of PvToChids
     */
	if ( ezcaNative == type ) {
		if ( multi_ezca_get_nelem( nms, m, dims, pe ) )
			goto cleanup;
	}
#endif

	typesz = 0;
	for ( i=0; i<m; i++ ) {
		int tmp;
		types[i] = ezcaNative == type ? nativeType(nms[i], 0, 1) : type;
		if ( (tmp = typesize(types[i])) > typesz ) {
			typesz = tmp;
		}
	}

	rowsize = n * typesz;

	/* get buffers; since we do asynchronous processing and we possibly
     * use different native types for different rows, we
	 * need to buffer the full array - we cannot do it row-wise
	 */

	if ( !(cbuf  = lcaMalloc( m * rowsize )) ) {
		ezErr1(
			EZCA_FAILEDMALLOC,
			"multi_ezca_put: not enough memory",
			pe);
		goto cleanup;
	}

	/* transpose and convert */
	for ( i=0, bufp = cbuf; i<m; i++, bufp+=rowsize) {
	int j = 0;
	switch ( types[i] ) {
		case ezcaByte:    CVTVEC( double, isnan(*(double*)fpt), epicsInt8,  *cpt=(epicsInt32)*fpt );  break;
		case ezcaShort:   CVTVEC( double, isnan(*(double*)fpt), epicsInt16, *cpt=(epicsInt32)*fpt );  break;
		case ezcaLong :   CVTVEC( double, isnan(*(double*)fpt), epicsInt32, *cpt=(epicsInt32)*fpt );  break;
		case ezcaFloat:   CVTVEC( double, isnan(*(double*)fpt), float,  *cpt=*fpt ); break;
		case ezcaDouble:  CVTVEC( double, isnan(*(double*)fpt), double, *cpt=*fpt ); break;
		case ezcaString:  CVTVEC( char*,
								    (!*fpt || !**fpt),
									dbr_string_t,
									if ( strlen(*fpt) >= sizeof(dbr_string_t) ) { \
									    ezErr1(EZCA_FAILEDMALLOC,"string too long", pe);\
										goto cleanup; \
									} else \
										strcpy(&(*cpt)[0],*fpt)
									);
						  break;
	}
	dims[i] = j;
	}

	ezcaStartGroup();

		for ( i=0, bufp = cbuf; i<m; i++, bufp += rowsize ) {
			if (doWait4Callback)
				ezcaPut(nms[i], types[i], dims[i], bufp);
			else
				ezcaPutOldCa(nms[i], types[i], dims[i], bufp);
		}

	if ( EZCA_OK != (rc = do_end_group(0, m, pe)) ) {
		ezErr(rc, "multi_ezca_put - ", pe);
	} else {
		rval = m;
	}

	if (!doWait4Callback)
		ca_flush_io(); /* make sure request goes out */

cleanup:
	lcaFree(types);
	lcaFree(cbuf);
	lcaFree(dims);
	return rval;
}

int epicsShareAPI
multi_ezca_get(char **nms, char *type, void **pres, int m, int *pn, TS_STAMP **pts, LcaError *pe)
{
void          *cbuf  = 0;
void          *fbuf  = 0;
int           *dims  = 0;
short         *stat  = 0;
short         *sevr  = 0;
int           rval   = 0;
char          *types = 0;
int           mo     = m;
int           rowsize,typesz,nreq,nstrings;
TS_STAMP      *ts    = 0;
int           rc;

register int  i,n = 0;
register char *bufp;

	nreq  = *pn;

	*pn   = 0;
	*pres = 0;
	*pts  = 0;

	/* get buffers; since we do asynchronous processing, we
	 * need to buffer the full array - we cannot do it row-wise
	 */
	if ( !(dims = lcaCalloc( m , sizeof(*dims) )) || !(types = lcaMalloc( m * sizeof(*types) )) ) {
		ezErr1( EZCA_FAILEDMALLOC, "multi_ezca_get: not enough memory", pe);
		goto cleanup;
	}

	if ( multi_ezca_get_nelem( nms, m, dims, pe ) )
		goto cleanup;

	typesz = 0;
	for ( nstrings=n=i=0; i<m; i++) {
		int tmp;

		/* clip to requested n */
		if ( nreq > 0 && dims[i] > nreq )
			dims[i] = nreq;

		if ( dims[i] > n )
			n = dims[i];
		/* nativeType uses ezcaPvToChid() which is non-groupable */
		if ( ezcaString == (types[i] = ezcaNative == *type ? nativeType(nms[i], 1, 1) : *type) )
			nstrings++;

		if ( (tmp = typesize(types[i])) > typesz )
			typesz = tmp;
	}

	if ( nstrings ) {
		if ( nstrings !=m ) {
			ezErr1(
				EZCA_INVALIDARG,
				"multi_ezca_get: type mismatch native 'string/enum' PVs cannot be\n"
				"mixed with numericals -- use 'char' type to enforce conversion\n",
				pe);
			goto cleanup;
		} else {
			*type = ezcaString;
		}
	}

	rowsize = n * typesz;

	if ( !(cbuf = lcaMalloc( m * rowsize ))          ||
		 !(stat = lcaCalloc( m,  sizeof(*stat)))     ||
		 !(ts   = lcaMalloc( m * sizeof(TS_STAMP)))  ||
		 !(sevr = lcaMalloc( m * sizeof(*sevr))) ) {
		ezErr1( EZCA_FAILEDMALLOC, "multi_ezca_get: not enough memory", pe);
		goto cleanup;
	}

	/* get the values along with status */
	ezcaStartGroup();
		for ( i=0, bufp=cbuf; i<m; i++, bufp+=rowsize ) {
			if ( (rc = ezcaGetWithStatus(nms[i],types[i],dims[i], bufp,ts + i,stat+i,sevr+i)) ) {
				ezErr(rc, "multi_ezca_get - ", pe);
				goto cleanup;
			}
		}

	if ( EZCA_OK != (rc = do_end_group(dims, m, pe)) ) {
		ezErr(rc, "multi_ezca_get - ", pe);
#ifndef SILENT_AND_PROGRESS
		goto cleanup;
#endif
	}

	for ( i=0; i<m; i++ ) {
		char *dotp;
		if ( sevr[i] >= ezcaSeverityWarnLevel )
			mexPrintf("Warning: PV (%s) with alarm status: %s (severity %s)\n",
						nms[i],
						alarmStatusString[stat[i]],
						alarmSeverityString[sevr[i]]);
		/* refuse to return an invalid VAL field */
		if ( sevr[i] >= ezcaSeverityRejectLevel && ( !(dotp=strrchr(nms[i],'.')) || !strcmp(dotp, ".VAL") )  )
			dims[i] = 0;
	}

	/* allocate the target buffer */
	if ( ezcaString == *type )
		/* Scilab expects NULL terminated char** list */
		fbuf = lcaCalloc( m*n+1, sizeof(char*) );
	else
		fbuf = lcaMalloc( m*n * sizeof(double) );

	if ( !fbuf ) {
		ezErr1( EZCA_FAILEDMALLOC, "multi_ezca_get: not enough memory", pe);
		goto cleanup;
	}

	/* transpose and convert */
	for ( i=0, bufp = cbuf; i<m; i++, bufp+=rowsize) {
	int j = 0;
	switch ( types[i] ) {
			case ezcaByte:   CVTVEC( double,
										(0),
										epicsInt8,
										*fpt= j>=dims[i] ? NAN : *cpt
							  );
							  break;

			case ezcaShort:   CVTVEC( double,
										(0),
										epicsInt16,
										*fpt= j>=dims[i] ? NAN : *cpt
							  );
							  break;

			case ezcaLong :   CVTVEC( double,
										(0),
										epicsInt32,
										*fpt= j>=dims[i] ? NAN : *cpt
							  );
							  break;

			case ezcaFloat:   CVTVEC( double,
										(0),
										float,
										*fpt= j>=dims[i] ? NAN : *cpt
							  );
							  break;

			case ezcaDouble:  CVTVEC( double,
										(0),
										double,
										*fpt= j>=dims[i] ? NAN : *cpt
							  );
							  break;

			case ezcaString:  CVTVEC( char *,
										(0),
										dbr_string_t,
										do {  \
										  if ( !(*fpt=my_strdup(j>=dims[i] ? "" : &(*cpt)[0])) ) { \
										     ezErr1(EZCA_FAILEDMALLOC, "strdup: no memory", pe); \
											 goto cleanup; \
										  } \
										} while (0)
							  );
							  break;
	}
	dims[i] = j;
	}

	*pres = fbuf; fbuf  = 0;
	*pts = ts; ts = 0;

	*pn   = n;
	rval  = m;

cleanup:
	if ( fbuf && ezcaString == *type ) {
		for ( i=0; i<n*m; i++)
			lcaFree(((char**)fbuf)[i]);
	}
	lcaFree(fbuf);
	lcaFree(cbuf);
	lcaFree(dims);
	lcaFree(types);
	lcaFree(stat);
	lcaFree(sevr);
	lcaFree(ts);
	return rval;
}

int epicsShareAPI
multi_ezca_get_misc(char **nms, int m, MultiEzcaFunc ezcaProc, int nargs, MultiArg args, LcaError *pe)
{
int		rval = 0;
int		i, rc;
char	*bufp0;
char	*bufp1;
char	*bufp2;
char	*bufp3;

	/* allocate buffers */
	for ( i=0; i<nargs; i++ ) {
		assert( (0==args[i].pres) != (0==args[i].buf) );
		if ( args[i].pres )
			*args[i].pres = 0;
		else /* args[i].buf is !=0 as asserted */
			continue; /* caller allocated/owns the buffer */

		if ( !(args[i].buf = lcaCalloc( m, args[i].size )) ) {
			ezErr1(EZCA_FAILEDMALLOC, "multi_ezca_get_misc: no memory", pe);
			goto cleanup;
		}
	}

	ezcaStartGroup();

	switch (nargs) {
		case 1:
		for ( i=0,
			  bufp0=args[0].buf
			  ;
			  i<m;
			  i++,
			  bufp0+=args[0].size
			  )
			ezcaProc(nms[i],bufp0);
		break;

		case 2:
		for ( i=0,
			  bufp0=args[0].buf,
			  bufp1=args[1].buf
			  ;
			  i<m;
			  i++,
			  bufp0+=args[0].size,
			  bufp1+=args[1].size
			  )
			ezcaProc(nms[i],bufp0,bufp1);
		break;

		case 3:
		for ( i=0,
			  bufp0=args[0].buf,
			  bufp1=args[1].buf,
			  bufp2=args[2].buf
			  ;
			  i<m;
			  i++,
			  bufp0+=args[0].size,
			  bufp1+=args[1].size,
			  bufp2+=args[2].size
			  )
			ezcaProc(nms[i],bufp0,bufp1,bufp2); 
		break;

		case 4:
		for ( i=0,
			  bufp0=args[0].buf,
			  bufp1=args[1].buf,
			  bufp2=args[2].buf,
			  bufp3=args[3].buf
			  ;
			  i<m;
			  i++,
			  bufp0+=args[0].size,
			  bufp1+=args[1].size,
			  bufp2+=args[2].size,
			  bufp3+=args[3].size
			  )
			ezcaProc(nms[i],bufp0,bufp1,bufp2,bufp3);
		break;
	default:
		assert(!"multi_ezca_get_misc: invalid number of arguments - should never happen");
	}

	if ( EZCA_OK != (rc = do_end_group(0, m, pe)) ) {
		ezErr(rc, "multi_ezca_get - ", pe);
		goto cleanup;
	}

	rval  = m;
	for ( i=0; i<nargs; i++ ) {
		if ( args[i].pres )
				*args[i].pres = args[i].buf;
	}
	nargs = 0;

cleanup:
	for ( i=0; i<nargs; i++ ) {
		/* release only the buffers we created/own */
		if ( args[i].pres ) {
			lcaFree (args[i].buf);
			args[i].buf = 0;
		}
	}
	return rval;
}

static char *getTypes(char **nms, int m, int type)
{
char *types = 0;
char *rval  = 0;
int  i;

	if ( !(types = lcaMalloc( m * sizeof(*types) )) ) {
		goto cleanup;
	}

	for ( i=0; i<m; i++ )
		types[i] = type;

	if ( ezcaNative == type ) {
		for ( i=0; i<m; i++ ) {
			if ( ezcaNative == (types[i] = nativeType(nms[i], 1, 0)) )
				break;
		}
	}

	rval = types;
	types = 0;

cleanup:
	lcaFree( types );
	return rval;
}

int epicsShareAPI
multi_ezca_set_mon(char **nms,  int m, int type, int clip, LcaError *pe)
{
char *types = 0;
int  *dims  = 0;
int  i, rc;
int  rval = -1;

	if ( !(dims  = lcaMalloc( m * sizeof(*dims) )) ) {
		ezErr1(EZCA_FAILEDMALLOC, "multi_ezca_set_mon: not enough memory", pe);
		goto cleanup;
	}

	if ( multi_ezca_get_nelem( nms, m, dims, pe ) )
		goto cleanup;

	rval = 0;
	/* ca monitors don't seem to work well for large arrays
	 * when specifying a zero count
	 */
	if ( ( types = getTypes(nms, m, type)) ) {
		for ( i=0; i<m; i++ ) {
			if ( clip && clip < dims[i] )
				dims[i] = clip;
			if ( -1 == types[i] ) {
				ezErr(EZCA_NOTCONNECTED, "multi_ezca_set_monitor - channel not connected", pe);
				rval = -1;
			} else if ( (rc = ezcaSetMonitor(nms[i], types[i], dims[i])) ) {
				rval = -1;
				ezErr(rc, "multi_ezca_set_monitor - ", pe);
			}
		}
	} else {
		ezErr1(EZCA_FAILEDMALLOC, "multi_ezca_set_monitor - no memory", pe);
	}

cleanup:

	lcaFree( types );
	lcaFree( dims );
	return rval;
}

int epicsShareAPI
multi_ezca_check_mon(char **nms, int m, int type, int *val, LcaError *pe)
{
char *types   = getTypes(nms, m, type);
int  i,rc;
int  rval     = types ? 0 : -1;
char errmsg[100];

	if ( types ) {
		for ( i=0; i<m; i++ ) {
			val[i] = -1 == types[i] ? (rc = -10) : (rc = ezcaNewMonitorValue(nms[i], types[i]));

			if ( !rval && rc < 0 ) {
				switch ( rc ) {
					case -10: rc = EZCA_NOTCONNECTED;
							  snprintf(errmsg, sizeof(errmsg), "multi_ezca_check_mon: PV '%s' not connected\n", nms[i]);
							  break;

					case  -1: rc = EZCA_NOMONITOR;
							  snprintf(errmsg, sizeof(errmsg), "multi_ezca_check_mon: no monitor on '%s' set\n", nms[i]);
							  break;
					case  -2: rc = EZCA_NOCHANNEL;
							  snprintf(errmsg, sizeof(errmsg), "multi_ezca_check_mon: no channel for PV '%s' found\n", nms[i]);
							  break;
					case  -3: rc = EZCA_INVALIDARG;
							  snprintf(errmsg, sizeof(errmsg), "multi_ezca_check_mon: invalid type requested (PV '%s')\n", nms[i]);
							  break;
					default:  rc = EZCA_INVALIDARG;
							  snprintf(errmsg, sizeof(errmsg), "multi_ezca_check_mon: invalid argument (PV: %s)\n", nms[i]);
							  break;
				}
				ezErr1(rc, errmsg, pe);
				rval = -1;	
			}
		}
	} else {
		ezErr1(EZCA_FAILEDMALLOC, "multi_ezca_check_mon: no memory", pe);
	}

	lcaFree( types );
	return rval;
}

int epicsShareAPI
multi_ezca_wait_mon(char **nms, int m, int type, LcaError *pe)
{
char *types   = getTypes(nms, m, type);
int  i,rc = EZCA_FAILEDMALLOC;

	if ( types ) {

		ezcaStartGroup();

		for ( i=0; i<m; i++ ) {
			if ( (rc = ezcaNewMonitorWait(nms[i], types[i])) ) {
				ezErr(rc, "multi_ezca_wait_mon - ", pe);
				goto cleanup;
			}
		}

		if ( EZCA_OK != (rc = do_end_group(0, m, pe)) ) {
			ezErr(rc, "multi_ezca_wait_mon - ", pe);
		}

	} else {
		ezErr1(rc, "multi_ezca_check_mon: no memory", pe);
		goto cleanup;
	}


cleanup:

	lcaFree( types );
	return (EZCA_OK == rc) ? 0 : -1;
}

void epicsShareAPI
ezcaSetSeverityWarnLevel(int level)
{
if ( level >= 10 ) {
  level-=10;
  mexPrintf("Setting severity REJECTION level to %i\n", level);
  ezcaSeverityRejectLevel = level;
} else {
  ezcaSeverityWarnLevel = level;
}
}

int epicsShareAPI
multi_ezca_clear_channels(char **nms, int m, LcaError *pe)
{
int rval = EZCA_OK, i, r = EZCA_OK;

	if ( !nms ) {
		if ( (rval = ezcaPurge( m<0 ? 0 : 1 )) )
			ezErr(rval, "multi_ezca_clear_channels - ", pe);
	} else {

		for ( i=0; i<m; i++ ) {
			if ( EZCA_OK != (r = ezcaClearChannel(nms[i])) )
				ezErr(r, "multi_ezca_clear_channels - ", (EZCA_OK == rval ? pe : 0));

			if ( EZCA_OK == rval )
				rval = r;
		}
	}

	return rval;
}

void epicsShareAPI
lcaErrorInit(LcaError *pe)
{
	pe->err    = 0;
	pe->msg[0] = 0;
	pe->nerrs  = 0;
	pe->errs   = 0;
}

static LcaError theLastError = {0, {0}, 0, 0};

void epicsShareAPI
lcaSaveLastError(LcaError *pe)
{
	ezcaFree(theLastError.errs);
	memcpy(&theLastError, pe, sizeof(*pe));
	/* we took over the (optional) error vector */
	pe->errs  = 0;
	pe->nerrs = 0;
}

LcaError * epicsShareAPI
lcaGetLastError()
{
	return &theLastError;
}

void epicsShareAPI
lcaSetError(LcaError *pe, int err, char *fmt, ...)
{
va_list ap;
	if ( !pe )
		return;

	pe->err = err;

	va_start(ap, fmt);

	vsnprintf(pe->msg, sizeof(pe->msg), fmt, ap);

	va_end(ap);

	pe->msg[sizeof(pe->msg)-1] = 0;
}
