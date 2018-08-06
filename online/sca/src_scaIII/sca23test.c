#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <sys/time.h>
#include <string.h>
#include <strings.h>

#include "scalib.h"

#define TO_UC	1		/* UC -> upper case */
#define NOT_TO_UC	0
#define KEYBOARD	0
#define NOT_KEYBOARD	1

#define MAX_PVNAMES	200
void *ap[MAX_PVNAMES];
int num_aps = 0;

typedef struct
{
    char name[SCA_EPICS_NAME_STRING_SIZE];
}SINGLE_NAME;

typedef struct
{
    char value[SCA_MAX_STRING];
}SINGLE_VALUE;

SINGLE_NAME get_pvnames[MAX_PVNAMES];
double get_results[MAX_PVNAMES];
int get_statuses[MAX_PVNAMES];
int num_get_pvnames = 0;
int num_dogets = 0;

SINGLE_NAME put_pvnames[MAX_PVNAMES];
SINGLE_VALUE put_values[MAX_PVNAMES];
double put_values_as_doubles[MAX_PVNAMES];
int put_statuses[MAX_PVNAMES];
int num_put_pvnames = 0;
int num_doputs = 0;


int errcnt = 0;

#define LINELENGTH      256
char runtime[30];
char line[LINELENGTH];

char last_command_line[LINELENGTH];

char *pcommand, *pname, *pvalue, *ptimeout, *pfname, *psleeptime, *pshowwhat;
char *ppendtime, *pnum_reps, *pdv;

char command[LINELENGTH];
char name[LINELENGTH];
char value[LINELENGTH];
char timeout[LINELENGTH];
char fname[LINELENGTH];
char sleeptime[LINELENGTH];
char pendtime[LINELENGTH];
char showwhat[LINELENGTH];
char num_reps[LINELENGTH];
char dv[LINELENGTH];

char old_command[LINELENGTH];
char old_name[LINELENGTH];
char old_value[LINELENGTH];
char old_timeout[LINELENGTH];
char old_fname[LINELENGTH];
char old_sleeptime[LINELENGTH];
char old_pendtime[LINELENGTH];
char old_showwhat[LINELENGTH];
char old_num_reps[LINELENGTH];
char old_dv[LINELENGTH];

double cresult;
int cstatus;

int keep_going = 1;
FILE *infile;
int source = KEYBOARD;

double my_gettimeofday();

