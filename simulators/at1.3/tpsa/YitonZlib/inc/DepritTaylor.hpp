//  File:         DepritTaylor.hpp
//  Description:  This file contains the definition of DepritTaylor class 
//                for Zlib c++ version. 
//  DepritTaylor: Deprit type Taylor transformation  = M exp(f),
//         where exp(f) is in Taylor expansion form with unit in linear order.
//
//  Author:       Yiton T. Yan                 
//  Copyright:    See Copyright.hpp

#ifndef DepritTaylor_H
#define DepritTaylor_H

#include "doubleMatrix.hpp"
#include "Tps.hpp"
#include "Vps.hpp"

class DepritTaylor: public Zlib {

public:
     DepritTaylor(); 
     DepritTaylor(int o, int dim);
     DepritTaylor(const DepritTaylor& zps);
     DepritTaylor(const Vps& zps);
     DepritTaylor(const Tps& zps); //convert from a single Lie with minOrder>1
     ~DepritTaylor();
     DepritTaylor& operator=(const DepritTaylor& zps);
     operator Vps() const; // need to be a virtual???
     DepritTaylor inv(int o=100);
     DepritTaylor operator*(const DepritTaylor& zps) const;

     doubleMatrix getRR() const { return RR;}
     Vps getff() const {return ff;}
     void assign(const doubleMatrix& M, const Vps& gg) {RR=M; ff=gg;}

     friend istream& operator >> (istream& in, DepritTaylor & zps);
     friend ostream& operator << (ostream& out, const DepritTaylor & zps);

protected:
     doubleMatrix RR;
     Vps ff;
     DepritTaylor& operator=(const Vps& zps);
};

#endif  //DepritTaylor_H

