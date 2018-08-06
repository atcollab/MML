#include "doubleMatrix.hpp"

const double EPSS=0.0;

int min2(int i, int j) {
   if ( i>= j )  
       return j;
   else 
       return i;
}

double dsignn(double x, double y){
    x = fabs(x);
    if ( y >= 0 ) 
        return x;
    else
        return -x;
}

void doubleMatrix::upperHessenberg(int n, int low, int igh, doubleMatrix & a, Vec & ort) {

   int     i,j,m,ii,jj,la,mp,kp1;
   double  f,g,h,scale;

/*   this subroutine is a translation of the algol procedure orthes,
     num. math. 12, 349-368(1968] by Martin and Wilkinson.
     handbook for auto. comp., vol.ii-linear algebra, 339-358(1971].

     given a real general Matrix, this subroutine
     reduces a subMatrix situated in rows and columns
     low through igh to upper hessenberg form by
     orthogonal similarity transformations.

     on input-

        n is the order of the Matrix,

        low and igh are integers determined by the balancing
          subroutine  balanc.  ifbalanc  has not been used,
          set low:=1, igh:=n,

        a contains the input Matrix.

     on output-

        a contains the hessenberg Matrix.  information about
          the orthogonal transformations used in the reduction
          is stored in the remaining triangle under the
          hessenberg Matrix,

        ort contains further information about the transformations.
          only elements low through igh are used.

     fortran routine by b. s. garbow
     modified by filippo neri. */

  la = igh - 1;
  kp1 = low + 1;
  if ( la >= kp1 ) {
      for (m = kp1; m <= la; m++) {
         h = 0.0;
         ort(m) = 0.0;
         scale = 0.0;

  /********** scale column (algol tol then not needed] **********/

         for ( i = m; i <= igh; i++ )  scale += fabs(a.A(i,m-1));
         if (scale != 0) {
           mp = m + igh;
  /********** for i:=igh step -1 until m for -- **********/

           for ( ii = m; ii <= igh; ii++) {
              i = mp - ii;
              ort(i) = a.A(i,m-1) / scale;
              h += ort(i) * ort(i);
           }

           g = -dsignn(sqrt(h),ort(m));
           h -= ort(m) * g;
           ort(m) -= g;
   /********** form (i-(u*ut]/h]*a **********/
         for ( j = m; j <= n; j++ ) {
            f = 0.0;
   /********** for i:=igh step -1 until m for -- **********/
            for ( ii = m; ii <= igh; ii++ ) {
               i = mp - ii;
               f += ort(i) * a.A(i,j);
            }

            f /=  h;

            for ( i = m; i <= igh; i++)
                 a.A(i,j) -= f * ort(i);

         }
   /********** form (i-(u*ut]/h]*a*(i-(u*ut]/h] **********/
         for ( i = 1; i <= igh; i++) {
            f = 0.0;
   /********** for j:=igh step -1 until m for -- **********/
            for ( jj = m; jj <= igh; jj++) { 
               j = mp - jj;
               f += ort(j) * a.A(i,j);
            }

            f /= h;

            for ( j = m; j <= igh; j++)  
                a.A(i,j) -= f * ort(j);

         }
         ort(m) *= scale;
         a.A(m,m-1) = scale * g;
      }
   }
   }
}
void doubleMatrix::upperHessenbergAccu(int n, int low, int igh, doubleMatrix & a, Vec & ort,doubleMatrix & z) {
    int       i,j,kl,mm,mp,mp1;
    double    g;

 /*  this subroutine is a translation of the algol procedure ortrans,
     num. math. 16, 181-204[1970] by peters and wilkinson.
     handbook for auto. comp., vol.ii-linear algebra, 372-395[1971].

     this subroutine accumulates the orthogonal similarity
     transformations used in the reduction of a real general
     Matrix to upper hessenberg form.

     on input-

        n is the order of the Matrix,

        low and igh are integers determined by the balancing
          subroutine  balanc.  if  balanc  has not been used,
          set low:=1, igh:=n,

        a contains information about the orthogonal trans-
          formations used in the reduction by  orthes
          in its strict lower triangle,

          ort contains further information about the trans-
          formations used in the reduction by  upperHessenberg.
          only elements low through igh are used.

     on output-

        z contains the transformation Matrix produced in the
          reduction by  upperHessenberg,

        ort has been altered.

     fortran routine by b. s. garbow.
     modified by f. neri. */


    /********** initialize z to identity Matrix **********/

    for ( i = 1; i <= n; i++ ) {
        for ( j = 1; j <= n; j++ ) 
            z.A(i,j) = 0.0;
        z.A(i,i) = 1.0;
    }

    kl = igh - low - 1;
    if ( kl >= 1 ) {
      for ( mm = 1; mm <= kl; mm++) {
        mp = igh - mm;
        if ( a.A(mp,mp-1) != 0.0 ) {
          mp1 = mp + 1;
          for (i = mp1; i <= igh; i++) 
              ort(i) = a.A(i,mp-1);
          for (j = mp; j <= igh; j++) {
            g = 0.0;
            for (i = mp; i <= igh; i++)
                g += ort(i) * z.A(i,j);
   /*********** divisor below is negative of h formed in orthes.
                double division avoids possible underflow **********/
            g = (g / ort(mp)) / a.A(mp,mp-1);
            for (i = mp; i <= igh; i++)
                z.A(i,j) += g * ort(i);
          }
       }
      }
    }
}

