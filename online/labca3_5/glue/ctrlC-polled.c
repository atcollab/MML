/* $Id: ctrlC-polled.c,v 1.5 2012/01/11 21:03:20 strauman Exp $ */

/* scilab Ctrl-C handling */

/* Author: Till Straumann <strauman@slac.stanford.edu>, 2004
 * This file is subject to the EPICS open license, consult the LICENSE file for
 * more information. This header must not be removed.
 */
#include <mex.h>

#include <multiEzcaCtrlC.h>

#include <cadef.h>
#include <ezca.h>

#ifdef MATLAB_APP
extern unsigned char utHandlePendingInterrupt();

static int poll_cb()
{
	if ( utHandlePendingInterrupt() ) {
		ezcaAbort();
		return 1;
	}
	return 0;
}

#else

#include <stack-c.h>
#include <version.h>

#if SCI_VERSION_MAJOR < 5
/* external declaration of 'interrupt flag' */
typedef int logical;

IMPORT struct {
	logical iflag, interruptible;
} C2F(basbrk);
#endif

extern void C2F(isbrk)(int *);
extern void C2F(inibrk)();

/* X loop */
extern int C2F(sxevents)();
extern int C2F(checkevts)(int *);

static int poll_cb()
{
int rval;
/* scilab 5 doesn't need this anymore :-)
 * OTOH, scilab 4 doesn't define SCI_VERSION_MAJOR at all
 * but luckily has a 'version.h' header
 */
#if SCI_VERSION_MAJOR < 5
	/* processing X loop necessary? */
	C2F(checkevts)(&rval);
	/* process X loop */
	if ( rval )
		C2F(sxevents)();
#endif
	C2F(isbrk)(&rval);
	if (rval) {
		/* reset irq flag so scilab doesn't detect another abort */
#if SCI_VERSION_MAJOR >= 5 /* win32 dosesn't export 'basbrk' */
      /* UPDATE: scilab-5.3.3 does export and declare basbrk :-) */
		C2F(basbrk).iflag = 0;
#else
		/* this clears iflag but also (re-) installs the SIGINT handler */
		C2F(inibrk)();
#endif
		ezcaAbort();
	}
	return rval;
}

#endif

void
multi_ezca_ctrlC_prologue(CtrlCState psave)
{
}

void
multi_ezca_ctrlC_epilogue(CtrlCState prest)
{
}

void
multi_ezca_ctrlC_initialize()
{
double   tottime = ezcaGetTimeout() * ezcaGetRetryCount();
unsigned cnt;

	/* use longer timeout to reduce polling load
	 * however: this is also the minimal latency,
	 * i.e., lcaGet() never takes less than the
	 * ezca timeout!!!
	 */
	ezcaSetTimeout((float)0.1);

	cnt = (unsigned)(tottime/ezcaGetTimeout());
	if ( cnt < 1 )
		cnt = 1;
	ezcaSetRetryCount(cnt);

	ezcaPollCbInstall(poll_cb);
}
