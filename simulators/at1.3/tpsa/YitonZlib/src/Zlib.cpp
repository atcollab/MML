#include "Zlib.hpp"

// -------------------------------------------------
int      Zlib::TpsFlag = 1;
int      Zlib::Tps_STATIC = 0;
int      Zlib::ZlibCanDim = 0;
//int      Zlib::ZlibMaxSize = 1;
//int      Zlib::ZlibNumVarM1 = 0;  
// -------------------------------------------------

//Global Variables
int      Zlib::ZlibNumVar = 0;  
int      Zlib::ZlibMaxOrder = -1;
int      Zlib::ZlibNumVarPrev;
int      Zlib::ZlibMaxOrderPrev;
int      Zlib::zpprepTpsCount = 0;
int      Zlib::digit = DBL_DIG+2;  // use of <cfloat>

// One-Step Index Pointers (OSIP's)
int**    Zlib::nmo;
int**    Zlib::nmob;
int**    Zlib::nmoe;
int****  Zlib::nmov;
int***   Zlib::jv;
int***   Zlib::jt;
int***   Zlib::jtf;
int***   Zlib::jtr;
int**    Zlib::nkpm;
int****  Zlib::ikb;
int****  Zlib::ikp;
int***   Zlib::kp;
int***   Zlib::lp;
int***   Zlib::jd;

double*     Zlib::csqrt;
double*     Zlib::cinv;
double*     Zlib::cln;
double*     Zlib::cexp;
double*     Zlib::csc;

//
//
// Vps part
int     Zlib::VpsFlag = 1;
int     Zlib::Vps_STATIC = 0;

// Zlib Members for Tracking

int**    Zlib::ivp;   // done
int**    Zlib::jpp;   // done
double* Zlib::xxx;

// Zlib Members for Concatenation
 
int***    Zlib::jpc;
int***    Zlib::ivpc;
int***    Zlib::ivppc;
int**     Zlib::jpcMemTest;
int     Zlib::nocnct = -1;
int     Zlib::nVarCnct = -1;

// Zlib auxiliary Static Members 
// mp --> jsNerveUse, ztpapek()--> jpek() --> pntcct() --> Static Members for Mult.
// nmvo --> Static Members for Tracking

int****  Zlib::mp; // done
int***   Zlib::nmvo;  // done
int*     Zlib::jsNerveUse;
//
//

void Zlib::checkGlobal() {
  if(ZlibNumVar < 1 || ZlibMaxOrder < 0)
  {
     cerr << "Error: Zlib::checkGlobal() : ZlibNumVar = ";
     cerr <<  ZlibNumVar << " < 1\n";
     cerr << "Error: Zlib::checkGlobal() : ZlibMaxOrder = ";
     cerr <<  ZlibMaxOrder << " < 0\n";
     cerr << "You must construct the Zlib nerve system by using\n"; 
     cerr << "the contructor Tps(int o, int v, int cnd) first to\n";
     cerr << "give the value of maxOrder and Num of Variables\n";
     exit(1);
  }
}

void Zlib::zpprepTps() {
  if (zpprepTpsCount) 
    {
      cout << "zpprepTpsCount = " << zpprepTpsCount << " ***\n";
      deAlloc();
    }
  ZlibMaxOrderPrev = ZlibMaxOrder;
  ZlibNumVarPrev = ZlibNumVar;
  zpprepTpsCount += 1;
  cout << "Initialize Zlib nerve for the number " << zpprepTpsCount << " times"
       << endl;
  cout << "VARIABLES = " << ZlibNumVar << ",  MAX_ORDER = " << ZlibMaxOrder
       << ",  CanDim = " << ZlibCanDim << endl;
  getnmo();
  getnmov();
  getjsNerveUse();
  getjv();
  getjt();
  getjtf();
  getjtr();
  getnkpm();
  mulprp();
  drvprp();
  getnmvo();
  prptrk();
  zpcoef();
  //  getjs(); // to be deleted
}

int Zlib::jpek(int nVar, int *js)
{
  register int o = js[0];
  register int iv;
  int jpk = nmob[nVar][o];
  register int nVarM1 = nVar-1;
  for (iv=1; iv < nVarM1; ++iv) {
    jpk += nmov[nVar][js[iv]][o][iv];
    o -=js[iv];
  }
  jpk += nmov[nVar][js[nVarM1]][o][nVarM1];
  return jpk;
} 


int Zlib::numMo(int nVar, int order)
{
  return nmo[nVar][order];
}

void Zlib::getnmo() 
{
  int nVar;
  nmob = new int*[ZlibNumVar+1];
  nmoe = new int*[ZlibNumVar+1];
  nmo  = new int*[ZlibNumVar+1];
  for (nVar=1; nVar<=ZlibNumVar; ++nVar)
    {
      nmob[nVar] = new int[ZlibMaxOrder+2];
      nmoe[nVar] = new int[ZlibMaxOrder+2];
      nmo [nVar] = new int[ZlibMaxOrder+2];
    }
  if(!nmo) 
    {
      cerr << "Zlib::getnmo : allocation failure in nmo\n"; 
      exit(1);
    }
  for (nVar=1; nVar<=ZlibNumVar; ++nVar)
    {
      nmob[nVar][0] = 0;
      nmoe[nVar][0] = 0;
      nmo [nVar][0] = 1;
      for(int i=1; i <= ZlibMaxOrder+1; ++i) 
	{
	  nmo [nVar][i] = (nmo[nVar][i-1]*(nVar+i))/i;
	  nmob[nVar][i] = nmo[nVar][i-1];
	  nmoe[nVar][i] = nmo[nVar][i]-1;
	}
    }
}


