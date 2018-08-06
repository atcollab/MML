#include <stdio.h>
#include <nslsc.h>
#include <ucode_def.h>
#include <umacro_v2.h>

#define N_MAX 256


int sgn(float x)
{
  if (x >= 0.0)
    return(1);
  else if (x == 0.0)
    return(0);
  else
    return(-1);
}

main(int argc, char *argv[])
{
  int       k, stpt[N_MAX], ndev, status;
  DEV_NAME  devnames[N_MAX];
  float     gain[N_MAX], offs[N_MAX], val;

  ndev = argc/2;
  if((argc < 2) || (argc % 2 == 0)) {
    printf("*** Incorrect number of args\n"); exit(0);
  } else {
    for(k=0; k < ndev; k++) {
      sscanf(argv[2*k+1], "%s", devnames[k]);
      sscanf(argv[2*k+2], "%f", &val);      
      ugddr_getcalib_data(devnames[k], &gain[k], &offs[k]);
      stpt[k] = (int)(val/gain[k]+sgn(val)*0.5);
      printf("name=%s, value=%d gain=%e\n", devnames[k], stpt[k], gain[k]) ;
    }
  }

  if(uidopen("Ctest")) {
    ucdperror(); exit(1);
  }
  status = usetmag(argc/2, devnames, stpt); 
  printf("%d\n", status);
  uclose();
}
