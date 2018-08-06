//  File:         DepritLie45.hpp
//  Description:  This file contains the definition of DepritLie45 class 
//                for Zlib c++ version. 
//  DepritLie45:  Deprit type Lie transformation = M exp(f), with parameters
//
//  Author:       Yiton T. Yan                 
//  Copyright:    See Copyright.hpp

#ifndef DepritLie45_H
#define DepritLie45_H

#include "doubleMatrix.hpp"
#include "Tps.hpp"
#include "Vps.hpp"

class DepritLie45: public Zlib {

public:
     DepritLie45(); 
     DepritLie45(int o, int canonicalDimnesion, int nVar);
     DepritLie45(const DepritLie45& zps);
     DepritLie45(const Vps& zps);
  // DepritLie45(const Tps& zps); //convert from a single Lie with minOrder > 1
     ~DepritLie45();
     DepritLie45& operator=(const DepritLie45& zps);
     operator Vps() const; // need to be a virtual???
     DepritLie45 inv(int o=100);
     DepritLie45 operator*(const DepritLie45& zps) const;

     doubleMatrix getRR() const { return RR;}
     Tps getff() const {return ff;}
     void assign(const doubleMatrix& M, const Tps& gg) {RR=M; ff=gg;}

     friend ostream& operator << (ostream& out, const DepritLie45 & zps);
     void condense(double eps=1.e-10); // put value < eps to 0.

protected:
     int num_var;
     int canonical_dimension;
     doubleMatrix RR;
     Tps ff;
     DepritLie45& operator=(const Vps& zps);
};

#endif  //DepritLie45_H