void Zlib::getnmov() 
{
  nmov = new int***[ZlibNumVar+1];
  int o2 = ZlibMaxOrder + 2;
  for (int nVar=1; nVar<=ZlibNumVar; ++nVar)
    {
      nmov[nVar] = new int **[o2];
      int i, j;
      for (i=0; i<o2; ++i) 
	{
	  nmov[nVar][i] = new int *[o2];
	}
      for (i=0; i < o2; ++i) 
	{
	  for (j=0; j < o2; ++j) 
	    {
	      nmov[nVar][i][j] = new int [nVar];
	    }
	}
      for (i=0; i < o2; ++i) 
	{
	  for (j=0; j < o2; ++j) 
	    {
	      for (int k=0; k < nVar; ++k) 
		{
		  nmov[nVar][i][j][k] = 0;
		}
	    }
	}
      for (j=0; j < o2; ++j) 
	{
	  for (i=0; i <= j; ++i) 
	    {
	      nmov[nVar][i][j] [nVar-1] = j - i;
	    }
	}
      for (int k=nVar-2; k > 0; --k) 
	{
	  for (j=0; j < o2; ++j) 
	    {
	      nmov[nVar][j][j][k] = 0;
	      for (i=j-1; i > -1; --i) 
		{
		  nmov[nVar][i][j][k] = nmov[nVar][i+1][j][k] 
                                    + nmov[nVar][0][j-i][k+1];
		}
	    }
	}
      for (j=0; j < o2; ++j) 
	{
	  for (i=0; i <= j; ++i) 
	    {
	      nmov[nVar][i][j][0] = 0;
	    }
	}
    }
}


void Zlib::getjv() 
{
  int j, iv;
  jv = new int**[ZlibNumVar+1];
  for (int nVar=1; nVar <=ZlibNumVar; ++nVar)
    {
      //      int size = nmo[nVar][ZlibMaxOrder];
      int size = nmo[nVar][ZlibMaxOrder+1];
      jv[nVar] = new int*[size];
      for (j=0; j<size; ++j)
	{
	  jv[nVar][j] = new int[nVar+1];
	}
      if(!jv[nVar][size-1]) 
	{
	  cerr << "Zlib::getjv : allocation failure in jv \n"; 
	  exit(1);
	}
      for(iv=0; iv <= nVar; ++iv) 
	{
	  jv[nVar][0][iv] = 0;
	}
      for(j=1; j < size; ++j) 
	{
	  int io;
	  //	  for (io=0; io <= ZlibMaxOrder; ++io) 
	  for (io=0; io <= ZlibMaxOrder+1; ++io) 
	    {
	      if(j < nmo[nVar][io]) break;
	    }      
	  jv[nVar][j][0] = io;
	  int j1 = j-nmo[nVar][io-1]+1;
	  int noa = io;
	  for(iv=1; iv < nVar; ++iv) 
	    {
	      int iox;
	      for(iox=noa; iox >= 0; --iox) 
		{
		  if(j1 <= nmov[nVar][iox][noa][iv]) break;
		}
	      jv[nVar][j][iv] = iox + 1;
	      j1 -= nmov[nVar][iox+1][noa][iv];
	      noa -= (iox+1);
	    }
	  jv[nVar][j][nVar] = noa;
	}
    }
}

void Zlib::getjt() 
{
  int j, iv;
  jt = new int**[ZlibNumVar+1];
  for (int nVar=1; nVar <=ZlibNumVar; ++nVar)
    {
      jt[nVar] = new int*[ZlibNumVar+1];
      int size = nmo[nVar][ZlibMaxOrder];
      for (int nVarB=1; nVarB<=ZlibNumVar; ++nVarB)
	{
	  jt[nVar][nVarB] = new int[size];
	  if(!jt[nVar][nVarB]) 
	    {
	      cerr << "Zlib::getjt : allocation failure in jt \n"; 
	      exit(1);
	    }
	  if (nVar == nVarB)
	    {
	      for (j=0; j<size; ++j)
		{
		  jt[nVar][nVarB][j] = j;
		}
	    }
	  else if (nVar < nVarB)
	    {
	      int *js;
	      js = new int[nVarB+1];
	      for (iv=nVar+1; iv<=nVarB; ++iv)
		{
		  js[iv] = 0;
		}
	      for (j=0; j<size; ++j)
		{
		  for (iv=0; iv<=nVar; ++iv)
		    {
		      js[iv] = jv[nVar][j][iv];
		    }
		  jt[nVar][nVarB][j] = jpek(nVarB, js);
		}
	    }
	  /*
	  else // (nVar > nVarB)
	    {
	      int thereIs;
	      for (j=0; j<size; ++j)
		{
		  thereIs = 1;
		  for (iv=nVarB+1; iv<=nVar; ++iv)
		    {
		      if (jv[nVar][j][iv] != 0) thereIs = 0;
		    }
		  if (thereIs)
		    {
		      jt[nVar][nVarB][j] = jpek(nVarB, jv[nVar][j]);
		    }
		  else 
		    {
		      jt[nVar][nVarB][j] = 0; // be careful --> j=0
		      //added on 11/3/2004 for partial tracking
		      // remember to check tps addition and transformVariable
		      int *js;
		      js = new int[nVarB+1];
		      for (iv=1; iv<=nVarB; ++iv) js[iv] = jv[nVar][j][iv];
		      js[0]=js[1]; for (iv=2; iv<=nVarB; ++iv) js[0] +=js[iv];
		      jt[nVar][nVarB][j] = jpek(nVarB, js);
		      //end added on 11/3/2004 for partial tracking
		    }
		}  
	    }  // end of else
	    */
	}
    }
}

