#include "DepritTaylor.hpp"
#include "Zlib.hpp"

DepritTaylor::DepritTaylor() {}
      
DepritTaylor::DepritTaylor(int o, int dim) {
      doubleMatrix M(dim,dim);
      RR = M;
      //      RR = RR.memConstruct(dim, dim);
      ff = ff.memConstruct(dim,dim,o);
}

DepritTaylor::DepritTaylor(const DepritTaylor& zps) {
      *this = zps;
}

DepritTaylor::DepritTaylor(const Vps& zps) {
      *this = zps;      
}

DepritTaylor::DepritTaylor(const Tps& zps) { //convert from a single Lie
      int minOrder = zps.getMinOrder();
      if (minOrder < 2)
	{
	  cerr << " ERROR, DepritTaylor::DepritTaylor(const Tps& zps), "
	       << " Tps order < 2.\n";
	  exit(1);
	}
      if (minOrder > 2) 
	{
	  int dim = ( zps.getNumVar()/2 ) * 2;
	  if (dim > ZlibCanDim*2) dim = ZlibCanDim*2;
	  doubleMatrix II(dim, 1.0);
	  RR = II;
	  ff = zps.singleLieTaylor();
	}
      else  // minOrder == 2;
	{
	  DepritTaylor dl(zps.singleLieTaylor());
	  RR = dl.getRR();
	  ff = dl.getff();
	}
}

DepritTaylor::~DepritTaylor() {};


DepritTaylor& DepritTaylor::operator=(const DepritTaylor& zps) {
      RR = zps.RR;
      ff = zps.ff;
      return *this;
}
      
DepritTaylor::operator Vps() const {
      return ff*RR;
}  

DepritTaylor DepritTaylor::inv(int o) {
      DepritTaylor dp;
      dp.RR = RR.invM();
      dp.ff = RR.invM()*ff.inverse()*RR;
      return dp;
}

DepritTaylor DepritTaylor::operator*(const DepritTaylor & zps) const {
      DepritTaylor obj;
      obj.RR = RR * zps.RR;
      obj.ff = (RR.invM()*ff*zps.RR)*zps.ff;
      return obj;
}      
      
istream& operator >> (istream& in, DepritTaylor & zps) {
     in >> zps.RR >> zps.ff;
     return in;
}

ostream& operator << (ostream& out, const DepritTaylor & zps) {
     out << zps.RR << zps.ff;
     return out;
}

DepritTaylor& DepritTaylor::operator=(const Vps& zps) {
      RR = zps.JacobianMatrix();
      ff = zps*(RR.invM());
      return *this;
}  




