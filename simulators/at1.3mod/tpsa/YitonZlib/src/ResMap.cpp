#include <assert.h>
#include "ResMap.hpp"

#define INICIAL_BUFFER_SIZE 100

static char *ReadLine(istream & fin);

int JxyTable::maxOrder;
int JxyTable::low;
int JxyTable::high;
int JxyTable::num;
int JxyTable::base;
double* JxyTable::twoJx;
double* JxyTable::twoJy;

static int JxyTableSwitch = 1;

JxyTable::JxyTable(int order) {
  maxOrder = order;
  if (order) {
    if (JxyTableSwitch) {
      JxyTableSwitch = 0;
      low = (maxOrder+1)/2;
      high= maxOrder+1;
      num = high+low;
      base = low*num+low;
      twoJx = new double[high];
      twoJy = new double[high];
    }
    v = new double[num*num];
  }
}

void JxyTable::memAllocate(int order) {
    if (JxyTableSwitch) {
      JxyTableSwitch = 0;
      maxOrder = order;
      low = (maxOrder+1)/2;
      high= maxOrder+1;
      num = high+low;
      base = low*num+low;
      twoJx = new double[high];
      twoJy = new double[high];
    }
    v = new double[num*num];
}

void JxyTable::Update( Vec & xys) {
  static int nx, ny;
  twoJx[0] = 1.0;
  twoJy[0] = 1.0;
  twoJx[1] = xys[0]*xys[0]+xys[1]*xys[1];
  twoJy[1] = xys[2]*xys[2]+xys[3]*xys[3];
  for (nx=2; nx<high; ++nx) {
    twoJx[nx] = twoJx[nx-1]*twoJx[1];
    twoJy[nx] = twoJy[nx-1]*twoJy[1];
  }
  if (twoJx[1]<1.e-40 || twoJy[1]<1.e-40) {
    for (nx=0; nx<num*num; ++nx) v[nx] = 0.0;
    if (twoJx[1] >= 1.e-40) {
      for (nx = 0; nx < high; nx++) v[nx*num+base] = twoJx[nx];
      for (nx = -low; nx < 0; nx++) v[nx*num+base] = 1.0/twoJx[-nx];
    }
    else if (twoJy[1] >= 1.e-40) {
      for (ny = 0; ny < high; ny++) v[base+ny] = twoJy[ny];
      for (ny = -low; ny < 0; ny++) v[base+ny] = 1.0/twoJy[-ny];
    }
  }
  else {
    static int itemp;
    for (nx = 0; nx < high; nx++) {
      itemp = nx*num+base;
      for (ny = 0; ny < high; ny++) v[itemp+ny] = twoJx[nx]*twoJy[ny];
      for (ny = -low; ny < 0; ny++) v[itemp+ny] = twoJx[nx]/twoJy[-ny];
    }
    for (nx = -low; nx < 0; nx++) {
      itemp = nx*num+base;
      for (ny = 0; ny < high; ny++) v[itemp+ny] = twoJy[ny]/twoJx[-nx];
      for (ny = -low; ny < 0; ny++) v[itemp+ny] = 1.0/(twoJx[-nx]*twoJy[-ny]);
    }
  }
}

int CosSinTable::maxOrder;
int CosSinTable::maxOrderP1;
double* CosSinTable::CosMxThetaX;
double* CosSinTable::SinMxThetaX;
double* CosSinTable::CosMyThetaY;
double* CosSinTable::SinMyThetaY;

static int CosSinTableSwitch = 1;

CosSinTable::CosSinTable(int order) {
  if (order) {
    if (CosSinTableSwitch) {
      CosSinTableSwitch = 0;
      maxOrder = order;
      maxOrderP1 = maxOrder+1;
      CosMxThetaX = new double[maxOrderP1];
      SinMxThetaX = new double[maxOrderP1];
      CosMyThetaY = new double[maxOrderP1];
      SinMyThetaY = new double[maxOrderP1];
    }
    v = new double[(2*maxOrderP1)*(maxOrderP1)];
  }
}

void CosSinTable::memAllocate(int order) {
  if (CosSinTableSwitch) {
    CosSinTableSwitch = 0;
    maxOrder = order;
    maxOrderP1 = order+1;
    CosMxThetaX = new double[maxOrderP1];
    SinMxThetaX = new double[maxOrderP1];
    CosMyThetaY = new double[maxOrderP1];
    SinMyThetaY = new double[maxOrderP1];
  }
  v = new double[(2*maxOrderP1)*(maxOrderP1)];
}

void CosSinTable::CosSinUpdate(Vec &xys) {
  CosMxThetaX[0] = 1.0;
  SinMxThetaX[0] = 0.0;
  CosMyThetaY[0] = 1.0;
  SinMyThetaY[0] = 0.0;
  CosMxThetaX[1] = xys[0];
  SinMxThetaX[1] = -xys[1];
  CosMyThetaY[1] = xys[2];
  SinMyThetaY[1] = -xys[3];
  for (int mx=1; mx<maxOrder; mx++) {
    CosMxThetaX[mx+1] = CosMxThetaX[mx]*CosMxThetaX[1] -
                        SinMxThetaX[mx]*SinMxThetaX[1]; 
    SinMxThetaX[mx+1] = SinMxThetaX[mx]*CosMxThetaX[1] +
                        CosMxThetaX[mx]*SinMxThetaX[1]; 
    CosMyThetaY[mx+1] = CosMyThetaY[mx]*CosMyThetaY[1] -
                        SinMyThetaY[mx]*SinMyThetaY[1]; 
    SinMyThetaY[mx+1] = SinMyThetaY[mx]*CosMyThetaY[1] +
                        CosMyThetaY[mx]*SinMyThetaY[1]; 
  }
}

void CosSinTable::CosUpdate() {
  for (int my=0; my<maxOrderP1; my++) {
    v[maxOrder*maxOrderP1+my]=
      CosMxThetaX[0]*CosMyThetaY[my] - SinMxThetaX[0]*SinMyThetaY[my];
    for (int mx=1; mx<maxOrderP1; mx++) {
      v[(mx+maxOrder)*maxOrderP1+my]=
	CosMxThetaX[mx]*CosMyThetaY[my] - SinMxThetaX[mx]*SinMyThetaY[my];
      v[(maxOrder-mx)*maxOrderP1+my]=
	CosMxThetaX[mx]*CosMyThetaY[my] + SinMxThetaX[mx]*SinMyThetaY[my];
    }
  }
  v[maxOrder*maxOrderP1] = 0.0; 
}

void CosSinTable::SinUpdate() {
  for (int my=0; my<maxOrderP1; my++) {
    v[(maxOrder)*maxOrderP1+my]=
      SinMxThetaX[0]*CosMyThetaY[my] + CosMxThetaX[0]*SinMyThetaY[my];
    for (int mx=1; mx<maxOrderP1; mx++) {
      v[(mx+maxOrder)*maxOrderP1+my]=
	SinMxThetaX[mx]*CosMyThetaY[my] + CosMxThetaX[mx]*SinMyThetaY[my];
      v[(maxOrder-mx)*maxOrderP1+my]=
	CosMxThetaX[mx]*SinMyThetaY[my] - SinMxThetaX[mx]*CosMyThetaY[my];
    }
  }
}

ResMap::ResMap(int order) { 
  memAllocate(order);
  sines.memAllocate(order);
  cosines.memAllocate(order);
  tjj.memAllocate(order);
}

ResMap::ResMap(const Tps & zz) {
  getResMap(zz);
}

void ResMap::getResMap(const Tps& zz ) {
  int order = zz.getMaxOrder();
  memAllocate(order);
  sines.memAllocate(order);
  cosines.memAllocate(order);
  tjj.memAllocate(order);

  int lTs =0;
  for (int ord=2; ord<=maxOrder; ord+=2){
    for (int nyy=0; nyy<=ord; nyy+=2){
      int nxx = ord -nyy;
      nxTs[lTs] = nxx;
      nyTs[lTs] = nyy;
      termTs[lTs] = maxOrder - ord +1;
      for (int p =0; p<termTs[lTs]; p++){
	coefTsDelta[lTs][p] = cTs(ord, nxx, nyy, p, zz);
      }
      ++lTs;
    }
  }
  
  int lCos =0;
  for( int mxy =1; mxy<=maxOrder; mxy++){

    for (int myy=0; myy<=mxy; myy++){
      int mxx = mxy-myy;
      for (int ord=mxy; ord<=maxOrder; ord+=2){
	for(int nyy=myy; nyy<=ord-mxx; nyy+=2){
	  int nxx = ord-nyy;
	  nx[lCos]=nxx;
	  ny[lCos]=nyy;
	  mx[lCos]=mxx;
	  my[lCos]=myy;
	  term[lCos]=maxOrder-ord+1;
	  for(int p=0; p<term[lCos]; p++){
	    coefCosDelta[lCos][p]= cCos(ord, mxx,myy, nxx,nyy,p,zz)
	      +cCos(ord, -mxx,-myy, nxx,nyy,p,zz);
	    coefSinDelta[lCos][p]= cSin(ord, mxx,myy, nxx,nyy,p,zz)
	      -cSin(ord, -mxx,-myy, nxx,nyy,p,zz);
	  }
	  lCos++;

	  if(mxx && myy){
	    nx[lCos]=nxx;
	    ny[lCos]=nyy;
	    mx[lCos]=-mxx;
	    my[lCos]=myy;
	    term[lCos]=maxOrder-ord+1;
	    for(int p=0; p<term[lCos]; p++){
	    coefCosDelta[lCos][p]= cCos(ord, -mxx,myy, nxx,nyy,p,zz)
	      +cCos(ord, mxx,-myy, nxx,nyy,p,zz);
	    coefSinDelta[lCos][p]= cSin(ord, -mxx,myy, nxx,nyy,p,zz)
	      -cSin(ord, mxx,-myy, nxx,nyy,p,zz);
	    }
	    lCos++;
	  }
	}
      }
    }
  }
  nmxy();
}

void ResMap::scaleMap(double tJx) {
  // e.g. tJx = emittance = emit, usually scale to emittance X.
  // Jx = esp * Jx_n; Jy = emit *Jy_n; h_t = emit * h_t_n; h_R = emit * h_R_n;
  // nx + ny - 2, where -2 is for h scale.
  double tJxsqrt = sqrt(tJx);
  for (int lTs=0; lTs<numCoefTs; lTs++) {
    double temp = pwr(tJxsqrt, nxTs[lTs]+nyTs[lTs]-2);
    for (int ip=0; ip<termTs[lTs]; ++ip) coefTsDelta[lTs][ip] *= temp;
  }
  for (int n=0; n<numCoef; n++) {
    double temp = pwr(tJxsqrt, nx[n]+ny[n]-2);
    for (int ip=0; ip<term[n]; ++ip) {
      coefCosDelta[n][ip] *= temp;
      coefSinDelta[n][ip] *= temp;
    }
  } 
}  

void ResMap::memAllocate(int order) {
  int i;
  maxOrder = order;
  int mTs = (maxOrder/2)*2;
  numCoefTs = mTs*(mTs+6)/8;

  int maxOrderSquare = maxOrder*maxOrder;
  if (maxOrder%2 == 0)
    numCoef = ( maxOrderSquare*maxOrderSquare + 10*maxOrderSquare*maxOrder
		+ 32*maxOrderSquare + 32*maxOrder)/48;
  else 
    numCoef = (maxOrder+1)*(maxOrder+1)*(maxOrder+3)*(maxOrder+5)/48;
  
  nxTs = new int[numCoefTs];
  nyTs = new int[numCoefTs];
  termTs = new int[numCoefTs];
  
  nmxTs  = new int[numCoefTs];
  nmyTs  = new int[numCoefTs];
  nxm2Ts  = new int[numCoefTs];
  nym2Ts  = new int[numCoefTs];
  nxm4Ts  = new int[numCoefTs];
  nym4Ts  = new int[numCoefTs];
  nxm6Ts  = new int[numCoefTs];
  nym6Ts  = new int[numCoefTs];

  coefTs = new double [numCoefTs];
  coefTsDelta = new double* [numCoefTs];
  for(i=0; i<numCoefTs; i++)
    coefTsDelta[i] = new double [maxOrder];

  mx = new int[numCoef];
  my = new int[numCoef]; 
  nx = new int[numCoef];
  ny = new int[numCoef];
  term = new int[numCoef];
  
  nmx  = new int[numCoef];
  nmy  = new int[numCoef];
  nxm2  = new int[numCoef];
  nym2  = new int[numCoef];
  nxm4  = new int[numCoef];
  nym4  = new int[numCoef];
  nxm6  = new int[numCoef];
  nym6  = new int[numCoef];

  coefCos = new double [numCoef];
  coefSin = new double [numCoef];
  coefCosDelta = new double* [numCoef];
  coefSinDelta = new double* [numCoef];
  for(i=0; i<numCoef; i++){
    coefCosDelta[i] = new double [maxOrder];
    coefSinDelta[i] = new double [maxOrder];
  }
  deltaPower = new double[maxOrder]; // Yiton Aug. 26, 1999
}

ResMap::~ResMap() { 
  if (maxOrder) {
    delete [] nxTs; delete [] nyTs; delete [] termTs;
    delete [] nmxTs;
    delete [] nmyTs;
    delete [] nxm2Ts;
    delete [] nym2Ts;
    delete [] nxm4Ts;
    delete [] nym4Ts;
    delete [] nxm6Ts;
    delete [] nym6Ts;
    delete [] coefTs;  delete [] coefTsDelta;
    
    delete [] mx; delete [] my; delete [] nx; delete [] ny; delete [] term;
    delete [] nmx;
    delete [] nmy;
    delete [] nxm2;
    delete [] nym2;
    delete [] nxm4;
    delete [] nym4;
    delete [] nxm6;
    delete [] nym6;
    delete [] coefCos;  delete [] coefCosDelta;
    delete [] coefSin;  delete [] coefSinDelta;
    delete [] deltaPower; // Yiton Aug. 26, 1999
  }
}

