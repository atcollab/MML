#include "Vec.hpp"
#include "doubleMatrix.hpp"
#include "TpsData.hpp"
#include "Tps.hpp"
#include "Vps.hpp"
	
//extern ofstream Lout;

Vps::Vps() : zp(0), dimVps(0) {}
	

Vps::Vps(int dimension, int nVar, int order) 
{
  if(nVar > ZlibNumVar || order > ZlibMaxOrder) 
    {
      ZlibNumVar = nVar;
      ZlibMaxOrder = order;
      zpprepTps();
      zpprepVps();
    } 
  else if (VpsFlag) 
    {
      VpsFlag = 0;
      Vps_STATIC = 0;
      zpprepVps();
    }
  dimVps = dimension;
  zp = new Tps[dimVps];
  if (order >= 0)
    {
      for (int i=0; i < dimVps; ++i) zp[i].memConstruct(nVar, order);
      if(!zp) 
	{
	  cerr << "Vps::Vps(int dimension, int nVar, int order) : "
	       << "allocation failure \n"; 
	  exit(1);
	}
    }
}  

Vps::Vps(const Vps& zps) : zp(new Tps[zps.dimVps]), dimVps(zps.dimVps) 
{
  for (int i=0; i<dimVps; ++i) zp[i] = (zps.zp)[i];
}     

Vps::Vps(Tps * u, int dim): zp(new Tps[dim]), dimVps(dim) 
{
  for (int i=0; i < dimVps; ++i) zp[i] = u[i];
}

/*
Vps::Vps(const Tps& H)     // Lie1
{
  *this = H.vps();
}
*/

Vps::Vps(const doubleMatrix& M) 
{
     int nVar = M.Col();
     dimVps = M.Row();
     int i,j;
     zp = new Tps[dimVps];
     for (i=0; i<dimVps; ++i) zp[i].memConstruct(nVar,1,999,1);
     for (i=0; i < dimVps; ++i) 
       {
         for (j=0; j < nVar; ++j) 
	   {
             (zp[i])[j+1] = M(i,j);
	   }
       }
}
	
Vps::Vps(const Vec & V)   // 0th-order Vps
{
     dimVps = V.getSize();
     zp = new Tps[dimVps];
     int i;
     for (i=0; i < dimVps; ++i) zp[i].memConstruct(1,0,999);
     for (i=0; i < dimVps; ++i)
       {
         (zp[i])[0] = V(i);
       }
}
	
Vps::Vps(const Vec & V, const doubleMatrix & M)   // 1st-order Vps
{
  dimVps = V.getSize();
  if ( !( dimVps == M.Row() ) ) 
    {
      cerr << "Vps::Vps(const Vec& V, const doubleMatrix& M)\n";
      exit(1);
    }
  int nVar = M.Col();
  zp = new Tps[dimVps];
  int i,j;
  for (i=0; i < dimVps; ++i)
    {
      zp[i].memConstruct(nVar,1,999,0);
      (zp[i])[0] = V(i);
      for (j=0; j < nVar; ++j) 
	{
	  (zp[i])[j+1] = M(i,j);
	}
    }
}

Vps Vps::makeI(int dimension, double cc)
{
  Vps obj(dimension, dimension);
  int i;
  for (i=0; i<dimension; ++i) obj.zp[i].memConstruct(dimension,1,999,1);
  obj.clear(1,1);
  for (i=0; i < dimension; ++i) 
    {
      (obj[i])[i+1] = cc;
    }
  return obj;
}

Vps::~Vps() 
{
   delete [] zp; 
}

Tps Vps::operator [] (int i) const
{
  return zp[i];
}

Tps& Vps::operator [] (int i) 
{
  return zp[i];
}

Tps Vps::operator () (int i) const
{
  return zp[i-1];
}

Tps& Vps::operator () (int i) 
{
  return zp[i-1];
}

Vps Vps::truncate(int order, int acc_ord) const 
{
  Vps obj(dimVps);
  for (int i=0; i<dimVps; ++i) 
    {
      (obj.zp)[i] = zp[i].truncate(order, acc_ord);
    }
  return obj;
}

Vps Vps::homogeneous(int order, int nVar, int acc_ord) const 
{
  Vps obj(dimVps);
  for (int i=0; i<dimVps; ++i) 
    {
      (obj.zp)[i] = zp[i].homogeneous(order, nVar, acc_ord);
    }
  return obj;
}

Vps Vps::filter(int max_ord, int min_ord, int acc_ord) const 
{
  int accOrd = min(getAccOrder(), acc_ord);
  Vps obj(dimVps);
  for (int i=0; i<dimVps; ++i) 
    {
      (obj.zp)[i] = zp[i].filter(max_ord, min_ord, accOrd);
    }
  return obj;
}

void Vps::filtering(int max_ord, int min_ord)
{
  for (int i=0; i<dimVps; ++i) 
    {
      zp[i].filtering(max_ord, min_ord);
    }
}

Vps Vps::append(int para) const
{
  Vps obj(dimVps+para);
  int i;
  for (i=0; i<dimVps; ++i) 
    {
      (obj.zp)[i] = zp[i];
    }
  for (i=dimVps; i<dimVps+para; ++i)
    {
      obj[i]=Tps::makeVariable(i);
    }
  return obj;
}

Vps Vps::subVps(int dim) const
{
  Vps obj(dim);
  for (int i=0; i<dim; ++i) 
    {
      (obj.zp)[i] = zp[i];
    }
  return obj;
}

Vps Vps::subVps(int dim, int nVar) const
{
  Vps obj(dim);
  for (int i=0; i<dim; ++i) 
    {
      (obj.zp)[i] = zp[i].subTps(nVar);
    }
  return obj;
}

Vps& Vps::operator=(const Vps& zps) { //Yan
    if (this != &zps) 
      {
        if (dimVps != zps.dimVps) 
	  {
	    dimVps = zps.dimVps;
	    if (zp) delete [] zp;
	    zp = new Tps[dimVps];
	  }
        for (int i=0; i<dimVps; ++i) zp[i] = zps[i];
     }
     return *this;
}

/*
Vps::operator Tps() const
{
     return singleLie();
}
*/        
        
//Vps Vps::operator+() const {  return *this;}

Vps Vps::operator+() const 
{
    Vps obj(dimVps);
    for (int i=0; i<dimVps; ++i) obj[i] = zp[i];
    return obj;
}

Vps Vps::operator-() const 
{
  Vps obj(dimVps);
  for (int i=0; i<dimVps; ++i) 
    {
      (obj.zp)[i] = -zp[i];
    }
  return obj;
}


Vps Vps::operator+(const Vps& zps) const
{
  Vps obj = *this;
  obj += zps;
  return obj;
}

