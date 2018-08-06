#include "windows.h"
#include "mmsystem.h"  /* For MSVC timer */
#include "gpfunc.h"


/*********************************************
Function:  GetTime() - returns the time since
           Jan. 1, 1970 in seconds,
           -1 if an error occurred.           
**********************************************/

/*  GetTime -> Time in seconds  */
double GetTime(void)
{
	DWORD Time;
	Time = timeGetTime();
	return (((double)Time)/1000);
}


