#include "doubleMatrix.hpp"
#include "Tps.hpp"

int Mdata::TotalCountdoubleMatrix = 0;

  void Mdata::operator++() { ++count; ++TotalCountdoubleMatrix; } // prefix
  void Mdata::operator++(int) { ++count; ++TotalCountdoubleMatrix; } // postfix
  void Mdata::operator--() { --count; --TotalCountdoubleMatrix; }
  void Mdata::operator--(int) { --count; --TotalCountdoubleMatrix; }

Mdata::Mdata(): r(1), c(1), v(new double *[1]), count(1) {
     ++TotalCountdoubleMatrix;
     rc = r*c;
     v[0] = new double [rc];
     int i;  // index
     for (i=1; i < r; ++i) v[i] = v[i-1] + c;
     for (i=0; i < rc; ++i) v[0][i] =   0.0;
}

Mdata::Mdata(int _r, int _c): r(_r), c(_c), v(new double *[_r]), count(1) {
     ++TotalCountdoubleMatrix;
     rc = r*c;
     v[0] = new double [rc];
     int i;  // index
     for (i=1; i < r; ++i) v[i] = v[i-1] + c;
     for (i=0; i < rc; ++i) v[0][i] =   0.0;
}

Mdata::Mdata(const Mdata &_v):r(_v.r), c(_v.c), v(new double *[_v.r]), count(1)
{
     ++TotalCountdoubleMatrix;
     rc = r*c;
     v[0] = new double [rc];
     for (int i=1; i < r; ++i) v[i] = v[i-1] + c;
     //     for (int i=0; i < rc; ++i) v[0][i] = _v.v[0][i];
     memcpy(v[0], _v.v[0] , rc*sizeof(double));
}

Mdata:: ~Mdata() {
     delete [] v[0];
     delete [] v;
}

Mdata & Mdata::operator = (const Mdata &_v) {
    if (v != _v.v) {
      if (r != _v.r || c != _v.c) {
        delete [] v[0];
        delete [] v;
        r = _v.r;
        c = _v.c;
        rc = r*c;
        v = new double*[r];
        v[0] = new double [rc];
        for (int i=1; i < r; ++i) v[i] = v[i-1] + c;
      }
      count = 1;
      memcpy(*v, *_v.v , rc*sizeof(double));
    }
    return *this;
}

int doubleMatrix::ROW = 4;
int doubleMatrix::COL = 4;

doubleMatrix::doubleMatrix() : v(new Mdata(ROW,COL)) {}

doubleMatrix::doubleMatrix(int r, int c, int R, int C) : v(new Mdata(r,c)) {
  ROW = R;       
  COL = C;
}

doubleMatrix::doubleMatrix(int n) : v(new Mdata(2*n,2*n)) {
  for (int i=0; i < n; ++i) {     
      int j = 2*i;
      int k = j+1;
      (*v)(j,k) = 1;
      (*v)(k,j) = -1;
  }
}

doubleMatrix::doubleMatrix(int n, double d) : v(new Mdata(n,n)) {
  for (int i=0; i < n; ++i) {     
      (*v)(i,i) = d;
  }
}

doubleMatrix::doubleMatrix(double d) : v(new Mdata(ROW,ROW)) {
  for (int i=0; i < ROW; ++i) {     
      (*v)(i,i) = d;
  }
}

/*
doubleMatrix::doubleMatrix(const Matrix& M) // interface with Lego
{
  cout << " here **************\n";
  int row = M.GetRow();
  int col = M.GetCol();
  v = new Mdata(row,col);
  for (int i=0; i<row; ++i)
    {
      for (int j=0; j<col; ++j)
	{
	  (*v)(i,j) = M(i+1, j+1);
	}
    }	  
  cout << " here here **************\n";
}
*/
doubleMatrix& doubleMatrix::memConstruct(int r, int c) {
    if (!(v->OnlyOne())) {
      --(*v);
    } else {
      delete v;
    }
    v = new Mdata(r,c);
    return *this;
}

double & doubleMatrix::operator () (int i, int j) {
    if (!(v->OnlyOne())) {
      --(*v);
      v=new Mdata(*v);
    }
    return (*v)(i,j);
}