Vps& Vps::operator+=(const Vps& zps) 
{
    if (dimVps != zps.dimVps) 
      {
	cerr << " *** Vps Vps:operator+=(const Vps& zps)\n";
        cerr << " *** Dimension problem\n";
	exit(1);
      }
    for (int i=0 ; i < dimVps ; ++i) zp[i] = zp[i] + (zps.zp)[i];
    return *this;
}

Vps Vps::operator-(const Vps& zps) const 
{
  //  Vps temp = -zps;
  //  temp += *this;
  return *this+(-zps);
}

Vps& Vps::operator-=(const Vps& zps) 
{
  //  *this = *this - zps;
  //  return *this;
  return *this+=(-zps);
}

Vps Vps::concatenate(const Vps& zps, int order) const  // order is not used??
{
    if ( zps.dimVps < getNumVar() ) 
      //    if ( !(zps.dimVps == getNumVar()) ) 
      {
	//        cerr << "concat zps.dimVps = " << zps.dimVps << " != " 
        cerr << "concat zps.dimVps = " << zps.dimVps << " < " 
             << getNumVar() << " = this->nVar\n"; 
	cerr << "Are you missing one indentity Tps component in the Vps? \n";
        exit(1);
      }
    if ( !(getNumVar() == nVarCnct && getMaxOrder() == nocnct) ) 
      {
	nocnct = getMaxOrder();
	nVarCnct = getNumVar();
	pntcct(nVarCnct, nocnct);
      }
    Vps wk = zps;         
    //    Vps obj = truncate(0); 
    Vps obj = homogeneous(0); 
    int i,j, iv, ivp, jp;
    for (i=0; i < dimVps; ++i) 
      {
	for (j=1; j<=nVarCnct; ++j) 
	  {
	    obj[i] += ((zp)[i]).zp->tps_data[j] * (zps.zp)[j-1];
	    //	    obj[i] += ((zp)[i])[j] * (zps.zp)[j-1];
	  }
      }
    int nmcct = nmo[nVarCnct][nocnct]-nVarCnct-1;

    int *jjpc, *ivvpc, *ivvppc;
    jjpc = jpc[nVarCnct][nocnct];
    ivvpc = ivpc[nVarCnct][nocnct];
    ivvppc = ivppc[nVarCnct][nocnct];
    for (j=0; j < nmcct; ++j) 
      {
        iv = ivvpc[j];
        ivp = ivvppc[j];
        jp = jjpc[j];
        wk[iv] = (zps.zp)[iv] * wk[ivp];
        for (i=0;i<dimVps;++i) obj[i]+=((zp)[i]).zp->tps_data[jp]*wk[iv];
	//     for (i=0; i < dimVps; ++i) obj[i] += ((zp)[i])[jp]*wk[iv];
    } 
    int accOrd=min(max(1,zps.getMinOrder())*getAccOrder(), obj.getAccOrder());
    obj.accOrderChange(accOrd);
    if (accOrd < obj.getMaxOrder()) obj.maxOrderChange(accOrd);
    return obj;
}

//int Vps::getSizem() const { return zp[0].getSizem();}
//int Vps::getCount() const { return 0; }

Vps Vps::operator()(const doubleMatrix& M) const 
{
  Vps zps(M);
  Vps othis = *this; othis.unifyVps();
  return othis.concatenate(zps);
} 

Vps Vps::operator*(const doubleMatrix& M) const 
{
  return (*this)(M);
} 

Vps operator*(const doubleMatrix& M, const Vps & zps) 
{
  if ( M.Col() != zps.getDim() )
    {
      cerr <<"Warning: Vps operator*(const doubleMatrix& M, const Vps & zps)\n"
	   << "M.Col()=" << M.Col() << " != " 
	   << zps.getDim() << "=zps.getDim() \n";
      if ( M.Col() < zps.getDim() ) exit(1);
    }

  int dim = M.Row();
  Vps obj(dim);
  for (int i=0; i<dim; ++i)
    {
      obj[i] = zps[0]*M(i,0);
      for (int j=1; j<M.Col(); ++j) obj[i] = obj[i] + zps[j]*M(i,j);
    }
  return obj;
}

/*
Vps operator*(const doubleMatrix& M, const Vps & zps) 
{
  Vps mm(M);
  Vps zvps=zps; zvps.unifyVps();
  return mm.concatenate(zvps);
}
*/

Vps Vps::operator() (const Vps& zps) const 
{
  Vps othis = *this; othis.unifyVps();
  Vps zvps = zps; zvps.unifyVps();
  return othis.concatenate(zvps);
}

Vps Vps::operator*(const Vps& zps) const {
    return (*this)(zps);
}

Vps& Vps::operator*=(const Vps& zps) 
{
  *this = (*this)(zps);
  return *this;
}

Tps operator*(const Tps& tp, const Vps & zps) 
{
  return tp(zps);
}

Tps operator*(const Tps& tp, const doubleMatrix & M) // u*M = u(M x)
{
  Vps zps(M);
  return tp(zps);
} 
  
Vps Vps::operator/(const Vps& zps) const 
{
  Vps othis = *this; othis.unifyVps();
  return othis.concatenate(zps.inverse());
}

Vps& Vps::operator/=(const Vps& zps) {
  *this = (*this)/zps;
  return *this;
}

Vps Vps::inverse() const 
{
    int reject = 0;
    if (!(dimVps == ZlibNumVar)) reject = 1;
    int i,io;
    if ( !getMinOrder() )
      {
	for (i=0; i<dimVps; ++i) 
	  {
	    if ( (zp[i])[0] > 1.e-8) reject = 1;
	  }
	if (reject) 
	  {
	    cerr << "constant term is not 0.000 in Vps Vps::inverse() \n";
	    cerr << " Please  consult Yiton T. Yan at SLAC.\n";
	    exit(1);
	  }
	else
	  {
	    for (i=0; i<dimVps; ++i) 
	      {
		zp[i].zp->min_order = 1;
	      }
	  }
      }
    doubleMatrix M = JacobianMatrix();
    Vps uuI = truncate(1) - *this;
    doubleMatrix MI = M.invM(0);
    Vps obj(MI); // to the first order
    Vps ss; 
    Vps I = makeI(dimVps, 1.0);
    for (io=2; io<=getMaxOrder(); ++io) 
      {
        ss = uuI.truncate(io)*obj.truncate(io-1);
	ss += I;
	obj = MI*ss.truncate(io);
      }
    return obj;
}

