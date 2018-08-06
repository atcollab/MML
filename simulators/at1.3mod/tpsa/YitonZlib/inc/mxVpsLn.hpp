//  File:         mxVpsLn.hpp
//  Description:  This file contains the definition of mxVpsLn class 
//                for Zlib c++ version. 
//  mxVpsLn:      mixed-variable Vps with a separated linear nomzlization
//                transformation. That is, from X = mw = ARA^{-1}w + U_2(w)-->
//                (a) X = x + U_2(x), where x = A^-1 w;
//                (b) z = V(y) = y + V_2(y), where
//                    z = (x, Px, y, Py, z, Pz)^T
//                    y = (X, px, Y, py, Z, pz)^T
//
//  Author:       Yiton T. Yan                 
//  Copyright:    See Copyright.hpp

#ifndef mxVpsLn_H
#define mxVpsLn_H

#include "doubleMatrix.hpp"
#include "Tps.hpp"
#include "Vps.hpp"
#include "mxVps.hpp"

class Vec;
//class doubleMatrix;
//class Tps;

class mxVpsLn: public mxVps {

public:
     mxVpsLn(); 
     mxVpsLn(int o, int dim, int nvar=99);
     mxVpsLn(const mxVpsLn& zps);
     mxVpsLn(const Vps& zps);
     ~mxVpsLn();
     mxVpsLn& operator=(const mxVpsLn& zps);
  // 3 returns for gf== generating function, and the mixed Vps's uu,ww.
  //     mxVpsLn& generating(int order=99); 
     mxVpsLn truncate(int order) const; 
     Vec operator() (const Vec & x, int order, int& lossflag) const; //mixed Map Tracking
     friend ostream& operator << (ostream& out, const mxVpsLn & zps);
     friend istream& operator >> (istream& in, mxVpsLn & zps);
     doubleMatrix getAA() const { return AA;}
     doubleMatrix getAI() const { return AI;}

protected:
     doubleMatrix AA, AI;
     mxVpsLn& operator=(const Vps& zps);
};

#endif  //mxVpsLn_H

