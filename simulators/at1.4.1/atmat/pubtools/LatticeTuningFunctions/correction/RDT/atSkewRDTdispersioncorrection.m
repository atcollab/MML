function [rcor,inCOD,ss]=atSkewRDTdispersioncorrection(...
    rerr,...
    r0,...
    indBPM,...
    indSCor,...
    inCOD,...
    neigSteerer,...
    correctflags,...
    scalefactor,...
    wdisp,...
    ModelRM,...
    steererlimit,...
    printouttext)
% function [...
%    rcor,...            1) corrected lattice
%    inCOD,...           2) initial COD (dpp is stored here)
%    hs,vs...            3) required steerers strengths (total)
%    ]=atdispersionfreesteering(...
%     rerr,...           1) AT lattice to correct
%     r0, ...            2) 2xNbpm reference rdt to correct to
%     indBPM,...         3) Nbx1 bpm indexes       (default: monitor)
%     indSCor,...        4) Nsx1 skew. cor indexes (default: sextupole)
%     inCOD,...          5) 6x1 initial COD guess  (default: 6x1 zero)
%     neigSteerer,...    6) 2xNiter eigenvectors for correction H and V at
%                          each iteration (default: [Nh/2 Nv/2])
%     correctflags,...   7) correct [ mean0](default: [ true])
%     scalefactor,...    8) scale factor to correction (default: 1.0)
%     [wdispv],...
%                        9) dispersion and tune weight:
%                           dispersionH*wdisph and orbith*(1-wdisph-wtune)
%                           dispersionV*wdispv and orbith*(1-wdispv)                          
%                           (default: 0.7 0.1 0.7)
%     ModelRM,...       10) ModelRM.Disp(N/S)Quad = 6x1 cell of dispersion 
%                           response mat. if [] compute RM (default: [])
%                           (default 0*2xNb, or from r0 if reftune is r0)
%     steererlimit      11) 2x1 limit of steerers abs(steerer)<steererlimit
%                           (default: [], no limits)
%     printouttext      12) if 1 or true, display rms orbit
%     )
%
% features impelemented:
% - limit correctors strengths
% - ddp correction
% - sum of steerers = 0
% - 6D orbit with BPM errors
% - initial coordinate
% - correction to reference rdt tune dispersion from r0 lattice
% - retrival of normal and skew quadrupole components also from alignment
%   errors and rotations
% - use atsetfieldvalues, atgetcells
%
% http://journals.aps.org/prab/abstract/10.1103/PhysRevSTAB.14.034002
%
%see also: qemsvd_mod findorbit6Err getresponsematrices



% response matrix kicks
%kval=1e-5;
delta=1e-3;

% default arguments
if nargin<12
    printouttext=true;
end
if nargin<11
    steererlimit=[];
end

if nargin<4
    if printouttext
        disp('get BPM and Correctors indexes'); end;
    indBPM=finc(atgetcells(rerr,'Class','Monitor'));
    indSCor=finc(atgetcells(rerr,'Class','Sextupole'));
end

if nargin<5
    inCOD=[0 0 0 0 0 0]';
end

if nargin<6
    neigSteerer=length(indSCor)/2;
end

if nargin<7
    correctflags=true;
end

if nargin<8
    if printouttext
        disp(' --- scale set to 1.0'); end;
    scalefactor=1.0;
end

if nargin<9
    if printouttext, disp(' ---wdispv=0.7'); end;
    wdisp=.7;
end

if nargin<10
    if printouttext, disp(' --- computing orbit Response matrix'); end;
    ModelRM=[];
end


if scalefactor<0 || scalefactor>1
    if printouttext
        disp(' --- scale factor out of range. Set to 1.0'); end;
    scalefactor=1.0;
end


% load or compute response matrix
if isempty(ModelRM)
    % get orbit RM
    if printouttext
        disp('get RM'); end;
    
    
        ModelRM=getresponsematrices(...
            rerr,...          %1 AT lattice
            indBPM,...      %2 bpm indexes in at lattice
            [],...     %3 h cor indexes
            [],...     %4 v cor indexes
            indSCor,...     %5 skew cor indexes
            [],...     %6 quad cor indexes
            [],...
            inCOD,...       %7 initial coordinates
            11 );       %8 specifiy rm to be computed
            
        
    
end

% load RM computed by getresponsematrices

drmS=ModelRM.DispSCor;

% quad RDT RM
[~,~,ind]=EquivalentGradientsFromAlignments6D(rerr,inCOD);
indAllSkew=ind;


