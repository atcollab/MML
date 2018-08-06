#include "DepritLie45.hpp"
#include "Zlib.hpp"

DepritLie45::DepritLie45() {}
      
DepritLie45::DepritLie45(int o, int canDim, int nVar) {
      doubleMatrix M(nVar, nVar);
      RR = M;
      ff = ff.memConstruct(nVar,o);
      num_var = nVar;
      canonical_dimension = canDim;
}

DepritLie45::DepritLie45(const DepritLie45& zps) {
      *this = zps;
}

DepritLie45::DepritLie45(const Vps& zps) {
      *this = zps;      
}

/* not done
DepritLie45::DepritLie45(const Tps& zps) { //convert from a single Lie
      int minOrder = zps.getMinOrder();
      if (minOrder < 2)
	{
	  cerr << " ERROR, DepritLie45::DepritLie45(const Tps& zps), "
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
	  DepritLie45 dl(zps.singleLieTaylor());
	  RR = dl.getRR();
	  ff = dl.getff();
	}
}
*/

DepritLie45::~DepritLie45() {};


DepritLie45& DepritLie45::operator=(const DepritLie45& zps) {
      num_var = zps.num_var;
      canonical_dimension = zps.canonical_dimension;
      RR = zps.RR;
      ff = zps.ff;
      return *this;
}
      
DepritLie45::operator Vps() const {
      int canDim = ZlibCanDim;
      ZlibCanDim = canonical_dimension;
      Vps obj = (ff.singleLieTaylor())*RR;
      ZlibCanDim = canDim;
      return obj;
//      return (ff.singleLieTaylor())*RR;
}  

DepritLie45 DepritLie45::inv(int o) {
      DepritLie45 dp;
      dp.RR = RR.invM(0);
      dp.ff = (ff*RR)*(-1.0);
      return dp;
}

DepritLie45 DepritLie45::operator*(const DepritLie45 & zps) const {
      DepritLie45 obj;
      obj.RR = RR * zps.RR;
      obj.ff = ff*((zps.RR).invM(0));
      obj.ff=( (zps.ff).singleLieTaylor() * (obj.ff).singleLieTaylor() ).singleLie();
      return obj;
}      
      
ostream& operator << (ostream& out, const DepritLie45 & zps) {
      out << "DepritLie45: canonical_dimension,, num_var, RR, ff = "
	  << zps.canonical_dimension << ' ' << zps.num_var 
          << endl << zps.RR << zps.ff;
     return out;
}

      
DepritLie45& DepritLie45::operator=(const Vps& zps) {
      int nVar = zps.getNumVar();
      num_var = nVar;
      canonical_dimension = zps.getDim()/2;
      int num_parameters = nVar-canonical_dimension*2;
      if (num_parameters < 0) canonical_dimension += (num_parameters - 1)/2;
      Vps zz = zps.subVps(canonical_dimension*2);
      RR = zz.linearMatrix();
      RR = RR.expandMatrix(nVar,nVar);
      for (int i=canonical_dimension*2; i<nVar; ++i) RR(i,i) = 1.0;
      Vps uu; uu = zz*(RR.invM(0));
      ff = uu.singleLie();
      return *this;
}

void DepritLie45::condense(double eps)
{
    ff.condense(eps);
}
