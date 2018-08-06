#include "Vec.hpp"
#include "doubleMatrix.hpp"
#include "Tps.hpp"
#include "Vps.hpp"
//#include "Ray.h"

ListTps** Tps::pTpsData;
static int additionlTpsNew = 0;

//extern ofstream Lout;
int Tps::nullTpsDel = 0;
int Tps::numTpsUse = 0;
int Tps::numTpsStr = 0;
int Tps::capNumTpsStr=0;

void Tps::ZlibNerve(int variables, int order, int canDim) 
{
  if (TpsFlag)
    {
      TpsFlag = 0;
      ZlibNumVar = variables;
      ZlibMaxOrder = order;
      ZlibCanDim = canDim;
      if (ZlibCanDim*2 > ZlibNumVar) 
	{
	  ZlibCanDim = ZlibNumVar/2;
	}
      Tps_STATIC = 0;
      zpprepTps();
      pTpsData = new ListTps*[ZlibNumVar+10]; //9 more ->increasing max_num_var
      for (int i=0; i<ZlibNumVar+10; ++i)
	{
	  pTpsData[i] = new ListTps[ZlibMaxOrder+10];//9 more->increasing max_o
	} 
    }
  else if (order > ZlibMaxOrder || variables > ZlibNumVar) 
    {
      ZlibMaxOrder = order;
      ZlibNumVar = variables;
      zpprepTps();
    }
}

void Tps::canonicalDimension(int canDim)
{
  ZlibCanDim = canDim;
}  

void Tps::ZlibDone()
{
   for (int i=0; i<=ZlibNumVar; ++i)
     {
      for (int j=0; i<=ZlibMaxOrder; ++i)
        {
          pTpsData[i][j].release();
        }
     }
}

Tps::Tps() : zp(0) {} 

Tps::Tps(int variables, int order)
{
  ZlibNerve(variables, order);
  memAlloc(variables, order);
}  

Tps::Tps(int nVar, int max_ord, int acc_ord, int min_ord)
{
  ZlibNerve(nVar, max_ord);
  memAlloc(nVar, max_ord, acc_ord, min_ord);
}  

Tps::Tps(const Tps& zz): zp(zz.zp) 
{ 
  ++(*zp); 
}

// need fixing  ??????? Yan
Tps::Tps(const Tps& zz, int max_ord, int min_ord, int acc_ord, int nVar)  
{
  if (max_ord > zz.zp->max_order) max_ord = zz.zp->max_order;
  if (min_ord < zz.zp->min_order) min_ord = zz.zp->min_order;
  if (acc_ord < max_ord) acc_ord = max_ord;
  if (nVar > zz.zp->num_var) nVar = zz.zp->num_var;
  if (min_ord <= max_ord)
    {
      memAlloc(nVar, max_ord, acc_ord, min_ord);
      for (int i=nmob[nVar][min_ord]; i<nmo[nVar][max_ord]; ++i)
	{
	  zp->tps_data[i] = zz.zp->tps_data[i];
	}
    }
  else
    {
      zp = new TpsData(zp->num_var, 0, 0, 0);     
      ++numTpsUse;
      zp->tps_data[0]=0.0;
    }
}

Tps::Tps(double cc) : zp(new TpsData(1, 0)) 
{
  ++numTpsUse;
  //Lout << "(1,0) ++additionalTpsNew = " << ++additionalTpsNew << endl;
  zp->tps_data[0] = cc;
} 

Tps::~Tps() 
{
  if (zp)
    {
      --(*zp); 
      if (zp->allGone()) 
	{
	  //	  if ( zp->mem_order) 
  	  if ( zp->mem_order && numTpsStr <capNumTpsStr) 
	    {
	      pTpsData[zp->num_var][zp->mem_order].prepend(zp);
              ++numTpsStr; --numTpsUse;
	    }
	  else
	    {
	      delete zp;
              --numTpsUse;
	    }
	}
    }
  else
    {
      delete zp;
      ++nullTpsDel;
    }
}

/*
Tps::~Tps() { --(*zp); if (zp->allGone()) delete zp; }  // save delete ??
*/

void Tps::memAlloc(int nVar, int max_ord, int acc_ord, int min_ord)
{
  zp = pTpsData[nVar][max_ord].gethead();
  ++numTpsUse;
  if (!zp)
    {
      zp = new TpsData(nVar, max_ord, acc_ord, min_ord);
      if (!zp)
	{
	  cerr << "ERROR, memAlloc - new TpsData not done due to system\n";
	  exit(1);
	}
      //Lout << "(" << nVar << ", " << max_ord << ")" << endl;
      zp->clear(min_ord, max_ord);   // need it ??
    }
  else
    {
      zp->fillOrder(max_ord, acc_ord, min_ord);
      zp->clear(min_ord, max_ord);   // need it ??
      --numTpsStr; 
    }
}

Tps& Tps::memConstruct(int nVar, int max_ord, int acc_ord, int min_ord)   // ??
{
  if (!zp)
    {
      ZlibNerve(nVar, max_ord);
      memAlloc(nVar, max_ord, acc_ord, min_ord);
    }
  else if ( (zp->mem_order >= max_ord) &&(zp->num_var==nVar)&&(zp->onlyOne()) )
    {
      zp->fillOrder(max_ord, acc_ord, min_ord);
      zp->clear( min_ord, max_ord);
    }
  else
    {
      --(*zp);
      if (zp->allGone()) 
	{
	  //	  if ( zp->mem_order) 
  	  if ( zp->mem_order && numTpsStr <capNumTpsStr) 
	    {
	      pTpsData[zp->num_var][zp->mem_order].prepend(zp);
              ++numTpsStr; --numTpsUse;
	    }
	  else
	    {
	      delete zp;
              --numTpsUse;
	    }
	}
      ZlibNerve(nVar, max_ord);
      memAlloc(nVar, max_ord, acc_ord, min_ord);
    }
  return *this;
}

Tps& Tps::operator=(const Tps& zps) 
{
  if (zp != zps.zp) 
    {
      if (zp)
	{
	  --(*zp);
	  if (zp->allGone()) 
	    {
	      //	      if ( zp->mem_order) 
	      if ( zp->mem_order && numTpsStr <capNumTpsStr) 
		{
		  pTpsData[zp->num_var][zp->mem_order].prepend(zp);
                  ++numTpsStr; --numTpsUse;
		}
	      else
		{
		  delete zp;
                  --numTpsUse;
		}
	    }
	}
      zp=zps.zp;
      ++(*zp);
    }
  return *this;
}

Tps& Tps::operator=(double cc) 
{
  if (zp)
    {
      --(*zp);
      if (zp->allGone()) 
	{
	  //	  if ( zp->mem_order) 
  	  if ( zp->mem_order && numTpsStr <capNumTpsStr) 
	    {
	      pTpsData[zp->num_var][zp->mem_order].prepend(zp);
              ++numTpsStr; --numTpsUse;
	    }
	  else
	    {
	      delete zp;
              --numTpsUse;
	    }
	}
      zp=new TpsData(zp->num_var,0);
      //Lout << "(var, 0) ++additionalTpsNew = " << ++additionalTpsNew << endl;
      ++numTpsUse;
    }
  else
    {
      zp=new TpsData(1,0);
      //Lout << "(1,0) ++additionalTpsNew = " << ++additionalTpsNew << endl;
      ++numTpsUse;
    }
  zp->tps_data[0] = cc;
  return *this;
}     
     
Tps Tps::truncate(int order, int acc_ord) const
{
  Tps obj(*this, order, zp->min_order, acc_ord);
  return obj;
}

Tps Tps::homogeneous(int order, int nVar, int acc_ord) const 
{
  if (nVar >= zp->num_var)
    {
      if (order<=zp->max_order && order>=zp->min_order)  
	{
	  Tps obj(*this, order, order, acc_ord);
	  return obj;
	}
      else
	{
	  Tps obj(zp->num_var, order, acc_ord, order);
	  obj.zp->clear(order, order);
	  return obj;
	}
    }
  else
    {
      Tps obj(*this, zp->max_order, order, acc_ord);
      obj.zp->homogeneous(order, nVar);
      return obj;
    }
}

Tps Tps::filter(int max_ord, int min_ord, int acc_ord) const 
{
  Tps obj(*this, max_ord, min_ord, acc_ord);
  return obj;
}

void Tps::filtering(int max_ord, int min_ord) 
{
  minOrderChange(min_ord);
  maxOrderChange(max_ord);
}

