
#include <string.h>
#include "MCAError.h"
#include "Channel.h"
#include "ChannelAccess.h"
#include "db_access.h"

int Channel::NextHandle = 1;
 
Channel::Channel( void ) {
	Handle = 0;
	Connected = false;
}

Channel::Channel( const ChannelAccess* ChanAcc ) {

	Handle = 0;
	Connected = false;
	CA = ChanAcc;
	EventID = 0;
	MonitorCBString = NULL;
	DataBuffer = NULL;
	Cache = NULL;
	LastPutStatus = 0;
	AlarmStatus = 0;
	AlarmSeverity = 0;

	ResetEventCount();

}

Channel::~Channel( void ) {
	
	MCAError Err;
	int status;

	if (Connected) {
		status = ca_clear_channel(ChannelID);
		if (status != ECA_NORMAL)
			Err.Message(MCAError::MCAERR, ca_message(status));
	}
	
	ChannelID = NULL;

	if (PVName)
		mxFree(PVName);	

	if (HostName)
		mxFree(HostName);	

	if (DataBuffer)
		mxFree(DataBuffer);

	if (Cache)
		mxDestroyArray(Cache);

}

void Channel::AllocChanMem( void ) {

	// Allocate space for the data on this channel
	//
	NumElements = ca_element_count(ChannelID);
	RequestType = dbf_type_to_DBR_TIME(ca_field_type(ChannelID));

	// Allocate enough space for the data buffer.
	//
	if (DataBuffer)
		mxFree(DataBuffer);

	DataBuffer = (union db_access_val *) mxCalloc(1, dbr_size_n(RequestType, NumElements));
	mexMakeMemoryPersistent(DataBuffer);

	// Allocate the space for the monitor cache.
	//
	if (Cache)
		mxDestroyArray(Cache);

	if (RequestType == DBR_TIME_STRING) {
				
		// Create MATLAB String - originally empty
		//
		if (NumElements == 1)
			Cache = mxCreateString("");
		else {
			Cache = mxCreateCellMatrix(1, NumElements);
			for (int i = 0; i < NumElements; i++) {
				mxArray* mymxArray = mxCreateString("");
				//mexMakeArrayPersistent(mymxArray);
				mxSetCell(Cache, i, mymxArray);
			}
		}
	}
	else {

		// Create a MATLAB numeric array
		//
		Cache = mxCreateDoubleMatrix(1, NumElements, mxREAL);
	}
	mexMakeArrayPersistent(Cache);

}

int Channel::Connect(char* Name) {

	chid Chid;
	MCAError Err;

	int status = ca_create_channel(Name, 0, 0, 0, &Chid);
	if (status == ECA_NORMAL) {
		status = CA->WaitForSearch();
		if (status != ECA_NORMAL) {
			ca_clear_channel(Chid);
			Handle = 0;
		}
		else
		{

			// Channel is now successfully connected.
			//
			Connected = true;

			// Allocate the next handle to this channel.
			//
			Handle = NextHandle;
			NextHandle += 1;

			// Save the Channel ID
			//
			ChannelID = Chid;

			// Record the channel's Process Variable Name.
			//
			PVName = (char *) mxCalloc(1, strlen(Name)+1);
			strcpy(PVName,Name);
			mexMakeMemoryPersistent(PVName);

			// Obtain the name of the Host where the PV is sourced from.
			//
			const char* HName = ca_host_name(Chid);
			HostName = (char *) mxCalloc(1, strlen(HName)+1);
			strcpy(HostName,HName);
			mexMakeMemoryPersistent(HostName);

			// Allocate memory for some of the Channel's data structures.
			//
			AllocChanMem();
	
		}
	}

	return Handle;
}

bool Channel::IsConnected( void ) const {
	return (Connected);
}

void Channel::Disconnect( void ) {

	int status;
	MCAError Err;

	if (Connected) {
		status = ca_clear_channel(ChannelID);
		if (status != ECA_NORMAL)
			Err.Message(MCAError::MCAERR, ca_message(status));
	}
	Connected = false;
}

char* Channel::GetPVName( void ) const {
	return (PVName);
}

int Channel::GetHandle( void ) const {
	return (Handle);
}

int Channel::GetState ( void ) const {
	return (ca_state(ChannelID));
}

int Channel::GetNumElements ( void ) const {
	return (NumElements);
}

chtype Channel::GetRequestType ( void ) const {
	return (RequestType);
}

bool Channel::IsNumeric( void ) const {

	MCAError Err;

	bool Result;

	switch (RequestType) {
	case DBR_TIME_STRING:
		Result = false;
		break;
	case DBR_TIME_CHAR:
	case DBR_TIME_INT:
	case DBR_TIME_FLOAT:
	case DBR_TIME_ENUM:
	case DBR_TIME_LONG:
	case DBR_TIME_DOUBLE:
		Result = true;
		break;
	default:
		Err.Message(MCAError::MCAERR, "Unimplemented Request Type in GetRequestTypeStr().");
	}

	return Result;
}

chid Channel::GetChannelID( void ) const {
	return (ChannelID);
}

