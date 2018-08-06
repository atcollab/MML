
// System
#ifdef BCC
#include <cstdlib>
#include <iostream>
#include <algorithm>
using namespace std;
#endif

// Matlab
#include "mex.h"

// Base
#include <shareLib.h>
#include <cadef.h>
#include <epicsMutex.h>
#include <tsDefs.h>
#include <dbDefs.h>
#include <errlog.h>

// Local
#include "MCAVersion.h"
#include "ChannelAccess.h"
#include "Channel.h"
#include "hash.h"
#include "queue.h"
#include "MCAError.h"

static ChannelAccess *CA = 0;
typedef IntHash<Channel> ChannelHash;
static ChannelHash ChannelTable;

class MonitorQueue
{
public:
    void clear()
    {
        mutex.lock();
        while(!MonQueue.IsEmpty())
            MonQueue.Dequeue();
        mutex.unlock();
    }

    void add(int handle)
    {
        if (handle == 0)
        {
            mexPrintf("MCA: internal error, tried to add handle 0 to MonitorQueue\n");
            return;
        }
        mutex.lock();
        MonQueue.Enqueue(handle);
        mutex.unlock();
    }
        
    int remove()
    {
        int result;
        mutex.lock();
        if (MonQueue.IsEmpty())
            result = 0;
        else
            result = MonQueue.Dequeue();
        mutex.unlock();
        return result;
    }
        
private:
    epicsMutex mutex;
    Queue<int> MonQueue;
};

static MonitorQueue MonitorQueue;

static int addChannel(const char *name)
{
    if (CA == 0)
    {
        MCAError::Error("addChannel(%s) called without CA", name);
        return 0;
    }
    Channel* Chan = new Channel(CA, name);
    int Handle = Chan->GetHandle();
    if (Handle != 0)
    {
        // Add the channel into the collection of channels
        ChannelTable.insert(Handle, Chan);
    }
    return Handle;
}

void mca_cleanup()
{
    ChannelHash::Iterator iter(ChannelTable);    

    // Delete all the channels from the Channel Table
    while (iter.getValue())
    {
        int key = iter.getKey();
        Channel *Chan = iter.remove();
        int Handle = Chan->GetHandle();
        if (Handle != key)
            MCAError::Warn("mca_cleanup inconsistency: key %d vs. handle %d\n",
                           key, Handle);
        Chan->ClearEvent();
        delete Chan;
    }
    
    // Empty the Monitor Command Queue
    MonitorQueue.clear();
    delete CA;
    CA = 0;
}

void monitor_callback( struct event_handler_args arg )
{
    Channel *Chan = (Channel *) arg.usr;
    if (CA->debugMode())
        mexPrintf("monitor_callback(%s) ...\n", Chan->GetPVName());

    Chan->LoadMonitorCache(arg);
    Chan->IncrementEventCount();
    // If a monitor string is installed, store the channel's
    // handle in the queue for subsequent timer-initiated execution.
    if (Chan->MonitorStringInstalled())
        MonitorQueue.add(Chan->GetHandle());
}

// Helper for mcainfo, fills one row in array with info for channel
static const char* MCAInfoFields[] = { "Handle", "PVName", "ElementCount", "NativeType", "State", "MCAMessage", "Host","Units" };
static void getChannelInfo(Channel *Chan, mxArray *matrix, int row)
{
    mxSetFieldByNumber(matrix, row, 0, mxCreateDoubleScalar(Chan->GetHandle()));
    mxSetFieldByNumber(matrix, row, 1, mxCreateString(Chan->GetPVName()));
    mxSetFieldByNumber(matrix, row, 2, mxCreateDoubleScalar(Chan->GetNumElements()));
    switch (Chan->GetState())
    {
    case cs_conn:
        mxSetFieldByNumber(matrix, row, 3, mxCreateString(Chan->GetRequestTypeStr()));
        mxSetFieldByNumber(matrix, row, 4, mxCreateString("connected"));
        mxSetFieldByNumber(matrix, row, 5, mxCreateString("Normal connection"));
        break;

    case cs_closed:
        mxSetFieldByNumber(matrix, row, 3, mxCreateString("unknown"));
        mxSetFieldByNumber(matrix, row, 4, mxCreateString("disconnected"));
        mxSetFieldByNumber(matrix, row, 5, mxCreateString("Permanently disconnected (cleared)"));
        break;

    default:
        mxSetFieldByNumber(matrix, row, 3, mxCreateString("unknown"));
        mxSetFieldByNumber(matrix, row, 4, mxCreateString("disconnected"));
        mxSetFieldByNumber(matrix, row, 5, mxCreateString("Disconnected due to server or network problem"));
        break;
    }
    mxSetFieldByNumber(matrix, row, 6, mxCreateString(Chan->GetHostName()));
  if (Chan->IsNumeric()) mxSetFieldByNumber(matrix, row, 7, mxCreateString(Chan->GetEngineeringUnits()));
}

