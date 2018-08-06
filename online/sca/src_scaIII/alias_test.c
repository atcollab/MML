/*
**  read the alias file and setup the aliases
**
**  expect	alias1	alias_alias1
**		el2	alias_el2
**
*/

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <sys/time.h>
#include <strings.h>
#include <string.h>

#include "scalib.h"

double timeout;

int status;
float el1val, el2val, wfmval[3];
float alias1val, alias2val, alias3val[3];
float putvals[3];

int e1fst, e2fst, wfmfst, wfmpfst, wfmgfst;
int a1fst, a2fst, a3fst;

int el1st, el2st, wfmst, wfmpst, wfmgst;
int alias1st, alias2st, alias3st;

main( argc, argv )
int argc;
char *argv[];
{
    int i;

    if ( argc == 1 )
    {
	printf( "Usage: alias_test path timeout print_flag\n" );
	exit( 0 );
    }

    if ( argc >= 3 )
	timeout = atof( argv[2] );
    else
	timeout = 5.0;

    printf( "path to alias_file = <%s>\n", argv[1] );
    printf( "timeout            = <%g>\n", timeout );

    status = sca_setup_aliases( argv[1], timeout );
    printf( "sca_setup_aliases status = %d\n", status );
    if ( status < 0 ) exit( 0 );

    for ( i = 0; i < 3; ++i )
    {
	e1fst =
	    do_getbyname( "SR01:AC34:AC00", SCA_FLOAT, 1, &el1val, &el1st );
	e2fst =
	    do_getbyname( "SR01:AC34:AC01", SCA_FLOAT, 1, &el2val, &el2st );

	a1fst =
	    do_getbyname( "alias1", SCA_FLOAT, 1, &alias1val, &alias1st );
	a2fst =
	    do_getbyname( "alias2", SCA_FLOAT, 1, &alias2val, &alias2st );

	printf( "\n%15s %9s %9s %10s\n",
	    "name", "fstat", "stat",  "value");

	printf( "%15s %9x %9x %10g\n",
	    "jane.VAL", e1fst, el1st, el1val );

	printf( "%15s %9x %9x %10g\n",
	    "fred.VAL", e2fst, el2st, el2val );


	printf( "%15s %9x %9x %10g\n",
	    "alias1.VAL", a1fst, alias1st, alias1val );

	printf( "%15s %9x %9x %10g\n",
	    "alias2.VAL", a2fst, alias2st, alias2val );

	usleep( 1000000 );	/* give el1, el2 a chance to change in IOC */
    }
	exit (0);
{
    int fst;
    int st;

    char putstr[3][40] = {"A","B","C"};
    char str[3][40];

    short putsht[3] = {68, 69, 70};
    short sht[3];

    float putflt[3] = { 71.1, 72.2, 73.3};
    float flt[3];

    short putenm[3] = {74, 75, 76};
    short enm[3];

    char putchr_[3] = {'M', 'N', 'O'};
    char chr_[3];

    long putlng[3] = {80, 81, 82};
    long lng[3];

    double putdbl[3] = {83, 84, 85};
    double dbl[3];

    int putint_[3] = {86, 87, 88};
    int int_[3];

    fst = do_putbyname( "wfmstring", SCA_STRING, 3, &putstr[0], &st );
    fst = do_getbyname( "wfmstring", SCA_STRING, 3, &str[0], &st );
    printf( "\n%15s %9x %9x %10s %10s %10s\n",
	"wfmstring", fst, st, &str[0][0], &str[1][0], &str[2][0] );

    fst = do_putbyname( "wfmshort", SCA_SHORT, 3, &putsht[0], &st );
    fst = do_getbyname( "wfmshort", SCA_SHORT, 3, &sht[0], &st );
    printf( "%15s %9x %9x %10d %10d %10d\n",
	"wfmshort", fst, st, sht[0], sht[1], sht[2] );

    fst = do_putbyname( "wfmfloat", SCA_FLOAT, 3, &putflt[0], &st );
    fst = do_getbyname( "wfmfloat", SCA_FLOAT, 3, &flt[0], &st );
    printf( "%15s %9x %9x %10g %10g %10g\n",
	"wfmfloat", fst, st, flt[0], flt[1], flt[2] );

    fst = do_putbyname( "wfmenum", SCA_ENUM, 3, &putenm[0], &st );
    fst = do_getbyname( "wfmenum", SCA_ENUM, 3, &enm[0], &st );
    printf( "%15s %9x %9x %10c %10c %10c\n",
	"wfmenum", fst, st, enm[0], enm[1], enm[2] );

    fst = do_putbyname( "wfmchar", SCA_CHAR, 3, &putchr_[0], &st );
    fst = do_getbyname( "wfmchar", SCA_CHAR, 3, &chr_[0], &st );
    printf( "%15s %9x %9x %10c %10c %10c\n",
	"wfmchar", fst, st, chr_[0], chr_[1], chr_[2] );

    fst = do_putbyname( "wfmlong", SCA_LONG, 3, &putlng[0], &st );
    fst = do_getbyname( "wfmlong", SCA_LONG, 3, &lng[0], &st );
    printf( "%15s %9x %9x %10ld %10ld %10ld\n",
	"wfmlong", fst, st, lng[0], lng[1], lng[2] );

    fst = do_putbyname( "wfmdouble", SCA_DOUBLE, 3, &putdbl[0], &st );
    fst = do_getbyname( "wfmdouble", SCA_DOUBLE, 3, &dbl[0], &st );
    printf( "%15s %9x %9x %10g %10g %10g\n",
	"wfmdouble", fst, st, dbl[0], dbl[1], dbl[2] );

    fst = do_putbyname( "wfmint", SCA_INT, 3, &putint_[0], &st );
    fst = do_getbyname( "wfmint", SCA_INT, 3, &int_[0], &st );
    printf( "%15s %9x %9x %10d %10d %10d\n",
	"wfmint", fst, st, int_[0], int_[1], int_[2] );
}

    if ( argc > 3 ) print_aps();
}
