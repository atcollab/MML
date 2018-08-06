function P = mkparamgroup_orbit(LATTICE,elemindex,paramstr,orbit)
%MKPARAMGROUP simplifies creation of AT parameter groups
% It group one or more elements in the
% same family and simultaneously vary
% 
% MKPARAMGROUP(LATTICE,ELEMINDEX,PARAMSTR,ORBIT)
% 
% LATTICE 
% FAMNAMESTR
% 
%
% PARAMSTR: 'K','K1','KS1','PB1'
%
% Revision History:
%   2002-06-26 Christoph Steier
%       added skew quadrupole gradient (KS1) as one possible
%       parameter

if isnumeric(elemindex)
    if ~ischar(paramstr)
        error('The third argument must be a string')
    else
        INDEX = elemindex;
        KIDNUM = 1:length(INDEX);
        PARAMSTR = paramstr;
    end
else
    error('Second argument has to be index list of elements');
end

switch lower(PARAMSTR)
case {'k1','k'}
    P = [];
    for loop = 1:length(INDEX)   
        if isfield(LATTICE{INDEX(KIDNUM(loop))},'T1')
            t1x=LATTICE{INDEX(KIDNUM(loop))}.T1(1);
            t1y=LATTICE{INDEX(KIDNUM(loop))}.T1(3);
        else
            t1x=0;t1y=0;
        end
        
        if ~isfield(LATTICE{INDEX(KIDNUM(loop))},'K')
            error(['Element ',int2str(KIDNUM(loop)),' does not have field ''K''']);
        end
        P1 = struct('ElemIndex',num2cell(INDEX(KIDNUM(loop))),'FieldName','K','Function',inline('x'));
        [P1.FieldIndex]=deal({1,1});
        [P1.Args]=deal({});
        
        if ~isfield(LATTICE{INDEX(KIDNUM(loop))},'PolynomB')
            error(['Element ',int2str(KIDNUM(loop)),' does not have field ''PolynomB''']);
        end
        P2 = struct('ElemIndex',num2cell(INDEX(KIDNUM(loop))),'FieldName','PolynomB','Function',inline('x'));
        [P2.FieldIndex]=deal({1,2});
        [P2.Args]=deal({});
        
        fstr = sprintf('-1*(%g*(x-(%g)))',orbit(1,INDEX(KIDNUM(loop)))+t1x,LATTICE{INDEX(KIDNUM(loop))}.PolynomB(2));
        P3 = struct('ElemIndex',num2cell(INDEX(KIDNUM(loop))),'FieldName','PolynomB','Function',inline(fstr));
        [P3.FieldIndex]=deal({1,1});
        [P3.Args]=deal({});
        
        if ~isfield(LATTICE{INDEX(KIDNUM(loop))},'PolynomA')
            error(['Element ',int2str(KIDNUM(loop)),' does not have field ''PolynomA''']);
        end        
        fstr = sprintf('-1*(%g*(x-(%g)))',orbit(3,INDEX(KIDNUM(loop)))+t1y,LATTICE{INDEX(KIDNUM(loop))}.PolynomB(2));
        P4 = struct('ElemIndex',num2cell(INDEX(KIDNUM(loop))),'FieldName','PolynomA','Function',inline(fstr));
        [P4.FieldIndex]=deal({1,1});
        [P4.Args]=deal({});
        
        P1.SavedValue = LATTICE{INDEX(KIDNUM(loop))}.K;
        P2.SavedValue = LATTICE{INDEX(KIDNUM(loop))}.PolynomB(2);
        P3.SavedValue = 0;
        P4.SavedValue = 0;
        
        P=[P;P1;P2;P3;P4];
    end
    P = reshape(P,1,length(P));
    