void Zlib::getjsNerveUse() {
  jsNerveUse = new int[ZlibNumVar+1];
  for(int k=0; k <= ZlibNumVar; k++) 
     jsNerveUse[k] = 0;
  if(!jsNerveUse) {
     cerr << "Zlib::zpprepTps : allocation failure in jsNerveUse\n"; 
     exit(1);
  }  
}

void Zlib::getnkpm() 
{ 
  int *jvs;
  nkpm = new int*[ZlibNumVar+1];
  for (int nVar=1; nVar <=ZlibNumVar; ++nVar)
    {
      nkpm[nVar] = new int[nVar+1];
      int size = nmo[nVar][ZlibMaxOrder];
      for (int nVarB=1; nVarB <=nVar; ++nVarB)
	{
	  nkpm[nVar][nVarB] = 0;
	  for(int j=0; j < size; ++j) 
	    {
	      jvs = jv[nVar][j];
	      int nkpj = jvs[1]+1;
	      for(int iv=2; iv <= nVarB; ++iv) nkpj *= (jvs[iv]+1);
	      nkpm[nVar][nVarB] += nkpj;
	    }
	}
    }
}


void Zlib::mulprp() 
{
  int nVar, nVarB, j, io, kpm, iv;
  ikb = new int***[ZlibNumVar+1];
  ikp = new int***[ZlibNumVar+1];
  for (nVar=1; nVar <=ZlibNumVar; ++nVar)
    {
      int size = nmo[nVar][ZlibMaxOrder];
      ikb[nVar] = new int**[nVar+1];
      ikp[nVar] = new int**[nVar+1];
      for (nVarB=1; nVarB <=nVar; ++nVarB)
	{
	  ikb[nVar][nVarB] = new int*[ZlibMaxOrder+1];
	  ikp[nVar][nVarB] = new int*[ZlibMaxOrder+1];
	  for(io=0; io<= ZlibMaxOrder; ++io) 
	    {
	      ikb[nVar][nVarB][io] = new int[size];
	      ikp[nVar][nVarB][io] = new int[size];
	      if(!ikp[nVar][nVarB][io]) 
		{
		  cerr << "Zlib::mulprp : allocation failure in ikb,ikp \n"; 
		  exit(1);
		}
	      for (j=0; j<size; ++j)
		{
		  ikb[nVar][nVarB][io][j] = 0;
		  ikp[nVar][nVarB][io][j] = 0;
		}
	    }
	}
    }
  kp  = new int** [ZlibNumVar+1];
  lp  = new int** [ZlibNumVar+1];
  for (nVar=1; nVar <=ZlibNumVar; ++nVar)
    {
      kp[nVar]  = new int* [nVar+1];
      lp[nVar]  = new int* [nVar+1];
      for (nVarB=1; nVarB <=nVar; ++nVarB)
	{
	  kp[nVar][nVarB]  = new int [ nkpm[nVar][nVarB] ];
	  if (!kp[nVar][nVarB]) {
	    cerr << nVar << ' ' << nVarB << endl;
	    cerr << "kp[nVar][nVarB] = new  " << endl; 
	    exit(1);
	  }
	  lp[nVar][nVarB]  = new int [ nkpm[nVar][nVarB] ];
	  if (!lp[nVar][nVarB]) {
	    cerr << nVar << ' ' << nVarB << endl;
	    cerr << "lp[nVar][nVarB] = new  " << endl; 
	    exit(1);
	  }
	  for(kpm=0; kpm < nkpm[nVar][nVarB]; ++kpm)
	    {
	      kp[nVar][nVarB][kpm] = 0;
	      lp[nVar][nVarB][kpm] = 0;
	    }
	}
    }
  if(!lp[ZlibNumVar][ZlibNumVar]) {
    cerr << "Zlib::mulprp-2 : allocation failure in kp,lp \n"; 
    exit(1);
  }
  for (nVar=1; nVar<=ZlibNumVar; ++nVar) {
    for (nVarB=1; nVarB<=nVar; ++nVarB) {
      kpm=0;
    }
  }
  int *js;
  js = new int[ZlibNumVar+1];
  int *jts;
  for (nVar=1; nVar<=ZlibNumVar; ++nVar)
    {
      for (nVarB=1; nVarB<=nVar; ++nVarB)
	{
	  jts = jt[nVar][nVarB];
	  //for io=0, j=0
	  io = 0;
	  j = 0;
	  kpm = 0;
	  ikb[nVar][nVarB][io][j] = kpm;
	  ikp[nVar][nVarB][io][j] = kpm;
	  kp[nVar][nVarB][kpm]    = 0; // the one in trouble on NOV04 Yan
	  lp[nVar][nVarB][kpm]    = 0;
	  for (io=1; io <= ZlibMaxOrder; ++io)
	    {
	      for (j=nmob[nVar][io]; j < nmo[nVar][io]; ++j) 
		{
		  int iou = 0;
		  if (jts[j])
		    {
		      ++kpm;
		      ikb[nVar][nVarB][0][j] = kpm;
		      ikp[nVar][nVarB][0][j] = kpm;
		      kp[nVar][nVarB][kpm]    = 0;
		      lp[nVar][nVarB][kpm]    = jts[j];
		    }
		  else 
		    {
		      ikp[nVar][nVarB][0][j] = kpm;
		      ikb[nVar][nVarB][0][j] = kpm+1;
		    }		      
		  int itis; // TRUE or False
		  for (iou=1; iou < io; iou++) 
		    {
		      js[0] = io - iou;
		      for (int ju=nmob[nVar][iou]; ju < nmo[nVar][iou]; ++ju)
			{
			  itis = 1; // TRUE
			  for (iv=nVarB+1; iv<=nVar; ++iv)
			    if (jv[nVar][ju][iv] != jv[nVar][j][iv]) itis = 0;
			  for (iv=1; iv <= nVarB; ++iv) // special
			    if (jv[nVar][ju][iv] > jv[nVar][j][iv]) itis = 0;
			  if(itis) 
			    {
			      ++kpm;
			      kp[nVar][nVarB][kpm] = ju;
			      for(iv=1; iv <= nVarB; ++iv)
				js[iv] = jv[nVar][j][iv]-jv[nVar][ju][iv];
			      lp[nVar][nVarB][kpm] = jpek(nVarB, js);
			    }
			}
		      ikp[nVar][nVarB][iou][j] = kpm;
		      ikb[nVar][nVarB][iou][j] = ikp[nVar][nVarB][iou-1][j]+1;
		    }
		  //  iou=io
		  ++kpm;
		  ikp[nVar][nVarB][io][j] = kpm;
		  ikb[nVar][nVarB][io][j] = ikp[nVar][nVarB][io-1][j]+1;
		  kp[nVar][nVarB][kpm]    = j;
		  lp[nVar][nVarB][kpm]    = 0;
		}
	    }
	}
    }
}