doubleMatrix Vps::JacobianMatrix() const //get Jocobian Matrix of a Vps at X= 0
{
     int r = getDim();
     int flag;
     int col = getNumVar(flag);
     doubleMatrix M(r, col);
     int i,j;
     for (i=0; i < r; ++i) 
       {
         if ( zp[i].getMaxOrder() && zp[i].getMinOrder() < 2 )
	   {
	     int c=zp[i].getNumVar();
	     for (j=0; j < c; ++j) 
	       {
		 M(i,j) = (zp[i])[j+1];
	       }
	   }
       }
     return M;
}

doubleMatrix Vps::linearMatrix() const //get linear part to a matrix from a Vps
{
     int r = getDim();
     int flag;
     int col = getNumVar(flag);
     doubleMatrix M(r, col);
     int i,j;
     for (i=0; i < r; ++i) 
       {
         if ( zp[i].getMaxOrder() && zp[i].getMinOrder() < 2 )
	   {
	     int c=zp[i].getNumVar();
	     for (j=0; j < c; ++j) 
	       {
		 M(i,j) = (zp[i])[j+1];
	       }
	   }
       }
     return M;
}

doubleMatrix Vps::linearMatrix2n() const //get linear part to a matrix from a Vps
{
     int r = getDim();
     int flag;
     int col = getNumVar(flag);
     doubleMatrix M(r, r);
     int i,j;
     for (i=0; i < r; ++i) 
       {
         if ( zp[i].getMaxOrder() && zp[i].getMinOrder() < 2 )
	   {
	     int c=min(r,zp[i].getNumVar());
	     for (j=0; j < c; ++j) 
	       {
		 M(i,j) = (zp[i])[j+1];
	       }
	   }
       }
     return M;
}
    
Vec Vps::getConstTerms() const 
{
     int r = getDim();
     Vec V(r);
     for (int i=0; i < r; ++i) 
       {
         V[i] = zp[i][0];
       }
     return V;
}

Vps Vps::operator*(double cc) const 
{
    Vps obj(dimVps);
    for (int i=0; i<dimVps; ++i) obj[i] = zp[i]*cc;
    return obj;
}

Vps Vps::operator+(const Vec & V) const 
{
  Vps obj = *this;
  obj += V;
  return obj;
}

Vps& Vps::operator+=(const Vec & V) 
{
    if (!(dimVps == V.getSize())) 
      {
	cerr << "Vps& Vps::operator+=(Vec & V): not the same dimension\n";
	exit(1);
      }
    for (int i=0; i<dimVps; ++i) 
      {
        zp[i] += V[i];
	//        zp[i][i+1] += V[i];
      }
    return *this;
}

Vps Vps::operator-(const Vec & V) const 
{
    Vps obj = *this;
    obj -= V;
    return obj;
}

Vps& Vps::operator-=(const Vec & V)
{
    if (!(dimVps == V.getSize())) 
      {
       cerr << "Vps& Vps::operator-=(Vec & V) : not the same dimension\n";
       exit(1);
      }
    for (int i=0; i<dimVps; ++i) 
      {
        zp[i] -= V[i];
	//        zp[i][i+1] -= V[i];
      }
    return *this;
}


Vec Vps::operator()(const Vec & x, int ord) const   // tracking
{
    int nVar = getNumVar();
    int order = min(getMaxOrder(), ord);
    int nm = nmo[nVar][order];
    //    int nm = nmo[nVar][getMaxOrder()];
    Vec v(dimVps);
    int i,j; // index
    for (i=0; i<dimVps; ++i) v[i] = (zp[i])[0]; // include 0th order
    //    for (i=0; i<dimVps; ++i) v[i] = 0.0;
    xxx[0] = 1.0;    
    int *ivpT, *jppT;
    ivpT = ivp[nVar];
    jppT = jpp[nVar];
    for (j=1; j < nm; ++j) xxx[j]=x[ivpT[j]]*xxx[jppT[j]];
    for (i=0; i< dimVps; ++i) 
      {
	//        for (j=1; j<nm; ++j) v[i] += (zp[i])[j]*xxx[j];
	TpsData *zpp = zp[i].Zp();   // Yunhai's sugestion for faster speed
        for (j=1; j<nm; ++j) v[i] += zpp->tps_data[j]*xxx[j];
      }
    return v;
}


Vec Vps::mxVpsTrk(const Vec & si, int ord, int& lossflag) const  // mixed Map Tracking
{
  // where v = [x,px,y,py,z,pz] style.
  // 1st step: make the linear transformation
  //  Vec si = RR*v;
  // assuming linear part if an identity -- only nonlinear part.
  // reduce ww(X,Y,Z,px,py,pz) from 6-var Vps to 3-var Vps wx(X,Y,Z).
  // 1. rearrange x for the variable order to be X,Y,Z,px,py,pz
  int i;
  int nVar = getNumVar(); int nVarh = nVar/2;
  Vec x(nVar); // ==[x,y,z,px,py,pz].
  for (i=0; i<nVarh; ++i) x[i] = si[i*2];
  for (i=nVarh; i<nVar; ++i) x[i] = si[(i-nVarh)*2+1];
  Vps w2 = (*this)(nVarh,x,ord); //[x,y,z,Px,Py,Pz]==w2(X,Y,Z) now, still 6-D.
  //  Vps wx = w2.subVps(nVarh);
  Vps wx(nVarh);  // xh = [x,y,z] == wx(X,Y,Z) and 3 dimensional now.
  for (int i=0; i<nVarh; ++i) wx[i] = w2[i]; 
  Vps wp(nVarh);  // Ph = [Px,Py,Pz]== wp(X,Y,Z) and 3 dimensional now.
  for (int i=0; i<nVarh; ++i) wp[i] = w2[i+nVarh]; 
  Vec xh(nVarh); for (i=0; i<nVarh; ++i) xh[i]=x[i];
  // solving xh =(x,y,z) = wx(X,Y,Z) for X,Y,Z, where xh is known.
  Vec XYZ = wx.newton(xh, lossflag);
  if (lossflag) return si;  // return the original ray.
  Vec Pxyz = wp(XYZ);
  for (i=0; i<nVarh; ++i) x[i*2] = XYZ[i];
  for (i=0; i<nVarh; ++i) x[i*2+1] = Pxyz[i];
  return x;
}

Vec Vps::operator*(const Vec & x) const   // tracking
{
    return (*this)(x);
}