void etdivv(double & a, double & b, double c, double d,
           double e, double f) {
/*--------------------------------------------------
   computes the complex division
     a + ib := (c + id)/(e + if)
  very slow, but tries to be as accurate as
  possible by changing the order of the
  operations, so to avoid under(over)flow
  problems.
  Written by F. Neri Feb. 12 1986
 --------------------------------------------------*/
   double  s,t,cc,dd,ee,ff,temp;
   int     flip;

      flip = 0;
      cc = c;
      dd = d;
      ee = e;
      ff = f;
      if (fabs(f) >= fabs(e)) {
        ee = f;
        ff = e;
        cc = d;
        dd = c;
        flip = 1;
      }
      s = 1.0/ee;
      t = 1.0/(ee+ ff*(ff*s));
      if  (fabs(ff) >= fabs(s)) {
        temp = ff;
        ff = s;
        s = temp;
      }

      if  (fabs(dd) >= fabs(s)) 
        a = t*(cc + s*(dd*ff));
      else if  (fabs(dd) >= fabs(ff))
        a = t*(cc + dd*(s*ff));
      else
        a = t*(cc + ff*(s*dd));

      if  (fabs(cc) >= fabs(s)) 
        b = t*(dd - s*(cc*ff));
      else if  (fabs(cc) >= fabs(ff))
        b = t*(dd - cc*(s*ff));
      else
        b = t*(dd - ff*(s*cc));

      if (flip != 0)  b = -b;
}


