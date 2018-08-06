#ifndef EZCA_H_INCLUDED
#define EZCA_H_INCLUDED
/*************************************************************************\
* Copyright (c) 2002 The University of Chicago, as Operator of Argonne
* National Laboratory.
* Copyright (c) 2002 The Regents of the University of California, as
* Operator of Los Alamos National Laboratory.
* This file is distributed subject to a Software License Agreement found
* in the file LICENSE that is included with this distribution. 
\*************************************************************************/
/*****************************************************************/
/*                                                               */
/* for backward compatability.  users who compile with -DOLDCA   */
/* will have all their ezcaPut() calls automatically turned into */
/* calls to ezcaPutOldCa() which uses ca_put() (no callback).    */
/*                                                               */
/* this was necessary because ca_array_put_callback() did not    */
/* appear in CA until EPICS 3.11.6.  using ezca to put values    */
/* onto IOCs booted with versions prior to 3.11.6 will not work  */
/* unless the user defines OLDCA on the compile line.            */
/*                                                               */
/* on the other hand, defining OLDCA turns ALL calls to ezcaPut  */
/* to ca_put() (no notification).                                */
/*                                                               */
/*****************************************************************/

#ifdef OLDCA
#define ezcaPut ezcaPutOldCa
#else
#define ezcaPut ezcaPut
#endif

#include <epicsVersion.h>
#include <shareLib.h>
#include <epicsTime.h>

#define BASE_IS_MIN_VERSION(a,b,c) \
	(   EPICS_VERSION > (a)    \
	|| (EPICS_VERSION==(a) && EPICS_REVISION > (b)) \
	|| (EPICS_VERSION==(a) && EPICS_REVISION == (b) && EPICS_MODIFICATION >= (c)) \
	)

