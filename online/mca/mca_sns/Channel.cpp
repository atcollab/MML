
#include <string.h>
#include "MCAError.h"
#include "Channel.h"
#include "ChannelAccess.h"
#include "db_access.h"

int Channel::NextHandle = 1;

static char *mxStrDup(const char *s)
{
    size_t len = strlen(s)+1;
    char *copy = (char *) mxCalloc(1, len);
    memcpy(copy, s, len);
    mexMakeMemoryPersistent(copy);
    return copy;
}

Channel::Channel(const ChannelAccess *CA, const char *Name)
    : CA(CA),
      Handle(NextHandle++),
      PVName(mxStrDup(Name)),
      ChannelID(0),
      EventID(0),
      MonitorCBString(0),
      HostName(0),
      egu(0),
      DataBuffer(0),
      AlarmStatus(0),
      AlarmSeverity(0),
      NumElements(0),
      RequestType(0),
      awaiting_put_callback(false),
      last_put_ok(false),
      Cache(0)
{
    ResetEventCount();
    
    int status = ca_create_channel(Name, 0, 0, 0, &ChannelID);
    if (status != ECA_NORMAL)
    {
        MCAError::Error("ca_create_channel: %s\n", ca_message(status));
        ChannelID = 0;
        return;
    }
    status = CA->WaitForSearch();
    if (status != ECA_NORMAL)
    {
        MCAError::Warn("WaitForSearch: %s\n", ca_message(status));
        ca_clear_channel(ChannelID);
        ChannelID = 0;
        Handle = 0;
        return;
    }

    // Obtain the name of the Host where the PV is sourced from.
    HostName = mxStrDup(ca_host_name(ChannelID));

    // Allocate memory for some of the Channel's data structures.
    AllocChanMem();
    if (CA->debugMode())
        mexPrintf("Channel '%s' created, handle %d\n", PVName, Handle);
}

Channel::~Channel()
{
    // Disconnect
    if (ChannelID)
    {
        int status = ca_clear_channel(ChannelID);
        ChannelID = 0;
        if (status != ECA_NORMAL)
            MCAError::Error("ca_clear_channel: %s\n", ca_message(status));
    }
    if (CA->debugMode())
        mexPrintf("Channel '%s' disposed, Handle %d\n", PVName, Handle);

    mxFree(PVName);    
    PVName = 0;

    if (HostName)
    {
        mxFree(HostName);
        HostName = 0;
    }    

    if (DataBuffer)
    {
        mxFree(DataBuffer);
        DataBuffer = 0;
    }

    if (egu)
    {
        mxFree(egu);
        egu=0;
    }
    cache_lock.lock();
    if (Cache)
    {
        mxDestroyArray(Cache);
        Cache = 0;
    }
    cache_lock.unlock();
}

void Channel::AllocChanMem()
{
    // Allocate space for the data on this channel
    NumElements = ca_element_count(ChannelID);
    RequestType = dbf_type_to_DBR_TIME(ca_field_type(ChannelID));

    // Allocate enough space for the data buffer.
    if (DataBuffer)
        mxFree(DataBuffer);

    DataBuffer = (union db_access_val *) mxCalloc(1, dbr_size_n(RequestType, NumElements));
    mexMakeMemoryPersistent(DataBuffer);

    // Allocate the space for the monitor cache.
    cache_lock.lock();
    if (Cache)
        mxDestroyArray(Cache);
    if (RequestType == DBR_TIME_STRING)
    {    // Create MATLAB String - originally empty
        if (NumElements == 1)
            Cache = mxCreateString("");
        else
        {
            Cache = mxCreateCellMatrix(1, NumElements);
            for (int i = 0; i < NumElements; i++)
            {
                mxArray* mymxArray = mxCreateString("");
                //mexMakeArrayPersistent(mymxArray);
                mxSetCell(Cache, i, mymxArray);
            }
        }
    }
    else
    {    // Create a MATLAB numeric array
        Cache = mxCreateDoubleMatrix(1, NumElements, mxREAL);
    }
    mexMakeArrayPersistent(Cache);
    cache_lock.unlock();
}

