#include "TpsData.hpp"


TpsData::TpsData(): mem_order(-1), count(0) {}

TpsData::TpsData(int nVar, int max_ord, int acc_ord, int min_ord):
         num_var(nVar), 
         max_order(max_ord), 
         acc_order(acc_ord),
         min_order(min_ord), 
         mem_order(max_ord), 
         count(1) 
{
  if(max_order > ZlibMaxOrder || num_var > ZlibNumVar) 
    {
      ZlibNumVar = num_var;
      ZlibMaxOrder = max_order;
      zpprepTps();
    }
  if (acc_order < max_order) acc_order = max_order;
  tps_data = new double[nmo[num_var][max_order]];
  for (int i=0; i<nmo[num_var][max_order]; ++i) { tps_data[i] = 0.0; } //??
}

TpsData::TpsData(const TpsData & zz): 
         num_var(zz.num_var),
         max_order(zz.max_order),
         acc_order(zz.acc_order),
         min_order(zz.min_order),
         mem_order(zz.max_order),
         count(1)
{
  tps_data = new double[nmo[num_var][max_order]];
  memcpy(tps_data, zz.tps_data, nmo[num_var][max_order]*sizeof(double));
}

TpsData & TpsData::operator = (const TpsData & zz) 
{
    if (tps_data != zz.tps_data) 
      {
	if ( (mem_order < zz.max_order) || (num_var != zz.num_var) )
	  {
	    if (mem_order >= 0) 
	      {
		delete [] tps_data;
	      }
	    num_var = zz.num_var;
	    mem_order = zz.max_order;
	    tps_data = new double [nmo[num_var][mem_order]];
	  }
	max_order = zz.max_order;
	acc_order = zz.acc_order;
	min_order = zz.min_order;
	count = 1;
	memcpy(tps_data, zz.tps_data , nmo[num_var][max_order]*sizeof(double));
      }
    return *this;
}

void TpsData::negative(const TpsData& zz) const
{
  for (int i=nmob[zz.num_var][zz.min_order]; 
           i<nmo[zz.num_var][zz.max_order]; ++i)
    {
      tps_data[i] = - zz.tps_data[i];
    }
}

void TpsData::additionEqualVar(const TpsData& za, const TpsData& zb)
{
  register int i;
  int *nmoob; nmoob = nmob[num_var];
  int *nmoo; nmoo = nmo[num_var];
  for (i=nmoob[min_order]; i<nmoo[max_order]; ++i) tps_data[i] = 0.0;
  for (i=nmoob[za.min_order]; i<nmoo[min(za.max_order, max_order)]; ++i) 
      tps_data[i] += za.tps_data[i];
  for (i=nmoob[zb.min_order]; i<nmoo[min(zb.max_order, max_order)]; ++i) 
      tps_data[i] += zb.tps_data[i];
}

void TpsData::addition(const TpsData& za, const TpsData& zb)
{           // must be za.num_var < zb.num_var since jt is za -> zb **
  register int i;
  int *jts; jts = jt[za.num_var][zb.num_var];
  memcpy(tps_data, zb.tps_data, nmo[num_var][zb.max_order]*sizeof(double));
  int *nmoob; nmoob = nmob[za.num_var];
  int *nmoo; nmoo = nmo[za.num_var];
  if (max_order > zb.max_order) clear(zb.max_order+1, max_order);
  if (min_order < zb.min_order) clear(min_order, zb.min_order-1);
  for (i=nmoob[za.min_order]; i<nmoo[za.max_order]; ++i)
      tps_data[jts[i]] += za.tps_data[i];
}

void TpsData::addConst(double cc)
{
  clear( 0, min_order-1);
  min_order = 0;
  tps_data[0] += cc;
}  

void TpsData::multiplication(const TpsData& za, const TpsData& zb)
{                              // must be za.num_var >= zb.num_var
  register int low_ord, high_ord, i, j, order;
  register int *nmoo, *nmoob, **ikkp, **ikkb, *kpp, *lpp, *ikpp, *ikbb;
  nmoo = nmo[num_var];
  nmoob = nmob[num_var];
  ikkp = ikp[num_var][zb.num_var];
  ikkb = ikb[num_var][zb.num_var];
  kpp = kp[num_var][zb.num_var];
  lpp = lp[num_var][zb.num_var];
  for (order=min_order; order<=max_order; ++order)
    {
      low_ord = max(order-zb.max_order, za.min_order);
      high_ord = min(za.max_order, order-zb.min_order);
      ikpp = ikkp[high_ord];
      ikbb = ikkb[low_ord];
      for (j=nmoob[order]; j<nmoo[order]; ++j)
	{
	  tps_data[j] = 0.0;  // clear
	  for (i=ikbb[j]; i<=ikpp[j]; ++i) // ??
	    {
	      tps_data[j] += za.tps_data[kpp[i]]*zb.tps_data[lpp[i]];
	    }
	}
    }
}