void Zlib::drvprp() {
  int *js;
  js = new int[ZlibNumVar+1];
  jd = new int**[ZlibNumVar+1];
  int j, iv; // index
  for (int nVar=1; nVar<=ZlibNumVar; ++nVar)
    {
      int size = nmo[nVar][ZlibMaxOrder];
      //      jd[nVar] = new int*[nVar+1];
      jd[nVar] = new int*[nVar];
      //      for(iv=0; iv <= nVar; ++iv) 
      for(iv=0; iv < nVar; ++iv) 
	{
	  jd[nVar][iv] = new int[size];
	  for(j=0; j < size; ++j)
	    {
	      jd[nVar][iv][j] = 0;
	    }
	}
      if(!jd[nVar][nVar-1]) 
	{
	  cerr << "Zlib::drvprp : allocation failure in jd \n"; 
	  exit(1);
	}
      for (j=0; j < size; ++j)
	{
	  js[0] = jv[nVar][j][0] + 1;
	  for(iv=1; iv <= nVar; ++iv) 
	    {
	      js[iv] = jv[nVar][j][iv];
	    }
	  js[1] += 1;
	  //	  jd[nVar][1][j] = jpek(nVar, js);
	  jd[nVar][0][j] = jpek(nVar, js);
	  for(iv=2; iv <= nVar; ++iv) 
	    {
	      js[iv-1] -= 1;
	      js[iv]   += 1;
	      //	      jd[nVar][iv][j] = jpek(nVar, js);
	      jd[nVar][iv-1][j] = jpek(nVar, js);
	    }
	}
    }
}


