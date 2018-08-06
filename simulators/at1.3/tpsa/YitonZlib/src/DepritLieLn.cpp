#include "DepritLieLn.hpp"

DepritLieLn::DepritLieLn() {}
      
DepritLieLn::DepritLieLn(int o, int dim) {
      AA = AA.memConstruct(dim, dim);
      RR = RR.memConstruct(dim, dim);
      AI = AI.memConstruct(dim, dim);
      ff = ff.memConstruct(dim, o);
}

DepritLieLn::DepritLieLn(const DepritLieLn& zps) {
      *this = zps;
}

DepritLieLn::DepritLieLn(const Vps& zps) {
      *this = zps;      
}

DepritLieLn::~DepritLieLn() {};


DepritLieLn& DepritLieLn::operator=(const DepritLieLn& zps) {
      AA = zps.AA; RR = zps.RR; AI = zps.AI;
      ff = zps.ff;
      return *this;
}
      
DepritLieLn::operator Vps() const {
      doubleMatrix M; M = RR*AI;
      Vps obj;  
      //      obj = Vps(ff);
      obj = ff.singleLieTaylor();
      obj = AA*obj*M;
      return obj;
}  

DepritLieLn DepritLieLn::inv(int o) {
      DepritLieLn dp;
      dp.ff = (ff*RR)*(-1.0);
      dp.RR = RR.invM();
      dp.AA = AA;
      dp.AI = AI;
      return dp;
}

DepritLieLn DepritLieLn::operator*(const DepritLieLn & zps) const {
      Vps obj1; obj1 = Vps(*this);
      Vps obj2; obj2 = Vps(zps);
      //      Vps obj3; obj3 = obj1*obj2;
      //      DepritLieLn obj(obj3);
      obj2 = obj1*obj2;
      DepritLieLn obj(obj2);
      return obj;
}      
      
ostream& operator << (ostream& out, const DepritLieLn & zps) {
     out << zps.AI << zps.RR << zps.AA << zps.ff;
     return out;
}

DepritLieLn& DepritLieLn::operator=(const Vps& zps) {
      doubleMatrix M; M = zps.JacobianMatrix();
      int success; 
      success = M.Norm(AA, RR, AI);
      if (!success) {
 	 cerr << "not success in M.Norm in DepritLieLn = Vps\n";
	 exit(1);
      }	 
      M = AA*(RR.invM());
      Vps uu; uu = zps*M; uu = AI*uu;
      //      ff = Tps(uu);
      ff = uu.singleLie();
      return *this;
}  





