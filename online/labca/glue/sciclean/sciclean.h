#ifndef SCICLEAN_H
#define SCICLEAN_H

#include <mex.h>

/* Framework for cleaning up objects that
 * are allocated from scilab interface functions.
 * This is necessary because a lot of macros
 * in 'stack-c.h' etc. expand to something like
 *
 *   if ( !C2F(some_routine)() ) return 0;
 *
 * and therefore abort the current routine w/o
 * giving the user a chance to cleanup resources.
 *
 * The idea here is to provide generic hooks so
 * that this problem is solved.
 */
 

#ifdef __cplusplus
extern "C" {
#endif

/* Our own scilab 'gateway' function; this MUST be used
 * in the jumptable. This gateway (not thread-safe ATM)
 * then passes a handle to the list of cleanups to the
 * interface functions and executes all registered cleanups
 * when the interface function returns.
 */

/* Handle to the list of cleanups */
typedef void *Sciclean;

/* Handle to a particular cleanup */
typedef int Scicleanup;

/* Register a cleanup; a NULL obj_clean function
 * may be used which is equivalent to 'free'.
 */
Scicleanup
sciclean_push(Sciclean sciclean, void *obj, void (*obj_clean)(void *obj));

/* A utility cleanup for string matrices
 * obtained with GetRhsVar(.."S"..) and the like
 */
void sciclean_freeRhsSVar(void *obj);

/* Utility macro to save typing; assumes the Scicleanup argument
 * to your user interface function is named 'scicleanup'.
 */
#define SCICLEAN(x)      ( (x) ? sciclean_push((sciclean), (x), 0) : (-1) )
#define SCICLEAN_SVAR(x) ( (x) ? sciclean_push((sciclean), (x), sciclean_freeRhsSVar) : (-1) )

/* Cancel a cleanup */
void
sciclean_cancel(Sciclean sciclean, Scicleanup scicleanup);

/* Scilab gate function prototype; uarg is passed through by gateway */

typedef int (*ScicleanGatefunc) __PARAMS((char *fname, int l, Sciclean sciclean));

/* Scilab interface function */

int sciclean_gateway __PARAMS((char*, ScicleanGatefunc F));

#ifdef __cplusplus
}
#endif

#endif
