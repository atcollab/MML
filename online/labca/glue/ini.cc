/* $Id: ini.cc,v 1.30 2007/06/20 07:33:30 strauman Exp $ */

/* xlabcaglue library initializer */

#if defined(WIN32) || defined(_WIN32)
#include <Windows.h>
#endif

#include <mex.h>
#include <cadef.h>
#include <ezca.h>
#include <multiEzcaCtrlC.h>
#include <multiEzca.h>

#if BASE_IS_MIN_VERSION(3,14,7)
#include <stdlib.h>
#include <epicsExit.h>
#endif

#include <errlog.h>

#if defined(WIN32) || defined(_WIN32)
typedef int pid_t;
#define getpid _getpid
extern "C" int _getpid();
#else
#include <unistd.h>
#endif

#ifdef SCILAB_APP
#include <signal.h>
#endif

// Configurable Parameters
#define DEBUG_FINA  1
#undef  USE_DLOPEN           // Use dlopen to lock scilabca in memory
#undef  USE_ATEXIT           // Class destructor now seems to work
#undef  USE_SCIWINEXITHACK   // Special hack for scilab/win32 (read below)
// End Of Configurable Parameters

#if defined(WIN32) || defined(_WIN32) || BASE_IS_MIN_VERSION(3,14,7)
#undef USE_DLOPEN            // ulink unloads the interface anyways
                             // so just locking the lib is probably worse
                             // than just a leak...
#endif

#if !(defined(WIN32) || defined(_WIN32)) || defined(MATLAB_APP)
#undef USE_SCIWINEXITHACK
#else
#ifdef USE_SCIWINEXITHACK
#include <wsci/wgnuplib.h>
extern "C" LPTW GetTextWinScilab(void);
#endif
extern "C" void C2F(xscion)(int*);
#endif


#if defined(USE_DLOPEN)
/* 
 * Use dlopen to lock libraries in memory and prevent from unlinking
 */
#include <dlfcn.h>
#endif

/* Our PID -- distinguish ourself from a forked caRepeater */
static	pid_t thepid;

#ifdef MATLAB_APP
static int isMcc(int ini)
{
	/* Check if this is executed from an mcc run
	 *
	 * (Thanks to Jim Sebek who suggested this fix
	 * on 4/10/07).
	 */
	mxArray *lhs = NULL;

	if ( 0 == mexCallMATLAB(1, &lhs, 0, NULL, "ismcc") &&
		 mxGetScalar(lhs) != 0. ) {
		mexPrintf("skip execution of multiEzca%s in ini.cc during mcc compilation\n", ini ? "Initializer" : "Finalizer");
		return -1;
	}
	return 0;
}
#endif

