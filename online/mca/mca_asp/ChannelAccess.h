#ifndef channelaccess_h
#define channelaccess_h

class Channel;

class ChannelAccess { 

public:

	// Constructor
	ChannelAccess( void );

	// Destructor
	virtual ~ChannelAccess( void );

	void Initialize( void );
	bool IsInitialized( void ) const;

	void SetDefaultTimeouts( void );

	void SetSearchTimeout( double );
	double GetSearchTimeout( void ) const;
	int WaitForSearch( void ) const;

	void SetGetTimeout( double );
	double GetGetTimeout( void ) const;
	int WaitForGet( void ) const;

	void SetPutTimeout( double );
	double GetPutTimeout( void ) const;
	int WaitForPut( void ) const;
	int WaitForPutIO( void ) const;

private:
	static bool CA_Initialized;

	double MCA_SEARCH_TIMEOUT;
	double MCA_GET_TIMEOUT;
	double MCA_PUT_TIMEOUT;


};

#endif // channelaccess_h

