## Copyright (C) 2000 Paul Kienzle
##
## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 2 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program; if not, write to the Free Software
## Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

## -*- texinfo -*-
## @deftypefn {Function File} {} datenum(Y, M, D [, h , m [, s]])
## @deftypefnx {Function File} {} datenum('date' [, P])
## Returns the specified local time as a number of days since Jan 1, 0000.
## By this reckoning, Jan 1, 1970 is day number 719529.  The fractional
## portion, corresponds to the portion of the specified day.
##
## Note: 32-bit architectures only handle times between Dec 14, 1901 
## and Jan 19, 2038, with special handling for 0000-01-01.  datenum
## returns -1 in case of a range error.
##
## @seealso{date,clock,now,datestr,datevec,calendar,weekday}
## @end deftypefn

## 2001-08-30 Paul Kienzle <pkienzle@users.sf.net>
## * make it independent of time zone

function n = datenum(Y,M,D,h,m,s)
  if nargin == 0 || (nargin > 2  && isstr(Y)) || nargin > 6
    usage("n=datenum('date' [, P]) or n=datenum(Y, M, D [, h, m [, s]])");
  endif
  if isstr(Y)
    if nargin < 2, M=[]; endif
    [Y,M,D,h,m,s] = datevec(Y,M);
  else
    if nargin < 6, s = zeros(size(Y)); endif
    if nargin < 5, m = s; endif
    if nargin < 4, h = s; endif
  endif

  n = zeros(size(Y));

  for i=1:prod(size(Y))
    tm.usec = 1e6*rem(s(i),1);
    tm.sec = floor(s(i));
    tm.min = m(i);
    tm.hour = h(i);
    tm.mday = D(i);
    tm.mon = M(i)-1;
    tm.year = Y(i)-1900;
    tm.zone = "CUT";
    tm.wday = 0;
    tm.yday = 0;
    tm.isdst = 0;
    if (Y(i) == 0 && M(i) == 1 && d(i) == 1)
      n(i) = (h(i)*3600 + m(i)*60 + s(i))/86400;
    else
      t = mktime(tm);
      if (t==-1 && Y(i) != 1969)
	n(i) = -1;
      else
      	n(i) = t / 86400 + 719529;
      endif
    endif
  endfor

  ## Correct for time zone
  n -= mktime(gmtime(0))/86400;
endfunction

%!assert(datevec(datenum(2003,11,28)),[2003,11,28,0,0,0])
