#ifndef channel_h
#define channel_h

#include <cadef.h>
#include "mex.h"

class ChannelAccess;

class Channel {

public:

	// Constructors
	Channel( void );
	Channel( const ChannelAccess* );

	// Destructor
	virtual ~Channel( void );

	int Connect( char* );
	void AllocChanMem( void );
	bool IsConnected( void ) const;
	void Disconnect( void );

	int GetHandle( void ) const;
	chid GetChannelID( void ) const;
	char* GetPVName( void ) const;
	char* GetHostName( void ) const;
	int GetState ( void ) const;
	int GetNumElements ( void ) const;
	chtype GetRequestType( void ) const;
	const char* GetRequestTypeStr( void ) const;
	bool IsNumeric( void ) const;

	// These methods must be used in combination:
	//
	// 1) GetValueFromCA - must be called first to retrieve the value from CA
	// 2) GetNumericValue - use if IsNumeric() returns True
	// 3) GetStringValue - use if IsNumeric() returns False
	// 4) GetTimeStamp - returns the Epics time stamp of value obtained from CA
	//
	void GetValueFromCA( void );
	double GetNumericValue( int ) const;
	const char* GetStringValue ( int ) const;
	epicsTimeStamp GetTimeStamp( void ) const;
	dbr_short_t	GetAlarmStatus( void ) const;
	dbr_short_t	GetAlarmSeverity( void ) const;

	// These methods must be used in combination:
	//
	// 1) SetNumericValue - must be called first if IsNumeric() returns True
	// 2) SetStringValue - must be called first if IsNumeric() returns False
	// 3) PutValueToCA - must be called next to send the value to CA
	// 4) SetLastPutStatus - must be called in PutValueToCA callback
	// 5) GetLastPutStatus - must be called last to determine if the Put succeeded
	//
	void SetNumericValue( int, double );
	void SetStringValue ( int, char* );
	void PutValueToCACallback ( int, caEventCallBackFunc * );
	double PutValueToCA ( int ) const;
	void SetLastPutStatus ( double );
	double GetLastPutStatus( void ) const;

	void SetMonitorString( const char*, int );
	bool MonitorStringInstalled( void ) const;
	const char* GetMonitorString( void ) const;
	void ClearMonitorString( void );
	void LoadMonitorCache( struct event_handler_args arg );
	int AddEvent( caEventCallBackFunc * );
	bool EventInstalled( void ) const;
	void ClearEvent( void );

	int GetEventCount( void ) const;
	void IncrementEventCount( void );
	void ResetEventCount( void );

	const mxArray *GetMonitorCache( void ) const;

private:

	int Handle;					// MCA channel handle.
	chid ChannelID;				// CA channel identifier.
	evid EventID;				// CA evnet identifier.  If a channel is not
								// monitored then EventID == NULL.
	char* MonitorCBString;		// Pointer to the MCA callback string for monitor
	char* PVName;				// The name of the Process Variable
	char* HostName;				// The name of the host name where the PV connected
	epicsTimeStamp TimeStamp;	// The time stamp of the most recent data
	dbr_short_t	AlarmStatus;	// The alarm status of the most recent data
	dbr_short_t	AlarmSeverity;	// The alarm severity of the most recent data

	bool Connected;
	int NumElements;
	chtype RequestType;

	double LastPutStatus;

	union db_access_val* DataBuffer;
	mxArray* Cache;
	int EventCount;

	static int NextHandle;
	const ChannelAccess* CA;

};

#endif // channel_h
