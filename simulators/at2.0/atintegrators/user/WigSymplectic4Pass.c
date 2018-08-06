/* WigSymplectic4Pass.c 
   Accelerator Toolbox 
   Created on 11/06/2002
   W. Wan wwan@lbl.gov 
   Modified 01/12/04 by
   L. Nadolski
   for speed optimization: 15% increase
   */

#include "mex.h"
#include<stdio.h>
#include<math.h>
#include "atlalib.c"
#include "elempass.h"

/* Constants of 4th order symplectic integrator obtained using Mathematica
   with 23 digits precision */

#define PI        3.141592653589793
#define TWOPI     6.28318530717959
#define PIo180    0.01745329251994  /* PI/180*/
#define KICK1     1.3512071919596576340477 /* For Yoshida integration scheme */
#define KICK2    -1.7024143839193152680954

void CompAy(double z, double* r, int nz, int nx, double *b, double* lambdaz,
            double *phasez, double *kx, double *Ay, double *Ayp) 

{
/*   Computing vector potential Ay and int_y(dAy/dx) */
 int i, j;
 double ky, kz, phi, sinkz, kxr0, kyr2, kxx, bkzoky;

 i  = 0;
 j  = 0;
 ky = 0.0;
 kz = 0.0;
 *Ay  = 0.0;
 *Ayp = 0.0;

 for(i = 0; i < nz; i++) {
  kz = TWOPI/lambdaz[i];
  /* phi = phasez[i]*PI/180; */
  phi = phasez[i]*PIo180;
  
  for(j = 0; j < nx; j++) {
   
   kxx = kx[i+j*nz];
   ky = sqrt(kxx*kxx + kz*kz);
   sinkz = sin(kz*z+phi);
   kxr0 = kxx*r[0];
   kyr2 = ky*r[2];
   bkzoky= b[i+j*nz]*kz/ky;
   
   if (fabs(kxx)>1e-5) {
    *Ay += -bkzoky/kxx*sin(kxr0)*sinh(kyr2)*sinkz;
   }
   else {
    *Ay += -bkzoky*r[0]*sinh(kyr2)*sinkz;
   }
   *Ayp += -bkzoky/ky*cos(kxr0)*(cosh(kyr2)-1.0)*sinkz;
/*
   if (fabs(r[2])>0) {
    printf("i = %d, j = %d, z = %g, x = %g, y = %g\n", i, j, z, r[0], r[2]);
    printf("kx = %g, ky = %g, kz = %g, b = %g\n", kx[i+j*nz], ky, kz, b[i+j*nz]);
   }
*/
  }
 }
/*
 if (fabs(r[2])>0) {
  printf("Message #1: Ay = %g, Ayp = %g\n", *Ay, *Ayp);
 }
*/
}

void CompDAz(double z, double* r, int nz, int nx, double *b, double* lambdaz,
             double *phasez, double *kx, double *Azpx, double *Azpy) {
/*   Computing vector potential dAz/dx and dAz/dy */
 int i, j;
 double ky, kz, phi, coskz, kxx, kxr0, kyr2, bky;

 i  = 0;
 j  = 0;
 ky = 0.0;
 kz = 0.0;
 *Azpx = 0.0;
 *Azpy = 0.0;
 
 for(i = 0; i < nz; i++) {
  kz = TWOPI/lambdaz[i];
/*  phi = phasez[i]*PI/180; */
  phi = phasez[i]*PIo180;
  
  for(j = 0;j<nx;j++) {
   
   kxx = kx[i+j*nz];
   kxr0 = kxx*r[0];
   ky = sqrt(kxx*kxx+kz*kz);
   kyr2 = ky*r[2];
   bky = b[i+j*nz]*ky;
   coskz = cos(kz*z+phi); 
   
   *Azpx += -b[i+j*nz]*cos(kxr0)*cosh(kyr2)*coskz;
   if (fabs(kxx)>1e-5) {
    *Azpy += -bky/kxx*sin(kxr0)*sinh(kyr2)*coskz;
   }
   else {
    *Azpy += -bky*r[0]*sinh(kyr2)*coskz;
   }
/*
   if (fabs(r[2])>0) {
    printf("i = %d, j = %d, z = %g, x = %g, y = %g\n", i, j, z, r[0], r[2]);
    printf("kx = %g, ky = %g, kz = %g, b = %g, phasez = %g\n", kx[i+j*nz], ky, kz, b[i+j*nz], phasez[i]);
   }
*/
  }
 }
/*
 if (fabs(r[2])>0) {
   printf("Message #1: Azpx = %g, Azpy = %g\n", *Azpx, *Azpy);
 }
*/
}

