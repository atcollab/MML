//  File:         doubleMatrix.hpp
//  Description:  This file contains the definition of doubleMatrix class 
//                for Zlib c++ version. 
//
//  Author:       Yiton T. Yan                 
//  Copyright:    See Copyright.hpp
//  Acknowledgement: N.M.
//

#ifndef doubleMatrix_H
#define doubleMatrix_H

#include "ZlibInc.hpp"
#include "Vec.hpp"

class Mdata {
  int r, c, rc;
  double **v;
  int count;
public:
  Mdata();
  Mdata(int _r, int _c);
  Mdata(const Mdata &_v);
  ~Mdata();
  Mdata & operator = (const Mdata &_v);
  int Row() const { return r; }
  int Col() const { return c; }
  int RC() const { return rc; }
  int Count() const { return count; }
  double operator [] (int i) const { return v[0][i]; }
  double& operator [] (int i) { return v[0][i]; }
  // operator const double*() const { return v; }
  double operator () (int i, int j) const { return v[i][j]; }
  // operator double*() { return v; }
  double& operator () (int i, int j) { return v[i][j]; }
    
  int AllGone() const { return count==0; }
  int OnlyOne() const { return count==1; }
  void operator++();// { ++count; ++TotalCountdoubleMatrix; } // prefix
  void operator++(int);// { ++count; ++TotalCountdoubleMatrix; } // postfix
  void operator--();// { --count; --TotalCountdoubleMatrix; }
  void operator--(int);// { --count; --TotalCountdoubleMatrix; }
  int TotalCount() { return TotalCountdoubleMatrix; }
private:
  static int TotalCountdoubleMatrix;
};

class doubleMatrix {
  Mdata *v;
  static int ROW; // for default row. 
  static int COL; // for default col
public:
  doubleMatrix();
  doubleMatrix(int r, int c) : v(new Mdata(r,c)) {}
  doubleMatrix(int r, int c, int R, int C);
  doubleMatrix(int n); // Symplectic identity, row = col = 2*n
  doubleMatrix(int, double); // diagonal doubleMatrix
  doubleMatrix(double); // diagonal doubleMatrix with default dimension r=c=ROW
  doubleMatrix(const doubleMatrix& _v) : v(_v.v) { ++(*v); }
  //  doubleMatrix(const Matrix&); // interface with Lego
  doubleMatrix& memConstruct(int r, int c);
  ~doubleMatrix() { --(*v); if (v->AllGone()) delete v; }
  double operator () (int i, int j) const { return (*v)(i,j); }
  double & operator () (int i, int j) ;  //{ return (*v)(i,j); }
  double A(int i, int j) const { return (*v)(i-1,j-1); }
  double& A(int i, int j); // { return (*v)(i-1,j-1); }
  doubleMatrix& operator=(const doubleMatrix& _v);
  //  doubleMatrix& operator=(const Matrix&);
  doubleMatrix subMatrix(int ri, int re, int ci, int ce) const;
  doubleMatrix subMatrix(int r, int c) const;
  doubleMatrix expandToSquare(int s) const;
  Vec getColVec(int ri, int re, int c) const;
  Vec getColVec(int c) const;
  Vec getRowVec(int r, int ci, int ce) const;
  Vec getRowVec(int r) const;
  doubleMatrix expandMatrix(int ri, int ci, int re, int ce) const;
  doubleMatrix expandMatrix(int r, int c) const;

  doubleMatrix operator+(const doubleMatrix& _v) const;
  doubleMatrix operator-(const doubleMatrix& _v) const;
  doubleMatrix operator*(const doubleMatrix& _v) const; 
  doubleMatrix operator/(const doubleMatrix& _v) const; 
  doubleMatrix& operator+=(const doubleMatrix& _v);
  doubleMatrix& operator-=(const doubleMatrix& _v);
  doubleMatrix& operator*=(const doubleMatrix& _v);
  doubleMatrix& operator/=(const doubleMatrix& _v);
  //doubleMatrix& inv();
  doubleMatrix invM(int s=1) const;
  int inv(); // bool
  int Eigen(doubleMatrix&, doubleMatrix&, Vec&, Vec&);
  int Norm(doubleMatrix& A, doubleMatrix& R, doubleMatrix& AI);
  int Norm45(doubleMatrix& A, doubleMatrix& R, doubleMatrix& AI);
  double AbsSumElm() const;
  int checkI() const; // bool
  int checkSymplecticity(doubleMatrix & S) const; // bool // S = M'*SS*M;
  void zero();
  Vec operator*(const Vec &) const;
  friend doubleMatrix operator*(const doubleMatrix&, const double);
  friend doubleMatrix operator*(const double, const doubleMatrix&);
  friend doubleMatrix operator/(const doubleMatrix&, const double);
  friend doubleMatrix operator/(const double, const doubleMatrix&);
  friend ostream & operator << (ostream &, const doubleMatrix &);
  friend istream & operator >> (istream &, doubleMatrix &);
  int Row() const { return v->Row(); }
  int Col() const { return v->Col(); }
  doubleMatrix Transpose() const;
  operator Vec() const;
  Vec vec(int col) const;
  int Count() const { return v->Count(); }
  int TotalCount() { return v->TotalCount(); }
//  int Ascript(int n, doubleMatrix & A, doubleMatrix &Ainv, doubleMatrix & R);
//  int Twiss(Vec& A, Vec& B, Vec& r);
private:
    static void upperHessenberg(int, int, int, doubleMatrix &, Vec &);
    static void upperHessenbergAccu(int, int, int, doubleMatrix &, Vec &, doubleMatrix &);
    static void Hessenberg(int, int, int, doubleMatrix &, Vec &, Vec &,
                     doubleMatrix &, int &);
};

#endif  //doubleMatrix_H