Tps Tps::subTps(int nVar) const
{
  Tps obj(nVar, zp->max_order, zp->acc_order, zp->min_order);
  obj.zp->subTpsData(*zp);
  return obj;
}

double Tps::operator [] (int i) const 
{
  //  cout << " * ";
  return zp->tps_data[i];
}

double & Tps::operator [] (int i)   // not protected for i out of bound
{
  //  cout << " + ";
  if (!(zp->onlyOne())) 
    {
      --(*zp);
      zp=new TpsData(*zp);      ++numTpsUse;
      /*
      Tps temp = *this;
      memAlloc(zp->num_var, zp->max_order, zp->acc_order, zp->min_order);
      for (int i=nmob[zp->num_var][zp->min_order]; 
   	       i<nmo[zp->num_var][zp->max_order]; ++i)
	{
	  zp->tps_data[i] = temp.zp->tps_data[i];
	}	  
      */
    }
  return zp->tps_data[i];
}

double Tps::operator [] (int power[]) const
{
  if (!zp) 
    {
      cerr << "no Tps variables***  double & Tps::operator [] (int power[])\n";
      exit(1);
    }
  int i = indexMonomial(zp->num_var, power);
  int order=jv[zp->num_var][i][0];
  if (order < zp->min_order || order > zp->max_order)
    {
      if (order > zp->acc_order)
	{
	  cerr << "out of bound:  double & Tps::operator [] (int power[])\n";
	  exit(1);
	}
      return 0;
    }
  return  zp->tps_data[i];
}

double & Tps::operator [] (int power[]) 
{
  if (!zp) 
    {
      cerr << "no Tps variables***  double & Tps::operator [] (int power[])\n";
      exit(1);
    }
  int i = indexMonomial(zp->num_var, power);
  int order=jv[zp->num_var][i][0];
  if (order > zp->acc_order)
    {
      cerr << "out of bound:  double & Tps::operator [] (int power[])\n";
      exit(1);
    }
  if (order > zp->max_order || !(zp->onlyOne()) )  
    {
      --(*zp);
      Tps temp = *this;
      if (order > zp->max_order) 
	memAlloc(zp->num_var, order, zp->acc_order, zp->min_order);
      else
	memAlloc(zp->num_var, zp->max_order, zp->acc_order, zp->min_order);
      for (int i=nmob[zp->num_var][zp->min_order]; 
	   i<nmo[zp->num_var][temp.zp->max_order]; ++i)
	{
	  zp->tps_data[i] = temp.zp->tps_data[i];
	}	  
    }
  if (order < zp->min_order)
    {
      zp->clear(order, zp->min_order-1);
      zp->min_order=order;
    }
  return zp->tps_data[i];
}

Tps Tps::makeVariable(int iv) // iv start from 0 !!!
{
  int nVar = iv+1;
  Tps obj(nVar, 1, 999, 1);
  obj.zp->tps_data[iv+1] = 1.0;
  return obj;
}

Tps Tps::makeVarPower(int iv, int o) 
{
  int nVar = iv+1;
  Tps obj(nVar, o, 999, o);
  int *js;
  js = new int[nVar+1];
  for (int i=1; i<nVar; ++i) js[i]=0;
  js[0] = o;
  js[iv+1] = o;
  obj.zp->tps_data[jpek(nVar, js)] = 1.0;
  return obj;
}

Tps Tps::makeMonomial(int nVar, int power[], double cc) 
{
    int order = power[0];
    for (int i=1; i<nVar; ++i)
      {
	order += power[i];
      }
    Tps obj(nVar, order);
    obj[power] = cc;
    return obj;
}

int Tps::indexMonomial (int nVar, int power[]) 
{
  register int o = power[0];
  for (int i=1; i<nVar; ++i) o += power[i];
  register int iv;
  int jpk = nmob[nVar][o];
  register int nVarM1 = nVar-1;
  register int nVarM2 = nVar-2;
  for (iv=0; iv < nVarM2; ++iv) 
    {
      jpk += nmov[nVar][power[iv]][o][iv+1];
      o -=power[iv];
    }
  jpk += nmov[nVar][power[nVarM2]][o][nVarM1];
  return jpk;
} 

Tps Tps::operator+() const
{
  return *this;
}

Tps Tps::operator-() const  
{
  Tps obj(zp->num_var, zp->max_order, zp->acc_order, zp->min_order);
  obj.zp->negative(*zp);
  return obj;
}
  
Tps Tps::operator+(const Tps& zps) const   // done
{
  int nVar = max(zp->num_var, zps.zp->num_var);
  int acc_ord = min(zp->acc_order, zps.zp->acc_order);
  int max_ord = max(zp->max_order, zps.zp->max_order);
  max_ord = min(max_ord, acc_ord);
  int min_ord = min(zp->min_order, zps.zp->min_order);
  Tps obj(nVar, max_ord, acc_ord, min_ord);
  if (zp->num_var == zps.zp->num_var)
    {
      obj.zp->additionEqualVar(*zp, *(zps.zp));
    }
  else
    {
      if (zp->num_var < zps.zp->num_var)
	{
	  obj.zp->addition(*zp, *(zps.zp));
	}
      else
	{
	  obj.zp->addition(*(zps.zp), *zp);
	}
    }
  return obj;
}  


Tps Tps::operator-(const Tps& zps) const
{
  return *this+(-zps);
}  

Tps Tps::operator*(const Tps& zps) const 
{
  return (*this).multiply(zps);
}

Tps Tps::multiply(const Tps& zps, int nVar) const 
{
  int acc_ord = min( (zp->min_order+zps.zp->acc_order), 
                     (zp->acc_order+zps.zp->min_order) );
  int min_ord = zp->min_order + zps.zp->min_order;
  int max_ord = min( (zp->max_order+zps.zp->max_order), acc_ord);
  if (min_ord > ZlibMaxOrder)
    {
      Tps obj = 0.0;
      return obj;
    }
  if (max_ord > ZlibMaxOrder)
    {
      max_ord = ZlibMaxOrder;
      acc_ord = ZlibMaxOrder;
    }
  if (zp->num_var >= zps.zp->num_var)
    {
      Tps obj(zp->num_var, max_ord, acc_ord, min_ord);
      obj.zp->multiplication(*zp, *zps.zp);
      return obj;
    }
  else
    {
      Tps obj(zps.zp->num_var, max_ord, acc_ord, min_ord);
      obj.zp->multiplication(*zps.zp, *zp);
      return obj;
    }
}

Tps Tps::operator/(const Tps& zps) const 
{
  return (*this).multiply(zps.inverse());
}

Tps Tps::divide(const Tps& zps, int nVar) const
{
  return (*this).multiply(zps.inverse());
}    

Tps Tps::inverse(int max_ord) const  // check again ??
{
  double u0 = zp->tps_data[0];
  if (fabs(u0) < ZLIB_TINY) 
    {
      cerr << "*** 0th order term is 0 in Tps::inverse(). Please"
           <<"     consult Yiton T. Yan at SLAC.\n";
      exit(1);
    }
  int min_ord = zp->searchMinOrder(1); 
  if (!min_ord) 
    {
      Tps obj = 1.0/u0;
      return obj;
    }
  Tps zps(*this, 999, min_ord); 
  int expension_power = ZlibMaxOrder/min_ord;
  if (expension_power * min_ord < ZlibMaxOrder) ++expension_power;
  if (expension_power > max_ord) expension_power = max_ord;
  zps /= u0;
  //---- objTps=1/(1+u)=1+cs(1)*u+cs(2)*u**2+cs(3)*u**3+...  ,cs = cinverse
  Tps objTps = zps*cinv[1];
  Tps wkTps = zps;
  for (int p=2; p <= expension_power; ++p) 
    {
      wkTps *= zps;
      objTps += cinv[p]*wkTps;
    }
  objTps += 1.0;
  objTps /= u0;
  return objTps;
}
    
Tps Tps::operator+(double cc) const 
{
  Tps obj(*this, 999);
  obj.zp->addConst(cc);
  return obj;
}
    
Tps Tps::operator-(double cc) const 
{
  return *this+(-cc);
}
    
Tps Tps::operator*(double cc) const
{
  Tps obj(zp->num_var, zp->max_order, zp->acc_order, zp->min_order);
  obj.zp->multiplication(*zp, cc);
  return obj;
}
    
Tps Tps::operator/(double cc) const 
{
  return *this*(1/cc);
}

Tps& Tps::operator+=(const Tps& zps) 
{
       *this = *this + zps;
       return *this;
}