void doubleMatrix::Hessenberg(int n, int low, int igh, doubleMatrix & h, 
                  Vec & wr, Vec & wi,
                  doubleMatrix & z, int & ierr) {

/*   this subroutine is a translation of the algol procedure hqr2,
     num. math. 16, 181-204[1970] by peters and wilkinson.
     handbookfor{auto. comp., vol.ii-linear algebra, 372-395[1971].

     this subroutine finds the eigenvalues and eigenVecs
     of a real upper hessenberg Matrix by the qr method.  the
     eigenVecs of a real general Matrix can also be found
     ifelmhes  and  eltran  or  orthes  and  ortran  have
     been used to reduce this general Matrix to hessenberg form
     and to accumulate the similarity transformations.

     on input-

        n is the order of the Matrix,

        low and igh are integers determined by the balancing
          subroutine  balanc.  ifbalanc  has not been used,
          set low:=1, igh:=n,

        h contains the upper hessenberg Matrix,

        z contains the transformation Matrix produced by  eltran
          after the reduction by  elmhes, or by  ortran  after the
          reduction by  orthes, ifperformed.  ifthe eigenVecs
          of the hessenberg Matrix are desired, z must contain the
          identity Matrix.

     on output-

        h has been destroyed,

        wr and wi contain the real and imaginary parts,
          respectively, of the eigenvalues.  the eigenvalues
          are unordered except that complex conjugate pairs
          of values appear consecutively with the eigenvalue
          having the positive imaginary part first.  ifan
          error exit is made, the eigenvalues should be correct
         for{indices ierr+1,...,n,

        z contains the real and imaginary parts of the eigenVecs.
          ifthe i-th eigenvalue is real, the i-th column of z
          contains its eigenVec.  ifthe i-th eigenvalue is complex
          with positive imaginary part, the i-th and [i+1]-th
          columns of z contain the real and imaginary parts of its
          eigenVec.  the eigenVecs are unnormalized.  ifan
          error exit is made, none of the eigenVecs has been found,

        ierr is set to
          zero      for{normal return,
          j          ifthe j-th eigenvalue has not been
                     determined after 30 iterations.

     arithmetic is double precision. complex division
     is simulated by routin etdivv.

     fortran routine by b. s. garbow.
     modified by f. neri. */


     /********** machep is a machine dependent parameter specifying
                the relative precision of floating point arithmetic.

                **********/

      int    i,j,k,l,m,en,ii,jj,ll,mm,na,nn;
      int    its,mp2,enm2;
      double p,q,r,s,t,w,x,y,ra,sa,vi,vr,zz,norm;
      int   notlas;
      double z3r,z3i;

      ierr = 0;
      norm = 0.0;
      k = 1;
      /********** store roots isolated by balanc
                 and compute Matrix norm **********/
     for (i = 1; i <= n; i++) {
        for (j = k; j <= n; j++)
           norm += fabs(h.A(i,j));
        k = i;
        if (!((i >= low) && (i <= igh))) {
             wr(i) = h.A(i,i);
             wi(i) = 0.0;
        }
      }

      en = igh;
      t = 0.0;

      /********** searchfor{next eigenvalues **********/
l60:  if (en < low) goto l340;
      its = 0;
      na = en - 1;
      enm2 = na - 1;
      /********** lookfor{single small sub-diagonal element}*/

l70: for ( ll = low; ll <= en; ll++) {
         l = en + low - ll;
         if (l == low) goto l100;
         s = fabs(h.A(l-1,l-1)) + fabs(h.A(l,l));
         if (s == 0.0) s = norm;
         if (fabs(h.A(l,l-1)) <= (EPSS*s)) goto l100;
      }

      /********** form shift **********/

l100: x = h.A(en,en);
      if (l == en) goto l270;
      y = h.A(na,na);
      w = h.A(en,na) * h.A(na,en);
      if (l == na) goto l280;
      if (its == 30) {
        ierr = en;
        goto l1000;
      }

      if ((its == 10) || (its == 20)) {
      /********** form exceptional shift **********/
        t += x;

        for (i = low; i <= en; i++)
            h.A(i,i) -= x;

        s = fabs(h.A(en,na)) + fabs(h.A(na,enm2));
        x = 0.75 * s;
        y = x;
        w = -0.4375 * s * s;
        its++;
      }

      /********** lookfor{two consecutive small
                 sub-diagonal elements.*/

     for ( mm = l; mm <= enm2; mm++) {
         m = enm2 + l - mm;
         zz = h.A(m,m);
         r = x - zz;
         s = y - zz;
         p = (r*s-w)/h.A(m+1,m)+h.A(m,m+1);
         q = h.A(m+1,m+1) - zz - r - s;
         r = h.A(m+2,m+1);
         s = fabs(p) + fabs(q) + fabs(r);
         p /= s;
         q /= s;
         r /= s;
         if (m == l) goto l150;
         if ((fabs(h.A(m,m-1))*(fabs(q)+fabs(r)))
               <= ( EPSS*fabs(p)
              *(fabs(h.A(m-1,m-1))+fabs(zz)+fabs(h.A(m+1,m+1)) ))) goto l150;
      }

l150: mp2 = m + 2;

     for (i = mp2; i <= en; i++) {
         h.A(i,i-2) = 0.0;
         if (i != mp2) h.A(i,i-3) = 0.0;
     }

     /* ********** double qr step involving rows l to en and
                 columns m to en **********/
     for (k = m; k <= na; k++) { 
       notlas = (k != na);
       if (k != m) {
         p = h.A(k,k-1);
         q = h.A(k+1,k-1);
         r = 0.0;
         if (notlas) r = h.A(k+2,k-1);
         x = fabs(p) + fabs(q) + fabs(r);
         if (x == 0.0) goto l260;
         p /= x;
         q /= x;
         r /= x;
       }

       s = dsignn(sqrt(p*p+q*q+r*r),p);
       if (k != m) h.A(k,k-1) = -s*x;
       else if (l != m) h.A(k,k-1) = -h.A(k,k-1);

       p += s;
       x = p/s;
       y = q/s;
       zz = r/s;
       q /= p;
       r /= p;

      /********** row modification **********/

            for (j = k; j <= n; j++) { 
              p = h.A(k,j) + q*h.A(k+1,j);
              if (notlas) {
                p += r*h.A(k+2,j);
                h.A(k+2,j) -= p * zz;
              }
              h.A(k+1,j) -= p * y;
              h.A(k,j) -= p * x;
            }

         j = min2(en,k+3);

      /********** column modification **********/

            for (i = 1; i <= j; i++ ) {
              p = x*h.A(i,k) + y*h.A(i,k+1);
              if (notlas) {
                p += zz*h.A(i,k+2);
                h.A(i,k+2) -= p * r;
              }
              h.A(i,k+1) -= p * q;
              h.A(i,k) -= p;
            }

      /********** accumulate transformations **********/

          for (i = low; i <= igh; i++) {
            p = x*z.A(i,k)+y*z.A(i,k+1);
            if (notlas) {
              p += zz*z.A(i,k+2);
              z.A(i,k+2) -= p * r;
            }
            z.A(i,k+1) -= p * q;
            z.A(i,k) -= p;
          }
l260: ;
      }

      goto l70;
      /********** one root found **********/
l270: h.A(en,en) = x + t;
      wr(en) = h.A(en,en);
      wi(en) = 0.0;
      en = na;
      goto l60;
      /********** two roots found **********/
l280: p = (y-x)/2.0;
      q = p*p+w;
      zz = sqrt(fabs(q));
      h.A(en,en) = x+t;
      x = h.A(en,en);
      h.A(na,na) = y + t;
      if (q < 0.0) goto l320;
      /********** real pair **********/
      zz = p + dsignn(zz,p);
      wr(na) = x + zz;
      wr(en) = wr(na);
      if (zz != 0.0) wr(en) = x - w/zz;
      wi(na) = 0.0;
      wi(en) = 0.0;
      x = h.A(en,na);
      s = fabs(x) + fabs(zz);
      p = x/s;
      q = zz/s;
      r = sqrt(p*p+q*q);
      p /= r;
      q /= r;
      /********** row modification **********/
      for (j = na; j <= n; j++) {
         zz = h.A(na,j);
         h.A(na,j) = q*zz+p*h.A(en,j);
         h.A(en,j) = q*h.A(en,j)-p*zz;
      }
      /********** column modification **********/
      for (i = 1; i <= en; i++) { 
         zz = h.A(i,na);
         h.A(i,na) = q*zz+p*h.A(i,en);
         h.A(i,en) =q*h.A(i,en)-p*zz;
      }
      /********** accumulate transformations **********/
      for (i = low; i <= igh; i++) {
         zz = z.A(i,na);
         z.A(i,na) = q*zz+p*z.A(i,en);
         z.A(i,en) = q*z.A(i,en)-p*zz;
      }

      goto l330;
      /********** complex pair **********/
l320: wr(na) = x+p;
      wr(en) = x+p;
      wi(na) = zz;
      wi(en) = -zz;
l330: en = enm2;
      goto l60;
      /********** all roots found.  backsubstitute to find*/
      /*          Vecs of upper triangular form **********/
l340: if (norm != 0.0) {
     for (nn = 1; nn <= n; nn++) {
        en = n+1-nn;
        p = wr(en);
        q = wi(en);
        na = en-1;
        if (q==0) {
          m = en;
          h.A(en,en) = 1.0;
          if (na != 0) {
            for (ii = 1; ii <= na; ii++) {
              i = en-ii;
              w = h.A(i,i)-p;
              r = h.A(i,en);

              if (m <= na) 
                for (j = m; j <= na; j++) r += h.A(i,j)*h.A(j,en);

              if (wi(i) < 0.0) {
                zz = w;
                s = r;
              } else {
                m = i;
                if (wi(i) == 0.0) {
                  t = w;
                  if (w == 0.0) t = EPSS*norm;
                  h.A(i,en) = -r/t;
                } else {
       /********** solve double equations **********/
                  x = h.A(i,i+1);
                  y = h.A(i+1,i);
                  q = (wr(i)-p)*(wr(i)-p)+wi(i)*wi(i);
                  t = (x*s-zz*r)/q;
                  h.A(i,en) = t;
                  if (fabs(x) <= fabs(zz)) h.A(i+1,en) = (-s-y*t)/zz;
                  else  h.A(i+1,en) = (-r-w*t)/x;
                } 
              }
            }
        }
      } else
      if (q < 0) { //** Complex ** 
        m = na;
      /********** last Vec component chosen imaginary so that  **/
      /********** eigenVec Matrix is triangular **********     **/
       if (na != 0) {
        if (fabs(h.A(en,na)) > fabs(h.A(na,en))) {
          h.A(na,na) = q/h.A(en,na);
          h.A(na,en) = -(h.A(en,en)-p)/h.A(en,na);
        } else {
          etdivv(z3r,z3i,0.0,-h.A(na,en),h.A(na,na)-p,q);
          h.A(na,na) = z3r;
          h.A(na,en) = z3i;
        }
        h.A(en,na) = 0.0;
        h.A(en,en) = 1.0;
        enm2 = na - 1;

        if (enm2 != 0) {
         for (ii = 1; ii <= enm2; ii++) {
           i = na-ii;
           w = h.A(i,i)-p;
           ra = 0.0;
           sa = h.A(i,en);

           for (j = m; j <= na; j++) {
             ra += h.A(i,j) * h.A(j,na);
             sa += h.A(i,j) * h.A(j,en);
           }

           if (!(wi(i) >= 0.0)) {
             zz = w;
             r = ra;
             s = sa;
           } else {
             m = i;
             if (wi(i)==0.0) {
               etdivv(z3r,z3i,-ra,-sa,w,q);
               h.A(i,na) = z3r;
               h.A(i,en) = z3i;
             }
             else {
             /********** solve complex equations **********/
               x = h.A(i,i+1);
               y = h.A(i+1,i);
               vr = (wr(i)-p)*(wr(i)-p)+wi(i)*wi(i)-q*q;
               vi = (wr(i)-p)*2.0*q;

               if ((vr ==0.0)  &&  (vi == 0.0)) 
                 vr = EPSS*norm*(fabs(w)+fabs(q)+fabs(x)+fabs(y)+fabs(zz));
               etdivv(z3r,z3i,x*r-zz*ra+q*sa,x*s-zz*sa-q*ra,vr,vi);
 
               h.A(i,na) = z3r;
               h.A(i,en) = z3i;

               if (fabs(x) <= fabs(zz)+fabs(q)) {
                 etdivv(z3r,z3i,-r-y*h.A(i,na),-s-y*h.A(i,en),zz,q);
                 h.A(i+1,na) = z3r;
                 h.A(i+1,en) = z3i;
               } else {
                 h.A(i+1,na) = (-ra-w*h.A(i,na)+q*h.A(i,en))/x;
                 h.A(i+1,en) = (-sa-w*h.A(i,en)-q*h.A(i,na))/x;
               }
             }
           }
         }
       }
      }
     }
   }


/*     ********** end back substitution.               */
/*               Vecs of isolated roots **********  */
      for (i = 1; i <= n; i++) 
         if (!((i >= low) && (i <= igh))) 
            for (j = i; j <= n; j++) z.A(i,j) = h.A(i,j);

/*     ********** multiply by transformation Matrix to give  */
/*                Vecs of original full Matrix.           */
/*                for j:=n step -1 until low for --          */


      for (jj = low; jj <= n; jj++) { 
         j = n+low-jj;
         m = min2(j,igh);
         for (i = low; i <= igh; i++) {
            zz = 0.0;
            for (k = low; k <= m; k++)  zz += z.A(i,k)*h.A(k,j);
            z.A(i,j) = zz;
         }
      }
    }
    en = 0;
    /********** last card of Hessenberg **********/
l1000: ierr = en;
}


