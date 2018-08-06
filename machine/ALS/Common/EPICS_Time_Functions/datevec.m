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
## @deftypefn {Function File} {V} datevec(date)
## @deftypefnx {Function File} {[Y,M,D,h,m,s] =} datevec(date)
## Breaks the number of days since Jan 1, 0000 into a year-month-day
## hour-minute-second format. By this reckoning, Jan 1, 1970 is day
## number 719529.  The fractional portion of @code{date} corresponds to the
## portion of the given day. If a single return value is requested,
## then the components of the date are columns of the matrix @code{V}.
##
## Note: 32-bit architectures only handle times between Dec 14, 1901 
## and Jan 19, 2038, with special handling for 0000-01-01.  datenum
## returns -1 in case of a range error.
##
## The parameter @code{P} is needed to convert date strings with 2 digit
## years into dates with 4 digit years.  2 digit years are assumed to be
## between @code{P} and @code{P+99}. If @code{P} is not given then the 
## current year - 50 is used, so that dates are centered on the present.
## For birthdates, you would want @code{P} to be current year - 99.  For
## appointments, you would want @code{P} to be current year.
##
## Dates must be represented as mm/dd/yy or dd-mmm-yyyy.  Times must
## be hh:mm:ss or hh:mm:ss PM, with seconds optional.  These correspond 
## to datestr format codes 0, 1, 2, 3, 13, 14, 15, 16.
##
## @seealso{date,clock,now,datestr,datenum,calendar,weekday} 
## @end deftypefn

function [Y,M,D,h,m,s] = datevec(date,P)

  if nargin == 0 || nargin > 2
    usage("V=datevec(n) or [Y,M,D,h,m,s]=datevec(n)");
  endif
  if nargin < 2, P = []; endif

  if isstr(date)
    if isempty(P)
      tm = localtime(time);
      P = tm.year+1900-50;
    endif

    global __month_names = ["Jan";"Feb";"Mar";"Apr";"May";"Jun";...
			    "Jul";"Aug";"Sep";"Oct";"Nov";"Dec"];
    global __time_names = ["AM";"PM"];

    Y = h = m = s = zeros(rows(date),1);
    M = D = ones(size(Y));
    error("datevec: doesn't handle strings yet");
  else
    Y = h = m = s = zeros(size(date));
    M = D = ones(size(Y));
    for i = 1:prod(size(date))
      if date(i) < 1
	t = 86400*date(i);
	h(i) = floor(t/3600);
	t = t - 3600*h(i);
	m(i) = floor(t/60);
	t = t - 60*m(i);
	s(i) = t;
      else
      	tm = gmtime((date(i) - 719529)*86400);
      	Y(i) = tm.year+1900;
      	M(i) = tm.mon+1;
      	D(i) = tm.mday;
      	h(i) = tm.hour;
      	m(i) = tm.min;
      	s(i) = tm.sec+tm.usec*1e-6;
      endif
    endfor
  endif

  if nargout <= 1
    Y = [ Y(:), M(:), D(:), h(:), m(:), s(:) ];
  endif
endfunction
