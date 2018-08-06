#include "mex.h"
#include <string.h>

#define NUMBER_OF_STRUCTS (sizeof(friends)/sizeof(struct phonebook))
#define NUMBER_OF_FIELDS (sizeof(field_names)/sizeof(*field_names))

struct phonebook
{ const char *name;
  double phone;
};

void mexFunction(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{ const char *field_names[] = {"name","phone"};
  struct phonebook friends[] = {{"Jordan Robert",3386},{"Mary Smith",3912},
                                {"Stacy Flora",3238},{"Harry Alpert",3077}
                               };
  int dims[2] = {1,NUMBER_OF_STRUCTS};
  int i,name_field,phone_field;

  if(nrhs !=0) { mexErrMsgTxt("No input argument required."); } 
  if(nlhs > 1) { mexErrMsgTxt("Too many output arguments."); }
  plhs[0] = mxCreateStructArray(2,dims,NUMBER_OF_FIELDS,field_names);
  name_field = mxGetFieldNumber(plhs[0],"name");
  phone_field = mxGetFieldNumber(plhs[0],"phone");
  
  for(i=0;i<NUMBER_OF_STRUCTS; i++)
  { mxArray *field_value;
    mxSetFieldByNumber(plhs[0],i,name_field,mxCreateString(friends[i].name));
    field_value = mxCreateDoubleMatrix(1,1,mxREAL);
    *mxGetPr(field_value) = friends[i].phone;
    mxSetFieldByNumber(plhs[0],i,phone_field,field_value);
  }
}