double& doubleMatrix::A(int i, int j) {
    if (!(v->OnlyOne())) {
      --(*v);
      v=new Mdata(*v);
    }
    return (*v)(i-1,j-1);
}

doubleMatrix& doubleMatrix::operator=(const doubleMatrix& _v) {
    if (v != _v.v) {
      --(*v);
      if (v->AllGone()) delete v;
      v=_v.v;
      ++(*v);
    }
    return *this;
}
/*
doubleMatrix& doubleMatrix::operator=(const Matrix& M) { // Interact with LEGO
  int r=M.GetRow();
  int c=M.GetCol();
  doubleMatrix MM(r,c);
  for (int i=0; i<r; ++i) {
    for (int j=0; j<c; ++j) {
      MM(i,j) = M[i*c+j];
    }
  }
  *this = MM;
  return *this;
}
*/
doubleMatrix doubleMatrix::subMatrix(int ri, int re, int ci, int ce) const {
     if (re > Row() || ce > Col()) {
       cerr << " Error in doubleMatrix:: "
            << " subMatrix(int ri, int re, int ci, int ce) const\n";
       exit(1);
     }
     doubleMatrix MM(re-ri+1,ce-ci+1);
     for (int i=ri; i<=re; ++i) {
       for (int j=ci; j<=ce; ++j) {
	 MM(i-ri,j-ci) = (*this)(i,j);
       }
     }	 
     return MM;
}

doubleMatrix doubleMatrix::subMatrix(int r, int c) const {
     return this->subMatrix(0,r-1,0,c-1);
}

doubleMatrix doubleMatrix::expandToSquare(int s) const {
  doubleMatrix M(s,1.0);
  for (int i=0; i<Row(); ++i) 
    {
      for (int j=0; j<Col(); ++j) M(i,j) = (*this)(i,j);
    }
  return M;
}

Vec doubleMatrix::getColVec(int ri, int re, int c) const {
     if (re > Row() || c > Col()) {
       cerr << " Error in  Vec doubleMatrix:: "
            << " getColVec(int ri, int re, int c) const\n";
       exit(1);
     }
     Vec V(re-ri+1);
     for (int i=ri; i<=re; ++i) {
	 V[i-ri] = (*this)(i,c);
     }	 
     return V;
}

Vec doubleMatrix::getColVec(int c) const {
     if (c > Col()) {
       cerr << " Error in  Vec doubleMatrix:: "
            << " getColVec(int c) const\n";
       exit(1);
     }
     Vec V(Row());
     for (int i=0; i<Row(); ++i) {
	 V[i] = (*this)(i,c);
     }	 
     return V;
}

Vec doubleMatrix::getRowVec(int r, int ci, int ce) const {
     if (r > Row() || ce > Col()) {
       cerr << " Error in  Vec doubleMatrix:: "
            << " getRowVec(int ri, int re, int c) const\n";
       exit(1);
     }
     Vec V(ce-ci+1);
     for (int i=ci; i<=ce; ++i) {
	 V[i-ci] = (*this)(r,i);
     }	 
     return V;
}

Vec doubleMatrix::getRowVec(int r) const {
     if (r > Row()) {
       cerr << " Error in  Vec doubleMatrix:: "
            << " getRowVec(int r) const\n";
       exit(1);
     }
     Vec V(Col());
     for (int i=0; i<Col(); ++i) {
	 V[i] = (*this)(r,i);
     }	 
     return V;
}

doubleMatrix doubleMatrix::expandMatrix(int ri, int ci, int re, int ce) const {
     doubleMatrix MM(re+1,ce+1);
     int rend = min( ri+Row()-1, re );
     int cend = min( ci+Col()-1, ce );
     for (int i=ri; i<=rend; ++i) {
       for (int j=ci; j<=cend; ++j) {
	 MM(i,j) = (*this)(i-ri,j-ci);
       }
     }	 
     return MM;
}

doubleMatrix doubleMatrix::expandMatrix(int r, int c) const {
     return this->expandMatrix(0, 0, r-1 ,c-1);
}

doubleMatrix doubleMatrix::operator+(const doubleMatrix& _v) const {
    if (!(Row()==_v.Row()) || !(Col()==_v.Col())) {
    	cerr << "not the same dimensions for doubleMatrix addition\n";
    	exit(1);
    }
    doubleMatrix vr(v->Row(), v->Col());
    for (int i=0; i < v->RC(); ++i) (*vr.v)[i] = (*v)[i] + (*_v.v)[i];
    return vr;
}

