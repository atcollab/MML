function varargout = plotltb(varargin)
%% plotltb
% MACHINEFUNCTIONS = PLOTLTB
% This fumction will plot the optical functions for the LTB and if provided
% an output argument will also output the optical functions in a struct.
% Assumes the ltb transfer line lattice is loaded in the global variable
% LTB as defined in asboosterinit.
%
% This function also assumes some default initial alpha, beta and eta
% values to plot and returns the subsequent twiss parameters for the LTB.
% The defaults are defined in LTBTWISS.
%
% Mark Boland 2006-08-15
% Eugene Tan  2006-08-17: Turned into function and uses machine_at to get
%                         the machine functions and also optionally return
%                         functions as a struct.
% Change the THERING to the BTS
getam('LTB_BEND','Model');

global THERING

% Default to plot the names of the elements
plotnames = 1;
for i=nargin:-1:1
    switch varargin{i}
        case 'nonames'
            plotnames = 0;
    end
end

% calculate the LTB Twiss parameters using the defaults for the ASP LTB
% lattice.
td = ltbtwiss;

% Plot results
figure('Position',[153         326        1269         799]);
axes('position',[0.1 0.2 0.85 0.75])
plot(td.spos,td.betax,'-b');
hold on
plot(td.spos,td.betay,'--r');
plot(td.spos,td.etax*10,'-.g');
plotelementsat(THERING);
legend('betax','betay','etax*10')
hold off
set(gca,'XLim',[td.spos(1) td.spos(end)]);
text(td.spos(end)*0.80,max(td.betax)/2,{sprintf('\\beta_x = %6.3f',td.betax(end));...
                                 sprintf('\\alpha_x = %6.3f',td.alphax(end));...
                                 sprintf('\\beta_y = %6.3f',td.betay(end));...
                                 sprintf('\\alpha_y = %6.3f',td.alphay(end));...
                                 sprintf('\\eta_x = %6.3f',td.etax(end));...
                                 sprintf('\\eta_{x''} = %6.3f',td.etapx(end))});

% Plot the names of the elements
if plotnames
    title('Polarity & end-to-end control system check of LTB, 6 June 2006')
    text(-1.5,-42,'Control','Rotation', 90)
    text(-1.2,-41.8,'sytem','Rotation', 90)
    text(-0.9,-41.7,'name','Rotation', 90)
    text(0.4,-44,'OCH-A-1-01','Rotation', 90)
    text(0.9,-44,'PS-Q-1-1','Rotation', 90)
    text(1.34,-44,'PS-Q-1-2','Rotation', 90,'fontsize',9)
    text(1.83,-44,'PS-Q-1-3','Rotation', 90,'fontsize',9)
    text(0.9,-50,'q11','Rotation', 90)
    text(1.4,-50,'q12','Rotation', 90)
    text(1.85,-50,'q13','Rotation', 90)
    text(3.1,-44,'PS-Q-1-4','Rotation', 90)
    text(1.59,-44,'OCV-A-1-01','Rotation', 90,'fontsize',7)
    text(2.2,-50,'b1','Rotation', 90)
    text(3.1,-50,'q2','Rotation', 90)
    text(4,-50,'b1','Rotation', 90)
    text(4.7,-50,'q31','Rotation', 90)
    text(4.7,-44,'PS-Q-1-5','Rotation', 90)
    text(5.2,-50,'q32','Rotation', 90)
    text(5.2,-44,'PS-Q-1-6','Rotation', 90)
    text(5.7,-44,'OCV-A-1-02','Rotation', 90)
    text(7.3,-50,'q33','Rotation', 90)
    text(7.3,-44,'PS-Q-1-7','Rotation', 90)
    text(7.7,-50,'q34','Rotation', 90)
    text(7.7,-44,'PS-Q-1-8','Rotation', 90)
    text(8.1,-50,'b3','Rotation', 90)
    text(9.25,-50,'q41','Rotation', 90)
    text(9.25,-44,'PS-Q-1-9','Rotation', 90)
    text(10,-50,'q42','Rotation', 90)
    text(10,-44,'PS-Q-1-10','Rotation', 90)
    text(10.6,-44,'OCV-A-1-03','Rotation', 90)
    text(10.9,-50,'q43','Rotation', 90)
    text(10.9,-44,'PS-Q-1-11','Rotation', 90)
    text(11.4,-44,'OCH-A-1-02','Rotation', 90)
    text(11.87,-44,'OCV-A-1-04','Rotation', 90)
    text(12.75,-44,'BSEP','Rotation', 90)
    text(14.9,-44,'BRICK','Rotation', 90)
end

if nargout == 1
    varargout{1} = td;
end