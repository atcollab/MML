#include "ZlibInc.hpp"

/*
int sign(double a) {return (a<0.0 ? -1 : 1);}

int min(int a, int b) {return (a<b ? a : b);}
//int min3(int a, int b, int c) { int t=min(b,c); return min(a,t); }
int min(int a, int b, int c) { int t=min(b,c); return min(a,t); }
double min(double a,double b) {return (a<b ? a : b);}
double min(double a, double b, double c) {double t=min(b,c); return min(a,t);}

int max(int a, int b) {return (a>b ? a : b);}
int max(int a, int b, int c) { int t=max(b,c); return max(a,t); }
double max(double a, double b) {return (a>b ? a : b);}
double max(double a, double b, double c) {double t=max(b,c); return max(a,t);}

//int abs(int a) {return (a>0.0 ? a : -a);}
//double abs(double a) {return (a>0.0 ? a : -a);}
*/

int kbinom(int n, int k) // kbinom = n!/[k!(n-k)!]
{
  if (n == 0 || k == 0) { return 1;}
  int nmk=n-k;
  int kb=nmk+1;
  for (int i=2; i<=k; ++i) kb=kb*(nmk+i)/i;
  return kb;
}
