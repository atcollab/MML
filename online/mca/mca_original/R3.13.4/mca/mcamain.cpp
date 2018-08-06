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
    int i,j, k, status,buflen,Cnt, Hndl, L,M,N,  NumHandles, commandswitch;
    
    int *HndlArray;
    mxArray  *mymxArray;
    double *myDblPr;
    chtype RequestType;
    
    char PVName[PV_NAME_LENGTH_MAX+1];
    // char MCAMessageString[MCA_MESSAGE_STRING_LENGTH_MAX+1];
    
    
      

    dbr_string_t StrBuffer;
    
        
    
    const char *MCAInfoFields[]={"PVName","ElementCount","NativeType","State","MCAMessage","Host"};
    char *NativeTypeStrings[] = {"STRING","INT","FLOAT","ENUM","CHAR","LONG","DOUBLE"};
    


    
    if(!CA_INITIALIZED) // Initialize CA if not initialized (first call)
    {   mexPrintf("Initializing MATLAB Channel Access ... \n");
        status = ca_task_initialize();
        if(status!=ECA_NORMAL)
            mexErrMsgTxt("Unable to initialise Challel Access\n");
        CA_INITIALIZED = true;
        // Register a function to be called when a this mex-file is cleared from memory
        // with 'clear' or when exitting MATLAB
        mexAtExit(mca_cleanup);
        // Lock the mex-file so that it can not be cleared without explicitly
        // mexUnclock
        mexLock();
        
        //start periodic polling:
        PollTimerHandle = SetTimer(NULL,NULL,MCA_POLL_PERIOD,background_poll);
        if(PollTimerHandle)
            mexPrintf("Periodic CA polling started! System Timer ID: %u\n",PollTimerHandle);
        else
            mexWarnMsgTxt("Failed to start periodic CA polling\n");
        
        
    }

    commandswitch = (int)mxGetScalar(prhs[0]);
   
    switch(commandswitch)
    {  case 0: 
            mexUnlock();
            break;
    
        case 1: // MCAOPEN - add channel(s) by PV names, all arguments following prhs[0]
               // must be strings - names of PV's
            for(i=1;i<nrhs;i++)
            {   mxGetString(prhs[i],PVName,PV_NAME_LENGTH_MAX+1);
                status = ca_search(PVName,&(CHNLS[HandlesUsed].CHID));
                if(status == ECA_NORMAL) // if not - go on to the next PV name
                {   status = ca_pend_io(MCA_SEARCH_TIMEOUT);
                    if (status == ECA_NORMAL)
                    {   // Allocate persistent memory for the DataBuffer on this channel
                        // to hold all elements of the DBR_XXX type
                        // nearest to the native type
                        // RequestType = dbf_type_to_DBR(ca_field_type(CHNLS[HandlesUsed].CHID));
                        // Cnt=ca_element_count(CHNLS[HandlesUsed].CHID);
                        
                        
                        CHNLS[HandlesUsed].NumElements = ca_element_count(CHNLS[HandlesUsed].CHID);
                        CHNLS[HandlesUsed].NativeType2DBR = dbf_type_to_DBR(ca_field_type(CHNLS[HandlesUsed].CHID));
                        CHNLS[HandlesUsed].MonitorEventCount = 0;
                        
                        switch(CHNLS[HandlesUsed].NativeType2DBR)
                        {   case DBR_STRING:
                                CHNLS[HandlesUsed].DataBuffer = mxCalloc(CHNLS[HandlesUsed].NumElements,sizeof(dbr_string_t));
                                
                            break;
                        
                            case DBR_INT: // As defined in db_access.h DBR_INT = DBR_SHORT = 1
                                CHNLS[HandlesUsed].DataBuffer = mxCalloc(CHNLS[HandlesUsed].NumElements,sizeof(dbr_short_t)); 
                            break;
                        
                            case DBR_FLOAT:
                                CHNLS[HandlesUsed].DataBuffer = mxCalloc(CHNLS[HandlesUsed].NumElements,sizeof(dbr_float_t)); 
                            break;
                
                            case DBR_ENUM:
                                CHNLS[HandlesUsed].DataBuffer = mxCalloc(CHNLS[HandlesUsed].NumElements,sizeof(dbr_enum_t)); 
                            break;
                
                            case DBR_CHAR:
                                CHNLS[HandlesUsed].DataBuffer = mxCalloc(CHNLS[HandlesUsed].NumElements,sizeof(dbr_char_t)); 
                            break;
                    
                            case DBR_LONG:
                                CHNLS[HandlesUsed].DataBuffer = mxCalloc(CHNLS[HandlesUsed].NumElements,sizeof(dbr_short_t)); 
                            break;
                    
                            case DBR_DOUBLE:
                                CHNLS[HandlesUsed].DataBuffer = mxCalloc(CHNLS[HandlesUsed].NumElements,sizeof(dbr_double_t)); 
                            break;
                        }   
                        mexMakeMemoryPersistent(CHNLS[HandlesUsed].DataBuffer);
                        
                                 
                        if(CHNLS[HandlesUsed].NativeType2DBR==DBR_STRING) // CACHE
                        {   if(CHNLS[HandlesUsed].NumElements==1) // Create MATLAB string - originally empty
                                CHNLS[HandlesUsed].CACHE = mxCreateString("");
                            else // Create MATLAB cell array of strings
                            {   CHNLS[HandlesUsed].CACHE = mxCreateCellMatrix(1,CHNLS[HandlesUsed].NumElements);
                                for(k=0;k<CHNLS[HandlesUsed].NumElements;k++)
                                {   mymxArray = mxCreateString("");
                                    mexMakeArrayPersistent(mymxArray);
                                    mxSetCell(CHNLS[HandlesUsed].CACHE, k, mymxArray);
                                }
                            }
                        }
                        else // Make CACHE a numeric mxArray 
                        {    CHNLS[HandlesUsed].CACHE = mxCreateDoubleMatrix(1,CHNLS[HandlesUsed].NumElements,mxREAL);  
                        }
                        
                        mexMakeArrayPersistent(CHNLS[HandlesUsed].CACHE);
                        
                        plhs[i-1]=mxCreateScalarDouble(++HandlesUsed);                        
                    
                    }
                    else
                        plhs[i-1]=mxCreateScalarDouble(0);

                }
                else
                    plhs[i-1]=mxCreateScalarDouble(0);
            } break;
            
        
        case 2:// MCAOPEN - add channel(s) by PV names. The arguments following prhs[0]
               // argument must be a cell array of strings - PV names
            
            L = mxGetM(prhs[1])*mxGetN(prhs[1]);
            plhs[0] = mxCreateDoubleMatrix(1,L,mxREAL);
            myDblPr = mxGetPr(plhs[0]);
            
            for(i=0;i<L;i++)
            {   mymxArray = mxGetCell(prhs[1],i);
                mxGetString(mymxArray,PVName,PV_NAME_LENGTH_MAX+1);
                status = ca_search(PVName,&(CHNLS[HandlesUsed].CHID));
                if(status == ECA_NORMAL) // if not - go on to the next PV name
                {   status = ca_pend_io(MCA_IO_TIMEOUT);
                    if (status == ECA_NORMAL)
                    {   // Allcate persistent memory for the DataBuffer on this channel
                        //RequestType = dbf_type_to_DBR(ca_field_type(CHNLS[HandlesUsed].CHID));
                        CHNLS[HandlesUsed].NativeType2DBR = dbf_type_to_DBR(ca_field_type(CHNLS[HandlesUsed].CHID));
                        CHNLS[HandlesUsed].NumElements = ca_element_count(CHNLS[HandlesUsed].CHID);
                        CHNLS[HandlesUsed].MonitorEventCount = 0;
                        //Cnt=ca_element_count(CHNLS[HandlesUsed].CHID);
                        switch(CHNLS[HandlesUsed].NativeType2DBR)
                        {   case DBR_STRING:
                                CHNLS[HandlesUsed].DataBuffer = mxCalloc(CHNLS[HandlesUsed].NumElements,sizeof(dbr_string_t)); 
                            break;
                        
                            case DBR_INT: // As defined in db_access.h DBR_INT = DBR_SHORT = 1
                                CHNLS[HandlesUsed].DataBuffer = mxCalloc(CHNLS[HandlesUsed].NumElements,sizeof(dbr_short_t)); 
                            break;
                        
                            case DBR_FLOAT:
                                CHNLS[HandlesUsed].DataBuffer = mxCalloc(CHNLS[HandlesUsed].NumElements,sizeof(dbr_float_t)); 
                            break;
                
                        
                            case DBR_ENUM:
                                CHNLS[HandlesUsed].DataBuffer = mxCalloc(CHNLS[HandlesUsed].NumElements,sizeof(dbr_enum_t)); 
                            break;
                
                            case DBR_CHAR:
                                CHNLS[HandlesUsed].DataBuffer = mxCalloc(CHNLS[HandlesUsed].NumElements,sizeof(dbr_char_t)); 
                            break;
                    
                            case DBR_LONG:
                                CHNLS[HandlesUsed].DataBuffer = mxCalloc(CHNLS[HandlesUsed].NumElements,sizeof(dbr_short_t)); 
                            break;
                    
                            case DBR_DOUBLE:
                                CHNLS[HandlesUsed].DataBuffer = mxCalloc(CHNLS[HandlesUsed].NumElements,sizeof(dbr_double_t)); 
                            break;
                        }   
                        mexMakeMemoryPersistent(CHNLS[HandlesUsed].DataBuffer);   
                        
                        if(CHNLS[HandlesUsed].NativeType2DBR == DBR_STRING) // CACHE
                        {   CHNLS[HandlesUsed].CACHE = mxCreateCellMatrix(1,CHNLS[HandlesUsed].NumElements);
                            for(k=0;k<CHNLS[HandlesUsed].NumElements;k++)
                            {   mymxArray = mxCreateString(StrBuffer);
                                mexMakeArrayPersistent(mymxArray);
                                mxSetCell(CHNLS[HandlesUsed].CACHE, k, mymxArray);
                            }
                        }
                        else
                        {    CHNLS[HandlesUsed].CACHE = mxCreateDoubleMatrix(1,CHNLS[HandlesUsed].NumElements,mxREAL);  
                        }
                        
                        mexMakeArrayPersistent(CHNLS[HandlesUsed].CACHE);
                        
                        
                        myDblPr[i] = ++HandlesUsed;
                    }
                    else
                        myDblPr[i] = 0;
                }
                else
                    myDblPr[i] = 0;
            } break;
            
       case 3: // MCAOPEN Return names of connected channels as cell array of strings
            plhs[0] = mxCreateCellArray(1, &HandlesUsed);
            for(i=0;i<HandlesUsed;i++)
            {   if(CHNLS[i].CHID!=NULL)
                    {   mymxArray = mxCreateString(ca_name(CHNLS[i].CHID));
                        mxSetCell(plhs[0], i, mymxArray);
                    }
                else
                    {   mymxArray = mxCreateString("");
                        //mexPrintf("Handle: %d PV: %s\n",i+1, "Cleared Channel");
                        mxSetCell(plhs[0], i, mymxArray);
                    }
              } break;
        
        
         
        case 5: // MCACLOSE permanently clear channel
            Hndl = (int)mxGetScalar(prhs[1]);
            if(Hndl<1 || Hndl>HandlesUsed)
                mexErrMsgTxt("Handle out of range");  

            // If a monitor is installed, set the EVID pointer to NULL 
            // ca_clear_event dos not do it by itself

            if(CHNLS[Hndl-1].EVID) 
                CHNLS[Hndl-1].EVID = NULL;
                
            // If there is Callback String - destroy it
            if(CHNLS[Hndl-1].MonitorCBString)
            {   mxFree(CHNLS[Hndl-1].MonitorCBString); 
                CHNLS[Hndl-1].MonitorCBString =NULL;
            }    
            
            if(ca_state(CHNLS[Hndl-1].CHID)==3)
                mexWarnMsgTxt("Channel previously cleared");
            else
                if(ca_clear_channel(CHNLS[Hndl-1].CHID)!=ECA_NORMAL)
                    mexErrMsgTxt("ca_clear_channel failed");

            break;
            
        case 10: // MCAINFO return channels info as MATLAB structure array
            if(HandlesUsed>0)
            {   plhs[0] = mxCreateStructMatrix(1,HandlesUsed,6,MCAInfoFields);
                
                for(i=0;i<HandlesUsed;i++)
                {   mxSetFieldByNumber(plhs[0],i,0,mxCreateString(ca_name(CHNLS[i].CHID)));
                    mxSetFieldByNumber(plhs[0],i,1,mxCreateScalarDouble(ca_element_count(CHNLS[i].CHID)));
                    mxSetFieldByNumber(plhs[0],i,5,mxCreateString(ca_host_name(CHNLS[i].CHID)));
                    
                    switch(ca_state(CHNLS[i].CHID))
                    {   case 1: // Disconnected due to Server or Network - may reconnect 
                            mxSetFieldByNumber(plhs[0],i,2,mxCreateString("unknown"));
                            mxSetFieldByNumber(plhs[0],i,3,mxCreateString("disconnected"));
                            mxSetFieldByNumber(plhs[0],i,4,mxCreateString("Disconnected due to server or network problem"));
                            break;
                        case 2: // Normal connection
                            mxSetFieldByNumber(plhs[0],i,2,mxCreateString(NativeTypeStrings[ca_field_type(CHNLS[i].CHID)]));
                            mxSetFieldByNumber(plhs[0],i,3,mxCreateString("connected"));
                            mxSetFieldByNumber(plhs[0],i,4,mxCreateString("Normal connection"));
                            break;
                        case 3: // Disconnected by user
                            mxSetFieldByNumber(plhs[0],i,2,mxCreateString("unknown"));
                            mxSetFieldByNumber(plhs[0],i,3,mxCreateString("disconnected"));
                            mxSetFieldByNumber(plhs[0],i,4,mxCreateString("Permanently disconnected (cleared) by the user"));                    
                            break;
                    }    
                }
            }
            else
            {   mexWarnMsgTxt("No connected PV's found"); 
                plhs[0] = mxCreateDoubleMatrix(0,0,mxREAL);
                
            }
            break;    
        
            
        case 11: // MCAINFO return info for 1 channel by handle number 
            Hndl = (int)mxGetScalar(prhs[1]);
            if(Hndl<1 || Hndl>HandlesUsed)
                mexErrMsgTxt("Handle out of range");  
                
            plhs[0] = mxCreateStructMatrix(1,1,6,MCAInfoFields);

            mxSetFieldByNumber(plhs[0],0,0,mxCreateString(ca_name(CHNLS[Hndl-1].CHID)));
            mxSetFieldByNumber(plhs[0],0,1,mxCreateScalarDouble(ca_element_count(CHNLS[Hndl-1].CHID)));
            mxSetFieldByNumber(plhs[0],0,5,mxCreateString(ca_host_name(CHNLS[Hndl-1].CHID)));
            
            switch(ca_state(CHNLS[Hndl-1].CHID))
            {  case 1: // Disconnected due to Server or Network - may reconnect 
                    mxSetFieldByNumber(plhs[0],0,2,mxCreateString("unknown"));
                    mxSetFieldByNumber(plhs[0],0,3,mxCreateString("disconnected"));
                    mxSetFieldByNumber(plhs[0],0,4,mxCreateString("Disconnected due to server or network problem"));
                    break;
                case 2: // Normal connection
                    mxSetFieldByNumber(plhs[0],0,2,mxCreateString(NativeTypeStrings[ca_field_type(CHNLS[Hndl-1].CHID)]));
                    mxSetFieldByNumber(plhs[0],0,3,mxCreateString("connected"));
                    mxSetFieldByNumber(plhs[0],0,4,mxCreateString("Normal connection"));
                    break;
                case 3: // Disconnected by user
                    mxSetFieldByNumber(plhs[0],0,2,mxCreateString("unknown"));
                    mxSetFieldByNumber(plhs[0],0,3,mxCreateString("disconnected"));
                    mxSetFieldByNumber(plhs[0],0,4,mxCreateString("Permanently disconnected (cleared) by the user"));                    
                    break;
            };    
            
        break;    
        
        case 12: // MCASTATE return an array of status (1 - OK, 0 - disconnected or cleared) 
            if(HandlesUsed>0)
            {   plhs[0] = mxCreateDoubleMatrix(1,HandlesUsed,mxREAL);
                myDblPr = mxGetPr(plhs[0]);
                for(i=0;i<HandlesUsed;i++)
                    myDblPr[i] = (double)(ca_state(CHNLS[i].CHID)==2);
            }
            else
            {   mexWarnMsgTxt("No connected PV's found"); 
                plhs[0] = mxCreateDoubleMatrix(0,0,mxREAL);
                
            }
            break;    
        
        
        case 30: // poll
            ca_poll();
        break;
            

        case 50: // MCAGET Get PV values by their MCA handles
            
            for(i=0;i<nrhs-1;i++) // First loop: place all ca_get requests in the buffer
            {   Hndl = (int)mxGetScalar(prhs[1+i]); //start from[1]:  [0] argument is the commnads switch
                if(Hndl<1 || Hndl>HandlesUsed)
                    mexErrMsgTxt("Invalid Handle");
                
                RequestType = dbf_type_to_DBR(ca_field_type(CHNLS[Hndl-1].CHID));
                Cnt = ca_element_count(CHNLS[Hndl-1].CHID);
                status = ca_array_get(RequestType,Cnt,CHNLS[Hndl-1].CHID,CHNLS[Hndl-1].DataBuffer);
                if(status!=ECA_NORMAL)
                    mexPrintf("Error in call to ca_array_get\n");
            }   
            
            status = ca_pend_io(MCA_GET_TIMEOUT);
            if(status!=ECA_NORMAL)
                mexErrMsgTxt("... ca_pend_io call timed out \n");
            
            
            for(i=0;i<nrhs-1;i++) // Another loop to copy data from temp structures to MATLAB
            
            {   Hndl = (int)mxGetScalar(prhs[1+i]);
                RequestType = RequestType = dbf_type_to_DBR(ca_field_type(CHNLS[Hndl-1].CHID));
                Cnt = ca_element_count(CHNLS[Hndl-1].CHID);
                
                if(RequestType==DBR_STRING)
                {   if(Cnt==1)
                        plhs[i] = mxCreateString((char*)(*((dbr_string_t*)(CHNLS[Hndl-1].DataBuffer))));
                    else
                    {   plhs[i] = mxCreateCellMatrix(1,Cnt);
                        for(j=0;j<Cnt;j++)
                            mxSetCell(plhs[i], j, mxCreateString((char*)(*((dbr_string_t*)(CHNLS[Hndl-1].DataBuffer)+j))));
                    }
                }
                
                else 
                {   plhs[i] = mxCreateDoubleMatrix(1,Cnt,mxREAL);
                    myDblPr = mxGetPr(plhs[i]);
                                        
                    switch(dbf_type_to_DBR(ca_field_type(CHNLS[Hndl-1].CHID)))
                    
                    {   case DBR_INT: // As defined in db_access.h DBR_INT = DBR_SHORT = 1
                        for(j=0;j<Cnt;j++)
                            myDblPr[j]= (double)(*((dbr_short_t*)(CHNLS[Hndl-1].DataBuffer)+j));
                        break;    
                 
                        case DBR_FLOAT:
                        for(j=0;j<Cnt;j++)
                            myDblPr[j]= (double)(*((dbr_float_t*)(CHNLS[Hndl-1].DataBuffer)+j));
                        break;
                
                        case DBR_ENUM:
                        for(j=0;j<Cnt;j++)
                            myDblPr[j]= (double)(*((dbr_enum_t*)(CHNLS[Hndl-1].DataBuffer)+j));
                        break;
                
                        case DBR_CHAR:
                        for(j=0;j<Cnt;j++)
                            myDblPr[j]= (double)(*((dbr_char_t*)(CHNLS[Hndl-1].DataBuffer)+j));
                        break;
                    
                        case DBR_LONG:
                        for(j=0;j<Cnt;j++)
                            myDblPr[j]= (double)(*((dbr_long_t*)(CHNLS[Hndl-1].DataBuffer)+j));
                        break;
                    
                        case DBR_DOUBLE:
                        for(j=0;j<Cnt;j++)
                            myDblPr[j]= (double)(*((dbr_double_t*)(CHNLS[Hndl-1].DataBuffer)+j));
                        break;
                    } 

                }
                
            } break;            

            case 51: // MCAGET Get scalar PV of the same type 
                     // second argument is an array of handles
                     // returns an array of values
            
            myDblPr = mxGetPr(prhs[1]);
            M = mxGetM(prhs[1]);
            N = mxGetN(prhs[1]);
            
            NumHandles = M*N;
            plhs[0] = mxCreateDoubleMatrix(M,N,mxREAL);
            
            for(i=0;i<NumHandles;i++) // First loop: place all ca_get requests in the buffer
            {   Hndl = (int)myDblPr[i];
                if(Hndl<1 || Hndl>HandlesUsed)
                    mexErrMsgTxt("Invalid Handle");
                
                RequestType = dbf_type_to_DBR(ca_field_type(CHNLS[Hndl-1].CHID));
                status = ca_array_get(DBR_DOUBLE,1,CHNLS[Hndl-1].CHID,mxGetPr(plhs[0])+i);
                if(status!=ECA_NORMAL)
                    mexPrintf("Error in call to ca_array_get\n");
            }   
            
            status = ca_pend_io(MCA_GET_TIMEOUT);
            if(status!=ECA_NORMAL)
                mexErrMsgTxt("... ca_pend_io call timed out \n");
            
            break;            

        
       
        case 70: // MCAPUT
            NumHandles = (nrhs-1)/2;
            for(i=0;i<NumHandles;i++)
            {   j = 2+i*2;
                Hndl = (int)mxGetScalar(prhs[1+i*2]); 
                if(Hndl<1 || Hndl>HandlesUsed)
                    mexErrMsgTxt("Handle out of range - no values written");
                // Set the status to 0 - mcaput_callback will write 1, if successful
                CHNLS[Hndl-1].LastPutStatus = 0;    
                RequestType = dbf_type_to_DBR(ca_field_type(CHNLS[Hndl-1].CHID));            
                Cnt = ca_element_count(CHNLS[Hndl-1].CHID);
                
                
                // If a value to write is passed as a string - the number of elements to write 
                //   is 1 , NOT the length of the string returned by mxGetNumberOfElements
                if(mxIsChar(prhs[j])) 
                    L=1;
                else
                    L = min(mxGetNumberOfElements(prhs[j]),Cnt);
                

                // Copy double or string data from MATLAB prhs[] to DataBuffer
                // on each channel 
                
                if(RequestType==DBR_STRING)
                {   // STRING type is is passed as a cell array of strings
                    // A a 1-row MATLAB character array (1 string) may also be passed as a value
                    
                    if(mxIsChar(prhs[j]))
                    {   mxGetString(prhs[j], StrBuffer, sizeof(dbr_string_t));
                        strcpy((char*)(*((dbr_string_t*)(CHNLS[Hndl-1].DataBuffer))),StrBuffer);
                        
                    }
                    else if(mxIsCell(prhs[j]))
                    {   for(k=0;k<L;k++)
                        {   mxGetString(mxGetCell(prhs[j],k), StrBuffer, sizeof(dbr_string_t));
                            strcpy((char*)(*((dbr_string_t*)(CHNLS[Hndl-1].DataBuffer)+k)),StrBuffer);
                        }
                    }
                }
                else
                {   myDblPr = mxGetPr(prhs[j]); 
                    switch(RequestType)
                    {   
                        case DBR_INT: // As defined in db_access.h DBR_INT = DBR_SHORT = 1
                        for(k=0;k<L;k++)
                            *((dbr_short_t*)(CHNLS[Hndl-1].DataBuffer)+k) = (dbr_short_t)(myDblPr[k]);
                        break;    
                 
                        case DBR_FLOAT:
                        for(k=0;k<L;k++)
                            *((dbr_float_t*)(CHNLS[Hndl-1].DataBuffer)+k) = (dbr_float_t)(myDblPr[k]);
                        break;
                
                        case DBR_ENUM:
                        for(k=0;k<L;k++)
                            *((dbr_enum_t*)(CHNLS[Hndl-1].DataBuffer)+k) = (dbr_enum_t)(myDblPr[k]);
                        break;
                
                        case DBR_CHAR:
                        for(k=0;k<L;k++)
                            *((dbr_char_t*)(CHNLS[Hndl-1].DataBuffer)+k) = (dbr_char_t)(myDblPr[k]);
                        break;
                   
                        case DBR_LONG:
                        for(k=0;k<L;k++)
                            *((dbr_long_t*)(CHNLS[Hndl-1].DataBuffer)+k) = (dbr_long_t)(myDblPr[k]);
                        break;
                    
                        case DBR_DOUBLE:
                        for(k=0;k<L;k++)
                            *((dbr_double_t*)(CHNLS[Hndl-1].DataBuffer)+k) = (dbr_double_t)(myDblPr[k]);
                        break;
                    } 
                }            
 
                // place request in the que 
                status = ca_array_put_callback(RequestType,L,CHNLS[Hndl-1].CHID,CHNLS[Hndl-1].DataBuffer,
                                                   mcaput_callback,&(CHNLS[Hndl-1].LastPutStatus));

                 if(status!=ECA_NORMAL)
                    mexPrintf("ca_array_put_callback failed\n");
            }   
            
            status = ca_pend_event(MCA_PUT_TIMEOUT);
            
            plhs[0]=mxCreateDoubleMatrix(1,NumHandles,mxREAL);
            myDblPr = mxGetPr(plhs[0]);  
            
            for(i=0;i<NumHandles;i++)
            {   Hndl = (int)mxGetScalar(prhs[1+i*2]);
                myDblPr[i] = (double)CHNLS[Hndl-1].LastPutStatus;
                
            }
           
            break;
        
       case 80: // MCAPUT - fast unconfirmed put for scalar numeric PV's
        
            myDblPr = mxGetPr(prhs[1]);
            M = mxGetM(prhs[1]);
            N = mxGetN(prhs[1]);                
            NumHandles = M*N;
            
            plhs[0] = mxCreateDoubleMatrix(M,N,mxREAL);
            myDblPr = mxGetPr(plhs[0]);  
            
            for(i=0;i<NumHandles;i++)
            {   myDblPr = mxGetPr(plhs[0]);
                Hndl = (int)(*(mxGetPr(prhs[1])+i)); 
                if(Hndl<1 || Hndl>HandlesUsed)
                    mexErrMsgTxt("Handle out of range - no values written");

                status = ca_array_put(DBR_DOUBLE,1,CHNLS[Hndl-1].CHID,mxGetPr(prhs[2])+i);

                if(status!=ECA_NORMAL)
                    {   myDblPr[i] = 0;
                        //mexPrintf("ca_array_put_callback failed\n");
                    }
                    else
                    {   myDblPr[i] = 1;
                    }
                    
            }   
            
            status = ca_pend_io(MCA_PUT_TIMEOUT);
            
            break;    
                 
            
        case 100: // MCAMON install Monitor or replace MonitorCBString
            
            Hndl = (int)mxGetScalar(prhs[1]); 
            
            // Check if the handle is within range 
            if(Hndl<1 || Hndl>HandlesUsed)
            {   plhs[0]=mxCreateScalarDouble(0);
                mexErrMsgTxt("Invalid Handle");
            }
            
            if(CHNLS[Hndl-1].EVID) // if VID is not NULL - another monitor is already installed - replace MonitorCBString
            {   if(CHNLS[Hndl-1].MonitorCBString) // Free memory for occupied by the old MonitorCBString
                {   mxFree(CHNLS[Hndl-1].MonitorCBString);
                    CHNLS[Hndl-1].MonitorCBString = NULL;
                }
                if(nrhs>2) // Check if the new string is specified
                {   if(mxIsChar(prhs[2]))
                    {   buflen = mxGetM(prhs[2])*mxGetN(prhs[2])+1;
                        CHNLS[Hndl-1].MonitorCBString = (char *)mxMalloc(buflen);
                        mexMakeMemoryPersistent(CHNLS[Hndl-1].MonitorCBString);
                        mxGetString(prhs[2],CHNLS[Hndl-1].MonitorCBString,buflen); 
                    } 
                    else
                        mexErrMsgTxt("Third argument must be a string\n");
                }
                plhs[0]=mxCreateScalarDouble(1);
            }
            else // No monitor is presently installed;
            {   RequestType = dbf_type_to_DBR(ca_field_type(CHNLS[Hndl-1].CHID)); // Closest to the native 
            
            
                if(nrhs>2)
                {   if(mxIsChar(prhs[2]))
                    {   buflen = mxGetM(prhs[2])*mxGetN(prhs[2])+1;
                        CHNLS[Hndl-1].MonitorCBString = (char *)mxMalloc(buflen);
                        mexMakeMemoryPersistent(CHNLS[Hndl-1].MonitorCBString);
                        mxGetString(prhs[2],CHNLS[Hndl-1].MonitorCBString,buflen); 
                    } 
                    else
                        mexErrMsgTxt("Third argument must be a string\n");
                }
                else
                    CHNLS[Hndl-1].MonitorCBString = NULL;  // Set MonitorCBString to NULL so that mcaMonitorEventHandler only copies data to CACHE
            
                // Count argument set to 0 - native count
                status = ca_add_array_event(RequestType,0,CHNLS[Hndl-1].CHID, mcaMonitorEventHandler, &CHNLS[Hndl-1], 0.0, 0.0, 0.0, &(CHNLS[Hndl-1].EVID));
              
                if(status!=ECA_NORMAL)
                {   mexPrintf("ca_add_array_event failed\n");      
                    plhs[0]=mxCreateScalarDouble(0);
                }
                else
                {   ca_poll();
                    plhs[0]=mxCreateScalarDouble(1);
                }
            }   
            break;
            
        case 200: // Clear Monitor MCACLEARMON
            
            Hndl = (int)mxGetScalar(prhs[1]); 
            if(Hndl<1 || Hndl>HandlesUsed)
                mexErrMsgTxt("Invalid Handle");
            if(!CHNLS[Hndl-1].EVID) 
                mexErrMsgTxt("No monitor installed - can not clear");
                
            status = ca_clear_event(CHNLS[Hndl-1].EVID);
            if(status!=ECA_NORMAL)
                mexPrintf("ca_clear_event failed\n");
                
            // Set the EVID pointer to NULL (ca_clear_event dos not do it by itself)
            // to use as a FLAG that no monitors are installed 
            CHNLS[Hndl-1].EVID = NULL;
            // Reset
            CHNLS[Hndl-1].MonitorEventCount = 0;    
            // If there is Callback String - destroy it
            if(CHNLS[Hndl-1].MonitorCBString)
            {   mxFree(CHNLS[Hndl-1].MonitorCBString); 
                CHNLS[Hndl-1].MonitorCBString =NULL;
            }
                
          
        break;
          
        case 300: // MCACACHE Get Cached values of a monitored PV
            for(i=0;i<nrhs-1;i++)
            {   Hndl = (int)mxGetScalar(prhs[1+i]);
                // if(Hndl<1 || Hndl>HandlesUsed || !CHNLS[Hndl-1].CACHE)
                if(Hndl<1 || Hndl>HandlesUsed)
                    plhs[i] = mxCreateDoubleMatrix(0,0,mxREAL);
                else
                    {   plhs[i] = mxDuplicateArray(CHNLS[Hndl-1].CACHE);
                        CHNLS[Hndl-1].MonitorEventCount = 0;
                    }
            }       
          
        break;
        
        case 500: // MCAMON Info on installed monitors
            L = 0;
            HndlArray = (int*)mxCalloc(HandlesUsed,sizeof(int));
            
            for(i=0;i<HandlesUsed;i++) // Count installed monitors
            {   if(CHNLS[i].EVID)
                HndlArray[L++]=i+1;
            }       
            
            if(L>0)
            {   plhs[0] = mxCreateDoubleMatrix(1,L,mxREAL);
                myDblPr = mxGetPr(plhs[0]);
                plhs[1] = mxCreateCellMatrix(1,L);
                for(i=0;i<L;i++)
                {   myDblPr[i] = (double)HndlArray[i];
                    mxSetCell(plhs[1],i,mxCreateString(CHNLS[HndlArray[i]-1].MonitorCBString));
                }
            }
            else
            {   plhs[0] = mxCreateDoubleMatrix(0,0,mxREAL);
                plhs[1] = mxCreateCellMatrix(0,0);
            }
            
        break;
        
        case 510: // MCAMONEVENTS Event count fot monitors
                       
            plhs[0] = mxCreateDoubleMatrix(1,HandlesUsed,mxREAL);
            myDblPr = mxGetPr(plhs[0]);
            for(i=0;i<HandlesUsed;i++)
                myDblPr[i]=(double)(CHNLS[i].MonitorEventCount);
            
        break;
        
        case 1000: // print timeout settings
            plhs[0] = mxCreateDoubleMatrix(3,1,mxREAL);
            mexPrintf("MCA timeout settings\n:");
            mexPrintf("mcaopen\t%f [s]\n",  MCA_SEARCH_TIMEOUT );
            mexPrintf("mcaget\t%f [s]\n",  MCA_GET_TIMEOUT ); 
            mexPrintf("mcaput\t%f [s]\n",  MCA_PUT_TIMEOUT );

            myDblPr = mxGetPr(plhs[0]);
            myDblPr[0] = MCA_SEARCH_TIMEOUT;
            myDblPr[1] = MCA_GET_TIMEOUT;
            myDblPr[2] = MCA_PUT_TIMEOUT;

            
        break;
        
        
        case 1001: // set MCA_SEARCH_TIMEOUT
            // return delay value
            MCA_SEARCH_TIMEOUT = mxGetScalar(prhs[1]);
            plhs[0] = mxCreateScalarDouble(MCA_SEARCH_TIMEOUT);
        break;
        
        case 1002: // set MCA_GET_TIMEOUT
            // return delay value
            MCA_GET_TIMEOUT = mxGetScalar(prhs[1]);
            plhs[0] = mxCreateScalarDouble(MCA_GET_TIMEOUT);
        break;
        
        case 1003: // set MCA_PUT_TIMEOUT
            // return delay value
            MCA_PUT_TIMEOUT = mxGetScalar(prhs[1]);
            plhs[0] = mxCreateScalarDouble(MCA_PUT_TIMEOUT);
        break;

    } 
}