int closestt(double x, double x1, double x2, double x3) {

  double   dx1, dx2, dx3;
  
  dx1 = x-x1; 
  dx2 = x-x2; 
  dx3 = x-x3;

  dx1 = fabs(dx1); 
  dx2 = fabs(dx2); 
  dx3 = fabs(dx3);
  if ((dx1 < dx2) && (dx1 < dx3)) 
      return 1;
  else if ((dx2 < dx1) && (dx2 < dx3))
      return 2;
  else
      return 3;
}

void SwwapMat(int n, doubleMatrix & a, int i, int j) {

     //  a[*, i] <==> a[*, j] 
     //  a[i, *] <==> a[j, *]  

    double   x;

    for (int k = 1; k <= n; k++) {
        x = a.A(k, i); 
        a.A(k, i) = a.A(k, j); 
        a.A(k, j) = x;
    }
}

void Swwap(double & x, double & y) {
    double z = x;
    x = y; 
    y = z;
}

double GetAngle(double x, double y) {

// Get the angle a from x=cos(a), y=sin(a) where -pi <= a <= pi 
  double   z;
  if (x != 0.0) 
      z = atan(y/x);
  else
      z = sign(y)*PI/2;
  if (x < 0) {
      if (y >= 0) 
        z += PI;
      else
        z -= PI;
  }
  return z;
}