void Zlib::deAlloc() {

     int io, jo, nVar, nVarB;
     for (nVar=1; nVar<=ZlibNumVarPrev; ++nVar)
       {
	 for(io=0; io < ZlibMaxOrderPrev+2; ++io) 
	   {
	     for(jo=0; jo < ZlibMaxOrderPrev+2; jo++) 
	       {
		 delete [] nmov[nVar][io][jo];
	       }
	     delete [] nmov[nVar][io];
	   }
	 delete [] nmov[nVar];
       }
     delete [] nmov;

     for (nVar=1; nVar<=ZlibNumVarPrev; ++nVar)
       {
	 int size = nmo[nVar][ZlibMaxOrderPrev+1];
	 for(int j=0; j < size; ++j)
	   {
	     delete [] jv[nVar][j];
	   }
	 delete [] jv[nVar];
       }
     delete [] jv; 

     for (nVar=1; nVar<=ZlibNumVarPrev; ++nVar)
       {
	 for (nVarB=1; nVarB<=ZlibNumVarPrev; ++nVarB)
	   {
	     delete [] jt[nVar][nVarB];
	   }
	 delete [] jt[nVar];
       }
     delete [] jt;

     for (nVar=1; nVar <=ZlibNumVarPrev; ++nVar)
       {
	 delete [] nkpm[nVar];
       }
     delete [] nkpm;

     for (nVar=1; nVar<=ZlibNumVarPrev; ++nVar)
       {
	 for (nVarB=1; nVarB<=nVar; ++nVarB)
	   {
	     for(io=0; io <= ZlibMaxOrderPrev; ++io) 
	       {
		 delete [] ikb[nVar][nVarB][io];
		 delete [] ikp[nVar][nVarB][io];
	       }
	     delete [] ikb[nVar][nVarB];
	     delete [] ikp[nVar][nVarB];
	   }
	 delete [] ikb[nVar];
	 delete [] ikp[nVar];
       }
     delete [] ikp; 
     delete [] ikb;

     for (nVar=1; nVar<=ZlibNumVarPrev; ++nVar)
       {
	 for (nVarB=1; nVarB<=nVar; ++nVarB)
	   {
	     delete [] kp[nVar][nVarB]; 
	     delete [] lp[nVar][nVarB]; 
	   }
	 delete [] kp[nVar]; 
	 delete [] lp[nVar]; 
       }
     delete [] kp; 
     delete [] lp; 

     for (nVar=1; nVar<=ZlibNumVarPrev; ++nVar)
       {
	 for(int iv=0; iv <= nVar; ++iv)
	   {
	     delete [] jd[nVar][iv];
	   }
	 delete [] jd[nVar];
       }
     delete [] jd;

  for (nVar=1; nVar <=ZlibNumVarPrev; ++nVar)
    {
      for (int iv=0; iv < nVar; ++iv) delete [] nmvo[nVar][iv];
      delete [] nmvo[nVar];
    }
  delete [] nmvo;
  for (nVar=1; nVar <=ZlibNumVarPrev; ++nVar)
    {
      delete [] ivp[nVar];;
      delete [] jpp[nVar];;
    }
  delete [] ivp;
  delete [] jpp;

     //     delete [] js;
     for (nVar=1; nVar<=ZlibNumVarPrev; ++nVar)
       {
	 delete [] nmob[nVar]; 
	 delete [] nmoe[nVar]; 
	 delete [] nmo[nVar];
       }
     delete [] nmob; 
     delete [] nmoe; 
     delete [] nmo;

     delete [] jsNerveUse;
     delete [] xxx;
     // delete coefs that were initiated in zpcoef
     delete [] csqrt;
     delete [] cinv;
     delete [] cln;
     delete [] cexp;
     delete [] csc;
}


//---------------------------------------------------------
// Zlib: subroutine zpcoef(no)
void Zlib::zpcoef()
{
  //---- coefficients of sqrt(1+x) for Taylor expansion
  int n;
  csqrt = new double[ZlibMaxOrder+1];
  csqrt[1] = 0.5;
  for (n=2; n <= ZlibMaxOrder; ++n)
    {
      csqrt[n] = -csqrt[n-1]*(1.0-1.5/n);
    }   
  //---- coefficients of 1/(1+x) for Taylor expansion
  cinv = new double[ZlibMaxOrder+1];
  cinv[1] = -1.0;
  for (n=2; n <= ZlibMaxOrder; ++n)
    {
      cinv[n] = - cinv[n-1];
    }   
  //---- coefficients of ln(1+x)
  cln = new double[ZlibMaxOrder+1];
  for (n=1; n <= ZlibMaxOrder; n += 2)
    {
      cln[n] = 1.0/n;
    }   
  for (n=2; n <= ZlibMaxOrder; n += 2) 
    {
      cln[n] = - 1.0/n;
    }   
  //---- coefficients of exp(x)
  cexp = new double[ZlibMaxOrder+1];
  int nf=1;
  for (n=1; n <= ZlibMaxOrder; ++n) 
    {
      nf *= n;
      cexp[n] = 1.0/nf;
    }
  //---- coefficients of sin(x) and cos(x) for Taylor expansion
  csc = new double[ZlibMaxOrder+1];
  csc[1]=1.0;
  double fk=1.0;
  double csign=-1.0;
  for (n=3; n <= ZlibMaxOrder; n+=2) 
    {
      fk *= (n-1);
      csc[n-1]=csign/fk;
      fk *= n;
      csc[n] = csign/fk;
      csign=-csign;
    }
  if ((n-ZlibMaxOrder) == 1) 
    {
      fk *= ZlibMaxOrder;
      csc[ZlibMaxOrder] = csign/fk;
    }
}



// Vps part 

void Zlib::zpprepVps() {
     if (Vps_STATIC) deAllocVps();
     Vps_STATIC += 1;     
     //     getnmvo();
     //     prptrk();
     getmp();
     getjpcMemTest();
}