double cTs(int  ord, int nx, int ny, int p, const Tps & zz) {
  
  const int nVar =5;
  static int *js; js = new int[nVar];
  js[4] = p;

  double result=0;

  int hx,hy,kx,ky;

  for (hx=0; hx<=nx/2; hx++)
    for (hy=0; hy<=ny/2; hy++)
      for (kx=nx/2-hx; kx<=nx-hx; kx++) {
	js[0] = nx-kx;
	js[1] = kx;
	for (ky=ny/2-hy; ky<=ny-hy; ky++) {
	  js[2] = ny-ky;
	  js[3] = ky;
	  if ((kx+ky)%2 == 0)
	    result += zz[js]*kbinom(nx-kx,hx)*kbinom(ny-ky,hy)
              *kbinom(kx,nx/2-hx)*kbinom(ky,ny/2-hy)*pwr(-1,ord/2-(hx+hy))
              *pwr(-1,(kx+ky)/2);
	}
      }
  return result*pwr(0.5,(nx+ny));
}

double cCos(int  ord, int mx, int my, int nx, int ny, int p, const Tps & zz) {

  const int nVar =5;
  static int *js; js = new int[nVar];
  js[4] = p;

  double result=0;

  int hx,hy,kx,ky;

  for (hx=0; hx<=(nx-mx)/2; hx++)
    for (hy=0; hy<=(ny-my)/2; hy++)
      for (kx=(nx-mx)/2-hx; kx<=nx-hx; kx++) {
	js[0] = nx-kx;
	js[1] = kx;
	for (ky=(ny-my)/2-hy; ky<=ny-hy; ky++){
	  js[2] = ny-ky;
	  js[3] = ky;
	  if ((kx+ky)%2 == 0)
	    result += zz[js]*kbinom(nx-kx,hx)*kbinom(ny-ky,hy)
	      *kbinom(kx,(nx-mx)/2-hx)*kbinom(ky,(ny-my)/2-hy)
	      *pwr(-1,(ord-mx-my)/2-hx-hy)*pwr(-1,(kx+ky)/2);
	}
      }
  return result*pwr(0.5,(nx+ny));
}

double cSin(int  ord, int mx, int my, int nx, int ny, int p, const Tps & zz) {

  const int nVar =5;
  static int *js; js = new int[nVar];
  js[4] = p;

  double result=0;
  int hx,hy,kx,ky;
  
  for (hx=0; hx<=(nx-mx)/2; hx++)
    for (hy=0; hy<=(ny-my)/2; hy++)
      for (kx=(nx-mx)/2-hx; kx<=nx-hx; kx++) {
	js[0] = nx-kx;
	js[1] = kx;
	for (ky=(ny-my)/2-hy; ky<=ny-hy; ky++){
	  js[2] = ny-ky;
	  js[3] = ky;
	  if ((kx+ky)%2 == 1) 
	    result += zz[js]*kbinom(nx-kx,hx)*kbinom(ny-ky,hy)
	      *kbinom(kx,(nx-mx)/2-hx)*kbinom(ky,(ny-my)/2-hy)
	      *pwr(-1,(ord-mx-my)/2-hx-hy)*pwr(-1,(kx+ky+1)/2);
	}
      }
  return result*pwr(0.5,(nx+ny));
}

istream& operator>> (istream& in, ResMap& zz){

  char *input; double temp;
  int i,j;
  int ch;

  for (i=0; i<59; i++){
    input = ReadLine(in);
    free(input);
  }

  for (i=0; i<5; i++)
    input = ReadLine(in);
  
  for (i=0; i<zz.numCoefTs; i++){
    in >>temp >>temp >>zz.nxTs[i] >>zz.nyTs[i];
    j=0;
    while (1){
      in >>zz.coefTsDelta[i][j];
      if ((ch = in.get())== '\n'){
	zz.termTs[i] = j+1;
	break;
      }
      else {
	j++;
	in.putback(ch); 
      }
    } 
  }

 
  
  for (i=0; i<5; i++)
    input = ReadLine(in);
  
  for (i=0; i<zz.numCoef; i++){
    in >>zz.mx[i] >>zz.my[i] >>zz.nx[i] >>zz.ny[i];
    j=0;
    while (1){
      in >>zz.coefCosDelta[i][j];
      if ((ch = in.get())== '\n'){
	zz.term[i] = j+1;
	break;
      }
      else{ 
	j++;
	in.putback(ch);
      }
    }
  }
  
  
  for (i=0; i<5; i++)
    input = ReadLine(in);

  for (i=0; i<zz.numCoef; i++){
    in >>zz.mx[i] >>zz.my[i] >>zz.nx[i] >>zz.ny[i];
    j=0;
    while (1){
      in >>zz.coefSinDelta[i][j];
      if ((ch = in.get())== '\n') 
	break;
      else {
	j++;
	in.putback(ch);
      }
    }
  }
  zz.nmxy();
  return in;
}

ostream& operator << (ostream& out, const ResMap & zz)
{
  out.flags(ios::showpoint|ios::scientific);
  int zero =0;
  out << "ResMap\n";
  int i,j;  // index
  for (i=0; i<zz.numCoefTs; ++i) {
    out << "  " << zero << "  " << zero << "  " << zz.nxTs[i]
        << "  " << zz.nyTs[i];
    for (j=0; j<zz.termTs[i]; ++j) {
      out << "  " << zz.coefTsDelta[i][j];
    }
    out << endl;
  }
  out << endl;
  for (i=0; i<zz.numCoef; ++i) {
    out << "  " << zz.mx[i] << "  " << zz.my[i] << "  " << zz.nx[i]
        << "  " << zz.ny[i];
    for (j=0; j<zz.term[i]; ++j) {
      out << "  " << zz.coefCosDelta[i][j];
    }
    out << endl;
  }
  out << endl;
  for (i=0; i<zz.numCoef; ++i) {
    out << "  " << zz.mx[i] << "  " << zz.my[i] << "  " << zz.nx[i]
        << "  " << zz.ny[i];
    for (j=0; j<zz.term[i]; ++j) {
      out << "  " << zz.coefSinDelta[i][j];
    }
    out << endl;
  }
  out << "\n\n";
  return out;
}


static char *ReadLine(istream & fin)
{
    char *line;
    int n=0, ch;
   
    line = (char *) malloc(INICIAL_BUFFER_SIZE + 1);
    assert (line != NULL);
   
    while ((ch = fin.get()) != '\n' && ch != EOF) 
      line[n++] = ch;
 
    if (n == 0 && ch == EOF) {
      free(line);
      return (NULL);
    }
    line[n] = '\0';
    
    return line;
}



void ResMap::SumTable(double delta){

  int i,j;

  for(j=0; j<maxOrder; j++) deltaPower[j] = pwr(delta, j);

  for(i=0; i<numCoefTs; i++){
    coefTs[i] = 0;
    for (j=0; j<termTs[i]; j++)
      coefTs[i] += deltaPower[j]*coefTsDelta[i][j];
  } 
  
  for (i=0; i<numCoef; i++){
    coefCos[i] = 0;
    coefSin[i] = 0;
    for (j=0; j<term[i]; j++){
     coefCos[i] += deltaPower[j]*coefCosDelta[i][j];
     coefSin[i] += deltaPower[j]*coefSinDelta[i][j];
    }
  }

  for (i=0; i<numCoef; i++)
    coefSin[i] = - coefSin[i]; // Checked with Fortran ???

}

 
void ResMap::nmxy(void) {
  int l;

  for (l=0;l<numCoef; l++){
    nmx[l]=(nx[l]-abs(mx[l]))/2;
    nmy[l]=(ny[l]-my[l])/2;
    nxm2[l]=nx[l]-2;
    nym2[l]=ny[l]-2;
    nxm4[l]=nx[l]-4;
    nym4[l]=ny[l]-4;
    nxm6[l]=nx[l]-6;
    nym6[l]=ny[l]-6;
  }
      
  for (l=0;l<numCoefTs; l++){
    nmxTs[l]=nxTs[l]/2;
    nmyTs[l]=nyTs[l]/2;
    nxm2Ts[l]=nxTs[l]-2;
    nym2Ts[l]=nyTs[l]-2;
    nxm4Ts[l]=nxTs[l]-4;
    nym4Ts[l]=nyTs[l]-4;
    nxm6Ts[l]=nxTs[l]-6;
    nym6Ts[l]=nyTs[l]-6;
  }
}

// The following static memeory is globally treated for local use
// to avoid repeated memory allocation.

  static const int n4=4; // parameter (n4=4);
  //--- Spb
  static double h[n4],dh[n4],zx[n4],zpx[n4],zy[n4],zpy[n4];
  //--- Dpb
  static double hh[n4][n4],dhh[n4][n4],h2[n4];
  static double zzx[n4][n4],zzpx[n4][n4],zzy[n4][n4],zzpy[n4][n4];
  static double hzzx[n4],hzzpx[n4],hzzy[n4],hzzpy[n4];
  //--- 3pb
  static double hhh[n4][n4][n4],dhhh[n4][n4][n4],h3[n4],gg3[n4][n4];
  static double zzzx[n4][n4][n4],zzzpx[n4][n4][n4];
  static double zzzy[n4][n4][n4],zzzpy[n4][n4][n4];
  static double hhzzzx[n4],hhzzzpx[n4],hhzzzy[n4],hhzzzpy[n4];
  //--- 4pb
  static double hhhh[n4][n4][n4][n4],dhhhh[n4][n4][n4][n4],h4[n4];
  static double ggg4[n4][n4][n4],gg4[n4][n4];
  static double zzzzx[n4][n4][n4][n4],zzzzpx[n4][n4][n4][n4];
  static double zzzzy[n4][n4][n4][n4],zzzzpy[n4][n4][n4][n4];
  static double hhhzzzzx[n4],hhhzzzzpx[n4],hhhzzzzy[n4],hhhzzzzpy[n4];
  static double h2zzx[n4],h2zzpx[n4],h2zzy[n4],h2zzpy[n4];

    //    SPB ******************************************************
    static double cmnTs;
    static double cmnxTs;
    static double cmnyTs;
    //     DPB ******************************************************
    static double cmnx2Ts;
    static double cmnxyTs;
    static double cmny2Ts;
    //     3PB ******************************************************
    static double cmnx3Ts;
    static double cmnx2yTs;
    static double cmnxy2Ts;
    static double cmny3Ts;
    //        4PB ************** to be implimented *********************
    static double cmnx4Ts;
    static double cmnx3yTs;
    static double cmnx2y2Ts;
    static double cmnxy3Ts;
    static double cmny4Ts;
  // sum over resonance terms
    static double cmn;
    static double smn;
    //        SPB ******************************************************
    static double cmnnx;
    static double cmnny;
    static double smnmx;
    static double smnmy;
    //        DPB ******************************************************
    static double smxnx;
    static double smxny;
    static double smynx;
    static double smyny;

    static double cmx2;
    static double cmnmy;
    static double cmxmy;
    static double cmy2;
    static double cnx2;
    static double cnxny;
    static double cny2;
    //        3PB ******************************************************
    static double smx2;
    static double smx3;
    static double smx2my;
    static double smy2;
    static double smxmy2;
    static double smxnx2;
    static double smxnxny;
    static double smxny2;
    static double smy3;
    static double smynx2;
    static double smynxny;
    static double smyny2;

    static double cmx2nx;
    static double cmx2ny;
    static double cmxmynx;
    static double cmxmyny;
    static double cmy2nx;
    static double cmy2ny;
    static double cnx3;
    static double cnx2ny;
    static double cnxny2;
    static double cny3;
    //        4PB ******************************************************
    static double smx3nx;
    static double smx3ny;
    static double smx2mynx;
    static double smx2myny;
    static double smxmy3;
    static double smxmy2nx;
    static double smxmy2ny;
    static double smxnx3;
    static double smxnx2ny;
    static double smxnxny2;
    static double smxny3;
    static double smy3nx;
    static double smy3ny;
    static double smynx3;
    static double smynx2ny;
    static double smynxny2;
    static double smyny3;

    static double cmx4;
    static double cmx2my;
    static double cmx3my;
    static double cmx2my2;
    static double cmx2nx2;
    static double cmx2nxny;
    static double cmx2ny2;
    static double cmxmynx2;
    static double cmxmynxny;
    static double cmxmyny2;
    static double cmy3;
    static double cmxmy3;
    static double cmy4;
    static double cmy2nx2;
    static double cmy2nxny;
    static double cmy2ny2;
    static double cnx4;
    static double cnx3ny;
    static double cnx2ny2;
    static double cnxny3;
    static double cny4;

    static double dx;
    static double dpx;
    static double dy;
    static double dpy;
    static double tpbx;
    static double tpbpx;
    static double tpby;
    static double tpbpy;


