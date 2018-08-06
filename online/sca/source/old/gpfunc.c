#include <sys/types.h>
#include <sys/time.h>
#include <sys/timeb.h>



/*********************************************
Function:  GetTime() - returns the time since
           Jan. 1, 1970 in seconds,
           -1 if an error occurred.           
**********************************************/
double GetTime(void)
{
	double Time;
	struct timeb tp;

	if (ftime(&tp) == -1) 
		Time = -1;
	else
		Time = ((double) tp.time) + ((double) tp.millitm)/1000;

return Time;
}


/*********************************************
Function:  Sleep(Delay) - delays Delay seconds
          
**********************************************/
void Sleep(double Delay)
{
	double Time0;

	Time0 = GetTime();
	while (GetTime()-Time0 < Delay);
return;
}

