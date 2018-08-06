/*
**  index_example.c is sca3_example.c changed to use 
**	sca_find_index(), que_putbyindex(), que_getbyindex().
**
**  index_example.c monitors el1, el2 which have 1 second SCAN in the crate.
**  index_example.c puts values to other pvs whose values are both monitored
**  with cache_get() and gotten directly using que_get(), do_get().
**
**  The makefile produces 2 executables - index_example and indexa_example.
**  index_example uses que_putbyindex(), do_put().
**  indexa_example is the result of compiling with USE_CACHE_PUT defined and
**  uses cache_put().
**
**	Usage: index_example  [num_reps | help]
**	       indexa_example [num_reps | help]
**
**	If num_reps is missing, usage is printed.
*/

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#ifdef WIN32
#include <windows.h>
#include <time.h>
#include <winsock.h>
#include <mmsystem.h>
#include <sys\timeb.h>
#define index(str, ch) strchr(str,ch)
#else
#include <sys/time.h>
#include <strings.h>
#endif
#include <string.h>

#include "scalib.h"

#define NUM_PVNAMES	10
#define NUM_SCANNED	2
#define NUM_WFMS	8
#define WFM_NELM	3

#define MAX_REPS	1000
#define DEFAULT_REPS	1

typedef struct
{
	char value[SCA_MAX_STRING];
} SINGLE_VALUE;

char *pv_names[NUM_PVNAMES] = { "el1", "el2", "string_wfm", "short_wfm",
				"float_wfm", "enum_wfm", "char_wfm",
				"long_wfm", "double_wfm","str2dblwfm" };

int scaType[NUM_PVNAMES]    = { SCA_DOUBLE, SCA_DOUBLE, SCA_STRING,
				SCA_SHORT, SCA_FLOAT, SCA_ENUM, 
				SCA_CHAR, SCA_LONG, SCA_DOUBLE, SCA_STRING };

int nelm[NUM_PVNAMES]	    = { 1, 1, WFM_NELM,
				WFM_NELM, WFM_NELM, WFM_NELM,
				WFM_NELM, WFM_NELM, WFM_NELM, WFM_NELM };

int apindex[NUM_PVNAMES]    = { -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 };

/* default values so we can see changes */

double	       el1_do_put_value = {1.0};	/* do not queue put since these*/
double	       el2_do_put_value = {1.0};	/* are on 1 second scan */
SINGLE_VALUE   wf_str_do_put_values[WFM_NELM]  = { "200", "201", "202"};
short          wf_sht_do_put_values[WFM_NELM]  = { 3000, 3001, 3002};
float          wf_flt_do_put_values[WFM_NELM]  = { 10.1, 10.2, 10.3};
unsigned short wf_enm_do_put_values[WFM_NELM]  = { 40000, 40001, 40002};
char           wf_char_do_put_values[WFM_NELM+1] = { 'a', 'b', 'c', '\0'};
long           wf_lng_do_put_values[WFM_NELM]  = { 2400, 2401, 2402};
double         wf_dbl_do_put_values[WFM_NELM]  = { 0.1, 0.2, 0.3};
SINGLE_VALUE   wf_str2dbl_do_put_values[WFM_NELM]  = { "400", "401", "402"};

double	       el1_do_get_value = {-1.0};
double	       el2_do_get_value = {-1.0};
SINGLE_VALUE   wf_str_do_get_values[WFM_NELM]  = { "555", "556", "557"};
short          wf_sht_do_get_values[WFM_NELM]  = { 6000., 6000, 6000};
float          wf_flt_do_get_values[WFM_NELM]  = { 888., 888., 888.};
unsigned short wf_enm_do_get_values[WFM_NELM]  = { 64000., 64000, 64000};
char           wf_char_do_get_values[WFM_NELM+1] = { 'z', 'z', 'z', '\0'};
long           wf_lng_do_get_values[WFM_NELM]  = { 64000., 64000, 64000};
double         wf_dbl_do_get_values[WFM_NELM]  = { 999., 999., 999.};
SINGLE_VALUE   wf_str2dbl_do_get_values[WFM_NELM]  = { "666", "667", "668"};

