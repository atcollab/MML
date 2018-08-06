function [pm,chi2,reshist] = findLSmin(cfun, p0, varargin)
%[pm,chi2,reshist] = findLSmin(cfun, p0, varargin)
%[pm,chi2,reshist] = findLSmin(cfun, p0, delta_p)
%[pm,chi2,reshist] = findLSmin(cfun, p0, delta_p, LMoption)
%This is an implementation of the LM algorithm as described by 
%"The Levenberg-Marquadt Algorithm: Implementation and Theory", Jorge J. More
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
%(1) we use pinv.m to invert (J'J+lambda D'D), one may supply the desired
%tolerance level in choosing singular values through LMoption
%(2) the convergence condition is met 
%(abs(norm(p-p0))<2*eps) | (chi2<eps*2) | (abs(1.0-chi2/chi20)<LMoption.FTOL) | (Delta <= LMoption.XTOL*norm(Dmat*p))
% where Delta is the size of the trusted region automatically determined by the algorithm. 
%(3) The experimental data must be supplied through the function cfun
%
%For examples of using this routine, see testfindLSmin.m
%
%Author: Xiaobiao Huang, created 8/27/2007
%last update, 8/30/2007
%

% global cntEvalJ;
% cntEvalJ = 0;
if nargin>=3
		delta_p = varargin{1};
else
		delta_p = ones(size(p0))*1.0e-6;
end
[f, cJ] = calcfJ(cfun, p0);
chi20 = 0.5 * f'*f;

LMoption.sigma = 0.1;
LMoption.SVtol = 0;
LMoption.MaxIter = 1000;
LMoption.XTOL = 1.e-8;
LMoption.FTOL = 1.e-8;
LMoption.Delta0 = sqrt(length(p0))*1.0;  %initial Delta, the size of trusted region
if nargin>=4
   LMoption = varargin{2}; 
end
Delta = LMoption.Delta0;

[N,NP] = size(cJ);
for ii=1:NP
	nJcol(ii) = norm(cJ(:,ii));
end
Dmat0 = diag(nJcol);

Dmat = Dmat0;
cnt = 0;
p = p0;
reshist = {};
while cnt<LMoption.MaxIter
    try
	[pnew, Delta, chi2, Dmat,cJ,flag_update,flag_converge,res] = LMupdate(cfun, p, delta_p,Dmat,cJ,Delta,LMoption);
    catch
      pm=p0;
      chi2=0;
      reshist{1}='no_fit';
      disp('  Warning: no fit in findLSmin/LMupdate')
      return
    end
    if ~flag_update
       cnt = cnt + 1;
       continue;
    end
	stopflag = flag_converge; 
	stopflag = stopflag | stopcriterion(chi20, chi2, pnew, p, LMoption);
    cnt = cnt + 1;
    p = pnew;
    chi20 = chi2;
    % disp([cnt Delta chi2])
    reshist{cnt} = res;
	if stopflag 
		break;
    end

end
pm = pnew;

%disp(['total number of Jacobian evaluation ' num2str(cntEvalJ)]);

function [f, cJ] = calcfJ(calcf, p, varargin)
%
f = calcf(p);
delta = ones(size(p))*1.0e-6;
if nargin>=3
   delta = varargin{1}; 
end
p0 = p;
for ii=1:length(delta)
	p = p0;	
	p(ii) = p(ii) + delta(ii);
    fn = calcf(p);
    cJ(:,ii) = (fn-f)/delta(ii);
end
% global cntEvalJ;
% cntEvalJ=cntEvalJ+1;

function flag = stopcriterion(chi20, chi2, p0, p, LMoption)
flag = (abs(norm(p-p0))<2*eps) | (chi2<eps*2) | (abs(1.0-chi2/chi20)<LMoption.FTOL);
if flag
%    disp([ (abs(norm(p-p0))<2*eps)  (chi2<eps*2)  (abs(1.0-chi2/chi20)<LMoption.FTOL)]);
end

function [pnew, Delta, chi2, Dmat,cJ, flag_update, flag_converge, res] = LMupdate(cfun, p, delta_p,Dmat,cJ,Delta,LMoption)
%one iteration of LM method
%
f = cfun(p);
chi2 = 0.5 * f'*f;

[N,NP] = size(cJ);
for ii=1:NP
	nJcol(ii) = max(Dmat(ii,ii), norm(cJ(:,ii)));
end
Dmat = diag(nJcol);

%step (a) of algorithm (7.1)

