function WeishiData = getuniverse(varargin)
%GETUNIVERSE - Returns a structure of stable lattice configurations
%  WeishiData = getuniverse(varargin)
%  1. QF  (1/m2)
%  2. QD  (1/m2)
%  3. QFA (1/m2)
%  4. MuX
%  5. MuY
%  6. BetaXStraight  (center of straight)  (m)
%  7. BetaYStraight  (center of straight)  (m)
%  8. DxStraight     (center of straight)  (m)
%  9. Alpha0         (MAD convention)   (1e-3)
% 10. SigmaXStraight (center of straight) (mm)  ???
% 11. Emittance      (micron)
% 12. BetaXB1        (center of B1)  (m)
% 13. BetaYB1        (center of B1)  (m)
% 14. DxB1           (center of B1)  (m)
% 15. SigmaXB1       (center of B1) (mm)  ???
% 16. BetaXB2        (center of B2)  (m)
% 17. BetaYB2        (center of B2)  (m)
% 18. DxB2           (center of B2)  (m)
% 19. SigmaXB2       (center of B2) (mm)  ???
%
% MuX and MuY are fractional tunes of one super period and all 12 super periods are identical 
% normal bend sectors.  The range of the k-values are from -10 to 10 1/m2 for QF, QD and QFA. 
% The step size is 0.02. The solutions in this file are those with damping in all 3 dimensions,
% betax and betay at the 3 locations above below 100 m, sigmax at those locations smaller than 
% 10 cm and emittance smaller than 100 micron.
%


if ~isempty(varargin)
    if strcmpi(varargin{1}, 'CreateTable')
        % Since loading the text takes some time, I resaved it in matlab format
        % If the tables get changed, then run getalsuniverse('CreateTable')
        if ispc
            %FileName = 'C:\greg\Matlab\machine\CAMD\StorageRing\fort.8_camd_2003_96_cosy_tunescan_v4_m5p5_1.3GeV_0.02';
            FileName = '\\Als-filer\physweb\website\personal_pages\wwan_files\fort.8_als_2003_cosy_tunescan_v4_m10p10_0.02_total_mu';
        else
            FileName = '/home/als2/www/htdoc/als_physics/website/personal_pages/wwan_files/fort.8_als_2003_cosy_tunescan_v4_m10p10_0.02_total_mu';
        end
        load(FileName);

        WeishiData.QF  = fort(:,1);
        WeishiData.QD  = fort(:,2);
        WeishiData.QFA = fort(:,3);
        WeishiData.MuX = fort(:,4);
        WeishiData.MuY = fort(:,5);

        WeishiData.BetaXStraight = fort(:,6);
        WeishiData.BetaYStraight = fort(:,7);
        
        WeishiData.DxStraight = fort(:,8);

        WeishiData.Alpha0 = 1e-3*fort(:,9);
        WeishiData.SigmaXStraight = 1000*fort(:,10);
        WeishiData.Emittance = 1e-6*fort(:,11);

        WeishiData.BetaXB1 = fort(:,12);
        WeishiData.BetaYB1 = fort(:,13);
        WeishiData.DxB1 = fort(:,14);
        WeishiData.SigmaXB1 = 1000*fort(:,15);

        try
        WeishiData.BetaXB2 = fort(:,16);
        WeishiData.BetaYB2 = fort(:,17);
        WeishiData.DxB2 = fort(:,18);
        WeishiData.SigmaXB2 = 1000*fort(:,19);
        catch
        end
        
        WeishiData = orderfields(WeishiData);

        FileNameSave = [getmmlroot, 'machine', filesep, getfamilydata('Machine'), filesep, 'StorageRing', filesep, getfamilydata('Machine'), 'Universe.mat'];
        save(FileNameSave, 'WeishiData');
        return;
    end
end

FileName = [getfamilydata('Machine'), 'Universe.mat'];

try
    load(FileName);
catch
    error('Could not load universe file %s', FileName);
end






