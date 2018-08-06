/* mxTimesTPS.c --- calculates the times of two TPS
   MATLAB usage: r = mxInverseTPS(p,q)
*/

/*
#include <stdio.h>
#include <stdlib.h>
*/
#include <math.h>
#include "mex.h"

void mexFunction(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{ int i,j,nv,mo,nmo,size_g,size_t;
  double NumberOfVariables,MaximumOrder,NumberOfMonomials;
  double *t,*g,*h,*CoeOfInv;

  if(nrhs != 5) mexErrMsgTxt("Five input arguments required.");
  if(nlhs > 1) mexErrMsgTxt("Too many output arguments.");

  nv = NumberOfVariables = mxGetScalar(prhs[0]);
  mo = MaximumOrder = mxGetScalar(prhs[1]);
  nmo = NumberOfMonomials = mxGetScalar(prhs[2]);
  size_g = mxGetNumberOfElements(prhs[3]);
  g = (double*) mxGetPr(prhs[3]);
  CoeOfInv = (double*) mxGetPr(prhs[4]);
  h = (double*) memalloc(size*(double));
  memcpy(h,g,size_g*(double));

  size_t = mxGetNumberOfElements(plhs[0]);
  if(size_t != nmo)
  { /* Following two statements are the same meaning. */
    /*
    plhs[0] = mxCreateNumericArray(nmo,1,mxDOUBLE_CLASS,mxREAL);
    */
    plhs[0] = mxCreateDoubleMatrix(nmo,1,mxREAL);
  }
  t = (double*) mxGetPr(plhs[0]);
  
  for(i=0; i<nmo; i++) t[i] = h[i]*CoeOfInv[0];
  for(j=1; j<mo; j++)
  { 
	mxArray *field_value;

	mxSetFieldByNumber(plhs[0],i,name_field,mxCreateString(friends[i].name));
	field_value = mxCreateDoubleMatrix(1,1,mxREAL);
	*mxGetPr(field_value) = friends[i].phone;
	
	mxSetFieldByNumber(plhs[0],i,phone_field,field_value);
    }
}

