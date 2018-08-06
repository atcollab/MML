/*
   sca3test does timing tests on que_get(), do_get() and 
   que_put(), do_put().  sca3test runs in either averaging or histogramming
   mode.

   1.  Averaging mode.  DOAVG option = 1.
	   1 channel  is  read, then written NumReps times.
	   2 channels are read, then written NumReps times.
			.
			.
			.
	   Nchans channels are read, then written NumReps times.

	   The average time to get, to put and to get + put 1,...,Nchans
	   channels is calculated and written to the outfile in a form
	   suitable for importing into Excel.

   2.  Histogramming mode.  DOAVG option = 0.
	   Nchans channels are read, then written NumReps times.

	   The time to get, to put and to get + put the Nchans channels
	   is calculated and is histogrammed in 3 histograms and
	   written to the outfile in a form suitable for importing into Excel.

   sca3test is driven by a configuration file.

***************   SAMPLE FILES FOR AN AVERAGING RUN  **************** 

CONFIG_FILE:  yoda_avg30_chans150.cfg

Infile	yoda_CAtest.lst
Outfile	yoda_avg30_chans150
NumReps	30
MaxWait	1.0
Print	0
Nchans	150
PrePuts	2
MinTime	0.0
DoAvg	1
AllDataFile
UserLabel1
UserLabel2
UserLabel3


INFILE:  yoda_CAtest.lst

get MOD001_DV_TEMP
get MOD002_DV_TEMP
	.
	.
	.
get MOD500_DV_TEMP
put MOD001_CV_TEMP
put MOD002_CV_TEMP
	.
	.
	.
put MOD500_CV_TEMP


OUTFILE:  yoda_avg30_chans150

sca3test NumReps MaxWait Print Nchans PrePuts Min_time DoAvg All U1 U2 U3
sca3test 30 1.000 0 150 2 0.000 1  "" "" "" ""
chart title	Average Time for N Channels
xaxis title	Number of Channels
yaxis title	Seconds	Time 30Aug96 13:38:55
label 1	 150 Data points - average +/- 1 std dev	infile = yoda_CAtest.lst
label 2	  30 Samples per data point	outfile = yoda_avg30_chans150
label 3	
label 4	host: pio.als	configfile = yoda_avg30_chans150.cfg
user  1	
user  2	
user  3	
num_chans put_time get_time tot_time put_stddev	get_stddev tot_stddev
1         6.77e-03 6.19e-03 1.29e-02 1.29e-02   1.29e-02   1.75e-02
2         8.52e-03 4.72e-03 1.32e-02 1.55e-02	9.35e-03   1.75e-02
	.
	.
	.
150       9.90e-02 6.81e-02 1.67e-01 1.16e-02   2.30e-02   2.54e-02


***************   SAMPLE FILES FOR A HISTOGRAMMING RUN  **************** 

CONFIG_FILE:  crioc_hist500_chans100.cfg

Infile	crioc_CAtest.lst
Outfile	crioc_hist500_chans100
NumReps	500
MaxWait	1.0
Print	0
Nchans	100
PrePuts	2
MinTime	0.0
DoAvg	0
AllDataFile
UserLabel1
UserLabel2
UserLabel3

INFILE:  yoda_CAtest.lst 	(same as above )

OUTFILE:  crioc_hist500_chans100

sca3test NumReps MaxWait Print Nchans PrePuts Min_time DoAvg All U1 U2 U3
sca3test 500 1.000 0 100 2 0.000 0  "" "" "" ""
chart title	Time to Access 100 Channels
xaxis title	msec for 100 Channels
yaxis title	Percentage of 500 Samples	Time 16Jul96 12:24:04
label 1	put average:   30.3 msec	infile = crioc_CAtest.lst
label 2	get average:   22.9 msec	outfile = crioc_hist500_chans100
label 3	tot average:   53.2 msec
label 4	host       : crconm22.als	configfile = crioc_hist500_chans100.cfg
user  1	
user  2	
user  3	
msec 	put_pcnt get_pcnt tot_pcnt put_freq get_freq tot_freq
0	   0.000    0.000    0.000	  0        0        0
1	   0.000    0.000    0.000	  0        0        0
	.
	.
	.
14	   0.000    0.000    0.000        0        0        0
15	   0.000   18.600    0.000        0       93        0
16	   0.600   21.200    0.000        3      106	    0
17	  15.600   10.600    0.000       78       53        0
18	   7.800    6.400    0.000       39       32	    0
19	   5.400    6.800    0.000	 27       34        0
        . 
	. 
	. 
32	   2.800    1.000    4.000	 14	   5	   20
33	   3.000    0.600    4.600	 15	   3	   23
34	   2.600    0.800    4.000	 13	   4	   20
        . 
	. 
	. 
200	 0.000	 0.000	 0.000	0	0	0

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

#define HIST_SIZE	201	/* underflow + 100 + overflow bin */
#define UNDERFLOW_BIN	0	/* HIST_SIZE must be divisible by 5 */
#define OVERFLOW_BIN	(HIST_SIZE - 1)	
#define HIST_COLUMNS	5

