/* $Id: ctrlC-sig.c,v 1.4 2006/04/11 02:07:29 strauman Exp $ */

/* Ctrl-C handling for solaris and linux */

/* Author: Till Straumann <strauman@slac.stanford.edu>, 2004
 * This file is subject to the EPICS open license, consult the LICENSE file for
 * more information. This header must not be removed.
 */

/* Solaris is nice; signals are just delivered to ONE thread
 * (not quite clear to which one, though);
 *
 * Linux is more messy: signals get delivered to ALL threads
 * (which don't mask the specific signal; the mask is inherited
 *  from the parent thread). 
 *
 * Linux Problem:
 *  a) we don't want any of the CA threads to get signals
 *     (otherwise, any of them might be scheduled to execute
 *     after we uninstalled our signal handler --> spurious
 *     'duplicate' signals).
 *  b) we can't have a dedicate signal handling thread either.
 *     The signal MUST be delivered to the same matlab/scilab
 *     thread it would without the CA threads (e.g. in case
 *     they do weird stuff like longjmp from the signal handler).
 *  
 *  SOLUTION:
 *   1) mask SIGINT around all ezca (and hence CA) calls.
 *      -> all newly created CA threads will inherit the SIGINT
 *         mask and will not see Ctrl-C.
 *   2) install a 'ezcaPollCb' to flash the SIGINT mask in a
 *      controlled way - since the PollCb executes in the main
 *      the app will see _exactly_ the same signal(s) as if
 *      labCA was not present, i.e. no extra threads created by
 *      labCA see the signals but _all_ application threads will
 *      see it.
 */


#if 1
#define _POSIX_PTHREAD_SEMANTICS /* solaris */
#endif

#include <signal.h>
#include <stdio.h>

#if (defined(__linux__) || defined(__linux) || defined(linux))
#define ISLINUX
#endif


#include <cadef.h>
#include <ezca.h>

#if BASE_IS_MIN_VERSION(3,14,0)
#define DO_MASK
#endif

#if defined(DEBUG) || defined(DO_MASK)
#include <pthread.h>
#endif

#include <multiEzcaCtrlC.h>

#ifdef DEBUG
static void (*orig)(int)=0;
static int inside = 0;
#endif

static int caught = 0;

typedef void (*SHandler)(int);

static SHandler siginst(SHandler h)
{
struct sigaction sa,so;
	sa.sa_handler = h;
	sigemptyset(&sa.sa_mask);
	sa.sa_flags   = 0;
	if ( sigaction(SIGINT, &sa, &so) ) {
		perror("installing SIGINT handler");
		return SIG_ERR;
	}
#ifdef DEBUG
	fprintf(stderr,
			"siginst: replacing 0x%08x by 0x%08x\n",
			(unsigned)so.sa_handler,
			(unsigned)sa.sa_handler);
#endif
	return so.sa_handler;
}

#ifdef DO_MASK

static int sigblk(sigset_t *po)
{
	sigset_t n;
	sigemptyset(&n);
	sigaddset(&n,SIGINT);
	sigaddset(&n,SIGABRT);
	return pthread_sigmask( SIG_BLOCK, &n, po );
} 

#define sigunblk(po) pthread_sigmask(SIG_SETMASK,(po),0)

static int flashSigCB()
{
sigset_t s,o;
	sigemptyset(&s);
	sigaddset(&s,SIGINT);
	caught = 0;
	pthread_sigmask( SIG_UNBLOCK, &s, &o );
	sigunblk(&o);
#ifdef DEBUG
	if (caught) {
		fprintf(stderr,"flashSigCB: signal caught\n");
	}
#endif
	return caught;
}

#else

#define sigblk(po)   do {} while (0)
#define sigunblk(po) do {} while (0)

#endif

static void
handler(int num)
{
	caught++;
#ifdef DEBUG
	fprintf(stderr,"thread 0x%08x got signal %i\n",pthread_self(),num);

	if (inside)
		ezcaAbort(); 
	else if (orig)
			orig(num);
#else
	ezcaAbort();
#endif
}

void
multi_ezca_ctrlC_prologue(CtrlCState psave)
{
	sigblk(&psave->mask);

#ifdef DEBUG
	fprintf(stderr,"Entering ctrlC_prologue\n");
	inside = 1;
#else
	psave->handler = siginst(handler);
#endif
}

void
multi_ezca_ctrlC_epilogue(CtrlCState prest)
{
#ifdef DEBUG
	inside = 0;
	fprintf(stderr,"Leaving ctrlC_epilogue\n");
#else
	if ( SIG_ERR != prest->handler ) {
		if ( handler != siginst(prest->handler) )
			fprintf(stderr,"restoring old handler failed\n");
	}
#endif
	sigunblk(&prest->mask);
}

void
multi_ezca_ctrlC_initialize()
{
#ifdef DEBUG
	orig = siginst(handler);
	if ( SIG_ERR == orig )
		orig = 0;
#else
#ifdef SCILAB_APP
	{
	SHandler s = signal(SIGINT, SIG_DFL);
	/* Workaround Scilab BUG: they use 'signal' and don't
	 * let their handler reinstall itself
	 */
	siginst(s);
	}
#endif
#endif
#ifdef DO_MASK
	ezcaPollCbInstall( flashSigCB );
#endif
}
