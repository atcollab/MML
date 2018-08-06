/* TIMEREVAL.C  mex-file to schedule delayed evaluation of matlab
   commands in MATLAB 'base' workspace
*/

#include <mex.h>
#ifdef WIN32
#pragma once
#include <windows.h>
#endif

static bool RUNNING = false;
static int NUMCALLS = 0;


struct TimerEvent
{   char* MatlabCallbackString;
    UINT TimerID;
    struct TimerEvent *Next;
    struct TimerEvent *Prev;
}; 

static struct TimerEvent *EventListHead = NULL;

// Search linked list for the structure whos TimerID field matches the input TimerID

struct TimerEvent *FindEventByTimerID( UINT TimerID, struct TimerEvent *Head)
{   struct TimerEvent *ThisOne = Head;
    while(ThisOne)
    {   if(ThisOne->TimerID == TimerID)
            return(ThisOne);
        else
            ThisOne = ThisOne->Next;       
    }
    return(ThisOne);
}


int AddToList(UINT TimerID, char* cbs)
{   struct TimerEvent *NewOne;
    NewOne = (struct TimerEvent *)mxMalloc(sizeof(struct TimerEvent));
    if(!NewOne)
        return(0);
    mexMakeMemoryPersistent(NewOne);
    NewOne->MatlabCallbackString = cbs;
    NewOne->TimerID = TimerID;
    NewOne->Prev = NULL;
    NewOne->Next = EventListHead;
    if(EventListHead)
        EventListHead->Prev = NewOne;
    EventListHead = NewOne;
    return(1);
}

void RemoveFromList(struct TimerEvent * EventToRemove)
{   if(!EventToRemove->Prev) // EventToRemove is the Head
    {   if(!EventToRemove->Next) // EventToRemove is also the last element
        {   EventListHead = NULL;
        }
        else // There are elements after EventToRemove
        {   EventListHead = EventToRemove->Next;
            (EventToRemove->Next)->Prev = NULL;
        }
    }
    else // EventToRemove is NOT the Head
    {   if(!EventToRemove->Next) // EventToRemove is the last element
        {   (EventToRemove->Prev)->Next = NULL; 
        }
        else // There are elements before and after EventToRemove - relink
        {   (EventToRemove->Next)->Prev = EventToRemove->Prev;
            (EventToRemove->Prev)->Next = EventToRemove->Next;
        }   
    }
    mxFree(EventToRemove->MatlabCallbackString);
    mxFree(EventToRemove);
}

static void ClearEventList()
{   while(EventListHead)
        {   KillTimer(NULL,EventListHead->TimerID);
            RemoveFromList(EventListHead);      
        }
}

void PrintEventList()
{   struct TimerEvent *ThisOne = EventListHead;
    while(ThisOne)
    {   mexPrintf("%u %s\n", ThisOne->TimerID,ThisOne->MatlabCallbackString);
        ThisOne = ThisOne->Next;
    }
}

void __stdcall  CallbackFncnSingle( HWND hwnd,   UINT uMsg,   UINT idEvent,  DWORD dwTime  )
{   // Scheduled to execute by the call to SetTimer
    // It runs only once: after completion it destroys the timer it is
    // associated with and removes itself from the linked list of scheduled events
    struct TimerEvent *PEvent;
    
    // Search global linked list of events for the matching TimerID
    PEvent = FindEventByTimerID( idEvent, EventListHead);
    
    // Execute commands stored in MatlabCallbackString field in MATLAB 'base' workspace
    mexEvalString(PEvent->MatlabCallbackString);
    
    // After completion - KillTimer and remove the Event from the list
    KillTimer(NULL,idEvent);
    RemoveFromList(PEvent);
}

void __stdcall  CallbackFncnMultiple( HWND hwnd,   UINT uMsg,   UINT idEvent,  DWORD dwTime  )
{   // Scheduled to execute by the call to SetTimer
    // It runs infinite number of times.

    struct TimerEvent *PEvent;
    
    // Search global linked list of events for the matching TimerID
    PEvent = FindEventByTimerID( idEvent, EventListHead);
    
    // Execute commands stored in MatlabCallbackString field in MATLAB 'base' workspace
    mexEvalString(PEvent->MatlabCallbackString);

}