main( argc, argv )
int argc;
char *argv[];
{

    char pvname[SCA_EPICS_NAME_STRING_SIZE];
    int i;

    strcpy( last_command_line, "help" );

    clear_command();

    old_command[0] = '0';
    old_name[0] = '0';
    old_value[0] = '0';
    strcpy( old_timeout, "1.0" );
    old_fname[0] = '0';
    strcpy( old_sleeptime, "1.0" );
    strcpy( old_pendtime, "1e-12" );
    old_showwhat[0] = '0';
    old_num_reps[0] = '0';
    old_dv[0] = '0';

    for ( i = 0; i < MAX_PVNAMES; ++i )
    {
	get_pvnames[i].name[0] = '0';
	put_pvnames[i].name[0] = '0';
	put_values[i].value[0] = '0';
	put_values_as_doubles[i] = 0.0;
    }

    if ( get_runtime( runtime, ( int )sizeof( runtime ) ) != 0 )
    {
	printf( "Cannot get runtime!\n" );
	exit( 1 );
    }
    printf( "%s\n", runtime );
	
    source = KEYBOARD;

    while( keep_going )
    {
	int l;
	char c;

	if ( keep_going == 1 && source == KEYBOARD ) print_command_list();
	keep_going = 1;

	if ( source == KEYBOARD )
	{
	    if( fgets( line, LINELENGTH, stdin ) )
		;
	    else
		exit( 0 );
	}
	else
	{
	    if ( fgets( line, LINELENGTH, infile ) )
		keep_going = 2;
	    else
	    {
		fclose( infile );
		source = KEYBOARD;
		continue;
	    }
	}

	line[strlen( line )-1] = ( char )NULL;
	if ( line[0] == '#' ) continue;
	if ( line[0] == '\0' ) continue;

	clear_command();

/* get command */
	pcommand = strtok( line, "	 " );
	if ( get_token( NOT_TO_UC, old_command, pcommand, command ) <= 0 )
	    continue;

/*REPEAT*/
	if ( strcmp( command, "r" ) == 0 ||
	     strcmp( command, "repeat" ) == 0 )
	{
	    strcpy( line, last_command_line );
	    pcommand = strtok( line, "	 " );
	    if ( get_token( NOT_TO_UC, old_command, pcommand, command ) <= 0 )
	    continue;
	}

/*CACHE_SET*/
	if ( strcmp( command, "a" ) == 0 ||
	     strcmp( command, "cache_set" ) == 0 )
	{
	    int stat;
	    strcpy( command, "cache_set" );
	    pname = strtok( NULL, "	 " );
	    if ( get_token( NOT_TO_UC, old_name, pname, name ) <= 0 )
	    {

		printf( "pv name missing from %s!\n", command );
		continue;
	    }
	    sprintf( last_command_line, "%s %s", command, name );
	    printf( "%s %s", command, name );

	    stat = cache_set( name, SCA_DOUBLE, 1, &ap[num_aps] );
	    if ( sca_error( stat ) )
	    {
		printf( "%s failed for %s\n", command, name );
		++errcnt;
	    }
	    else
		++num_aps;

	    print_sca_status( stat );
	    save_command();
	}

/*CACHE_GET*/
	else if ( strcmp( command, "b" ) == 0 ||
		strcmp( command, "cache_get" ) == 0 )
	{
	    int stat;
	    strcpy( command, "cache_get" );
	    pname = strtok( NULL, "	 " );
	    if ( get_token( NOT_TO_UC, old_name, pname, name ) <= 0 )
	    {

		printf( "pv name missing from %s!\n", command );
		continue;
	    }
	    sprintf( last_command_line, "%s %s", command, name );
	    printf( "%s %s\n", command, name );

	    stat=cache_getbyname( name, SCA_DOUBLE, &cresult, 1);
/*
	    stat = cache_get( ap[num_aps], &cresult[r++], 1 );
*/
	    if ( sca_error( stat ) )
	    {
		printf( "HOWDY! cache_get status for %s = 0x%x\n", name, stat);
		print_ap( ap[num_aps] );
		errcnt++;
	    }
	    else
	    {

		printf( "%s = %g  ", name, cresult );
	    }

	    print_sca_status( stat );
	    save_command();
	}

/*CACHE_PUT*/
	else if ( strcmp( command, "c" ) == 0 ||
		strcmp( command, "cache_put" ) == 0 )
	{
	    int stat;
	    double dvalue;
	    strcpy( command, "cache_put" );

	    pvalue = strtok( NULL, "	 " );
	    if ( get_token( NOT_TO_UC, old_value, pvalue, value ) <= 0 )
	    {

		printf( "put value missing from %s!\n", command );
		continue;
	    }

	    pname = strtok( NULL, "	 " );
	    if ( get_token( NOT_TO_UC, old_name, pname, name ) <= 0 )
	    {

		printf( "pv name missing from %s!\n", command );
		continue;
	    }
	    sprintf( last_command_line, "%s %s %s", command, value, name );
	    printf( "%s %s %s", command, value, name );

	    dvalue = atof( value );

	    stat=cache_putbyname( name, SCA_DOUBLE, &dvalue, 1);

	    if ( sca_error( stat ) )
	    {
		printf( "\nHOWDY! cache_put status for %s = 0x%x\n",
			name, stat);
		my_print_sca_status( stat );
		print_ap( ap[num_aps] );
		errcnt++;
	    }
	    else
	    {
		print_sca_status( stat );
	    }
	    save_command();
	}

/*QUE_GET*/
	else if ( strcmp( command, "d" ) == 0 ||
		strcmp( command, "que_get" ) == 0 )
	{
	    int stat;
	    int ix;

	    strcpy( command, "que_get" );
	    pname = strtok( NULL, "	 " );
	    if ( get_token( NOT_TO_UC, old_name, pname, name ) <= 0 )
	    {

		printf( "pv name missing from %s!\n", command );
		continue;
	    }
	    sprintf( last_command_line, "%s %s", command, name );
	    printf( "%s %s", command, name );

	    if ( num_dogets > 0 )
	    {
		num_dogets = 0;
		num_get_pvnames = 0;
	    }
	    ix = findadd_name( &num_get_pvnames, get_pvnames, name );

	    stat = que_get( name, SCA_DOUBLE, 1,
			&get_results[ix], &get_statuses[ix] );
	    if ( sca_error( stat ) )
	    {
		printf( "\nHOWDY! que_get status for %s = 0x%x\n", name, stat);
		errcnt++;
	    }

	    print_sca_status( stat );
	    save_command();
	}

/*DO_GET*/
	else if ( strcmp( command, "e" ) == 0 ||
		strcmp( command, "do_get" ) == 0 )
	{
	    int stat;
	    double wait_time;
	    strcpy( command, "do_get" );

	    ptimeout = strtok( NULL, "	 " );
	    if ( get_token( NOT_TO_UC, old_timeout, ptimeout, timeout ) <= 0)
	    {
		printf( "timeout missing from %s!\n", command );
		continue;
	    }
	    sprintf( last_command_line, "%s %s", command, timeout );
	    printf( "%s %s\n", command, timeout );

	    wait_time = atof( timeout );
	    stat = do_get( wait_time );
	    if ( stat < 0 )
		printf( "HOWDY! do_get() called with nothing in get_q\n" );
	    else
	    {
		int i;
		if ( stat > 0 )
		{
		    printf( "HOWDY! do_get() returned with %d errors\n", stat );
		    ++errcnt;
		}
		for ( i = 0; i < num_get_pvnames; ++i )
		{
		    printf( "%s = %g ", get_pvnames[i], get_results[i] );
		    print_sca_status( get_statuses[i] );
		}
	    }
	    ++num_dogets;
	    save_command();
	}

/*FILE*/
	if ( strcmp( command, "f" ) == 0 ||
	     strcmp( command, "file" ) == 0 )
	{
	    int stat;

	    strcpy( command, "file" );
	    if ( source == NOT_KEYBOARD )
	    {
		printf( "Nested file commands not permitted\n" );
		exit( 1 );
	    }
	    pfname = strtok( NULL, "	 " );
	    if ( get_token( NOT_TO_UC, old_fname, pfname, fname ) <= 0 )
	    {

		printf( "file name missing from %s!\n", command );
		continue;
	    }
	    sprintf( last_command_line, "%s %s", command, fname );
	    printf( "%s %s\n", command, fname );

	    infile = fopen( fname, "r" );
	    if ( infile == ( FILE *)NULL )
	    {
		printf( "Cannot open %s\n", name );
		source = KEYBOARD;
		++errcnt;
	    }
	    else
	    {
		source = NOT_KEYBOARD;
	    }

	    save_command();
	}

/*QUE_PUT*/
	else if ( strcmp( command, "g" ) == 0 ||
		strcmp( command, "que_put" ) == 0 )
	{
	    int stat;
	    int ix;
	    strcpy( command, "que_put" );
	    pname = strtok( NULL, "	 " );
	    if ( get_token( NOT_TO_UC, old_name, pname, name ) <= 0 )
	    {

		printf( "pv name missing from %s!\n", command );
		continue;
	    }

	    sprintf( last_command_line, "%s %s", command, name );
	    printf( "%s %s", command, name );
	    if ( num_doputs > 0 )
	    {
		num_doputs = 0;
		num_put_pvnames = 0;
	    }
	    ix = findadd_name( &num_put_pvnames, put_pvnames, name );

	    stat=que_put( name, SCA_DOUBLE, 1,
			&put_values_as_doubles[ix], &put_statuses[ix] );
	    if ( sca_error( stat ) )
	    {
		printf( "\nHOWDY! que_put status for %s = 0x%x\n", name, stat);
		errcnt++;
	    }

	    print_sca_status( stat );
	    save_command();
	}

/*SET_PUTVAL*/
	else if ( strcmp( command, "h" ) == 0 ||
		strcmp( command, "set_putval" ) == 0 )
	{
	    int i;
	    int ix;
	    int stat;

	    strcpy( command, "set_putval" );

	    pvalue = strtok( NULL, "	 " );
	    if ( get_token( NOT_TO_UC, old_value, pvalue, value ) <= 0 )
	    {

		printf( "put value missing from %s!\n", command );
		continue;
	    }

	    pname = strtok( NULL, "	 " );
	    if ( get_token( NOT_TO_UC, old_name, pname, name ) <= 0 )
	    {

		printf( "pv name missing from %s!\n", command );
		continue;
	    }
	    sprintf( last_command_line, "%s %s %s", command, value, name );
	    printf( "%s %s %s\n", command, value, name );

	    ix = findadd_name( &num_put_pvnames, put_pvnames, name );
	    strcpy( put_values[ix].value, value );
	    put_values_as_doubles[ix] = atof( value );

	    save_command();
	}

/*SHOW*/
	else if ( strcmp( command, "s" ) == 0 ||
		strcmp( command, "show" ) == 0 )
	{
	    int i;
	    int ix;
	    int stat;


	    strcpy( command, "show" );
	    pshowwhat = strtok( NULL, "	 " );
	    if ( get_token( NOT_TO_UC, old_showwhat, pshowwhat, showwhat ) <=0 )
	    {

		printf( "show what missing from %s!\n", command );
		continue;
	    }
	    sprintf( last_command_line, "%s %s", command, showwhat );
	    printf( "%s %s\n", command, showwhat );

	    if ( strcmp( showwhat, "putvals" ) == 0 ||
		 strcmp( showwhat, "pvals" ) == 0 )
	    {
		if ( num_put_pvnames <= 0 )
		    printf( "No Values!\n" );
		else
		    for ( i = 0; i < num_put_pvnames; ++i )
			printf ( "%s %s\n",
			    put_pvnames[i].name, put_values[i].value );
	    }
	    else if ( strcmp( showwhat, "aps" ) == 0 )
	    {
		print_aps();
	    }
	    save_command();
	}

/*DO_PUT*/
	else if ( strcmp( command, "i" ) == 0 ||
		strcmp( command, "do_put" ) == 0 )
	{
	    int stat;
	    double wait_time;
	    strcpy( command, "do_put" );

	    ptimeout = strtok( NULL, "	 " );
	    if ( get_token( NOT_TO_UC, old_timeout, ptimeout, timeout ) <= 0)
	    {

		printf( "timeout missing from %s!\n", command );
		continue;
	    }
	    sprintf( last_command_line, "%s %s", command, timeout );
	    printf( "%s %s\n", command, timeout );

	    wait_time = atof( timeout );
	    stat = do_put( atof( timeout ) );
	    if ( stat < 0 )
		printf( "HOWDY! do_put() called with nothing in put_q\n" );
	    else
	    {
		int i;
		if ( stat > 0 )
		{
		    printf( "HOWDY! do_put() returned with %d errors\n", stat );
		    ++errcnt;
		}
		for ( i = 0; i < num_put_pvnames; ++i )
		{
		    printf( "%s -> %g",
			put_pvnames[i], put_values_as_doubles[i] );
		    print_sca_status( put_statuses[i] );
		}
	    }

	    ++num_doputs;
	    save_command();
	}  

/*PAUSE*/
	else if ( strcmp( command, "p" ) == 0 ||
		strcmp( command, "pause" ) == 0 )
	{
	    strcpy( command, "pause" );

	    if ( source == KEYBOARD )
		keep_going = 2;
	    else
		fgets( line, LINELENGTH, stdin );
	    save_command();
	}
	    

/*TIME*/
	else if ( strcmp( command, "t" ) == 0 ||
		strcmp( command, "time" ) == 0 )
	{
#define HISTSIZE	202
	    int hist[HISTSIZE];
	    int bin;
	    int i, nr, stat, vstat, num_changes;
	    double start, finish, elapsed, value, last_value, deltav;
	    double get_rate;
	    double scan_rate;
	    double change_rate;

	    strcpy( command, "time" );
	    for ( i = 0; i < HISTSIZE; ++i )
		hist[i] = 0;

	    pnum_reps = strtok( NULL, "	 " );
	    if ( get_token( NOT_TO_UC, old_num_reps, pnum_reps, num_reps ) <=0 )
	    {

		printf( "num_reps missing from %s!\n", command );
		continue;
	    }

	    pdv = strtok( NULL, "	 " );
	    if ( get_token( NOT_TO_UC, old_dv, pdv, dv ) <=0 )
	    {

		printf( "dv(delta value) missing from %s!\n", command );
		continue;
	    }

	    pname = strtok( NULL, "	 " );
	    if ( get_token( NOT_TO_UC, old_name, pname, name ) <= 0 )
	    {

		printf( "pv name missing from %s!\n", command );
		continue;
	    }

	    sprintf( last_command_line,
			"%s %s %s %s", command, num_reps, dv, name );
	    printf( "%s %s %s %s\n", command, num_reps, dv, name );

	    nr = atoi( num_reps );
	    if ( nr <= 0 )
		nr = 1;

	    deltav = atof( dv );
	    if ( deltav <= 0.0 )
		deltav = 1.0;

	    stat = que_get( name, SCA_DOUBLE, 1, &value, &vstat ); 
	    if ( sca_error( stat ) )
	    {
		printf( "HOWDY! que_get status for %s = 0x%x\n", name, stat);
		print_sca_status( stat );
		errcnt++;
		continue;
	    }
	    stat = do_get( 0.5 );
	    if ( stat != 0 )
		printf( "%d errors from do_get()\n", stat );
	    last_value = value;

	    set_min_time_between_do_gets( 0.0 );

	    start = my_gettimeofday();
	    for ( i = 0; i < nr; ++i )
	    {
		double diff;

		stat = do_get( 0.5 );
		
		if ( ( diff = value - last_value ) < 0.0 )
		    diff = -diff;
		last_value = value;

		bin = ( ( diff / deltav ) + 0.1 );

		if ( bin > HISTSIZE - 1 )
		    bin = HISTSIZE - 1;
		++hist[bin];
	    }
	    finish = my_gettimeofday();
	    elapsed = finish - start;

	    printf( "pvname:         %s\n", name );
	    printf( "num gets:       %s	( with callbacks )\n", num_reps );
	    printf( "hist bin width: %s\n\n", dv );

	    num_changes = nr - hist[0];
	    get_rate = ( double)nr / elapsed;
	    change_rate = ( double)num_changes / elapsed;
	    scan_rate = 1.0/change_rate;

	    printf( "elapsed time:   %10.3f sec\n", elapsed );
	    printf( "do_get() rate:  %10.3f / sec\n", get_rate );
	    printf( "change_rate:    %10.3f / sec\n", change_rate );
	    printf( "scan_rate:      %10.3f sec\n", scan_rate );
	    printf( "\n       bin     change      count\n" );
	    for ( bin = 0; bin < HISTSIZE; ++bin )
	    {
		if ( hist[bin] > 0 )
		    printf( "%10d %10.3f %10d\n",
			bin, (double)bin*deltav, hist[bin] );
	    }

	    save_command();
	}

/*PEND*/
	else if ( strcmp( command, "u" ) == 0 ||
		strcmp( command, "pend" ) == 0 )
	{
	    int stat;
	    strcpy( command, "pend" );
	    ppendtime = strtok( NULL, "	 " );
	    stat = get_token( NOT_TO_UC, old_pendtime, ppendtime, pendtime );
	    if ( stat<= 0)
	    {
		printf( "pend time missing from %s!\n", command );
		continue;
	    }
	    sprintf( last_command_line, "%s %s", command, pendtime );
	    printf( "%s %s\n", command, pendtime );

	    sca_pend_event( ( float )atof( pendtime ) );
	    save_command();
	}  

/*HELP*/
	else if ( strcmp( command, "y" ) == 0 ||
		  strcmp( command, "?" ) == 0 ||
		  strcmp( command, "help" ) == 0 )
	{
	    strcpy( command, "help" );
	    strcpy( last_command_line, "help" );
	    help();
	}

/*SLEEP*/
	else if ( strcmp( command, "z" ) == 0 ||
		strcmp( command, "sleep" ) == 0 )
	{
	    int stat;
	    strcpy( command, "sleep" );
	    psleeptime = strtok( NULL, "	 " );
	    stat = get_token( NOT_TO_UC, old_sleeptime, psleeptime, sleeptime );
	    if ( stat<= 0)
	    {
		printf( "sleep time missing from %s!\n", command );
		continue;
	    }
	    sprintf( last_command_line, "%s %s", command, sleeptime );
	    printf( "%s %s\n", command, sleeptime );

	    usleep( ( unsigned )( atof( sleeptime ) * 1000000. ) );
	    save_command();
	}  

/*QUIT, EXIT*/
	else if ( strcmp( command, "q" ) == 0 ||
		  strcmp( command, "quit" ) == 0 ||
		  strcmp( command, "x" ) == 0 ||
		  strcmp( command, "exit" ) == 0 )
	{
	    exit( 0 );
	}
    }

    print_global_stats();
}

