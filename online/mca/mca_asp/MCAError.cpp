
#include "mex.h"
#include "MCAError.h"

MCAError::MCAError( void )
{
}

MCAError::~MCAError( void )
{

}

void MCAError::Message(int Level, const char* Mesg)
{

	switch (Level) {
	case MCAINFO:
		mexPrintf(Mesg);
		mexPrintf("\n");
		break;
	case MCAWARN:
		mexWarnMsgTxt(Mesg);
		mexPrintf("\n");
		break;
	case MCAERR:
		mexErrMsgTxt(Mesg);
		break;
	default:
		mexPrintf("MCAError.Message: Invalid Option\n");
	}
}

