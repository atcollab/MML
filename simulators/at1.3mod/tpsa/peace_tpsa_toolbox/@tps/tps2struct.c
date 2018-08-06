/* tps2struct.c --- Pack/Unpack variable to/from a class TPS
   MATLAB usage: [n o c] = tps2struct(t)
   MATLAB usage: t = tps2struct(n,o,c)
   It cost a lot in building the API between MATLAB and C!
   For simple calculation, the C code may get no gain of efficiency.
*/

/*
#include <stdio.h>
#include <stdlib.h>
*/
#include "mex.h"
#include <string.h>

void mexFunction(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{ int nfields,i,j;
  char cmd[100],tmp[10];
  const char *ans = "ans";
  const char *fnames[3] = {"n","o","c"};
  
  if(nrhs == 0) mexErrMsgTxt("Input arguments required.");
  else if(nrhs == 1) /* Unpack */
  { if(!mxIsStruct(prhs[0])) mexErrMsgTxt("Single input must be a TPS structure.");
    else if(mxGetNumberOfElements(prhs[0]) != 1)
    { mexErrMsgTxt("Single input must be a TPS structure."); }

    nfields = mxGetNumberOfFields(prhs[0]);
    if(nlhs == 0)
    { for(i=0;i<nfields;i++)
      { strcpy(cmd,mxGetFieldNameByNumber(prhs[0],i));
        strcat(cmd,"=");
        strcat(cmd,mxGetName(prhs[0]));
        strcat(cmd,".");
        strcat(cmd,mxGetFieldNameByNumber(prhs[0],i));
        mexEvalString(cmd);
      }
    }
    else
    { j = (nlhs < nfields) ? nlhs : nfields;
      for(i=0;i<j;i++)
      { plhs[i] = mxDuplicateArray(mxGetFieldByNumber(prhs[0],0,i)); }
    }
  }
  else /* Pack */
  { if(nrhs != 3) mexErrMsgTxt("Three input arguments required.");
    else
    { plhs[0] = mxCreateStructMatrix(1,1,3,fnames);
      for(i=0;i<nrhs;i++)
      { mxSetFieldByNumber(plhs[0],0,i,mxDuplicateArray(prhs[i])); }
      strcpy(cmd,mxGetName(plhs[0]));
      strcat(cmd," = class(");
      strcat(cmd,mxGetName(prhs[0]));
      strcat(cmd,",'TPS')");
      mexEvalString(cmd);
    }
  }
}
