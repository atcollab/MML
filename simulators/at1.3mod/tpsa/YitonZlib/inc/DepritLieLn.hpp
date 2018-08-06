//  File:         DepritLieLn.hpp
//  Description:  This file contains the definition of DepritLieLn class 
//                for Zlib c++ version. 
//  DepritLieLn:  Linearly normalized Deprit type Lie transformation
//                = AI R exp(f) A.
//
//  Author:       Yiton T. Yan                 
//  Copyright:    See Copyright.hpp
//

#ifndef DepritLieLn_H
#define DepritLieLn_H

#include "Vps.hpp"
#include "DepritLie.hpp"

class DepritLieLn: public DepritLie {

public:
     DepritLieLn(); 
     DepritLieLn(int o, int dim);
     DepritLieLn(const DepritLieLn& zps);
     DepritLieLn(const Vps& zps);
     ~DepritLieLn();
     DepritLieLn& operator=(const DepritLieLn& zps);
     operator Vps() const; 
     DepritLieLn inv(int o=100);
     DepritLieLn operator*(const DepritLieLn& zps) const;

     doubleMatrix getAA() const { return AA;}
     doubleMatrix getAI() const { return AI;}
     void assign(const doubleMatrix& MI, const doubleMatrix& R, const Tps& gg, const doubleMatrix& MM) {AI=MI; RR=R; ff=gg; AA=MM;}
     friend ostream& operator << (ostream& out, const DepritLieLn & zps);

protected:
     doubleMatrix AA, AI;
     DepritLieLn& operator=(const Vps& zps);
};

#endif  //DepritLieLn_H