// All the matlab calls end up in here.
// This routine is ugly, one big switch for all the
// 'mca(...)' calls, and most important there's no
// enforcement of consistent code numbers in the
// mca(..) calls and the switch in here....
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    char PVName[PVNAME_SZ + 1];

    // Lazy initialization
    if (CA == 0)
    {
        /* With R3.14.7, Matlab crashes on exit with 'errlogInit failed...'
         * unless we do this here:
         */
        errlogInit(0);
        CA = new ChannelAccess();
        mexAtExit(mca_cleanup);
        mexLock();
    }

    // Obtain the MCA command and then execute it.
    int    commandswitch = (int) mxGetScalar(prhs[0]);
    switch (commandswitch)
    {
    case -1:   // MCAVERSION - This is where the version string gets defined!
        plhs[0] = mxCreateString(MCA_VERSION);
        break;
        
    case 0:    // MCAUNLOCK - unlocks the mex file so it can be cleared from memory with clear
        mexUnlock();
        break;
    
    case 1:    // MCAOPEN - open channels using strings of PV Names
    {    // Loop through all the supplied PV Names
        for (int i = 0; i < nrhs - 1; i++)
        {
            // First argument of prhs is the command switch
            mxGetString(prhs[i + 1], PVName, PVNAME_SZ+1);
            plhs[i] = mxCreateDoubleScalar(addChannel(PVName));
        }
        break;
    }
    
    case 2:    // MCAOPEN - open channels using a cell array of PV Names
    {    // Determine how big the output cell array needs to be and then create it
        int L = mxGetM(prhs[1]) * mxGetN(prhs[1]);
        plhs[0] = mxCreateDoubleMatrix(1, L, mxREAL);
        double *myDblPr = mxGetPr(plhs[0]);

        // Loop through all the supplied PV Names in the cell array
        for (int i = 0; i < L; i++)
        {
            mxArray *mymxArray = mxGetCell(prhs[1], i);
            mxGetString(mymxArray, PVName, PVNAME_SZ+1);
            myDblPr[i] = addChannel(PVName);
        }
        break;
    }
    
    case 3:    // MCAOPEN - Returns two lists:
               //              a) A double matrix of handles of connected PVs
               //              b) a cell array of correcponding PV names.
    {
        int HandlesUsed = ChannelTable.size();
        // Matrix of handles of connected PVs
        plhs[0] = mxCreateDoubleMatrix(1, HandlesUsed, mxREAL);
        double *myDblPr = mxGetPr(plhs[0]);
        // Cell array of PV Names
        plhs[1] = mxCreateCellArray(1, &HandlesUsed);

        // Create an iterator for the Channel Table and get the first element.
        ChannelHash::Iterator iter(ChannelTable);   
        Channel *Chan = iter.getValue();
        int i = 0;
        while (Chan)
        {
            int Handle = Chan->GetHandle();
            if (Handle != iter.getKey())
                MCAError::Warn("mca inconsistency: Handle %d vs. key %d\n",
                                Handle, iter.getKey());
            myDblPr[i] = Handle;
            mxArray *mymxArray = mxCreateString(Chan->GetPVName());
            mxSetCell(plhs[1], i, mymxArray);
            ++i;
            Chan = iter.next();
        }
        break;
    }

    // 4 used to be MCACHECK, now same as MCASTATE

    case 5:    // MCACLOSE - Close one channel
    {
        for (int i = 0; i < nrhs - 1; i++)
        {
            int Handle = (int) mxGetScalar(prhs[i + 1]);
            // Retrieve the Channel from the Channel Table.
            Channel *Chan = ChannelTable.find(Handle);
            if (!Chan)
                MCAError::Error("mcaclose(%d): Invalid handle.", Handle);
            else 
            {
                ChannelTable.remove(Handle);
                delete Chan;
            }
        }
        break;
    }

    case 10:    // MCAINFO - Returns two lists:
                //              a) A double matrix of handles of PVs
                //              b) Channel information as a MATLAB structure array
    {
        int HandlesUsed = ChannelTable.size();
        if (HandlesUsed > 0)
        {
            plhs[0] = mxCreateDoubleMatrix(1, HandlesUsed, mxREAL);
            double *handles = mxGetPr(plhs[0]);
            plhs[1] = mxCreateStructMatrix(1, HandlesUsed, 8, MCAInfoFields);

            // Create an iterator for the Channel Table and get the first element.
            ChannelHash::Iterator iter(ChannelTable);   
            Channel *Chan = iter.getValue();
            int i = 0;
            while (Chan)
            {
                getChannelInfo(Chan, plhs[1], i);
                handles[i] = Chan->GetHandle();
                ++i;
                Chan = iter.next();
            }
            if (i != HandlesUsed)
                MCAError::Warn("mcainfo: Got %d, expected %d PVs\n",
                               i, HandlesUsed);        
        }
        else
        {
            MCAError::Warn("mcainfo: No connected PVs found.");
            plhs[0] = mxCreateDoubleMatrix(0, 0, mxREAL);
            plhs[1] = mxCreateDoubleMatrix(0, 0, mxREAL);
        }
        break;
    }

    case 11:    // MCAINFO - Returns Channel information for one Channel
    {
        int Handle = (int) mxGetScalar(prhs[1]);
        Channel *Chan = ChannelTable.find(Handle);
        if (!Chan)
            MCAError::Error("mcainfo(%d): Invalid handle.", Handle);
        else
        {
            plhs[0] = mxCreateStructMatrix(1, 1, 8, MCAInfoFields);
            getChannelInfo(Chan, plhs[0], 0);
        }
        break;
    }

    // MCASTATE(no args) - return array (pv, states) of status for all open channels
    //            (1 - OK, 0 - disconnected)
    case 12:
    {
        int HandlesUsed = ChannelTable.size();
        // Matrix of handles of connected PVs
        plhs[0] = mxCreateDoubleMatrix(1, HandlesUsed, mxREAL);
        double *myDblPr0 = mxGetPr(plhs[0]);

        // Matrix of states of connected PVs
        plhs[1] = mxCreateDoubleMatrix(1, HandlesUsed, mxREAL);
        double *myDblPr1 = mxGetPr(plhs[1]);

        // Loop through all the open channels
        if (nrhs == 1)
        {
            if (HandlesUsed > 0)
            {
                ChannelHash::Iterator iter(ChannelTable);   
                Channel *Chan = iter.getValue();
                int i = 0;
                while (Chan)
                {
                    myDblPr0[i] = (double)(Chan->GetHandle());
                    myDblPr1[i] = (double)(Chan->GetState() == 2);
                    ++i;
                    Chan = iter.next();
                }
            }
            else
            {
                mexWarnMsgTxt("No connected PVs found");
                plhs[0] = mxCreateDoubleMatrix(0, 0, mxREAL);
                plhs[1] = mxCreateDoubleMatrix(0, 0, mxREAL);
            }
        }
        break;
    }

    // MCASTATE(pv, pv, ...) - return an array of status for specified channels
    //                         (1 - OK, 0 - disconnected)
    case 13:
    {
        int HandlesUsed = nrhs - 1;

        // Matrix of states of connected PVs
        plhs[0] = mxCreateDoubleMatrix(1, HandlesUsed, mxREAL);
        double *myDblPr = mxGetPr(plhs[0]);
        // Only loop through the supplied channels
        for (int i = 0; i < HandlesUsed; i++)
        {
                int Handle = (int) mxGetScalar(prhs[i + 1]);
                Channel *Chan = ChannelTable.find(Handle);
                if (!Chan)
                    MCAError::Error("mcastate(%d): Invalid handle.", Handle);

                myDblPr[i] = (double)(Chan->GetState() == cs_conn);
        }
        break;
    }

    case 30:    // MCAPOLL - Poll Channel Access
        ca_poll();
        break;
    case 40:    // MCAENUMSTRINGS - Get ENUM Strings for one channel
    {
        int NoStrings = 2;
        mxArray *mymxArray1 ;

        int Handle = (int) mxGetScalar(prhs[1]);
        Channel *Chan = ChannelTable.find(Handle);
        if (!Chan)
            MCAError::Error("mcaget(%d): Invalid handle.", Handle);
        // Get the current value from Channel Access.
        // Calls MCAError::Error on failure...
        else
        {
            Chan->GetEnumStringsFromCA();
            NoStrings=Chan->GetNumEnumStrings();
            plhs[0] = mxCreateCellArray(1, &NoStrings);
            if(NoStrings > 0) {
                for(int j=0;j<NoStrings;j++){
                    mymxArray1 = mxCreateString(Chan->GetEnumString(j));
                    mxSetCell(plhs[0],j,mymxArray1);
                }
            }

       }
       break;
    }
   case 41:    // MCAEGU - Get engineering units
   {
        int NoStrings=1;
        mxArray *mymxArray ;
        int Handle = (int) mxGetScalar(prhs[1]);
        Channel *Chan = ChannelTable.find(Handle);
        if (!Chan)
            MCAError::Error("mcaget(%d): Invalid handle.", Handle);
        else
        {
            plhs[0] = mxCreateCellArray(1, &NoStrings);
            if(NoStrings > 0) {
                    mymxArray = mxCreateString(Chan->GetEngineeringUnits());
                    mxSetCell(plhs[0],0,mymxArray);
            }
        }
        break;
    }
   case 42:    // MCAPREC - Get channel precision
   {
        int Handle = (int) mxGetScalar(prhs[1]);
        Channel *Chan = ChannelTable.find(Handle);
        if (!Chan)
            MCAError::Error("mcaget(%d): Invalid handle.", Handle);
        else
        {
           plhs[0] = mxCreateDoubleScalar(Chan->GetPrecision());
        }
        break;
    }
   case 43:    // MCATYPE - function...to be tested
   {
        int NoStrings=1;
        mxArray *mymxArray ;
        int Handle = (int) mxGetScalar(prhs[1]);
        Channel *Chan = ChannelTable.find(Handle);
        if (!Chan)
            MCAError::Error("mcaget(%d): Invalid handle.", Handle);
        else
        {
            plhs[0] = mxCreateCellArray(1, &NoStrings);
            if(NoStrings > 0) {
                    mymxArray = mxCreateString(Chan->GetRequestTypeStr());
                    mxSetCell(plhs[0],0,mymxArray);
            }
        }
        break;
    }


    case 50:    // MCAGET(pv, pv, ...) - Get PV Values by their MCA Handles
    {
        for (int i = 0; i < nrhs - 1; i++)
        {
            int Handle = (int) mxGetScalar(prhs[i + 1]);
            Channel *Chan = ChannelTable.find(Handle);
            if (!Chan)
                MCAError::Error("mcaget(%d): Invalid handle.", Handle);
            // Get the current value from Channel Access.
            // Calls MCAError::Error on failure...
            Chan->GetValueFromCA();
            int Num = Chan->GetNumElements(); 
            if (Chan->GetRequestType() == DBR_TIME_STRING)
            {
                if (Num == 1)
                    plhs[i] = mxCreateString(Chan->GetStringValue(0));
                else
                {
                    plhs[i] = mxCreateCellMatrix(1, Num);
                    for (int j = 0; j < Num; j++)
                        mxSetCell(plhs[i], j, mxCreateString(Chan->GetStringValue(j)));
                }
            }
            else
            {
                plhs[i] = mxCreateDoubleMatrix(1, Num, mxREAL);
                double *myDblPr = mxGetPr(plhs[i]);
                for (int j = 0; j < Num; j++)
                    myDblPr[j] = Chan->GetNumericValue(j);
            }
        }
        break;
    }

    case 51:    // MCAGET(pv_array) - Get Scalar PV of the same type
                // Second argument is an array of handles
                // Returns an array of values
    {
        double *myRDblPr = mxGetPr(prhs[1]);
        int M = mxGetM(prhs[1]);
        int N = mxGetN(prhs[1]);
        int NumHandles = M * N;

        plhs[0] = mxCreateDoubleMatrix(M, N, mxREAL);
        double *myLDblPr = mxGetPr(plhs[0]);

        // Issue get requests for each channel
        for (int i = 0; i < NumHandles; i++)
        {
            int Handle = (int) myRDblPr[i];
            Channel *Chan = ChannelTable.find(Handle);
            if (!Chan)
                MCAError::Error("mcaget(%d): Invalid handle.", Handle);

            if (Chan->IsNumeric())
                Chan->GetValueFromCA();
            else
                MCAError::Error(
                "MCAGET(%d) can only be used for numeric PVs when called with an array of PVs",
                Handle);
        }
        // TODO: This is nonsense, since it's really one get after the other.
        // Would make sense if GetValueFromCA() didn't flush CA,
        // then follow with one 'wait' right here to get all values...
        for (int j = 0; j < NumHandles; j++)
        {
            int Handle = (int) myRDblPr[j];
            Channel *Chan = ChannelTable.find(Handle);
            myLDblPr[j] = (double)Chan->GetNumericValue(0);
        }

        break;
    }

    case 60:    // MCATIME - Returns the local 
                // year, month, day, hour, min, sec, nanosec
                // for the most recently retrieved value
                // for a channel (via MCAGET or MCAMON)
    {
        for (int i = 0; i < nrhs - 1; i++)
        {
            int Handle = (int) mxGetScalar(prhs[i + 1]);
            Channel *Chan = ChannelTable.find(Handle);
            if (!Chan)
                MCAError::Error("mcatime(%d): Invalid handle.", Handle);
            plhs[i] = mxCreateDoubleMatrix(1, 7, mxREAL);
            double *d = mxGetPr(plhs[i]);
            epicsTime time(Chan->GetTimeStamp());
            local_tm_nano_sec local = (local_tm_nano_sec) time;
            d[0] = local.ansi_tm.tm_year + 1900;
            d[1] = local.ansi_tm.tm_mon + 1;
            d[2] = local.ansi_tm.tm_mday;
            d[3] = local.ansi_tm.tm_hour;
            d[4] = local.ansi_tm.tm_min;
            d[5] = local.ansi_tm.tm_sec;
            d[6] = local.nSec;
        }
        break;
    }

    case 61:    // MCAALARM - Returns the EPICS Alarm Status and Severity for the most 
                //            recently retrieved value for a channel (via MCAGET or MCAMON)
    {
        for (int i = 0; i < nrhs - 1; i++)
        {
            int Handle = (int) mxGetScalar(prhs[i + 1]);
            Channel *Chan = ChannelTable.find(Handle);
            if (!Chan)
                MCAError::Error("mcaalarm(%d): Invalid handle.", Handle);
            plhs[i] = mxCreateDoubleMatrix(1, 2, mxREAL);
            double *myDblPr = mxGetPr(plhs[i]);
            myDblPr[0] = (double)Chan->GetAlarmStatus();
            myDblPr[1] = (double)Chan->GetAlarmSeverity();
        }
        break;
    }

    case 70:    // MCAPUT(PV, VALUE, PV, VALUE, ...) - Put values to PVs by their MCA Handles
    {
        // Following the first argument, which is the command switch, the
        // values for each channel come in pairs
        int NumHandles = (nrhs - 1) /2;
        dbr_string_t StrBuffer;
        
        plhs[0] = mxCreateDoubleMatrix(1, NumHandles, mxREAL);
        double *result = mxGetPr(plhs[0]);
        for (int i = 0; i < NumHandles; i++)
        {    // Get the handle and find the channel
            int j = 2 + i * 2;
            int Handle = (int) mxGetScalar(prhs[1 + i * 2]);
            Channel *Chan = ChannelTable.find(Handle);
            if (!Chan)
                MCAError::Error("mcaput(%d): Invalid handle.", Handle);

            chtype RequestType = Chan->GetRequestType();
            int Num = Chan->GetNumElements(); 
            // Get the number of values to write
            int L;
            if (mxIsChar(prhs[j]))
                L = 1;
            else
            {   // minimum(PV array size, provided data size)
                L = mxGetNumberOfElements(prhs[j]);
                if (Num < L)
                    L = Num;
            }
            if (RequestType == DBR_TIME_STRING)
            {
                if (mxIsNumeric(prhs[j]))
                    MCAError::Error("mcaput(%s): Need string values",
                                    Chan->GetPVName());
                if (mxIsChar(prhs[j]))
                {
                    mxGetString(prhs[j], StrBuffer, sizeof(dbr_string_t));
                    Chan->SetStringValue(0, StrBuffer);
                }
                else if (mxIsCell(prhs[j]))
                {
                    for (int k = 0; k < L; k++)
                    {
                        mxGetString(mxGetCell(prhs[j], k), StrBuffer, sizeof(dbr_string_t));
                        Chan->SetStringValue(k, StrBuffer);
                    }
                }
            }
            else // native data is numeric
            {    
                if (!mxIsNumeric(prhs[j]))
                    MCAError::Error("mcaput(%s): Need numeric values",
                                    Chan->GetPVName());
                double *myDblPr = mxGetPr(prhs[j]);
                for (int k = 0; k < L; k++)
                    Chan->SetNumericValue(k, myDblPr[k]);
            }

            // Put the values to Channel Access, get response
            result[i] = Chan->PutValueToCACallback(L);
            // mexPrintf("back from PutValueToCACallback(%s) : %g\n",
            //           Chan->GetPVName(), result[i]);
        }
        break;
    }

    case 80:    // MCAPUT(PV-array, VALUE-array) - VALUE array contains scalars
    {
        int M = mxGetM(prhs[1]);
        int N = mxGetN(prhs[1]);
        int NumHandles = M * N;
        plhs[0] = mxCreateDoubleMatrix(M, N, mxREAL);
        for (int i = 0; i < NumHandles; i++)
        {
            int Handle = (int) (*(mxGetPr(prhs[1]) + i));
            Channel *Chan = ChannelTable.find(Handle);
            if (!Chan)
                MCAError::Error("mcaput([pv, ..], [scalar, ...]): Invalid handle %d.", Handle);
            if (! Chan->IsNumeric())
                MCAError::Error("MCAPUT([pv, pv, ..], [scalar, scalar, ...]) can only be used for numeric PVs.");
            // Write the value to the PV
            double Value = (*(mxGetPr(prhs[2]) + i));
            Chan->SetNumericValue(0, Value);
            double *result = mxGetPr(plhs[0]);
            result[i] = Chan->PutValueToCA(1) ? 1.0 : 0.0;
        }
        break;
    }

    case 100:    // MCAMON - install a monitor
    {
        // Find the channel with the specified handle
        int Handle = (int) mxGetScalar(prhs[1]);
        Channel *Chan = ChannelTable.find(Handle);
        if (!Chan)
             MCAError::Error("mcamon(%d): Invalid handle.", Handle);
        bool OK = true;
        // If a third argument is specified
        if (nrhs > 2)
        {    // If the third argument is a string
            if (mxIsChar(prhs[2]))
            {
                // Create the new monitor callback string
                int buflen = mxGetM(prhs[2]) * mxGetN(prhs[2]) + 1;
                char *CBString = (char *)mxMalloc(buflen);
                mxGetString(prhs[2], CBString, buflen);
                Chan->SetMonitorString(CBString);
                mxFree(CBString);
            }
            else
                MCAError::Error("mcamon(%s): Third argument must be a string.\n",
                                Chan->GetPVName());
        }
        else // Make sure the monitor string is cleared.
            Chan->ClearMonitorString();

        if (! Chan->EventInstalled())
        {   // Subscribe, but only once!
            int status = Chan->AddEvent(monitor_callback);
            if (status == ECA_NORMAL)
                CA->Flush();
            else // AddEvent should already have bailed out by now...
                OK = false;
        }
        plhs[0] = mxCreateDoubleScalar(OK ? 1.0 : 0.0);
        break;
    }

    case 200:    // MCACLEARMON - clears a monitor
    {
        int Handle = (int) mxGetScalar(prhs[1]);
        Channel *Chan = ChannelTable.find(Handle);
        if (!Chan)
            MCAError::Error("mcaclearmon(%d): Invalid handle.", Handle);
        Chan->ClearEvent();
        break;
    }

    case 300:    // MCACACHE - get the cached values of a monitored PV
    {
        for (int i = 0; i < nrhs - 1; i++)
        {
            // Find the channel with the specified handle
            int Handle = (int) mxGetScalar(prhs[i + 1]);
            Channel *Chan = ChannelTable.find(Handle);
            if (!Chan)
                MCAError::Error("mcacache(%d): Invalid handle.", Handle);
    
            const mxArray *Cache = Chan->LockMonitorCache();
            if (Cache)
                plhs[i] = mxDuplicateArray(Cache);
            else
                plhs[i] = mxCreateDoubleMatrix(0, 0, mxREAL);
            Chan->ReleaseMonitorCache();
            Chan->ResetEventCount();
        }
        break;
    }

    case 500:    // MCAMON - get info on installed monitors.
    {
        int i, MonitorsInstalled = 0;

        // Get the total number of defined channels and create an array
        // to hold the handles of those that have installed monitors.
        int HandlesUsed = ChannelTable.size();
        int *HandleArray = (int *) mxCalloc(HandlesUsed, sizeof(int));

        // Iterate through all the defined channels and add their
        // handles into the array if they have monitors defined.
        ChannelHash::Iterator iter(ChannelTable);   
        Channel *Chan = iter.getValue();
        while (Chan)
        {
            if (Chan->EventInstalled())
                HandleArray[MonitorsInstalled++] = Chan->GetHandle();
            Chan = iter.next();
        }
        if (MonitorsInstalled > 0)
        {
            // An array of the handles of channels with installed monitors.
            plhs[0] = mxCreateDoubleMatrix(1, MonitorsInstalled, mxREAL);
            double *handles = mxGetPr(plhs[0]);
            // An array of the monitor strings for each installed monitor.
            plhs[1] = mxCreateCellMatrix(1, MonitorsInstalled);
            for (i = 0; i < MonitorsInstalled; i++)
            {
                Chan = ChannelTable.find(HandleArray[i]);
                if (! Chan)
                    MCAError::Error("Internal error, mcamon cannot find channel for handle %d\n",
                                    HandleArray[i]);    
                handles[i] = (double) HandleArray[i];
                mxSetCell(plhs[1], i, mxCreateString(Chan->GetMonitorString()));
            }
        }
        else
        {
            plhs[0] = mxCreateDoubleMatrix(0, 0, mxREAL);
            plhs[1] = mxCreateCellMatrix(0, 0);
        }
        mxFree (HandleArray);
        break;
    }

    case 510:    // MCAMONEVENTS - Event count for monitors
    {
        int HandlesUsed = ChannelTable.size();
        plhs[0] = mxCreateDoubleMatrix(1, HandlesUsed, mxREAL);
        double *handles = mxGetPr(plhs[0]);
        plhs[1] = mxCreateDoubleMatrix(1, HandlesUsed, mxREAL);
        double *counts = mxGetPr(plhs[1]);

        ChannelHash::Iterator iter(ChannelTable);    
        Channel *Chan = iter.getValue();
        int i = 0;
        while (Chan)
        {
            handles[i] = Chan->GetHandle();
            counts[i] = Chan->GetEventCount();
            ++i;
            Chan = iter.next();
        }
        break;
    }

    // MCAEXEC - Execute the command strings for the channels in
    //             the monitor queue
    case 600:
    {
        if (CA->debugMode())
            mexPrintf("MCAEXEC triggered\n");
        int Handle;
        while ((Handle = MonitorQueue.remove()) != 0)
        {
            // Find the channel.  If it still exists, execute its 
            // command string (if it has one.)
            Channel *Chan = ChannelTable.find(Handle);
            if (Chan)
            {
                const char* MonitorString = Chan->GetMonitorString();
                if (MonitorString)
                    mexEvalString(MonitorString);
            }
            else
                MCAError::Warn("MCAEXEC: internal error, unknown handle %d\n",
                               Handle);
        }
        break;
    }

    case 999:     // MCAEXIT
        mca_cleanup();
        break;

    case 1001:    // Set MCA_SEARCH_TIMEOUT
        CA->SetSearchTimeout(mxGetScalar(prhs[1]));
        break;

    case 1002:    // Set MCA_GET_TIMEOUT
        CA->SetGetTimeout(mxGetScalar(prhs[1]));
        break;

    case 1003:    // Set MCA_PUT_TIMEOUT
        CA->SetPutTimeout(mxGetScalar(prhs[1]));
        break;

    case 1004:    // Set default timeouts
        CA->SetDefaultTimeouts();
        // FALL THROUGH to return the settings
    case 1000:    // Get all Timeout Settings.
    {
        plhs[0] = mxCreateDoubleMatrix(3, 1, mxREAL);
        double *myDblPr = mxGetPr(plhs[0]);
        myDblPr[0] = CA->GetSearchTimeout();
        myDblPr[1] = CA->GetGetTimeout();
        myDblPr[2] = CA->GetPutTimeout();
        break;
    }
    
    case 9999:
    {
        if (CA)
            CA->setDebug(nrhs > 1);
        break;
    }

    default:
        MCAError::Error("Invalid mca code %d", commandswitch);
    }  // switch (command)
}
