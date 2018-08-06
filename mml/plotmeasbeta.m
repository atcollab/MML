function plotmeasbeta(varargin)
%PLOTMEASBETA - plot quadrupole betatron function from measurement
%
%  INPUTS
%  None - Ask user to select a file
%  1. AO - output structure from measbeta programme
%
%  See also measbeta, plotbeta

%  Written by Laurent S. Nadolski


FileName = '';

if isempty(varargin)
    if isempty(FileName)
        DirectoryName = getfamilydata('Directory', 'QUAD');
        DirStart = pwd;
        cd(DirectoryName);
        [FileName, DirectoryName] = uigetfile('*.mat', 'Select a Quad File');
        if FileName == 0 
            ArchiveFlag = 0;
            disp('   Quadrupole betatron plotting canceled.');
            return
        end
        FileName = [DirectoryName, FileName];
    end    
    % Load from file
    load(FileName);
    cd(DirStart);
else
    AO = varargin{1};
end

QuadFam = fieldnames(AO.FamilyName);

spos  = [];
betax = [];
betaz = [];

for k = 1:length(QuadFam)
%     spos  = [spos AO.FamilyName.(QuadFam{k}).Position];
%     betax = [betax AO.FamilyName.(QuadFam{k}).beta(:,1)];
%     betaz = [betaz AO.FamilyName.(QuadFam{k}).beta(:,2)];
     betax = AO.FamilyName.(QuadFam{k}).beta(:,1);
     betaz = AO.FamilyName.(QuadFam{k}).beta(:,2);
    
    figure
    subplot(2,1,1)
    bar(betax)
    xlabel('Quadrupole number')
    ylabel('\beta_x [m]');
    title(sprintf('%s quadrupole family', QuadFam{k}))

    subplot(2,1,2)
    bar(betaz)
    xlabel('Quadrupole number')
    ylabel('\beta_z [m]');
    addlabel(1,0,sprintf('%s', datestr(AO.TimeStamp,0)));
end
