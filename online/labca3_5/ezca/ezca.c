/*************************************************************************\
* Copyright (c) 2002 The University of Chicago, as Operator of Argonne
* National Laboratory.
* Copyright (c) 2002 The Regents of the University of California, as
* Operator of Los Alamos National Laboratory.
* This file is distributed subject to a Software License Agreement found
* in the file LICENSE that is included with this distribution. 
\*************************************************************************/
#include <stdio.h>
#if (__BORLANDC__)
#undef __STDC__
#include <string.h> /* for strdup(), strcpy() and strncpy() */
#define __STDC__ 0
#else
#include <string.h> /* for strdup(), strcpy() and strncpy() */
#endif
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
/* #include <strings.h>  index()  */
/* #include <malloc.h> */
/* #include <memory.h>  for memcpy()  */

/* for channel access calls */
#include <cadef.h>
#include <caerr.h>

#include <dbDefs.h> /* needed for PVNAME_SZ and FLDNAME_SZ */
#include <db_access.h>

#define epicsExportSharedSymbols
#include <shareLib.h>

#include <ezca.h> /* what all users of EZCA include */

/* Check consistency between our symbols and CA's (the designers of ezca decided not to export the CA API) */
#if EZCA_UNITS_SIZE != MAX_UNITS_SIZE
#error "Inconsistent definition:  our EZCA_UNITS_SIZE does not match CA's MAX_UNITS_SIZE !"
#endif
#if EZCA_ENUM_STATES != MAX_ENUM_STATES
#error "Inconsistent definition:  our EZCA_ENUM_STATES does not match CA's MAX_ENUM_STATES !"
#endif
#if EZCA_ENUM_STRING_SIZE != MAX_ENUM_STRING_SIZE
#error "Inconsistent definition:  our EZCA_ENUM_STRING_SIZE does not match CA's MAX_ENUM_STRING_SIZE !"
#endif


/*
#if defined(WIN32) || defined(_WIN32)
#undef __STDC__
#define __STDC__ 0
#define strdup _strdup
#endif
*/

#if !defined(linux) && !defined(WIN32) && !defined(_WIN32)
extern char *strdup(const char *s1);
#endif

#if 1 && BASE_IS_MIN_VERSION(3,14,0) 
#define EPICS_THREE_FOURTEEN
#include <epicsMutex.h>
#include <epicsEvent.h>
#include <epicsThread.h>
static epicsMutexId	ezcaMutex       = 0;
/* count outstanding CA requests and post 'ezcaDone' when
 * no more requests are outstanding.
 * This is more efficient than ca_pend_event() which always
 * waits for the full timeout to expire. We take advantage
 * of 3.14 being multithreaded here since another CA worker
 * thread handles CA activity for us.
 */
static volatile int ezcaOutstanding = 0;
static epicsEventId ezcaDone        = 0;

#ifndef EZCA_MALLOC_TRACE
#define ezcamalloc	malloc
#define ezcacalloc	calloc
#define ezcafree	free
#endif

#define DEBUG_LOCK 0

#define	EZCA_LOCK() \
	do { \
		if (DEBUG_LOCK)								\
		printf("Thread %s (0x%lx) tries to lock\n",	\
			epicsThreadGetNameSelf(),				\
			(unsigned long)epicsThreadGetIdSelf()); \
		epicsMutexLock(ezcaMutex);					\
	} while (0)
#define	EZCA_UNLOCK()	\
	do { \
		if (DEBUG_LOCK) \
		printf("Thread %s (0x%lx) unlocks\n",		\
			epicsThreadGetNameSelf(),				\
			(unsigned long)epicsThreadGetIdSelf()); \
		epicsMutexUnlock(ezcaMutex); 				\
	} while (0)
#define DO_INIT_ONCE() \
	do { epicsThreadOnce(&Initialized, init, 0); } while (0)

/* remember # of outstanding requests and flush */
#define MARK_OUTSTANDING(n) do { if ( (ezcaOutstanding = (n)) ) ca_flush_io(); } while (0)

/* decrement # of outstanding requests and post 'ezcaDone' when zero is reached */
#define POST_DONE() do { if ( --ezcaOutstanding == 0 ) epicsEventSignal(ezcaDone); if ( ezcaOutstanding < 0 ) { fprintf(stderr,"EZCA FATAL ERROR; no outstanding transaction expected\n"); exit(1); }; } while (0)
#else
#define EZCA_LOCK() \
	do { \
	} while (0)
#define EZCA_UNLOCK() \
	do { \
	} while (0)
#define DO_INIT_ONCE() \
    do { if (!Initialized) init(0); } while (0)
#define MARK_OUTSTANDING(n) do { } while (0)
#define POST_DONE() do { } while (0)
#endif


#define BOOL  char
#define FALSE 0
#define TRUE  1

#define NODESPERMAL 3

/* For Hashing.                                                      */
/* The hash algorithm is the algorithm described in:                 */
/* "Fast Hashing of Variable Length Text Strings", Peter K. Pearson, */
/* Communications of the ACM, June 1990.                             */
/* DO NOT CHANGE THE VALUE OF HASHTABLESIZE!!!!!!!!!                 */
#define HASHTABLESIZE 256

#define SHORT_TIME ((float)1.e-12)
#define MAXPVARNAMELENGTH ((PVNAME_SZ)+(FLDNAME_SZ)+2)

#define UNDEFINED -1

/**************/
/*            */
/* Work Types */
/*            */
/**************/

#define GET                 0
#define PUT                 1
#define GETUNITS            2
#define GETNELEM            3
#define GETPRECISION        4
#define GETGRAPHICLIMITS    5
#define GETCONTROLLIMITS    6
#define GETSTATUS           7
#define GETWITHSTATUS       8
#define SETMONITOR          9
#define CLEARMONITOR        10
#define AUTOERRORMESSAGEOFF 11
#define AUTOERRORMESSAGEON  12
#define DEBUGOFF            13
#define DEBUGON             14
#define DELAY               15
#define FREEMEM             16
#define PVTOCHID            17
#define SETTIMEOUT          18
#define STARTGROUP          19
#define TRACEOFF            20
#define TRACEON             21
#define SETRETRYCOUNT       22
#define GETRETRYCOUNT       23
#define GETTIMEOUT          24
#define PUTOLDCA            25
#define CLEARCHANNEL		26
#define MONBLOCK            27
#define GETWARNLIMITS       28
#define GETALARMLIMITS      29
#define GETENUMSTATES       30

/********************************/
/*                              */
/* for error-printing functions */
/*                              */
/********************************/

/* for ErrorLocation */
#define SINGLEWORK 0
#define LISTWORK   1

/* for ListPrint */
#define LASTONLY  0
#define WHOLELIST 1

#define OKMSG "OK"

#define GET_MSG                 "ezcaGet()"
#define PUT_MSG                 "ezcaPut()"
#define PUTOLDCA_MSG            "ezcaPutOldCa()"
#define GETUNITS_MSG            "ezcaGetUnits()"
#define GETENUMSTATES_MSG       "ezcaGetEnumStrings()"
#define GETNELEM_MSG            "ezcaGetNelem()"
#define GETPRECISION_MSG        "ezcaGetPrecision()"
#define GETGRAPHICLIMITS_MSG    "ezcaGetGraphicLimits()"
#define GETCONTROLLIMITS_MSG    "ezcaGetControlLimits()"
#define GETSTATUS_MSG           "ezcaGetStatus()"
#define GETWITHSTATUS_MSG       "ezcaGetWithStatus()"
#define SETMONITOR_MSG          "ezcaSetMonitor()"
#define CLEARMONITOR_MSG        "ezcaClearMonitor()"
#define AUTOERRORMESSAGEOFF_MSG "ezcaAutoErrorMessageOff()"
#define AUTOERRORMESSAGEON_MSG  "ezcaAutoErrorMessageOn()"
#define DEBUGOFF_MSG            "ezcaDebugOff()"
#define DEBUGON_MSG             "ezcaDebugOn()"
#define DELAY_MSG               "ezcaDelay()"
#define FREEMEM_MSG             "ezcaFree()"
#define PVTOCHID_MSG            "ezcaPvToChid()"
#define SETTIMEOUT_MSG          "ezcaSetTimeout()"
#define STARTGROUP_MSG          "ezcaStartGroup()"
#define TRACEOFF_MSG            "ezcaTraceOff()"
#define TRACEON_MSG             "ezcaTraceOn()"
#define SETRETRYCOUNT_MSG       "ezcaSetRetryCount()"
#define GETRETRYCOUNT_MSG       "ezcaGetRetryCount()"
#define GETTIMEOUT_MSG          "ezcaGetTimeout()"
#define CLEARCHANNEL_MSG		"ezcaClearChannel()"
#define MONBLOCK_MSG			"ezcaNewMontorWait()"
#define GETWARNLIMITS_MSG       "ezcaGetWarnLimits()"
#define GETALARMLIMITS_MSG      "ezcaGetAlarmLimits()"
/* Error Messages */
#define INVALID_PVNAME_MSG  "invalid process variable name"
#define INVALID_TYPE_MSG    "invalid EZCA data type"
#define FAILED_MALLOC_MSG   "unable to allocate memory"
#define INVALID_NELEM_MSG   "invalid number of elements specified"
#define TOO_MANY_NELEM_MSG  "specified too many nelem"
#define INVALID_PBUFF_MSG   "invalid (probably NULL) pointer to user buffer"
#define INVALID_ARG_MSG     "invalid argument received by this function"
#define NOT_CONNECTED_MSG   "channel not currently connected"
#define NO_RESPONSE_IN_TIME_MSG "no response in time"
#define UDFREQ_MSG          "item(s) requested undefined for its native data type"
#define INGROUP_MSG         "currently in a group"
#define NOTINGROUP_MSG      "not currently in a group"
#define NO_PVAR_FOUND_MSG   "could not find process variable"
#define ECA_BADCHID_MSG     "corrupted/disconnected chid"
/* CA detected Error Messages */
#define PROLOGUE_MSG           "prologue()"
#define CAADDARRAYEVENT_MSG    "ca_add_array_event()"
#define CAARRAYGETCALL_MSG     "ca_array_get_callback()"
#define CAARRAYPUTCALL_MSG     "ca_array_put_callback()"
#define CAARRAYPUT_MSG         "ca_array_put()"
#define CASEARCHANDCONNECT_MSG "ca_search_and_connect()"
#define CAPENDIO_MSG           "ca_pend_io()"
#define CAPENDEVENT_MSG        "ca_pend_event()"
#define CAARRAYPUTCALLBACK_MSG "put_callback()"
#define CAARRAYGETCALLBACK_MSG "get_callback()"
/* Additional ezca Messages    */
#define NO_MONITOR_MSG         "no monitor on PV/type found" 
#define ABORTED_MSG            "EZCA call aborted by user"
#define INTERNALERR_MSG        "EZCA internal error"

/************************/
/*                      */
/* Start Error Messages */
/*                      */
/************************/

static char *ErrorMsgs[] =
{
    INVALID_PVNAME_MSG,
    INVALID_TYPE_MSG,
    FAILED_MALLOC_MSG,
    INVALID_NELEM_MSG,
    TOO_MANY_NELEM_MSG,
    INVALID_PBUFF_MSG,
    INVALID_ARG_MSG,
    NOT_CONNECTED_MSG,
    NO_RESPONSE_IN_TIME_MSG,
    UDFREQ_MSG,
    INGROUP_MSG,
    NOTINGROUP_MSG,
    NO_PVAR_FOUND_MSG,
    ECA_BADCHID_MSG,

    CAPENDEVENT_MSG,
    CAADDARRAYEVENT_MSG,
    CAARRAYGETCALL_MSG,
    CAARRAYPUTCALL_MSG,
    CAPENDIO_MSG,
    CAARRAYPUT_MSG,
    CASEARCHANDCONNECT_MSG,
    CAARRAYPUTCALLBACK_MSG,
    CAARRAYGETCALLBACK_MSG,

	NO_MONITOR_MSG,
	ABORTED_MSG,
	INTERNALERR_MSG
};

/* These MUST match the above table */

#define INVALID_PVNAME_MSG_IDX      0
#define INVALID_TYPE_MSG_IDX        1
#define FAILED_MALLOC_MSG_IDX       2
#define INVALID_NELEM_MSG_IDX       3
#define TOO_MANY_NELEM_MSG_IDX      4
#define INVALID_PBUFF_MSG_IDX       5
#define INVALID_ARG_MSG_IDX         6
#define NOT_CONNECTED_MSG_IDX       7
#define NO_RESPONSE_IN_TIME_MSG_IDX 8
#define UDFREQ_MSG_IDX              9
#define INGROUP_MSG_IDX            10
#define NOTINGROUP_MSG_IDX         11
#define NO_PVAR_FOUND_MSG_IDX      12
#define ECA_BADCHID_MSG_IDX        13
#define CAPENDEVENT_MSG_IDX        14
#define CAADDARRAYEVENT_MSG_IDX    15
#define CAARRAYGETCALL_MSG_IDX     16
#define CAARRAYPUTCALL_MSG_IDX     17
#define CAPENDIO_MSG_IDX           18
#define CAARRAYPUT_MSG_IDX         19
#define CASEARCHANDCONNECT_MSG_IDX 20
#define CAARRAYPUTCALLBACK_MSG_IDX 21
#define CAARRAYGETCALLBACK_MSG_IDX 22
#define NO_MONITOR_MSG_IDX         23
#define ABORTED_MSG_IDX            24
#define INTERNALERR_MSG_IDX        25

/**********************/
/*                    */
/* End Error Messages */
/*                    */
/**********************/

/*******************/
/*                 */
/* Data Structures */
/*                 */
/*******************/

typedef enum {
	awaited       = -1,
	old_data      = 0,
	needs_reading = 1
} MON_STATE;

struct monitor
{
	struct work    *waiter;	/* work struct waiting for this monitor */
    struct monitor *left;
    struct monitor *right;
    struct channel *cp; /* for debugging printing only */
    char ezcadatatype;
    char dbr_type;
    evid evd;
    BOOL needs_reading;
    BOOL active; /* only goes active after OK add_event and OK pend_io */
    int last_nelem;
    void *pval;
    /* other info */
    short status;
    short severity;
    epicsTimeStamp time_stamp;
}; /* end struct monitor */

struct channel
{
    struct channel	*next;
    char 		*pvname;
    chid		cid;
	struct monitor *monitor_list;
    int			refcnt;
#define SEARCHED	1
#define CONNECTED	2
    char		ever_successfully_searched;
}; /* end struct channel */

/* map to printable chars at offset 'U'... */
typedef enum { usable=0, trashed='T'-'U', recyclable='R'-'U' } Trash_t;

struct work
{
    struct work *next;
    struct channel *cp;
    int rc;
    char *error_msg;
    char *aux_error_msg;
    Trash_t trashme;
    BOOL needs_work;
    /* the rest filled in based on type of work */
    char dbr_type;
    BOOL reported;
    char *pvname;
    char worktype;
    void *pval;
    int nelem;
    char ezcadatatype;
    char *strp;
    int *intp;
    short *s1p, *s2p;
    double *d1p, *d2p;
    short *status;
    short *severity;
    epicsTimeStamp *tsp;
    chid *pchid;
    evid *pevid;
}; /* end struct work */

struct work_list
{
    struct work *head;
    struct work *tail;
}; /* end struct work_list */

/**************************/
/*                        */
/* Local Global Variables */
/*                        */
/**************************/

#ifdef EPICS_THREE_FOURTEEN
static /*volatile*/ epicsThreadOnceId Initialized = 0;
#else
static BOOL Initialized = FALSE;
#endif

static struct work_list Work_list;
static struct work *Workp;
static struct channel *Channels[HASHTABLESIZE];

static struct channel *Channel_avail_hdr;
static struct monitor *Monitor_avail_hdr;
static struct work *Work_avail_hdr;

static struct channel *Discarded_channels;
static struct monitor *Discarded_monitors;
static struct work *Discarded_work;

static char ErrorLocation;
static char ListPrint;

/* User Configurable Parameters */
static BOOL AutoErrorMessage;
static BOOL InGroup;
static float TimeoutSeconds;
static unsigned volatile RetryCount;
static unsigned SavedRetryCount;

static EzcaPollCb pollCb = 0;

static BOOL Debug;
static BOOL Trace;

/* For Hashing.                                                      */
/* The hash algorithm is the algorithm described in:                 */
/* "Fast Hashing of Variable Length Text Strings", Peter K. Pearson, */
/* Communications of the ACM, June 1990.                             */
static unsigned char RandomNumbers[256] =
{
     39,159,180,252, 71,  6, 13,164,232, 35,226,155, 98,120,154, 69,
    157, 24,137, 29,147, 78,121, 85,112,  8,248,130, 55,117,190,160,
    176,131,228, 64,211,106, 38, 27,140, 30, 88,210,227,104, 84, 77,
     75,107,169,138,195,184, 70, 90, 61,166,  7,244,165,108,219, 51,
      9,139,209, 40, 31,202, 58,179,116, 33,207,146, 76, 60,242,124,
    254,197, 80,167,153,145,129,233,132, 48,246, 86,156,177, 36,187,
     45,  1, 96, 18, 19, 62,185,234, 99, 16,218, 95,128,224,123,253,
     42,109,  4,247, 72,  5,151,136,  0,152,148,127,204,133, 17, 14,
    182,217, 54,199,119,174, 82, 57,215, 41,114,208,206,110,239, 23,
    189, 15,  3, 22,188, 79,113,172, 28,  2,222, 21,251,225,237,105,
    102, 32, 56,181,126, 83,230, 53,158, 52, 59,213,118,100, 67,142,
    220,170,144,115,205, 26,125,168,249, 66,175, 97,255, 92,229, 91,
    214,236,178,243, 46, 44,201,250,135,186,150,221,163,216,162, 43,
     11,101, 34, 37,194, 25, 50, 12, 87,198,173,240,193,171,143,231,
    111,141,191,103, 74,245,223, 20,161,235,122, 63, 89,149, 73,238,
    134, 68, 93,183,241, 81,196, 49,192, 65,212, 94,203, 10,200, 47 
};


/*******************/
/*                 */
/* Local Functions */
/*                 */
/*******************/

/* Utilities */
static void append_to_work_list(struct work *);
static void copy_time_stamp(epicsTimeStamp *, epicsTimeStamp *); /* really should be */
						     /* in tsDefs.h      */
static void empty_work_list(void);
static struct channel *find_channel(char *);
static void get_channel(struct work *, struct channel **);
static BOOL get_from_monitor(struct work *, struct channel *);
static void release_channel(struct channel **);
static struct work *get_work(void);
static struct work *get_work_single(void);
static unsigned char hash(char *);
static void init(void *);
static BOOL issue_get(struct work *, struct channel *);
static void issue_wait(struct work *);
static void print_error(struct work *);
static void prologue(void);
static void epilogue(void);

/* Channel Access Interface Functions */
static int EzcaAddArrayEvent(struct work *, struct monitor *, unsigned long count);
static int EzcaClearChannel(struct channel *);
static int EzcaClearEvent(struct monitor *);
static BOOL EzcaConnected(struct channel *);
static int EzcaArrayGetCallback(struct work *, struct channel *);
static int EzcaArrayPutCallback(struct work *, struct channel *);
static int EzcaArrayPut(struct work *, struct channel *);
static unsigned EzcaElementCount(struct channel *);
static void EzcaInitializeChannelAccess(void);
static int EzcaNativeType(struct channel *);
static int EzcaPendEvent(struct work *, float, BOOL);
static int EzcaPendIO(struct work *, float);
static int EzcaQueueSearchAndConnect(struct work *, struct channel *);

/* Callbacks */
static void my_connection_callback(struct connection_handler_args);
static void my_get_callback(struct event_handler_args);
static void my_monitor_callback(struct event_handler_args);
static void my_put_callback(struct event_handler_args);

/* Memory Management */
static void clean_and_push_channel(struct channel **);
static void clean_and_push_monitor(struct monitor *);
static struct channel *pop_channel(void);
static struct monitor *pop_monitor(void);
static struct work *pop_work(void);
static void init_work(struct work *);
static void push_channel(struct channel *, struct channel**);
static void push_monitor(struct monitor *, struct monitor**);
static void push_work(struct work *);
static void recycle_work(struct work *);

/* Debugging */
static void print_avails(void);
static void print_channel_avail(void);
static void print_channels(void);
static void print_discarded_channels(void);
static void print_discarded_monitors(void);
static void print_discarded_work(void);
static void print_monitor_avail(void);
static void print_state(void);
static void print_work_avail(void);
static void print_work_list(void);
static void print_workp(void);

/********************************/
/*                              */
/* Externally Visible Functions */
/*         EZCA API             */
/*                              */
/********************************/

/***************************************************************/
/*                                                             */
/* Immediate Functions                                         */
/*                                                             */
/* These do not allocate any work, so do not store error msgs, */
/* nor do they change ErrorLocation.                           */
/* These are executed immediately, without respect to InGroup  */
/* context.                                                    */
/*                                                             */
/***************************************************************/

/****************************************************************
*
*
****************************************************************/

void epicsShareAPI ezcaLock()
{
	DO_INIT_ONCE();
	EZCA_LOCK();
}

void epicsShareAPI ezcaUnlock()
{
	EZCA_LOCK();
}

/* this is intended to be called from a signal handler
 * which must not do any memory management nor access
 * any internal data structures.
 *
 * Usage:
 *
 *   static void sighandler()
 *   {
 *         ezcaAbort();
 *   }
 *
 *   main()
 *   {
 *      orig = signal(SIGINT, handler);
 *       / * "interruptable" ezca calls go here * /
 *      signal(SIGINT, orig);
 *   }
 */
void epicsShareAPI ezcaAbort()
{
	RetryCount = 0;
}

EzcaPollCb epicsShareAPI ezcaPollCbInstall(EzcaPollCb newCb)
{
EzcaPollCb rval;
#ifdef EPICS_THREE_FOURTEEN
epicsThreadOnceId i;
#else
int	i;
#endif

/* give them the option to call this prior to initializing the library */
if ( (i=Initialized) )
	EZCA_LOCK();

	rval = pollCb;
	pollCb = newCb;

if (i)
	EZCA_UNLOCK();

	return rval;
}

int epicsShareAPI ezcaEndGroup()
{
	/* ezcaEndGroupWithReport is mutexed */
	return ezcaEndGroupWithReport((int **) NULL, (int *) NULL);
} /* end ezcaEndGroup() */

/****************************************************************
*
*
****************************************************************/