void Zlib::deAllocVps() 
{
  /**********************************************************
  for (int nVar=1; nVar <=ZlibNumVarPrev; ++nVar)
    {
      for (int iv=0; iv < nVar; ++iv) delete [] nmvo[nVar][iv];
      delete [] nmvo[nVar];
    }
  delete [] nmvo;
  for (int nVar=1; nVar <=ZlibNumVarPrev; ++nVar)
    {
      delete [] ivp[nVar];;
      delete [] jpp[nVar];;
    }
  delete [] ivp;
  delete [] jpp;
  **********************************************************/
  for (int nVar=1; nVar <=ZlibNumVarPrev; ++nVar)
    {
      for (int i=0; i <= ZlibMaxOrderPrev; ++i) 
	{
	  for (int j=0; j <= ZlibMaxOrderPrev; ++i) delete [] mp[nVar][i][j];
	  delete [] mp[nVar][i];
	}
      delete [] mp[nVar];
    }
  delete [] mp;
  int nVarMemTest = ZlibNumVarPrev;
  if ( nVarMemTest < 10 ) nVarMemTest = 10;
  if ( ZlibMaxOrderPrev < 6 ) nVarMemTest = 6;
  nVarMemTest *= 3;
  for (int i=1; i<nVarMemTest; ++i) delete [] jpcMemTest[i];
  delete [] jpcMemTest;

  if (nocnct >= 0) 
    {
      for (int nVar=1; nVar <=ZlibNumVarPrev; ++nVar)
	{
	  for (int i=0; i <= ZlibMaxOrderPrev; ++i) 
	    {
	      delete [] jpc[nVar][i];
	      delete [] ivpc[nVar][i];
	      delete [] ivppc[nVar][i];
	    }
	  delete [] jpc[nVar];
	  delete [] ivpc[nVar];
	  delete [] ivppc[nVar];
	}
      delete [] jpc;
      delete [] ivpc;
      delete [] ivppc;
    }
}

/* 
*************************************************     
c---- prepare nmvo(nv,no)
      do 5 iv=1,nv
 5    nmvo(iv,1)=1
      do 10 io=2,no
         iom1=io-1
      do 10 iv=1,nv
         nmvo(iv,io)=nmvo(iv,iom1)
         do 20 i=iv+1,nv
 20      nmvo(iv,io)=nmvo(iv,io)+nmvo(i,iom1)
 10   continue
**************************************************
*/

void Zlib::getnmvo() 
{
  nmvo = new int **[ZlibNumVar+1];
  for (int nVar=1; nVar <=ZlibNumVar; ++nVar)
    {
      nmvo[nVar] = new int *[nVar];
      int iv; // index
      for (iv=0; iv < nVar; ++iv) nmvo[nVar][iv] = new int[ZlibMaxOrder+1];
      for (iv=0; iv < nVar; ++iv) nmvo[nVar][iv][1] = 1;
      
      for (int io=2; io<=ZlibMaxOrder; ++io) 
	{
	  int iom1 = io - 1;
	  for (iv=0; iv < nVar; ++iv) 
	    {
	      nmvo[nVar][iv][io] = nmvo[nVar][iv][iom1];
	      for (int i=iv+1; i < nVar; ++i) 
		{
		  nmvo[nVar][iv][io] += nmvo[nVar][i][iom1];
		}
	    }
	}
    }
}
             
void Zlib::prptrk() 
{
  //  xxx = new double[ZlibMaxSize]; // only for memory  
  xxx = new double[ nmo[ZlibNumVar][ZlibMaxOrder] ]; // only for memory  
  int maxVarP1 = ZlibNumVar+1;
  ivp = new int*[maxVarP1];
  jpp = new int*[maxVarP1];
  for (int nVar=1; nVar<maxVarP1; ++nVar)
    {
      ivp[nVar] = new int[ nmo[nVar][ZlibMaxOrder] ];
      jpp[nVar] = new int[ nmo[nVar][ZlibMaxOrder] ];
      if (!jpp[nVar]) { cerr << "prptrk mem alloc  " << endl; exit(1);}
      ivp[nVar][0] = jpp[nVar][0] = 0; 
      int iv, j;
      for (iv=0; iv < nVar; ++iv)   // io = 1; io=0 not necessary
	{
	  j = iv + 1;
	  ivp[nVar][j] = iv;
	  jpp[nVar][j] = 0;
	}
      for (int io=2; io <=ZlibMaxOrder; ++io) 
	{
	  int iom1=io-1;
	  int iom2=io-2;
	  for (iv=0; iv < nVar; ++iv) 
	    {
	      int nmvovo = nmvo[nVar][iv][io];
	      int ivm1 = iv - 1;
	      for (int jvo=1; jvo<=nmvovo; ++jvo) 
		{
		  j += 1;
		  ivp[nVar][j]=iv;
		  jpp[nVar][j]=nmo[nVar][iom2]-1+jvo;
		  for (int i=0; i < iv; ++i) 
		    {
		      jpp[nVar][j] += nmvo[nVar][i][iom1];
		    }
		}
	    }
	}
    }
}
	
/*
**********************************************
c---- prepare tracking pointers
c---- io=0 is not necessary
c---- io=1
      do 30 jj=1,nv
         j=jj+1
         ivp(j)=jj
         jpp(j)=1
 30   continue
c---- io=2,no
      do 40 io=2,no
         iom1=io-1
         iom2=io-2
      do 40 iv=1,nv
         nmvovo=nmvo(iv,io)
         ivm1=iv-1
         do 50 jvo=1,nmvovo
            j=j+1
            ivp(j)=iv
            jpp(j)=nmo(iom2)+jvo
            do 60 i=1,ivm1
 60         jpp(j)=jpp(j)+nmvo(i,iom1)
 50      continue
 40   continue
c----


*---- tracking start
*---- initialization for io=0
      xx(1)=1.d0
      do 5 i=nub,nu
 5    yy(i)=uu(1,i)
*---- io=1,no
      nmu=nmo(nou)
      do 10 j=2,nmu
         iv=ivp(j)
         jp=jpp(j)
         xx(j)=x(iv)*xx(jp)
 10   continue
      do 20 i=nub,nu
      do 20 j=2,nmu
 20   yy(i)=yy(i)+uu(j,i)*xx(j)
*----
      do 30 i=nub,nu
 30   y(i)=yy(i)
**************************************************
*/

