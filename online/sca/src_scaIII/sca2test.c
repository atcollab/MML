/*
	Program to test the cache_set(), cache_get(), cache_getbyname(),
	cache_put() and cache_putbyname.

	sca2test assumes the existence of "num_pvs" process variables
	MOD001_CV_TEMP, MOD002_CV_TEMP, ... 

	1. Setup an array of (num_pvs * rep_count) values for the puts
	   in putval[0] = 1.0, putval[1] = 1.0, ...
	   Setup a corresponding array to hold the results of gets in result[].

	2. Call cache_get() once for each pv;  set_noflush_after_cache_put()
	   once for all but the last pv so that the ca_pend_io() is deferred. 

	3. for rep_count times
	       cache_put the next num_pvs values to MOD001_CV_TEMP, ...
	       wait usleep_time
	       cache_get the values until the results match what was
	       put or 5 sec elapse

	4. compare putval[] with result[] and print if requested.
			
	5  sca2test is  normally launched via script run_sca2test.
*/

#include <stdio.h>
#ifdef WIN32 
#include <windows.h>
#include <time.h>
#include <winsock.h>
#include <mmsystem.h>
#include <sys\timeb.h>
#define index(str, ch) strchr(str,ch)
#else
#include <sys/types.h>
#include <sys/time.h>
#include <strings.h>
#endif

#ifdef EXCAS
#define MAX_PVNAMES	8
#else
#define MAX_PVNAMES	200
#endif


#include "scalib.h"

void *ap[MAX_PVNAMES];

double *result;
double *putval;

typedef  struct
{
    char name[SCA_EPICS_NAME_STRING_SIZE];
} ONE_PVNAME;

ONE_PVNAME name[MAX_PVNAMES];

/* pv names used by the CA server example: excas */
char *excas_names[MAX_PVNAMES] = {"albert","fred","janet","freddy","alan","jane","bill","billy"};

double my_gettimeofday();

#ifndef WIN32
extern int sca_hashdepth();
#endif

int print_result(double *putval, double *result, int rep_count, int num_pvnames, int r);
int win32_gettimeofday(struct timeval  *pt, struct timezone *tz);

