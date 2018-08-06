#include <stdio.h>
#include <nslsc.h>
#include <ucode_def.h>
#include <umacro_v2.h>
#include <time.h>

/*
nslsc.h:#define DEV_NAMELEN   16
nslsc.h:typedef char DEV_NAME[DEV_NAMELEN];
*/


#define N_MAX 256


int uget(int ndev, DEV_NAME devnames[], float setp[], float rdbk[])
{
  int       i, setp_cnts[N_MAX], rdbk_cnts[N_MAX], status;
  float     gain[N_MAX], offset[N_MAX];

  if (ndev < 1) {
    printf("*** No of devices = %d\n", ndev); exit(0);
  }
  for(i = 0; i < ndev; i++) {
    ugddr_getcalib_data(devnames[i], &gain[i], &offset[i]);
  }

  if (uidopen("Ctest")) {
    ucdperror(); exit(1);
  }
  status = ureadsetp(ndev, devnames, setp_cnts) ||
           ureadmag(ndev, devnames, rdbk_cnts);
  if (status) {
    fprintf(stderr, "*** ");
    ucdperror();
  } else {
    for(i = 0; i < ndev; i++) {
      setp[i] = setp_cnts[i]*gain[i]; rdbk[i] = rdbk_cnts[i]*gain[i];
    }
  }
  uclose();
  return(status);
}

int sgn(float x)
{
  if (x >= 0.0)
    return(1);
  else if (x == 0.0)
    return(0);
  else
    return(-1);
}

int uputsp(int ndev, DEV_NAME devnames[], float setp[])
{
  int       k, cnts[N_MAX], status;
  float     gain[N_MAX], offset[N_MAX], val;

  if (ndev < 1) {
    printf("*** No of devices = %d\n", ndev); exit(0);
  } else {
    for (k = 0; k < ndev; k++) {
      ugddr_getcalib_data(devnames[k], &gain[k], &offset[k]);
      cnts[k] = (int)(setp[k]/gain[k]+sgn(setp[k])*0.5);
      printf("name=%s, value=%d gain=%e\n", devnames[k], cnts[k], gain[k]) ;
    }
  }

  if(uidopen("Ctest")) {
    ucdperror(); exit(1);
  }
  status = usetmag(ndev, devnames, cnts); 
  uclose();
  return(status);
}


main(int argc, char *argv[])
{
  clock_t   tv1, tv2;
  double    time;
  int       i, ndev, status;
  DEV_NAME  devnames[N_MAX];
  float     setp[N_MAX], rdbk[N_MAX], val;

  char read = 0;

  if (read) {
    if( argc <= 1 )
      printf("*** command line error\n");
    else {
      ndev = argc - 1;
      for(i = 0; i < ndev; i++)
	strcpy(devnames[i], argv[i+1]);
      tv1 = clock();
      status = uget(ndev, devnames, setp, rdbk);
      tv2 = clock();
      time = (tv2-tv1)/(CLOCKS_PER_SEC/(double)1000.0);
      printf("execution time = %5.3f sec\n", 1e-3*time);
      if (status == 0)
	for (i = 0; i < ndev; i++) {
	  printf("%d %s %e %e\n", status, devnames[i], setp[i], rdbk[i]) ;
	}
      else
	printf("%d\n", status);
    }
  } else {    
    if((argc < 2) || (argc % 2 == 0)) {
      printf("*** Incorrect number of args\n"); exit(0);
    } else {
      ndev = argc/2;
      for (i = 0; i < ndev; i++) {
	sscanf(argv[2*i+1], "%s", devnames[i]);
	sscanf(argv[2*i+2], "%f", &setp[i]);      
      }
      tv1 = clock();
      status = uputsp(ndev, devnames, setp);
      tv2 = clock();
      time = (tv2-tv1)/(CLOCKS_PER_SEC/(double)1000.0);
      printf("execution time = %5.3f sec\n", 1e-3*time);
      printf("%d\n", status);
      status = uget(ndev, devnames, setp, rdbk);
      if (status == 0)
	for (i = 0; i < ndev; i++) {
	  printf("%d %s %e %e\n", status, devnames[i], setp[i], rdbk[i]) ;
	}
      else
	printf("%d\n", status);
    }
  }

}
