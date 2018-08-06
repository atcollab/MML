/*
** group_test.c
**
*/

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <assert.h>
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
#define NUM_GROUPS	4

#define MAX_REPS	1000
#define DEFAULT_REPS	1

#define MIN_TESTNUM	1
#define MAX_TESTNUM	4
#define DEFAULT_TESTNUM	1

double do_get_timeout = .4;
double do_get_time;
char vursion[] = { "12345678901" };

typedef struct
{
	char value[SCA_MAX_STRING];
} SINGLE_VALUE;

char
current_group_name[SCA_MAX_STRING];

char *
group_names[NUM_GROUPS]     = { "Group1","Group2","Group3","Group4" };

char *
group_name[NUM_PVNAMES]     = { "Group1",	"Group2",	"Group2",
				"Group3",	"Group3",	"Group3",
				"Group3",	"Group4",	"Group4",
				"Group4"	};

char *pv_names[NUM_PVNAMES] = { "el1",		"el2",		"string_wfm",
				"short_wfm",	"float_wfm",	"enum_wfm",
				"char_wfm",	"long_wfm",	"double_wfm",
				"str2dblwfm"	};

int scaType[NUM_PVNAMES]    = { SCA_DOUBLE,	SCA_DOUBLE,	SCA_STRING,
				SCA_SHORT,	SCA_FLOAT,	SCA_ENUM, 
				SCA_CHAR,	SCA_LONG,	SCA_DOUBLE,
				SCA_STRING	};

int nelm[NUM_PVNAMES]	    = { 1,		1,		WFM_NELM,
				WFM_NELM,	WFM_NELM,	WFM_NELM,
				WFM_NELM,	WFM_NELM,	WFM_NELM,
				WFM_NELM	};

int remove_order[NUM_PVNAMES]={ 6,		2,		1,
				5,		7,		4,
				8,		3,		9,
				10		};

void *group_ids[NUM_PVNAMES];		/* from group_addchannel */
void *channel_ids[NUM_PVNAMES];		/* from group_addchannel */

/* default values so we can see changes */

double	       el1_do_put_value = {1.0};       /* do not queue put since these*/
double	       el2_do_put_value = {1.0};       /* are on 1 second scan */
SINGLE_VALUE   wf_str_do_put_values[WFM_NELM]  = { "200", "201", "202"};
short          wf_sht_do_put_values[WFM_NELM]  = { 3000, 3001, 3002};
float          wf_flt_do_put_values[WFM_NELM]  = { 10.1, 10.2, 10.3};
unsigned short wf_enm_do_put_values[WFM_NELM]  = { 40000, 40001, 40002};
char           wf_char_do_put_values[WFM_NELM+1] = { 'a', 'b', 'c', '\0'};
long           wf_lng_do_put_values[WFM_NELM]  = { 2400, 2401, 2402};
double         wf_dbl_do_put_values[WFM_NELM]  = { 0.1, 0.2, 0.3};
SINGLE_VALUE   wf_str2dbl_do_put_values[WFM_NELM]  = { "400", "401", "402"};

