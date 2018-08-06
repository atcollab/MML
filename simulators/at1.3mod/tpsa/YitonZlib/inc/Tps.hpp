#ifndef TPS_HH
#define TPS_HH
//  Filename:     Tps.hpp
//  -------------------------------------------------------------------
//  Category:     TPSA
//  -------------------------------------------------------------------
//  Release version:  $$.$$.$$
//  -------------------------------------------------------------------
//  Copyright:    See Copyright.hpp
//  -------------------------------------------------------------------
//  Description:  
//     Declared class:  Tps (Truncated Power Series) for
//     Truncated power series algebra in Zlib
//  -------------------------------------------------------------------
//  Author:       Yiton T. Yan                 
//  Maintenance
//     31-JAN-96, Original version,  Yiton T. Yan, SLAC. 
//  -------------------------------------------------------------------


//#include <complex>
#include "TpsData.hpp"
#include "Zlib.hpp"

class Vec;
class Ray;
class doubleMatrix;
class Vps;
//class DepritLie;

//  -------------------------------------------------------------------
class Tps: public Zlib {
      friend class Vps;
      friend class Dps;
      friend class ResMap;
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

  // the static member function
  // Tps::ZlibNerve(maximum_variables, maximum_order, canonical_dimension);
  // is suggested to be called first to establish the Zlib Nerve
  // MAXIMUM NUMBER OF VARIABLES AND MAXIMUM ORDER before use 
  // of Tps and Vps. You may go ahead without calling the nerve
  // first. However, this may involve with auto-re-construction of the Zlib 
  // nerve if, later, the order or the number of variables becomes larger. 
  // Re-construction of nerve does not affect your existing Tps's (OK!!).
  // Canonical dimension is represented 
  // by a static global parameter which can be assigned by default such that 
  // it is equal to maximm_variables/2 (e.g. 5/2 = 2). 
  // For exmaple: Tps::nerve(5,9); for 5-variable, 9th-order nerve, with
  // a canonical dimension of 2; or Tps::nerve(6,5,2); for 5th order, 
  // 6 variable nerve, with a canonical dimension of 2;

  // One can change the canonical dimension by using 
  // Tps::canonicalDimension(int canonical_dimension);


  static void ZlibNerve(int maximum_variables, int maximum_order, 
                    int canonical_dimension=999);
  static  void canonicalDimension(int canonical_dimension);
  static void ZlibDone();   // to release Tps memory before exit.
  Tps();                              // default constructor, point to null
  Tps(int nVar, int order); // Construct a Tps of nVar varialbes of order
  Tps(const Tps& zps);             // shallow copy (copy a pointer)
  Tps(const Tps& zps, int max_ord, int min_order=0, int acc_order=999, int nVar=999);   // deep copy (actual data copy)
  Tps(double cc);                  // Oth order Tps; nVar is Ok!
  ~Tps();                          // destructor
  Tps& operator=(const Tps& zps);     // assignment
  Tps& operator=(double cc);          // assign a double to a 0th order Tps
  Tps truncate(int order, int acc_order=999) const;
  // return a Tps of homogeneous order in the first nVar variables or all Vars
  Tps homogeneous(int order, int nVar=999, int acc_order=999) const; 
  Tps filter(int max_order, int min_order=0, int acc_order=999) const;   
  void filtering(int max_order, int min_order=0);   
     // Tps truncated at max_order with a minimum order min_order
  Tps subTps(int nVar) const; // grading  to only the first nVar variables
  double operator[](int power[]) const;  // X[power] = the term of
  double & operator[](int power[]);      // (x_0^power[0])(x_1^power[1]) ...
  
  static Tps makeVariable(int i); // nVar = i+1 (Ok); Tps = x_i, i start from 0
  static Tps makeVarPower(int i, int o); //nVar = i+1 (Ok); Tps = x_i**o, 
  static Tps makeMonomial(int nVar, int power[], double cc=1.0); 
                                   // Tps = cc (x_1^power[0])(x_2^power[1] ...)

  Tps operator+() const;  // get +Tps, Do we need this one -- does not hurt?
  Tps operator-() const;  // get -Tps
  Tps operator+(const Tps& zps) const;
  Tps operator-(const Tps& zps) const;
  Tps operator*(const Tps& zps) const;
  Tps operator/(const Tps& zps) const;

  Tps operator+(double cc) const;
  Tps operator-(double cc) const;
  Tps operator*(double cc) const;
  Tps operator/(double cc) const;