Vps Vps::operator()(int nVarKeep, const Vec & x, int ord) const   // partial tracking
{
    int i,j; // index
    // The first "nVarKeep" are still kept as variables while
    // those not kept are evaluated with the given value of x.
    // The return Vps is kept with the same "dim" but with only "nVarKeep"
    // variables.
    int dim = getDim();
    int nVar = getNumVar();
    int order = min( getMaxOrder(), ord);
    //    int maxOrder = getMaxOrder();
    int nVarEval = nVar - nVarKeep;
    int nm = nmo[nVar][order];
    //    int nmKeep = nmo[nVarKeep][getMaxOrder()];
    int nmEval = nmo[nVarEval][order];
    //    int *jtsk; jtsk = jt[nVar][nVarKeep];
    int *jtsk; jtsk = jtf[nVar][nVarKeep];
    int *jtse; jtse = jtr[nVar][nVarEval];
    //    int *jtsKeep; jtsKeep = jt[nVarKeep][nVar];
    //    int *jtsEval; jtsEval = jtr[nVarEval][nVar];
    Vps ww(dim,nVarKeep,order);  // not asign 0 yet, so use "clear"
    ww.clear(0,order);
    Vec xsft(nVarEval); 
    for (i=0; i<nVarEval; ++i) xsft[i]= x[i+nVarKeep];
    xxx[0] = 1.0;    
    int *ivpT, *jppT;
    ivpT = ivp[nVarEval];
    jppT = jpp[nVarEval];
    for (j=1; j < nmEval; ++j) xxx[j]=xsft[ivpT[j]]*xxx[jppT[j]];
    for (j=1; j<nm; ++j)
      {
	int jtskj = jtsk[j];
	int jtsej = jtse[j];
	for (i=0; i< dim; ++i) 
	  {
	    ww[i][jtskj] += (zp[i])[j]*xxx[jtsej];
	  }
      }
    return ww;
}


int Vps::Norm(doubleMatrix& A, doubleMatrix& R, doubleMatrix& AI) {
    doubleMatrix M; M = JacobianMatrix();
    int success; 
    success = M.Norm(A, R, AI);
    return success;
}

Vps Vps::DispersedClosedOrbit( doubleMatrix& etas ) {  // assuming 4-by-5 map
      int num_var = getNumVar();
      int order = getMaxOrder();
      int dim = getDim();

      doubleMatrix etat(dim,order);
      doubleMatrix MM =linearMatrix();
      doubleMatrix NN = MM.subMatrix(dim,dim);


      // to the 1st order of delta
      doubleMatrix II(dim,1.0);
      doubleMatrix N0=II-NN;
      doubleMatrix N0inv = N0.invM(0);

      int *js; js = new int[num_var+1]; 
      for (int i=0; i<=num_var; ++i) js[i]=0;
      js[0]=1; js[num_var]=1;
      int k = jpek(num_var, js); 
      Vec shi(dim); // for (int i=0; i<dim; ++i) shi[i] = MM[i][dim];
      for (int i=0; i<dim; ++i) shi[i] = (*this)[i][k];
      Vec eta = N0inv*shi;
      for (int i=0; i<dim; ++i) etat(i,0) = eta[i]; 
      //      Vps Xco(dim+1); Xco[dim]=0.0; 
      Vps Xco = Vps::makeI(dim+1,0.0);  // Xco=0; in all dimension
      for (int i=0; i<dim; ++i) Xco[i]=Tps::makeVariable(dim)*etat(i,0);
      // Transform into the 1st order-delta closed orbit, i.e. relative to Xco;
      Vps Ivps = Vps::makeI(dim+1, 1.0);  // vec{x} = vex{x}
      Vps Xc = Xco;
      Vps XXc = Ivps + Xc;  // vec{x} = vec{x} + vec{Xc}
      Vps zz1 = (*this)(XXc);  zz1 = zz1 -Xc.subVps(dim); // transformed map

      // to the io-th-order of delta
      //      int *js; js = new int[num_var+1]; 
      for (int io=2; io<=order; ++io) {
	for (int i=0; i<=num_var; ++i) js[i]=0;
	js[0]=io; js[num_var]=io;
	k = jpek(num_var, js); 
	for (int i=0; i<dim; ++i) shi[i] = zz1[i][k];
	eta = N0inv*shi;
	for (int i=0;i<dim;++i) etat(i,io-1) = eta[i]; 
	for (int i=0;i<dim;++i) Xco[i]=Tps::makeVarPower(dim,io)*etat(i,io-1);
	Xco[dim]=Tps::makeVarPower(dim,io)*0;
	// Transform into the dispersed closed orbit, relative to Xc;
	//      Vps Ivps = Vps::makeI(dim, 1.0);  // vec{x} = vex{x}
	Xc = Xc + Xco;  // closed orbit up to the io-th order delta
	XXc = Ivps + Xc;  // vec{x} = vec{x} + vec{Xc}
	zz1 = (*this)(XXc);  
	zz1 = zz1 -Xc.subVps(dim); //the transformed map
      }
      *this = zz1;
      etas = etat;
      return Xc;
}

ostream & operator << (ostream & out, const Vps & zps) 
{
  //  static int digit = 8;
  int digit = Zlib::digit;
  Vps obj = zps;
  obj.unifyVps();
  out.flags(ios::showpoint|ios::scientific);
  static double zero=0.0;            
  static int nega=-1;  
  int dim = obj.getDim();
  int nVar = obj.getNumVar();
  int size = obj.getSize();
  out << "Vps" 
      << ' ' << dim
      << ' ' << nVar
      << ' ' << obj.getMinOrder() 
      << ' ' << obj.getMaxOrder() 
      << ' ' << obj.getAccOrder() 
      << ' ' << size
      << "\n";
  int i, noTINY;
  Vps data_obj = obj;
  int *jvv;
  //  for (int j=0; j < size; ++j) 
  for (int j=obj.nmob[nVar][obj.getMinOrder()]; j < size; ++j) 
    {
      noTINY = 0;
      for (i=0; i < dim; ++i) 
	{
	   if (fabs((data_obj[i])[j])>ZLIB_TINY) noTINY = 1;
	}
      if (noTINY) {
         for (i=0; i < dim; ++i)
	   //       out << setw(Zlib::digit+9) << setprecision(Zlib::digit)
	   if (j >= obj[i].getSize()) 
	     {
	       out << setw(digit+9) << setprecision(digit)
		   << 0 << ' ';
	     }
	   else
	     {
	       out << setw(digit+9) << setprecision(digit)
		   << (data_obj[i])[j] << ' ';
	     }
	 jvv = (obj.jv)[nVar][j];
	 //         for (i=0; i <= nVar; ++i) out << (obj.jv)[nVar][j][i] << ' ';
         for (i=0; i <= nVar; ++i) out << jvv[i] << ' ';
         out << "\n";
      }
  }
  for (i=0; i < dim; ++i)
            out << setw(12) << setprecision(4) << zero << ' ';
  for (i=0; i <= obj.ZlibNumVar; ++i) out << nega << ' ';
  out << "\n\n";
  return (out);
}	