int epicsShareAPI ezcaEndGroupWithReport(int **rcs, int *nrcs)
{

struct work *wp;
int needs_work;
int status = 0;
unsigned attempts;
unsigned int nelem;
unsigned int i;
BOOL all_reported, error;
int issued_a_search;
unsigned char hi;
int rc;

    prologue();

    if (InGroup)
    {
	/* in a group */

	if (Trace || Debug)
    printf("ezcaEndGroupWithReport() about to process work list\n");

	for (wp = Work_list.head; wp; wp = wp->next) {
		if ( wp->cp ) {
			fprintf(stderr,"EZCA FATAL ERROR: ezcaEndGroupWithReport() found non-NULL wp->cp\n");
			exit(1);
		}
	}

	/* searching for all the channels */
	for (wp = Work_list.head, nelem = 0, issued_a_search = 0; 
	    wp; wp = wp->next)
	{
	    nelem ++;

	    if (wp->rc == EZCA_OK)
	    {
		/* all input args OK */
		if ((wp->cp = find_channel(wp->pvname)))
		{
		    if (Trace || Debug)
	printf("ezcaEndGroupWithReport() was able to find_channel() >%s<\n", 
			wp->pvname);
		}
		else
		{
		    /* not in Channels  must ca_search_and_connect() and add */
		    if (Trace || Debug)
printf("ezcaEndGroupWithReport() could not find_channel() >%s< must ca_search_and_connect() and add\n", wp->pvname);
		    if ((wp->cp = pop_channel()))
		    {
			if (((wp->cp)->pvname = strdup(wp->pvname)))
			{
			    if (EzcaQueueSearchAndConnect(wp, wp->cp) 
				    == ECA_NORMAL)
			    {
				issued_a_search++;

				/* adding to Channels */
				hi = hash((wp->cp)->pvname);
				(wp->cp)->next = Channels[hi];
				Channels[hi] = wp->cp;
			    }
			    else
			    {
				if ( wp->cp->ever_successfully_searched ) {
					/* MARK_OUTSTANDING() is only issued
					 * below when we know the number of
					 * outstanding search requests. Hence
					 * we must make sure not to release the
					 * library mutex before we can MARK
					 */
					fprintf(stderr,"EZCA FATAL ERROR: clean_and_push_channel would release library MUTEX here\n");
					exit (1);
				}
				/* something went wrong ... rc and */
				/* error msg have already been set */

				EZCA_LOCK(); /* make *sure* mutex is not relinquished by adding a nest count */
				clean_and_push_channel(&wp->cp);
				EZCA_UNLOCK();
			    } /* endif */
			}
			else
			{
			    wp->rc = EZCA_FAILEDMALLOC;
			    wp->error_msg = ErrorMsgs[FAILED_MALLOC_MSG_IDX];

			    if (AutoErrorMessage)
				print_error(wp);
			} /* endif */
		    }
		    else
		    {
			wp->rc = EZCA_FAILEDMALLOC;
			wp->error_msg = ErrorMsgs[FAILED_MALLOC_MSG_IDX];

			if (AutoErrorMessage)
			    print_error(wp);
		    } /* endif */
		} /* endif */
	    } /* endif */
	} /* endfor */

	/* waiting for all searches to connect */
	if (issued_a_search)
	{
		MARK_OUTSTANDING(issued_a_search);

	    for (all_reported = FALSE, attempts = 0; 
		!all_reported && attempts <= RetryCount; attempts ++)
	    {
		if (Trace || Debug)
		    printf("ezcaEndGroupWithReport() search attempt %d of %d\n",
			attempts+1, RetryCount+1);

		EzcaPendEvent((struct work *) NULL, TimeoutSeconds, FALSE);

		for (all_reported = TRUE, wp = Work_list.head; 
		    all_reported && wp; 
			wp = wp->next)
		    /* (wp->rc = OK) ==> (wp->cp is connected) */
		    all_reported = (wp->rc != EZCA_OK 
			|| (wp->cp ? EzcaConnected(wp->cp) : FALSE));
	    } /* endfor */

		/* Make sure 'report-required' flag (puser!=0) is
		 * cleared on all channels
		 */
		for ( wp = Work_list.head; wp; wp=wp->next ) {
			if ( wp->cp && wp->cp->cid ) {
				ca_set_puser(wp->cp->cid, 0);
			}
		}
	} /* endif */

	/* identifying those that were not able to connect */
	for (wp = Work_list.head; wp; wp = wp->next)
	{

	    if (wp->rc == EZCA_OK && wp->cp && !EzcaConnected(wp->cp))
	    {

	        if ( CONNECTED == wp->cp->ever_successfully_searched )
	        {
		   	    wp->rc = EZCA_NOTCONNECTED;
	            wp->error_msg = ErrorMsgs[NOT_CONNECTED_MSG_IDX];
	        }
	        else
	        {
	            /* remove */
	            clean_and_push_channel( &wp->cp );

				if ( RetryCount )
				{
	            	wp->rc = EZCA_NOTIMELYRESPONSE;
	            	wp->error_msg = ErrorMsgs[NO_PVAR_FOUND_MSG_IDX];
				}
				else
				{
	            	wp->rc = EZCA_ABORTED;
	            	wp->error_msg = ErrorMsgs[ABORTED_MSG_IDX];
				}
	        }

		    wp->aux_error_msg = strdup(wp->pvname);

		    if (AutoErrorMessage)
		        print_error(wp);
	    } /* endif */
	} /* endfor */

	/* issuing the work for those that are still EZCA_OK */
	for (wp = Work_list.head; wp; wp = wp->next)
	{
	    if (wp->rc == EZCA_OK)
	    {
		switch (wp->worktype)
		{
		    case GET:
		    case GETWITHSTATUS:
			if (get_from_monitor(wp, wp->cp))
			{
			    if (Trace || Debug)
    printf("ezcaEndGroupWithReport(): found an active monitor with a value for >%s<\n", 
		wp->pvname);
			    wp->needs_work = FALSE;
			}
			else
			{
			    if (Trace || Debug)
printf("ezcaEndGroupWithReport(): did not find an active monitor with a value for >%s<\n",
				wp->pvname);

			    wp->needs_work = issue_get(wp, wp->cp);
			} /* endif */
			break;
		    case GETCONTROLLIMITS:
		    case GETGRAPHICLIMITS:
		    case GETPRECISION:
		    case GETUNITS:
			case GETWARNLIMITS:
			case GETALARMLIMITS:
			wp->nelem = 1; /* = EzcaElementCount(wp->cp); */
			wp->needs_work = issue_get(wp, wp->cp);
			break;
			case GETENUMSTATES:
				if ( DBF_ENUM != EzcaNativeType(wp->cp) ) {
					wp->strp[0] = 0;
					wp->needs_work = FALSE;
				} else {
					wp->nelem = 1;
					wp->needs_work = issue_get(wp, wp->cp);
				}
			break;
		    case GETNELEM:
			*wp->intp = wp->nelem = EzcaElementCount(wp->cp);
			wp->needs_work = FALSE;
			break;
		    case GETSTATUS:
			if (get_from_monitor(wp, wp->cp))
			{
			    if (Trace || Debug)
    printf("ezcaEndGroupWithReport(): found an active monitor with a value for >%s<\n", 
		wp->pvname);
			    wp->needs_work = FALSE;
			}
			else
			{
			    if (Trace || Debug)
printf("ezcaEndGroupWithReport(): did not find an active monitor with a value for >%s<\n",
				wp->pvname);

			    wp->nelem = 1; /* = EzcaElementCount(wp->cp); */
			    wp->needs_work = issue_get(wp, wp->cp);
			} /* endif */
			break;
		    case PUT:
			if (wp->nelem <= (int)EzcaElementCount(wp->cp))
			{
			    wp->reported = FALSE;
			    if (EzcaArrayPutCallback(wp, wp->cp) == ECA_NORMAL)
				wp->needs_work = TRUE;
			    else
			    {
				/* something went wrong ... rc and */
				/* error msg have already been set */

				/* need to trash this wp so it's */
				/* never used again in case the  */
				/* callback fires off later      */

				wp->needs_work = FALSE;
				wp->trashme = trashed;
				if (Debug)
				    printf("trashing wp %p\n", wp);

			    } /* endif */
			}
			else
			{
			    /* too many elements requested */
			    wp->rc = EZCA_INVALIDARG;
			    wp->error_msg = ErrorMsgs[TOO_MANY_NELEM_MSG_IDX];

			    if (AutoErrorMessage)
				print_error(wp);
			} /* endif */
			break;
		    case PUTOLDCA:
			wp->needs_work = FALSE;
			if (wp->nelem <= (int)EzcaElementCount(wp->cp))
			    EzcaArrayPut(wp, wp->cp);
			else
			{
			    /* too many elements requested */
			    wp->rc = EZCA_INVALIDARG;
			    wp->error_msg = ErrorMsgs[TOO_MANY_NELEM_MSG_IDX];

			    if (AutoErrorMessage)
				print_error(wp);
			} /* endif */
			break;

			case MONBLOCK:
				{ struct monitor *mp;

					wp->reported = FALSE;

					mp = wp->cp->monitor_list;

					while (mp && ( ! (wp->ezcadatatype == mp->ezcadatatype) || !mp->active))
						mp = mp->right;
					if ( !mp ) {
						wp->rc = EZCA_INVALIDARG;
						wp->error_msg = ErrorMsgs[NO_MONITOR_MSG_IDX];
						if (AutoErrorMessage)
							print_error(wp);
					} else {
						if ( (wp->needs_work = !mp->needs_reading) ) {
							wp->pval   = mp;
							if ( mp->waiter ) {
								fprintf(stderr,"EZCA FATAL ERROR: mp->waiter is already set\n");
								exit(1);
							}
							mp->waiter = wp;
						} else {
							wp->pval = NULL;
						}
					}
				}
			break;
		    default:
			fprintf(stderr,
"EZCA FATAL ERROR: ezcaEndGroupWithReport() found invalid worktype %d in group list\n",
			    wp->worktype);
			exit(1);
			break;
		} /* end switch() */
	    } /* endif */
	} /* endor */

	/* looking for work that is still EZCA_OK and needs_work */
	for (wp = Work_list.head, needs_work = 0; wp ; wp = wp->next)
	{
		if (wp->rc == EZCA_OK && wp->needs_work)
			needs_work++;
	}

	if (needs_work)
	{
	    if (Trace || Debug)
		printf("ezcaEndGroupWithReport() found work\n");

		MARK_OUTSTANDING(needs_work);

	    for (all_reported = FALSE, error = FALSE, attempts = 0;
		!all_reported && !error && attempts <= RetryCount; 
		    attempts ++)
	    {
		if (Trace || Debug)
		    printf("ezcaEndGroupWithReport(): attempt %d of %d\n", 
			attempts+1, RetryCount+1);

		status = EzcaPendEvent((struct work *) NULL, TimeoutSeconds, FALSE);

		if (status == ECA_TIMEOUT)
		{
		    /* normal completion ... must identify all wp's whose    */
		    /* rc is currently EZCA_OK and needs_work and check      */
		    /* their reported                                        */

		    for (all_reported = TRUE, wp = Work_list.head; 
			all_reported && wp; 
			    wp = wp->next)
			/* (EZCA_OK && needs_work) ===> reported */
			all_reported = 
		    (!(wp->rc == EZCA_OK && wp->needs_work) || wp->reported);
		}
		else
		    error = TRUE;
	    } /* endfor */

	    if (error)
	    {
		/* abnormal completion ... must identify all wp's whose */
		/* rc is currently EZCA_OK and needs_work and set       */
		/* their rc's appropriately and trash_them              */

		for (wp = Work_list.head; wp; wp = wp->next)
		{
		    if (wp->rc == EZCA_OK && wp->needs_work)
		    {
				if ( MONBLOCK == wp->worktype && wp->pval )
				{
				struct monitor *mp = wp->pval;
				/* no need to trash (no callback has a pointer to this
				 * work node). Just clear the 'waiter'...
				 */
				mp->waiter = (struct work *)NULL;
				wp->pval = 0;
				}
				else
				{
				wp->trashme = trashed;

				if (Debug)
					printf("trashing wp %p\n", wp);

				}
			wp->rc = EZCA_CAFAILURE;
			wp->error_msg = ErrorMsgs[CAPENDEVENT_MSG_IDX];
			wp->aux_error_msg = strdup(ca_message(status));

			if (AutoErrorMessage)
			    print_error(wp);
		    } /* endif */
		} /* endfor */
	    }
	    else
	    {
		/* normal completion ... must identify all wp's whose    */
		/* rc is currently EZCA_OK and needs_work and check      */
		/* their reported flags and set their rc's appropriately */
		for (wp = Work_list.head; wp; wp = wp->next)
		{
		    if (wp->rc == EZCA_OK && wp->needs_work)
		    {
			if (!(wp->reported))
			{
			    /* callback did not respond back */
			    /* int time no value received    */

			    /* need to trash this wp so it's */
			    /* never used again in case the  */
			    /* callback fires off later      */
				if ( RetryCount )
				{
			    	wp->rc = EZCA_NOTIMELYRESPONSE;
			    	wp->error_msg = 
					ErrorMsgs[NO_RESPONSE_IN_TIME_MSG_IDX];
				}
				else
				{
	            	wp->rc = EZCA_ABORTED;
	            	wp->error_msg = ErrorMsgs[ABORTED_MSG_IDX];
				}

			    if (AutoErrorMessage)
				print_error(wp);

				if ( MONBLOCK == wp->worktype && wp->pval )
				{
				struct monitor *mp = wp->pval;
				/* no need to trash (no callback has a pointer to this
				 * work node). Just clear the 'waiter'...
				 */
				mp->waiter = (struct work *)NULL;
				wp->pval = 0;
				}
				else
				{
			    wp->trashme = trashed;

			    if (Debug)
				printf("trashing wp %p\n", wp);
				}
			} /* endif */
		    } /* endif */
		} /* endfor */
	    } /* endif */
	}
	else
	{
	    if (Trace || Debug)
		printf("ezcaEndGroupWithReport() found no work\n");
	} /* endif */

	if (nrcs)
	    *nrcs = nelem;

	if (rcs)
	    *rcs = (int *) ezcamalloc(nelem*sizeof(int));

	for (i = 0, wp = Work_list.head, rc = EZCA_OK; wp; wp = wp->next, i ++)
	{
	    /* setting rc to first encoutered problem or EZCA_OK */
	    if (rc == EZCA_OK && wp->rc != EZCA_OK)
		rc = wp->rc;

	    if (rcs && *rcs)
		(*rcs)[i] = wp->rc;

	    /* clearing all the malloc'd memory in PUT works */
	    if ( (wp->worktype == PUT || wp->worktype == PUTOLDCA) && wp->pval)
	    {
		ezcafree((char *) wp->pval);
		wp->pval = (void *) NULL;
	    } /* endif */
	} /* endfor */

	if (Trace || Debug)
    printf("ezcaEndGroupWithReport() setting ErrorLocation LIST and clearing InGroup\n");

	ErrorLocation = LISTWORK;
	ListPrint = WHOLELIST;
	InGroup = FALSE;

	/* release all channel structs we reference */
	for (wp = Work_list.head; wp; wp = wp->next) {
		release_channel( & wp->cp );
	}

    }
    else
    {
	/* not in a group */
	rc = EZCA_NOTINGROUP;

	if (nrcs)
	    *nrcs = -1;

	if (rcs)
	    *rcs = (int *) NULL;

	if (AutoErrorMessage)
	    printf("%s\n", NOTINGROUP_MSG);
    } /* endif */

    epilogue();
    return rc;

} /* end endgroup() */

/****************************************************************
*
* if there are no errors to report (no work done) retuns NULL in **buff
* with EZCA_OK.
*
****************************************************************/

int epicsShareAPI ezcaGetErrorString(char *prefix, char **buff)
{

struct work *wp;
char *wtm;
char *cp;
size_t nbytes;
int rc;

    prologue();

    if (buff)
    {
	/* calculating size of buffer */

	nbytes = 0;

	if (ErrorLocation == SINGLEWORK)
	{
	    /* using Workp */

	    if (Debug)
		printf("ezcaGetErrorString() using SINGLEWORK (Workp)\n");
		
	    if (Workp)
	    {
		wp = Workp;
		switch (wp->worktype)
		{
		    case GET:              wtm = GET_MSG;              break;
		    case PUT:              wtm = PUT_MSG;              break;
		    case PUTOLDCA:         wtm = PUTOLDCA_MSG;         break;
		    case GETUNITS:         wtm = GETUNITS_MSG;         break;
		    case GETENUMSTATES:    wtm = GETENUMSTATES_MSG;    break;
		    case GETNELEM:         wtm = GETNELEM_MSG;         break;
		    case GETPRECISION:     wtm = GETPRECISION_MSG;     break;
		    case GETGRAPHICLIMITS: wtm = GETGRAPHICLIMITS_MSG; break;
		    case GETCONTROLLIMITS: wtm = GETCONTROLLIMITS_MSG; break;
		    case GETWARNLIMITS:    wtm = GETWARNLIMITS_MSG;    break;
		    case GETALARMLIMITS:   wtm = GETALARMLIMITS_MSG;   break;
		    case GETSTATUS:        wtm = GETSTATUS_MSG;        break;
		    case GETWITHSTATUS:    wtm = GETWITHSTATUS_MSG;    break;
		    case SETMONITOR:       wtm = SETMONITOR_MSG;       break;
		    case CLEARMONITOR:     wtm = CLEARMONITOR_MSG;     break;
		    case AUTOERRORMESSAGEOFF: 
			wtm = AUTOERRORMESSAGEOFF_MSG;                 break;
		    case AUTOERRORMESSAGEON:     
			wtm = AUTOERRORMESSAGEON_MSG;                  break;
		    case DEBUGOFF:         wtm = DEBUGOFF_MSG;         break;
		    case DEBUGON:          wtm = DEBUGON_MSG;          break;
		    case DELAY:            wtm = DELAY_MSG;            break;
		    case FREEMEM:          wtm = FREEMEM_MSG;  break;
		    case PVTOCHID:         wtm = PVTOCHID_MSG;         break;
		    case SETTIMEOUT:       wtm = SETTIMEOUT_MSG;       break;
		    case STARTGROUP:       wtm = STARTGROUP_MSG;       break;
		    case CLEARCHANNEL:     wtm = CLEARCHANNEL_MSG;     break;
		    case MONBLOCK:         wtm = MONBLOCK_MSG;         break;
		    case TRACEOFF:         wtm = TRACEOFF_MSG;         break;
		    case TRACEON:          wtm = TRACEON_MSG;          break;
		    case SETRETRYCOUNT:    wtm = SETRETRYCOUNT_MSG;    break;
		    case GETRETRYCOUNT:    wtm = GETRETRYCOUNT_MSG;    break;
		    case GETTIMEOUT:       wtm = GETTIMEOUT_MSG;       break;
		    default:
			fprintf(stderr, 
	"EZCA FATAL ERROR: ezcaGetErrorString() found invalid worktype %d\n", 
			    wp->worktype);
			exit(1);
			break;
		} /* end switch() */

		nbytes = nbytes 
			    + (prefix ? strlen(prefix) : 0) + 1
			    + strlen(wtm) + 2
			    + (wp->rc == EZCA_OK 
				? strlen(OKMSG) 
				: (strlen(wp->error_msg) 
				    + (wp->aux_error_msg 
					? strlen(wp->aux_error_msg)+3 
					: 0)))
			    + 1; /* for <CR> or NULL character */

	    } /* endif */
	}
	else
	{
	    /* using Work_list */

	    if (Debug)
		printf("ezcaGetErrorString() using LISTWORK (Work_list)\n");

	    for (wp = (ListPrint == WHOLELIST ? Work_list.head: Work_list.tail); 
		    wp; wp = wp->next)
	    {
		switch (wp->worktype)
		{
		    case GET:              wtm = GET_MSG;              break;
		    case PUT:              wtm = PUT_MSG;              break;
		    case PUTOLDCA:         wtm = PUTOLDCA_MSG;         break;
		    case GETUNITS:         wtm = GETUNITS_MSG;         break;
		    case GETENUMSTATES:    wtm = GETENUMSTATES_MSG;    break;
		    case GETNELEM:         wtm = GETNELEM_MSG;         break;
		    case GETPRECISION:     wtm = GETPRECISION_MSG;     break;
		    case GETGRAPHICLIMITS: wtm = GETGRAPHICLIMITS_MSG; break;
		    case GETCONTROLLIMITS: wtm = GETCONTROLLIMITS_MSG; break;
		    case GETWARNLIMITS:    wtm = GETWARNLIMITS_MSG;    break;
		    case GETALARMLIMITS:   wtm = GETALARMLIMITS_MSG;   break;
		    case GETSTATUS:        wtm = GETSTATUS_MSG;        break;
		    case GETWITHSTATUS:    wtm = GETWITHSTATUS_MSG;    break;
		    case SETMONITOR:       wtm = SETMONITOR_MSG;       break;
		    case CLEARMONITOR:     wtm = CLEARMONITOR_MSG;     break;
		    case AUTOERRORMESSAGEOFF: 
			wtm = AUTOERRORMESSAGEOFF_MSG;                 break;
		    case AUTOERRORMESSAGEON:     
			wtm = AUTOERRORMESSAGEON_MSG;                  break;
		    case DEBUGOFF:         wtm = DEBUGOFF_MSG;         break;
		    case DEBUGON:          wtm = DEBUGON_MSG;          break;
		    case DELAY:            wtm = DELAY_MSG;            break;
		    case FREEMEM:          wtm = FREEMEM_MSG;  break;
		    case PVTOCHID:         wtm = PVTOCHID_MSG;         break;
		    case SETTIMEOUT:       wtm = SETTIMEOUT_MSG;       break;
		    case STARTGROUP:       wtm = STARTGROUP_MSG;       break;
		    case CLEARCHANNEL:     wtm = CLEARCHANNEL_MSG;     break;
		    case MONBLOCK:         wtm = MONBLOCK_MSG;         break;
		    case TRACEOFF:         wtm = TRACEOFF_MSG;         break;
		    case TRACEON:          wtm = TRACEON_MSG;          break;
		    case SETRETRYCOUNT:    wtm = SETRETRYCOUNT_MSG;    break;
		    case GETRETRYCOUNT:    wtm = GETRETRYCOUNT_MSG;    break;
		    case GETTIMEOUT:       wtm = GETTIMEOUT_MSG;       break;
		    default:
			fprintf(stderr, 
	"EZCA FATAL ERROR: ezcaGetErrorString() found invalid worktype %d\n", 
			    wp->worktype);
			exit(1);
			break;
		} /* end switch() */

		nbytes = nbytes 
			    + (prefix ? strlen(prefix) : 0) + 1
			    + strlen(wtm) + 2
			    + (wp->rc == EZCA_OK 
				? strlen(OKMSG) 
				: (strlen(wp->error_msg)
				    + (wp->aux_error_msg 
					? strlen(wp->aux_error_msg)+3 
					: 0)))
			    + 1; /* for <CR> or NULL character */

	    } /* endfor */
	} /* endif */

	if (nbytes > 0)
	{
	    if ((*buff = ezcacalloc(nbytes, 1)))
	    {
		if (Debug)
	    printf("ezcaGetErrorString() just allocated %ld bytes\n", 
		    (long)nbytes);

		/* filling the buffer */

		if (ErrorLocation == SINGLEWORK)
		{
		    /* using Workp */
		    if (Workp)
		    {
			wp = Workp;
			cp = *buff;

			switch (wp->worktype)
			{
			    case GET:              
				wtm = GET_MSG;                 break;
			    case PUT:              
				wtm = PUT_MSG;                 break;
			    case PUTOLDCA:         
				wtm = PUTOLDCA_MSG;            break;
			    case GETUNITS:         
				wtm = GETUNITS_MSG;            break;
			    case GETENUMSTATES:         
				wtm = GETENUMSTATES_MSG;       break;
			    case GETNELEM:         
				wtm = GETNELEM_MSG;            break;
			    case GETPRECISION:     
				wtm = GETPRECISION_MSG;        break;
			    case GETGRAPHICLIMITS: 
				wtm = GETGRAPHICLIMITS_MSG;    break;
			    case GETCONTROLLIMITS: 
				wtm = GETCONTROLLIMITS_MSG;    break;
		    	case GETWARNLIMITS:
				wtm = GETWARNLIMITS_MSG;       break;
			    case GETALARMLIMITS:
				wtm = GETALARMLIMITS_MSG;      break;
			    case GETSTATUS:        
				wtm = GETSTATUS_MSG;           break;
			    case GETWITHSTATUS:    
				wtm = GETWITHSTATUS_MSG;       break;
			    case SETMONITOR:       
				wtm = SETMONITOR_MSG;          break;
			    case CLEARMONITOR:     
				wtm = CLEARMONITOR_MSG;        break;
			    case AUTOERRORMESSAGEOFF: 
				wtm = AUTOERRORMESSAGEOFF_MSG; break;
			    case AUTOERRORMESSAGEON:     
				wtm = AUTOERRORMESSAGEON_MSG;  break;
			    case DEBUGOFF:         
				wtm = DEBUGOFF_MSG;            break;
			    case DEBUGON:          
				wtm = DEBUGON_MSG;             break;
			    case DELAY:            
				wtm = DELAY_MSG;               break;
			    case FREEMEM:  
				wtm = FREEMEM_MSG;             break;
			    case PVTOCHID:         
				wtm = PVTOCHID_MSG;            break;
			    case SETTIMEOUT:       
				wtm = SETTIMEOUT_MSG;          break;
			    case STARTGROUP:       
				wtm = STARTGROUP_MSG;          break;
		    	case CLEARCHANNEL:
			    wtm = CLEARCHANNEL_MSG;        break;
		    	case MONBLOCK:
				wtm = MONBLOCK_MSG;            break;
			    case TRACEOFF:         
				wtm = TRACEOFF_MSG;            break;
			    case TRACEON:          
				wtm = TRACEON_MSG;             break;
			    case SETRETRYCOUNT:    
				wtm = SETRETRYCOUNT_MSG;       break;
			    case GETRETRYCOUNT:    
				wtm = GETRETRYCOUNT_MSG;       break;
			    case GETTIMEOUT:       
				wtm = GETTIMEOUT_MSG;          break;
			    default:
				fprintf(stderr, 
	"EZCA FATAL ERROR: ezcaGetErrorString() found invalid worktype %d\n", 
				    wp->worktype);
				exit(1);
				break;
			} /* end switch() */

			if (prefix)
			{
			    strcat(cp, prefix);
			    cp += strlen(prefix);
			} /* endif */

			strcat(cp, " ");
			cp ++;

			strcat(cp, wtm);
			cp += strlen(wtm);

			strcat(cp, ": ");
			cp += 2;

			if (wp->rc == EZCA_OK)
			{
			    strcat(cp, OKMSG);
			    cp += strlen(OKMSG);
			}
			else
			{
			    strcat(cp, wp->error_msg);
			    cp += strlen(wp->error_msg);
			    if (wp->aux_error_msg)
			    {
				strcat(cp, " : ");
				cp += 3;

				strcat(cp, wp->aux_error_msg);
				cp += strlen(wp->aux_error_msg);
			    } /* endif */
			} /* endif */

			*cp = '\0';
		    }
		    else
		    {
			fprintf(stderr, 
"EZCA FATAL ERROR: ezcaGetErrorString() found NULL Workp when known to be non-NULL\n");
			exit(1);
		    } /* endif */
		}
		else
		{
		    /* using Work_list */
		    for (cp = *buff, 
		wp = (ListPrint == WHOLELIST ? Work_list.head : Work_list.tail);
			wp; wp = wp->next)
		    {
			switch (wp->worktype)
			{
			    case GET:              
				wtm = GET_MSG;                 break;
			    case PUT:              
				wtm = PUT_MSG;                 break;
			    case PUTOLDCA:         
				wtm = PUTOLDCA_MSG;            break;
			    case GETUNITS:         
				wtm = GETUNITS_MSG;            break;
			    case GETENUMSTATES:         
				wtm = GETENUMSTATES_MSG;       break;
			    case GETNELEM:         
				wtm = GETNELEM_MSG;            break;
			    case GETPRECISION:     
				wtm = GETPRECISION_MSG;        break;
			    case GETGRAPHICLIMITS: 
				wtm = GETGRAPHICLIMITS_MSG;    break;
			    case GETCONTROLLIMITS: 
				wtm = GETCONTROLLIMITS_MSG;    break;
		    	case GETWARNLIMITS:
				wtm = GETWARNLIMITS_MSG;       break;
			    case GETALARMLIMITS:
				wtm = GETALARMLIMITS_MSG;      break;
			    case GETSTATUS:        
				wtm = GETSTATUS_MSG;           break;
			    case GETWITHSTATUS:    
				wtm = GETWITHSTATUS_MSG;       break;
			    case SETMONITOR:       
				wtm = SETMONITOR_MSG;          break;
			    case CLEARMONITOR:     
				wtm = CLEARMONITOR_MSG;        break;
			    case AUTOERRORMESSAGEOFF: 
				wtm = AUTOERRORMESSAGEOFF_MSG; break;
			    case AUTOERRORMESSAGEON:     
				wtm = AUTOERRORMESSAGEON_MSG;  break;
			    case DEBUGOFF:         
				wtm = DEBUGOFF_MSG;            break;
			    case DEBUGON:          
				wtm = DEBUGON_MSG;             break;
			    case DELAY:               
				wtm = DELAY_MSG;               break;
			    case FREEMEM:  
				wtm = FREEMEM_MSG;             break;
			    case PVTOCHID:         
				wtm = PVTOCHID_MSG;            break;
			    case SETTIMEOUT:       
				wtm = SETTIMEOUT_MSG;          break;
			    case STARTGROUP:       
				wtm = STARTGROUP_MSG;          break;
		    	case CLEARCHANNEL:
			    wtm = CLEARCHANNEL_MSG;        break;
		    	case MONBLOCK:
				wtm = MONBLOCK_MSG;            break;
			    case TRACEOFF:         
				wtm = TRACEOFF_MSG;            break;
			    case TRACEON:          
				wtm = TRACEON_MSG;             break;
			    case SETRETRYCOUNT:    
				wtm = SETRETRYCOUNT_MSG;       break;
			    case GETRETRYCOUNT:    
				wtm = GETRETRYCOUNT_MSG;       break;
			    case GETTIMEOUT:       
				wtm = GETTIMEOUT_MSG;          break;
			    default:
				fprintf(stderr, 
	"EZCA FATAL ERROR: ezcaGetErrorString() found invalid worktype %d\n", 
				    wp->worktype);
				exit(1);
				break;
			} /* end switch() */

			if (prefix)
			{
			    strcat(cp, prefix);
			    cp += strlen(prefix);
			} /* endif */

			strcat(cp, " ");
			cp ++;

			strcat(cp, wtm);
			cp += strlen(wtm);

			strcat(cp, ": ");
			cp += 2;

			if (wp->rc == EZCA_OK)
			{
			    strcat(cp, OKMSG);
			    cp += strlen(OKMSG);
			}
			else
			{
			    strcat(cp, wp->error_msg);
			    cp += strlen(wp->error_msg);

			    if (wp->aux_error_msg)
			    {
				strcat(cp, " : ");
				cp += 3;

				strcat(cp, wp->aux_error_msg);
				cp += strlen(wp->aux_error_msg);

			    } /* endif */
			} /* endif */

			if (wp->next)
			{
			    *cp = '\n';
			    cp ++;
			} 
			else
			{
			    *cp = '\0';
			    cp ++;
			} /* endif */

		    } /* endfor */
		} /* endif */

		rc = EZCA_OK;
	    }
	    else
	    {
		rc = EZCA_FAILEDMALLOC;

		if (AutoErrorMessage)
		    printf("%s\n", FAILED_MALLOC_MSG);
	    } /* endif */
	}
	else
	{

	    rc = EZCA_OK;

	    *buff = (char *) NULL;

	    if (Trace || Debug)
		printf("ezcaGetErrorString() found no work\n");
	} /* endif */
    }
    else
    {
	rc = EZCA_INVALIDARG;

	if (AutoErrorMessage)
	    printf("%s\n", INVALID_ARG_MSG);
    } /* endif */

    epilogue();
    return rc;

} /* end ezcaGetErrorString() */

/****************************************************************
*
* because this function returns TRUE/FALSE, it does not conform to
* the normal error message scheme of the rest of the functions.
* for this reason it does not get a work node and is therefore
* classified as an immediate function (rather than a non-groupable
* work function).
*
* the user wishes to know if he needs to read the value that he
* presumably set a monitor on.  this function returns TRUE (needs 
* reading) or FALSE.
*
* It always error towards forcing the read ... if anything goes wrong,
* it returns -1.
*
* It returns FALSE iff there is an existing monitor that does not 
* need reading ... otherwise returns TRUE (no channel, invalid args, ...)
*
****************************************************************/

int epicsShareAPI ezcaNewMonitorValue(char *pvname, char type)
{

struct channel *cp;
struct monitor *mp;
BOOL found;
int rc;

    prologue();

    if (pvname)
    {
	if (VALID_EZCA_DATA_TYPE(type))
	{
	    if ((cp = find_channel(pvname)))
	    {
		mp = cp->monitor_list;
		found = FALSE;
		while (mp && !found)
		    if (!(found = (type == mp->ezcadatatype)))
			mp = mp->right;

		if (found)
		    rc = (int) mp->needs_reading;
		else
		{
		    /* no monitor */

		    if (Trace || Debug)
	printf("ezcaNewMonitorValue() found no monitor name >%s< type %d\n",
			pvname, type);

		    rc = -1;
		} /* endif */
		release_channel(&cp);
	    }
	    else
	    {
		/* no channel */
		rc = -2;

		if (Trace || Debug)
	printf("ezcaNewMonitorValue() found no channel name >%s< type %d\n",
			pvname, type);
	    } /* endif */
	}
	else
	{
	    /* invalid type */
	    rc = -3;

	    if (AutoErrorMessage)
		printf("%s\n", INVALID_TYPE_MSG);
	} /* endif */
    }
    else
    {
	/* invalid pvname */
	rc = -4;

	if (AutoErrorMessage)
	    printf("%s\n", INVALID_PVNAME_MSG);

    } /* endif */

    epilogue();
    return rc;

} /* end ezcaNewMonitorValue() */

/****************************************************************
*
* if there is no outstanding work, this function is a no-op.
*
****************************************************************/