void TpsData::multiplication(const TpsData& zz, double cc)
{
  for (int j=nmob[num_var][min_order]; j<nmo[num_var][max_order]; ++j)
    {
      tps_data[j] = zz.tps_data[j]*cc;
    }
}    

void TpsData::derivative(TpsData & zz, int iv)
{
  int **jvv, *jdd;
  jvv = jv[num_var];
  jdd = jd[num_var][iv];
  for (int j=nmob[num_var][min_order]; j< nmo[num_var][max_order]; ++j)
    {
      tps_data[j] = (jvv[j][iv+1]+1)*zz.tps_data[jdd[j]];
    }
}

void TpsData::integral(TpsData & zz, int iv)
{
  int **jvv, *jdd;
  jvv = jv[num_var];
  jdd = jd[num_var][iv];
  clear(min_order, max_order);
  for (int j=nmob[num_var][min_order-1]; j< nmo[num_var][max_order-1]; ++j)
    {
      tps_data[jdd[j]] = zz.tps_data[j]/(jvv[j][iv+1]+1);
    }
}

void TpsData::multiplyVariable(TpsData & zz, int iv) 
{
  int *jdd;
  jdd = jd[num_var][iv];
  clear( min_order, max_order);
  for (int j=nmob[num_var][min_order-1]; j< nmo[num_var][max_order-1]; ++j)
    {
      tps_data[jdd[j]] = zz.tps_data[j];
    }
}

void TpsData::transformVariable(TpsData & zz) 
{         // must be zz.num_var < num_var since jt is zz to *this **
  int *jts; jts = jt[zz.num_var][num_var];
  clear( min_order, max_order);
  for (int j=nmob[zz.num_var][min_order]; j< nmo[zz.num_var][max_order]; ++j)
    {
      tps_data[jts[j]] = zz.tps_data[j];
    }
}

void TpsData::lineIntegralDiagonal(int nVar, double c)
{
  int **jvv;  jvv = jv[num_var];
  for (int j=nmob[num_var][min_order]; j< nmo[num_var][max_order]; ++j)
    {
      int pp1 = jvv[j][1] + 1;
      for (int iv =2; iv <= nVar; ++iv) pp1 += jvv[j][iv];
      tps_data[j] *= pwr(c,pp1)/pp1;
    }
}  

void TpsData::condense(double eps)
{
  for (int j=nmob[num_var][min_order]; j< nmo[num_var][max_order]; ++j)
      if (fabs(tps_data[j]) < eps) tps_data[j] = 0.0;
}

void TpsData::ratio(const TpsData &zz) //ratio for each corresponding coefficient.
{
  for (int j=nmob[num_var][min_order]; j< nmo[num_var][max_order]; ++j)
    tps_data[j] /= zz.tps_data[j];
}

void TpsData::subTpsData(TpsData & zz)
{
  int i;
  int **jvv;
  jvv = jv[num_var];
  int *js;
  js = new int[zz.num_var+1];
  for (i=num_var+1; i<zz.num_var+1; ++i) js[i] = 0;
  for (int j=nmob[num_var][min_order]; j<nmo[num_var][max_order]; ++j)
    {
      for (i=0; i<=num_var; ++i) js[i] = jvv[j][i];
      tps_data[j] = zz.tps_data[jpek(zz.num_var,js)];
    }  
}

void TpsData::homogeneous(int order, int nVar)
{
  int i;
  int **jvv = jv[num_var];
  for (int j=nmob[num_var][min_order]; j<nmo[num_var][max_order]; ++j)
    {
      int ord = jvv[j][1];
      for (i=2; i<=nVar; ++i) ord += jvv[j][i];
      if (ord !=order) tps_data[j] = 0.0;
    }  
}

