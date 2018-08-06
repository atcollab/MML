#include "Vec.hpp"

VecData::VecData(int _n): n(_n), v(new double [_n]), count(1) {
     for (int i=0; i<_n; ++i) v[i]=0.0;
}
  
VecData & VecData::operator = (const VecData &_v) {
    if (v != _v.v) {
      if (n < _v.n) {
         delete [] v;
          v = new double [_v.n];
      }
      n = _v.n;
      count = 1;
      memcpy(v, _v.v , n*sizeof(double));
    }
    return *this;
}

double & Vec::operator [] (int i) {
    if (!(v->OnlyOne())) {
      --(*v);
      v=new VecData(*v);
    }
    return (*v)[i];
  }

double & Vec::operator () (int i) {
    if (!(v->OnlyOne())) {
      --(*v);
      v=new VecData(*v);
    }
    return (*v)[i-1];
  }


Vec& Vec::operator=(const Vec& _v) {
    if (v != _v.v) {
      --(*v);
      if (v->AllGone()) delete v;
      v=_v.v;
      ++(*v);
    }
    return *this;
}

Vec Vec::operator+(const Vec& _v) const {
    Vec vr(v->getSize());
    for (int i=0 ; i < v->getSize() ; ++i)
      (*vr.v)[i] = (*v)[i] + (*_v.v)[i];
    return vr;
}

Vec Vec::operator-(const Vec& _v) const {
    Vec vr(v->getSize());
    for (int i=0 ; i < v->getSize() ; ++i)
      (*vr.v)[i] = (*v)[i] - (*_v.v)[i];
    return vr;
}

Vec Vec::operator*(double cc) const {
    Vec vr(*this);
    for (int i=0; i < v->getSize(); ++i) vr[i] *= cc;
    return vr;
}

Vec operator*(double cc, const Vec& V) {
    Vec vr(V);
    for (int i=0; i < V.getSize(); ++i) vr[i] *= cc;
    return vr;
}
    

double Vec::operator*(const Vec& _v) const {   
    double temp = 0.0;
    for (int i=0 ; i < v->getSize() ; ++i)
      temp += (*v)[i] * (*_v.v)[i];
    return temp;
}

Vec& Vec::operator+=(const Vec& _v) {
    if (!(v->OnlyOne())) {
      --(*v);
      v=new VecData(*v);
    }
    for (int i=0 ; i < v->getSize() ; ++i)   // otherwise can be a lot of checking
      (*v)[i] += (*_v.v)[i];
    return *this;
}

Vec& Vec::operator-=(const Vec& _v) {
    if (!(v->OnlyOne())) {
      --(*v);
      v=new VecData(*v);
    }
    for (int i=0 ; i < v->getSize() ; ++i)   //otherwise can be a lot of checking
      (*v)[i] -= (*_v.v)[i];
    return *this;
}

ostream& operator << (ostream& out, const Vec & _v) {
  //  out << "V" << ' ' << _v.v->getSize() << "\n";
  for (int i=0; i < _v.v->getSize(); i++) out << _v[i] << ' ';
  out << "\n";
  return (out);
}

istream& operator >> (istream& in, Vec & _v) {
  char ch;
  int size;
  in >> ch >> size;
  if ( !(size == _v.v->getSize()) ) {
     --(*_v.v);
     if (_v.v->AllGone()) delete _v.v;
     _v.v = new VecData(size);
     if (!_v.v) {cerr << "Vec istream mem problem\n"; exit(1);}
  }
  for (int i=0; i < size; i++) in >> _v[i];
  return (in);
}


double Vec::norm() {
  return sqrt( (*this) * (*this) );
}

