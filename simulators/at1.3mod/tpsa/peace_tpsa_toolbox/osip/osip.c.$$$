/* mxNumberOfMonomials.c --- calculates the NumberOfMonomials
   MATLAB usage: nmo = mxNumberOfMonomials(NumberOfVariable,MaximumOrder)
   It cost a lot in building the API between MATLAB and C!
   For simple calculation, the C code may get no gain of efficiency.
*/

/*
#include <stdio.h>
#include <stdlib.h>
*/
#include "mex.h"

void mexFunction(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{ double NumberOfVariables,MaximumOrder;
  int nv,mo,i,j;
  double *nmo;
  
  if(nrhs != 2) mexErrMsgTxt("Two input arguments required.");
  if(nlhs > 1) mexErrMsgTxt("Too many output arguments.");
  nv = NumberOfVariables = mxGetScalar(prhs[0]);
  mo = MaximumOrder = mxGetScalar(prhs[1]);
  /*
  printf("NumberOfVariables = %f = %d\n",NumberOfVariables,nv);
  printf("MaximumOrder = %f = %d\n",MaximumOrder,mo);
  */
  plhs[0] = mxCreateDoubleMatrix(nv,mo,mxREAL);
  nmo = mxGetPr(plhs[0]); /* Take care the arrangement of matrix elements! */
  for(i=0; i<nv; i++)
  { nmo[i] = i+2; /* order 1 (j=0) case */
    for(j=1; j<mo; j++) nmo[j*nv+i] = nmo[i+(j-1)*nv]*(i+2+j)/(j+1);
  }
}
