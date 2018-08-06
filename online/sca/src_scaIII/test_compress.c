/*
**  test_compress.c monitors test_compress.VAL which is fed by el1.
**  test_compress is a compress record, is defined in sca3_example.db.
**  All 10 values are gotten the 1st time.  Then just 1 which is the latest.
**
**	Usage: test_compress  [num_reps | help]
**	       test_compress [num_reps | help]
**
**	If num_reps is missing, usage is printed.

**	acc -g -Xa -I. -o test_compress ./test_compress.c scalib.o -L/home/als2/devel/als_std_epics/base/lib/sun4 -lca -lCom

    test_compress.c was made to test compress record for beam_loss monitor.	
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

#define NUM_PVNAMES	1	/*10*/
#define NUM_SCANNED	2
#define NUM_WFMS	8
#define WFM_NELM	10	/*3*/

#define MAX_REPS	1000
#define DEFAULT_REPS	1

typedef struct
{
	char value[SCA_MAX_STRING];
} SINGLE_VALUE;

char *pv_names[NUM_PVNAMES] = { "test_compress" };

int scaType[NUM_PVNAMES]    = { SCA_DOUBLE };

int nelm[NUM_PVNAMES]	    = { WFM_NELM };
double *values[NUM_PVNAMES];

void *ap[NUM_PVNAMES];

int num_cache_set_errors    = 0;

main( argc, argv )
int argc;
char *argv[];
{
    int i, j, rep, num_reps;
    int status;

    /* setup cache for monitoring all pvs */
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

    for ( i = 0; i < NUM_PVNAMES; ++i )
    {
	values[i] = ( double *)calloc( nelm[i], sizeof( double ) );
	status = cache_set( pv_names[i], scaType[i], nelm[i], &ap[i] );
	if ( sca_error( status ) )
	{
	    printf( "cache_set failed for %s\n", pv_names[i] );
	    print_sca_status( status );
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

	/* get the monitor value of all pvs */
	for ( i = 0; i < NUM_PVNAMES; ++i )
	{
	    status = cache_get( ap[i], values[i], nelm[i] );
	    if ( sca_error( status ) ||
		!sca_connected( status ) ||
		!sca_monitor_active( status ) ||
		!sca_fresh_value( status ) )
	    {
		print_sca_status( status );
	    }
	    else
	    {

		/* print the results */
		printf( "\n" );
		print_sca_status( status );
		printf( "%10s", pv_names[i] );
		print_values( (void *)values[i], nelm[i], scaType[i] );
		printf( "\n" );
	    }
	    nelm[i] = 1;
	    sca_pend_event( .25 );
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
    printf( " Usage: test_compress  [num_reps | help]\n" );
    printf( "        test_compress [num_reps | help]\n\n" );
    printf( "        If num_reps is missing, usage is printed.\n" );
    return 0;
}