void epicsShareAPI ezcaPerror(char *prefix)
{

struct work *wp;
char *wtm;

    prologue();

    if (ErrorLocation == SINGLEWORK)
    {
	/* using Workp */

	if (Workp)
	{
	    wp = Workp;

	    switch (wp->worktype)
	    {
		case GET:              wtm = GET_MSG;              break;
		case PUT:              wtm = PUT_MSG;              break;
		case PUTOLDCA:         wtm = PUTOLDCA_MSG;         break;
		case GETUNITS:         wtm = GETUNITS_MSG;         break;
	    case GETENUMSTATES:    wtm = GETENUMSTATES_MSG;    break;
		case GETNELEM:         wtm = GETNELEM_MSG;         break;
		case GETPRECISION:     wtm = GETPRECISION_MSG;     break;
		case GETGRAPHICLIMITS: wtm = GETGRAPHICLIMITS_MSG; break;
		case GETCONTROLLIMITS: wtm = GETCONTROLLIMITS_MSG; break;
		case GETWARNLIMITS:    wtm = GETWARNLIMITS_MSG;    break;
		case GETALARMLIMITS:   wtm = GETALARMLIMITS_MSG;   break;
		case GETSTATUS:        wtm = GETSTATUS_MSG;        break;
		case GETWITHSTATUS:    wtm = GETWITHSTATUS_MSG;    break;
		case SETMONITOR:       wtm = SETMONITOR_MSG;       break;
		case CLEARMONITOR:     wtm = CLEARMONITOR_MSG;     break;
		case AUTOERRORMESSAGEOFF: 
		    wtm = AUTOERRORMESSAGEOFF_MSG;                 break;
		case AUTOERRORMESSAGEON:     
		    wtm = AUTOERRORMESSAGEON_MSG;                  break;
		case DEBUGOFF:         wtm = DEBUGOFF_MSG;         break;
		case DEBUGON:          wtm = DEBUGON_MSG;          break;
		case DELAY:            wtm = DELAY_MSG;            break;
		case FREEMEM:          wtm = FREEMEM_MSG;          break;
		case PVTOCHID:         wtm = PVTOCHID_MSG;         break;
		case SETTIMEOUT:       wtm = SETTIMEOUT_MSG;       break;
		case STARTGROUP:       wtm = STARTGROUP_MSG;       break;
		case CLEARCHANNEL:     wtm = CLEARCHANNEL_MSG;     break;
		case MONBLOCK:         wtm = MONBLOCK_MSG;         break;
		case TRACEOFF:         wtm = TRACEOFF_MSG;         break;
		case TRACEON:          wtm = TRACEON_MSG;          break;
		case SETRETRYCOUNT:    wtm = SETRETRYCOUNT_MSG;    break;
		case GETRETRYCOUNT:    wtm = GETRETRYCOUNT_MSG;    break;
		case GETTIMEOUT:       wtm = GETTIMEOUT_MSG;       break;
		default:
		    fprintf(stderr, 
		"EZCA FATAL ERROR: ezcaPerror() found invalid worktype %d\n", 
			wp->worktype);
		    exit(1);
		    break;
	    } /* end switch() */

	    printf("%s %s: ", (prefix ? prefix : ""), wtm);
	    print_error(wp);
	} /* endif */
    }
    else
    {
	/* using Work_list */

	for (wp = (ListPrint == WHOLELIST ? Work_list.head : Work_list.tail); 
	    wp; wp = wp->next)
	{
	    switch (wp->worktype)
	    {
		case GET:              wtm = GET_MSG;              break;
		case PUT:              wtm = PUT_MSG;              break;
		case PUTOLDCA:         wtm = PUTOLDCA_MSG;         break;
		case GETUNITS:         wtm = GETUNITS_MSG;         break;
	    case GETENUMSTATES:    wtm = GETENUMSTATES_MSG;    break;
		case GETNELEM:         wtm = GETNELEM_MSG;         break;
		case GETPRECISION:     wtm = GETPRECISION_MSG;     break;
		case GETGRAPHICLIMITS: wtm = GETGRAPHICLIMITS_MSG; break;
		case GETCONTROLLIMITS: wtm = GETCONTROLLIMITS_MSG; break;
		case GETWARNLIMITS:    wtm = GETWARNLIMITS_MSG;    break;
		case GETALARMLIMITS:   wtm = GETALARMLIMITS_MSG;   break;
		case GETSTATUS:        wtm = GETSTATUS_MSG;        break;
		case GETWITHSTATUS:    wtm = GETWITHSTATUS_MSG;    break;
		case SETMONITOR:       wtm = SETMONITOR_MSG;       break;
		case CLEARMONITOR:     wtm = CLEARMONITOR_MSG;     break;
		case AUTOERRORMESSAGEOFF: 
		    wtm = AUTOERRORMESSAGEOFF_MSG;                 break;
		case AUTOERRORMESSAGEON:     
		    wtm = AUTOERRORMESSAGEON_MSG;                  break;
		case DEBUGOFF:         wtm = DEBUGOFF_MSG;         break;
		case DEBUGON:          wtm = DEBUGON_MSG;          break;
		case DELAY:            wtm = DELAY_MSG;            break;
		case FREEMEM:          wtm = FREEMEM_MSG;          break;
		case PVTOCHID:         wtm = PVTOCHID_MSG;         break;
		case SETTIMEOUT:       wtm = SETTIMEOUT_MSG;       break;
		case STARTGROUP:       wtm = STARTGROUP_MSG;       break;
		case CLEARCHANNEL:     wtm = CLEARCHANNEL_MSG;     break;
		case MONBLOCK:         wtm = MONBLOCK_MSG;         break;
		case TRACEOFF:         wtm = TRACEOFF_MSG;         break;
		case TRACEON:          wtm = TRACEON_MSG;          break;
		case SETRETRYCOUNT:    wtm = SETRETRYCOUNT_MSG;    break;
		case GETRETRYCOUNT:    wtm = GETRETRYCOUNT_MSG;    break;
		case GETTIMEOUT:       wtm = GETTIMEOUT_MSG;       break;
		default:
		    fprintf(stderr, 
		"EZCA FATAL ERROR: ezcaPerror() found invalid worktype %d\n", 
			wp->worktype);
		    exit(1);
		    break;
	    } /* end switch() */

	    printf("%s %s: ", (prefix ? prefix : ""), wtm);
	    print_error(wp);
	} /* endfor */
    } /* endif */

    epilogue();
} /* end ezcaPerror() */

/**************************************************************/
/*                                                            */
/* Non-Groupable Work Functions                               */
/*                                                            */
/* These allocate work,so they store error msgs.  They do not */
/* change ErrorLocation.                                      */
/* These are executed immediately, without respect to InGroup */
/* context.                                                   */
/*                                                            */
/**************************************************************/

/****************************************************************
*
*
****************************************************************/

void epicsShareAPI ezcaAutoErrorMessageOff()
{

struct work *wp;

    prologue();

    if ((wp = get_work_single()))
    {
	ErrorLocation = SINGLEWORK;

	/* filling work */
	wp->worktype = AUTOERRORMESSAGEOFF;

	wp->rc = EZCA_OK;

	AutoErrorMessage = FALSE;

	if (Trace || Debug)
	    printf("clearing AutoErrorMessage\n");
    }
    else
    {
	if (AutoErrorMessage)
	    printf("%s\n", FAILED_MALLOC_MSG);
    } /* endif */

    epilogue();
} /* end ezcaAutoErrorMessageOff() */

/****************************************************************
*
*
****************************************************************/

void epicsShareAPI ezcaAutoErrorMessageOn()
{

struct work *wp;

    prologue();

    if ((wp = get_work_single()))
    {
	ErrorLocation = SINGLEWORK;

	/* filling work */
	wp->worktype = AUTOERRORMESSAGEON;
	wp->rc = EZCA_OK;

	AutoErrorMessage = TRUE;

	if (Trace || Debug)
	    printf("setting AutoErrorMessage\n");
    }
    else
    {
	if (AutoErrorMessage)
	    printf("%s\n", FAILED_MALLOC_MSG);
    } /* endif */

    epilogue();
} /* end ezcaAutoErrorMessageOn() */

/****************************************************************
*
*
****************************************************************/

int epicsShareAPI ezcaClearMonitor(char *pvname, char type)
{

struct channel *cp;
struct monitor *mp;
struct work *wp;
BOOL found;
int rc;

    prologue();

    if ((wp = get_work_single()))
    {
	ErrorLocation = SINGLEWORK;

	/* filling work */
	wp->worktype = CLEARMONITOR;
	wp->ezcadatatype = type;

	/* checking input args */

	if (!pvname)
	{
	    wp->rc = EZCA_INVALIDARG;
	    wp->error_msg = ErrorMsgs[INVALID_PVNAME_MSG_IDX];

	    if (AutoErrorMessage)
		print_error(wp);
	} 
	else if (!(wp->pvname = strdup(pvname)))
	{
	    wp->rc = EZCA_FAILEDMALLOC;
	    wp->error_msg = ErrorMsgs[FAILED_MALLOC_MSG_IDX];

	    if (AutoErrorMessage)
		print_error(wp);
	} 
	else if (!VALID_EZCA_DATA_TYPE(wp->ezcadatatype))
	{
	    wp->rc = EZCA_INVALIDARG;
	    wp->error_msg = ErrorMsgs[INVALID_TYPE_MSG_IDX];

	    if (AutoErrorMessage)
		print_error(wp);
	} 
	else
	{
	    /* arguments are valid */
	    wp->rc = EZCA_OK;
	} /* endif */

	if (wp->rc == EZCA_OK)
	{
	    /* all input args OK */
	    if ((cp = find_channel(wp->pvname)))
	    {
		/* everything OK so far ... otherwise something */
		/* went wrong and it is already explained in wp */

		/* loop to check monitor list for monitor of the same type */
		mp = cp->monitor_list;
		found = FALSE;
		while (mp && !found)
		if (!(found = (wp->ezcadatatype == mp->ezcadatatype)))
		    mp = mp->right;

		if (found)
		{
		    if (Trace || Debug)
		printf("ezcaClearMonitor(): found monitor ... clearing now\n");

		    /* removing monitor from this channel's list */
		    if (mp->left)
			/* mp is NOT leftmost */
			(mp->left)->right = mp->right;
		    else
			/* mp is leftmost */
			cp->monitor_list = mp->right;

		    if (mp->right)
			/* mp is NOT rightmost */
			(mp->right)->left = mp->left;

		    /* clearing event, freeing memory, and */
		    /* taking this monitor out of service  */

		    mp->active = FALSE;

		    clean_and_push_monitor(mp);

		    wp->rc = EZCA_OK;
		}
		else
		{
		    /* no monitor to clear */

		    wp->rc = EZCA_OK;

		    if (Trace || Debug)
		printf("ezcaClearMonitor(): found channel but no monitor\n");

		} /* endif */
		release_channel(&cp);
	    } 
	    else
	    {
		wp->rc = EZCA_OK;

		if (Trace || Debug)
		    printf("ezcaClearMonitor: found no channel\n");
	    } /* endif */
	} /* endif */

	rc = wp->rc;
	    
    }
    else
    {
	rc = EZCA_FAILEDMALLOC;

	if (AutoErrorMessage)
	    printf("%s\n", FAILED_MALLOC_MSG);
    } /* endif */

    epilogue();
    return rc;

} /* end ezcaClearMonitor() */

/****************************************************************
*
* Available, but not advertised.
*
****************************************************************/

void epicsShareAPI ezcaDebugOff()
{

struct work *wp;

    prologue();

    if ((wp = get_work_single()))
    {
	ErrorLocation = SINGLEWORK;

	/* filling work */
	wp->worktype = DEBUGOFF;
	wp->rc = EZCA_OK;

	if (Trace || Debug)
	    printf("clearing Debug\n");

	Debug = FALSE;
    }
    else
    {
	if (AutoErrorMessage)
	    printf("%s\n", FAILED_MALLOC_MSG);
    } /* endif */

    epilogue();
} /* end ezcaDebugOff() */

/****************************************************************
*
* Available, but not advertised.
*
****************************************************************/

void epicsShareAPI ezcaDebugOn()
{

struct work *wp;

    prologue();

    if ((wp = get_work_single()))
    {
	ErrorLocation = SINGLEWORK;

	/* filling work */
	wp->worktype = DEBUGON;
	wp->rc = EZCA_OK;

	Debug = TRUE;

	if (Trace || Debug)
	    printf("setting Debug\n");
    }
    else
    {
	if (AutoErrorMessage)
	    printf("%s\n", FAILED_MALLOC_MSG);
    } /* endif */

    epilogue();
} /* end ezcaDebugOn() */

/****************************************************************
*
* This is a function that we provide for users that use ezcaSetMonitor().
* If they set a monitor and go a long time without calling another 
* ezca function, they could lose important values.  
*
* Now all they have to do is call this function which allows us to check
* the monitors.
*
****************************************************************/

int epicsShareAPI ezcaDelay(float sec)
{

struct work *wp;
int status;
int rc;
unsigned   attempt;

    prologue();

    if ((wp = get_work_single()))
    {
	ErrorLocation = SINGLEWORK;

	/* filling work */
	wp->worktype = DELAY;

	if (sec > 0.)
	{
		RetryCount = (unsigned)(sec/TimeoutSeconds);
		if ( RetryCount * TimeoutSeconds < sec )
			RetryCount++;
		for ( attempt=0, status = ECA_TIMEOUT;
		     ECA_TIMEOUT == status && attempt<RetryCount && sec > 0;
		     attempt++, sec-=TimeoutSeconds ) {
	    	status = EzcaPendEvent((struct work *) NULL, sec > TimeoutSeconds ? TimeoutSeconds : sec, TRUE);
			if ( ECA_TIMEOUT != status )
				break;
		}

	    if (status == ECA_TIMEOUT)
		{
			/* normal return code */
			if ( (wp->rc = RetryCount ? EZCA_OK : EZCA_ABORTED) )
			{
				wp->error_msg = ErrorMsgs[ABORTED_MSG_IDX];
			}
		}
	    else
	    {
		wp->rc = EZCA_CAFAILURE;
		wp->error_msg = ErrorMsgs[CAPENDEVENT_MSG_IDX];
		wp->aux_error_msg = strdup(ca_message(status));
		if (AutoErrorMessage)
		    print_error(wp);
	    } /* endif */
	}
	else
	{
	    wp->rc = EZCA_INVALIDARG;
	    wp->error_msg = ErrorMsgs[INVALID_ARG_MSG_IDX];

	    if (AutoErrorMessage)
		print_error(wp);
	} /* endif */

	rc = wp->rc;
    }
    else
    {
	rc = EZCA_FAILEDMALLOC;

	if (AutoErrorMessage)
	    printf("%s\n", FAILED_MALLOC_MSG);
    } /* endif */

    epilogue();
    return rc;

} /* end ezcaDelay() */

/****************************************************************
*
*
****************************************************************/

void epicsShareAPI ezcaFree(void *buff)
{

struct work *wp;

    prologue();

    if ((wp = get_work_single()))
    {
	ErrorLocation = SINGLEWORK;

	/* filling work */
	wp->worktype = FREEMEM;
	wp->rc = EZCA_OK;

	if (buff)
	    ezcafree(buff);

	if (Debug)
	    printf("ezcaFree() just freed starting\n");
    }
    else
    {
	if (AutoErrorMessage)
	    printf("%s\n", FAILED_MALLOC_MSG);
    } /* endif */

    epilogue();
} /* end ezcaFree() */

/****************************************************************
*
*
****************************************************************/

int epicsShareAPI ezcaGetRetryCount()
{

struct work *wp;
int rc;

    prologue();

    if ((wp = get_work_single()))
    {
	ErrorLocation = SINGLEWORK;

	/* filling work */
	wp->worktype = GETRETRYCOUNT;
	wp->rc = EZCA_OK;

	rc  = (int) SavedRetryCount;
    }
    else
    {
	if (AutoErrorMessage)
	    printf("%s\n", FAILED_MALLOC_MSG);

	rc = UNDEFINED;

    } /* endif */

    epilogue();
    return rc;

} /* end ezcaGetRetryCount() */

/****************************************************************
*
*
****************************************************************/

float epicsShareAPI ezcaGetTimeout()
{

struct work *wp;
float rc;

    prologue();

    if ((wp = get_work_single()))
    {
	ErrorLocation = SINGLEWORK;

	/* filling work */
	wp->worktype = GETTIMEOUT;
	wp->rc = EZCA_OK;

	rc  = TimeoutSeconds;
    }
    else
    {
	if (AutoErrorMessage)
	    printf("%s\n", FAILED_MALLOC_MSG);

	rc = UNDEFINED;

    } /* endif */

    epilogue();
    return rc;

} /* end ezcaGetTimeout() */

/****************************************************************
*
*
****************************************************************/

int epicsShareAPI ezcaPvToChid(char *pvname, chid **cid)
{

struct channel *cp;
struct work *wp;
int rc;

    prologue();

    if ((wp = get_work_single()))
    {
	ErrorLocation = SINGLEWORK;

	/* filling work */
	wp->worktype = PVTOCHID;

	if (cid)
	{
	    if (pvname)
	    {
		/* arguments are valid */

		if ((wp->pvname = strdup(pvname)))
		{

		    get_channel(wp, &cp);

		    if (cp)
		    {
			/* everything OK */

			/* wp->rc set by get_channel() if something went bad */
			/* NOTE:  error message printed by get_channel()     */
			/*        also if AutoErrorMessage is set.           */

			wp->rc = EZCA_OK;
			*cid = &(cp->cid);
		    } /* endif */

			release_channel( &cp );
		}
		else
		{
		    wp->rc = EZCA_FAILEDMALLOC;
		    wp->error_msg = ErrorMsgs[FAILED_MALLOC_MSG_IDX];

		    if (AutoErrorMessage)
			print_error(wp);
		} /* endif */
	    }
	    else
	    {
		wp->rc = EZCA_INVALIDARG;
		wp->error_msg = ErrorMsgs[INVALID_PVNAME_MSG_IDX];

		if (AutoErrorMessage)
		    print_error(wp);
	    } /* endif */
	}
	else
	{
	    wp->rc = EZCA_INVALIDARG;
	    wp->error_msg = ErrorMsgs[INVALID_PBUFF_MSG_IDX];

	    if (AutoErrorMessage)
		print_error(wp);
	} /* endif */

	rc = wp->rc;
    }
    else
    {
	rc = EZCA_FAILEDMALLOC;

	if (AutoErrorMessage)
	    printf("%s\n", FAILED_MALLOC_MSG);
    } /* endif */

    epilogue();
    return rc;

} /* end ezcaPvToChid() */

/****************************************************************
*
*
****************************************************************/

int epicsShareAPI ezcaSetMonitor(char *pvname, char type, unsigned long count)
{

struct channel *cp;
struct monitor *mp;
struct work *wp;
BOOL found;
int rc;

    prologue();

    if ((wp = get_work_single()))
    {
	ErrorLocation = SINGLEWORK;

	/* filling work */

	wp->worktype = SETMONITOR;
	wp->ezcadatatype = type;

	/* checking input args */

        if (!pvname)
        {
            wp->rc = EZCA_INVALIDARG;
            wp->error_msg = ErrorMsgs[INVALID_PVNAME_MSG_IDX];

            if (AutoErrorMessage)
		print_error(wp);
        } 
        else if (!(wp->pvname = strdup(pvname)))
        {
            wp->rc = EZCA_FAILEDMALLOC;
            wp->error_msg = ErrorMsgs[FAILED_MALLOC_MSG_IDX];

            if (AutoErrorMessage)
		print_error(wp);
        } 
	else if (!VALID_EZCA_DATA_TYPE(wp->ezcadatatype))
	{
	    wp->rc = EZCA_INVALIDARG;
	    wp->error_msg = ErrorMsgs[INVALID_TYPE_MSG_IDX];

	    if (AutoErrorMessage)
		print_error(wp);
	} 
	else
	{
	    /* arguments are valid */
	    wp->rc = EZCA_OK;
	} /* endif */

	if (wp->rc == EZCA_OK)
	{
	    /* all input args OK */
	    get_channel(wp, &cp);

	    if (cp)
	    {
		/* everything OK so far ... otherwise something */
		/* went wrong and it is already explained in wp */

		/* loop to check monitor list for monitor of the same type */
		mp = cp->monitor_list;
		found = FALSE;
		while (mp && !found)
		    if (!(found = (wp->ezcadatatype == mp->ezcadatatype)))
			mp = mp->right;

		if (found)
		{
		    if (Trace || Debug)
		printf("ezcaSetMonitor(): found monitor already existed\n");

		    wp->rc = EZCA_OK;
		}
		else
		{
		    /* was not in the monitor list ... need to */
		    /* place it there and start the monitor    */

		    if (Trace || Debug)
    printf("ezcaSetMonitor(): monitor did not exist. establishing one now\n");
		    if ((mp = pop_monitor()))
		    {
			/* filling the mp here because ca_pend_io() could   */
			/* cause my_monitor_callback() go be executed and   */
			/* we need a full mp there in order for it to work. */

			mp->ezcadatatype = wp->ezcadatatype;

			mp->cp = cp;

			if (Debug)
			{
    printf("ezcaSetMonitor() channels before pushing monitor onto channel\n");
			    print_channels();
			} /* endif */

			/* pushing the monitor onto the monitor list */
			if (cp->monitor_list)
			{
			    /* non-empty list */
			    mp->right = cp->monitor_list;
			    (cp->monitor_list)->left = mp;
			}
			else
			    /* empty list */
			    mp->right = (struct monitor *) NULL;

			mp->left = (struct monitor *) NULL;
			cp->monitor_list = mp;

			if (Debug)
			{
    printf("ezcaSetMonitor() channels after pushing monitor onto channel\n");
			    print_channels();
			} /* endif */

			if (EzcaAddArrayEvent(wp, mp, count) == ECA_NORMAL)
			{
			    mp->active = TRUE;

			    if (EzcaPendIO(wp, SHORT_TIME) == ECA_NORMAL)
				wp->rc = EZCA_OK;
			    else
			    {
				/* something went wrong ... rc and */
				/* error msg have already been set */

				mp->active = FALSE;

				/* need to take mp off of cp->monitor_list */
				/* should be on top.                       */
				if (cp->monitor_list)
				{
				    if ((cp->monitor_list)->right)
				    {
					/* more than one in the list */
					cp->monitor_list = 
					    (cp->monitor_list)->right;
					(cp->monitor_list)->left = 
					    (struct monitor *) NULL;
				    }
				    else
					/* only one in the list */
					cp->monitor_list = 
					    (struct monitor *) NULL;
				}
				else
				{
				    /* cannot be NULL ... just pushed      */
				    /* a monitor something has gone wrong. */

				    fprintf(stderr,
	    "EZCA FATAL ERROR: ezcaSetMonitor() found NULL cp->monitor_list\n");
				    exit(1);
				} /* endif */

				clean_and_push_monitor(mp);
			    } /* endif */
			}
			else
			{
			    /* something went wrong ... rc and */
			    /* error msg have already been set */

			    /* need to take mp off of cp->monitor_list */
			    /* should be on top.                       */
			    if (cp->monitor_list)
			    {
				if ((cp->monitor_list)->right)
				{
				    /* more than one in the list */
				    cp->monitor_list = 
					(cp->monitor_list)->right;
				    (cp->monitor_list)->left = 
					(struct monitor *) NULL;
				}
				else
				    /* only one in the list */
				    cp->monitor_list = (struct monitor *) NULL;
			    }
			    else
			    {
				/* cannot be NULL ... just pushed a monitor */
				/* something has gone wrong.                */

				fprintf(stderr, 
	"EZCA FATAL ERROR: ezcaSetMonitor() found NULL cp->monitor_list\n");
				exit(1);
			    } /* endif */

			    clean_and_push_monitor(mp);

			} /* endif */
		    }
		    else
		    {
			wp->rc = EZCA_FAILEDMALLOC;
			wp->error_msg = ErrorMsgs[FAILED_MALLOC_MSG_IDX];

			if (AutoErrorMessage)
			    print_error(wp);
		    } /* endif */
		} /* endif */
		release_channel(&cp);
	    } /* endif */
	} /* endif */

	rc = wp->rc;
	    
    }
    else
    {
	rc = EZCA_FAILEDMALLOC;

	if (AutoErrorMessage)
	    printf("%s\n", FAILED_MALLOC_MSG);
    } /* endif */

    epilogue();
    return rc;

} /* end ezcaSetMonitor() */

/****************************************************************
*
*
****************************************************************/

int epicsShareAPI ezcaSetRetryCount(int retry)
{

struct work *wp;
int rc;

    prologue();

    if ((wp = get_work_single()))
    {
	ErrorLocation = SINGLEWORK;

	/* filling work */
	wp->worktype = SETRETRYCOUNT;

	if (retry >= 0)
	{
	    RetryCount = SavedRetryCount = (unsigned) retry;

	    wp->rc = EZCA_OK;
	}
	else
	{
	    wp->rc = EZCA_INVALIDARG;
	    wp->error_msg = ErrorMsgs[INVALID_ARG_MSG_IDX];

	    if (AutoErrorMessage)
		print_error(wp);
	} /* endif */

	rc = wp->rc;
    }
    else
    {
	rc = EZCA_FAILEDMALLOC;

	if (AutoErrorMessage)
	    printf("%s\n", FAILED_MALLOC_MSG);
    } /* endif */

    epilogue();
    return rc;

} /* end ezcaSetRetryCount() */

/****************************************************************
*
*
****************************************************************/

int epicsShareAPI ezcaSetTimeout(float sec)
{

struct work *wp;
int rc;

    prologue();

    if ((wp = get_work_single()))
    {
	ErrorLocation = SINGLEWORK;

	/* filling work */
	wp->worktype = SETTIMEOUT;

	if (sec > 0)
	{
	    TimeoutSeconds = sec;

	    wp->rc = EZCA_OK;
	}
	else
	{
	    wp->rc = EZCA_INVALIDARG;
	    wp->error_msg = ErrorMsgs[INVALID_ARG_MSG_IDX];

	    if (AutoErrorMessage)
		print_error(wp);
	} /* endif */

	rc = wp->rc;
    }
    else
    {
	rc = EZCA_FAILEDMALLOC;

	if (AutoErrorMessage)
	    printf("%s\n", FAILED_MALLOC_MSG);
    } /* endif */

    epilogue();
    return rc;

} /* end ezcaSetTimeout() */

/****************************************************************
*
*
****************************************************************/

int epicsShareAPI ezcaStartGroup()
{

struct work *wp;
int rc;

    prologue();

    if ((wp = get_work_single()))
    {
	ErrorLocation = SINGLEWORK;

	/* filling work */
	wp->worktype = STARTGROUP;

	if (InGroup)
	{
	    /* already in a group */
	    wp->rc = EZCA_INGROUP;
	    wp->error_msg = ErrorMsgs[INGROUP_MSG_IDX];

	    if (AutoErrorMessage)
		print_error(wp);
	}
	else
	{
	    /* not in a group */

	    if (Trace || Debug)
	printf("ezcaStartGroup() about to empty_work_list() and set InGroup\n");

	    empty_work_list();

	    InGroup = TRUE;

	    wp->rc = EZCA_OK;

	} /* endif */

	rc = wp->rc;
    }
    else
    {
	rc = EZCA_FAILEDMALLOC;

	if (AutoErrorMessage)
	    printf("%s\n", FAILED_MALLOC_MSG);

    } /* endif */

    epilogue();
    return rc;

} /* end ezcaStartGroup() */

int epicsShareAPI ezcaClearChannel(char *pvname)
{

struct channel *cp = 0;
struct work *wp;
int rc;

    prologue();

    if ((wp = get_work_single()))
    {
	ErrorLocation = SINGLEWORK;

	/* filling work */
	wp->worktype = CLEARCHANNEL;

    if (!pvname || !(cp=find_channel(pvname)))
    {
        wp->rc = EZCA_INVALIDARG;
        wp->error_msg = ErrorMsgs[INVALID_PVNAME_MSG_IDX];

        if (AutoErrorMessage)
			print_error(wp);
    }
	else if (InGroup)
	{
	    /* already in a group */
	    wp->rc = EZCA_INGROUP;
	    wp->error_msg = ErrorMsgs[INGROUP_MSG_IDX];

	    if (AutoErrorMessage)
			print_error(wp);
	}
	else
	{
	    /* not in a group */


		if ( cp ) {
	    if (Trace || Debug)
	printf("ezcaClearChannel() about to call clean_and_push_channel()\n");
			clean_and_push_channel( &cp );
	    	wp->rc = EZCA_OK;
		}
	} /* endif */

	rc = wp->rc;
    }
    else
    {
	rc = EZCA_FAILEDMALLOC;

	if (AutoErrorMessage)
	    printf("%s\n", FAILED_MALLOC_MSG);

    } /* endif */

	/* if clean_and_push_channel() was successful, cp is NULL at this point */
	release_channel( &cp );

    epilogue();
    return rc;

} /* end ezcaClearChannel() */

/* clear all channels */
int epicsShareAPI ezcaPurge(int disconnectedOnly)
{

struct channel *cp;
struct work *wp;
int rc,i;

    prologue();

    if ((wp = get_work_single()))
    {
	ErrorLocation = SINGLEWORK;

	/* filling work */
	wp->worktype = CLEARCHANNEL;

	if (InGroup)
	{
	    /* already in a group */
	    wp->rc = EZCA_INGROUP;
	    wp->error_msg = ErrorMsgs[INGROUP_MSG_IDX];

	    if (AutoErrorMessage)
			print_error(wp);
	}
	else
	{
	    /* not in a group */
		for ( i = 0; i < HASHTABLESIZE; i++ ) {
			for ( cp = Channels[i]; cp; ) {
				if ( !disconnectedOnly || !EzcaConnected(cp) ) {
					if ( cp->refcnt ) {
						fprintf(stderr,"EZCA FATAL ERROR: ezcaClearChannel() -- refcnt is not 0\n");
						exit(1);
					}
					/* normal get_channel() or find_channel() increment the
					 * refcnt...
					 */
					cp->refcnt++;
					clean_and_push_channel(&cp);
					/* start over */
					cp = Channels[i];
				} else {
					cp = cp->next;
				}
			}
		}

	   	wp->rc = EZCA_OK;
	} /* endif */

	rc = wp->rc;
    }
    else
    {
	rc = EZCA_FAILEDMALLOC;

	if (AutoErrorMessage)
	    printf("%s\n", FAILED_MALLOC_MSG);

    } /* endif */

    epilogue();
    return rc;

} /* end ezcaClearChannel() */


/****************************************************************
*
* Available, but not advertised.
*
****************************************************************/

void epicsShareAPI ezcaTraceOff()
{

struct work *wp;

    prologue();

    if ((wp = get_work_single()))
    {
	ErrorLocation = SINGLEWORK;

	/* filling work */
	wp->worktype = TRACEOFF;
	wp->rc = EZCA_OK;

	if (Trace || Debug)
	    printf("clearing Trace\n");

	Trace = FALSE;
    }
    else
    {
	if (AutoErrorMessage)
	    printf("%s\n", FAILED_MALLOC_MSG);
    } /* endif */

    epilogue();
} /* end ezcaTraceOff() */

/****************************************************************
*
* Available, but not advertised.
*
****************************************************************/

void epicsShareAPI ezcaTraceOn()
{

struct work *wp;

    prologue();

    if ((wp = get_work_single()))
    {
	ErrorLocation = SINGLEWORK;

	/* filling work */
	wp->worktype = TRACEON;
	wp->rc = EZCA_OK;

	Trace = TRUE;

	if (Trace || Debug)
	    printf("setting Trace\n");
    }
    else
    {
	if (AutoErrorMessage)
	    printf("%s\n", FAILED_MALLOC_MSG);
    } /* endif */

    epilogue();
} /* end ezcaTraceOn() */

