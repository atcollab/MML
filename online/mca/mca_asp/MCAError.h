#ifndef mcaerror_h
#define mcaerror_h

class MCAError  
{
public:

	void Message(int, const char *);

	enum { MCAINFO, MCAWARN, MCAERR };

	MCAError( void );
	~MCAError( void );

};

#endif // mcaerror_h
