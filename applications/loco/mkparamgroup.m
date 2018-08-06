function P = mkparamgroup(LATTICE,varargin)
%MKPARAMGROUP - Simplifies creation of AT parameter groups
%  It group one or more elements in the
%  same family and simultaneously vary
%
%  MKPARAMGROUP(LATTICE,ELEMINDEX,PARAMSTR)
%  MKPARAMGROUP(LATTICE,FAMNAMESTR,PARAMSTR)
%  MKPARAMGROUP(LATTICE,FAMNAMESTR,KIDNUM,PARAMSTR)
%
%  LATTICE
%  FAMNAMESTR
%
%  PARAMSTR: 'K1', 'K' - Quadrupole (PolynomB(2) and K)
%            'cK'      - Fit quadrupoles with a gain between them (PolynomB(2) and K)
%            'K2'      - Sextupole  (PolynomB(3)) 
%            'K3'      - Octupole   (PolynomB(4)) 
%            'KS1', 's', 's1' - Skew quadrupole
%            'PB1' - PolynomB(2) 
%            'tilt' - Magnet tilt in radians
%  (PARAMSTR is not case sensitive)
%
%  Revision History:
%  2002-06-26 Christoph Steier
%      Added skew quadrupole gradient (KS1) as one possible parameter
%
%  2004-02-09 WJC
%     'TILT','K1','K2','K3' changed index 'i' to 'k'


if isnumeric(varargin{1})
    if nargin==3 && ~ischar(varargin{2})
        error('The third argument must be a string');
    else
        INDEX = varargin{1};
        KIDNUM = 1:length(INDEX);
        PARAMSTR = varargin{2};
        if nargin==4
            ScaleFactor = varargin{3};
        end
    end