% skew RDT RM
[respsx,respsz]=semrdtresp_mod(rerr,indBPM,indAllSkew);    % RDT response matrix assumes K=1
SL=atgetfieldvalues(rerr,indAllSkew,'Length');          % quadrupole lengths
SL(SL==0)=1;% thin lens magnets
lengthsmat=repmat(SL',length(indBPM),1);
respsx=respsx.*lengthsmat;
respsz=respsz.*lengthsmat;

[~,skcor]=ismember(indSCor,indAllSkew);
rdtS=[...
    real(respsx(:,skcor));...
    imag(respsx(:,skcor));...
    real(respsz(:,skcor));...
    imag(respsz(:,skcor))];


inCOD=[0 0 0 0 0 0]';
[l,~,~]=atlinopt(r0,0,indBPM);
refdispersion=arrayfun(@(a)a.Dispersion(3),l);


[~,KSnoer,~]=EquivalentGradientsFromAlignments6D(r0,inCOD);

fx=respsx*KSnoer;
fz=respsz*KSnoer;
rdtvecs=[...
    real(fx);...
    imag(fx);...
    real(fz);...
    imag(fz)]';

refrdt(1,:)=rdtvecs;



% get rdt vectors to correct
[~,KSi,~]=EquivalentGradientsFromAlignments6D(rerr,inCOD);

fx=respsx*KSi;
fz=respsz*KSi;
rs0=[...
    real(fx);...
    imag(fx);...
    real(fz);...
    imag(fz)]';


alpha=mcf(rerr);
indrfc=find(atgetcells(rerr,'Frequency'));

% get initial dispersion

d=finddispersion6Err(rerr,indBPM,indrfc,alpha,delta,inCOD);
dy0=d(3,:);

%rerr0=rerr;
 ss0=atgetfieldvalues(rerr,indSCor,'PolynomA',{1,2});
    
% iterate correction
Niter=size(neigSteerer,1);
for iter=1:Niter
    
    if printouttext
        disp(['RDT Disp. Tune Steering iter ' num2str(iter,'%d, ') ...
            ' n-eig: ' num2str(neigSteerer(iter,:),'%d, ') ...
            ' alpha: ' num2str(wdisp,'%2.2f ')]);
    end
    
    % initial corrector strengths
    cors0=atgetfieldvalues(rerr,indSCor,'PolynomA',{1,2});
    
    
    % get current rdt vectors to correct
    [~,KSe,~]=EquivalentGradientsFromAlignments6D(rerr,inCOD);
    %KQ=atgetfieldvalues(rerr,indAllQuad,'PolynomB',{1,2});
    %KS=atgetfieldvalues(rerr,indAllSkew,'PolynomA',{1,2});
    
    fx=respsx*KSe;
    fz=respsz*KSe;
    rs=[...
        real(fx);...
        imag(fx);...
        real(fz);...
        imag(fz)]';
    
    % get current dispersion
    d=finddispersion6Err(rerr,indBPM,indrfc,alpha,delta,inCOD);
    dy=d(3,:);
 
    % subtract reference orbit
    rs=rs-refrdt(1,:);
    % subtract reference dispersion
    dy=dy-refdispersion(1,:);
    % subtract reference tune

    % weigths between RDT, tune and dispersion
    rs=rs*(1-wdisp(1));
    dy=dy*(wdisp(1));
    
    % build RMs
    if  correctflags(1) % mean0 no dpp
        RMS=[rdtS*(1-wdisp(1));drmS{3}*(wdisp(1));ones(size(indSCor))];
    elseif ~correctflags(1) % no dpp no mean0
        RMS=[rdtS*(1-wdisp(1));drmS{3}*(wdisp(1))];
    end
    
    % compute correction
    if correctflags(1) % mean = 0
        vecs=[rs dy 0]';
    else % no constraint on correctors mean
        vecs=[rs dy]';
    end
    
    dcs=qemsvd_mod(RMS,vecs,neigSteerer(iter,1));
    
    % get total correctors values and apply scaling
    
    ss=cors0-dcs*scalefactor;
    
    % limit steerers strengths
    if ~isempty(steererlimit)
        ss(abs(ss)>steererlimit(1))=steererlimit(2);
    end
    
    % apply correction in lattice
    rcor=rerr;
    rcor=atsetfieldvalues(rcor,indSCor,'PolynomA',{1,2},ss);
    
    % lattice start point for next iteration
    rerr=rcor;
end


% get current rdt vectors to correct
[~,KS,~]=EquivalentGradientsFromAlignments6D(rcor,inCOD);

fx=respsx*KS;
fz=respsz*KS;
rsc=[...
    real(fx);...
    imag(fx);...
    real(fz);...
    imag(fz)]';

% get current dispersion
d=finddispersion6Err(rcor,indBPM,indrfc,alpha,delta,inCOD);
dyc=d(3,:);


if printouttext
    % display results
    disp(['        before' '    ' '-->' '    ' 'after'])
    disp(['rs: ' num2str(std(rs0-refrdt(1,:))*1e3,'%3.3f') ' -> ' num2str(std(rsc-refrdt(1,:))*1e3,'%3.3f') '']);
    disp(['dY: ' num2str(std(dy0-refdispersion(1,:))*1e3,'%3.3f') ' -> ' num2str(std(dyc-refdispersion(1,:))*1e3,'%3.3f') 'mm'])
    disp(['    ' 'min' '    ' 'mean' '    ' 'max'])
    disp(['ss:'  num2str([min(ss-ss0) mean(ss-ss0) max(ss-ss0)]*1e0,' %2.2f ') ' 1/m2'])
    disp(['dpp: ' num2str(inCOD(5))])
    
%     figure;
%     subplot(2,1,1);
%     plot(rs0-refrdt(1,:),'r'); hold on;
%     plot(rsc-refrdt(1,:),'b'); 
%     legend('before','after')
%     subplot(2,1,2);
%     plot(dy0-refdispersion(1,:),'r'); hold on;
%     plot(dyc-refdispersion(1,:),'b'); 
    
end


end
