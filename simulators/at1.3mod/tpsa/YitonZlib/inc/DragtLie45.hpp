//  File:         DragtLie45.hpp
//  Description:  This file contains the definition of DragtLie45 class 
//                for Zlib c++ version. 
//  DragtLie45   :  Dragt-Finn type Lie transformation = MM exp(f3)exp(f4)...;
//
//  Author:       Yiton T. Yan                 
//  Copyright:    See Copyright.hpp
//

#ifndef DragtLie45_H
#define DragtLie45_H

#include "Vps.hpp"
#include "Tps.hpp"
#include "doubleMatrix.hpp"

class DragtLie45: public Zlib { 

public:
     DragtLie45();
     DragtLie45(int o, int canonicalDimnesion, int nVar);
     DragtLie45(const DragtLie45& zps);
     DragtLie45(const Vps& zps);
     ~DragtLie45();
     DragtLie45& operator=(const DragtLie45& zps);
     operator Vps() const; 
     DragtLie45 inv(int o=100);
     DragtLie45 operator*(const DragtLie45& zps) const;

     doubleMatrix getRR() const { return RR;}
     Tps getff() const {return ff;}
     void assign(const doubleMatrix& M, const Tps& gg) {RR=M; ff=gg;}

     friend ostream& operator << (ostream& out, const DragtLie45 & zps);

protected:
     int num_var;
     int canonical_dimension;
     doubleMatrix RR;
     Tps ff;
     DragtLie45& operator=(const Vps& zps);
};

#endif  //DragtLie45_H