#define LINELENGTH	256

int repcount;	/* repcount */
float max_wait;	/* sec */
int print_values;	/* print all values, statuses, times at end */
int num_chans;	/* number of channels per repetition using */
		    /* MOD001_DV_TEMP, MOD002_DV_TEMP, ... */  
int num_prelims;	/* Number of preliminary reads of all channels*/
float min_time_btwn;/* minimum time between do_gets and do_puts */
int do_average;	/* average, rather than bin(the default)*/
char all[LINELENGTH];		/* file to which to write all raw data */
char user1[LINELENGTH];	/* user title for excel plot */
char user2[LINELENGTH];	/* user title for excel plot */
char user3[LINELENGTH];	/* user title for excel plot */

char *usage[] =
{
"Infile  is a list of channels for getting and putting.",
"Outfile is a tab delimited output file for import to Excel.",
"NumReps is no. of times to read the channels.",
"MaxWait is the maximum seconds to wait for i/o(do_put/que_put) to complete.",
"Print   is a print flag. 0 for do; 1 for do not print",
"Nchans  is no. of channels to put, then get NumRep times.",
"Prelims is no. of preliminary accesses of the Nchans channels.",
"           Do 1 or more to keep initial connection time out of the results.",
"MinTime is minimum delay between puts and minimum delay betweee gets.",
"           Use 0.0 to go as fast as possible.",
"DoAvg   is output selector: 0-histgram times; 1-list average times.",
"AllDataFile     is name of a file to which all the raw data will be written.",
"UserLabel1      is user's plot title 1.",
"UserLabel2      is user's plot title 2.",
"UserLabel3      is user's plot title 3."
};
int nelm_usage = sizeof( usage ) / sizeof( char *);

char *example[] =
{
"#configuration file for sca3test",
"#Format is parameter [tab value].",
"",
"Infile	yoda_CAtest",
"Outfile	yoda_avg30_chans150",
"NumReps	30",
"MaxWait	1.0",
"Print	0",
"Nchans	150",
"Prelims	2",
"MinTime	0.0",
"DoAvg	1",
"AllDataFile",
"UserLabel1	This is an example.",
"UserLabel2",
"UserLabel3	Hope it helps."
};
int nelm_example = sizeof( example ) / sizeof( char *);

char line[LINELENGTH];
char config_file_name[LINELENGTH];
char infile_name[LINELENGTH];
char outfile_name[LINELENGTH];

char runtime[30];