void mexFunction(	int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{   UINT thandle,buflen,tofind;
    int ms_delay,commandswitch,option;
    char* cbs;
    struct TimerEvent* PEvent;
    mexAtExit(ClearEventList);
    
    commandswitch = (int)mxGetScalar(prhs[0]);
    switch(commandswitch)
    {   case 1: //Add single call timer
            ms_delay = (int)mxGetScalar(prhs[1]);
            buflen = (mxGetM(prhs[2]) * mxGetN(prhs[2]) * sizeof(mxChar)) + 1;
            cbs = (char*)mxMalloc(buflen);
            mxGetString(prhs[2], cbs ,buflen);
            mexMakeMemoryPersistent(cbs);
            thandle=SetTimer(NULL,NULL,ms_delay,CallbackFncnSingle);
            AddToList(thandle,cbs);
            plhs[0]=mxCreateScalarDouble(thandle);
            
        break;
        
        case 2: //Add multiple call timer
            ms_delay = (int)mxGetScalar(prhs[1]);
            buflen = (mxGetM(prhs[2]) * mxGetN(prhs[2]) * sizeof(mxChar)) + 1;
            cbs = (char*)mxMalloc(buflen);
            mxGetString(prhs[2], cbs ,buflen);
            mexMakeMemoryPersistent(cbs);
            thandle=SetTimer(NULL,NULL,ms_delay,CallbackFncnMultiple);
            AddToList(thandle,cbs);
            plhs[0]=mxCreateScalarDouble(thandle);
        break;
        
        case 3: 
            // Kill all existing timers before starting a new one
            // timereval(3,type,delay,callback);
            ClearEventList();
            option = (int)mxGetScalar(prhs[1]);         
            ms_delay = (int)mxGetScalar(prhs[2]);
            buflen = (mxGetM(prhs[3]) * mxGetN(prhs[3]) * sizeof(mxChar)) + 1;
            cbs = (char*)mxMalloc(buflen);
            mxGetString(prhs[3], cbs ,buflen);
            mexMakeMemoryPersistent(cbs);
            
            if(option==1)
                thandle=SetTimer(NULL,NULL,ms_delay,CallbackFncnSingle);
            else if(option==2)
                thandle=SetTimer(NULL,NULL,ms_delay,CallbackFncnMultiple);
                
            AddToList(thandle,cbs);
            plhs[0]=mxCreateScalarDouble(thandle);
            
        break;   
        
        case 4:
            PrintEventList();
        
            
        break; 
        
        case 5:
            tofind = (int)mxGetScalar(prhs[1]);  
            PEvent = FindEventByTimerID( tofind, EventListHead);
            if(PEvent)
            {   KillTimer(NULL,PEvent->TimerID);
                RemoveFromList(PEvent);
            }
                 
        break;    

        case 6:
            // timereval(6,OldTimerID,type,delay,callback);
            tofind = (int)mxGetScalar(prhs[1]);
            PEvent = FindEventByTimerID( tofind, EventListHead);
            if(PEvent)
            {   KillTimer(NULL,PEvent->TimerID);
                RemoveFromList(PEvent);
            }
            option = (int)mxGetScalar(prhs[2]);
            
            ms_delay = (int)mxGetScalar(prhs[3]);
            buflen = (mxGetM(prhs[4]) * mxGetN(prhs[4]) * sizeof(mxChar)) + 1;
            cbs = (char*)mxMalloc(buflen);
            mxGetString(prhs[4], cbs ,buflen);
            mexMakeMemoryPersistent(cbs);
            
            if(option==1)
                thandle=SetTimer(NULL,NULL,ms_delay,CallbackFncnSingle);
            else if(option==2)
                thandle=SetTimer(NULL,NULL,ms_delay,CallbackFncnMultiple);
                
            AddToList(thandle,cbs);
            plhs[0]=mxCreateScalarDouble(thandle);
            
        break;   
        

    }
            
        
}