int
get_runtime( runtime, sizeof_runtime )
char *runtime;
int sizeof_runtime;
{
    struct timeval tp;
    struct timezone tzp;
    struct tm *tm_p;
    int cc;

    if ( gettimeofday( &tp, &tzp ) )
	return -1;

    tm_p = localtime( ( time_t *)&tp.tv_sec );
    cc = strftime( runtime, sizeof_runtime, "Time %d%b%y %H:%M:%S" , tm_p ); 
    return 0;
}

double
my_gettimeofday()
{
    struct timeval tm;
    double u2s = 1000000.0;

#ifdef WIN32
    SYSTEMTIME st;

	GetSystemTime(&st);
	return (double)time(NULL) + (double)st.wMilliseconds / 1000.0;
( &tm );
#else
    gettimeofday( &tm, ( struct timezone *)NULL );

    return (double)tm.tv_sec + (double)tm.tv_usec / u2s;
#endif
}

int
my_print_sca_status( stat )
int stat;
{
    printf( "\n" );
    print_sca_status( stat );
}

int
clear_command()
{
    command[0] = '\0';
    name[0] = '\0';
    value[0] = '\0';
    timeout[0] = '\0';
    fname[0] = '\0';
    sleeptime[0] = '\0';
    pendtime[0] = '\0';
    showwhat[0] = '\0';
    num_reps[0] = '\0';
    dv[0] = '\0';
    return 0;
}
int
save_command()
{
    if ( command[0] != '\0' )  strcpy( old_command, command );
    if ( name[0] != '\0' )     strcpy( old_name, name );
    if ( value[0] != '\0' )    strcpy( old_value, value );
    if ( timeout[0] != '\0' )  strcpy( old_timeout, timeout );
    if ( fname[0] != '\0' )    strcpy( old_fname, fname );
    if ( sleeptime[0] != '\0' )strcpy( old_sleeptime, sleeptime );
    if ( pendtime[0] != '\0' ) strcpy( old_pendtime, pendtime );
    if ( showwhat[0] != '\0' ) strcpy( old_showwhat, showwhat );
    if ( num_reps[0] != '\0' ) strcpy( old_num_reps, num_reps );
    if ( dv[0] != '\0' )       strcpy( old_dv, dv );
    return 0;
}

