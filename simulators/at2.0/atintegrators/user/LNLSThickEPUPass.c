/* LNLSThickEPUPass.c
   Accelerator Toolbox 
   ximenes@lnls.br
*/

#define _USE_MATH_DEFINES

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>
#include "mex.h"
#include "elempass.h"
#include "atlalib.c"


    
void fill(double *pout, double *pin, int m, int n, int nr_steps)
{ int i, j;
  for (i=0; i<m; i++) {
     for (j=0; j<n; j++) {
        pout[i+j*m] = pin[i+j*m] / nr_steps;
     }
  }
}

void fastdrift(double* r, double NormL)

/*   NormL=(Physical Length)/(1+delta)  is computed externally to speed up calculations
     in the loop if momentum deviation (delta) does not change
     such as in 4-th order symplectic integrator w/o radiation
*/

{   double dx = NormL*r[1];
    double dy = NormL*r[3];
    r[0]+= dx;
    r[2]+= dy;
    r[5]+= NormL*(r[1]*r[1]+r[3]*r[3])/(2*(1+r[4]));
}


        
void interpolate_kickmap(int nx, int ny, double *XEPU, double *YEPU, double *PXEPU, double *PYEPU, double x, double y, double *xkick, double *ykick) {
    int    ix, iy;
    double xmin, xmax, ymin, ymax;
    double x1, x2, y1, y2;
    double fq11, fq12, fq21, fq22, fR1, fR2, fP;
    
    /* min and max values */
    iy=0;ix=0;    xmin = XEPU[iy+ix*ny];
    iy=0;ix=nx-1; xmax = XEPU[iy+ix*ny];
    iy=0;ix=0;    ymin = YEPU[iy+ix*ny];
    iy=ny-1;ix=0; ymax = YEPU[iy+ix*ny];
       
    /* indices */
    ix = (int) ((x - xmin) / ((xmax - xmin) / (nx - 1)) );
    iy = (int) ((y - ymin) / ((ymax - ymin) / (ny - 1)) );
    if ((ix < 0) || (ix >= nx) || (iy < 0) || (iy >= ny)) {
        *xkick = *ykick = tan(M_PI/2);
        return;
    }
    
    /* coordinates */
    x1  = XEPU[0+ix*ny];
    x2  = XEPU[0+(ix+1)*ny];
    y1  = YEPU[iy+0*ny];
    y2  = YEPU[(iy+1)+0*ny];
    
    /* xkick */
    fq11 = PXEPU[iy+ix*ny];
    fq21 = PXEPU[iy+(ix+1)*ny];
    fq12 = PXEPU[(iy+1)+ix*ny];
    fq22 = PXEPU[(iy+1)+(ix+1)*ny];
    fR1 = ((x2 - x) * fq11 + (x - x1) * fq21) / (x2 - x1);
    fR2 = ((x2 - x) * fq12 + (x - x1) * fq22) / (x2 - x1);
    fP  = ((y2 - y) * fR1 + (y - y1) * fR2) / (y2 - y1);
    *xkick = fP;
    
    /* ykick */
    fq11 = PYEPU[iy+ix*ny];
    fq21 = PYEPU[iy+(ix+1)*ny];
    fq12 = PYEPU[(iy+1)+ix*ny];
    fq22 = PYEPU[(iy+1)+(ix+1)*ny];
    fR1 = ((x2 - x) * fq11 + (x - x1) * fq21) / (x2 - x1);
    fR2 = ((x2 - x) * fq12 + (x - x1) * fq22) / (x2 - x1);
    fP  = ((y2 - y) * fR1 + (y - y1) * fR2) / (y2 - y1);
    *ykick = fP;
    
    /*
    *xkick = ix;
    *ykick = iy;
    */
    
}

void LNLSThickEPUPass(double *r, double E, double le, int nr_steps, int nx, int ny, double *XEPU, double *YEPU, double *PXEPU, double *PYEPU,
                 double *R1, double *R2, double *T1, double *T2, int num_particles)

