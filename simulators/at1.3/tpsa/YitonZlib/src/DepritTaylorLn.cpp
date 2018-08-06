#include "DepritTaylorLn.hpp"

DepritTaylorLn::DepritTaylorLn() {}
      
DepritTaylorLn::DepritTaylorLn(int o, int dim) {
      AA = AA.memConstruct(dim, dim);
      RR = RR.memConstruct(dim, dim);
      AI = AI.memConstruct(dim, dim);
      ff = ff.memConstruct(dim, dim, o);
}

DepritTaylorLn::DepritTaylorLn(const DepritTaylorLn& zps) {
      *this = zps;
}

DepritTaylorLn::DepritTaylorLn(const Vps& zps) {
      *this = zps;      
}

DepritTaylorLn::~DepritTaylorLn() {};


DepritTaylorLn& DepritTaylorLn::operator=(const DepritTaylorLn& zps) {
      AA = zps.AA; RR = zps.RR; AI = zps.AI;
      ff = zps.ff;
      return *this;
}
      
DepritTaylorLn::operator Vps() const {
      doubleMatrix M; M = RR*AI;
      Vps obj;  
      obj = AA*ff*M;
      return obj;
}  

DepritTaylorLn DepritTaylorLn::inv(int o) {
      DepritTaylorLn dp;
      dp.ff = RR.invM()*ff.inverse()*RR;
      dp.RR = RR.invM();
      dp.AA = AA;
      dp.AI = AI;
      return dp;
}

DepritTaylorLn DepritTaylorLn::operator*(const DepritTaylorLn & zps) const {
      Vps obj1; obj1 = Vps(*this);
      Vps obj2; obj2 = Vps(zps);
      obj2 = obj1*obj2;
      DepritTaylorLn obj(obj2);
      return obj;
}      
      
istream& operator >> (istream& in, DepritTaylorLn & zps) {
     in >> zps.AI >> zps.RR >> zps.AA >> zps.ff;
     return in;
}

ostream& operator << (ostream& out, const DepritTaylorLn & zps) {
     out << zps.AI << zps.RR << zps.AA << zps.ff;
     return out;
}

DepritTaylorLn& DepritTaylorLn::operator=(const Vps& zps) {
      doubleMatrix M; M = zps.JacobianMatrix();
      int success; 
      success = M.Norm(AA, RR, AI);
      if (!success) {
 	 cerr << "not success in M.Norm in DepritTaylorLn = Vps\n";
	 exit(1);
      }	 
      M = AA*(RR.invM());
      ff = zps*M; ff = AI*ff;
      return *this;
}  