double		el1_cache_get_value = {-121.0};
double		el2_cache_get_value = {-121.0};
SINGLE_VALUE  	wf_str_cache_get_values[WFM_NELM] = { "777", "888", "999"};
short 		wf_sht_cache_get_values[WFM_NELM] = { 6000., 6000, 6000};
float		wf_flt_cache_get_values[WFM_NELM] = { 888., 888., 888.};
unsigned short	wf_enm_cache_get_values[WFM_NELM] = { 64000., 64000, 64000};
char		wf_char_cache_get_values[WFM_NELM+1] = { 'z', 'z', 'z', '\0'};
long		wf_lng_cache_get_values[WFM_NELM] = { 64000., 64000, 64000};
double		wf_dbl_cache_get_values[WFM_NELM] = { 999., 999., 999.};
SINGLE_VALUE  	wf_str2dbl_cache_get_values[WFM_NELM] = { "123", "456", "789"};

double	       el1_increments = {0.0};		/* do not queue put since these*/
double	       el2_increments = {0.0};		/* are on 1 second scan */
SINGLE_VALUE   wf_str_increments[WFM_NELM]  = { "3", "3", "3"};
short          wf_sht_increments[WFM_NELM]  = { 3, 3, 3};
float          wf_flt_increments[WFM_NELM]  = { .3, .3, .3};
unsigned short wf_enm_increments[WFM_NELM]  = { 3, 3, 3};
char           wf_char_increments[WFM_NELM] = { ( char)3, ( char)3, ( char)3};
long           wf_lng_increments[WFM_NELM]  = { 3, 3, 3};
double         wf_dbl_increments[WFM_NELM]  = { .3, .3, .3};
SINGLE_VALUE   wf_str2dbl_increments[WFM_NELM]  = { "3", "3", "3"};

void *ap[NUM_PVNAMES];

float max_wait = 5.0;	/* sec */

