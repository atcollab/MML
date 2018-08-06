/* $Id: gnelm.c,v 1.6 2007/05/23 02:50:15 strauman Exp $ */

#include <cadef.h>
#include <multiEzca.h>
#include <stdio.h>
#include <stdarg.h>

/* Trivial command line utility using multi-ezca / ezca
 * useful for debugging DLL / PATH problems under WIN32
 */

/* Author: Till Straumann <strauman@slac.stanford.edu>, 2003 */

#define MAX_PVS 25

int
main(int argc, char **argv)
{
int blah[MAX_PVS];
int i;
if (--argc > MAX_PVS)
  argc = MAX_PVS;
if (!argc) {
	fprintf(stderr,"Usage: %s PV [PV] [PV]...\n",argv[0]);
	exit(1);
}
argv++; 
multi_ezca_get_nelem(argv,argc,blah,0);
printf("Numbers of elements of the requested PV(s) is/are:\n");
for (i=0; i<argc; i++)
	printf("%040s: %6i element%s\n",argv[i],blah[i], 1==blah[i] ? "":"s" );

return 0;
}

#if 0
int mexPrintf(char  *fmt, ...)
{
int    rval;
va_list ap;
	va_start(fmt,ap);
	rval = vprintf(fmt,ap);
	va_end(ap);
	return rval;
}
#endif