istream & operator >> (istream & in, Vps & obj) 
{
    int dim, min_ord, max_ord, acc_ord, nVar, size;
    char star;
    in >> star >> star >> star >> dim >> nVar >> min_ord >> max_ord 
       >> acc_ord >> size;
    cout << dim << ' ' << nVar << ' ' << min_ord << ' ' << max_ord << ' '
         << acc_ord << ' ' << size << endl;
    int *js;
    int i, jpk;  // index
    js = new int[nVar+1];
    if (max_ord > Zlib::ZlibMaxOrder) {  // YAN 11/18/2004
      max_ord=Zlib::ZlibMaxOrder; 
      acc_ord=Zlib::ZlibMaxOrder; 
    }
    obj.memConstruct(dim, nVar, max_ord, acc_ord, min_ord);
    double *coef;
    coef = new double[dim];
    for (int j=0; j < size; ++j) 
      {
        for (i=0; i < dim; ++i) in >> coef[i];
        for (i=0; i <= nVar; ++i) in >> js[i];
	if (js[0] < 0) break;
	if (js[0] <= Zlib::ZlibMaxOrder) {
	  jpk = obj.jpek(nVar, js); 
	  for (i=0; i < dim; ++i) (obj[i])[jpk] = coef[i];
	}
      }
    delete [] coef;
    delete [] js;
    return (in);
}	


void Vps::getVps(ifstream& in, int dimension, int order, int var)
{
     if ( !(dimension == dimVps) ) 
       {
	 cout << "dimVps, dimension = " << dimVps << ", " << dimension << endl;
	 dimVps = dimension;
	 if (zp) delete [] zp;
	 zp = new Tps[dimVps];
       }
     for (int i=0; i < dimVps; ++i) zp[i].getTps(in, order, var);
     cout << "  getVps done\n";
}


int Vps::getDim() const { return dimVps;}
int Vps::getNumVar() const { return zp[0].getNumVar();}
int Vps::getMinOrder() const { return zp[0].getMinOrder();}
int Vps::getMaxOrder() const { return zp[0].getMaxOrder();}
int Vps::getAccOrder() const { return zp[0].getAccOrder();}
int Vps::getSize() const { return  zp[0].getSize();}

int Vps::getNumVar(int &getFlag) const 
{ 
  int numVar=zp[0].getNumVar();
  getFlag=0;
  for (int i=1; i<dimVps; ++i) 
    {
      if (zp[i].getNumVar()>numVar)
	{
	  getFlag=1;
	  numVar=zp[i].getNumVar();
	}
    }
  //  if (getFlag) :cout << "numVar not the same in Vps::getNumVar(int) const\n";
  return numVar;
}

int Vps::getAccOrder(int &getFlag) const 
{ 
  int accOrder=zp[0].getAccOrder();
  getFlag=0;
  for (int i=1; i<dimVps; ++i) 
    {
      if (zp[i].getAccOrder()<accOrder)
	{
	  getFlag=1;
	  accOrder=zp[i].getAccOrder();
	}
    }
  //  if (getFlag) :cout << "accOrder not the same in Vps::getAccOrder(int) const\n";
  return accOrder;
}

int Vps::getMinOrder(int &getFlag) const 
{ 
  int minOrder=zp[0].getMinOrder();
  getFlag=0;
  for (int i=1; i<dimVps; ++i) 
    {
      if (zp[i].getMinOrder() != minOrder) 
	{
	  getFlag = 1;
	  if (zp[i].getMinOrder()<minOrder) minOrder=zp[i].getMinOrder();
	}
    }
  //  if (getFlag) :cout << "minOrder not the same in Vps::getMinOrder(int) const\n";
  return minOrder;
}

int Vps::getMaxOrder(int &getFlag) const 
{ 
  int maxOrder=zp[0].getMaxOrder();
  getFlag=0;
  for (int i=1; i<dimVps; ++i) 
    {
      if (zp[i].getMaxOrder()>maxOrder)
	{
	  getFlag=1;
	  maxOrder=zp[i].getMaxOrder();
	}
    }
  //  if (getFlag) :cout <<"maxOrder not the same in Vps::getMaxOrder(int) const\n";
  return maxOrder;
}

int Vps::getSize(int &getFlag) const 
{ 
  int size=zp[0].getSize();
  getFlag=0;
  for (int i=1; i<dimVps; ++i) 
    {
      if (zp[i].getSize()>size)
	{
	  getFlag=1;
	  size=zp[i].getSize();
	}
    }
  //  if (getFlag) :cout << "size not the same in Vps::getsize(int) const\n";
  return size;
}

Vps Vps::derivative(int iv) const 
{
     Vps obj(dimVps);
     for (int i=0; i < dimVps; ++i) 
       {
         obj[i] = zp[i].derivative(iv);
       }
     return obj;
}

Vps Vps::PoissonBracket(const Tps & zps) const  // [zps, *this]
{
     Vps obj(dimVps);
     for (int i=0; i < dimVps; ++i) 
       {
         obj[i] = zp[i].PoissonBracket(zps);
       }
     return obj;
}

Vps PoissonBracket(const Tps & zps, const Vps & V) // [zps, V]
{
  //     Vps obj;
  //     obj = V.PoissonBracket(zps);
  //     return obj;
     return V.PoissonBracket(zps);
}

void Vps::clear(int min_ord, int max_ord) 
{
     for (int i=0; i<dimVps; ++i) zp[i].clear(min_ord, max_ord);
}

void Vps::numVarChange(int order) 
{
  for (int i=0; i<dimVps; ++i) zp[i].numVarChange(order);
}

void Vps::maxOrderChange(int order) 
{
  for (int i=0; i<dimVps; ++i) zp[i].maxOrderChange(order);
}

void Vps::maxOrderVarChange(int numVar, int order) 
{
  for (int i=0; i<dimVps; ++i) zp[i].maxOrderVarChange(numVar,order);
}

void Vps::accOrderChange(int order) 
{
  for (int i=0; i<dimVps; ++i) zp[i].accOrderChange(order);
}

void Vps::forceAccOrderChange(int order) 
{
  for (int i=0; i<dimVps; ++i) zp[i].forceAccOrderChange(order);
}

void Vps::minOrderChange(int order) 
{
  for (int i=0; i<dimVps; ++i) zp[i].minOrderChange(order);
}

void Vps::unifyVps()
{
  int flagVar, flagOrder;
  int numVar=getNumVar(flagVar);
  int order=getMaxOrder(flagOrder);
  if (flagVar || flagOrder)
    {
      maxOrderVarChange(numVar,order);
    }
  order=getMinOrder(flagOrder);
  if (flagOrder)
    {
      minOrderChange(order);
    }
}

bool Vps::checkVps()
{
  for (int i=0; i<getDim(); ++i)
    {
      if (zp[i].checkTps()) return 1;
    }
  return 0;
}

