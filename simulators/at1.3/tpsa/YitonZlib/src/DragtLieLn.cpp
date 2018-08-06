#include "DragtLieLn.hpp"

DragtLieLn::DragtLieLn() {}
      
DragtLieLn::DragtLieLn(int o, int dim) {
      doubleMatrix M(dim,dim);
      AA = M;
      RR = M;
      AI = M;
      ff = ff.memConstruct(dim,o);
}

DragtLieLn::DragtLieLn(const DragtLieLn& zps) {
      *this = zps;
}

DragtLieLn::DragtLieLn(const Vps& zps) {
      *this = zps;      
}

DragtLieLn::~DragtLieLn() {};


DragtLieLn& DragtLieLn::operator=(const DragtLieLn& zps) {
      AA = zps.AA; RR = zps.RR; AI = zps.AI;
      ff = zps.ff;
      return *this;
}
      
DragtLieLn::operator Vps() const { 
      doubleMatrix M; M = RR*AI;
      Vps obj = ff.orderLieTaylor();
      obj = AA*obj*M;
      return obj;
}  

DragtLieLn DragtLieLn::inv(int o) {
      DragtLieLn dp;
      dp.ff = (ff*RR)*(-1.0);
      dp.RR = RR.invM();
      dp.AA = AA;
      dp.AI = AI;
      return dp;
}

DragtLieLn DragtLieLn::operator*(const DragtLieLn & zps) const {
      Vps obj1; obj1 = Vps(*this);
      Vps obj2; obj2 = Vps(zps);
      obj2 = obj1*obj2;
      DragtLieLn obj(obj2);
      return obj;
}      
      
ostream& operator << (ostream& out, const DragtLieLn & zps) {
     out << zps.AI << zps.RR << zps.AA << zps.ff;
     return out;
}

DragtLieLn& DragtLieLn::operator=(const Vps& zps) {
      doubleMatrix M; M = zps.JacobianMatrix();
      int success; 
      success = M.Norm(AA, RR, AI);
      if (!success) {
 	 cerr << "not success in M.Nrom in DragtLieLn = Vps\n";
	 exit(1);
      }	 
      M = AA*(RR.invM());
      Vps uu; uu = zps*M; uu = AI*uu;
      ff = uu.orderLie();
      return *this;
}  