double		el1_group_get_value = {-121.0};
double		el2_group_get_value = {-121.0};
SINGLE_VALUE  	wf_str_group_get_values[WFM_NELM] = { "777", "888", "999"};
short 		wf_sht_group_get_values[WFM_NELM] = { 6000., 6000, 6000};
float		wf_flt_group_get_values[WFM_NELM] = { 888., 888., 888.};
unsigned short	wf_enm_group_get_values[WFM_NELM] = { 64000., 64000, 64000};
char		wf_char_group_get_values[WFM_NELM+1] = { 'z', 'z', 'z', '\0'};
long		wf_lng_group_get_values[WFM_NELM] = { 64000., 64000, 64000};
double		wf_dbl_group_get_values[WFM_NELM] = { 999., 999., 999.};
SINGLE_VALUE  	wf_str2dbl_group_get_values[WFM_NELM] = { "123", "456", "789"};

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


    void *do_put_values[NUM_PVNAMES] = {
	&el1_do_put_value, &el2_do_put_value,
	wf_str_do_put_values,
	wf_sht_do_put_values, wf_flt_do_put_values,
	wf_enm_do_put_values, wf_char_do_put_values,
	wf_lng_do_put_values, wf_dbl_do_put_values, wf_str2dbl_do_put_values };

    void *group_get_values[NUM_PVNAMES] = {
	&el1_group_get_value, &el2_group_get_value,
	wf_str_group_get_values,
	wf_sht_group_get_values, wf_flt_group_get_values,
	wf_enm_group_get_values, wf_char_group_get_values,
	wf_lng_group_get_values, wf_dbl_group_get_values,
	wf_str2dbl_group_get_values };

    void *increments[NUM_PVNAMES] = {
	&el1_increments, &el2_increments,
	wf_str_increments,
	wf_sht_increments, wf_flt_increments,
	wf_enm_increments, wf_char_increments,
	wf_lng_increments, wf_dbl_increments, wf_str2dbl_increments };

    int i, j, rep;
    int group, channel;
    int num_reps = DEFAULT_REPS;
    int testnum = DEFAULT_TESTNUM;

    num_que_put_errors = 0;
    num_que_get_errors = 0;

    for ( i = 0; i < MAX_REPS; ++i )
    {
	num_do_put_errors[i] = 0;
	num_do_get_errors[i] = 0;
    }

    if ( argc > 1 )
    {
	if ( strstr( argv[1], "help" ) )		/* usage */
	    usage();

	num_reps = atoi( argv[1] );			/* num_reps */
	if ( num_reps > MAX_REPS )
	    num_reps = MAX_REPS;
	    
    }

    if ( argc > 2 )				/* test number */
    {
	testnum = atoi( argv[2] );
	if ( testnum > MAX_TESTNUM )
	    testnum = DEFAULT_TESTNUM;
	else if ( testnum < MIN_TESTNUM )
	    testnum = DEFAULT_TESTNUM;
    }


    printf( "group_test: num_reps = %d testnum = %d\n", num_reps, testnum );
    /* create groups of channels from list */
    if ( testnum == 1 || testnum == 4 )
    {
	for ( channel = 0; channel < NUM_PVNAMES; ++channel )
	{
	    int status;
	    void *dummy;

	    status = group_addchannel(	group_name[channel],
					    pv_names[channel],
					    scaType[channel],
					    nelm[channel],
					    ( void **)NULL,
					    ( void **)NULL );
	    if ( sca_error( status ) )
	    {
		printf( "group_addchannel: " );
		print_sca_status( status );
		printf( "Error adding group %s channel %s.\n",
		    group_name[channel], pv_names[channel] );
	    }
	}
    }

    else if ( testnum == 2 )
    {
	;
    }

    else if ( testnum == 3 )
    {
	for ( channel = 0; channel < NUM_PVNAMES; ++channel )
	{
	    int status;

	    status = group_addchannel(	group_name[channel],
			    		pv_names[channel],
			    		scaType[channel],
			    		nelm[channel],
					&group_ids[channel],
					&channel_ids[channel]);
	    if ( sca_error( status ) )
	    {
		printf( "group_addchannel: " );
		print_sca_status( status );
		printf( "Error adding group %s channel %s.\n",
		    group_name[channel], pv_names[channel] );
	    }
	}
    }

    /* do_get will ca_pend_event() to insure do_gets are no more frequent
    ** than min_time_between_do_gets.  */
    set_min_time_between_do_gets( .5 );
    for ( group = 0; group < NUM_GROUPS; ++group )
    {
	/* 0.0 forces no put_callbacks */
	group_set_do_put_timeout( group_name[group], (double)1.0 );

	group_set_refresh_period( group_name[group], .1 );
    }


    for ( rep = 0; rep < num_reps; ++rep )
    {
	typedef union
	{
	    double doublev[WFM_NELM];
	    char stringv[SCA_MAX_STRING*WFM_NELM];
	    short shortv[WFM_NELM];
	    float floatv[WFM_NELM];
	    short enumv[WFM_NELM];
	    char charv[WFM_NELM];
	    long longv[WFM_NELM];
	}VALUE;

	/* change the put values for the next repetition */
	for ( channel = 0; channel < NUM_PVNAMES; ++channel )
	{
	    int status;
	    inc_put_values( (void *)do_put_values[channel], nelm[channel],
				scaType[channel], (void *)increments[channel] );

	    status = group_putchannelbyname(group_name[channel],
					    pv_names[channel],
					    scaType[channel],
					    nelm[channel],
					    (void *)do_put_values[channel],
					    &put_status[channel]
					    );
	}

	for ( group = 0; group < NUM_GROUPS; ++group )
	{
	    group_flushbyname( group_names[group] );
	}

	printf( "\n" );
	current_group_name[0] = ( char)NULL;

	printf( "%4s %4s %4s %10s %4s %4s %8s %8s %8s\n",
					"rep",
					"item", 
					"grp",
					"channel",
					"Type",
					"nelm",
					"getstat",
					"putstat",
					"value(s)"
					);

	for ( channel = 0; channel < NUM_PVNAMES; ++channel )
	{
	    int vstatus;
	    int status;
	    int getstatus, putstatus;

	    if ( testnum == 1 || testnum == 2 )
	    {
		status = group_getchannelbyname( group_name[channel],
				    pv_names[channel],
				    scaType[channel],
				    nelm[channel],
				    (void *)group_get_values[channel],
				    &vstatus
				    );
	    }

	    else if ( testnum == 3 )
	    {
		status = group_getchannel( channel_ids[channel],
				    nelm[channel],
				    (void *)group_get_values[channel],
				    &vstatus
				    );
	    }

	    else if ( testnum == 4 )
	    {
		if ( strcmp( group_name[channel], current_group_name ) != 0 )
		{
		    strcpy( current_group_name, group_name[channel] );
		    status = group_getfirstchannelbyname( group_name[channel],
					    nelm[channel],
					    (void *)group_get_values[channel],
					    &vstatus );
		}
		else
		{
		    status = group_getnextchannelbyname( group_name[channel],
					    nelm[channel],
					    (void *)group_get_values[channel],
					    &vstatus );
		}
	    }

	    else
	    {
		printf( "Unrecognizable testnum = %d\n", testnum );
		exit( 4 );
	    }

	    if ( testnum == 3 )
		group_getchannelstatus( channel_ids[channel],
					&getstatus, &putstatus );
	    else
		group_getchannelstatusbyname( group_name[channel],
					pv_names[channel],
					scaType[channel],
					&getstatus, &putstatus );

	    printf( "%4d %4d %4d %10s %4d %4d %08x %08x",
					rep+1,
					channel+1, 
					( int)group_name[channel][5]-( int)'0',
					pv_names[channel],
					scaType[channel],
					nelm[channel],
					getstatus,
					putstatus
					);

	    print_values( (void *)group_get_values[channel],
			nelm[channel], scaType[channel] );
	    printf( "\n" );

	}

	for ( group = 0; group < NUM_GROUPS; ++group )
	{
	    group_get_do_get_timeout( group_name[group],
				&do_get_timeout, &do_get_time );
	    printf( "%s do_get_timeout %5.3f do_get_time %5.3f\n",
		group_names[group], do_get_timeout, do_get_time );

	}
{
int x;
for(x=0;x<WFM_NELM;++x)
printf( "put: %d vs got: %d; ",
wf_lng_do_put_values[x], wf_lng_group_get_values[x] );
printf("\n");
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
		    printf( "<%s> ", blank_field );
		else
		    if ( ((( SINGLE_VALUE *)values)[j].value[0]) == '\0' )
			printf( "%7s", "nil" );
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
		{
		    printf( "%7.1f", ( ( float *)values)[j] );
		    /*printf( "<0x%x>", ( ( long *)values)[j] );*/
		}
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
		    if ( ( ( unsigned char *)values)[j] == '\0' )
			printf( "%7s", "nil" );
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
		{
		    printf( "%7.1f", ( ( double *)values)[j] );
		    /*printf( "<0x%x> <0x%x>", ( ( long *)values)[j], ( ( ( long *)values)[j])+1 );*/
		}
	    break;
	}
    }
}
int
usage()
{
    printf( "\n " );
    printf( " Usage: group_test  [num_reps | help] [grouping_testnum]\n" );
    printf( "        No args->group_test 1 %d\n\n",
			DEFAULT_REPS, DEFAULT_TESTNUM );

    printf( "        grouping_testnum 1 - " );
    printf( "Build groups by name with group_addchannel().\n" );
    printf( "                            " );
    printf( "Access by name with group_getchannelbyname().\n" );

    printf( "        grouping_testnum 2 - " );
    printf( "Build groups by name with group_getchannelbyname().\n" );
    printf( "                            " );
    printf( "Access by name with group_getchannelbyname().\n" );

    printf( "        grouping_testnum 3 - " );
    printf( "Build groups with group_addchannel().\n" );
    printf( "                            " );
    printf( "Access by pointer with group_getchannel().\n" );

    printf( "        grouping_testnum 4 - " );
    printf( "Build groups by name with group_addchannel().\n" );
    printf( "                            " );
    printf( "Access by using group_getfirstchannel() and \n" );
    printf( "                            " );
    printf( "group_getnextchannel().\n" );

    exit( 0 );
}
