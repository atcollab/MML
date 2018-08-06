#include "DragtLie45.hpp"

DragtLie45::DragtLie45() {}
      
DragtLie45::DragtLie45(int o, int canDim, int nVar) {
      doubleMatrix M(nVar, nVar);
      RR = M;
      ff = ff.memConstruct(nVar,o);
      num_var = nVar;
      canonical_dimension = canDim;
}

DragtLie45::DragtLie45(const DragtLie45& zps) {
      *this = zps;
}

DragtLie45::DragtLie45(const Vps& zps) {
      *this = zps;      
}

DragtLie45::~DragtLie45() {};


DragtLie45& DragtLie45::operator=(const DragtLie45& zps) {
      num_var = zps.num_var;
      canonical_dimension = zps.canonical_dimension;
      RR = zps.RR;
      ff = zps.ff;
      return *this;
}
      
DragtLie45::operator Vps() const { 
      int canDim = ZlibCanDim;
      ZlibCanDim = canonical_dimension;
      Vps obj = (ff.orderLieTaylor())*RR;
      ZlibCanDim = canDim;
      return obj;
      //      return (ff.orderLieTaylor())*RR;
}  

DragtLie45 DragtLie45::inv(int o) {
      DragtLie45 dp;
      dp.RR = RR.invM();
      dp.ff = (ff*RR)*(-1.0);
      return dp;
}

DragtLie45 DragtLie45::operator*(const DragtLie45 & zps) const {
      Vps obj1; obj1 = Vps(*this);
      Vps obj2; obj2 = Vps(zps);
      obj2 = obj1*obj2;
      DragtLie45 obj(obj2);
      return obj;
}      
      
ostream& operator << (ostream& out, const DragtLie45 & zps) {
      out << "DragtLie45: canonical_dimension,, num_var, RR, ff = "
	  << zps.canonical_dimension << ' ' << zps.num_var 
          << endl << zps.RR << zps.ff;
     return out;
}

DragtLie45& DragtLie45::operator=(const Vps& zps) {
      num_var = zps.getNumVar();
      canonical_dimension = zps.getDim()/2;
      int num_parameters = num_var-canonical_dimension*2;
      if (num_parameters < 0) canonical_dimension += (num_parameters - 1)/2;
      Vps zz = zps.subVps(canonical_dimension*2);
      RR = zz.linearMatrix();
      RR = RR.expandMatrix(num_var,num_var);
      for (int i=canonical_dimension*2; i<num_var; ++i) RR(i,i) = 1.0;
      Vps uu; uu = zz*(RR.invM(0));
      ff = uu.orderLie();
      return *this;
}  

