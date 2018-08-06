#include <stdio.h>
#include <stdlib.h>
#include <malloc.h>
#include <string.h>
#ifndef WIN32
#include <strings.h>
#endif

#include "scalib.h"

#define LINE_SIZE		4095

#define GETTING_FIELD_NAME	0	/* internal states */
#define GETTING_VALUES		1

int prep_for_strtok( char *string, char delim );
int is_a_number( char *c );

main( argc, argv )
int argc;
char *argv[];
{
    int status;
    int pvnames_count = 0;
    int values_count = 0;

    char line[LINE_SIZE];
    char name[SCA_EPICS_NAME_STRING_SIZE];

    char values[SCA_MAX_PUT_COUNT*SCA_MAX_STRING];
    int put_status[SCA_MAX_PUT_COUNT];

    int state = GETTING_FIELD_NAME;
    int arg;
    int num_values_are_numbers;

    char separator[2];
    char *c;
    separator[0] = ( char)128;
    separator[1] = ( char)NULL;

    for ( arg = 1; arg < argc; arg += 2 ) /* check args for pv names and values*/
    {
	int next_arg =  arg + 1;

	if ( *argv[arg] == '\0' ) break;
	if ( next_arg >= argc ) break;		/* name without value */
	if ( *argv[next_arg] == '\0' ) break;

	++pvnames_count;

    }

    if ( pvnames_count > 0 )
    {
	int pv;
	int status;
	int num_put_errors;
	int arg = 1;

	for ( pv = 0; pv < pvnames_count; ++pv )
	{
	    int status =
		que_put( argv[arg], SCA_STRING, 1, argv[arg+1],&put_status[pv] );
	    arg += 2;
	}
	
	num_put_errors = do_put( 5.0 );

	if ( num_put_errors > 0 )
	    printf("%s: %d put errors\n", argv[0], num_put_errors );
    }

    else
    {		
	state = GETTING_FIELD_NAME;

	while( fgets( line, LINE_SIZE-2, stdin ) != (char * )NULL )
	{
	    int i, j, l;
	    int status;
	    int strtok_count;
	    int line_continued = 0;

	    if ( line[0] == '\n' ) continue;	/* skip empty lines */
	    if ( line[0] == '#' ) continue;	/* skip comment     */

	    l = strlen( line );		/* check for line buffer overflow */
	    if ( line[l-1] != '\n' )
	    {
		line[SCA_PVNAME_SZ + 20] = '\0';
		fprintf( stderr, "scaput:\tInput line too long for buffer!\n" );
		fprintf( stderr, "\tSkipping %s...\n", line );
		state = GETTING_FIELD_NAME;
		continue;
	    }

	    line[l-1] = '\0';		/* change newline to NULL */
	    if ( line[l-2] == '\\' )
	    {
		line_continued = 1;	/* remember backslash */
		line[l-2] = '\0';	/* change backslash to NULL */
	    }

	    prep_for_strtok( line, separator[0] );
	    strtok_count = 0;

	    switch ( state )
	    {
		case GETTING_FIELD_NAME:
		{
		    /* get pv field name. */
		    if ( strtok_count++ == 0 )
			c = strtok( line, separator );
		    else
			c = strtok( NULL, separator );

		    if ( c == ( char *)NULL)
			break;

		    if ( strlen( c ) < SCA_EPICS_NAME_STRING_SIZE )
		    {
			strcpy( name, c );
			state = GETTING_VALUES;
			values_count = 0;
			num_values_are_numbers = 0;
			/* no break so we can fall thru to GETTING_VALUES */
		    }
		    else
		    {
			fprintf( stderr,
			"scaput:\tChannel name too long!\n" );
			fprintf( stderr, "\tSkipping %s...\n", line );
			break;
		    }
		}
		/* no break so we can fall thru to GETTING_VALUES */

		case GETTING_VALUES:
		{
		    while ( 1 )
		    {
			int l;
			if ( strtok_count++ == 0 )
			    c = strtok( line, separator );
			else
			    c = strtok( NULL, separator );

			if ( c == ( char)NULL )
			{
			    if ( line_continued )
				break;

			    if (values_count == 1 ||
				values_count != num_values_are_numbers )
			    {
				int status = que_put( name, SCA_STRING,
					values_count, values, &put_status[0] );

				int errcnt = do_put( 5.0 );
				if ( errcnt > 0 )
				    printf("%s: %d put errors\n",
					argv[0], errcnt );
			    }
			    else if (values_count > 1 )
			    {
				int status;
				int errcnt;
				double *dv = (double *)malloc(
					values_count * sizeof( double ) );
				int i;
				for ( i = 0; i < values_count; ++i )
				    sscanf( values+i*SCA_MAX_STRING, "%lf",
					dv + i );

				status = que_put( name, SCA_DOUBLE,
					values_count, dv, &put_status[0] );

				errcnt = do_put( 5.0 );
				if ( errcnt > 0 )
				    printf("%s: %d put errors\n",
					argv[0], errcnt );

				free( dv );
			    }
			    state = GETTING_FIELD_NAME;
			    break;
			}
			else
			{
			    char *p = &values[values_count*SCA_MAX_STRING];
			    if ( *c == '"' )	/* remove quotes if any */
			    {
				l = strlen( c );
				if ( c[l-1] == '"' )
				    c[l-1] = ( char)NULL; /* NULL closing " */
				++c;			  /* skip opening " */
			    }
			    strcpy(p, c );
			    ++values_count;
			    num_values_are_numbers += is_a_number( p );
			}
		    }
		}
		break;
	    }
	}
    }
}

