/* CHANGES FROM UNIX VERSION                                                   */
/*                                                                             */
/* 1.  Changed header files.                                                   */
/* 2.  Added WSAStartUP() and WSACleanUp().                                    */
/* 3.  Used closesocket() instead of close().                                  */ 

#include <stdio.h>      /* for printf(), fprintf() */

#ifdef WINDOWS
#include <winsock.h>    /* for socket(),... */
#include <windows.h>
#include <errno.h>
#else
#include <sys/types.h>
#include <netinet/in.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <errno.h>
#include <netdb.h>
#include <string.h>
#endif

#include <stdlib.h>     /* for exit() */
#include <math.h>

#include "mex.h"
#include "matrix.h"


/* Output Arguments */
#define	OUTPUT1 plhs[0]

/* Inputs Arguments */
#define	INPUT1 prhs[0]
#define	INPUT2 prhs[1]
#define	INPUT3 prhs[2]
#define	INPUT4 prhs[3]
#define	INPUT5 prhs[4]
#define	INPUT6 prhs[5]

#define max(a, b)  (((a) > (b)) ? (a) : (b))
#define min(a, b)  (((a) < (b)) ? (a) : (b))


extern int h_errno;

#define BUFFSIZE 80   /* Size of receive buffer */
#define PORT 5066

void DieWithError(char *errorMessage)
{
	fprintf (stderr, "%s: %d\n", errorMessage, h_errno);  /* Changed errno to h_errno for the windows compile! */
	exit (h_errno);                                       /* Changed errno to h_errno for the windows compile! */
}