main( argc, argv )
int argc;
char *argv[];
{

    int stat;

    int put_status[NUM_PVNAMES];
    int num_que_put_errors;
    int num_do_put_errors[MAX_REPS];

    int get_status[NUM_PVNAMES];
    int num_que_get_errors;
    int num_do_get_errors[MAX_REPS];

    int cache_get_status[NUM_PVNAMES];
    int num_cache_set_errors;

    void *do_put_values[NUM_PVNAMES] = {
	&el1_do_put_value, &el2_do_put_value,
	wf_str_do_put_values,
	wf_sht_do_put_values, wf_flt_do_put_values,
	wf_enm_do_put_values, wf_char_do_put_values,
	wf_lng_do_put_values, wf_dbl_do_put_values, wf_str2dbl_do_put_values };

    void *do_get_values[NUM_PVNAMES] = {
	&el1_do_get_value, &el2_do_get_value,
	wf_str_do_get_values,
	wf_sht_do_get_values, wf_flt_do_get_values,
	wf_enm_do_get_values, wf_char_do_get_values,
	wf_lng_do_get_values, wf_dbl_do_get_values, wf_str2dbl_do_get_values };

    void *cache_get_values[NUM_PVNAMES] = {
	&el1_cache_get_value, &el2_cache_get_value,
	wf_str_cache_get_values,
	wf_sht_cache_get_values, wf_flt_cache_get_values,
	wf_enm_cache_get_values, wf_char_cache_get_values,
	wf_lng_cache_get_values, wf_dbl_cache_get_values,
	wf_str2dbl_cache_get_values };

    void *increments[NUM_PVNAMES] = {
	&el1_increments, &el2_increments,
	wf_str_increments,
	wf_sht_increments, wf_flt_increments,
	wf_enm_increments, wf_char_increments,
	wf_lng_increments, wf_dbl_increments, wf_str2dbl_increments };

    int i, j, rep, num_reps;

    num_que_put_errors = 0;
    num_que_get_errors = 0;
    num_cache_set_errors = 0;

    for ( i = 0; i < MAX_REPS; ++i )
    {
	num_do_put_errors[i] = 0;
	num_do_get_errors[i] = 0;
    }

    if ( argc > 1 )
    {
	if ( strstr( argv[1], "help" ) )
	    usage();
	else
	{
	    num_reps = atoi( argv[1] );
	    if ( num_reps > MAX_REPS )
		num_reps = MAX_REPS;
	}
    }
    else
	usage();

    /* getem once to establish acbs */
    for ( i = 0; i < NUM_PVNAMES; ++i )
    {
	stat = do_getbyname( pv_names[i], scaType[i], nelm[i],
		do_get_values[i], &get_status[i] );
	if ( sca_error( stat ) )
	{
	    printf( "Error doing que_get of %s.\n", pv_names[i]);
	    print_sca_status( stat );
	    ++num_que_get_errors;
	}
	stat = sca_find_index( pv_names[i], scaType[i] );
	if ( sca_error( stat ) )
	{
	    printf( "Error doing sca_find_index of %s.\n", pv_names[i]);
	    print_sca_status( stat );
	    ++num_que_get_errors;
	}
	else
	    apindex[i] = stat;
    }
#ifndef USE_CACHE_PUT
    /* queue put to all pvs that are not scanned in crate */

    for ( i = NUM_SCANNED; i < NUM_PVNAMES; ++i )
    {
	stat = que_putbyindex( apindex[i], nelm[i],
		do_put_values[i], &put_status[i] );
	if ( sca_error( stat ) )
	{
	    printf( "Error doing que_put of %s.\n", pv_names[i]);
	    print_sca_status( stat );
	    ++num_que_put_errors;
	}
    }
    if ( num_que_put_errors > 0 )
    {
	printf( "Quitting because of %d que_put errors\n",
		    num_que_put_errors );
	exit( 1 );
    }
#endif

    /* slow down the whole process so that the monitors on the scanned
    ** pvs have a chance to change.
    */
    set_min_time_between_do_gets( 1.0 );

    /* queue get from all pvs*/

    for ( i = 0; i < NUM_PVNAMES; ++i )
    {
	stat = que_getbyindex( apindex[i], nelm[i],
		do_get_values[i], &get_status[i] );
	if ( sca_error( stat ) )
	{
	    printf( "Error doing que_get of %s.\n", pv_names[i]);
	    print_sca_status( stat );
	    ++num_que_get_errors;
	}
    }
    if ( num_que_get_errors )
    {
	printf( "Quitting because of %d que_get errors\n",
		num_que_put_errors );
	exit( 1 );
    }

    /* setup cache for monitoring all pvs */
    for ( i = 0; i < NUM_PVNAMES; ++i )
    {
	stat = cache_set( pv_names[i], scaType[i], nelm[i], &ap[i] );
	if ( sca_error( stat ) )
	{
	    printf( "cache_set failed for %s\n", pv_names[i] );
	    print_sca_status( stat );
	    ++num_cache_set_errors;
	}
    }
    if ( num_cache_set_errors )
    {
	printf( "Quitting because of %d cache_set errors\n",
		num_cache_set_errors );
	exit( 1 );
    }

    for ( rep = 0; rep < num_reps; ++rep )
    {
	for ( i = 0; i < NUM_PVNAMES; ++i )
	{
	    put_status[i] = 0xffffffff;
	    get_status[i] = 0xffffffff;
	    cache_get_status[i] = 0xffffffff;
	}

	/* do the puts to the pvs that are not scanned */
#ifndef USE_CACHE_PUT
	num_do_put_errors[rep] = do_put( max_wait );
	if ( num_do_put_errors[rep] > 0 )
	{
	    int i;
	    for ( i = NUM_SCANNED; i < NUM_PVNAMES; ++i )
	    {
		if ( sca_error( put_status[i] ) )
		{
		    printf( "Error putting %s with do_put in rep %d\n",
				pv_names[i], rep );
		    print_sca_status( put_status[i] );
		}
	    }
	}
#else
	for ( i = NUM_SCANNED; i < NUM_PVNAMES; ++i )
	{
	    put_status[i] = cache_put( ap[i], do_put_values[i], nelm[i] );
	}
#endif

 	/* do the gets of all pvs with callbacks */

	num_do_get_errors[rep] = do_get( max_wait );
	if ( num_do_get_errors[rep] > 0 )
	{
	    int i;
	    for ( i = 0; i < NUM_PVNAMES; ++i )
	    {
		if ( sca_error( get_status[i] ) )
		{
		    printf( "Error getting %s with do_get in rep %d\n",
				pv_names[i], rep );
		    print_sca_status( get_status[i] );
		}
	    }
	}

	/* get the monitor value of all pvs */
	for ( i = 0; i < NUM_PVNAMES; ++i )
	{
	    cache_get_status[i] =
			cache_get( ap[i], cache_get_values[i], nelm[i] );
	    if ( sca_error( cache_get_status[i] ) ||
		!sca_connected( cache_get_status[i] ) ||
		!sca_monitor_active( cache_get_status[i] ) ||
		!sca_fresh_value( cache_get_status[i] ) )
	    {
		printf( "Error getting %s with cache_get in rep %d\n",
				pv_names[i], rep );
		print_sca_status( cache_get_status[i] );
	    }
	}

	/* print the results */
	printf( "\n" );
	printf( "%10s%21s%21s%21s\n",
	    "pv_name", "do_put_values", "do_get_values", "cache_get_values" );
	for ( i = 0; i < NUM_PVNAMES; ++i )
	{
	    printf( "%10s", pv_names[i] );
	    print_values( (void *)do_put_values[i], nelm[i], scaType[i] );
	    print_values( (void *)do_get_values[i], nelm[i], scaType[i] );
	    print_values( (void *)cache_get_values[i], nelm[i], scaType[i] );
	    printf( "\n" );
	}

	/* change the put values for the next repitition */
	for ( i = 0; i < NUM_PVNAMES; ++i )
	{
	    inc_put_values( (void *)do_put_values[i], nelm[i], scaType[i],
				(void *)increments[i] );
	}
    }
}

