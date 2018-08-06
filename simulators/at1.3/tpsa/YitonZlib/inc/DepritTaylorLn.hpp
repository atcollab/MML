//  File:         DepritTaylorLn.hpp
//  Description:  This file contains the definition of DepritTaylorLn class 
//                for Zlib c++ version. 
//  DepritTaylorLn:  Linearly normalized Deprit type Taylor transformation
//                = AI R exp(f) A, where exp(f) is in Taylor form.
//
//  Author:       Yiton T. Yan                 
//  Copyright:    See Copyright.hpp
//

#ifndef DepritTaylorLn_H
#define DepritTaylorLn_H

#include "Vps.hpp"
#include "DepritTaylor.hpp"

class DepritTaylorLn: public DepritTaylor {

public:
     DepritTaylorLn(); 
     DepritTaylorLn(int o, int dim);
     DepritTaylorLn(const DepritTaylorLn& zps);
     DepritTaylorLn(const Vps& zps);
     ~DepritTaylorLn();
     DepritTaylorLn& operator=(const DepritTaylorLn& zps);
     operator Vps() const; 
     DepritTaylorLn inv(int o=100);
     DepritTaylorLn operator*(const DepritTaylorLn& zps) const;

     doubleMatrix getAA() const { return AA;}
     doubleMatrix getAI() const { return AI;}
     void assign(const doubleMatrix& MI, const doubleMatrix& R, const Vps& gg, const doubleMatrix& MM) {AI=MI; RR=R; ff=gg; AA=MM;}
     friend istream& operator >> (istream& in, DepritTaylorLn & zps);
     friend ostream& operator << (ostream& out, const DepritTaylorLn & zps);

protected:
     doubleMatrix AA, AI;
     DepritTaylorLn& operator=(const Vps& zps);
};

#endif  //DepritTaylorLn_H