void DriftX(double* r, double L) {
/*   Input parameter L is the physical length
     1/(1+delta) normalization is done internally
*/
 double p_norm, NormL;

 p_norm = 1.0/(1.0+r[4]);
 NormL  = L*p_norm;
 r[0] += NormL*r[1];
 r[5] += NormL*p_norm*r[1]*r[1]*0.5;
}

void DriftY(double z, double* r, double L, int nz, int nx,
            double *b, double* lambdaz, double *phasez, double* kx) {
/*   Input parameter L is the physical length
     1/(1+delta) normalization is done internally
*/
 double p_norm, NormL;
 double Ay, Ayp;

 Ay  = 0.0;
 Ayp = 0.0;
 CompAy(z, r, nz, nx, b, lambdaz, phasez, kx, &Ay, &Ayp);
/*
 if (fabs(r[2])>0) {
   printf("Message #2: Ay = %g, Ayp = %g\n", Ay, Ayp);
 }
*/
 r[1] -= Ayp;
 r[3] -= Ay;
 p_norm = 1.0/(1.0+r[4]);
 NormL  = L*p_norm;
 r[2] += NormL*r[3];
 r[5] += NormL*p_norm*r[3]*r[3]*0.5;
 CompAy(z, r, nz, nx, b, lambdaz, phasez, kx, &Ay, &Ayp);
/*
 if (fabs(r[2])>0) {
   printf("Message #2: Ay = %g, Ayp = %g\n", Ay, Ayp);
 }
*/
 r[1]+= Ayp;
 r[3]+= Ay;
}

void Kick(double z, double* r, double L, int nz, int nx,
            double *b, double* lambdaz, double *phasez, double* kx) {
 double Azpx, Azpy;

 Azpx = 0.0;
 Azpy = 0.0;
 CompDAz(z, r, nz, nx, b, lambdaz, phasez, kx, &Azpx, &Azpy);
/*
 if (fabs(r[2])>0) {
   printf("Message #2: Azpx = %g, Azpy = %g\n", Azpx, Azpy);
 }
*/
 r[1]+= L*Azpx;
 r[3]+= L*Azpy;
}

void WigSymplectic4Pass(double *r_in, double le, int nz, int nx, double *b,
                        double* lambdaz, double *phasez, double* kx,
                        int num_int_steps,
                        double *T1, double *T2,
                        double *R1, double *R2, int num_particles)
