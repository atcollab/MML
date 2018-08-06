/*
**  connect_test.c is used to  answer the following question:
**
**	Question:
**  	If a process using sca asks for a pv in more than one
**	format, do they all share the same chid?

**	Method:
**  	    status = do_getbyname( "el1", SCA_DOUBLE, 1, *dvalue, &dstatus );
**  	    status = do_getbyname( "el1", SCA_FLOAT, 1, *fvalue, &fstatus );
**  	    status = do_getbyname( "el1", SCA_STRING, 1, *svalue, &sstatus );
**	    print_aps();
**	or
**	    status = cache_set( "el1", SCA_DOUBLE, 1, &dap );
**	    status = cache_set( "el1", SCA_FLOAT, 1, &fap );
**	    status = cache_set( "el1", SCA_STRING, 1, &sap );
**	    print_aps();
**
**	Observation:
**	    The three aps had different channel_id pointers.
**	    client_stat in the ioc also reported 3 channels.
** 
**	Answer:
**	NO!  There is not a single shared connection for "el1.VAL"
**
**	Usage: connect_test
**
*/

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <sys/time.h>
#include <strings.h>
#include <string.h>

#include "scalib.h"

double dvalue;
float fvalue;
char svalue[SCA_MAX_STRING];

int status, dstatus, fstatus, sstatus;
void *dap, *fap, *sap, *d2ap;

main( argc, argv )
int argc;
char *argv[];
{
    status = cache_set( "el1.VAL", SCA_DOUBLE, 1, &dap );
    status = cache_set( "el1.VAL", SCA_FLOAT, 1, &fap );
    status = cache_set( "el1.VAL", SCA_STRING, 1, &sap );
    status = cache_set( "el1.ARF", SCA_DOUBLE, 1, &d2ap );
    print_aps();

    status = do_getbyname( "el1.VAL", SCA_DOUBLE, 1, &dvalue, &dstatus );
    status = do_getbyname( "el1.VAL", SCA_FLOAT, 1, &fvalue, &fstatus );
    status = do_getbyname( "el1.VAL", SCA_STRING, 1, &svalue, &sstatus );
    print_aps();

    printf( "\n%g %g %s\n", dvalue, fvalue, svalue );

    usleep(100000000);
}