/* prep_for_strtok() takes a null_terminated string containing fields
   separated by blanks and/or tabs and returns it with all the blanks
   and tabs changed to delim.  Compound fields and empty fields must
   be enclosed in double quotes.  Blanks and tabs are preserved within quotes.
   This allows the fields to be readily accessed via strtok() with delim
   in the separator string.  The quoted fields retain the quotes.

   With delim = '|'
	< 	"The next field is empty" "" goodbye 1.0>
   becomes
	<||"The next field is empty"|""|goodbye|1.0>
*/

int
prep_for_strtok( char *c, char delim )
{
#define FIND_START_OF_FIELD		0 /* internal state definitions */
#define FIND_END_OF_FIELD		1
#define FIND_END_OF_QUOTED_FIELD	2

    int state;				/* internal state */

    state = FIND_START_OF_FIELD;

    while( *c )		/* not done till hit end of string */
    {
	switch ( state )
	{
	    case FIND_START_OF_FIELD:
		/* convert blank and tab to delim until start of field */

		if ( *c == ' ' || *c == '\t' )
		    *c = delim;
		else if ( *c == '"' )
		    state = FIND_END_OF_QUOTED_FIELD;
		else
		    state = FIND_END_OF_FIELD;
		break;

	    case FIND_END_OF_FIELD:
		/* find end of a blank or tab delimited field */
		if ( *c == ' ' || *c == '\t' )
		{
		    *c = delim;
		    state = FIND_START_OF_FIELD;
		}
	    break;

	    case FIND_END_OF_QUOTED_FIELD:
		/* find end of a double quoted field */
		if ( *c == '"' )
		{
		    state = FIND_END_OF_FIELD;
		    /* now copy to  blank or tab. This will keep a trailing */
		    /* backslash(continuation symbol) with the field */
		}
	    break;
	}
	++c;
    }
}
/*
    is_a_number() determines if a string represents a decimal number.

    A number is an optional sign(+/-) followed by digits and at most 
    one decimal point.
*/
#define IS_A_NUMBER	1
#define IS_NOT_A_NUMBER	0
int
is_a_number( char *c )
{
    int num_digits = 0;
    if ( *c == ( char)NULL )		/* is string empty? */
	return IS_NOT_A_NUMBER;

    else if ( *c == '"' )		/* is quoted? */
	return IS_NOT_A_NUMBER;

    if ( *c == '+' || *c == '-' )	/* skip over sign */
	++c;

    while ( *c )			/* get digits before decimal point */
    {
	if ( isdigit( *c ) )
	{
	   ++c;
	   ++num_digits;
	}
	else
	{
	    if ( *c == '.' )
	    {
		++c;
		while( *c )		/* get digits after decimal point */
		{
		    if ( isdigit( *c ) )
		    {
			++c;
			++num_digits;
		    }
		    else
		    {
			return IS_NOT_A_NUMBER;
		    }
		}
		break;
	    }
	    else
		return IS_NOT_A_NUMBER;
	}
    }
    if ( num_digits > 0 )
	return IS_A_NUMBER;
    else
	return IS_NOT_A_NUMBER;
}