int main(argc, argv)
int argc;
char *argv[];
{
    double before, after, get_begin;
    double Before, After;
    double get_elapsed = 0.0;
    double put_elapsed = 0.0;
    double num_gets = 0;
    double num_puts = 0;

    int i, j, rep_count, num_pvnames, stat, r, r0, pr;
    int errcnt = 0;
    int group = 0;
    int monitor = 0;
    int do_print_results = 0;
    int do_print_aps = 0;
    int do_getbyname = 0;
    int do_putbyname = 0;
    int num_old_values = 0;
    int usleep_time = 0;

    if ( argc > 1 )
    {
	if ( strncmp( argv[1], "help", 4 ) == 0 )
	{
	    fprintf( stderr, "Usage:\n" );
	    fprintf( stderr, "%10s rep    num  group  mon-  print  print  get   usleep  put \n", argv[0] );
	    fprintf( stderr, "%10s count  pvs  puts   itor  res-    aps   by    after   by  \n", argv[0] );
	    fprintf( stderr, "%10s                          ults          name  rep     name\n", argv[0] );
	    fprintf( stderr, "%10s 1000   1    0      0     0      0      0     0       0   \n", "defaults" );
	    fprintf( stderr, "\n" );
	    return 3;
	}
    }
	
    rep_count = 1000;
    num_pvnames = 1;

    if ( argc >= 2 )
	rep_count = atoi( argv[1] );
    if ( rep_count < 1 ) rep_count = 1;
    fprintf( stderr, "%d reps", rep_count );

    if ( argc >= 3 )
	num_pvnames = atoi( argv[2] );
    if ( num_pvnames < 1 )
	num_pvnames = 1;
    if ( num_pvnames > MAX_PVNAMES )
	num_pvnames = MAX_PVNAMES;
    fprintf( stderr, " of %d pvs.", num_pvnames );

    if ( argc >= 4 )
	group = atoi( argv[3] );
    if ( group )
	fprintf( stderr, " group puts." );
    else
	fprintf( stderr, " no group puts." );

    if ( argc >= 5 )
	    monitor = atoi( argv[4] );
    if ( monitor )
	fprintf( stderr, " monitor." );
    else
	fprintf( stderr, " no monitor." );

    if ( argc >= 6 )
	    do_print_results = atoi( argv[5] );
    if ( do_print_results )
	fprintf( stderr, " print results.\n" );
    else
	fprintf( stderr, " no print results.\n" );

    if ( argc >= 7 )
	    do_print_aps = atoi( argv[6] );
    if ( do_print_aps )
	fprintf( stderr, " print aps." );
    else
	fprintf( stderr, " no print aps." );

    if ( argc >= 8 )
	    do_getbyname = atoi( argv[7] );
    if ( do_getbyname )
	fprintf( stderr, " getbyname." );
    else
	fprintf( stderr, " no getbyname." );

    if ( argc >= 9 )
	    usleep_time = atoi( argv[8] );
    if ( usleep_time )
	fprintf( stderr, " sleep %ld usec.", usleep_time );
    else
	fprintf( stderr, " no sleep." );

    if ( argc >= 10 )
	    do_putbyname = atoi( argv[9] );
    if ( do_putbyname )
	fprintf( stderr, " putbyname.\n" );
    else
	fprintf( stderr, " no putbyname.\n" );

    for ( i = 0; i < num_pvnames; ++i )
#ifndef EXCAS
		sprintf( (char *)&name[i], "MOD%03d_CV_TEMP", i+1 );
#else 
		sprintf( (char *)&name[i], excas_names[i] );
#endif

    result = ( double *)calloc( rep_count * num_pvnames, sizeof( double ) );
    putval = ( double *)calloc( rep_count * num_pvnames, sizeof( double ) );


    {
	double v = 1.0;
	for ( j = 0; j < ( rep_count * num_pvnames ); ++j )
	    putval[j] = v +  ( (double ).1 * (double )j );
    }

    printf( "%s", argv[0] );
    for ( i = 1; i < argc; ++i )
	printf(" %s", argv[i] );
    printf( "\n" );

    for ( i = 0; i < num_pvnames; ++i )
    {
	stat = cache_set( &(name[i].name[0]), SCA_DOUBLE, 1, &ap[i] );
	if ( sca_error( stat ) )
	{
	    fprintf( stderr, "cache_set failed for %s\n", &name[i] );
	    ++errcnt;
	}
	if ( group && (i != ( num_pvnames - 1 ) ) )
	    set_noflush_after_cache_put( ap[i] );
    }

    if ( errcnt )
	return 4;

    Before = my_gettimeofday();
    pr = 0;
    r0 = 0;
    for ( i = 0; i < rep_count; i++ )
    {
	int j;
	int keep_going;

	before = my_gettimeofday();
#ifdef DO_PUT
    for ( j = 0; j < num_pvnames; ++j )
	{
	    if ( do_putbyname )
	    {
		stat=cache_putbyname((void*)(&(name[j].name[0])), SCA_DOUBLE,
						&putval[pr++], 1);
		++num_puts;
	    }
	    else
	    {
		stat = cache_put( ap[j], &putval[pr++], 1 );
		++num_puts;
	    }

	    if ( sca_error( stat ) )
	    {
		print_ap( ap[j] );
		errcnt++;
	    }
	}
	after = my_gettimeofday();
	put_elapsed += ( after - before );
#else
	after = 0;
#endif
	get_begin = after;
	do
	{
	    keep_going = 0;
#ifndef WIN32
	    if ( usleep_time )
		usleep( ( unsigned )usleep_time );/*match scan rate in IOC */
#endif
	    before = my_gettimeofday();
	    r = r0;
	    for ( j = 0; j < num_pvnames; ++j )
	    {
		if ( do_getbyname )
		{
		    stat=cache_getbyname((void*)(&(name[j].name[0])),
						SCA_DOUBLE,&result[r++],1);
		    ++num_gets;
		}
		else
		{
		    stat = cache_get( ap[j], &result[r++], 1 );
		    ++num_gets;
		}

		if ( sca_error( stat ) )
		{
		    fprintf( stderr,
		    "HOWDY! cache_get status for %s = 0x%x\n",
			(void*)(&(name[j].name[0])),stat);
		    print_sca_status( stat );
		    print_ap( ap[j] );
		    errcnt++;
		    exit(5);
		}
		if ( putval[r-1] != result[r-1] ) keep_going = 1;
		if ( sca_old_value( stat ) )
		    ++num_old_values;
	    }
	    after = my_gettimeofday();
	    get_elapsed += ( after - before );
	    /* ---------------------------------------------------------
	    print_result( putval, result, rep_count, num_pvnames,
	    rep_count * num_pvnames );
	    ------------------------------------------------------------*/
	}while( keep_going && (after - get_begin) < 5.0 ); /* 5 sec to finish */
	r0 += num_pvnames;
    }
    After = my_gettimeofday();

    fprintf( stderr, "run_sca2test " );

    if ( argc > 1 )	fprintf( stderr, "%-6s", argv[1] );
    if ( argc > 2 )	fprintf( stderr, " %-2s", argv[2] );
    if ( argc > 3 )	fprintf( stderr, "%2s", argv[3] );
    if ( argc > 4 )	fprintf( stderr, "%2s", argv[4] );
    if ( argc > 5 )	fprintf( stderr, "%2s", argv[5] );
    if ( argc > 6 )	fprintf( stderr, "%2s", argv[6] );
    if ( argc > 7 )	fprintf( stderr, "%2s", argv[7] );
    if ( argc > 8 )	fprintf( stderr, " %-7s", argv[8] );
    if ( argc > 9 )	fprintf( stderr, "%2s", argv[9] );
    fprintf(stderr, "\n" );

    fprintf(stderr, "%7.3lf Total elapsed seconds\n", After - Before );
    fprintf(stderr, "%7d errors\n", errcnt );
    fprintf(stderr,
	"%7.0lf gets %7.3lf elapsed sec. %9.1lf gets/sec %5.1f msec/get\n",
		num_gets, get_elapsed, num_gets/get_elapsed,
		get_elapsed/num_gets*1000. );
#ifdef DO_PUT
    fprintf(stderr,
	"%7.0lf puts %7.3lf elapsed sec. %9.1lf puts/sec %5.1f msec/put\n",
		num_puts, put_elapsed, num_puts/put_elapsed,
		put_elapsed/num_puts*1000. );
#endif

    printf( "num_old_values = %d\n", num_old_values );
	    if ( usleep_time )
	    {
#ifdef WIN32
		fprintf( stderr, "No usleep for NT\n");
#endif
	    }

    if ( do_print_results )
    {
	int r = rep_count*num_pvnames;
	int diffs = 0;
#ifdef DO_PUT
	print_putval( putval, rep_count, num_pvnames );
#endif
	print_result( putval, result, rep_count, num_pvnames, r );
	printf( "%7.3lf Total elapsed seconds\n", After - Before );
	printf( "%7d errors\n", errcnt );
	printf(
	    "%7.0lf gets %4.1lf elapsed sec. %9.1lf gets/sec %5.1f msec/get\n",
		num_gets, get_elapsed, num_gets/get_elapsed,
		get_elapsed/num_gets*1000. );

#ifdef DO_PUT
	printf(
	    "%7.0lf puts %4.1lf elapsed sec. %9.1lf puts/sec %5.1f msec/put\n",
		num_puts, put_elapsed, num_puts/put_elapsed,
		put_elapsed/num_puts*1000. );
	printf( "Put Values and Results differ %d times\n", diffs );
	fprintf( stderr, "Put Values and Results differ %d times\n", diffs );
#endif
    }

    if ( do_print_aps )
	print_aps();
}

