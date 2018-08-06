/* $Id: ecget.h,v 1.1 2004/02/11 23:06:10 till Exp $ */

/* Public header for 'ecdrget' */

/* Till Straumann, 2004 */

#ifndef SSRL_ECGET_H
#define SSRL_ECGET_H

#include <shareLib.h>

#ifdef __cplusplus
extern "C" {
#endif

epicsShareFunc void epicsShareAPI
ecdrget(char *, int *, long **, int *);

#ifdef __cplusplus
};
#endif

#endif