void ResMap::exph1(Vec & xys) {

  SumTable(xys[4]);
  tjj.Update(xys);
  CosSinTable::CosSinUpdate(xys);
  sines.SinUpdate();
  cosines.CosUpdate();
  //--- local array
  //    Note zx[2]=zx[3]=zpx[2]=zpx[3]=zy[0]=zy[1]=zpy[0]=zpy[1] = 0 always.
  //    SPB ******************************************************
  int i,l;   // loop index
  for (i=0; i<n4; ++i) {
    dh[i]=0.0;
  }
  //ccccc sum over tune shift terms
  for (l=0; l<numCoefTs; ++l) {
    //    SPB ******************************************************
    cmnTs=coefTs[l]*tjj(nmxTs[l],nmyTs[l]);
    cmnxTs=nxTs[l]*cmnTs;
    cmnyTs=nyTs[l]*cmnTs;
    dh[0]=dh[0] + cmnxTs;
    dh[2]=dh[2] + cmnyTs;
  }
  // sum over resonance terms
  
  for (l=0; l<numCoef; ++l) {
    
    cmn=tjj(nmx[l],nmy[l])*(coefCos[l]*cosines(mx[l],my[l])+
			    coefSin[l]*sines(mx[l],my[l]));
    smn=tjj(nmx[l],nmy[l])*(coefSin[l]*cosines(mx[l],my[l])-
			    coefCos[l]*sines(mx[l],my[l]));
    //        SPB ******************************************************
    cmnnx=nx[l]*cmn;
    cmnny=ny[l]*cmn;
    smnmx=mx[l]*smn;
    smnmy=my[l]*smn;
    dh[0]=dh[0]+cmnnx;
    dh[1]=dh[1]+smnmx;
    dh[2]=dh[2]+cmnny;
    dh[3]=dh[3]+smnmy;
  }
  //*****************************************************************
  //
  //
  //                    Spb - begin                              
  //                                                               
  // *****************************************************************

  //    Calculate vec{H} =[h[0],h[1],h[2],h[3]]
  dh[0]=-dh[0]*tjj(-1,0);
  dh[2]=-dh[2]*tjj(0,-1);

  for (i=0; i<n4; ++i) {			  
    h[i]=dh[i];
  }
  //   Calculate vec{zx} =[zx[0],zx[1],0,0], and vec{zpx}, etc
  zx[0]=xys[1];
  zx[1]=xys[0]*tjj(-1,0);
  zpx[0]=-xys[0];
  zpx[1]=xys[1]*tjj(-1,0);
  zy[2]=xys[3];
  zy[3]=xys[2]*tjj(0,-1);
  zpy[2]=-xys[2];
  zpy[3]=xys[3]*tjj(0,-1);
  //---- Calculate Spb = vec{H} . vec{z} = Spb{x,px,y,py}[[0][1] or [2][3]]
  dx=h[0]*zx[0]+h[1]*zx[1];
  dpx=h[0]*zpx[0]+h[1]*zpx[1];
  dy=h[2]*zy[2]+h[3]*zy[3];
  dpy=h[2]*zpy[2]+h[3]*zpy[3];
  //c******************************************************************
  //c                         end - Spb                               *
  //c******************************************************************
 xys[0]=xys[0]+dx;
 xys[1]=xys[1]+dpx;
 xys[2]=xys[2]+dy;
 xys[3]=xys[3]+dpy;
}

void ResMap::exph2(Vec & xys) {

  SumTable(xys[4]);
  tjj.Update(xys);
  CosSinTable::CosSinUpdate(xys);
  sines.SinUpdate();
  cosines.CosUpdate();
  //--- local array
  //    Note zx[2]=zx[3]=zpx[2]=zpx[3]=zy[0]=zy[1]=zpy[0]=zpy[1] = 0 always.
  //    SPB ******************************************************
  int i,j,l;   // loop index
  for (i=0; i<n4; ++i) {
    dh[i]=0.0;
    //       DPB ******************************************************
    for (j=0; j<n4; ++j) {
      dhh[i][j]=0.0;
    }
  }
  //ccccc sum over tune shift terms
  for (l=0; l<numCoefTs; ++l) {
    //    SPB ******************************************************
    cmnTs=coefTs[l]*tjj(nmxTs[l],nmyTs[l]);
    cmnxTs=nxTs[l]*cmnTs;
    cmnyTs=nyTs[l]*cmnTs;
    dh[0]=dh[0] + cmnxTs;
    dh[2]=dh[2] + cmnyTs;
    //     DPB ******************************************************
    cmnx2Ts=(nxm2Ts[l])*cmnxTs;
    dhh[1][0]=dhh[1][0]+cmnx2Ts;
    cmnxyTs=nyTs[l]*cmnxTs;
    dhh[3][0]=dhh[3][0]+cmnxyTs;
    cmny2Ts=(nym2Ts[l])*cmnyTs;
    dhh[3][2]=dhh[3][2]+cmny2Ts;
  }
  // sum over resonance terms
  
  for (l=0; l<numCoef; ++l) {
    
    cmn=tjj(nmx[l],nmy[l])*(coefCos[l]*cosines(mx[l],my[l])+
			    coefSin[l]*sines(mx[l],my[l]));
    smn=tjj(nmx[l],nmy[l])*(coefSin[l]*cosines(mx[l],my[l])-
			    coefCos[l]*sines(mx[l],my[l]));
    //        SPB ******************************************************
    cmnnx=nx[l]*cmn;
    cmnny=ny[l]*cmn;
    smnmx=mx[l]*smn;
    smnmy=my[l]*smn;
    dh[0]=dh[0]+cmnnx;
    dh[1]=dh[1]+smnmx;
    dh[2]=dh[2]+cmnny;
    dh[3]=dh[3]+smnmy;
    //        DPB ******************************************************
    smxnx=nx[l]*smnmx;
    smxny=ny[l]*smnmx;
    smynx=nx[l]*smnmy;
    smyny=ny[l]*smnmy;

    cmx2=mx[l]*mx[l]*cmn;
    cmnmy=my[l]*cmn;
    cmxmy=mx[l]*cmnmy;
    cmy2=my[l]*cmnmy;
    cnx2=nxm2[l]*cmnnx;
    cnxny=nx[l]*cmnny;       
    cny2=nym2[l]*cmnny;

    dhh[0][0]=dhh[0][0]+smxnx;
    dhh[1][0]=dhh[1][0]+cnx2;
    dhh[2][0]=dhh[2][0]+smynx;
    dhh[3][0]=dhh[3][0]+cnxny;
    dhh[0][1]=dhh[0][1]+cmx2;
    dhh[2][1]=dhh[2][1]+cmxmy;
    dhh[3][1]=dhh[3][1]+smxny;
    dhh[2][2]=dhh[2][2]+smyny;
    dhh[3][2]=dhh[3][2]+cny2;
    dhh[2][3]=dhh[2][3]+cmy2;
  }
  //*****************************************************************
  //
  //
  //                    Spb - begin                              
  //                                                               
  // *****************************************************************

  //    Calculate vec{H} =[h[0],h[1],h[2],h[3]]
  dh[0]=-dh[0]*tjj(-1,0);
  dh[2]=-dh[2]*tjj(0,-1);

  for (i=0; i<n4; ++i) {			  
    h[i]=dh[i];
  }
  //   Calculate vec{zx} =[zx[0],zx[1],0,0], and vec{zpx}, etc
  zx[0]=xys[1];
  zx[1]=xys[0]*tjj(-1,0);
  zpx[0]=-xys[0];
  zpx[1]=xys[1]*tjj(-1,0);
  zy[2]=xys[3];
  zy[3]=xys[2]*tjj(0,-1);
  zpy[2]=-xys[2];
  zpy[3]=xys[3]*tjj(0,-1);
  //---- Calculate Spb = vec{H} . vec{z} = Spb{x,px,y,py}[[0][1] or [2][3]]
  dx=h[0]*zx[0]+h[1]*zx[1];
  dpx=h[0]*zpx[0]+h[1]*zpx[1];
  dy=h[2]*zy[2]+h[3]*zy[3];
  dpy=h[2]*zpy[2]+h[3]*zpy[3];
  //c******************************************************************
  //c                         end - Spb                               *
  //c******************************************************************
  //c******************************************************************
  //c******************************************************************
  //c                                                                 *
  //c                        Dpb - begin                              *
  //c                                                                 *
  //c******************************************************************
  //c==== Calculate DPB
  //c---- Calculate vec{vec{H}} = hh[n4][n4], and vec{H2} = h2[n4]
  //c1    Calculation of vec{vec{H}}
  hh[0][0]=-tjj(-1,0)*dhh[0][0];
  hh[1][0]=-tjj(-2,0)*dhh[1][0];
  hh[2][0]=-tjj(-1,0)*dhh[2][0];
  hh[3][0]=-tjj(-1,-1)*dhh[3][0];
  hh[0][1]=-dhh[0][1];
  hh[1][1]=-hh[0][0];
  hh[2][1]=-dhh[2][1];
  hh[3][1]=tjj(0,-1)*dhh[3][1];
  hh[0][2]=-hh[3][1];
  hh[1][2]=hh[3][0];
  hh[2][2]=-tjj(0,-1)*dhh[2][2];
  hh[3][2]=-tjj(0,-2)*dhh[3][2];
  hh[0][3]=hh[2][1];
  hh[1][3]=-hh[2][0];
  hh[2][3]=-dhh[2][3];
  hh[3][3]=-hh[2][2];
  //c2    Calculation of vec{H2}=vec{H} . vec{vec{H}}
  for (i=0; i<n4; ++i) { 
    h2[i]=h[0]*hh[0][i];
    for (j=1; j<n4; ++j) {	   
      h2[i]=h2[i]+h[j]*hh[j][i];
    }
  }
  //-- Calculate vec{vec{z}} = zz[n4][n4], and vec{HZZ} = vec{H} . vec{vec{z}}
  //c1    Calculate vec{vec{z}} = zz[n4][n4] ={zzx,zzpx,zzy,zzpy}[n4][n4]
  zzx[0][0]=zpx[0];
  zzx[1][0]=zpx[1];
  zzx[0][1]=zzx[1][0];
  zzx[1][1]=-tjj(-1,0)*zx[1];

  zzpx[0][0]=-zx[0];
  zzpx[1][0]=-zx[1];
  zzpx[0][1]=zzpx[1][0];
  zzpx[1][1]=-tjj(-1,0)*zpx[1];

  zzy[2][2]=zpy[2];
  zzy[3][2]=zpy[3];
  zzy[2][3]=zzy[3][2];
  zzy[3][3]=-tjj(0,-1)*zy[3];

  zzpy[2][2]=-zy[2];
  zzpy[3][2]=-zy[3];
  zzpy[2][3]=zzpy[3][2];
  zzpy[3][3]=-tjj(0,-1)*zpy[3];
  //c1    Calculate vec{HZZ}} = vec{H} . vec{vec{zz}}=
  //               hzz[n4] ={hzzx,hzzpx,hzzy,hzzpy}[n4]
  for (i=0; i<2; ++i) { 
    hzzx[i]=h[0]*zzx[0][i];
    hzzx[i]=hzzx[i]+h[1]*zzx[1][i];
    hzzpx[i]=h[0]*zzpx[0][i];
    hzzpx[i]=hzzpx[i]+h[1]*zzpx[1][i];
  }
  for (i=2; i<4; ++i){
    hzzy[i]=h[2]*zzy[2][i];
    hzzy[i]=hzzy[i]+h[3]*zzy[3][i];
    hzzpy[i]=h[2]*zzpy[2][i];
    hzzpy[i]=hzzpy[i]+h[3]*zzpy[3][i];
  }
   
  //c---- Calculate Dpb = vec{H2} . vec{H}.[vec{H}.vec{vec{z}} 
  //c                    = Dpb{x,px,y,py}[[0][1] or [2][3]]
  dx+=0.5*(h2[0]*zx[0]+h2[1]*zx[1]+h[0]*hzzx[0]+h[1]*hzzx[1]);
  dpx+=0.5*(h2[0]*zpx[0]+h2[1]*zpx[1]+h[0]*hzzpx[0]+h[1]*hzzpx[1]);
  dy+=0.5*(h2[2]*zy[2]+h2[3]*zy[3]+h[2]*hzzy[2]+h[3]*hzzy[3]);
  dpy+=0.5*(h2[2]*zpy[2]+h2[3]*zpy[3]+h[2]*hzzpy[2]+h[3]*hzzpy[3]);
  //c******************************************************************
  //c                         end - Dpb                               *
  //c******************************************************************
 xys[0]=xys[0]+dx;
 xys[1]=xys[1]+dpx;
 xys[2]=xys[2]+dy;
 xys[3]=xys[3]+dpy;
}