double
my_gettimeofday()
{
    struct timeval tm;
    double u2s = 1000000.0;

#ifdef WIN32
    win32_gettimeofday( &tm, (struct timezone*)NULL);
#else
    gettimeofday( &tm, ( struct timezone *)NULL );
#endif
    return (double)tm.tv_sec + (double)tm.tv_usec / u2s;
}

#ifdef WIN32
int
win32_gettimeofday(struct timeval  *pt, struct timezone *tz)
{
	double time_count;
	LARGE_INTEGER counts, counts_sec;

	QueryPerformanceFrequency(&counts_sec);
	QueryPerformanceCounter(&counts);
	time_count = (double)counts.QuadPart/(double)counts_sec.QuadPart;
	pt->tv_sec = (long)time_count;
	pt->tv_usec = (long)((time_count - (double)pt->tv_sec)*1000000.0);
	return 0;

}

#endif

int
print_putval( putval, rep_count, num_pvnames )
double *putval;
int rep_count;
int num_pvnames;
{
	int current = 0;
	int line = 0;
	int r = rep_count*num_pvnames;
	int i;

	printf( "Put Values:\n" );
	while( current < r )
	{
	    for ( i = 0; i < 10; ++i )
	    {
		printf( "%7.1lf", putval[current++] );
		if ( current >= r )
		    break;
	    }
	    printf( "\n" );
	    if ( (line % 5) == 4 ) printf( "\n" );
	    ++line;
	}
	return 0;
}

int
print_result(double *putval, double *result, int rep_count, int num_pvnames, int r)
{
    int current = 0;
    int i;
    int diffs;
    int line = 0;

    printf( "Results:\n" );
    while( current < r )
    {
	for ( i = 0; i < 10; ++i )
	{
	    char c = ' ';
#ifdef DO_PUT
	    if ( putval[current] != result[current] )
	    {
		++diffs;
		c = '>';
		}
#else
		diffs = 0;
#endif
	    printf( "%c%6.1lf", c, result[current++] );
	    if ( current >= r )
		break;
	}
	printf( "\n" );
	if ( (line % 5) == 4 ) printf( "\n" );
	++line;
    }
    return diffs;
}
