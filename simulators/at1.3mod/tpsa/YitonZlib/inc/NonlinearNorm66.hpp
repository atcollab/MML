//  File:         NonlinearNorm66.hpp
//  Description:  This file contains the definition of NonlinearNorm66 class 
//                for Zlib c++ version. 
//  NonlinearNorm66:  nonlinearly normalized map
//                m = AI R exp(f) A, where R exp(f) = GI exp(-h) G, and 
//                G = exp(F3) exp(F4) exp(F5) ...
//
//  Author:       Yiton T. Yan                 
//  Copyright:    See Copyright.hpp
//

#ifndef NonlinearNorm66_H
#define NonlinearNorm66_H

#include "doubleMatrix.hpp"
#include "Tps.hpp"
#include "Vps.hpp"

class NonlinearNorm66: public Zlib {

public:
     NonlinearNorm66(); 
     NonlinearNorm66(int o, int canonicalDimnesion, int nVar);
     NonlinearNorm66(const NonlinearNorm66& zps);
     NonlinearNorm66(const Vps& zps);
     ~NonlinearNorm66();
     NonlinearNorm66& operator=(const NonlinearNorm66& zps);
     void condense(double eps = 1.e-10);
     //     operator Vps() const; 
     doubleMatrix getAA() { return AA;}
     doubleMatrix getAI() { return AI;}
     doubleMatrix getRR() { return RR;}
     Tps getFF() { return FF;}
     Tps gethh() { return hh;}
     Tps getHH() { return HH;}
     Vps getAF() { return AF;}
     Vps getAFI(){ return AFI;}
     Tps gettnx() { return tnx;}
     Tps gettny() { return tny;}
     friend ostream& operator << (ostream& out, const NonlinearNorm66 & zps);

private:
     int num_var;
     int canonical_dimension;
     doubleMatrix AA, AI, RR;
     Tps FF;
     Tps hh;  // in 2tjx, 2tjy power format
     Tps HH;  // in x, Px, y, Py, delta format ( H = -HH)
     Vps AF, AFI;  // = AA*eFF & eFFI(AI5);
     Tps tnx; // =(1/2pi)(dh/dJx) = -(1/pi) dhh/d(2Jx); (h = -hh);
     Tps tny; // =(1/2pi)(dh/dJy) = -(1/pi) dhh/d(2Jy); (h = -hh);
     NonlinearNorm66& operator=(const Vps& zps);
};

#endif  //NonlinearNorm66_H
