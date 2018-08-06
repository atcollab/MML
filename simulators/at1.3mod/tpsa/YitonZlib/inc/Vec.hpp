//  File:         Vec.hpp
//  Description:  This file contains the definition of Vec class 
//                for Zlib c++ version. 
//  Vec   :       Vector
//
//  Author:       Yiton T. Yan
//  Acknowledgement: Scott Berg
//

#ifndef VEC_H
#define VEC_H

#include "ZlibInc.hpp"

class VecData {
  int n;
  double *v;
  int count;
public:
  VecData(int _n);
  VecData(const VecData &_v): n(_v.n),
    v((double *) memcpy(new double[_v.n], _v.v, _v.n*sizeof(double))), 
    count(1) {}
  ~VecData() { delete [] v;}
  VecData & operator = (const VecData &_v);
  int getSize() const { return n; }
  int Count() const { return count; }
  // operator const double*() const { return v; }
  double operator[](int i) const { return v[i]; }
  // operator double*() { return v; }
  double& operator[](int i) { return v[i]; }
    
  int AllGone() const { return count==0; }
  int OnlyOne() const { return count==1; }
  void operator++() { ++count; } // prefix
  void operator++(int) { ++count; } // postfix
  void operator--() { --count; }
  void operator--(int) { --count; }
};

class Vec {
  VecData* v;
public:
  Vec() : v(new VecData(6)) {}
  Vec(int n) : v(new VecData(n)) {}
  Vec(const Vec& _v) : v(_v.v) { ++(*v); }
  ~Vec() { --(*v); if (v->AllGone()) delete v; }
  double operator()(int i) const { return (*v)[i-1]; }
  double & operator()(int i) ;  //{ return (*v)[i-1]; }
  double operator[](int i) const { return (*v)[i]; }
  double & operator[](int i) ;  //{ return (*v)[i]; }
  Vec& operator=(const Vec& _v);
  Vec operator+(const Vec& _v) const;
  Vec operator-(const Vec& _v) const;
  Vec operator*(double) const;  
  friend Vec operator*(double, const Vec&); 
  double operator*(const Vec& _v) const;    // inner product
  Vec& operator+=(const Vec& _v);
  Vec& operator-=(const Vec& _v);
  friend ostream & operator << (ostream &, const Vec &);
  friend istream & operator >> (istream &, Vec &);
  int getSize() const { return v->getSize(); }
  int Count() const { return v->Count(); }
  double norm();
};
#endif  //VEC_H