doubleMatrix doubleMatrix::operator-(const doubleMatrix& _v) const {
    if (!(Row()==_v.Row()) || !(Col()==_v.Col())) {
    	cerr << "not the same dimensions for doubleMatrix subtraction\n";
    	exit(1);
    }
    doubleMatrix vr(v->Row(), v->Col());
    for (int i=0; i < v->RC(); ++i) (*vr.v)[i] = (*v)[i] - (*_v.v)[i];
    return vr;
}

doubleMatrix doubleMatrix::operator*(const doubleMatrix& _v) const {   
    if (v->Col() != _v.v->Row()) {
       cerr << "Error: doubleMatrix doubleMatrix::operator*(const doubleMatrix&) const ";
       cerr << "row or col is not the same\n";
       exit(1);
     }
    doubleMatrix vr(v->Row(), _v.v->Col());
    for (int i=0 ; i < v->Row() ; ++i) {
      for (int j=0 ; j < _v.v->Col() ; ++j) {
        (*vr.v)(i,j) = 0.0;
        for (int k=0 ; k < v->Col() ; ++k) {
           (*vr.v)(i,j) += (*v)(i,k) * (*_v.v)(k,j);
        }
      }
    }
    return vr;
}

doubleMatrix doubleMatrix::operator/(const doubleMatrix& _v) const {   
    if (v->Col() != _v.v->Row() || _v.v->Row() != _v.v->Col()) {
       cerr << "Error: doubleMatrix doubleMatrix::operator/(const doubleMatrix&) const";
       cerr << "row or col is not the same\n";
       exit(1);
     }
    doubleMatrix vr(v->Row(), _v.v->Col());
    vr = (*this) * _v.invM();
    return vr;
}

doubleMatrix& doubleMatrix::operator+=(const doubleMatrix& _v) {
    if (!(v->OnlyOne())) {
      --(*v);
      v=new Mdata(*v);
    }
    for (int i=0; i < v->RC(); ++i) (*v)[i] += (*_v.v)[i];
    return *this;
}

doubleMatrix& doubleMatrix::operator-=(const doubleMatrix& _v) {
    if (!(v->OnlyOne())) {
      --(*v);
      v=new Mdata(*v);
    }
    for (int i=0; i < v->RC(); ++i) (*v)[i] -= (*_v.v)[i];
    return *this;
}

doubleMatrix& doubleMatrix::operator*=(const doubleMatrix& _v) {   
    if (v->Col() != _v.v->Row()) {
       cerr << "Error: doubleMatrix doubleMatrix::operator*(const doubleMatrix&) const";
       cerr << "row or col is not the same\n";
       exit(1);
     }
    doubleMatrix vr(*this);
    *this = vr * _v;
    return *this;
}

doubleMatrix& doubleMatrix::operator/=(const doubleMatrix& _v) {   
    if (v->Col() != _v.v->Row() || _v.v->Row() != _v.v->Col()) {
       cerr << "Error: doubleMatrix doubleMatrix::operator/(const doubleMatrix&) const";
       cerr << "row or col is not the same\n";
       exit(1);
     }
    doubleMatrix vr(*this);
    *this = vr / _v;
    return *this;
}

doubleMatrix::operator Vec() const {
  int row = v->Row();
  Vec vr(row);
  for (int i=0; i<row; ++i) {
    vr[i] = (*v)(i,0);
  }
  return vr;
}

Vec doubleMatrix::vec(int col) const {
  if (col >= v->Col()) {
     cerr << "Warning ** in vec(int col), col too big and is reasigned 0\n";
     col = 0;
  }
  int row = v->Row();
  Vec vr(row);
  for (int i=0; i<row; ++i) {
    vr[i] = (*v)(i,col);
  }
  return vr;
}

doubleMatrix operator*(const doubleMatrix& M, const double c) {
  doubleMatrix T(M);
  for (int i=0; i < M.Row(); ++i) {
  for (int j=0; j < M.Col(); ++j) {
      T(i,j) *= c;
  }}
  return(T);
}

