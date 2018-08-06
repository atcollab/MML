function varargout =  compensate_wiggler(newtunes, quadfam1, quadlist1, quadfam2, quadlist2, refpt_alpha);
% function varargout =  compensate_wiggler(newtunes, quadfam1, quadlist1, quadfam2, quadlist2, refpt_alpha);
%
% modified 2000-09-26, Christoph Steier 
% to use both the k-value and PolynomB(2) in oder to make this routine
% work both for the LinearPass and SymplecticPass cases.
%
% modified 2000-11-07, Christoph Steier
% use smaller stepsize for differentiation, use fprintf to print
% status information, fit tune iteratively
%

% Must declare THERING as global in order for the function to modify Quad values 
global THERING
delta = 1e-5; % step size for numeric differentiation

% find indexes of the 2 quadrupole families use for fitting
Q1I = findcells(THERING,'FamName',quadfam1);
Q2I = findcells(THERING,'FamName',quadfam2);

Q1I= Q1I(quadlist1);
Q2I= Q2I(quadlist2);

InitialK1 = getcellstruct(THERING,'K',Q1I);
InitialK2 = getcellstruct(THERING,'K',Q2I);
InitialPolB1 = getcellstruct(THERING,'PolynomB',Q1I,2);
InitialPolB2 = getcellstruct(THERING,'PolynomB',Q2I,2);

% Compute initial tunes before fitting 
[ LD, InitialTunes] = linopt(THERING,0);
fprintf('Tunes before compensate_wiggler: nu_x=%g, nu_y=%g\n',InitialTunes(1),InitialTunes(2));
TD = twissring(THERING,0,refpt_alpha);
if length(refpt_alpha)>1
    alpha = mean(abs(cat(1,TD.alpha)));
else
    alpha = cat(1,TD.alpha);
end
fprintf('alpha at refpt %d before compensate_wiggler: alpha_x=%g, alpha_y=%g\n',refpt_alpha(1),alpha(1),alpha(2));

TempTunes = InitialTunes;
TempAlpha = alpha;
TempK1 = InitialK1;
TempK2 = InitialK2;
TempPolB1 = InitialPolB1;
TempPolB2 = InitialPolB2;

fprintf('distance from goal: %g\n',max([abs(TempTunes(:)-newtunes(:));abs(TempAlpha(:))]));

while any(abs(TempTunes(:)-newtunes(:))>5e-5) | any(abs(TempAlpha(:))>0.01)
        
    % Take Derivative
    for loop =1:2
        THERING = setcellstruct(THERING,'K',Q1I(loop),TempK1(loop)+delta);
        THERING = setcellstruct(THERING,'PolynomB',Q1I(loop),TempPolB1(loop)+delta,2);
        [LD , tmptune ] = linopt(THERING,0);
        Tunes_dK1(loop,1:2) = tmptune;
        TD = twissring(THERING,0,refpt_alpha);
        if length(refpt_alpha)>1
            alpha_dK1(loop,1:2) = mean(abs(cat(1,TD.alpha)));
        else
            alpha_dK1(loop,1:2) = cat(1,TD.alpha);
        end
        THERING = setcellstruct(THERING,'K',Q1I(loop),TempK1(loop));
        THERING = setcellstruct(THERING,'PolynomB',Q1I(loop),TempPolB1(loop),2);
    end
    
    for loop =1:2
        THERING = setcellstruct(THERING,'K',Q2I(loop),TempK2(loop)+delta);
        THERING = setcellstruct(THERING,'PolynomB',Q2I(loop),TempPolB2(loop)+delta,2);
        [LD , tmptune ] = linopt(THERING,0);
        Tunes_dK2(loop,1:2) = tmptune;
        TD = twissring(THERING,0,refpt_alpha);
        if length(refpt_alpha)>1
            alpha_dK2(loop,1:2) = mean(abs(cat(1,TD.alpha)));
        else
            alpha_dK2(loop,1:2) = cat(1,TD.alpha);
        end
        THERING = setcellstruct(THERING,'K',Q2I(loop),TempK2(loop));
        THERING = setcellstruct(THERING,'PolynomB',Q2I(loop),TempPolB2(loop),2);
    end
    
    %Construct the Jacobian
    J = ([Tunes_dK1(1,:)' Tunes_dK1(2,:)' Tunes_dK2(1,:)' Tunes_dK2(2,:)'; ...
            alpha_dK1(1,:)' alpha_dK1(2,:)' alpha_dK2(1,:)' alpha_dK2(2,:)'] ...
        - [TempTunes(:) TempTunes(:) TempTunes(:) TempTunes(:); ...
            TempAlpha(:) TempAlpha(:) TempAlpha(:) TempAlpha(:)])/delta;
    Jinv = inv(J);
    
    fac = 0.5*max(max(abs(Jinv)));
    if fac<=10
        fac=1;
    end
    
    
    dnu = ([newtunes(:) - TempTunes(:);0.2*([0;0]-TempAlpha(:))]);
    dK = 1/fac*Jinv*dnu;
    
    TempK1 = TempK1+dK(1:2);
    TempK2 = TempK2+dK(3:4);
    TempPolB1 = TempPolB1+dK(1:2);
    TempPolB2 = TempPolB2+dK(3:4);
    
    THERING = setcellstruct(THERING,'K',Q1I,TempK1);
    THERING = setcellstruct(THERING,'PolynomB',Q1I,TempPolB1,2);
    THERING = setcellstruct(THERING,'K',Q2I,TempK2);
    THERING = setcellstruct(THERING,'PolynomB',Q2I,TempPolB2,2);
    
    OldTunes = TempTunes;
    OldAlpha = TempAlpha;
    
    [ LD, TempTunes] = linopt(THERING,0);
    TD = twissring(THERING,0,refpt_alpha);
    if length(refpt_alpha)>1
        TempAlpha = mean(abs(cat(1,TD.alpha)));
    else
        TempAlpha = cat(1,TD.alpha);
    end
    
    fprintf('distance from goal: %g\n',max([norm(TempTunes(:)-newtunes(:));TempAlpha(:)]));
    fprintf('nu_x=%g, nu_y=%g, alph_x=%g, alph_y=%g\n',TempTunes(1),TempTunes(2),TempAlpha(1),TempAlpha(2));
    
    if max(abs([[OldTunes-TempTunes];0.01*[OldAlpha-TempAlpha]]))<3e-5
        fprintf('No change: Exiting\n');
        break;
    end
    
end

fprintf('Tunes after compensate_wiggler: nu_x=%g, nu_y=%g\n',TempTunes(1),TempTunes(2));