Tps Vps::mixedVps(int ord) // added for mixed var Vps with linear Identity.
{
   int i;
   doubleMatrix M; 
   M = this->linearMatrix2n();
   //   M = this->JacobianMatrix();
   if (!M.checkI()) {
        cerr << "In Vps::mixedVps(int ord);\n";
	cerr << "linear part of the Vps is not an identity *** \n";
	exit(1);
   }
   int order = min( (getMaxOrder()), ord);
   if (order >ZlibMaxOrder)  order = ZlibMaxOrder;
   int canDim2 = min(getNumVar()/2, ZlibCanDim)*2; // +++++
   doubleMatrix MD(canDim2, 1.0); 
   for (i=0; i<canDim2; i+=2) { MD(i,i) = -1.0; }
   Vps vv;
   Vps si;
   Vps y = this->homogeneous(1);
   Vps usi2 = MD*this->filter(order,2); // get (5.8) from 2nd order up
   Vps vy = usi2.homogeneous(2); // without the 1st order tentatively
   // above  3rd  order
   doubleMatrix MD2(canDim2, 1.0); 
   for (i=1; i<canDim2; i+=2) { MD2(i,i) = 0.0; }
   for (i=3; i<=order; ++i) {
      si = y + MD2*vy;
      vv = usi2.filter(i,2);
      vy = vv(si);
   }
   vy += y;
   *this = vy;  // done, we get z = vy(y); // the first return.
   Tps tps=0;
   int getgf = 0;      // get generating function if getgf = 1;
   if (getgf) {
     vv=0.5*y; 
     for (i=2; i<=order; ++i) {  
       vv += (1.0/(i+1))*vy.homogeneous(i);  
     }
     doubleMatrix SS(canDim2/2); 
     for (i=0; i<canDim2; i+=2) { SS(i,i+1) = 1.0; }
     vv = SS*vv;
     Tps tps = -vv[0].multiplyVariable(0);
     for (i=1; i<canDim2; ++i) tps -= vv[i].multiplyVariable(i);
   }
   return tps;  // the second return.
}

// re-order var sequence based on pnt. But not the map sequence. 
// BE VERY CAREFUL at this point.***
Vps Vps::reOrderVar(int *pnt) const {
  int i;
  int nVar = getNumVar(); 
  cout << " You are re-ordering the variable sequence as follows: ";
  for (i=0; i<nVar; ++i) cout << pnt[i];
  cout << endl;
  Vps vv(nVar);
  for (i=0; i<nVar; ++i) vv[i] = Tps::makeVariable(pnt[i]);
  Vps ww = (*this)(vv);  // ww(X,Y,Z,px,py,pz) now
  return ww;
}

Vps Vps::inverseGenerating(Tps & gf) {  // Eq. (5.7).
   int nVar = gf.getNumVar();
   Vps vp(nVar);
   for (int i=0; i<nVar; ++i) vp[i] = gf.derivative(i);
   doubleMatrix SS(nVar/2); 
   for (int i=0; i<nVar; i+=2) { SS(i,i+1) = 1.0; }
   *this = - (SS*vp);
   return *this;
}

Vec Vps::newton(Vec xh, int& lossflag) // xh=[x,y,z] given for newton Raphson shooting X,Y,Z
{
  lossflag = 0;
  doubleMatrix MM = this->linearMatrix(); 
  // MM = inv(MM)   
  if (!MM.inv()) {cerr <<" no matrix inverse in Vps::newton.\n"; return(1); }
  // x = MM^-1*(xh-w(X0)); X0 is a guessed, iterated till X0 = w(X0).
  Vec X0=xh; // initial guess.
  /*  element guess for ray = 
  X0[0]=2.47416151307626973E-03;
  X0[1]=9.30192543940975419E-06;
  X0[2]=-2.46959644327343630E-03;
  */
  Vec F =  xh - (*this)(X0);
  double residualp=F.norm();
  double residual;
  for (int i=0; i<1000; ++i) {
    Vec x = MM*F;
    X0 = x+X0;
    F =  xh - (*this)(X0);
    residual = F.norm();    //    residual = x.norm();
    //    cout << residual << ' ';
    if (residual > residualp) {
      for (int k=0; k<100; ++k) {
	x = 0.8*x; 
	X0=X0-x;
	F =  xh - (*this)(X0);
	residual = F.norm();
	if (residual < residualp) break;
      }
      if (residual > residualp) {
	lossflag = 1;
	cerr<<"Generating track does not converge. Residaul = "<< residual
	    << " at " << i+1 << "th iteration." << endl;
	return X0;
      }
    } 
    if ( residual < 1.e-16 ) break;
    residualp = residual;
  }
  if (residual > 1.e-12) {
     cout << "residual = " << residual << endl;
     cerr << "Be careful, may not be converge, check residual = " 
          << residual << " *** \n";
  }
  return X0;
}

/*
Vec Vps::newton(Vec xh, int& lossflag) // xh=[x,y,z] given for newton Raphson shooting X,Y,Z
{
  lossflag = 0;
  Vec XYZ;
  Vps w2 = this->filter(getMaxOrder(),2);
  Vec w0 = this->getConstTerms();
  doubleMatrix MM = this->linearMatrix(); 
  if ( !MM.inv() ) {   // MM = inv(MM)   
    cerr << " no matrix inverse in Vps::newton.\n";
    return(1);
  }
  // XYZ = MM^-1*(xh-w0)-w2(X0); X0 is a guessed, iterated till X0 = XYZ.
  Vec XYZ0 = MM*(xh - w0);
  Vec X0=xh; // initial guess.
  double residual;
  for (int i=0; i<1000; ++i) {
    Vec tp = w2(X0); 
    XYZ = XYZ0 - MM*tp;
    Vec dif = XYZ-X0; 
    residual = dif.norm();
    if (residual > 1) {
      lossflag = 1;
      cerr<<"Generating track does not converge. Residaul = "<< residual
	  << " at " << i+1 << "th iteration." << endl;
      return XYZ;
    }
    if ( residual < 1.e-15 ) break;
    X0 = XYZ;
  }
  if (residual > 1.e-12) {
     cerr << "Be careful, may not be converge, check residual = " 
          << residual << " *** \n";
  }
  return XYZ;
}
*/

Vps Vps::excludeNoParaDependentTerms(int lastindxs) const {
  Vps obj(dimVps);
  for (int i=0; i<dimVps; ++i) 
    (obj.zp)[i]=zp[i].excludeNoParaDependentTerms(lastindxs);
  return obj;
}

Vps Vps::nonlinearBetaParaTerms(int lastindxs) const {
  Vps obj(dimVps);
  for (int i=0; i<dimVps; ++i) 
    (obj.zp)[i]=zp[i].nonlinearBetaParaTerms(lastindxs);
  return obj;
}

