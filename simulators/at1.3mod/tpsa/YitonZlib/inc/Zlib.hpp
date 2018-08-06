#ifndef ZLIB_HH
#define ZLIB_HH

//  Filename:     Zlib.hpp
//  ---------------------------------------------------------------------------
//  Category:     TPSA
//  ---------------------------------------------------------------------------
//  Release version:  $$.$$.$$
//  ---------------------------------------------------------------------------
//  Copyright:    see Copyright.hpp
//  ---------------------------------------------------------------------------
//  Description:  
//     Declared class:  Zlib (Zlib nerve) for Zlib C++ version
//  ---------------------------------------------------------------------------
//  Author:       Yiton T. Yan                 
//  Maintenance:
//     30-MAR-96, Yiton T. Yan, SLAC. 
//  ---------------------------------------------------------------------------

#include "ZlibInc.hpp"

class Zlib {

public:
        static int  jpek(int nVar, int*js);
        static int  numMo(int nVar, int order);
        static int digit;  // use of <cfloat>
protected:

        static int TpsFlag;         // Flag for first zpprep 
        static int Tps_STATIC;      
        static int ZlibCanDim;
  //        static int ZlibMaxSize;
  //        static int ZlibNumVarM1;

        static int ZlibNumVar;
        static int ZlibMaxOrder;
        static int ZlibNumVarPrev;  // Zlib dimension for zpprep previous one
        static int ZlibMaxOrderPrev;// Zlib maximum order for zpprep pointers
        static int zpprepTpsCount;      // Flag for zpprep

        static int**       nmo; 
        static int**       nmob; 
        static int**       nmoe; 
        static int****     nmov;
        static int***      jv;
        static int***      jt;
        static int***      jtf;  // the front part of jt: added for genrating on 11/3/2004.
        static int***      jtr;  // the rear part of jt: added for genrating on 11/3/2004.
        static int**       nkpm;
        static int****     ikb;
        static int****     ikp;
        static int***      kp;
        static int***      lp;
        static int***      jd;
        static double *csqrt;            // Sqrt Coeffs
        static double *cinv;             // Inverse Coeffs
        static double *cln;              // Ln Coeffs
        static double *cexp;             // Exp Coeffs
        static double *csc;              // Sine and CosSine Coeffs

        static int*    jsNerveUse;

        static void zpprepTps(void);   
        static void getnmo();
        static void getnmov();
        static void getjsNerveUse();
        static void getjv();
        static void getjt(); 
        static void getjtf(); 
        static void getjtr(); 
        static void getnkpm();
        static void mulprp();
        static void drvprp();
        static void deAlloc();
        static void zpcoef();


        static void  checkGlobal(void);
  //          static int*    js;
  //          void getjs();
  
        
// map
	static int***   nmvo; // zp tracking
        static int**    ivp;
        static int**    jpp;
        static double*  xxx;
        static int****  mp; // zp->tpa      
        static int***    jpc;  
        static int***    ivpc;
        static int***    ivppc;
        static int**     jpcMemTest;
        static int     nocnct;
        static int     nVarCnct;
        
        static void ztpapek(int nVar, int jtpa, int nov, int *js);
        static void pntcct(int nVar, int nov);

        
        
        static int VpsFlag;         // Flag for first zpprepVps 
        static int Vps_STATIC;      // Flag for zpprepVps

        static void zpprepVps();
        static void deAllocVps();       
        static void getnmvo();
        static void prptrk();
        static void getmp();
        static void getjpcMemTest();
};

#endif  //ZLIB_HH

