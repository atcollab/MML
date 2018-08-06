#ifndef TPSDATA_H
#define TPSDATA_H

#include "Zlib.hpp"

class TpsData: public Zlib
{
  friend class Tps;
  friend class Vps;
  friend class ListTps;
public:
  TpsData();
  TpsData(int nVar, int max_ord, int acc_ord=999, int min_ord=0);
  TpsData(const TpsData &);
  ~TpsData() 
  {
    delete [] tps_data;   
  }
  TpsData & operator = (const TpsData &);
  double operator[](int i) const { return tps_data[i]; }
  double& operator[](int i) { return tps_data[i]; }
  void negative(const TpsData& zz) const;
  void additionEqualVar(const TpsData& za, const TpsData& zb); // = za+zb
  void addition(const TpsData& za, const TpsData& zb); // = za+zb
  void addConst(double cc);
  void multiplication(const TpsData& za, const TpsData& zb); // = za*zb
  void multiplication(const TpsData& zz, double cc); // = zz*cc

  void derivative(TpsData & zz, int iv);
  void integral(TpsData & zz, int iv);
  void multiplyVariable(TpsData & zz, int iv);
  void transformVariable(TpsData & zz);
  void lineIntegralDiagonal( int nVar, double c);
  void condense(double eps);
  void ratio(const TpsData &zz); // ratio for each corresponding coefficient.
  void subTpsData(TpsData& zz);
  void homogeneous(int order, int nVar); //homogeneous order for the first nVar

  void clear(int min_order=0, int max_order=999);
  void fillOrder(int max_odr, int acc_odr=999, int min_odr=0);
  void maxOrderChange(int max_order); // change the max_order
  void accOrderChange(int acc_order); // change the acc_order
  void minOrderChange(int max_order); // change the min_order
  void forceAccOrderChange(int acc_order); // forcefully change the acc_order
  int searchMinOrder(int startOrder); //search for the min order from starOrder
  int getNumVar() { return num_var; }
  int getMaxOrder() { return max_order; }
  int getMinOrder() { return min_order; }
  int getAccOrder() { return acc_order; }
  int getMemOrder() { return mem_order; }
  int getCount() { return count; }
  bool operator==(const TpsData& zps) const;
  bool checkTpsData();
  void operator++() { ++count; } // prefix
  void operator++(int) { ++count; } // postfix
  void operator--() { --count; }
  void operator--(int) { --count; }
  bool allGone() const { return count==0; }
  bool onlyOne() const { return count==1; }

  void getFi(TpsData& fi, int order, double mux, double muy, TpsData& Hi);
  void excludeNoParaDependentTerms(int lastindxs=1);
  void nonlinearBetaParaTerms(int lastindxs=1);
  void deltaGiven(double eps=1, int lastindxs=1);
private:
  double *tps_data;
  int num_var, max_order, acc_order, min_order, mem_order;
  int count;
};


struct ListTpsElem
{
    TpsData *zp;
    ListTpsElem* next;
};


class ListTps
{
    ListTpsElem* head;
 public:
    ListTps() {head = 0;}
    ~ListTps() {release();}
    void prepend(TpsData * zp);
    void del();
    ListTpsElem* first() { return (head); }         
    void print(ofstream&);
    void release();
    TpsData* gethead();    
    static int numTpsDataStored;
    static int numTpsNewAlloc;
};

#endif  //TPSDATA_H