Tps& Tps::operator-=(const Tps& zps) {
       *this = *this - zps;
       return *this;
}

Tps& Tps::operator*=(const Tps& zps) {
    *this = (*this).multiply(zps);
    return *this;
}

Tps& Tps::operator/=(const Tps& zps) {
    *this = (*this).multiply(zps.inverse());
    return *this;
}
    
Tps& Tps::operator+=(double cc) {
    *this = *this + cc;
    return *this;
}
    
Tps& Tps::operator-=(double cc) {
    *this = *this - cc;
    return *this;
}

Tps& Tps::operator*=(double cc) {
    *this = (*this) * cc;
    return *this;
}

Tps& Tps::operator/=(double cc) {
    *this = (*this)/cc;
    return *this;
}

void Tps::clear(int min_ord, int max_ord, int nVar)
{
  if (!(zp->onlyOne())) 
    {
      --(*zp);
      zp=new TpsData(*zp);
      ++numTpsUse;
      //Lout << "(copy-clear)++additionalTpsNew = " << ++additionalTpsNew << endl;
    }
  zp->clear(min_ord, max_ord);
}

//??

bool Tps::operator==(const Tps& zps) const {
  if (zp != zps.zp) 
    {
      return zp==zps.zp;
    }
  return 1;
}

bool Tps::operator!=(const Tps& zps) const {
     if (*this==zps) return 0;
     return 1;
}

ostream& operator << (ostream& out, const Tps & zps)
{ 
  //  static int digit = 17;
  int digit = Zlib::digit;
  out.flags(ios::showpoint|ios::scientific);
  static double zero=0.0;
  static int nega=-1;
  int nVar = zps.getNumVar();
  /*  tentative comment out for Dynamic aperture fitting on 3/1/2005 Yan
  out << "Tps" 
      << ' ' << 1 
      << ' ' << nVar
      << ' ' << zps.getMinOrder() 
      << ' ' << zps.getMaxOrder() 
      << ' ' << zps.getAccOrder() 
      << ' ' << zps.getSize() 
      << "\n";
  */
  int i;  // index
  //  for (int j=0; j < zps.getSize(); ++j)
  int jStart = 0;
  if (zps.getMinOrder()) 
    {
      jStart = Zlib::numMo(nVar, zps.getMinOrder()-1);
    }
  for (int j=jStart; j < Zlib::numMo(nVar, zps.getMaxOrder()); ++j)
    {
      if (fabs(zps[j]) > ZLIB_TINY) 
	{
	  out << setw(digit+8) << setprecision(digit)
	      << zps[j] << ' ';
	  for (i=0; i <= nVar; ++i) 
	    {
	      out << (zps.jv)[nVar][j][i] << ' ';
	    }  
	  out << "\n";
	}
    }
  /*  tentaive comment out for dyanmics aperture fitting
  out << zero << ' ';  
  for (i=0; i <= nVar; ++i) out << nega << ' ';
  out << "\n\n";
  */
  return out;
}

istream& operator >> (istream& in, Tps & obj)
{
  int dim, nVar, min_ord, max_ord, acc_ord, size;
  char star;
  in >> star >> star >> star >> dim >> nVar >> min_ord >> max_ord >> acc_ord >> size;
  int *js;
  js = new int[nVar+1];
  obj.memConstruct(nVar, max_ord, acc_ord, min_ord);
  int i;  
  double coef;
  int jStart = 0;
   //  if (min_ord) jStart = Tps::numMo(nVar, min_ord-1);
  for (int j=jStart; j < size; ++j) 
    {
      in >> coef;
      for (i=0; i <= nVar; ++i) in >> js[i];
      if (js[0] < 0) break;
      obj[Zlib::jpek(nVar, js)] = coef;
    }
  delete [] js;
  return (in);
}	

/*
void Tps::getTps(ifstream& in, int max_ord)
{
  if (max_ord > ZlibMaxOrder) max_ord = ZlibMaxOrder;
  double coef;     
  char ch1;
  int imax = 100000;
  int i,j,order,nVar;
  for (i=0; i< imax; ++i) { in >> ch1; if (ch1 =='S' || ch1 =='s') break; }
  for (i=0; i< imax; ++i) { in >> ch1; if (ch1 =='=') break; }
  in >> order;
  for (i=0; i< imax; ++i) { in >> ch1; if (ch1 =='=') break; }
  in >> nVar;
  int *js;
  js = new int[nVar+1];
  max_ord = min(max_ord, order);
  cout << "nVar = " << nVar << "  max_ord = " << max_ord << endl;
  *this = this->memConstruct(nVar, max_ord, max_ord,0);
  this->clear();
  for (j=0; j<imax; ++j) 
    {
      in >> js[0] >> coef;
      for (i=1; i<=nVar; ++i) in >> js[i];
      if (js[0] < 0) break;
      if (js[0] <= max_ord) zp->tps_data[jpek(nVar, js)] = coef;
    }
  delete [] js;
} 
*/
 
void Tps::getTps(ifstream& in, int max_ord, int var)
{
  if (max_ord > ZlibMaxOrder) max_ord = ZlibMaxOrder;
  double coef;     
  char ch1;
  int imax = 100000;
  int i,j,order,nVar;
  for (i=0; i< imax; ++i) { in >> ch1; if (ch1 =='S' || ch1 =='s') break; }
  for (i=0; i< imax; ++i) { in >> ch1; if (ch1 =='=') break; }
  in >> order;
  for (i=0; i< imax; ++i) { in >> ch1; if (ch1 =='=') break; }
  in >> nVar;
  int *js;
  js = new int[nVar+1];
  max_ord = min(max_ord, order);
  cout << "nVar = " << nVar << "  max_ord = " << max_ord << endl;
  *this = this->memConstruct(nVar, max_ord, max_ord,0);
  this->clear();
  for (j=0; j<imax; ++j) 
    {
      in >> js[0] >> coef;
      for (i=1; i<=nVar; ++i) in >> js[i];
      if (js[0] < 0) break;
      if (js[0] <= max_ord) zp->tps_data[jpek(nVar, js)] = coef;
    }
  delete [] js;
  if (nVar > var) *this = subTps(var);
}  

/*
void Tps::getTps(ifstream& in, int max_ord, int var)
{
  if (max_ord > ZlibMaxOrder) max_ord = ZlibMaxOrder;
  double coef;     
  char ch1;
  int imax = 100000;
  int i,j,order,nVar, nVar0;
  for (i=0; i< imax; ++i) { in >> ch1; if (ch1 =='S' || ch1 =='s') break; }
  for (i=0; i< imax; ++i) { in >> ch1; if (ch1 =='=') break; }
  in >> order;
  for (i=0; i< imax; ++i) { in >> ch1; if (ch1 =='=') break; }
  in >> nVar; nVar0 = nVar; if (var) {if (nVar > var) nVar = var;}
  int nDif=nVar0-nVar;
  int *jDif; jDif = new int[nDif];
  int *js;
  js = new int[nVar+1];
  max_ord = min(max_ord, order);
  cout << "nVar0 = " << nVar0 << "    nVar = " << nVar 
       << "  max_ord = " << max_ord << endl;
  *this = this->memConstruct(nVar, max_ord, max_ord,0);
  this->clear();
  for (j=0; j<imax; ++j) 
    {
      in >> js[0] >> coef;
      for (i=1; i<=nVar; ++i) in >> js[i];
      int adum, osum; osum = 0;
      for (i=0; i<nDif; ++i) { in >> adum; osum += adum; }
      if (js[0] < 0) break;
      js[0] -= osum;
      if (js[0] <= max_ord) 
	{
	  if (js[0]) zp->tps_data[jpek(nVar, js)] = coef;
	  else if (osum==0) zp->tps_data[0] = coef;
	}
    }
  delete [] js;
}  
*/

      // return the number of variables of a Tps
int Tps::getNumVar() const { return zp->num_var; }
      // return the order of a Tps
int Tps::getMaxOrder() const 
{ 
  if (zp)  return zp->max_order; 
  else return -1;
}
int Tps::getAccOrder() const 
{ 
  if (zp) return zp->acc_order;
  else return -1;
}
int Tps::getMinOrder() const 
{ 
  if (zp) return zp->min_order; 
  else return -1;
}
int Tps::getMemOrder() const 
{ 
  if (zp) return zp->mem_order; 
  else return -1;
}
      // return array size of a Tps