Vps& Vps::memConstruct(int dimension, int nvar, int max_ord, int acc_ord, int min_ord) 
{
  if (dimVps != dimension)
    {
      if (zp) delete [] zp;
      dimVps = dimension;
      zp = new Tps[dimVps];
    }       
  for (int i=0; i<dimVps; ++i) 
    {
      zp[i].memConstruct(nvar, max_ord, acc_ord, min_ord);
    }
  return *this;
}


Tps Vps::singleLie2n(int ord) const
{
   doubleMatrix M; 
   M = this->linearMatrix2n();
   //   M = this->JacobianMatrix();
   if (!M.checkI()) {
        cerr << "In Vps::singleLie() const\n";
	cerr << "linear part of the Vps is not an identity *** \n";
	exit(1);
   }
   int order = min( (getMaxOrder()+1), ord);
   if (order >ZlibMaxOrder)  order = ZlibMaxOrder;
   int i,n,m;
   Tps gi;
   Vps *wnm = new Vps[order];
   for (n=2; n < order; ++n) {
     for (m=2; m < n; ++m) {
       i=1;
       if ( wnm[m].getDim() )   wnm[m] += 
	  ((wnm[m-1]).homogeneous(n-i)).PoissonBracket(gi.homogeneous(i+2))/m;
       else  wnm[m] = 
          ((wnm[m-1]).homogeneous(n-i)).PoissonBracket(gi.homogeneous(i+2))/m;
       for (i=2; i<=(n-m); ++i)  wnm[m] += 
          ((wnm[m-1]).homogeneous(n-i)).PoissonBracket(gi.homogeneous(i+2))/m;
     }
     if ( wnm[1].getDim() ) wnm[1] += homogeneous(n); 
     else wnm[1] = homogeneous(n); 
     for (m=2; m<n; ++m) {
       wnm[1] -= wnm[m].homogeneous(n); 
     }	      
     wnm[0] = (wnm[1]).homogeneous(n)/(-(n+1));
     if (n>2) gi += (wnm[0])[0].multiplyVariable(1);
     else gi = (wnm[0])[0].multiplyVariable(1);
     for (i=2; i < getDim(); i+=2) {    // iv starts with 0  NOT 1!!!!
       gi += (wnm[0])[i].multiplyVariable(i+1);
     }
     for (i=1; i < getDim(); i+=2) {
       gi -= (wnm[0])[i].multiplyVariable(i-1);
     }
   }
   gi.accOrderChange(gi.getMaxOrder());
   return gi;
}

Tps Vps::singleLie65(int ord) const
{
   doubleMatrix M; 
   M = this->linearMatrix2n();
   //   M = this->JacobianMatrix();
   if (!M.checkI()) {
        cerr << "In Vps::singleLie() const\n";
	cerr << "linear part of the Vps is not an identity *** \n";
	exit(1);
   }
   int order = min( (getMaxOrder()+1), ord);
   if (order >ZlibMaxOrder)  order = ZlibMaxOrder;
   int i,n,m;
   int canDim2 = min(getNumVar()/2, ZlibCanDim)*2; canDim2=4;// +++++
   Tps gi;
   Vps *wnm = new Vps[order];
   for (n=2; n < order; ++n) {
     for (m=2; m < n; ++m) {
       i=1;
       if ( wnm[m].getDim() )   wnm[m] += 
	  ((wnm[m-1]).homogeneous(n-i)).PoissonBracket(gi.homogeneous(i+2))/m;
       else  wnm[m] = 
          ((wnm[m-1]).homogeneous(n-i)).PoissonBracket(gi.homogeneous(i+2))/m;
       for (i=2; i<=(n-m); ++i)  wnm[m] += 
          ((wnm[m-1]).homogeneous(n-i)).PoissonBracket(gi.homogeneous(i+2))/m;
     }
     if ( wnm[1].getDim() ) wnm[1] += homogeneous(n); 
     else wnm[1] = homogeneous(n); 
     for (m=2; m<n; ++m) {
       wnm[1] -= wnm[m].homogeneous(n); 
     }	      
     //+++ 45 begin
     wnm[0] = (wnm[1]).homogeneous(n);
     for (i=0; i < canDim2; i+=2)  // - S*Wnm
       {
	 Tps temp = wnm[0][i];
	 wnm[0][i] = wnm[0][i+1];
	 wnm[0][i+1] = -temp;
       }
     if (n>2) gi += wnm[0].lineIntegralDiagonal(canDim2);
     else gi = wnm[0].lineIntegralDiagonal(canDim2);
   }
   gi.accOrderChange(gi.getMaxOrder());
   return gi;
}

Tps Vps::singleLie(int ord) const
{
   doubleMatrix M; 
   M = this->linearMatrix2n();
   //   M = this->JacobianMatrix();
   if (!M.checkI()) {
        cerr << "In Vps::singleLie() const\n";
	cerr << "linear part of the Vps is not an identity *** \n";
	exit(1);
   }
   int order = min( (getMaxOrder()+1), ord);
   if (order >ZlibMaxOrder)  order = ZlibMaxOrder;
   int i,n,m;
   int canDim2 = min(getNumVar()/2, ZlibCanDim)*2; // +++++
   Tps gi;
   Vps *wnm = new Vps[order];
   for (n=2; n < order; ++n) {
     for (m=2; m < n; ++m) {
       i=1;
       if ( wnm[m].getDim() )   wnm[m] += 
	  ((wnm[m-1]).homogeneous(n-i)).PoissonBracket(gi.homogeneous(i+2))/m;
       else  wnm[m] = 
          ((wnm[m-1]).homogeneous(n-i)).PoissonBracket(gi.homogeneous(i+2))/m;
       for (i=2; i<=(n-m); ++i)  wnm[m] += 
          ((wnm[m-1]).homogeneous(n-i)).PoissonBracket(gi.homogeneous(i+2))/m;
     }
     if ( wnm[1].getDim() ) wnm[1] += homogeneous(n); 
     else wnm[1] = homogeneous(n); 
     for (m=2; m<n; ++m) {
       wnm[1] -= wnm[m].homogeneous(n); 
     }	      
     //+++ 45 begin
     wnm[0] = (wnm[1]).homogeneous(n);
     for (i=0; i < canDim2; i+=2)  // - S*Wnm
       {
	 Tps temp = wnm[0][i];
	 wnm[0][i] = wnm[0][i+1];
	 wnm[0][i+1] = -temp;
       }
     if (n>2) gi += wnm[0].lineIntegralDiagonal(canDim2);
     else gi = wnm[0].lineIntegralDiagonal(canDim2);
   }
   gi.accOrderChange(gi.getMaxOrder());
   return gi;
}

