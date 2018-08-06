//  File:         mxVps.hpp
//  Description:  This file contains the definition of mxVps class 
//                for Zlib c++ version. 
//  mxVps:        mixed-variable Vps with a separated linear transformation.
//                That is, from X = mw = Mw + U_2(w) ----->
//                (a) X = x + U_2(x), where x = M^-1 w;
//                (b) z = V(y) = y + V_2(y), where
//                    z = (x, Px, y, Py, z, Pz)^T
//                    y = (X, px, Y, py, Z, pz)^T
//
//  Author:       Yiton T. Yan                 
//  Copyright:    See Copyright.hpp

#ifndef mxVps_H
#define mxVps_H

#include "doubleMatrix.hpp"
#include "Tps.hpp"
#include "Vps.hpp"

class Vec;
//class doubleMatrix;
//class Tps;

class mxVps: public Zlib {

public:
     mxVps(); 
     mxVps(int o, int dim, int nvar=99);
     mxVps(const mxVps& zps);
     mxVps(const Vps& zps);
     ~mxVps();
     mxVps& operator=(const mxVps& zps);
  // 3 returns for gf== generating function, and the mixed Vps's uu,ww.
     mxVps& generating(int order=99); 
     mxVps truncate(int order) const; 
     Vec operator() (const Vec & x, int order, int& lossflag) const; //mixed Map Tracking
     friend ostream& operator << (ostream& out, const mxVps & zps);
     friend istream& operator >> (istream& in, mxVps & zps);
     doubleMatrix getRR() const { return RR;}
     Vps getuu() const {return uu;}
     Tps getgf() const {return gf;}

protected:
     doubleMatrix RR;
     Vps uu;   // uu(x,px,y,py,x,pz) or uu(X,px,Y,py,Z,pz).
     Tps gf;   // gf(X,px,Y,py,Z,pz).
     Vps ww;   // ww(X,Y,Z,px,py,pz).
     mxVps& operator=(const Vps& zps);
};

#endif  //mxVps_H

