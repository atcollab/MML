//  File:         DragtLieLn.hpp
//  Description:  This file contains the definition of DragtLieLn class 
//                for Zlib c++ version. 
//  DragtLieLn :  Dragt-Finn type Lie transformation=AI RR exp(f3)exp(f4)...AA;
//
//  Author:       Yiton T. Yan                 
//  Copyright:    See Copyright.hpp
//

#ifndef DragtLieLn_H
#define DragtLieLn_H

#include "Vps.hpp"
#include "DragtLie.hpp"

class DragtLieLn: public DragtLie {  

public:
     DragtLieLn();
     DragtLieLn(int o, int dim);
     DragtLieLn(const DragtLieLn& zps);
     DragtLieLn(const Vps& zps);
     ~DragtLieLn();
     DragtLieLn& operator=(const DragtLieLn& zps);
     operator Vps() const; 
     DragtLieLn inv(int o=100);
     DragtLieLn operator*(const DragtLieLn& zps) const;

     doubleMatrix getAA() const { return AA;}
     doubleMatrix getAI() const { return AI;}
     void assign(const doubleMatrix& MI, const doubleMatrix& R, const Tps& gg, const doubleMatrix& MM) {AI=MI; RR=R; ff=gg; AA=MM;}

     friend ostream& operator << (ostream& out, const DragtLieLn & zps);

private:
     doubleMatrix AA, AI;
     DragtLieLn& operator=(const Vps& zps);
};

#endif  //DragtLieLn_H