/**************************************************************/
/*                                                            */
/* Groupable Work Functions                                   */
/*                                                            */
/* These allocate work,so they store error msgs.  They may    */
/* change ErrorLocation.                                      */
/* These are executed with respect to InGroup context.        */
/*                                                            */
/**************************************************************/

/****************************************************************
*
*
****************************************************************/

int epicsShareAPI ezcaGet(char *pvname, char type, int nelem, void *buff)
{

struct work *wp;
struct channel *cp;
int rc;

    prologue();

    if ((wp = get_work()))
    {

	ErrorLocation = (InGroup ? LISTWORK : SINGLEWORK);
	ListPrint = (InGroup ? LASTONLY : ListPrint);

	/* filling work */
	wp->worktype = GET;

	wp->ezcadatatype = type;
	wp->nelem = nelem;
	wp->pval = buff;

	/* checking input args */
        if (!pvname)
        {
            wp->rc = EZCA_INVALIDARG;
            wp->error_msg = ErrorMsgs[INVALID_PVNAME_MSG_IDX];

            if (AutoErrorMessage)
		print_error(wp);
        } 
        else if (!(wp->pvname = strdup(pvname)))
        {
            wp->rc = EZCA_FAILEDMALLOC;
            wp->error_msg = ErrorMsgs[FAILED_MALLOC_MSG_IDX];

            if (AutoErrorMessage)
		print_error(wp);
        } 
	else if (!VALID_EZCA_DATA_TYPE(wp->ezcadatatype))
	{
	    wp->rc = EZCA_INVALIDARG;
            wp->error_msg = ErrorMsgs[INVALID_TYPE_MSG_IDX];

	    if (AutoErrorMessage)
		print_error(wp);
	} 
	else if (wp->nelem <= 0)
	{
	    wp->rc = EZCA_INVALIDARG;
            wp->error_msg = ErrorMsgs[INVALID_NELEM_MSG_IDX];

	    if (AutoErrorMessage)
		print_error(wp);
	}
	else if (!(wp->pval))
	{
	    wp->rc = EZCA_INVALIDARG;
            wp->error_msg = ErrorMsgs[INVALID_PBUFF_MSG_IDX];

	    if (AutoErrorMessage)
		print_error(wp);
	}
	else
	{
	    /* arguments are valid ... EZCA_OK for now */
	    wp->rc = EZCA_OK;
	} /* endif */

	if (InGroup)
	    append_to_work_list(wp);
	else if (wp->rc == EZCA_OK)
	{
	    /* all input args OK */

	    get_channel(wp, &cp);

	    if (cp)
	    {
		/* everything OK so far ... otherwise something */
		/* went wrong and it is already explained in wp */

		if (EzcaConnected(cp))
		{
		    /* channel is currently connected */
		    if (!get_from_monitor(wp, cp))
		    {
			/* did not find an active   */
			/* monitor that had a value */
			/* need to do explicit get  */

			if (Trace || Debug)
	    printf("ezcaGet(): did not find an active monitor with a value\n");

			if (issue_get(wp, cp))
			{
			    /* a EzcaArrayGetCallback() */
			    /* was successfully  issued */
			    issue_wait(wp);
			    if (AutoErrorMessage && wp->rc != EZCA_OK)
				print_error(wp);
			} /* endif */
		    } /* endif */
		}
		else
		{
		    /* channel is not connected */

		    wp->rc = EZCA_NOTCONNECTED;
		    wp->error_msg = ErrorMsgs[NOT_CONNECTED_MSG_IDX];

		    if (AutoErrorMessage)
			print_error(wp);
		} /* endif */
	    } /* endif */

		release_channel( &cp );

	} /* endif */

	rc = wp->rc;
    }
    else
    {
	rc = EZCA_FAILEDMALLOC;

	if (AutoErrorMessage)
	    printf("%s\n", FAILED_MALLOC_MSG);
    } /* endif */

    epilogue();
    return rc;

} /* end ezcaGet() */

/****************************************************************
*
*
****************************************************************/

static int
getInfo(char *pvname, char worktype, ...)
{

struct work *wp;
struct channel *cp;
int rc;
va_list ap;
void    **ptrs[4];
int     nptrs = 0;
int     i;
int     canGetFromMon = 0;


    prologue();

    if ((wp = get_work()))
    {

	ErrorLocation = (InGroup ? LISTWORK : SINGLEWORK);
	ListPrint = (InGroup ? LASTONLY : ListPrint);

	/* filling work */

	wp->worktype = worktype;
	wp->rc       = EZCA_OK;

	/* checking input args */
    if (!pvname)
    {
        wp->rc = EZCA_INVALIDARG;
        wp->error_msg = ErrorMsgs[INVALID_PVNAME_MSG_IDX];
    } 
    else if (!(wp->pvname = strdup(pvname)))
    {
        wp->rc = EZCA_FAILEDMALLOC;
        wp->error_msg = ErrorMsgs[FAILED_MALLOC_MSG_IDX];
    }
	else
	{

		switch ( worktype ) {
			default:
				wp->rc        = EZCA_INTERNALERR;
				wp->error_msg = ErrorMsgs[INTERNALERR_MSG_IDX];
			break;

			case GETCONTROLLIMITS:
			case GETGRAPHICLIMITS:
			case GETALARMLIMITS:
			case GETWARNLIMITS:
				ptrs[nptrs++] = (void*)&wp->d1p;
				ptrs[nptrs++] = (void*)&wp->d2p;
			break;

			case GETPRECISION:
				ptrs[nptrs++] = (void*)&wp->s1p;
			break;

			case GETUNITS:
			case GETENUMSTATES:
				ptrs[nptrs++] = (void*)&wp->strp;
			break;

			case GETNELEM:
				ptrs[nptrs++] = (void*)&wp->intp;
			break;

			case GETSTATUS:
				ptrs[nptrs++] = (void*)&wp->tsp;
				ptrs[nptrs++] = (void*)&wp->status;
				ptrs[nptrs++] = (void*)&wp->severity;
				canGetFromMon = 1;
			break;
		}

		va_start( ap, worktype );
			for (i = 0; i<nptrs; i++ ) {
				if ( ! (*ptrs[i] = va_arg(ap, void*)) ) {
	    			wp->rc        = EZCA_INVALIDARG;
	    			wp->error_msg = ErrorMsgs[INVALID_PBUFF_MSG_IDX];
					break;
				}
			}
		va_end( ap );
	}

	if ( wp->rc != EZCA_OK && AutoErrorMessage )
		print_error(wp);

	if (InGroup)
	    append_to_work_list(wp);
	else if (wp->rc == EZCA_OK)
	{
	    /* all input args OK */

	    get_channel(wp, &cp);

	    if (cp)
		{
			/* everything OK so far ... otherwise something */
			/* went wrong and it is already explained in wp */
			if (EzcaConnected(cp))
			{
				/* channel is currently connected */

				if ( GETNELEM == worktype )
				{
					/* we dont have to do more; the info is already available
					 * with the channel...
					 */
					*(wp->intp) = EzcaElementCount(cp);
				}
				else if ( DBF_ENUM != EzcaNativeType(wp->cp) )
				{
					wp->strp[0] = 0;
				}
				else
				{

				    if ( !canGetFromMon || !get_from_monitor(wp, cp))
					{
						/* could not use or did not find an active   */
						/* monitor that had a value                  */
						/* need to do explicit get                   */

						if ( canGetFromMon && (Trace || Debug) )
							printf("%s: did not find an active monitor with a value\n", pvname);

						/* we are not really interested in the actual data,
						 * just the sideband info. Request minimum of elements...
						 */
						wp->nelem = 1;

						if (issue_get(wp, cp))
						{
							/* a EzcaArrayGetCallback() */
							/* was successfully  issued */
							issue_wait(wp);
							if (AutoErrorMessage && wp->rc != EZCA_OK)
								print_error(wp);
						} /* endif */
					}
				}
			}
			else
			{
				/* channel is not connected */

				wp->rc = EZCA_NOTCONNECTED;
				wp->error_msg = ErrorMsgs[NOT_CONNECTED_MSG_IDX];

				if (AutoErrorMessage)
					print_error(wp);
			} /* endif */
		} /* endif */

		release_channel( &cp );

	} /* endif */

	rc = wp->rc;
	    
    }
    else
    {
	rc = EZCA_FAILEDMALLOC;

	if (AutoErrorMessage)
	    printf("%s\n", FAILED_MALLOC_MSG);
    } /* endif */

    epilogue();
    return rc;

} /* end getInfo() */

int epicsShareAPI ezcaGetControlLimits(char *pvname, double *low, double *high)
{
	return getInfo(pvname, GETCONTROLLIMITS, low, high);
}

int epicsShareAPI ezcaGetGraphicLimits(char *pvname, double *low, double *high)
{
	return getInfo(pvname, GETGRAPHICLIMITS, low, high);
}

int epicsShareAPI ezcaGetWarnLimits(char *pvname, double *low, double *high)
{
	return getInfo(pvname, GETWARNLIMITS, low, high);
}

int epicsShareAPI ezcaGetAlarmLimits(char *pvname, double *low, double *high)
{
	return getInfo(pvname, GETALARMLIMITS, low, high);
}

int epicsShareAPI ezcaGetPrecision(char *pvname, short *precision)
{
	return getInfo(pvname, GETPRECISION, precision);
}

int epicsShareAPI ezcaGetUnits(char *pvname, char *units)
{
	return getInfo(pvname, GETUNITS, units);
}

int epicsShareAPI ezcaGetNelem(char *pvname, int *nelem)
{
	return getInfo(pvname, GETNELEM, nelem);
}

int epicsShareAPI ezcaGetStatus(char *pvname, epicsTimeStamp *timestamp, 
    short *status, short *severity)
{
	return getInfo(pvname, GETSTATUS, timestamp, status, severity);
}

int epicsShareAPI ezcaGetEnumStrings(char *pvname, char states[EZCA_ENUM_STATES][EZCA_ENUM_STRING_SIZE])
{
	return getInfo(pvname, GETENUMSTATES, states);
}

/****************************************************************
*
*
****************************************************************/

int epicsShareAPI ezcaGetWithStatus(char *pvname, char type, int nelem, 
	void *buff, epicsTimeStamp *timestamp, short *status, short *severity)
{

struct channel *cp;
struct work *wp;
int rc;

    prologue();

    if ((wp = get_work()))
    {

	ErrorLocation = (InGroup ? LISTWORK : SINGLEWORK);
	ListPrint = (InGroup ? LASTONLY : ListPrint);

	/* filling work */
	wp->worktype = GETWITHSTATUS;
	wp->ezcadatatype = type;
	wp->nelem = nelem;
	wp->pval = buff;
	wp->tsp = timestamp;
	wp->status = status;
	wp->severity = severity;

	/* checking input args */
        if (!pvname)
        {
            wp->rc = EZCA_INVALIDARG;
            wp->error_msg = ErrorMsgs[INVALID_PVNAME_MSG_IDX];

            if (AutoErrorMessage)
		print_error(wp);
        } 
        else if (!(wp->pvname = strdup(pvname)))
        {
            wp->rc = EZCA_FAILEDMALLOC;
            wp->error_msg = ErrorMsgs[FAILED_MALLOC_MSG_IDX];

            if (AutoErrorMessage)
		print_error(wp);
        } 
	else if (!VALID_EZCA_DATA_TYPE(wp->ezcadatatype))
	{
	    wp->rc = EZCA_INVALIDARG;
	    wp->error_msg = ErrorMsgs[INVALID_TYPE_MSG_IDX];

	    if (AutoErrorMessage)
		print_error(wp);
	} 
	else if (wp->nelem <= 0)
	{
	    wp->rc = EZCA_INVALIDARG;
	    wp->error_msg = ErrorMsgs[INVALID_NELEM_MSG_IDX];

	    if (AutoErrorMessage)
		print_error(wp);
	}
	else if (!(wp->pval))
	{
	    wp->rc = EZCA_INVALIDARG;
	    wp->error_msg = ErrorMsgs[INVALID_PBUFF_MSG_IDX];

	    if (AutoErrorMessage)
		print_error(wp);
	}
	else if (!(wp->tsp))
	{
	    wp->rc = EZCA_INVALIDARG;
	    wp->error_msg = ErrorMsgs[INVALID_PBUFF_MSG_IDX];

	    if (AutoErrorMessage)
		print_error(wp);
	} 
	else if (!(wp->status))
	{
	    wp->rc = EZCA_INVALIDARG;
	    wp->error_msg = ErrorMsgs[INVALID_PBUFF_MSG_IDX];

	    if (AutoErrorMessage)
		print_error(wp);
	}
	else if (!(wp->severity))
	{
	    wp->rc = EZCA_INVALIDARG;
	    wp->error_msg = ErrorMsgs[INVALID_PBUFF_MSG_IDX];

	    if (AutoErrorMessage)
		print_error(wp);
	}
	else
	{
	    /* arguments are valid */
	    wp->rc = EZCA_OK;
	} /* endif */

	if (InGroup)
	    append_to_work_list(wp);
	else if (wp->rc == EZCA_OK)
	{
	    /* all input args OK */

	    get_channel(wp, &cp);

	    if (cp)
	    {
		/* everything OK so far ... otherwise something */
		/* went wrong and it is already explained in wp */

		if (EzcaConnected(cp))
		{
		    /* channel is currently connected */
		    if (!get_from_monitor(wp, cp))
		    {
			/* did not find an active   */
			/* monitor that had a value */
			/* need to do explicit get  */

			if (Trace || Debug)
printf("ezcaGetWithStatus(): did not find an active monitor with a value\n");

			if (issue_get(wp, cp))
			{
			    /* a EzcaArrayGetCallback() */
			    /* was successfully  issued */
			    issue_wait(wp);
			    if (AutoErrorMessage && wp->rc != EZCA_OK)
				print_error(wp);
			} /* endif */
		    } /* endif */
		}
		else
		{
		    /* channel is not connected */

		    wp->rc = EZCA_NOTCONNECTED;
		    wp->error_msg = ErrorMsgs[NOT_CONNECTED_MSG_IDX];

		    if (AutoErrorMessage)
			print_error(wp);
		} /* endif */
	    } /* endif */

		release_channel( &cp );

	} /* endif */

	rc = wp->rc;
	    
    }
    else
    {
	rc = EZCA_FAILEDMALLOC;

	if (AutoErrorMessage)
	    printf("%s\n", FAILED_MALLOC_MSG);
    } /* endif */

    epilogue();
    return rc;

} /* end ezcaGetWithStatus() */

/****************************************************************
*
*
****************************************************************/

int epicsShareAPI ezcaPut(char *pvname, char type, int nelem, void *buff)
{

struct channel *cp;
struct work *wp;
int nbytes;
unsigned attempts;
BOOL reported, error;
int rc;

    prologue();

    if ((wp = get_work()))
    {

	ErrorLocation = (InGroup ? LISTWORK : SINGLEWORK);
	ListPrint = (InGroup ? LASTONLY : ListPrint);

	/* filling work */

	wp->worktype = PUT;
	wp->ezcadatatype = type;
	wp->nelem = nelem;

	/* NOTE: must make a copy of the user's buffer here, not  */
	/*       just point to what was given to us.  we must do  */
	/*       this because this routine might have been called */
	/*       inside a group and the user might want to re-use */
	/*       the buffer immediately after our call.           */
	/* NOTE ALSO: that this allocated memory must be free'd   */
	/*            in ezcaEndGroup() and NOT in push_work()    */
	/*            because in push_work() we cannot be sure    */
	/*            that this was malloc'd by us.               */

	if (buff && wp->nelem > 0)
	{
	    switch (wp->ezcadatatype)
	    {
		case ezcaByte: 
		    nbytes = wp->nelem*dbr_value_size[DBR_CHAR];   break;
		case ezcaString:
		    nbytes = wp->nelem*dbr_value_size[DBR_STRING]; break;
		case ezcaShort:
		    nbytes = wp->nelem*dbr_value_size[DBR_SHORT];  break;
		case ezcaLong:
		    nbytes = wp->nelem*dbr_value_size[DBR_LONG];   break;
		case ezcaFloat:
		    nbytes = wp->nelem*dbr_value_size[DBR_FLOAT];  break;
		case ezcaDouble:
		    nbytes = wp->nelem*dbr_value_size[DBR_DOUBLE]; break;
		default:
		    /* error message printed later in ezcaEndGroup() */
		    nbytes = 0;                                    break;
	    } /* end switch() */

	} 
	else
	    nbytes = 0;

	if (nbytes > 0)
	{
	    if ((wp->pval = (void *) ezcamalloc ((unsigned) nbytes)))
		memcpy((char *) (wp->pval), (char *) buff, nbytes);
	}
	else
	    wp->pval = (void *) NULL;

	/* checking input args */
        if (!pvname)
        {
            wp->rc = EZCA_INVALIDARG;
            wp->error_msg = ErrorMsgs[INVALID_PVNAME_MSG_IDX];

            if (AutoErrorMessage)
		print_error(wp);
        } 
        else if (!(wp->pvname = strdup(pvname)))
        {
            wp->rc = EZCA_FAILEDMALLOC;
            wp->error_msg = ErrorMsgs[FAILED_MALLOC_MSG_IDX];

            if (AutoErrorMessage)
		print_error(wp);
        } 
	else if (!VALID_EZCA_DATA_TYPE(wp->ezcadatatype))
	{
	    wp->rc = EZCA_INVALIDARG;
	    wp->error_msg = ErrorMsgs[INVALID_TYPE_MSG_IDX];

	    if (AutoErrorMessage)
		print_error(wp);
	} 
	else if (wp->nelem <= 0)
	{
	    wp->rc = EZCA_INVALIDARG;
	    wp->error_msg = ErrorMsgs[INVALID_NELEM_MSG_IDX];

	    if (AutoErrorMessage)
		print_error(wp);
	}
	else if (!(wp->pval))
	{
	    wp->rc = EZCA_INVALIDARG;
	    wp->error_msg = ErrorMsgs[INVALID_PBUFF_MSG_IDX];

	    if (AutoErrorMessage)
		print_error(wp);
	}
	else
	{
	    /* arguments are valid */
	    wp->rc = EZCA_OK;
	} /* endif */

	if (InGroup)
	    append_to_work_list(wp);
	else if (wp->rc == EZCA_OK)
	{
	    /* all input args OK */
	    get_channel(wp, &cp);

	    if (cp)
	    {
		/* everything OK so far ... otherwise something */
		/* went wrong and it is already explained in wp */

		if (EzcaConnected(cp))
		{
		    /* channel is currently connected */

		    if (wp->nelem <= (int)EzcaElementCount(cp))
		    {
			wp->reported = FALSE;

			if (EzcaArrayPutCallback(wp, cp) == ECA_NORMAL)
			{
				MARK_OUTSTANDING(1);

			    for (reported = error = FALSE, attempts = 0;
				!reported && !error && attempts<=RetryCount;
				    attempts ++)
			    {

				if (Trace || Debug)
				    printf("ezcaPut(): attempt %d of %d\n", 
					attempts+1, RetryCount+1);

				if (EzcaPendEvent(wp, TimeoutSeconds, FALSE) 
					== ECA_TIMEOUT)
				    reported = wp->reported;
				else
				{
				    /* something went wrong ... rc and */
				    /* error msg have already been set */

				    /* need to trash this wp so it's */
				    /* never used again in case the  */
				    /* callback fires off later      */

				    error = TRUE;

				    wp->trashme = trashed;

				    if (Debug)
					printf("trashing wp\n");
				} /* endif */
			    } /* endfor */

			    if (reported)
			    {
				if (AutoErrorMessage && wp->rc != EZCA_OK)
				    print_error(wp);
			    }
			    else
			    {
				if (!error)
				{
				    /* callback did not respond back */
				    /* int time no value received    */

				    /* need to trash this wp so it's */
				    /* never used again in case the  */
				    /* callback fires off later      */

					if ( RetryCount )
					{
				    	wp->rc = EZCA_NOTIMELYRESPONSE;
				    	wp->error_msg =
						ErrorMsgs[NO_RESPONSE_IN_TIME_MSG_IDX];
					}
					else
					{
	            		wp->rc = EZCA_ABORTED;
	            		wp->error_msg = ErrorMsgs[ABORTED_MSG_IDX];
					}

				    if (AutoErrorMessage)
					print_error(wp);
				    wp->trashme = trashed;

				    if (Debug)
					printf("trashing wp\n");
				} /* endif */
			    } /* endif */
			}
			else
			{
			    /* something went wrong ... rc and */
			    /* error msg have already been set */

			    /* need to trash this wp so it's */
			    /* never used again in case the  */
			    /* callback fires off later      */

			    wp->trashme = trashed;
			    if (Debug)
				printf("trashing wp\n");
			} /* endif */
		    }
		    else
		    {
			/* too many elements requested */
			wp->rc = EZCA_INVALIDARG;
			wp->error_msg = ErrorMsgs[TOO_MANY_NELEM_MSG_IDX];

			if (AutoErrorMessage)
			    print_error(wp);
		    } /* endif */
		}
		else
		{
		    /* channel is not connected */

		    wp->rc = EZCA_NOTCONNECTED;
		    wp->error_msg = ErrorMsgs[NOT_CONNECTED_MSG_IDX];

		    if (AutoErrorMessage)
			print_error(wp);
		} /* endif */
	    } /* endif */

		release_channel( &cp );

	    /* no matter what happened ... */
	    /* freeing malloc'd memory */
	    if (wp->pval)
	    {
		ezcafree((char *) wp->pval);
		wp->pval = (void *) NULL;
	    } /* endif */
	} /* endif */

	rc = wp->rc;
	    
    }
    else
    {
	rc = EZCA_FAILEDMALLOC;

	if (AutoErrorMessage)
	    printf("%s\n", FAILED_MALLOC_MSG);
    } /* endif */

    epilogue();
    return rc;

} /* end ezcaPut() */

/****************************************************************
*
*
****************************************************************/

int epicsShareAPI ezcaPutOldCa(char *pvname, char type, int nelem, void *buff)
{

struct channel *cp;
struct work *wp;
int nbytes;
int rc;

    prologue();

    if ((wp = get_work()))
    {

	ErrorLocation = (InGroup ? LISTWORK : SINGLEWORK);
	ListPrint = (InGroup ? LASTONLY : ListPrint);

	/* filling work */

	wp->worktype = PUTOLDCA;
	wp->ezcadatatype = type;
	wp->nelem = nelem;

	/* NOTE: must make a copy of the user's buffer here, not  */
	/*       just point to what was given to us.  we must do  */
	/*       this because this routine might have been called */
	/*       inside a group and the user might want to re-use */
	/*       the buffer immediately after our call.           */
	/* NOTE ALSO: that this allocated memory must be free'd   */
	/*            in ezcaEndGroup() and NOT in push_work()    */
	/*            because in push_work() we cannot be sure    */
	/*            that this was malloc'd by us.               */

	if (buff && wp->nelem > 0)
	{
	    switch (wp->ezcadatatype)
	    {
		case ezcaByte: 
		    nbytes = wp->nelem*dbr_value_size[DBR_CHAR];   break;
		case ezcaString:
		    nbytes = wp->nelem*dbr_value_size[DBR_STRING]; break;
		case ezcaShort:
		    nbytes = wp->nelem*dbr_value_size[DBR_SHORT];  break;
		case ezcaLong:
		    nbytes = wp->nelem*dbr_value_size[DBR_LONG];   break;
		case ezcaFloat:
		    nbytes = wp->nelem*dbr_value_size[DBR_FLOAT];  break;
		case ezcaDouble:
		    nbytes = wp->nelem*dbr_value_size[DBR_DOUBLE]; break;
		default:
		    /* error message printed later in ezcaEndGroup() */
		    nbytes = 0;                                    break;
	    } /* end switch() */

	} 
	else
	    nbytes = 0;

	if (nbytes > 0)
	{
	    if ((wp->pval = (void *) ezcamalloc ((unsigned) nbytes)))
		memcpy((char *) (wp->pval), (char *) buff, nbytes);
	}
	else
	    wp->pval = (void *) NULL;

	/* checking input args */
        if (!pvname)
        {
            wp->rc = EZCA_INVALIDARG;
            wp->error_msg = ErrorMsgs[INVALID_PVNAME_MSG_IDX];

            if (AutoErrorMessage)
		print_error(wp);
        } 
        else if (!(wp->pvname = strdup(pvname)))
        {
            wp->rc = EZCA_FAILEDMALLOC;
            wp->error_msg = ErrorMsgs[FAILED_MALLOC_MSG_IDX];

            if (AutoErrorMessage)
		print_error(wp);
        } 
	else if (!VALID_EZCA_DATA_TYPE(wp->ezcadatatype))
	{
	    wp->rc = EZCA_INVALIDARG;
	    wp->error_msg = ErrorMsgs[INVALID_TYPE_MSG_IDX];

	    if (AutoErrorMessage)
		print_error(wp);
	} 
	else if (wp->nelem <= 0)
	{
	    wp->rc = EZCA_INVALIDARG;
	    wp->error_msg = ErrorMsgs[INVALID_NELEM_MSG_IDX];

	    if (AutoErrorMessage)
		print_error(wp);
	}
	else if (!(wp->pval))
	{
	    wp->rc = EZCA_INVALIDARG;
	    wp->error_msg = ErrorMsgs[INVALID_PBUFF_MSG_IDX];

	    if (AutoErrorMessage)
		print_error(wp);
	}
	else
	{
	    /* arguments are valid */
	    wp->rc = EZCA_OK;
	} /* endif */

	if (InGroup)
	    append_to_work_list(wp);
	else if (wp->rc == EZCA_OK)
	{
	    /* all input args OK */
	    get_channel(wp, &cp);

	    if (cp)
	    {
		/* everything OK so far ... otherwise something */
		/* went wrong and it is already explained in wp */

		if (EzcaConnected(cp))
		{
		    /* channel is currently connected */

		    if (wp->nelem <= (int)EzcaElementCount(cp))
		    {
			if (EzcaArrayPut(wp, cp) == ECA_NORMAL)
			    EzcaPendIO(wp, SHORT_TIME);
		    }
		    else
		    {
			/* too many elements requested */
			wp->rc = EZCA_INVALIDARG;
			wp->error_msg = ErrorMsgs[TOO_MANY_NELEM_MSG_IDX];

			if (AutoErrorMessage)
			    print_error(wp);
		    } /* endif */
		}
		else
		{
		    /* channel is not connected */

		    wp->rc = EZCA_NOTCONNECTED;
		    wp->error_msg  = ErrorMsgs[NOT_CONNECTED_MSG_IDX];

		    if (AutoErrorMessage)
			print_error(wp);
		} /* endif */
	    } /* endif */


		release_channel( &cp );

	    /* no matter what happened ... */
	    /* freeing malloc'd memory */
	    if (wp->pval)
	    {
		ezcafree((char *) wp->pval);
		wp->pval = (void *) NULL;
	    } /* endif */
	} /* endif */

	rc = wp->rc;
	    
    }
    else
    {
	rc = EZCA_FAILEDMALLOC;

	if (AutoErrorMessage)
	    printf("%s\n", FAILED_MALLOC_MSG);
    } /* endif */

    epilogue();
    return rc;

} /* end ezcaPutOldCa() */

/****************************************************************
*
*
****************************************************************/


int epicsShareAPI ezcaNewMonitorWait(char *pvname, char type)
{
struct channel *cp;
struct monitor *mp;
struct work *wp;
int rc;

    prologue();

    if ((wp = get_work()))
    {

	ErrorLocation = (InGroup ? LISTWORK : SINGLEWORK);
	ListPrint = (InGroup ? LASTONLY : ListPrint);

	/* filling work */

	wp->worktype = MONBLOCK;
	wp->ezcadatatype = type;


	/* checking input args */
    if (!pvname)
	{
		wp->rc = EZCA_INVALIDARG;
		wp->error_msg = ErrorMsgs[INVALID_PVNAME_MSG_IDX];
	} 
    else if (!(wp->pvname = strdup(pvname)))
	{
		wp->rc = EZCA_FAILEDMALLOC;
		wp->error_msg = ErrorMsgs[FAILED_MALLOC_MSG_IDX];
	} 
	else if (!VALID_EZCA_DATA_TYPE(wp->ezcadatatype))
	{
	    wp->rc = EZCA_INVALIDARG;
	    wp->error_msg = ErrorMsgs[INVALID_TYPE_MSG_IDX];
	} 
	else
	{
	    /* arguments are valid */
	    wp->rc = EZCA_OK;
	} /* endif */

	if (InGroup)
	    append_to_work_list(wp);
	else if (wp->rc == EZCA_OK)
	{
		if ((cp = find_channel(wp->pvname)))
		{
			mp = cp->monitor_list;
			while (mp && ( ! (type == mp->ezcadatatype) || !mp->active))
					mp = mp->right;

			if (mp)
			{
				if ( !mp->needs_reading ) {
					wp->reported = FALSE;
	
					if( mp->waiter ) {
						fprintf(stderr,"EZCA FATAL ERROR: mp->waiter is already set\n");
						exit(1);
					}
					mp->waiter   = wp;
#ifdef DEBUG
					printf("TSILL issueing wait\n");
#endif
					issue_wait(wp);
#ifdef DEBUG
					printf("DONE\n");
#endif
					mp->waiter   = (struct work *)NULL;
				} else {
#ifdef DEBUG
				printf("TSILL no need to wait\n");
#endif
				}
			}
			else
			{
				/* no monitor */
				wp->rc = EZCA_INVALIDARG;
				wp->error_msg = ErrorMsgs[NO_MONITOR_MSG_IDX];

				if (Trace || Debug)
					printf("add_wait() found no monitor name >%s< type %d\n",
							wp->pvname, type);

			} /* endif */
			release_channel(&cp);
		}
		else
		{
			/* no channel */
			wp->rc = EZCA_INVALIDARG;
			wp->error_msg = ErrorMsgs[INVALID_PVNAME_MSG_IDX];

			if (Trace || Debug)
				printf("add_wait() found no channel name >%s< type %d\n",
						pvname, type);
		} /* endif */
	} /* endif */

	rc = wp->rc;

	if ( AutoErrorMessage && EZCA_OK != wp->rc )
		print_error(wp);
	    
    }
    else
    {
	rc = EZCA_FAILEDMALLOC;

	if (AutoErrorMessage)
	    printf("%s\n", FAILED_MALLOC_MSG);
    } /* endif */

    epilogue();
    return rc;

} /* end ezcaNewMonitorWait() */