bool Channel::IsNumeric() const
{
    switch (RequestType)
    {
    case DBR_TIME_STRING:
        return false;
    case DBR_TIME_CHAR:
    case DBR_TIME_INT:
    case DBR_TIME_FLOAT:
    case DBR_TIME_ENUM:
    case DBR_TIME_LONG:
    case DBR_TIME_DOUBLE:
        return true;
    default:
        MCAError::Error("IsNumeric(%s): Unimplemented Request Type %d in GetRequestTypeStr().",
                        PVName, (int) RequestType);
    }
    return false;
}

const char* Channel::GetRequestTypeStr()  const
{
    const char* ReqString;

    switch (RequestType) {
    case DBR_TIME_STRING:
        ReqString = "STRING";
        break;
    case DBR_TIME_INT:
        ReqString = "INT";
        break;
    case DBR_TIME_FLOAT:
        ReqString = "FLOAT";
        break;
    case DBR_TIME_ENUM:
        ReqString = "ENUM";
        break;
    case DBR_TIME_CHAR:
        ReqString = "CHAR";
        break;
    case DBR_TIME_LONG:
        ReqString = "LONG";
        break;
    case DBR_TIME_DOUBLE:
        ReqString = "DOUBLE";
        break;
    default:
        ReqString = "UNKNOWN";
        break;        
    }

    return ReqString;
}

void Channel::GetValueFromCA()
{
    int status;

    status = ca_array_get(RequestType, NumElements, ChannelID, DataBuffer);
    if (status != ECA_NORMAL)
        MCAError::Error("ca_array_get: %s\n", ca_message(status));

    status = CA->WaitForGet();
    if (status != ECA_NORMAL)
        MCAError::Error("GetValueFromCA: %s\n", ca_message(status));

    switch (RequestType)
    {
    case DBR_TIME_INT:
        TimeStamp = ((struct dbr_time_short *) DataBuffer)->stamp;
        AlarmStatus = ((struct dbr_time_short *) DataBuffer)->status;
        AlarmSeverity = ((struct dbr_time_short *) DataBuffer)->severity;
        break;
    case DBR_TIME_FLOAT:
        TimeStamp = ((struct dbr_time_float *) DataBuffer)->stamp;
        AlarmStatus = ((struct dbr_time_float *) DataBuffer)->status;
        AlarmSeverity = ((struct dbr_time_float *) DataBuffer)->severity;
        break;
    case DBR_TIME_ENUM:
        TimeStamp = ((struct dbr_time_enum *) DataBuffer)->stamp;
        AlarmStatus = ((struct dbr_time_enum *) DataBuffer)->status;
        AlarmSeverity = ((struct dbr_time_enum *) DataBuffer)->severity;
        break;
    case DBR_TIME_CHAR:
        TimeStamp = ((struct dbr_time_char *) DataBuffer)->stamp;
        AlarmStatus = ((struct dbr_time_char *) DataBuffer)->status;
        AlarmSeverity = ((struct dbr_time_char *) DataBuffer)->severity;
        break;
    case DBR_TIME_LONG:
        TimeStamp = ((struct dbr_time_long *) DataBuffer)->stamp;
        AlarmStatus = ((struct dbr_time_long *) DataBuffer)->status;
        AlarmSeverity = ((struct dbr_time_long *) DataBuffer)->severity;
        break;
    case DBR_TIME_DOUBLE:
        TimeStamp = ((struct dbr_time_double *) DataBuffer)->stamp;
        AlarmStatus = ((struct dbr_time_double *) DataBuffer)->status;
        AlarmSeverity = ((struct dbr_time_double *) DataBuffer)->severity;
        break;
    case DBR_TIME_STRING:
        TimeStamp = ((struct dbr_time_string *) DataBuffer)->stamp;
        AlarmStatus = ((struct dbr_time_string *) DataBuffer)->status;
        AlarmSeverity = ((struct dbr_time_string *) DataBuffer)->severity;
        break;
    default:
        MCAError::Error("GetValueFromCA(%s): Unimplemented Request Type %d\n",
                        PVName, (int)RequestType);
    }
}

