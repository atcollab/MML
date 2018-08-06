#include <stdio.h>
#include <nslsc.h>

#define N_MAX 256


main(int argc, char *argv[])
{
  int       i, ndev, stpt[N_MAX], rdbk[N_MAX];
  DEV_NAME  devnames[N_MAX];
  float     gain[N_MAX], offs[N_MAX];

  if( argc == 1 ) {
    ndev = 1;
    strcpy(devnames[0], "uvcurr");
  } else {
    ndev = argc -1;
    for(i = 0; i < ndev; i++) {
      strcpy(devnames[i], argv[i+1]);
    }
  }
  for(i = 0; i < ndev; i++) {
    ugddr_getcalib_data(devnames[i], &gain[i], &offs[i]);
  }

  if(uidopen("Ctest")) {
    ucdperror(); exit(1);
  }
  if(ureadsetp(ndev, devnames, stpt) || ureadmag(ndev, devnames, rdbk)) {
    fprintf(stderr, "*** ");
    ucdperror();
  } else {
    for(i = 0; i < ndev; i++)
      printf("%e %e %e\n", stpt[i]*gain[i], rdbk[i]*gain[i], gain[i]);
  }
  uclose();
}
