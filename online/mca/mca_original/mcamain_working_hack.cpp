/* MCAMAIN.CPP main mex-file for MATLAB Channel Access Toolbox 

This needs to be comiled as cpp file: add '-TP' option to the COMPFLAGS
line in mexopt.bat 
To make mex-file the following preprocessor flags must also be defined:
DB_TEXT_GLBLSOURCE
_WIN32 
EPICS_DLL_NO ...     
For example: a mex command from MATLAB should look like this:
>> mex mcamain.cpp D:\Epics\base\lib\Win32\Com.lib...
    D:\Epics\base\lib\Win32\ca.lib -DDB_TEXT_GLBLSOURCE ...
    -D_WIN32 -DEPICS_DLL_NO ...     
    -ID:\Epics\base\include...
    -ID:\Epics\base\include\os\WIN32 ...
    -v
*/

#include "mex.h"
#include "matrix.h"
#include <stdlib.h>




#include <cadef.h>
#include <caerr.h>

#include <dbDefs.h> /* needed for PVNAME_SZ and FLDNAME_SZ */
#include <db_access.h>
#define epicsExportSharedSymbols
#include <shareLib.h>




//#define __STDC__ 0



#include <afxwin.h> // Need this to use windows system timer



#define min2(a, b)  (((a) < (b)) ? (a) : (b)) 

#define MAX_HANDLES 10000
#define PV_NAME_LENGTH_MAX 51
#define MCA_MESSAGE_STRING_LENGTH_MAX 1000


// Structure contains data relevant to interfacing MATLAB  with Channel Access
struct mca_channel
{ chid      CHID;       // CA channel identifier
  evid      EVID;       // CA evnet identifier. If a channel is not monitored EVID == NULL 
  mxArray*  CACHE;      // pointer to a persistent mxArray, internal to mcamain.c
  void*     DataBuffer;
  char*     MonitorCBString;    // MATLAB callback string for monitor
  int       LastPutStatus;
  chtype    NativeType2DBR;     // Established After first connection
  int       NumElements;
  int       MonitorEventCount;  // Increments by 1 when a monitor event for the channel occurs
                                // resets to 0 by reads from the cache
//  char*     GetCBString;      // MATLAB callback string for asynchronous get/put
//  int       AsyncGetPending; 
    
//  mxArray*  LastCB_CPUTIME;

} CHNLS[MAX_HANDLES]; 




// Global Variables
static bool CA_INITIALIZED = false;
static int HandlesUsed = 0;

static int Locked = 0;

// Timeout delays
double MCA_IO_TIMEOUT = 1.0;
double MCA_POLL_TIMEOUT = 0.00001;
double MCA_EVENT_TIMEOUT = 0.1;
double MCA_PUT_TIMEOUT = 0.01;
double MCA_GET_TIMEOUT = 5;
double MCA_SEARCH_TIMEOUT = 1.0;
int    MCA_POLL_PERIOD = 10; // period [ms] between background ca_poll(); calls

int WARNINGLEVEL = 0;

static UINT PollTimerHandle = 0;

