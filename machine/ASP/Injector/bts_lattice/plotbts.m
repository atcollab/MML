function varargout = plotbts(varargin)
%% plotbts
% MACHINEFUNCTIONS = PLOTBTS
% This fumction will plot the optical functions for the BTS and if provided
% an output argument will also output the optical functions in a struct.
% Assumes the bts transfer line lattice is loaded in the global variable
% BTS as defined in asboosterinit.
%
% This function also assumes some default initial alpha, beta and eta
% values to plot and returns the subsequent twiss parameters for the BTS.
% The defaults are defined in BTSTWISS.
%
% Mark Boland 2006-08-15
% Eugene Tan  2006-08-17: Turned into function and uses machine_at to get
%                         the machine functions and also optionally return
%                         functions as a struct.
global THERING

% Switch THERING to the BTS
getam('BTS_BEND','Model');

% Default to plot the names of the elements
plotnames = 1;
for i=nargin:-1:1
    switch varargin{i}
        case 'nonames'
            plotnames = 0;
    end
end

% calculate the BTS Twiss parameters using the defaults for the ASP BTS
% lattice.
td = btstwiss;

% Plot results
figure('Position',[153         326        1269         799]);
axes('position', [0.1 0.3 0.85 0.65]);
plot(td.spos,td.betax,'-b');
hold on
plot(td.spos,td.betay,'--r');
plot(td.spos,td.etax*10,'-.g');
plotelementsat(THERING);
legend('betax','betay','etax*10')
hold off
set(gca,'XLim',[td.spos(1) td.spos(end)]);
text(td.spos(end)*0.85,max(td.betax)/2,{sprintf('\\beta_x = %6.3f',td.betax(end));...
                                 sprintf('\\alpha_x = %6.3f',td.alphax(end));...
                                 sprintf('\\beta_y = %6.3f',td.betay(end));...
                                 sprintf('\\alpha_y = %6.3f',td.alphay(end));...
                                 sprintf('\\eta_x = %6.3f',td.etax(end));...
                                 sprintf('\\eta_{x''} = %6.3f',td.etapx(end))});
                             
if nargout == 1
    varargout{1} = td;
end

if plotnames
    %% add names and model
    title ('Polarity & end-to-end control system check of BTS, 6 June 2006')
    text(-4.3,-35,'Polarity','fontsize',12)
    text(-4,-47, 'Control', 'Rotation', 90, 'VerticalAlignment','cap', 'HorizontalAlignment','left')
    text(-2.7,-47, 'System','Rotation', 90)
    text(-1.6,-46.5, 'Name','Rotation', 90)
    text(2.5,-50, 'PS-OC-3-1', 'Rotation', 90)
    text(3.5,-50, 'PS-SEP-A-3', 'Rotation', 90)
    text(7.5,-50, 'PS-BA-3-1', 'Rotation', 90)
    text(7.5,-54, 'b1','fontsize',6,'Rotation', 90)
    text(9,-54, 'q21','fontsize',6,'Rotation', 90)
    text(9,-50, 'PS-QFA-3-1', 'Rotation', 90)
    text(10,-50, 'PS-QFA-3-2', 'Rotation', 90)
    text(10,-54, 'q22','fontsize',6,'Rotation', 90)
    text(10.7,-50, 'PS-OC-3-2', 'Rotation', 90)
    text(16,-50, 'PS-BA-3-2', 'Rotation', 90)
    text(16,-54, 'b2','fontsize',6,'Rotation', 90)
    text(18,-50, 'PS-QFB-3-1', 'Rotation', 90)
    text(18,-54, 'q31','fontsize',6,'Rotation', 90)
    text(19.4,-50, 'PS-QFA-3-3', 'Rotation', 90,'fontsize',8)
    text(19.4,-54, 'q32','fontsize',6,'Rotation', 90)
    text(21,-50, 'PS-QFA-3-4', 'Rotation', 90,'fontsize',8)
    text(21,-54, 'q33','fontsize',6,'Rotation', 90)
    text(22,-50, 'PS-OC-3-3', 'Rotation', 90)
    text(23,-50, 'PS-BA-3-3', 'Rotation', 90)
    text(31.5,-54, 'b4','fontsize',6,'Rotation', 90)
    text(23,-54, 'b3','fontsize',6,'Rotation', 90)
    text(24.2,-50, 'PS-QFA-3-5', 'Rotation', 90)
    text(24.2,-54, 'q41','fontsize',6,'Rotation', 90)
    text(25,-50, 'PS-QFA-3-6', 'Rotation', 90)
    text(25,-54, 'q42','fontsize',6,'Rotation', 90)
    text(28,-50, 'PS-OC-3-4', 'Rotation', 90)
    text(28,-54, 'q43','fontsize',6,'Rotation', 90)
    text(29,-50, 'PS-QFA-3-7', 'Rotation', 90)
    text(29.9,-54, 'q44','fontsize',6,'Rotation', 90)
    text(29.9,-50, 'PS-QFB-3-2', 'Rotation', 90)
    text(31.5,-50, 'PS-BA-3-4', 'Rotation', 90)
    text(32.6,-50, 'PS-QFB-3-3', 'Rotation', 90)
    text(32.6,-54, 'q51','fontsize',6,'Rotation', 90)
    text(33.5,-50, 'PS-QFC-3-1', 'Rotation', 90,'fontsize',7)
    text(33.5,-54, 'q52','fontsize',6,'Rotation', 90)
    text(33.5,-54, 'q53','fontsize',6,'Rotation', 90)
    text(34,-50, 'PS-OC-3-5', 'Rotation', 90,'fontsize',7)
    text(34.5,-50, 'PS-QFA-3-8', 'Rotation', 90,'fontsize',7)
    text(35,-50, 'PS-SEP-B-3', 'Rotation', 90,'fontsize',7)
    line(5,40)
    text(1,-67, 'extrseptum', 'Rotation', 90)
    text(3,-67.4, 'extrmagnet', 'Rotation', 90)
    text(36.2,-67.4, 'pre-septum', 'Rotation', 90)
    text(37.6,-67.4, 'inseptum', 'Rotation', 90)
    text(10.4,-67.4, 'screen 1', 'Rotation', 90)
    text(19.5,-67.4, 'screen 2', 'Rotation', 90)
    text(33.3,-67.4, 'screen 3', 'Rotation', 90)
    text(38.8,-67.4, 'screen 4', 'Rotation', 90)
end