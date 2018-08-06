/*#include "scalib.h"*/
/* ALS Simple Channel Access Header */

/* change log */
/*
date	by	description
----	--	-----------
*/

#ifndef INCscah
#define INCscah

#ifdef __cplusplus
extern "C" {
#endif

#ifdef WIN32
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

#if defined(WIN32) || defined(__STDC__) 


/* -------------------- SCA III calls -------------------- */

scaEntry int scaCall
que_get( 
    char *name,			/* fieldname */
    int scatype,		/* data type, e.g. SCA_STRING */
    int n, 			/* number of data elements */
    void *pdest,		/* Pointer to array to receive data */
    int *pstatus);		/* Pointer to int to receive status */

scaEntry int scaCall
que_getbyindex( 
    int index,			/* index from  sca_find_index() */
    int n, 			/* number of data elements */
    void *pdest,		/* Pointer to array to receive data */
    int *pstatus);		/* Pointer to int to receive status */

scaEntry int scaCall
do_get( double timeout );

scaEntry int scaCall
do_getbyname( 
    char *name,        		/* fieldname */
    int scatype,                /* data type, e.g. SCA_STRING */
    int n,                      /* number of data elements */
    void *pdest,                /* Pointer to array to receive data */
    int *pstatus);              /* Pointer to int to receive status */

scaEntry int scaCall
do_putbyname( 
    char *name,        		/* fieldname */
    int scatype,                /* data type, e.g. SCA_STRING */
    int n,                      /* number of data elements */
    void *psrc,                 /* Pointer to array containing data */
    int *pstatus);              /* Pointer to int to receive status */

scaEntry int scaCall
do_getbyindex( 
    int index,			/* index from  sca_find_index() */
    int n,                      /* number of data elements */
    void *pdest,                /* Pointer to array to receive data */
    int *pstatus);              /* Pointer to int to receive status */

scaEntry int scaCall
que_put( 
    char *name,      		/* fieldname */
    int scatype,                /* data type, e.g. SCA_STRING */
    int n,                      /* number of data elements */
    void *psrc,                 /* Pointer to array containing data */
    int *pstatus);              /* Pointer to int to receive status */

scaEntry int scaCall
que_putbyindex( 
    int index,                	/* index from  sca_find_index() */
    int n,                      /* number of data elements */
    void *psrc,                 /* Pointer to array containing data */
    int *pstatus);              /* Pointer to int to receive status */

scaEntry int scaCall
do_put( double timeout );

scaEntry int scaCall
do_putbyindex(
    int index,                	/* index from  sca_find_index() */
    int n,                      /* number of data elements */
    void *psrc,                 /* Pointer to array containing data */
    int *pstatus);              /* Pointer to int to receive status */

scaEntry int scaCall
set_min_time_between_do_gets( double time );

scaEntry int scaCall
set_min_time_between_do_puts( double time );

scaEntry double scaCall
get_min_time_between_do_gets();

scaEntry double scaCall
get_min_time_between_do_puts();

scaEntry int scaCall
group_addchannel(
    char *group_name,		/* group name */
    char *channel_name,		/* channel name */
    int scatype,		/* data type, e.g. SCA_STRING */
    int nmax,			/* number of data elements */
    void **ppgroup,		/* returns pointer to group */
    void **ppchan );		/* returns pointer to channel */

scaEntry int scaCall
group_removechannelbyname(
    char *group_name,		/* group name */
    char *channel_name,		/* channel name */
    int scatype );		/* data type, e.g. SCA_STRING */

scaEntry int scaCall
group_removechannel( void *pchan );	/* pointer to channel */

scaEntry int scaCall
group_freebyname( char *group_name );	/* group name */

scaEntry int scaCall
group_free( void *pgroup );	/* pointer to group */

scaEntry int scaCall
group_refreshbyname( char *group_name );	/* group name */

scaEntry int scaCall
group_refresh( void *pgroup );	/* pointer to group */

scaEntry int scaCall
group_getchannelbyname(
    char *group_name,		/* group name */
    char *channel_name,		/* channel name */
    int scatype,		/* data type, e.g. SCA_STRING */
    int nelm,			/* number of data elements */
    void *pdest,		/* returns value(s) */
    int *pstatus );		/* returns status */

scaEntry int scaCall
group_getchannel(
    void *pchan,		/* pointer to channel */
    int nelm,			/* number of data elements */
    void *pdest,		/* returns value(s) */
    int *pstatus );		/* returns status */

scaEntry int scaCall
group_printbyname( char *group_name );

scaEntry int scaCall
group_print( void *pgroup );

scaEntry int scaCall
groups_print( int first_group, int num_wanted );

scaEntry int scaCall
group_set_refresh_period( char *group_name, double period );

scaEntry int scaCall
group_get_refresh_period( char *group_name, double *period );

scaEntry double scaCall
group_get_refresh_period_lower_limit();

scaEntry double scaCall
group_get_refresh_period_upper_limit();

scaEntry double scaCall
group_get_default_refresh_period();

scaEntry int scaCall
group_set_do_get_timeout( char *group_name, double timeout );

scaEntry int scaCall
group_get_do_get_timeout( char *group_name, double *timeout, double *time );

scaEntry int scaCall
group_getnextchannelbyname(
char *group_name,		/* group name */
int nelm,			/* number of channel values to return */
void *pdest,			/* where to return channel values */
int *pstatus			/* where to return channel status */
);

scaEntry int scaCall
group_getfirstchannelbyname( 
char *group_name,		/* group name */
int nelm,			/* number of channel values to return */
void *pdest,			/* where to return channel values */
int *pstatus );	

scaEntry int scaCall
sca_setup_aliases( 
char *filename,			/* name of file containing alias definitions */
double timeout );		/* number of seconds to wait for connections */

/* -------------------- SCA II calls -------------------- */

scaEntry int scaCall
cache_set(
    char *name,			/* field name */
    int scatype,		/* data type, e.g. SCA_STRING */
    int nmax,                   /* max number of data elements */
    void **pap );

scaEntry int scaCall
cache_get( 
    void *ap,                  /* acceleration block pointer */
    void *dest_ptr,            /* Pointer to array to receive data */
    int n );                   /* number of data elements */

scaEntry int scaCall
cache_getbyname(
    char *name,                /* fieldname */
    int scatype,               /* data type, e.g. SCA_STRING */
    void *dest_ptr,            /* Pointer to array to receive data */
    int n);                    /* number of data elements */

scaEntry int scaCall
cache_put( 
    void *ap,                  /* acceleration block pointer */
    void *src_ptr,             /* Pointer to array with data */
    int n);                    /* number of data elements */

scaEntry int scaCall
cache_putbyname(
    char *name,                /* fieldname */
    int scatype,               /* data type, e.g. SCA_STRING */
    void *src_ptr,             /* Pointer to array with data */
    int n);                    /* number of data elements */

scaEntry int scaCall
set_noflush_after_cache_put( 
    void *ap );                /* acceleration block pointer */

scaEntry int scaCall
clear_noflush_after_cache_put( 
    void *ap );                /* acceleration block pointer */

/* -------------------- SCA II Backward Compatible Calls -------------------- */

scaEntry int scaCall 
sca_getap( char *name, int scatype, int nmax, void **pap);

scaEntry int scaCall
sca_get( void *ap, void *dest_ptr, int n);

scaEntry int scaCall
sca_getbyname( char *name, int scatype, void *dest_ptr,int n); 

scaEntry int scaCall
sca_put( void *ap, void *src_ptr, int n);  

scaEntry int scaCall
sca_putbyname( char *name, int scatype, void *src_ptr, int n);

/* -------------------- SCA I Backward Compatible Calls -------------------- */

scaEntry void *scaCall
SCAap();

scaEntry void 
SCAFree(void *ap);

scaEntry int scaCall
SCAget(
	char *name,			/*field name */
	void *ap,			/* ignored   */
	int af,				/* ignored   */
	int type,                       /* data sca type, e.g. SCA_DOUBLE */
	int n,				/* number of data elements */
	void *dest_ptr);                 /* Pointer to array to receive data */

scaEntry int scaCall
SCAput(
	char *name,			/*field name */
	void *ap,			/* ignored   */
	int af,				/* ignored   */
	int type,                       /* data sca type, e.g. SCA_DOUBLE */
	int n,				/* number of data elements */
	void *src_ptr);                  /* Pointer to values to put */

/* -------------------- COMMON Support Calls -------------------- */


scaEntry double scaCall
sca_gettimeofday();

scaEntry int scaCall
sca_pend_event( double pend_time );

scaEntry int scaCall
sca_sleep( int delay_in_msec, int max_delay_in_msec );

scaEntry int scaCall
sca_buildap(
	char *name,		/* field name */
	int scatype,		/* data type, e.g. SCA_STRING */
	int nmax,		/* max number of data elements */
	void **pap);

scaEntry int scaCall
sca_getnamebyindex(
	int index,		/* index into ap_table */
	char *name);		/* field name */

scaEntry void * scaCall
sca_findc_ap( char *name );

scaEntry void * scaCall
sca_find_ap( char *name );

scaEntry int scaCall
sca_find_index( char *name, int scatype );

scaEntry void * scaCall
sca_find_firstap();

scaEntry void * scaCall
sca_find_nextap();

scaEntry int scaCall
sca_get_hash_table_size();

scaEntry int scaCall
sca_set_hash_table_size();

/* -------------------- DIAGNOSTIC Calls -------------------- */

scaEntry int scaCall
print_ap( void  *ap) ;

scaEntry int scaCall
print_aps();

scaEntry int scaCall
print_value( void *ap );

scaEntry int scaCall
print_global_stats();

scaEntry int scaCall
print_defaults();

scaEntry int scaCall
print_sca_status_str( char * str, int status );

scaEntry int scaCall
print_sca_status( int status );

scaEntry int scaCall
sca_hashcheck();

scaEntry int scaCall
sca_hashdepth();

scaEntry int scaCall
sca_hashhist();

scaEntry int scaCall
sca_hashdump();

scaEntry int scaCall
sca_release();

#else

/* -------------------- SCA III calls -------------------- */

extern int que_get();
extern int do_get();
extern int do_getbyname();
extern int que_put();
extern int do_put();
extern int do_putbyname();
extern int set_min_time_between_do_gets();
extern int set_min_time_between_do_puts();
extern double get_min_time_between_do_gets();
extern double get_min_time_between_do_puts();

extern int group_addchannel();
extern int group_removechannelbyname();
extern int group_removechannel();
extern int group_freebyname();
extern int group_free();
extern int group_refreshbyname();
extern int group_refresh();
extern int group_getchannelbyname();
extern int group_getchannel();
extern int group_printbyname();
extern int group_print();
extern int groups_print();
extern int group_set_refresh_period();
extern int group_get_refresh_period();
extern double group_get_refresh_period_lower_limit();
extern double group_get_refresh_period_upper_limit();
extern double group_get_default_refresh_period();
extern int group_set_do_get_timeout();
extern int group_get_do_get_timeout();

/* -------------------- SCA II calls -------------------- */

extern int cache_set();
extern int cache_get();
extern int cache_getbyname();
extern int cache_put();
extern int cache_putbyname();
extern int set_noflush_after_cache_put();
extern int clear_noflush_after_cache_put();

/* -------------------- SCA II Backward Compatible Calls -------------------- */

extern int sca_getap();
extern int sca_get();
extern int sca_getbyname();
extern int sca_put();
extern int sca_putbyname();

/* -------------------- SCA I Backward Compatible Calls -------------------- */

void *SCAap();
void SCAFree();
extern int SCAget();
extern int SCAput();

/* -------------------- COMMON Support Calls -------------------- */

extern double sca_gettimeofday();
extern int sca_pend_event();
extern int sca_sleep();
extern int sca_buildap();
extern int sca_getnamebyindex();
extern void *sca_findc_ap();
extern void *sca_find_ap();
extern int sca_find_index();
extern void *sca_find_firstap();
extern void *sca_find_nextap();
extern int sca_get_hash_table_size();
extern int sca_set_hash_table_size();

/* -------------------- DIAGNOSTIC Calls -------------------- */

extern int print_ap();
extern int print_aps();
extern int print_value();
extern int print_global_stats();
extern int print_defaults();
extern int print_sca_status();

extern int sca_hashcheck();
extern int sca_hashdepth();
extern int sca_hashhist();
extern int sca_hashdump();
extern int sca_release();
#endif

#ifdef __cplusplus
}
#endif

#endif 	/* INCscah */