void ResMap::exph3(Vec & xys) {

  SumTable(xys[4]);
  tjj.Update(xys);
  CosSinTable::CosSinUpdate(xys);
  sines.SinUpdate();
  cosines.CosUpdate();
  //--- local array
  //    Note zx[2]=zx[3]=zpx[2]=zpx[3]=zy[0]=zy[1]=zpy[0]=zpy[1] = 0 always.
  //    SPB ******************************************************
  int i,j,k,l;   // loop index
  for (i=0; i<n4; ++i) {
    dh[i]=0.0;
    //       DPB ******************************************************
    for (j=0; j<n4; ++j) {
      dhh[i][j]=0.0;
      //          3PB ******************************************************
      for (k=0; k<n4; ++k) {
	dhhh[i][j][k]=0.0;
	//             4PB ************************************** deleted
      }
    }
  }
  //ccccc sum over tune shift terms
  for (l=0; l<numCoefTs; ++l) {
    //    SPB ******************************************************
    cmnTs=coefTs[l]*tjj(nmxTs[l],nmyTs[l]);
    cmnxTs=nxTs[l]*cmnTs;
    cmnyTs=nyTs[l]*cmnTs;
    dh[0]=dh[0] + cmnxTs;
    dh[2]=dh[2] + cmnyTs;
    //     DPB ******************************************************
    cmnx2Ts=(nxm2Ts[l])*cmnxTs;
    dhh[1][0]=dhh[1][0]+cmnx2Ts;
    cmnxyTs=nyTs[l]*cmnxTs;
    dhh[3][0]=dhh[3][0]+cmnxyTs;
    cmny2Ts=(nym2Ts[l])*cmnyTs;
    dhh[3][2]=dhh[3][2]+cmny2Ts;
    //     3PB ******************************************************
    cmnx3Ts=nxm4Ts[l]*cmnx2Ts;
    dhhh[1][1][0]=dhhh[1][1][0]+cmnx3Ts;
    cmnx2yTs=nxm2Ts[l]*cmnxyTs;
    dhhh[3][1][0]=dhhh[3][1][0]+cmnx2yTs;
    cmnxy2Ts=nym2Ts[l]*cmnxyTs;
    dhhh[3][3][0]=dhhh[3][3][0]+cmnxy2Ts;
    cmny3Ts=nym4Ts[l]*cmny2Ts;
    dhhh[3][3][2]=dhhh[3][3][2]+cmny3Ts;
    //        4PB ************** deleted *********************
  }
  // sum over resonance terms
  
  for (l=0; l<numCoef; ++l) {
    
    cmn=tjj(nmx[l],nmy[l])*(coefCos[l]*cosines(mx[l],my[l])+
			    coefSin[l]*sines(mx[l],my[l]));
    smn=tjj(nmx[l],nmy[l])*(coefSin[l]*cosines(mx[l],my[l])-
			    coefCos[l]*sines(mx[l],my[l]));
    //        SPB ******************************************************
    cmnnx=nx[l]*cmn;
    cmnny=ny[l]*cmn;
    smnmx=mx[l]*smn;
    smnmy=my[l]*smn;
    dh[0]=dh[0]+cmnnx;
    dh[1]=dh[1]+smnmx;
    dh[2]=dh[2]+cmnny;
    dh[3]=dh[3]+smnmy;
    //        DPB ******************************************************
    smxnx=nx[l]*smnmx;
    smxny=ny[l]*smnmx;
    smynx=nx[l]*smnmy;
    smyny=ny[l]*smnmy;

    cmx2=mx[l]*mx[l]*cmn;
    cmnmy=my[l]*cmn;
    cmxmy=mx[l]*cmnmy;
    cmy2=my[l]*cmnmy;
    cnx2=nxm2[l]*cmnnx;
    cnxny=nx[l]*cmnny;       
    cny2=nym2[l]*cmnny;

    dhh[0][0]=dhh[0][0]+smxnx;
    dhh[1][0]=dhh[1][0]+cnx2;
    dhh[2][0]=dhh[2][0]+smynx;
    dhh[3][0]=dhh[3][0]+cnxny;
    dhh[0][1]=dhh[0][1]+cmx2;
    dhh[2][1]=dhh[2][1]+cmxmy;
    dhh[3][1]=dhh[3][1]+smxny;
    dhh[2][2]=dhh[2][2]+smyny;
    dhh[3][2]=dhh[3][2]+cny2;
    dhh[2][3]=dhh[2][3]+cmy2;
    //        3PB ******************************************************
    smx2=mx[l]*smnmx;
    smx3=mx[l]*smx2;
    smx2my=my[l]*smx2;
    smy2=my[l]*smnmy;
    smxmy2=mx[l]*smy2;
    smxnx2=nxm2[l]*smxnx;
    smxnxny=ny[l]*smxnx;
    smxny2=nym2[l]*smxny;
    smy3=my[l]*smy2;
    smynx2=nxm2[l]*smynx;
    smynxny=ny[l]*smynx;
    smyny2=nym2[l]*smyny;

    cmx2nx=nx[l]*cmx2;
    cmx2ny=ny[l]*cmx2;
    cmxmynx=nx[l]*cmxmy;
    cmxmyny=ny[l]*cmxmy;
    cmy2nx=nx[l]*cmy2;
    cmy2ny=ny[l]*cmy2;
    cnx3=nxm4[l]*cnx2;
    cnx2ny=ny[l]*cnx2;
    cnxny2=nym2[l]*cnxny;
    cny3=nym4[l]*cny2;

    dhhh[0][0][0]=dhhh[0][0][0]+cmx2nx;
    dhhh[1][0][0]=dhhh[1][0][0]+smxnx2;
    dhhh[2][0][0]=dhhh[2][0][0]+cmxmynx;
    dhhh[3][0][0]=dhhh[3][0][0]+smxnxny;
    dhhh[1][1][0]=dhhh[1][1][0]+cnx3;
    dhhh[2][1][0]=dhhh[2][1][0]+smynx2;
    dhhh[3][1][0]=dhhh[3][1][0]+cnx2ny;
    dhhh[2][2][0]=dhhh[2][2][0]+cmy2nx;
    dhhh[3][2][0]=dhhh[3][2][0]+smynxny;
    dhhh[3][3][0]=dhhh[3][3][0]+cnxny2;
    dhhh[0][0][1]=dhhh[0][0][1]+smx3;
    dhhh[2][0][1]=dhhh[2][0][1]+smx2my;
    dhhh[3][0][1]=dhhh[3][0][1]+cmx2ny;
    dhhh[2][2][1]=dhhh[2][2][1]+smxmy2;
    dhhh[3][2][1]=dhhh[3][2][1]+cmxmyny;
    dhhh[3][3][1]=dhhh[3][3][1]+smxny2;
    dhhh[2][2][2]=dhhh[2][2][2]+cmy2ny;
    dhhh[3][2][2]=dhhh[3][2][2]+smyny2;
    dhhh[3][3][2]=dhhh[3][3][2]+cny3;
    dhhh[2][2][3]=dhhh[2][2][3]+smy3;
  }
  //*****************************************************************
  //
  //
  //                    Spb - begin                              
  //                                                               
  // *****************************************************************

  //    Calculate vec{H} =[h[0],h[1],h[2],h[3]]
  dh[0]=-dh[0]*tjj(-1,0);
  dh[2]=-dh[2]*tjj(0,-1);

  for (i=0; i<n4; ++i) {			  
    h[i]=dh[i];
  }
  //   Calculate vec{zx} =[zx[0],zx[1],0,0], and vec{zpx}, etc
  zx[0]=xys[1];
  zx[1]=xys[0]*tjj(-1,0);
  zpx[0]=-xys[0];
  zpx[1]=xys[1]*tjj(-1,0);
  zy[2]=xys[3];
  zy[3]=xys[2]*tjj(0,-1);
  zpy[2]=-xys[2];
  zpy[3]=xys[3]*tjj(0,-1);
  //---- Calculate Spb = vec{H} . vec{z} = Spb{x,px,y,py}[[0][1] or [2][3]]
  dx=h[0]*zx[0]+h[1]*zx[1];
  dpx=h[0]*zpx[0]+h[1]*zpx[1];
  dy=h[2]*zy[2]+h[3]*zy[3];
  dpy=h[2]*zpy[2]+h[3]*zpy[3];
  //c******************************************************************
  //c                         end - Spb                               *
  //c******************************************************************
  //c******************************************************************
  //c******************************************************************
  //c                                                                 *
  //c                        Dpb - begin                              *
  //c                                                                 *
  //c******************************************************************
  //c==== Calculate DPB
  //c---- Calculate vec{vec{H}} = hh[n4][n4], and vec{H2} = h2[n4]
  //c1    Calculation of vec{vec{H}}
  hh[0][0]=-tjj(-1,0)*dhh[0][0];
  hh[1][0]=-tjj(-2,0)*dhh[1][0];
  hh[2][0]=-tjj(-1,0)*dhh[2][0];
  hh[3][0]=-tjj(-1,-1)*dhh[3][0];
  hh[0][1]=-dhh[0][1];
  hh[1][1]=-hh[0][0];
  hh[2][1]=-dhh[2][1];
  hh[3][1]=tjj(0,-1)*dhh[3][1];
  hh[0][2]=-hh[3][1];
  hh[1][2]=hh[3][0];
  hh[2][2]=-tjj(0,-1)*dhh[2][2];
  hh[3][2]=-tjj(0,-2)*dhh[3][2];
  hh[0][3]=hh[2][1];
  hh[1][3]=-hh[2][0];
  hh[2][3]=-dhh[2][3];
  hh[3][3]=-hh[2][2];
  //c2    Calculation of vec{H2}=vec{H} . vec{vec{H}}
  for (i=0; i<n4; ++i) { 
    h2[i]=h[0]*hh[0][i];
    for (j=1; j<n4; ++j) {	   
      h2[i]=h2[i]+h[j]*hh[j][i];
    }
  }
  //-- Calculate vec{vec{z}} = zz[n4][n4], and vec{HZZ} = vec{H} . vec{vec{z}}
  //c1    Calculate vec{vec{z}} = zz[n4][n4] ={zzx,zzpx,zzy,zzpy}[n4][n4]
  zzx[0][0]=zpx[0];
  zzx[1][0]=zpx[1];
  zzx[0][1]=zzx[1][0];
  zzx[1][1]=-tjj(-1,0)*zx[1];

  zzpx[0][0]=-zx[0];
  zzpx[1][0]=-zx[1];
  zzpx[0][1]=zzpx[1][0];
  zzpx[1][1]=-tjj(-1,0)*zpx[1];

  zzy[2][2]=zpy[2];
  zzy[3][2]=zpy[3];
  zzy[2][3]=zzy[3][2];
  zzy[3][3]=-tjj(0,-1)*zy[3];

  zzpy[2][2]=-zy[2];
  zzpy[3][2]=-zy[3];
  zzpy[2][3]=zzpy[3][2];
  zzpy[3][3]=-tjj(0,-1)*zpy[3];
  //c1    Calculate vec{HZZ}} = vec{H} . vec{vec{zz}}=
  //               hzz[n4] ={hzzx,hzzpx,hzzy,hzzpy}[n4]
  for (i=0; i<2; ++i) { 
    hzzx[i]=h[0]*zzx[0][i];
    hzzx[i]=hzzx[i]+h[1]*zzx[1][i];
    hzzpx[i]=h[0]*zzpx[0][i];
    hzzpx[i]=hzzpx[i]+h[1]*zzpx[1][i];
  }
  for (i=2; i<4; ++i){
    hzzy[i]=h[2]*zzy[2][i];
    hzzy[i]=hzzy[i]+h[3]*zzy[3][i];
    hzzpy[i]=h[2]*zzpy[2][i];
    hzzpy[i]=hzzpy[i]+h[3]*zzpy[3][i];
  }
   
  //c---- Calculate Dpb = vec{H2} . vec{H}.[vec{H}.vec{vec{z}} 
  //c                    = Dpb{x,px,y,py}[[0][1] or [2][3]]
  dx+=0.5*(h2[0]*zx[0]+h2[1]*zx[1]+h[0]*hzzx[0]+h[1]*hzzx[1]);
  dpx+=0.5*(h2[0]*zpx[0]+h2[1]*zpx[1]+h[0]*hzzpx[0]+h[1]*hzzpx[1]);
  dy+=0.5*(h2[2]*zy[2]+h2[3]*zy[3]+h[2]*hzzy[2]+h[3]*hzzy[3]);
  dpy+=0.5*(h2[2]*zpy[2]+h2[3]*zpy[3]+h[2]*hzzpy[2]+h[3]*hzzpy[3]);
  //c******************************************************************
  //c                         end - Dpb                               *
  //c******************************************************************
  //c******************************************************************
  //c******************************************************************
  //c                                                                 *
  //c                        3pb - begin                              *
  //c                                                                 *
  //c******************************************************************
  //c---- 3pb
  //c---- Calculate vec{vec{vec{H}}} = hhh[n4][n4][n4], and vec{H3} = h3[n4]
  //c----  Calculation of vec{vec{vec{H}}}
  hhh[0][0][0]=tjj(-1,0)*dhhh[0][0][0];
  hhh[1][0][0]=-tjj(-2,0)*dhhh[1][0][0];
  hhh[2][0][0]=tjj(-1,0)*dhhh[2][0][0];
  hhh[3][0][0]=-tjj(-1,-1)*dhhh[3][0][0];
  hhh[0][1][0]=hhh[1][0][0];
  hhh[1][1][0]=-tjj(-3,0)*dhhh[1][1][0];
  hhh[2][1][0]=-tjj(-2,0)*dhhh[2][1][0];
  hhh[3][1][0]=-tjj(-2,-1)*dhhh[3][1][0];
  hhh[0][2][0]=hhh[2][0][0];
  hhh[1][2][0]=hhh[2][1][0];
  hhh[2][2][0]=tjj(-1,0)*dhhh[2][2][0];
  hhh[3][2][0]=-tjj(-1,-1)*dhhh[3][2][0];
  hhh[0][3][0]=hhh[3][0][0];
  hhh[1][3][0]=hhh[3][1][0];
  hhh[2][3][0]=hhh[3][2][0];
  hhh[3][3][0]=-tjj(-1,-2)*dhhh[3][3][0];
  hhh[0][0][1]=-dhhh[0][0][1];
  hhh[1][0][1]=-hhh[0][0][0];
  hhh[2][0][1]=-dhhh[2][0][1];
  hhh[3][0][1]=-tjj(0,-1)*dhhh[3][0][1];
  hhh[0][2][1]=hhh[2][0][1];
  hhh[1][2][1]=-hhh[2][0][0];
  hhh[2][2][1]=-dhhh[2][2][1];
  hhh[3][2][1]=-tjj(0,-1)*dhhh[3][2][1];
  hhh[0][3][1]=hhh[3][0][1];
  hhh[1][3][1]=-hhh[3][0][0];
  hhh[2][3][1]=hhh[3][2][1];
  hhh[3][3][1]=tjj(0,-2)*dhhh[3][3][1];
  hhh[0][2][2]=-hhh[3][2][1];
  hhh[1][2][2]=hhh[3][2][0];
  hhh[2][2][2]=tjj(0,-1)*dhhh[2][2][2];
  hhh[3][2][2]=-tjj(0,-2)*dhhh[3][2][2];
  hhh[0][3][2]=-hhh[3][3][1];
  hhh[1][3][2]=hhh[3][3][0];
  hhh[2][3][2]=hhh[3][2][2];
  hhh[3][3][2]=-tjj(0,-3)*dhhh[3][3][2];
  hhh[0][2][3]=hhh[2][2][1];
  hhh[1][2][3]=-hhh[2][2][0];
  hhh[2][2][3]=-dhhh[2][2][3];
  hhh[3][2][3]=-hhh[2][2][2];
     
  for (i=0; i<n4; ++i){
    
    hhh[i][1][1]=-hhh[i][0][0];
    hhh[i][0][2]=-hhh[i][3][1];
    hhh[i][1][2]=hhh[i][3][0];
    hhh[i][0][3]=hhh[i][2][1];
    hhh[i][1][3]=-hhh[i][2][0];
    hhh[i][3][3]=-hhh[i][2][2];
  }

  //c---- Calculation of vec{vec{GG3}}=vec{H} . vec{vec{vec{H}}} = gg3(j,k)
  for (k=0; k<n4; ++k){
    for (j=0; j<n4; ++j){
      gg3[j][k]=h[0]*hhh[0][j][k];
      for (i=1; i<n4; ++i){
	gg3[j][k]=gg3[j][k]+h[i]*hhh[i][j][k];
      }
    }
  }

  //c-- Calculation of vec{H3}=vec{H2}.vec{vec{H}}+vec{H}.vec{vec{G3}} = h3(k)
  for (j=0; j<n4; ++j){
    
    h3[j]=h2[0]*hh[0][j]+h[0]*gg3[0][j];
    for (i=1; i<n4; ++i){
      h3[j]=h3[j]+h2[i]*hh[i][j]+h[i]*gg3[i][j];
    }
  }

  //c********* vec{H3} calculated *********************
  //c---- Calculation of vec{vec{vec{z}}}
  zzzx[0][0][0]=zzpx[0][0];
  zzzx[0][0][1]=zzpx[0][1];
  zzzpx[0][0][0]=-zzx[0][0];
  zzzpx[0][0][1]=-zzx[0][1];
  zzzx[0][1][1]=zzpx[1][1];
  zzzpx[0][1][1]=-zzx[1][1];
  zzzx[1][1][1]=-3*tjj(-1,0)*zzx[1][1];
  zzzpx[1][1][1]=-3*tjj(-1,0)*zzpx[1][1];
  zzzx[1][0][0]=zzzx[0][0][1];
  zzzx[1][0][1]=zzzx[0][1][1];
  zzzpx[1][0][0]=zzzpx[0][0][1];
  zzzpx[1][0][1]=zzzpx[0][1][1];
  
  for (i=0;i<2;i++){
    
    zzzx[i][1][0]=zzzx[i][0][1];
    zzzpx[i][1][0]=zzzpx[i][0][1];
  }


  zzzy[2][2][2]=zzpy[2][2];
  zzzy[2][2][3]=zzpy[2][3];
  zzzpy[2][2][2]=-zzy[2][2];
  zzzpy[2][2][3]=-zzy[2][3];
  zzzy[2][3][3]=zzpy[3][3];
  zzzpy[2][3][3]=-zzy[3][3];
  zzzy[3][3][3]=-3*tjj(0,-1)*zzy[3][3];
  zzzpy[3][3][3]=-3*tjj(0,-1)*zzpy[3][3];
  zzzy[3][2][2]=zzzy[2][2][3];
  zzzy[3][2][3]=zzzy[2][3][3];
  zzzpy[3][2][2]=zzzpy[2][2][3];
  zzzpy[3][2][3]=zzzpy[2][3][3];
  for (i=2;i<4;i++){
    zzzy[i][3][2]=zzzy[i][2][3];
    zzzpy[i][3][2]=zzzpy[i][2][3];
  }
      
  //c---- Calculate hhzzz
  for(k=0;k<2;k++){
    
    hhzzzx[k]=0.0;
    hhzzzpx[k]=0.0;
    for (j=0;j<2;j++){
      for (i=0;i<2;i++){
	
	hhzzzx[k]=hhzzzx[k]+h[j]*h[i]*zzzx[i][j][k];
	hhzzzpx[k]=hhzzzpx[k]+h[j]*h[i]*zzzpx[i][j][k];
      }
    }
  }

 
  for (k=2;k<4;k++){
    hhzzzy[k]=0.0;
    hhzzzpy[k]=0.0;
    for (j=2;j<4;j++){
      for (i=2;i<4;i++){
	hhzzzy[k]=hhzzzy[k]+h[j]*h[i]*zzzy[i][j][k];
	hhzzzpy[k]=hhzzzpy[k]+h[j]*h[i]*zzzpy[i][j][k];
      }
    }
  }

  //c---- Calculate 3pb
  tpbx=h3[0]*zx[0]+3*h2[0]*hzzx[0]+h[0]*hhzzzx[0]
    +h3[1]*zx[1]+3*h2[1]*hzzx[1]+h[1]*hhzzzx[1];
  tpbpx=h3[0]*zpx[0]+3*h2[0]*hzzpx[0]+h[0]*hhzzzpx[0]
    +h3[1]*zpx[1]+3*h2[1]*hzzpx[1]+h[1]*hhzzzpx[1];
  tpby=h3[2]*zy[2]+3*h2[2]*hzzy[2]+h[2]*hhzzzy[2]
    +h3[3]*zy[3]+3*h2[3]*hzzy[3]+h[3]*hhzzzy[3];
  tpbpy=h3[2]*zpy[2]+3*h2[2]*hzzpy[2]+h[2]*hhzzzpy[2]
    +h3[3]*zpy[3]+3*h2[3]*hzzpy[3]+h[3]*hhzzzpy[3];
  dx=dx+tpbx/6;
  dpx=dpx+tpbpx/6;
  dy=dy+tpby/6;
  dpy=dpy+tpbpy/6;
  //c******************************************************************
  //c                         end - 3pb                               *
  //c******************************************************************
  //c******************************************************************
  //c******************************************************************
  //c                                                                 *
  //c                        4pb - begin          deleted             *
  //c                                                                 *
  //c******************************************************************
  //c---- 4pb
  //c---- Calculate vec{vec{vec{vec{H}}}} = hhhh[n4][n4][n4][n4], 
  //and vec{H4} = h4[n4]
 //c******************************************************************
 //c                         end - 4pb                               *
 //c******************************************************************
 //c******************************************************************
 //c******************************************************************
 //c                                                                 *
 //c                        5pb - begin          to be implemented   *
 //c                                                                 *
 //c******************************************************************
 xys[0]=xys[0]+dx;
 xys[1]=xys[1]+dpx;
 xys[2]=xys[2]+dy;
 xys[3]=xys[3]+dpy;
}