void TpsData::clear(int min_ord, int max_ord)
{
  int max_size = nmo[num_var][ min(max_ord, mem_order) ];
  for (int j=nmob[num_var][min_ord]; j<max_size; ++j)
    {
      tps_data[j] = 0.0;
    }
}    

void TpsData::fillOrder(int max_ord, int acc_ord, int min_ord)
{
  max_order = max_ord;
  acc_order = acc_ord;
  min_order = min_ord;
}

void TpsData::maxOrderChange(int max_ord)
{
  if (max_ord < max_order)
    {
      max_order = max_ord;
      acc_order = max_ord;
    }
  else if (max_ord > max_order)
    {
      clear(max_order+1, max_ord);
      max_order = max_ord;
    }
}

void TpsData::accOrderChange(int acc_ord)
{
  if (acc_ord < acc_order)
    {
      acc_order = acc_ord;
    }
}

void TpsData::forceAccOrderChange(int acc_ord)
{
      acc_order = acc_ord;
}

void TpsData::minOrderChange(int min_ord)
{
  if (min_ord > min_order)
    {
      min_order = min_ord;
    }
  else if (min_ord < min_order)
    {
      clear(min_ord, min_order-1);
      min_order = min_ord;
    }
}

bool TpsData::operator==(const TpsData& zps) const
{
  if (num_var != zps.num_var) return 0;
  if (acc_order != zps.acc_order) return 0;
  if (max_order != zps.max_order) return 0;
  if (min_order != zps.min_order) return 0;
  for (int j=nmo[num_var][min_order]; j< nmo[num_var][max_order]; ++j)
    {
      if (fabs(tps_data[j]-zps.tps_data[j]) > ZLIB_TINY) return 0;
    }
  return 1;
}  

bool TpsData::checkTpsData()
{
    for (int j=nmob[num_var][min_order]; j<nmo[num_var][max_order]; ++j)
    {
      if ( fabs(tps_data[j]) > ZLIB_TINY) return 1;
    }
  return 0;
}

int TpsData::searchMinOrder(int startOrder)
{
  int min_ord = 0;  // look for min_order after startOrder-1
  for (int io=startOrder; io<=max_order; ++io)
    {
      for (int j=nmob[num_var][io]; j<nmo[num_var][io]; ++j)
	{
	  if ( fabs(tps_data[j]) > ZLIB_TINY) 
	    {
	      min_ord = io;
	      break;
	    }
	}
      if (min_ord) break;
    }
  return min_ord;
}

