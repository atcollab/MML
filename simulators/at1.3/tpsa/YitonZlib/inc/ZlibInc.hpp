//
//  ZlibInc.hpp
//

#ifndef ZlibInc_HH
#define ZlibInc_HH

#include <fstream>
#include <iostream>
#include <iomanip>
#include <cfloat>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string>

using namespace std;

#define PI   3.1415926535898
#define ZLIB_TINY   1.e-30    


inline int sign(double a) {return (a<0.0 ? -1 : 1);}
inline int min(int a, int b) {return (a<b ? a : b);}
//int min3(int a, int b, int c) { int t=min(b,c); return min(a,t); }
inline int min(int a, int b, int c) { int t=min(b,c); return min(a,t); }
inline double min(double a,double b) {return (a<b ? a : b);}
inline double min(double a, double b, double c) 
       {double t=min(b,c); return min(a,t);}
inline int max(int a, int b) {return (a>b ? a : b);}
inline int max(int a, int b, int c) { int t=max(b,c); return max(a,t); }
inline double max(double a, double b) {return (a>b ? a : b);}
inline double max(double a, double b, double c) 
       {double t=max(b,c); return max(a,t);}
inline int pwr(int a, int p) 
       {int ap = 1; for (int i=0; i<p; ++i) ap *=a; return ap;}
inline double pwr(double c, int p)
       {double d = 1.0; for (int i=0; i<p; ++i) d *= c; return d;}

//int abs(int a) {return (a>0.0 ? a : -a);}
//inline double abs(double a) {return (a>0.0 ? a : -a);}

int kbinom(int n, int k); // kbinom = n!/[k!(n-k)!]

#endif

