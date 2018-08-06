/*#include "scalib.h"*/
/* ALS Simple Channel Access Header */

/* change log */
/*
date	by	description
----	--	-----------
*/


#ifndef INCscasharedh
#define INCscasharedh

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

/* SCA I only defines */
#define SCA_SYNCHRONOUS_ACCESS  0
#define SCA_ASYNCHRONOUS_ACCESS 1
#define SCA_MONITOR_ACCESS      2
/* end SCA I only defines */

/*
   status returned by SCAget and SCAput is number of values
   successfully returned by SCAget or sent by SCAput or one of the
   following if an error occurred
*/

#define SCA_NO_ERROR				(  0 << 16 )

#define SCA_CANNOT_FIND_NAME			(  1 << 16 )
#define SCA_BAD_NAME_SIZE                       (  2 << 16 )
#define SCA_BAD_DATA_TYPE			(  3 << 16 )
#define SCA_NO_ACB			 	(  4 << 16 )
#define SCA_BAD_ACB				(  5 << 16 )
#define SCA_BAD_CHID                       	(  6 << 16 )
#define SCA_INTERNAL_ERROR                 	(  7 << 16 )

#define SCA_CANNOT_SEARCH			(  8 << 16 )
#define SCA_CANNOT_MALLOC			(  9 << 16 )
#define SCA_CANNOT_CREATE_MONITOR		( 10 << 16 )

#define SCA_CANNOT_PEND				( 11 << 16 )
#define SCA_CANNOT_PUT 				( 12 << 16 )
#define SCA_CANNOT_GET 				( 13 << 16 )

#define SCA_BAD_ARG 				( 14 << 16 )

#define SCA_CANNOT_FIND_GROUP			( 15 << 16 )
#define SCA_CANNOT_FIND_CHANNEL			( 16 << 16 )
#define SCA_GROUP_REFRESH_INCOMPLETE		( 17 << 16 )

#define SCA_NO_CALLBACK				( 18 << 16 )

#define SCA_ERROR_MASK				( 63 << 16 )	/* 0x3f */

/*
    sca connection states
*/
 
#define SCA_CONNECTED           		(  0 <<  8 )
#define SCA_DISCONNECTED			(  1 <<  8 )
#define SCA_NEVER_CONNECTED			(  2 <<  8 )
#define SCA_CONNECTION_STATE_IRRELEVANT		( 14 <<  8 )
#define SCA_NO_CONNECTION_STATE			( 15 <<  8 )

#define SCA_CONN_STATE_MASK			( 15 <<  8 )	/* 0xf00 */

/*
    sca monitor states
*/
 
#define SCA_MONITOR_ACTIVE			(  0 <<  4 )
#define SCA_MONITOR_ON_STANDBY			(  1 <<  4 )
#define SCA_NEVER_MONITORED			(  2 <<  4 )
#define SCA_MONITOR_CORRUPTED			(  3 <<  4 )
#define SCA_MONITOR_STATE_IRRELEVANT		( 14 <<  4 )
#define SCA_NO_MONITOR_STATE			( 15 <<  4 )

#define SCA_MON_STATE_MASK			( 15 <<  4 )	/* 0xf0 */

/*
    sca value states
*/
 
#define SCA_FRESH_VALUE				   0
#define SCA_OLD_VALUE				   1
#define SCA_NO_VALUE				   2
#define SCA_VALUE_STATE_IRRELEVANT		  14
#define SCA_NO_VALUE_STATE			  15
 
#define SCA_VAL_STATE_MASK			  15		/* 0xf */

#define SCA_NO_AP\
	(SCA_NO_CONNECTION_STATE + SCA_NO_MONITOR_STATE + SCA_NO_VALUE_STATE)

#define SCA_ALL_STATES_MASK\
	(SCA_CONN_STATE_MASK + SCA_MON_STATE_MASK + SCA_VAL_STATE_MASK)

