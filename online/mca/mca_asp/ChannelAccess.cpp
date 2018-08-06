#include <string.h>
#include "ChannelAccess.h"
#include "Channel.h"
#include "MCAError.h"
#include <cadef.h>

bool ChannelAccess::CA_Initialized = false;

const double DEFAULT_SEARCH_TIMEOUT = 1.0;
const double DEFAULT_GET_TIMEOUT = 5.0;
const double DEFAULT_PUT_TIMEOUT = 0.01;

ChannelAccess::ChannelAccess( void )
{

	MCA_SEARCH_TIMEOUT = DEFAULT_SEARCH_TIMEOUT;
	MCA_GET_TIMEOUT = DEFAULT_GET_TIMEOUT;
	MCA_PUT_TIMEOUT = DEFAULT_PUT_TIMEOUT;

}

ChannelAccess::~ChannelAccess( void )
{
	if (CA_Initialized) {
		ca_context_destroy();
		CA_Initialized = false;
	}
}

void ChannelAccess::Initialize( void )
{
	int status;
	MCAError Err;

	if (CA_Initialized)
		Err.Message(MCAError::MCAWARN, "Attempt to initialize Channel Access when already initialized.");
	else
	{
		status = ca_context_create(ca_enable_preemptive_callback);
		if (status == ECA_NORMAL) {
			CA_Initialized = true;
		}
		else
			Err.Message(MCAError::MCAERR, ca_message(status));
	}	
}

bool ChannelAccess::IsInitialized() const
{
	return CA_Initialized;
}

void ChannelAccess::SetDefaultTimeouts( void ) {

	MCA_SEARCH_TIMEOUT = DEFAULT_SEARCH_TIMEOUT;
	MCA_GET_TIMEOUT = DEFAULT_GET_TIMEOUT;
	MCA_PUT_TIMEOUT = DEFAULT_PUT_TIMEOUT;

}

void ChannelAccess::SetSearchTimeout( double SearchTimeOut )
{
	MCA_SEARCH_TIMEOUT = SearchTimeOut;
}

double ChannelAccess::GetSearchTimeout( void ) const
{
	return (MCA_SEARCH_TIMEOUT);
}

int ChannelAccess::WaitForSearch( void ) const
{

	MCAError Err;
	int status;

	if (CA_Initialized)
		status = ca_pend_io(MCA_SEARCH_TIMEOUT);
	else
		Err.Message(MCAError::MCAERR,"Attempt to call Channel Access ca_pend_io() when not initialised.");

	return (status);

}

void ChannelAccess::SetGetTimeout( double GetTimeOut )
{
	MCA_GET_TIMEOUT = GetTimeOut;
}

double ChannelAccess::GetGetTimeout( void ) const
{
	return (MCA_GET_TIMEOUT);
}

int ChannelAccess::WaitForGet( void ) const
{

	MCAError Err;
	int status;

	if (CA_Initialized)
		status = ca_pend_io(MCA_GET_TIMEOUT);
	else
		Err.Message(MCAError::MCAERR,"Attempt to call Channel Access ca_pend_io() when not initialised.");

	return (status);

}

void ChannelAccess::SetPutTimeout( double PutTimeOut )
{
	MCA_PUT_TIMEOUT = PutTimeOut;
}

double ChannelAccess::GetPutTimeout( void ) const
{
	return (MCA_PUT_TIMEOUT);
}

int ChannelAccess::WaitForPut( void ) const
{

	MCAError Err;
	int status;

	if (CA_Initialized)
		status = ca_pend_event(MCA_PUT_TIMEOUT);
	else
		Err.Message(MCAError::MCAERR,"Attempt to call Channel Access ca_pend_event() when not initialised.");

	return (status);

}

int ChannelAccess::WaitForPutIO( void ) const
{

	MCAError Err;
	int status;

	if (CA_Initialized)
		status = ca_pend_io(MCA_PUT_TIMEOUT);
	else
		Err.Message(MCAError::MCAERR,"Attempt to call Channel Access ca_pend_io() when not initialised.");

	return (status);

}


