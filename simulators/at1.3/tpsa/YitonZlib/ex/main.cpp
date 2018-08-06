#include "Vec.hpp"
#include "TpsData.hpp"
#include "Tps.hpp"
#include "Vps.hpp"
#include "DepritLieLn.hpp"
#include "DepritTaylorLn.hpp"
#include "ResMap.hpp"
#include "mxVps.hpp"
#include "time.h"


void no_storage();

int main() 
{
  //  set_new_handler(&no_storage);
  int dim, no, nv2, nomax;
  Tps::setTpsOutputPrecision(4); 
  nomax = 6; nv2 = 6; dim = 6;
  int candim = 2;

  Tps::ZlibNerve(nv2,nomax, candim); 
  cout << "after   ZlibNerve *********\n ";  

    int nomap = nomax;
    // nomap = nomax-1; // comment out means order(gf)=order(mxVps);
    Vps map(6);
    ifstream fmap("map.dat");
    map.getVps(fmap, nv2, nomap);
    cout << "order of map: " << map.getMaxOrder() << endl;
    cout << "accuracy order of map: " << map.getAccOrder() << endl;
    fmap.close();
    // take 0th order out, it is the closed orbit, that is all.
    map = map.filter(map.getMaxOrder(),1);
    cout << "order of map: " << map.getMaxOrder() << endl;
    cout << "accuracy order of map: " << map.getAccOrder() << endl;
    Vps map45 = map.subVps(4, 5);
    Vec x0(5); for (int k=0; k<5; ++k) x0[k]=0.0; 
    Vec x; for (int k=0; k<6; ++k) x[k]=0.0; 
    double betax = 7.76;
    double betay = 5.05;
    double emittx = 2.7E-09;
    double emitty = emittx/2;
    double sigmax = sqrt(betax*emittx);
    double sigmay = sqrt(betay*emitty);
    double sigmap = 3.E-03;
    double sigmaz = 0.0105;
    double deltainitial=0.03;
    double deltadelta=0.01;
    for (int ik=0; ik<1; ++ik)
{
    x0(4)=deltainitial-deltadelta*ik;
    Vps map44 = map45(4,x0);
    ofstream m44out("m44.out");
    m44out << map44;
    mxVps mxv(map44);
    ofstream mout("mxVps.out");
    mout << mxv;
// Tracking for dynamic aperture starts from here for a defined energy
   int lossflag;
   int order = nomax;
   int nturn=1000;
   int nprt=20;
   double * lostTurn; lostTurn = new double[nprt];
   for (int i=0; i<nprt; ++i) lostTurn[i]=nturn;
   double * lostsigx; lostsigx = new double[nprt];
   for (int i=0; i<nprt; ++i) lostsigx[i]=100+5*i;
   Vec *xx; xx = new Vec[nturn+1];
   ofstream fout("ff.out");
   int i;
   cout << clock() << " =clock\n";
   for (int j=1; j < nprt; ++j) {
     cout << lostsigx[j] << " sigmax \n";
     x[0]=lostsigx[j]*sigmax;
     // 540 turn will get lost
     x[0]=5.0*j*sigmax;
     x[2]=5.0*j*sigmay;
     x[4]=0.0*sigmap;
     xx[0]=x;
     cout << x << " = x_ini\n";
     for (i=0; i<nturn; ++i) {
       //      xx[i+1] = mxv(xx[i],10);    
       xx[i+1] = mxv(xx[i],nomax,lossflag);    
       if (lossflag) {
  	 cout << "lost turn = " << i << endl;
	 lostTurn[j]=i;
	 break;
       }
       fout << xx[i+1][0]<< ' '<< xx[i+1][1]<< ' '<< xx[i+1][2]<< ' '
 	    << xx[i+1][3]<< ' '<< xx[i+1][4]<< ' '<< xx[i+1][5]<< endl;
       fout.flush();
     }
     //    fout <<-1<<' '<<-1<<' '<<-1<<' '<<-1<<' '<<-1<<' '<<-1<<' '<< endl;
     //    fout.flush();
  }
  fout.close(); 
  cout << " i = " << i << endl;
  cout << clock() << " =clock\n";
  ofstream lout("lost.out");
  lout << lostsigx << endl;
  lout << lostTurn << endl;
  lout.close();
  cout << " all done \n";
  mout.close();
}
  exit(1); 
 }

void no_storage() {
  cerr << "Operation new failed: no storage is availabe.\n";
  exit(1);
}