doubleMatrix operator*(const double c, const doubleMatrix& M) {
  doubleMatrix T = M;
  for (int i=0; i < M.Row(); ++i) {
  for (int j=0; j < M.Col(); ++j) {
      T(i,j) *= c;
  }}
  return(T);
}

doubleMatrix operator/(const doubleMatrix& M, const double c) {
  doubleMatrix T(M);
  for (int i=0; i < M.Row(); ++i) {
  for (int j=0; j < M.Col(); ++j) {
      T(i,j) /= c;
  }}
  return(T);
}

doubleMatrix operator/(const double c, const doubleMatrix& M) {
  doubleMatrix T = M.invM();
  for (int i=0; i < M.Row(); ++i) {
  for (int j=0; j < M.Col(); ++j) {
      T(i,j) *= c;
  }}
  return(T);
}

//---------------------------------------------------
 
void InvdoubleMatrix(double** a, int n);//acknowledgement: N. Malitsky & A. Reshetov 
void solveLinearEquations(double** a, double* b, int n); //ack:NM & AR 

doubleMatrix doubleMatrix::invM(int s) const{
    int n = v->Row();
    if (n != v->Col()) {
       cerr << "Error: doubleMatrix& doubleMatrix::invM()";
       cerr << "row and col are not the same\n";
       exit(1);
     }
    doubleMatrix S(n/2);
    if (s) {
       S = (-1.0)*S*(*this).Transpose()*S;
       return S;
    }
    double **aa;
    aa = new double *[n+1];
    int i;
    for (i=1; i<=n; ++i) {
        aa[i] = new double [n+1];
        for (int j=1; j<=n; ++j) {
     aa[i][j] = (*v)(i-1,j-1);
        }
    }
    InvdoubleMatrix(aa, n);
    doubleMatrix obj(n,n);
    for (i=1; i<=n; ++i) {
        for (int j=1; j<=n; ++j) {
            //(*v)(i-1,j-1) = aa[i][j];
            (*obj.v)(i-1,j-1) = aa[i][j];
        }
    }
    //return(*this);
    return(obj);
}
int doubleMatrix::inv() {
    int i; // index
    int n = v->Row();
    if (n != v->Col()) {
       cerr << "Error: doubleMatrix& doubleMatrix::invM()";
       cerr << "row and col are not the same\n";
       exit(1);
     }
    if (!(v->OnlyOne())) {
      --(*v);
      v=new Mdata(*v);
    }
    double **aa;
    aa = new double *[n+1];
    for (i=1; i<=n; ++i) {
        aa[i] = new double [n+1];
        for (int j=1; j<=n; ++j) {
            aa[i][j] = (*v)(i-1,j-1);
        }
    }
    InvdoubleMatrix(aa, n);
    for (i=1; i<=n; ++i) {
        for (int j=1; j<=n; ++j) {
            (*v)(i-1,j-1) = aa[i][j];
        }
    }
    return(1);
}

doubleMatrix doubleMatrix::Transpose() const {
    doubleMatrix temp(Col(), Row());
    for (int i=0; i<Row(); ++i) {
    for (int j=0; j<Col(); ++j) {
        temp(i,j) = (*this)(j,i);
    }}
    return temp;
}

double doubleMatrix::AbsSumElm() const {
    double sum = 0.0;
    for (int i=0; i< Row(); ++i) {
        for (int j=0; j<Col(); ++j) {
	    sum += fabs((*this)(i,j));
	}
    }
    return sum;
}

int doubleMatrix::checkI() const {
    if (!(Row()==Col())) {return 0;}
    doubleMatrix I(Row(), 1.0);
    I -= *this;
    if (I.AbsSumElm() < 1.e-5) {
       return 1;
    } else {
       return 0;
    }
}

int doubleMatrix::checkSymplecticity(doubleMatrix & S) const {
    if (!(Row()==Col())) {return 0;}
    if (!(Row()/2 *2 ==Row())) {return 0;}
    doubleMatrix SS(Row()/2);
    S = this->Transpose() * SS * (*this);
    SS -= S;
    if (SS.AbsSumElm() < 1.e-5) {
       return 1;
    } else {
       return 0;
    }
}


void doubleMatrix::zero() {
     for (int i=0; i < v->RC(); ++i) (*v)[i] = 0.0;
}