//--------------------------------------------------------------
// mp [ZlibMaxOrder+1][ZlibMaxOrder+1][ZlibNumVar+1]
// Zlib: subroutine zpmp(nv,no,mp)
//--------------------------------------------------------------

void Zlib::getmp() 
{
  int i,j,nVar; // index
  mp = new int***[ZlibNumVar+1];
  for (nVar=1; nVar <=ZlibNumVar; ++nVar)
    {
      mp[nVar] = new int**[ZlibMaxOrder+1];
      for(i=0; i <= ZlibMaxOrder;i++) // warning
	{
	  mp[nVar][i] = new int*[ZlibMaxOrder+1];
	  for(j=0; j <= ZlibMaxOrder; j++)
	    { 
	      mp[nVar][i][j] = new int[nVar+1];
	    }
	}
    }
  if( !mp[ZlibNumVar][ZlibMaxOrder][ZlibMaxOrder]) 
    {
      cerr << "Vps::zpprepVps() : allocation failure for mp \n";
      exit(1);
    }
  int ***mpT;
  for (nVar=1; nVar <=ZlibNumVar; ++nVar)
    {
      mpT = mp[nVar];
      for(i=0; i <= ZlibMaxOrder;i++) // warning
	{
	  for(j=0; j <= ZlibMaxOrder; j++)
	    { 
	      for(int k=0; k <= nVar; k++) mpT[i][j][k] = 0;
	    }
	}
      for(i=0; i <= ZlibMaxOrder; i++)  // warning
	for(j=0; j <= ZlibMaxOrder; j++) mpT[i][j][1]=i;
      for(i=1; i <= ZlibMaxOrder; i++)
	for(j=1; j <= ZlibMaxOrder; j++)
	  mpT[i][j][2] = mpT[i-1][j][2]+j-i+2;
      for(int k=3; k <= nVar; k++)
	for(j=1; j <= ZlibMaxOrder; j++)
	  {
	    for(i=1; i <= j; i++)
	      mpT[i][j][k] = mpT[j-i+1][j-i+1][k-1] + 1;
	    for(i=1; i<=j; i++)
	      mpT[i][j][k]+=mpT[i-1][j][k];
	  }
    }
}

void Zlib::getjpcMemTest() 
{
  int nVarMemTest = ZlibNumVar;
  int max_ord = ZlibMaxOrder;
  if ( nVarMemTest < 10 ) nVarMemTest = 10;
  if ( max_ord < 6 ) nVarMemTest = 6;
  nVarMemTest *= 3;
  max_ord *= 3;
  jpcMemTest = new int*[nVarMemTest];
  int i,j;
  for (i=1; i<nVarMemTest; ++i)
    {
      jpcMemTest[i] = new int[max_ord];
    }
  for (i=1; i<nVarMemTest; ++i)
    {
      for (j=1; j<max_ord; ++j)
	{
	  jpcMemTest[i][j] = 0;
	}
    }
}

//void Zlib::ztpapek(int jtpa, int no) const

void Zlib::ztpapek(int nVar, int jtpa, int no, int *js)
{
   int ***mpT;
   mpT = mp[nVar];
   int i;
   int mona = jtpa;
   int noa = no;
   for(int iv = nVar; iv >= 2; iv--)
     for(i=noa; i >= 0; i--)
     {
         if(mona > mpT[i][noa][iv])
         {
            js[iv] = i;
            mona -= mpT[i][noa][iv];
            noa -= i;
            break;
         }
     }
   for(i=noa; i >= 0; i--)
      if(mona > mpT[i][noa][1])
      {
        js[1] = i;
        break;
      }
   return;
}