int Tps::getSize() const 
{
  if (zp) return nmo[zp->num_var][zp->max_order]; 
  else return -1;
}

bool Tps::checkTps()
{
  return zp->checkTpsData();
}

Tps Tps::derivative(int iv) const // iv starts with 0  NOT 1 !!!!
{
  if (iv >= ZlibNumVar || iv < 0)   // iv starts with 0  NOT 1 !!!!
    {
      cerr << "in Tps Tps::derivative(int iv) const; "
	   << " your argument iv = " << iv << " is out of bound\n";
      exit(1);
    }	  
  if (iv >= zp->num_var)
    {
      Tps obj = 0.0;
      return obj;
    }
  int min_ord = max(zp->min_order-1, 0);
  Tps obj(zp->num_var, zp->max_order-1, zp->acc_order-1, min_ord);
  obj.zp->derivative(*zp, iv);      // iv starts with 0  NOT 1 !!!!
  return obj;
}

Tps Tps::PoissonBracket(const Tps & zps) const     //[zps, *this]
{
	Tps objTps;
	objTps=zps.derivative(0)*derivative(1)-zps.derivative(1)*derivative(0);
	int i1, i2;
	for (int i=1; i < ZlibCanDim; ++i) {
	    i1 = 2 * i;
	    i2 = i1 + 1;
	    objTps += zps.derivative(i1)*derivative(i2);
	    objTps -= zps.derivative(i2)*derivative(i1);
	}
	return objTps;
}

Tps PoissonBracket(const Tps & zps1, const Tps & zps2)     //[zps1, zps2]
{
  return zps2.PoissonBracket(zps1);
}

Tps Tps::integral(int iv) const 
{
  if (iv >= ZlibNumVar || iv < 0)   // iv starts with 0  NOT 1 !!!!
    {
      cerr << "in Tps Tps::integral(int iv) const; "
	   << " your argument iv = " << iv << " is out of bound\n";
      exit(1);
    }	   
  if (iv >= zp->num_var)
    {
      return multiplyVariable(iv);
    }
  int max_ord = zp->max_order+1;
  int acc_ord = zp->acc_order+1;
  if (max_ord > ZlibMaxOrder)
    {
      max_ord = ZlibMaxOrder;
      acc_ord = ZlibMaxOrder;
    }
  Tps obj(zp->num_var, max_ord, acc_ord, zp->min_order+1);
  obj.zp->integral(*zp, iv);      // iv starts with 0  NOT 1 !!!!
  return obj;
}

Tps Tps::multiplyVariable(int iv) const
{
  if (iv >= ZlibNumVar || iv < 0)   // iv starts with 0  NOT 1 !!!!
    {
      cerr << "in Tps Tps::multiplyVariable(int iv) const; "
	   << " your argument iv = " << iv << " is out of bound\n";
      exit(1);
    }	   
  int max_ord = zp->max_order+1;
  int acc_ord = zp->acc_order+1;
  if (max_ord > ZlibMaxOrder)
    {
      max_ord = ZlibMaxOrder;
      acc_ord = ZlibMaxOrder;
    }
  if (iv >= zp->num_var)
    {
      int nVarB = iv+1;
      Tps zz(nVarB, max_ord, acc_ord, zp->min_order);
      zz.zp->transformVariable(*zp);
      Tps obj(nVarB, max_ord, acc_ord, zp->min_order+1);
      obj.zp->multiplyVariable(*(zz.zp), iv);   
      return obj;
    }
  Tps obj(zp->num_var, max_ord, acc_ord, zp->min_order+1);
  obj.zp->multiplyVariable(*zp, iv);   
  return obj;
}

Tps Tps::plusVariable(int iv) const      // iv starts with 0  NOT 1 !!!!
{
  if (iv >= ZlibNumVar || iv < 0)   // iv starts with 0  NOT 1 !!!!
    {
      cerr << "in Tps Tps::plusVariable(int iv) const; "
	   << " your argument iv = " << iv << " is out of bound\n";
      exit(1);
    }	   
  Tps obj = *this + makeVariable(iv);
  return obj;
}  

Tps Tps::minusVariable(int iv) const     // iv starts with 0  NOT 1 !!!!
{
  if (iv >= ZlibNumVar || iv < 0)   // iv starts with 0  NOT 1 !!!!
    {
      cerr << "in Tps Tps::minusVariable(int iv) const; "
	   << " your argument iv = " << iv << " is out of bound\n";
      exit(1);
    }	   
  Tps obj = *this - makeVariable(iv);
  return obj;
}

Tps pwr(const Tps& zps, int n) 
{
  if (n == 0) {
    Tps obj = 1;
    return obj;
  }
  else {
    Tps obj = zps;
    for (int i=2; i <=abs(n); ++i) obj *= zps;
    if (n < 0) return 1.0/obj;
    return obj;
  }
}

Tps Tps::sqrt() const 
{
  double u0=zp->tps_data[0];
  if (u0 < ZLIB_TINY) 
    {
      cerr << "In Tps::sqrt, the 0th order term of the Tps is <=0\n";
      exit(1);
    }
  int min_ord=zp->searchMinOrder(1); 
  if (!min_ord) 
    {
      Tps obj = 1.0;
      return obj;
    }
  Tps zps(*this, 999, min_ord); 
  int expension_power = ZlibMaxOrder/min_ord;
  if (expension_power * min_ord < ZlibMaxOrder) ++expension_power;
  zps /= u0;
  Tps temp = zps;
  Tps obj = csqrt[1]*temp + 1.0;
  for (int p=2; p <= expension_power; ++p) 
    {
      temp = temp.multiply(zps);
      obj += csqrt[p]*temp;
    }
  return obj;
}

Tps sqrt(const Tps & zps) 
{ 
  return zps.sqrt()*sqrt(zps[0]); 
}

Tps Tps::exp() const
{
  if (!zp) 
    {
      cerr << "warning! Tps::exp(), null Tps\n";
      return 1;
    }
  int min_ord=zp->searchMinOrder(1); 
  if (!min_ord) 
    {
      Tps obj=1.0;
      return obj;
    }
  Tps zps(*this, 999, min_ord); 
  int expension_power = ZlibMaxOrder/min_ord;
  if (expension_power * min_ord < ZlibMaxOrder) ++expension_power;
  Tps temp = zps;
  Tps obj = zps + 1.0;
  for (int p=2; p <= expension_power; ++p) 
    {
      temp = temp.multiply(zps);
      obj += cexp[p]*temp;
    }
  return obj;
}

Tps exp(const Tps& zps) 
{  
  return zps.exp()*exp(zps[0]); 
}

Tps Tps::log() const
{
  double u0=zp->tps_data[0];
  if (u0 < ZLIB_TINY) {
    cerr << "In Tps::log, the 0th order term of the Tps is <=0\n";
    exit(1);
  }
  int min_ord=zp->searchMinOrder(1); 
  if (!min_ord) 
    {
      Tps obj=1;
      return obj;
    }
  Tps zps(*this, 999, min_ord); 
  int expension_power = ZlibMaxOrder/min_ord;
  if (expension_power * min_ord < ZlibMaxOrder) ++expension_power;
  zps /= u0;
  Tps temp = zps;
  Tps obj = zps;
  for (int p=2; p <= expension_power; ++p) 
    {
      temp = temp.multiply(zps);
      obj += cln[p]*temp;
    }
  return obj;
}

Tps log(const Tps& zps) 
{
  return zps.log()+log(zps[0]); 
}

Tps Tps::sin() const
{
  int min_ord = zp->searchMinOrder(1); 
  if (!min_ord) 
    {
      Tps obj=0.0;
      return obj;
    }
  Tps zps(*this, 999, min_ord); 
  int expension_power = ZlibMaxOrder/min_ord;
  if (expension_power * min_ord < ZlibMaxOrder) ++expension_power;
  Tps temp = zps;
  Tps temp2 = temp*temp;
  Tps obj = csc[1]*temp;
  for (int p=3; p <= expension_power; p+=2) 
    {
      temp *= temp2;
      obj += csc[p]*temp;
    }
  return obj;
}
	
Tps Tps::cos() const
{
  int min_ord = zp->searchMinOrder(1); 
  if (!min_ord) 
    {
      Tps obj=1.0;
      return obj;
    }
  Tps zps(*this, 999, min_ord); 
  int expension_power = ZlibMaxOrder/min_ord;
  if (expension_power * min_ord < ZlibMaxOrder) ++expension_power;
  Tps temp = zps;
  Tps temp2 = temp*temp;
  temp = temp2;
  Tps obj = csc[2]*temp + 1.0;
  for (int p=4; p <= expension_power; p+=2) 
    {
      temp *= temp2;
      obj += csc[p]*temp;
    }
  return obj;
}

