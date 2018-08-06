#include <stdio.h>
#include <string.h>
#include "mex.h"
#include "matrix.h"
/* #include "gpfunc.h" */
#include "modnaff.h"
/* #include "complexe.h" */
/* #include <sys/ddi.h> */

double pi=M_PI;

#define max(x, y) ((x) > (y) ? (x) : (y))
#define min(x, y) ((x) < (y) ? (x) : (y))

/* Input Arguments */
#define	Y_IN  prhs[0]
#define	YP_IN  prhs[1]
#define	WIN_IN  prhs[2]

/* Output Arguments */
#define	NU_OUT plhs[0]


int call_naff(double *ydata, double *ypdata, int ndata, double  *nu_out, int win)
{
    int i, iCpt, numfreq;
	
	ndata = 6*(int )(ndata/6.0);
	 
    
 g_NAFVariable.DTOUR=2*pi;   /* size of a "cadran" */
 g_NAFVariable.XH=1;         /* step */
 g_NAFVariable.T0=0;         /* time t0 */
 g_NAFVariable.NTERM=10;     /* max term to find */
 g_NAFVariable.KTABS=ndata;  /* number of data : must be a multiple of 6 */
 g_NAFVariable.m_pListFen=NULL; /*no window*/
 g_NAFVariable.TFS=NULL;    /* will contain frequency */
 g_NAFVariable.ZAMP=NULL;   /* will contain amplitude */
 g_NAFVariable.ZTABS=NULL;  /* will contain data to analyze */

 /*internal use in naf */
 g_NAFVariable.NERROR=0;
 g_NAFVariable.ICPLX=1;
 g_NAFVariable.IPRT=-1; /*0*/
 g_NAFVariable.NFPRT=stdout; /*NULL;*/
 g_NAFVariable.NFS=0;
 g_NAFVariable.IW=win;
 g_NAFVariable.ISEC=1;
 g_NAFVariable.EPSM=2.2204e-16; 
 g_NAFVariable.UNIANG=0;
 g_NAFVariable.FREFON=0;
 g_NAFVariable.ZALP=NULL; 
 g_NAFVariable.m_iNbLineToIgnore=1; /*unused*/
 g_NAFVariable.m_dneps=1.E100;
 g_NAFVariable.m_bFSTAB=FALSE; /*unused*/
 /*end of interl use in naf */
     
    naf_initnaf();
    
    /*remplit les donnees initiales*/
    for(i=0;i<ndata;i++)
    {
     g_NAFVariable.ZTABS[i+1].reel=ydata[i];
     g_NAFVariable.ZTABS[i+1].imag=ypdata[i];
    }
    
    /*analyse en frequence*/
    /* recherche de 8 termes */
    naf_mftnaf(8,fabs(g_NAFVariable.FREFON)/g_NAFVariable.m_dneps);

   /* affichage des resultats */

/*   mexPrintf("NFS=%d\n",g_NAFVariable.NFS);
   for(iCpt=1;iCpt<=g_NAFVariable.NFS; iCpt++)
   {
    mexPrintf("AMPL=%g+i*%g abs(AMPL)=%g arg(AMPL)=%g FREQ=%g\n",
           g_NAFVariable.ZAMP[iCpt].reel,g_NAFVariable.ZAMP[iCpt].imag, 
           (float )i_compl_module(g_NAFVariable.ZAMP[iCpt]), 
           (float )i_compl_angle(g_NAFVariable.ZAMP[iCpt]),
           (float )g_NAFVariable.TFS[iCpt]);

 	   nu_out[iCpt-1] = g_NAFVariable.TFS[iCpt];

   } 
*/

   numfreq = g_NAFVariable.NFS;
   
   for(iCpt=1;iCpt<=numfreq; iCpt++)
 	   nu_out[iCpt-1] = g_NAFVariable.TFS[iCpt];

 
    /*liberation de la memoire*/
	naf_cleannaf();
	return(numfreq);
}



/*  MATLAB TO C-CALL LINKING FUNCTION  */
void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[] )
{         
	double	 *nu_out,*y_in,*yp_in,*win_in;
	double    nu[8];
	unsigned int  i,m,n,m2,n2,numfreq;
	int win;

	if ((nrhs < 2) || (nrhs >3)) {
		mexErrMsgTxt("Requires 2 or 3 input arguments");
	}
	
	if (nrhs == 2) win = 0;
	else {

	  m = mxGetM(WIN_IN);
 	  n = mxGetN(WIN_IN);
 
  	  if (!mxIsNumeric(WIN_IN) || mxIsComplex(WIN_IN) || 
      	  mxIsSparse(WIN_IN)  ||  (max(m,n) != 1) || (min(m,n) != 1)) {
    	  	mexErrMsgTxt("CALCNAFF requires that Window be a scalar.");
  	  }

	  /* assign pointer */
	
	  win_in   = mxGetPr(WIN_IN);
	
	  win = (int )*win_in;	

/*	  mexPrintf("Window = %d\n",win); */
	}
	
  /* Check the dimensions of Y.  Y can be >6 X 1 or 1 X >6. */
  
  m = mxGetM(Y_IN);
  n = mxGetN(Y_IN);
  
  if (!mxIsNumeric(Y_IN) || mxIsComplex(Y_IN) || 
      mxIsSparse(Y_IN)  || !mxIsDouble(Y_IN) || 
      (max(m,n) <= 6) || (min(m,n) != 1)) {
    mexErrMsgTxt("CALCNAFF requires that Y be a >=6 x 1 vector.");
  }


	/* assign pointer */
	
	y_in   = mxGetPr(Y_IN);

 /* Check the dimensions of YP.  YP must have same size as Y */
  
  m2 = mxGetM(YP_IN);
  n2 = mxGetN(YP_IN);
  
  if (!mxIsNumeric(YP_IN) || mxIsComplex(YP_IN) || 
      mxIsSparse(YP_IN)  || !mxIsDouble(YP_IN) || 
      (m2 != m) || (n2 != n)) {
    mexErrMsgTxt("CALCNAFF requires that YP has the same size as Y.");
  }


	/* assign pointer */
	
	yp_in   = mxGetPr(YP_IN);

	/* call subroutine that sets up NAFF */

	numfreq = call_naff(y_in,yp_in,(int )max(m,n),nu,win);	


	/* Create Output Vector */
		
	NU_OUT = mxCreateDoubleMatrix(numfreq, (unsigned int) 1, mxREAL);

	/* assign pointer */
	
	nu_out = mxGetPr(NU_OUT);

	/* copy results */
	
	for(i=0;i<numfreq;i++) nu_out[i] = nu[i];
		
	return;
} 


