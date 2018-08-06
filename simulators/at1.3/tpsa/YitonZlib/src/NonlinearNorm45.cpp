#include "DepritLie45.hpp"
#include "NonlinearNorm45.hpp"

NonlinearNorm45::NonlinearNorm45() {}
      
NonlinearNorm45::NonlinearNorm45(int o, int canDim, int nVar) {
      num_var = nVar;
      canonical_dimension = canDim;
      eta = eta.memConstruct(canDim*2, o);
      AA = AA.memConstruct(nVar, nVar);
      RR = RR.memConstruct(nVar, nVar);
      AI = AI.memConstruct(nVar, nVar);
      FF = FF.memConstruct(nVar, o);
      hh = hh.memConstruct(canDim, o);
}
      
NonlinearNorm45::NonlinearNorm45(const NonlinearNorm45& zps) {
      *this = zps;
}

NonlinearNorm45::NonlinearNorm45(const Vps& zps) {
      *this = zps;      
}

NonlinearNorm45::~NonlinearNorm45() {};


NonlinearNorm45& NonlinearNorm45::operator=(const NonlinearNorm45& zps) {
      num_var = zps.num_var;
      canonical_dimension = zps.canonical_dimension;
      eta = zps.eta;
      AA = zps.AA; RR = zps.RR; AI = zps.AI;
      FF = zps.FF;
      hh = zps.hh;
      return *this;
}
      
void NonlinearNorm45::condense(double eps)
{
     FF.condense(eps);
     hh.condense(eps);
}

/*
NonlinearNorm45::operator Vps() const {
      int canDim = ZlibCanDim;
      ZlibCanDim = canonical_dimension;
      //
      doubleMatrix M; M = RR*AI;
      Vps obj = ff.singleLieTaylor();
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

NonlinearNorm45 NonlinearNorm45::inv(int o) {
      NonlinearNorm45 dp;
      dp.FF = FF;
      dp.hh = -hh;
      dp.RR = RR.invM();
      dp.AA = AA;
      dp.AI = AI;
      return dp;
}
*/
      
ostream& operator << (ostream& out, const NonlinearNorm45 & zps) {
  out << "NonlinearNorm45: canonical_dimension,num_var,eta,AI,RR,AA,FF,hh,hhc,HH,AF,AFI,AFC="
      << zps.canonical_dimension << ' ' << zps.num_var << endl 
      << "Dispersion Matrix (dim by order) is:\n" << zps.eta
      << "Dispersed closed orbit Xc =\n" << zps.Xc
      << "AI =\n" << zps.AI << "RR =\n" << zps.RR << "AA = \n" << zps.AA 
      << "hh in (2Jx)^m (2Jy)n (Delta)^p:\n" << zps.hh
      << "hhc in (2Jx)^m (2Jy)n (Delta)^p:\n" << zps.hhc
      << "HH in (x,px,y,py,delta):\n" << zps.HH
      << "FF =\n" << zps.FF 
      << "Nonlinear A:\n" << zps.AF << "Nonlinear AI:\n" << zps.AFI
      << "Nonlinear A: AFC =\n" << zps.AFC;
  return out;
}

NonlinearNorm45& NonlinearNorm45::operator=(const Vps& zps) {
      num_var = zps.getNumVar();
      canonical_dimension = zps.getDim()/2;
      int order = zps.getMaxOrder();
      int dim = canonical_dimension * 2;
      //      doubleMatrix etat(dim,order);
      int num_parameters = num_var-dim;
      if (num_parameters < 0) 
        {
           canonical_dimension += (num_parameters - 1)/2;
	   dim = canonical_dimension * 2;
	   num_parameters = num_var-dim;
        }    
      Vps map = zps.subVps(dim);
      Xc = map.DispersedClosedOrbit(eta); //get dispersedClosed orbit map: map
      doubleMatrix MM =map.linearMatrix();
      doubleMatrix NN = MM.subMatrix(dim,dim);
      doubleMatrix SS;
      int flgg = NN.checkSymplecticity(SS);
      if (!flgg ) cout << flgg << endl << SS;
      int success = NN.Norm(AA, RR, AI);
      if (!success) {
 	 cerr << "not success in NN.Norm in NonlinearNorm45 = Vps\n";
	 exit(1);
      }	 
      doubleMatrix AA5 = AA.expandMatrix(num_var,num_var);
      for (int i=dim; i<num_var; ++i) AA5(i,i) = 1.0;
      doubleMatrix AI5 = AI.expandMatrix(num_var,num_var);
      for (int i=dim; i<num_var; ++i) AI5(i,i) = 1.0;
      //------------ if w.r.t. the geometric closed orbit; AI=(AI   -AI eta);
      
      //------------ end if w.r.t. the geometric closed orbit A=(A  eta);

      Vps mf = AI * map(AA5);  // get mf = R exp(f)
      Vps mf_save = mf;
      doubleMatrix RRI = RR.invM(0);
      double mux = atan2(RR(0,1), RR(0,0));  // atan2(y,x);
      double muy = atan2(RR(2,3), RR(2,2));
      doubleMatrix RR5 = RR.expandMatrix(num_var,num_var);
      for (int i=dim; i<num_var; ++i) RR5(i,i) = 1.0;
      doubleMatrix RRI5 = RRI.expandMatrix(num_var,num_var);
      for (int i=dim; i<num_var; ++i) RRI5(i,i) = 1.0;
      int i = 3;
      Vps mfi; mfi = mf(RRI5);
      Tps fi = mfi.homoOrderLie(3);
      Tps hi;
      Tps Fi = fi.getFi(i,mux,muy,hi); 
      hh = hi; FF = Fi; 
      HH = hh.convert_hi2fi(canonical_dimension);

      int ord = min(order+1, ZlibMaxOrder);
      //      Vps AF,AFI,AH,AHI;
      Vps AH,AHI;
      for (i=4; i<=ord; ++i) {
       	AF = Fi.singleLieTaylor(1); 
      	mf = mf(AF.append(1));
      	AFI = (-Fi).singleLieTaylor(); 
	mf = AFI(mf.append(1));   // get mf = R e^h eFi+1 Q';
	DepritLie45 mf45(mf); mf45.condense(1.e-5); 
	AHI = (-HH).singleLieTaylor(); 	AHI = AHI.append(1);
	Vps RHI5 = RRI5*AHI; 
	mfi = mf(RHI5); 
	DepritLie45 mfi45(mfi); mfi45.condense(1.e-5); 
	fi = mfi.homoOrderLie(i);
	Fi = fi.getFi(i,mux,muy,hi); 
	hh += hi; FF += Fi;
	HH = hh.convert_hi2fi(canonical_dimension);
      }
      AF = FF.orderLieTaylor(1);
      AF = AA*AF;
      AFI = (-FF).orderLieTaylor();
      AFI= AFI(AI5);   // w.r.t. the dispersed closed orbit
      //*****************************************************  map checked Ok
      AH = HH.singleLieTaylor();
      Vps chk = AH(RR5);
      chk = chk(AFI.append(1));
      chk =  AF(chk.append(1));
      Vps II = chk-map;
      II.condense(1.e-5);
      II.ratio(map);
      II.condense(1.e-5);
      cout << II;
      cout << "==== 0 (checked Ok) ==== Original map - Nonlinear Norm map\n";
      //      **********************************************************/
      // for delta-dependent terms only (of hh and AF) as hhc and AFC
      //      hhc = hh.excludeNoParaDependentTerms();
      hhc = hh.nonlinearBetaParaTerms();
      AFC = AF.nonlinearBetaParaTerms();
      return *this;
}  