  Tps& operator+=(const Tps& zps);
  Tps& operator-=(const Tps& zps);
  Tps& operator*=(const Tps& zps);
  Tps& operator/=(const Tps& zps);

  Tps& operator+=(double cc);
  Tps& operator-=(double cc);
  Tps& operator*=(double cc);
  Tps& operator/=(double cc);

  void clear(int min_ord=0, int max_ord=999, int nVar=999); // clear Tps
  bool operator==(const Tps& zps) const;    // equality of Tps's
  bool operator!=(const Tps& zps) const;

  friend ostream & operator << (ostream &, const Tps &);
  //  friend ostream & operator << (ostream &, const Vps &);
  friend istream & operator >> (istream &, Tps &);
  //  friend istream & operator >> (istream &, Vps &);
  //  void getTps(ifstream&, int order=999);
  void getTps(ifstream&, int order=999, int var=999);

  //  Tps multiply(const Tps & zps, int order=999, int nVar=999) const; 
  Tps multiply(const Tps & zps, int nVar=999) const; 
             // allow for multiplication up to min(order, maxmumOrderOfNerve);

  //  Tps divide(const Tps & zps, int order=100, int nVar=999) const;
  Tps divide(const Tps & zps, int nVar=999) const;
             // allow for multiplication up to min(order, maxmumOrderOfNerve);

  Tps inverse(int order=999) const; 
                        // define 1/Tps up to min(order, maxmumOrderOfNerve);
  
  int getNumVar() const;  // return the Tps number of variables
  int getMaxOrder() const;  // return the Tps maximum order
  int getAccOrder() const;  // return the Tps accuracy order
  int getMinOrder() const;  // return the Tps minimum order
  int getMemOrder() const;  // return the Tps memory order
  int getSize() const;   // return the Tps array size up to the max_order
  bool checkTps();
  void condense(double eps=1.e-10); // put value < eps to 0.
  void ratio(const Tps &tps); // ratio for each corresponding coefficient.
  void condenseMinOrder(int minOrder=0); // condense the range of the 
  void condenseMaxOrder(int minOrder=0); // min order to the max order.
  //       void condenseNumVar(); // 
  int getCount() const {return zp->getCount();}  // tbd 

  // return patial derivative with respect to variable number iv 
  Tps derivative(int iv)  const;        // iv starts with 0  NOT 1 !!!!
  // integration with respect to variable number iv 
  Tps integral(int iv) const;           // iv starts with 0  NOT 1 !!!!
  // Tps multiplied by the ivth variable
  Tps multiplyVariable(int iv) const;      // iv starts with 0  NOT 1 !!!!
  Tps plusVariable(int iv) const;          // iv starts with 0  NOT 1 !!!!
  Tps minusVariable(int iv) const;         // iv starts with 0  NOT 1 !!!!

  friend Tps pwr( const Tps&, int n); // n can be 0, negative, or positive
  friend Tps sin(const Tps &);
  friend Tps cos(const Tps &);
  friend Tps sqrt(const Tps & zps);
  friend Tps exp(const Tps& zps);
  friend Tps log(const Tps& zps);

  static void setTpsOutputPrecision(int); 

