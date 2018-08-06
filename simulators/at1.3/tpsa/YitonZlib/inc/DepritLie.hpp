//  File:         DepritLie.hpp
//  Description:  This file contains the definition of DepritLie class 
//                for Zlib c++ version. 
//  DepritLie:    Deprit type Lie transformation  = M exp(f)
//
//  Author:       Yiton T. Yan                 
//  Copyright:    See Copyright.hpp

#ifndef DepritLie_H
#define DepritLie_H

#include "doubleMatrix.hpp"
#include "Tps.hpp"
#include "Vps.hpp"

class DepritLie: public Zlib {

public:
     DepritLie(); 
     DepritLie(int o, int dim);
     DepritLie(const DepritLie& zps);
     DepritLie(const Vps& zps);
     DepritLie(const Tps& zps); //convert from a single Lie with minOrder > 1
     ~DepritLie();
     DepritLie& operator=(const DepritLie& zps);
     operator Vps() const; // need to be a virtual???
     DepritLie inv(int o=100);
     DepritLie operator*(const DepritLie& zps) const;

     doubleMatrix getRR() const { return RR;}
     Tps getff() const {return ff;}
     void assign(const doubleMatrix& M, const Tps& gg) {RR=M; ff=gg;}

     friend ostream& operator << (ostream& out, const DepritLie & zps);

protected:
     doubleMatrix RR;
     Tps ff;
     DepritLie& operator=(const Vps& zps);
};

#endif  //DepritLie_H

