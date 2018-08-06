#ifndef RESMAP_HH
#define RESMAP_HH
//  Filename:     ResMap.hpp
//  -------------------------------------------------------------------
//  Category:     TPSA
//  -------------------------------------------------------------------
//  Release version:  $$.$$.$$
//  -------------------------------------------------------------------
//  Copyright:    See Copyright.hpp
//  -------------------------------------------------------------------
//  Description:  
//     Declared class:  ResMap (Resonance Basis Map) for
//     Truncated power series algebra in Zlib
//  -------------------------------------------------------------------
//  Maintenance
//     31-July-99, Original version,  Yiton T. Yan, SLAC. 
//     10-September-99, added exphn, ResTrackn,  Peace Change, SRRC
//  -------------------------------------------------------------------


#include "Tps.hpp"
#include "Vps.hpp"
#include "Vec.hpp"
#include "DepritLieLn45.hpp"

class JxyTable {
 private:
  double *v;
 public:
  JxyTable(int maxOrd=0);
  ~JxyTable() { delete [] v; }
  void memAllocate(int maxOrd);
  void Update(Vec &xys);
  double operator () (int i, int j) const
    { return  v[i*num+j+base]; }
  static int maxOrder;
  static int low, high, num, base;
  static double *twoJx;
  static double *twoJy;
};

class CosSinTable {
 private:
  double *v;
 public:
  CosSinTable(int maxOrd=0);
  ~CosSinTable() { delete [] v; }
  void memAllocate(int maxOrd);
  static void CosSinUpdate(Vec &xys);
  void CosUpdate();
  void SinUpdate();
  double operator () (int i, int j) const 
    { return  v[(i+maxOrder)*maxOrderP1+j]; }
 private:
  static int maxOrder;
  static int maxOrderP1;
  static double *CosMxThetaX;
  static double *SinMxThetaX;
  static double *CosMyThetaY;
  static double *SinMyThetaY;
};

class ResMap {

private:

  int maxOrder;
  void memAllocate(int maxOrd);

  int numCoefTs;
  int *nxTs, *nyTs, *termTs;
  int *nmxTs,*nmyTs,*nxm2Ts,*nym2Ts, *nxm4Ts,*nym4Ts,*nxm6Ts,*nym6Ts;
  double *coefTs;
  double **coefTsDelta; 
    
  int numCoef;
  int *mx, *my, *nx, *ny, *term;
  int *nmx,*nmy,*nxm2,*nym2, *nxm4,*nym4,*nxm6,*nym6;
  double *coefCos, *coefSin;
  double **coefCosDelta, **coefSinDelta;

  CosSinTable sines, cosines;
  JxyTable tjj;
  void nmxy(void);
  void SumTable(double delta);
  
public:
  ResMap() {maxOrder = 0;};
  ResMap(int order);
  ResMap(const Tps &);
  ~ResMap();
  void getResMap(const Tps&);
  void scaleMap(double tJx);
  void drivingForce(double tJx);
  int getOrder() {return maxOrder;}
  friend istream& operator>>(istream& in, ResMap& zz);
  friend ostream& operator<<(ostream& out, const ResMap& zz);
  void exph1(Vec &xys);
  void exph2(Vec &xys);
  void exph3(Vec &xys);
  void exph4(Vec &xys);
  void exphn(Vec &xys, int n);  // Peace

private:
  double *deltaPower;
};

double cTs(int ord, int nx, int ny, int p, const Tps & zz);
double cCos(int ord, int mx, int my, int nx, int ny, int p, const  Tps & zz);
double cSin(int ord, int mx, int my, int nx, int ny, int p, const Tps & zz);

class ResMapLn45 {
private:
  doubleMatrix AA, RR, AI;
  ResMap resmap;

public:
  ResMapLn45() {}
  ResMapLn45(const Vps&);
  ~ResMapLn45() {}
  void scaleMap(double tJx) { resmap.scaleMap(tJx); }
  void drivingForce(double tJx) { resmap.drivingForce(tJx); }
  void ResTrack(Vec & xys);
  void ResTrackn(Vec & xys, int n);   // Peace
  void ReplaceRR(const doubleMatrix & MM) { RR = MM; }
  doubleMatrix getAA() { return AA; }
  doubleMatrix getRR() { return RR; }
  doubleMatrix getAI() { return AI; }
  friend istream& operator>>(istream& in, ResMapLn45&);
  friend ostream& operator<<(ostream& out, const ResMapLn45&);
};

#endif // RESMAP_HH