#ifdef __cplusplus
extern "C" {
#endif

/* Immediate Functions ... do not affect error message */

epicsShareFunc void epicsShareAPI ezcaLock(void);	/* lock library mutex    */
epicsShareFunc void epicsShareAPI ezcaUnlock(void);	/* release library mutex */
/* Abort polling by temporarily setting retryCount to 0;
 * NOTE: this routine does NO memory management and is meant to be
 *       called from a signal handler (see comments in ezca.c).
 */
epicsShareFunc void epicsShareAPI ezcaAbort(void);
typedef int (*EzcaPollCb)(); 
epicsShareFunc EzcaPollCb epicsShareAPI ezcaPollCbInstall(EzcaPollCb);
epicsShareFunc int epicsShareAPI ezcaEndGroup(void);
epicsShareFunc int epicsShareAPI ezcaEndGroupWithReport(int **rcs, int *nrcs);
epicsShareFunc int epicsShareAPI ezcaGetErrorString(char *prefix, char **buff);
epicsShareFunc int epicsShareAPI ezcaNewMonitorValue(char *pvname, 
	char ezcatype); /* returns TRUE/FALSE or < 0 if no monitor or other error */
/* Block until monitor happens */
epicsShareFunc int epicsShareAPI ezcaNewMonitorWait(char *pvname, char ezcatype);
epicsShareFunc void epicsShareAPI ezcaPerror(char *prefix);

/* Non-Groupable Work Functions */

epicsShareFunc void epicsShareAPI ezcaAutoErrorMessageOff(void);
epicsShareFunc void epicsShareAPI ezcaAutoErrorMessageOn(void);
epicsShareFunc int epicsShareAPI ezcaClearMonitor(char *pvname, char ezcatype);
epicsShareFunc void epicsShareAPI ezcaDebugOff(void);
epicsShareFunc void epicsShareAPI ezcaDebugOn(void);
epicsShareFunc int epicsShareAPI ezcaDelay(float sec);
epicsShareFunc void epicsShareAPI ezcaFree(void *buff);
epicsShareFunc int epicsShareAPI ezcaGetRetryCount(void);
epicsShareFunc float epicsShareAPI ezcaGetTimeout(void);
epicsShareFunc int epicsShareAPI ezcaPvToChid(char *pvname, chid **cid);
epicsShareFunc int epicsShareAPI ezcaSetMonitor(char *pvname, char ezcatype, unsigned long count);
epicsShareFunc int epicsShareAPI ezcaSetRetryCount(int retry);
epicsShareFunc int epicsShareAPI ezcaSetTimeout(float sec);
epicsShareFunc int epicsShareAPI ezcaStartGroup(void);
epicsShareFunc int epicsShareAPI ezcaClearChannel(char *pvname);
epicsShareFunc int epicsShareAPI ezcaPurge(int disconnectedOnly);
epicsShareFunc void epicsShareAPI ezcaTraceOff(void);
epicsShareFunc void epicsShareAPI ezcaTraceOn(void);

/* Groupable Work Functions */

epicsShareFunc int epicsShareAPI ezcaGet(char *pvname, char ezcatype, 
	int nelem, void *data_buff);
epicsShareFunc int epicsShareAPI ezcaGetControlLimits(char *pvname, 
	double *low, double *high);
epicsShareFunc int epicsShareAPI ezcaGetGraphicLimits(char *pvname, 
	double *low, double *high);
epicsShareFunc int epicsShareAPI ezcaGetWarnLimits(char *pvname, 
	double *low, double *high);
epicsShareFunc int epicsShareAPI ezcaGetAlarmLimits(char *pvname, 
	double *low, double *high);
epicsShareFunc int epicsShareAPI ezcaGetNelem(char *pvname, int *nelem);
epicsShareFunc int epicsShareAPI ezcaGetPrecision(char *pvname, 
	short *precision);
epicsShareFunc int epicsShareAPI ezcaGetStatus(char *pvname, 
	epicsTimeStamp *timestamp, short *status, short *severity);
epicsShareFunc int epicsShareAPI ezcaGetUnits(char *pvname, 
	char *units); /* units must be at least	EZCA_UNITS_SIZE large */
epicsShareFunc int epicsShareAPI ezcaGetWithStatus(char *pvname, 
	char ezcatype, int nelem, void *data_buff, epicsTimeStamp *timestamp, 
	short *status, short *severity);
epicsShareFunc int epicsShareAPI ezcaPut(char *pvname, char ezcatype, 
	int nelem, void *data_buff);
epicsShareFunc int epicsShareAPI ezcaPutOldCa(char *pvname, char ezcatype, 
	int nelem, void *data_buff);

/* must match size of char units[] in dbr_gr_xxxx */
/* and dbr_ctrl_xxxx structs in db_access.h       */
#define EZCA_UNITS_SIZE 8
/* must match size of char strs[][] in dbr_gr_xxxx */
/* and dbr_ctrl_xxxx structs in db_access.h       */
#define EZCA_ENUM_STATES 16
#define EZCA_ENUM_STRING_SIZE 26

epicsShareFunc int epicsShareAPI ezcaGetEnumStrings(char *pvname, char states[EZCA_ENUM_STATES][EZCA_ENUM_STRING_SIZE]);

/* Data Types */
#define ezcaByte   0
#define ezcaString 1
#define ezcaShort  2
#define ezcaLong   3
#define ezcaFloat  4
#define ezcaDouble 5
#define VALID_EZCA_DATA_TYPE(X) (((X) >= 0)&&((X)<=(ezcaDouble)))

/* Return Codes */
#define EZCA_OK                0
#define EZCA_INVALIDARG        1
#define EZCA_FAILEDMALLOC      2
#define EZCA_CAFAILURE         3
#define EZCA_UDFREQ            4
#define EZCA_NOTCONNECTED      5
#define EZCA_NOTIMELYRESPONSE  6
#define EZCA_INGROUP           7
#define EZCA_NOTINGROUP        8
#define EZCA_ABORTED           9
#define EZCA_INTERNALERR      10

#ifdef __cplusplus
}
#endif

#endif
