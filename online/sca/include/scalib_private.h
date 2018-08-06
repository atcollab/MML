/*#include "scalib.h"*/
/* ALS Simple Channel Access Header */

/* change log */
/*
date	by	description
----	--	-----------
*/


#ifndef INCscaprivateh
#define INCscaprivateh

#ifdef __cplusplus
extern "C" {
#endif

#ifdef WIN32
#define cfree free
#define bcopy(s,d,len) memcpy(d,s,(size_t)len)
#define scaCall __stdcall
#ifdef _SCADLL
#define scaEntry __declspec(dllexport)
#else
#define scaEntry __declspec(dllimport)
#endif
#else
#define scaEntry
#define scaCall 
#endif

#include "scalib_shared.h"

#define sca_valid_acb( ap )	(ap->validation_code == AP_VALIDATION_CODE )
#define sca_invalid_acb( ap )	(ap->validation_code != AP_VALIDATION_CODE )

#define form_status( error, ap )\
	( error + ap->connection_state + ap->monitor_state + ap->value_state )

#define qget_form_status( error, ap )\
	( error + ap->connection_state + ap->monitor_state +\
	  ap->q_get_value_state )

#define qput_form_status( error, ap )\
	( error + ap->connection_state + ap->monitor_state +\
	  ap->q_put_value_state )

/*
** States of get_q and put_q.
**
**	Initially there is no queue - SCA_NO_Q.
**	A que_get/put() when SCA_NO_Q, creates the queue, adds 1 get/put and
**      sets - SCA_Q_OPEN.
**	A que_get/put() when SCA_Q_OPEN, adds to the queue.
**	A que_get/put() when SCA_Q_CLOSED, clears the queue, adds 1 get/put and
**	sets SCA_Q_OPEN.
**	do_get/put() when SCA_Q_OPEN, closes the queue - SCA_Q_CLOSED and
**	does the gets/puts.
*/
#define SCA_NO_Q		0
#define SCA_Q_OPEN		1
#define SCA_Q_CLOSED		2

/*
** Q_ITEM - a u_long in which most significant 4 bits are a code number and
** the least significant 28 bits are index of acb in acb_table.
*/
#define GET_Q_INC	256
#define PUT_Q_INC	256
typedef unsigned long Q_ITEM;
typedef unsigned long CALLBACK_CODE;
typedef unsigned long AP_INDEX;

#define CALLBACK_CODE_MASK      ( ( unsigned long )0xf0000000 )
#define CALLBACK_CODE_INC       ( ( unsigned long )0x10000000 )
#define AP_INDEX_MASK           ( ( unsigned long )0x0fffffff )

#define MAX_SEARCH_PEND_CYCLES		10
#define MAX_DO_GET_PEND_CYCLES		300
#define MAX_DO_PUT_PEND_CYCLES		300
#define MIN_TIME_BETWEEN_DO_GETS        ((double).050 ) /* sec */
#define MIN_TIME_BETWEEN_DO_PUTS        ((double).050 ) /* sec */
#define DEFAULT_SEARCH_PEND_TIME	((float).1 )   /* sec */
#define DEFAULT_DO_GET_PEND_TIME	((float).1 )   /* sec */
#define DEFAULT_DO_PUT_PEND_TIME	((float).1 )   /* sec */
#define AP_TABLE_INC	256

/*
    options is form in which caller wants SCAget to return the value(s) or
	    form in which caller is supplying value(s) to SCAput
*/
#define SCA_EXTENSION_SZ 4      /* SCA name extension, including period(.)*/
				/* Hashed name is pvname.field.ext   */
#define SCA_TYPE_SZ     12      /* Max size of scatype name string   */

#define SCA_NAME_SIZE \
	(SCA_PVNAME_SZ + SCA_FLDNAME_SZ + SCA_EXTENSION_SZ )

#define SCA_NAME_STRING_SIZE	( SCA_NAME_SIZE + 1 )
						/* + 1 NULL string terminator */

#define SCA_MIN_TIME_BETWEEN_TRY_HARDS		((double).250)	/* sec */
#define SCA_TRY_HARD_MAXTIME			((double)4.0 )	/* sec */
#define SCA_TRY_HARD_PEND_TIME			((float).10 )	/* sec */
#define SCA_QUICK_PEND				((float)1.0e-12) /* sec */
#define MIN_SMART_PEND_INTERVAL			((float)0.101)  /* sec */
#define SCA_PUT_PEND_TIMEOUT			((float)0.500)  /* sec */

#define SCA_MONITOR_LIFETIME	( (double)( 5 * 60 ) ) /* sec */

#define AP_VALIDATION_CODE	0x1a2b3c4d
#define SCA_SKIP_FLUSH ((unsigned long )0x00000001)

/*
ALIAS_ACB must exactly reflect the beginning of the ACCELERATION_CONTROL_BLOCK
*/
#define ACB_COMMON	\
    int validation_code;		/* ap validation code		*/\
    void *next_ap;			/* forward link to next ap	*/\
    int acb_index;			/* index into acb_table		*/\
    void *real_acb;			/* pointer to real control block*/\
    char sca_name[SCA_NAME_STRING_SIZE];  /* name with scatype		*/\
    char name[SCA_EPICS_NAME_STRING_SIZE];/* name without scatype	*/

typedef struct
{
    ACB_COMMON
}ALIAS_ACB;

typedef struct
{
    ACB_COMMON
    int scatype;			/*     SCA_STRING, ...               */
    int nmax;				/*     max elements in value         */
					/*         1 except for waveforms    */
    unsigned long options;

					/* get/put call arguments */

    short alarm_severity;		/*     of value pointed to by buff */
    short alarm_status;			/*     of value pointed to by buff */
    void *buff;				/*     ptr to caller/s value buffer */
    int n;				/*     count */
    int ofs;				/*     offset into get/put buffer */
    union db_access_val *pmonitor;	/*     get buffer for ca  */
    int monitor_ca_status;		/*     last CA status from handler */


					/*     ptr to get/put buffers */
    void *pcontrol;			/*     put buffer for ca  */


    unsigned long num_gets;		/*     number of get calls */
    unsigned long num_get_errors;	/*     number of get errors */
    unsigned long num_puts;		/*     number of put calls */
    unsigned long num_put_errors;	/*     number of put errors */

    unsigned long num_monitor_values;	/*     number of monitor updates  */
    unsigned long num_fresh_on_fresh;	/*     number of fresh after fresh */
    unsigned long num_fresh_on_stale;	/*     number of fresh after stale */
    unsigned long num_fresh_on_no_value;/*     number of fresh after no value */

    unsigned long monitor_values;	/*     number of monitor updates  */
    unsigned long fresh_on_fresh;	/*     number of fresh after fresh */
    unsigned long fresh_on_stale;	/*     number of fresh after stale */
    unsigned long fresh_on_no_value;	/*     number of fresh after no value */

    unsigned long num_monitor_changes;	/*     num monitor state changes */
    unsigned long num_monitor_problems;	/*     number of monitor problems */
    unsigned long num_conn_changes;	/*     num connection state changes */

    double last_get_time;		/*     from host  */
    double last_put_time;		/*     from host  */
    double last_monitor_time;		/*     from host  */
    double last_conn_state_time;	/*     from host  */
    double try_hard_timer;		/*     duration of last try hard */

    chtype dtype;			/* DBR_... type derived from scatype*/
    chid channel_id;			/* chid from search */
    evid event_id;			/* from ca_array_add_event() */

    int connection_state;		/* from connection handler */
    int monitor_state;			/* from event handler */
    int value_state;			/* from event handler */

					/* que_get call arguments */

    unsigned long q_get_n;		/*     count */
    void *q_get_pdest;			/*     ptr to caller's dest buffer */
    int *q_get_pstatus;			/*     ptr to caller's return status */
    int q_get_value_state;		/*     from callback handler */
    unsigned long q_get_ofs;		/*     offset into get buffer */
    union db_access_val *q_get_pmonitor;/*     que_get buffer for ca  */
    short q_get_alarm_severity;		/*     of value pointed to by pmonitor*/
    short q_get_alarm_status;		/*     of value pointed to by pmonitor*/
    double last_do_get_time;		/*     time of last do_get */
    CALLBACK_CODE get_callback_code;	/*     callback_code from last do_get */
    CALLBACK_CODE get_callback_code_h;	/*     callback_code from handler */
    int get_callback_ca_status;		/*     last CA status from handler */
    unsigned long missing_get_callbacks;/*     missed callbacks */
    unsigned long ignored_get_callbacks;/*     callback code mismatch, ignored*/

    unsigned long num_que_gets;		/*     number of que_get calls */
    unsigned long num_que_get_errors;	/*     number of que_get errors */

    double last_que_get_time;		/*     from host  */

					/* que_put call arguments */

    unsigned long q_put_n;		/*     count */
    void *q_put_psrc;			/*     ptr to caller's src buffer */
    int *q_put_pstatus;			/*     ptr to caller's return status */
    int q_put_value_state;              /*     FRESH:callback received NO: not*/
    unsigned long q_put_ofs;		/*     offset into src buffer */
    void *q_put_pcontrol;		/*     put buffer for ca  */
    short q_put_alarm_severity;		/*     of value pointed to by pmonitor*/
    short q_put_alarm_status;		/*     of value pointed to by pmonitor*/
    double last_do_put_time;		/*     time of last do_put */
    CALLBACK_CODE put_callback_code;	/*     callback_code from last do_put */
    CALLBACK_CODE put_callback_code_h;	/*     callback_code from handler */
    int put_callback_ca_status;		/*     last CA status from handler */
    unsigned long missing_put_callbacks;/*     missed callbacks */
    unsigned long ignored_put_callbacks;/*     callback code mismatch, ignored*/

    unsigned long num_que_puts;		/*     number of que_put calls */
    unsigned long num_que_put_errors;	/*     number of que_put errors */

    double last_que_put_time;		/*     from host  */

}ACCELERATION_CONTROL_BLOCK;

struct sca_group
{
    ELLNODE node;
    char group_name[SCA_NAME_STRING_SIZE];
    double last_refresh_time;
    double group_refresh_period;
    double do_get_timeout;
    double do_get_time;
    int demand_refresh;
    int num_refreshes;
    struct sca_group_channel *pcurrent;	/* for stepping thru channels */
    ELLLIST *pchannel_list;
};

struct sca_group_channel
{
    ELLNODE node;
    ACCELERATION_CONTROL_BLOCK *ap;
    struct sca_group *pgroup;		/* group to which channel belongs */
    int scatype;
    int nmax;
    int valsize;		/* length of value(s) in cache */
    void *pvalue;		/* where SCA caches value(s)  */
    int status;			/* where SCA caches status */
    void *pdest;		/* where caller wants get status */
    void *pstatus;
};

typedef struct sca_group SCA_GROUP;
typedef struct sca_group_channel SCA_GROUP_CHANNEL;

#define DEFAULT_GROUP_REFRESH_PERIOD		0.500   /* sec */
#define GROUP_REFRESH_PERIOD_LOWER_LIMIT	0.100	/* sec */
#define GROUP_REFRESH_PERIOD_UPPER_LIMIT	3600.	/* sec */

#if defined(WIN32) || defined(__STDC__) 

/* LOCAL routines */

ACCELERATION_CONTROL_BLOCK *
find_ap( char *sca_name );

void *
sca_find_ap( char *sca_name );

int
sca_find_index( char *name, int scatype );

ACCELERATION_CONTROL_BLOCK *
findc_ap( char *sca_name );

void *
sca_findc_ap( char *sca_name );

ACCELERATION_CONTROL_BLOCK *
find_firstap();

ACCELERATION_CONTROL_BLOCK *
find_nextap();

void *
sca_find_nextap();

void *
sca_find_firstap();

int
cache_goto_active( ACCELERATION_CONTROL_BLOCK *ap );     

int
cache_goto_standby( ACCELERATION_CONTROL_BLOCK *ap );     

int
cache_try_hard_for_value( ACCELERATION_CONTROL_BLOCK *ap );

int
scatodbr( int scatype, chtype *dtype );

int
sca_name_gen( 
	char *name,
	int scatype,
	char *sca_name);

int
cache_try_hard_for_connection( ACCELERATION_CONTROL_BLOCK *ap );

int
cache_pend( double current_time );

int
cache_smart_pend();

int
add_to_ap_table( ACCELERATION_CONTROL_BLOCK *ap );

int
add_to_get_q( 
	ACCELERATION_CONTROL_BLOCK *ap,
	int n,
	void *pdest,
	int *pstatus );

int
add_to_put_q(
	ACCELERATION_CONTROL_BLOCK *ap,
	int n,
	void *psrc,
	int *pstatus );

void
cacheEventHandler( struct event_handler_args arg );

void
que_get_callback_handler( struct event_handler_args arg );

void
que_put_callback_handler( struct event_handler_args arg );

void
scaConnHand(struct connection_handler_args arg );

SCA_GROUP *
find_group( char *group_name );

SCA_GROUP *
findc_group( char *group_name );

SCA_GROUP_CHANNEL *
find_channel_in_group( SCA_GROUP *pgroup,
		char *channel_name, int scatype );

SCA_GROUP_CHANNEL *
findc_channel_in_group( SCA_GROUP *pgroup,
		char *channel_name, int scatype, int nmax, int *pstatus );

int
print_group( SCA_GROUP *pgroup );

#endif

#ifdef __cplusplus
}
#endif

#endif 	/* INCscaprivateh */