void ResMap::exph4(Vec & xys) {
  SumTable(xys[4]);
  tjj.Update(xys);
  CosSinTable::CosSinUpdate(xys);
  sines.SinUpdate();
  cosines.CosUpdate();
  //--- local array
  //    Note zx[2]=zx[3]=zpx[2]=zpx[3]=zy[0]=zy[1]=zpy[0]=zpy[1] = 0 always.
  //    SPB ******************************************************
  int i,j,k,l;   // loop index
  for (i=0; i<n4; ++i) {
    dh[i]=0.0;
    //       DPB ******************************************************
    for (j=0; j<n4; ++j) {
      dhh[i][j]=0.0;
      //          3PB ******************************************************
      for (k=0; k<n4; ++k) {
	dhhh[i][j][k]=0.0;
	//             4PB ***************************************************
	for (l=0; l<n4; ++l) {
	  dhhhh[i][j][k][l]=0.0;
	}
      }
    }
  }
  //ccccc sum over tune shift terms
  for (l=0; l<numCoefTs; ++l) {
    //    SPB ******************************************************
    cmnTs=coefTs[l]*tjj(nmxTs[l],nmyTs[l]);
    cmnxTs=nxTs[l]*cmnTs;
    cmnyTs=nyTs[l]*cmnTs;
    dh[0]=dh[0] + cmnxTs;
    dh[2]=dh[2] + cmnyTs;
    //     DPB ******************************************************
    cmnx2Ts=(nxm2Ts[l])*cmnxTs;
    dhh[1][0]=dhh[1][0]+cmnx2Ts;
    cmnxyTs=nyTs[l]*cmnxTs;
    dhh[3][0]=dhh[3][0]+cmnxyTs;
    cmny2Ts=(nym2Ts[l])*cmnyTs;
    dhh[3][2]=dhh[3][2]+cmny2Ts;
    //     3PB ******************************************************
    cmnx3Ts=nxm4Ts[l]*cmnx2Ts;
    dhhh[1][1][0]=dhhh[1][1][0]+cmnx3Ts;
    cmnx2yTs=nxm2Ts[l]*cmnxyTs;
    dhhh[3][1][0]=dhhh[3][1][0]+cmnx2yTs;
    cmnxy2Ts=nym2Ts[l]*cmnxyTs;
    dhhh[3][3][0]=dhhh[3][3][0]+cmnxy2Ts;
    cmny3Ts=nym4Ts[l]*cmny2Ts;
    dhhh[3][3][2]=dhhh[3][3][2]+cmny3Ts;
    //        4PB ************** to be implimented *********************
    cmnx4Ts=nxm6Ts[l]*cmnx3Ts;
    dhhhh[1][1][1][0]=dhhhh[1][1][1][0]+cmnx4Ts;
    cmnx3yTs=nxm4Ts[l]*cmnx2yTs;
    dhhhh[3][1][1][0]=dhhhh[3][1][1][0]+cmnx3yTs;
    cmnx2y2Ts=nxm2Ts[l]*cmnxy2Ts;
    dhhhh[3][3][1][0]=dhhhh[3][3][1][0]+cmnx2y2Ts;
    cmnxy3Ts=nym4Ts[l]*cmnxy2Ts;
    dhhhh[3][3][3][0]=dhhhh[3][3][3][0]+cmnxy3Ts;
    cmny4Ts=nym6Ts[l]*cmny3Ts;
    dhhhh[3][3][3][2]=dhhhh[3][3][3][2]+cmny4Ts;
    //        5PB ************** to be implimented *********************
  }
  // sum over resonance terms
  
  for (l=0; l<numCoef; ++l) {
    
    cmn=tjj(nmx[l],nmy[l])*(coefCos[l]*cosines(mx[l],my[l])+
			    coefSin[l]*sines(mx[l],my[l]));
    smn=tjj(nmx[l],nmy[l])*(coefSin[l]*cosines(mx[l],my[l])-
			    coefCos[l]*sines(mx[l],my[l]));
    //        SPB ******************************************************
    cmnnx=nx[l]*cmn;
    cmnny=ny[l]*cmn;
    smnmx=mx[l]*smn;
    smnmy=my[l]*smn;
    dh[0]=dh[0]+cmnnx;
    dh[1]=dh[1]+smnmx;
    dh[2]=dh[2]+cmnny;
    dh[3]=dh[3]+smnmy;
    //        DPB ******************************************************
    smxnx=nx[l]*smnmx;
    smxny=ny[l]*smnmx;
    smynx=nx[l]*smnmy;
    smyny=ny[l]*smnmy;

    cmx2=mx[l]*mx[l]*cmn;
    cmnmy=my[l]*cmn;
    cmxmy=mx[l]*cmnmy;
    cmy2=my[l]*cmnmy;
    cnx2=nxm2[l]*cmnnx;
    cnxny=nx[l]*cmnny;       
    cny2=nym2[l]*cmnny;

    dhh[0][0]=dhh[0][0]+smxnx;
    dhh[1][0]=dhh[1][0]+cnx2;
    dhh[2][0]=dhh[2][0]+smynx;
    dhh[3][0]=dhh[3][0]+cnxny;
    dhh[0][1]=dhh[0][1]+cmx2;
    dhh[2][1]=dhh[2][1]+cmxmy;
    dhh[3][1]=dhh[3][1]+smxny;
    dhh[2][2]=dhh[2][2]+smyny;
    dhh[3][2]=dhh[3][2]+cny2;
    dhh[2][3]=dhh[2][3]+cmy2;
    //        3PB ******************************************************
    smx2=mx[l]*smnmx;
    smx3=mx[l]*smx2;
    smx2my=my[l]*smx2;
    smy2=my[l]*smnmy;
    smxmy2=mx[l]*smy2;
    smxnx2=nxm2[l]*smxnx;
    smxnxny=ny[l]*smxnx;
    smxny2=nym2[l]*smxny;
    smy3=my[l]*smy2;
    smynx2=nxm2[l]*smynx;
    smynxny=ny[l]*smynx;
    smyny2=nym2[l]*smyny;

    cmx2nx=nx[l]*cmx2;
    cmx2ny=ny[l]*cmx2;
    cmxmynx=nx[l]*cmxmy;
    cmxmyny=ny[l]*cmxmy;
    cmy2nx=nx[l]*cmy2;
    cmy2ny=ny[l]*cmy2;
    cnx3=nxm4[l]*cnx2;
    cnx2ny=ny[l]*cnx2;
    cnxny2=nym2[l]*cnxny;
    cny3=nym4[l]*cny2;

    dhhh[0][0][0]=dhhh[0][0][0]+cmx2nx;
    dhhh[1][0][0]=dhhh[1][0][0]+smxnx2;
    dhhh[2][0][0]=dhhh[2][0][0]+cmxmynx;
    dhhh[3][0][0]=dhhh[3][0][0]+smxnxny;
    dhhh[1][1][0]=dhhh[1][1][0]+cnx3;
    dhhh[2][1][0]=dhhh[2][1][0]+smynx2;
    dhhh[3][1][0]=dhhh[3][1][0]+cnx2ny;
    dhhh[2][2][0]=dhhh[2][2][0]+cmy2nx;
    dhhh[3][2][0]=dhhh[3][2][0]+smynxny;
    dhhh[3][3][0]=dhhh[3][3][0]+cnxny2;
    dhhh[0][0][1]=dhhh[0][0][1]+smx3;
    dhhh[2][0][1]=dhhh[2][0][1]+smx2my;
    dhhh[3][0][1]=dhhh[3][0][1]+cmx2ny;
    dhhh[2][2][1]=dhhh[2][2][1]+smxmy2;
    dhhh[3][2][1]=dhhh[3][2][1]+cmxmyny;
    dhhh[3][3][1]=dhhh[3][3][1]+smxny2;
    dhhh[2][2][2]=dhhh[2][2][2]+cmy2ny;
    dhhh[3][2][2]=dhhh[3][2][2]+smyny2;
    dhhh[3][3][2]=dhhh[3][3][2]+cny3;
    dhhh[2][2][3]=dhhh[2][2][3]+smy3;
    //        4PB ******************************************************
    smx3nx=nx[l]*smx3;
    smx3ny=ny[l]*smx3;
    smx2mynx=nx[l]*smx2my;
    smx2myny=ny[l]*smx2my;
    smxmy3=mx[l]*smy3;
    smxmy2nx=nx[l]*smxmy2;
    smxmy2ny=ny[l]*smxmy2;
    smxnx3=nxm4[l]*smxnx2;
    smxnx2ny=ny[l]*smxnx2;
    smxnxny2=nym2[l]*smxnxny;
    smxny3=nym4[l]*smxny2;
    smy3nx=nx[l]*smy3;
    smy3ny=ny[l]*smy3;
    smynx3=nxm4[l]*smynx2;
    smynx2ny=ny[l]*smynx2;
    smynxny2=nx[l]*smyny2;
    smyny3=nym4[l]*smyny2;

    cmx4=mx[l]*mx[l]*cmx2;
    cmx2my=my[l]*cmx2;
    cmx3my=mx[l]*cmx2my;
    cmx2my2=my[l]*cmx2my;
    cmx2nx2=nxm2[l]*cmx2nx;
    cmx2nxny=ny[l]*cmx2nx;
    cmx2ny2=nym2[l]*cmx2ny;
    cmxmynx2=nxm2[l]*cmxmynx;
    cmxmynxny=ny[l]*cmxmynx;
    cmxmyny2=nym2[l]*cmxmyny;
    cmy3=my[l]*cmy2;
    cmxmy3=mx[l]*cmy3;
    cmy4=my[l]*cmy3;
    cmy2nx2=nxm2[l]*cmy2nx;
    cmy2nxny=ny[l]*cmy2nx;
    cmy2ny2=nym2[l]*cmy2ny;
    cnx4=nxm6[l]*cnx3;
    cnx3ny=ny[l]*cnx3;
    cnx2ny2=nxm2[l]*cnxny2;
    cnxny3=nx[l]*cny3;
    cny4=nym6[l]*cny3;
    
    dhhhh[0][0][0][0]=dhhhh[0][0][0][0]+smx3nx;
    dhhhh[1][0][0][0]=dhhhh[1][0][0][0]+cmx2nx2;
    dhhhh[2][0][0][0]=dhhhh[2][0][0][0]+smx2mynx;
    dhhhh[3][0][0][0]=dhhhh[3][0][0][0]+cmx2nxny;
    dhhhh[1][1][0][0]=dhhhh[1][1][0][0]+smxnx3;
    dhhhh[2][1][0][0]=dhhhh[2][1][0][0]+cmxmynx2;
    dhhhh[3][1][0][0]=dhhhh[3][1][0][0]+smxnx2ny;
    dhhhh[2][2][0][0]=dhhhh[2][2][0][0]+smxmy2nx;
    dhhhh[3][2][0][0]=dhhhh[3][2][0][0]+cmxmynxny;
    dhhhh[3][3][0][0]=dhhhh[3][3][0][0]+smxnxny2;
    dhhhh[1][1][1][0]=dhhhh[1][1][1][0]+cnx4;
    dhhhh[2][1][1][0]=dhhhh[2][1][1][0]+smynx3;
    dhhhh[3][1][1][0]=dhhhh[3][1][1][0]+cnx3ny;
    dhhhh[2][2][1][0]=dhhhh[2][2][1][0]+cmy2nx2;
    dhhhh[3][2][1][0]=dhhhh[3][2][1][0]+smynx2ny;
    dhhhh[3][3][1][0]=dhhhh[3][3][1][0]+cnx2ny2;
    dhhhh[2][2][2][0]=dhhhh[2][2][2][0]+smy3nx;
    dhhhh[3][2][2][0]=dhhhh[3][2][2][0]+cmy2nxny;
    dhhhh[3][3][2][0]=dhhhh[3][3][2][0]+smynxny2;
    dhhhh[3][3][3][0]=dhhhh[3][3][3][0]+cnxny3;
    dhhhh[0][0][0][1]=dhhhh[0][0][0][1]+cmx4;
    dhhhh[2][0][0][1]=dhhhh[2][0][0][1]+cmx3my;
    dhhhh[3][0][0][1]=dhhhh[3][0][0][1]+smx3ny;
    dhhhh[2][2][0][1]=dhhhh[2][2][0][1]+cmx2my2;
    dhhhh[3][2][0][1]=dhhhh[3][2][0][1]+smx2myny;
    dhhhh[3][3][0][1]=dhhhh[3][3][0][1]+cmx2ny2;
    dhhhh[2][2][2][1]=dhhhh[2][2][2][1]+cmxmy3;
    dhhhh[3][2][2][1]=dhhhh[3][2][2][1]+smxmy2ny;
    dhhhh[3][3][2][1]=dhhhh[3][3][2][1]+cmxmyny2;
    dhhhh[3][3][3][1]=dhhhh[3][3][3][1]+smxny3;
    dhhhh[2][2][2][2]=dhhhh[2][2][2][2]+smy3ny;
    dhhhh[3][2][2][2]=dhhhh[3][2][2][2]+cmy2ny2;
    dhhhh[3][3][2][2]=dhhhh[3][3][2][2]+smyny3;
    dhhhh[3][3][3][2]=dhhhh[3][3][3][2]+cny4;
    dhhhh[2][2][2][3]=dhhhh[2][2][2][3]+cmy4;
  }
  //*****************************************************************
  //
  //
  //                    Spb - begin                              
  //                                                               
  // *****************************************************************

  //    Calculate vec{H} =[h[0],h[1],h[2],h[3]]
  dh[0]=-dh[0]*tjj(-1,0);
  dh[2]=-dh[2]*tjj(0,-1);

  for (i=0; i<n4; ++i) {			  
    h[i]=dh[i];
  }
  //   Calculate vec{zx} =[zx[0],zx[1],0,0], and vec{zpx}, etc
  zx[0]=xys[1];
  zx[1]=xys[0]*tjj(-1,0);
  zpx[0]=-xys[0];
  zpx[1]=xys[1]*tjj(-1,0);
  zy[2]=xys[3];
  zy[3]=xys[2]*tjj(0,-1);
  zpy[2]=-xys[2];
  zpy[3]=xys[3]*tjj(0,-1);
  //---- Calculate Spb = vec{H} . vec{z} = Spb{x,px,y,py}[[0][1] or [2][3]]
  dx=h[0]*zx[0]+h[1]*zx[1];
  dpx=h[0]*zpx[0]+h[1]*zpx[1];
  dy=h[2]*zy[2]+h[3]*zy[3];
  dpy=h[2]*zpy[2]+h[3]*zpy[3];

  //c******************************************************************
  //c                         end - Spb                               *
  //c******************************************************************
  //c******************************************************************
  //c******************************************************************
  //c                                                                 *
  //c                        Dpb - begin                              *
  //c                                                                 *
  //c******************************************************************
  //c==== Calculate DPB
  //c---- Calculate vec{vec{H}} = hh[n4][n4], and vec{H2} = h2[n4]
  //c1    Calculation of vec{vec{H}}
  hh[0][0]=-tjj(-1,0)*dhh[0][0];
  hh[1][0]=-tjj(-2,0)*dhh[1][0];
  hh[2][0]=-tjj(-1,0)*dhh[2][0];
  hh[3][0]=-tjj(-1,-1)*dhh[3][0];
  hh[0][1]=-dhh[0][1];
  hh[1][1]=-hh[0][0];
  hh[2][1]=-dhh[2][1];
  hh[3][1]=tjj(0,-1)*dhh[3][1];
  hh[0][2]=-hh[3][1];
  hh[1][2]=hh[3][0];
  hh[2][2]=-tjj(0,-1)*dhh[2][2];
  hh[3][2]=-tjj(0,-2)*dhh[3][2];
  hh[0][3]=hh[2][1];
  hh[1][3]=-hh[2][0];
  hh[2][3]=-dhh[2][3];
  hh[3][3]=-hh[2][2];
  //c2    Calculation of vec{H2}=vec{H} . vec{vec{H}}
  for (i=0; i<n4; ++i) { 
    h2[i]=h[0]*hh[0][i];
    for (j=1; j<n4; ++j) {	   
      h2[i]=h2[i]+h[j]*hh[j][i];
    }
  }
  //-- Calculate vec{vec{z}} = zz[n4][n4], and vec{HZZ} = vec{H} . vec{vec{z}}
  //c1    Calculate vec{vec{z}} = zz[n4][n4] ={zzx,zzpx,zzy,zzpy}[n4][n4]
  zzx[0][0]=zpx[0];
  zzx[1][0]=zpx[1];
  zzx[0][1]=zzx[1][0];
  zzx[1][1]=-tjj(-1,0)*zx[1];

  zzpx[0][0]=-zx[0];
  zzpx[1][0]=-zx[1];
  zzpx[0][1]=zzpx[1][0];
  zzpx[1][1]=-tjj(-1,0)*zpx[1];

  zzy[2][2]=zpy[2];
  zzy[3][2]=zpy[3];
  zzy[2][3]=zzy[3][2];
  zzy[3][3]=-tjj(0,-1)*zy[3];

  zzpy[2][2]=-zy[2];
  zzpy[3][2]=-zy[3];
  zzpy[2][3]=zzpy[3][2];
  zzpy[3][3]=-tjj(0,-1)*zpy[3];
  //c1    Calculate vec{HZZ}} = vec{H} . vec{vec{zz}}=
  //               hzz[n4] ={hzzx,hzzpx,hzzy,hzzpy}[n4]
  for (i=0; i<2; ++i) { 
    hzzx[i]=h[0]*zzx[0][i];
    hzzx[i]=hzzx[i]+h[1]*zzx[1][i];
    hzzpx[i]=h[0]*zzpx[0][i];
    hzzpx[i]=hzzpx[i]+h[1]*zzpx[1][i];
  }
  for (i=2; i<4; ++i){
    hzzy[i]=h[2]*zzy[2][i];
    hzzy[i]=hzzy[i]+h[3]*zzy[3][i];
    hzzpy[i]=h[2]*zzpy[2][i];
    hzzpy[i]=hzzpy[i]+h[3]*zzpy[3][i];
  }
   
  //c---- Calculate Dpb = vec{H2} . vec{H}.[vec{H}.vec{vec{z}} 
  //c                    = Dpb{x,px,y,py}[[0][1] or [2][3]]
  dx+=0.5*(h2[0]*zx[0]+h2[1]*zx[1]+h[0]*hzzx[0]+h[1]*hzzx[1]);
  dpx+=0.5*(h2[0]*zpx[0]+h2[1]*zpx[1]+h[0]*hzzpx[0]+h[1]*hzzpx[1]);
  dy+=0.5*(h2[2]*zy[2]+h2[3]*zy[3]+h[2]*hzzy[2]+h[3]*hzzy[3]);
  dpy+=0.5*(h2[2]*zpy[2]+h2[3]*zpy[3]+h[2]*hzzpy[2]+h[3]*hzzpy[3]);
  //c******************************************************************
  //c                         end - Dpb                               *
  //c******************************************************************
  //c******************************************************************
  //c******************************************************************
  //c                                                                 *
  //c                        3pb - begin                              *
  //c                                                                 *
  //c******************************************************************
  //c---- 3pb
  //c---- Calculate vec{vec{vec{H}}} = hhh[n4][n4][n4], and vec{H3} = h3[n4]
  //c----  Calculation of vec{vec{vec{H}}}
  hhh[0][0][0]=tjj(-1,0)*dhhh[0][0][0];
  hhh[1][0][0]=-tjj(-2,0)*dhhh[1][0][0];
  hhh[2][0][0]=tjj(-1,0)*dhhh[2][0][0];
  hhh[3][0][0]=-tjj(-1,-1)*dhhh[3][0][0];
  hhh[0][1][0]=hhh[1][0][0];
  hhh[1][1][0]=-tjj(-3,0)*dhhh[1][1][0];
  hhh[2][1][0]=-tjj(-2,0)*dhhh[2][1][0];
  hhh[3][1][0]=-tjj(-2,-1)*dhhh[3][1][0];
  hhh[0][2][0]=hhh[2][0][0];
  hhh[1][2][0]=hhh[2][1][0];
  hhh[2][2][0]=tjj(-1,0)*dhhh[2][2][0];
  hhh[3][2][0]=-tjj(-1,-1)*dhhh[3][2][0];
  hhh[0][3][0]=hhh[3][0][0];
  hhh[1][3][0]=hhh[3][1][0];
  hhh[2][3][0]=hhh[3][2][0];
  hhh[3][3][0]=-tjj(-1,-2)*dhhh[3][3][0];
  hhh[0][0][1]=-dhhh[0][0][1];
  hhh[1][0][1]=-hhh[0][0][0];
  hhh[2][0][1]=-dhhh[2][0][1];
  hhh[3][0][1]=-tjj(0,-1)*dhhh[3][0][1];
  hhh[0][2][1]=hhh[2][0][1];
  hhh[1][2][1]=-hhh[2][0][0];
  hhh[2][2][1]=-dhhh[2][2][1];
  hhh[3][2][1]=-tjj(0,-1)*dhhh[3][2][1];
  hhh[0][3][1]=hhh[3][0][1];
  hhh[1][3][1]=-hhh[3][0][0];
  hhh[2][3][1]=hhh[3][2][1];
  hhh[3][3][1]=tjj(0,-2)*dhhh[3][3][1];
  hhh[0][2][2]=-hhh[3][2][1];
  hhh[1][2][2]=hhh[3][2][0];
  hhh[2][2][2]=tjj(0,-1)*dhhh[2][2][2];
  hhh[3][2][2]=-tjj(0,-2)*dhhh[3][2][2];
  hhh[0][3][2]=-hhh[3][3][1];
  hhh[1][3][2]=hhh[3][3][0];
  hhh[2][3][2]=hhh[3][2][2];
  hhh[3][3][2]=-tjj(0,-3)*dhhh[3][3][2];
  hhh[0][2][3]=hhh[2][2][1];
  hhh[1][2][3]=-hhh[2][2][0];
  hhh[2][2][3]=-dhhh[2][2][3];
  hhh[3][2][3]=-hhh[2][2][2];
     
  for (i=0; i<n4; ++i){
    
    hhh[i][1][1]=-hhh[i][0][0];
    hhh[i][0][2]=-hhh[i][3][1];
    hhh[i][1][2]=hhh[i][3][0];
    hhh[i][0][3]=hhh[i][2][1];
    hhh[i][1][3]=-hhh[i][2][0];
    hhh[i][3][3]=-hhh[i][2][2];
  }

  //c---- Calculation of vec{vec{GG3}}=vec{H} . vec{vec{vec{H}}} = gg3(j,k)
  for (k=0; k<n4; ++k){
    for (j=0; j<n4; ++j){
      gg3[j][k]=h[0]*hhh[0][j][k];
      for (i=1; i<n4; ++i){
	gg3[j][k]=gg3[j][k]+h[i]*hhh[i][j][k];
      }
    }
  }

  //c-- Calculation of vec{H3}=vec{H2}.vec{vec{H}}+vec{H}.vec{vec{G3}} = h3(k)
  for (j=0; j<n4; ++j){
    
    h3[j]=h2[0]*hh[0][j]+h[0]*gg3[0][j];
    for (i=1; i<n4; ++i){
      h3[j]=h3[j]+h2[i]*hh[i][j]+h[i]*gg3[i][j];
    }
  }

  //c********* vec{H3} calculated *********************
  //c---- Calculation of vec{vec{vec{z}}}
  zzzx[0][0][0]=zzpx[0][0];
  zzzx[0][0][1]=zzpx[0][1];
  zzzpx[0][0][0]=-zzx[0][0];
  zzzpx[0][0][1]=-zzx[0][1];
  zzzx[0][1][1]=zzpx[1][1];
  zzzpx[0][1][1]=-zzx[1][1];
  zzzx[1][1][1]=-3*tjj(-1,0)*zzx[1][1];
  zzzpx[1][1][1]=-3*tjj(-1,0)*zzpx[1][1];
  zzzx[1][0][0]=zzzx[0][0][1];
  zzzx[1][0][1]=zzzx[0][1][1];
  zzzpx[1][0][0]=zzzpx[0][0][1];
  zzzpx[1][0][1]=zzzpx[0][1][1];
  
  for (i=0;i<2;i++){
    
    zzzx[i][1][0]=zzzx[i][0][1];
    zzzpx[i][1][0]=zzzpx[i][0][1];
  }


  zzzy[2][2][2]=zzpy[2][2];
  zzzy[2][2][3]=zzpy[2][3];
  zzzpy[2][2][2]=-zzy[2][2];
  zzzpy[2][2][3]=-zzy[2][3];
  zzzy[2][3][3]=zzpy[3][3];
  zzzpy[2][3][3]=-zzy[3][3];
  zzzy[3][3][3]=-3*tjj(0,-1)*zzy[3][3];
  zzzpy[3][3][3]=-3*tjj(0,-1)*zzpy[3][3];
  zzzy[3][2][2]=zzzy[2][2][3];
  zzzy[3][2][3]=zzzy[2][3][3];
  zzzpy[3][2][2]=zzzpy[2][2][3];
  zzzpy[3][2][3]=zzzpy[2][3][3];
  for (i=2;i<4;i++){
    zzzy[i][3][2]=zzzy[i][2][3];
    zzzpy[i][3][2]=zzzpy[i][2][3];
  }
      
  //c---- Calculate hhzzz
  for(k=0;k<2;k++){
    
    hhzzzx[k]=0.0;
    hhzzzpx[k]=0.0;
    for (j=0;j<2;j++){
      for (i=0;i<2;i++){
	
	hhzzzx[k]=hhzzzx[k]+h[j]*h[i]*zzzx[i][j][k];
	hhzzzpx[k]=hhzzzpx[k]+h[j]*h[i]*zzzpx[i][j][k];
      }
    }
  }

 
  for (k=2;k<4;k++){
    hhzzzy[k]=0.0;
    hhzzzpy[k]=0.0;
    for (j=2;j<4;j++){
      for (i=2;i<4;i++){
	hhzzzy[k]=hhzzzy[k]+h[j]*h[i]*zzzy[i][j][k];
	hhzzzpy[k]=hhzzzpy[k]+h[j]*h[i]*zzzpy[i][j][k];
      }
    }
  }

  //c---- Calculate 3pb
  tpbx=h3[0]*zx[0]+3*h2[0]*hzzx[0]+h[0]*hhzzzx[0]
    +h3[1]*zx[1]+3*h2[1]*hzzx[1]+h[1]*hhzzzx[1];
  tpbpx=h3[0]*zpx[0]+3*h2[0]*hzzpx[0]+h[0]*hhzzzpx[0]
    +h3[1]*zpx[1]+3*h2[1]*hzzpx[1]+h[1]*hhzzzpx[1];
  tpby=h3[2]*zy[2]+3*h2[2]*hzzy[2]+h[2]*hhzzzy[2]
    +h3[3]*zy[3]+3*h2[3]*hzzy[3]+h[3]*hhzzzy[3];
  tpbpy=h3[2]*zpy[2]+3*h2[2]*hzzpy[2]+h[2]*hhzzzpy[2]
    +h3[3]*zpy[3]+3*h2[3]*hzzpy[3]+h[3]*hhzzzpy[3];
  dx=dx+tpbx/6;
  dpx=dpx+tpbpx/6;
  dy=dy+tpby/6;
  dpy=dpy+tpbpy/6;
  //c******************************************************************
  //c                         end - 3pb                               *
  //c******************************************************************
  //c******************************************************************
  //c******************************************************************
  //c                                                                 *
  //c                        4pb - begin                              *
  //c                                                                 *
  //c******************************************************************
  //c---- 4pb
  //c---- Calculate vec{vec{vec{vec{H}}}} = hhhh[n4][n4][n4][n4], 
  //and vec{H4} = h4[n4]
  //c----  Calculation of ve{vec{vec{vec{H}}}}
  hhhh[0][0][0][0]=tjj(-1,0)*dhhhh[0][0][0][0];
  hhhh[1][0][0][0]=tjj(-2,0)*dhhhh[1][0][0][0];
  hhhh[2][0][0][0]=tjj(-1,0)*dhhhh[2][0][0][0];
  hhhh[3][0][0][0]=tjj(-1,-1)*dhhhh[3][0][0][0];
  hhhh[0][1][0][0]=hhhh[1][0][0][0];
  hhhh[1][1][0][0]=-tjj(-3,0)*dhhhh[1][1][0][0];
  hhhh[2][1][0][0]=tjj(-2,0)*dhhhh[2][1][0][0];
  hhhh[3][1][0][0]=-tjj(-2,-1)*dhhhh[3][1][0][0];
  hhhh[0][2][0][0]=hhhh[2][0][0][0];
  hhhh[1][2][0][0]=hhhh[2][1][0][0];
  hhhh[2][2][0][0]=tjj(-1,0)*dhhhh[2][2][0][0];
  hhhh[3][2][0][0]=tjj(-1,-1)*dhhhh[3][2][0][0];
  hhhh[0][3][0][0]=hhhh[3][0][0][0];
  hhhh[1][3][0][0]=hhhh[3][1][0][0];
  hhhh[2][3][0][0]=hhhh[3][2][0][0];
  hhhh[3][3][0][0]=-tjj(-1,-2)*dhhhh[3][3][0][0];
  for (i=0;i<n4;i++){
    hhhh[i][0][1][0]=hhhh[i][1][0][0];
  }
  
  hhhh[0][1][1][0]=hhhh[1][1][0][0];
  hhhh[1][1][1][0]=-tjj(-4,0)*dhhhh[1][1][1][0];
  hhhh[2][1][1][0]=-tjj(-3,0)*dhhhh[2][1][1][0];
  hhhh[3][1][1][0]=-tjj(-3,-1)*dhhhh[3][1][1][0];
  hhhh[0][2][1][0]=hhhh[2][1][0][0];
  hhhh[1][2][1][0]=hhhh[2][1][1][0];
  hhhh[2][2][1][0]=tjj(-2,0)*dhhhh[2][2][1][0];
  hhhh[3][2][1][0]=-tjj(-2,-1)*dhhhh[3][2][1][0];
  hhhh[0][3][1][0]=hhhh[3][1][0][0];
  hhhh[1][3][1][0]=hhhh[3][1][1][0];
  hhhh[2][3][1][0]=hhhh[3][2][1][0];
  hhhh[3][3][1][0]=-tjj(-2,-2)*dhhhh[3][3][1][0];
  for (i=0;i<n4;i++){
    hhhh[i][0][2][0]=hhhh[i][2][0][0];
    hhhh[i][1][2][0]=hhhh[i][2][1][0];
  }
  
  hhhh[0][2][2][0]=hhhh[2][2][0][0];
  hhhh[1][2][2][0]=hhhh[2][2][1][0];
  hhhh[2][2][2][0]=tjj(-1,0)*dhhhh[2][2][2][0];
  hhhh[3][2][2][0]=tjj(-1,-1)*dhhhh[3][2][2][0];
  hhhh[0][3][2][0]=hhhh[3][2][0][0];
  hhhh[1][3][2][0]=hhhh[3][2][1][0];
  hhhh[2][3][2][0]=hhhh[3][2][2][0];
  hhhh[3][3][2][0]=-tjj(-1,-2)*dhhhh[3][3][2][0];
  for (i=0;i<n4;i++){
    hhhh[i][0][3][0]=hhhh[i][3][0][0];
    hhhh[i][1][3][0]=hhhh[i][3][1][0];
    hhhh[i][2][3][0]=hhhh[i][3][2][0];
  }
  
  hhhh[0][3][3][0]=hhhh[3][3][0][0];
  hhhh[1][3][3][0]=hhhh[3][3][1][0];
  hhhh[2][3][3][0]=hhhh[3][3][2][0];
  hhhh[3][3][3][0]=-tjj(-1,-3)*dhhhh[3][3][3][0];
  hhhh[0][0][0][1]=dhhhh[0][0][0][1];
  hhhh[1][0][0][1]=-hhhh[0][0][0][0];
  hhhh[2][0][0][1]=dhhhh[2][0][0][1];
  hhhh[3][0][0][1]=-tjj(0,-1)*dhhhh[3][0][0][1];
  for (i=0;i<n4;i++){
    
    hhhh[i][1][0][1]=-hhhh[i][0][0][0];
  }
  hhhh[0][2][0][1]=hhhh[2][0][0][1];
  hhhh[1][2][0][1]=hhhh[2][1][0][1];
  hhhh[2][2][0][1]=dhhhh[2][2][0][1];
  hhhh[3][2][0][1]=-tjj(0,-1)*dhhhh[3][2][0][1];
  hhhh[0][3][0][1]=hhhh[3][0][0][1];
  hhhh[1][3][0][1]=hhhh[3][1][0][1];
  hhhh[2][3][0][1]=hhhh[3][2][0][1];
  hhhh[3][3][0][1]=-tjj(0,-2)*dhhhh[3][3][0][1];
  for (i=0;i<n4;i++){
    for(j=0;j<n4;j++){
      hhhh[i][j][1][1]=-hhhh[i][j][0][0];
    }
    hhhh[i][0][2][1]=hhhh[i][2][0][1];
    hhhh[i][1][2][1]=-hhhh[i][2][0][0];
  }
  
  hhhh[0][2][2][1]=hhhh[2][0][2][1];
  hhhh[1][2][2][1]=hhhh[2][1][2][1];
  hhhh[2][2][2][1]=dhhhh[2][2][2][1];
  hhhh[3][2][2][1]=-tjj(0,-1)*dhhhh[3][2][2][1];
  hhhh[0][3][2][1]=hhhh[3][0][2][1];
  hhhh[1][3][2][1]=hhhh[3][1][2][1];
  hhhh[2][3][2][1]=hhhh[3][2][2][1];
  hhhh[3][3][2][1]=-tjj(0,-2)*dhhhh[3][3][2][1];
  for(i=0;i<n4;i++){
    
    hhhh[i][0][3][1]=hhhh[i][3][0][1];
    hhhh[i][1][3][1]=-hhhh[i][3][0][0];
    hhhh[i][2][3][1]=hhhh[i][3][2][1];
  }

  hhhh[0][3][3][1]=hhhh[3][3][0][1];
  hhhh[1][3][3][1]=hhhh[3][3][1][1];
  hhhh[2][3][3][1]=hhhh[3][3][2][1];
  hhhh[3][3][3][1]=tjj(0,-3)*dhhhh[3][3][3][1];
  // begin
  for (i=0;i<n4;i++){
    for(j=0;j<n4;j++){
      hhhh[i][j][0][2]=-hhhh[i][j][3][1];
      hhhh[i][j][1][2]=hhhh[i][j][3][0];
    }
    
    hhhh[i][0][2][2]=-hhhh[i][3][2][1];
    hhhh[i][1][2][2]=hhhh[i][3][2][0];
  }

  hhhh[0][2][2][2]=hhhh[2][2][0][2];
  hhhh[1][2][2][2]=hhhh[2][2][1][2];
  hhhh[2][2][2][2]=tjj(0,-1)*dhhhh[2][2][2][2];
  hhhh[3][2][2][2]=tjj(0,-2)*dhhhh[3][2][2][2];
  hhhh[0][3][2][2]=hhhh[3][2][0][2];
  hhhh[1][3][2][2]=hhhh[3][2][1][2];
  hhhh[2][3][2][2]=hhhh[3][2][2][2];
  hhhh[3][3][2][2]=-tjj(0,-3)*dhhhh[3][3][2][2];

  for (i=0;i<n4;i++){
    hhhh[i][0][3][2]=-hhhh[i][3][3][1];
    hhhh[i][1][3][2]=hhhh[i][3][3][0];
    hhhh[i][2][3][2]=hhhh[i][3][2][2];
  }
  hhhh[0][3][3][2]=hhhh[3][3][0][2];
  hhhh[1][3][3][2]=hhhh[3][3][1][2];
  hhhh[2][3][3][2]=hhhh[3][3][2][2];
  hhhh[3][3][3][2]=-tjj(0,-4)*dhhhh[3][3][3][2];

// stop here
  for(i=0;i<n4;i++){ 
    for(j=0;j<n4;j++){
      
     
      hhhh[i][j][0][3]=hhhh[i][j][2][1];
      hhhh[i][j][1][3]=-hhhh[i][j][2][0];
    }
    hhhh[i][0][2][3]=hhhh[i][2][2][1];
    hhhh[i][1][2][3]=-hhhh[i][2][2][0];
  }
  hhhh[0][2][2][3]=hhhh[2][2][0][3];
  hhhh[1][2][2][3]=hhhh[2][2][1][3];
  hhhh[2][2][2][3]=dhhhh[2][2][2][3];
  hhhh[3][2][2][3]=-hhhh[2][2][2][2];
  
  for(i=0;i<n4;i++){
    hhhh[i][3][2][3]=-hhhh[i][2][2][2];
    for (j=0;j<n4;j++){     
      hhhh[i][j][3][3]=-hhhh[i][j][2][2];
    }
  }
 
  
  //c-- Calculation of vec{vec{GG4}=vec{H} . vec{vec{vec{vec{H}}}} = gg4(k,l)
  for(l=0;l<n4;l++){
    for(k=0;k<n4;k++){ 
      gg4[k][l]=0.0;
      for(j=0;j<n4;j++){ 
	ggg4[j][k][l]=h[0]*hhhh[0][j][k][l];
	for(i=1;i<n4;i++){ 
	  ggg4[j][k][l]=ggg4[j][k][l]+h[i]*hhhh[i][j][k][l];
	}  
	
	gg4[k][l]=gg4[k][l]+h[j]*ggg4[j][k][l];
      }
    }
  }
    //c---- Calculation of vec{H4}=vec{H3}.vec{vec{H}}+3vec{H2}.vec{vec{GG3}}
  //c                            + vec{H} . vec{vec{GG4}} = h4(k)
 
 for(j=0;j<n4;j++){
   
   h4[j]=h3[0]*hh[0][j]+3*h2[0]*gg3[0][j]+h[0]*gg4[0][j];
     for(i=1;i<n4;i++){
       h4[j]=h4[j]+h3[i]*hh[i][j]+3*h2[i]*gg3[i][j]+h[i]*gg4[i][j];
     }
 }


 //c********* vec{H4} calculated *********************
 //c---- Calculation of vec{vec{vec{z}}}
 zzzzx[0][0][0][0]=zzzpx[0][0][0];
 zzzzx[0][0][0][1]=zzzpx[0][0][1];
 zzzzpx[0][0][0][0]=-zzzx[0][0][0];
 zzzzpx[0][0][0][1]=-zzzx[0][0][1];
 zzzzx[0][0][1][1]=zzzpx[0][1][1];
 zzzzpx[0][0][1][1]=-zzzx[0][1][1];
 zzzzx[0][1][1][1]=zzzpx[1][1][1];
 zzzzpx[0][1][1][1]=-zzzx[1][1][1];
 zzzzx[1][1][1][1]=-5*tjj(-1,0)*zzzx[1][1][1];
 zzzzpx[1][1][1][1]=-5*tjj(-1,0)*zzzpx[1][1][1];
 zzzzx[1][0][0][0]=zzzzx[0][0][0][1];
 zzzzx[1][0][0][1]=zzzzx[0][0][1][1];
 zzzzx[1][0][1][1]=zzzzx[0][1][1][1];
 zzzzpx[1][0][0][0]=zzzzpx[0][0][0][1];
 zzzzpx[1][0][0][1]=zzzzpx[0][0][1][1];
 zzzzpx[1][0][1][1]=zzzzpx[0][1][1][1];
 for (i=0;i<2;i++){
   zzzzx[i][1][0][0]=zzzzx[i][0][0][1];
   zzzzx[i][1][0][1]=zzzzx[i][0][1][1];
   zzzzpx[i][1][0][0]=zzzzpx[i][0][0][1];
   zzzzpx[i][1][0][1]=zzzzpx[i][0][1][1];
   for (j=0;j<2;j++){
   
   zzzzx[i][j][1][0]=zzzzx[i][j][0][1];
   zzzzpx[i][j][1][0]=zzzzpx[i][j][0][1];
   }
 }

 zzzzy[2][2][2][2]=zzzpy[2][2][2];
 zzzzy[2][2][2][3]=zzzpy[2][2][3];
 zzzzpy[2][2][2][2]=-zzzy[2][2][2];
 zzzzpy[2][2][2][3]=-zzzy[2][2][3];
 zzzzy[2][2][3][3]=zzzpy[2][3][3];
 zzzzpy[2][2][3][3]=-zzzy[2][3][3];
 zzzzy[2][3][3][3]=zzzpy[3][3][3];
 zzzzpy[2][3][3][3]=-zzzy[3][3][3];
 zzzzy[3][3][3][3]=-5*tjj(0,-1)*zzzy[3][3][3];
 zzzzpy[3][3][3][3]=-5*tjj(0,-1)*zzzpy[3][3][3];
 zzzzy[3][2][2][2]=zzzzy[2][2][2][3];
 zzzzy[3][2][2][3]=zzzzy[2][2][3][3];
 zzzzy[3][2][3][3]=zzzzy[2][3][3][3];
 zzzzpy[3][2][2][2]=zzzzpy[2][2][2][3];
 zzzzpy[3][2][2][3]=zzzzpy[2][2][3][3];
 zzzzpy[3][2][3][3]=zzzzpy[2][3][3][3];
 for (i=2;i<4;i++){
   zzzzy[i][3][2][2]=zzzzy[i][2][2][3];
   zzzzy[i][3][2][3]=zzzzy[i][2][3][3];
   zzzzpy[i][3][2][2]=zzzzpy[i][2][2][3];
   zzzzpy[i][3][2][3]=zzzzpy[i][2][3][3];
   for (j=2;j<4;j++){
     zzzzy[i][j][3][2]=zzzzy[i][j][2][3];
     zzzzpy[i][j][3][2]=zzzzpy[i][j][2][3];
   }
 }
 //c---- Calculate hhhzzzz
 
 for (l=0;l<2;l++){
   hhhzzzzx[l]=0.0;
   hhhzzzzpx[l]=0.0;
   for (k=0;k<2;k++){
     for (j=0;j<2;j++){
       for (i=0;i<2;i++){
	 
	 hhhzzzzx[l]=hhhzzzzx[l]+h[k]*h[j]*h[i]*zzzzx[i][j][k][l];
	 hhhzzzzpx[l]=hhhzzzzpx[l]+h[k]*h[j]*h[i]*zzzzpx[i][j][k][l];
       }
     }
   }
 }
 

 for (l=2;l<4;l++){
   hhhzzzzy[l]=0.0;
   hhhzzzzpy[l]=0.0;
   for (k=2;k<4;k++){
     for (j=2;j<4;j++){
       for (i=2;i<4;i++){
	 
	 hhhzzzzy[l]=hhhzzzzy[l]+h[k]*h[j]*h[i]*zzzzy[i][j][k][l];
	 hhhzzzzpy[l]=hhhzzzzpy[l]+h[k]*h[j]*h[i]*zzzzpy[i][j][k][l];
       }
     }
   }
 }
 //c---- Calculate vec{h2zz} = vec{H2} . vec{vec{zz}}
 for (i=0;i<2;i++){
   h2zzx[i]=h2[0]*zzx[0][i]+h2[1]*zzx[1][i];
   h2zzpx[i]=h2[0]*zzpx[0][i]+h2[1]*zzpx[1][i];
 }
 for (i=2;i<4;i++){
   h2zzy[i]=h2[2]*zzy[2][i]+h2[3]*zzy[3][i];
   h2zzpy[i]=h2[2]*zzpy[2][i]+h2[3]*zzpy[3][i];
 }
 //c---- Calculate 4pb
 tpbx=h4[0]*zx[0]+4*h3[0]*hzzx[0]+3*h2[0]*h2zzx[0]
   +6*h2[0]*hhzzzx[0]+h[0]*hhhzzzzx[0]
   +h4[1]*zx[1]+4*h3[1]*hzzx[1]+3*h2[1]*h2zzx[1]
   +6*h2[1]*hhzzzx[1]+h[1]*hhhzzzzx[1];
 tpbpx=h4[0]*zpx[0]+4*h3[0]*hzzpx[0]+3*h2[0]*h2zzpx[0]
   +6*h2[0]*hhzzzpx[0]+h[0]*hhhzzzzpx[0]
   +h4[1]*zpx[1]+4*h3[1]*hzzpx[1]+3*h2[1]*h2zzpx[1]
   +6*h2[1]*hhzzzpx[1]+h[1]*hhhzzzzpx[1];
 tpby=h4[2]*zy[2]+4*h3[2]*hzzy[2]+3*h2[2]*h2zzy[2]
   +6*h2[2]*hhzzzy[2]+h[2]*hhhzzzzy[2]
   +h4[3]*zy[3]+4*h3[3]*hzzy[3]+3*h2[3]*h2zzy[3]
   +6*h2[3]*hhzzzy[3]+h[3]*hhhzzzzy[3];
 tpbpy=h4[2]*zpy[2]+4*h3[2]*hzzpy[2]+3*h2[2]*h2zzpy[2]
   +6*h2[2]*hhzzzpy[2]+h[2]*hhhzzzzpy[2]
   +h4[3]*zpy[3]+4*h3[3]*hzzpy[3]+3*h2[3]*h2zzpy[3]
   +6*h2[3]*hhzzzpy[3]+h[3]*hhhzzzzpy[3];
 //101  format(4e13.4)
 dx=dx+tpbx/24;
 dpx=dpx+tpbpx/24;
 dy=dy+tpby/24;
 dpy=dpy+tpbpy/24;
 //c******************************************************************
 //c                         end - 4pb                               *
 //c******************************************************************

 xys[0]=xys[0]+dx;
 xys[1]=xys[1]+dpx;
 xys[2]=xys[2]+dy;
 xys[3]=xys[3]+dpy;
}

