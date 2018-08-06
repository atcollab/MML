/* Sets up a monitor. Handles DBR_STS and DBR_TIME types  */
/* Connects to a pv in each of 2 crates and monitors both */
/* Added WIN32 def for windows compatibility */
#ifdef WIN32
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <time.h>
#include <windows.h>
#include <mmsystem.h>
#define CREATE_MONITOR_LOCK
#define DELETE_MONITOR_LOCK
#define LOCK_MONITOR_CACHE
#define UNLOCK_MONITOR_CACHE

#elif VXWORKS
#include "caerr.h"
#include "cadef.h"
#include "stdioLib.h"
#include "stdlib.h"
#include <string.h>
#include "sys/times.h"
#define CREATE_MONITOR_LOCK
#define DELETE_MONITOR_LOCK
#define LOCK_MONITOR_CACHE
#define UNLOCK_MONITOR_CACHE

#else
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/time.h>
#define CREATE_MONITOR_LOCK
#define DELETE_MONITOR_LOCK
#define LOCK_MONITOR_CACHE
#define UNLOCK_MONITOR_CACHE
#endif

#include <math.h>
#include "dbDefs.h"
#include "caerr.h"
#include "cadef.h"
#include "epicsVersion.h"
#include "alarm.h"
#include "ellLib.h"

#define SCA_LIBRARY	0    /* keeps sca_get LOCAL, not extern in scalib.h */
#include "scalib.h"
#include "scalib_private.h"
#include "sca_release.h"

#define PEND_DELAY      2.0

/* hash table of pointers to lists of ACCELERATION_CONTROL_BLOCKs */
/* Begin hash table global definitions */

#define NTABLESIZES 9
static struct {
	unsigned int	tablesize;
	int		shift;
}sca_hashTableParms[NTABLESIZES] = {
	{256,0},
	{512,1},
	{1024,2},
	{2048,3},
	{4096,4},
	{8192,5},
	{16384,6},
	{32768,7},
	{65536,8}
};

#define DEFAULT_HASHSIZE	4	/* pick pair from table above */

#define AP_NULL	( ( ACCELERATION_CONTROL_BLOCK * )NULL )

ACCELERATION_CONTROL_BLOCK **acb_hashtbl = ( ACCELERATION_CONTROL_BLOCK **)NULL;
ACCELERATION_CONTROL_BLOCK *last_ap = AP_NULL;

int sca_HashTableSize = -1;
int sca_HashTableShift = -1;
int last_hash_index = -1;


/*The hash algorithm is a modification of the algorithm described in	*/
/* Fast Hashing of Variable Length Text Strings, Peter K. Pearson,	*/
/* Communications of the ACM, June 1990					*/
/* The modifications were designed by Marty Kraimer			*/