double Channel::GetNumericValue(int Index) const
{
    switch (RequestType)
    {
    case DBR_TIME_INT:
        return (double) (*(&(DataBuffer->tshrtval.value) + Index));
        break;
    case DBR_TIME_FLOAT:
        return (double) (*(&(DataBuffer->tfltval.value) + Index));
        break;
    case DBR_TIME_ENUM:
        return (double) (*(&(DataBuffer->tenmval.value) + Index));
        break;
    case DBR_TIME_CHAR:
        return (double) (*(&(DataBuffer->tchrval.value) + Index));
        break;
    case DBR_TIME_LONG:
        return (double) (*(&(DataBuffer->tlngval.value) + Index));
        break;
    case DBR_TIME_DOUBLE:
        return (double) (*(&(DataBuffer->tdblval.value) + Index));
        break;
    case DBR_TIME_STRING:
        MCAError::Error("GetNumericValue(%s) cannot handle string data.",
                        PVName);
    default:
        MCAError::Error("GetNumericValue(%s) cannot handle type %d.",
                        PVName, (int) RequestType);
    }
    return 0.0;
}

const char* Channel::GetStringValue ( int Index ) const
{
    switch (RequestType)
    {
    case DBR_TIME_STRING:
        return (char *)(&(DataBuffer->tstrval.value) + Index);
        break;
    default:
        MCAError::Error("GetStringValue(%s) cannot decode type %d.",
                        PVName, (int) RequestType);
    }
    return "";
}

void Channel::SetNumericValue(int Index, double Value)
{
    chtype Type = dbf_type_to_DBR(ca_field_type(ChannelID));;
    switch (Type)
    {
    case DBR_INT:
        *((dbr_short_t *) (DataBuffer) + Index) = (dbr_short_t) (Value);
        break;
    case DBR_FLOAT:
        *((dbr_float_t *) (DataBuffer) + Index) = (dbr_float_t) (Value);
        break;
    case DBR_ENUM:
        *((dbr_enum_t *) (DataBuffer) + Index) = (dbr_enum_t) (Value);
        break;
    case DBR_CHAR:
        *((dbr_char_t *) (DataBuffer) + Index) = (dbr_char_t) (Value);
        break;
    case DBR_LONG:
        *((dbr_long_t *) (DataBuffer) + Index) = (dbr_long_t) (Value);
        break;
    case DBR_DOUBLE:
        *((dbr_double_t *) (DataBuffer) + Index) = (dbr_double_t) (Value);
        break;
    case DBR_STRING:
        MCAError::Error("SetNumericValue(%s) cannot take a String value for raw type %d.",
                        PVName, (int)Type);
    }
}

void Channel::SetStringValue (int Index, char* StrBuffer)
{

    chtype Type = dbf_type_to_DBR(ca_field_type(ChannelID));;

    switch (Type)
    {
    case DBR_STRING:
        strcpy((char *)(*((dbr_string_t *)(DataBuffer) + Index)), StrBuffer);
        break;
    default:
        MCAError::Error("SetStringValue(%s) must take a String value.",
                        PVName);
    }
}

// Invoked by CAC library when 'put' is done.
//
// In principle, there needs to be another mutex for the awaiting_put_callback
// and last_put_ok handshake variables...
void Channel::put_callback(struct event_handler_args arg)
{
    Channel *me = (Channel *) arg.usr;
    if (! me->awaiting_put_callback)
    {   // That ship has sailed...
        if (me->CA->debugMode())
            mexPrintf("put_callback(%s): in thread %d arrived too late\n",
                      me->PVName, (unsigned long) epicsThreadGetIdSelf());
        return;
    }
    me->last_put_ok = (arg.status == ECA_NORMAL);
    if (me->CA->debugMode())
        mexPrintf("put_callback(%s): %s in thread %d...\n",
                  me->PVName, (me->last_put_ok ? "OK" : "Error"),
                  (unsigned long) epicsThreadGetIdSelf());
    
    // Wake waiting PutValueToCACallback()
    me->put_completed.signal();
}

