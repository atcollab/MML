/* ThinEPUPass.c
   Accelerator Toolbox 
*/

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>
#include "mex.h"
#include "elempass.h"
#include "atlalib.c"

void fill(double *pout, double *pin, int m, int n)
{ int i, j;
  for (i=0; i<m; i++) {
     for (j=0; j<n; j++) {
        pout[i+j*m] = pin[i+j*m];
     }
  }
}

void ThinEPUPass(double *r, int nx, int ny, double *XEPU, double *YEPU, double *PXEPU, double *PYEPU,
                 double *R1, double *R2, double *T1, double *T2, int num_particles)

{ int c;
  double *r6, *xi, *yi;   
  char *method;
  int buflen;
  double xkick, ykick;
  int num_in, num_out;
  mxArray *input_array[6], *output_array[1];

  num_in = 6;
  num_out = 1;
  input_array[0] = mxCreateDoubleMatrix(ny,nx,mxREAL);
  input_array[1] = mxCreateDoubleMatrix(ny,nx,mxREAL);
  input_array[2] = mxCreateDoubleMatrix(ny,nx,mxREAL);
  input_array[3] = mxCreateDoubleMatrix(1,1,mxREAL);
  input_array[4] = mxCreateDoubleMatrix(1,1,mxREAL);
  xi = (double*)mxCalloc(1,sizeof(double));
  yi = (double*)mxCalloc(1,sizeof(double));
  fill(mxGetPr(input_array[0]), XEPU, ny, nx);
  fill(mxGetPr(input_array[1]), YEPU, ny, nx);
  mxSetM(input_array[0], ny) ;
  mxSetN(input_array[0], nx) ;
  mxSetM(input_array[1], ny) ;
  mxSetN(input_array[1], nx) ;
  buflen = 6;
  method = mxCalloc(buflen,sizeof(char));
  strncpy(method,"*cubic",buflen);
  /*
  mexPrintf(" method = ");
  for(c = 0;c<buflen;c++) {
     mexPrintf("%c", method[c]);
  }
  mexPrintf("\n");
  */
  input_array[5] = mxCreateString(method);
  for (c = 0;c<num_particles;c++){/* Loop over particles */
     r6 = r+c*6;
     /* linearized misalignment transformation at the entrance */
     ATaddvv(r6,T1);
     ATmultmv(r6,R1);
     xi[0] = r6[0]; 
     yi[0] = r6[2]; 
     fill(mxGetPr(input_array[3]), xi, 1, 1);
     fill(mxGetPr(input_array[4]), yi, 1, 1);
     mxSetM(input_array[3], 1) ;
     mxSetN(input_array[3], 1) ;
     mxSetM(input_array[4], 1) ;
     mxSetN(input_array[4], 1) ;
     fill(mxGetPr(input_array[2]), PXEPU, ny, nx);
     mxSetM(input_array[2], ny) ;
     mxSetN(input_array[2], nx) ;
     mexCallMATLAB(num_out, output_array, num_in, input_array, "interp2");
     xkick = mxGetScalar(output_array[0]);
     fill(mxGetPr(input_array[2]), PYEPU, ny, nx);
     mxSetM(input_array[2], ny) ;
     mxSetN(input_array[2], nx) ;
     mexCallMATLAB(num_out, output_array, num_in, input_array, "interp2");
     ykick = mxGetScalar(output_array[0]);

     r6[1] += xkick;
     r6[3] += ykick;
           
     /* linearized misalignment transformation at the exit */
     ATmultmv(r6,R2);
     ATaddvv(r6,T2);
  }
  mxDestroyArray(input_array[5]);
  mxFree(method);
  mxFree(yi);
  mxFree(xi);
  mxDestroyArray(input_array[4]);
  mxDestroyArray(input_array[3]);
  mxDestroyArray(input_array[2]);
  mxDestroyArray(input_array[1]);
  mxDestroyArray(input_array[0]);
}

ExportMode int* passFunction(const mxArray *ElemData, int *FieldNumbers,
double *r_in, int num_particles, int mode)