int doubleMatrix::Eigen(doubleMatrix & Vre, doubleMatrix & Vim, Vec & wr, Vec & wi) {

/* This routine finds the eigenvalues and 
   eigenVecs of the full Matrix fm 
 */

   if (Row() != Col()) {
      cout << "this Matrix does not have eigen values\n";
      return false;
   }

   int n = Row();

   int       info, i, j, k, c;
   Vec    ort;
   Vec    cosfm, sinfm, nufm1, nufm2;
   Vec    nu1, nu2;
   doubleMatrix    aa(n,n), vv(n,n);

   // copy Matrix to temporary storage [the Matrix aa is destroyed]
      for (i = 1; i <= n; i++)
        for (j = 1; j <= n; j++)
          aa.A(i, j) = (*v)[(i-1)*Row()+j-1];
   // Compute eigenvalues and eigenVecs using double
   // precision Eispack routines:
      doubleMatrix::upperHessenberg(n, 1, n, aa, ort);
      doubleMatrix::upperHessenbergAccu(n, 1, n, aa, ort, vv);
      doubleMatrix::Hessenberg(n, 1, n, aa, wr, wi, vv, info);

      if (info != 0) {
        cout << "  Error in eigen\n"; 
        return 0; //false
      }

      for (i = 1; i <= n / 2; i++)
	for (j = 1; j <= n; j++) {
          Vre.A(j, 2*i-1) = vv.A(j, 2*i-1); 
          Vim.A(j, 2*i-1) = vv.A(j, 2*i);
          Vre.A(j, 2*i) = vv.A(j, 2*i-1); 
          Vim.A(j, 2*i) = -vv.A(j, 2*i);
        }

      for (i = 1; i <= n / 2; i++) {
        j = 2*i-1;
        cosfm(i) = ((*v)[(j-1)*(Row()+1)] + (*v)[j*(Row()+1)])/2.0;
        if (fabs(cosfm(i)) > 1.0) {
          cout << "cosfm(" << i <<  ")=" << cosfm(i)
               << " > 1.0!\n";
          return 0; // false
        }
        sinfm(i) = sign((*v)[(j-1)*Row()+j]) * 
                   sqrt(1-cosfm(i)*cosfm(i));

        nufm1(i) = GetAngle(cosfm(i), sinfm(i))/(2*PI);
	if (nufm1(i) < 0) 
            nufm1(i) += 1.0;
        if (nufm1(i) <= 0.5) 
            nufm2(i) = nufm1(i);
        else
	    nufm2(i) = 1.0 - nufm1(i);

        nu1(i) = GetAngle(wr(j), wi(j))/(2*PI);
	if (nu1(i) < 0) 
           nu1(i) += 1.0;
        if (nu1(i) <= 0.5) 
	   nu2(i) = nu1(i);
        else
	   nu2(i) = 1.0 - nu1(i);
      }

      for (i = 1; i <= n / 2; i++) {
	c = closestt(nufm2(i), nu2(1), nu2(2), nu2(3));
        if (c != i) {
          j = 2*c - 1; 
          k = 2*i - 1;
          SwwapMat(n, Vre, j, k); 
          SwwapMat(n, Vim, j, k);
          SwwapMat(n, Vre, j+1, k+1); 
          SwwapMat(n, Vim, j+1, k+1);
          Swwap(wr(j), wr(k)); 
          Swwap(wi(j), wi(k));
          Swwap(wr(j+1), wr(k+1)); 
          Swwap(wi(j+1), wi(k+1));
          Swwap(nu1(i), nu1(c)); 
          Swwap(nu2(i), nu2(c));
        }
      }

      for (i = 1; i <= n / 2; i++)
      if ((0.5-nufm1(i))*(0.5-nu1(i)) < 0) {
        j = 2*i-1;
        SwwapMat(n, Vim, j, j+1); 
        Swwap(wi(j), wi(j+1));
      }
   return true;
}