double Channel::PutValueToCACallback (int Size)
{
    int status;
    // Reset status, clear the signal
    put_completed.tryWait();
    last_put_ok = false;

    if (CA->debugMode())
        mexPrintf("PutValueToCACallback(%s), handle %d, thread %lu...\n",
                  PVName, Handle, (unsigned long) epicsThreadGetIdSelf());
    chtype Type = dbf_type_to_DBR(ca_field_type(ChannelID));
    awaiting_put_callback = true;
    status = ca_array_put_callback(Type, Size, ChannelID, DataBuffer,
                                   put_callback, this);
    if (status != ECA_NORMAL)
    {
        MCAError::Error("ca_array_put_callback(%s): %s\n",
                        PVName, ca_message(status));
        // We actually won't get here...
        return 0.0;
    }
    CA->Flush();
    // Wait for response ...
    bool got_response = put_completed.wait(CA->GetPutTimeout());
    awaiting_put_callback = false;
    if (! got_response)
        return -1.0; // timeout
    if (last_put_ok)
        return 1.0;  // OK
    return 0.0;      // Error
}

bool Channel::PutValueToCA (int Size) const 
{
    chtype Type = dbf_type_to_DBR(ca_field_type(ChannelID));;
    int status = ca_array_put(Type, Size, ChannelID, DataBuffer);
    if (status != ECA_NORMAL)
        return false;
    CA->Flush();
    return true;
}

void Channel::SetMonitorString(const char* MonString)
{
    // If it exists, remove the monitor string.
    ClearMonitorString();
    MonitorCBString = mxStrDup(MonString);
}

void Channel::ClearMonitorString() 
{
    // If it exists, remove the monitor string.
    if (MonitorCBString)
    {
        mxFree(MonitorCBString);
        MonitorCBString = NULL;
    }
}

/** Pull the received data out of a monitor callback. */
void Channel::LoadMonitorCache( struct event_handler_args arg )
{
    // This is called from the monitor callback thread.
    // The Cache is guarded with a lock.
    // TODO: The timestamps/status/severity should probably also get locked.
    // Same for the event counters....
    union db_access_val *pBuf = (union db_access_val *) arg.dbr;
    int i;

    int Cnt = ca_element_count(ChannelID);
    if (Cnt > NumElements  ||  arg.type != RequestType)
        AllocChanMem();

    // The initial status/severity/stamp of the DBR_TIME_xxx is the same.
    TimeStamp = ((struct dbr_time_short *) pBuf)->stamp;
    AlarmStatus = ((struct dbr_time_short *) pBuf)->status;
    AlarmSeverity = ((struct dbr_time_short *) pBuf)->severity;
    // Decode the value, which differs for each DBR_TIME_xxx.
    cache_lock.lock();
    if (RequestType == DBR_TIME_STRING)
    {
        if (NumElements == 1)
        {
            mxDestroyArray(Cache);
            Cache = mxCreateString((char *)((pBuf)->tstrval.value));
            mexMakeArrayPersistent(Cache);
        }
        else
        {
            for (i = 0; i < NumElements; i++)
            {
                mxArray *mymxArray = mxGetCell(Cache, i);
                mxDestroyArray(mymxArray);
                mymxArray = mxCreateString((char *) (&(pBuf->tstrval.value) + i));
                //mexMakeArrayPersistent(mymxArray);
                mxSetCell(Cache, i, mymxArray);
            }
        }
    }
    else
    {   // Received numeric data
        double *myDblPr = mxGetPr(Cache);
        switch (RequestType)
        {
        case DBR_TIME_INT:
            for (i = 0; i < NumElements; i++)
                myDblPr[i] = (double) (*(&((pBuf)->tshrtval.value) + i));
            break;
        case DBR_TIME_FLOAT:
            for (i = 0; i < NumElements; i++)
                myDblPr[i] = (double) (*(&((pBuf)->tfltval.value) + i));
            break;
        case DBR_TIME_ENUM:
            for (i = 0; i < NumElements; i++)
                myDblPr[i] = (double) (*(&((pBuf)->tenmval.value) + i));
            break;
        case DBR_TIME_CHAR:
            for (i = 0; i < NumElements; i++)
                myDblPr[i] = (double) (*(&((pBuf)->tchrval.value) + i));
            break;
        case DBR_TIME_LONG:
            for (i = 0; i < NumElements; i++)
                myDblPr[i] = (double) (*(&((pBuf)->tlngval.value) + i));
            break;
        case DBR_TIME_DOUBLE:
            for (i = 0; i < NumElements; i++)
                myDblPr[i] = (double) (*(&((pBuf)->tdblval.value) + i));
            break;
        default:
            MCAError::Warn("LoadMonitorCache(%s): Unknown type %d\n",
                           PVName, (int) RequestType);
            break;
        }
    }    
    cache_lock.unlock();
}