/*
   r_in -- 6-by-N matrix of initial conditions reshaped into 
           1-d array of 6*N elements 
   le -- physical length
   nz -- number of longitudinal harmonocs
   nx -- number of transverse harmonics for each longitudinal harmonics
   b -- peak magnetic field of each longitudinal harmonics
   lambdaz -- wavelength of each longitudinal harmonics
   phasez -- phase of each longitudinal harmonics
   kx -- wave number of each transverse harmonics
   num_int_steps -- number of slices
   T1 -- 6 x 1 translation at entrance
   T2 -- 6 x 1 translation at exit
   R1 -- 6 x 6 rotation matrix at the entrance
   R2 -- 6 x 6 rotation matrix at the exit
*/
{
 int c, m;
 double *r6;
 double SL, L1, L2, K1, K2, L1pL2;
 double z;

 SL = le/num_int_steps;
 K1 = SL*KICK1;
 K2 = SL*KICK2;
 L1 = K1*0.5;
 L2 = K2*0.5;
 L1pL2 = L1+L2;

 for(c = 0;c<num_particles;c++) {
  r6 = r_in+c*6;

  /* linearized misalignment transformation at the entrance */
  ATaddvv(r6,T1);
  ATmultmv(r6,R1);

  /* integrator */
  /* for speed optimization: condensed driftX */
  
   DriftX(r6, L1);
   z = L1;
  
  /** this is valid if at least two slides **/
  for(m = 0; m < num_int_steps-1; m++) { /* Loop over slices */
   DriftY(z, r6, L1, nz, nx, b, lambdaz, phasez, kx);
   Kick(z, r6, K1, nz, nx, b, lambdaz, phasez, kx);
   DriftY(z, r6, L1, nz, nx, b, lambdaz, phasez, kx);
   DriftX(r6, L1pL2);
   z += L1pL2;
   DriftY(z, r6, L2, nz, nx, b, lambdaz, phasez, kx);
   Kick(z, r6, K2, nz, nx, b, lambdaz, phasez, kx);
   DriftY(z, r6, L2, nz, nx, b, lambdaz, phasez, kx);
   DriftX(r6, L1pL2);
   z += L1pL2;
   DriftY(z, r6, L1, nz, nx, b, lambdaz, phasez, kx);
   Kick(z, r6, K1, nz, nx, b, lambdaz, phasez, kx);
   DriftY(z, r6, L1, nz, nx, b, lambdaz, phasez, kx);
   DriftX(r6, K1); /* since K1=2*L1*/
   z += K1;
  }
  /* last slice */
   DriftY(z, r6, L1, nz, nx, b, lambdaz, phasez, kx);
   Kick(z, r6, K1, nz, nx, b, lambdaz, phasez, kx);
   DriftY(z, r6, L1, nz, nx, b, lambdaz, phasez, kx);
   DriftX(r6, L1pL2);
   z += L1pL2;
   DriftY(z, r6, L2, nz, nx, b, lambdaz, phasez, kx);
   Kick(z, r6, K2, nz, nx, b, lambdaz, phasez, kx);
   DriftY(z, r6, L2, nz, nx, b, lambdaz, phasez, kx);
   DriftX(r6, L1pL2);
   z += L1pL2;
   DriftY(z, r6, L1, nz, nx, b, lambdaz, phasez, kx);
   Kick(z, r6, K1, nz, nx, b, lambdaz, phasez, kx);
   DriftY(z, r6, L1, nz, nx, b, lambdaz, phasez, kx);
   DriftX(r6, L1);
   z += L1; 

  /* linearized misalignment transformation at the exit */
  ATmultmv(r6,R2);
  ATaddvv(r6,T2);
 }
}

ExportMode int* passFunction(const mxArray *ElemData,int *FieldNumbers,
                             double *r_in, int num_particles, int mode)

