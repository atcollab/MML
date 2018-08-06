/*
**  sca3_example.c monitors el1, el2 which have 1 second SCAN in the crate.
**  sca3_example.c puts values to other pvs whose values are both monitored with
**  cache_get() and gotten directly using que_get(), do_get().
**
**	Usage: See usage() below.
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

char el4[4];
char temp[32];

float max_put_wait = 5.0;	/* sec */
float max_get_wait = 5.0;	/* sec */

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
    int test_num;

    int delay_in_msec, max_delay_in_msec;
    int delay_in_usec, max_delay_in_usec;
    int num_usec;
    double tarray[2], sarray[2];

    num_que_put_errors = 0;
    num_que_get_errors = 0;
    num_cache_set_errors = 0;

    strcpy( el4, "el4" );

    for ( i = 0; i < MAX_REPS; ++i )
    {
	num_do_put_errors[i] = 0;
	num_do_get_errors[i] = 0;
    }

    if ( argc <= 1 )			/* help */
    {
	usage();
	exit( 0 );
    }

    if ( argc >= 2 )
    {
	if ( argv[1][0] == 'h' ||
	     argv[1][0] == 'H' )	/* help */
	{
	    usage();
	    exit( 0 );
	}

	if (	strcmp( argv[1], "t1" ) == 0 ||
		strcmp( argv[1], "t2" ) == 0 ||
		strcmp( argv[1], "t3" ) == 0 ||
		strcmp( argv[1], "t4" ) == 0 ||
		strcmp( argv[1], "t5" ) == 0 ||
		strcmp( argv[1], "t6" ) == 0 )

	{
	    test_num = atoi( &argv[1][1] );
	}
	else
	{
	    printf( "Unrecognized command\n" );
	    usage();
	    exit( 0 );
	}
    }

    if ( argc >= 3 )
    {
	num_reps = atoi( argv[2] );
	if ( num_reps > MAX_REPS )
	    num_reps = MAX_REPS;
	if ( num_reps <= 0 )
	    num_reps = 1;
    }
    else
	num_reps = 1;


    if ( argc >= 4 )
    {
	delay_in_msec = atoi( argv[3] );
    }
    else
    {
	delay_in_msec = 1000;
    }

    if ( argc >= 5 )
    {
	max_delay_in_msec = atoi( argv[4] );
    }
    else
    {
	max_delay_in_msec = delay_in_msec;
    }

    printf( "\nt%d: num_reps = %d", test_num, num_reps );
    if ( test_num > 2 )
    {
	printf( " delay_in_msec = %d max_delay_in_msec = %d",
	    delay_in_msec, max_delay_in_msec );
    }
    printf( "\n" );

