#include "DragtLieLn45.hpp"

DragtLieLn45::DragtLieLn45() {}
      
DragtLieLn45::DragtLieLn45(int o, int canDim, int nVar) {
      doubleMatrix M(nVar, nVar), MM(nVar, nVar), MI(nVar, nVar);
      RR = M; AA = MM; AI = MI;
      ff = ff.memConstruct(nVar,o);
      num_var = nVar;
      canonical_dimension = canDim;
}
      
DragtLieLn45::DragtLieLn45(const DragtLieLn45& zps) {
      *this = zps;
}

DragtLieLn45::DragtLieLn45(const Vps& zps) {
      *this = zps;      
}

DragtLieLn45::~DragtLieLn45() {};


DragtLieLn45& DragtLieLn45::operator=(const DragtLieLn45& zps) {
      num_var = zps.num_var;
      canonical_dimension = zps.canonical_dimension;
      AA = zps.AA; RR = zps.RR; AI = zps.AI;
      ff = zps.ff;
      return *this;
}
      
DragtLieLn45 DragtLieLn45::operator-(const DragtLieLn45& zps) {
      if (canonical_dimension != zps.canonical_dimension || 
          num_var != zps.num_var) {
	cerr << "ERROR: DragtLieLn45::operator-(const DragtLieLn45& zps)\n";
	exit(1);
      }
      DragtLieLn45 dp;
      dp.canonical_dimension = canonical_dimension;
      dp.num_var = num_var;
      dp.AA = AA-zps.AA; dp.RR = RR-zps.RR; dp.AI = AI-zps.AI;
      dp.ff = ff-zps.ff;
      return dp;
}
      
void DragtLieLn45::condense(double eps)
{
     ff.condense(eps);
}

DragtLieLn45::operator Vps() const {
      int canDim = ZlibCanDim;
      ZlibCanDim = canonical_dimension;
      //
      doubleMatrix M; M = RR*AI;
      Vps obj = ff.orderLieTaylor();
      int dim = canonical_dimension*2;
      doubleMatrix AA4 = AA.subMatrix(dim, dim);
      obj = AA4*obj*M;
      AA4 = AA.subMatrix( 0,dim-1,dim,AA.Col()-1);
      AA4 = AA4.expandMatrix(0,dim,AA.Row()-1,AA.Col()-1);
      Vps objM(AA4);
      objM = objM.subVps(dim);
      obj +=objM;
      //
      ZlibCanDim = canDim;
      return obj;
}  

DragtLieLn45 DragtLieLn45::inv(int o) {
      DragtLieLn45 dp;
      dp.ff = (ff*RR)*(-1.0);
      dp.RR = RR.invM();
      dp.AA = AA;
      dp.AI = AI;
      return dp;
}

DragtLieLn45 DragtLieLn45::operator*(const DragtLieLn45 & zps) const {
      Vps obj1; obj1 = Vps(*this);
      Vps obj2; obj2 = Vps(zps);
      obj2 = obj1*obj2;
      DragtLieLn45 obj(obj2);
      return obj;
}      
      
ostream& operator << (ostream& out, const DragtLieLn45 & zps) {
  out << "DragtLieLn45: canonical_dimension, num_var, AI,RR,AA, ff = "
      << zps.canonical_dimension << ' ' << zps.num_var 
      << endl << zps.AI << zps.RR << zps.AA << zps.ff;
  return out;
}

DragtLieLn45& DragtLieLn45::operator=(const Vps& zps) {
      num_var = zps.getNumVar();
      canonical_dimension = zps.getDim()/2;
      int dim = canonical_dimension * 2;
      int num_parameters = num_var-dim;
      if (num_parameters < 0) 
        {
           canonical_dimension += (num_parameters - 1)/2;
	   dim = canonical_dimension * 2;
        }    
      Vps zz = zps.subVps(dim);
      doubleMatrix MM =zz.linearMatrix();
      doubleMatrix NN = MM.subMatrix(dim,dim);
      doubleMatrix A1, A1I;
      int success = NN.Norm(A1, RR, A1I);
      if (!success) {
 	 cerr << "not success in NN.Norm in DragtLieLn45 = Vps\n";
	 exit(1);
      }	 
      A1 = A1.expandMatrix(num_var,num_var);
      int i;
      for (i=dim; i<num_var; ++i) A1(i,i) = 1.0;
      doubleMatrix hh = MM.subMatrix(0,dim-1,dim,num_var-1);
      doubleMatrix II(dim,1.0);
      doubleMatrix IN=II-NN;
      hh = (IN.invM(0))*hh;
      doubleMatrix A0(num_var,1.0);
      for (i=0; i<dim; ++i) {
	for (int j=dim; j<num_var; ++j) A0(i,j) = hh(i,j-dim);
      }
      AA = A0*A1;
      AI = AA.invM(0);
      doubleMatrix AI4 = AI.subMatrix(dim, dim);
      zz = AI4*zz(AA);
      AI4 = AI.subMatrix( 0,dim-1,dim,AI.Col()-1);
      AI4 = AI4.expandMatrix(0,dim,AI.Row()-1,AI.Col()-1);
      Vps objM(AI4);
      objM = objM.subVps(dim);
      zz += objM;
      RR = zz.linearMatrix().expandMatrix(num_var, num_var);
      for (i=dim; i<num_var; ++i) RR(i,i) = 1.0;
      zz = zz(RR.invM(0));
      ff = zz.orderLie();
      return *this;
}  





