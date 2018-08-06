function [FileName, DirectoryName] = arplot_boosterRF_report(DirectoryName)
%ARPLOT_BOOSTERRF_REPORT - Publish archiver plots from arplot_boosterRF to a web page
%
%  DIRECTIONS
%  1. run arplot_boosterRF
%  3. make sure the plots are scaled properly
%  4. run arplot_boosterRF_report
%
%  See also arplot arplot_sr

%  Written by Greg Portmann
%  Modified from arplot_sr_report to publish Booster RF plots


DirectoryDate = getappdata(1, 'ArchiveDate');

ButtonName = questdlg('Do to want to publish this report to the ALS website?','ARPLOT_BOOSTERRF_REPORT','Yes','No','Cancel','Yes');
drawnow;
switch ButtonName,
    case 'Yes'
        PresentDirectory = pwd;
        if ispc
            DirectoryName = ['\Als-filer\physweb\performance_reports\weekly\', DirectoryDate];
        else
            DirectoryName = ['/home/als2/www/htdoc/als_physics/performance_reports/weekly/', DirectoryDate];
        end
        
        gotodirectory(DirectoryName);
        cd(PresentDirectory);

    case 'No'
        if nargin == 0
            % Get directory path to write HTML file
            % DirectoryName = getfamilydata('Directory', 'DataRoot');
            % i = findstr(DirectoryName, filesep);
            % DirectoryName = DirectoryName(1:i(end-1))
            % DirectoryName = [DirectoryName, 'HTML', filesep];
            % DirectoryName = uigetdir(DirectoryName, 'Select a directory to put the HTLM output');
            
            %[DirectoryName, FileName, ExtentionName] = fileparts(which('getsp'));
            %i = findstr(DirectoryName, filesep);
            %if isempty(i)
            %    error('Directory not found');
            %else
            %    DirectoryName = [DirectoryName(1:i(end)), 'users', filesep, 'html', filesep, 'Archiver', filesep];
            %    DirectoryName = uigetdir(DirectoryName, 'Select a directory to put the arplot HTLM output');
            %    if DirectoryName == 0
            %        return;
            %    end
            %end
            
            DirectoryName = uigetdir([pwd, filesep], 'Select a directory to put the arplot HTML output');
            if DirectoryName == 0
                return;
            end
        end
        
    otherwise
        return;

end


saveas(figure(1), 'ARPlot_Fig1', 'fig');
saveas(figure(2), 'ARPlot_Fig2', 'fig');
saveas(figure(3), 'ARPlot_Fig3', 'fig');
saveas(figure(4), 'ARPlot_Fig4', 'fig');

options.format = 'html';
options.outputDir = DirectoryName;
options.showCode = false;

FileName = publish('arplot_boosterRF_html', options);


delete('ARPlot_Fig1.fig');
delete('ARPlot_Fig2.fig');
delete('ARPlot_Fig3.fig');
delete('ARPlot_Fig4.fig');


% Open website
web(FileName);