main( argc, argv )
int argc;
char *argv[];
{
    char empty_string = '\0';
    char empty_quote[3];
    int arg = 1;
    int num_errors;
    int stat;
    int num_que_put_errors = 0;
    int num_put_errors = 0;
    int num_que_get_errors = 0;
    int num_get_errors = 0;
    int num_get_channels = 0;
    int num_put_channels = 0;
    int num_tot_channels = 0;
    double total_get_time = 0.0;
    double total_put_time = 0.0;
    double total_time = 0.0;
    int num_channels;
    int first;
    int i;

    int get_count = 0;
    int put_count = 0;
    double *put_value;
    double *get_value;
    int *put_status;
    int *get_status;
    double *put_begin;
    double *put_end;
    double *get_begin;
    double *get_end;
    double *tot_begin;
    double *tot_end;

    char *pvnames;	/* for gets */
    char *pvnamez;	/* for puts */
    int pvname_size = 40;
    char *name;
    FILE *all_data;
    FILE *infile;
    FILE *outfile;
    FILE *config_file;

    double put_time;
    double get_time;
    double tot_time;

    double psum;
    double gsum;
    double tsum;

    double p2sum;
    double g2sum;
    double t2sum;

    double pstddev;
    double gstddev;
    double tstddev;

    int put_hist[HIST_SIZE];
    int get_hist[HIST_SIZE];
    int tot_hist[HIST_SIZE];

    char pvname[40];

    double start_time, end_time, elapsed_time, average_time;

    infile_name[0] = '\0';
    outfile_name[0] = '\0';
    config_file_name[0] = '\0';
    repcount = 1000;
    max_wait = 1.0;
    print_values = 0;
    num_chans = 1;
    num_prelims = 1;
    min_time_btwn = .001;
    do_average = 0;
    all[0] = '\0';
    user1[0] = '\0';
    user2[0] = '\0';
    user3[0] = '\0';
    empty_quote[0] = '"'; 
    empty_quote[1] = '"'; 
    empty_quote[2] = '\0'; 

    if ( get_runtime( runtime, ( int )sizeof( runtime ) ) != 0 )
    {
	fprintf( stderr, "Cannot get runtime!\n" );
	exit( 1 );
    }
    fprintf( stderr, "%s\n", runtime );
	

    if ( argc <= 1 )
    {
	int i;
	fprintf( stderr, "\nUsage: %s config_file\n", argv[0]);

	fprintf( stderr, "\nconfig_file specifies:\n" );
	for( i = 0; i < nelm_usage; ++i )
	    fprintf( stderr, "%s\n", usage[i] );

	fprintf( stderr, "\nFor example,\n" );
	for( i = 0; i < nelm_example; ++i )
	    fprintf( stderr, "%s\n", example[i] );

	fprintf( stderr, "\n" );
	
	exit( 0 );
    }

    strcpy( config_file_name, argv[1] );
    if ( ( config_file = fopen( config_file_name, "r") ) == (FILE *) NULL)
    {
	printf("%s can't open config_file %s\n", argv[0], argv[1] );
	exit( 1 );
    }

    while( fgets( line, LINELENGTH, config_file ) )
    {
	int l = strlen( line ) - 1;
	char c;
	char *tab, *value;
	char *comment;

	line[l] = ( char )NULL;

	comment = index( line, ( int)('#') );	/* skip comment lines */
	if ( comment != ( char )NULL )		/* chop comments from line */
	    *comment = ( char )NULL;

	if ( line[0] == ( char )NULL )
	    continue;

	tab = index( line, ( int)('\t') );
	if ( tab == ( char *)NULL )	/* skip lines with no tab */
	    continue;
	*tab = ( char )NULL;	/* break line in 2 at tab */
	value = ++tab;
	
	l = strlen( line );
	for ( c = 0; c < l; ++c )	/* convert to upper case */
	{
	    if ( islower( line[c] ) )
		line[c] = toupper( line[c] );
	}

	if ( strstr( line, "INFILE" ) != ( char * )NULL )
	{
	    strcpy( infile_name, value );
	    if ( ( infile = fopen( infile_name, "r") ) == (FILE *) NULL)
	    {
		printf("%s can't open infile %s\n", argv[0], infile_name );
		exit( 1 );
	    }
	}


	else if ( strstr( line, "OUTFILE" ) != ( char * )NULL )
	{
	    strcpy( outfile_name, value );
	    if ( ( outfile = fopen( outfile_name, "w") ) == (FILE *) NULL)
	    {
		printf("%s can't open outfile %s\n", argv[0], outfile_name );
		exit( 1 );
	    }
	}

	else if ( strstr( line, "NUMREPS" ) != ( char * )NULL )
	{
	    repcount = atoi( value );
	    if ( repcount <= 0 ) repcount = 1;
	}

	else if ( strstr( line, "MAXWAIT" ) != ( char * )NULL )
	{
	    max_wait = atof( value );
	    if ( max_wait <= 0.0 ) max_wait = 1.0;
	    if ( max_wait > 30.0 ) max_wait = 30.0;
	}

	else if ( strstr( line, "PRINT" ) != ( char * )NULL )
	{
	    print_values = atoi( value );
	    if ( print_values != 0 ) print_values = 1;
	}

	else if ( strstr( line, "NCHANS" ) != ( char * )NULL )
	{
	    num_chans = atoi( value );
	    if ( num_chans <= 0 ) num_chans = 1;
	    if ( num_chans > 1000 ) num_chans = 1000;
	}

	else if ( strstr( line, "PREPUTS" ) != ( char * )NULL )
	{
	    num_prelims = atoi( value );
	    if ( num_prelims < 0 ) num_prelims = 0;
	}

	else if ( strstr( line, "MINTIME" ) != ( char * )NULL )
	{
	    min_time_btwn = atof( value );
	    if ( min_time_btwn < 0.0 )
		min_time_btwn = 0.0;
	}

	else if ( strstr( line, "DOAVG" ) != ( char * )NULL )
	{
	    do_average = atoi( value );
	    if ( do_average != 0 ) do_average = 1;
	}

	else if ( strstr( line, "ALLDATAFILE" ) != ( char * )NULL )
	{
	    strcpy( all, value );
	    if ( *all != '\0' )
		{
		if ( ( all_data = fopen( all, "w") ) == (FILE *) NULL)
		{
		    printf("%s can't open all data file %s\n",argv[0],all );
		    exit( 1 );
		}
	    }
	}

	else if ( strstr( line, "USERLABEL1" ) != ( char * )NULL )
	{
	    strcpy( user1, value );
	}

	else if ( strstr( line, "USERLABEL2" ) != ( char * )NULL )
	{
	    strcpy( user2, value );
	}

	else if ( strstr( line, "USERLABEL3" ) != ( char * )NULL )
	{
	    strcpy( user3, value );
	}
    }

    fprintf( stderr, "infile  = %s\n", infile_name );
    fprintf( stderr, "outfile = %s\n", outfile_name );
    if ( infile_name == '\0' || outfile_name == '\0' )
    {
	fprintf( stderr, "infile and/or outfile not specified in %s\n",
		config_file_name );
    }
    fprintf( stderr, "%s NumReps MaxWait Print Nchans ", argv[0]);
    fprintf( stderr, "PrePuts Min_time DoAvg All U1 U2 U3\n" );
    fprintf( stderr, "sca3test %d %5.3f %d %d %d %5.3f %d ",
	    repcount, max_wait, print_values, num_chans, num_prelims,
	    min_time_btwn, do_average );
    if ( *all == '\0' )
	fprintf( stderr, " %s", empty_quote );
    else
	fprintf( stderr, " %s", all );

    if ( *user1 == '\0' )
	fprintf( stderr, " %s", empty_quote );
    else
	fprintf( stderr, " %c%s%c", '"', user1, '"' );

    if ( *user2 == '\0' )
	fprintf( stderr, " %s", empty_quote );
    else
	fprintf( stderr, " %c%s%c", '"', user2, '"' );

    if ( *user3 == '\0' )
	fprintf( stderr, " %s\n", empty_quote );
    else
	fprintf( stderr, " %c%s%c\n", '"', user3, '"' );

    fprintf( outfile, "%s NumReps MaxWait Print Nchans ", argv[0]);
    fprintf( outfile, "PrePuts Min_time DoAvg All U1 U2 U3\n" );
    fprintf( outfile, "sca3test %d %5.3f %d %d %d %5.3f %d ",
	    repcount, max_wait, print_values, num_chans, num_prelims,
	    min_time_btwn, do_average );
    if ( *all == '\0' )
	fprintf( outfile, " %s", empty_quote );
    else
	fprintf( outfile, " %s", all );

    if ( *user1 == '\0' )
	fprintf( outfile, " %s", empty_quote );
    else
	fprintf( outfile, " %c%s%c", '"', user1, '"' );

    if ( *user2 == '\0' )
	fprintf( outfile, " %s", empty_quote );
    else
	fprintf( outfile, " %c%s%c", '"', user2, '"' );

    if ( *user3 == '\0' )
	fprintf( outfile, " %s\n", empty_quote );
    else
	fprintf( outfile, " %c%s%c\n", '"', user3, '"' );

    get_begin = tot_begin  = ( double *)calloc( repcount, sizeof( double ) );
    get_end   = put_begin  = ( double *)calloc( repcount, sizeof( double ) );
    put_end   = tot_end    = ( double *)calloc( repcount, sizeof( double ) );

    put_value = ( double *)calloc( num_chans, sizeof( double ) );
    get_value = ( double *)calloc( num_chans, sizeof( double ) );
    get_status=    ( int *)calloc( num_chans, sizeof( int ) );
    put_status=    ( int *)calloc( num_chans, sizeof( int ) );
    pvnames   =   ( char *)calloc( num_chans, pvname_size );
    pvnamez   =   ( char *)calloc( num_chans, pvname_size );

    while( ( get_count < num_chans || put_count < num_chans ) &&
	   fgets( line, LINELENGTH, infile ) )
    {
	line[strlen(line)-1] = ( char )NULL;
	if ( strstr( line, "get " ) != ( char * )NULL )
	{
	    if ( get_count >= num_chans )
		continue;
	    strcpy(  pvnames + get_count * pvname_size, &line[4] );
	    ++get_count;
	}
	else if ( strstr( line, "put " ) != ( char * )NULL )
	{
	    if ( put_count >= num_chans )
		continue;
	    strcpy(  pvnamez + put_count * pvname_size, &line[4] );
	    ++put_count;
	}
    }
    if ( get_count != put_count )
    {
	fprintf( stderr, "get_count(%d) != put_count(%d) from channel list\n",
		get_count, put_count);
	exit( 1 );
    }
    num_chans = get_count;

    for ( i = 0; i < HIST_SIZE; ++i )
    {
	 put_hist[i] = 0;
	 get_hist[i] = 0;
	 tot_hist[i] = 0;
    }

    /* do them all num_prelims times just to establish the connections */
    for ( i = 0; i < num_prelims; ++i ) 
    {
	int pv;
	double ddum;
	int idum;

	num_errors = 0;
	for ( pv = 0; pv < num_chans; ++pv )
	{
	    name = pvnames + pv * pvname_size;
	    stat = que_get( name, SCA_DOUBLE, 1,
		    &put_value[pv], &get_status[pv]);
	    if ( sca_error( stat ) )
	    {
		fprintf( stderr,
		    "prelim %2d %s que_get status 0x%x\n", i, name, stat );
		++num_errors;
	    }
	}
	if ( num_errors )
	{
	    fprintf( stderr,
		"%2d errors doing prelim %2d que_gets of %s,...,%s\n",
		num_errors, i+1, pvnames, pvnames+pvname_size*(num_chans-1) );
	}

	num_errors = do_get( max_wait );
	if ( num_errors )
	    fprintf( stderr,
		"%2d errors doing prelim %2d do_get   of %s,...,%s\n",
		num_errors, i+1, pvnames, pvnames+pvname_size*(num_chans-1) );
    
	num_errors = 0;
	for ( pv = 0; pv < num_chans; ++pv )
	{
	    name = pvnamez + pv * pvname_size;
	    stat = que_put( name, SCA_DOUBLE, 1,
		    &put_value[pv], &put_status[pv] );
	    if ( sca_error( stat ) )
	    {
		fprintf( stderr,
		    "prelim %2d %s que_put status 0x%x\n", i, name, stat );
		++num_errors;
	    }
	}
	if ( num_errors )
	{
	    fprintf( stderr,
		"%2d errors doing prelim %2d que_puts of %s,...,%s\n",
		num_errors, i+1, pvnamez, pvnamez+pvname_size*(num_chans-1) );
	}

	num_errors = do_put( max_wait );
	if ( num_errors )
	    fprintf( stderr,
		"%2d errors doing prelim %2d do_put   of %s,...,%s\n",
		num_errors, i+1, pvnamez, pvnamez+pvname_size*(num_chans-1) );
    }

    if ( min_time_btwn >= 0.0 )
    {
	set_min_time_between_do_puts( min_time_btwn );
	set_min_time_between_do_gets( min_time_btwn );
    }

    if ( do_average)
    {
	first = 1;
	fprintf( outfile, "chart title\tAverage Time for N Channels\n" );
	fprintf( outfile, "xaxis title\tNumber of Channels\n" );
	fprintf( outfile, "yaxis title\tSeconds\t" );
	fprintf( outfile, "%s\n", runtime );

	fprintf( outfile, "label 1\t" );
	fprintf( outfile, "%4d Data points - average +/- 1 std dev\t",
			num_chans );
	fprintf( outfile, "infile = %s\n", infile_name );

	fprintf( outfile, "label 2\t%4d Samples per data point\t", repcount );
	fprintf( outfile, "outfile = %s\n", outfile_name );

	fprintf( outfile, "label 3\t%s\n", &empty_string );

	gethostname( line, LINELENGTH );
	fprintf( outfile, "label 4\thost: %s\t", line );
	fprintf( outfile, "configfile = %s\n", config_file_name );

	fprintf( outfile, "user  1\t%s\n", user1 );
	fprintf( outfile, "user  2\t%s\n", user2 );
	fprintf( outfile, "user  3\t%s\n", user3 );

	fprintf( outfile, "num_chans\t" );
	fprintf( outfile, "put_time\tget_time\t" );
	fprintf( outfile, "tot_time\tput_stddev\t" );
	fprintf( outfile, "get_stddev\ttot_stddev\n" );
    }
    else
    {
	first = num_chans;
    }

    for ( num_channels = first; num_channels <= num_chans; ++num_channels )
    {
	int rep;
/*
	int pv;
	for ( pv = 0; pv < num_channels; ++pv )
	{
	    put_status[pv] = 0x1eeeeeee;
	    get_status[pv] = 0x1fffffff;
	}
*/
	start_time = sca_gettimeofday();
	for ( rep = 0; rep < repcount; ++rep )
	{
	    int channel;
	    char *name;

	    get_begin[rep] = sca_gettimeofday();

	    if ( rep == 0 )
	    {
		name = pvnames;
		for ( channel = 0; channel < num_channels; ++channel )
		{
		    stat = que_get( name, SCA_DOUBLE, 1, &get_value[channel],
			&get_status[channel] );
		    name += pvname_size;
		    if ( sca_error( stat ) )
			++num_que_get_errors;
		}
	    }
	    num_errors = do_get( max_wait );
	    num_get_errors += num_errors;

	    put_begin[rep] = sca_gettimeofday();

	    if ( rep == 0 )
	    {
		name = pvnamez;
		for ( channel = 0; channel < num_channels; ++channel )
		{
		    stat = que_put( name, SCA_DOUBLE, 1, &put_value[channel],
			&put_status[channel] );
		    name += pvname_size;
		    if ( sca_error( stat ) )
			++num_que_put_errors;
		}
	    }
	    num_errors = do_put( max_wait );
	    num_put_errors += num_errors;

	    put_end[rep] = sca_gettimeofday();
	}

	num_get_channels += ( num_channels * repcount );
	num_put_channels += ( num_channels * repcount );
	num_tot_channels = num_get_channels + num_put_channels;

	if ( print_values )
	{
	    int rep;

	    if ( num_channels == first )
	    {
		fprintf( stdout, "\n   nch   rep");
		fprintf( stdout,"  put_time  get_time  tot_time\t( in msec)\n");
	    }

	    for ( rep = 0; rep < repcount; ++rep )
	    {
		double t_time = ( tot_end[rep] - tot_begin[rep] )*1000.;

		fprintf( stdout, "%6d%6d  %8.3f  %8.3f  %8.3f%\n",
		    num_channels, rep+1, (put_end[rep]-put_begin[rep])*1000.,
			   (get_end[rep]-get_begin[rep])*1000., t_time );
	    }
	}
/*
	print_global_stats();
*/


	if ( *all != NULL )
	{
	    fprintf( all_data, "%d", num_channels );
	    for ( rep = 0; rep < repcount; ++rep )
	    {
		fprintf( all_data, "\t%e", get_end[rep] - get_begin[rep] );
	    }
	    fprintf( all_data, "\n" );

	    fprintf( all_data, "%d", num_channels + 10000 );
	    for ( rep = 0; rep < repcount; ++rep )
	    {
		fprintf( all_data, "\t%e", put_end[rep] - put_begin[rep] );
	    }
	    fprintf( all_data, "\n" );

	    fprintf( all_data, "%d", num_channels + 20000 );
	    for ( rep = 0; rep < repcount; ++rep )
	    {
		fprintf( all_data, "\t%e", tot_end[rep] - tot_begin[rep] );
	    }
	    fprintf( all_data, "\n" );
	}

	if ( do_average )
	{
	    double denom;

	    psum = p2sum = 0.0;
	    gsum = g2sum = 0.0;
	    tsum = t2sum = 0.0;

	    for ( rep = 0; rep < repcount; ++rep )
	    {
		put_time = put_end[rep] - put_begin[rep];
		psum += put_time;
		p2sum += put_time * put_time;

		get_time = get_end[rep] - get_begin[rep];
		gsum += get_time;
		g2sum += get_time * get_time;

		tot_time = tot_end[rep] - tot_begin[rep];
		tsum += tot_time;
		t2sum += tot_time * tot_time;
	    }

	    denom = repcount;
	    if ( repcount > 1 )
		denom = denom * ( repcount - 1 );

	    pstddev = sqrt( ( repcount * p2sum - psum * psum ) / denom );
	    gstddev = sqrt( ( repcount * g2sum - gsum * gsum ) / denom );
	    tstddev = sqrt( ( repcount * t2sum - tsum * tsum ) / denom );

	    put_time = psum / repcount;
	    get_time = gsum / repcount;
	    tot_time = tsum / repcount;

	    total_get_time += gsum;
	    total_put_time += psum;
	    total_time += tsum;

	    fprintf( outfile,  "%d\t%13e\t%13e\t%13e\t%13e\t%13e\t%13e\n",
		num_channels, put_time, get_time, tot_time,
		pstddev, gstddev, tstddev);
	}
    }
    if ( *all != NULL ) fclose( all_data );

    if ( do_average == 0 )
    {
	int rep;
	int bin;
	double num_ops = ( double )( repcount * num_chans );
	double num_reps = ( double )repcount;
	psum = gsum = tsum = 0.0;

	for ( rep = 0; rep < repcount; ++rep )
	{
	    put_time = put_end[rep] - put_begin[rep];
	    psum += put_time;
	    bin = (int)( put_time * 1000. + .5 );
	    if ( bin > OVERFLOW_BIN )
		bin = OVERFLOW_BIN;
	    else if ( bin <= UNDERFLOW_BIN )
		bin = UNDERFLOW_BIN;
	    ++put_hist[bin];

	    get_time = get_end[rep] - get_begin[rep];
	    gsum += get_time;
	    bin = (int)( get_time * 1000. + .5 );
	    if ( bin > OVERFLOW_BIN )
		bin = OVERFLOW_BIN;
	    else if ( bin <= UNDERFLOW_BIN )
		bin = UNDERFLOW_BIN;
	    ++get_hist[bin];

	    tot_time = tot_end[rep] - tot_begin[rep];
	    tsum += tot_time;
	    bin = (int)( tot_time * 1000. + .5 );
	    if ( bin > OVERFLOW_BIN )
		bin = OVERFLOW_BIN;
	    else if ( bin <= UNDERFLOW_BIN )
		bin = UNDERFLOW_BIN;
	    ++tot_hist[bin];
	}

	total_get_time = gsum;
	total_put_time = psum;
	total_time = tsum;

	fprintf( outfile,
	    "chart title\tTime to Access %d Channels\n", num_chans );
	fprintf( outfile,
	    "xaxis title\tmsec for %d Channels\n", num_chans );
	fprintf( outfile,
	    "yaxis title\tPercentage of %d Samples\t", repcount );
	fprintf( outfile, "%s\n", runtime );

	fprintf( outfile,
	    "label 1\tget average: %6.1f msec/get\t", gsum/num_ops*1000. );
	fprintf( outfile, "outfile = %s\n", outfile_name );

	fprintf( outfile,
	    "label 2\tput average: %6.1f msec/put\t", psum/num_ops*1000. );
	fprintf( outfile, "infile = %s\n", infile_name );

	fprintf( outfile,
	    "label 3\ttot average: %6.1f msec/get_put\n", tsum/num_ops*1000.);

	gethostname( line, LINELENGTH );
	fprintf( outfile, "label 4\thost       : %s\t", line );
	fprintf( outfile, "configfile = %s\n", config_file_name );

	fprintf( outfile, "user  1\t%s\n", user1 );
	fprintf( outfile, "user  2\t%s\n", user2 );
	fprintf( outfile, "user  3\t%s\n", user3 );

	fprintf( outfile, "msec\tput_pcnt\tget_pcnt\ttot_pcnt" );
	fprintf( outfile, "\tput_freq\tget_freq\ttot_freq\n" );

	for ( bin = 0; bin < HIST_SIZE; ++bin )
	{
	    fprintf( outfile, "%d\t%6.3f\t%6.3f\t%6.3f\t%d\t%d\t%d\n", bin,
		( double )put_hist[bin] / num_reps * 100.,
		( double )get_hist[bin] / num_reps * 100.,
		( double )tot_hist[bin] / num_reps * 100.,
		put_hist[bin], get_hist[bin], tot_hist[bin]);
	}
    }

    average_time = total_time/(double)(num_tot_channels/2)*1000.;

    fprintf( stderr, "%6d gets     ", num_get_channels );
    fprintf( stderr, "in %5.3f sec -> %5.3lf msec/get\n",
	    total_get_time, total_get_time/(double)num_get_channels*1000. );

    fprintf( stderr, "%6d puts     ", num_put_channels );
    fprintf( stderr, "in %5.3f sec -> %5.3lf msec/put\n",
	    total_put_time, total_put_time/(double)num_put_channels*1000. );

    fprintf( stderr, "%6d get_puts ", num_tot_channels/2 );
    fprintf( stderr, "in %5.3f sec -> %5.3lf msec/get_put\n\n",
	    total_time, average_time );

    fprintf( stderr, "%6d errors from que_get()\n", num_que_get_errors );
    fprintf( stderr, "%6d errors from do_get()\n", num_get_errors );
    fprintf( stderr, "%6d errors from que_put()\n", num_que_put_errors );
    fprintf( stderr, "%6d errors from do_put()\n", num_put_errors );

    print_global_stats();
}

