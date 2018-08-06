#ifndef MULTI_EZCA_CTRLC_H
#define MULTI_EZCA_CTRLC_H
/* $Id: multiEzcaCtrlC.h,v 1.2 2004/01/30 01:45:33 till Exp $ */

/* interface to Ctrl-C handling */

/* Author: Till Straumann <strauman@slac.stanford.edu>, 2002-2003 */

/* LICENSE: EPICS open license, see ../LICENSE file */

#if !defined(WIN32) && !defined(_WIN32)
#include <signal.h>
#endif

typedef struct CtrlCStateRec_ {
	void		(*handler)(int);
#if !defined(WIN32) && !defined(_WIN32)
	sigset_t	mask;
#endif
} CtrlCStateRec, *CtrlCState;

#ifdef __cplusplus
extern "C" {
#endif

void
multi_ezca_ctrlC_prologue(CtrlCState psave);

void
multi_ezca_ctrlC_epilogue(CtrlCState prestore);

/* initialize CtrlC handling; must be
 * called _before_ initializing CA!
 */
void
multi_ezca_ctrlC_initialize();

#ifdef __cplusplus
};
#endif

#endif