void TpsData::getFi(TpsData& fi, int order, double mux, double muy, TpsData& Hi)
{
  int nVar = num_var; int canD = nVar/2; int nVarH = nVar - canD;
  double* chpre; chpre = new double[ nmo[nVar][order] ];
  double* chpim; chpim = new double[ nmo[nVar][order] ];
  for (int j=nmob[nVar][order]; j<nmo[nVar][order]; ++j) {
    int *jsv; jsv = jv[nVar][j];
    int * js; js = new int[nVar+1]; for (int i=0; i<=nVar; ++i) js[i]=jsv[i];
    int l=js[1];  int m=js[2]; int n=js[3];  int o=js[4]; 
    int lm = l+m; int no=n+o;
    // C^'_lmnop = sin(th)/(1-cos(h) * i * C^_lmnop; ^^^^^^^^^^^^
    // C^_lmnop = (1/2)^(l+m+n+o) * sum_a=0->m; #################
    double chreal=0.0; double chimag = 0.0; 
    // sum_a=0->m @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    double sumar=0.0; double sumai = 0.0; 
    for (int a=0; a<=m; ++a) {
      int ma = m-a;
      // sum_k=ma->lm-a &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
      double sumkr=0.0; double sumki = 0.0; 
      for (int k=ma; k<=lm-a; ++k) {
	js[1]=lm-k; js[2]=k;
	// sum_c=0->o %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	double sumcr = 0.0;  double sumci = 0.0; 
	for (int c=0; c<=o; ++c) {
	  int oc = o-c;
	  // sum_h=oc->no-c *************************************
	  double sumhr=0.0; double sumhi=0.0;
	  for (int h=oc; h<=no-c; ++h) {
	    js[3]=no-h; js[4]=h;
	    double tm = kbinom(no-h,c)*kbinom(h,oc)*fi[ jpek(nVar,js) ];
	    double th = h - (h/4)*4;
	    if (th==0) {sumhr += tm;}
	    else if (th==1) {sumhi += tm;}
	    else if (th==2) {sumhr -= tm;}
	    else if (th==3) {sumhi -= tm;}
	  }
	  // sum_h=oc->no-c *************************************
	  int toc = oc - (oc/2)*2;
	  if (toc){ sumcr -= sumhr; sumci -= sumhi; }
	  else { sumcr += sumhr; sumci += sumhi; }
	}
	// sum_c=0->o %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	double temp = kbinom(lm-k,a)*kbinom(k,ma);
	double tk = k - (k/4)*4;
	if (tk==0) {sumkr += temp*sumcr; sumki += temp*sumci;}
	else if (tk==1) {sumkr -= temp*sumci; sumki += temp*sumcr;}
	else if (tk==2) {sumkr -= temp*sumcr; sumki -= temp*sumci;}
	else if (tk==3) {sumkr += temp*sumci; sumki -= temp*sumcr;}
      }
      // sum_k=ma->lm-a &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
      int tma = ma - (ma/2)*2;
      if (tma) { sumar -= sumkr; sumai -= sumki; }
      else { sumar += sumkr; sumai += sumki; }
    }
    // sum_a=0->m @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    int lmno = lm + no;
    double pwr2lmno = pwr(0.5,lmno);
    chreal = sumar * pwr2lmno;
    chimag = sumai * pwr2lmno;
    // C^_lmnop = (1/2)^(l+m+n+o) * sum_a=0->m; #################
    if ( l==m & n==o & m+o>0 ) { 
      chpre[j]=0.0; chpim[j] = 0.0; 
      int *jhs; jhs = new int[nVarH+1]; 
      jhs[1]=m; jhs[2]=o; jhs[nVarH] = js[nVar]; 
      jhs[0] = jhs[1]; for (int k=2; k<=nVarH; ++k) jhs[0] += jhs[k];
      //      chre [ jpek(nVarH,jhs) ] = chreal;
      Hi [ jpek(nVarH,jhs) ] = chreal;
      //      cout <<l<<m<<n<<o<<js[5]<< ' '<< jpek(nVarH,jhs) 
      //	   << ' ' << chreal << ' ' << chimag << endl;
    }
    else {
      double th = (l-m)*mux + (n-o)*muy;
      double scth = sin(th)/(1-cos(th));
      chpre[j] = 0.5 * (chreal + scth * chimag);
      chpim[j] = 0.5 * (chimag - scth * chreal);
      /*
      if (mux >= 7) {
	chpre[j] = chreal;
	chpim[j] = chimag;
      }
      */
      // C^'_lmnop = (1/2)*(1-[sin(th)/(1-cos(th)]*i) * C^_lmnop;^^
    }
  }

  double* cpre; cpre = new double[ nmo[nVar][order] ];
  double* cpim; cpim = new double[ nmo[nVar][order] ];
  for (int j=nmob[nVar][order]; j<nmo[nVar][order]; ++j) {
    int *jsv; jsv = jv[nVar][j];
    int * js; js = new int[nVar+1]; for (int i=0; i<=nVar; ++i) js[i]=jsv[i];
    int l=js[1];  int m=js[2]; int n=js[3];  int o=js[4]; 
    int lm = l+m; int no=n+o;
    // sum_a=0->m @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    double sumar=0.0; double sumai = 0.0; 
    for (int a=0; a<=m; ++a) {
      int ma = m-a;
      // sum_k=ma->lm-a &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
      double sumkr=0.0; double sumki = 0.0; 
      for (int k=ma; k<=lm-a; ++k) {
	js[1]=lm-k; js[2]=k;
	// sum_c=0->o %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	double sumcr = 0.0;  double sumci = 0.0; 
        for (int c=0; c<=o; ++c) {
	  int oc = o-c;
	  // sum_h=oc->no-c *************************************
	  double sumhr=0.0; double sumhi=0.0;
	  for (int h=oc; h<=no-c; ++h) {
	    js[3]=no-h; js[4]=h;
	    int jpt = jpek(nVar,js);
	    double tm = kbinom(no-h,c)*kbinom(h,oc);
	    sumhr += tm * chpre[jpt];
	    sumhi += tm * chpim[jpt];
	  }
	  // sum_h=oc->no-c *************************************
	  int tc = c - (c/2)*2;
	  if (tc){ sumcr -= sumhr; sumci -= sumhi; }
	  else   { sumcr += sumhr; sumci += sumhi; }
	}
	// sum_c=0->o %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	double temp = kbinom(lm-k,a)*kbinom(k,ma);
	sumkr += temp*sumcr; sumki += temp*sumci;
      }
      // sum_k=ma->lm-a &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
      int ta = a - (a/2)*2;
      if (ta) { sumar -= sumkr; sumai -= sumki; }
      else { sumar += sumkr; sumai += sumki; }
    }
    // sum_a=0->m @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    int mo = m + o;
    double tk = mo - (mo/4)*4;
    if (tk==0)       {cpre[j] =  sumar; cpim[j] =  sumai;}
    else if (tk==1)  {cpre[j] = -sumai; cpim[j] =  sumar;}
    else if (tk==2)  {cpre[j] = -sumar; cpim[j] = -sumai;}
    else if (tk==3)  {cpre[j] =  sumai; cpim[j] = -sumar;}
    tps_data[j] = cpre[j];
  }
}