/*******************/
/*                 */
/* Local Functions */
/*                 */
/*******************/

/*************/
/*           */
/* Utilities */
/*           */
/*************/

/****************************************************************
*
*
****************************************************************/

static void append_to_work_list(struct work *wp)
{

    if (wp)
    {
	if (Work_list.tail)
	{
	    /* non-empty list */
	    Work_list.tail->next = wp;
	    Work_list.tail = wp;
	}
	else
	{
	    /* empty list */
	    Work_list.head = wp;
	    Work_list.tail = wp;
	} /* endif */
    } /* endif */

} /* end append_to_work_list() */

/****************************************************************
*
* really should be in tsDefs.h
*
****************************************************************/

static void copy_time_stamp(epicsTimeStamp *dest, epicsTimeStamp *src)
{

    if (dest && src)
    {
	dest->secPastEpoch = src->secPastEpoch;
	dest->nsec = src->nsec;
    } /* endif */

} /* end copy_time_stamp() */

/****************************************************************
*
*
****************************************************************/

static void empty_work_list()
{

struct work *wp;

    if (Debug)
    {
	printf("entering empty_work_list()\n");
	print_state();
    } /* endif */

    wp = Work_list.head;
    while (wp)
    {
	Work_list.head = wp->next;
	push_work(wp);
	wp = Work_list.head;
    } /* endwhile */

    Work_list.head = (struct work *) NULL;
    Work_list.tail = (struct work *) NULL;

    if (Debug)
    {
	printf("work_list and work_avail after\n");
	print_state();
    } /* endif */

} /* end empty_work_list() */

/****************************************************************
*
* attempts to find channel in Channels by pvname
*
****************************************************************/

static struct channel *find_channel(char *pvname)
{

unsigned char hi;
BOOL found;
struct channel *rc;

    if (pvname)
    {
	hi = hash(pvname);

	rc = Channels[hi];
	found = FALSE;
	while (rc && !found)
	    if (!(found = !strcmp(rc->pvname, pvname)))
		rc = rc->next;
		else
		rc->refcnt++;
    }
    else
	rc = (struct channel *) NULL;

    if (Trace || Debug)
    {
	if (rc)
	    printf("find_channel() found >%s<\n", pvname);
	else
	    /* do not attempt to print pvname here ... may not be printable */
	    printf("find_channel() did not find channel\n");
    } /* endif */

    return rc;

} /* end find_channel() */

/****************************************************************
*
* attempts to find channel in Channels by pvname
* if not found, creates it and places it there.
*
* peforms all the necessary ca calls.  
*
* if everything went OK, * leaves wp unchanged and places pointer 
* to channel in cpp.
*
* if something went wrong, cpp gets NULL and wp->rc set with
* appropriate error message placed into wp->error_msg.
*
****************************************************************/

static void get_channel(struct work *wp, struct channel **cpp)
{

unsigned char hi;
unsigned attempts;
BOOL done;

    if (!wp || !cpp)
    {
	fprintf(stderr, 
	    "EZCA FATAL ERROR: get_channel() got wp %p cpp %p\n", wp, cpp);
	exit(1);
    } /* endif */

    if (Debug)
    {
	printf("entering get_channel()\n");
	print_state();
    } /* endif */

    if (wp->pvname)
    {
	if ((*cpp = find_channel(wp->pvname)))
	{
	    if (Trace || Debug)
		printf("get_channel(): was able to find_channel()\n");
	}
	else
	{
	    /* not in Channels ... must ca_search_and_connect() and add */
	    if (Trace || Debug)
printf("get_channel(): could not find_channel(). must ca_search_and_connect() and add\n");

	    if ((*cpp = pop_channel()))
	    {
		if (((*cpp)->pvname = strdup(wp->pvname)))
		{

		    if (EzcaQueueSearchAndConnect(wp, *cpp) == ECA_NORMAL)
		    {
			/* adding to Channels */
			hi = hash((*cpp)->pvname);
			(*cpp)->next = Channels[hi];
			Channels[hi] = *cpp;

			MARK_OUTSTANDING(1);

			for (done = FALSE, attempts = 0; 
			    !done && attempts <= RetryCount; attempts ++)
			{
			    if (Trace || Debug)
				printf("get_channel(): attempt %d of %d\n", 
				    attempts+1, RetryCount+1);

			    if (EzcaPendEvent(wp,TimeoutSeconds,FALSE) == ECA_TIMEOUT)
				done = EzcaConnected(*cpp);
			} /* endfor */

			ca_set_puser((*cpp)->cid, 0);

			if ( !done ) {
		    	clean_and_push_channel( cpp );
		
				if ( RetryCount )
				{
					wp->rc = EZCA_NOTIMELYRESPONSE;
					wp->error_msg = ErrorMsgs[NO_PVAR_FOUND_MSG_IDX];
				}
				else
				{
	           		wp->rc = EZCA_ABORTED;
	           		wp->error_msg = ErrorMsgs[ABORTED_MSG_IDX];
				}
				wp->aux_error_msg = strdup(wp->pvname);
	
				if (AutoErrorMessage)
		    		print_error(wp);
			}
	    	} /* endif */
		    else
		    {
			/* something went wrong ... rc and */
			/* error msg have already been set */

			clean_and_push_channel( cpp );
		    } /* endif */
		}
		else
		{
		    wp->rc = EZCA_FAILEDMALLOC;
		    wp->error_msg = ErrorMsgs[FAILED_MALLOC_MSG_IDX];

		    if (AutoErrorMessage)
			print_error(wp);
		} /* endif */
	    } 
	    else
	    {
		wp->rc = EZCA_FAILEDMALLOC;
		wp->error_msg = ErrorMsgs[FAILED_MALLOC_MSG_IDX];

		if (AutoErrorMessage)
		    print_error(wp);
	    } /* endif */
	} /* endif */
    }
    else
    {
	*cpp = (struct channel *) NULL;
	wp->rc = EZCA_INVALIDARG;
	wp->error_msg = ErrorMsgs[INVALID_PVNAME_MSG_IDX];

	if (AutoErrorMessage)
	    print_error(wp);
    } /* endif */

    if (Debug)
    {
	printf("channels and channel_avail after\n");
	print_state();
    } /* endif */

} /* end get_channel() */

/* release a reference to a channel struct; decrement refcnt and
 * set referring pointer to NULL
 */

static void
release_channel( struct channel **cpp )
{
	if ( ! (*cpp) )
		return;

	if ( (*cpp)->refcnt <= 0 ) {
		fprintf(stderr,"EZCA FATAL ERROR: release_channel() called with refcnt <= 0\n");
		exit(1);
	}
	(*cpp)->refcnt--;
	*cpp = 0;
}

/****************************************************************
*
* A user is doing some kind of get (ezcaGet, ezcaGetStatus, ezcaGetWithStatus).
* This function checks the channel for a monitor of the type specified in wp.
* If it finds one, it copies the appropriate value(s) to wp and return TRUE.
* Any other condition it returns FALSE.
*
* The only way wp->rc and wp->error_msg get affected is if the user
* wants to read the value and wants more values than are available.
* That is only possible if the monitor was found (i.e. returns TRUE).
*
* NOTE: This function does not care whether or not the channel is 
*       currently connected ... that is the responsibility of the caller.
*
****************************************************************/

static BOOL get_from_monitor(struct work *wp, struct channel *cp)
{

struct monitor *mp;
BOOL found_error;
BOOL rc;

    if (wp && cp)
    {
	/* loop to check monitor list for */
	/* monitor of the same type       */
	mp = cp->monitor_list;
	rc = FALSE;
	while (mp && !rc)
	    if (!(rc = ((wp->ezcadatatype == mp->ezcadatatype)
			    && mp->active && mp->pval)))
		mp = mp->right;

	if (rc)
	{
	    if (Trace || Debug)
		printf("get_from_monitor(): found active monitor with value\n");

	    found_error = FALSE;

	    if (wp->pval)
	    {
		/* wants the value from the monitor */

		if (wp->nelem <= mp->last_nelem)
		{
		    /* time to copy the data */
		    switch (wp->ezcadatatype)
		    {
			case ezcaByte:
			    memcpy((char *) (wp->pval), 
				(char *) (mp->pval),
				wp->nelem*dbr_value_size[DBR_TIME_CHAR]);

			    if (Trace || Debug)
	    printf("get_from_monitor() just memcpy %d bytes from %p to %p\n",
				wp->nelem*dbr_value_size[DBR_TIME_CHAR],
				mp->pval, wp->pval);

			    break;
			case ezcaString:
			    memcpy((char *) (wp->pval), 
				(char *) (mp->pval),
			    wp->nelem*dbr_value_size[DBR_TIME_STRING]);

			    if (Trace || Debug)
	    printf("get_from_monitor() just memcpy %d bytes from %p to %p\n",
			    wp->nelem*dbr_value_size[DBR_TIME_STRING], 
				mp->pval, wp->pval);

			    break;
			case ezcaShort:
			    memcpy((char *) (wp->pval), 
				(char *) (mp->pval),
			    wp->nelem*dbr_value_size[DBR_TIME_SHORT]);

			    if (Trace || Debug)
	    printf("get_from_monitor() just memcpy %d bytes from %p to %p\n",
			    wp->nelem*dbr_value_size[DBR_TIME_SHORT], 
				mp->pval, wp->pval);

			    break;
			case ezcaLong:
			    memcpy((char *) (wp->pval), 
				(char *) (mp->pval),
			    wp->nelem*dbr_value_size[DBR_TIME_LONG]);

			if (Trace || Debug)
	    printf("get_from_monitor() just memcpy %d bytes from %p to %p\n",
				wp->nelem*dbr_value_size[DBR_TIME_LONG],
				mp->pval, wp->pval);

			    break;
			case ezcaFloat:
			    memcpy((char *) (wp->pval), (char *) (mp->pval),
				wp->nelem*dbr_value_size[DBR_TIME_FLOAT]);

			    if (Trace || Debug)
	    printf("get_from_monitor() just memcpy %d bytes from %p to %p\n",
				wp->nelem*dbr_value_size[DBR_TIME_FLOAT], 
				mp->pval, wp->pval);

			    break;
			case ezcaDouble:
			    memcpy((char *) (wp->pval), (char *) (mp->pval),
				wp->nelem*dbr_value_size[DBR_TIME_DOUBLE]);

			    if (Trace || Debug)
	    printf("get_from_monitor() just memcpy %d bytes from %p to %p\n",
				wp->nelem*dbr_value_size[DBR_TIME_DOUBLE], 
				mp->pval, wp->pval);

			    break;
			default:
			    fprintf(stderr, 
"EZCA FATAL ERROR: get_from_monitor() found unrecognizable ezcadatatype %d\n",
				wp->ezcadatatype);
			    exit(1);
			    break;
		    } /* end switch() */

		    mp->needs_reading = FALSE;
		}
		else
		{
		    /* too many requested elements */
		    found_error = TRUE;

		    wp->rc = EZCA_INVALIDARG;
		    wp->error_msg = ErrorMsgs[TOO_MANY_NELEM_MSG_IDX];

		    if (AutoErrorMessage)
			print_error(wp);
		} /* endif */
	    } /* endif */

	    if (!found_error)
	    {
		if (wp->status)
		{
		    /* wants the status from the monitor */

		    *(wp->status) = mp->status;

		    if (Trace || Debug)
			printf("get_from_monitor() just copied status %d\n", 
			    *(wp->status));
		} /* endif */

		if (wp->severity)
		{
		    /* wants the severity from the monitor */

		    *(wp->severity) = mp->severity;

		    if (Trace || Debug)
			printf("get_from_monitor() just copied severity %d\n",
			    *(wp->severity));
		} /* endif */

		if (wp->tsp)
		{
		    /* wants the time from the monitor */

		    copy_time_stamp(wp->tsp, &(mp->time_stamp));

		    if (Trace || Debug)
			printf("get_from_monitor() just copied time\n");
		} /* endif */
	    } /* endif */
	} /* endif */
    }
    else
    {
	fprintf(stderr, 
	    "EZCA FATAL ERROR: get_from_monitor() got wp %p cp %p\n", wp, cp);
	exit(1);
    } /* endif */

    return rc;

} /* end get_from_monitor() */

/****************************************************************
*
* Presumably an ezcaXXXX() function has just been called.  It was
* either called in the context of InGroup or not.  If InGroup,
* then need a work node that can be placed onto the WorkList,
* otherwise, need to get a good one for Workp;
*
****************************************************************/

static struct work *get_work()
{

struct work *rc;

    if (InGroup)
	/* need to pop_work() for list */
	rc = pop_work();
    else
	/* need to use Workp */
	rc = get_work_single();

    return rc;

} /* end get_work() */

/****************************************************************
*
* It has been determined that we need to use Workp.  It may
* be NULL or it may need to be trashed.  This function takes
* care of all that and returns a clean and initialized Workp,
* or it returns NULL if it cannot get one.
*
****************************************************************/

static struct work *get_work_single()
{

struct work *rc;

    if (Workp)
    {
	if (usable != Workp->trashme)
	{
	    /* must trash this one and get a new one */

	    push_work(Workp);

	    rc = Workp = pop_work();

	}
	else
	{
	    rc = Workp;
	    init_work(rc);
	} /* endif */
    }
    else
	/* no Workp available */
	rc = Workp = pop_work();

    return rc;

} /* end get_work_single() */

/****************************************************************
*
* The hash algorithm is the algorithm described in:                 
* "Fast Hashing of Variable Length Text Strings", Peter K. Pearson,
* Communications of the ACM, June 1990.                           
*
****************************************************************/

static unsigned char hash(char *pvname)
{

unsigned char rc;

    for (rc = 0; *pvname; pvname ++)
	rc = RandomNumbers[rc^*pvname];

    return rc;

} /* end hash() */

/****************************************************************
*
*
****************************************************************/

static void init(void *unused)
{

int i;

#ifdef EPICS_THREE_FOURTEEN
	ezcaMutex = epicsMutexMustCreate();
	ezcaDone  = epicsEventMustCreate(epicsEventEmpty);
#else
    Initialized = TRUE;
#endif

    EzcaInitializeChannelAccess();

    Channel_avail_hdr = (struct channel *) NULL;
    Monitor_avail_hdr = (struct monitor *) NULL;
    Work_avail_hdr = (struct work *) NULL;
    Workp = (struct work *) NULL;

    Discarded_channels = (struct channel *) NULL;
    Discarded_monitors = (struct monitor *) NULL;
    Discarded_work = (struct work *) NULL;

    Work_list.head = (struct work *) NULL;
    Work_list.tail = (struct work *) NULL;

    for (i = 0; i < HASHTABLESIZE; i ++)
	Channels[i] = (struct channel *) NULL;

    ErrorLocation = SINGLEWORK;
    ListPrint = LASTONLY;

    /* Default Values for User Configurable Global Parameters */
    AutoErrorMessage = TRUE;
    InGroup = FALSE;
    TimeoutSeconds = (float)0.2;
    SavedRetryCount = RetryCount = 75;

    Debug = FALSE;
    Trace = FALSE;

} /* end init() */

/****************************************************************
*
* Returns TRUE iff actually issued EzcaArrayGetCallback() and it
* returned successfully.
*
* If something went wrong, then changes wp->rc and wp->error_msg, 
* otherwise they're left alone.
*
****************************************************************/

static BOOL issue_get(struct work *wp, struct channel *cp)
{

BOOL rc;

    if (wp && cp)
    {
	if (EzcaConnected(cp))
	{
	    if (wp->nelem <= (int)EzcaElementCount(cp))
	    {
		wp->reported = FALSE;

		if (EzcaArrayGetCallback(wp, cp) == ECA_NORMAL)
		    rc = TRUE;
		else
		{
		    /* something went wrong ... rc and */
		    /* error msg have already been set */

		    /* need to trash this wp so it's */
		    /* never used again in case the  */
		    /* callback fires off later      */

		    rc = FALSE;

		    wp->trashme = trashed;
		    if (Debug)
			printf("trashing wp %p\n", wp);
		} /* endif */
	    }
	    else
	    {
		/* too many requested elements */
		rc = FALSE;

		wp->rc = EZCA_INVALIDARG;
		wp->error_msg = ErrorMsgs[TOO_MANY_NELEM_MSG_IDX];

		if (AutoErrorMessage)
		    print_error(wp);
	    } /* endif */
	} 
	else
	    rc = FALSE;
    }
    else
    {
	fprintf(stderr, "EZCA FATAL ERROR: issue_get() got wp %p cp %p\n", 
	    wp, cp);
	exit(1);
    } /* endif */

    return rc;

} /* end issue_get() */

/****************************************************************
*
* assumed upon entry that wp->rc is already = EZCA_OK
*
****************************************************************/

static void issue_wait(struct work *wp)
{

BOOL reported, error;
unsigned attempts;

    if (wp)
    {
	MARK_OUTSTANDING(1);

	for (reported = FALSE, error = FALSE, attempts = 0;
	    !reported && !error && attempts <= RetryCount; 
		attempts ++)
	{
	    if (Trace || Debug)
		printf("issue_wait(): attempt %d of %d\n", 
		    attempts+1, RetryCount+1);

	    if (EzcaPendEvent(wp, TimeoutSeconds, FALSE) == ECA_TIMEOUT)
		reported = wp->reported;
	    else
	    {
		/* something went wrong ... rc and */
		/* error msg have already been set */

		/* need to trash this wp so it's */
		/* never used again in case the  */
		/* callback fires off later      */

		error = TRUE;

		wp->trashme = trashed;

		if (Debug)
		    printf("trashing wp %p\n", wp);
	    } /* endif */
	} /* endfor */

	if (!reported && !error)
	{
	    /* callback did not respond back */
	    /* int time no value received    */

	    /* need to trash this wp so it's */
	    /* never used again in case the  */
	    /* callback fires off later      */

		if ( RetryCount )
		{
	    	wp->rc = EZCA_NOTIMELYRESPONSE;
	    	wp->error_msg = ErrorMsgs[NO_RESPONSE_IN_TIME_MSG_IDX];
		}
		else
		{
			wp->rc = EZCA_ABORTED;
			wp->error_msg = ErrorMsgs[ABORTED_MSG_IDX];
		}

	    if (AutoErrorMessage)
		print_error(wp);
	    wp->trashme = trashed;

	    if (Debug)
		printf("trashing wp %p\n", wp);
	} /* endif */
    } 
    else
    {
	fprintf(stderr, "EZCA FATAL ERROR: issue_wait() got NULL wp\n");
	exit(1);
    } /* endif */

} /* end issue_wait() */

/****************************************************************
*
*
****************************************************************/

static void print_error(struct work *wp)
{

    if (wp)
    {
	if (wp->rc == EZCA_OK)
	    printf("%s\n", OKMSG);
	else
	{
	    if (wp->error_msg || wp->aux_error_msg)
	    {
		if (wp->error_msg)
		    printf("%s", wp->error_msg);
		if (wp->aux_error_msg)
		    printf(" : %s", wp->aux_error_msg);
		printf("\n");
	    } /* endif */
	} /* endif */
    } /* endif */

} /* end print_error() */

/****************************************************************
*
* this gets called at the beginning of all the ezca routines.
* since there is no work node to place the return code from
* ca_pend_event(), we must print error messages directly from 
* here when a non-ok rc (ok means ECA_TIMEOUT) comes from ca_pend_event().
*
****************************************************************/

static void prologue()
{

int rc;

	DO_INIT_ONCE();

	EZCA_LOCK();

    /* restore retry count in case they aborted */
    RetryCount = SavedRetryCount;

    {
	if (!InGroup)
	{
	    /* whole purpose of being InGroup is so that ca_pend_event() */
	    /* can be done at ezcaEndGroup() */

	    rc = EzcaPendEvent((struct work *) NULL, SHORT_TIME, TRUE);

	    if (rc != ECA_TIMEOUT)
		fprintf(stderr, "%s: %s", PROLOGUE_MSG, ca_message(rc));
	} /* endif */
    } /* endif */

    if (Debug)
    {
	printf("--start end-of-prologue() report\n");
	print_state();
	printf("--end end-of-prologue() report\n");
    } /* endif */

} /* end prologue() */

static void epilogue()
{
	EZCA_UNLOCK();
}

/**************************************/
/*                                    */
/* Channel Access Interface Functions */
/*                                    */
/**************************************/

/****************************************************************
*
* if evertything goes ok, then wp is unchanged.
*
* if something went wrong, wp->rc = EZCA_CAFAILURE
* and wp->error_msg is set.
*
****************************************************************/

static int EzcaAddArrayEvent(struct work *wp, struct monitor *mp, unsigned long count)
{

int rc;

    if (!wp || !mp || !(mp->cp))
    {
	fprintf(stderr, 
	    "EZCA FATAL ERROR: EzcaAddEvent() got wp %p mp %p mp->cp %p\n", 
	    wp, mp, mp->cp);
	exit(1);
    } /* endif */

    switch (mp->ezcadatatype)
    {
	case ezcaByte:   mp->dbr_type = DBR_TIME_CHAR;   break;
	case ezcaString: mp->dbr_type = DBR_TIME_STRING; break;
	case ezcaShort:  mp->dbr_type = DBR_TIME_SHORT;  break;
	case ezcaLong:   mp->dbr_type = DBR_TIME_LONG;   break;
	case ezcaFloat:  mp->dbr_type = DBR_TIME_FLOAT;  break;
	case ezcaDouble: mp->dbr_type = DBR_TIME_DOUBLE; break;
	default: 
	    fprintf(stderr, 
    "EZCA FATAL ERROR: EzcaAddEvent() got unrecognizable ezca data type %d\n", 
		mp->ezcadatatype);
	    exit(1);
	    break;
    } /* end switch() */

    if (Trace || Debug)
    {
	printf("ca_add_array_event(ezcatype (%d)->dbrtype (%d) >%s<)\n", 
	    mp->ezcadatatype, mp->dbr_type, (mp->cp)->pvname); 

	if (Debug)
	    print_state();
    } /* endif */

    rc = ca_add_array_event(mp->dbr_type, count, (mp->cp)->cid, 
	    my_monitor_callback, (void *) mp, (float) 0, (float) 0, (float) 0, 
	    &(mp->evd));

    if (rc != ECA_NORMAL)
    {
	wp->rc = EZCA_CAFAILURE;

	wp->error_msg = ErrorMsgs[CAADDARRAYEVENT_MSG_IDX];
	wp->aux_error_msg = strdup(ca_message(rc));

	if (AutoErrorMessage)
	    print_error(wp);
    } /* endif */

    return rc;

} /* end EzcaAddEvent() */

/****************************************************************
*
* don't care what this returns ... the channels are always removed
* from the channel list so they will never be used again.  
* the worst that could happen is that the channels are
* not cleared.
*
* Channel access will segmentation fault if you attempt to ca_clear_channel()
* that has never had a search done on it.
*
****************************************************************/

static int EzcaClearChannel(struct channel *cp)
{
int rval = 0;
    if (cp
#ifndef EPICS_THREE_FOURTEEN
 && cp->ever_successfully_searched
#endif
		) {
	/* ca_clear_channel() waits for user CB to complete;
	 * we must unlock to prevent deadlock.
	 */
	EZCA_UNLOCK();
	rval = ECA_NORMAL == ca_clear_channel(cp->cid) ? 0 : -1;
	EZCA_LOCK();
	}
	return rval;
} /* end EzcaClearChannel() */

/****************************************************************
*
* don't care what this returns ... the monitors are always removed
* from the channel's monitor lists so they will never be used
* again.  the worst that could happen is that the monitors are
* not cleared and we waste time in the callback routines.
*
* TS: Do care what it returns. If it returns ECA_NORMAL, it seems
*     to be OK to reuse the monitor. CA will not invoke the callback
*     on successfully cancelled monitors. The callback is removed
*     prior to sending the cancel request to the server (checked
*     back to 3.13.0beta4).
*
****************************************************************/

static int EzcaClearEvent(struct monitor *mp)
{
	return mp ? ca_clear_event(mp->evd) : ECA_NORMAL;
} /* end EzcaClearEvent() */

/****************************************************************
*
*
****************************************************************/

static BOOL EzcaConnected(struct channel *cp)
{

BOOL rc;

    if (cp) {
	rc = (cp->ever_successfully_searched && ca_state(cp->cid) == cs_conn);
	if ( rc )
		cp->ever_successfully_searched = CONNECTED;
    }
	else
    {
	fprintf(stderr, "EZCA WARNING: EzcaConnected() rcvd NULL cp\n");
	rc = FALSE;
    } /* endif */

    return rc;

} /* end EzcaConnected() */

/****************************************************************
*
* this function chooses a dbr_xxx type for ca_array_get_callback() 
* based on the worktype
*
* this function gets called under 1 of 2 worktype's
*     Type 1: GET (val), GETSTATUS (time, stat, sevr), 
*	     or GETWITHSTATUS(val, time,stat, sevr)
*        here a DBR_TIME_XXXX based on wp->dbr_type
*     Type 2: GETUNITS, GETGRAPHICLIMITS, GETCONTROLLIMITS, 
*        GETWARNLIMITS, GETALARMLIMITS or GETPRECISION, GETENUMSTATES
*        here a DBR_CTRL_XXXX based on native type
*        Note: native type = DBR_STRING, none of these wortype
*              requests are defined.
*        Note: GETPRECISION defined for native type DBR_FLOAT or DBR_DOUBLE
*        Note: GETENUMSTATES defined for native type DBR_ENUM
*
* if evertything goes ok, then wp is unchanged.
*
* if something went wrong, 
*     wp->rc = EZCA_UDFREQ (tried to ask for something that was undefined
*                           by the native data type ... only Type 2 worktypes)
*     wp->rc = EZCA_CAFAILURE (bad rc from ca_array_get_callback())
* in either case, wp->error_msg is set.
*
****************************************************************/

