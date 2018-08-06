/* TaylormapPass2.c 
   Accelerator Toolbox 
   Created on 05/06/2004
   W. Wan wwan@lbl.gov */

#include "mex.h"
#include<stdio.h>
#include<math.h>
#include "atlalib.c"
#include "elempass.h"

#define PI        3.141592653589793

void TaylormapPass2(double *r_in, double le, int no, int nv,
                        double *x, int nx, double *px, int npx,
                        double *y, int ny, double *py, int npy,
                        double *delta, int ndelta, double *t, int nt,
                        double *T1, double *T2,
                        double *R1, double *R2, int num_particles)
/*
   r_in -- 6-by-N matrix of initial conditions reshaped into 
           1-d array of 6*N elements 
   le -- physical length
   no -- order of the Taylor map
   nv -- number of variables in the input
   x -- Taylor map of final x
   nx -- number of monomials in the map x
   px -- Taylor map of final px
   npx -- number of monomials in the map px
   y -- Taylor map of final y
   ny -- number of monomials in the map y
   py -- Taylor map of final py
   npy -- number of monomials in the map py
   delta -- Taylor map of final delta p / p
   ndelta -- number of monomials in the map delta
   t -- Taylor map of final t
   nt -- number of monomials in the map t
   T1 -- 6 x 1 translation at entrance
   T2 -- 6 x 1 translation at exit
   R1 -- 6 x 6 rotation matrix at the entrance
   R2 -- 6 x 6 rotation matrix at the exit
   num_particles -- number of particles
*/
#define NUM_COLUMNS 9
{
 int c,i,j;
 double *r6; 
 double *rtmp;
 double tmp;
 double *product;

 rtmp = (double*)mxCalloc(6,sizeof(double));
 product = (double*)mxCalloc(no*nv,sizeof(double));

 for(c = 0;c<num_particles;c++) {
  r6 = r_in+c*6;
  for(i=0;i<6;i++) {
   rtmp[i] = r6[i];
   r6[i] = 0;
  }

  /* linearized misalignment transformation at the entrance */
  ATaddvv(rtmp,T1);
  ATmultmv(rtmp,R1);

  /* Taylor map */

  for(i=0;i<nv;i++) {
   tmp = 1;
   for(j=0;j<no;j++) {
    tmp *= rtmp[i];
    product[j+i*no] = tmp;
   }
  }

  /* x final */
  for(i=0;i<nx;i++) {
   tmp = x[i+1*nx];
   for(j=0;j<nv;j++) {
    if ((int)x[i+(j+3)*nx]>0) {
     tmp *= product[(int)x[i+(j+3)*nx]-1+j*no];
    }
   }
   r6[0] += tmp;
  }

  /* px final */
  for(i=0;i<npx;i++) {
   tmp = px[i+1*npx];
   for(j=0;j<nv;j++) {
    if ((int)px[i+(j+3)*npx]>0) {
     tmp *= product[(int)px[i+(j+3)*npx]-1+j*no];
    }
   }
   r6[1] += tmp;
  }

  /* y final */
  for(i=0;i<ny;i++) {
   tmp = y[i+1*ny];
   for(j=0;j<nv;j++) {
    if ((int)y[i+(j+3)*ny]>0) {
     tmp *= product[(int)y[i+(j+3)*ny]-1+j*no];
    }
   }
   r6[2] += tmp;
  }

  /* py final */
  for(i=0;i<npy;i++) {
   tmp = py[i+1*npy];
   for(j=0;j<nv;j++) {
    if ((int)py[i+(j+3)*npy]>0) {
     tmp *= product[(int)py[i+(j+3)*npy]-1+j*no];
    }
   }
   r6[3] += tmp;
  }

  /* delta final */
  for(i=0;i<ndelta;i++) {
   tmp = delta[i+1*ndelta];
   for(j=0;j<nv;j++) {
    if ((int)delta[i+(j+3)*ndelta]>0) {
     tmp *= product[(int)delta[i+(j+3)*ndelta]-1+j*no];
    }
   }
   r6[4] += tmp;
  }

  /* t final */
  for(i=0;i<nt;i++) {
   tmp = t[i+1*nt];
   for(j=0;j<nv;j++) {
    if ((int)t[i+(j+3)*nt]>0) {
     tmp *= product[(int)t[i+(j+3)*nt]-1+j*no];
    }
   }
   r6[5] += tmp;
  }

  /* linearized misalignment transformation at the exit */
  ATmultmv(r6,R2);
  ATaddvv(r6,T2);
 }
 mxFree(rtmp);
 mxFree(product);
}

