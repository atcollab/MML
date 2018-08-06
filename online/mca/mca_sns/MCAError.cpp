
// System
#include <stdarg.h>
#include <stdio.h>
// Matlab
#include "mex.h"
// Local
#include "MCAError.h"

void MCAError::Warn(const char *format, ...)
{
    va_list ap;
    va_start(ap, format);
    char msg[4000];
    vsnprintf(msg, sizeof(msg), format, ap);
    mexWarnMsgTxt(msg);
    va_end(ap); 
}

void MCAError::Error(const char *format, ...)
{
    va_list ap;
    va_start(ap, format);
    char msg[4000];
    vsnprintf(msg, sizeof(msg), format, ap);
    mexErrMsgTxt(msg);
    va_end(ap); 
}
