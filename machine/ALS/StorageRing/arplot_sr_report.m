function [FileName, DirectoryName] = arplot_sr_report(DirectoryName)
%ARPLOT_SR_REPORT - Publish archiver plots from arplot_sr & arplot_sbm to a web page
%
%  DIRECTIONS
%  1. run arplot_sr
%  2. run arplot_sbm
%  3. make sure the plots are scaled properly
%  4. run arplot_sr_report
%
%  See also arplot, arplot_sr, arplot_sbm
 
%  Written by Greg Portmann


FigNum = 10;  % Must be the same as FigNum in arplot_sr


if max(get(0,'Children')) < 21
    error('No superbend figures.  Run arplot_sbm to generate them.');
end


% ArchiveDate gets set by arplot_sr & arplot_sbm
DirectoryDate = getappdata(FigNum+1, 'ArchiveDate');

ButtonName = questdlg('Do to want to publish this report to the ALS website?','ARPLOT_SR_REPORT','Yes','No','Cancel','Yes');
drawnow;
switch ButtonName,
    case 'Yes'
        PresentDirectory = pwd;
        if ispc
            DirectoryName = ['\\Als-filer\physweb\performance_reports\weekly\', DirectoryDate];
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
            
            DirectoryName = uigetdir([pwd, filesep], 'Select a directory to put the arplot HTLM output');
            if DirectoryName == 0
                return;
            end
        end
        
    otherwise
        return;

end

saveas(figure(FigNum+1), 'ARPlot_Fig1', 'fig');
saveas(figure(FigNum+2), 'ARPlot_Fig2', 'fig');
saveas(figure(FigNum+3), 'ARPlot_Fig3', 'fig');
saveas(figure(FigNum+4), 'ARPlot_Fig4', 'fig');
saveas(figure(FigNum+5), 'ARPlot_Fig5', 'fig');
saveas(figure(FigNum+6), 'ARPlot_Fig6', 'fig');
saveas(figure(FigNum+7), 'ARPlot_Fig7', 'fig');
saveas(figure(FigNum+8), 'ARPlot_Fig8', 'fig');
saveas(figure(FigNum+9), 'ARPlot_Fig9', 'fig');
saveas(figure(FigNum+10), 'ARPlot_Fig10', 'fig');
saveas(figure(FigNum+11), 'ARPlot_Fig11', 'fig');
saveas(figure(FigNum+12), 'ARPlot_Fig12', 'fig');
saveas(figure(FigNum+13), 'ARPlot_Fig13', 'fig');
saveas(figure(FigNum+14), 'ARPlot_Fig14', 'fig');
saveas(figure(FigNum+15), 'ARPlot_Fig15', 'fig');
saveas(figure(FigNum+16), 'ARPlot_Fig16', 'fig');
saveas(figure(FigNum+17), 'ARPlot_Fig17', 'fig');
saveas(figure(FigNum+18), 'ARPlot_Fig18', 'fig');
saveas(figure(FigNum+19), 'ARPlot_Fig19', 'fig');
saveas(figure(FigNum+20), 'ARPlot_Fig20', 'fig');
saveas(figure(FigNum+21), 'ARPlot_Fig21', 'fig');
saveas(figure(FigNum+22), 'ARPlot_Fig22', 'fig');
saveas(figure(FigNum+23), 'ARPlot_Fig23', 'fig');
saveas(figure(FigNum+23), 'ARPlot_Fig24', 'fig');
saveas(figure(FigNum+23), 'ARPlot_Fig25', 'fig');

options.format = 'html';
options.outputDir = DirectoryName;
options.showCode = false;

FileName = publish('arplot_sr_html', options);


delete('ARPlot_Fig1.fig');
delete('ARPlot_Fig2.fig');
delete('ARPlot_Fig3.fig');
delete('ARPlot_Fig4.fig');
delete('ARPlot_Fig5.fig');
delete('ARPlot_Fig6.fig');
delete('ARPlot_Fig7.fig');
delete('ARPlot_Fig8.fig');
delete('ARPlot_Fig9.fig');
delete('ARPlot_Fig10.fig');
delete('ARPlot_Fig11.fig');
delete('ARPlot_Fig12.fig');
delete('ARPlot_Fig13.fig');
delete('ARPlot_Fig14.fig');
delete('ARPlot_Fig15.fig');
delete('ARPlot_Fig16.fig');
delete('ARPlot_Fig17.fig');
delete('ARPlot_Fig18.fig');
delete('ARPlot_Fig19.fig');
delete('ARPlot_Fig20.fig');
delete('ARPlot_Fig21.fig');
delete('ARPlot_Fig22.fig');
delete('ARPlot_Fig23.fig');
delete('ARPlot_Fig24.fig');
delete('ARPlot_Fig25.fig');


% Open website
web(FileName);
