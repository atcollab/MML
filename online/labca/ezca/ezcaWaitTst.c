#include <cadef.h>
#include <caerr.h>
#include "ezca.h"
#include <stdio.h>
#include <stdlib.h>

static int sgrp(int npvs)
{
	return npvs > 0 ? ezcaStartGroup() : 0;
}

static int egrp(int npvs)
{
	return npvs > 0 ? ezcaEndGroup() : 0;
}

#define SGRP() if ( sgrp(npvs) ) return -1;
#define EGRP() if ( egrp(npvs) ) return -1;

static int forall(char **pvs, int npvs)
{
int i,j;
float pv[npvs];

	SGRP();

	for ( i=0; i<npvs; i++ )
		if ( ezcaSetMonitor(pvs[i], ezcaFloat, 1) )
			return -1;

	EGRP();

	for (j=0; j<5; j++) {
		SGRP();
		for ( i=0; i<npvs; i++ )
			if ( ezcaNewMonitorWait(pvs[i],ezcaFloat) )
				return -1;

		EGRP();

		SGRP();
			for ( i=0; i<npvs; i++ )
				if ( ezcaGet(pvs[i], ezcaFloat, 1, pv+i) )
					return -1;
		EGRP();

		for (i=0; i<npvs; i++)
			printf("%s: %8.4g\n", pvs[i], pv[i]);	
	}
	return 0;
}

int
main(int argc, char **argv)
{
int i,j;
float v;
	if ( argc < 2 ) {
		fprintf(stderr,"Usage: %s <pv names>\n", argv[0]);
		exit(1);
	}
	//ezcaDebugOn();
	ezcaSetTimeout(2.0);
	ezcaSetRetryCount(4);

	forall(argv+1, argc-1);

	for ( i=1; i<argc; i++ )
		ezcaClearMonitor(argv[i],ezcaFloat);
	return 0;
}