Tps sin(const Tps & zps)
{
  double u0=zps[0];
  Tps obj = sin(u0)*zps.cos() + cos(u0)*zps.sin();
  return obj;
}

Tps cos(const Tps & zps)
{
  double u0=zps[0];
  Tps obj = cos(u0)*zps.cos() - sin(u0)*zps.sin();
  return obj;
}
	
void  Tps::setTpsOutputPrecision(int a) 
{
  Zlib::digit = a;
}

int & Tps::maxOrderChange() 
{
  return zp->max_order;
}

void Tps::maxOrderVarChange(int numVar, int order) 
{
  if (numVar < zp->num_var)
    {
      cerr << "numVar < zp->num_var in void Tps::numVarChange (int numVar)\n"; 
      exit(1);
    }
  else if (numVar == zp->num_var)
    {
      if (order <=zp->mem_order)
	{
	  zp->maxOrderChange(order);
	}
      else
	{
	  Tps obj(numVar, order, zp->acc_order, zp->min_order);
	  for (int i=nmob[numVar][zp->min_order]; i<nmo[numVar][zp->max_order];++i)
	    {
	      obj.zp->tps_data[i] = zp->tps_data[i];
	    }
	  *this = obj;
	}
    }
  else
    {
      Tps obj(numVar, order, zp->acc_order, zp->min_order);
      int maxO = min(order,zp->max_order);
      for (int i=nmob[zp->num_var][zp->min_order]; i<nmo[zp->num_var][maxO]; ++i)
	{
	  int *js; js = new int[numVar+1]; 
	  int j;
          for (j=0; j<=zp->num_var; ++j) js[j]=jv[zp->num_var][i][j];
          for (j=zp->num_var+1; j<=numVar; ++j) js[j]=0;
	  obj.zp->tps_data[jpek(numVar,js)] = zp->tps_data[i];
	}
      *this = obj;
    }
}

void Tps::numVarChange(int numVar) 
{
  if (numVar < zp->num_var)
    {
      cerr << "numVar < zp->num_var in void Tps::numVarChange (int numVar)\n"; 
      exit(1);
    }
  else if (numVar > zp->num_var)
    {
      Tps obj(numVar, zp->max_order, zp->acc_order, zp->min_order);
      for (int i=nmob[zp->num_var][zp->min_order]; 
          i<nmo[zp->num_var][zp->max_order]; ++i)
	{
	  int *js; js = new int[numVar+1]; 
	  int j;
          for (j=0; j<=zp->num_var; ++j) js[j]=jv[zp->num_var][i][j];
          for (j=zp->num_var+1; j<=numVar; ++j) js[j]=0;
	  obj.zp->tps_data[jpek(numVar,js)] = zp->tps_data[i];
	}
      *this = obj;
    }
}

void Tps::maxOrderChange (int order) 
{
  if (order <= zp->mem_order)
    {
      zp->maxOrderChange(order);
    }
  else
    {
      int nVar = zp->num_var;
      Tps obj(nVar, order, zp->acc_order, zp->min_order);
      for (int i=nmob[nVar][zp->min_order]; i<nmo[nVar][zp->max_order]; ++i)
	{
	  obj.zp->tps_data[i] = zp->tps_data[i];
	}
      *this = obj;
    }
}

void Tps::accOrderChange (int order) 
{
  zp->accOrderChange(order);
}

void Tps::forceAccOrderChange (int order) 
{
  zp->forceAccOrderChange(order);
}

void Tps::minOrderChange (int order) 
{
  zp->minOrderChange(order);
}

// 1-D Map Tracking
/*
double Tps::operator() (const Ray & x, int sorder) const 
{
    if (VpsFlag) 
      {
	VpsFlag = 0;
	Vps_STATIC = 0;
	zpprepVps();
      }
    int nVar = getNumVar();
    int nm = nmo[nVar][getMaxOrder()];
    if (sorder>0 && sorder<getMaxOrder()) nm = nmo[nVar][sorder];
    int j; // index
    double v = zp->tps_data[0];
    xxx[0] = 1.0;    
    int *ivpT, *jppT;
    ivpT = ivp[nVar];
    jppT = jpp[nVar];
    for (j=1; j < nm; ++j) xxx[j]=x[ivpT[j]]*xxx[jppT[j]];
    for (j=1; j<nm; ++j) v += zp->tps_data[j]*xxx[j];
    return v;
}
*/

double Tps::operator()(const Vec & x) const   // 1-D tracking
{
    if (VpsFlag) 
      {
	VpsFlag = 0;
	Vps_STATIC = 0;
	zpprepVps();
      }
    int nVar = getNumVar();
    int nm = nmo[nVar][getMaxOrder()];
    int j; // index
    double v = zp->tps_data[0];
    xxx[0] = 1.0;    
    int *ivpT, *jppT;
    ivpT = ivp[nVar];
    jppT = jpp[nVar];
    for (j=1; j < nm; ++j) xxx[j]=x[ivpT[j]]*xxx[jppT[j]];
    for (j=1; j<nm; ++j) v += zp->tps_data[j]*xxx[j];
    return v;
}

Tps Tps::operator()(const Vps & zvps) const 
{
  Vps tt(1);
  tt[0] = *this;
  Vps zps = zvps; zps.unifyVps();
  tt = tt.concatenate(zps);
  return tt[0];
}

Tps Tps::operator()(const doubleMatrix& M) const 
{
  Vps tt(1);
  tt[0] = *this;
  Vps zps(M);
  tt = tt.concatenate(zps);
  return tt[0];
} 

Tps Tps::operator*(const doubleMatrix& M) const 
{
  return (*this)(M);
} 

Tps& Tps::operator*=(const doubleMatrix& M) 
{
  *this = (*this)(M);
  return *this;
} 

/* *********************************************************************

int Tps::getMaxNumVar() { return ZlibNumVar;}
int Tps::getMaxOrder() { return ZlibMaxOrder;}
int Tps::getMaxSize() { return ZlibMaxSize;}
************************************************************************/

Tps Tps::PoissonBracket(int i) const {     //[*this, x(i)], i =0, or 1, or ...
      Tps obj;
      if ( i-i/2*2 )  obj = this->derivative(i-1);
      else obj = (-1.0)*(this->derivative(i+1));
      return obj;
}

Vps Tps::PoissonBracket() const {    //[*this, I=vec(x)]
      int nVar = getNumVar();
      int dimVps = (nVar/2)*2;
      if (dimVps > 2*ZlibCanDim) dimVps = 2*ZlibCanDim;
      Vps obj(dimVps);
      int i;
// iv starts with 0  NOT 1 !!!!
      for (i=0; i<dimVps; i+=2) obj[i] = (-1.0)*(this->derivative(i+1));
      for (i=1; i<dimVps; i+=2) obj[i] = this->derivative(i-1);
      return obj;
}      

Vps Tps::singleLieTaylor() const {
      int maxOrd = getAccOrder()-1;
      if (maxOrd > ZlibMaxOrder) maxOrd = ZlibMaxOrder;
      int minOrder = getMinOrder();
      int npb;
      if (minOrder > 2)  npb = (maxOrd-1)/(minOrder-2);
      else 
	{
	  npb = 15;
	  cerr << " *** warning Tps::singLieTaylor: minOrder < 3\n";
	}
      int i,fac;
 /*
      int nVar = getNumVar();
      int dimVps = (nVar/2)*2;
      if (dimVps > 2*ZlibCanDim) dimVps = 2*ZlibCanDim;
      Vps obj(dimVps), temp;
// iv starts with 0  NOT 1 !!!!
      for (i=0; i<dimVps; i+=2) obj[i] = (-1.0)*(this->derivative(i+1));
      for (i=1; i<dimVps; i+=2) obj[i] = this->derivative(i-1);
 */
      Vps obj = this->PoissonBracket();
      Vps temp;
      fac=2;
      if (npb > 1) {
          temp = obj.PoissonBracket(*this);
          obj += temp/fac;
      }
      for (i=3; i<=npb; ++i) {
	  temp = temp.PoissonBracket(*this);
	  fac *=i;
          obj += temp/fac;
      }         
      obj += Vps::makeI(obj.getDim());
      return obj;
}

Vps Tps::singleLieTaylor(int o) const { return singleLieTaylor(); }

