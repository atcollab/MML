#include "mxVps.hpp"
#include "Zlib.hpp"

mxVps::mxVps() {}
      
mxVps::mxVps(int o, int dim, int nvar) {
      doubleMatrix M(dim,dim);      RR = M;
      //      RR = RR.memConstruct(dim, dim);
      if (nvar > 88) nvar=dim;
      uu = uu.memConstruct(dim,nvar,o);
      gf = gf.memConstruct(nvar,o+1); // nVar == dim.
      ww = ww.memConstruct(dim,nvar,o);
}

mxVps::mxVps(const mxVps& zps) {
      *this = zps;
}

mxVps::mxVps(const Vps& zps) {
      *this = zps;      
}

mxVps::~mxVps() {};


mxVps& mxVps::operator=(const mxVps& zps) {
      RR = zps.RR;
      uu = zps.uu;
      gf = zps.gf;
      ww = zps.ww;
      return *this;
}

mxVps& mxVps::generating(int order) {
  gf=uu.mixedVps(order);// uu,gf are updated to functions of mixed variables.
  int nVar = uu.getNumVar(); int nVarh = nVar/2;
  int *pnt; pnt = new int[nVar];
  int i;
  for (i=0; i<nVarh; ++i) pnt[i*2] = i;
  for (i=nVarh; i<nVar; ++i) pnt[(i-nVarh)*2+1] = i;
  Vps tp = uu.reOrderVar(pnt); // [x,Px,y,Py,z,Pz]==tp(X,Y,Z,px,py,pz)
  // [x,y,z,Px,Py,Pz] == ww(X,Y,Z,px,py,pz).
  for (i=0; i<nVar; ++i) ww[pnt[i]] = tp[i];
  return *this;
}

mxVps mxVps::truncate(int order) const {
  mxVps zz;
  zz.RR = RR;
  zz.uu = uu.truncate(order);
  zz.ww = ww.truncate(order);
  zz.gf = gf;
  //  zz.gf = gf.truncate(order+1);
  return zz;
}



Vec mxVps::operator() (const Vec & v, int ord, int& lossflag) const  // mixed Map Tracking
{
  // where v = [x,px,y,py,z,pz] style.
  // 1st step: make the linear transformation
  Vec si = RR*v;
  Vec x = ww.mxVpsTrk(si,ord,lossflag);
  return x;
}


ostream & operator << (ostream& out, const mxVps & zps) {
     out << zps.RR;
     out << zps.uu;
     out << zps.ww;
     out << zps.gf;
     return out;
}
      
istream & operator >> (istream & in, mxVps & zps) {
     in >> zps.RR;
     cout << "zps.RR read \n";
     in >> zps.uu;
     cout << "zps.uu read \n";
     in >> zps.ww;
     cout << "zps.ww read \n";
     //     in >> zps.gf;
     cout << "zps.gf read skipped \n";
     return in;
}

/*
mxVps& mxVps::operator=(const Vps& zps) {
      RR = zps.linearMatrix2n();
      doubleMatrix RRI = RR.invM();
      uu = zps(RRI);
      gf = 0.;  // dummy
      ww = uu.homogeneous(0); // dummy
      return *this;
}  
*/

mxVps& mxVps::operator=(const Vps& zps) {
      RR = zps.linearMatrix2n();
      doubleMatrix RRI = RR.invM();
      uu = zps(RRI);
      ww = uu.homogeneous(0); // dummy
      return this->generating();
}  