void getsincos(double a, double b, double& sn, double& cn) {
       double c = sqrt(a*a+b*b); // Get sin and cos for a sin + b cos = 0 
       sn = b/c;  //with sin > 0 always;
       cn = a/c;
       if (b < 0.0) {sn = -sn;}
       else {cn = - cn;}
}

int doubleMatrix::Norm(doubleMatrix& A, doubleMatrix& R, doubleMatrix& AI) {
    if (!(Row()==Col())) {return 0;}
    int n = Row();
    doubleMatrix wr(n,n), wi(n,n), temp(n,n);
    Vec vr(n), vi(n);
    if ( this->checkI() ) {
       doubleMatrix I(n, 1.0);
       A = I; R = I; AI = I;
       return 1;
    }
    if (!((*this).Eigen(wr, wi, vr, vi))) {return 0;}
    int i,j,k;
    for (j=0; j<n; j+=2) {
        for (i=0; i<n; ++i) {   
    	    temp(i,j) = wr(i,j);              
	    temp(i,j+1) = wi(i,j);
	}
    }
    A = temp; 
    doubleMatrix RR(n,n);
    temp = A.invM()*A;
    for (i=0; i<n; ++i) temp(i,i) = 1.0/sqrt(temp(i,i));
    double sn, cn;
    for (k=0; k < n/2; ++k) {
        i=2*k; j=i+1;
        getsincos(A(i,i), A(i,j), sn, cn);
	RR(i,i) = cn;
	RR(i,j) = sn;
	RR(j,i) =-sn;
	RR(j,j) = cn;
    }
    A=A*temp*RR;
    temp.zero();
    for (k=0; k < n/2; ++k) {
        i=2*k;	j=i+1;
	temp(i,i) = temp(j,j) = sign(A(i,i));
    }
    A=A*temp;
    AI = A.invM();
    R = AI*(*this)*A;
    return 1;
}

int doubleMatrix::Norm45(doubleMatrix& AA, doubleMatrix& RR, doubleMatrix& AAI)
{
    if (!(Row()==4 || Row()==5)) {return 0;}
    if (!(Col()==5)) {return 0;}
    doubleMatrix NN = subMatrix(4,4);
    doubleMatrix A, R, AI;
    int flag = NN.Norm(A,R,AI);
    if (! flag) {return 0;}
    AA = A.expandMatrix(5,5);
    AA(4,4) = 1.0;
    RR = R.expandMatrix(5,5);
    RR(4,4) = 1.0;
    Vec hh = getColVec(0,3,4);
    doubleMatrix II(4,1.0);
    doubleMatrix IN=II-NN;
    hh = (IN.invM(0))*hh;
    doubleMatrix A0(5,1.0);
    for (int i=0; i<4; ++i) A0(i,4) = hh[i];
    AA = A0*AA;
    AAI = AA.invM(0);
    return 1;
}

Vec doubleMatrix::operator*(const Vec & _v) const {
    Vec objv(Col());
    int i,j;
    for (i=0; i < Row(); ++i) {
        objv[i] = (*v)(i,0)*_v[0];
        for (j=1; j < Col(); ++j) {
            objv[i] += (*v)(i,j)*_v[j];
        }
    }
    return objv;
}

ostream& operator << (ostream& out, const doubleMatrix & _v) {
  //  static int digit = 17;
  int digit = Zlib::digit;
  out << 'M' << ' ' << _v.v->Row() << ' ' << _v.v->Col();
  for (int i=0; i < _v.v->Row(); ++i) {
      out << "\n";
      for (int j=0; j < _v.v->Col(); j++)
            out << setw(digit+9) << setprecision(digit)
                << _v(i,j) << ' ';
  }
  out << "\n\n";
  return (out);
}

istream& operator >> (istream& in, doubleMatrix & _v) {
  char ch;
  int r, c;
  in >> ch >> r >> c;
  if (!(r == _v.v->Row()) || !(c == _v.v->Col())) {
     --(*_v.v);
     if (_v.v->AllGone()) delete _v.v;
     _v.v = new Mdata(r,c);
     if (!_v.v) {cerr << "doubleMatrix istream mem problem\n"; exit(1);}
  }
  for (int i=0; i < r; ++i) {
      for (int j=0; j < c; j++) in >> (*_v.v) (i,j);
  }
  return (in);
}