/*
int pow (int a, int p) {
     int ap = 1;
     for (int i=0; i<p; ++i) ap *=a;
     return ap;
}
*/

doubleMatrix Tps::f2Matrix(int n2) const {  // Lie9
  //      const int n2 = 20;
      int n = pwr(2, n2);
      Tps zz = this->homogeneous(2)/n;
      int nVar = getNumVar();
      int dimVps = (nVar/2)*2;
      if (dimVps > 2*ZlibCanDim) dimVps = 2*ZlibCanDim;
      Vps obj(dimVps), temp;
      int i,fac;
      // iv starts with 0  NOT 1 !!!!
      for (i=0; i<dimVps; i+=2) obj[i] = (-1.0)*(zz.derivative(i+1));
      for (i=1; i<dimVps; i+=2) obj[i] = zz.derivative(i-1);
      fac=2;
          temp = obj.PoissonBracket(zz);
          obj = obj + temp/fac;
      for (i=3; i<=30; ++i) {
	  temp = temp.PoissonBracket(zz);
	  if ( !temp.checkVps() ) break;
	  fac *=i;
          obj = obj + temp/fac;
      }         
      obj += Vps::makeI(dimVps);
      doubleMatrix MM = obj.linearMatrix();
      int r = MM.Row();
      int c = MM.Col();
      if (r < c ) MM = MM.expandToSquare(c);
      for (i=0; i<n2; ++i) {
	  MM *= MM;
      }
      if (r < c) MM = MM.subMatrix(r,c);
      return MM;
}

Vps Tps::f2Vps(int n2) const {  // Lie9
    return Vps(this->f2Matrix(n2));
}

Vps Tps::f2VpsPara(int n2) const {  // Lie9
  //      const int n2 = 20;
      int n = pwr(2, n2);
      int nVar = getNumVar();
      int dimVps = (nVar/2)*2;
      dimVps = min(dimVps, 2*ZlibCanDim);
      Tps zz = this->homogeneous(2,dimVps)/n;
      Vps obj(dimVps), temp;
      int i,fac;
      // iv starts with 0  NOT 1 !!!!
      for (i=0; i<dimVps; i+=2) obj[i] = (-1.0)*(zz.derivative(i+1));
      for (i=1; i<dimVps; i+=2) obj[i] = zz.derivative(i-1);
      fac=2;
          temp = obj.PoissonBracket(zz);
	  temp.forceAccOrderChange(999);
          obj = obj + temp/fac;
      for (i=3; i<=30; ++i) {
	  temp = temp.PoissonBracket(zz);
	  temp.forceAccOrderChange(999);
	  if ( !temp.getMaxOrder() ) break;
	  if ( !temp.checkVps() ) break;
	  fac *=i;
          obj = obj + temp/fac;
      }         
      obj += Vps::makeI(dimVps);
      Vps obj5(nVar);
      for (i=0; i<dimVps; ++i) obj5[i] = obj[i];
      for (i=dimVps; i<nVar; ++i) obj5[i] = Tps::makeVariable(i);
      for (i=0; i<n2; ++i) {
  	  obj5 = obj5(obj5);
      }
      obj = obj5.subVps(dimVps);
      return obj;
}

Vps Tps::orderLieTaylor2n() const {

      int maxOrder = getMaxOrder();
      if (maxOrder > ZlibMaxOrder) maxOrder = ZlibMaxOrder;
      int minOrder = getMinOrder();
      Vps obj;
      Tps gi;
 /*
      if (minOrder < 3)
	{
	  if (maxOrder < 3)
	    {
	      if (maxOrder == 2) 
		{
		  gi = this->homogeneous(maxOrder);
		  obj = gi.f2Vps();
		  if (minOrder < 2) 
		    {
		      gi = this->homogeneous(1);
		      obj = obj.PoissonBracket(gi);
		    }
		}

		}
	      else if (maxOrder == 1)
		{
		}
	    }
	  cerr << " *** warning Tps::orderLieTaylor: minOrder < 3\n";
	  minOrder = 3;
	}
 */
      gi = this->homogeneous(maxOrder, 999, getAccOrder());
      obj = gi.singleLieTaylor();
      int min3 = max(3, minOrder);
      for (int n=maxOrder-1; n>=min3; --n) {
	gi = this->homogeneous(n, 999, getAccOrder());
        obj = gi.LieVps(obj);
      }
      int accOrd = min(getAccOrder() - 1, ZlibMaxOrder);
      obj.accOrderChange(accOrd);
      if (obj.getMaxOrder() > accOrd) obj.maxOrderChange(accOrd);
      return obj;
}

Vps Tps::orderLieTaylor(int flag) const {

   int maxOrder = getMaxOrder();
   if (maxOrder > ZlibMaxOrder) maxOrder = ZlibMaxOrder;
   int minOrder = getMinOrder();
   Vps obj;
   Tps gi;
   if (flag) {
     cout << "flag == 1 = " << flag << endl;
      gi = this->homogeneous(minOrder, 999, getAccOrder());
      obj = gi.singleLieTaylor();
      for (int n=minOrder+1; n<=maxOrder; ++n) {
	gi = this->homogeneous(n, 999, getAccOrder());
        obj = gi.LieVps(obj);
      }
   }
   else {
     cout << "flag == 0 = " << flag << endl;
      gi = this->homogeneous(maxOrder, 999, getAccOrder());
      obj = gi.singleLieTaylor();
      //      Vps o_save = obj;
      int min3 = max(3, minOrder);
      for (int n=maxOrder-1; n>=min3; --n) {
	gi = this->homogeneous(n, 999, getAccOrder());
        obj = gi.LieVps(obj);
      }
   }
   int accOrd = min(getAccOrder() - 1, ZlibMaxOrder);
   obj.accOrderChange(accOrd);
   if (obj.getMaxOrder() > accOrd) obj.maxOrderChange(accOrd);
   return obj;
}

// Vps Tps::orderLieTaylor(int order) const {return orderLieTaylor();}


Vps Tps::LieVps(const Vps& zps) const {
      int maxOrder = getAccOrder()-1;
      if (maxOrder > ZlibMaxOrder) maxOrder = ZlibMaxOrder;
      int minOrder = getMinOrder();
      int npb;
      if (minOrder < 3)
	{
	  npb = 15;
	  cerr << " *** warning Tps::LieVps: minOrder < 3\n";
	}
      else 
	{
	  npb = ( maxOrder - zps.getMinOrder() ) / ( minOrder-2 );
	}
      Vps obj = zps;
      Vps temp = zps;
      int fac = 1;
      for (int i=1; i<=npb; ++i) {
	  temp = temp.PoissonBracket(*this);
	  fac *=i;
          obj += temp/fac;
      }         
      return obj;
}

void Tps::condense(double eps)
{
    zp->condense(eps);
    condenseMinOrder();
    condenseMaxOrder();
}

void Tps::ratio(const Tps& zps)
{
  zp->ratio( *(zps.zp) );
}

void Tps::condenseMinOrder(int minOrder)
{
    if ( minOrder ) 
      {
	zp->min_order = minOrder;
      }
    else
      {
	int nVar = getNumVar();
	int doubleBreak = 0;
	for (int io=zp->min_order; io <=zp->max_order; ++io)
	  {
	    for (int j=Zlib::numMo(nVar, io-1); j<Zlib::numMo(nVar, io); ++j)
	      {
		if (fabs(zp->tps_data[j]) > ZLIB_TINY) 
		  {
		    zp->min_order = io;
		    doubleBreak = 1;
		    break;
		  }
	      }
	    if (doubleBreak) break;
	  }
	if ( !doubleBreak ) zp->min_order = zp->max_order;
      }
}

void Tps::condenseMaxOrder(int maxOrder)
{
    if ( maxOrder ) 
      {
	zp->max_order = maxOrder;
      }
    else
      {
	int nVar = getNumVar();
	int doubleBreak = 0;
	for (int io=zp->max_order; io >=zp->min_order; --io)
	  {
	    for (int j=Zlib::numMo(nVar, io-1); j<Zlib::numMo(nVar, io); ++j)
	      {
		if (fabs(zp->tps_data[j]) > ZLIB_TINY) 
		  {
		    zp->max_order = io;
		    doubleBreak = 1;
		    break;
		  }
	      }
	    if (doubleBreak) break;
	  }
	if ( !doubleBreak )  zp->max_order = zp->min_order = 0;
      }
}

Tps BCH(const Tps& z1, const Tps& z2, int ord) {return z2.BCH(z1, ord);}//Lie4