case 'pb1'

    P = [];
    for loop = 1:length(INDEX)                
        if isfield(LATTICE{INDEX(KIDNUM(loop))},'T1')
            t1x=LATTICE{INDEX(KIDNUM(loop))}.T1(1);
            t1y=LATTICE{INDEX(KIDNUM(loop))}.T1(3);
        else
            t1x=0;t1y=0;
        end
        
        if ~isfield(LATTICE{INDEX(KIDNUM(loop))},'PolynomB')
            error(['Element ',int2str(KIDNUM(loop)),' does not have field ''PolynomB''']);
        end
        P2 = struct('ElemIndex',num2cell(INDEX(KIDNUM(loop))),'FieldName','PolynomB','Function',inline('x'));
        [P2.FieldIndex]=deal({1,2});
        [P2.Args]=deal({});
        
        fstr = sprintf('-1*(%g*(x-(%g)))',orbit(1,INDEX(KIDNUM(loop)))+t1x,LATTICE{INDEX(KIDNUM(loop))}.PolynomB(2));
        P3 = struct('ElemIndex',num2cell(INDEX(KIDNUM(loop))),'FieldName','PolynomB','Function',inline(fstr));
        [P3.FieldIndex]=deal({1,1});
        [P3.Args]=deal({});
        
        if ~isfield(LATTICE{INDEX(KIDNUM(loop))},'PolynomA')
            error(['Element ',int2str(KIDNUM(loop)),' does not have field ''PolynomA''']);
        end        
        fstr = sprintf('-1*(%g*(x-(%g)))',orbit(3,INDEX(KIDNUM(loop)))+t1y,LATTICE{INDEX(KIDNUM(loop))}.PolynomB(2));
        P4 = struct('ElemIndex',num2cell(INDEX(KIDNUM(loop))),'FieldName','PolynomA','Function',inline(fstr));
        [P4.FieldIndex]=deal({1,1});
        [P4.Args]=deal({});
        
        P2.SavedValue = LATTICE{INDEX(KIDNUM(loop))}.PolynomB(2);
        P3.SavedValue = 0;
        P4.SavedValue = 0;
        
        P=[P;P2;P3;P4];
    end
    P = reshape(P,1,length(P));
    
case 'ks1'
    P = [];
    for loop = 1:length(INDEX)                
        if isfield(LATTICE{INDEX(KIDNUM(loop))},'T1')
            t1x=LATTICE{INDEX(KIDNUM(loop))}.T1(1);
            t1y=LATTICE{INDEX(KIDNUM(loop))}.T1(3);
        else
            t1x=0;t1y=0;
        end
        
        if ~isfield(LATTICE{INDEX(KIDNUM(loop))},'PolynomA')
            error(['Element ',int2str(KIDNUM(loop)),' does not have field ''PolynomA''']);
        end
        P2 = struct('ElemIndex',num2cell(INDEX(KIDNUM(loop))),'FieldName','PolynomA','Function',inline('x'));
        [P2.FieldIndex]=deal({1,2});
        [P2.Args]=deal({});
        
        fstr = sprintf('-1*(%g*(x-(%g)))',orbit(1,INDEX(KIDNUM(loop)))+t1x,LATTICE{INDEX(KIDNUM(loop))}.PolynomA(2));
        P3 = struct('ElemIndex',num2cell(INDEX(KIDNUM(loop))),'FieldName','PolynomA','Function',inline(fstr));
        [P3.FieldIndex]=deal({1,1});
        [P3.Args]=deal({});
        
        if ~isfield(LATTICE{INDEX(KIDNUM(loop))},'PolynomB')
            error(['Element ',int2str(KIDNUM(loop)),' does not have field ''PolynomB''']);
        end        
        fstr = sprintf('+1*(%g*(x-(%g)))',orbit(3,INDEX(KIDNUM(loop)))+t1y,LATTICE{INDEX(KIDNUM(loop))}.PolynomA(2));
        P4 = struct('ElemIndex',num2cell(INDEX(KIDNUM(loop))),'FieldName','PolynomB','Function',inline(fstr));
        [P4.FieldIndex]=deal({1,1});
        [P4.Args]=deal({});
        
        P2.SavedValue = LATTICE{INDEX(KIDNUM(loop))}.PolynomA(2);
        P3.SavedValue = 0;
        P4.SavedValue = 0;
        
        P=[P;P2;P3;P4];
    end
    P = reshape(P,1,length(P));
end