// ********************************************
void ludcmp(double** a, int n, int* indx, double* d)
{
  int imax, k;
  double big, dum, sum, temp;
  double* vv;
 
  vv = new double[n+1];
  if(!vv) 
  { 
    cerr << "ludcmp: allocation failure in vector()\n";
    exit(1);
  }
  *d = 1.0;
  int i; // index
  for(i=1; i <= n ; i++)
  {
     big = 0.0;
     for(int j=1; j <= n; j++)
       if ((temp = fabs(a[i][j])) > big) big = temp;
     if (big == 0.0) cerr << "ludcmp : Singular doubleMatrix in routine \n";
     vv[i] = 1./big;
  }
  for (int j = 1; j <= n; j++)
  {
     for (i=1; i < j; i++)
     {
         sum = a[i][j];
         for (k=1; k < i ; k++) sum -= a[i][k]*a[k][j];
         a[i][j] = sum;
     }
     big = 0.0;
     for(i=j; i <= n; i++)
     {
         sum = a[i][j];
         for (k=1; k < j; k++)
             sum -= a[i][k]*a[k][j];
         a[i][j] = sum;
         if ((dum = vv[i]*fabs(sum)) >= big)
         {
             big = dum;
             imax = i;
         }
     }
     if ( j != imax)
     {
         for (k=1; k <= n; k++)
         {
            dum = a[imax][k];
            a[imax][k] = a[j][k];
            a[j][k] = dum;
         }
         *d = -(*d);
         vv[imax] = vv[j];
     }
     indx[j] = imax;
     if (a[j][j] == 0.0) a[j][j] = ZLIB_TINY;
     if (j != n) 
     {
        dum =1.0/(a[j][j]);
        for (i=j+1; i <= n; i++) a[i][j] *= dum; 
     }
  }
  delete [] vv;
}

void lubksb(double** a, int n, int* indx, double* b)
{
   int ii = 0;
   int ip, j;
   double sum;
   int i; // index

   for(i=1; i <= n; i++)
   {
      ip = indx[i];
      sum = b[ip];
      b[ip] = b[i];
      if(ii)
          for(j=ii; j <= i-1; j++) sum -= a[i][j]*b[j];
      else if (sum) ii = i;
      b[i] = sum;
    }
    for (i=n; i >=1; i--)
    {
       sum = b[i];
       for (j=i+1; j <= n; j++) sum -= a[i][j]*b[j];
       b[i] = sum/a[i][i];
    }
}

void InvdoubleMatrix(double**a, int n)
{
   double** y;
   double* col;
   double  d;
   int* indx;

   indx = new int[n+1];   
   col  = new double[n+1]; 
   y = new double*[n+1];
   int i; // index
   for(i=1; i <= n; i++)
           y[i] = new double[n+1];
   if(!y[n]) 
   {
     cerr << "invdoubleMatrix: allocation failure \n";
     exit(1);
   } 
   ludcmp(a, n, indx, &d);
   for(i = 1; i <= n; i++) d *= a[i][i];

   if( fabs(d) < ZLIB_TINY) 
   {
      cerr << "Error : invdoubleMatrix ";
      cerr << "fabs(Determinant) = " << fabs(d) << " < " << ZLIB_TINY << " \n";
      exit(1);
   }

   for(int j=1; j <= n; j++)
   {
      for(i=1; i <= n; i++) col[i]= 0.0;
      col[j] = 1.0;
      lubksb(a, n, indx, col);
      for(i=1; i <= n; i++) y[i][j]=col[i];
   }
   for(i=1; i <= n; i++)
     for(int j=1; j <= n; j++)
          a[i][j]=y[i][j];

   for(i=1; i <= n; i++)
            delete [] y[i];
   delete [] y;
   delete [] col;
   delete [] indx;
   return;
}

  
//---------------------------------------------------------

void solveLinearEquations(double**a, double* b, int n)
{
 
   double  d;
   int* indx;

   indx = new int[n+1];   
   if(!indx) 
   {
     cerr << "solveLinearEquations: allocation failure \n";
     exit(1);
   } 

   ludcmp(a, n, indx, &d);
   lubksb(a, n, indx, b);

   delete [] indx;
   return;
}