ResMapLn45::ResMapLn45(const Vps& uu) {
     DepritLieLn45 dl(uu);
     AA = dl.getAA();
     RR = dl.getRR();
     AI = dl.getAI();
     resmap.getResMap(dl.getff());
     //     ofstream fout("tbd2.out");
     //     fout << resmap;
}

// added by Peace on Aug. 26, 1999
// revised by Yiton on Sep. 16, 1999
void ResMapLn45::ResTrackn(Vec& xys, int n) {
  xys = AI*xys;
  xys = RR*xys;
  if (n==3) resmap.exph3(xys);
  else if (n==4) resmap.exph4(xys);
  else if (n==2) resmap.exph2(xys);
  else if (n==1) resmap.exph1(xys);
  else {
    cerr << n << "PB is not available \n";
    exit(1);
  }
  xys = AA*xys;
}

void ResMapLn45::ResTrack(Vec& xys) {
  xys = AI*xys;
  xys = RR*xys;
  resmap.exph4(xys);
  xys = AA*xys;
}

ostream& operator<<(ostream& out, const ResMapLn45& zz) {
  out << zz.AA;
  out << zz.RR;
  out << zz.AI;
  out << zz.resmap;
  return out;
}

istream& operator>>(istream& in,  ResMapLn45& zz) {
  in >> zz.AA;
  in >> zz.RR;
  in >> zz.AI;
  in >> zz.resmap;
  return in;
}
