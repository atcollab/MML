#ifndef channel_h
#define channel_h

#include <cadef.h>
#include "mex.h"

class ChannelAccess;

class Channel
{
public:
    Channel(const ChannelAccess *CA, const char *Name);

    virtual ~Channel();

    int GetHandle() const
    {   return Handle; }
    
    chid GetChannelID() const
    {   return ChannelID;  }
    
    char* GetPVName() const
    {   return PVName; }

    char* GetHostName() const
    {
        if (HostName)
            return HostName;
        return (const char *) "<unknown>";
    }
    
    int GetState () const
    {   return ChannelID ? ca_state(ChannelID) : cs_never_conn; }
    
    
    int GetNumElements () const
    {   return NumElements; }

    chtype GetRequestType () const
    {   return (RequestType); }
    
    const char* GetRequestTypeStr() const;
    
    /** @returns True if value is numeric, i.e. anything but string.
     *  @see #GetNumericValue()
     *  @see #GetStringValue()
     */
    bool IsNumeric() const;

    /** Issue a 'get' request to CA.
     *  Must be called first to retrieve the value from CA.
     *  Will create Matlab exception on failure, including timeout.
     */
    void GetValueFromCA();

   /** Read the enum string for this PV from CA.
     *  Returns a string array, empty array when no enums are defined.
     *  Will create Matlab exception on failure, including timeout.
     */
    void GetEnumStringsFromCA();

    /* @return Most recent time stamp. */    
    epicsTimeStamp GetTimeStamp() const
    {   return TimeStamp; }
    
    /* @return Most recent alarm status. */    
    dbr_short_t GetAlarmStatus() const
    {   return AlarmStatus; }
    
    /* @return Most recent alarm severity. */    
    dbr_short_t GetAlarmSeverity() const
    {   return AlarmSeverity; }

    /** Get numeric value.
     *  Use only if isNumeric return true.
     */    
    double GetNumericValue( int ) const;
    
    /** Get string value.
     *  Use only if isNumeric return false.
     */    
    const char* GetStringValue ( int ) const;
    
    void SetNumericValue( int, double );

    void SetStringValue ( int, char* );
    
    /** Issue CA put callback, wait for result within timeout.
     *  @return -1.0 on timeout, 0.0 on error, 1.0 if OK.
     */ 
    double PutValueToCACallback (int Size);
    
    /** Simply send current value to CA, no callback.
     *  @return true when OK.
     */
    bool PutValueToCA ( int ) const;

    /** Set the Matlab command to invoke on incoming monitors. */
    void SetMonitorString(const char *MonString);

    /** Clear the Matlab command to invoke on incoming monitors. */
    void ClearMonitorString();
    
    bool MonitorStringInstalled() const
    {   return MonitorCBString != 0;  }

    const char *GetMonitorString() const
    {   return MonitorCBString; }

    void LoadMonitorCache( struct event_handler_args arg );
    
    int AddEvent(caEventCallBackFunc *MonitorEventHandler);
    
    bool EventInstalled() const
    {  return EventID != 0; }

    
    void ClearEvent();

    
    int GetEventCount() const
    {  return EventCount; }

    void IncrementEventCount()
    {  EventCount++; }

    void ResetEventCount()
    {  EventCount = 0; }

    /** Lock and obtain the cache for monitored values.
     *  @see #ReleaseMonitorCache()
     */
    const mxArray *LockMonitorCache()
    {   
        cache_lock.lock();
        return Cache;
    }

    void ReleaseMonitorCache()
    {   cache_lock.unlock();  }

    int GetNumEnumStrings () const
    {   return EnumStrings.no_str; }

    const char *GetEnumString(int) const;

    const char* GetEngineeringUnits();

    double GetPrecision();
private:
    Channel(); // don't use
    
    void AllocChanMem();
    
    static int NextHandle;

    const ChannelAccess* CA;
    int Handle;                 // MCA channel handle.
    char* PVName;               // The name of the Process Variable
    chid ChannelID;                // CA channel identifier.
    evid EventID;                // CA evnet identifier.  If a channel is not
                                // monitored then EventID == NULL.
    char* MonitorCBString;        // Pointer to the MCA callback string for monitor
    char* HostName;                // The name of the host name where the PV connected
    char * egu;                    //engineering units
    union db_access_val* DataBuffer;
    epicsTimeStamp TimeStamp;    // The time stamp of the most recent data
    dbr_short_t    AlarmStatus;    // The alarm status of the most recent data
    dbr_short_t    AlarmSeverity;    // The alarm severity of the most recent data
    //struct
    dbr_gr_enum EnumStrings;  //enum strings for ENUM type PVs
    int NumElements;
    chtype RequestType;

    // used for put-callback
    static void put_callback(struct event_handler_args arg);
    epicsEvent put_completed;
    bool awaiting_put_callback;
    bool last_put_ok;

    epicsMutex cache_lock;
    mxArray* Cache;
    
    int EventCount;
};

#endif // channel_h
