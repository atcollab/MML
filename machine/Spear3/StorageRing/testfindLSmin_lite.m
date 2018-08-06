function v=testfindLSmin(varargin)
%this is an example showing how to use findLSmin.m
%the problems are drawon from More's paper
%

opt =1;
switch opt
case 1
    p0 = [-1, 0, 0]';
    [pm,chi2,hist] = findLSmin_lite(@fFlectherPowell, p0);
    %[pm,chi2,hist] = findLSmin(@fFlectherPowell, p0);
case 2
    p0 = [25, 5, -5, 1]';
    [pm,chi2,hist] = findLSmin_lite( @fBrownDennis, p0);
 %   [pm,chi2,hist] = findLSmin( @fBrownDennis, p0);
case 3
	N = 40;
	n = (1:N)';
	global g_yv;
	b = 1.0;
	A = 5.0;
	lambda = 0.1;
	g_yv = b + A*exp(-lambda*n)+0.1*randn(N,1);

	p0 = [0, 1, 0]';
	[pm,chi2,hist] = findLSmin_lite( @fGSLex, p0);
%    [pm,chi2,hist] = findLSmin( @fGSLex, p0);
end
    v.pm = pm;
    v.chi2 = chi2;
    v.hist = hist;

%display the results
cnt = 0;
for ii=1:length(v.hist)
	if isempty(v.hist{ii})
		continue;
	end
	cnt = cnt + 1;
	
	chi2(cnt) = v.hist{ii}.chi2;
    lambda(cnt) = v.hist{ii}.lamda;
	disp(sprintf('iter %d  chi2=%6.4f  lambda=%6.4f', cnt,chi2(cnt),lambda(cnt)))
end
n = 1:cnt;
figure
plot(n, log10(chi2));
xlabel('iteration')
ylabel('log10(chi2)');
grid on
figure
plot(n, log10(lambda));
xlabel('iteration')
ylabel('log10(lambda)');
grid on
save tmp 

function f = fFlectherPowell(p)
f1 = 10*(p(3)-10*theta(p(1),p(2)));
f2 = 10*(sqrt(p(1)^2+p(2)^2) - 1);
f3 = p(3);
f = [f1, f2, f3]';
function val = theta(x1,x2)
if x1>0
	val = atan(x2/x1)/2./pi;
elseif x1<0
	val = atan(x2/x1)/2./pi+0.5;
%else
%	val = 0.25;
end

function f = fBrownDennis(p)
m=20;
t = 0.2*(1:m);
for ii=1:m
   f(ii,1) =  (p(1)+p(2)*t(ii)-exp(t(ii)))^2 + (p(3)+p(4)*sin(t(ii))-cos(t(ii)))^2;
end

function f = fGSLex(p)
N = 40;
n = (1:N)';
global g_yv;

f = g_yv - (p(1)+p(2)*exp(-p(3)*n));
	