static unsigned char T[256] = {
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
/* End hash table global definitions */

int first_time = 0;
double try_hard_failure_time = 0.0;
double sca_time_of_pend = 0.0;
int num_pends = 0;

/*
** Globals for Version 3.0 routines
*/

ACCELERATION_CONTROL_BLOCK **ap_table;
int ap_table_nelm = 0;
int ap_table_len = 0;

Q_ITEM *get_q;
int get_q_state = SCA_NO_Q;
int get_q_len = 0;
int get_q_nelm = 0;
CALLBACK_CODE get_callback_code = 0;
double get_timestamp = 0.0;

Q_ITEM *put_q;
int put_q_state = SCA_NO_Q;
int put_q_len = 0;
int put_q_nelm = 0;
CALLBACK_CODE put_callback_code = 0;
double put_timestamp = 0.0;

int num_not_connected = 0;
int status_dump;		/* unwanted statuses dumped here */

unsigned long num_que_gets = 0;
unsigned long num_que_get_errors = 0;
unsigned long num_get_callbacks = 0;
unsigned long missing_get_callbacks = 0;
unsigned long ignored_get_callbacks = 0;
unsigned long num_do_gets = 0;

unsigned long num_que_puts = 0;
unsigned long num_que_put_errors = 0;
unsigned long num_put_callbacks = 0;
unsigned long missing_put_callbacks = 0;
unsigned long ignored_put_callbacks = 0;
unsigned long num_do_puts = 0;

double min_time_between_do_gets = MIN_TIME_BETWEEN_DO_GETS;
double min_time_between_do_puts = MIN_TIME_BETWEEN_DO_PUTS;
double min_smart_pend_interval  = MIN_SMART_PEND_INTERVAL;

/* definitions  for event logging */

static SINGLE_EVENT *event_buf = ( SINGLE_EVENT *)NULL;
static int *event_buf_size = ( int *)NULL;
static int *event_counter = ( int *)NULL;

double n2s = 1000000000.0;

#ifndef WIN32
int cache_smart_pend();
int cache_pend();
int print_ap();
/*extern void cac_gettimeval(struct timeval  *pt);*/
#endif

int scatypes[] = {				SCA_STRING,
						SCA_SHORT,
						SCA_FLOAT,
						SCA_ENUM,
						SCA_CHAR,
						SCA_LONG,
						SCA_DOUBLE,
						SCA_INT		};

char scatype_names[][SCA_TYPE_SZ] = {		"SCA_STRING",
						"SCA_SHORT",
						"SCA_FLOAT",
						"SCA_ENUM",
						"SCA_CHAR",
						"SCA_LONG",
						"SCA_DOUBLE",
						"SCA_INT" 	};

char sca_extensions[][SCA_EXTENSION_SZ] = {	".STR",
						".SHT",
						".FLT",
						".ENM",
						".CHR",
						".LNG",
						".DBL",
						".INT"		};
char sca_what[] = { " SCA_WHAT?" };

int num_scatypes = sizeof( scatypes ) / sizeof( int );

char sca_conn_up[]    = {" CONNECTED"};
char sca_conn_down[]  = {" DISCONNECTED"};
char sca_conn_never[] = {" NEVER_CONNECTED"};
char sca_conn_state_irrelevant[] = {" "};
char sca_no_conn_state[]= {" NO_CONNECTION_STATE"};

char sca_mon_active[] = {" MONITOR_ACTIVE"};
char sca_mon_stdby[]  = {" MONITOR_ON_STANDBY"};
char sca_mon_never[]  = {" NEVER_MONITORED"};
char sca_mon_corrupt[]= {" MONITOR_CORRUPTED"};
char sca_mon_state_irrelevant[] = {" "};
char sca_no_mon_state[]= {" NO_MONITOR_STATE"};

char sca_val_fresh[]  = {" FRESH_VALUE"};
char sca_val_old[]    = {" OLD_VALUE"};
char sca_val_not[]    = {" NO_VALUE"};
char sca_val_state_irrelevant[] = {" "};
char sca_no_val_state[]= {" NO_VALUE_STATE"};

int scatype_name2num();
char *scatype2asc();
char *connst2asc();
char *monst2asc();
char *valst2asc();
double sca_gettimeofday();


scaEntry
int scaCall
sca_release( revision )
char *revision;
{
    strcpy( revision, release );
    return 0;
}

/*
** --------------------------------------------------------------------
** SCA - METHOD 1 - Queued data requests.  No caching of data.   !!!!!
** --------------------------------------------------------------------
*/

scaEntry
int scaCall
set_min_time_between_do_gets( time )
double time;
{
    if ( time >= 0.0 ) min_time_between_do_gets = time;
    return 0;
}

scaEntry
double scaCall
get_min_time_between_do_gets()
{
    return min_time_between_do_gets;
}

scaEntry
int scaCall
set_min_time_between_do_puts( time )
double time;
{
    if ( time >= 0.0 ) min_time_between_do_puts = time;
    return 0;
}

scaEntry
double scaCall
get_min_time_between_do_puts()
{
    return min_time_between_do_puts;
}

scaEntry
int scaCall
set_min_smart_pend_interval( time )
double time;
{
    if ( time >= 0.0 ) min_smart_pend_interval = time;
    return 0;
}

scaEntry
double scaCall
get_min_smart_pend_interval()
{
    return min_smart_pend_interval;
}

scaEntry
int scaCall
que_get( name, scatype, n, pdest, pstatus )
char *name;         			/* fieldname */
int scatype;                            /* data type, e.g. SCA_STRING */
int n;                                  /* number of data elements */
void *pdest;                            /* Pointer to array to receive data */
int *pstatus;                           /* Pointer to int to receive status */
{
    ACCELERATION_CONTROL_BLOCK *ap;
    chtype dtype;
    char sca_name[SCA_NAME_STRING_SIZE];
    int stat;

    if ( pstatus == ( int *)NULL )	/* setup to return status or not */
	pstatus = &status_dump;

    if ( pdest == ( void * )NULL )
    {
	*pstatus = SCA_BAD_ARG + SCA_NO_AP;
	++num_que_get_errors;
	return *pstatus;
    }

    stat = scatodbr( scatype, &dtype );/* map scatype -> DBR_... type */
    if ( sca_error( stat ) )
    {
	*pstatus = stat;
	++num_que_get_errors;
	return stat;
    }

    stat = sca_name_gen( name, scatype, sca_name );	/* form field.type id*/
    if ( sca_error( stat ) )
    {
	*pstatus = stat;
	++num_que_get_errors;
	return stat;
    }

    switch ( get_q_state )
    {
	case SCA_NO_Q:
	    get_q_len = GET_Q_INC;
	    get_q = ( Q_ITEM *)malloc( get_q_len * sizeof( Q_ITEM ) );
	    if ( get_q == ( Q_ITEM *)NULL )
	    {
		*pstatus = SCA_CANNOT_MALLOC + SCA_NO_AP;
		++num_que_get_errors;
		return *pstatus;
	    }				/* no break intentional */

	case SCA_Q_CLOSED:
	    get_q_nelm = 0;
	    get_q_state = SCA_Q_OPEN;	/* no break intentional */

	case SCA_Q_OPEN:
	    ap = find_ap( sca_name );   
	    if ( ap == ( ACCELERATION_CONTROL_BLOCK * )NULL )
	    {
		stat = sca_buildap( name, scatype, n, (void **)(&ap) );
    		if ( sca_error( stat ) )
    		{
		    *pstatus = stat;
		    ++num_que_get_errors;
		    return stat;
    		}
	    }

	    ap->q_get_value_state = SCA_NO_VALUE;
	    stat = add_to_get_q( ap, n, pdest, pstatus );
	    if ( sca_error( stat ) )
	    {
		*pstatus = qget_form_status( stat & SCA_ERROR_MASK, ap );
		++num_que_get_errors;
		++ap->num_que_get_errors;
		return *pstatus;
	    }
    }
    ++ap->num_que_gets;
    ++num_que_gets;
    ap->last_que_get_time = sca_gettimeofday();
    *pstatus = qget_form_status( SCA_NO_ERROR, ap );
	
    return *pstatus;
}

scaEntry
int scaCall
que_getbyindex( index, n, pdest, pstatus )
int index;                              /* index from sca_find_index() */
int n;                                  /* number of data elements */
void *pdest;                            /* Pointer to array to receive data */
int *pstatus;                           /* Pointer to int to receive status */
{
    ACCELERATION_CONTROL_BLOCK *ap;
    chtype dtype;
    char sca_name[SCA_NAME_STRING_SIZE];
    int stat;

    if ( pstatus == ( int *)NULL )	/* setup to return status or not */
	pstatus = &status_dump;

    if ( index < 0 || index >= ap_table_nelm )
    {
	*pstatus = SCA_BAD_ARG + SCA_NO_AP;
	++num_que_get_errors;
	return *pstatus;
    }

    ap = ap_table[index];   
    if ( ap == ( ACCELERATION_CONTROL_BLOCK * )NULL )
    {
	*pstatus = SCA_NO_ACB + SCA_NO_AP;
	++num_que_get_errors;
	return *pstatus;
    }

    if ( pdest == ( void * )NULL )
    {
	*pstatus = SCA_BAD_ARG + SCA_NO_AP;
	++num_que_get_errors;
	return *pstatus;
    }

    switch ( get_q_state )
    {
	case SCA_NO_Q:
	    get_q_len = GET_Q_INC;
	    get_q = ( Q_ITEM *)malloc( get_q_len * sizeof( Q_ITEM ) );
	    if ( get_q == ( Q_ITEM *)NULL )
	    {
		*pstatus = SCA_CANNOT_MALLOC + SCA_NO_AP;
		++num_que_get_errors;
		return *pstatus;
	    }				/* no break intentional */

	case SCA_Q_CLOSED:
	    get_q_nelm = 0;
	    get_q_state = SCA_Q_OPEN;	/* no break intentional */

	case SCA_Q_OPEN:
	    ap->q_get_value_state = SCA_NO_VALUE;
	    stat = add_to_get_q( ap, n, pdest, pstatus );
	    if ( sca_error( stat ) )
	    {
		*pstatus = qget_form_status( stat & SCA_ERROR_MASK, ap );
		++num_que_get_errors;
		++ap->num_que_get_errors;
		return *pstatus;
	    }
    }
    ++ap->num_que_gets;
    ++num_que_gets;
    ap->last_que_get_time = sca_gettimeofday();
    *pstatus = qget_form_status( SCA_NO_ERROR, ap );
	
    return *pstatus;
}

scaEntry
int scaCall
do_get( double timeout )
{
    int i, count;
    double now;
    double dt;
    void que_get_callback_handler();

    ACCELERATION_CONTROL_BLOCK *ap;
    AP_INDEX ap_index;

    double end_time;
    float pend_time;

    int missing_callbacks;
    int num_cannot_get;

    end_time = sca_gettimeofday() + timeout;
    if ( timeout == 0.0 )
	end_time += 2.0;		/* Is connection wait only for t=0.0 */

    if ( get_q_nelm == 0 )		/* anything to do? */
    {
	return -1;
    }

    get_q_state = SCA_Q_CLOSED;

    get_callback_code += CALLBACK_CODE_INC;
    if ( get_callback_code == 0 )
	get_callback_code = CALLBACK_CODE_INC;

    ++num_do_gets;

    /* PASS 1
    **
    **  Flush and wait for connections if there is at least 1 channel which
    **		1. is not connected and
    **		2. this is the first get of its value.
    */
    num_not_connected = 0;
    for ( i = 0; i < get_q_nelm; ++i )
    {
	ap_index = get_q[i] & AP_INDEX_MASK;
	ap = ap_table[ap_index];
	++ap->num_gets;
	if ( sca_not_connected( ap->connection_state ) )
	{
	    *((int*)(ap->q_get_pstatus)) =
		qget_form_status( SCA_CANNOT_GET, ap );
	    if ( ap->num_gets == 1 )
		++num_not_connected;
	}
	else
	    *((int*)(ap->q_get_pstatus)) =
		qget_form_status(SCA_NO_CALLBACK, ap );

	ap->q_get_value_state = SCA_NO_VALUE;
    }
    count = -1;
    if ( num_not_connected > 0 )	/* giv'em a chance to connect */
    {
#ifdef VXWORKS
	pend_time = .017;
#else
	pend_time = .0005F;
#endif
	for (;; )
	{
	    int j;

	    ca_pend_event( pend_time );    
	    ++count;

	    num_not_connected = 0;
	    for ( j = 0; j < get_q_nelm; ++j )
	    {
		ap_index = get_q[j] & AP_INDEX_MASK;
		ap = ap_table[ap_index];
		if ( sca_not_connected( ap->connection_state ) )
		{
		    *((int*)(ap->q_get_pstatus)) =
			qget_form_status( SCA_CANNOT_GET,ap);
		    if ( ap->num_gets == 1 )
			++num_not_connected;
		}
		else
		    *((int*)(ap->q_get_pstatus)) =
			qget_form_status(SCA_NO_CALLBACK,ap);
	    }
	    if ( num_not_connected == 0)
		break;

	    if ( ( now = sca_gettimeofday() ) > end_time )
		break;
	}
    }

    /* PASS 2
    **
    ** Do the gets and wait for the callbacks for all which were found
    ** connected above.
    */

    /*num_get_callbacks = 0;*/

    /* Limit call frequency if necessary */

    now = sca_gettimeofday();
    ap_index = get_q[0] & AP_INDEX_MASK;
    ap = ap_table[ap_index];
    dt = now - ap->last_do_get_time;

    if ( dt < min_time_between_do_gets )
    {
	float min_time = min_time_between_do_gets - dt;
	if ( min_time > 0.0 )
	    ca_pend_event( min_time );
	now = sca_gettimeofday();
    }

    num_cannot_get = 0;
    for ( i = 0; i < get_q_nelm; ++i )
    {
	int ca_status;
	unsigned n;

	ap_index = get_q[i] & AP_INDEX_MASK;
	ap = ap_table[ap_index];
	ap->last_do_get_time = now;
	ap->get_callback_code = get_callback_code;
	ap->get_callback_code_h = 0;
	get_q[i] = get_q[i] & AP_INDEX_MASK | get_callback_code;

	if ( sca_no_callback( *((int*)(ap->q_get_pstatus)) ) )
	{
	    if ( ap->q_get_n > ( n = ca_element_count(ap->channel_id ) ) )
		ap->q_get_n = n;

	    ca_status = ca_array_get_callback(
			ap->dtype,
			ap->q_get_n,
			ap->channel_id,
			que_get_callback_handler,
			(void *)get_q[i] );
	    if ( ca_status != ECA_NORMAL )
	    {
		*((int*)(ap->q_get_pstatus)) =
			qget_form_status( SCA_CANNOT_GET,ap);
		++num_cannot_get;
	    }
	    else
	    {
		++ap->missing_get_callbacks;
		++missing_get_callbacks;
	    }
	}
	else
	    ++num_cannot_get;
    }
    missing_callbacks = 0;
    count = -1;
#ifdef VXWORKS
	pend_time = .017;
#else
	pend_time = .0005F;
#endif

    end_time = sca_gettimeofday() + timeout;
    if ( timeout == 0.0 ) end_time += 1.0;
    for (;; )
    {
	int j;
	int ca_stat;

	ca_stat = ca_pend_event( pend_time );    
	++count;

	missing_callbacks = 0;
	for ( j = 0; j < get_q_nelm; ++j )
	{
	    ap_index = get_q[j] & AP_INDEX_MASK;
	    ap = ap_table[ap_index];
	    if ( sca_error( *((int*)(ap->q_get_pstatus)) ) ||
	         ap->get_callback_code_h != ap->get_callback_code )
		++missing_callbacks;
	}
	if ( missing_callbacks <= num_cannot_get )
	    break;

	if ( ( now = sca_gettimeofday() ) > end_time )
	    break;
    }
    return missing_callbacks;
}

scaEntry
int scaCall
do_getbyname( name, scatype, n, pdest, pstatus )
char *name;         			/* fieldname */
int scatype;                            /* data type, e.g. SCA_STRING */
int n;                                  /* number of data elements */
void *pdest;                            /* Pointer to array to receive data */
int *pstatus;                           /* Pointer to int to receive status */
{
    int status = que_get( name, scatype, n, pdest, pstatus );
    if ( sca_error( status ) )
	return 1;
    return do_get( 5.0 );
}

scaEntry
int scaCall
do_getbyindex( index, n, pdest, pstatus )
int index;                            	/* index from  sca_find_index()*/
int n;                                  /* number of data elements */
void *pdest;                            /* Pointer to array to receive data */
int *pstatus;                           /* Pointer to int to receive status */
{
    int status = que_getbyindex( index, n, pdest, pstatus );
    if ( sca_error( status ) )
	return 1;
    return do_get( 5.0 );
}

scaEntry
int scaCall
do_putbyname( name, scatype, n, psrc, pstatus )
char *name;         			/* fieldname */
int scatype;                            /* data type, e.g. SCA_STRING */
int n;                                  /* number of data elements */
void *psrc;                             /* Pointer to array containing data */
int *pstatus;                           /* Pointer to int to receive status */
{
    int status = que_put( name, scatype, n, psrc, pstatus );
    if ( sca_error( status ) )
	return 1;
    return do_put( 5.0 );
}

scaEntry
int scaCall
do_putbyindex( index, n, psrc, pstatus )
int index;                            	/* index from  sca_find_index()*/
int n;                                  /* number of data elements */
void *psrc;                             /* Pointer to array containing data */
int *pstatus;                           /* Pointer to int to receive status */
{
    int status = que_putbyindex( index, n, psrc, pstatus );
    if ( sca_error( status ) )
	return 1;
    return do_put( 5.0 );
}

/* 
callback funcution for ca_array_get_callback
*/ 

void
que_get_callback_handler( arg )
struct event_handler_args arg;
{
    int i, n;
    ACCELERATION_CONTROL_BLOCK  *ap;
    chid channel_id = arg.chid;
    chtype dbrType = arg.type;
    long count = arg.count;
    union db_access_val *pBuf = ( union db_access_val * )arg.dbr;
    CALLBACK_CODE user_arg = ( CALLBACK_CODE )arg.usr;

    AP_INDEX ap_index = user_arg & AP_INDEX_MASK;
    ap = ap_table[ap_index];
/*
print_event_args( arg, "que_get_callback_handler" );
printf("HODAR: %s\n",  ca_message( arg.status ) );
*/

    ++num_get_callbacks;
    if ( ( user_arg & CALLBACK_CODE_MASK ) !=  ap->get_callback_code )
    {
	++ap->ignored_get_callbacks;
	++ignored_get_callbacks;
	return;
    }

    ap->get_callback_ca_status = arg.status;
    if ( arg.status != ECA_NORMAL )
    {
	if ( arg.status == ECA_DISCONN )
	{
	    ap->connection_state = SCA_DISCONNECTED;
	    ap->q_get_value_state = SCA_NO_VALUE;
	    *((int*)(ap->q_get_pstatus)) =
		qget_form_status( SCA_CANNOT_GET, ap );
	    return;
	}

	if ( arg.status == ECA_CONN )
	{
	    ap->connection_state = SCA_CONNECTED;
	}
    }

    if ( ( void *)pBuf == ( void *)NULL )
    {
	ap->q_get_value_state = SCA_NO_VALUE;
	*((int*)(ap->q_get_pstatus)) = qget_form_status( SCA_CANNOT_GET, ap );
	return;
    }

    --ap->missing_get_callbacks;
    --missing_get_callbacks;
    ap->get_callback_code_h = user_arg & CALLBACK_CODE_MASK;
    n = ap->q_get_n;
    if ( n > count ) n = count;

    if ( dbr_type_is_STRING( dbrType ) )
    {
	ap->q_get_alarm_severity = ((struct dbr_time_string *)pBuf)->severity;
	ap->q_get_alarm_status = ((struct dbr_time_string *)pBuf)->status;
	bcopy( &((struct dbr_time_string *)pBuf)->value[0],
	    &(( char *)ap->q_get_pdest)[0], n * MAX_STRING_SIZE );
    }

    else if ( dbr_type_is_SHORT( dbrType ) )
    {
	ap->q_get_alarm_severity = ((struct dbr_time_short *)pBuf)->severity;
	ap->q_get_alarm_status = ((struct dbr_time_short *)pBuf)->status;
	bcopy(
	    ( char *)&(( short *)&(((struct dbr_time_short *)pBuf)->value))[0],
	    ( char *)&(( short *)(ap->q_get_pdest))[0],
	    n * sizeof( short ) );
    }

    else if ( dbr_type_is_FLOAT( dbrType ) )
    {
	int i;
	ap->q_get_alarm_severity = ((struct dbr_time_float *)pBuf)->severity;
	ap->q_get_alarm_status = ((struct dbr_time_float *)pBuf)->status;
	bcopy(
	    ( char *)&(( float *)&(((struct dbr_time_float *)pBuf)->value))[0],
	    ( char *)&(( float *)(ap->q_get_pdest))[0],
	    n * sizeof( float ) );
/*
for( i=0; i<n; ++i )
{
printf( "%d 0x%08x %g\n",
dbrType,
(( float *)&(((struct dbr_time_float *)pBuf)->value))[0],
(( float *)&(((struct dbr_time_float *)pBuf)->value))[0]);
}
*/
    }

    else if ( dbr_type_is_ENUM( dbrType ) )
    {
	ap->q_get_alarm_severity = ((struct dbr_time_enum *)pBuf)->severity;
	ap->q_get_alarm_status = ((struct dbr_time_enum *)pBuf)->status;
	bcopy(
	    ( char *)&(( unsigned short *)\
				    &(((struct dbr_time_enum *)pBuf)->value))[0],
	    ( char *)&(( unsigned short *)(ap->q_get_pdest))[0],
	    n * sizeof( unsigned short ) );
    }

    else if ( dbr_type_is_CHAR( dbrType ) )
    {
	ap->q_get_alarm_severity = ((struct dbr_time_char *)pBuf)->severity;
	ap->q_get_alarm_status = ((struct dbr_time_char *)pBuf)->status;
	bcopy(
	    ( char *)&(( char *)&(((struct dbr_time_char *)pBuf)->value))[0],
	    ( char *)&(( char *)(ap->q_get_pdest))[0],
	    n * sizeof( char ) );
    }

    else if ( dbr_type_is_LONG( dbrType ) )
    {
	ap->q_get_alarm_severity = ((struct dbr_time_long *)pBuf)->severity;
	ap->q_get_alarm_status = ((struct dbr_time_long *)pBuf)->status;
	bcopy(
	    ( char *)&(( long *)&(((struct dbr_time_long *)pBuf)->value))[0],
	    ( char *)&(( long *)(ap->q_get_pdest))[0],
	    n * sizeof( long ) );
    }

    else if ( dbr_type_is_DOUBLE( dbrType ) )
    {
	ap->q_get_alarm_severity = ((struct dbr_time_double *)pBuf)->severity;
	ap->q_get_alarm_status = ((struct dbr_time_double *)pBuf)->status;
	bcopy(
	    ( char *)&(( double *)&(((struct dbr_time_double *)pBuf)->value))[0],
	    ( char *)&(( double *)(ap->q_get_pdest))[0],
	    n * sizeof( double ) );
    }

    else
    {
	ap->q_get_value_state = SCA_NO_VALUE;
	*((int *)ap->q_get_pstatus) = qget_form_status( SCA_BAD_DATA_TYPE, ap );
	++ap->num_que_get_errors;
	return;
    }
    ap->q_get_value_state = SCA_FRESH_VALUE;
    *((int*)(ap->q_get_pstatus)) = qget_form_status( SCA_NO_ERROR, ap );
    return;
}

/* BEGIN put */

scaEntry int scaCall
que_put( name, scatype, n, psrc, pstatus )
char *name;         			/* fieldname */
int scatype;                            /* data type, e.g. SCA_STRING */
int n;                                  /* number of data elements */
void *psrc;                             /* Pointer to array containing data */
int *pstatus;                           /* Pointer to int to receive status */
{
    ACCELERATION_CONTROL_BLOCK *ap;
    chtype dtype;
    char sca_name[SCA_NAME_STRING_SIZE];
    int stat;

    if ( pstatus == ( int *)NULL )	/* setup to return status or not */
	pstatus = &status_dump;

    if ( psrc == ( void * )NULL )
    {
	*pstatus = SCA_BAD_ARG + SCA_NO_AP;
	++num_que_put_errors;
	return *pstatus;
    }

    stat = scatodbr( scatype, &dtype );/* map scatype -> DBR_... type */
    if ( sca_error( stat ) )
    {
	*pstatus = stat;
	++num_que_put_errors;
	return stat;
    }

    stat = sca_name_gen( name, scatype, sca_name );	/* form field.type id*/
    if ( sca_error( stat ) )
    {
	*pstatus = stat;
	++num_que_put_errors;
	return stat;
    }

    switch ( put_q_state )
    {
	case SCA_NO_Q:
	    put_q_len = GET_Q_INC;
	    put_q = ( Q_ITEM *)malloc( put_q_len * sizeof( Q_ITEM ) );
	    if ( put_q == ( Q_ITEM *)NULL )
	    {
		*pstatus = SCA_CANNOT_MALLOC + SCA_NO_AP;
		++num_que_put_errors;
		return *pstatus;
	    }				/* no break intentional */

	case SCA_Q_CLOSED:
	    put_q_nelm = 0;
	    put_q_state = SCA_Q_OPEN;	/* no break intentional */

	case SCA_Q_OPEN:
	    ap = find_ap( sca_name );   
	    if ( ap == ( ACCELERATION_CONTROL_BLOCK * )NULL )
	    {
		stat = sca_buildap( name, scatype, n, ( void **)(&ap) );
    		if ( sca_error( stat ) )
    		{
		    *pstatus = stat;
		    ++num_que_put_errors;
		    return stat;
    		}
	    }

	    stat = add_to_put_q( ap, n, psrc, pstatus );
	    if ( sca_error( stat ) )
	    {
		*pstatus = qput_form_status( stat & SCA_ERROR_MASK, ap );
		++num_que_put_errors;
		++ap->num_que_put_errors;
		return *pstatus;
	    }
    }
    ++ap->num_que_puts;
    ++num_que_puts;
    ap->last_que_put_time = sca_gettimeofday();
    *pstatus = qput_form_status( SCA_NO_ERROR, ap );
	
    return *pstatus;
}

scaEntry int scaCall
que_putbyindex( index, n, psrc, pstatus )
int index;                            	/* data type, e.g. SCA_STRING */
int n;                                  /* number of data elements */
void *psrc;                             /* Pointer to array containing data */
int *pstatus;                           /* Pointer to int to receive status */
{
    ACCELERATION_CONTROL_BLOCK *ap;
    chtype dtype;
    char sca_name[SCA_NAME_STRING_SIZE];
    int stat;

    if ( pstatus == ( int *)NULL )	/* setup to return status or not */
	pstatus = &status_dump;

    if ( index < 0 || index >= ap_table_nelm )
    {
	*pstatus = SCA_BAD_ARG + SCA_NO_AP;
	++num_que_put_errors;
	return *pstatus;
    }

    ap = ap_table[index];   
    if ( ap == ( ACCELERATION_CONTROL_BLOCK * )NULL )
    {
	*pstatus = SCA_NO_ACB + SCA_NO_AP;
	++num_que_put_errors;
	return *pstatus;
    }

    if ( psrc == ( void * )NULL )
    {
	*pstatus = SCA_BAD_ARG + SCA_NO_AP;
	++num_que_put_errors;
	return *pstatus;
    }

    switch ( put_q_state )
    {
	case SCA_NO_Q:
	    put_q_len = GET_Q_INC;
	    put_q = ( Q_ITEM *)malloc( put_q_len * sizeof( Q_ITEM ) );
	    if ( put_q == ( Q_ITEM *)NULL )
	    {
		*pstatus = SCA_CANNOT_MALLOC + SCA_NO_AP;
		++num_que_put_errors;
		return *pstatus;
	    }				/* no break intentional */

	case SCA_Q_CLOSED:
	    put_q_nelm = 0;
	    put_q_state = SCA_Q_OPEN;	/* no break intentional */

	case SCA_Q_OPEN:
	    stat = add_to_put_q( ap, n, psrc, pstatus );
	    if ( sca_error( stat ) )
	    {
		*pstatus = qput_form_status( stat & SCA_ERROR_MASK, ap );
		++num_que_put_errors;
		++ap->num_que_put_errors;
		return *pstatus;
	    }
    }
    ++ap->num_que_puts;
    ++num_que_puts;
    ap->last_que_put_time = sca_gettimeofday();
    *pstatus = qput_form_status( SCA_NO_ERROR, ap );
	
    return *pstatus;
}

scaEntry int scaCall
do_put( double timeout )
/* timeout  > 0.0 callbacks are expected. */
/*                allow timeout seconds for connections & callbacks */
/* timeout <= 0.0 no callbacks are expected */
/*                allow cabs(timeout) seconds for connections */
{
    int i, k, count;
    double now;
    double dt;
    void que_put_callback_handler();

    ACCELERATION_CONTROL_BLOCK *ap;
    AP_INDEX ap_index;

    double start_time = sca_gettimeofday(); 
    double end_time;
    float pend_time;

    int missing_callbacks;
    int num_put_failures = 0;

    end_time = start_time + fabs( timeout );

    if ( put_q_nelm == 0 )		/* anything to do? */
	return -1;

    put_q_state = SCA_Q_CLOSED;

    put_callback_code += CALLBACK_CODE_INC;
    if ( put_callback_code == 0 )
	put_callback_code = CALLBACK_CODE_INC;

    ++num_do_puts;
    /* PASS 1
    **
    **  Flush and wait for connections
    **
    */
    num_not_connected = 0;
    for ( i = 0; i < put_q_nelm; ++i )
    {
	ap_index = put_q[i] & AP_INDEX_MASK;
	ap = ap_table[ap_index];
	if ( sca_not_connected( ap->connection_state ) )
	    ++num_not_connected;
    }

    count = -1;
    if ( num_not_connected > 0 )	/* giv'em a chance to connect */
    {
	int j;
#ifdef VXWORKS
	pend_time = .017;
#else
	pend_time = .0005F;
#endif
	for ( ;; )
	{
	    ca_pend_event( pend_time );    
	    ++count;

	    num_not_connected = 0;
	    for ( j = 0; j < put_q_nelm; ++j )
	    {
		ap_index = put_q[j] & AP_INDEX_MASK;
		ap = ap_table[ap_index];
		if ( sca_not_connected( ap->connection_state ) )
		{
		    ++num_not_connected;
		}
	    }
	    if ( num_not_connected == 0)
		break;

	    if ( ( now = sca_gettimeofday() ) > end_time )
		break;
	}
/*
if ( count > 0 ) printf("do_put: wait_for_connections %d times\n", count+1 );
*/
    }

    /* PASS 2
    **
    ** Do the puts and wait for the callbacks
    **
    */

    /*num_put_callbacks = 0;*/

    /* Limit call frequency if necessary */

    now = sca_gettimeofday();
    ap_index = put_q[0] & AP_INDEX_MASK;
    ap = ap_table[ap_index];
    dt = now - ap->last_do_put_time;

    if ( dt < min_time_between_do_puts )
    {
	float min_time = min_time_between_do_puts - dt;
	if ( min_time > 0.0 )
	    ca_pend_event( min_time );
	now = sca_gettimeofday();
    }

    for ( k = 0; k < put_q_nelm; ++k )
    {
	int ca_status;
	int n;

	ap_index = put_q[k] & AP_INDEX_MASK;
	ap = ap_table[ap_index];
	ap->last_do_put_time = now;
	ap->put_callback_code = put_callback_code;
	ap->put_callback_code_h = 0;
	ap->q_put_value_state = SCA_NO_VALUE;
	put_q[k] = put_q[k] & AP_INDEX_MASK | put_callback_code;
	*((int*)(ap->q_put_pstatus)) = qput_form_status( SCA_NO_CALLBACK, ap );
	n = ap->q_put_n;

	switch ( ap->scatype )
	{
	    int i;	/* intention for local loops */
	    case SCA_STRING: 
		for ( i = 0; i < n; ++i )
		{
		    strncpy((char * )ap->q_put_pcontrol + i * MAX_STRING_SIZE,
			    (char * )ap->q_put_psrc + i * MAX_STRING_SIZE,
			    MAX_STRING_SIZE-1 );
		    *( ( ( char * )ap->q_put_pcontrol ) +
				( i + 1 ) * MAX_STRING_SIZE - 1 )  = '\0';
		}
		break;
	    case SCA_SHORT:
		bcopy( ( char *)&(( short * )ap->q_put_psrc )[0],
		       ( char *)&(( short * )ap->q_put_pcontrol)[0],
		       n * sizeof( short ) );
		break;
	    case SCA_FLOAT:
		bcopy( ( char *)&(( float * )ap->q_put_psrc )[0],
		       ( char *)&(( float * )ap->q_put_pcontrol)[0],
		       n * sizeof( float ) );
		break;
	    case SCA_ENUM:
		bcopy( ( char *)&(( unsigned short * )ap->q_put_psrc )[0],
		       ( char *)&(( unsigned short * )ap->q_put_pcontrol)[0],
		       n * sizeof( unsigned short ) );
		break;
	    case SCA_CHAR:
		bcopy( ( char *)&(( unsigned char * )ap->q_put_psrc )[0],
		       ( char *)&(( unsigned char * )ap->q_put_pcontrol)[0],
		       n * sizeof( unsigned char ) );
		break;
	    case SCA_LONG:
		bcopy( ( char *)&(( long * )ap->q_put_psrc )[0],
		       ( char *)&(( long * )ap->q_put_pcontrol)[0],
		       n * sizeof( long ) );
		break;
	    case SCA_DOUBLE:
		bcopy( ( char *)&(( double * )ap->q_put_psrc )[0],
		       ( char *)&(( double * )ap->q_put_pcontrol)[0],
		       n * sizeof( double ) );
		break;
	    case SCA_INT:
		bcopy( ( char *)&(( int * )ap->q_put_psrc )[0],
		       ( char *)&(( int * )ap->q_put_pcontrol)[0],
		       n * sizeof( int ) );
		break;
	    default:
/*BAD*/	        return qput_form_status( SCA_BAD_DATA_TYPE, ap );
	}

	if ( timeout <= 0.0 )
	{
	    ca_status = ca_array_put(
			    ap->dtype % (LAST_TYPE+1),
			    ap->q_put_n,
			    ap->channel_id,
			    ap->q_put_pcontrol );
	    if ( ca_status != ECA_NORMAL )
	    {
		*((int*)(ap->q_put_pstatus)) =
			qput_form_status( SCA_CANNOT_PUT,ap);
		++num_put_failures;
	    }
	    else
	    {
		ap->q_put_value_state = SCA_FRESH_VALUE;
		*((int*)(ap->q_put_pstatus)) =
			qput_form_status( SCA_NO_ERROR,ap);
	    }
	}
	else
	{
	    ca_status = ca_array_put_callback(
			    ap->dtype % (LAST_TYPE+1),
			    ap->q_put_n,
			    ap->channel_id,
			    ap->q_put_pcontrol,
			    que_put_callback_handler,
			    (void *)put_q[k] );
	    ++ap->missing_put_callbacks;
	    ++missing_put_callbacks;
	    if ( ca_status != ECA_NORMAL )
	    {
		*((int*)(ap->q_put_pstatus)) =
			qput_form_status( SCA_CANNOT_PUT,ap);
	    }
	}
    }

    if ( timeout <= 0.0 )
    {
	
	ca_flush_io();
	return num_put_failures;
    }

    missing_callbacks = 0;
#ifdef VXWORKS
	pend_time = .017;
#else
	pend_time = .0005F;
#endif
    end_time = sca_gettimeofday() + fabs( timeout );
    count = -1;
    for (;;)
    {
	int j;
	int ca_stat;

	ca_stat = ca_pend_event( pend_time );    
	++count;

	missing_callbacks = 0;
	for ( j = 0; j < put_q_nelm; ++j )
	{
	    ap_index = put_q[j] & AP_INDEX_MASK;
	    ap = ap_table[ap_index];
	    if ( ap->put_callback_code_h != ap->put_callback_code )
		++missing_callbacks;
	}
	if ( missing_callbacks == 0)
	    break;
	
	if ( ( now = sca_gettimeofday() ) > end_time )
	    break;
    }
/*
if ( count > 0 ) printf("do_put: wait_for_callbacks   %d times\n", count+1 );
*/
    return missing_callbacks;
}

/* 
callback funcution for ca_array_put_callback
*/ 

void
que_put_callback_handler( arg )
struct event_handler_args arg;
{
    chid channel_id = arg.chid;
    chtype dbrType = arg.type;
    long count = arg.count;
    CALLBACK_CODE user_arg = ( CALLBACK_CODE )arg.usr;

    AP_INDEX ap_index = user_arg & AP_INDEX_MASK;
    ACCELERATION_CONTROL_BLOCK  *ap = ap_table[ap_index];
    ap->put_callback_ca_status = arg.status;
    ++num_put_callbacks;

/*
print_event_args( arg, "que_put_callback_handler" );
printf( "ap = 0x%x\n", ap );
print_ap_table();
print_q("put_q", put_q, put_q_nelm );
print_aps();
*/

    ap->put_callback_code_h =  user_arg & CALLBACK_CODE_MASK;
    if ( ap->put_callback_code_h !=  ap->put_callback_code )
    {
	++ap->ignored_put_callbacks;
	++ignored_put_callbacks;
	return;
    }

    if ( arg.status != ECA_NORMAL )
    {
	if ( arg.status == ECA_DISCONN )
	{
	    ap->connection_state = SCA_DISCONNECTED;
	    *((int*)(ap->q_put_pstatus)) =
		 qput_form_status( SCA_CANNOT_PUT , ap );
	    return;
	}

	if ( arg.status == ECA_CONN )
	{
	    ap->connection_state = SCA_CONNECTED;
	}
    }

    --ap->missing_put_callbacks;
    --missing_put_callbacks;
    ap->q_put_value_state = SCA_FRESH_VALUE;
    *((int*)(ap->q_put_pstatus)) = qput_form_status( SCA_NO_ERROR, ap );
    return;
}

/* END put */

int
add_to_ap_table( ap )
ACCELERATION_CONTROL_BLOCK *ap;
{
    int new_len;
    ACCELERATION_CONTROL_BLOCK **new_table;
    int i;

    if ( ap_table_nelm == ap_table_len )	/* protect against overflow */
    {
	new_len = ap_table_len + AP_TABLE_INC;
	new_table = ( ACCELERATION_CONTROL_BLOCK **)malloc(
			new_len * sizeof( ACCELERATION_CONTROL_BLOCK *) );
	if ( new_table == ( ACCELERATION_CONTROL_BLOCK ** )NULL )
	    return form_status( SCA_CANNOT_MALLOC, ap );
	for ( i = 0; i < ap_table_nelm; ++i )
	    new_table[i] = ap_table[i];
	free( ap_table );
	ap_table = new_table;
	ap_table_len = new_len;
    }
    ap_table[ap_table_nelm] = ap;
    ap->acb_index = ap_table_nelm;
    ++ap_table_nelm;
    return form_status( SCA_NO_ERROR, ap );
}

int
add_to_get_q( ap, n, pdest, pstatus )
ACCELERATION_CONTROL_BLOCK *ap;
int n;
void *pdest;
int *pstatus;
{
    int new_len;
    Q_ITEM *new_q;
    int i;
    if ( get_q_nelm == get_q_len )	/* protect against overflow */
    {
	new_len = get_q_len + GET_Q_INC;
	new_q = ( Q_ITEM *)malloc( new_len * sizeof( Q_ITEM ) );
	if ( new_q == ( Q_ITEM *)NULL )
	    return qget_form_status( SCA_CANNOT_MALLOC, ap );
	get_q_len = new_len;
	for ( i = 0; i < get_q_nelm; ++i )
	    new_q[i] = get_q[i];
	free( get_q );
	get_q = new_q;
	get_q_len = new_len;
    }
    get_q[get_q_nelm] = ap->acb_index;
    ap->q_get_pdest = pdest;
    ap->q_get_pstatus = pstatus;
    ap->q_get_n = n;
    if ( ap->q_get_n > ap->nmax )
	ap->q_get_n = ap->nmax;

    ++get_q_nelm;
    return qget_form_status( SCA_NO_ERROR, ap );
}

int
add_to_put_q( ap, n, psrc, pstatus )
ACCELERATION_CONTROL_BLOCK *ap;
int n;
void *psrc;
int *pstatus;
{
    int new_len;
    Q_ITEM *new_q;
    int i;
    if ( put_q_nelm == put_q_len )	/* protect against overflow */
    {
	new_len = put_q_len + GET_Q_INC;
	new_q = ( Q_ITEM *)malloc( new_len * sizeof( Q_ITEM ) );
	if ( new_q == ( Q_ITEM *)NULL )
	    return qput_form_status( SCA_CANNOT_MALLOC, ap );
	put_q_len = new_len;
	for ( i = 0; i < put_q_nelm; ++i )
	    new_q[i] = put_q[i];
	free( put_q );
	put_q = new_q;
	put_q_len = new_len;
    }
    put_q[put_q_nelm] = ap->acb_index;
    ap->q_put_psrc = psrc;
    ap->q_put_pstatus = pstatus;
    ap->q_put_n = n;
    if ( ap->q_put_n > ap->nmax )
	ap->q_put_n = ap->nmax;

    ++put_q_nelm;
    return qput_form_status( SCA_NO_ERROR, ap );
}

/*
** --------------------------------------------------------------------
** SCA - METHOD 2 - Data caching with monitors.   !!!!!
** --------------------------------------------------------------------
*/

scaEntry
int scaCall
cache_set( 
char *name,                             /* field name */
int scatype,                            /* data type, e.g. SCA_STRING */
int nmax,                               /* max number of data elements */
void **pap )				/* returns to pointer ACB */
{
    int stat;
    ACCELERATION_CONTROL_BLOCK *ap;

    stat = sca_buildap( name, scatype, nmax, ( void **)(&ap) );
    if ( sca_error( stat ) )
	return stat;

    *pap = ( void *)ap;
    if ( !sca_monitor_active( ap->monitor_state ) )
    {
	int stat = cache_goto_active( ap );
	if ( sca_error( stat ) )
	    *pap = ( void *)NULL;
	return stat;
    }
    else
	return form_status( SCA_NO_ERROR, ap );
}

scaEntry
int scaCall
set_noflush_after_cache_put( void *ap )
{
    ((ACCELERATION_CONTROL_BLOCK *)ap)->options |= SCA_SKIP_FLUSH;
    return ( form_status( SCA_NO_ERROR, ((ACCELERATION_CONTROL_BLOCK *)ap) ) );
}

scaEntry
int scaCall
clear_noflush_after_cache_put( void *ap )
{
    ((ACCELERATION_CONTROL_BLOCK *)ap)->options &= ~SCA_SKIP_FLUSH;
    return ( form_status( SCA_NO_ERROR, ((ACCELERATION_CONTROL_BLOCK *)ap) ) );
}

scaEntry
int scaCall
cache_get( 
void *vap,				/* acceleration block pointer */
void *dest_ptr,                         /* Pointer to array to receive data */
int n )                                 /* number of data elements */
{
    int stat;
    int i;
    ACCELERATION_CONTROL_BLOCK *ap = ( ACCELERATION_CONTROL_BLOCK *)vap;


    if ( ap == ( ACCELERATION_CONTROL_BLOCK * )NULL )
    {
	return SCA_NO_ACB;
    }

    if ( sca_invalid_acb( ap ) )
    {
	return SCA_BAD_ACB;
    }

    if ( sca_monitor_corrupted( ap->monitor_state ) )
	return form_status( SCA_INTERNAL_ERROR, ap );

    ++ap->num_gets;
    ++ap->num_get_errors;
    ap->buff = dest_ptr;
    ap->n = n;
    if ( n > ap->nmax )
	ap->n = ap->nmax;
    ap->ofs = 0;
    ap->last_get_time = sca_gettimeofday();

    if ( sca_monitor_on_standby( ap->monitor_state ) )
    {
	stat = cache_goto_active( ap );			/* try hard? */
	if ( sca_error( stat ) )
	    return stat;
    }

    if ( ap->num_gets == 1 )
    {
	stat = cache_try_hard_for_value( ap );
	if ( !sca_connected( stat ) )
	    return form_status( SCA_CANNOT_GET, ap );
    }

    if ( cache_smart_pend() == SCA_CANNOT_PEND )
	return form_status( SCA_CANNOT_PEND, ap );

	LOCK_MONITOR_CACHE;

    switch ( ap->scatype )
    {
	case SCA_STRING:
	{
	    ap->alarm_severity = (ap->pmonitor)->tstrval.severity;
	    ap->alarm_status = (ap->pmonitor)->tstrval.status;
	    bcopy( (char*)((ap->pmonitor)->tstrval.value), (char*)dest_ptr,
	    	MAX_STRING_SIZE * ap->n );
	    break;
	}
	case SCA_SHORT:
	    ap->alarm_severity = (ap->pmonitor)->tshrtval.severity;
	    ap->alarm_status = (ap->pmonitor)->tshrtval.status;
	    bcopy( (char *)&((ap->pmonitor)->tshrtval.value),
		    ( char *)dest_ptr, sizeof( short ) * ap->n );
	    break;
	case SCA_FLOAT:
	    ap->alarm_severity = (ap->pmonitor)->tfltval.severity;
	    ap->alarm_status = (ap->pmonitor)->tfltval.status;
	    bcopy( (char *)&((ap->pmonitor)->tfltval.value),
		( char *)dest_ptr, sizeof( float ) * ap->n );
	    break;
	case SCA_ENUM:
	    ap->alarm_severity = (ap->pmonitor)->tenmval.severity;
	    ap->alarm_status = (ap->pmonitor)->tenmval.status;
	    bcopy( (char *)&((ap->pmonitor)->tenmval.value),
		( char *)dest_ptr, sizeof( unsigned short ) * ap->n );
	    break;
	case SCA_CHAR:
	    ap->alarm_severity = (ap->pmonitor)->tchrval.severity;
	    ap->alarm_status = (ap->pmonitor)->tchrval.status;
	    bcopy( ( char *)&((ap->pmonitor)->tchrval.value),
		(  char *)dest_ptr, sizeof( char ) * ap->n );
	    break;
	case SCA_LONG:
	    ap->alarm_severity = (ap->pmonitor)->tlngval.severity;
	    ap->alarm_status = (ap->pmonitor)->tlngval.status;
	    bcopy( (char *)&((ap->pmonitor)->tlngval.value),
		( char *)dest_ptr, sizeof( long ) * ap->n );
	    break;
	case SCA_DOUBLE:
	{
	    ap->alarm_severity = (ap->pmonitor)->tdblval.severity;
	    ap->alarm_status = (ap->pmonitor)->tdblval.status;
	    bcopy( (char *)&((ap->pmonitor)->tdblval.value),
		( char *)dest_ptr, sizeof( double ) * ap->n );
	}
	    break;
	case SCA_INT:
	    ap->alarm_severity = (ap->pmonitor)->tlngval.severity;
	    ap->alarm_status = (ap->pmonitor)->tlngval.status;
	    bcopy( (char *)&((ap->pmonitor)->tlngval.value),
		( char *)dest_ptr, sizeof( long ) * ap->n );
	    break;
	default:
	    ap->alarm_severity = INVALID_ALARM;
	    ap->alarm_status = UDF_ALARM;
	    ap->value_state = SCA_NO_VALUE;
	    ap->monitor_state = SCA_MONITOR_CORRUPTED;
	    ca_clear_event( ap->event_id );
	    ++ap->num_monitor_problems;
	    ++ap->num_monitor_changes;
	    UNLOCK_MONITOR_CACHE;
		return form_status( SCA_INTERNAL_ERROR, ap );
    }

    ap->num_monitor_values = ap->monitor_values;
    ap->num_fresh_on_fresh = ap->fresh_on_fresh;
    ap->num_fresh_on_stale = ap->fresh_on_stale;
    ap->num_fresh_on_no_value = ap->fresh_on_no_value;

    ap->monitor_values = 0;
    ap->fresh_on_fresh = 0;
    ap->fresh_on_stale = 0;
    ap->fresh_on_no_value = 0;

    --ap->num_get_errors;
    stat = form_status( SCA_NO_ERROR, ap );
    if ( ap->value_state == SCA_FRESH_VALUE )
	ap->value_state = SCA_OLD_VALUE;\

	UNLOCK_MONITOR_CACHE;

    return stat;
}

scaEntry int scaCall
cache_getbyname(
char *name,         			/* fieldname */
int scatype,                            /* data type, e.g. SCA_STRING */
void *dest_ptr,                         /* Pointer to array to receive data */
int n)                                  /* number of data elements */
{
    ACCELERATION_CONTROL_BLOCK *ap;
    chtype dtype;
    char sca_name[SCA_NAME_STRING_SIZE];
    int stat;

    stat = scatodbr( scatype, &dtype );
    if ( sca_error( stat ) )
	return stat;

    stat = sca_name_gen( name, scatype, sca_name );
    if ( sca_error( stat ) )
	return stat;

    ap = find_ap( sca_name );   
    if ( ap != ( ACCELERATION_CONTROL_BLOCK * )NULL )
	return cache_get( ( void*)ap, dest_ptr, n );

    stat = cache_set( name, scatype, n, (void **)(&ap) );
    if ( sca_error( stat ) )
	return stat;
    else
	return cache_get( ( void*)ap, dest_ptr, n );
}

scaEntry
int scaCall
cache_put( 
void *vap,				/* acceleration block pointer */
void *src_ptr,                          /* Pointer to array with data */
int n)                                  /* number of data elements */
{

    int i;
    int ca_stat;
    int retval = SCA_NO_ERROR;
    ACCELERATION_CONTROL_BLOCK *ap = ( ACCELERATION_CONTROL_BLOCK *)vap;

    if ( ap == ( ACCELERATION_CONTROL_BLOCK * )NULL )
	return SCA_NO_ACB;

    if ( sca_invalid_acb( ap ) )
	return SCA_BAD_ACB;

    ++ap->num_puts;
    ++ap->num_put_errors;
    ap->buff = src_ptr;
    ap->n = n;
    ap->ofs = 0;
    ap->last_put_time = sca_gettimeofday();

    if ( n < 1 ) n = 1;

    if ( ap->pcontrol == ( void * )NULL )
	ap->pcontrol = ( void * )calloc( dbr_size_n(ap->dtype, ap->nmax), 1 );

    if ( ap->pcontrol == ( void * )NULL )
	return SCA_CANNOT_MALLOC;

    if ( ap->num_puts == 1 )
    {
	int stat = cache_try_hard_for_connection( ap );
	if ( sca_not_connected( stat ) )
	    if ( sca_cannot_pend( stat ) )
		return form_status( SCA_CANNOT_PEND, ap );
	    else
		return form_status( SCA_CANNOT_PUT, ap );
    }
    switch ( ap->scatype )
    {
	case SCA_STRING: 
	{
	    int j = 0;
	    for ( i = 0; i < n; ++i )
	    {
		strncpy( (char *)ap->pcontrol + j,
		    (char *)src_ptr + j,
		    MAX_STRING_SIZE-1 );
		*( ( char *)ap->pcontrol + j + MAX_STRING_SIZE-1 ) = '\0';
		j += MAX_STRING_SIZE;
	    }
	    break;
	}
	case SCA_SHORT:
	    bcopy( ( char *)&(( short *)src_ptr )[0],
		   ( char *)&(( short *)ap->pcontrol)[0],
		   n * sizeof( short ) );
	    break;

	case SCA_FLOAT:
	    bcopy( ( char *)&(( float *)src_ptr )[0],
		   ( char *)&(( float *)ap->pcontrol)[0],
		   n * sizeof( float ) );
	    break;

	case SCA_ENUM:
	    bcopy( ( char *)&(( unsigned short *)src_ptr )[0],
		   ( char *)&(( unsigned short *)ap->pcontrol)[0],
		   n * sizeof( unsigned short ) );
	    break;

	case SCA_CHAR:
	    bcopy( ( char *)&(( unsigned char *)src_ptr )[0],
		   ( char *)&(( unsigned char *)ap->pcontrol)[0],
		   n * sizeof( unsigned char ) );
	    break;

	case SCA_LONG:
	    bcopy( ( char *)&(( long *)src_ptr )[0],
		   ( char *)&(( long *)ap->pcontrol)[0],
		   n * sizeof( long ) );
	    break;

	case SCA_DOUBLE:
	    bcopy( ( char *)&(( double *)src_ptr )[0],
		   ( char *)&(( double *)ap->pcontrol)[0],
		   n * sizeof( double ) );
	    break;

	case SCA_INT:
	    bcopy( ( char *)&(( int *)src_ptr )[0],
		   ( char *)&(( int *)ap->pcontrol)[0],
		   n * sizeof( int ) );
	    break;

	default:
	   retval = form_status( SCA_BAD_DATA_TYPE, ap );
    }

	
    ca_stat = ca_array_put(ap->dtype % (LAST_TYPE+1),
						n, ap->channel_id, src_ptr );
    if ( ca_stat != ECA_NORMAL )
	return form_status( SCA_CANNOT_PUT, ap );

    if ( ap->options & SCA_SKIP_FLUSH )
    {
	--ap->num_put_errors;
	return form_status( SCA_NO_ERROR, ap );
    }
    else
    {
	ca_stat = ca_pend_io( SCA_PUT_PEND_TIMEOUT );
	if ( ca_stat == ECA_NORMAL )
	{
	    ca_stat = ca_pend_event( SCA_QUICK_PEND );
	    if ( ca_stat == ECA_TIMEOUT || ca_stat == ECA_NORMAL )
	    {
		--ap->num_put_errors;
		return form_status( SCA_NO_ERROR, ap );
	    }
	    else
		return form_status( SCA_CANNOT_PEND, ap );
	}
	else
	    return form_status( SCA_CANNOT_PEND, ap );
    }
}

scaEntry
int scaCall
cache_putbyname( name, scatype, src_ptr, n )
char *name;         			/* pv name */
int scatype;                            /* data type, e.g. SCA_STRING */
void *src_ptr;                          /* Pointer to array with data */
int n;                                  /* number of data elements */
{
    void *ap;   
    chtype dtype;
    char sca_name[SCA_NAME_STRING_SIZE];
    int stat;

    stat = scatodbr( scatype, &dtype );
    if ( sca_error( stat ) )
	return stat;

    stat = sca_name_gen( name, scatype, sca_name );
    if ( sca_error( stat ) )
	return stat;

    ap = ( void *)find_ap( sca_name );   
    if ( ap != ( ACCELERATION_CONTROL_BLOCK * )NULL )
	return cache_put( ap, src_ptr, n );

    stat = cache_set( name, scatype, n, &ap );
    if ( sca_no_error( stat ) )
	return cache_put( ap, src_ptr, n );
    else
	return stat;
}

/* put monitor on active/standby */

int
cache_goto_active( ap )
ACCELERATION_CONTROL_BLOCK *ap;         /* acceleration block pointer */
{
    void cacheEventHandler();
    int ca_stat;

    if ( !sca_monitor_active( ap->monitor_state ) )
    {
	ca_stat = ca_add_array_event(
	    ap->dtype,			/* TYPE */
	    ap->nmax,			/* COUNT */
	    ap->channel_id,			/* CHID */
	    cacheEventHandler,		/* USERFUNC */
	    ap,				/* USERARG */
	    (float)0,
	    (float)0,
	    (float)0,
	    &ap->event_id );		/* PEVID */
	if ( ca_stat != ECA_NORMAL )
	{
	    ap->monitor_state = SCA_MONITOR_CORRUPTED;
	    return form_status( SCA_INTERNAL_ERROR, ap );
	}
	ap->monitor_state = SCA_MONITOR_ACTIVE;
	++ap->num_monitor_changes;
    }
    return form_status( SCA_NO_ERROR, ap );
}


int
cache_goto_standby( 
ACCELERATION_CONTROL_BLOCK  *ap)
{

    if ( !sca_monitor_on_standby( ap->monitor_state ) )
    {
	ap->value_state = SCA_NO_VALUE;
	if ( ca_clear_event( ap->event_id ) != ECA_NORMAL )
	{
	    ap->monitor_state = SCA_MONITOR_CORRUPTED;
	    ++ap->num_monitor_problems;
	    ++ap->num_monitor_changes;
	    return form_status( SCA_INTERNAL_ERROR, ap );
	}

	ap->monitor_state = SCA_MONITOR_ON_STANDBY;
	++ap->num_monitor_changes;
    }
    return form_status( SCA_NO_ERROR, ap );
}


int
cache_smart_pend()
{
    double current_time = sca_gettimeofday();
    if ( current_time >= ( sca_time_of_pend + min_smart_pend_interval ) )
	return cache_pend( current_time );
    return SCA_NO_ERROR;
}

int
cache_pend( current_time )
double current_time;
{
    int ca_stat;
    sca_time_of_pend = current_time;	/* bring i/o up-to-date */
    ++num_pends;

    ca_stat = ca_pend_event( SCA_QUICK_PEND );
    if ( ca_stat == ECA_TIMEOUT || ca_stat == ECA_NORMAL )
	return SCA_NO_ERROR;
    else
	return SCA_CANNOT_PEND;
}

scaEntry 
int scaCall
cache_pend_for( current_time, pend_time )
double current_time;
double pend_time;
{
    int ca_stat;
    sca_time_of_pend = current_time;	/* bring i/o up-to-date */
    ++num_pends;

    ca_stat = ca_pend_event( (float)pend_time );
    if ( ca_stat == ECA_TIMEOUT || ca_stat == ECA_NORMAL )
	return SCA_NO_ERROR;
    else
	return SCA_CANNOT_PEND;
}

int
sca_pend_event( pend_time )
double pend_time;
{
    int ca_stat;
    sca_time_of_pend = sca_gettimeofday();	/* bring i/o up-to-date */
    ++num_pends;

    ca_stat = ca_pend_event( ( float)pend_time );
    if ( ca_stat == ECA_TIMEOUT || ca_stat == ECA_NORMAL )
	return SCA_NO_ERROR;
    else
	return SCA_CANNOT_PEND;
}

int
sca_sleep( delay_in_msec, max_delay_in_msec )
int delay_in_msec;	/* requested delay */
int max_delay_in_msec;	/* maximum delay allowed */
{
    int retval;
    if ( delay_in_msec <= 0 )
    {
	retval = sca_pend_event( ( double )SCA_QUICK_PEND );
	if ( retval == SCA_NO_ERROR )
	    retval =  SCA_BAD_ARG;
	return retval;
    }

    else if ( max_delay_in_msec <= 0 )
    {
	retval = sca_pend_event( ( double )SCA_QUICK_PEND );
	if ( retval == SCA_NO_ERROR )
	    retval =  SCA_BAD_ARG;
	return retval;
    }

    if ( delay_in_msec > max_delay_in_msec )
	delay_in_msec = max_delay_in_msec;

    return sca_pend_event( ( double )delay_in_msec * .001 );
}

int
cache_try_hard_for_value( ap )
ACCELERATION_CONTROL_BLOCK *ap;
{
    double dt = ap->last_get_time - try_hard_failure_time;
    int ca_stat;

    if ( dt > SCA_MIN_TIME_BETWEEN_TRY_HARDS &&
	 ( ap->connection_state != SCA_CONNECTED ||
	   ap->monitor_values <= 0 ) )
    {
	double start_time = sca_gettimeofday();
	ap->try_hard_timer = (double)0.0;

	while( ap->monitor_values <= 0 &&
		    ap->try_hard_timer < SCA_TRY_HARD_MAXTIME )
	{
	    ca_stat = ca_pend_event( SCA_TRY_HARD_PEND_TIME );
	    ap->try_hard_timer = sca_gettimeofday() - start_time;
	    if ( ap->monitor_values > 0 )
		break;
	}
	if ( ap->monitor_values <= 0 )
	{
	    try_hard_failure_time = sca_gettimeofday();
	    return SCA_NEVER_CONNECTED;
	}
    }

    if ( sca_connected( ap->connection_state ) )
        return SCA_CONNECTED;
    else if ( ap->monitor_values == 0 )
	return SCA_NEVER_CONNECTED;
    else
	return SCA_DISCONNECTED;
}

int
cache_try_hard_for_connection( ap )
ACCELERATION_CONTROL_BLOCK *ap;
{
    double dt = ap->last_put_time - try_hard_failure_time;
    int ca_stat;

    if ( /* dt > SCA_MIN_TIME_BETWEEN_TRY_HARDS && */
	 ap->connection_state != SCA_CONNECTED )
    {

	double start_time = sca_gettimeofday();
	ap->try_hard_timer = (double)0.0;

	while( ap->try_hard_timer < SCA_TRY_HARD_MAXTIME )
	{
	    ca_stat = ca_pend_event( SCA_TRY_HARD_PEND_TIME );
	    ap->try_hard_timer = sca_gettimeofday() - start_time;
	    if ( sca_connected( ap->connection_state ) )
		break;
	}
	if ( sca_not_connected( ap->connection_state ) )
	{
	    try_hard_failure_time = sca_gettimeofday();
	    return SCA_NEVER_CONNECTED;
	}
    }
    return ap->connection_state;
}
void
cacheEventHandler(arg)
struct event_handler_args arg;
{
    ACCELERATION_CONTROL_BLOCK  *ap;
    chid channel_id = arg.chid;
    chtype dbrType = arg.type;
    union db_access_val *pBuf;
    int nelm, ncopy;

    ap = ( ACCELERATION_CONTROL_BLOCK * )ca_puser( channel_id );
    pBuf = ( union db_access_val * )arg.dbr;
#if (EPICS_REVISION > 12)
    nelm = channel_id->privCount;
#else
    nelm = channel_id->count;
#endif
    if ( nelm > ap->nmax )
	nelm = ap->nmax;
    ncopy = dbr_size_n( dbrType, nelm );
    if ( sca_connected( ap->connection_state )
	&& sca_monitor_active( ap->monitor_state ) )
    {
        TS_STAMP ts;
        tsLocalTime( &ts );

	LOCK_MONITOR_CACHE;
	if ( dbr_type_is_STRING( dbrType ) )  
	    bcopy( (char *)pBuf, (char *)ap->pmonitor, ncopy );

	else if ( dbr_type_is_SHORT( dbrType ) )
	{
            if ( event_buf && ( ( ap->options & SCA_NO_EVENT_LOGGING ) == 0 ) &&
		( ap->name_id > 0  ) )
            {
                if ( pBuf->tshrtval.value != (ap->pmonitor)->tshrtval.value )
                {
		    int ec = *event_counter;
                    if ( ec < *event_buf_size )
                    {
                        event_buf[ec].ts.secPastEpoch = ts.secPastEpoch;
                        event_buf[ec].ts.nsec = ts.nsec;
                        event_buf[ec].ap = ap;
                        event_buf[ec].old.sht = (ap->pmonitor)->tshrtval.value;
                        event_buf[ec].new.sht = pBuf->tshrtval.value;
                    }
                    ++*event_counter;
                }
            }
	    bcopy( (char *)pBuf, (char *)ap->pmonitor, ncopy );
	}

	else if ( dbr_type_is_FLOAT( dbrType ) )
	{
            if ( event_buf && ( ( ap->options & SCA_NO_EVENT_LOGGING ) == 0 ) &&
		( ap->name_id > 0  ) )
            {
                if ( pBuf->tfltval.value != (ap->pmonitor)->tfltval.value )
                {
		    int ec = *event_counter;
                    if ( ec < *event_buf_size )
                    {
                        event_buf[ec].ts.secPastEpoch = ts.secPastEpoch;
                        event_buf[ec].ts.nsec = ts.nsec;
                        event_buf[ec].ap = ap;
                        event_buf[ec].old.flt = (ap->pmonitor)->tfltval.value;
                        event_buf[ec].new.flt = pBuf->tfltval.value;
                    }
                    ++*event_counter;
                }
            }
	    bcopy( (char *)pBuf, (char *)ap->pmonitor, ncopy );
	}

	else if ( dbr_type_is_ENUM( dbrType ) )
	{
            if ( event_buf && ( ( ap->options & SCA_NO_EVENT_LOGGING ) == 0 ) &&
		( ap->name_id > 0  ) )
            {
                if ( pBuf->tshrtval.value != (ap->pmonitor)->tshrtval.value )
                {
		    int ec = *event_counter;
                    if ( ec < *event_buf_size )
                    {
                        event_buf[ec].ts.secPastEpoch = ts.secPastEpoch;
                        event_buf[ec].ts.nsec = ts.nsec;
                        event_buf[ec].ap = ap;
                        event_buf[ec].old.sht = (ap->pmonitor)->tshrtval.value;
                        event_buf[ec].new.sht = pBuf->tshrtval.value;
                    }
                    ++*event_counter;
                }
            }
	    bcopy( (char *)pBuf, (char *)ap->pmonitor, ncopy );
	}

	else if ( dbr_type_is_CHAR( dbrType ) )
	    bcopy( (char *)pBuf, (char *)ap->pmonitor, ncopy );

	else if ( dbr_type_is_LONG( dbrType ) )
	    bcopy( (char *)pBuf, (char *)ap->pmonitor, ncopy );

	else if ( dbr_type_is_DOUBLE( dbrType ) )
	    bcopy( (char *)pBuf, (char *)ap->pmonitor, ncopy );

	else
	{
	    ap->monitor_state = SCA_MONITOR_CORRUPTED;
	    ap->value_state = SCA_NO_VALUE;
	    ++ap->num_monitor_problems;

	    UNLOCK_MONITOR_CACHE;
	    return;
	}

	UNLOCK_MONITOR_CACHE;
	ap->last_monitor_time=(double)ts.secPastEpoch + (double)ts.nsec / n2s;
	if (ap->last_monitor_time > (ap->last_get_time + SCA_MONITOR_LIFETIME) )
	{
	    cache_goto_standby( ap );
	}
	else
	{
	    ++ap->monitor_values;
	    if ( ap->value_state == SCA_FRESH_VALUE )
		++ap->fresh_on_fresh;
	    else if ( ap->value_state == SCA_OLD_VALUE )
		++ap->fresh_on_stale;
	    else
		++ap->fresh_on_no_value;

	    ap->value_state = SCA_FRESH_VALUE;
	}
    }
}

/*
** --------------------------------------------------------------------
** BACKWARD COMPATIBLE CALLS FOR SCA I
** --------------------------------------------------------------------
*/

/*
** Uses SCA III calls.  Ignores ap and af args.
** Translates return status from do_getbyname() into 
**       -status if there was an error
**        0 if there is no callback and so no value
**        n if there is a value
*/
scaEntry
int scaCall
SCAget( name, ap, af, type, n, dest_ptr )
char *name;			/*field name */
void *ap;			/* ignored   */
int af;				/* ignored   */
int type;                       /* data sca type, e.g. SCA_DOUBLE */
int n;				/* number of data elements */
void *dest_ptr;                 /* Pointer to array to receive data */
{
    int status, status1;
    status = do_getbyname( name, type, n, dest_ptr, &status1 );

    if ( sca_error( status1 ) )
	return -status1;

    else if ( status == 0 )
	return n;
    else 
	return 0;
}
/*
** Uses SCA III calls.  Ignores ap and af args.
** Translates return status from do_putbyname() into 
**       -status if there was an error
**        0 if there is no callback and so no value not put(for sure)
**        n if value was put
*/
scaEntry
int scaCall
SCAput(
	char *name,			/*field name */
	void *ap,			/* ignored   */
	int af,				/* ignored   */
	int scatype,        /* data sca type, e.g. SCA_DOUBLE */
	int n,				/* number of data elements */
	void *psrc         /* Pointer to values to put */
)
{
    int status, status1;
    status = que_put( name, scatype, n, psrc, &status1 );
    if ( sca_error( status1 ) )
    	return -status1;

		/* dont use callbacks */
    status = do_put( -5.00 );

	return n;
}

scaEntry void * scaCall 
SCAap()
{
	return (void * )NULL;
}

scaEntry void scaCall 
SCAFree(void *ap)
{
	return;
}


/*
** --------------------------------------------------------------------
** BACKWARD COMPATIBLE CALLS FOR SCA II
** --------------------------------------------------------------------
*/

scaEntry
int scaCall
sca_getap( name, scatype, nmax, pap )
char *name;                             /* field name */
int scatype;                            /* data type, e.g. SCA_STRING */
int nmax;                               /* max number of data elements */
void **pap;				/* returns ACB pointer */
{
    return cache_set( name, scatype, nmax, pap );
}

scaEntry
int scaCall
sca_get( ap, dest_ptr, n )
void *ap;				/* acceleration block pointer */
void *dest_ptr;                         /* Pointer to array to receive data */
int n;                                  /* number of data elements */
{
    return cache_get( ap, dest_ptr, n );
}

scaEntry
int scaCall
sca_getbyname( name, scatype, dest_ptr, n )
char *name;         			/* fieldname */
int scatype;                            /* data type, e.g. SCA_STRING */
void *dest_ptr;                         /* Pointer to array to receive data */
int n;                                  /* number of data elements */
{
    return cache_getbyname( name, scatype, dest_ptr, n );
}

scaEntry
int scaCall
sca_put( ap,  src_ptr, n )
void *ap;				/* acceleration block pointer */
void *src_ptr;                          /* Pointer to array with data */
int n;                                  /* number of data elements */
{
    return cache_put( ap,  src_ptr, n );
}

scaEntry
int scaCall
sca_putbyname( name, scatype, src_ptr, n )
char *name;         			/* pv name */
int scatype;                            /* data type, e.g. SCA_STRING */
void *src_ptr;                          /* Pointer to array with data */
int n;                                  /* number of data elements */
{
    return cache_putbyname( name, scatype, src_ptr, n );
}

/*
** --------------------------------------------------------------------
** SCA - COMMON ROUTINES
** --------------------------------------------------------------------
*/


scaEntry
int scaCall
sca_buildap( name, scatype, nmax, pap )
char *name;                             /* field name */
int scatype;                            /* data type, e.g. SCA_STRING */
int nmax;                               /* max number of data elements */
void **pap;
{
    int ca_stat;
    int stat;
    ACCELERATION_CONTROL_BLOCK *ap;
    chtype dtype;
    char sca_name[SCA_NAME_STRING_SIZE];
    void scaConnHand();

    if ( first_time == 0)
    {
	int num_scatype_names = sizeof( scatype_names )/ SCA_TYPE_SZ;
	int num_sca_extensions = sizeof( sca_extensions ) / SCA_EXTENSION_SZ;

	ca_stat = ca_task_initialize();
	++first_time;

	if ( num_scatype_names != num_scatypes ||
	     num_sca_extensions != num_scatypes )
	    return SCA_INTERNAL_ERROR + SCA_NO_AP;
    }

    *pap = ( void * )NULL;

    stat = scatodbr( scatype, &dtype );
    if ( sca_error( stat ) )
	return stat;

    stat = sca_name_gen( name, scatype, sca_name );
    if ( sca_error( stat ) )
	return stat;

    ap = find_ap( sca_name );
    if ( ap != ( ACCELERATION_CONTROL_BLOCK *)NULL )
    {
	if ( sca_valid_acb( ap ) )
	{
	    *pap = ( void *)ap;
	    return form_status( SCA_NO_ERROR, ap );
	}
	else
	    return SCA_BAD_ACB + SCA_NO_AP;
    }

    ap = findc_ap( sca_name );
    if ( ap == ( ACCELERATION_CONTROL_BLOCK *)NULL )
    {
	return SCA_CANNOT_MALLOC + SCA_NO_AP;
    }

    ap->connection_state = SCA_NO_CONNECTION_STATE;
    ap->monitor_state = SCA_NO_MONITOR_STATE;
    ap->value_state = SCA_NO_VALUE_STATE;
    ap->q_get_value_state = SCA_NO_VALUE_STATE;
    ap->q_put_value_state = SCA_NO_VALUE_STATE;

    /* allocate a buffer for the monitor values */
	ap->pmonitor =
		(union db_access_val *)calloc( dbr_size_n(dtype, nmax),1 );
	if ( ap->pmonitor == (union db_access_val *)NULL )
	{
	    free( ap );
	    return SCA_CANNOT_MALLOC + SCA_NO_AP;
	}
	ap->q_get_pmonitor =
		(union db_access_val *)calloc( dbr_size_n(dtype, nmax),1 );
	if ( ap->q_get_pmonitor == (union db_access_val *)NULL )
	{
	    free( ap->pmonitor );
	    free( ap );
	    return SCA_CANNOT_MALLOC + SCA_NO_AP;
	}
	ap->q_put_pcontrol =
		(union db_access_val *)calloc( dbr_size_n(dtype, nmax),1 );
	if ( ap->q_put_pcontrol == (union db_access_val *)NULL )
	{
	    free( ap->pmonitor );
	    free( ap->q_get_pmonitor );
	    free( ap );
	    return SCA_CANNOT_MALLOC + SCA_NO_AP;
	}

    stat = add_to_ap_table( ap );
    if ( sca_error( stat ) )
    {
	free( ap->pmonitor );
	free( ap->q_get_pmonitor );
	free( ap->q_put_pcontrol );
	free( ap );
	return SCA_CANNOT_MALLOC + SCA_NO_AP;
    }

    ap->validation_code = AP_VALIDATION_CODE;
    ap->real_acb = ( void *)NULL;
    strcpy( ap->name, name );
    strcpy( ap->sca_name, sca_name );
    ap->scatype = scatype;
    ap->dtype = dtype;

    if ( nmax < 1 ) nmax = 1;
    ap->nmax = nmax;

    ap->connection_state = SCA_NEVER_CONNECTED;
    ap->value_state = SCA_NO_VALUE;
    ap->q_get_value_state = SCA_NO_VALUE;

    ap->last_get_time = ap->last_put_time = ap->last_monitor_time =
	sca_gettimeofday();
    ca_stat = ca_search_and_connect(
		ap->name,		/* NAME */
		&ap->channel_id,	/* CHIDPTR */
		scaConnHand,		/* PFUNC */
		ap );			/* PUSER */
    if ( ca_stat != ECA_NORMAL )
	return form_status( SCA_CANNOT_SEARCH, ap );

    *pap = ( void *)ap;
    return stat;
}

scaEntry
int scaCall
sca_buildalias( name, scatype, ap_real, pap )
char *name;                             /* field name */
int scatype;                            /* data type, e.g. SCA_STRING */
void *ap_real;				/* supplies ap of real channel */
void **pap;				/* returns pointer to ALIAS_ACB */
{
    int stat;
    ALIAS_ACB *ap;
    char sca_name[SCA_NAME_STRING_SIZE];
    int j;

    *pap = ( void * )NULL;

    stat = sca_name_gen( name, scatype, sca_name );
    if ( sca_error( stat ) )
	return stat;

    ap = (ALIAS_ACB *) calloc( 1, sizeof( ALIAS_ACB ) );	/* create */

    if ( ap == ( ALIAS_ACB*)NULL )
    {
	printf("out of memory\n");
	exit(1);
    }

    strncpy( ap->sca_name,  sca_name, SCA_NAME_SIZE );
    ap->sca_name[SCA_NAME_SIZE] = '\0';

    j = (int )sca_hash( sca_name, strlen( sca_name ) );

    ap->next_ap = acb_hashtbl[j];		/* link */
    acb_hashtbl[j] = ( ACCELERATION_CONTROL_BLOCK *)ap;

    stat = add_to_ap_table( ( ACCELERATION_CONTROL_BLOCK *)ap );
    if ( sca_error( stat ) )
    {
	free( ap );
	return SCA_CANNOT_MALLOC + SCA_NO_AP;
    }

    ap->validation_code = AP_VALIDATION_CODE;
    ap->real_acb = ap_real;
    strcpy( ap->name, name );
    strcpy( ap->sca_name, sca_name );

    *pap = ( void *)ap;
    return stat;
}

void
scaConnHand(arg)
struct connection_handler_args arg;
{
    ACCELERATION_CONTROL_BLOCK  *ap;
    chid channel_id;
    channel_id = arg.chid;

    ap = ( ACCELERATION_CONTROL_BLOCK * )ca_puser( channel_id );
    if ( arg.op == CA_OP_CONN_UP )
    {
	ap->connection_state = SCA_CONNECTED;
    }
    else if ( arg.op == CA_OP_CONN_DOWN )
    {
	ap->connection_state = SCA_DISCONNECTED;
	ap->value_state = SCA_OLD_VALUE;
    }

    ap->last_conn_state_time = sca_gettimeofday();
    ++ap->num_conn_changes;

}


int
scatodbr( scatype, dtype )
int scatype;
chtype *dtype;
{
    /* Check that type is a valid SCA_xxxx type and convert to DBR_xxxx type */

    switch ( scatype )
    {
	case SCA_STRING:
	    *dtype = DBR_TIME_STRING;
	    break;
	case SCA_SHORT:
	    *dtype = DBR_TIME_SHORT;
	    break;
	case SCA_FLOAT:
	    *dtype = DBR_TIME_FLOAT;
	    break;
	case SCA_ENUM:
	    *dtype = DBR_TIME_ENUM;
	    break;
	case SCA_CHAR:
	    *dtype = DBR_TIME_CHAR;
	    break;
	case SCA_LONG:
	    *dtype = DBR_TIME_LONG;
	    break;
	case SCA_DOUBLE:
	    *dtype = DBR_TIME_DOUBLE;
	    break;
	case SCA_INT:
	    *dtype = DBR_TIME_LONG;
	    break;
	default:
	   return SCA_BAD_DATA_TYPE + SCA_NO_AP;
    }

    return SCA_NO_ERROR + SCA_NO_AP;
}

int
sca_name_gen( name, scatype, sca_name )
char *name;
int scatype;
char *sca_name;
{
    /* Check that type is a valid SCA_xxxx type.  Form sca_name which is
    ** name.extension
    */

    int len;
    if ( ( len = strlen( name ) ) > SCA_EPICS_NAME_SIZE )
	return SCA_BAD_NAME_SIZE + SCA_NO_AP;

    if ( ( len + SCA_EXTENSION_SZ ) > SCA_NAME_SIZE )
	return SCA_BAD_NAME_SIZE + SCA_NO_AP;

    strcpy( sca_name, name );

    switch ( scatype )
    {
	case SCA_STRING:
	    strcat( sca_name, ".STR" );
	    break;
	case SCA_SHORT:
	    strcat( sca_name, ".SHT" );
	    break;
	case SCA_FLOAT:
	    strcat( sca_name, ".FLT" );
	    break;
	case SCA_ENUM:
	    strcat( sca_name, ".ENM" );
	    break;
	case SCA_CHAR:
	    strcat( sca_name, ".CHR" );
	    break;
	case SCA_LONG:
	    strcat( sca_name, ".LNG" );
	    break;
	case SCA_DOUBLE:
	    strcat( sca_name, ".DBL" );
	    break;
	case SCA_INT:
	    strcat( sca_name, ".INT" );
	    break;
	default:
	   return SCA_BAD_DATA_TYPE + SCA_NO_AP;
    }
    return SCA_NO_ERROR + SCA_NO_AP;
}

scaEntry int scaCall
sca_getnamebyindex( index, name )
int index;
char *name;
{
    ACCELERATION_CONTROL_BLOCK  *ap;

    if ( index < 0 || index >= ap_table_nelm )
    {
	return SCA_BAD_ARG + SCA_NO_AP;
    }

    ap = ap_table[index];   
    if ( ap == ( ACCELERATION_CONTROL_BLOCK * )NULL )
    {
	return SCA_NO_ACB + SCA_NO_AP;
    }

    strcpy( name, ap->name );
	
    return SCA_NO_ERROR;
}

/*
sca_setup_aliases returns

if no errors in reading file
    number of aliases for which ca connection fails

if errors in reading file
    -1000000 if file cannot be opened.
    negative of line number of first line in file an error

Normal return with all ca connections established within timeout is 0.

File format is

    #define scatype SCA_DOUBLE
    #define nmax 1
    pvname alias [scatype][nmax]

    with fields separated by space[s] and/or tab[s].

    #define scatype	sets the default for scatype.
    #define nmax	sets the default for number of elements

    The defaults may be overridden by specifying scatype and nmax
    on the alias definition line.

    The defaults are initially

	scatype = SCA_FLOAT
	nmax = 1
*/

scaEntry int scaCall
sca_setup_aliases( char *path, double timeout )
{
    int num_aliases = 0;
    FILE *infile;

    int default_scatype = SCA_FLOAT;
    int default_nmax = 1;

#define LINELENGTH	255
    char line[LINELENGTH];
    int line_count = 0;

    if ( timeout < 0.0 )
	timeout = 0.0;
    else if ( timeout <= 5.0 )
	;
    else
	timeout = 1.0;	/* catches NANs as well as > 5.0 */

    /* open alias file */
    if ( ( infile = fopen( path, "r" ) ) == ( FILE *)NULL )
	return -1000000;
    
    while( fgets( line, LINELENGTH, infile ) != ( char *)NULL )
    {
	char *p;
	char *pvname;
	char *alias;
	char *param;
	char *value;

	int scatype;
	int nmax;
	int num_elements;

	int stat;
	int count;
	char sca_name[SCA_NAME_STRING_SIZE];
	ACCELERATION_CONTROL_BLOCK *ap;
	ACCELERATION_CONTROL_BLOCK *ap_real;
	ALIAS_ACB *ap_alias;;

	line[strlen(line)-1] = ( char)NULL;

        ++line_count;
	if ( line[0] == ( char)NULL )
	    continue;

	/* Get first field.  Usually it will be a pvname. */

	if ( ( p = strtok( line, " \t" ) ) == ( char *)NULL )
	    continue;

	/* If this is a default specification line, take care of them */

	if ( strcmp( p, "#define" ) == 0 )
	{
	    if ( ( param = strtok( (char *)NULL, " \t" ) ) == ( char *)NULL )
		return -line_count;

	    if ( ( value = strtok( (char *)NULL, " \t" ) ) == ( char *)NULL )
		return -line_count;

	    if ( strcmp( param, "scatype" ) == 0 )
	    {
		int n = scatype_name2num( value );
		if ( n > 0 )
		    default_scatype = n;
		else
		    return -line_count;
	    }
	    else if ( strcmp( param, "nmax" ) == 0 )
	    {
		int n = atoi( value );
		if ( n > 0 )
		    default_nmax = n;
		else
		    return -line_count;
	    }
	    continue;
	}
	else if ( *p == '#' )
	    continue;

	/* This is an alias definition line. */
	/* pvname is first */

	pvname = p;
	if ( strlen( pvname ) > SCA_EPICS_NAME_SIZE )
	    return -line_count;

	/* alias name is second */
	alias = strtok( (char *)NULL, " \t" );
	{
	    if( alias == ( char *)NULL || *alias == ( char)NULL )
		return -line_count;

	    if ( strlen( alias ) > SCA_EPICS_NAME_SIZE )
		return -line_count;
	}

	scatype = default_scatype;
	nmax = default_nmax;

	/* Check for overrides of the defaults */

	while ( ( value=strtok( (char *)NULL, " \t" ) ) != ( char *)NULL )
	{
	    if ( memcmp( value, "SCA_", 4 ) == 0 )
	    {
		int n = scatype_name2num( value );
		if ( n > 0 )
		    scatype = n;
		else
		    return -line_count;
	    }
	    else if ( *value >= '0' && *value <= '9' )
	    {
		nmax = atoi( value );
		if ( nmax <= 0 )
		    return -line_count;
	    }
	    else
		return -line_count;
	}

	/* If alias exists, done. */
	stat = sca_name_gen( alias, scatype, sca_name );
	if ( sca_error( stat ) )
	    return -line_count;

	if ( ap = find_ap( sca_name ) )
	    continue;

	/* Alias does not exist, build control block for it and pvname. */

	stat = sca_buildap( pvname, scatype, nmax, ( void *)&ap_real );
	stat = sca_buildalias( alias, scatype, ap_real, &ap_alias );
	++num_aliases;
    }

    /*
    **  Flush and wait for real channel connections
    */

    {
	int j;
	double now;
	double end_time = sca_gettimeofday() + timeout;

#ifdef VXWORKS
	float pend_time = .017;
#else
	float pend_time = .0005F;
#endif
	num_not_connected = 0;
	for ( ;; )
	{
	    ca_pend_event( pend_time );    

	    num_not_connected = 0;
	    for ( j = 0; j < ap_table_nelm; ++j )
	    {
		ACCELERATION_CONTROL_BLOCK *ap = ap_table[j];
		if ( ap->real_acb == ( void *)NULL )
		{
		    if ( sca_not_connected( ap->connection_state ) )
			++num_not_connected;
		}
	    }
	    if ( num_not_connected == 0)
		break;

	    if ( ( now = sca_gettimeofday() ) > end_time )
		break;
	}
    }
    return num_not_connected;
}

double
sca_gettimeofday()
{
	TS_STAMP ts;
	tsLocalTime(&ts);
	return (double)ts.secPastEpoch + (double)ts.nsec / n2s;
}
/* hash was here */

/*
** --------------------------------------------------------------------
** SCA - DIAGNOSTIC ROUTINES
** --------------------------------------------------------------------
*/

scaEntry
int scaCall
print_aps()
{
    ACCELERATION_CONTROL_BLOCK *ap;
    if ( ( ap = find_firstap() ) != ( ACCELERATION_CONTROL_BLOCK * )NULL )
	print_ap( ap );
    else
	return 0;

    while( ( ap = find_nextap( ) ) != ( ACCELERATION_CONTROL_BLOCK * )NULL ) 
	print_ap( ap );
    return 0;
}

scaEntry
int scaCall
print_ap( vap )
void *vap;
{
ACCELERATION_CONTROL_BLOCK  *ap = ( ACCELERATION_CONTROL_BLOCK  *)vap;
    if ( sca_invalid_acb( ap ) )
	printf( "Invalid " );
    printf( "ACCELERATION_CONTROL_BLOCK at 0x%x. Next ap is at 0x%x\n",
	    ap, ap->next_ap );
    printf( "\tacb_index             = %d\n", ap->acb_index );
    printf( "\treal_acb              = 0x%x\n", ap->real_acb );
    printf( "\tsca_name              = %s\n", ap->sca_name );
    printf( "\tname                  = %s\n", ap->name );

    if ( ap->real_acb ) return 0;

    printf( "\tscatype               = %s\n", scatype2asc( ap->scatype ) );
    printf( "\tdtype                = 0x%x = %s\n",
				     ap->dtype, dbr_type_to_text( ap->dtype ) );
    printf( "\tnmax                 = %d\n", ap->nmax );
    printf( "\toptions              = %lu\n", ap->options );
    printf( "\talarm_severity       = %d\n", ap->alarm_severity );
    printf( "\talarm_status         = %d\n", ap->alarm_status );
    printf( "\tbuff                 = 0x%x\n", ap->buff );
    printf( "\tn                    = %d\n", ap->n );
    printf( "\tofs                  = %d\n", ap->ofs );
    printf( "\tpmonitor             = 0x%x\n", ap->pmonitor );
    printf( "\tpcontrol             = 0x%x\n", ap->pcontrol );
    printf( "\tmonitor_ca_status    = 0x%x\n", ap->monitor_ca_status );

    printf( "\tnum_gets             = %lu\n", ap->num_gets );
    printf( "\tnum_get_errors       = %lu\n", ap->num_get_errors );
    printf( "\tnum_puts             = %lu\n", ap->num_puts );
    printf( "\tnum_put_errors       = %lu\n", ap->num_put_errors );

    printf( "\tnum_monitor_values   = %lu\n", ap->num_monitor_values );
    printf( "\tnum_fresh_on_fresh   = %lu\n", ap->num_fresh_on_fresh );
    printf( "\tnum_fresh_on_stale   = %lu\n", ap->num_fresh_on_stale );
    printf( "\tnum_fresh_on_no_value= %lu\n", ap->num_fresh_on_no_value );


    printf( "\tmonitor_values       = %lu\n", ap->monitor_values );
    printf( "\tfresh_on_fresh       = %lu\n", ap->fresh_on_fresh );
    printf( "\tfresh_on_stale       = %lu\n", ap->fresh_on_stale );
    printf( "\tfresh_on_no_value    = %lu\n", ap->fresh_on_no_value );

    printf( "\tnum_monitor_changes  = %lu\n", ap->num_monitor_changes );
    printf( "\tnum_monitor_problems = %lu\n", ap->num_monitor_problems );
    printf( "\tnum_conn_changes     = %lu\n", ap->num_conn_changes );

    printf( "\tlast_get_time        = %15.3lf\n", ap->last_get_time );
    printf( "\tlast_put_time        = %15.3lf\n", ap->last_put_time );
    printf( "\tlast_monitor_time    = %15.3lf\n", ap->last_monitor_time );
    printf( "\tlast_conn_state_time = %15.3lf\n", ap->last_conn_state_time );
    printf( "\ttry_hard_timer       = %d\n", ap->try_hard_timer );

    printf( "\ttype                 = %d\n", ap->dtype );
    printf( "\tchannel_id           = 0x%x\n", ap->channel_id );
    printf( "\tevent_id             = 0x%x\n", ap->event_id );

    printf( "\n" );

    printf( "\tconnection_state     = %s\n", connst2asc(ap->connection_state) );
    printf( "\tmonitor_state        = %s\n", monst2asc(ap->monitor_state) );
    printf( "\tvalue_state          = %s\n", valst2asc(ap->value_state) );
    printf( "\n" );
    print_value( ap );
    printf( "\n" );

    printf("que_get calls:\n" );
    printf( "\tq_get_n              = %lu\n", ap->q_get_n );
    printf( "\tq_get_pdest          = 0x%x\n", ap->q_get_pdest );
    printf( "\tq_get_pstatus        = 0x%x\n", ap->q_get_pstatus );
    printf( "\tq_get_value_state    = %s\n", valst2asc(ap->q_get_value_state) );
    printf( "\tq_get_ofs            = %d\n", ap->q_get_ofs );
    printf( "\tq_get_pmonitor       = 0x%x\n", ap->q_get_pmonitor );
    printf( "\tq_get_alarm_severity = %d\n", ap->q_get_alarm_severity );
    printf( "\tq_get_alarm_status   = %d\n", ap->q_get_alarm_status );
    printf( "\tlast_do_get_time     = %15.3lf\n", ap->last_do_get_time );
    printf( "\tget_callback_code    = 0x%x\n", ap->get_callback_code );
    printf( "\tget_callback_code_h  = 0x%x\n", ap->get_callback_code_h );
    printf( "\tget_callbackcastatus = 0x%x\n", ap->get_callback_ca_status);
    printf( "\tmissing_get_callbacks= %lu\n", ap->missing_get_callbacks );
    printf( "\tignored_get_callbacks= %lu\n", ap->ignored_get_callbacks );
    printf( "\tnum_que_gets         = %lu\n", ap->num_que_gets );
    printf( "\tnum_que_get_errors   = %lu\n", ap->num_que_get_errors );
    printf( "\tlast_que_get_time    = %15.3lf\n", ap->last_que_get_time );
    printf( "\n" );

    printf("que_put calls:\n" );
    printf( "\tq_put_n              = %lu\n", ap->q_put_n );
    printf( "\tq_put_psrc           = 0x%x\n", ap->q_put_psrc );
    printf( "\tq_put_pstatus        = 0x%x\n", ap->q_put_pstatus );
    printf( "\tq_put_ofs            = %d\n", ap->q_put_ofs );
    printf( "\tq_put_pcontrol       = 0x%x\n", ap->q_put_pcontrol );
    printf( "\tq_put_alarm_severity = %d\n", ap->q_put_alarm_severity );
    printf( "\tq_put_alarm_status   = %d\n", ap->q_put_alarm_status );
    printf( "\tlast_do_put_time     = %15.3lf\n", ap->last_do_put_time );
    printf( "\tput_callback_code    = 0x%x\n", ap->put_callback_code );
    printf( "\tput_callback_code_h  = 0x%x\n", ap->put_callback_code_h );
    printf( "\tput_callbackcastatus = 0x%x\n", ap->put_callback_ca_status);
    printf( "\tmissing_put_callbacks= %lu\n", ap->missing_put_callbacks );
    printf( "\tignored_put_callbacks= %lu\n", ap->ignored_put_callbacks );
    printf( "\tnum_que_puts         = %lu\n", ap->num_que_puts );
    printf( "\tnum_que_put_errors   = %lu\n", ap->num_que_put_errors );
    printf( "\tlast_que_put_time    = %15.3lf\n", ap->last_que_put_time );
    printf( "\n" );
    
    return 0;

}

scaEntry
int scaCall
print_defaults()
{
    printf( "DEFAULT_SEARCH_PEND_TIME            = %10.3f\n",
	    DEFAULT_SEARCH_PEND_TIME );
    printf( "DEFAULT_DO_GET_PEND_TIME            = %10.3f\n",
	    DEFAULT_DO_GET_PEND_TIME );
    printf( "DEFAULT_DO_PUT_PEND_TIME            = %10.3f\n",
	    DEFAULT_DO_PUT_PEND_TIME );
    printf( "DEFAULT_GROUP_REFRESH_PERIOD        = %10.3f\n",
	    DEFAULT_GROUP_REFRESH_PERIOD );
    return 0;
}

int
scatype_name2num( scatype_name )
char *scatype_name;
{
    int i;
    for ( i = 0; i < num_scatypes; ++i )
    {
	if ( strcmp( scatype_names[i], scatype_name ) == 0 )
	    return scatypes[i];
    }
    return 0;
}

char *
scatype2asc( scatype )
int scatype;
{
    int i;
    for ( i = 0; i < num_scatypes; ++i )
    {
	if ( scatype ==  scatypes[i] )
	    return scatype_names[i];
    }
    return sca_what;
}

char *
connst2asc( connection_state )
int connection_state;
{
    if ( sca_connected( connection_state ) )
	return sca_conn_up;
    else if ( sca_disconnected( connection_state ) )
	return sca_conn_down;
    else if ( sca_never_connected( connection_state ) )
	return sca_conn_never;
    else if( sca_connection_state_irrelevant( connection_state ) )
	return sca_conn_state_irrelevant;
    else if( sca_no_connection_state( connection_state ) )
	return sca_no_conn_state;
    else
	return sca_what;
}

char *
monst2asc( monitor_state )
int monitor_state;
{
    if ( sca_monitor_active(monitor_state ) )
	return sca_mon_active;
    else if ( sca_monitor_on_standby( monitor_state ) )
	return sca_mon_stdby;
    else if ( sca_never_monitored( monitor_state ) )
	return sca_mon_never;
    else if ( sca_monitor_corrupted( monitor_state ) )
	return sca_mon_corrupt;
    else if( sca_monitor_state_irrelevant( monitor_state ) )
	return sca_mon_state_irrelevant;
    else if( sca_no_monitor_state( monitor_state ) )
	return sca_no_mon_state;
    else
	return sca_what;
}

char *
valst2asc( value_state )
int value_state;
{
    if ( sca_fresh_value( value_state ) )
	return sca_val_fresh;
    else if ( sca_old_value( value_state ) )
	return sca_val_old;
    else if ( sca_no_value( value_state ) )
	return sca_val_not;
    else if( sca_value_state_irrelevant( value_state ) )
	return sca_val_state_irrelevant;
    else if( sca_no_value_state( value_state ) )
	return sca_no_val_state;
    else
	return sca_what;
}

int
print_status( ca_stat, event )
int ca_stat;
char *event;
{
	if ( ca_stat == ECA_NORMAL )
	    printf( " ca_stat = ECA_NORMAL %s\n", event );
	else if ( ca_stat == ECA_STRTOBIG )
	    printf( " ca_stat = ECA_STRTOBIG %s\n", event );
	else if ( ca_stat == ECA_BADTYPE )
	    printf( " ca_stat = ECA_BADTYPE %s\n", event );
	else if ( ca_stat == ECA_ALLOCMEM )
	    printf( " ca_stat = ECA_ALLOCMEM %s\n", event );
	else if ( ca_stat == ECA_TIMEOUT )
	    printf( " ca_stat = ECA_TIMEOUT %s\n", event );
	else
    	    printf( " ca_stat = %d(0x%x->error %d severity %d) %s\n",
		ca_stat, ca_stat,
		CA_EXTRACT_MSG_NO(ca_stat),
		CA_EXTRACT_SEVERITY(ca_stat), event  );
	return 0;
}

int
print_eca()
{
    printf( " ECA_STRTOBIG = %d\n", ECA_STRTOBIG );
    printf( " ECA_BADTYPE = %d\n", ECA_BADTYPE );
    printf( " ECA_ALLOCMEM = %d\n", ECA_ALLOCMEM );
    printf( " ECA_NORMAL = %d\n", ECA_NORMAL );
    printf( " DBR_STRING = %d\n", DBR_STRING );
    printf( " TYPENOTCONN = %d\n\n", TYPENOTCONN );
    printf( " ECA_IODONE = %d\n\n", ECA_IODONE );
    printf( " ECA_IOINPROGRESS = %d\n\n", ECA_IOINPROGRESS );
    return 0;
}

int
print_value( vap )
void *vap;
{
    short status;
    short severity;
    char t[32];
    ACCELERATION_CONTROL_BLOCK *ap = ( ACCELERATION_CONTROL_BLOCK *)vap;

    switch ( ap->dtype )
    {
	case DBR_TIME_STRING:
	    status = (ap->pmonitor)->tstrval.status;
	    severity = (ap->pmonitor)->tstrval.severity;
	    tsStampToText( &((ap->pmonitor)->tstrval.stamp),
			TS_TEXT_MONDDYYYY, t );
	    printf( "%c%c%c%c%c%c%c %s st =%3d sev =%3d; val =%s\n",
			t[4],t[5],t[0],t[1],t[2],t[10],t[11],&t[13],
			status, severity,
			(ap->pmonitor)->tstrval.value );
	    break;
	case DBR_TIME_SHORT:
	    status = (ap->pmonitor)->tshrtval.status;
	    severity = (ap->pmonitor)->tshrtval.severity;
	    tsStampToText( &((ap->pmonitor)->tshrtval.stamp),
			TS_TEXT_MONDDYYYY, t );
	    printf( "%c%c%c%c%c%c%c %s st =%3d sev =%3d; val =%5d\n",
			t[4],t[5],t[0],t[1],t[2],t[10],t[11],&t[13],
			status, severity,
			(ap->pmonitor)->tshrtval.value );
	    break;
	case DBR_TIME_FLOAT:
	    status = (ap->pmonitor)->tfltval.status;
	    severity = (ap->pmonitor)->tfltval.severity;
	    tsStampToText( &((ap->pmonitor)->tfltval.stamp),
			TS_TEXT_MONDDYYYY, t );
	    printf( "%c%c%c%c%c%c%c %s st =%3d sev =%3d; val =%7.1f\n",
			t[4],t[5],t[0],t[1],t[2],t[10],t[11],&t[13],
			status, severity,
			(ap->pmonitor)->tfltval.value );
	    break;
	case DBR_TIME_ENUM:
	    status = (ap->pmonitor)->tenmval.status;
	    severity = (ap->pmonitor)->tenmval.severity;
	    tsStampToText( &((ap->pmonitor)->tenmval.stamp),
			TS_TEXT_MONDDYYYY, t );
	    printf( "%c%c%c%c%c%c%c %s st =%3d sev =%3d; val =%5d\n",
			t[4],t[5],t[0],t[1],t[2],t[10],t[11],&t[13],
			status, severity,
			(ap->pmonitor)->tenmval.value );
	    break;
	case DBR_TIME_CHAR:
	    status = (ap->pmonitor)->tchrval.status;
	    severity = (ap->pmonitor)->tchrval.severity;
	    tsStampToText( &((ap->pmonitor)->tchrval.stamp),
			TS_TEXT_MONDDYYYY, t );
	    printf( "%c%c%c%c%c%c%c %s st =%3d sev =%3d; val =%5d\n",
			t[4],t[5],t[0],t[1],t[2],t[10],t[11],&t[13],
			status, severity,
			(int)(ap->pmonitor)->tchrval.value );
	    break;
	case DBR_TIME_LONG:
	    status = (ap->pmonitor)->tlngval.status;
	    severity = (ap->pmonitor)->tlngval.severity;
	    tsStampToText( &((ap->pmonitor)->tlngval.stamp),
			TS_TEXT_MONDDYYYY, t );
	    printf( "%c%c%c%c%c%c%c %s st =%3d sev =%3d; val =%ld\n",
			t[4],t[5],t[0],t[1],t[2],t[10],t[11],&t[13],
			status, severity,
			(ap->pmonitor)->tlngval.value );
	    break;
	case DBR_TIME_DOUBLE:
	    status = (ap->pmonitor)->tdblval.status;
	    severity = (ap->pmonitor)->tdblval.severity;
	    tsStampToText( &((ap->pmonitor)->tdblval.stamp),
			TS_TEXT_MONDDYYYY, t );
	    printf( "\ttime                 = %c%c%c%c%c%c%c %s\n",
			t[4],t[5],t[0],t[1],t[2],t[10],t[11],&t[13] );
	    printf( "\tstatus               = %d\n", status );
	    printf( "\tseverity             = %d\n", severity );
	    printf( "\tvalue                = %7.1lf\n",
			(ap->pmonitor)->tdblval.value );
	    break;
	default:
	    printf( "%s: Unrecognizable DBR_TIME_xxx = %d\n", ap->dtype );
    }
    return 0;
}


scaEntry int scaCall
print_sca_status_str(char *my_string, int status )
{
    if ( sca_no_error( status ) )
	strcpy(my_string, " NO_ERROR" );

    else if ( sca_cannot_find_name( status ) )
	strcpy(my_string, " CANNOT_FIND_NAME" );

    else if ( sca_bad_name_size( status ) )
	strcpy(my_string, " BAD_NAME_SIZE" );

    else if ( sca_bad_data_type( status ) )
	strcpy(my_string, " BAD_DATA_TYPE" );

    else if ( sca_no_acb( status ) )
	strcpy(my_string, " NO_ACCELERATION_CONTROL_BLOCK" );

    else if ( sca_bad_acb( status ) )
	strcpy(my_string, " BAD_ACB" );

    else if ( sca_no_callback( status ) )
	strcpy(my_string, " NO_CALLBACK" );

    else if ( sca_bad_chid( status ) )
	strcpy(my_string, " BAD_CHID" );

    else if ( sca_internal_error( status ) )
	strcpy(my_string, " INTERNAL_ERROR" );

    else if ( sca_cannot_search( status ) )
	strcpy(my_string, " CANNOT_SEARCH" );

    else if ( sca_cannot_malloc( status ) )
	strcpy(my_string, " CANNOT_MALLOC" );

    else if ( sca_cannot_create_monitor( status ) )
	strcpy(my_string, " CANNOT_CREATE_MONITOR" );

    else if ( sca_cannot_pend( status ) )
	strcpy(my_string, " CANNOT_PEND" );

    else if ( sca_cannot_put( status ) )
	strcpy(my_string, " CANNOT_PUT" );

    else if ( sca_cannot_get( status ) )
	strcpy(my_string, " CANNOT_GET" );

    else if ( sca_bad_arg( status ) )
	strcpy(my_string, " BAD_ARG" );

    else if ( sca_cannot_find_group( status ) )
	strcpy(my_string, " CANNOT_FIND_GROUP" );

    else if ( sca_cannot_find_channel( status ) )
	strcpy(my_string, " CANNOT_FIND_CHANNEL" );

    else
    {
	strcpy(my_string, sca_what );
    }

    strcat( my_string, connst2asc( status ) );
    strcat( my_string, monst2asc( status ) );
    strcat( my_string, valst2asc( status ) );

    return 0;
}

scaEntry int scaCall
print_sca_status( int status ) {
	char my_string[256];

	print_sca_status_str( my_string, status );
	printf("%s\n",my_string);
	return 0;
}


int
info( header, ap )
char *header;
void *ap;
{
    printf("\n%s\n",                   header );
    printf("get_q_nelm        = %d\n",   get_q_nelm    );
    printf("ap_table_nelm     = %d\n",   ap_table_nelm );
    printf("ap_table          = 0x%x\n", ap_table );
    printf("ap_table[0]       = 0x%x\n", ap_table[0] );
    printf("ap                = 0x%x\n", ap          );
    printf("num_not_connected = %d\n", num_not_connected );
    printf("missing_get_clbks = %d\n", missing_get_callbacks );
	return 0;
}

int
print_q(q_name, q, q_nelm )
char *q_name;
Q_ITEM *q;
int q_nelm;
{
    int i;
    printf("%s: %d elements\n", q_name, q_nelm );
    for ( i = 0; i < q_nelm; ++i )
	printf("\t%s[%d] = 0x%x\n", q_name, i, q[i] );
	return 0;
}

int
print_ap_table()
{
    int i;
    printf("ap_table: %d elements\n", ap_table_nelm );
    for ( i = 0; i < ap_table_nelm; ++i )
	printf("\tap_table[%d] = 0x%x\n", i, ap_table[i] );
	return 0;
}

int
print_event_args(arg, handler_name )
struct  event_handler_args arg;
char *handler_name;
{
    printf( "Event handler args from %s\n", handler_name );
    printf( "    usr    = 0x%08x", arg.usr );
    printf( "    chid   = 0x%08x", arg.chid );
    printf( "    type   = 0x%08x\n", arg.type );
    printf( "    count  = 0x%08x", arg.count );
    printf( "    dbr    = 0x%08x", arg.dbr );
    printf( "    status = 0x%08x\n", arg.status );
	return 0;
}

scaEntry int scaCall
print_global_stats()
{
    printf( "Globals:\n" );
    printf( "    num_not_connected     = %6d\n\n", num_not_connected );

    printf( "    num_que_gets          = %6lu", num_que_gets );
    printf( "    num_que_puts          = %6lu\n", num_que_puts );

    printf( "    num_que_get_errors    = %6lu", num_que_get_errors );
    printf( "    num_que_put_errors    = %6lu\n", num_que_put_errors );

    printf( "    num_get_callbacks     = %6lu", num_get_callbacks );
    printf( "    num_put_callbacks     = %6lu\n", num_put_callbacks );

    printf( "    missing_get_callbacks = %6lu", missing_get_callbacks );
    printf( "    missing_put_callbacks = %6lu\n", missing_put_callbacks );

    printf( "    ignored_get_callbacks = %6lu", ignored_get_callbacks );
    printf( "    ignored_put_callbacks = %6lu\n", ignored_put_callbacks );

    printf( "    num_do_gets           = %6lu", num_do_gets );
    printf( "    num_do_puts           = %6lu\n", num_do_puts );
    return 0;
}

/*
** --------------------------------------------------------------------
** SCA - METHOD 3 - Grouping and data caching without monitors.   !!!!!
** --------------------------------------------------------------------
*/

ELLLIST group_list;
ELLLIST *pgroup_list = (ELLLIST *)NULL;

int
group_addchannel( group_name, channel_name, scatype, nmax, ppgroup, ppchan )
char *group_name;		/* group name */
char *channel_name;		/* pvname[.fieldname] */
int scatype;			/* data type, e.g. SCA_STRING */
int nmax;			/* max number of data elements */
void **ppgroup;		        /* returns group ptr.  Pass NULL to ignore */
void **ppchan;		        /* returns channel ptr.  Pass NULL to ignore */
{
    SCA_GROUP *pgroup;
    SCA_GROUP_CHANNEL *pchan;
    int stat;

    if ( ( pgroup = findc_group( group_name ) ) == ( SCA_GROUP *)NULL )
	return SCA_CANNOT_FIND_GROUP;

    pchan = findc_channel_in_group( pgroup, channel_name, scatype, nmax, &stat);
    if ( pchan == ( SCA_GROUP_CHANNEL *)NULL )
	return stat;

    if ( ppgroup != ( void **)NULL )
	*ppgroup = pgroup;
    if ( ppchan != ( void **)NULL )
	*ppchan = pchan;

    return SCA_NO_ERROR + SCA_STATES_IRRELEVANT;
}

int
group_removechannelbyname( group_name, channel_name, scatype )
char *group_name;		/* group name */
char *channel_name;		/* pvname[.fieldname] */
int scatype;			/* data type, e.g. SCA_STRING */
{
    SCA_GROUP_CHANNEL *pchan;
    SCA_GROUP *pgroup = find_group( group_name );
    if ( pgroup == ( SCA_GROUP *)NULL )
	return SCA_CANNOT_FIND_GROUP + SCA_STATES_IRRELEVANT;

    pchan = find_channel_in_group( pgroup, channel_name, scatype );
    if ( pchan == ( SCA_GROUP_CHANNEL *)NULL )
	return SCA_CANNOT_FIND_CHANNEL + SCA_STATES_IRRELEVANT;

    return group_removechannel( pchan );
}

int
group_removechannel( pchan )
void *pchan;			/* pointer to channel */
{
    SCA_GROUP_CHANNEL *pc = ( SCA_GROUP_CHANNEL *)pchan;

    if ( pc == ( SCA_GROUP_CHANNEL *)NULL )
	return SCA_CANNOT_FIND_CHANNEL + SCA_STATES_IRRELEVANT;

    /* remove channel from list */
    ellDelete( (pc->pgroup)->pchannel_list, &(pc->node) );

    /* Deallocate value */
    if ( ((SCA_GROUP_CHANNEL *)pc)->pvalue != ( void *)NULL )
	free( ((SCA_GROUP_CHANNEL *)pc)->pvalue );

    /* reset group's current channel pointer if this is it */
    if ( ( pc->pgroup)->pcurrent == pc )
	( pc->pgroup)->pcurrent = ( SCA_GROUP_CHANNEL *)NULL;

    /* Deallocate channel */
    free( pc );
    return SCA_NO_ERROR + SCA_STATES_IRRELEVANT;
}

int
group_freebyname( group_name )
char *group_name;		/* group name */
{
    SCA_GROUP *pgroup = find_group( group_name );
    if ( pgroup == ( SCA_GROUP *)NULL )
	return SCA_CANNOT_FIND_GROUP;           /* group not found */

    return group_free( ( void*)pgroup );
}

int
group_free( pgroup )
void *pgroup;			/* pointer to group */
{
    ELLNODE *pnode;
    SCA_GROUP_CHANNEL *pchan;
    SCA_GROUP *pg = ( SCA_GROUP *)pgroup;
    if ( pg == ( SCA_GROUP *)NULL )
	return SCA_CANNOT_FIND_GROUP + SCA_STATES_IRRELEVANT;

/* Remove group from list */
    ellDelete( pgroup_list, &(pg->node) );

/* Deallocate channels of group */
    if ( pg->pchannel_list != ( ELLLIST *)NULL )
    {
       while ( pnode = ellFirst( pg->pchannel_list ) )
       {
	   pchan = ( SCA_GROUP_CHANNEL *)pnode;
	   if ( pchan->pvalue != ( void *)NULL )
	       free( pchan->pvalue );
	   ellDelete( pg->pchannel_list, &(pchan->node) );
       }
       free( pg->pchannel_list );
    }
    free( pg );
    return SCA_NO_ERROR + SCA_STATES_IRRELEVANT;
}

int
group_refreshbyname( group_name )
char *group_name;		/* group name */
{
    SCA_GROUP *pgroup = find_group( group_name );
    if ( pgroup == ( SCA_GROUP *)NULL )
	return SCA_CANNOT_FIND_GROUP + SCA_STATES_IRRELEVANT;

    return group_refresh( (void *)pgroup );
}

int
group_refresh( pgroup )
void *pgroup;			/* pointer to group */
{
    int ca_status;
    int num_channels = 0;
    ELLNODE *pnode;
    double current_time, earliest_refresh_time;

    SCA_GROUP *pg = ( SCA_GROUP *)pgroup;
    if ( pg == ( SCA_GROUP *)NULL )
	return SCA_CANNOT_FIND_GROUP + SCA_STATES_IRRELEVANT;

    current_time = sca_gettimeofday();
    earliest_refresh_time =
	pg->last_refresh_time + GROUP_REFRESH_PERIOD_LOWER_LIMIT;
    if ( earliest_refresh_time > current_time )
	ca_status = ca_pend_event(earliest_refresh_time - current_time );
    pnode = ellFirst( pg->pchannel_list );
    while( pnode != ( ELLNODE *)NULL )
    {
	int stat;
	SCA_GROUP_CHANNEL *pchan = ( SCA_GROUP_CHANNEL *)pnode;
	if ( pchan->pvalue == ( void *)NULL )
	{
	    pchan->pvalue = calloc( pchan->nmax, pchan->valsize );
	    if ( pchan->pvalue == ( void *)NULL )
	    {
		stat = pchan->status =
		    SCA_CANNOT_MALLOC + SCA_STATES_IRRELEVANT;
	    }
	    else
	    {
		stat = que_get(	(pchan->ap)->name,
				pchan->scatype,
				pchan->nmax,
				pchan->pvalue,
				&(pchan->status) );
	    }
	}
	else
	{
	    stat = que_get(	(pchan->ap)->name,
				pchan->scatype,
				pchan->nmax,
				pchan->pvalue,
				&(pchan->status) );
	}
	if ( sca_no_error( stat ) )
	    ++num_channels; 
	pnode = ellNext( pnode );
    }

    pg->demand_refresh = 0;
    pg->last_refresh_time = current_time;
    if ( num_channels > 0 )
    {
	/* set min time between do gets very small so that auto refresh period
	** controls the timing.  Likewise, do_get() waits only that long.
	*/
	double cur_min_time_between_do_gets = get_min_time_between_do_gets();
	int num_errors;   

	set_min_time_between_do_gets( 1.0e-12 );

	current_time = sca_gettimeofday();
	if ( pg->do_get_timeout <= 0.0 )
	{
	    num_errors = do_get( (double)num_channels * .010 + .020);   
	}
	else
	{
	    num_errors = do_get( pg->do_get_timeout );   
	}
	pg->last_refresh_time = sca_gettimeofday();
	pg->do_get_time = pg->last_refresh_time - current_time;
	set_min_time_between_do_gets( cur_min_time_between_do_gets );
	++(pg->num_refreshes);
	if ( num_errors != 0 )
	{
	    return SCA_GROUP_REFRESH_INCOMPLETE + SCA_STATES_IRRELEVANT;
	}
    }
    return SCA_NO_ERROR + SCA_STATES_IRRELEVANT;
}

int
group_getchannelbyname(
	group_name, channel_name, scatype, nelm, pdest, pstatus )
char *group_name;		/* group name */
char *channel_name;		/* pvname[.fieldname] */
int scatype;			/* data type, e.g. SCA_STRING */
int nelm;			/* number of channel values to return */
void *pdest;			/* where to return channel values */
int *pstatus;			/* where to return channel status */
{
    int i, stat;
    double cur_time;
    SCA_GROUP_CHANNEL *pchan;
    SCA_GROUP *pgroup;

    if ( ( pgroup = findc_group( group_name ) ) == ( SCA_GROUP *)NULL )
	return SCA_CANNOT_FIND_GROUP + SCA_STATES_IRRELEVANT;
 
    pchan = findc_channel_in_group( pgroup, channel_name, scatype, nelm, &stat);
    if ( pchan == ( SCA_GROUP_CHANNEL *)NULL )
	return stat;
    return group_getchannel( pchan, nelm, pdest, pstatus );
}

int
group_getchannel(pchan, nelm, pdest, pstatus )
void *pchan;			/* pointer to channel */
int nelm;			/* number of channel values to return */
void *pdest;			/* where to return channel values */
int *pstatus;			/* where to return channel status */
{
    int i, stat;
    double cur_time;
    SCA_GROUP *pg;
    SCA_GROUP_CHANNEL *pc = ( SCA_GROUP_CHANNEL *)pchan;
 
    if ( pc == ( SCA_GROUP_CHANNEL *)NULL )
	return SCA_CANNOT_FIND_CHANNEL + SCA_STATES_IRRELEVANT;

    pg = pc->pgroup;
    if ( pg == ( SCA_GROUP *)NULL )
	return SCA_CANNOT_FIND_GROUP + SCA_STATES_IRRELEVANT;
    cur_time = sca_gettimeofday();
    if (( cur_time > (pg->last_refresh_time + pg->group_refresh_period) ) ||
		pg->demand_refresh ||
		pc->pvalue == ( void *)NULL )/* group_refresh sets pvalue */
	group_refresh( pg );

    if ( nelm > pc->nmax )
	nelm = pc->nmax;
    bcopy( (char*)(pc->pvalue), (char*)pdest, (pc->valsize) * nelm );
    *pstatus = pc->status;
    (pc->pgroup)->pcurrent = pc;

    return SCA_NO_ERROR + SCA_STATES_IRRELEVANT;
}

scaEntry int scaCall
group_getfirstchannelbyname( group_name, nelm, pdest, pstatus )
char *group_name;		/* group name */
int nelm;			/* number of channel values to return */
void *pdest;			/* where to return channel values */
int *pstatus;			/* where to return channel status */
{
    SCA_GROUP_CHANNEL *pchan;
    SCA_GROUP *pgroup;

    if ( ( pgroup = find_group( group_name ) ) == ( SCA_GROUP *)NULL )
	return SCA_CANNOT_FIND_GROUP + SCA_STATES_IRRELEVANT;

    if ( pgroup->pchannel_list != ( ELLLIST *)NULL )
    {
	pchan = ( SCA_GROUP_CHANNEL *)ellFirst( pgroup->pchannel_list );
	if ( pchan != ( SCA_GROUP_CHANNEL *)NULL )
	{
	    pgroup->pcurrent = pchan;
	    return group_getchannel( pchan, nelm, pdest, pstatus );
	}
    }
    return SCA_CANNOT_FIND_CHANNEL + SCA_STATES_IRRELEVANT;
}

scaEntry int scaCall
group_getnextchannelbyname( group_name, nelm, pdest, pstatus )
char *group_name;		/* group name */
int nelm;			/* number of channel values to return */
void *pdest;			/* where to return channel values */
int *pstatus;			/* where to return channel status */
{
    SCA_GROUP_CHANNEL *pchan;
    SCA_GROUP *pgroup;

    if ( ( pgroup = find_group( group_name ) ) == ( SCA_GROUP *)NULL )
	return SCA_CANNOT_FIND_GROUP + SCA_STATES_IRRELEVANT;

    if ( pgroup->pchannel_list != ( ELLLIST *)NULL )
    {
	pchan = ( SCA_GROUP_CHANNEL *)ellNext( pgroup->pcurrent );
	if ( pchan != ( SCA_GROUP_CHANNEL *)NULL )
	{
	    pgroup->pcurrent = pchan;
	    return group_getchannel( pchan, nelm, pdest, pstatus );
	}
    }
    return SCA_CANNOT_FIND_CHANNEL + SCA_STATES_IRRELEVANT;
}

int
group_getfirstchannel( pgroup, nelm, pdest, pstatus )
void *pgroup;			/* group */
int nelm;			/* number of channel values to return */
void *pdest;			/* where to return channel values */
int *pstatus;			/* where to return channel status */
{
    SCA_GROUP_CHANNEL *pchan;
    SCA_GROUP *pg = ( SCA_GROUP *)pgroup;

    if ( pg == ( SCA_GROUP *)NULL )
	return SCA_CANNOT_FIND_GROUP + SCA_STATES_IRRELEVANT;

    if ( pg->pchannel_list != ( ELLLIST *)NULL )
    {
	pchan = ( SCA_GROUP_CHANNEL *)ellFirst( pg->pchannel_list );
	if ( pchan != ( SCA_GROUP_CHANNEL *)NULL )
	{
	    pg->pcurrent = pchan;
	    return group_getchannel( pchan, nelm, pdest, pstatus );
	}
    }
    return SCA_CANNOT_FIND_CHANNEL + SCA_STATES_IRRELEVANT;
}

int
group_getnextchannel( pgroup, nelm, pdest, pstatus )
void *pgroup;			/* group */
int nelm;			/* number of channel values to return */
void *pdest;			/* where to return channel values */
int *pstatus;			/* where to return channel status */
{
    SCA_GROUP_CHANNEL *pchan;
    SCA_GROUP *pg = ( SCA_GROUP *)pgroup;

    if ( pg == ( SCA_GROUP *)NULL )
	return SCA_CANNOT_FIND_GROUP + SCA_STATES_IRRELEVANT;

    if ( pg->pchannel_list != ( ELLLIST *)NULL )
    {
	pchan = ( SCA_GROUP_CHANNEL *)ellNext( pg->pchannel_list );
	if ( pchan != ( SCA_GROUP_CHANNEL *)NULL )
	{
	    pg->pcurrent = pchan;
	    return group_getchannel( pchan, nelm, pdest, pstatus );
	}
    }
    return SCA_CANNOT_FIND_CHANNEL + SCA_STATES_IRRELEVANT;
}

int
group_printbyname( group_name )
char *group_name;		/* group name */
{
    SCA_GROUP *pgroup = find_group( group_name );
    if ( pgroup == ( SCA_GROUP *)NULL )
    {
	printf( "Cannot find %s\n", group_name );
	return SCA_CANNOT_FIND_GROUP + SCA_STATES_IRRELEVANT;
    }
    group_print( pgroup );
    return SCA_NO_ERROR + SCA_STATES_IRRELEVANT;
}

int
groups_print( first_group, num_wanted )	/* return number printed */
int first_group;			/* first group is 1*/
int num_wanted;	
{
    SCA_GROUP *pgroup;
    int num_groups = 0;
    int num_printed = 0;
    int this_group = 0;

    if ( pgroup_list == ( ELLLIST *)NULL )
    {
	printf( "\nSorry! Never any groups!\n" );
	return num_printed;
    }
    else if ( ( num_groups = ellCount( pgroup_list ) ) == 0 )
    {
	printf( "\nSorry! No groups!\n" );
	return num_printed;
    }
    else if ( first_group > num_groups )
    {
	printf( "\nSorry! Only %d groups!\n", num_groups );
	return num_printed;
    }
    else
    {
	ELLNODE *pnode = ellFirst( pgroup_list );
	while( pnode != ( ELLNODE *)NULL )
	{
	    if ( ++this_group >= first_group )
		group_print( ( SCA_GROUP *)pnode );
	    if ( ++num_printed >= num_wanted )
		break;
	    pnode = ellNext( pnode );
	}
	return num_printed;
    }
}

int
group_print( pgroup )
void *pgroup;
{
    int num_channels;
    int num_channels_printed = 0;
    ELLLIST *pchannel_list;

    SCA_GROUP *pg = ( SCA_GROUP *)pgroup;
    printf( "\n" );
    printf( "Group %s @ 0x%x:  ", pg->group_name, pg );
    printf( "Next @ 0x%x:  ", pg->node.next );
    printf( "Prev @ 0x%x\n", pg->node.previous );
    printf( "    last_refresh_time    = %5.3f\n", pg->last_refresh_time );
    printf( "    group_refresh_period = %5.3f\n", pg->group_refresh_period );
    printf( "    demand_refresh       = %d\n", pg->demand_refresh );
    printf( "    num_refreshes        = %d\n", pg->num_refreshes );
    printf( "    pcurrent             = 0x%x\n", pg->pcurrent );
    printf( "    pchannel_list        = 0x%x\n", pg->pchannel_list );

    pchannel_list = pg->pchannel_list;
    if ( pchannel_list == ( ELLLIST *)NULL )
    {
	printf( "\nNever any channels!\n" );
	return num_channels_printed;
    }
    else if ( ( num_channels = ellCount( pchannel_list ) ) == 0 )
    {
	printf( "\nNo channels!\n" );
	return num_channels_printed;
    }
    else
    {
	ELLNODE *pnode = ellFirst( pchannel_list );
	while( pnode != ( ELLNODE *)NULL )
	{
	    printf( "Channel %d of %d:", ++num_channels_printed, num_channels );
	    group_printchannel( ( SCA_GROUP_CHANNEL *)pnode );
	    pnode = ellNext( pnode );
	}
	return num_channels_printed;
    }
}

int
group_printchannel( pchan )
SCA_GROUP_CHANNEL *pchan;
{
    printf( "  %s @ 0x%x:  ", (pchan->ap)->sca_name, pchan );
    printf( "Next @ 0x%x:  ", pchan->node.next );
    printf( "Prev @ 0x%x \n", pchan->node.previous );
    printf( "           *ap              =  0x%x\n", pchan->ap      );
    printf( "           *pgroup          =  0x%x\n", pchan->pgroup  );
    printf( "            scatype         =  %d\n",   pchan->scatype );
    printf( "            nmax            =  %d\n",   pchan->nmax    );
    printf( "            valsize         =  %d\n",   pchan->valsize );
    printf( "           *pvalue          =  0x%x\n", pchan->pvalue  );
    printf( "            status          =  0x%x\n", pchan->status  );
    return 1;
}

/*
** --------------------------------------------------------------------
** SCA - Acceleration Control Block creation and lookup routines.   !!!!!
** --------------------------------------------------------------------
*/
/* 
	Modelled after the functions in A K Biocca's aa_private.c with
	the hash index computation replaced by a modification of
	hash() found in EPICS 3.12 dbStaticLib.c.
*/

/*	Second version from Marty Kraimer */

int
sca_hash( char *pname, int length)
{
    unsigned char h0=0;
    unsigned char h1=0;
    unsigned short ind0,ind1;
    int         i;
 
    for(i=0; i<length; i+=2, pname+=2) {
        h0 = T[h0^*pname];
        h1 = T[h1^*(pname+1)];
    }
    ind0 = (unsigned short)h0;
    ind1 = (unsigned short)h1;
    return( ( int)( (ind1<<sca_HashTableShift) ^ ind0 ) );
}

int
sca_get_hash_table_size()
{
    return( sca_HashTableSize );
}

int
sca_set_hash_table_size( new_size )
int new_size;
{
    int i;
    int size = NTABLESIZES - 1;

    for(i=0; i< NTABLESIZES; i++)
    {
	if( sca_hashTableParms[i].tablesize >= new_size)
	{
	    size = i;
	    break;
	}
    }

    if ( acb_hashtbl != (ACCELERATION_CONTROL_BLOCK **)NULL )
    {
	/* If table is not empty, we're too late */ 
	for ( i = 0; i < sca_HashTableSize; ++i )
	{
	    if ( acb_hashtbl[i] != (ACCELERATION_CONTROL_BLOCK *)NULL )
		return 0 ;	/* Sorry! Too Late!  Table already in use. */
	}
	free( acb_hashtbl );
    }

    sca_HashTableSize = sca_hashTableParms[size].tablesize;
    sca_HashTableShift = sca_hashTableParms[size].shift;
    last_hash_index = sca_HashTableSize;

    acb_hashtbl = (ACCELERATION_CONTROL_BLOCK **)\
	calloc( sca_HashTableSize , sizeof( ACCELERATION_CONTROL_BLOCK *) );

    if ( acb_hashtbl == (ACCELERATION_CONTROL_BLOCK **)NULL )
	return 0;	/* Sorry! Out of Memory! */

    return 1;
    
}

ACCELERATION_CONTROL_BLOCK *
acb_malloc()			/* allocate an ACCELERATION_CONTROL_BLOCK */
{
    ACCELERATION_CONTROL_BLOCK *ap;

    ap = (ACCELERATION_CONTROL_BLOCK *)
	calloc( 1, sizeof( ACCELERATION_CONTROL_BLOCK ) );

    if ( ap ) return ap;

    printf("out of memory\n");
    exit(1);
}

int
acb_free( ap )			/* deallocate an ACCELERATION_CONTROL_BLOCK */
ACCELERATION_CONTROL_BLOCK *ap;
{
    if ( ap )
    {
	if ( ap->pmonitor ) cfree( ( char *)(ap->pmonitor) );
	if ( ap->pcontrol ) cfree( ( char *)(ap->pcontrol) );
	cfree( ( char *)ap );
    }
	return 0;
}

ACCELERATION_CONTROL_BLOCK *
find_ap( sca_name )  /* find ACCELERATION_CONTROL_BLOCK by sca_name */
char *sca_name;
{
    ACCELERATION_CONTROL_BLOCK *ap;
    int j;

    if ( acb_hashtbl == ( ACCELERATION_CONTROL_BLOCK **)NULL )
	return AP_NULL;

    if ( sca_name[0] == (char)NULL ) return AP_NULL;

    /* compute hash index, search the hash list, if exists return it
     * else return NULL
     */

    j = (int )sca_hash( sca_name, strlen( sca_name ) );

    ap = acb_hashtbl[j];				/* scan */
    while( ap )
    {
	if ( strcmp( sca_name, ap->sca_name ) == 0 )
	{
	    if ( ap->real_acb)
		return ap->real_acb;
	    else
		return ap;
	}

	ap = ap->next_ap;
    }

    return AP_NULL;
}

void *
sca_find_ap( sca_name )
char *sca_name;
{
   return ( void *)find_ap( sca_name );
}

int
sca_find_index( channel_name, scatype )	/*i.e., index into ap_table */
char *channel_name;		/* pvname[.fieldname] */
int scatype;			/* data type, e.g. SCA_STRING */
{
    ACCELERATION_CONTROL_BLOCK *ap;
    char sca_name[SCA_NAME_STRING_SIZE];
    chtype dtype;
    int stat;

    stat = scatodbr( scatype, &dtype );/* map scatype -> DBR_... type */
    if ( sca_error( stat ) )
	return stat;

    stat = sca_name_gen( channel_name, scatype, sca_name );
    if ( sca_error( stat ) )
	return stat;

    if ( ap = find_ap( sca_name ) )
	return ap->acb_index;
    else
	return SCA_NO_ACB;
}

ACCELERATION_CONTROL_BLOCK *
findc_ap( sca_name )  /* find or create ACCELERATION_CONTROL_BLOCK by sca_name */
char *sca_name;
{
    ACCELERATION_CONTROL_BLOCK *ap;
    int j;

    if ( sca_name[0] == (char)NULL) return AP_NULL;

    if (ap = find_ap( sca_name ) ) return ap;	/* search */

    if ( acb_hashtbl == ( ACCELERATION_CONTROL_BLOCK ** )NULL )
    {
	int size = sca_hashTableParms[DEFAULT_HASHSIZE].tablesize;
        if ( sca_set_hash_table_size( size ) == 0 )
	    return AP_NULL;
    }

    j = (int )sca_hash( sca_name, strlen( sca_name ) );

    ap = (ACCELERATION_CONTROL_BLOCK *)
		acb_malloc();	/* create */

    strncpy( ap->sca_name,  sca_name, SCA_NAME_SIZE );
    ap->sca_name[SCA_NAME_SIZE] = '\0';

    ap->next_ap = acb_hashtbl[j];		/* link */
    acb_hashtbl[j] = ap;

    return ap;
}

void *
sca_findc_ap( sca_name )
char *sca_name;
{
   return ( void *)findc_ap( sca_name );
}

/* non-reentrant pair of routines to allow caller to access all hashed aps */
/* routines return pointer to next acb or NULL if no more                  */

ACCELERATION_CONTROL_BLOCK *
find_firstap()
{
    for ( last_hash_index = 0; last_hash_index < sca_HashTableSize; ++last_hash_index )
	if ( acb_hashtbl[last_hash_index] != AP_NULL )
	{
	    last_ap = acb_hashtbl[last_hash_index];
	    return ( last_ap );
	}
    return ( last_ap = AP_NULL );
}

void *
sca_find_firstap()
{
   return ( void *)find_firstap();
}

ACCELERATION_CONTROL_BLOCK *
find_nextap( )
{
    if ( last_ap == AP_NULL )
	return AP_NULL;

    if ( last_ap->next_ap != AP_NULL )
	return ( last_ap = last_ap->next_ap );

    while( ++last_hash_index < sca_HashTableSize )
    {
	if ( acb_hashtbl[last_hash_index] != AP_NULL )
	    return( last_ap = acb_hashtbl[last_hash_index] );
    }
    return AP_NULL;
}

void *
sca_find_nextap()
{
   return ( void *)find_nextap();
}

int
sca_hashdepth()
{
    int last_hash_index;
    ACCELERATION_CONTROL_BLOCK *last_ap;
    int num_aps;

    last_hash_index = -1;
    while( ++last_hash_index < sca_HashTableSize )
    {
	num_aps = 0;
	last_ap = acb_hashtbl[last_hash_index];
	while( last_ap != AP_NULL )
	{
	    ++num_aps;
	    last_ap = last_ap->next_ap;
	}
	if ( num_aps )
	{
	    int i;
	    printf( "%4d ", last_hash_index );

	    for ( i = 0; i < num_aps; ++i )
		printf("." );

	    printf( "\n" );
	}

    }
    printf( "\n" );
	return 0;
}

#define HASHHIST_SIZE	150
int
sca_hashhist( hist_max )
int hist_max;
{
    int last_hash_index;
    ACCELERATION_CONTROL_BLOCK *last_ap;
    int num_aps;
    int i;
    int total_aps = 0;
    int namlen;
    int nhist_max = 40;
    int *hist  = ( int *)calloc( hist_max + 1, sizeof( int ) );
    int *nhist = ( int *)calloc( nhist_max + 1 , sizeof( int ) );

    last_hash_index = -1;
    while( ++last_hash_index < sca_HashTableSize )
    {
	num_aps = 0;
	last_ap = acb_hashtbl[last_hash_index];
	while( last_ap != AP_NULL )
	{
	    ++total_aps;
	    ++num_aps;
	    namlen = strlen( last_ap->sca_name );
	    if ( namlen >= nhist_max )
		namlen = nhist_max;
	    ++nhist[namlen];
	    last_ap = last_ap->next_ap;
	}

	if ( num_aps >= hist_max  )
	    num_aps = hist_max;

	++hist[num_aps];
    }

printf( "\nFrequency of hash table depths for %d pv_names ", total_aps );
printf( "and table length of %d\n", sca_HashTableSize );
printf( "depth\tcount\n" );
    for ( i = 0; i <= hist_max; ++i )
	if ( hist[i] > 0 ) printf( "%3d\t%d\n", i, hist[i] );

printf( "\nFrequency of pv_name lengths for %d pv_names ", total_aps );
printf( "and table length of %d\n", sca_HashTableSize );
printf( "length\tcount\n" );
    for ( i = 0; i <= nhist_max; ++i )
	if ( nhist[i] > 0 ) printf( "%3d\t%d\n", i, nhist[i] );
	return 0;
}

int
sca_hashcheck()
{
    int last_hash_index;
    ACCELERATION_CONTROL_BLOCK *last_ap;
    int num_aps;

    last_hash_index = -1;
    while( ++last_hash_index < sca_HashTableSize )
    {
	num_aps = 0;
	last_ap = acb_hashtbl[last_hash_index];
	if ( last_ap != AP_NULL )
	{
	    while( last_ap->next_ap != (void *)0 )
	    {
		if ( last_ap->next_ap != (void*)0 &&
		    last_ap->next_ap < (void *)0x10000 )
		{
		    printf( "Suspicious next_ap\n" );
		    print_ap( last_ap );
		    return 1;
		}
		++num_aps;
		last_ap = last_ap->next_ap;
	    }
	}
    }
    return 0;
}

/* dump the hash table to standard output.
**
** Format:	element <tab> depth		for import to excel etc.
*/
int
sca_hashdump()
{
    int last_hash_index;
    ACCELERATION_CONTROL_BLOCK *last_ap;
    int num_aps;
    int i;

    last_hash_index = -1;
    while( ++last_hash_index < sca_HashTableSize )
    {
	num_aps = 0;
	last_ap = acb_hashtbl[last_hash_index];
	while( last_ap != AP_NULL )
	{
	    ++num_aps;
	    last_ap = last_ap->next_ap;
	}
	printf( "%d\t%d\n", last_hash_index, num_aps ); 
    }
    return 0;
}

/*
** --------------------------------------------------------------------
** SCA - Group creation and lookup routines.   !!!!!
** --------------------------------------------------------------------
*/


SCA_GROUP *
find_group( group_name )
char *group_name;		/* group name */
{
    ELLNODE *pnode;
    if ( pgroup_list == ( ELLLIST *)NULL )		/* create list? */
    {
	pgroup_list = ( ELLLIST *)&group_list;
	ellInit( pgroup_list );
    }

    pnode = ellFirst( pgroup_list );			/* node exists? */
    while ( pnode != ( ELLNODE *)NULL )
    {
	SCA_GROUP *pgroup = ( SCA_GROUP *)pnode;
	if ( strcmp( group_name, pgroup->group_name ) == 0 )
	    return pgroup;
	else
            pnode = ellNext( pnode );
    }
    return ( SCA_GROUP *)NULL;
}

SCA_GROUP *
findc_group( group_name )
char *group_name;		/* group name */
{
    SCA_GROUP *pgroup= find_group( group_name );
    if ( pgroup != ( SCA_GROUP *)NULL )
	return pgroup;

/* Create a group */

    pgroup = ( SCA_GROUP *)calloc( 1, sizeof( SCA_GROUP ) );
    if ( pgroup == ( SCA_GROUP *)NULL )
    {
	fprintf( stdout, "Cannot allocate memory for group %s\n", group_name );
	exit( 4 );
    }

    strncpy( pgroup->group_name, group_name, SCA_NAME_SIZE );
    (pgroup->group_name)[SCA_NAME_SIZE] = '\n';
    pgroup->group_refresh_period = DEFAULT_GROUP_REFRESH_PERIOD;
    pgroup->do_get_timeout = 0;
    pgroup->demand_refresh = 1;
    pgroup->group_flush_period = DEFAULT_GROUP_FLUSH_PERIOD;
    pgroup->do_put_timeout = 0;
    pgroup->demand_flush = 1;
    pgroup->pchannel_list = ( ELLLIST *)calloc( 1, sizeof( ELLLIST ) );
    ellInit( pgroup->pchannel_list );

    if ( pgroup_list == ( ELLLIST *)NULL )
    {
	pgroup_list = &group_list;
	ellInit( pgroup_list );
    }
    ellAdd( pgroup_list, &(pgroup->node) );/* Add group to end of list */
    return pgroup;
}

SCA_GROUP_CHANNEL *
find_channel_in_group( pgroup, channel_name, scatype )
SCA_GROUP *pgroup;		/* group name */
char *channel_name;		/* pvname[.fieldname] */
int scatype;			/* data type, e.g. SCA_STRING */
{
    ELLNODE *pnode;
    char sca_name[SCA_NAME_STRING_SIZE];
    int stat;

    stat = sca_name_gen( channel_name, scatype, sca_name );
    if ( sca_error( stat ) )
	return ( SCA_GROUP_CHANNEL *)NULL;

    pnode = ellFirst( pgroup->pchannel_list );
    while ( pnode != ( ELLNODE *)NULL )
    {
	SCA_GROUP_CHANNEL *pchan = (SCA_GROUP_CHANNEL *)pnode;
	if ( strcmp( sca_name, (pchan->ap)->sca_name ) == 0 )
	    return pchan;
	pnode = ellNext( pnode );
    }
    return ( SCA_GROUP_CHANNEL *)NULL;
}

SCA_GROUP_CHANNEL *
findc_channel_in_group( pgroup, channel_name, scatype, nmax, pstatus )
SCA_GROUP *pgroup;		/* group name */
char *channel_name;		/* pvname[.fieldname] */
int scatype;			/* data type, e.g. SCA_STRING */
int nmax;			/* max number of data elements */
int *pstatus;			/* returns status of call */
{
    int stat;
    ACCELERATION_CONTROL_BLOCK *ap;
    SCA_GROUP_CHANNEL *pchan;
    char sca_name[SCA_NAME_STRING_SIZE];
    void *valptr;
    int valsize;

    *pstatus = SCA_NO_ERROR + SCA_STATES_IRRELEVANT;
    if ( pchan = find_channel_in_group( pgroup, channel_name, scatype ) )
    {
	return pchan;
    }

    /* Create channel */

    switch ( scatype )			/* check type; get value size */
    {
	case SCA_STRING:
	    valsize = MAX_STRING_SIZE;
	    break;

	case SCA_SHORT:
	    valsize = sizeof( short );
	    break;

	case SCA_FLOAT:
	    valsize = sizeof( float );
	    break;

	case SCA_ENUM:
	    valsize = sizeof( short );
	    break;

	case SCA_CHAR:
	    valsize = sizeof( char );
	    break;

	case SCA_LONG:
	    valsize = sizeof( long );
	    break;

	case SCA_DOUBLE:
	    valsize = sizeof( double );
	    break;

	case SCA_INT:
	    valsize = sizeof( long );
	    break;

	default:
	    *pstatus = SCA_BAD_DATA_TYPE + SCA_STATES_IRRELEVANT;
	    return ( SCA_GROUP_CHANNEL *)NULL;
    }

    stat = sca_name_gen( channel_name, scatype, sca_name );
    if ( sca_error( stat ) )
    {
	*pstatus = stat & ~SCA_ALL_STATES_MASK | SCA_STATES_IRRELEVANT;
	return ( SCA_GROUP_CHANNEL *)NULL;
    }

    stat = sca_buildap( channel_name, scatype, nmax, (void *)&ap );
    if ( sca_error( stat ) )
    {
	*pstatus = stat & ~SCA_ALL_STATES_MASK | SCA_STATES_IRRELEVANT;
	return ( SCA_GROUP_CHANNEL *)NULL;
    }

    pchan = ( SCA_GROUP_CHANNEL *) calloc( 1, sizeof( SCA_GROUP_CHANNEL ) );
    pchan->ap = ap;
    pchan->pgroup = pgroup;
    pchan->scatype = scatype;
    pchan->nmax = nmax;
    pchan->valsize = valsize;

    /* Add channel to tail of list */
    ellAdd( pgroup->pchannel_list, &(pchan->node) );
    return pchan;
}

int
group_set_refresh_period( group_name, period )
char *group_name;		/* group name */
double period;			/* new refresh period */
{
    SCA_GROUP *pgroup = find_group( group_name );
    if ( pgroup == ( SCA_GROUP *)NULL )
	return SCA_CANNOT_FIND_GROUP + SCA_STATES_IRRELEVANT;

    if ( period < GROUP_REFRESH_PERIOD_LOWER_LIMIT )
	return SCA_BAD_ARG + SCA_STATES_IRRELEVANT;

    if ( period > GROUP_REFRESH_PERIOD_UPPER_LIMIT)
	return SCA_BAD_ARG + SCA_STATES_IRRELEVANT;

    pgroup->group_refresh_period = period;
    return SCA_NO_ERROR + SCA_STATES_IRRELEVANT;
}

int
group_get_refresh_period( group_name, period )
char *group_name;		/* group name */
double *period;			/* refresh period */
{
    SCA_GROUP *pgroup = find_group( group_name );
    if ( pgroup == ( SCA_GROUP *)NULL )
	return SCA_CANNOT_FIND_GROUP + SCA_STATES_IRRELEVANT;

    *period = pgroup->group_refresh_period;
    return SCA_NO_ERROR + SCA_STATES_IRRELEVANT;
}

int
group_set_do_get_timeout( group_name, timeout )
char *group_name;		/* group name */
double timeout;			/* new do_get timeout */
{
    SCA_GROUP *pgroup = find_group( group_name );
    if ( pgroup == ( SCA_GROUP *)NULL )
	return SCA_CANNOT_FIND_GROUP + SCA_STATES_IRRELEVANT;

    pgroup->do_get_timeout = timeout;
    return SCA_NO_ERROR + SCA_STATES_IRRELEVANT;
}

int
group_get_do_get_timeout( group_name, timeout, time )
char *group_name;		/* group name */
double *timeout;		/* do_get timeout */
double *time;			/* last do_get time */
{
    SCA_GROUP *pgroup = find_group( group_name );
    if ( pgroup == ( SCA_GROUP *)NULL )
	return SCA_CANNOT_FIND_GROUP + SCA_STATES_IRRELEVANT;

    *timeout = pgroup->do_get_timeout;
    *time    = pgroup->do_get_time;
    return SCA_NO_ERROR + SCA_STATES_IRRELEVANT;
}

double
group_get_default_refresh_period ()
{
    return DEFAULT_GROUP_REFRESH_PERIOD;
}

double
group_get_refresh_period_lower_limit()
{
    return GROUP_REFRESH_PERIOD_LOWER_LIMIT;
}

double
group_get_refresh_period_upper_limit()
{
    return GROUP_REFRESH_PERIOD_UPPER_LIMIT;
}

int
group_flushbyname( group_name )
char *group_name;		/* group name */
{
    SCA_GROUP *pgroup = find_group( group_name );
    if ( pgroup == ( SCA_GROUP *)NULL )
	return SCA_CANNOT_FIND_GROUP + SCA_STATES_IRRELEVANT;

    return group_flush( (void *)pgroup );
}

int
group_flush( pgroup )
void *pgroup;			/* pointer to group */
{
    int ca_status;
    int num_channels = 0;
    ELLNODE *pnode;
    double current_time, earliest_flush_time;

    SCA_GROUP *pg = ( SCA_GROUP *)pgroup;
    if ( pg == ( SCA_GROUP *)NULL )
	return SCA_CANNOT_FIND_GROUP + SCA_STATES_IRRELEVANT;

    current_time = sca_gettimeofday();
    earliest_flush_time =
	pg->last_flush_time + GROUP_FLUSH_PERIOD_LOWER_LIMIT;
    if ( earliest_flush_time > current_time )
	ca_status = ca_pend_event(earliest_flush_time - current_time );
    pnode = ellFirst( pg->pchannel_list );
    while( pnode != ( ELLNODE *)NULL )
    {
	int stat;
	SCA_GROUP_CHANNEL *pchan = ( SCA_GROUP_CHANNEL *)pnode;
	if ( pchan->pputvalue != ( void *)NULL )
	{
	    stat = que_put(	(pchan->ap)->name,
				pchan->scatype,
				pchan->nmax,
				pchan->pputvalue,
				&(pchan->putstatus) );
	}
	if ( sca_no_error( stat ) )
	    ++num_channels; 
	pnode = ellNext( pnode );
    }

    pg->demand_flush = 0;
    pg->demand_refresh = 1;
    pg->last_flush_time = current_time;
    if ( num_channels > 0 )
    {
	/* set min time between do puts very small so that flush period
	** controls the timing.  Likewise, do_put() waits only that long.
	*/
	double cur_min_time_between_do_puts = get_min_time_between_do_puts();
	int num_errors;   

	set_min_time_between_do_puts( 1.0e-12 );

	current_time = sca_gettimeofday();

	num_errors = do_put( pg->do_put_timeout );   

	pg->last_flush_time = sca_gettimeofday();
	pg->do_put_time = pg->last_flush_time - current_time;
	set_min_time_between_do_puts( cur_min_time_between_do_puts );
	++(pg->num_flushes);
	if ( num_errors != 0 )
	{
	    return SCA_GROUP_FLUSH_INCOMPLETE + SCA_STATES_IRRELEVANT;
	}
    }
    return SCA_NO_ERROR + SCA_STATES_IRRELEVANT;
}

int
group_set_do_put_timeout( group_name, timeout )
char *group_name;		/* group name */
double timeout;			/* new do_put timeout */
{
    SCA_GROUP *pgroup = find_group( group_name );
    if ( pgroup == ( SCA_GROUP *)NULL )
	return SCA_CANNOT_FIND_GROUP + SCA_STATES_IRRELEVANT;

    pgroup->do_put_timeout = timeout;
    return SCA_NO_ERROR + SCA_STATES_IRRELEVANT;
}

int
group_get_do_put_timeout( group_name, timeout, time )
char *group_name;		/* group name */
double *timeout;		/* do_put timeout */
double *time;			/* last do_put time */
{
    SCA_GROUP *pgroup = find_group( group_name );
    if ( pgroup == ( SCA_GROUP *)NULL )
	return SCA_CANNOT_FIND_GROUP + SCA_STATES_IRRELEVANT;

    *timeout = pgroup->do_put_timeout;
    *time    = pgroup->do_put_time;
    return SCA_NO_ERROR + SCA_STATES_IRRELEVANT;
}

int
group_putchannelbyname(
	group_name, channel_name, scatype, nelm, psrc, pstatus )
char *group_name;		/* group name */
char *channel_name;		/* pvname[.fieldname] */
int scatype;			/* data type, e.g. SCA_STRING */
int nelm;			/* number of channel values to return */
void *psrc;			/* where to find channel values for put */
int *pstatus;			/* where to return channel status */
{
    int i, stat;
    double cur_time;
    SCA_GROUP_CHANNEL *pchan;
    SCA_GROUP *pgroup;

    if ( ( pgroup = findc_group( group_name ) ) == ( SCA_GROUP *)NULL )
	return SCA_CANNOT_FIND_GROUP + SCA_STATES_IRRELEVANT;
 
    pchan = findc_channel_in_group( pgroup, channel_name, scatype, nelm, &stat);
    if ( pchan == ( SCA_GROUP_CHANNEL *)NULL )
	return stat;
    return group_putchannel( pchan, nelm, psrc, pstatus );
}

int
group_putchannel(pchan, nelm, psrc, pstatus )
void *pchan;			/* pointer to channel */
int nelm;			/* number of channel values to set */
void *psrc;			/* where to find channel values for put */
int *pstatus;			/* where to return channel status */
{
    int i, stat;
    double cur_time;
    SCA_GROUP *pg;
    SCA_GROUP_CHANNEL *pc = ( SCA_GROUP_CHANNEL *)pchan;
 
    if ( pc == ( SCA_GROUP_CHANNEL *)NULL )
	return SCA_CANNOT_FIND_CHANNEL + SCA_STATES_IRRELEVANT;

    pg = pc->pgroup;
    if ( pg == ( SCA_GROUP *)NULL )
	return SCA_CANNOT_FIND_GROUP + SCA_STATES_IRRELEVANT;
    if ( pc->pputvalue == ( void *)NULL )
    {
	pc->pputvalue = calloc( pc->nmax, pc->valsize );
	if ( pc->pputvalue == ( void *)NULL )
	{
	    pc->status = SCA_CANNOT_MALLOC + SCA_STATES_IRRELEVANT;
	    *pstatus = pc->status;
	    return SCA_CANNOT_MALLOC + SCA_STATES_IRRELEVANT;
	}
    }

    if ( nelm > pc->nmax )
	nelm = pc->nmax;
    bcopy(  (char*)psrc, (char*)(pc->pputvalue), (pc->valsize) * nelm );

    (pc->pgroup)->pcurrent = pc;

    pc->status = SCA_NO_ERROR + SCA_STATES_IRRELEVANT;
    *pstatus = pc->status;
    return pc->status;
}

int
group_getchannelstatusbyname( group_name, channel_name, scatype,
				getstatus, putstatus )
char *group_name;		/* group name */
char *channel_name;		/* pvname[.fieldname] */
int scatype;			/* data type, e.g. SCA_STRING */
int *getstatus;			/* where to return status of last get */
int *putstatus;			/* where to return status of last put */
{
    int i, stat;
    SCA_GROUP_CHANNEL *pc;
    SCA_GROUP *pgroup;

    if ( ( pgroup = find_group( group_name ) ) == ( SCA_GROUP *)NULL )
	return SCA_CANNOT_FIND_GROUP + SCA_STATES_IRRELEVANT;
 
    pc = find_channel_in_group( pgroup, channel_name, scatype );
    if ( pc == ( SCA_GROUP_CHANNEL *)NULL )
	return SCA_CANNOT_FIND_CHANNEL + SCA_STATES_IRRELEVANT;

    *getstatus = pc->status;
    *putstatus = pc->putstatus;
    return SCA_NO_ERROR + SCA_STATES_IRRELEVANT;
}

int
group_getchannelstatus(pchan, getstatus, putstatus )
void *pchan;			/* pointer to channel */
int *getstatus;			/* where to return status of last get */
int *putstatus;			/* where to return status of last put */
{
    int i, stat;
    double cur_time;
    SCA_GROUP_CHANNEL *pc = ( SCA_GROUP_CHANNEL *)pchan;
 
    if ( pc == ( SCA_GROUP_CHANNEL *)NULL )
	return SCA_CANNOT_FIND_CHANNEL + SCA_STATES_IRRELEVANT;

    *getstatus = pc->status;
    *putstatus = pc->putstatus;
    return SCA_NO_ERROR + SCA_STATES_IRRELEVANT;
}

/* functions for event logging */
int
sca_event_log_enable( void *buf, int *buf_size, int *counter )
{
    event_buf = ( SINGLE_EVENT *)buf;
    event_buf_size = buf_size;
    event_counter = counter;
    return 0;
}

int
sca_event_log_disable()
{
    event_buf = ( SINGLE_EVENT *)NULL;
    return 0;
}