#define SCA_STATES_IRRELEVANT\
	(SCA_CONNECTION_STATE_IRRELEVANT + SCA_MONITOR_STATE_IRRELEVANT +\
	SCA_VALUE_STATE_IRRELEVANT)

#define sca_error( status )\
		( status & SCA_ERROR_MASK )
#define sca_no_error( status )\
		( ( status & SCA_ERROR_MASK ) == 0 )

#define sca_connected( status )\
		( ( status & SCA_CONN_STATE_MASK ) == SCA_CONNECTED )
#define sca_not_connected( status )\
		( ( status & SCA_CONN_STATE_MASK ) != SCA_CONNECTED )
#define sca_disconnected( status )\
		( ( status & SCA_CONN_STATE_MASK ) == SCA_DISCONNECTED )
#define sca_never_connected( status )\
		( ( status & SCA_CONN_STATE_MASK ) == SCA_NEVER_CONNECTED )
#define sca_connection_state_irrelevant( status )\
	( ( status & SCA_CONN_STATE_MASK ) == SCA_CONNECTION_STATE_IRRELEVANT )
#define sca_no_connection_state( status )\
		( ( status & SCA_CONN_STATE_MASK ) == SCA_NO_CONNECTION_STATE )

#define sca_monitor_active( status )\
		( ( status & SCA_MON_STATE_MASK ) == SCA_MONITOR_ACTIVE )
#define sca_monitor_on_standby( status )\
		( ( status & SCA_MON_STATE_MASK ) == SCA_MONITOR_ON_STANDBY )
#define sca_never_monitored( status )\
		( ( status & SCA_MON_STATE_MASK ) == SCA_NEVER_MONITORED )
#define sca_monitor_corrupted( status )\
		( ( status & SCA_MON_STATE_MASK ) == SCA_MONITOR_CORRUPTED )
#define sca_monitor_state_irrelevant( status )\
	( ( status & SCA_MON_STATE_MASK ) == SCA_MONITOR_STATE_IRRELEVANT )
#define sca_no_monitor_state( status )\
		( ( status & SCA_MON_STATE_MASK ) == SCA_NO_MONITOR_STATE )

#define sca_fresh_value( status )\
		( ( status & SCA_VAL_STATE_MASK ) == SCA_FRESH_VALUE )
#define sca_old_value( status )\
		( ( status & SCA_VAL_STATE_MASK ) == SCA_OLD_VALUE )
#define sca_no_value( status )\
		( ( status & SCA_VAL_STATE_MASK ) == SCA_NO_VALUE )
#define sca_value_state_irrelevant( status )\
	( ( status & SCA_VAL_STATE_MASK ) == SCA_VALUE_STATE_IRRELEVANT )
#define sca_no_value_state( status )\
		( ( status & SCA_VAL_STATE_MASK ) == SCA_NO_VALUE_STATE )

#define sca_connected_fresh_value( status )\
		( sca_connected( status ) && sca_fresh_value( status ) )
#define sca_connected_old_value( status )\
		( sca_connected( status ) && sca_old_value( status ) )
#define sca_connected_no_value( status )\
		( sca_connected( status ) && sca_no_value( status ) )

#define sca_no_ap( status )\
		( ( status & SCA_ALL_STATES_MASK ) == SCA_NO_AP )

#define sca_standby_old_value( status )\
		( sca_monitor_on_standby( status ) && sca_old_value( status ) )
#define sca_standby_no_value( status )\
		( sca_monitor_on_standby( status ) && sca_no_value( status ) )

#define sca_disconnected_old_value( status )\
		( sca_disconnected( status ) && sca_old_value( status ) )
#define sca_disconnected_no_value( status )\
		( sca_disconnected( status ) && sca_no_value( status ) )

#define sca_never_connected_no_value( status )\
		( sca_never_connected( status ) && sca_no_value( status ) )

#define sca_getap_ok( status ) ( sca_no_error( status ) )

#define sca_get_ok( status )\
		( sca_no_error( status ) && sca_connected( status ) &&\
		  sca_monitor_active( status ) && !sca_no_value( status ) )