Tps Vps::orderLie2n(int ord) const
{
   int iv;
   doubleMatrix M; 
   M = this->linearMatrix2n();
   //   M = this->JacobianMatrix();
   if (!M.checkI()) {
        cerr << "In Vps::orderLie() const\n";
	cerr << "linear part of the Vps is not an identity *** \n";
	exit(1);
   }
   int order = min( (getMaxOrder()+1), ord);
   if (order >ZlibMaxOrder)  order = ZlibMaxOrder;
   Vps temp = *this;
   Vps temp2;
   Tps ff, gi; 
   int n=2;
     temp2 = temp.homogeneous(n)/(-(n+1));
     gi = temp2[0].multiplyVariable(1);
     for (iv=2; iv < getDim(); iv+=2) {    // iv starts with 0  NOT 1!!!!
       gi += temp2[iv].multiplyVariable(iv+1);
     }
     for (iv=1; iv < getDim(); iv+=2) {
       gi -= temp2[iv].multiplyVariable(iv-1);
     }
     ff = gi;
   for (n=3; n<order; ++n) {
     temp -= gi.singleLieTaylor();
    //     temp = temp.filter(order,n);
     temp.filtering(order,n);
     temp = temp.LieVps(-gi);
     temp2 = temp.homogeneous(n)/(-(n+1));
     gi = temp2[0].multiplyVariable(1);
     for (iv=2; iv < getDim(); iv+=2) {    // iv starts with 0  NOT 1!!!!
       gi += temp2[iv].multiplyVariable(iv+1);
     }
     for (iv=1; iv < getDim(); iv+=2) {
       gi -= temp2[iv].multiplyVariable(iv-1);
     }
     ff += gi;
   }
   ff.accOrderChange(ff.getMaxOrder());
   return ff;
}

Tps Vps::orderLie(int ord) const
{
   int i;
   doubleMatrix M; 
   M = this->linearMatrix2n();
   //   M = this->JacobianMatrix();
   if (!M.checkI()) {
        cerr << "In Vps::orderLie() const\n";
	cerr << "linear part of the Vps is not an identity *** \n";
	exit(1);
   }
   int order = min( (getMaxOrder()+1), ord);
   if (order >ZlibMaxOrder)  order = ZlibMaxOrder;
   int canDim2 = min(getNumVar()/2, ZlibCanDim)*2; // +++++
   Vps temp = *this;
   Vps temp2;
   Tps ff, gi; 
   int n=2;
     temp2 = temp.homogeneous(n);
     for (i=0; i < canDim2; i+=2)  // - S*Wnm
       {
	 Tps temp3 = temp2[i];
	 temp2[i] = temp2[i+1];
	 temp2[i+1] = -temp3;
       }
     gi = temp2.lineIntegralDiagonal(canDim2);
     ff = gi;
   for (n=3; n<order; ++n) {
     temp -= gi.singleLieTaylor();
    //     temp = temp.filter(order,n);
     temp.filtering(order,n);
     temp = temp.LieVps(-gi);
     temp2 = temp.homogeneous(n);
     for (i=0; i < canDim2; i+=2)  // - S*Wnm
       {
	 Tps temp3 = temp2[i];
	 temp2[i] = temp2[i+1];
	 temp2[i+1] = -temp3;
       }
     gi = temp2.lineIntegralDiagonal(canDim2);
     ff += gi;
   }
   ff.accOrderChange(ff.getMaxOrder());
   return ff;
}

Tps Vps::homoOrderLie(int ord) const
{
   int i;
   int canDim2 = min(getNumVar()/2, ZlibCanDim)*2; // +++++
   Vps temp = *this;
   Vps temp2;
   Tps ff; 
   int n=ord-1;
   temp2 = temp.homogeneous(n);
   for (i=0; i < canDim2; i+=2)  // - S*Wnm
     {
       Tps temp3 = temp2[i];
       temp2[i] = temp2[i+1];
       temp2[i+1] = -temp3;
     }
   ff = temp2.lineIntegralDiagonal(canDim2);
   //   ff.accOrderChange(ff.getMaxOrder());
   return ff;
}

Vps Vps::LieVps(const Tps& zps) const {
      int maxOrder = getAccOrder();
      if (maxOrder > ZlibMaxOrder) maxOrder = ZlibMaxOrder;
      int minOrder = zps.getMinOrder();
      int npb;
      if (minOrder < 3)
	{
	  npb = 15;
	  cerr << " *** warning Tps::LieVps: minOrder < 3\n";
	}
      else 
	{
	  npb = ( maxOrder - getMinOrder() ) / ( minOrder-2 );
	}
      Vps obj = *this;
      Vps temp = *this;
      int fac = 1;
      for (int i=1; i<=npb; ++i) {
	  temp = temp.PoissonBracket(zps);
	  fac *=i;
          obj += temp/fac;
      }         
      return obj;
}

Tps Vps::lineIntegralDiagonal(int nVar, double c) const 
{
  if (nVar > ZlibNumVar || nVar < 1)   // iv starts with 0  NOT 1 !!!!
    {
      cerr << "in Tps Vps::lineIntegralDiagonal(int nVar, double c) const; "
	   << " your argument nVar = " << nVar << " is out of bound\n";
      exit(1);
    }	   
  Vps vv(nVar);
  int i;
  for (i=0; i<nVar; ++i) vv[i] = (*this)[i].lineIntegralDiagonal(nVar, c);
  Tps obj = vv[0].multiplyVariable(0);
  for (i=1; i<nVar; ++i) obj += vv[i].multiplyVariable(i);
  return obj;
}

/*
Tps Vps::lineIntegralDiagonal(int nVar, double c) const 
{
  if (nVar > ZlibNumVar || nVar < 1)   // iv starts with 0  NOT 1 !!!!
    {
      cerr << "in Tps Vps::lineIntegralDiagonal(int nVar, double c) const; "
	   << " your argument nVar = " << nVar << " is out of bound\n";
      exit(1);
    }	   
  int dim = getDim();
  Vps vv(dim);
  int i;
  for (i=0; i<dim; ++i) vv[i] = (*this)[i].lineIntegralDiagonal(nVar, c);
  Tps obj = vv[0].multiplyVariable(0);
  for (i=1; i<dim; ++i) obj += vv[i].multiplyVariable(i);
  return obj;
}
*/

Tps Vps::lineIntegral1D(int iv, double c) const 
{
  return (*this)[iv].lineIntegral1D(iv, c);
}

void Vps::condense(double eps)
{
  for (int i=0; i<getDim(); ++i) (*this)[i].condense(eps);
}

void Vps::ratio(const Vps& vps)
{
  for (int i=0; i<dimVps; ++i) zp[i].ratio(vps[i]);
}

