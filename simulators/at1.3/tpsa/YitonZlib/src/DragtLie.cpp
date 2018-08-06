#include "DragtLie.hpp"

DragtLie::DragtLie() {}
      
DragtLie::DragtLie(int o, int dim) {
      doubleMatrix M(dim,dim);
      RR = M;
      ff = ff.memConstruct(dim,o);
}

DragtLie::DragtLie(const DragtLie& zps) {
      *this = zps;
}

DragtLie::DragtLie(const Vps& zps) {
      *this = zps;      
}

DragtLie::~DragtLie() {};


DragtLie& DragtLie::operator=(const DragtLie& zps) {
      RR = zps.RR;
      ff = zps.ff;
      return *this;
}
      
DragtLie::operator Vps() const { 
      return (ff.orderLieTaylor())*RR;
}  

DragtLie DragtLie::inv(int o) {
      DragtLie dp;
      dp.RR = RR.invM();
      dp.ff = (ff*RR)*(-1.0);
      return dp;
}

DragtLie DragtLie::operator*(const DragtLie & zps) const {
      Vps obj1; obj1 = Vps(*this);
      Vps obj2; obj2 = Vps(zps);
      obj2 = obj1*obj2;
      DragtLie obj(obj2);
      return obj;
}      
      
ostream& operator << (ostream& out, const DragtLie & zps) {
     out  << zps.RR  << zps.ff;
     return out;
}

DragtLie& DragtLie::operator=(const Vps& zps) {
      RR = zps.JacobianMatrix();
      Vps uu; uu = zps*(RR.invM());
      //      uu = uu.filter(uu.getMaxOrder(), 2);
      ff = uu.orderLie();
      return *this;
}  