#define NUM_FIELDS_2_REMEMBER 12
{
 int *returnptr;
 int fnum, *NewFieldNumbers;
 mxArray *tmpmxptr;
 double le;
 double *pr1, *pr2, *pt1, *pt2;
 int num_int_steps;
 int nz, nx;
 double *b, *lambdaz, *phasez, *kx;

 switch(mode) {
  case NO_LOCAL_COPY: { /* Get fields by names from MATLAB workspace  */
   tmpmxptr=mxGetField(ElemData,0,"Length");
   if(tmpmxptr) {
    le = mxGetScalar(tmpmxptr);
    returnptr = NULL;
   }
   else
    mexErrMsgTxt("Required field 'Length' was not found in the element data structure"); 
   tmpmxptr=mxGetField(ElemData,0,"NumOfLongHarm");
   if(tmpmxptr) {
    nz = (int)mxGetScalar(tmpmxptr);
    returnptr = NULL;
   }
   else
    mexErrMsgTxt("Required field 'NumOfLongHarm' was not found in the element data structure");
   tmpmxptr=mxGetField(ElemData,0,"NumOfTranHarm");
   if(tmpmxptr) {
    nx = (int)mxGetScalar(tmpmxptr);
    returnptr = NULL;
   }
   else
    mexErrMsgTxt("Required field 'NumOfTranHarm' was not found in the element data structure");
   tmpmxptr=mxGetField(ElemData,0,"Bfield");
   if(tmpmxptr) {
    b = mxGetPr(tmpmxptr);
    returnptr = NULL;
   }
   else
    mexErrMsgTxt("Required field 'Bfield' was not found in the element data structure");
   tmpmxptr=mxGetField(ElemData,0,"Lambdaz");
   if(tmpmxptr) {
    lambdaz = mxGetPr(tmpmxptr);
    returnptr = NULL;
   }
   else
    mexErrMsgTxt("Required field 'Lambdaz' was not found in the element data structure");
   tmpmxptr=mxGetField(ElemData,0,"Phasez");
   if(tmpmxptr) {
    phasez = mxGetPr(tmpmxptr);
    returnptr = NULL;
   }
   else
    mexErrMsgTxt("Required field 'Phasez' was not found in the element data structure");
   tmpmxptr=mxGetField(ElemData,0,"Kx");
   if(tmpmxptr) {
    kx = mxGetPr(tmpmxptr);
    returnptr = NULL;
   }
   else
    mexErrMsgTxt("Required field 'Kx' was not found in the element data structure");
   tmpmxptr=mxGetField(ElemData,0,"NumIntSteps");
   if(tmpmxptr) {
    num_int_steps = (int)mxGetScalar(tmpmxptr);
    returnptr = NULL;
   }
   else
    mexErrMsgTxt("Required field 'NumIntSteps' was not found in the element data structure");
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
   fnum = mxGetFieldNumber(ElemData,"NumOfLongHarm");
   if(fnum<0)
    mexErrMsgTxt("Required field 'NumOfLongHarm' was not found in the element data structure");
   NewFieldNumbers[1] = fnum;
   fnum = mxGetFieldNumber(ElemData,"NumOfTranHarm");
   if(fnum<0)
    mexErrMsgTxt("Required field 'NumOfTranHarm' was not found in the element data structure");
   NewFieldNumbers[2] = fnum;
   fnum = mxGetFieldNumber(ElemData,"Bfield");
   if(fnum<0)
    mexErrMsgTxt("Required field 'Bfield' was not found in the element data structure");
   NewFieldNumbers[3] = fnum;
   fnum = mxGetFieldNumber(ElemData,"Lambdaz");
   if(fnum<0)
    mexErrMsgTxt("Required field 'Lambdaz' was not found in the element data structure");
   NewFieldNumbers[4] = fnum;
   fnum = mxGetFieldNumber(ElemData,"Phasez");
   if(fnum<0)
    mexErrMsgTxt("Required field 'Phasez' was not found in the element data structure");
   NewFieldNumbers[5] = fnum;
   fnum = mxGetFieldNumber(ElemData,"Kx");
   if(fnum<0)
    mexErrMsgTxt("Required field 'Kx' was not found in the element data structure");
   NewFieldNumbers[6] = fnum;
   fnum = mxGetFieldNumber(ElemData,"NumIntSteps");
   if(fnum<0)
    mexErrMsgTxt("Required field 'NumIntSteps' was not found in the element data structure");
   NewFieldNumbers[7] = fnum;
   fnum = mxGetFieldNumber(ElemData,"T1");
   if(fnum<0)
    mexErrMsgTxt("Required field 'T1' was not found in the element data structure");
   NewFieldNumbers[8] = fnum;
   fnum = mxGetFieldNumber(ElemData,"T2");
   if(fnum<0)
    mexErrMsgTxt("Required field 'T2' was not found in the element data structure");
   NewFieldNumbers[9] = fnum;
   fnum = mxGetFieldNumber(ElemData,"R1");
   if(fnum<0)
    mexErrMsgTxt("Required field 'R1' was not found in the element data structure");
   NewFieldNumbers[10] = fnum;
   fnum = mxGetFieldNumber(ElemData,"R2");
   if(fnum<0)
    mexErrMsgTxt("Required field 'R2' was not found in the element data structure");
   NewFieldNumbers[11] = fnum;

   le = mxGetScalar(mxGetFieldByNumber(ElemData,0,NewFieldNumbers[0]));
   nz = (int)mxGetScalar(mxGetFieldByNumber(ElemData,0,NewFieldNumbers[1]));
   nx = (int)mxGetScalar(mxGetFieldByNumber(ElemData,0,NewFieldNumbers[2]));
   b = mxGetPr(mxGetFieldByNumber(ElemData,0,NewFieldNumbers[3]));
   lambdaz = mxGetPr(mxGetFieldByNumber(ElemData,0,NewFieldNumbers[4]));
   phasez = mxGetPr(mxGetFieldByNumber(ElemData,0,NewFieldNumbers[5]));
   kx = mxGetPr(mxGetFieldByNumber(ElemData,0,NewFieldNumbers[6]));
   num_int_steps = (int)mxGetScalar(mxGetFieldByNumber(ElemData,0,NewFieldNumbers[7]));
   pt1 = mxGetPr(mxGetFieldByNumber(ElemData,0,NewFieldNumbers[8]));
   pt2 = mxGetPr(mxGetFieldByNumber(ElemData,0,NewFieldNumbers[9]));
   pr1 = mxGetPr(mxGetFieldByNumber(ElemData,0,NewFieldNumbers[10]));
   pr2 = mxGetPr(mxGetFieldByNumber(ElemData,0,NewFieldNumbers[11]));

   returnptr = NewFieldNumbers;
  }
  break;
  case USE_LOCAL_COPY: { /* Get fields from MATLAB using field numbers
                            The second argument ponter to the array of field 
                            numbers is previously created with 
                            QuadLinPass( ..., MAKE_LOCAL_COPY) */
   le = mxGetScalar(mxGetFieldByNumber(ElemData,0,FieldNumbers[0]));
   nz = (int)mxGetScalar(mxGetFieldByNumber(ElemData,0,FieldNumbers[1]));
   nx = (int)mxGetScalar(mxGetFieldByNumber(ElemData,0,FieldNumbers[2]));
   b = mxGetPr(mxGetFieldByNumber(ElemData,0,FieldNumbers[3]));
   lambdaz = mxGetPr(mxGetFieldByNumber(ElemData,0,FieldNumbers[4]));
   phasez = mxGetPr(mxGetFieldByNumber(ElemData,0,FieldNumbers[5]));
   kx = mxGetPr(mxGetFieldByNumber(ElemData,0,FieldNumbers[6]));
   num_int_steps = (int)mxGetScalar(mxGetFieldByNumber(ElemData,0,FieldNumbers[7]));
   pt1 = mxGetPr(mxGetFieldByNumber(ElemData,0,FieldNumbers[8]));
   pt2 = mxGetPr(mxGetFieldByNumber(ElemData,0,FieldNumbers[9]));
   pr1 = mxGetPr(mxGetFieldByNumber(ElemData,0,FieldNumbers[10]));
   pr2 = mxGetPr(mxGetFieldByNumber(ElemData,0,FieldNumbers[11]));
   returnptr = FieldNumbers;
  }
  break;
  default: {
   mexErrMsgTxt("No match for calling mode in function WigSymplectic4Pass\n");
  }
 }
 WigSymplectic4Pass(r_in, le, nz, nx, b, lambdaz, phasez, kx, num_int_steps,
                    pt1, pt2, pr1, pr2, num_particles);
 return(returnptr);
}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
 int m,n; double *r_in;
 mxArray *tmpmxptr;
 double le;
 double *pr1, *pr2, *pt1, *pt2;
 int num_int_steps;
 int nz, nx;
 double *b, *lambdaz, *phasez, *kx;

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
 tmpmxptr=mxGetField(prhs[0],0,"NumOfLongHarm");
 if(tmpmxptr)
   nz = (int)mxGetScalar(tmpmxptr);
 else
   mexErrMsgTxt("Required field 'NumOfLongHarm' was not found in the element data structure");
 tmpmxptr=mxGetField(prhs[0],0,"NumOfTranHarm");
 if(tmpmxptr)
   nx = (int)mxGetScalar(tmpmxptr);
 else
   mexErrMsgTxt("Required field 'NumOfTranHarm' was not found in the element data structure");
 tmpmxptr=mxGetField(prhs[0],0,"Bfield");
 if(tmpmxptr)
   b = mxGetPr(tmpmxptr);
 else
   mexErrMsgTxt("Required field 'Bfield' was not found in the element data structure");
 tmpmxptr=mxGetField(prhs[0],0,"Lambdaz");
 if(tmpmxptr)
   lambdaz = mxGetPr(tmpmxptr);
 else
   mexErrMsgTxt("Required field 'Lambdaz' was not found in the element data structure");
 tmpmxptr=mxGetField(prhs[0],0,"Phasez");
 if(tmpmxptr)
   phasez = mxGetPr(tmpmxptr);
 else
   mexErrMsgTxt("Required field 'Phasez' was not found in the element data structure");
 tmpmxptr=mxGetField(prhs[0],0,"Kx");
 if(tmpmxptr)
   kx = mxGetPr(tmpmxptr);
 else
   mexErrMsgTxt("Required field 'Kx' was not found in the element data structure");
 tmpmxptr=mxGetField(prhs[0],0,"NumIntSteps");
 if(tmpmxptr)
   num_int_steps = (int)mxGetScalar(tmpmxptr);
 else
   mexErrMsgTxt("Required field 'NumIntSteps' was not found in the element data structure");
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
 WigSymplectic4Pass(r_in, le, nz, nx, b, lambdaz, phasez, kx, num_int_steps,
                    pt1, pt2, pr1, pr2, n);
}
