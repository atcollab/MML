function plot_all_linac_watchdog_files(varargin)
% function plot_all_linac_watchdog_files(varargin)
%
% Routine that plots the saved data files of the linac watchdog program

gotodata

load 'modulator_reference_waveforms.mat'
mod1nom=mod1;mod2nom=mod2;timevecnom=timevec;

dirdata = dir('linac_modulator*.mat');

if nargin>0
    starttime = datenum(varargin);
else
    starttime = datenum('2014-01-01');
end

if size(dirdata,1)>0
    for loop=1:size(dirdata,1)
        if dirdata(loop).datenum > starttime
            load(dirdata(loop).name);
            if exist('ionpump','var')
                if ~exist('timevec16','var')
                    timevec16=(0:length(kly2fwd))*2.0001e-9-1e-5
                end
                indvec=find(timevec>0);
                indvec2=find(timevec16>0);
                
                figure
                subplot(2,1,1);
                plot( ...
                    timevecnom(indvec),mod1nom(indvec),'c-',timevecnom(indvec),mod2nom(indvec),'m-', ...
                    timevec(indvec),mod1(indvec),'b-',timevec(indvec),mod2(indvec),'r-');
                xaxis([min(timevec(indvec)) max(timevec(indvec))]);
                xlabel('t [s]');
                ylabel('Modulator Output');
                legend('Mod 1 reference','Mod 2 reference','Mod 1 actual','Mod 2 actual')
                title(datestr(dirdata(loop).datenum));
                subplot(2,1,2);
                plot( ...
                    timevec16(indvec2),kly2cathv(indvec2)/20,'c-',timevec16(indvec2),ionpump(indvec2)/20,'m-', ...
                    timevec16(indvec2),kly2fwd(indvec2),'b-',timevec16(indvec2),ln2fwd(indvec2),'r-');
                xaxis([min(timevec(indvec)) max(timevec(indvec))]);
                xlabel('t [s]');
                ylabel('Kly 2 / LN 2');
                legend('Kly 2 Cath Volt/20','Ion Pump/20','Kly 2 Fwrd Pwr','LN 2 Fwrd Pwr')
            else
                indvec=find(timevec>0);
                
                figure
                plot( ...
                    timevecnom(indvec),mod1nom(indvec),'c-',timevecnom(indvec),mod2nom(indvec),'m-', ...
                    timevec(indvec),mod1(indvec),'b-',timevec(indvec),mod2(indvec),'r-');
                xaxis([min(timevec(indvec)) max(timevec(indvec))]);
                xlabel('t [s]');
                ylabel('Modulator Output');
                legend('Mod 1 reference','Mod 2 reference','Mod 1 actual','Mod 2 actual')
                title(datestr(dirdata(loop).datenum));
            end
        end
    end
end

    