void mcaMonitorEventHandler(struct event_handler_args arg)
{   union db_access_val *pBuf;
    struct mca_channel* PCHNL = (struct mca_channel*)arg.usr;
    double *myDblPr;
    chtype RequestType;
    int i,Cnt;
    mxArray* mymxArray;
    pBuf = (union db_access_val *)arg.dbr;
    
    //mexPrintf("MCA Monitor Event Handler Called\n");
    
    PCHNL->MonitorEventCount++;
    
    Cnt = ca_element_count(arg.chid);  
    RequestType = dbf_type_to_DBR(ca_field_type(arg.chid)); // Closest to the native 
    
    if(RequestType==DBR_STRING)
    {   if(Cnt==1)
        {   mxDestroyArray(PCHNL->CACHE); // clear mxArray that pointed to by PCHNL->CACHE
            PCHNL->CACHE = mxCreateString((char*)((pBuf)->strval)); // Create new array with current string value
            mexMakeArrayPersistent(PCHNL->CACHE);
        }
        else
        {   for(i=0;i<Cnt;i++)
            {   mymxArray = mxGetCell(PCHNL->CACHE,i);
                mxDestroyArray(mymxArray);
                mymxArray = mxCreateString(  (char*)   (&(pBuf->strval)+i)   );
                mexMakeArrayPersistent(mymxArray);
                mxSetCell(PCHNL->CACHE,i,mymxArray);
            }
        }
    }
    else
    {   myDblPr = mxGetPr(PCHNL->CACHE);
        
        switch(RequestType)
        {   case DBR_INT: // As defined in db_access.h DBR_INT = DBR_SHORT = 1
            for (i = 0; i<Cnt;i++)
                myDblPr[i]= (double)(*(&((pBuf)->intval)+i));
            break;    
            
            case DBR_FLOAT:
            for (i = 0; i<Cnt;i++)
                myDblPr[i]= (double)(*(&((pBuf)->fltval)+i));
            break;
                
            case DBR_ENUM:
            for (i = 0; i<Cnt;i++)
                myDblPr[i]= (double)(*(&((pBuf)->enmval)+i));
            break;
                
            case DBR_CHAR:
            for (i = 0; i<Cnt;i++)
                myDblPr[i]= (double)(*(&((pBuf)->charval)+i));
            break;
                    
            case DBR_LONG:
            for (i = 0; i<Cnt;i++)
                myDblPr[i]= (double)(*(&((pBuf)->longval)+i));
            break;
                    
            case DBR_DOUBLE:
            for (i = 0; i<Cnt;i++)
                myDblPr[i]= (double)(*(&((pBuf)->doubleval)+i));
            break;
        }
    }
    
    if(PCHNL->MonitorCBString)
    {   
        mexEvalString(PCHNL->MonitorCBString);
    }
}


void mca_close_channels(void)
{   mexPrintf("Closing CA connections ...\n");
    ca_task_exit();
    HandlesUsed = 0;
    CA_INITIALIZED = false;            
}

static void mca_cleanup(void)
{   int i, status;
    
    mexPrintf("Terminating periodic CA polling\n");
    KillTimer(NULL,PollTimerHandle);
        
    // Clear persistent memory Arrays
    for(i=0;i<HandlesUsed;i++)
    {   if(CHNLS[i].EVID)
        {   mexPrintf("Clearing monitor on channel %d\n",i); 
            status = ca_clear_event(CHNLS[i].EVID);
                if(status!=ECA_NORMAL)
                    mexPrintf("ca_clear_event failed\n"); 
        }
        
        
        if(CHNLS[i].CACHE)
            mxDestroyArray(CHNLS[i].CACHE);

        
        if(CHNLS[i].DataBuffer)
            mxFree(CHNLS[i].DataBuffer);
        if(CHNLS[i].MonitorCBString)
            mxFree(CHNLS[i].MonitorCBString);      
    }
    mexPrintf("Closing CA connections ...\n");
    ca_task_exit();
    HandlesUsed = 0;
      
    CA_INITIALIZED = false;
}


void mcaput_callback(struct event_handler_args handler_args)
{   // This callback vrites the integer 1 on success
    // and 0 on failure  to the memory location
    // specified by  void* handler_args.usr
    if (handler_args.status == ECA_NORMAL)
        *((int*)handler_args.usr)=1;
    else
        *((int*)handler_args.usr)=0;
}


void __stdcall  background_poll( HWND hwnd,   UINT uMsg,   UINT idEvent,  DWORD dwTime  )
{   // To be used with the system timer for periodic Channel Acccess polling
    ca_poll();
}
    
 


void mexFunction(	int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{   
   int  status;
    
    if(!CA_INITIALIZED) // Initialize CA if not initialized (first call)
    {   

        status = ca_task_initialize();

        
    }

 
}