#define sca_put_ok( status )\
		( sca_no_error( status ) && sca_connected( status ) )

#define sca_cannot_find_name( s ) ( (s&SCA_ERROR_MASK) == SCA_CANNOT_FIND_NAME )
#define sca_bad_name_size( s )    ( (s&SCA_ERROR_MASK) == SCA_BAD_NAME_SIZE )
#define sca_bad_data_type( s )    ( (s&SCA_ERROR_MASK) == SCA_BAD_DATA_TYPE )
#define sca_no_acb( s )           ( (s&SCA_ERROR_MASK) == SCA_NO_ACB )
#define sca_bad_acb( s )          ( (s&SCA_ERROR_MASK) == SCA_BAD_ACB )
#define sca_bad_chid( s )         ( (s&SCA_ERROR_MASK) == SCA_BAD_CHID )
#define sca_internal_error( s )   ( (s&SCA_ERROR_MASK) == SCA_INTERNAL_ERROR )

#define sca_cannot_search( s )    ( (s&SCA_ERROR_MASK) == SCA_CANNOT_SEARCH )
#define sca_cannot_malloc( s )    ( (s&SCA_ERROR_MASK) == SCA_CANNOT_MALLOC )
#define sca_cannot_create_monitor( s )\
			( (s&SCA_ERROR_MASK) == SCA_CANNOT_CREATE_MONITOR )
#define sca_cannot_pend( s )      ( (s&SCA_ERROR_MASK) == SCA_CANNOT_PEND )
#define sca_cannot_put( s )       ( (s&SCA_ERROR_MASK) == SCA_CANNOT_PUT )
#define sca_cannot_get( s )       ( (s&SCA_ERROR_MASK) == SCA_CANNOT_GET )

#define sca_bad_arg( s )          ( (s&SCA_ERROR_MASK) == SCA_BAD_ARG )
#define sca_no_callback( s )          ( (s&SCA_ERROR_MASK) == SCA_NO_CALLBACK )

#define sca_cannot_find_group( s )\
			( (s&SCA_ERROR_MASK) == SCA_CANNOT_FIND_GROUP )
#define sca_cannot_find_channel( s )\
			( (s&SCA_ERROR_MASK) == SCA_CANNOT_FIND_CHANNEL )
/*
    Max get count for caget
*/
#define SCA_MAX_GET_COUNT	1024
#define SCA_MAX_PUT_COUNT	1024

/*
    type is form in which caller wants SCAget to return the value(s) or
	    form in which caller is supplying value(s) to SCAput
*/
#define SCA_STRING	100
#define	SCA_SHORT	101
#define	SCA_FLOAT	102
#define	SCA_ENUM	103
#define	SCA_CHAR	104
#define	SCA_LONG	105
#define	SCA_DOUBLE	106
#define	SCA_INT		107

/*
    options is form in which caller wants SCAget to return the value(s) or
	    form in which caller is supplying value(s) to SCAput
*/
#define SCA_MAX_STRING	40	/* longest string SCAget will return */
				/*     Must =  epics MAX_STRING_SIZE */
#define SCA_PVNAME_SZ	28	/* size of max pv name               */
				/*     EPICS PVNAME_SZ               */
#define SCA_FLDNAME_SZ	5	/* EPICS field name, including period(.)  */
				/*     EPICS FLDNAME_SZ + 1          */
#define SCA_EXTENSION_SZ 4      /* SCA name extension, including period(.)*/
				/* Hashed name is pvname.field.ext   */

#define SCA_EPICS_NAME_SIZE \
	(SCA_PVNAME_SZ + SCA_FLDNAME_SZ )

#define SCA_EPICS_NAME_STRING_SIZE \
	(SCA_PVNAME_SZ + SCA_FLDNAME_SZ + 1)	/* + 1 for NULL terminator */

#ifdef __cplusplus
}
#endif

#endif 	/* INCscasharedh */