{ 

  const double constc = 299792458;
  const double E0     = 0.51099892811;

  int c, i;
  double *r6, *xi, *yi;   
  char *method;
  int buflen;
  double xkick, ykick, gam, beta, brho, L1, norm, NormL1;
  int num_in, num_out;
  

  gam = (E/1e9) / (E0/1000);
  beta  = sqrt(1 - 1/(gam*gam));
  brho = beta * E / constc;
  
  num_in = 6;
  num_out = 1;
  xi = (double*)mxCalloc(1,sizeof(double));
  yi = (double*)mxCalloc(1,sizeof(double));
  
  /*
  mexPrintf(" method = ");
  for(c = 0;c<buflen;c++) {
    
  }
  mexPrintf("\n");
  */
  L1 = le / (2.0 * nr_steps);
  
  for (c = 0;c<num_particles;c++){/* Loop over particles */
     
      r6 = r+c*6;
     
     /* linearized misalignment transformation at the entrance */
     ATaddvv(r6,T1);
     ATmultmv(r6,R1);
     
     norm = 1/(1+r6[4]);
     NormL1 = L1*norm;
     for(i = 0; i<nr_steps; ++i) { /* loog over integration step */
		 fastdrift(r6, NormL1);
         interpolate_kickmap(nx, ny, XEPU, YEPU, PXEPU, PYEPU, r6[0], r6[2], &xkick, &ykick);    
         /* r6[1] += (xkick/nr_steps) / (brho * brho);
         r6[3] += (ykick/nr_steps) / (brho * brho); */
         r6[1] += (xkick/nr_steps) / (brho * brho) / (1+r6[4]); /* as with tracysoleil */
         r6[3] += (ykick/nr_steps) / (brho * brho) / (1+r6[4]); /* as with tracysoleil */                                              
         fastdrift(r6, NormL1);
     }
           
     /* linearized misalignment transformation at the exit */
     ATmultmv(r6,R2);
     ATaddvv(r6,T2);
     
  }
  
}

ExportMode int* passFunction(const mxArray *ElemData, int *FieldNumbers,
double *r_in, int num_particles, int mode)

#define NUM_FIELDS_2_REMEMBER 13
{
  double  le, E;
  int     nx, ny, nr_steps;
  double  *XEPU, *YEPU, *PXEPU, *PYEPU;
  double  *pr1, *pr2, *pt1, *pt2;
  int     *returnptr;
  int     *NewFieldNumbers,fnum;
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
        
	tmpmxptr=mxGetField(ElemData,0,"Energy");
        if(tmpmxptr) {
           E = mxGetScalar(tmpmxptr);
           returnptr = NULL;
        }
        else
           mexErrMsgTxt("Required field 'Energy' was not found in the element data structure");
		   
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
        tmpmxptr =mxGetField(ElemData,0,"NumIntSteps");
        if(tmpmxptr) { 
           nr_steps = (int)mxGetScalar(tmpmxptr);
           returnptr = NULL;
        }
        else
           mexErrMsgTxt("Required field 'NumIntSteps' was not found in the element data structure");
	
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
	fnum = mxGetFieldNumber(ElemData,"Energy");
        if(fnum<0)
           mexErrMsgTxt("Required field 'Energy' was not found in the element data structure");
        NewFieldNumbers[11] = fnum;
	fnum = mxGetFieldNumber(ElemData,"NumIntSteps");
        if(fnum<0)
           mexErrMsgTxt("Required field 'NumIntSteps' was not found in the element data structure");
        NewFieldNumbers[12] = fnum;
	

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
	E = mxGetScalar(mxGetFieldByNumber(ElemData,0,NewFieldNumbers[11]));
	nr_steps = mxGetScalar(mxGetFieldByNumber(ElemData,0,NewFieldNumbers[12]));

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
	E = mxGetScalar(mxGetFieldByNumber(ElemData,0,FieldNumbers[11]));
	nr_steps = mxGetScalar(mxGetFieldByNumber(ElemData,0,FieldNumbers[12]));
        returnptr = FieldNumbers;
     }
     break;
     default: {
        mexErrMsgTxt("No match for calling mode in function ThickEPUPass\n");
     }
  }
  LNLSThickEPUPass(r_in, E, le, nr_steps, nx, ny, XEPU, YEPU, PXEPU, PYEPU, pr1, pr2, pt1, pt2, num_particles);

  return(returnptr);
}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
  int m,n;
  double *r_in;
  mxArray *tmpmxptr;
  double le, E;
  int nx, ny, nr_steps;
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
  tmpmxptr = mxGetField(prhs[0],0,"Energy");
  if(tmpmxptr)
     E = mxGetScalar(tmpmxptr);
  else
     mexErrMsgTxt("Required field 'Energy' was not found in the element data structure");
  tmpmxptr = mxGetField(prhs[0],0,"NumIntSteps");
  if(tmpmxptr)
     nr_steps = (int)mxGetScalar(tmpmxptr);
  else
     mexErrMsgTxt("Required field 'NumIntSteps' was not found in the element data structure");
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
  LNLSThickEPUPass(r_in, E, le, nr_steps, nx, ny, XEPU, YEPU, PXEPU, PYEPU, pr1, pr2, pt1, pt2, n);
}
