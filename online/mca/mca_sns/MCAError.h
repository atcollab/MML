#ifndef mcaerror_h
#define mcaerror_h

// Sillt hack:
// mex defines printf = mexPrintf,
// which clashes with out format(printf... below.
#ifdef printf
#define patch_printf
#undef printf
#endif

#ifdef WIN32
#define __attribute__(x) /* nothing */
#endif

class MCAError
{
public:
    static void Warn(const char *format, ...) 
         __attribute__ ((format (printf, 1, 2)));
    static void Error(const char *format, ...) 
         __attribute__ ((format (printf, 1, 2)));
};

#ifdef patch_printf
#define printf mexPrintf
#endif

#endif // mcaerror_h
