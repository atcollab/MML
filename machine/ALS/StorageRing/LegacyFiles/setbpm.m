function  [OrbitSTD, IterOut] = setbpm(CMfamily, Ygoal, Xelem, Yelem, In5, In6, In7, In8, In9, In10)
%  [OrbitSTD, IterOut] = setbpm(CMfamily, BPMgoal, CMlist, BPMlist, Iterations, Tolerance);
%     or
%  [OrbitSTD, IterOut] = setbpm(CMfamily1, BPMgoal1, CMlist1, BPMlist1, ...
%                               CMfamily2, BPMgoal2, CMlist2, BPMlist2, Iterations, Tolerance );
%
%   Inputs: CMfamily   = corrector magnet family
%           BPMgoal    = goal orbit
%           CMlist     = list of corrector magnets to use (eg., HCMlist/VCMlist)
%           BPMlist    = list of BPMs (must correspond to the BPMgoal)  (eg., BPMlist)
%           Iterations = number of "feedback" steps {Default = 3}
%           Tolerance  = rms tolerance to limit the iterations [mm] {Default = 0}
%
%           Atleast 4 inputs are required.
%
%   setbpm can be used to do one plane or two planes.
%
%   Algorithm: Least squares based on model:  deltaBPM = S * deltaCM
%              Change in corrector magnets:   deltaCM  = inv(S'*S)*S'*deltaBPM
%
%  EXAMPLES
%  1. [OrbitSTD, IterOut] = setbpm('HCM', getgolden('BPMx'), family2dev('HCM'), family2dev('BPMx'), 1); 
%  2. HCMList = getcmlist('HCM','2 7');
%     BPMxList = getbpmlist('x','Bergoz','1 2 9 10');
%     [OrbitSTD, IterOut] = setbpm('HCM', getgolden('BPMx',BPMxList), HCMList, BPMxList, 1); 
%  3. VCMList = getcmlist('VCM','2 7');
%     BPMyList = getbpmlist('y','Bergoz','1 2 9 10');
%     [OrbitSTD, IterOut] = setbpm('VCM', getgolden('BPMy',BPMyList), VCMList, BPMyList, 1); 
%  4. [OrbitSTD, IterOut] = setbpm('HCM', getgolden('BPMx',BPMxList), HCMList, BPMxList, 'VCM', getgolden('BPMy',BPMyList), VCMList, BPMyList, 1); 


% Initialize
MMmax = 1.0;
ExtraDelay = 0;  
Iter  = 3;      % Default: can be over written by In5 or In9
Tol   = 0;      % Default: can be over written by In6 or In10


% Inputs
if nargin < 4
    error('SETBPM:  Need at least 4 arguments!');
elseif nargin == 4
    BumpFlag = 1;
elseif nargin == 5
    BumpFlag = 1;
    Iter = In5;
elseif nargin == 6
    BumpFlag = 1;
    Iter = In5;
    Tol = In6;
elseif nargin == 7
    error('SETBPM:  Wrong number of inputs.');
elseif nargin == 8
    BumpFlag = 2;
    CMfamily2 = In5;
    Ygoal2 = In6;
    Xelem2 = In7;
    Yelem2 = In8;
elseif nargin == 9
    BumpFlag = 2;
    CMfamily2 = In5;
    Ygoal2 = In6;
    Xelem2 = In7;
    Yelem2 = In8;
    Iter = In9;
elseif nargin == 10
    BumpFlag = 2;
    CMfamily2 = In5;
    Ygoal2 = In6;
    Xelem2 = In7;
    Yelem2 = In8;
    Iter = In9;
    Tol = In10;
elseif nargin > 10
    error('SETBPM:  Too many inputs.');
end


if CMfamily == 'HCM'
    S = getrespmat('BPMx',Yelem, CMfamily, Xelem);
elseif CMfamily == 'VCM'
    S = getrespmat('BPMy',Yelem, CMfamily, Xelem);
else
    error('SETBPM:  Magnet family must be VCM or HCM!');
end

if (CMfamily(1,1) == 'H')
    Dim = 1;
else
    Dim = 2;
end

if size(Yelem, 1) == size(Ygoal, 1)
    % OK
else
    error('SETBPM:  Size of Ygoal does not equal size of Yelem.');
end

if BumpFlag == 2
    if CMfamily == CMfamily2
        error('CMfamily1 must be a different plane from CMfamily2.');
    end

    if CMfamily2 == 'HCM'
        S2 = getrespmat('BPMx',Yelem2, CMfamily2, Xelem2);
    elseif CMfamily2 == 'VCM'
        S2 = getrespmat('BPMy',Yelem2, CMfamily2, Xelem2);
    else
        error('SETBPM:  Magnet family must be VCM or HCM!');
    end

    if (CMfamily2(1,1) == 'H')
        Dim2 = 1;
    else
        Dim2 = 2;
    end

    if size(Yelem2, 1) == size(Ygoal2, 1)
        % OK
    else
        error('SETBPM:  Size of Ygoal2 does not equal size of Yelem2.');
    end
end

if (Iter < 1)
    error('SETBPM:  Number of feedback steps must be 1 or greater.');
end


% Function
if BumpFlag == 1
    % 1 bump

    % SVD Correction
    % Decompose the tune response matrix:
    % S = U*S*V'
    % The V matrix columns are the singular vectors in the corrector magnet space
    % The U matrix columns are the singular vectors in the BPM space
    % U'*U=I and V*V'=I
    % CMCoef is the projection onto the columns of ResponseMatrix*V(:,Ivec) (same space as spanned by U)
    [U, SS, V] = svd(S, 0);
    Ivec = find(diag(SS) > max(diag(SS))*1e-3);

    
    for i=1:Iter
        pause(ExtraDelay);
        Y = getbpm(Dim, Yelem);

        % Check tolerance
        OrbitSTD = std(Ygoal-Y);
        %OrbitMAX=max(abs(Ygoal-Y));
        if OrbitSTD < Tol
            %disp(['  Within tolerance, break']); pause(0)
            IterOut = i-1;
            break;
        end

        CMCoef = diag(diag(SS(Ivec,Ivec)).^(-1)) * U(:,Ivec)' * (Ygoal -Y);
        DeltaCM = V(:,Ivec) * CMCoef;       % Convert the vector CMCoef back to coefficents of ResponseMatrix
        %DeltaCM  = inv(S' *S) *S' *(Ygoal -Y);

        N = floor(max(abs(S*DeltaCM))/MMmax);
        SP = getsp(CMfamily, Xelem);

        if N > 1
            for i=1:N
                SPnew = SP + (i/N) * DeltaCM;
                setsp(CMfamily, SPnew, Xelem, -1);
            end
        end
        setsp(CMfamily, SP + DeltaCM, Xelem, -2);
        IterOut = i;
    end
    Y = getbpm(Dim, Yelem);
    OrbitSTD = std(Ygoal-Y);
    
else
    % 2 Bumps
    
    % SVD Correction
    % Decompose the tune response matrix:
    % S = U*S*V'
    % The V matrix columns are the singular vectors in the corrector magnet space
    % The U matrix columns are the singular vectors in the BPM space
    % U'*U=I and V*V'=I
    % CMCoef is the projection onto the columns of ResponseMatrix*V(:,Ivec) (same space as spanned by U)
    [U, SS, V] = svd(S, 0);
    Ivec = find(diag(SS) > max(diag(SS))*1e-3);

    [U2, SS2, V2] = svd(S2, 0);
    Ivec2 = find(diag(SS2) > max(diag(SS2))*1e-3);


    for i=1:Iter
        pause(ExtraDelay);
        Y  = getbpm(Dim,  Yelem);
        Y2 = getbpm(Dim2, Yelem2);

        % Check tolerance
        OrbitSTD(1,1) = std(Ygoal-Y);
        %OrbitMAX=max(abs(Ygoal-Y)) ;
        OrbitSTD(2,1) = std(Ygoal2-Y2);
        %OrbitMAX=max(abs(Ygoal2-Y2));
        if (OrbitSTD(1,1)<Tol) & (OrbitSTD(2,1)<Tol)
            %disp(['  Within tolerance , break, i=',num2str(i)]); pause(0)
            IterOut = i-1;
            break;
        end

        CMCoef = diag(diag(SS(Ivec,Ivec)).^(-1)) * U(:,Ivec)' * (Ygoal -Y);
        DeltaCM = V(:,Ivec) * CMCoef;       % Convert the vector CMCoef back to coefficents of ResponseMatrix
        %DeltaCM  = inv(S' *S) *S' *(Ygoal -Y);

        CMCoef2 = diag(diag(SS2(Ivec2,Ivec2)).^(-1)) * U2(:,Ivec2)' * (Ygoal2 -Y2);
        DeltaCM2 = V2(:,Ivec2) * CMCoef2;       % Convert the vector CMCoef back to coefficents of ResponseMatrix
        %DeltaCM2 = inv(S2'*S2)*S2'*(Ygoal2-Y2);


        N = floor(max(abs(S*DeltaCM))/MMmax);
        SP = getsp(CMfamily, Xelem);

        N2 = floor(max(abs(S2*DeltaCM2))/MMmax);
        SP2 = getsp(CMfamily2, Xelem2);

        N = max([N N2]);

        if N > 1
            for i=1:N
                SPnew  = SP +  (i/N) * DeltaCM;
                SPnew2 = SP2 + (i/N) * DeltaCM2;

                setsp(CMfamily,  SPnew,  Xelem,  0);
                setsp(CMfamily2, SPnew2, Xelem2, 0);

                setsp(CMfamily,  SPnew,  Xelem,  -1);
                setsp(CMfamily2, SPnew2, Xelem2, -1);
            end
        end
        setsp(CMfamily,  SP  + DeltaCM,  Xelem,  0);
        setsp(CMfamily2, SP2 + DeltaCM2, Xelem2, 0);

        setsp(CMfamily,  SP  + DeltaCM,  Xelem,  -2);
        setsp(CMfamily2, SP2 + DeltaCM2, Xelem2, -2);
        IterOut = i;
    end

    Y  = getbpm(Dim,  Yelem);
    Y2 = getbpm(Dim2, Yelem2);
    OrbitSTD(1,1) = std(Ygoal-Y);
    OrbitSTD(2,1) = std(Ygoal2-Y2);

end

