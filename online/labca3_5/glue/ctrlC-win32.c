/* $Id: ctrlC-win32.c,v 1.7 2006/04/14 23:45:28 till Exp $ */

/* Ctrl-C processing for WIN32 */

/* Author: Till Straumann <strauman@slac.stanford.edu>, 2004
 * This file is subject to the EPICS open license, consult the LICENSE file for
 * more information. This header must not be removed.
 */

#include <Windows.h> /* must include this first */

#include <cadef.h>
#include <ezca.h>
#include <multiEzcaCtrlC.h>

#ifdef MATLAB_APP

#define WM_MTLBHACK (WM_USER + 10)

#endif

#define K_STAT(flags) (((flags)>>30) & 3)

/* In MATLAB, the thread executing the MEX file doesn't
 * get WM_KEYBOARD messages - the keyboard seems to be
 * processed by a different thread
 * It is possible to use SetWindowsHookEx() to intercept key
 * presses/releases --  however, we don't know the ThreadID
 * and would hence have to use thread ID 0.
 *
 * However, it seems that the key-processing task sends
 * an WM_USER+10 event to us, so we use that as a hack...
 *
 * In SCILAB, the 'hook' solution doesn't work because the
 * executing thread is normally processing the input queue.
 * Since no queue processing occurs, the hook would never
 * be invoked (unless we periodically 'peek' at the queue
 * -- in that case we can as well process it which is what
 * we do here).
 */

static volatile int ctrl = -1;

#ifdef DEBUG
static volatile int rec  = 0;
static DWORD mesgs[100];
static DWORD codes[100];
static DWORD flags[100];

static void recMsg(PMSG pmsg)
{
	if ( rec < sizeof(codes)/sizeof(codes[0]) ) {
		switch ( pmsg->message ) {
			default:
				mesgs[rec]=pmsg->message;
				codes[rec]=pmsg->wParam;
				flags[rec]=pmsg->lParam;
				rec++;
			case WM_TIMER:
			case WM_MOUSEMOVE:
				break;
		}
	}
}

static void showMsgs()
{
char buf[2000],*p;
int  i;
	for ( i=0, p=buf, *p=0; i < rec; i++ )
		p+=sprintf(p,"%3i (0x%04x): %4i  0x%08x -- 0x%08x\n",
				mesgs[i], mesgs[i],
				codes[i], codes[i],
				flags[i] );
	p+=sprintf(p, "MSGS: %i\n", rec);
	MessageBox( NULL, (LPCTSTR)buf, "Error", MB_OK | MB_ICONINFORMATION );
}

#endif

#ifdef MATLAB_APP

static int procMsg(PMSG pmsg)
{
	return ( WM_MTLBHACK == pmsg->message );
}

#define MYPEEK(pm) (PeekMessage(pm, 0, WM_MTLBHACK, WM_MTLBHACK, PM_NOREMOVE))

#else /* SCILAB_APP */

static int procMsg(PMSG pmsg)
{
DWORD m = pmsg->message;

	if ( WM_KEYFIRST <= m && WM_KEYLAST >= m ) {
		switch ( pmsg->wParam ) {
				case VK_CONTROL:
						ctrl = ( K_STAT( pmsg->lParam ) < 2 ) ? 1 : 0;
						/* K_STAT: 0 -- just pressed, 1 -- still down, 3 -- just released */
						break;

				case 'C':
						if ( 0 == K_STAT( pmsg->lParam ) && 1 == ctrl )
							return 1;

				default:
						break;
		}
	}
	return 0;
}

#define MYPEEK(pm) (PeekMessage (pm, 0, WM_KEYFIRST, WM_KEYLAST, PM_REMOVE))
#endif


static int multi_ezca_pollCb()
{
MSG m;
	while ( MYPEEK(&m) ) {
#ifdef DEBUG
		recMsg(pmsg);
#endif
		if ( procMsg(&m) ) {
			ezcaAbort();
			return 1;
		}
	}
	return 0;
}

void
multi_ezca_ctrlC_prologue(CtrlCState psave)
{
#ifdef DEBUG
	rec    = 0;
#endif
	ctrl   = -1;
}

void
multi_ezca_ctrlC_epilogue(CtrlCState prest)
{
}

/* Install a callback to detect windoze activity (Ctrl-C) */
void
multi_ezca_ctrlC_initialize()
{
	ezcaPollCbInstall( multi_ezca_pollCb );
}