int
inc_put_values( void *values, int nelm, int scatype, void *deltas )
{
    int j;

    for ( j = 0; j < nelm; ++j )
    {
	switch ( scatype )
	{
	    case SCA_STRING:
	    {
		int current_value = atoi( ( ( SINGLE_VALUE *)values)[j].value );
		int delta = atoi( ( ( SINGLE_VALUE *)deltas)[j].value );
		current_value += delta;
		sprintf( ( ( SINGLE_VALUE *)values)[j].value, "%d",
			current_value );
	    }
	    break;

	    case SCA_SHORT:
		( ( short *)values)[j] += ( ( short *)deltas)[j];
	    break;

	    case SCA_FLOAT:
		( ( float *)values)[j] += ( ( float *)deltas)[j];
	    break;

	    case SCA_ENUM:
		( ( unsigned short *)values)[j] +=
			( ( unsigned short *)deltas)[j];
	    break;

	    case SCA_CHAR:
		( ( unsigned char *)values)[j] +=
			( ( unsigned char *)deltas)[j];
	    break;
	    case SCA_LONG:
		( ( long *)values)[j] += ( ( long *)deltas)[j];
	    break;
	    case SCA_DOUBLE:
		( ( double *)values)[j] += ( ( double *)deltas)[j];
	    break;
	}
    }
}

int
print_values( void *values, int nelm, int scatype )
{
    int j;
    char blank_field[] = {" " };

    for ( j = 0; j < WFM_NELM; ++j )
    {
	switch ( scatype )
	{
	    case SCA_STRING:
		if ( j >= nelm )
		    printf( "%7s", blank_field );
		else
		    printf( "%7s", &((( SINGLE_VALUE *)values)[j].value[0]) );
	    break;
	    case SCA_SHORT:
		if ( j >= nelm )
		    printf( "%7s", blank_field );
		else
		    printf( "%7d", ( ( short *)values)[j] );
	    break;
	    case SCA_FLOAT:
		if ( j >= nelm )
		    printf( "%7s", blank_field );
		else
		    printf( "%7.1f", ( ( float *)values)[j] );
	    break;
	    case SCA_ENUM:
		if ( j >= nelm )
		    printf( "%7s", blank_field );
		else
		    printf( "%7u", ( ( unsigned short *)values)[j] );
	    break;
	    case SCA_CHAR:
		if ( j >= nelm )
		    printf( "%7s", blank_field );
		else
		    printf( "%7c", ( ( unsigned char *)values)[j] );
	    break;
	    case SCA_LONG:
		if ( j >= nelm )
		    printf( "%7s", blank_field );
		else
		    printf( "%7ld", ( ( long *)values)[j] );
	    break;
	    case SCA_DOUBLE:
		if ( j >= nelm )
		    printf( "%7s", blank_field );
		else
		    printf( "%7.1f", ( ( double *)values)[j] );
	    break;
	}
    }
}
int
usage()
{
    printf( "\n " );
    printf( " Usage: index_example  [num_reps | help]\n" );
    printf( "        indexa_example [num_reps | help]\n\n" );
    printf( "        If num_reps is missing, usage is printed.\n" );
    return 0;
}
