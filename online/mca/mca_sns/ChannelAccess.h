#ifndef channelaccess_h
#define channelaccess_h

// Base
#include <cadef.h>
// Local
#include "MCAError.h"

// Wrapper around CAC context
class ChannelAccess
{ 
public:
	// Constructor creates CA context
	ChannelAccess() : debug(false)
    {
        mexPrintf("MCA Initialized\n");
        SetDefaultTimeouts();
        int status = ca_context_create(ca_enable_preemptive_callback);
        if (status != ECA_NORMAL)
            MCAError::Error("context_create: %s\n", ca_message(status));
    }

    // Destructor destroys CA context
    virtual ~ChannelAccess()
    {
        ca_context_destroy();
        mexPrintf("MCA Finalized\n");
    }

    bool debugMode() const
    {   return debug; }
    
    void setDebug(bool mode)
    {   debug = mode; }
    
	void SetDefaultTimeouts()
    {
        const double DEFAULT_TIMEOUT = 10.0;
        MCA_SEARCH_TIMEOUT = DEFAULT_TIMEOUT;
        MCA_GET_TIMEOUT = DEFAULT_TIMEOUT;
        MCA_PUT_TIMEOUT = DEFAULT_TIMEOUT;
    }

	void SetSearchTimeout(double SearchTimeOut )
    {   MCA_SEARCH_TIMEOUT = SearchTimeOut; }
    
	double GetSearchTimeout() const
    {  return (MCA_SEARCH_TIMEOUT); }
    
	int WaitForSearch() const
    {  return ca_pend_io(MCA_SEARCH_TIMEOUT); }

	void SetGetTimeout(double GetTimeOut)
    {  MCA_GET_TIMEOUT = GetTimeOut; }
    
	double GetGetTimeout() const
    {  return MCA_GET_TIMEOUT; }
    
	int WaitForGet() const
    {   return ca_pend_io(MCA_GET_TIMEOUT); }

    void SetPutTimeout(double PutTimeOut)
    {   MCA_PUT_TIMEOUT = PutTimeOut; }

    double GetPutTimeout() const
    {   return MCA_PUT_TIMEOUT; }

    int Flush() const
    {   return ca_flush_io(); }

private:
    bool debug;

	double MCA_SEARCH_TIMEOUT;
	double MCA_GET_TIMEOUT;
	double MCA_PUT_TIMEOUT;
};

#endif // channelaccess_h