ExportMode int* passFunction(const mxArray *ElemData,int *FieldNumbers,
                             double *r_in, int num_particles, int mode)

#define NUM_FIELDS_2_REMEMBER 19
{
 int *returnptr;
 int fnum, *NewFieldNumbers;
 mxArray *tmpmxptr;
 double le;
 int no, nv;
 double *pr1, *pr2, *pt1, *pt2;
 double *x, *px, *y, *py, *t, *delta;
 int nx, npx, ny, npy, nt, ndelta;

 switch(mode) {
  case NO_LOCAL_COPY: { /* Get fields by names from MATLAB workspace  */
   tmpmxptr=mxGetField(ElemData,0,"Length");
   if(tmpmxptr) {
    le = mxGetScalar(tmpmxptr);
    returnptr = NULL;
   }
   else
    mexErrMsgTxt("Required field 'Length' was not found in the element data structure"); 
   tmpmxptr=mxGetField(ElemData,0,"Order");
   if(tmpmxptr) {
    no = (int)mxGetScalar(tmpmxptr);
    returnptr = NULL;
   }
   else
    mexErrMsgTxt("Required field 'Order' was not found in the element data structure");
   tmpmxptr=mxGetField(ElemData,0,"NumOfVar");
   if(tmpmxptr) {
    nv = (int)mxGetScalar(tmpmxptr);
    returnptr = NULL;
   }
   else
    mexErrMsgTxt("Required field 'NumOfVar' was not found in the element data structure");
   tmpmxptr=mxGetField(ElemData,0,"MapX");
   if(tmpmxptr) {
    x = mxGetPr(tmpmxptr);
    returnptr = NULL;
   }
   else
    mexErrMsgTxt("Required field 'MapX' was not found in the element data structure");
   tmpmxptr=mxGetField(ElemData,0,"NumOfMonoX");
   if(tmpmxptr) {
    nx = (int)mxGetScalar(tmpmxptr);
    returnptr = NULL;
   }
   else
    mexErrMsgTxt("Required field 'NumOfMonoX' was not found in the element data structure");
   tmpmxptr=mxGetField(ElemData,0,"MapPx");
   if(tmpmxptr) {
    px = mxGetPr(tmpmxptr);
    returnptr = NULL;
   }
   else
    mexErrMsgTxt("Required field 'MapPx' was not found in the element data structure");
   tmpmxptr=mxGetField(ElemData,0,"NumOfMonoPx");
   if(tmpmxptr) {
    npx = (int)mxGetScalar(tmpmxptr);
    returnptr = NULL;
   }
   else
    mexErrMsgTxt("Required field 'NumOfMonoPx' was not found in the element data structure");
   tmpmxptr=mxGetField(ElemData,0,"MapY");
   if(tmpmxptr) {
    y = mxGetPr(tmpmxptr);
    returnptr = NULL;
   }
   else
    mexErrMsgTxt("Required field 'MapY' was not found in the element data structure");
   tmpmxptr=mxGetField(ElemData,0,"NumOfMonoY");
   if(tmpmxptr) {
    ny = (int)mxGetScalar(tmpmxptr);
    returnptr = NULL;
   }
   else
    mexErrMsgTxt("Required field 'NumOfMonoY' was not found in the element data structure");
   tmpmxptr=mxGetField(ElemData,0,"MapPy");
   if(tmpmxptr) {
    py = mxGetPr(tmpmxptr);
    returnptr = NULL;
   }
   else
    mexErrMsgTxt("Required field 'MapPy' was not found in the element data structure");
   tmpmxptr=mxGetField(ElemData,0,"NumOfMonoPy");
   if(tmpmxptr) {
    npy = (int)mxGetScalar(tmpmxptr);
    returnptr = NULL;
   }
   else
    mexErrMsgTxt("Required field 'NumOfMonoPy' was not found in the element data structure");
   tmpmxptr=mxGetField(ElemData,0,"MapDelta");
   if(tmpmxptr) {
    delta = mxGetPr(tmpmxptr);
    returnptr = NULL;
   }
   else
    mexErrMsgTxt("Required field 'MapDelta' was not found in the element data structure");
   tmpmxptr=mxGetField(ElemData,0,"NumOfMonoDelta");
   if(tmpmxptr) {
    ndelta = (int)mxGetScalar(tmpmxptr);
    returnptr = NULL;
   }
   else
    mexErrMsgTxt("Required field 'NumOfMonoDelta' was not found in the element data structure");
   tmpmxptr=mxGetField(ElemData,0,"MapT");
   if(tmpmxptr) {
    t = mxGetPr(tmpmxptr);
    returnptr = NULL;
   }
   else
    mexErrMsgTxt("Required field 'MapT' was not found in the element data structure");
   tmpmxptr=mxGetField(ElemData,0,"NumOfMonoT");
   if(tmpmxptr) {
    nt = (int)mxGetScalar(tmpmxptr);
    returnptr = NULL;
   }
   else
    mexErrMsgTxt("Required field 'NumOfMonoT' was not found in the element data structure");
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
  }
  break;
  case MAKE_LOCAL_COPY: { /* Find field numbers first
                             Save a list of field number in an array
                             and make returnptr point to that array */
   NewFieldNumbers = (int*)mxCalloc(NUM_FIELDS_2_REMEMBER,sizeof(int));
   fnum = mxGetFieldNumber(ElemData,"Length");
   if(fnum<0)
    mexErrMsgTxt("Required field 'Length' was not found in the element data structure"); 
   NewFieldNumbers[0] = fnum;
   fnum = mxGetFieldNumber(ElemData,"Order");
   if(fnum<0)
    mexErrMsgTxt("Required field 'Order' was not found in the element data structure");
   NewFieldNumbers[1] = fnum;
   fnum = mxGetFieldNumber(ElemData,"NumOfVar");
   if(fnum<0)
    mexErrMsgTxt("Required field 'NumOfVar' was not found in the element data structure");
   NewFieldNumbers[2] = fnum;
   fnum = mxGetFieldNumber(ElemData,"MapX");
   if(fnum<0)
    mexErrMsgTxt("Required field 'MapX' was not found in the element data structure");
   NewFieldNumbers[3] = fnum;
   fnum = mxGetFieldNumber(ElemData,"NumOfMonoX");
   if(fnum<0)
    mexErrMsgTxt("Required field 'NumOfMonoX' was not found in the element data structure");
   NewFieldNumbers[4] = fnum;
   fnum = mxGetFieldNumber(ElemData,"MapPx");
   if(fnum<0)
    mexErrMsgTxt("Required field 'MapPx' was not found in the element data structure");
   NewFieldNumbers[5] = fnum;
   fnum = mxGetFieldNumber(ElemData,"NumOfMonoPx");
   if(fnum<0)
    mexErrMsgTxt("Required field 'NumOfMonoPx' was not found in the element data structure");
   NewFieldNumbers[6] = fnum;
   fnum = mxGetFieldNumber(ElemData,"MapY");
   if(fnum<0)
    mexErrMsgTxt("Required field 'MapY' was not found in the element data structure");
   NewFieldNumbers[7] = fnum;
   fnum = mxGetFieldNumber(ElemData,"NumOfMonoY");
   if(fnum<0)
    mexErrMsgTxt("Required field 'NumOfMonoY' was not found in the element data structure");
   NewFieldNumbers[8] = fnum;
   fnum = mxGetFieldNumber(ElemData,"MapPy");
   if(fnum<0)
    mexErrMsgTxt("Required field 'MapPy' was not found in the element data structure");
   NewFieldNumbers[9] = fnum;
   fnum = mxGetFieldNumber(ElemData,"NumOfMonoPy");
   if(fnum<0)
    mexErrMsgTxt("Required field 'NumOfMonoPy' was not found in the element data structure");
   NewFieldNumbers[10] = fnum;
   fnum = mxGetFieldNumber(ElemData,"MapDelta");
   if(fnum<0)
    mexErrMsgTxt("Required field 'MapDelta' was not found in the element data structure");
   NewFieldNumbers[11] = fnum;
   fnum = mxGetFieldNumber(ElemData,"NumOfMonoDelta");
   if(fnum<0)
    mexErrMsgTxt("Required field 'NumOfMonoDelta' was not found in the element data structure");
   NewFieldNumbers[12] = fnum;
   fnum = mxGetFieldNumber(ElemData,"MapT");
   if(fnum<0)
    mexErrMsgTxt("Required field 'MapT' was not found in the element data structure");
   NewFieldNumbers[13] = fnum;
   fnum = mxGetFieldNumber(ElemData,"NumOfMonoT");
   if(fnum<0)
    mexErrMsgTxt("Required field 'NumOfMonoT' was not found in the element data structure");
   NewFieldNumbers[14] = fnum;
   fnum = mxGetFieldNumber(ElemData,"T1");
   if(fnum<0)
    mexErrMsgTxt("Required field 'T1' was not found in the element data structure");
   NewFieldNumbers[15] = fnum;
   fnum = mxGetFieldNumber(ElemData,"T2");
   if(fnum<0)
    mexErrMsgTxt("Required field 'T2' was not found in the element data structure");
   NewFieldNumbers[16] = fnum;
   fnum = mxGetFieldNumber(ElemData,"R1");
   if(fnum<0)
    mexErrMsgTxt("Required field 'R1' was not found in the element data structure");
   NewFieldNumbers[17] = fnum;
   fnum = mxGetFieldNumber(ElemData,"R2");
   if(fnum<0)
    mexErrMsgTxt("Required field 'R2' was not found in the element data structure");
   NewFieldNumbers[18] = fnum;

   le = mxGetScalar(mxGetFieldByNumber(ElemData,0,NewFieldNumbers[0]));
   no = (int)mxGetScalar(mxGetFieldByNumber(ElemData,0,NewFieldNumbers[1]));
   nv = (int)mxGetScalar(mxGetFieldByNumber(ElemData,0,NewFieldNumbers[2]));
   x = mxGetPr(mxGetFieldByNumber(ElemData,0,NewFieldNumbers[3]));
   nx = (int)mxGetScalar(mxGetFieldByNumber(ElemData,0,NewFieldNumbers[4]));
   px = mxGetPr(mxGetFieldByNumber(ElemData,0,NewFieldNumbers[5]));
   npx = (int)mxGetScalar(mxGetFieldByNumber(ElemData,0,NewFieldNumbers[6]));
   y = mxGetPr(mxGetFieldByNumber(ElemData,0,NewFieldNumbers[7]));
   ny = (int)mxGetScalar(mxGetFieldByNumber(ElemData,0,NewFieldNumbers[8]));
   py = mxGetPr(mxGetFieldByNumber(ElemData,0,NewFieldNumbers[9]));
   npy = (int)mxGetScalar(mxGetFieldByNumber(ElemData,0,NewFieldNumbers[10]));
   delta = mxGetPr(mxGetFieldByNumber(ElemData,0,NewFieldNumbers[11]));
   ndelta = (int)mxGetScalar(mxGetFieldByNumber(ElemData,0,NewFieldNumbers[12]));
   t = mxGetPr(mxGetFieldByNumber(ElemData,0,NewFieldNumbers[13]));
   nt = (int)mxGetScalar(mxGetFieldByNumber(ElemData,0,NewFieldNumbers[14]));
   pt1 = mxGetPr(mxGetFieldByNumber(ElemData,0,NewFieldNumbers[15]));
   pt2 = mxGetPr(mxGetFieldByNumber(ElemData,0,NewFieldNumbers[16]));
   pr1 = mxGetPr(mxGetFieldByNumber(ElemData,0,NewFieldNumbers[17]));
   pr2 = mxGetPr(mxGetFieldByNumber(ElemData,0,NewFieldNumbers[18]));

   returnptr = NewFieldNumbers;
  }
  break;
  case USE_LOCAL_COPY: { /* Get fields from MATLAB using field numbers
                            The second argument ponter to the array of field 
                            numbers is previously created with 
                            QuadLinPass( ..., MAKE_LOCAL_COPY) */
   le = mxGetScalar(mxGetFieldByNumber(ElemData,0,FieldNumbers[0]));
   no = (int)mxGetScalar(mxGetFieldByNumber(ElemData,0,FieldNumbers[1]));
   nv = (int)mxGetScalar(mxGetFieldByNumber(ElemData,0,FieldNumbers[2]));
   x = mxGetPr(mxGetFieldByNumber(ElemData,0,FieldNumbers[3]));
   nx = (int)mxGetScalar(mxGetFieldByNumber(ElemData,0,FieldNumbers[4]));
   px = mxGetPr(mxGetFieldByNumber(ElemData,0,FieldNumbers[5]));
   npx = (int)mxGetScalar(mxGetFieldByNumber(ElemData,0,FieldNumbers[6]));
   y = mxGetPr(mxGetFieldByNumber(ElemData,0,FieldNumbers[7]));
   ny = (int)mxGetScalar(mxGetFieldByNumber(ElemData,0,FieldNumbers[8]));
   py = mxGetPr(mxGetFieldByNumber(ElemData,0,FieldNumbers[9]));
   npy = (int)mxGetScalar(mxGetFieldByNumber(ElemData,0,FieldNumbers[10]));
   delta = mxGetPr(mxGetFieldByNumber(ElemData,0,FieldNumbers[11]));
   ndelta = (int)mxGetScalar(mxGetFieldByNumber(ElemData,0,FieldNumbers[12]));
   t = mxGetPr(mxGetFieldByNumber(ElemData,0,FieldNumbers[13]));
   nt = (int)mxGetScalar(mxGetFieldByNumber(ElemData,0,FieldNumbers[14]));
   pt1 = mxGetPr(mxGetFieldByNumber(ElemData,0,FieldNumbers[15]));
   pt2 = mxGetPr(mxGetFieldByNumber(ElemData,0,FieldNumbers[16]));
   pr1 = mxGetPr(mxGetFieldByNumber(ElemData,0,FieldNumbers[17]));
   pr2 = mxGetPr(mxGetFieldByNumber(ElemData,0,FieldNumbers[18]));
   returnptr = FieldNumbers;
  }
  break;
  default: {
   mexErrMsgTxt("No match for calling mode in function TaylormapPass2\n");
  }
 }
 TaylormapPass2(r_in, le, no, nv, x, nx, px, npx, y, ny, py, npy, delta, ndelta, t, nt,
                    pt1, pt2, pr1, pr2, num_particles);
 return(returnptr);
}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
 int m,n; double *r_in;
 mxArray *tmpmxptr;
 double le;
 int no, nv;
 double *pr1, *pr2, *pt1, *pt2;
 double *x, *px, *y, *py, *t, *delta;
 int nx, npx, ny, npy, nt, ndelta;

 /* ALLOCATE memory for the output array of the same size as the input  */
 m = mxGetM(prhs[1]);
 n = mxGetN(prhs[1]);
 if(m!=6) 
  mexErrMsgTxt("Second argument must be a 6 x N matrix");
 tmpmxptr=mxGetField(prhs[0],0,"Length");
 if(tmpmxptr)
   le = mxGetScalar(tmpmxptr);
 else
   mexErrMsgTxt("Required field 'Length' was not found in the element data structure"); 
 tmpmxptr=mxGetField(prhs[0],0,"Order");
 if(tmpmxptr)
   no = (int)mxGetScalar(tmpmxptr);
 else
   mexErrMsgTxt("Required field 'Order' was not found in the element data structure");
 tmpmxptr=mxGetField(prhs[0],0,"NumOfVariables");
 if(tmpmxptr)
   nv = (int)mxGetScalar(tmpmxptr);
 else
   mexErrMsgTxt("Required field 'NumOfVariables' was not found in the element data structure");
 tmpmxptr=mxGetField(prhs[0],0,"MapX");
 if(tmpmxptr)
   x = mxGetPr(tmpmxptr);
 else
   mexErrMsgTxt("Required field 'MapX' was not found in the element data structure");
 tmpmxptr=mxGetField(prhs[0],0,"NumOfMonoX");
 if(tmpmxptr)
   nx = (int)mxGetScalar(tmpmxptr);
 else
   mexErrMsgTxt("Required field 'NumOfMonoX' was not found in the element data structure");
 tmpmxptr=mxGetField(prhs[0],0,"MapPx");
 if(tmpmxptr)
   px = mxGetPr(tmpmxptr);
 else
   mexErrMsgTxt("Required field 'MapPx' was not found in the element data structure");
 tmpmxptr=mxGetField(prhs[0],0,"NumOfMonoPx");
 if(tmpmxptr)
   npx = (int)mxGetScalar(tmpmxptr);
 else
   mexErrMsgTxt("Required field 'NumOfMonoPx' was not found in the element data structure");
 tmpmxptr=mxGetField(prhs[0],0,"MapY");
 if(tmpmxptr)
   y = mxGetPr(tmpmxptr);
 else
   mexErrMsgTxt("Required field 'MapY' was not found in the element data structure");
 tmpmxptr=mxGetField(prhs[0],0,"NumOfMonoY");
 if(tmpmxptr)
   ny = (int)mxGetScalar(tmpmxptr);
 else
   mexErrMsgTxt("Required field 'NumOfMonoY' was not found in the element data structure");
 tmpmxptr=mxGetField(prhs[0],0,"MapPy");
 if(tmpmxptr)
   py = mxGetPr(tmpmxptr);
 else
   mexErrMsgTxt("Required field 'MapPy' was not found in the element data structure");
 tmpmxptr=mxGetField(prhs[0],0,"NumOfMonoPy");
 if(tmpmxptr)
   npy = (int)mxGetScalar(tmpmxptr);
 else
   mexErrMsgTxt("Required field 'NumOfMonoPy' was not found in the element data structure");
 tmpmxptr=mxGetField(prhs[0],0,"MapDelta");
 if(tmpmxptr)
   delta = mxGetPr(tmpmxptr);
 else
   mexErrMsgTxt("Required field 'MapDelta' was not found in the element data structure");
 tmpmxptr=mxGetField(prhs[0],0,"NumOfMonoDelta");
 if(tmpmxptr)
   ndelta = (int)mxGetScalar(tmpmxptr);
 else
   mexErrMsgTxt("Required field 'NumOfMonoDelta' was not found in the element data structure");
 tmpmxptr=mxGetField(prhs[0],0,"MapT");
 if(tmpmxptr)
   t = mxGetPr(tmpmxptr);
 else
   mexErrMsgTxt("Required field 'MapT' was not found in the element data structure");
 tmpmxptr=mxGetField(prhs[0],0,"NumOfMonoT");
 if(tmpmxptr)
   nt = (int)mxGetScalar(tmpmxptr);
 else
   mexErrMsgTxt("Required field 'NumOfMonoT' was not found in the element data structure");
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
 TaylormapPass2(r_in, le, no, nv, x, nx, px, npx, y, ny, py, npy, delta, ndelta, t, nt,
                    pt1, pt2, pr1, pr2, n);
}
