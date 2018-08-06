//  File:         DragtLieLn45.hpp
//  Description:  This file contains the definition of DragtLieLn45 class 
//                for Zlib c++ version. 
//  DragtLieLn45:  Linearly normalized Dragt type Lie transformation
//                = AI R exp(f) A with np parameters.
//
//  Author:       Yiton T. Yan                 
//  Copyright:    See Copyright.hpp
//

#ifndef DragtLieLn45_H
#define DragtLieLn45_H

#include "Vps.hpp"
#include "DragtLie45.hpp"

class DragtLieLn45: public DragtLie45 {

public:
     DragtLieLn45(); 
     DragtLieLn45(int o, int canonicalDimnesion, int nParameters);
     DragtLieLn45(const DragtLieLn45& zps);
     DragtLieLn45(const Vps& zps);
     ~DragtLieLn45();
     DragtLieLn45& operator=(const DragtLieLn45& zps);
     operator Vps() const; 
     DragtLieLn45 operator-(const DragtLieLn45& zps);
     void condense(double eps = 1.e-10);
     DragtLieLn45 inv(int o=100);
     DragtLieLn45 operator*(const DragtLieLn45& zps) const;

     doubleMatrix getAA() { return AA;}
     doubleMatrix getAI() { return AI;}
     void assign(const doubleMatrix& MI, const doubleMatrix& R, const Tps& gg, const doubleMatrix& MM) {AI=MI; RR=R; ff=gg; AA=MM;}
     friend ostream& operator << (ostream& out, const DragtLieLn45 & zps);

private:
     doubleMatrix AA, AI;
     DragtLieLn45& operator=(const Vps& zps);
};

#endif  //DragtLieLn45_H