static int EzcaArrayGetCallback(struct work *wp, struct channel *cp)
{

int rc;

    if (!wp || !cp)
    {
	fprintf(stderr, 
	    "EZCA FATAL ERROR: EzcaArrayGetCallback() got wp %p cp %p\n", 
	    wp, cp);
	exit(1);
    } /* endif */

    rc = ECA_NORMAL;

    if (wp->worktype == GET || wp->worktype == GETWITHSTATUS)
    {
	/* requesting dbr_time_xxxx based on request type */
	switch (wp->ezcadatatype)
	{
	    case ezcaByte:   wp->dbr_type = DBR_TIME_CHAR;   break;
	    case ezcaString: wp->dbr_type = DBR_TIME_STRING; break;
	    case ezcaShort:  wp->dbr_type = DBR_TIME_SHORT;  break;
	    case ezcaLong:   wp->dbr_type = DBR_TIME_LONG;   break;
	    case ezcaFloat:  wp->dbr_type = DBR_TIME_FLOAT;  break;
	    case ezcaDouble: wp->dbr_type = DBR_TIME_DOUBLE; break;
	    default: 
		fprintf(stderr, 
"EZCA FATAL ERROR: EzcaArrayGetCallback() got unknown ezca data type %d\n", 
		    wp->ezcadatatype);
		exit(1);
		break;
	} /* end switch() */
    }
    else if (wp->worktype == GETSTATUS)
    {
	/* requesting dbr_time_xxxx based on native type */
	if (EzcaConnected(cp))
	{
	    switch (EzcaNativeType(cp))
	    {
		case DBF_ENUM:   wp->dbr_type = DBR_TIME_ENUM;   break;
		case DBF_CHAR:   wp->dbr_type = DBR_TIME_CHAR;   break;
		case DBF_STRING: wp->dbr_type = DBR_TIME_STRING; break;
		/* case DBF_INT = DBF_SHORT:  */
		case DBF_SHORT:  wp->dbr_type = DBR_TIME_SHORT;  break;
		case DBF_LONG:   wp->dbr_type = DBR_TIME_LONG;   break;
		case DBF_FLOAT:  wp->dbr_type = DBR_TIME_FLOAT;  break;
		case DBF_DOUBLE: wp->dbr_type = DBR_TIME_DOUBLE; break;
		default:
		    fprintf(stderr, 
	    "EZCA FATAL ERROR: EzcaArrayGetCallback() unknown dbr type %x\n",
			EzcaNativeType(cp));
		    exit(1);
		    break;
	    } /* end switch() */
	}
	else
	{
	    rc = wp->rc = EZCA_CAFAILURE;
	    wp->error_msg = ErrorMsgs[CAARRAYGETCALL_MSG_IDX];
	    wp->aux_error_msg = strdup(ECA_BADCHID_MSG);

	    if (AutoErrorMessage)
		print_error(wp);
	} /* endif */
    }
    else if (wp->worktype == GETUNITS || wp->worktype == GETGRAPHICLIMITS 
	|| wp->worktype == GETWARNLIMITS || wp->worktype == GETALARMLIMITS
	|| wp->worktype == GETCONTROLLIMITS || wp->worktype == GETPRECISION
	|| wp->worktype == GETENUMSTATES)
    {
	/* requesting dbr_ctrl_xxxx based on native type */
	if (EzcaConnected(cp))
	{
	    switch (EzcaNativeType(cp))
	    {
		case DBF_ENUM:
			if ( GETENUMSTATES == wp->worktype )
			{
				wp->dbr_type = DBR_CTRL_ENUM;
				break;
			}
			/* else FALL THRU */

		case DBF_STRING:
		    /* units, gr limits, ctrl limits, precision are  */
		    /* all undefined for native type string and enum */

		    rc = wp->rc = EZCA_UDFREQ;

		    wp->error_msg = ErrorMsgs[CAARRAYGETCALL_MSG_IDX];
		    wp->aux_error_msg = strdup(UDFREQ_MSG);

		    if (AutoErrorMessage)
			print_error(wp);
		    break;
		/* case DBF_INT = DBF_SHORT:  */
		case DBF_SHORT:
		    if (wp->worktype != GETPRECISION)
			wp->dbr_type = DBR_CTRL_SHORT;
		    else
		    {
			/* precision undefined */
			rc = wp->rc = EZCA_UDFREQ;
			wp->error_msg = ErrorMsgs[CAARRAYGETCALL_MSG_IDX];
			wp->aux_error_msg = strdup(UDFREQ_MSG);

			if (AutoErrorMessage)
			    print_error(wp);
		    } /* endif */
		    break;
		case DBF_FLOAT:
		    wp->dbr_type = DBR_CTRL_FLOAT;
		    break;
		case DBF_CHAR:
		    if (wp->worktype != GETPRECISION)
			wp->dbr_type = DBR_CTRL_CHAR;
		    else
		    {
			/* precision undefined */
			rc = wp->rc = EZCA_UDFREQ;
			wp->error_msg = ErrorMsgs[CAARRAYGETCALL_MSG_IDX];
			wp->aux_error_msg = strdup(UDFREQ_MSG);

			if (AutoErrorMessage)
			    print_error(wp);
		    } /* endif */
		    break;
		case DBF_LONG:
		    if (wp->worktype != GETPRECISION)
			wp->dbr_type = DBR_CTRL_LONG;
		    else
		    {
			/* precision undefined */
			rc = wp->rc = EZCA_UDFREQ;
			wp->error_msg = ErrorMsgs[CAARRAYGETCALL_MSG_IDX];
			wp->aux_error_msg = strdup(UDFREQ_MSG);

			if (AutoErrorMessage)
			    print_error(wp);
		    } /* endif */
		    break;
		case DBF_DOUBLE:
		    wp->dbr_type = DBR_CTRL_DOUBLE;
		    break;
		default:
		    fprintf(stderr, 
	    "EZCA FATAL ERROR: EzcaArrayGetCallback() unknown dbr type %x\n",
			EzcaNativeType(cp));
		    exit(1);
		    break;
	    } /* end switch() */
	}
	else
	{
	    rc = wp->rc = EZCA_CAFAILURE;
	    wp->error_msg = ErrorMsgs[CAARRAYGETCALL_MSG_IDX];
	    wp->aux_error_msg = strdup(ECA_BADCHID_MSG);

	    if (AutoErrorMessage)
		print_error(wp);
	} /* endif */
    }
    else
    {
	fprintf(stderr, 
	"EZCA FATAL ERROR: EzcaArrayGetCallback() got unknown worktype %d\n", 
	    wp->worktype);
	exit(1);
    } /* endif */

    if (rc == ECA_NORMAL)
    {
	if (Trace || Debug)
	{
	    printf("ca_array_get_callback(dbrtype (%d) >%s<)\n", 
		wp->dbr_type, wp->pvname); 

	    if (Debug)
		print_state();
	} /* endif */

	rc = ca_array_get_callback(wp->dbr_type, (unsigned long) wp->nelem,
		    cp->cid, my_get_callback, (void *) wp);

	if (rc != ECA_NORMAL)
	{
	    wp->rc = EZCA_CAFAILURE;
	    wp->error_msg = ErrorMsgs[CAARRAYGETCALL_MSG_IDX];
	    wp->aux_error_msg = strdup(ca_message(rc));

	    if (AutoErrorMessage)
		print_error(wp);
	} /* endif */
    } /* endif */

    return rc;

} /* end EzcaArrayGetCallback() */

/****************************************************************
*
* if evertything goes ok, then wp is unchanged.
*
* if something went wrong, wp->rc = EZCA_CAFAILURE
* and wp->error_msg is set.
*
****************************************************************/

static int EzcaArrayPutCallback(struct work *wp, struct channel *cp)
{

int rc;

    if (!wp || !cp)
    {
	fprintf(stderr, 
	    "EZCA FATAL ERROR: EzcaArrayPutCallback() got wp %p cp %p\n", 
	    wp, cp);
	exit(1);
    } /* endif */

    switch (wp->ezcadatatype)
    {
	case ezcaByte:   wp->dbr_type = DBR_CHAR;   break;
	case ezcaString: wp->dbr_type = DBR_STRING; break;
	case ezcaShort:  wp->dbr_type = DBR_SHORT;  break;
	case ezcaLong:   wp->dbr_type = DBR_LONG;   break;
	case ezcaFloat:  wp->dbr_type = DBR_FLOAT;  break;
	case ezcaDouble: wp->dbr_type = DBR_DOUBLE; break;
	default: 
	    fprintf(stderr, 
"EZCA FATAL ERROR: EzcaArrayPutCallback() got unrecognizable ezca data type %d\n", 
		wp->ezcadatatype);
	    exit(1);
	    break;
    } /* end switch() */

    if (Trace || Debug)
    {
printf("ca_array_put_callback(ezcatype (%d)->dbrtype (%d), nelem %d, >%s<, wp->pval %p)\n", 
	    wp->ezcadatatype, wp->dbr_type, wp->nelem, wp->pvname, wp->pval); 

	if (Debug)
	    print_state();
    } /* endif */

    rc = ca_array_put_callback(wp->dbr_type, (unsigned long) wp->nelem,
		cp->cid, wp->pval, my_put_callback, (void *) wp);

    if (rc != ECA_NORMAL)
    {
	wp->rc = EZCA_CAFAILURE;
	wp->error_msg = ErrorMsgs[CAARRAYPUTCALL_MSG_IDX];
	wp->aux_error_msg = strdup(ca_message(rc));

	if (AutoErrorMessage)
	    print_error(wp);
    } /* endif */

    return rc;

} /* end EzcaArrayPutCallback() */

/****************************************************************
*
* if evertything goes ok, then wp is unchanged.
*
* if something went wrong, wp->rc = EZCA_CAFAILURE
* and wp->error_msg is set.
*
****************************************************************/

static int EzcaArrayPut(struct work *wp, struct channel *cp)
{

int rc;

    if (!wp || !cp)
    {
	fprintf(stderr, 
	    "EZCA FATAL ERROR: EzcaArrayPut() got wp %p cp %p\n", wp, cp);
	exit(1);
    } /* endif */

    switch (wp->ezcadatatype)
    {
	case ezcaByte:   wp->dbr_type = DBR_CHAR;   break;
	case ezcaString: wp->dbr_type = DBR_STRING; break;
	case ezcaShort:  wp->dbr_type = DBR_SHORT;  break;
	case ezcaLong:   wp->dbr_type = DBR_LONG;   break;
	case ezcaFloat:  wp->dbr_type = DBR_FLOAT;  break;
	case ezcaDouble: wp->dbr_type = DBR_DOUBLE; break;
	default: 
	    fprintf(stderr, 
    "EZCA FATAL ERROR: EzcaArrayPut() got unrecognizable ezca data type %d\n", 
		wp->ezcadatatype);
	    exit(1);
	    break;
    } /* end switch() */

    if (Trace || Debug)
    {
printf("ca_array_put(ezcatype (%d)->dbrtype (%d), nelem %d, >%s<, wp->pval %p)\n", 
	    wp->ezcadatatype, wp->dbr_type, wp->nelem, wp->pvname, wp->pval); 

	if (Debug)
	    print_state();
    } /* endif */

    rc = ca_array_put(wp->dbr_type, (unsigned long) wp->nelem,
	    cp->cid, wp->pval);

    if (rc != ECA_NORMAL)
    {
	wp->rc = EZCA_CAFAILURE;
	wp->error_msg = ErrorMsgs[CAARRAYPUT_MSG_IDX];
	wp->aux_error_msg = strdup(ca_message(rc));

	if (AutoErrorMessage)
	    print_error(wp);
    } /* endif */

    return rc;

} /* end EzcaArrayPut() */

/****************************************************************
*
*
****************************************************************/

static unsigned EzcaElementCount(struct channel *cp)
{

unsigned rc;

    if (cp)
	rc = ca_element_count(cp->cid);
    else
    {
	fprintf(stderr, "EZCA WARNING: EzcaElementCount() rcvd NULL cp\n");
	rc = (unsigned) 0;
    } /* endif */

    return rc;

} /* end EzcaElementCount() */

/****************************************************************
*
*
****************************************************************/

static void EzcaInitializeChannelAccess()
{
    if (Trace || Debug)
	printf("ca_task_initialize()\n");

#ifdef EPICS_THREE_FOURTEEN
    ca_context_create(ca_enable_preemptive_callback);
#else
    ca_task_initialize();
#endif

} /* end initialize_channel_access() */

/****************************************************************
*
*
****************************************************************/

static int EzcaNativeType(struct channel *cp)
{

int rc;

    if (cp)
	rc = (int) ca_field_type(cp->cid);
    else
    {
	fprintf(stderr, "EZCA FATAL ERROR: EzcaNativeType() rcvd NULL cp\n");
	exit(1);
    } /* endif */

    return rc;

} /* end EzcaNativeType() */

/****************************************************************
*
* if not passed a struct work *wp then called in prologue just
* to give CA an opportunity to do what it needs to do or called
* in ezcaEndGroup for group waits ... in either case, not
* associated with any single piece of work ... just done any
* time a EZCA call made. Hence there is no place to put any error message.
*
* if struct work passed and anything other than ECA_TIMEOUT returned,
* then wp->rc and wp->error_message set appropriately.
*
****************************************************************/

static int EzcaPendEvent(struct work *wp, float sec, BOOL realPend)
{

int rc;

    if (Trace || Debug)
	printf("ca_pend_event(%f)\n", (sec > 0 ? sec : SHORT_TIME));

	if ( pollCb && pollCb() ) {
		rc = ECA_TIMEOUT;
	} else {
		if ( realPend )
			MARK_OUTSTANDING(0);
    	if (sec <= 0.)
			sec = SHORT_TIME;
EZCA_UNLOCK();
#ifdef EPICS_THREE_FOURTEEN
		if ( realPend )
			rc = ca_pend_event(sec);
		else {
			switch (epicsEventWaitWithTimeout(ezcaDone, sec)) {
				case epicsEventWaitOK:
				case epicsEventWaitTimeout:
					rc = ECA_TIMEOUT;
				break;
				default:
					rc = ECA_INTERNAL;
			}
		}
#else
		rc =  ca_pend_event(sec);
#endif
EZCA_LOCK();
	}

    if (wp)
    {
	if (rc != ECA_TIMEOUT)
	{
	    wp->rc = EZCA_CAFAILURE;
	    wp->error_msg = ErrorMsgs[CAPENDEVENT_MSG_IDX];
	    wp->aux_error_msg = strdup(ca_message(rc));

	    if (AutoErrorMessage)
		print_error(wp);
	} /* endif */
    } /* endif */

    return rc;

} /* end EzcaPendEvent() */

/****************************************************************
*
* if not passed a wp, then just being called to flush the buffer
* with CA calls that we don't care about ... ca_clear_event() or
* ca_clear_channel().
*
* if evertything goes ok, then wp is unchanged.
*
* if something went wrong, wp->rc = EZCA_CAFAILURE
* and wp->error_msg is set.
*
****************************************************************/

static int EzcaPendIO(struct work *wp, float sec)
{

int rc;

    if (Trace || Debug)
	printf("ca_pend_io(%f)\n", (sec > 0 ? sec : SHORT_TIME));

	if ( pollCb && pollCb() ) {
		rc = ECA_TIMEOUT;
	} else {
EZCA_UNLOCK();
    if (sec > 0)
	rc = ca_pend_io(sec);
    else
	rc = ca_pend_io(SHORT_TIME);
EZCA_LOCK();
	}

    if (wp)
    {
	if (rc != ECA_NORMAL)
	{
	    wp->rc = EZCA_CAFAILURE;
	    wp->error_msg = ErrorMsgs[CAPENDIO_MSG_IDX];
	    wp->aux_error_msg = strdup(ca_message(rc));

	    if (AutoErrorMessage)
		print_error(wp);
	} /* endif */
    } /* endif */

    return rc;

} /* end EzcaQueuePendIO() */

/****************************************************************
*
* if evertything goes ok, then wp is unchanged.
*
* if something went wrong, wp->rc = EZCA_CAFAILURE
* and wp->error_msg is set.
*
****************************************************************/

static int EzcaQueueSearchAndConnect(struct work *wp, struct channel *cp)
{

int rc;

    if (!wp || !cp)
    {
	fprintf(stderr, 
	    "EZCA FATAL ERROR: EzcaQueueSearchAndConnect() got wp %p cp %p\n", wp, cp);
	exit(1);
    } /* endif */

    if (Trace || Debug)
	printf("ca_search_and_connect(>%s<)\n", wp->pvname);

	/* Mark this CHID as 'not-reported' by setting puser
	 * to non-null (we use 'wp' as a marker)
	 */
    rc = ca_search_and_connect(wp->pvname, &(cp->cid), 
	    my_connection_callback, (void *) wp);

    if (rc == ECA_NORMAL)
	{
	/* tell them to report back */
	cp->ever_successfully_searched = SEARCHED;
	}
    else
    {
	wp->rc = EZCA_CAFAILURE;
	wp->error_msg = ErrorMsgs[CASEARCHANDCONNECT_MSG_IDX];
	wp->aux_error_msg = strdup(ca_message(rc));

	if (AutoErrorMessage)
	    print_error(wp);
    } /* endif */

    return rc;

} /* end EzcaQueueSearchAndConnect() */

/*************/
/*           */
/* Callbacks */
/*           */
/*************/

/****************************************************************
*
* from epicsH/cadef.h
* struct  connection_handler_args
* {
*     chid chid;    Channel id
*     long op;      External codes for channel access operations
* };
*
* Presumably a ca_search_and_connect() has been previously called which 
* named this routine as the callback.  This is an empty function, we
* don't care *when* channels become connected/disconnected.  All we
* care about is their connection status when we want to use them.
* According to the CA user's manual, we have to supply a non-NULL
* connection handler routine for things to work properly ... so here
* it is.
*
* As an interesting side quesiton:  
*     When we did the the ca_search_and_connect() we could have passed
*     a user arg that would be passed to this routine.  We did not pass
*     one, but if we did, where would we find it in struct 
*     connection_handler_args?
*
****************************************************************/

static void my_connection_callback(struct connection_handler_args arg)
{
EZCA_LOCK();
/* TODO: should we try to recycle trashed work nodes
 *       referring to disconnected channels here?
 */
if ( Trace || Debug ) {
	char *msg = "???";
	switch ( arg.op ) {
		case CA_OP_CONN_UP:   msg = "UP";   break;
		case CA_OP_CONN_DOWN: msg = "DOWN"; break;
		default:
		break;
	}
	printf("my_connection_callback: %s\n", msg);
}
	/* should we report ? */
	if ( ca_puser(arg.chid) && CA_OP_CONN_UP == arg.op  ) {
		ca_set_puser(arg.chid, 0);
		POST_DONE();	
	}
EZCA_UNLOCK();
} /* end my_connection_callback() */

/****************************************************************
*
* from epicsH/cadef.h
* struct  event_handler_args
* {
*     void *usr;   User argument supplied when event added
*     chid chid;   Channel id
*     long type;   the type of the value returned (long aligned)
*     long count;  the element count of the item returned
*     void *dbr;   Pointer to the value returned
*     int status; CA Status of the op from server - CA V4.1 
* };
*
* Presumably a ca_array_get_callback() has been previously called which 
* named this routine as the callback.  The request type was either
* DBR_TIME_XXXX (GET, GETSTATUS, GETWITHSTATUS) where XXXX is the
* user-specified request type or DBR_CTRL_XXXX (GETUNITS, GETPRECISION, 
* GETGRAPHICLIMITS, GETCONTROLLIMITS, GETWARNLIMITS, GETALARMLIMITS, GETENUMSTATES)
* where XXXX is the native data type.
*
* Presumably, wp that is passed here has been set up properly based upon
* the work type ... sometimes we copy values, sometimes status and severity, ...
*
* The actual data is sitting in the dbr field.
*
* In the event that arg.count > 1, the value is still sitting the the dbr
* field, but as an array that starts at the dbr field.
*
****************************************************************/