int rampgenTableLoad (
	char *iocName,
	int elementCount,
	int dacChannel,
	double egul,
	double eguf,
	char *tableName,
	double *table)
{
    int sock;                        /* Socket descriptor */
    struct sockaddr_in echoServAddr; /* Echo server address */
    unsigned short echoServPort;     /* Echo server port */
    char *servIP;                    /* Server IP address (dotted quad) */
    
    char buff[BUFFSIZE];
    int bytesRcvd, totalBytesRcvd;    /* Bytes read in single recv() and total bytes read */
	int bytesXmited, bytesLeft;
    #ifdef WINDOWS
         WSADATA wsaData;             /* Structure for WinSock setup communication */
    #endif
	int i;
	unsigned short *rtable;
	int rtableSize;
	int error;
	double eslo;
	int val;
	unsigned short sval;
	struct hostent *host;
	struct in_addr *ptr;

	/* Allocate the integer ramp table */
	bytesXmited = elementCount * sizeof (short int);
	rtable = (short int *)malloc (bytesXmited);
	
	/* synthesize table elements */
	eslo = (eguf - egul) / 65536.0;
	for	(i=	0; i < elementCount; i++) {
		/*val = (int) round ((table[i] - egul) / eslo); */
		val = (int) floor(((table[i] - egul) / eslo) + .5);  /* For some reason round is not being found in math.h */
		if (val > 65535) val = 65535;
		if (val < 0) val = 0;
		sval = ((short int)val);
        /* printf ("%d: %g -> %d(%d)\n", i, table[i], val, sval); */
		rtable[i] = htons (sval);
	}
	
	/* Create a reliable, stream socket using TCP */
	if ((sock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0) {
		free (rtable);
		return 10;
	}

	/* Construct the server address structure */
	memset(&echoServAddr, 0, sizeof(echoServAddr));     /* Zero out structure */
	echoServAddr.sin_family      = AF_INET;             /* Internet address family */
	echoServAddr.sin_port        = htons(PORT); /* Server port */
	echoServAddr.sin_addr.s_addr = inet_addr(iocName);   /* Server IP address */
	if (echoServAddr.sin_addr.s_addr == -1) {
		/* Do DNS lookup on iocName */
		host = gethostbyname (iocName);
		if (h_errno) {
			free (rtable);
			return 11;
		}
		ptr = (struct in_addr *) host->h_addr_list[0];
		echoServAddr.sin_addr.s_addr = ptr->s_addr;
	}
	
	/* Establish the connection to the echo server */
	if (connect(sock, (struct sockaddr *) &echoServAddr, sizeof(echoServAddr)) < 0) {
		free (rtable);
		return 11;
	}

	*(short int *)buff = htons (44);				/* header length in bytes */
	*(short int *)(buff+2) = htons (elementCount);	/* element count */
	*(short int *)(buff+4) = htons (dacChannel);	/* DAC channel */
	memcpy (buff+6, tableName, 40);					/* table name */

	if (send(sock, buff, 46, 0) != 46) {
		free (rtable);
		return 12;
	}

	/* Receive server response */
	if ((bytesRcvd = recv(sock, buff, BUFFSIZE, 0)) <= 0) {
		free (rtable);
		return 13;
	}

	/* Check for errors in header */
	error = ntohs (*(short int *)buff);
	if (error) {
		free (rtable);
		return error;
	}

	/* Send	the	the	table  */
	if ((i = send(sock, rtable, bytesXmited, 0)) != bytesXmited) {
		free (rtable);
		return 14;
	}

	/* Receive server response */;
	if ((bytesRcvd = recv(sock, buff, BUFFSIZE, 0)) <= 0) {
		free (rtable);
		return 15;
	}
	
	/* cleanup and return server's response code to caller */
	error = ntohs (*(short int *)buff);
	close (sock);
	free (rtable);
	
 	return (error);	
}



/*  MATLAB TO C-CALL LINKING FUNCTION  */
void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[] )
{ 
    int Channel;
    int RTABLELEN, ErrorFlag, n, m, buflen, Status;
    char *TableName, *IOCName;
    double *WaveForm;
 	double egul, eguf;

    
    /* Test for correct number of arguments */
    if (nrhs < 6)
    	mexErrMsgTxt("   6 inputs are required (rampgentableload.c).");

    
    /* Input 1: Ramp Table Array */
    if (!mxIsNumeric(INPUT1) || mxIsComplex(INPUT1) || !mxIsDouble(INPUT1))
        mexErrMsgTxt("   The waveform must be a double array. (rampgentableload.c).");
        
    WaveForm = mxGetPr(INPUT1);
    m = mxGetM(INPUT1);
    n = mxGetN(INPUT1);
        
    if (m > 1 && n > 1)
        mexErrMsgTxt("   The waveform must be a vector. (rampgentableload.c).");

    RTABLELEN = max(m,n);


    /* Input 2: IOC input string */
    /* b0101-1.als.lbl.gov for HCM1-2  */
    /* b0101-3.als.lbl.gov for VCM1-2  */
    /* b0102-3.als.lbl.gov for HCM2-3  */
    /* b0102-5.als.lbl.gov for VCM2-3  */
    /* li14-40.als.lbl.gov for RF      */
    buflen = (mxGetM(INPUT2) * mxGetN(INPUT2)) + 1;   /* Length of input string */
    IOCName = mxCalloc(buflen, sizeof(char));
    Status = mxGetString(INPUT2, IOCName, buflen);
    if(Status != 0)
        mexWarnMsgTxt("Not enough space to read in the IOCName input.  IOCName is truncated.");

    if (mxGetN(INPUT2) > 40)
        mexErrMsgTxt("   IOCName must be 40 characters or less. (rampgentableload.c).");     

    
    /* Input 3: Channel Number */
	m = mxGetM(INPUT3);
	n = mxGetN(INPUT3);
	if (!mxIsNumeric(INPUT3) || mxIsComplex(INPUT3) || !mxIsDouble(INPUT3) || (max(m,n) != 1) || (min(m,n) != 1))
		mexErrMsgTxt("Channel must be a scalar.");
        
    Channel = (int) mxGetScalar(INPUT3);
	if ((Channel < 0) || (Channel > 3))
		mexErrMsgTxt("Channel must be 0, 1, 2, or 3.");

    
    /* Input 4: Table name comment string */
    buflen = (mxGetM(INPUT4) * mxGetN(INPUT4)) + 1;   /* Length of input string */
    TableName = mxCalloc(buflen, sizeof(char));
    Status = mxGetString(INPUT4, TableName, buflen);
    if(Status != 0)
        mexWarnMsgTxt("Not enough space to read in the TableName input.  TableName is truncated.");

    if (mxGetN(INPUT4) > 40)
        mexErrMsgTxt("   TableName must be 40 characters or less. (rampgentableload.c).");     
        

    /* Input 5: egul */
	m = mxGetM(INPUT5);
	n = mxGetN(INPUT5);
	if (!mxIsNumeric(INPUT5) || mxIsComplex(INPUT5) || !mxIsDouble(INPUT5) || (max(m,n) != 1) || (min(m,n) != 1))
		mexErrMsgTxt("Channel must be a scalar.");
        
    egul = (int) mxGetScalar(INPUT5);

    /* Input 6: eguf */
	m = mxGetM(INPUT6);
	n = mxGetN(INPUT6);
	if (!mxIsNumeric(INPUT6) || mxIsComplex(INPUT6) || !mxIsDouble(INPUT6) || (max(m,n) != 1) || (min(m,n) != 1))
		mexErrMsgTxt("Channel must be a scalar.");
        
    eguf = (int) mxGetScalar(INPUT6);
    
	if (eguf < egul)
		mexErrMsgTxt("eguf cannot be less than egul.");

    
    /* Transmit table */
    mexPrintf("   Transmitting table '%s' with %d points to %s.\n", TableName, RTABLELEN, IOCName);
    mexPrintf("   Channel number = %d  egul=%f eguf=%f.\n", Channel, egul, eguf);
 

    /* Load the table */
    ErrorFlag = rampgenTableLoad(
            IOCName, 
            RTABLELEN,
            Channel,
            egul,
            eguf,
            TableName,
            WaveForm);
    
    if (ErrorFlag) {
        mexPrintf("   rampgenTableLoad returns %d\n", ErrorFlag);
        if (ErrorFlag==1)
            mexPrintf("       -> Element count mismatch between table and PV\n");
        if (ErrorFlag==2)
            mexPrintf("       -> Specified DAC ramp is not enabled\n");
        if (ErrorFlag==3)
            mexPrintf("       -> Specified DAC out of range\n");
        mexErrMsgTxt("   Error loading the ramp table (rampgentableload.c).");     
    }
}