else
    FAMNAMESTR = varargin{1};
    INDEX = findcells(LATTICE,'FamName',FAMNAMESTR);
    if(isempty(INDEX))
        error(['No elements that belong to the family ''',FAMNAMESTR,...
            ''' found in the lattice ',inputname(1)]);
    end
    if isnumeric(varargin{2})
        KIDNUM = varargin{2};
        PARAMSTR = varargin{3};
    else
        KIDNUM = 1:length(INDEX);
        PARAMSTR = varargin{2};
    end
end

switch lower(PARAMSTR)
    case {'k1','k'}
        if ~isfield(LATTICE{INDEX(KIDNUM(1))},'PolynomB')
            error(['Element ',int2str(KIDNUM(1)),' does not have field ''PolynomB''']);
        end

        if isfield(LATTICE{INDEX(KIDNUM(1))},'K')
            % Change .K and .PolynomB(2)
            P1 = struct('ElemIndex',num2cell(INDEX(KIDNUM)),'FieldName','K','Function',inline('x'));
            [P1.FieldIndex]=deal({1,1});
            [P1.Args]=deal({});

            P2 = struct('ElemIndex',num2cell(INDEX(KIDNUM)),'FieldName','PolynomB','Function',inline('x'));
            [P2.FieldIndex]=deal({1,2});
            [P2.Args]=deal({});

            for k = 1:length(KIDNUM)
                P1(k).SavedValue = LATTICE{INDEX(KIDNUM(k))}.K;
                P2(k).SavedValue = LATTICE{INDEX(KIDNUM(k))}.PolynomB(2);
            end
            P = reshape([P1;P2],1,2*length(P1));
        else
            % Change ..PolynomB(2)
            %error(['Element ',int2str(KIDNUM(1)),' does not have field ''K''']);
            P = struct('ElemIndex',num2cell(INDEX(KIDNUM)),'FieldName','PolynomB','Function',inline('x'));
            [P.FieldIndex]=deal({1,2});
            [P.Args]=deal({});
            for k = 1:length(KIDNUM)
                P(k).SavedValue = LATTICE{INDEX(KIDNUM(k))}.PolynomB(2);
            end
        end

    case {'ck','kak'}
        if ~isfield(LATTICE{INDEX(KIDNUM(1))},'PolynomB')
            error(['Element ',int2str(KIDNUM(1)),' does not have field ''PolynomB''']);
        end

        if isfield(LATTICE{INDEX(KIDNUM(1))},'K')
            % Change .K and .PolynomB(2)
            for i = 1:length(KIDNUM)
                Ptmp = struct('ElemIndex',{INDEX(i)},'FieldName','K','Function',inline('a*x'));
                Ptmp.FieldIndex = {1,1};
                Ptmp.Args = {ScaleFactor(i)};
                P1(i) = Ptmp;
            end

            for i = 1:length(KIDNUM)
                Ptmp = struct('ElemIndex',{INDEX(i)},'FieldName','PolynomB','Function',inline('a*x'));
                Ptmp.FieldIndex = {1,2};
                Ptmp.Args = {ScaleFactor(i)};
                P2(i) = Ptmp;
            end

            for k = 1:length(KIDNUM)
                P1(k).SavedValue = LATTICE{INDEX(KIDNUM(k))}.K;
                P2(k).SavedValue = LATTICE{INDEX(KIDNUM(k))}.PolynomB(2);
            end
            P = reshape([P1;P2],1,2*length(P1));
        else
            % Change .PolynomB(2)
            error(['Element ',int2str(KIDNUM(1)),' does not have field ''K''']);
            for i = 1:length(KIDNUM)
                Ptmp = struct('ElemIndex',{INDEX(i)},'FieldName','PolynomB','Function',inline('a*x'));
                Ptmp.FieldIndex = {1,2};
                Ptmp.Args = {ScaleFactor(i)};
                P(i) = Ptmp;
            end

            for k = 1:length(KIDNUM)
                P(k).SavedValue = LATTICE{INDEX(KIDNUM(k))}.PolynomB(2);
            end
        end

    case 'k2'

        if ~isfield(LATTICE{INDEX(KIDNUM(1))},'PolynomB')
            error(['Element ',int2str(KIDNUM(1)),' does not have field ''PolynomB''']);
        end
        P = struct('ElemIndex',num2cell(INDEX(KIDNUM)),'FieldName','PolynomB','Function',inline('x'));
        [P.FieldIndex]=deal({1,3});
        [P.Args]=deal({});
        for k = 1:length(KIDNUM)
            P(k).SavedValue = LATTICE{INDEX(KIDNUM(k))}.PolynomB(3);
        end
        
    case 'k3'
        if ~isfield(LATTICE{INDEX(KIDNUM(1))},'PolynomB')
            error(['Element ',int2str(KIDNUM(1)),' does not have field ''PolynomB''']);
        end
        P = struct('ElemIndex',num2cell(INDEX(KIDNUM)),'FieldName','PolynomB','Function',inline('x'));
        [P.FieldIndex]=deal({1,4});
        [P.Args]=deal({});
        for k = 1:length(KIDNUM)
            P(k).SavedValue = LATTICE{INDEX(KIDNUM(k))}.PolynomB(4);
        end

    case 'tilt'
        if ~isfield(LATTICE{INDEX(KIDNUM(1))},'R1')
            error(['Element ',int2str(KIDNUM(1)),' does not have field ''R1''']);
        end
        if ~isfield(LATTICE{INDEX(KIDNUM(1))},'R2')
            error(['Element ',int2str(KIDNUM(1)),' does not have field ''R2''']);
        end

        P1 = struct('ElemIndex',num2cell(INDEX(KIDNUM)),'FieldName','R1','Function',inline('mksrollmat(x)'));
        [P1.FieldIndex]=deal({1:6,1:6});
        [P1.Args]=deal({});

        P2 = struct('ElemIndex',num2cell(INDEX(KIDNUM)),'FieldName','R2','Function',inline('mksrollmat(-x)'));
        [P2.FieldIndex]=deal({1:6,1:6});
        [P2.Args]=deal({});

        for k = 1:length(KIDNUM)
            P1(k).SavedValue = LATTICE{INDEX(KIDNUM(k))}.R1;
            P2(k).SavedValue = LATTICE{INDEX(KIDNUM(k))}.R2;
        end
        P = reshape([P1;P2],1,2*length(P1));
        
    case {'s','s1', 'ks1'}
        if ~isfield(LATTICE{INDEX(KIDNUM(1))},'PolynomA')
            error(['Element ',int2str(KIDNUM(1)),' does not have field ''PolynomA''']);
        end
        P = struct('ElemIndex',num2cell(INDEX(KIDNUM)),'FieldName','PolynomA','Function',inline('x'));
        [P.FieldIndex]=deal({1,2});
        [P.Args]=deal({});
        for k = 1:length(KIDNUM)
            P(k).SavedValue = LATTICE{INDEX(KIDNUM(k))}.PolynomA(2);
        end

    case 'pb1'
        if ~isfield(LATTICE{INDEX(KIDNUM(1))},'PolynomB')
            error(['Element ',int2str(KIDNUM(1)),' does not have field ''PolynomB''']);
        end
        P = struct('ElemIndex',num2cell(INDEX(KIDNUM)),'FieldName','PolynomB','Function',inline('x'));
        [P.FieldIndex]=deal({1,2});
        [P.Args]=deal({});
        for k = 1:length(KIDNUM)
            P(k).SavedValue = LATTICE{INDEX(KIDNUM(k))}.PolynomB(2);
        end
end

