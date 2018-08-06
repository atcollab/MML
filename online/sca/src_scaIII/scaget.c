#include <stdio.h>
#include <stdlib.h>
#include <string.h>


#include "scalib.h"
#include "scaget.h"

#define PVNAME_BUFFER_SIZE	2047
#define LINE_SIZE		255

typedef struct {
    void *next;
    char pvname[SCA_EPICS_NAME_STRING_SIZE];
    int num_values;
    char *pvalue;
    int pstatus;
}SCAGET_PARAMS;

SCAGET_PARAMS *getlist = ( SCAGET_PARAMS * )NULL;
SCAGET_PARAMS *getlist_last = ( SCAGET_PARAMS * )NULL;
int pvnames_count = 0;
char _line_[LINE_SIZE+1];

#define MAX_CHARS_IN_NUM_VALUES	8

main( argc, argv )
int argc;
char *argv[];
{
    char line[LINE_SIZE+1];
    char num_to_get[MAX_CHARS_IN_NUM_VALUES+1];
    
    int exit_stat;

    int i, j;

    exit_stat = SCAGET_NOTHING_DONE;
    strcpy( num_to_get, "1" );

    build_getlist( &num_to_get, &argv[1], argc - 1 );

#define MAX_FIELDS	(LINE_SIZE/2)

    if ( pvnames_count == 0 )
    {		
	while( fgets( line, LINE_SIZE, stdin ) != (char * )NULL )
	{

	    int i;
	    int num_len;
	    int len = strlen( line ) - 1;
	    char delimiters[3] = { " 	" }; /* space/tab = field delimeters */
	    int num_fields = 0;
	    char *fields[MAX_FIELDS];

	    if( len <= 0 )
		continue;
	    line[len] = '\0';

	    if ( line[0] == '#' )
		continue;

	    for ( i = 0; i < MAX_FIELDS; ++i )
	    {
		if ( i == 0 )
		{
		    fields[i] = strtok( line, delimiters );
		}
		else
		{
		    fields[i] = strtok( NULL, delimiters );
		}

		if ( fields[i] == ( char *)NULL )
		    break;
		else
		    ++num_fields;
	    }

	    if ( num_fields > 0 )
		build_getlist( &num_to_get, &fields[0], num_fields );

	    if ( pvnames_count >= SCA_MAX_GET_COUNT )
		break;
	}
    }

    if ( pvnames_count > 0 )
    {
	int status;
	SCAGET_PARAMS *p = getlist;

	exit_stat = SCAGET_OK;
	while( p != ( SCAGET_PARAMS *)NULL )
	{
	    status = que_get( p->pvname, SCA_STRING, p->num_values,
		p->pvalue, &p->pstatus );
	    p = ( SCAGET_PARAMS *)p->next;
	}

	status = do_get( 5.0 );

	p = getlist;
	while( p != ( SCAGET_PARAMS *)NULL )
	{
	    int i;
	    fprintf( stdout, "%s", p->pvname );

	    for ( i = 0; i < p->num_values; ++i )
	    {
		char *this_value = p->pvalue + i * SCA_MAX_STRING;
		if ( sca_error( p->pstatus ) ) {
		    fprintf( stdout, "\t%s", "<get_error>" );
			print_sca_status(p->pstatus);
		} else if ( this_value[0] == '\0' )
		    fprintf( stdout, "\t%s", "<null_string>" );
		else
		    fprintf( stdout, "\t%s", this_value );
	    }
	    fprintf( stdout, "\n" ); 
	    p = ( SCAGET_PARAMS *)p->next;
	}

	p = getlist;
	while( p != ( SCAGET_PARAMS *)NULL )
	{
	    SCAGET_PARAMS *pnext = ( SCAGET_PARAMS *)p->next;
	    free( p->pvalue );
	    free( p );
	    p = pnext;
	}
    }
    else
    {
	fprintf( stderr, "Usage: scaget [[nelm] pvname]]...\n" );
        exit_stat = SCAGET_NO_CHAN_NAMES;
    }

    /*if ( exit_stat == 0 || exit_stat == 1 )
	ca_task_exit();*/

    exit(exit_stat);
}
int
add_to_getlist( pvname )
char *pvname;		/* pvname is 'pvname' or 'num_values pvname' */
{
    int one = 1;
    int *num_values = &one;
    char *name = pvname;
    char *space = ( char *)strchr( pvname, ( int)(' ') );
    SCAGET_PARAMS *new;

    if ( space != ( char *)NULL )
    {
	int num = atoi( pvname );
	if ( num > 1 ) num_values = &num;

	if ( *(++space) != '\0' );
	    name = space;
    }
    new = ( SCAGET_PARAMS *)calloc( 1, sizeof( SCAGET_PARAMS ) );
    strcpy( new->pvname, name );
    new->num_values = *num_values;
    new->pvalue = ( char *)calloc( new->num_values, SCA_MAX_STRING );

    if ( getlist == ( SCAGET_PARAMS *)NULL )
    {
	getlist = new;
	getlist_last = new;
    }
    else
    {
	getlist_last->next = ( void *)new;
	getlist_last = ( void *)new;
    }

    ++pvnames_count;
}

int
is_a_number( text )
char *text;
{
    char c;
    char *p = text;
    while( ( c = *p++ ) != '\0' )
	if ( c < '0' || c > '9' )
	    return 0;
    return p - text - 1;
}

int
build_getlist( char *num_to_get, char **argV, int argC )
{
    int j;
    for ( j = 0; j < argC; ++j )	/* get pv names & num_values */
    {
	int num_len;
	if ( *argV[j] == '\0' )
	    break;

	if ( num_len = is_a_number( argV[j] ) )
	{
	    int num = atoi( argV[j] );
	    if ( num < 1 || num_len > MAX_CHARS_IN_NUM_VALUES )
		strcpy( num_to_get, "1" );
	    else
		strcpy( num_to_get, argV[j] );
	    continue;
	}

	strcpy( _line_, num_to_get );	/* form 'number pvname' */
	strcat( _line_, " " );
	strcat( _line_, argV[j] );

	add_to_getlist( _line_ );
    }
}