% [u,s,v] = svd(cJ);
% ss = diag(s);
% numSV = chooseNumSV(ss, LMoption.numSV);
% Ivec = 1:numSV;
% %cJp = v*diag(1./ss(Ivec))*u';
% vs = zeros(size(s'));
% for ii=1:numSV
%     vs(ii,ii) = 1./ss(ii);
% end
% cJp = v*vs*u';
cJp = pinv(cJ);

dpk = -cJp*f;
qa = Dmat*dpk;
if norm(Dmat*dpk)<=Delta*(1.0+LMoption.sigma)
    alph = 0.0;
else 
	%using algorithm (5.5)
	uk = norm( (cJ*pinv(Dmat))'*f )/Delta;
	phi0 = norm(qa)-Delta;
	phip0=-(Dmat'*qa)'*cJp*cJp'*(Dmat'*qa)/norm(qa);
	lk = -phi0/phip0;
	
	alph = 0.001; %we start with alph = 0.001
	while norm(Dmat*dpk)/Delta-1.0 > LMoption.sigma
        [norm(Dmat*dpk)/Delta-1.0] ;
		if alph>uk || alph<lk
			alph = max(0.001*uk, sqrt(uk*lk));
        end
        if LMoption.SVtol==0
            matinvC = pinv(cJ'*cJ+alph*Dmat'*Dmat);
        else
            matinvC = pinv(cJ'*cJ+alph*Dmat'*Dmat,LMoption.SVtol);
        end
		dpk = -matinvC*cJ'*f;
		qa = Dmat*dpk;
		phi = norm(qa)-Delta;
		phip=-(Dmat'*qa)'*matinvC*(Dmat'*qa)/norm(qa);
		if phi<0
			uk = alph;
		end
		lk = max(lk, alph-phi/phip);
        %Delta=0; %for testing
		alph = alph - (phi+Delta)/Delta*phi/phip;
        if isinf(alph)
            disp('  Warning: alph=inf in LMupdate')
            return
        end
	end
end
%step (b)
	[fnew,cJnew] = calcfJ(cfun,p+dpk,delta_p); 
	
	chi2new = 0.5 * fnew'*fnew;
	if chi2new > chi2
		rho = 0.0;
	else
		rho = (chi2-chi2new)*2.0 / (norm(cJ*dpk)^2 + 2*alph*norm(qa)^2); %Eq. (4.4)
	end
	
%step (c)	
  flag_update = 0;
	if rho<0.0001
		pnew = p;
	else
		pnew = p+dpk;
    chi2 = chi2new;
    cJ = cJnew;
    flag_update = 1;
	end

%step (d)	
	if rho<0.25
		if chi2new<chi2  %rho>0
			scalemu = 0.5;
		elseif chi2new<10*chi2  %
			scalemu = 0.1;
		else
			gamma = -(norm(cJ*dpk)^2 + alph*norm(qa)^2)/2.0/chi2;
			scalemu = 0.5*gamma/(gamma+0.5*(1.0-chi2new/chi2));  %Eq. (4.5)
			if scalemu>0.5
				scalemu = 0.5;
			elseif scalemu<0.1
				scalemu = 0.1;
			end
		end
		Delta = scalemu*Delta;
	elseif rho>0.75
	%on page 109 (after Eq. (4.4)), it says we multiply Delta by a constant>1
	%but in (7.1) it says using Delta = 2.0*norm(qa)
		%Delta = 2.0*norm(qa);
		Delta = 2.0*Delta;
	elseif alph<1e-6
		Delta = 2.0*norm(qa);
	%else %Delta remains the same	
	end
	flag_converge = (Delta <= LMoption.XTOL*norm(Dmat*p)) | ( (norm(cJ*dpk)^2 + 2*alph*norm(qa)^2)<= 2*chi2*LMoption.FTOL);

%return more information for evaluation
	res.Delta = Delta;
	res.chi2 = chi2new;
	res.rho = rho;
	res.alph = alph;
	res.p = pnew;

% function numSV = chooseNumSV(ss, option)
% %this function may work well, but is not used
% %it determines the number singular values that should be used in inverting a matrix
% %
% lss = log10(ss);
% NP = length(lss);
% 
% if lss(end)> -6.0
% 	numSV = NP;
% elseif NP<=3
% 		numSV = max(1, length(find(lss>-12.0)));
% else
% 	dlss = -diff(lss);	
% 	midstep = median(dlss);
% 	indxJump = find(dlss-midstep>5.0);
% 	if isempty(indxJump)
% 		numSV = NP;
% 	elseif indxJump(end)>NP/2
% 		numSV = indxJump(end);
% 	else
% 		numSV = max(1, length(find(lss>-12.0)));;
% 	end
% 		
% end
% %numSV = length(ss)

