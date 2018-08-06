function [x1, y1, x2, y2] = xyechotek(data, varargin)
%function [x1, y1, x2, y2] = xyechotek(data)
%Convert echotek data (as save in mat files) to x, y orbit
%Input:
%   data,   8xN matrix, complex,  data(1,:) 
%	data is a 8x65536 matrix, each row is a complex sequence corresponding I+iQ
%	for 65536 turns. The eight rows correspond to 8 buttons of 2 BPMs, which
%	are (OL1, IL1, IU1, OU1, OL2, IL2, IU2, OU2).----from Jim Sebek, 3/13/06
%
%[x1, y1, x2, y2] = xyechotek(data, 'nocali')
%

		XGAIN = 19.4; %[mm/[u]]
		YGAIN = 21.4; %[mm/[v]]

A = abs(data(3,:));
B = abs(data(4,:));
C = abs(data(1,:));
D = abs(data(2,:));

SUM = real(A+B+C+D);

zindx = find(SUM==0);
nzindx = setxor(1:length(A), zindx);

	x1(nzindx) = real(-A(nzindx)+B(nzindx)+C(nzindx)-D(nzindx))./SUM(nzindx);
	y1(nzindx) = real( A(nzindx)+B(nzindx)-C(nzindx)-D(nzindx))./SUM(nzindx);
	x1(zindx) = 0;
	y1(zindx) = 0;

A = abs(data(3+4,:));
B = abs(data(4+4,:));
C = abs(data(1+4,:));
D = abs(data(2+4,:));

SUM = real(A+B+C+D);

zindx = find(SUM==0);
nzindx = setxor(1:length(A), zindx);

	x2(nzindx) = real(-A(nzindx)+B(nzindx)+C(nzindx)-D(nzindx))./SUM(nzindx);
	y2(nzindx) = real( A(nzindx)+B(nzindx)-C(nzindx)-D(nzindx))./SUM(nzindx);
	x2(zindx) = 0;
	y2(zindx) = 0;

    opt = 'cali';
if nargin>=2
   opt = varargin{1};
end
if strcmp(opt, 'cali')
      x1 = x1*XGAIN;
      y1 = y1*YGAIN;
      x2 = x2*XGAIN;
      y2 = y2*YGAIN;
       
end
   