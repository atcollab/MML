//  File:         DepritLieLn45.hpp
//  Description:  This file contains the definition of DepritLieLn45 class 
//                for Zlib c++ version. 
//  DepritLieLn45:  Linearly normalized Deprit type Lie transformation
//                = AI R exp(f) A with parameters.
//
//  Author:       Yiton T. Yan                 
//  Copyright:    See Copyright.hpp
//

#ifndef DepritLieLn45_H
#define DepritLieLn45_H

#include "Vps.hpp"
#include "DepritLie45.hpp"

class DepritLieLn45: public DepritLie45 {

public:
     DepritLieLn45(); 
     DepritLieLn45(int o, int canonicalDimnesion, int nVar);
     DepritLieLn45(const DepritLieLn45& zps);
     DepritLieLn45(const Vps& zps);
     ~DepritLieLn45();
     DepritLieLn45& operator=(const DepritLieLn45& zps);
     operator Vps() const; 
     DepritLieLn45 operator-(const DepritLieLn45& zps);
     void condense(double eps = 1.e-10);
     DepritLieLn45 inv(int o=100);
     DepritLieLn45 operator*(const DepritLieLn45& zps) const;

     doubleMatrix getAA() { return AA;}
     doubleMatrix getAI() { return AI;}
     void assign(const doubleMatrix& MI, const doubleMatrix& R, const Tps& gg, const doubleMatrix& MM) {AI=MI; RR=R; ff=gg; AA=MM;}
     friend ostream& operator << (ostream& out, const DepritLieLn45 & zps);

private:
     doubleMatrix AA, AI;
     DepritLieLn45& operator=(const Vps& zps);
};

#endif  //DepritLieLn45_H