int
get_token( to_uc, pold, psrc, pnew )
int to_uc;	/* convert to upper case? */
char *pold;	/* old value of token */
char *psrc;	/* source of new value of token */
char *pnew;	/* new value of token - returned*/
{

/*
   If src is empty
       copy old to new
   else
       copy src to new
   return length of new
*/

    pnew[0] = ( char )NULL;

    if ( psrc == ( char *)NULL )
	strcpy( pnew, pold );
    else
    {
	if ( to_uc )
	{
	    int c, l;
	    l = strlen( psrc ) + 1;
	    for ( c = 0; c < l; ++c )	/* convert to upper case */
	    {
		if ( islower( psrc[c] ) )
		    pnew[c] = toupper( psrc[c] );
		else
		    pnew[c] = psrc[c];
	    }
	}
	else
	    strcpy( pnew, psrc );
    }
    return strlen( pnew );
}

int
print_command_list()
{
    fprintf( stderr, "\n" );

fprintf( stderr,
"a. cache_set name  b. cache_get name      c. cache_put val name\n");

fprintf( stderr,
"d. que_get name    e. do_get timeout      f. file name\n");

fprintf( stderr,
"g. que_put name    h. set_putval val name i. do_put timeout\n");

fprintf( stderr,
"p. pause           q. quit                r. repeat\n");

fprintf( stderr,
"s. show pvals|aps  t. time reps dv name   u. sleep time\n");

fprintf( stderr,
"x. exit            y. help                       \n\n");

return 0;
}