static void my_get_callback(struct event_handler_args arg)
{

struct work *wp;
int nbytes;

EZCA_LOCK();
    if (Trace || Debug)
	printf("entering my_get_callback()\n");

    if ((wp = (struct work *) arg.usr))
    {
	if (usable == wp->trashme)
	{
	    if (Trace || Debug)
		printf("my_get_callback() pvname >%s<\n", wp->pvname);

	    if (arg.status == ECA_NORMAL)
	    {
		/* checking that channel access gave us what we asked for */
		if (arg.type == wp->dbr_type)
		{
		    if (Trace || Debug)
	printf("my_get_callback() ezcadatatype %d (arg.type %ld) worktype %d\n",
			wp->ezcadatatype, arg.type, wp->worktype);

		    switch (arg.type)
		    {
			/* GET, GETSTATUS, or GETWITHSTATUS */

			case DBR_TIME_ENUM:   
			    /* only valid if worktype is GETSTATUS */
			    /* this is because a call to ezcaGetStatus() */
			    /* does not allow the user to specify an     */
			    /* ezcadatatype, so we use the native type.  */
			    /* the native data type might be enum and    */
			    /* there's nothing wrong with asking for the */
			    /* time, stat, and sev of an enum.           */
			    if (wp->worktype == GETSTATUS)
			    {
				/* must copy status, severity, and time */
				if (wp->status && wp->severity && wp->tsp)
				{
				    *(wp->status) = 
					((struct dbr_time_enum *) arg.dbr)->status;
				    *(wp->severity) = 
				    ((struct dbr_time_enum *) arg.dbr)->severity;
				    copy_time_stamp(wp->tsp, 
				    &(((struct dbr_time_enum *) arg.dbr)->stamp));

				    if (Trace || Debug)
	printf("my_get_callback() just copied status %d, severity %d, and time\n", *(wp->status), *(wp->severity));
				} 
				else
				{
				    fprintf(stderr, 
    "EZCA FATAL ERROR: my_get_callback() wp->worktype %d wp->status %p wp->severity %p wp->tsp %p\n",
					wp->worktype, wp->status, wp->severity,
					wp->tsp);
				    exit(1);
				} /* endif */
			    }
			    else
			    {
				fprintf(stderr, 
    "EZCA FATAL ERROR: my_get_callback() found arg.type DBR_TIME_ENUM %ld with wp->worktype %d\n",
				    arg.type, wp->worktype);
				exit(1);
			    } /* endif */
			    break;
			case DBR_TIME_CHAR:   
			    if (wp->worktype == GET 
				|| wp->worktype == GETWITHSTATUS 
				|| wp->worktype == GETSTATUS)
			    {
				if (wp->worktype == GET 
				    || wp->worktype == GETWITHSTATUS)
				{
				    /* must copy value */
				    if (arg.count == wp->nelem)
				    {
					nbytes = arg.count*dbr_value_size[arg.type];

					if (Trace || Debug)
    printf("my_get_callback() size %d X count %ld = nbytes %d ezcadatatype %d -> dbrtype %d\n", 
						dbr_value_size[arg.type], arg.count,
						nbytes, wp->ezcadatatype, 
						wp->dbr_type);

					if (wp->pval)
					{
					    memcpy((char *) (wp->pval), 
			    (char *) &(((struct dbr_time_char *) arg.dbr)->value),
						nbytes);

					    if (Trace || Debug)
			    printf("my_get_callback() just memcpy %d bytes to %p\n",
						nbytes, wp->pval);
					}
					else
					{
					    fprintf(stderr, 
	"EZCA FATAL ERROR: my_get_callback() wp->worktype %d with NULL wp->pval\n",
						wp->worktype);
					    exit(1);
					} /* endif */
				    }
				    else
				    {
					fprintf(stderr, 
	    "EZCA FATAL ERROR: my_get_callback() got %ld nelem when asked for %d\n",
					    arg.count, wp->nelem);
					exit(1);
				    } /* endif */
				} /* endif */

				if (wp->worktype == GETSTATUS 
				    || wp->worktype == GETWITHSTATUS)
				{
				    /* must copy status, severity, and time */
				    if (wp->status && wp->severity && wp->tsp)
				    {
					*(wp->status) = 
					((struct dbr_time_char *) arg.dbr)->status;
					*(wp->severity) = 
				    ((struct dbr_time_char *) arg.dbr)->severity;
					copy_time_stamp(wp->tsp, 
				    &(((struct dbr_time_char *) arg.dbr)->stamp));

					if (Trace || Debug)
	printf("my_get_callback() just copied status %d, severity %d, and time\n", *(wp->status), *(wp->severity));
				    } 
				    else
				    {
					fprintf(stderr, 
    "EZCA FATAL ERROR: my_get_callback() wp->worktype %d wp->status %p wp->severity %p wp->tsp %p\n",
					    wp->worktype, wp->status, wp->severity,
					    wp->tsp);
					exit(1);
				    } /* endif */
				} /* endif */
			    }
			    else
			    {
				fprintf(stderr, 
    "EZCA FATAL ERROR: my_get_callback() found arg.type DBR_TIME_CHAR %ld with wp->worktype %d\n",
				    arg.type, wp->worktype);
				exit(1);
			    } /* endif */
			    break;
			case DBR_TIME_STRING:  
			    if (wp->worktype == GET 
				|| wp->worktype == GETWITHSTATUS 
				|| wp->worktype == GETSTATUS)
			    {
				if (wp->worktype == GET 
				    || wp->worktype == GETWITHSTATUS)
				{
				    /* must copy value */
				    if (arg.count == wp->nelem)
				    {
					nbytes = arg.count*dbr_value_size[arg.type];

					if (Trace || Debug)
    printf("my_get_callback() size %d X count %ld = nbytes %d ezcadatatype %d -> dbrtype %d\n", 
						dbr_value_size[arg.type], arg.count,
						nbytes, wp->ezcadatatype, 
						wp->dbr_type);

					if (wp->pval)
					{
					    memcpy((char *) (wp->pval), 
			    (char *) &(((struct dbr_time_string *) arg.dbr)->value),
						nbytes);

					    if (Trace || Debug)
			    printf("my_get_callback() just memcpy %d bytes to %p\n",
						nbytes, wp->pval);
					}
					else
					{
					    fprintf(stderr, 
	"EZCA FATAL ERROR: my_get_callback() wp->worktype %d with NULL wp->pval\n",
						wp->worktype);
					    exit(1);
					} /* endif */
				    }
				    else
				    {
					fprintf(stderr, 
	    "EZCA FATAL ERROR: my_get_callback() got %ld nelem when asked for %d\n",
					    arg.count, wp->nelem);
					exit(1);
				    } /* endif */
				} /* endif */

				if (wp->worktype == GETSTATUS 
				    || wp->worktype == GETWITHSTATUS)
				{
				    /* must copy status, severity, and time */
				    if (wp->status && wp->severity && wp->tsp)
				    {
					*(wp->status) = 
				    ((struct dbr_time_string *) arg.dbr)->status;
					*(wp->severity) = 
				    ((struct dbr_time_string *) arg.dbr)->severity;
					copy_time_stamp(wp->tsp, 
				    &(((struct dbr_time_string *) arg.dbr)->stamp));

					if (Trace || Debug)
	printf("my_get_callback() just copied status %d, severity %d, and time\n", *(wp->status), *(wp->severity));
				    } 
				    else
				    {
					fprintf(stderr, 
    "EZCA FATAL ERROR: my_get_callback() wp->worktype %d wp->status %p wp->severity %p wp->tsp %p\n",
					    wp->worktype, wp->status, wp->severity,
					    wp->tsp);
					exit(1);
				    } /* endif */
				} /* endif */
			    }
			    else
			    {
				fprintf(stderr, 
    "EZCA FATAL ERROR: my_get_callback() found arg.type DBR_TIME_STRING %ld with wp->worktype %d\n",
				    arg.type, wp->worktype);
				exit(1);
			    } /* endif */
			    break;
			case DBR_TIME_SHORT:    
			    if (wp->worktype == GET 
				|| wp->worktype == GETWITHSTATUS 
				|| wp->worktype == GETSTATUS)
			    {
				if (wp->worktype == GET 
				    || wp->worktype == GETWITHSTATUS)
				{
				    /* must copy value */
				    if (arg.count == wp->nelem)
				    {
					nbytes = arg.count*dbr_value_size[arg.type];

					if (Trace || Debug)
    printf("my_get_callback() size %d X count %ld = nbytes %d ezcadatatype %d -> dbrtype %d\n", 
						dbr_value_size[arg.type], arg.count,
						nbytes, wp->ezcadatatype, 
						wp->dbr_type);

					if (wp->pval)
					{
					    memcpy((char *) (wp->pval), 
			    (char *) &(((struct dbr_time_short *) arg.dbr)->value),
					    nbytes);

					    if (Trace || Debug)
			    printf("my_get_callback() just memcpy %d bytes to %p\n",
						nbytes, wp->pval);
					}
					else
					{
					    fprintf(stderr, 
	"EZCA FATAL ERROR: my_get_callback() wp->worktype %d with NULL wp->pval\n",
						wp->worktype);
					    exit(1);
					} /* endif */
				    }
				    else
				    {
					fprintf(stderr, 
	    "EZCA FATAL ERROR: my_get_callback() got %ld nelem when asked for %d\n",
					    arg.count, wp->nelem);
					exit(1);
				    } /* endif */
				} /* endif */

				if (wp->worktype == GETSTATUS 
				    || wp->worktype == GETWITHSTATUS)
				{
				    /* must copy status, severity, and time */
				    if (wp->status && wp->severity && wp->tsp)
				    {
					*(wp->status) = 
				    ((struct dbr_time_short *) arg.dbr)->status;
					*(wp->severity) = 
				    ((struct dbr_time_short *) arg.dbr)->severity;
					copy_time_stamp(wp->tsp, 
				    &(((struct dbr_time_short *) arg.dbr)->stamp));

					if (Trace || Debug)
	printf("my_get_callback() just copied status %d, severity %d, and time\n", *(wp->status), *(wp->severity));
				    } 
				    else
				    {
					fprintf(stderr, 
    "EZCA FATAL ERROR: my_get_callback() wp->worktype %d wp->status %p wp->severity %p wp->tsp %p\n",
					    wp->worktype, wp->status, wp->severity,
					    wp->tsp);
					exit(1);
				    } /* endif */
				} /* endif */
			    }
			    else
			    {
				fprintf(stderr, 
    "EZCA FATAL ERROR: my_get_callback() found arg.type DBR_TIME_SHORT %ld with wp->worktype %d\n",
				    arg.type, wp->worktype);
				exit(1);
			    } /* endif */
			    break;
			case DBR_TIME_LONG:      
			    if (wp->worktype == GET 
				|| wp->worktype == GETWITHSTATUS 
				|| wp->worktype == GETSTATUS)
			    {
				if (wp->worktype == GET 
				    || wp->worktype == GETWITHSTATUS)
				{
				    /* must copy value */
				    if (arg.count == wp->nelem)
				    {
					nbytes = arg.count*dbr_value_size[arg.type];

					if (Trace || Debug)
    printf("my_get_callback() size %d X count %ld = nbytes %d ezcadatatype %d -> dbrtype %d\n", 
						dbr_value_size[arg.type], arg.count,
						nbytes, wp->ezcadatatype, 
						wp->dbr_type);

					if (wp->pval)
					{
					    memcpy((char *) (wp->pval), 
			    (char *) &(((struct dbr_time_long *) arg.dbr)->value),
					    nbytes);

					    if (Trace || Debug)
			    printf("my_get_callback() just memcpy %d bytes to %p\n",
						nbytes, wp->pval);
					}
					else
					{
					    fprintf(stderr, 
	"EZCA FATAL ERROR: my_get_callback() wp->worktype %d with NULL wp->pval\n",
						wp->worktype);
					    exit(1);
					} /* endif */
				    }
				    else
				    {
					fprintf(stderr, 
	    "EZCA FATAL ERROR: my_get_callback() got %ld nelem when asked for %d\n",
					    arg.count, wp->nelem);
					exit(1);
				    } /* endif */
				} /* endif */

				if (wp->worktype == GETSTATUS 
				    || wp->worktype == GETWITHSTATUS)
				{
				    /* must copy status, severity, and time */
				    if (wp->status && wp->severity && wp->tsp)
				    {
					*(wp->status) = 
				    ((struct dbr_time_long *) arg.dbr)->status;
					*(wp->severity) = 
				    ((struct dbr_time_long *) arg.dbr)->severity;
					copy_time_stamp(wp->tsp, 
				    &(((struct dbr_time_long *) arg.dbr)->stamp));

					if (Trace || Debug)
	printf("my_get_callback() just copied status %d, severity %d, and time\n", *(wp->status), *(wp->severity));
				    } 
				    else
				    {
					fprintf(stderr, 
    "EZCA FATAL ERROR: my_get_callback() wp->worktype %d wp->status %p wp->severity %p wp->tsp %p\n",
					    wp->worktype, wp->status, wp->severity,
					    wp->tsp);
					exit(1);
				    } /* endif */
				} /* endif */
			    }
			    else
			    {
				fprintf(stderr, 
    "EZCA FATAL ERROR: my_get_callback() found arg.type DBR_TIME_LONG %ld with wp->worktype %d\n",
				    arg.type, wp->worktype);
				exit(1);
			    } /* endif */
			    break;
			case DBR_TIME_FLOAT:    
			    if (wp->worktype == GET 
				|| wp->worktype == GETWITHSTATUS 
				|| wp->worktype == GETSTATUS)
			    {
				if (wp->worktype == GET 
				    || wp->worktype == GETWITHSTATUS)
				{
				    /* must copy value */
				    if (arg.count == wp->nelem)
				    {
					nbytes = arg.count*dbr_value_size[arg.type];

					if (Trace || Debug)
    printf("my_get_callback() size %d X count %ld = nbytes %d ezcadatatype %d -> dbrtype %d\n", 
						dbr_value_size[arg.type], arg.count,
						nbytes, wp->ezcadatatype, 
						wp->dbr_type);

					if (wp->pval)
					{
					    memcpy((char *) (wp->pval), 
			    (char *) &(((struct dbr_time_float *) arg.dbr)->value),
					    nbytes);

					    if (Trace || Debug)
			    printf("my_get_callback() just memcpy %d bytes to %p\n",
						nbytes, wp->pval);
					}
					else
					{
					    fprintf(stderr, 
	"EZCA FATAL ERROR: my_get_callback() wp->worktype %d with NULL wp->pval\n",
						wp->worktype);
					    exit(1);
					} /* endif */
				    }
				    else
				    {
					fprintf(stderr, 
	    "EZCA FATAL ERROR: my_get_callback() got %ld nelem when asked for %d\n",
					    arg.count, wp->nelem);
					exit(1);
				    } /* endif */
				} /* endif */

				if (wp->worktype == GETSTATUS 
				    || wp->worktype == GETWITHSTATUS)
				{
				    /* must copy status, severity, and time */
				    if (wp->status && wp->severity && wp->tsp)
				    {
					*(wp->status) = 
				    ((struct dbr_time_float *) arg.dbr)->status;
					*(wp->severity) = 
				    ((struct dbr_time_float *) arg.dbr)->severity;
					copy_time_stamp(wp->tsp, 
				    &(((struct dbr_time_float *) arg.dbr)->stamp));

					if (Trace || Debug)
	printf("my_get_callback() just copied status %d, severity %d, and time\n", *(wp->status), *(wp->severity));
				    } 
				    else
				    {
					fprintf(stderr, 
    "EZCA FATAL ERROR: my_get_callback() wp->worktype %d wp->status %p wp->severity %p wp->tsp %p\n",
					    wp->worktype, wp->status, wp->severity,
					    wp->tsp);
					exit(1);
				    } /* endif */
				} /* endif */
			    }
			    else
			    {
				fprintf(stderr, 
    "EZCA FATAL ERROR: my_get_callback() found arg.type DBR_TIME_FLOAT %ld with wp->worktype %d\n",
				    arg.type, wp->worktype);
				exit(1);
			    } /* endif */
			    break;
			case DBR_TIME_DOUBLE:  
			    if (wp->worktype == GET 
				|| wp->worktype == GETWITHSTATUS 
				|| wp->worktype == GETSTATUS)
			    {
				if (wp->worktype == GET 
				    || wp->worktype == GETWITHSTATUS)
				{
				    /* must copy value */
				    if (arg.count == wp->nelem)
				    {
					nbytes = arg.count*dbr_value_size[arg.type];

					if (Trace || Debug)
    printf("my_get_callback() size %d X count %ld = nbytes %d ezcadatatype %d -> dbrtype %d\n", 
						dbr_value_size[arg.type], arg.count,
						nbytes, wp->ezcadatatype, 
						wp->dbr_type);

					if (wp->pval)
					{
					    memcpy((char *) (wp->pval), 
			    (char *) &(((struct dbr_time_double *) arg.dbr)->value),
						nbytes);

					    if (Trace || Debug)
			    printf("my_get_callback() just memcpy %d bytes to %p\n",
						nbytes, wp->pval);
					}
					else
					{
					    fprintf(stderr, 
	"EZCA FATAL ERROR: my_get_callback() wp->worktype %d with NULL wp->pval\n",
						wp->worktype);
					    exit(1);
					} /* endif */
				    }
				    else
				    {
					fprintf(stderr, 
	    "EZCA FATAL ERROR: my_get_callback() got %ld nelem when asked for %d\n",
					    arg.count, wp->nelem);
					exit(1);
				    } /* endif */
				} /* endif */

				if (wp->worktype == GETSTATUS 
				    || wp->worktype == GETWITHSTATUS)
				{
				    /* must copy status, severity, and time */
				    if (wp->status && wp->severity && wp->tsp)
				    {
					*(wp->status) = 
				    ((struct dbr_time_double *) arg.dbr)->status;
					*(wp->severity) = 
				    ((struct dbr_time_double *) arg.dbr)->severity;
					copy_time_stamp(wp->tsp, 
				    &(((struct dbr_time_double *) arg.dbr)->stamp));

					if (Trace || Debug)
	printf("my_get_callback() just copied status %d, severity %d, and time\n", *(wp->status), *(wp->severity));
				    } 
				    else
				    {
					fprintf(stderr, 
    "EZCA FATAL ERROR: my_get_callback() wp->worktype %d wp->status %p wp->severity %p wp->tsp %p\n",
					    wp->worktype, wp->status, wp->severity,
					    wp->tsp);
					exit(1);
				    } /* endif */
				} /* endif */
			    }
			    else
			    {
				fprintf(stderr, 
    "EZCA FATAL ERROR: my_get_callback() found arg.type DBR_TIME_DOUBLE %ld with wp->worktype %d\n",
				    arg.type, wp->worktype);
				exit(1);
			    } /* endif */
			    break;

			/* GETUNITS, GETPRECISION, GETGRAPHICLIMITS, */
			/* GETWARNLIMITS, GETALARMLIMITS,            */
			/* GETCONTROLLIMITS or GETENUMSTATES         */

			/* case DBR_CTRL_INT = DBR_CTRL_SHORT: */
			case DBR_CTRL_SHORT:
			    switch (wp->worktype)
			    {
				case GETUNITS:
				    if (wp->strp)
				    {
					strncpy(wp->strp, 
					((struct dbr_ctrl_short *) arg.dbr)->units,
						EZCA_UNITS_SIZE);
					wp->strp[EZCA_UNITS_SIZE-1] = '\0';

					    if (Trace || Debug)
				    printf("my_get_callback() just copied units\n");
				    }
				    else
				    {
					fprintf(stderr, 
    "EZCA FATAL ERROR: my_get_callback() worktype GETUNITS got NULL wp->strp\n");
					exit(1);
				    } /* endif */
				    break;
				case GETPRECISION:
				    fprintf(stderr, 
    "EZCA FATAL ERROR: my_get_callback() got worktype GETPRECISION with arg.dbr DBR_CTRL_SHORT\n");
				    exit(1);
				    break;
				case GETGRAPHICLIMITS:
				    if (wp->d1p && wp->d2p)
				    {
					*(wp->d1p) = 
			    ((struct dbr_ctrl_short *) arg.dbr)->lower_disp_limit;
					*(wp->d2p) = 
			    ((struct dbr_ctrl_short *) arg.dbr)->upper_disp_limit;

					if (Trace || Debug)
			printf("my_get_callback() just copied graphic limits\n");
				    } 
				    else
				    {
					fprintf(stderr, 
    "EZCA FATAL ERROR: my_get_callback() worktype GETGRAPHICLIMITS got NULL wp->d1p %p wp->d2p %p\n",
					    wp->d1p, wp->d2p);
					exit(1);
				    } /* endif */
				    break;
				case GETCONTROLLIMITS:
				    if (wp->d1p && wp->d2p)
				    {
					*(wp->d1p) = 
			    ((struct dbr_ctrl_short *) arg.dbr)->lower_ctrl_limit;
					*(wp->d2p) = 
			    ((struct dbr_ctrl_short *) arg.dbr)->upper_ctrl_limit;

					if (Trace || Debug)
			printf("my_get_callback() just copied control limits\n");
				    } 
				    else
				    {
					fprintf(stderr, 
    "EZCA FATAL ERROR: my_get_callback() worktype GETCONTROLLIMITS got NULL wp->d1p %p wp->d2p %p\n",
					    wp->d1p, wp->d2p);
					exit(1);
				    } /* endif */
				    break;
				case GETWARNLIMITS:
				    if (wp->d1p && wp->d2p)
				    {
					*(wp->d1p) = 
			    ((struct dbr_ctrl_short *) arg.dbr)->lower_warning_limit;
					*(wp->d2p) = 
			    ((struct dbr_ctrl_short *) arg.dbr)->upper_warning_limit;

					if (Trace || Debug)
			printf("my_get_callback() just copied warning limits\n");
				    } 
				    else
				    {
					fprintf(stderr, 
    "EZCA FATAL ERROR: my_get_callback() worktype GETWARNLIMITS got NULL wp->d1p %p wp->d2p %p\n",
					    wp->d1p, wp->d2p);
					exit(1);
				    } /* endif */
				    break;
				case GETALARMLIMITS:
				    if (wp->d1p && wp->d2p)
				    {
					*(wp->d1p) = 
			    ((struct dbr_ctrl_short *) arg.dbr)->lower_alarm_limit;
					*(wp->d2p) = 
			    ((struct dbr_ctrl_short *) arg.dbr)->upper_alarm_limit;

					if (Trace || Debug)
			printf("my_get_callback() just copied alarm limits\n");
				    } 
				    else
				    {
					fprintf(stderr, 
    "EZCA FATAL ERROR: my_get_callback() worktype GETALARMLIMITS got NULL wp->d1p %p wp->d2p %p\n",
					    wp->d1p, wp->d2p);
					exit(1);
				    } /* endif */
				    break;
				default:
				    fprintf(stderr, 
    "EZCA FATAL ERROR: my_get_callback() found arg.type DBR_CTRL_SHORT %ld with wp->worktype %d\n",
				    arg.type, wp->worktype);
				    exit(1);
				    break;
			    } /* end switch() */
			    break;
			case DBR_CTRL_FLOAT:
			    switch (wp->worktype)
			    {
				case GETUNITS:
				    if (wp->strp)
				    {
					strncpy(wp->strp, 
					((struct dbr_ctrl_float *) arg.dbr)->units,
						EZCA_UNITS_SIZE);
					wp->strp[EZCA_UNITS_SIZE-1] = '\0';

					    if (Trace || Debug)
				    printf("my_get_callback() just copied units\n");
				    }
				    else
				    {
					fprintf(stderr, 
    "EZCA FATAL ERROR: my_get_callback() worktype GETUNITS got NULL wp->strp\n");
					exit(1);
				    } /* endif */
				    break;
				case GETPRECISION:
				    if (wp->s1p)
				    {
					*(wp->s1p) = 
				    ((struct dbr_ctrl_float *) arg.dbr)->precision;

					if (Trace || Debug)
				printf("my_get_callback() just copied precision\n");
				    } 
				    else
				    {
					fprintf(stderr, 
    "EZCA FATAL ERROR: my_get_callback() worktype GETPRECISION got NULL wp->s1p\n");
					exit(1);
				    } /* endif */
				    break;
				case GETGRAPHICLIMITS:
				    if (wp->d1p && wp->d2p)
				    {
					*(wp->d1p) = 
			    ((struct dbr_ctrl_float *) arg.dbr)->lower_disp_limit;
					*(wp->d2p) = 
			    ((struct dbr_ctrl_float *) arg.dbr)->upper_disp_limit;

					if (Trace || Debug)
			printf("my_get_callback() just copied graphic limits\n");
				    } 
				    else
				    {
					fprintf(stderr, 
    "EZCA FATAL ERROR: my_get_callback() worktype GETGRAPHICLIMITS got NULL wp->d1p %p wp->d2p %p\n",
					    wp->d1p, wp->d2p);
					exit(1);
				    } /* endif */
				    break;
				case GETCONTROLLIMITS:
				    if (wp->d1p && wp->d2p)
				    {
					*(wp->d1p) = 
			    ((struct dbr_ctrl_float *) arg.dbr)->lower_ctrl_limit;
					*(wp->d2p) = 
			    ((struct dbr_ctrl_float *) arg.dbr)->upper_ctrl_limit;

					if (Trace || Debug)
			printf("my_get_callback() just copied control limits\n");
				    } 
				    else
				    {
					fprintf(stderr, 
    "EZCA FATAL ERROR: my_get_callback() worktype GETCONTROLLIMITS got NULL wp->d1p %p wp->d2p %p\n",
					    wp->d1p, wp->d2p);
					exit(1);
				    } /* endif */
				    break;
				case GETWARNLIMITS:
				    if (wp->d1p && wp->d2p)
				    {
					*(wp->d1p) = 
			    ((struct dbr_ctrl_float *) arg.dbr)->lower_warning_limit;
					*(wp->d2p) = 
			    ((struct dbr_ctrl_float *) arg.dbr)->upper_warning_limit;

					if (Trace || Debug)
			printf("my_get_callback() just copied warning limits\n");
				    } 
				    else
				    {
					fprintf(stderr, 
    "EZCA FATAL ERROR: my_get_callback() worktype GETWARNLIMITS got NULL wp->d1p %p wp->d2p %p\n",
					    wp->d1p, wp->d2p);
					exit(1);
				    } /* endif */
				    break;
				case GETALARMLIMITS:
				    if (wp->d1p && wp->d2p)
				    {
					*(wp->d1p) = 
			    ((struct dbr_ctrl_float *) arg.dbr)->lower_alarm_limit;
					*(wp->d2p) = 
			    ((struct dbr_ctrl_float *) arg.dbr)->upper_alarm_limit;

					if (Trace || Debug)
			printf("my_get_callback() just copied alarm limits\n");
				    } 
				    else
				    {
					fprintf(stderr, 
    "EZCA FATAL ERROR: my_get_callback() worktype GETALARMLIMITS got NULL wp->d1p %p wp->d2p %p\n",
					    wp->d1p, wp->d2p);
					exit(1);
				    } /* endif */
				    break;
				default:
				    fprintf(stderr, 
    "EZCA FATAL ERROR: my_get_callback() found arg.type DBR_CTRL_FLOAT %ld with wp->worktype %d\n",
				    arg.type, wp->worktype);
				    exit(1);
				    break;
			    } /* end switch() */
			    break;
			case DBR_CTRL_CHAR:
			    switch (wp->worktype)
			    {
				case GETUNITS:
				    if (wp->strp)
				    {
					strncpy(wp->strp, 
					((struct dbr_ctrl_char *) arg.dbr)->units,
						EZCA_UNITS_SIZE);
					wp->strp[EZCA_UNITS_SIZE-1] = '\0';

					    if (Trace || Debug)
				    printf("my_get_callback() just copied units\n");
				    }
				    else
				    {
					fprintf(stderr, 
    "EZCA FATAL ERROR: my_get_callback() worktype GETUNITS got NULL wp->strp\n");
					exit(1);
				    } /* endif */
				    break;
				case GETPRECISION:
				    fprintf(stderr, 
    "EZCA FATAL ERROR: my_get_callback() got worktype GETPRECISION with arg.dbr DBR_CTRL_CHAR\n");
				    exit(1);
				    break;
				case GETGRAPHICLIMITS:
				    if (wp->d1p && wp->d2p)
				    {
					*(wp->d1p) = 
			    ((struct dbr_ctrl_char *) arg.dbr)->lower_disp_limit;
					*(wp->d2p) = 
			    ((struct dbr_ctrl_char *) arg.dbr)->upper_disp_limit;

					if (Trace || Debug)
			printf("my_get_callback() just copied graphic limits\n");
				    } 
				    else
				    {
					fprintf(stderr, 
    "EZCA FATAL ERROR: my_get_callback() worktype GETGRAPHICLIMITS got NULL wp->d1p %p wp->d2p %p\n",
					    wp->d1p, wp->d2p);
					exit(1);
				    } /* endif */
				    break;
				case GETCONTROLLIMITS:
				    if (wp->d1p && wp->d2p)
				    {
					*(wp->d1p) = 
			    ((struct dbr_ctrl_char *) arg.dbr)->lower_ctrl_limit;
					*(wp->d2p) = 
			    ((struct dbr_ctrl_char *) arg.dbr)->upper_ctrl_limit;

					if (Trace || Debug)
			printf("my_get_callback() just copied control limits\n");
				    } 
				    else
				    {
					fprintf(stderr, 
    "EZCA FATAL ERROR: my_get_callback() worktype GETCONTROLLIMITS got NULL wp->d1p %p wp->d2p %p\n",
					    wp->d1p, wp->d2p);
					exit(1);
				    } /* endif */
				    break;
				case GETWARNLIMITS:
				    if (wp->d1p && wp->d2p)
				    {
					*(wp->d1p) = 
			    ((struct dbr_ctrl_char *) arg.dbr)->lower_warning_limit;
					*(wp->d2p) = 
			    ((struct dbr_ctrl_char *) arg.dbr)->upper_warning_limit;

					if (Trace || Debug)
			printf("my_get_callback() just copied warning limits\n");
				    } 
				    else
				    {
					fprintf(stderr, 
    "EZCA FATAL ERROR: my_get_callback() worktype GETWARNLIMITS got NULL wp->d1p %p wp->d2p %p\n",
					    wp->d1p, wp->d2p);
					exit(1);
				    } /* endif */
				    break;
				case GETALARMLIMITS:
				    if (wp->d1p && wp->d2p)
				    {
					*(wp->d1p) = 
			    ((struct dbr_ctrl_char *) arg.dbr)->lower_alarm_limit;
					*(wp->d2p) = 
			    ((struct dbr_ctrl_char *) arg.dbr)->upper_alarm_limit;

					if (Trace || Debug)
			printf("my_get_callback() just copied alarm limits\n");
				    } 
				    else
				    {
					fprintf(stderr, 
    "EZCA FATAL ERROR: my_get_callback() worktype GETALARMLIMITS got NULL wp->d1p %p wp->d2p %p\n",
					    wp->d1p, wp->d2p);
					exit(1);
				    } /* endif */
				    break;
				default:
				    fprintf(stderr, 
    "EZCA FATAL ERROR: my_get_callback() found arg.type DBR_CTRL_CHAR %ld with wp->worktype %d\n",
				    arg.type, wp->worktype);
				    exit(1);
				    break;
			    } /* end switch() */
			    break;
			case DBR_CTRL_LONG:
			    switch (wp->worktype)
			    {
				case GETUNITS:
				    if (wp->strp)
				    {
					strncpy(wp->strp, 
					((struct dbr_ctrl_long *) arg.dbr)->units,
						EZCA_UNITS_SIZE);
					wp->strp[EZCA_UNITS_SIZE-1] = '\0';

					    if (Trace || Debug)
				    printf("my_get_callback() just copied units\n");
				    }
				    else
				    {
					fprintf(stderr, 
    "EZCA FATAL ERROR: my_get_callback() worktype GETUNITS got NULL wp->strp\n");
					exit(1);
				    } /* endif */
				    break;
				case GETPRECISION:
				    fprintf(stderr, 
    "EZCA FATAL ERROR: my_get_callback() got worktype GETPRECISION with arg.dbr DBR_CTRL_LONG\n");
				    exit(1);
				    break;
				case GETGRAPHICLIMITS:
				    if (wp->d1p && wp->d2p)
				    {
					*(wp->d1p) = 
			    ((struct dbr_ctrl_long *) arg.dbr)->lower_disp_limit;
					*(wp->d2p) = 
			    ((struct dbr_ctrl_long *) arg.dbr)->upper_disp_limit;

					if (Trace || Debug)
			printf("my_get_callback() just copied graphic limits\n");
				    } 
				    else
				    {
					fprintf(stderr, 
    "EZCA FATAL ERROR: my_get_callback() worktype GETGRAPHICLIMITS got NULL wp->d1p %p wp->d2p %p\n",
					    wp->d1p, wp->d2p);
					exit(1);
				    } /* endif */
				    break;
				case GETCONTROLLIMITS:
				    if (wp->d1p && wp->d2p)
				    {
					*(wp->d1p) = 
			    ((struct dbr_ctrl_long *) arg.dbr)->lower_ctrl_limit;
					*(wp->d2p) = 
			    ((struct dbr_ctrl_long *) arg.dbr)->upper_ctrl_limit;

					if (Trace || Debug)
			printf("my_get_callback() just copied control limits\n");
				    } 
				    else
				    {
					fprintf(stderr, 
    "EZCA FATAL ERROR: my_get_callback() worktype GETCONTROLLIMITS got NULL wp->d1p %p wp->d2p %p\n",
					    wp->d1p, wp->d2p);
					exit(1);
				    } /* endif */
				    break;
				case GETWARNLIMITS:
				    if (wp->d1p && wp->d2p)
				    {
					*(wp->d1p) = 
			    ((struct dbr_ctrl_long *) arg.dbr)->lower_warning_limit;
					*(wp->d2p) = 
			    ((struct dbr_ctrl_long *) arg.dbr)->upper_warning_limit;

					if (Trace || Debug)
			printf("my_get_callback() just copied warning limits\n");
				    } 
				    else
				    {
					fprintf(stderr, 
    "EZCA FATAL ERROR: my_get_callback() worktype GETWARNLIMITS got NULL wp->d1p %p wp->d2p %p\n",
					    wp->d1p, wp->d2p);
					exit(1);
				    } /* endif */
				    break;
				case GETALARMLIMITS:
				    if (wp->d1p && wp->d2p)
				    {
					*(wp->d1p) = 
			    ((struct dbr_ctrl_long *) arg.dbr)->lower_alarm_limit;
					*(wp->d2p) = 
			    ((struct dbr_ctrl_long *) arg.dbr)->upper_alarm_limit;

					if (Trace || Debug)
			printf("my_get_callback() just copied alarm limits\n");
				    } 
				    else
				    {
					fprintf(stderr, 
    "EZCA FATAL ERROR: my_get_callback() worktype GETALARMLIMITS got NULL wp->d1p %p wp->d2p %p\n",
					    wp->d1p, wp->d2p);
					exit(1);
				    } /* endif */
				    break;
				default:
				    fprintf(stderr, 
    "EZCA FATAL ERROR: my_get_callback() found arg.type DBR_CTRL_LONG %ld with wp->worktype %d\n",
				    arg.type, wp->worktype);
				    exit(1);
				    break;
			    } /* end switch() */
			    break;
			case DBR_CTRL_DOUBLE:
			    switch (wp->worktype)
			    {
				case GETUNITS:
				    if (wp->strp)
				    {
					strncpy(wp->strp, 
					((struct dbr_ctrl_double *) arg.dbr)->units,
						EZCA_UNITS_SIZE);
					wp->strp[EZCA_UNITS_SIZE-1] = '\0';

					    if (Trace || Debug)
				    printf("my_get_callback() just copied units\n");
				    }
				    else
				    {
					fprintf(stderr, 
"EZCA FATAL ERROR: my_get_callback() worktype GETUNITS got NULL wp->strp\n");
					exit(1);
				    } /* endif */
				    break;
				case GETPRECISION:
				    if (wp->s1p)
				    {
					*(wp->s1p) = 
				((struct dbr_ctrl_double *) arg.dbr)->precision;

					if (Trace || Debug)
			    printf("my_get_callback() just copied precision\n");
				    } 
				    else
				    {
					fprintf(stderr, 
"EZCA FATAL ERROR: my_get_callback() worktype GETPRECISION got NULL wp->s1p\n");
					exit(1);
				    } /* endif */
				    break;
				case GETGRAPHICLIMITS:
				    if (wp->d1p && wp->d2p)
				    {
					*(wp->d1p) = 
			((struct dbr_ctrl_double *) arg.dbr)->lower_disp_limit;
					*(wp->d2p) = 
			((struct dbr_ctrl_double *) arg.dbr)->upper_disp_limit;

					if (Trace || Debug)
		    printf("my_get_callback() just copied graphic limits\n");
				    } 
				    else
				    {
					fprintf(stderr, 
"EZCA FATAL ERROR: my_get_callback() worktype GETGRAPHICLIMITS got NULL wp->d1p %p wp->d2p %p\n",
					    wp->d1p, wp->d2p);
					exit(1);
				    } /* endif */
				    break;
				case GETCONTROLLIMITS:
				    if (wp->d1p && wp->d2p)
				    {
					*(wp->d1p) = 
			((struct dbr_ctrl_double *) arg.dbr)->lower_ctrl_limit;
					*(wp->d2p) = 
			((struct dbr_ctrl_double *) arg.dbr)->upper_ctrl_limit;

					if (Trace || Debug)
		    printf("my_get_callback() just copied control limits\n");
				    } 
				    else
				    {
					fprintf(stderr, 
"EZCA FATAL ERROR: my_get_callback() worktype GETCONTROLLIMITS got NULL wp->d1p %p wp->d2p %p\n",
					    wp->d1p, wp->d2p);
					exit(1);
				    } /* endif */
				    break;
				case GETWARNLIMITS:
				    if (wp->d1p && wp->d2p)
				    {
					*(wp->d1p) = 
			    ((struct dbr_ctrl_double *) arg.dbr)->lower_warning_limit;
					*(wp->d2p) = 
			    ((struct dbr_ctrl_double *) arg.dbr)->upper_warning_limit;

					if (Trace || Debug)
			printf("my_get_callback() just copied warning limits\n");
				    } 
				    else
				    {
					fprintf(stderr, 
    "EZCA FATAL ERROR: my_get_callback() worktype GETWARNLIMITS got NULL wp->d1p %p wp->d2p %p\n",
					    wp->d1p, wp->d2p);
					exit(1);
				    } /* endif */
				    break;
				case GETALARMLIMITS:
				    if (wp->d1p && wp->d2p)
				    {
					*(wp->d1p) = 
			    ((struct dbr_ctrl_double *) arg.dbr)->lower_alarm_limit;
					*(wp->d2p) = 
			    ((struct dbr_ctrl_double *) arg.dbr)->upper_alarm_limit;

					if (Trace || Debug)
			printf("my_get_callback() just copied alarm limits\n");
				    } 
				    else
				    {
					fprintf(stderr, 
    "EZCA FATAL ERROR: my_get_callback() worktype GETALARMLIMITS got NULL wp->d1p %p wp->d2p %p\n",
					    wp->d1p, wp->d2p);
					exit(1);
				    } /* endif */
				    break;
				default:
				    fprintf(stderr, 
"EZCA FATAL ERROR: my_get_callback() found arg.type DBR_CTRL_DOUBLE %ld with wp->worktype %d\n",
				    arg.type, wp->worktype);
				    exit(1);
				    break;
			    } /* end switch() */
			    break;

			case DBR_CTRL_ENUM:
				if ( GETENUMSTATES == wp->worktype )
				{
				char *p;
				int   i,m;
					if ( (p = wp->strp) ) 
					{
					struct dbr_ctrl_enum *dbr = (struct dbr_ctrl_enum*)arg.dbr;
						m = dbr->no_str;
						if ( m > EZCA_ENUM_STATES )
							m = EZCA_ENUM_STATES;
						for ( i = 0; i < m; i++, p+=EZCA_ENUM_STRING_SIZE )
						{
							strncpy( p, dbr->strs[i], EZCA_ENUM_STRING_SIZE );
						}
						if ( i < EZCA_ENUM_STATES )
							*p = 0;
					}
					else
					{
					fprintf(stderr, 
    "EZCA FATAL ERROR: my_get_callback() worktype GETENUMSTATES got NULL wp->strp\n");
					exit(1);
					}
				}
				else
				{
				    fprintf(stderr, 
"EZCA FATAL ERROR: my_get_callback() found arg.type DBR_CTRL_ENUM %ld with wp->worktype %d\n",
				    arg.type, wp->worktype);
				    exit(1);
				}
				break;
			default:
			    fprintf(stderr, 
		    "EZCA FATAL ERROR: my_get_callback() unknown arg.type %ld\n",
				arg.type);
			    exit(1);
			    break;
		    } /* end switch() */
		}
		else
		{
		    fprintf(stderr, 
    "EZCA FATAL ERROR: my_get_callback() got type %ld when asked for type %d\n",
			arg.type, wp->dbr_type);
		    exit(1);
		} /* endif */
	    }
	    else
	    {
		if (Trace || Debug)
		    printf("my_get_callback() found bad arg.status %d\n", 
			arg.status);

		wp->rc = EZCA_CAFAILURE;
		wp->error_msg = ErrorMsgs[CAARRAYGETCALLBACK_MSG_IDX];
		wp->aux_error_msg = strdup(ca_message(arg.status));
	    } /* endif */

	    if (Trace || Debug)
		printf("my_get_callback() setting reported\n");

	    wp->reported = TRUE;
#ifdef DEBUG
		printf("TSILL my_get_callback POST (%i)\n", ezcaOutstanding);
#endif
		POST_DONE();
	}
	else
	{
	    if (Trace || Debug)
		printf("my_get_callback() inactive work node\n");
		recycle_work(wp);
	} /* endif */
    }
    else
    {
        fprintf(stderr, "EZCA FATAL ERROR: my_get_callback() got NULL wp\n");
        exit(1);
    } /* endif */

    if (Trace || Debug)
	printf("exiting my_get_callback()\n");

EZCA_UNLOCK();
} /* end my_get_callback() */

