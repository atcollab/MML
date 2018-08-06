#ifndef Vps_HH
#define Vps_HH
//  Filename:     Vps.hpp
//  ---------------------------------------------------------------------------
//  Category:     TPSA
//  ---------------------------------------------------------------------------
//  Release version:  $$.$$.$$
//  ---------------------------------------------------------------------------
//  Copyright:    see Copyright.hpp
//  ---------------------------------------------------------------------------
//  Description:  
//     Declared class:  Vps (Vector truncated Power Series) in Zlib
//  ---------------------------------------------------------------------------
//  Author:       Yiton T. Yan                 
//  Maintenance:
//     30-Jan-97, Original version,  Yiton T. Yan, SLAC.
//  ---------------------------------------------------------------------------

#include "Zlib.hpp"

class Vec;
class doubleMatrix;
class Tps;

//  -------------------------------------------------------------------
class Vps: public Zlib {
  friend class Tps;
  friend class DepritLie;
  friend class DepritLieLn;
  friend class DepritLie45;
  friend class DepritLieLn45;
  friend class DepritTaylor;
  friend class DepritTaylorLn;
  friend class DragtLie;
  friend class DragtLieLn;
  friend class DragtLie45;
  friend class DragtLieLn45;
  friend class mxVps;

public:
  // construction and destruction
  Vps();
  Vps(int dimension, int number_of_variables=-1, int order=-1);
  Vps(const Vps& zps);
  Vps(Tps * u, int dimension);  
  Vps(const doubleMatrix& M);  // linear Vps with 0 in 0th order
  Vps(const Vec & V);    // 0th order Vps
  Vps(const Vec & V, const doubleMatrix& M);  // linear Vps
  static Vps makeI(int dimension, double cc=1.0); //return an (cc*Identity) Vps
  ~Vps();

  Tps operator[](int i) const; // Vps dimension start from 0th
  Tps& operator[](int i) ;     // Vps dimension start from 0th
  Tps operator()(int i) const; // Vps dimension start from 1st for Lego use
  Tps& operator()(int i) ;     // Vps dimension start from 1st for Lego use
  Vps& operator=(const Vps& zps);        // assignment

  Vps truncate(int order, int acc_order =999) const; 
  // return a Vps of homogeneous order for the first nVar variables or all Vars
  Vps homogeneous(int order, int nVar=999, int acc_order=999) const;   
  Vps filter(int max_order, int min_order=0, int acc_order=999) const;   
  void filtering(int max_order, int min_order=0);   
                       // Vps truncated at max_order and set up min_order
  Vps append(int para) const; // append parameter dimensions.
  Vps subVps(int dim) const; // pick the first dim dimension of the Vps
  Vps subVps(int dim, int nVar) const; // pick the first dim dimension of 
                                       // the Vps up to nVar variables

  Vps operator+() const; // get +Vps
  Vps operator-() const; // get -Vps
  Vps operator+(const Vps& zps) const;
  Vps& operator+=(const Vps& zps);
  Vps operator-(const Vps& zps) const;
  Vps& operator-=(const Vps& zps);


  Vps operator() (const Vps& zps) const; // concatenation, uu*vv = uu(vv)
                                         // Tps(Vps) is in Tps.hpp
  Vps operator()(const doubleMatrix& M) const; // = uu.concatenate(M) = uu(M x)
                                         // Tps(doubleMatrix) is in Tps.hpp
  friend Vps operator*(const doubleMatrix& M, const Vps & zps); // M*uu = M uu

  Vps inverse() const;  // == inverse Taylor map, // inline inverse(Vps) at end
  Vps operator/(const Vps& zps) const;    //= uu/vv = uu(inverse(vv))
  Vps& operator/=(const Vps& zps);      // uu = uu/=vv = uu(inverse(vv))

  doubleMatrix JacobianMatrix() const; // get the Jocobian doubleMatrix of a Vps at X=0
  doubleMatrix linearMatrix() const; // get the linear part into a doubleMatrix
  doubleMatrix linearMatrix2n() const; // get the linear part into a VpsMatrix
  Vec getConstTerms() const;     // extract the 0th order from the Taylor map
  Vps operator*(double cc) const;

  Vps operator+(const Vec & V) const;
  Vps& operator+=(const Vec & V);
  Vps operator-(const Vec & V) const;
  Vps& operator-=(const Vec & V);

  Vec operator() (const Vec & x, int order=99) const;  // Taylor Map Tracking
  Vec operator * (const Vec & x) const;      // Taylor Map Tracking
  // mixed Varaiable tracking
  Vec mxVpsTrk(const Vec & x, int order, int &lossflg) const; // mxMap Tracking,   Added for mixed Variable tracking.
// Partial Taylor Map Tracking; the 1st nVarkeep variables are still variables
  Vps operator() (int nVarKeep, const Vec & x, int order=99) const;
  int Norm(doubleMatrix& A, doubleMatrix& R, doubleMatrix& AI);
  // returned dispersed closed orbit as Vps;  and *this is updated to the Vps
  // w.r.t. the dispersedclosed orbit Xc; Xc == sum of eta(i-1)*delta^i
  Vps DispersedClosedOrbit(doubleMatrix& eta); // order by order process

