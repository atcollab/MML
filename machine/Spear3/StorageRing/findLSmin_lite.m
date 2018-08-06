function [pm,chi2,reshist] = findLSmin_lite(cfun, p0, varargin)
%[pm,chi2,reshist] = findLSmin_lite(cfun, p0, varargin)
%[pm,chi2,reshist] = findLSmin_lite(cfun, p0, delta_p)
%[pm,chi2,reshist] = findLSmin_lite(cfun, p0, delta_p, LMoption)
%This is a wrapper of the least square code "lemafit.m" (X. Huang, 2003) which implement the 
%simple version of the Leverberg-Marquadt method as described in Numerical Recipe in C
%The function interface is made the same as "findLSmin.m". 
%Input: 
%cfun, a function handle to calculate the residual vector f
%f = cfun(p)
%    p, NPx1, the parameter vector
%    f, Nx1,  chi2 = 1/2 f'*f, 
%p0, NPx1,
%    the initial value of the parameter vector
%delta_p, NPx1,
%    the small deviation for each parameter being used in the calculation of 
%    Jacobian matrix. By default using delta_p = ones(size(p))*1.0e-6 
%    J, NxNP, $J_{ij} = d f_i/d p_j$
%LMoption, 
%    an option structure containing {sigma, SVtol, MaxIter, XTOL, FTOL,
%    Delta0}, if not supplied, the default values are {0.1, 0, 1000,
%    1.e-8, 1.e-8, sqrt(NP)}. SVtol=0 means using the default.
%Output:
%pm,       NPx1, p value at minimum
%chi2,     minimal chi2 = 1/2 f'*f,
%reshist,  a list of cells containing the history of iterations
%
%note 
%(1) The experimental data must be supplied through the function cfun
%
%For examples of using this routine, see testfindLSmin_lite.m
%
%Author: Xiaobiao Huang, created 9/20/2007
%last update, 
%

LMoption.nomessage = 1;  %set to 0 if you want the message
LMoption.sigma = 0.1;
LMoption.SVtol = 1.0e-6; %since we use pinv, tolv is not used. 
LMoption.MaxIter = 1000;
LMoption.XTOL = 1.e-8;
LMoption.FTOL = 1.e-8;
LMoption.Lambda0 = 0.01;  %initial Delta, the size of trusted region
if nargin>=4
   LMoption = varargin{2}; 
end
[pm,Cii,chi2s,diags,covm,hist] = lemafit(cfun, p0, LMoption);
chi2 = chi2s(end);
reshist = hist;

function flag = stopcriterion(chi20, chi2, p0, p, LMoption)
flag = (abs(norm(p-p0))<2*eps) | (chi2<eps*2) | (abs(1.0-chi2/chi20)<LMoption.FTOL);
if flag
%    disp([ (abs(norm(p-p0))<2*eps)  (chi2<eps*2)  (abs(1.0-chi2/chi20)<LMoption.FTOL)]);
end

function nchi2 = f_nchi2(calcf, para)
%
f = calcf(para);
nchi2 = f'*f/length(f);

function [A,B] = f_lmmatrix(calcf,para)
%
f = calcf(para);
delta = ones(size(para))*1.0e-6;
if nargin>=3
   delta = varargin{1}; 
end
p0 = para;
for ii=1:length(delta)
	p = p0;	
	p(ii) = p(ii) + delta(ii);
    fn = calcf(p);
    cJ(:,ii) = (fn-f)/delta(ii);
end
A = cJ'*cJ;
B = -cJ'*f;

function [para,Cii,chi2s,varargout] = lemafit(calcf, para_init,LMoption)
%[para,Cii,chi2s] = lemafit(calcf,data, para_init,nrep,varargin)
%a general L-M nonlinear fitting code
%nchi2 = f_nchi2(para) to return nchi2
%[A,B] = f_lmmatrix(para) to return \alpha matrix and \beta vector
%data,  to be fitted
%para_init,  initial parameters
%nrep,    run nrep iterations
%output:
%para:    fitting result
%Cii:     diagonal element of \alpha matrix, related to error bar
%chi2s:   a record of chi2s of each iteration 

nomessage = LMoption.nomessage;

tolv =LMoption.SVtol;
if tolv>1.0e-4
      disp(['Warning: is your SV cut-off threshold ' num2str(tolv,'%1.2e') ' too large ']); 
end

para0 = para_init;
para = para0;
nrep = LMoption.MaxIter;

%chi2 = feval(f_nchi2,calcf, para0);
chi2 = f_nchi2(calcf,para0);
chi2s = zeros(20,1);

%lamda = 1.e-2;
lamda = LMoption.Lambda0;

chi20 = chi2;
if ~nomessage
	message = sprintf('initial, chi2=%f\t lamda=%e',chi2,lamda);
	disp (message)
end
		
cnt = 0;
downcnt = 0;

tnode.chi2 = chi20;
tnode.lamda= lamda;
tnode.para = para;
hist{downcnt+1} = tnode;

while downcnt < nrep
    chi2s(cnt+1) = chi20;
        
	if abs(chi20 - chi2) < 1.e-5
		if ~nomessage
			disp 'calculating alpha, beta,...'
		end
		%[A0,B]= feval(f_lmmatrix,calcf,para0);
		[A0,B]= f_lmmatrix(calcf,para0);
	end
	A = A0;
	for i=1:length(B)
		A(i,i) = A(i,i) * (1.+lamda);
	end
	if ~isempty(find(A==NaN)) || ~isempty(find(A==Inf))
        break
    end
% 	[u,s,v] = svd(A);
%   	vs = zeros(size(s));
% 	for ii = 1:size(s,2)
% 	     if s(ii,ii) > tolv
% 	          vs(ii,ii) = 1./s(ii,ii);   
% 	     end 
% 	end
% 	dx = v*vs*u'*B;
    dx = pinv(A)*B;
    
	para = para + dx;
	chi2 = f_nchi2(calcf,para);
	if chi2 < chi20
		lamda = lamda /10.;
        
        flag = stopcriterion(chi20, chi2, para, para+dx, LMoption);
		para0 = para;
		chi20 = chi2;
		downcnt = downcnt + 1;
		
		tnode.chi2 = chi20;
		tnode.lamda= lamda;
		tnode.para = para;
		hist{downcnt+1} = tnode;

		if ~nomessage
		message = sprintf('down, chi2=%f\t lamda=%e',chi2,lamda);
		disp (message)
        end
       
        if flag
            break
        end
	else
		lamda = lamda*10.;
		para = para0;
		
        if lamda >= 1E15
            break;
        end

		if ~nomessage
		message = sprintf('up, chi2=%f\t lamda=%e',chi2,lamda);
		disp (message)
		end
	end
	
	cnt = cnt + 1;
end
chi2s(cnt+1) = chi20;

%calculate covmariance matrix with lambda = 0
[u,s,v] = svd(A0);
diags = diag(s);
diags(find(diags<tolv)) = Inf; %
vs = diag(1./diags);

%save tmplemadump u diags v 
covm = v*vs*u';
Cii  = diag(covm);

if nargout>=4
	diags = diag(s);
	varargout{1} = diags;
end
if nargout>=5
	varargout{2} = covm;
end

if nargout>=6
	varargout{3} = hist;	
end