#define NUM_FIELDS_2_REMEMBER 11
{
  double le;
  int nx, ny;
  double *XEPU, *YEPU, *PXEPU, *PYEPU;
  double *pr1, *pr2, *pt1, *pt2;
  int *returnptr;
  int *NewFieldNumbers,fnum;
  mxArray *tmpmxptr;

  switch(mode) {
     case NO_LOCAL_COPY: { /* Get fields by names from MATLAB workspace  */
        tmpmxptr=mxGetField(ElemData,0,"Length");
        if(tmpmxptr) {
           le = mxGetScalar(tmpmxptr);
           returnptr = NULL;
        }
        else
           mexErrMsgTxt("Required field 'Length' was not found in the element data structure");
        tmpmxptr =mxGetField(ElemData,0,"NumX");
        if(tmpmxptr) {
           nx = (int)mxGetScalar(tmpmxptr);
           returnptr = NULL;
        }
        else
           mexErrMsgTxt("Required field 'NumX' was not found in the element data structure"); 
        tmpmxptr =mxGetField(ElemData,0,"NumY");
        if(tmpmxptr) { 
           ny = (int)mxGetScalar(tmpmxptr);
           returnptr = NULL;
        }
        else
           mexErrMsgTxt("Required field 'NumY' was not found in the element data structure");
        tmpmxptr = mxGetField(ElemData,0,"XGrid");
        if(tmpmxptr) {
           XEPU = mxGetPr(tmpmxptr);
           returnptr = NULL;
        }
        else
           mexErrMsgTxt("Required field 'XGrid' was not found in the element data structure");
        tmpmxptr = mxGetField(ElemData,0,"YGrid");
        if(tmpmxptr) {
           YEPU = mxGetPr(tmpmxptr);
           returnptr = NULL;
        }
        else
           mexErrMsgTxt("Required field 'YGrid' was not found in the element data structure");
        tmpmxptr = mxGetField(ElemData,0,"PxGrid");
        if(tmpmxptr) {
           PXEPU = mxGetPr(tmpmxptr);
           returnptr = NULL;
        }
        else
           mexErrMsgTxt("Required field 'PxGrid' was not found in the element data structure");
        tmpmxptr = mxGetField(ElemData,0,"PyGrid");
        if(tmpmxptr) {
           PYEPU = mxGetPr(tmpmxptr);
           returnptr = NULL;
        }
        else
           mexErrMsgTxt("Required field 'PyGrid' was not found in the element data structure");
        tmpmxptr=mxGetField(ElemData,0,"R1");
        if(tmpmxptr) {
           pr1 = mxGetPr(tmpmxptr);
           returnptr = NULL;
        }
        else
           mexErrMsgTxt("Required field 'R1' was not found in the element data structure");
        tmpmxptr=mxGetField(ElemData,0,"R2");
        if(tmpmxptr) {
           pr2 = mxGetPr(tmpmxptr);
           returnptr = NULL;
        }
        else
           mexErrMsgTxt("Required field 'R2' was not found in the element data structure");
        tmpmxptr=mxGetField(ElemData,0,"T1");
        if(tmpmxptr) {
           pt1 = mxGetPr(tmpmxptr);
           returnptr = NULL;
        }
        else
           mexErrMsgTxt("Required field 'T1' was not found in the element data structure");
        tmpmxptr=mxGetField(ElemData,0,"T2");
        if(tmpmxptr) {
           pt2 = mxGetPr(tmpmxptr);
           returnptr = NULL;
        }
        else
           mexErrMsgTxt("Required field 'T2' was not found in the element data structure");
     }
     break;
     case MAKE_LOCAL_COPY: { /* Find field numbers first
                                Save a list of field number in an array
                                and make returnptr point to that array */
        /* Allocate memory for integer array of 
           field numbers for faster futurereference */

        NewFieldNumbers = (int*)mxCalloc(NUM_FIELDS_2_REMEMBER,sizeof(int));

        /* Populate */
        fnum = mxGetFieldNumber(ElemData,"Length");
        if(fnum<0)
           mexErrMsgTxt("Required field 'Length' was not found in the element data structure");
        NewFieldNumbers[0] = fnum;
        fnum = mxGetFieldNumber(ElemData,"NumX");
        if(fnum<0) 
           mexErrMsgTxt("Required field 'NumX' was not found in the element data structure"); 
        NewFieldNumbers[1] = fnum;
        fnum = mxGetFieldNumber(ElemData,"NumY");
        if(fnum<0) 
           mexErrMsgTxt("Required field 'NumY' was not found in the element data structure"); 
        NewFieldNumbers[2] = fnum;
        fnum = mxGetFieldNumber(ElemData,"XGrid");
        if(fnum<0) 
           mexErrMsgTxt("Required field 'XGrid' was not found in the element data structure"); 
        NewFieldNumbers[3] = fnum;
        fnum = mxGetFieldNumber(ElemData,"YGrid");
        if(fnum<0) 
           mexErrMsgTxt("Required field 'YGrid' was not found in the element data structure"); 
        NewFieldNumbers[4] = fnum;
        fnum = mxGetFieldNumber(ElemData,"PxGrid");
        if(fnum<0)
           mexErrMsgTxt("Required field 'PxGrid' was not found in the element data structure");
        NewFieldNumbers[5] = fnum;
        fnum = mxGetFieldNumber(ElemData,"PyGrid");
        if(fnum<0)
           mexErrMsgTxt("Required field 'PyGrid' was not found in the element data structure");
        NewFieldNumbers[6] = fnum;
        fnum = mxGetFieldNumber(ElemData,"R1");
        if(fnum<0)
           mexErrMsgTxt("Required field 'R1' was not found in the element data structure");
        NewFieldNumbers[7] = fnum;
        fnum = mxGetFieldNumber(ElemData,"R2");
        if(fnum<0)
           mexErrMsgTxt("Required field 'R2' was not found in the element data structure");
        NewFieldNumbers[8] = fnum;
        fnum = mxGetFieldNumber(ElemData,"T1");
        if(fnum<0)
           mexErrMsgTxt("Required field 'T1' was not found in the element data structure");
        NewFieldNumbers[9] = fnum;
        fnum = mxGetFieldNumber(ElemData,"T2");
        if(fnum<0)
           mexErrMsgTxt("Required field 'T2' was not found in the element data structure");
        NewFieldNumbers[10] = fnum;

        le = mxGetScalar(mxGetFieldByNumber(ElemData,0,NewFieldNumbers[0]));
        nx = (int)mxGetScalar(mxGetFieldByNumber(ElemData,0,NewFieldNumbers[1]));
        ny = (int)mxGetScalar(mxGetFieldByNumber(ElemData,0,NewFieldNumbers[2]));
        XEPU = mxGetPr(mxGetFieldByNumber(ElemData,0,NewFieldNumbers[3]));
        YEPU = mxGetPr(mxGetFieldByNumber(ElemData,0,NewFieldNumbers[4]));
        PXEPU = mxGetPr(mxGetFieldByNumber(ElemData,0,NewFieldNumbers[5]));
        PYEPU = mxGetPr(mxGetFieldByNumber(ElemData,0,NewFieldNumbers[6]));
        pr1 = mxGetPr(mxGetFieldByNumber(ElemData,0,NewFieldNumbers[7]));
        pr2 = mxGetPr(mxGetFieldByNumber(ElemData,0,NewFieldNumbers[8]));
        pt1 = mxGetPr(mxGetFieldByNumber(ElemData,0,NewFieldNumbers[9]));
        pt2 = mxGetPr(mxGetFieldByNumber(ElemData,0,NewFieldNumbers[10]));

        returnptr = NewFieldNumbers;
     }
     break;
     case USE_LOCAL_COPY: { /* Get fields from MATLAB using field numbers
                               The second argument ponter to the array of field 
                               numbers is previously created with 
                               QuadLinPass( ..., MAKE_LOCAL_COPY) */

        le = mxGetScalar(mxGetFieldByNumber(ElemData,0,FieldNumbers[0]));
        nx = (int)mxGetScalar(mxGetFieldByNumber(ElemData,0,FieldNumbers[1]));
        ny = (int)mxGetScalar(mxGetFieldByNumber(ElemData,0,FieldNumbers[2]));
        XEPU = mxGetPr(mxGetFieldByNumber(ElemData,0,FieldNumbers[3]));
        YEPU = mxGetPr(mxGetFieldByNumber(ElemData,0,FieldNumbers[4]));
        PXEPU = mxGetPr(mxGetFieldByNumber(ElemData,0,FieldNumbers[5]));
        PYEPU = mxGetPr(mxGetFieldByNumber(ElemData,0,FieldNumbers[6]));
        pr1 = mxGetPr(mxGetFieldByNumber(ElemData,0,FieldNumbers[7]));
        pr2 = mxGetPr(mxGetFieldByNumber(ElemData,0,FieldNumbers[8]));
        pt1 = mxGetPr(mxGetFieldByNumber(ElemData,0,FieldNumbers[9]));
        pt2 = mxGetPr(mxGetFieldByNumber(ElemData,0,FieldNumbers[10]));

        returnptr = FieldNumbers;
     }
     break;
     default: {
        mexErrMsgTxt("No match for calling mode in function ThinEPUPass\n");
     }
  }
  ThinEPUPass(r_in, nx, ny, XEPU, YEPU, PXEPU, PYEPU, pr1, pr2, pt1, pt2, num_particles);

  return(returnptr);
}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
  int m,n;
  double *r_in;
  mxArray *tmpmxptr;
  double le;
  int nx, ny;
  double *XEPU, *YEPU, *PXEPU, *PYEPU;
  double *pr1, *pr2, *pt1, *pt2;

  /* ALLOCATE memory for the output array of the same size as the input */
  m = mxGetM(prhs[1]);
  n = mxGetN(prhs[1]);
  if(m!=6) 
     mexErrMsgTxt("Second argument must be a 6 x N matrix");

  tmpmxptr = mxGetField(prhs[0],0,"Length");
  if(tmpmxptr)
     le = mxGetScalar(tmpmxptr);
  else
     mexErrMsgTxt("Required field 'Length' was not found in the element data structure");
  tmpmxptr = mxGetField(prhs[0],0,"NumX");
  if(tmpmxptr)
     nx = (int)mxGetScalar(tmpmxptr);
  else
     mexErrMsgTxt("Required field 'NumX' was not found in the element data structure");
  tmpmxptr = mxGetField(prhs[0],0,"NumY");
  if(tmpmxptr)
     ny = (int)mxGetScalar(tmpmxptr);
  else
     mexErrMsgTxt("Required field 'NumY' was not found in the element data structure");
  tmpmxptr=mxGetField(prhs[0],0,"XGrid");
  if(tmpmxptr)
     XEPU = mxGetPr(tmpmxptr);
  else
     mexErrMsgTxt("Required field 'XGrid' was not found in the element data structure"); 
  tmpmxptr=mxGetField(prhs[0],0,"YGrid");
  if(tmpmxptr)
     YEPU = mxGetPr(tmpmxptr);
  else
     mexErrMsgTxt("Required field 'YGrid' was not found in the element data structure");
  tmpmxptr=mxGetField(prhs[0],0,"PxGrid");
  if(tmpmxptr)
     PXEPU = mxGetPr(tmpmxptr);
  else
     mexErrMsgTxt("Required field 'PxGrid' was not found in the element data structure"); 
  tmpmxptr=mxGetField(prhs[0],0,"PyGrid");
  if(tmpmxptr)
     PYEPU = mxGetPr(tmpmxptr);
  else
     mexErrMsgTxt("Required field 'PyGrid' was not found in the element data structure");
  tmpmxptr=mxGetField(prhs[0],0,"R1");
  if(tmpmxptr)
     pr1 = mxGetPr(tmpmxptr);
  else
     mexErrMsgTxt("Required field 'R1' was not found in the element data structure");
  tmpmxptr=mxGetField(prhs[0],0,"R2");
  if(tmpmxptr)
     pr2 = mxGetPr(tmpmxptr);
  else
     mexErrMsgTxt("Required field 'R2' was not found in the element data structure");
  tmpmxptr=mxGetField(prhs[0],0,"T1");
  if(tmpmxptr)
     pt1 = mxGetPr(tmpmxptr);
  else
     mexErrMsgTxt("Required field 'T1' was not found in the element data structure");
  tmpmxptr=mxGetField(prhs[0],0,"T2");
  if(tmpmxptr)
     pt2 = mxGetPr(tmpmxptr);
  else
     mexErrMsgTxt("Required field 'T2' was not found in the element data structure");
  plhs[0] = mxDuplicateArray(prhs[1]);
  r_in = mxGetPr(plhs[0]);
  ThinEPUPass(r_in, nx, ny, XEPU, YEPU, PXEPU, PYEPU, pr1, pr2, pt1, pt2, n);
}