//void Zlib::pntcct(int no) const
void Zlib::pntcct(int nVar, int no)
{
  if (jpcMemTest[nVar][no]) 
    {
      // comment out for IDHamiltonian
      // cout << "cnct Mem already done for (" << nVar << ", " << no << ")\n";
      return;
    }
  jpcMemTest[nVar][no] = 1;
  int i, j, io;
  static int in_time = 0;
  if ( !in_time )
    {
      in_time = 1;
      jpc = new int**[ZlibNumVar+1];
      ivpc = new int**[ZlibNumVar+1];
      ivppc = new int**[ZlibNumVar+1];
      for (i=1; i<=ZlibNumVar; ++i)
	{
	  jpc[i] = new int*[ZlibMaxOrder+1];
	  ivpc[i] = new int*[ZlibMaxOrder+1];
	  ivppc[i] = new int*[ZlibMaxOrder+1];
	  for (io=0; io<=ZlibMaxOrder; ++io)
	    {
	      int size = nmo[i][io];
	      jpc[i][io] = new int[size];
	      ivpc[i][io] = new int[size];
	      ivppc[i][io] = new int[size];
	    }
	}
    }
  int *jjpc, *ivvpc, *ivvppc;
  jjpc = jpc[nVar][no];
  ivvpc = ivpc[nVar][no];
  ivvppc = ivppc[nVar][no];

  int jj = -1;
  for(int jjj = 2; jjj <= nmo[nVar][no]; jjj++)
    {
      ztpapek(nVar,jjj, no, jsNerveUse);
      io=jsNerveUse[1];
      for(i=2; i <= nVar; i++) io += jsNerveUse[i];
      jsNerveUse[0] = io;  // need***
      if(io > 1)
	{     
	  jj += 1;
	  j = jpek(nVar, jsNerveUse); 
	  jjpc[jj] = j;
	  for(int iv=1; iv <= nVar; iv++)
	    {
	      if(jsNerveUse[iv] > 1)
		{
		  ivvpc [jj] = iv-1;  // need *** -1
		  ivvppc[jj] = iv-1;  // need *** -1
		  break;
		}
	      if(jsNerveUse[iv] == 1)
		{
		  ivvpc[jj] = iv-1;  // need *** -1
		  for(int ii=iv+1; ii <= nVar; ii++)
		    {
		      if(jsNerveUse[ii] > 0)
			{
			  ivvppc[jj] = ii-1;   // need *** -1
			  break;
			}
		      if(ii > nVar)
			{
			  cerr << "Error: Vps:initialStaticMember :";
			  cerr << " wrong in pntcct\n";
			  exit(1);
			}
		    }
		  break;
		}
	    }
	}
    }
  return;
}

//added on 11/3/2004 for partial tracking
// remember to check tps addition and transformVariable

void Zlib::getjtr() 
{
  int j, iv;
  jtr = new int**[ZlibNumVar+1];
  for (int nVar=1; nVar <=ZlibNumVar; ++nVar)
    {
      jtr[nVar] = new int*[ZlibNumVar+1];
      int size = nmo[nVar][ZlibMaxOrder];
      for (int nVarB=1; nVarB<=ZlibNumVar; ++nVarB)
	{
	  jtr[nVar][nVarB] = new int[size];
	  if(!jtr[nVar][nVarB]) 
	    {
	      cerr << "Zlib::getjtr : allocation failure in jtr \n"; 
	      exit(1);
	    }
	  if (nVar == nVarB)
	    {
	      for (j=0; j<size; ++j)
		{
		  jtr[nVar][nVarB][j] = 0;
		}
	    }
	  else if (nVar > nVarB)
	    {
	      int *js;
	      js = new int[nVarB+1];
	      int nVarKeep=nVar-nVarB;
	      for (j=0; j<size; ++j)
		{
		  for (iv=1; iv<=nVarB; ++iv) js[iv]=jv[nVar][j][iv+nVarKeep];
		  js[0]=js[1]; for (iv=2; iv<=nVarB; ++iv) js[0] +=js[iv];
		  jtr[nVar][nVarB][j] = jpek(nVarB, js);
		}
	    }
	  else // nVar < nVarB, nVar is the last half.
	    {
	      int *js;
	      js = new int[nVarB+1];
	      int nVarKeep=nVarB-nVar;
	      for (iv=1; iv<=nVarKeep; ++iv)
		{
		  js[iv] = 0;
		}
	      for (j=0; j<size; ++j)
		{
		  js[0] = jv[nVar][j][0];
		  for (iv=1; iv<=nVar; ++iv)
		    {
		      js[iv+nVarKeep] = jv[nVar][j][iv];
		    }
		  jtr[nVar][nVarB][j] = jpek(nVarB, js);
		}
	    }
	}
    }
}

void Zlib::getjtf() 
{
  int j, iv;
  jtf = new int**[ZlibNumVar+1];
  for (int nVar=1; nVar <=ZlibNumVar; ++nVar)
    {
      jtf[nVar] = new int*[ZlibNumVar+1];
      int size = nmo[nVar][ZlibMaxOrder];
      for (int nVarB=1; nVarB<=ZlibNumVar; ++nVarB)
	{
	  jtf[nVar][nVarB] = new int[size];
	  if(!jtf[nVar][nVarB]) 
	    {
	      cerr << "Zlib::getjtf : allocation failure in jtf \n"; 
	      exit(1);
	    }
	  if (nVar == nVarB)
	    {
	      for (j=0; j<size; ++j)
		{
		  jtf[nVar][nVarB][j] = j;
		}
	    }
	  else if (nVar > nVarB)
	    {
	      int *js;
	      js = new int[nVarB+1];
	      for (j=0; j<size; ++j)
		{
		  for (iv=1; iv<=nVarB; ++iv) js[iv]=jv[nVar][j][iv];
		  js[0]=js[1]; for (iv=2; iv<=nVarB; ++iv) js[0] +=js[iv];
		  jtf[nVar][nVarB][j] = jpek(nVarB, js);
		}
	    }
	  else // nVar < nVarB, nVar is the front half.
	    {
	      int *js;
	      js = new int[nVarB+1];
	      for (iv=nVar+1; iv<=nVarB; ++iv)
		{
		  js[iv] = 0;
		}
	      for (j=0; j<size; ++j)
		{
		  for (iv=0; iv<=nVar; ++iv)
		    {
		      js[iv] = jv[nVar][j][iv];
		    }
		  jtf[nVar][nVarB][j] = jpek(nVarB, js);
		}
	    }
	}
    }
}

