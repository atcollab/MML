//  File:         NonlinearNorm45.hpp
//  Description:  This file contains the definition of NonlinearNorm45 class 
//                for Zlib c++ version. 
//  NonlinearNorm:  nonlinearly normalized map
//                m = AI R exp(f) A, where R exp(f) = GI exp(-h) G, and 
//                G = exp(F3) exp(F4) exp(F5) ...
//
//  Author:       Yiton T. Yan                 
//  Copyright:    See Copyright.hpp
//

#ifndef NonlinearNorm45_H
#define NonlinearNorm45_H

#include "doubleMatrix.hpp"
#include "Tps.hpp"
#include "Vps.hpp"

class NonlinearNorm45: public Zlib {

public:
     NonlinearNorm45(); 
     NonlinearNorm45(int o, int canonicalDimnesion, int nVar);
     NonlinearNorm45(const NonlinearNorm45& zps);
     NonlinearNorm45(const Vps& zps);
     ~NonlinearNorm45();
     NonlinearNorm45& operator=(const NonlinearNorm45& zps);
     void condense(double eps = 1.e-10);
     //     operator Vps() const; 
     doubleMatrix getEta() { return eta;}
     Vps getXc() { return Xc; }
     doubleMatrix getAA() { return AA;}
     doubleMatrix getAI() { return AI;}
     doubleMatrix getRR() { return RR;}
     Tps getFF() { return FF;}
     Tps gethh() { return hh;}
     Tps gethhc() { return hhc;}
     Tps getHH() { return HH;}
     Vps getAF() { return AF;}
     Vps getAFI(){ return AFI;}
     Vps getAFC() { return AFC;}
     friend ostream& operator << (ostream& out, const NonlinearNorm45 & zps);

private:
     int num_var;
     int canonical_dimension;
     doubleMatrix eta;
     Vps Xc;
     doubleMatrix AA, AI, RR;
     Tps FF;
     Tps hh;  // in 2tjx, 2tjy power format
     Tps hhc;  // in 2tjx, 2tjy power format for delta-dependent terms only
     Tps HH;  // in x, Px, y, Py, delta format
     Vps AF, AFI;  // = AA*eFF & eFFI(AI5);
     Vps AFC;  // for delta-dependent terms of AF.
     NonlinearNorm45& operator=(const Vps& zps);
};

#endif  //NonlinearNorm45_H