// Getting this to work on all platforms was hard work...
static void
multiEzcaFinalizer()
{
#ifdef MATLAB_APP
	/* Skip execution of finalizer if this is a mcc compilation run
	 * (J. Sebek, 6/2007)
	 */
	if ( isMcc(0) )
		return;
#endif

#if (defined(WIN32) || defined(_WIN32)) && !defined(MATLAB_APP)
	{
	// Scilab seems to kill threads cold when exiting (but not
    // as a result of 'ulink'). In this case, we must not try
	// to clean up since any attempt to synchronize with another
	// thread cleaning up [as the errlog exit handler does] would
	// deadlock (because all threads are already dead).
	// This is further complicated by the asynchronous nature
	// of scilab with GUI. I don't really know who ends up calling
	// ExitProcess() but it seems it is not the same thread that's
	// executing this code. When we get here things still look good
	// but at the time the errlog exit handler blocks for the errlog
	// thread to terminate the system seems to schedule what's
	// then doing ExitProcess() so that we never return from waiting
	// for errlog...
	// 
	// We implement two ways for detecting if we are exiting or
	// only unlinking:
	//   a) inspect hWndParent of the textwin struct. This is
	//      set to NULL by WinExit(). Drawback: sacrifice of
	//      binary compatibility. We know about the workings
	//      of WinExit() and must use knowledge abou the textwin
	//      layout (wgnuplib.h).
	//   b) Just wait for some time; eventually the threads will
	//      be dead and we detect them as 'suspended'.
	//      Drawback: we don't really know how long to wait nor
	//      how to synchronize.
	//
	// Another problem: mexPrintf()ing from an exiting wscilab.exe
	// crashes (but a [nogui] scilab.exe works fine). We handle that
	// here, too.
	int           dontPrint;
	// We rely on the errlog thread having this name!
	epicsThreadId errlogid = epicsThreadGetId("errlog");

		C2F(xscion)(&dontPrint);

		if ( dontPrint ) {
			// In graphical mode; we need to find out
			// if we are exiting or just unloading
#ifdef USE_SCIWINEXITHACK
			if ( 0 == GetTextWinScilab()->hWndParent ) {
				// bail out right away
				return;
			}
			// at this point we have either a normal hWndParent
			// and are not exiting. However, just in case we were
			// compiled for a different version of scilab and
			// the hWndParent member is actually bogus we resort
			// to the 'delay' method anyways...
#endif
			// delay a bit so we'll detect dead threads below.
			epicsThreadSleep(2.0);
		}

#if DEBUG_FINA > 0
		if ( ! dontPrint ) {
			mexPrintf("Errlog thread has ID 0x%08x\n", errlogid);
		}
#endif
		// win32 'IsSuspended' routine calls GetExitCodeThread and
		// declares the thread suspended if it's dead already...
		if ( !errlogid || epicsThreadIsSuspended(errlogid) ) {
#if DEBUG_FINA > 0
			if ( ! dontPrint )
				mexPrintf("aborting cleanup; bailing out\n");
#endif
			return; // don't attempt any cleanup
		}
	}
#endif

	// If we make it here, it's safe to print...

#if DEBUG_FINA > 0
	mexPrintf("Entering labca finalizer\n");
#endif

	if ( thepid != getpid() ) {
		/* DONT run this if a forked caRepeater exits */
#if DEBUG_FINA > 0
		mexPrintf("labca finalizer: PID mismatch\n");
#endif
		_exit(-1);
		return; //never get here
	}

	// FIXME: proper ezca shutdown; move all of this to ezca...

#if DEBUG_FINA > 1
	mexPrintf("clearing channels...\n");
#endif
	multi_ezca_clear_channels(0,-1, 0);
#if DEBUG_FINA > 1
	mexPrintf("done\n");
#endif
	ezcaLock();


#if DEBUG_FINA > 1
	mexPrintf("destroying CA context...\n");
#endif
	ca_context_destroy();
#if DEBUG_FINA > 1
	mexPrintf("done\n");
#endif

#if BASE_IS_MIN_VERSION(3,14,7)
#if DEBUG_FINA > 1
	mexPrintf("calling exits...\n");
#endif
	/* replicate epicsExit w/o calling exit() */
	epicsExitCallAtExits();
#if DEBUG_FINA > 1
	mexPrintf("done\n");
#endif
	epicsThreadSleep(1.);
#endif

#if DEBUG_FINA > 0
	mexPrintf("Leaving labca finalizer\n");
#endif
}

class multiEzcaInitializer {
public:
	multiEzcaInitializer();
	~multiEzcaInitializer();
};

multiEzcaInitializer::
~multiEzcaInitializer()
{
#ifndef USE_ATEXIT
	multiEzcaFinalizer();
#endif
}

multiEzcaInitializer::
multiEzcaInitializer()
{
CtrlCStateRec saved;

#ifdef MATLAB_APP
	/* Skip execution of initializer if this is a mcc compilation run
	 * (J. Sebek, 4/2007)
	 */
	if ( isMcc(1) )
		return;
#endif

#ifdef SCILAB_APP
	/* uninstall scilabs recovery method; I'd rather have
	 * a coredump to debug...
	 */
	signal(SIGSEGV, SIG_DFL);
#endif

/* don't print to stderr because that
 * doesn't go to scilab's main window...
 */
mexPrintf((char*)"Initializing labCA Release '$Name: labca_3_1 $'...\n");
mexPrintf((char*)"Author: Till Straumann <strauman@slac.stanford.edu>\n");

#ifdef MATLAB_APP
  /* Under matlab, always lock the library in memory - even though we
   * now do a pretty good job cleaning up (and as a matter of fact
   * I now can clear and reload scilabca and matlabca under unix [but
   * not win$] w/o crashing) but more work in ezcamt is needed until
   * we can release this...
   */
  mexLock();
#endif
#if defined(USE_DLOPEN) && !defined(MATLAB_APP)
  if ( !dlopen("libsezcaglue.so",RTLD_NOW) ) {
	mexPrintf((char*)"Locking library in memory failed: %s\n",dlerror());
  }
#endif

multi_ezca_ctrlC_initialize();

multi_ezca_ctrlC_prologue(&saved);
ezcaAutoErrorMessageOff(); /* calls ezca init() */
multi_ezca_ctrlC_epilogue(&saved);

/* MUST initialize errlog -- otherwise it is never initialized
 * until after epicsCallAtExits(), i.e., from some class destructor.
 * At that point it is too late however and it won't be shut
 * down anymore.
 */
errlogInit(0);	// FIXME: should move that to ezca initialization

/* Another problem on unix is the 'fork'ed caRepeater calling the
 * finalizer...
 */
thepid = getpid();
#ifdef USE_ATEXIT
/* On unix the class destructor is called too late; atexit seems to
 * give a cleaner shutdown.
 *
 * UPDATE -- 2007/6/5: with the new shutdown implementation the
 * class destructor seems to work on all platforms.
 */
atexit(multiEzcaFinalizer);
#endif
}

static multiEzcaInitializer theini;