/* TEST 1 and TEST 2 */
if ( test_num == 1 || test_num == 2 )
{
    if ( test_num == 1 )
    {
	/* queue put to all pvs that are not scanned in crate */

	for ( i = NUM_SCANNED; i < NUM_PVNAMES; ++i )
	{
	    stat = que_put( pv_names[i], scaType[i], nelm[i],
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
    }

    /* slow down the whole process so that the monitors on the scanned
    ** pvs have a chance to change.
    */
    set_min_time_between_do_gets( 1.0 );

    /* queue get from all pvs*/

    for ( i = 0; i < NUM_PVNAMES; ++i )
    {
	stat = que_get( pv_names[i], scaType[i], nelm[i],
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

    for ( rep = 1; rep <= num_reps; ++rep )
    {
	for ( i = 0; i < NUM_PVNAMES; ++i )
	{
	    put_status[i] = 0xffffffff;
	    get_status[i] = 0xffffffff;
	    cache_get_status[i] = 0xffffffff;
	}

	/* do the puts to the pvs that are not scanned */
	if ( test_num == 1 )
	{
	    num_do_put_errors[rep] = do_put( max_put_wait );
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
	}
	else
	{
	    for ( i = NUM_SCANNED; i < NUM_PVNAMES; ++i )
	    {
		put_status[i] = cache_put( ap[i], do_put_values[i], nelm[i] );
	    }
	}

 	/* do the gets of all pvs with callbacks */

	num_do_get_errors[rep] = do_get( max_get_wait );
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
	sprintf( temp, "%d/%d", rep, num_reps );
	while( strlen( temp ) < 8 )
	{
	    strcat( temp, " " );
	}
	printf( "\n" );
	printf( "%-8s%2s%21s%21s%21s\n",
	    temp, "pv", "do_put_values", "do_get_values", "cache_get_values" );
	for ( i = 0; i < NUM_PVNAMES; ++i )
	{
	    printf( "%10s", pv_names[i] );
	    if ( i < NUM_SCANNED )
		print_values( (void *)do_put_values[i],       0, scaType[i] );
	    else
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

/* TEST 3 */
    else if ( test_num == 3  )
    {
	int total_errors = 0;
	double dest = 0.0;
	printf( "do_get_byname of %s\n", el4 );
	printf( "    rep      nerrs      value status\n" );
	for ( i = 0; i < num_reps; ++i )
	{
	    int num_errors;
	    int status;

	    dest = -9999.99;
	    num_errors =
		do_getbyname( el4, SCA_DOUBLE, 1, &dest, &status ); 

	    total_errors += num_errors;
	    sprintf( temp, "%d/%d", i+1, num_reps );
	    while( strlen( temp ) < 9 )
	    {
		strcat( temp, " " );
	    }
	    printf( "    %s%5d%11.1f", temp, num_errors, dest );
	    print_sca_status( status );
	    sca_sleep( delay_in_msec, max_delay_in_msec );
	}
	printf( "total     %8d\n", total_errors );
    }

/* TEST 4 */
    else if ( test_num == 4  )
    {
	int total_errors = 0;
	double src = 0.9;
	printf( "do_put_byname of %s\n", el4 );
	printf( "    rep      nerrs      value status\n" );
	for ( i = 0; i < num_reps; ++i )
	{
	    int num_errors = 0;
	    int status;

	    src += .1;
	    num_errors =
		do_putbyname( el4, SCA_DOUBLE, 1, &src, &status ); 

	    total_errors += num_errors;
	    sprintf( temp, "%d/%d", i+1, num_reps );
	    while( strlen( temp ) < 9 )
	    {
		strcat( temp, " " );
	    }
	    printf( "    %s%5d%11.1f", temp, num_errors, src );
	    print_sca_status( status );
	    sca_sleep( delay_in_msec, max_delay_in_msec );
	}
	printf( "total     %8d\n", total_errors );
    }

/* TEST 5 */
    else if ( test_num == 5  )
    {
	int total_errors = 0;
	double src = 1.0;
	double dest= 2.2;
	printf( "do_put_byname and do_get_byname of %s\n", el4 );
	printf( "             nerrs      value status\n" );
	for ( i = 0; i < num_reps; ++i )
	{
	    int num_errors;
	    int status;

	    src += .1;
	    num_errors =
		do_putbyname( el4, SCA_DOUBLE, 1, &src, &status ); 
	    sprintf( temp, "%d/%d", i+1, num_reps );
	    while( strlen( temp ) < 9 )
	    {
		strcat( temp, " " );
	    }
	    printf( "put %9s%5d%11.1f", temp, num_errors, src );
	    print_sca_status( status );

	    dest -99999.99;
	    num_errors =
		do_getbyname( el4, SCA_DOUBLE, 1, &dest, &status ); 
	    printf( "get          %5d%11.1f", num_errors, src );
	    print_sca_status( status );
	    sca_sleep( delay_in_msec, max_delay_in_msec );
	}
	printf( "total %13d\n", total_errors );
    }

/* TEST 6 */
#ifndef WIN32
    else if ( test_num == 6  )
    {
	/*sca_sleep vs usleep for num msec given by arg 3 */

	printf(
	"\nnum           sleep dt  sca_sleep dt (for %d msec delays )\n",
	    delay_in_msec );

	for ( i = 1; i <= num_reps; ++i )
	{
	    tarray[0]=sca_gettimeofday();
	    sca_sleep( delay_in_msec, max_delay_in_msec );
	    tarray[1] = sca_gettimeofday();

	    if ( delay_in_msec <= 0 )
		printf( "delay_in_msec = %d, usleep skipped\n", delay_in_msec );

	    else if ( max_delay_in_msec <= 0 )
		printf( "max_delay_in_msec = %d, usleep skipped\n",
		    max_delay_in_msec );

	    else
	    {
		if ( delay_in_msec > max_delay_in_msec )
		    delay_in_msec = max_delay_in_msec;
		delay_in_usec = delay_in_msec * 1000;
		sarray[0]=sca_gettimeofday();
		usleep( delay_in_usec );
		sarray[1] = sca_gettimeofday();
	    }

	    sprintf( temp, "%d/%d", i, num_reps );
	    while( strlen( temp ) < 9 )
	    {
		strcat( temp, " " );
	    }
	    printf( "%s%13.6f %13.6f\n", temp,
		sarray[1]-sarray[0], tarray[1]-tarray[0] );
	}
	return;
    }
#endif
    exit( 0 );
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
    printf( "Usage:\n" );
    printf( "        sca3_example[ h[elp]|H[elp]]\n" );
    printf( "        sca3_example  t1|t2 [num_reps]\n" );
    printf( "        sca3_example  t3|t4|t5[ num_reps[ delay[ max_delay]]]\n" );
    printf( "        sca3_example  t6[ num_reps[ delay[ max_delay]]]\n\n" );

    printf( "        t1 cache_get vs do_get. Use do_put to set values\n" );
    printf( "        t2 cache_get vs do_get. Use cache_put to set values\n" );
    printf( "        t3 does do_gets for testing callbacks\n" );
    printf( "        t4 does do_puts for testing callbacks\n" );
    printf( "        t5 does do_puts and do_gets for testing callbacks\n" );
    printf( "        t6 compares sca_sleep() with usleep()\n\n" );
    printf( "Defaults: num_reps = 1; delay = 1000 msec; max_delay = delay\n\n");
    return 0;
}