  friend ostream & operator << (ostream &, const Vps &);
  friend istream & operator >> (istream &, Vps &);
  void getVps(ifstream&, int dimension=1, int order=999, int var=999);
  int getDim() const;        //get Vps dimension
  int getNumVar() const;     // get number of variables
  int getNumVar(int &) const;     // get number of variables
  int getMinOrder() const;   // get minimum order
  int getMinOrder(int&) const;   // get minimum order
  int getMaxOrder() const;   // get maximum order
  int getMaxOrder(int&) const;   // get maximum order
  int getAccOrder() const;   // get accuracy order
  int getAccOrder(int&) const;   // get accuracy order
  int getSize() const; // = number of monomial of maximum order of the Vps
  int getSize(int&) const; // = number of monomial of maximum order of the Vps

  Vps derivative(int iv) const;
  friend Vps PoissonBracket(const Tps & zps, const Vps & V);  // [zps, V]
  void clear(int min_ord, int max_ord);
  Tps singleLie2n(int order=99) const; // Lie2 single-Lie transformation from 
                                     // a linear-identity n-jet Vps
  Tps singleLie65(int order=99) const; // Lie2 single-Lie transformation from 
                                     // a linear-identity n-jet Vps of 6-by-5
  Tps singleLie(int order=99) const; // Lie2 single-Lie transformation from 
                                     // a linear-identity n-jet Vps of 4-by-5
  Tps orderLie2n(int order=99) const;// Lie5 order-by-order Lie transformation 
  Tps orderLie(int order=99) const;  // from a linear-identity n-jet Vps
  Tps homoOrderLie(int order) const;  // from a linear-identity n-jet Vps

  Vps LieVps(const Tps& zps) const; // Lie6 == exp(:zps:)Vps;
  Tps lineIntegralDiagonal(int nvar, double c=1.0) const; //along diagoanl of 
            // th first nVar variables while keeping other variables unchanged.
  Tps lineIntegral1D(int iv, double c=1.0) const; //along 1-D while keeping
                                                // other variables to be 0.
  void condense(double eps = 1.e-10);
  void ratio(const Vps& vps); // for each element ratio 

  // interface with Lego:
  void forceAccOrderChange(int order); //change a Vps accuracy order forcefully
  void unifyVps();
  bool checkVps();
  // two returns for Tps== generating function, *this for mixed Vps.
  // added for mixed varable Vps in Oct 2004
  Tps mixedVps(int order=99);  // from a linear-identity n-jet Vps
// re-order var sequence based on pnt. But not the map sequence. 
// BE VERY CAREFUL at this point.***
  Vps reOrderVar(int *pnt) const;//re-ordering variable sequence based on pnt.
  Vps inverseGenerating(Tps & gf);  // Eq. (5.7).
  Vec newton(Vec xh, int& lossflag); // xh=[x,y,z] given for newton Raphson shooting X,Y,Z
  Vps excludeNoParaDependentTerms(int lastindxs=1) const;
  Vps nonlinearBetaParaTerms(int lastindxs=1) const;
  // moved out from private for mxVpsLn use
  Vps& memConstruct(int dim, int nvar, int max_ord, int acc_ord=999, int min_ord=0); 
  Vps operator*(const doubleMatrix& M) const;  // = uu.concatenate(M) = uu(M)

private:
  Tps *zp;
  int dimVps;
  Vps(const Vps& zps, int max_order, int min_ord = 0, int acc_order = 999);

  // concatenation, uu.concatenate(vv) = uu(vv) up to order
  Vps concatenate(const Vps & zps, int order=999) const; 
  Vps operator*(const Vps& zps) const; 
  Vps& operator*=(const Vps& zps);       //  uu = {uu *= vv} = uu(vv)
  friend Tps operator*(const Tps& tp, const Vps & zps);//u*vv = u(vv) in Tps.hpp
  Vps PoissonBracket(const Tps & Zps) const;  // [Zps, *this] 
  void numVarChange(int numVar); // change a Vps number of variables.
  void maxOrderChange(int order); // change a Vps maximum order 
  void maxOrderVarChange(int numVar, int order);
  void minOrderChange(int order); // change a Vps minimum order 
  void accOrderChange(int order); // change a Vps accuracy order
  //      Vps(const Tps& H); //?? Lie1 copy from a Hamiltonian !!further discussion
  bool jpcMemNotDone() const;
};

inline Vps operator*(double cc, const Vps &zps) { return zps * cc; }
inline Vps operator/(const Vps &zps, double cc) { return zps * (1.0/cc); }
inline Vps operator/(double cc, const Vps &zps) { return zps.inverse() * cc; }
inline Vps operator+(const Vec & V, const Vps& zps) { return zps+V; }
inline Vps operator-(const Vec & V, const Vps& zps) { return ( (-zps)+V); }
inline Vps inverse(Vps& zps) { return zps.inverse(); }// == inverse Taylor map

#endif  //Vps_H