  TpsData* Zp() const {return zp;}
  double operator() (const Ray & x, int sorder=0) const;// 1-D Map Tracking
  double operator() (const Vec & x) const;      //1-D Taylor Map Tracking
  Tps operator()(const Vps&) const; // = Tps u.concatenate(Vps) = u(Vps)
  Tps operator()(const doubleMatrix& M) const; //= Tps u.concatenate(M)= u(M x)
  friend Tps PoissonBracket(const Tps & zps1, const Tps & zps2); //[zps1, zps2]
  Vps singleLieTaylor() const;  // Lie2
  Vps singleLieTaylor(int) const;  // Lie2 --- to be deleted
  doubleMatrix f2Matrix(int n2=20) const;  // M = exp(:f2:)
  Vps f2Vps(int n2=20) const;  // Vps = exp(:f2:)
  Vps f2VpsPara(int n2=20) const;  // order >= 2 including parameter variables
  Vps orderLieTaylor(int flag=0) const;  // Lie7 flag=1 means reverse process
  Vps orderLieTaylor2n() const;  // Lie7
  // deleted to use the argument for a flag to do reverse process.
  //  Vps orderLieTaylor(int order) const;  
  Vps LieVps(const Vps& zps) const; // exp(:f:) Vps;
  Tps lineIntegral1D(int iv, double c=1.0) const; //along 1-D while keeping
                               // the other D variable as 0
  friend Tps BCH(const Tps& z1, const Tps& z2, int o=99);// exp(:z1:)exp(:z2:),
         // will perform BCH up to maximum accuracy limited by maximum order 
         // unless o (BCH order) is specified to be less than 5
  Vps inverseGenerating(int order=99) const;  // Eq. (5.7). gf to mixed Vps.
  // get the normal form generator Fi for the homogeneous order i from fi;
  Tps getFi(int theOrder, double mux, double muy, Tps& hi) const;  
  Tps convert_hi2fi(int canD) const;
  Tps excludeNoParaDependentTerms(int lastindxs=1) const;
  Tps nonlinearBetaParaTerms(int lastindxs=1) const;
  void deltaGiven(double eps=1, int lastindxs=1);
  static int numTpsUse;
  static int nullTpsDel;
  static int numTpsStr;
  static int capNumTpsStr;

//protected:
  double operator[](int i) const; // Tps X(order); x[0] = const term;
  double & operator[](int i);    // X[i] = (i+1)th monomial term; try
                                 // not to use it externally;
  // moved out from private for mxVpsLn use.
  Tps& memConstruct(int nVar, int max_order, int acc_order=999, int min_ord=0);
protected:
  static ListTps **pTpsData;           

private:
  TpsData *zp;                 
  static int indexMonomial(int nVar, int power[]);

                        // allocate Tps memory up to nVar and max_order
                        // e.g. Tps z; z.memConstruct(6, 5);
  void memAlloc(int nVar, int max_ord, int acc_ord=999, int min_ord=0 );
  int & maxOrderChange();         // change a Tps maximum order 
  void numVarChange(int numVar); //change a Tps number of variables (expansion)
  void maxOrderChange(int order); // change a Tps maximum order 
  void maxOrderVarChange(int numVar, int order);
  void accOrderChange(int order); // change a Tps accuracy order 
  void minOrderChange(int order); // change a Tps minimum order 
  void forceAccOrderChange(int order); //change a Tps accuracy order forcefully

  Tps(int nVar, int max_order, int acc_order, int min_order=0); 
  Tps sin() const;
  Tps cos() const; 
  Tps sqrt() const;
  Tps exp() const;
  Tps log() const;
  Tps operator*(const doubleMatrix& M) const; // = Tps u.concatenate(M) = u(M x)
  Tps& operator*=(const doubleMatrix& M);  // Tps u = u.concatenate(M) = u(M x)
  Tps PoissonBracket(const Tps & zps) const;     //[zps, *this]
  Tps PoissonBracket(int iv) const;     //[*this, x(iv)], iv =0 or 1, or ...
  Vps PoissonBracket() const;     //[*this, I=vec(x)]
  Tps BCH(const Tps& zps, int o=99) const; // exp(:zps:)exp(:*this:) // Lie4
         // will perform BCH up to maximum accuracy limited by maximum order 
         // unless o (BCH order) is specified to be less than 5
  Tps BCH99(const Tps& zps) const; // perform BCH in Vps way.
  Tps lineIntegralDiagonal(int nvar, double c=1.0) const; //along diagoanl of 
            // th first nVar variables while keeping other variables unchanged.
  // in SingleLie.cc
  //      Tps& operator=(const Vps& zps);
  //      Tps& singleLieTransform(const Vps& zps, int o=100); // Lie3
  //      Vps vps(int o=0) const;  // Lie2
  //  double_complex getclm(int ihomo, int lmno[]) const;
};

inline Tps operator+(double cc, const Tps &zps) { return zps + cc; }
inline Tps operator-(double cc, const Tps &zps) { return (-zps) + cc; }
inline Tps operator*(double cc, const Tps &zps) { return zps * cc; }
inline Tps operator/(double cc, const Tps &zps) { return zps.inverse() * cc; }

inline Tps tan(const Tps & zps) { return sin(zps)/cos(zps); }
inline Tps cot(const Tps & zps) { return (cos(zps)/sin(zps)); }
inline Tps sec(const Tps & zps) { return (1/cos(zps)); }
inline Tps csc(const Tps & zps) { return (1/sin(zps)); }
inline Tps sinh(const Tps& zps) { return ( exp(zps)-exp(-zps) )*0.5; }
inline Tps cosh(const Tps& zps) { return ( exp(zps)+exp(-zps) )*0.5; }
inline Tps log10(const Tps& zps) { return log(zps)/log(10.0); }

#endif  //TPS_HH