Tps Tps::BCH(const Tps& zps, int ord) const {
     if (getMinOrder() < 3 || zps.getMinOrder() < 3) 
       {
	 ord = 4;
	 cerr << " warning: Tps::BCH : BCH order changed to 4 due to "
	      << "Linear terms and/or Drift terms.\n";
       }	 
     if (ord > 4) return this->BCH99(zps);
     Tps objBCH;
     objBCH = *this + zps;
     if (ord == 0) return objBCH;
     Tps obj1;
     obj1 = (*this).PoissonBracket(zps);
     objBCH += obj1*0.5;
     if (ord == 1) return objBCH;
     Tps obj2, obj3;
     obj2 = (*this).PoissonBracket(obj1);
     objBCH += obj2/12.0;
     obj3 = zps.PoissonBracket(obj1);
     objBCH -= obj3/12.0;
     if (ord == 2) return objBCH;
     Tps obj4;
     obj4 = zps.PoissonBracket(obj2);
     objBCH -= obj4/24.0;
     if (ord == 3) return objBCH;
     obj1 = (*this).PoissonBracket(obj4);
     objBCH -= obj1/120.0;
     obj4 = zps.PoissonBracket(obj3);
     obj1 = zps.PoissonBracket(obj4);
     objBCH += obj1/720.0;
     obj1 = (*this).PoissonBracket(obj4);
     objBCH -= obj1/360.0;
     obj4 = (*this).PoissonBracket(obj2);
     obj1 = zps.PoissonBracket(obj4);
     objBCH += obj1/360.0;
     obj1 = (*this).PoissonBracket(obj4);
     objBCH -= obj1/720.0;
     obj4 = (*this).PoissonBracket(obj3);
     obj1 = zps.PoissonBracket(obj4);
     objBCH += obj1/120.0;
     return objBCH;
}

Tps Tps::BCH99(const Tps& zps) const {
  Vps uu = this->singleLieTaylor();
  Vps yy = zps.singleLieTaylor();
  Vps zz = uu(yy);
  return zz.singleLie();
}     

Vps Tps::inverseGenerating(int ord) const {  // Eq. (5.7).
   int order = min( getMaxOrder(), ord);
   if (order >ZlibMaxOrder)  order = ZlibMaxOrder;
   int nVar = getNumVar();
   Vps vp(nVar);
   for (int i=0; i<nVar; ++i) vp[i] = this->derivative(i);
   doubleMatrix SS(nVar/2); 
   for (int i=0; i<nVar; i+=2) { SS(i,i+1) = 1.0; }
   vp = - (SS*vp);
   return vp;
}


Tps Tps::getFi(int order, double mux, double muy, Tps& hi) const 
{
  int nVar = getNumVar();  int canD = nVar/2; int nVarH = nVar - canD;
  Tps Fi(nVar, order);
  Tps Hi(nVarH, order-1);
  Fi.zp->getFi(*zp, order, mux, muy, *(Hi.zp));
  Fi = Fi.filter(order, order, ZlibMaxOrder);
  hi = Hi;
  return Fi;
}

Tps Tps::convert_hi2fi(int canD) const // so far assuming only 1 parameter delta
{
  int nVarH = getNumVar();
  int nVar = nVarH + canD;
  Tps x2 = Tps::makeVarPower(0,2);
  Tps px2 = Tps::makeVarPower(1,2);
  Tps tjx = x2+px2;
  Tps y2,py2,tjy,z2,pz2,tjz;
  if (canD>1) {
    y2= Tps::makeVarPower(2,2);
    py2= Tps::makeVarPower(3,2);
    tjy = y2+py2;
  }
  if (canD>2){
    z2= Tps::makeVarPower(4,2);
    pz2= Tps::makeVarPower(5,2);
    tjz = z2+pz2;
  }
  Tps delta = Tps::makeVariable(nVar-1);
  Tps fi; Tps obj; int firstFlag = 1;
  for (int j=nmob[nVarH][getMinOrder()]; j<nmo[nVarH][getMaxOrder()]; ++j) {
    int *js; js = jv[nVarH][j];
    int canO = js[1]; for (int k=2; k<=canD; ++k) canO +=js[k];
    if (canO>0) {
      obj = pwr(tjx,js[1]);
      if (canD>1) obj = obj * pwr(tjy,js[2]);
      if (canD>2) obj = obj * pwr(tjz,js[3]);
      obj = obj * pwr(delta,js[nVarH]);
      if (firstFlag) { fi = (*zp)[j]*obj; firstFlag = 0; }
      else { fi += (*zp)[j]*obj; }
    }
  }
  int minOrd = max(3, fi.getMinOrder());
  int accOrd = min(ZlibMaxOrder, fi.getAccOrder());
  fi = fi.filter(fi.getMaxOrder(), minOrd, accOrd);
  return fi;
}

Tps Tps::lineIntegralDiagonal(int nVar, double c) const 
{
      Tps obj(*this);
      obj.zp->lineIntegralDiagonal( nVar, c);
      return obj;
}

Tps Tps::excludeNoParaDependentTerms(int lastindxs) const {
  Tps obj(*this, this->getMaxOrder());
  obj.zp->excludeNoParaDependentTerms(lastindxs);
  return obj;
}

Tps Tps::nonlinearBetaParaTerms(int lastindxs) const {
  Tps obj(*this, this->getMaxOrder());
  obj.zp->nonlinearBetaParaTerms(lastindxs);
  return obj;
}

void Tps::deltaGiven(double eps, int lastindxs) {
  zp->deltaGiven(eps,lastindxs);
}

/*
double pwr(double c, int p)
{
  double d = 1.0;
  for (int i=0; i<p; ++i) d *= c;
  return d;
}
*/

Tps Tps::lineIntegral1D(int iv, double c) const 
{
  int max_ord = min(zp->max_order+1, ZlibMaxOrder);
  int acc_ord = zp->acc_order+1;
  int min_ord = zp->min_order+1;
  if (min_ord > ZlibMaxOrder) 
    {
      Tps z = 0.0;
      return z;
    }
  Tps obj(zp->num_var, max_ord, acc_ord, min_ord);
  obj.zp->clear(min_ord, max_ord);
  int i;
  int *p; p = new int[zp->num_var];  int *p1; p1 = new int[zp->num_var];
  for (i=0; i<zp->num_var; ++i) { p[i] = 0; p1[i] = 0; }
  for (i=min_ord; i<=max_ord; ++i)
    {
      p[iv] = i;
      p1[iv] = i-1;
      obj[p] = (*this)[p1]*pwr(c,i)/i;
    }      
  obj.condenseMinOrder();
  obj.condenseMaxOrder();
  return obj;
}
  
/*
Tps BCH(const Tps& zps1, const Tps& zps2, int ord) {
     Tps objBCH;
     objBCH = zps1 + zps2;
     if (ord == 0) return objBCH;
     Tps obj1;
     obj1 = PoissonBracket(zps1, zps2);
     obj1 = PoissonBracket(zps1, zps2);
     objBCH += obj1*0.5;
     if (ord == 1) return objBCH;
     Tps obj2, obj3;
     obj2 = PoissonBracket(zps1, obj1);
     objBCH += obj2/12.0;
     obj3 = PoissonBracket(zps2, obj1);
     objBCH -= obj3/12.0;
     if (ord == 2) return objBCH;
     Tps obj4;
     obj4 = PoissonBracket(zps2, obj2);
     objBCH -= obj4/24.0;
     if (ord == 3) return objBCH;
     obj1 = PoissonBracket(zps1, obj4);
     objBCH -= obj1/120.0;
     obj4 = PoissonBracket(zps2, obj3);
     obj1 = PoissonBracket(zps2, obj4);
     objBCH += obj1/720.0;
     obj1 = PoissonBracket(zps1, obj4);
     objBCH -= obj1/360.0;
     obj4 = PoissonBracket(zps1, obj2);
     obj1 = PoissonBracket(zps2, obj4);
     objBCH += obj1/360.0;
     obj1 = PoissonBracket(zps1, obj4);
     objBCH -= obj1/720.0;
     obj4 = PoissonBracket(zps1, obj3);
     obj1 = PoissonBracket(zps2, obj4);
     objBCH += obj1/120.0;
     return objBCH;
}
*/