/****************************************************************
*
* from epicsH/cadef.h
* struct  event_handler_args
* {
*     void *usr;   User argument supplied when event added
*     chid chid;   Channel id
*     long type;   the type of the value returned (long aligned)
*     long count;  the element count of the item returned
*     void *dbr;   Pointer to the value returned
*     int status; CA Status of the op from server - CA V4.1 
* };
*
* Presumably a ca_add_array_event() has been previously called which 
* established a monitor and named this routine as the callback.
*
* The request type was DBR_TIME_XXXX.  When this monitor is called, arg.dbr
* is a pointer to one of these dbr_time_xxxx structs.  This structure is 
* filled with all kinds of information, (status, severity, limits, ...).
*
* The actual data is sitting in the value field of the dbr_time_xxxx structure.
*
* In the event that arg.count > 1, the value is still sitting the the value
* field, but as an array that starts at the value field.
*
****************************************************************/

static void my_monitor_callback(struct event_handler_args arg)
{

struct monitor *mp;
int nbytes;

EZCA_LOCK();
    if (Trace || Debug)
	printf("entering my_monitor_callback()\n");

    if ((mp = (struct monitor *) arg.usr))
    {
	if (mp->active)
	{
	    /* checking that channel access gave us what we asked for */
	    if (arg.type == mp->dbr_type)
	    {
		if (arg.status == ECA_NORMAL)
		{
		    nbytes = arg.count * dbr_value_size[arg.type];
		    if (Trace || Debug)
			printf("my_monitor_callback() pvname >%s< size %d X count %ld = nbytes %d ezcadatatype %d -> dbrtype %d\n", 
			    (mp->cp ? (mp->cp)->pvname : "NULL"), 
			    dbr_value_size[arg.type], arg.count,
			    nbytes, mp->ezcadatatype, mp->dbr_type);

		    if (arg.count != mp->last_nelem)
		    {
			if (Trace || Debug)
		    printf("my_monitor_callback() allocating %ld X %d = %d bytes\n",
				arg.count, dbr_value_size[arg.type], nbytes);

			/* different amount coming in ... need new data buff */

			if (mp->pval)
			{
			    if (Trace || Debug)
			printf("my_monitor_callback() freeing mp->pval %p\n",
				    mp->pval);
			    ezcafree((char *) mp->pval);
			    mp->pval = (void *) NULL;
			} /* endif */

			if (!(mp->pval = (void *) ezcamalloc((unsigned) nbytes)))
			{
			    fprintf(stderr, 
	"EZCA FATAL ERROR: my_monitor_callback() could not allocate %d bytes\n",
				nbytes);
			    exit(1);
			} /* endif */

			if (Trace || Debug)
		printf("my_monitor_callback() allocated %d bytes mp->pval %p\n",
				nbytes, mp->pval);

			mp->last_nelem = arg.count;

		    } /* endif */

		    switch (arg.type)
		    {
			case DBR_TIME_CHAR:
			    memcpy((char *) (mp->pval), 
			(char *) &(((struct dbr_time_char *) arg.dbr)->value),
				nbytes);
			    mp->status = 
				((struct dbr_time_char *) arg.dbr)->status;
			    mp->severity = 
				((struct dbr_time_char *) arg.dbr)->severity;
			    copy_time_stamp(&(mp->time_stamp), 
				&(((struct dbr_time_char *) arg.dbr)->stamp));
			    break;
			case DBR_TIME_STRING:
			    memcpy((char *) (mp->pval), 
			(char *) &(((struct dbr_time_string *)arg.dbr)->value),
				nbytes);
			    mp->status = 
				((struct dbr_time_string *) arg.dbr)->status;
			    mp->severity = 
				((struct dbr_time_string *) arg.dbr)->severity;
			    copy_time_stamp(&(mp->time_stamp), 
				&(((struct dbr_time_string *) arg.dbr)->stamp));
			    break;
			case DBR_TIME_SHORT:
			    memcpy((char *) (mp->pval), 
			(char *) &(((struct dbr_time_short *)arg.dbr)->value),
				nbytes);
			    mp->status = 
				((struct dbr_time_short *) arg.dbr)->status;
			    mp->severity = 
				((struct dbr_time_short *) arg.dbr)->severity;
			    copy_time_stamp(&(mp->time_stamp),
				&(((struct dbr_time_short *) arg.dbr)->stamp));
			    break;
			case DBR_TIME_LONG:
			    memcpy((char *) (mp->pval), 
			(char *) &(((struct dbr_time_long *) arg.dbr)->value),
				nbytes);
			    mp->status = 
				((struct dbr_time_long *) arg.dbr)->status;
			    mp->severity = 
				((struct dbr_time_long *) arg.dbr)->severity;
			    copy_time_stamp(&(mp->time_stamp),
				&(((struct dbr_time_long *) arg.dbr)->stamp));
			    break;
			case DBR_TIME_FLOAT:
			    memcpy((char *) (mp->pval), 
			(char *) &(((struct dbr_time_float *)arg.dbr)->value),
				nbytes);
			    mp->status = 
				((struct dbr_time_float *) arg.dbr)->status;
			    mp->severity = 
				((struct dbr_time_float *) arg.dbr)->severity;
			    copy_time_stamp(&(mp->time_stamp),
				&(((struct dbr_time_float *) arg.dbr)->stamp));
			    break;
			case DBR_TIME_DOUBLE:
			    memcpy((char *) (mp->pval), 
			(char *)&(((struct dbr_time_double *)arg.dbr)->value),
				nbytes);
			    mp->status = 
				((struct dbr_time_double *) arg.dbr)->status;
			    mp->severity = 
				((struct dbr_time_double *) arg.dbr)->severity;
			    copy_time_stamp(&(mp->time_stamp),
				&(((struct dbr_time_double *) arg.dbr)->stamp));
			    break;
			default:
			    fprintf(stderr, 
"EZCA FATAL ERROR: my_monitor_callback() encountered unrecognizable type %ld\n",
				arg.type);
			    break;
		    } /* end switch() */

		    if (Trace || Debug)
		    printf("my_monitor_callback() just memcpy %d bytes to %p\n",
			    nbytes, mp->pval);

		    mp->needs_reading = TRUE;
			if ( mp->waiter && usable == mp->waiter->trashme ) {
				if ( mp->waiter->worktype != MONBLOCK ) {
					fprintf(stderr,"EZCA FATAL ERROR: work type is not MONBLOCK\n");
					exit(1);
				}
				mp->waiter->reported = TRUE;
				mp->waiter->pval     = NULL;
#ifdef DEBUG
				printf("TSILL my_mon_callback POST (%i)\n", ezcaOutstanding);
#endif
				POST_DONE();
			}
			mp->waiter = (struct work *)NULL;
		}
		else
		{
		    if (Trace || Debug)
			printf("my_monitor_callback() found arg.status %d\n",
			    arg.status);

		    if (mp->pval)
		    {
			if (Trace || Debug)
			printf("my_monitor_callback() freeing mp->pval %p\n",
				mp->pval);
			ezcafree((char *) mp->pval);
		    } /* endif */

		    mp->pval = (void *) NULL;
		    mp->needs_reading = FALSE;
		    mp->last_nelem = UNDEFINED;
		    mp->status = UNDEFINED;
		    mp->severity = UNDEFINED;
		} /* endif */
	    }
	    else
	    {
		fprintf(stderr, 
"EZCA FATAL ERROR: my_monitor_callback() got type %ld when asked for type %d\n",
		    arg.type, mp->dbr_type);
		exit(1);
	    } /* endif */
	}
	else
	{
	    if (Trace || Debug)
		printf("my_monitor_callback() inactive monitor\n");
	} /* endif */
    }
    else
    {
        fprintf(stderr, 
	    "EZCA FATAL ERROR: my_monitor_callback() got NULL mp\n");
        exit(1);
    } /* endif */

    if (Trace || Debug)
	printf("exiting my_monitor_callback()\n");

EZCA_UNLOCK();
} /* end my_monitor_callback() */

/****************************************************************
*
* from epicsH/cadef.h
* struct  event_handler_args
* {
*     void *usr;   User argument supplied when event added
*     chid chid;   Channel id
*     long type;   the type of the value returned (long aligned)
*     long count;  the element count of the item returned
*     void *dbr;   Pointer to the value returned
*     int status; CA Status of the op from server - CA V4.1 
* };
*
* Presumably a ca_array_put_callback() has been previously called which 
* named this routine as the callback.  
*
****************************************************************/

static void my_put_callback(struct event_handler_args arg)
{

struct work *wp;

EZCA_LOCK();
    if (Trace || Debug)
	printf("entering my_put_callback()\n");

    if ((wp = (struct work *) arg.usr))
    {
	if (usable == wp->trashme)
	{
	    wp->reported = TRUE;
#ifdef DEBUG
		printf("TSILL my_put_callback POST (%i)\n", ezcaOutstanding);
#endif
		POST_DONE();

	    if (Trace || Debug)
	printf("my_put_callback() pvname >%s< ezcatype %d setting reported\n",
		    wp->pvname, wp->ezcadatatype);

	    if (arg.status != ECA_NORMAL)
	    {
		if (Trace || Debug)
		    printf("my_put_callback() found bad arg.status %d\n", 
			arg.status);

		wp->rc = EZCA_CAFAILURE;
		wp->rc = EZCA_CAFAILURE;
		wp->error_msg = ErrorMsgs[CAARRAYPUTCALLBACK_MSG_IDX];
		wp->aux_error_msg = strdup(ca_message(arg.status));
	    } /* endif */
	}
	else
	{
	    if (Trace || Debug)
		printf("my_put_callback() inactive work node\n");
		recycle_work(wp);
	} /* endif */
    }
    else
    {
        fprintf(stderr, "EZCA FATAL ERROR: my_put_callback() got NULL wp\n");
        exit(1);
    } /* endif */

    if (Trace || Debug)
	printf("exiting my_put_callback()\n");

EZCA_UNLOCK();
} /* end my_put_callback() */

/*********************/
/*                   */
/* Memory Management */
/*                   */
/*********************/

/****************************************************************
*
* clears the chid and empties monitor list via clean_and_push_monitor()
*
****************************************************************/

static void clean_and_push_channel(struct channel **cpp)
{

int    clear_failed;
struct monitor *mp;

    if ( *cpp )
    {  
	if ( 0 == --(*cpp)->refcnt ) {

	/* clearing monitor list       */
	/* note that this loop ends up */
	/* with p->monitor_list = NULL */

	while ((mp = (*cpp)->monitor_list))
	{
	    if (((*cpp)->monitor_list = mp->right))
		((*cpp)->monitor_list)->left = (struct monitor *) NULL;

	    /* not calling clean_and_push_monitor() here because want to */
	    /* bunch up these ca_clear_event() calls and flush as one    */

	    mp->active = FALSE;

	    if (mp->pval)
	    {
		ezcafree((char *) mp->pval);
		mp->pval = (void *) NULL;
	    } /* endif */

	    push_monitor(mp, ECA_NORMAL != EzcaClearEvent(mp) ? &Discarded_monitors : &Monitor_avail_hdr);

	} /* endwhile */
	/* clearing the chid */

	clear_failed = EzcaClearChannel(*cpp);
#ifndef EPICS_THREE_FOURTEEN
	EzcaPendIO((struct work *) NULL, SHORT_TIME);
#endif

	push_channel(*cpp, clear_failed ? &Discarded_channels : &Channel_avail_hdr);

	} else if ( (*cpp)->refcnt < 0 ) {
		fprintf(stderr,"EZCA FATAL ERROR: clean_and_push_channel() with refcnt <=0\n");
		exit(1);
	}


    } /* endif */
    *cpp = 0;

} /* end clean_and_push_channel() */

/****************************************************************
*
*
****************************************************************/

static void clean_and_push_monitor(struct monitor *mp)
{
int clear_failed;
    if (mp)
    {

	mp->active = FALSE;

	if (mp->pval)
	{
	    ezcafree((char *) mp->pval);
	    mp->pval = (void *) NULL;
	} /* endif */

	clear_failed = EzcaClearEvent(mp);
	EzcaPendIO((struct work *) NULL, SHORT_TIME);

	push_monitor(mp, clear_failed ? &Discarded_monitors : &Monitor_avail_hdr);

    } /* endif */

} /* end clean_and_push_monitor() */

/****************************************************************
*
*
****************************************************************/

static struct channel *pop_channel()
{

struct channel *rc;
int i;

    if (Debug)
    {
	printf("entering pop_channel()\n");
	print_state();
    } /* endif */

    if (Channel_avail_hdr != NULL)
    {
        rc = Channel_avail_hdr;
        Channel_avail_hdr = rc->next;
    }
    else
    {
        if ((Channel_avail_hdr = (struct channel *) 
	    ezcamalloc((unsigned) (sizeof(struct channel)*NODESPERMAL))) != NULL)
        {
	    if (Debug)
		printf("pop_channel() allocated sizeof(struct channel) %d * NODESPERMAL %d bytes = %d bytes %p\n", 
		    (unsigned)sizeof(struct channel), NODESPERMAL, 
			(unsigned)sizeof(struct channel)*NODESPERMAL, Channel_avail_hdr);

            for (rc = Channel_avail_hdr, i=0; i < (NODESPERMAL-1); i ++)
            {
                rc->next = rc + 1;
				rc->refcnt = 0;
		rc->pvname = (char *) NULL;
		if (Debug)
		    printf("i = %d rc %p rc->next %p\n", i, rc, rc->next);
                rc++;
            } /* endfor */
            rc->next = (struct channel *) NULL;
			rc->refcnt = 0;
	    rc->pvname = (char *) NULL;
	    if (Debug)
		printf("i = %d rc %p rc->next %p\n", i, rc, rc->next);
            rc = Channel_avail_hdr;
            Channel_avail_hdr = rc->next;
        }
        else
            rc = (struct channel *) NULL;
    } /* endif */

    if (rc)
    {
	rc->next = (struct channel *) NULL;
	if (rc->pvname)
	{
	    ezcafree(rc->pvname);
	    rc->pvname = (char *) NULL;
	} /* endif */
	rc->monitor_list = (struct monitor *) NULL;
	rc->ever_successfully_searched = FALSE;
	if ( rc->refcnt ) {
		fprintf(stderr,"EZCA FATAL ERROR: pop_channel refcnt != 0\n"); 
		exit(1);
	}
	rc->refcnt = 1;
    } /* endif */

    if (Debug)
    {
	printf("exiting pop_channel() rc %p rc->next %p\n", 
	    rc, (rc ? rc->next : NULL));
	print_state();
    } /* endif */

    return rc;

} /* end pop_channel() */

/****************************************************************
*
*
****************************************************************/

static struct monitor *pop_monitor()
{

struct monitor *rc;
int i;

    if (Debug)
    {
	printf("entering pop_monitor()\n");
	print_state();
    } /* endif */

    if (Monitor_avail_hdr != NULL)
    {
        rc = Monitor_avail_hdr;
        Monitor_avail_hdr = rc->left;
    }
    else
    {
        if ((Monitor_avail_hdr = (struct monitor *) 
	    ezcamalloc((unsigned) (sizeof(struct monitor)*NODESPERMAL))) != NULL)
        {
	    if (Debug)
		printf("pop_monitor() allocated sizeof(struct monitor) %d * NODESPERMAL %d bytes = %d bytes %p\n", 
		    (unsigned)sizeof(struct monitor), NODESPERMAL, 
		    (unsigned)sizeof(struct monitor)*NODESPERMAL, Monitor_avail_hdr);

            for (rc = Monitor_avail_hdr, i=0; i < (NODESPERMAL-1); i ++)
            {
                rc->left = rc + 1;

		if (Debug)
		    printf("i = %d rc %p rc->left %p\n", i, rc, rc->left);

                rc++;
            } /* endfor */
            rc->left = (struct monitor *) NULL;

	    if (Debug)
		printf("i = %d rc %p rc->left %p\n", i, rc, rc->left);

            rc = Monitor_avail_hdr;
            Monitor_avail_hdr = rc->left;
        }
        else
            rc = (struct monitor *) NULL;
    } /* endif */

    if (rc)
    {
	rc->waiter = (struct work*)NULL;
	rc->left = (struct monitor *) NULL;
	rc->right = (struct monitor *) NULL;
	rc->cp = (struct channel *) NULL;
	rc->ezcadatatype = UNDEFINED;
	rc->dbr_type = UNDEFINED;
	rc->pval = (void *) NULL;
	rc->needs_reading = FALSE;
	rc->active = FALSE;
	rc->last_nelem = UNDEFINED;
	rc->status = UNDEFINED;
	rc->severity = UNDEFINED;
    } /* endif */

    if (Debug)
    {
	printf("exiting pop_monitor() (rc->lft %p) rc %p (rc->right %p)\n", 
	    (rc ? rc->left : NULL), rc, (rc ? rc->right : NULL));
	print_state();
    } /* endif */

    return rc;

} /* end pop_monitor() */

/****************************************************************
*
*
****************************************************************/

static struct work *pop_work()
{

struct work *rc;
int i;

    if (Debug)
    {
	printf("entering pop_work()\n");
	print_state();
    } /* endif */

    if (Work_avail_hdr != NULL)
    {
        rc = Work_avail_hdr;
        Work_avail_hdr = rc->next;
    }
    else
    {
        if ((Work_avail_hdr = (struct work *) 
	    ezcamalloc((unsigned) (sizeof(struct work)*NODESPERMAL))) != NULL)
        {

	    if (Debug)
		printf("pop_work() allocated sizeof(struct work) %d * NODESPERMAL %d bytes = %d bytes %p\n", 
		    (unsigned)sizeof(struct work), NODESPERMAL, 
		    (unsigned)sizeof(struct work)*NODESPERMAL, Work_avail_hdr);

            for (rc = Work_avail_hdr, i=0; i < (NODESPERMAL-1); i ++)
            {
                rc->next = rc + 1;
		rc->pvname = (char *) NULL;
		rc->aux_error_msg = (char *) NULL;

		if (Debug)
		    printf("i = %d rc %p rc->next %p\n", i, rc, rc->next);

                rc++;
            } /* endfor */
            rc->next = (struct work *) NULL;
	    rc->pvname = (char *) NULL;
	    rc->aux_error_msg = (char *) NULL;

	    if (Debug)
		printf("i = %d rc %p rc->next %p\n", i, rc, rc->next);

            rc = Work_avail_hdr;
            Work_avail_hdr = rc->next;
        }
        else
            rc = (struct work *) NULL;
    } /* endif */

    if (rc)
	init_work(rc);

    if (Debug)
    {
	printf("exiting pop_work() rc %p rc->next %p\n", 
	    rc, (rc ? rc->next : NULL));
	print_state();
    } /* endif */

    return rc;

} /* end pop_work() */

/****************************************************************
*
*
****************************************************************/

static void init_work(struct work *wp)
{

    if (wp)
    {
	wp->next = (struct work *) NULL;
	wp->cp = (struct channel *) NULL;
	wp->rc = UNDEFINED;
	wp->error_msg = (char *) NULL;
	if (wp->aux_error_msg)
	{
	    ezcafree(wp->aux_error_msg);
	    wp->aux_error_msg = (char *) NULL;
	} /* endif */
	wp->trashme = usable;
	wp->needs_work = FALSE;
	if (wp->pvname)
	{
	    ezcafree(wp->pvname);
	    wp->pvname = (char *) NULL;
	} /* endif */
	wp->dbr_type = UNDEFINED;
	wp->reported = FALSE;
	wp->worktype = UNDEFINED;
	wp->pval = (void *) NULL;
	wp->nelem = UNDEFINED;
	wp->ezcadatatype = UNDEFINED;
	wp->strp = (char *) NULL;
	wp->intp = (int *) NULL;
	wp->s1p = (short *) NULL;
	wp->s2p = (short *) NULL;
	wp->d1p = (double *) NULL;
	wp->d2p = (double *) NULL;
	wp->status = (short *) NULL;
	wp->severity = (short *) NULL;
	wp->tsp = (epicsTimeStamp *) NULL;
	wp->pchid = (chid *) NULL;
	wp->pevid = (evid *) NULL;
    } /* endif */

} /* end init_work() */

/****************************************************************
*
*
****************************************************************/

static void push_channel(struct channel *p, struct channel **plist)
{
struct channel **pc,*c;

    if (Debug)
    {
	printf("entering push_channel() p %p\n", p);
	print_state();
    } /* endif */

    if (p)
    {
	if (p->pvname)
	{
		for ( pc = &Channels[hash(p->pvname)]; *pc; pc = & (*pc)->next )
			if ( !strcmp(p->pvname, (*pc)->pvname ) ) {
				c = *pc;
				*pc = c->next;
				c->next = 0;
				break;
			}
		
	    ezcafree(p->pvname);
	    p->pvname = (char *) NULL;
	} /* endif */
	p->next = *plist;
	*plist = p;
    } /* endif */

    if (Debug)
    {
	print_state();
	printf("exiting push_channel()\n");
    } /* endif */

} /* end push_channel() */

/****************************************************************
*
* placing them onto discarded monitors because don't want
* subsequent callbacks writing in this value.  
* Ex. subsequent callbacks can occur if ca_clear_event() didn't work.
*
* TS: pass desired list head as an argument; probably EzcaClearEvent()
*     could be called from here...
*
****************************************************************/

static void push_monitor(struct monitor *p, struct monitor **l)
{

    if (Debug)
    {
	printf("entering push_monitor() p %p\n", p);
	print_state();
    } /* endif */

    if (p)
    {
	/* add paranoia */
	memset(p, 0, sizeof(*p));
	p->left = *l;
	*l = p;
    } /* endif */

    if (Debug)
    {
	print_state();
	printf("exiting push_monitor()\n");
    } /* endif */

} /* end push_monitor() */

/****************************************************************
*
*
****************************************************************/

static void recycle_work(struct work *wp)
{
struct work **ppw, *pw;

    if (Debug)
    {
	printf("entering recycle_work() wp %p\n", wp); 
	print_state();
    } /* endif */

	/* internal fields of wp have been released by push_work() when
	 * the wp was put onto the discarded list
	 */

	for ( ppw = &Discarded_work; *ppw; ppw = &(*ppw)->next ) {
		if ( *ppw ==  wp ) {
			/* remove from Discarded_work list */
			*ppw = wp->next;
			wp->next = Work_avail_hdr;
			Work_avail_hdr = wp;
			if (Debug) {
				printf("Success; %p moved from Discarded to Avail list\n", wp);
				printf("exiting recycle_work()\n");
			}
			return;
		}
	}
	/* If we get here, the node is still on the work list
	 * or in Workp...
	 */
	for ( pw = Work_list.head; pw && pw != wp; pw = pw->next )
		;
	if ( pw || Workp == wp ) {
		/* simply reset trashme */
		wp->trashme = recyclable;
		if (Debug) {
			printf("Success; %p found in work list or Workp; recycling trashme\n", wp);
			printf("exiting recycle_work()\n");
		}
		return;
	}
	fprintf(stderr,"EZCA FATAL ERROR: recycle_work() didn't find wp in Discarded list!\n");
	exit(1);
}

static void push_work(struct work *p)
{

    if (Debug)
    {
	printf("entering push_work() p %p trashme %c\n", 
	    p, (p ? (p->trashme + 'U') : 'X'));
	print_state();
    } /* endif */

    if (p)
    {
	if (p->pvname)
	{
	    ezcafree(p->pvname);
	    p->pvname = (char *) NULL;
	} /* endif */

	if (p->aux_error_msg)
	{
	    ezcafree(p->aux_error_msg);
	    p->aux_error_msg = (char *) NULL;
	} /* endif */

	if (trashed == p->trashme)
	{
	    p->next = Discarded_work;
	    Discarded_work = p;
	}
	else
	{
		/* usable and recyclable work nodes appear here */
	    p->next = Work_avail_hdr;
	    Work_avail_hdr = p;
	} /* endif */
    } /* endif */

    if (Debug)
    {
	print_state();
	printf("exiting push_work()\n");
    } /* endif */

} /* end push_work() */

/*************/
/*           */
/* Debugging */
/*           */
/*************/

/****************************************************************
*
*
****************************************************************/

static void print_avails()
{
    print_channel_avail();
    print_monitor_avail();
    print_work_avail();
} /* end print_avails() */

/****************************************************************
*
*
****************************************************************/

static void print_channel_avail()
{

struct channel *cp;

    printf("Channel_avail_hdr %p : ", Channel_avail_hdr); 
    for (cp = Channel_avail_hdr; cp; cp = cp->next) 
	printf("%p (nxt %p) ", cp, cp->next); 
    printf("\n");

} /* end print_channel_avail() */

/****************************************************************
*
*
****************************************************************/

static void print_channels()
{

int            i;
struct channel *cp;
struct monitor *mp;

    printf("Start Channels:\n");
	for ( i=0; i<HASHTABLESIZE; i++ )
    for (cp = Channels[i]; cp; cp = cp->next) 
    {
	printf(">%s< %p (nxt %p) ml %p ", 
	    cp->pvname, cp, cp->next, cp->monitor_list);
	for (mp = cp->monitor_list; mp; mp = mp->right) 
	    printf("M>(lft %p) %p (rght %p) type %d pval %p active %c cp %p<M ",
		mp->left, mp, mp->right, mp->ezcadatatype, mp->pval, 
		(mp->active ? 'T' : 'F'), mp->cp);
	printf("\n");
    } /* endfor */
    printf("End Channels:\n");

} /* end print_channels() */

/****************************************************************
*
*
****************************************************************/

static void print_discarded_channels()
{

struct channel *cp;

    printf("Discarded_channels %p : ", Discarded_channels); 
    for (cp = Discarded_channels; cp; cp = cp->next) 
	printf("%p (nxt %p) ml %p \n", cp, cp->next, cp->monitor_list);
	printf("\n");

} /* end print_discarded_channels() */

/****************************************************************
*
*
****************************************************************/

static void print_discarded_monitors()
{

struct monitor *mp;

    printf("Discarded_monitors %p : ", Discarded_monitors); 
    for (mp = Discarded_monitors; mp; mp = mp->left) 
	printf("%p active %c (lft %p) ", 
	    mp, (mp->active ? 'T' : 'F'), mp->left); 
    printf("\n");

} /* end print_discarded_monitors() */

/****************************************************************
*
*
****************************************************************/

static void print_discarded_work()
{

struct work *wp;

    printf("Discarded_work %p : ", Discarded_work); 
    for (wp = Discarded_work; wp; wp = wp->next) 
	printf("%p trashme %c (nxt %p) ", 
	    wp, (wp->trashme + 'U'), wp->next); 
    printf("\n");

} /* end print_discarded_work() */

/****************************************************************
*
*
****************************************************************/

static void print_monitor_avail()
{

struct monitor *mp;

    printf("Monitor_avail_hdr %p : ", Monitor_avail_hdr); 
    for (mp = Monitor_avail_hdr; mp; mp = mp->left) 
	printf("%p (lft %p) ", mp, mp->left); 
    printf("\n");

} /* end print_monitor_avail() */

/****************************************************************
*
*
****************************************************************/

static void print_state()
{

    printf("****** Start State:\n");
    printf("AutoErrorMessage %c InGroup %c Debug %c Trace %c ErrorLocation %s ListPrint %s TimeoutSeconds %f\n", 
	(AutoErrorMessage ? 'T' : 'F'), 
	(InGroup ? 'T' : 'F'), 
	(Debug ? 'T' : 'F'), 
	(Trace ? 'T' : 'F'), 
	(ErrorLocation == SINGLEWORK 
	    ? "LastOnly"
	    : (ErrorLocation == LISTWORK ? "ListWork" : "Unknown")), 
	(ListPrint == LASTONLY 
	    ? "LastOnly"
	    : (ListPrint == WHOLELIST ? "WholeList" : "Unknown")), 
	TimeoutSeconds);
    print_workp();
    print_avails();
    print_discarded_channels();
    print_discarded_monitors();
    print_discarded_work();
    print_channels();
    print_work_list();
    printf("****** End State:\n");

} /* end print_state() */

/****************************************************************
*
*
****************************************************************/

static void print_work_avail()
{

struct work *wp;

    printf("Work_avail_hdr %p : ", Work_avail_hdr); 
    for (wp = Work_avail_hdr; wp; wp = wp->next) 
	printf("%p (nxt %p) ", wp, wp->next); 
    printf("\n");

} /* end print_work_avail() */

/****************************************************************
*
*
****************************************************************/

static void print_work_list()
{

struct work *wp;

    printf("Work_list head %p tail %p : ", Work_list.head, Work_list.tail); 
    for (wp = Work_list.head; wp; wp = wp->next) 
	printf("%p trashme %c (nxt %p)", 
	    wp, (wp->trashme + 'U'), wp->next); 
    printf("\n");

} /* end print_work_list() */

/****************************************************************
*
*
****************************************************************/

static void print_workp()
{

    printf("Workp : "); 
    if (Workp)
	printf("%p trashme %c (nxt %p)\n", 
	    Workp, (Workp->trashme + 'U'), Workp->next); 
    else
	printf("0\n");

} /* end print_workp() */

#if defined(vxWorks)
char *strdup(const char *str)
{
  char *new, *ptr;
  
  if (! str)
    return(0);
  
  new = (char *) ezcamalloc(strlen(str) + 1);
  if (! new)
    return(0);
  
  for (ptr = new; *ptr++ = *str++; ) /* empty loop body */;
  
  return(new);
}
#endif