int
help()
{
    fprintf( stderr, "\n" );
    fprintf( stderr, "a. cache_set <name>\n");
    fprintf( stderr, "b. cache_get <name>\n");
    fprintf( stderr, "c. cache_put <value> <name>\n" );

    fprintf( stderr, "d. que_get   <name>\n");
    fprintf( stderr, "e. do_get    <timeout_in_sec> (default = 1.0)\n");
    fprintf( stderr, "f. file      <name>\n" );

    fprintf( stderr, "g. que_put   <name>\n" );
    fprintf( stderr, "h. set_putval<value> <name>\n");
    fprintf( stderr, "i. do_put    <timeout_in_sec> (default = 1.0)\n");

    fprintf( stderr, "p. pause ( in file only )\n");
    fprintf( stderr, "q. quit\n");
    fprintf( stderr, "r. repeat_last_command\n");

    fprintf( stderr, "s. show      <putvals | aps> (default = putvals)\n");
    fprintf( stderr, "t. time      <reps> <dv> <name>\n");
    fprintf( stderr, "u. pend      <time> ( default = 1.e-12 sec.)\n");

    fprintf( stderr, "x. exit\n" );
    fprintf( stderr, "y. help\n" );
    fprintf( stderr, "z. sleep     <time> (default = 1.0 )\n");

    fprintf( stderr, "Enter letter or name + arguments if any.\n" );
    fprintf( stderr, "For example a test.ai or cache_set test_ai.\n\n" );
    fprintf( stderr,
	    "Missing trailing arguments get default or previous value.\n" );
    fprintf( stderr, "For example que_get test.ai\n" );
    fprintf( stderr, "            que_put           vs que_put test.ai\n" );
    fprintf( stderr, "            set_putval 1234.5 vs set_putval 1234.5 test_ai\n" );
    fprintf( stderr, "            do_put            vs do_put 1\n" );
    fprintf( stderr, "            do_get            vs do_get 1\n\n" );

    fprintf( stderr, "Enter q, quit, x, exit or ctrl d to quit\n" );

    keep_going = 2;	/* Suppress regular prompts */
return 0;
}

int
findadd_name( num_names, names, name )
int *num_names;
SINGLE_NAME *names;
char *name;
{
    int i;
    int lastnam = *num_names;
    for ( i = 0; i < *num_names; ++i )
    {
	if ( strcmp( names[i].name, name ) == 0 )
	    return i;
    }
    strcpy( names[*num_names].name, name );
    ++*num_names;
    return lastnam;
}
