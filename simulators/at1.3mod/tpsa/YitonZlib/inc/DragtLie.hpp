//  File:         DragtLie.hpp
//  Description:  This file contains the definition of DragtLie class 
//                for Zlib c++ version. 
//  DragtLie   :  Dragt-Finn type Lie transformation = MM exp(f3)exp(f4)...;
//
//  Author:       Yiton T. Yan                 
//  Copyright:    See Copyright.hpp
//

#ifndef DragtLie_H
#define DragtLie_H

#include "Vps.hpp"
#include "Tps.hpp"
#include "doubleMatrix.hpp"

class DragtLie: public Zlib { 

public:
     DragtLie();
     DragtLie(int o, int dim);
     DragtLie(const DragtLie& zps);
     DragtLie(const Vps& zps);
     ~DragtLie();
     DragtLie& operator=(const DragtLie& zps);
     operator Vps() const; 
     DragtLie inv(int o=100);
     DragtLie operator*(const DragtLie& zps) const;

     doubleMatrix getRR() const { return RR;}
     Tps getff() const {return ff;}
     void assign(const doubleMatrix& M, const Tps& gg) {RR=M; ff=gg;}

     friend ostream& operator << (ostream& out, const DragtLie & zps);

protected:
     doubleMatrix RR;
     Tps ff;
     DragtLie& operator=(const Vps& zps);
};

#endif  //DragtLie_H

