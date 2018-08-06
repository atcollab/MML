#include "mex.h"
#include "matrix.h"
#include <stdlib.h>

#define __STDC__ 0

#include <shareLib.h>
#include <cadef.h>
#include <afxwin.h> // Need this to use windows system timer
#include <db_access.h>
#include <alarmString.h>
#include <tsDefs.h>


#define min2(a, b)  (((a) < (b)) ? (a) : (b)) 

#define MAX_HANDLES 10000
#define PV_NAME_LENGTH_MAX 51
#define MCA_MESSAGE_STRING_LENGTH_MAX 1000





// Global Variables
static bool CA_INITIALIZED = false;


// static int HandlesUsed = 0;
// static int Locked = 0;

// Timeout delays
/*
double MCA_IO_TIMEOUT = 1.0;
double MCA_POLL_TIMEOUT = 0.00001;
double MCA_EVENT_TIMEOUT = 0.1;
double MCA_PUT_TIMEOUT = 0.01;
double MCA_GET_TIMEOUT = 5;
double MCA_SEARCH_TIMEOUT = 1.0;
int    MCA_POLL_PERIOD = 10; // period [ms] between background ca_poll(); calls

*/

void mexFunction(	int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{   int status;

    if(!CA_INITIALIZED) // Initialize CA if not initialized (first call)
    {   mexPrintf("Initializing MATLAB Channel Access ... \n");
        status = ca_task_initialize();
        if(status!=ECA_NORMAL)
            mexErrMsgTxt("Unable to initialise Challel Access\n");
        CA_INITIALIZED = true;
        // Register a function to be called when a this mex-file is cleared from memory
        // with 'clear' or when exitting MATLAB

        
    }
    else
    {   CA_INITIALIZED = false;
        mexPrintf("Closing MATLAB Channel Access ... \n");
        ca_task_exit();
    }
 
}