/*
Tps& Tps::norm(double exsq, double dta) {   // to be deleted, for temp use only
     int i,j, kount;
     for (j=0; j< nmo[getOrder()]; ++j) {
         kount=0;
         for (i=0; i<4; ++i) kount += jv[i][j];
	 for (i=0; i<kount; ++i) zp[j] *= exsq;
	 for (i=0; i<jv[4][j]; ++i) zp[j] *= dta;
     }
     return *this;
}
*/



double CC(int ie, int l, int m)
{
  //     CC(ie,l,m)= SUM[ia=LRG(0,ie-l),SML(ie,m)]
  //       (-1)**ia * kBinom(l+m-ie,m-ia)*kBinom(ie,ia);
  //       //            kBinom(l+m-ie,m-ia)*kBinom(ie,ia);
  int nrme=l+m-ie;
  int ia0=0;
  if (ie > l) ia0=ie-l;
  int iaf=ie;
  if (m < ie) iaf=m;
  double cc=0.0;
  for (int ia=ia0; ia<=iaf; ++ia)
         //    cc=cc+kbinom(nrme,m-ia)*kbinom(ie,ia);
    cc=cc+pwr(-1,ia)*kbinom(nrme,m-ia)*kbinom(ie,ia);
  return cc;
}
  
/*

int kbinom(int n, int k) // kbinom = n!/[k!(n-k)!]
{
  if (n == 0 || k == 0) { return 1;}
  int nmk=n-k;
  int kb=nmk+1;
  for (int i=2; i<=k; ++i) kb=kb*(nmk+i)/i;
  return kb;
}

double CCM(int ie, int l, int m)
{
  //     CC(ie,l,m)= SUM[ia=LRG(0,ie-l),SML(ie,m)]
  //       (-1)**(m-ia) * kBinom(l+m-ie,m-ia)*kBinom(ie,ia);
  //       //            kBinom(l+m-ie,m-ia)*kBinom(ie,ia);
  int nrme=l+m-ie;
  int ia0=0;
  if (ie > l) ia0=ie-l;
  int iaf=ie;
  if (m < ie) iaf=m;
  double cc=0.0;
  for (int ia=ia0; ia<=iaf; ++ia)
        //    cc=cc+kbinom(nrme,m-ia)*kbinom(ie,ia);
    cc=cc+pwr(-1,m-ia)*kbinom(nrme,m-ia)*kbinom(ie,ia);
  return cc;
}
  
double_complex Dps::getrlm(int ihomo, int lmno[]) const
{
//     /= sqrt(1/2)**ihomo * SUM[ie1=0,l+m] SUM[ie2=0,n+o] 
//     = i**m * SUM[ie1=0,l+m] SUM[ie2=0,n+o] 
//       C(l+m-ie1,ie1,n+o-ie2,ie2)*CCM(ie1,l,m)*CCM(ie2,n.o).
//     where,  for l,m,n,o,... given,
//        CCM(ie1,l,m)= SUM[ia1=LRG(0,ie1-l),SML(ie1,m)* (-1)**(m-ia1)
//                   *Binom(l+m-ie1,m-ia1)*Binom(ie1,ia1);
//        CCM(ie2,n,o)= SUM[ia2=LRG(0,ie2-l),SML(ie2,o)* (-1)**(m-ia2)
//                   *Binom(n+o-ie2,o-ia2)*Binom(ie2,ia2);

      int i,j;
      const int canDimMax=3; const int orderMax=11; 
      int nr[canDimMax];
      int lm[canDimMax*2];
      int js[canDimMax*2+1];
      js[0] = ihomo;
      //
      int nVar = getNumVar();
      int canDim=nVar/2;
      for (i=canDim; i<canDimMax; ++i) {
	nr[i]=0;
	lm[i*2] = lm[i*2+1] = 0;
      }
      int mosum=0;
      for (i=0; i<canDim; ++i) {
         int id1=i*2;
         int id2=id1+1;
	 lm[id1] = lmno[id1];
	 lm[id2] = lmno[id2];
         nr[i]=lmno[id1]+lmno[id2];
	 mosum += lm[id2];
      }
      double_complex clm(0.0, 0.0);
      double_complex plusi(0.0, -1.0);
      for (int ie3=0; ie3<=nr[2]; ++ie3) {
	js[5]=nr[2]-ie3; js[6]=ie3;
	double cc3 = CC(ie3,lm[4],lm[5]);
	for (int ie2=0; ie2<=nr[1]; ++ie2) {
	  js[3]=nr[1]-ie2; js[4] = ie2;
	  double cc2 = CC(ie2,lm[2],lm[3]);
	  for (int ie1=0; ie1<=nr[0]; ++ie1) {
	    js[1]=nr[0]-ie1; js[2]=ie1;
	    //c----    ccsum = C*CCM(ie1,1)*CCM(ie2,2)*...CCM(ie?,?)
	    j=jpek(nVar,js);
	    clm += (*zp)[j]*CCM(ie1,lm[0],lm[1])*cc2*cc3;
	  }
	}
      }
      clm=clm*pwr(plusi,mosum);
      return clm;
}
  
double_complex Tps::getclm(int ihomo, int lmno[]) const
{
//  subroutine getclm(ff,ihomo,nVar,lm,clm)
//--- obtaining the coeficients of C(l,m,n,o) of homogeneous polynomial
//    of degree i. One can refer to Section 3.8.3 of Cahpter 3 of the SSCL-500.
//    here x+= X - iPx while x-= X + iPx.
//---- C(l,m,n,o) = aa(l,m,n,o) + i bb(l,m,n,o)
//     //= sqrt(1/2)**ihomo * SUM[ie1=0,l+m] SUM[ie2=0,n+o] 
//     = (1/2)**ihomo * SUM[ie1=0,l+m] SUM[ie2=0,n+o] 
//       //(-i)**(ie1+ie2)  *R(l+m-ie1,ie1,n+o-ie2,ie2)*CC(ie1,l,m)*CC(ie2,n.o).
//       i**(ie1+ie2)  *R(l+m-ie1,ie1,n+o-ie2,ie2)*CC(ie1,l,m)*CC(ie2,n.o).
//     where,  for l,m,n,o,... given,
//        CC(ie1,l,m)= SUM[ia1=LRG(0,ie1-l),SML(ie1,m)* (-1)**ia1
//                   *Binom(l+m-ie1,m-ia1)*Binom(ie1,ia1);
//        CC(ie2,n,o)= SUM[ia2=LRG(0,ie2-l),SML(ie2,o)* (-1)**ia2
//                   *Binom(n+o-ie2,o-ia2)*Binom(ie2,ia2);

      int i,j;
      const int canDimMax=3; const int orderMax=11; 
      int nr[canDimMax];
      int lm[canDimMax*2];
      int js[canDimMax*2+1];
      js[0] = ihomo;
      int nVar = getNumVar();
      int canDim=nVar/2;
      for (i=canDim; i<canDimMax; ++i) {
	nr[i]=0;
	lm[i*2] = lm[i*2+1] = 0;
      }
      for (i=0; i<canDim; ++i) {
         int id1=i*2;
         int id2=id1+1;
	 lm[id1] = lmno[id1];
	 lm[id2] = lmno[id2];
         nr[i]=lmno[id1]+lmno[id2];
      }
      //      cout << "canDim = " << canDim << endl;
      //      for (int i=0; i<2*canDim; ++i) cout << lmno[i] << ' ';
      //      cout << "nr = " << nr[0] << ' ' << nr[1] << ' ' << nr[2] << endl;
      double_complex clm(0.0, 0.0);
      //      double_complex minusi(0.0, -1.0);
      double_complex plusi(0.0, 1.0);
      for (int ie3=0; ie3<=nr[2]; ++ie3) {
	js[5]=nr[2]-ie3; js[6]=ie3;
	double cc3 = CC(ie3,lm[4],lm[5]);
	for (int ie2=0; ie2<=nr[1]; ++ie2) {
	  js[3]=nr[1]-ie2; js[4] = ie2;
	  double cc2 = CC(ie2,lm[2],lm[3]);
	  for (int ie1=0; ie1<=nr[0]; ++ie1) {
	    js[1]=nr[0]-ie1; js[2]=ie1;
	    //c----    ccsum = R*CC(ie1,1)*CC(ie2,2)*...CC(ie?,?)
	    j=jpek(nVar,js);
	    int iesum=ie1+ie2+ie3;
	    clm += (*zp)[j]*CC(ie1,lm[0],lm[1])*cc2*cc3*pwr(plusi,iesum);
	  }
	}
      }
      clm=clm*pwr(0.5,ihomo);
      return clm;
}
*/