const char* Channel::GetRequestTypeStr( void )  const {

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

void Channel::GetValueFromCA( void ) {

	int status;
	MCAError Err;

	status = ca_array_get(RequestType, NumElements, ChannelID, DataBuffer);
	if (status != ECA_NORMAL)
		Err.Message(MCAError::MCAERR, ca_message(status));

	status = CA->WaitForGet();
	if (status != ECA_NORMAL)
		Err.Message(MCAError::MCAERR, ca_message(status));

	switch (RequestType) {
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
		Err.Message(MCAError::MCAERR, "Unimplemented Request Type in GetValueFromCA().");
	}

}

double Channel::GetNumericValue( int Index ) const {

	double Val;
	MCAError Err;

	switch (RequestType) {
	case DBR_TIME_INT:
		Val = (double) (*(&(DataBuffer->tshrtval.value) + Index));
		break;
	case DBR_TIME_FLOAT:
		Val = (double) (*(&(DataBuffer->tfltval.value) + Index));
		break;
	case DBR_TIME_ENUM:
		Val = (double) (*(&(DataBuffer->tenmval.value) + Index));
		break;
	case DBR_TIME_CHAR:
		Val = (double) (*(&(DataBuffer->tchrval.value) + Index));
		break;
	case DBR_TIME_LONG:
		Val = (double) (*(&(DataBuffer->tlngval.value) + Index));
		break;
	case DBR_TIME_DOUBLE:
		Val = (double) (*(&(DataBuffer->tdblval.value) + Index));
		break;
	case DBR_TIME_STRING:
		Err.Message(MCAError::MCAERR, "GetNumericValue() cannot return a string value.");
	}
	return Val;

}

const char* Channel::GetStringValue ( int Index ) const {

	char *Str;
	MCAError Err;

	switch (RequestType) {
	case DBR_TIME_STRING:
		Str = (char *)(&(DataBuffer->tstrval.value) + Index);
		break;
	default:
		Err.Message(MCAError::MCAERR, "GetStringValue() cannot return a numeric value.");
	}
	return Str;

}

epicsTimeStamp Channel::GetTimeStamp( void ) const {
	return TimeStamp;
}

dbr_short_t Channel::GetAlarmStatus( void ) const {
	return AlarmStatus;
}

dbr_short_t Channel::GetAlarmSeverity( void ) const {
	return AlarmSeverity;
}

void Channel::SetNumericValue( int Index, double Value ) {

	MCAError Err;

	chtype Type = dbf_type_to_DBR(ca_field_type(ChannelID));;
	switch (Type) {
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
		Err.Message(MCAError::MCAERR, "SetNumericValue() cannot take a String value.");
	}

}

void Channel::SetStringValue ( int Index, char* StrBuffer) {

	MCAError Err;

	chtype Type = dbf_type_to_DBR(ca_field_type(ChannelID));;

	switch (Type) {
	case DBR_STRING:
		strcpy((char *)(*((dbr_string_t *)(DataBuffer) + Index)), StrBuffer);
		break;
	default:
		Err.Message(MCAError::MCAERR, "SetStringValue() must take a String value.");
	}

}

void Channel::PutValueToCACallback ( int Size, caEventCallBackFunc *PutEventHandler ) {

	int status;
	MCAError Err;

	chtype Type = dbf_type_to_DBR(ca_field_type(ChannelID));;
	status = ca_array_put_callback(Type, Size, ChannelID, DataBuffer, PutEventHandler, this);
	if (status != ECA_NORMAL) {
		Err.Message(MCAError::MCAINFO, "ca_array_put_callback failed");
		LastPutStatus = 0;
	}

	status = CA->WaitForPut();

	return;
}

double Channel::PutValueToCA ( int Size ) const {

	int status;
	double RetVal;
	MCAError Err;

	chtype Type = dbf_type_to_DBR(ca_field_type(ChannelID));;
	status = ca_array_put(Type, Size, ChannelID, DataBuffer);
	if (status != ECA_NORMAL)
		RetVal = 0;
	else
		RetVal = 1;

	status = CA->WaitForPutIO();

	return (RetVal);
}

void Channel::SetLastPutStatus( double Status ) {
	LastPutStatus = Status;
}

double Channel::GetLastPutStatus( void ) const {
	return (LastPutStatus);
}

void Channel::SetMonitorString(const char* MonString, int buflen) {

	// If it exists, remove the monitor string.
	//
	if (MonitorCBString) {
		mxFree(MonitorCBString);
		MonitorCBString = NULL;
	}

	// Allocate space for the new monitor string.
	//
	MonitorCBString = (char*) mxMalloc(buflen);
	mexMakeMemoryPersistent(MonitorCBString);
	strcpy(MonitorCBString, MonString);

}

void Channel::LoadMonitorCache( struct event_handler_args arg ) {

	// Pointer to the data associated with the channel.
	//
	union db_access_val *pBuf = (union db_access_val *) arg.dbr;

	int i;
	double *myDblPr;
	mxArray *mymxArray;

	int Cnt = ca_element_count(ChannelID);
	if (Cnt > NumElements)
		AllocChanMem();

	if (arg.type != RequestType)
		AllocChanMem();

	if(RequestType == DBR_TIME_STRING) {
	
		TimeStamp = ((struct dbr_time_string *) pBuf)->stamp;
		if (NumElements == 1) {

			mxDestroyArray(Cache);
			Cache = mxCreateString((char *)((pBuf)->tstrval.value));
			mexMakeArrayPersistent(Cache);

		}
		else {

			for (i = 0; i < NumElements; i++) {

				mymxArray = mxGetCell(Cache, i);
				mxDestroyArray(mymxArray);
				mymxArray = mxCreateString((char *) (&(pBuf->tstrval.value) + i));
				//mexMakeArrayPersistent(mymxArray);
				mxSetCell(Cache, i, mymxArray);

			}
		}
	}
	else {
	
		myDblPr = mxGetPr(Cache);

		switch (RequestType) {
		case DBR_TIME_INT:
			TimeStamp = ((struct dbr_time_short *) pBuf)->stamp;
			AlarmStatus = ((struct dbr_time_short *) pBuf)->status;
			AlarmSeverity = ((struct dbr_time_short *) pBuf)->severity;
			for (i = 0; i < NumElements; i++)
				myDblPr[i] = (double) (*(&((pBuf)->tshrtval.value) + i));
			break;
		case DBR_TIME_FLOAT:
			TimeStamp = ((struct dbr_time_float *) pBuf)->stamp;
			AlarmStatus = ((struct dbr_time_float *) pBuf)->status;
			AlarmSeverity = ((struct dbr_time_float *) pBuf)->severity;
			for (i = 0; i < NumElements; i++)
				myDblPr[i] = (double) (*(&((pBuf)->tfltval.value) + i));
			break;
		case DBR_TIME_ENUM:
			TimeStamp = ((struct dbr_time_enum *) pBuf)->stamp;
			AlarmStatus = ((struct dbr_time_enum *) pBuf)->status;
			AlarmSeverity = ((struct dbr_time_enum *) pBuf)->severity;
			for (i = 0; i < NumElements; i++)
				myDblPr[i] = (double) (*(&((pBuf)->tenmval.value) + i));
			break;
		case DBR_TIME_CHAR:
			TimeStamp = ((struct dbr_time_char *) pBuf)->stamp;
			AlarmStatus = ((struct dbr_time_char *) pBuf)->status;
			AlarmSeverity = ((struct dbr_time_char *) pBuf)->severity;
			for (i = 0; i < NumElements; i++)
				myDblPr[i] = (double) (*(&((pBuf)->tchrval.value) + i));
			break;
		case DBR_TIME_LONG:
			TimeStamp = ((struct dbr_time_long *) pBuf)->stamp;
			AlarmStatus = ((struct dbr_time_long *) pBuf)->status;
			AlarmSeverity = ((struct dbr_time_long *) pBuf)->severity;
			for (i = 0; i < NumElements; i++)
				myDblPr[i] = (double) (*(&((pBuf)->tlngval.value) + i));
			break;
		case DBR_TIME_DOUBLE:
			TimeStamp = ((struct dbr_time_double *) pBuf)->stamp;
			AlarmStatus = ((struct dbr_time_double *) pBuf)->status;
			AlarmSeverity = ((struct dbr_time_double *) pBuf)->severity;
			for (i = 0; i < NumElements; i++)
				myDblPr[i] = (double) (*(&((pBuf)->tdblval.value) + i));
			break;
		default:
			break;
		}
	}
}

const mxArray *Channel::GetMonitorCache( void ) const {
	return (Cache);
}

char* Channel::GetHostName( void )  const {
	return (HostName);
}

bool Channel::EventInstalled( void ) const {
	return (EventID==0?0:1);
}

int Channel::AddEvent( caEventCallBackFunc *MonitorEventHandler ) {

	int status;
	MCAError Err;

	status = ca_add_event(RequestType, ChannelID, MonitorEventHandler, this, &EventID);
	if (status != ECA_NORMAL)
		Err.Message(MCAError::MCAERR, ca_message(status));

	return (status);

}

void Channel::ClearMonitorString( void ) {

	// If it exists, remove the monitor string.
	//
	if (MonitorCBString) {
		mxFree(MonitorCBString);
		MonitorCBString = NULL;
	}

}

void Channel::ClearEvent( void ) {

	int status;
	MCAError Err;

	if (EventID) {

		status = ca_clear_event(EventID);
		if (status != ECA_NORMAL)
			Err.Message(MCAError::MCAWARN, "ca_add_array_event failed.\n");

		EventID = 0;

		ClearMonitorString();
	}
}

int Channel::GetEventCount( void ) const {
	return (EventCount);
}

void Channel::IncrementEventCount( void ) {
	EventCount++;
}

void Channel::ResetEventCount( void ) {
	EventCount = 0;
}

bool Channel::MonitorStringInstalled( void ) const {
	return (MonitorCBString?1:0);
}

const char* Channel::GetMonitorString( void ) const {
	return (MonitorCBString);
}