int Channel::AddEvent(caEventCallBackFunc *MonitorEventHandler)
{
    int status = ca_add_array_event(RequestType, ca_element_count(ChannelID),
                                    ChannelID,
                                    MonitorEventHandler, this,
                                    0.0, 0.0, 0.0, &EventID);
    if (status != ECA_NORMAL)
        MCAError::Error("ca_add_array_event(%s): %s\n",
                        PVName, ca_message(status));
    return status;
}

void Channel::ClearEvent()
{
    if (!EventID)
        return;
    int status = ca_clear_event(EventID);
    EventID = 0;
    if (status != ECA_NORMAL)
        MCAError::Warn("ca_clear_event(%s) failed: %s\n",
                       PVName, ca_message(status));
    ClearMonitorString();
}
void Channel::GetEnumStringsFromCA()
{
    int status;
    status =ca_get (DBR_GR_ENUM, ChannelID, &EnumStrings);

    if (status != ECA_NORMAL)
        MCAError::Error("ca_get: %s\n", ca_message(status));

    status = CA->WaitForGet();
    if (status != ECA_NORMAL)
        MCAError::Error("GetEnumStringsFromCA: %s\n", ca_message(status));

}

const char* Channel::GetEnumString(int index) const
    {   if (index < EnumStrings.no_str)
           return EnumStrings.strs[index];
         else
                return NULL; }

const char* Channel::GetEngineeringUnits()
{
    int status;
    dbr_gr_float gf;
    if (RequestType !=DBR_TIME_STRING)
    {
      status =ca_get (DBR_GR_FLOAT, ChannelID, &gf);

      if (status != ECA_NORMAL)
          MCAError::Error("ca_get: %s\n", ca_message(status));

      status = CA->WaitForGet();
      if (status != ECA_NORMAL)
          MCAError::Error("GetEngineeringUnits: %s\n", ca_message(status));
      if (egu) /* release memory if egu was already set */
     {
        mxFree(egu);
        egu = NULL;
     }
     egu=mxStrDup(gf.units);

      return egu;
     } else 
        return NULL;

}
double Channel::GetPrecision()
{
    int status;
    dbr_gr_float gf;
    if (RequestType !=DBR_TIME_STRING)
    {
    status =ca_get (DBR_GR_FLOAT, ChannelID, &gf);

    if (status != ECA_NORMAL)
        MCAError::Error("ca_get: %s\n", ca_message(status));

    status = CA->WaitForGet();
    if (status != ECA_NORMAL)
        MCAError::Error("GetPrecision: %s\n", ca_message(status));
    return gf.precision;
    } else
    {
        return 0;
    }


}
