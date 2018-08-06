#include "mxVpsLn.hpp"
#include "Zlib.hpp"

mxVpsLn::mxVpsLn() {}
      
mxVpsLn::mxVpsLn(int o, int dim, int nvar) {
      AA = AA.memConstruct(dim, dim);
      RR = RR.memConstruct(dim, dim);
      AI = AI.memConstruct(dim, dim);
      if (nvar > 88) nvar=dim;
      uu = uu.memConstruct(dim,nvar,o);
      gf = gf.memConstruct(nvar,o+1); // nVar == dim.
      ww = ww.memConstruct(dim,nvar,o);
}

mxVpsLn::mxVpsLn(const mxVpsLn& zps) {
      *this = zps;
}

mxVpsLn::mxVpsLn(const Vps& zps) {
      *this = zps;      
}

mxVpsLn::~mxVpsLn() {};


mxVpsLn& mxVpsLn::operator=(const mxVpsLn& zps) {
      AA = zps.AA; RR = zps.RR; AI = zps.AI;
      uu = zps.uu;
      gf = zps.gf;
      ww = zps.ww;
      return *this;
}

/*
mxVpsLn& mxVpsLn::generating(int order) {
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
*/

mxVpsLn mxVpsLn::truncate(int order) const {
  mxVpsLn zz;
  zz.AA = AA;   zz.RR = RR;   zz.AI = AI;
  zz.uu = uu.truncate(order);
  zz.ww = ww.truncate(order);
  zz.gf = gf;
  //  zz.gf = gf.truncate(order+1);
  return zz;
}


Vec mxVpsLn::operator() (const Vec & v, int ord, int& lossflag) const  // mixed Map Tracking
{
  // where v = [x,px,y,py,z,pz] style.
  // 1st step: make the linear transformation
  Vec si = RR*(AI*v);
  Vec x = ww.mxVpsTrk(si,ord,lossflag);
  return AA*x;
}

ostream & operator << (ostream& out, const mxVpsLn & zps) {
     out << zps.AI;
     out << zps.RR;
     out << zps.AA;
     out << zps.uu;
     out << zps.ww;
     out << zps.gf;
     return out;
}
      
istream & operator >> (istream & in, mxVpsLn & zps) {
     in >> zps.AI;
     cout << "zps.AI read \n";
     in >> zps.RR;
     cout << "zps.RR read \n";
     in >> zps.AA;
     cout << "zps.AA read \n";
     in >> zps.uu;
     cout << "zps.uu read \n";
     in >> zps.ww;
     cout << "zps.ww read \n";
     //     in >> zps.gf;
     cout << "zps.gf read skipped \n";
     return in;
}
      
mxVpsLn& mxVpsLn::operator=(const Vps& zps) {
      doubleMatrix M; M = zps.JacobianMatrix();
      int success; 
      success = M.Norm(AA, RR, AI);
      if (!success) {
 	 cerr << "not success in M.Norm in DepritLieLn = Vps\n";
	 exit(1);
      }	 
      M = AA*(RR.invM());
      uu = zps*M; uu = AI*uu;
      gf=uu.mixedVps();// uu,gf are now functions of mixed variables.
      ww = uu.homogeneous(0); // dummy
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




