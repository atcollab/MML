function modelserverdemo(COMMAND,varargin);
% MODELSERVERDEMO
% MATLAB Channel Access Toolbox and Accelerator Toolbox
% to controls applications with
% real-time on-line model features
%
% MODELSERVERDEMO(RING


% This example applications 
%
% 1. monitors the strength of 
% QF,QD quadrupoles families and 
% SF,SD sextupole families
% served by ATfake_sp3.vi LabView(*) program
%  (*) LabView code uses LabView-ActiveX interface to 
%      EPICS by Kay-Uwe Kasemir (LANL)
%
% 2. When any change occurs, MATLAB updates the
% Accelerator Toolbox model with new values and computes
% tunes and chromaticities
%
% 3. Posts the new computed tune and chromaticity values 
% on another server application ATpost_model.vi implemented in LabView
%
% *******************************************************************************

% Load SPEAR3 Lattice

persistent RING QFI QDI SFI SDI qfh qdh sfh sdh txh tyh cxh cyh

if ~ischar(COMMAND)
    error('First argument must be a string')
end

switch lower(COMMAND)
case 'init'
    if iscell(varargin{1})
        RING = varargin{1};
    else
        error('Second argument must be a cell array');
    end
    
    % Find indexes of elements
    QFI = findcells(RING,'FamName','QF');
    QDI = findcells(RING,'FamName','QD');
    SFI = findcells(RING,'FamName','SF');
    SDI = findcells(RING,'FamName','SD');

    % Open conections to CA process variables
    [qfh,qdh,sfh,sdh]=mcaopen('QF','QD','SF','SD');
    [txh, tyh, cxh, cyh] = mcaopen('X-tune','Y-tune','X-chromaticity','Y-chromaticity');
    if ~all([qfh,qdh,sfh,sdh,txh, tyh, cxh, cyh])
        error('Could not open CA connection to one of the PVs')
    end
    
    mcamon(qfh);
    mcamon(qdh);
    mcamon(sfh);
    mcamon(sdh);

    % Install monitors with callbacks to compute and post
    % tunes and chromaticities
    mcamon(qfh,'modelserverdemo(''syncmodel'',''QF''); timereval(3,1,100,''modelserverdemo tunechrompost'');');
    mcamon(qdh,'modelserverdemo(''syncmodel'',''QD''); timereval(3,1,100,''modelserverdemo tunechrompost'');');
    mcamon(sfh,'modelserverdemo(''syncmodel'',''SF''); timereval(3,1,100,''modelserverdemo tunechrompost'');');
    mcamon(sdh,'modelserverdemo(''syncmodel'',''SD''); timereval(3,1,100,''modelserverdemo tunechrompost'');');

case 'syncmodel'
    if ~ischar(varargin{1})
        error('Second argument must be a string');
    else
        switch varargin{1}
        case 'QF'
            RING = setcellstruct(RING,'K',QFI,mcacache(qfh));
            RING = setcellstruct(RING,'PolynomB',QFI,mcacache(qfh),2);
        case 'QD'
            RING = setcellstruct(RING,'K',QDI,mcacache(qdh));
            RING = setcellstruct(RING,'PolynomB',QDI,mcacache(qdh),2);
        case 'SF'
            RING = setcellstruct(RING,'PolynomB',SFI,mcacache(sfh),3);
        case 'SD'
            RING = setcellstruct(RING,'PolynomB',SDI,mcacache(sdh),3);
        otherwise
            warning('Unknown magnet family name');
        end
    end
case 'tunechrompost'
    [t,c] = tunechrom(RING,0,'chrom');
    mcaput(txh, t(1), tyh, t(2), cxh, c(1), cyh, c(2));
end