void TpsData::excludeNoParaDependentTerms(int lastindxs) {
  int **jvv;  jvv = jv[num_var];
  int varBegin = num_var-lastindxs+1;
  for (int j=nmob[num_var][min_order]; j<nmo[num_var][max_order]; ++j) {
    int flag = 1;
    for (int i=varBegin; i<=num_var; ++i) {
      if (jvv[j][i]>0) flag=0;
    }
    if (flag) tps_data[j] = 0.0;
  }
}

void TpsData::nonlinearBetaParaTerms(int lastindxs) {
  int **jvv;  jvv = jv[num_var];
  int varBegin = num_var-lastindxs+1;
  for (int j=nmob[num_var][min_order]; j<nmo[num_var][max_order]; ++j) {
    int flag = 1; int paraOrd=0;
    for (int i=varBegin; i<=num_var; ++i) paraOrd += jvv[j][i];
    if (paraOrd) {
      if ( (jvv[j][0]-paraOrd)== 1) flag = 0;
    }
    if (flag) tps_data[j] = 0.0;
  }
}

void TpsData::deltaGiven(double eps, int lastindxs) {
  int **jvv;  jvv = jv[num_var];
  int varBegin = num_var-lastindxs+1;
  for (int j=nmob[num_var][min_order]; j<nmo[num_var][max_order]; ++j) {
    int flag = 1; int paraOrd=0;
    for (int i=varBegin; i<=num_var; ++i) paraOrd += jvv[j][i];
    if (paraOrd) {
      if ( (jvv[j][0]-paraOrd)== 1) flag = 0;
    }
    if (flag) { tps_data[j] = 0.0; }
    else { tps_data[j] *= pwr(eps,paraOrd); }
  }
}

//*************** ListTps ***************************************

int ListTps::numTpsDataStored = 0;
int ListTps::numTpsNewAlloc = 0;

//ofstream Lout("listTps.out");



void ListTps::prepend(TpsData *zp)
{
     ListTpsElem * temp = new ListTpsElem;
     temp->next = head;
     temp->zp = zp;
     head = temp;
     //     Lout << "(" << zp->num_var << ", " << zp->mem_order 
     //     << ")  ++ numTpsDataStored = " << ++numTpsDataStored << endl;
}

void ListTps::print(ofstream& fout)
{
     ListTpsElem * temp = head;
     while (temp != 0) 
     {
         fout << temp->zp << " -> ";
	 temp = temp->next;
     }       
     fout << "\n******************\n";
}

void ListTps::del()              
{ 
     ListTpsElem* temp = head;
     head = head->next;
     delete temp;
}

void ListTps::release()
{
     if (head != 0) cout << " release Tps ";
     while (head != 0) del();
}

TpsData* ListTps::gethead()
{
     if (head != 0) 
       {
	 TpsData *zp=head->zp;
	 zp->count = 1;
         del();
	 //	 Lout << "(" << zp->num_var << ", " << zp->mem_order 
	 //     << ") -- numTpsDataStored = " << --numTpsDataStored << endl;
	 return zp;
       }
     else
       {
	 //	 Lout << " *** new alloc numTps = " << ++numTpsNewAlloc << endl;
	 TpsData * zp=0;
	 return zp;
       }
}