int
get_runtime( runtime, sizeof_runtime )
char *runtime;
int sizeof_runtime;
{
    struct timeval tp;
    struct tm *tm_p;
    int cc;

#ifndef WIN32
    struct timezone tzp;
    if ( gettimeofday( &tp, &tzp ) )
#else
    if ( win32_gettimeofday( &tp, (struct timezone*)NULL)  )
#endif
	    return -1;

    tm_p = localtime( ( time_t *)&tp.tv_sec );
    cc = strftime( runtime, sizeof_runtime, "Time %d%b%y %H:%M:%S" , tm_p ); 
    return 0;
}

#ifdef WIN32
int
win32_gettimeofday(struct timeval  *pt, struct timezone *tz)
{
	DWORD win_sys_time;
 	TIMECAPS tc;
	int status;
	static UINT     wTimerRes = 0;
	static long offset_time;

	if (wTimerRes == 0 ) {	  /* initialize timer */
 		wTimerRes = min(max(tc.wPeriodMin, 1), tc.wPeriodMax);
		status = timeBeginPeriod(wTimerRes); 
		if (status != TIMERR_NOERROR)
			printf("timer setup failed\n");
		offset_time = (long)time(NULL) - (long)timeGetTime()/1000;
	}

	win_sys_time = timeGetTime();
	pt->tv_sec = (long)win_sys_time/1000 + offset_time;
	pt->tv_usec = (long)((win_sys_time % 1000) * 1000);
	return 0;
}

#endif
