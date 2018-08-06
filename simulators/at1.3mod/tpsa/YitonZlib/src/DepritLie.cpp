#include "DepritLie.hpp"
#include "Zlib.hpp"

DepritLie::DepritLie() {}
      
DepritLie::DepritLie(int o, int dim) {
      doubleMatrix M(dim,dim);
      RR = M;
      //      RR = RR.memConstruct(dim, dim);
      ff = ff.memConstruct(dim,o);
}

DepritLie::DepritLie(const DepritLie& zps) {
      *this = zps;
}

DepritLie::DepritLie(const Vps& zps) {
      *this = zps;      
}

DepritLie::DepritLie(const Tps& zps) { //convert from a single Lie
      int minOrder = zps.getMinOrder();
      if (minOrder < 2)
	{
	  cerr << " ERROR, DepritLie::DepritLie(const Tps& zps), "
	       << " Tps order < 2.\n";
	  exit(1);
	}
      if (minOrder > 2) 
	{
	  int dim = ( zps.getNumVar()/2 ) * 2;
	  if (dim > ZlibCanDim*2) dim = ZlibCanDim*2;
	  doubleMatrix II(dim, 1.0);
	  RR = II;
	  ff = zps;
	}
      else  // minOrder == 2;
	{
	  DepritLie dl(zps.singleLieTaylor());
	  RR = dl.getRR();
	  ff = dl.getff();
	}
}

DepritLie::~DepritLie() {};


DepritLie& DepritLie::operator=(const DepritLie& zps) {
      RR = zps.RR;
      ff = zps.ff;
      return *this;
}
      
DepritLie::operator Vps() const {
      return (ff.singleLieTaylor())*RR;
}  

DepritLie DepritLie::inv(int o) {
      DepritLie dp;
      dp.RR = RR.invM();
      dp.ff = (ff*RR)*(-1.0);
      return dp;
}

DepritLie DepritLie::operator*(const DepritLie & zps) const {
      DepritLie obj;
      obj.RR = RR * zps.RR;
      obj.ff = ff*((zps.RR).invM());
      //      obj.ff = BCH(obj.ff, zps.ff);
      obj.ff=( (zps.ff).singleLieTaylor() * (obj.ff).singleLieTaylor() ).singleLie();
      return obj;
}      
      
ostream& operator << (ostream& out, const DepritLie & zps) {
     out << zps.RR << zps.ff;
     return out;
}

      
DepritLie& DepritLie::operator=(const Vps& zps) {
      RR = zps.JacobianMatrix();
      Vps uu; uu = zps*(RR.invM());
      ff = uu.singleLie();
      return *this;
}  