int oddint(int jj) {
	int rm = jj - (jj/2)*2;
	return rm;
}

void InitJJ(int n, doubleMatrix & JJ) {

    int j;

    for (int i = 1; i <=  n; i++)
        for (j = 1; j <= n; j++)
           JJ.A(i,j) = 0;
        for (j = 1; j <= n; j++)
           if (oddint(j)) {
               JJ.A(j,j+1) = 1;
               JJ.A(j+1,j) = -1;
           }
}

void GetAinv(int n, doubleMatrix &Ainv,
             doubleMatrix & Vre, doubleMatrix & Vim, doubleMatrix & JJ) {

    int       i, j, sgn;
    double    z;

    for (i = 1; i <= n; i++)
        if (oddint(i)) {
          z  = 0;
          for (j = 1; j <= n; j++)
            for (int k = 1; k <= n; k++)
              z += Vre.A(j, i)*JJ.A(j, k)*Vim.A(k, i);
          sgn = sign(z);
          z = 1/z;
          z = sqrt(fabs(z));
          for (j = 1; j <= n; j++) {
            Vre.A(j, i) *= z;
            Vim.A(j, i) *= sgn * z;
          }
        }

    for (i = 1; i <= n; i++) {
        Ainv.A(1,i) = sign(Vre.A(1,1))*Vre.A(i, 1);
        Ainv.A(2,i) = sign(Vre.A(1,1))*Vim.A(i, 1);
        Ainv.A(3,i) = sign(Vre.A(3,3))*Vre.A(i, 3);
        Ainv.A(4,i) = sign(Vre.A(3,3))*Vim.A(i, 3);
        if (n >4) {
            Ainv.A(5, i) = sign(Vre.A(5, 5))*Vre.A(i, 5);
            Ainv.A(6, i) = sign(Vre.A(5, 5))*Vim.A(i, 5);
        }
    }
}








