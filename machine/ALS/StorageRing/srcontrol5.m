function srcontrol5(action, Input2, Input3)
% srcontrol5
% Storage ring control program
%
% This program controls all storage ring magnets, performs orbit feedback and
% tune feedforward and helps to diagnose problems in routine user operation
% of the ALS storage ring. It includes a gui to simplify the use of this
% program.
%
% It was originally programmed by Greg Portmann (until December 2000) with input
% from Winfried Decking, David Robin, Christoph Steier, Ying Wu and others
% and is currently (July 2002) maintained by Christoph Steier and Tom Scarvie.
%
% The actual version of this program is srcontrol5 (is called by default if you call srcontrol).
%
% Christoph Steier, July 2002
%
% SRCONTROL5 is the newest versionof SRCONTROL, edited to work with G. Portmann's new (2005) Matlab middle layer.
%
% Tom Scarvie, April 2005

% known bugs/problems (May 2001):
% - IDBPM averaging might be a bit too long for orbit feedback
%        solved after Superbend shutdown ... Instead of averaging, digital low pass filters are used
% - gap2tune does not give correct answers for wiggler and potentially other IDs -> orbit feedback
%        seems to be OK for other IDs, has been corrected for wiggler (fit to insertion device
%        compensation table)
% - chicanes do not work in orbit feedback
%        solved. One problem was that orbit response matrizes were mis-scaled by factor of two.
%        Second problem was different time constant of power supply control. Solved by moving controls
%        of center chicanes to cPCI (and magnets are fast, hysteresis free, aircore coils).
%        Center chicane in sector 4 is now routinely used in orbit feedback. Sector 11 to follow soon.
% - zero reading of ID gap dumps beam
%        solved in srcontrol5, still a problem in srcontrol5_hightune (but that routine has to be completely
%        rewritten because of all recent changes to srcontrol5, anyhow). For gap readings below the minimum
%        allowed gap for a device, the tune feedforward disables itself.
% - cycling of lattice causes frequent power supply failures
%        solved by changing the cycling procedure. 1.5 GeV operation is now on the upper hysteresis branch
%        as was the 1.9 GeV injection lattice before.
% - frequently stalled data in IDBPM readout
%        solved with new BPM readouts and digital filtering. Seems to have been a resolution problem
%        of the digital averaging algorithm.
% - magnet ramp tables are not in perfect agreement with magnetic measurements
%        Does not appear to be a serious problem. Superbends are slightly out of sync with other magnets,
%        but this does not cause any negative effects while ramping.
% - no good way to operate with injection at 1.5 GeV and storage energy below that
%        There now is a reasonable way to inject at 1.5 GeV and ramp down to lower storage energy. But
%        it has to be tested again after implementing new (and more) chicanes ...

% revision history
% 2001-05-10, Christoph Steier
% check whether readback from insertion device is significantly (more than 1 mm) below minimum
% gap, to avoid false zero readings of insertion device gaps to cause the tune feed forward
% to implement false huge correction (and dump the beam). If the insertion device gap readbacks
% gets more than 1 mm below the nominal minimum gap, the routine now assumes the insertion device
% to be open.
%
% 2001-08-30 and during Superbend commissioning, Christoph Steier, Tom Scarvie, Winni Decking
% various changes have been made to incorporate the Superbends and some other new equipment
% installed in the Superbend shutdown. This included some changes to programs being called by srcontrol
% (like srload, srsave, srcycle, srramp, ...). The main changes within srcontrol were in the orbit
% correction and slow orbit feedback routines (incorporating frequency feedback, ...)
%
% 2002-05-04, Christoph Steier
% added new IDBPMs, modified orbit feedback to use trim DACs, removed LSB toggling in vertical
% orbit feedback, ...
%
% 2002-07-29, T.Scarvie
% added check of CM trim currents to warn of problems that might rail the orbit feedback
%
% 2002-07-31, Christoph Steier
% increased the gain of the RF frequency feedback from 1/50 of the gain of the horizontal
% orbit feedback to 1/20. Reason was that the frequency feedback was reacting a bit too slow if all
% insertion device gaps are closed at once at high speed at the beginning of a fill.
%
% 2002-08-05, C.Steier, T.Scarvie
% Added conditional to reduce orbit feedback gain if running in two-bunch mode
%
% 2003-06-02, T.Scarvie
% Added loop inside orbit feedback to reset the SR11 chicane M1 and M2 motors every 20s to combat drift problem
%
% 2003-06-18, C. Steier
% Disabled loop to periodically reset chicane in SR11. Al Robb replaced power supply, seems to be no problem anymore.
%
% 2004-05-10, C. Steier
% The list of all BBPMs is now set up automatically be calling getlist('BBPMx'). This way, new BBPMs have to be added
% at fewer places in the software. It should now be sufficient to modify getlist and run the orbit response matrix
% rountine (getsmat) once to enable use of the new BBPMs.
%
% 2004-05-14, C. Steier
% Modified parameters for ramprate reduction (in srramp and here). Previous parameters were slightly too
% cautious. Increased initial slow ramprate to 0.4 A/s.
%
% 2004-05-14, C. Steier
% Incorporated insertion device compensation schemes for nu_y = 9.2 lattice.
%
% 2004-06-14, T.Scarvie
% Added controls for fast orbit feedback
%
% 2004-06-21, C. Steier
% Added tune feedforward (in the global tune compensation scheme for the nu_y=9.2 lattice) for the shift
% dependent tune shift of the EPUs, as well as a skew quadrupole feedforward for the EPU im sector 11
% (both only active in parallel mode so far).
%
% 2005-02-13, T.Scarvie
% Separated horizontal and vertical planes for setting Fast Feedback PIDs
%
% 2008-07-31, T.Scarvie
% Added checks to orbit correction to warn if SR bumps are on
%
% 2010-09-16, C. Steier
% Adjusted gain of RF frequency in feedback to take new voltage divider into account.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NOTES for conversion to new Middle Layer %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% We never use the gap and bump control flags - the radio buttons have been disabled - 
%        should we try to keep the functionality?
%
% checksrmags
% checksrorbit(...)


% For the compiler
%#function goldenpage
%#function setoperationalmode


% Check if the AO exists
checkforao;


%%%%%%%%%%%%%%
% Initialize %
%%%%%%%%%%%%%%

global FEEDBACK_STOP_FLAG

SR_Mode = getfamilydata('OperationalMode');
SR_GEV = getfamilydata('Energy');

BSCramprate = getfamilydata('BSCRampRate');
if isnan(BSCramprate) || isempty(BSCramprate)
    BSCramprate = 0.4;
    setfamilydata(BSCramprate, 'BSCRampRate');
end

if nargin < 1
    action = 'Initialize';
end
if nargin < 2
    Input2 = 0;
end
if nargin < 3
    Input3 = 0;
end

if strcmp(getfamilydata('OperationalMode'), '1.9 GeV, Two-Bunch')
    FOFBcheckboxVal = 0;
else
    FOFBcheckboxVal = 1;
end

% if strcmp(getfamilydata('OperationalMode'), '1.5 GeV, Inject at 1.23') || strcmp(SR_Mode, '1.9 GeV, Inject at 1.353')
%     TUNEcheckboxVal = 0;
% else
TUNEcheckboxVal = 1;
% end

%%%%%%%%%%%%%%%%
% Main Program %
%%%%%%%%%%%%%%%%

switch(action)

    case 'StopOrbitFeedback'

        FEEDBACK_STOP_FLAG = 1;

    case 'Initialize'

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % GUI
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        ButtonWidth = 200;
        ButtonHeight  = 25;

        Offset1 = 8*25+12 + 47 + 25+25;
        Offset2 = 47+25+25;
        Offset3 = 45+25;
        Offset4 = 1;
        Offset5 = 30;
        FigWidth = ButtonWidth+6;
        FigHeight  = 3+9*(ButtonHeight+6)+24+Offset1;
        ButtonWidth = 200-6;

        % Change figure position
        set(0,'Units','pixels');
        p=get(0,'screensize');

        h0 = figure( ...
            'Color',[0.8 0.8 0.8], ...
            'HandleVisibility','Off', ...
            'Interruptible', 'on', ...
            'MenuBar','none', ...
            'Name','ALS SR CONTROL', ...
            'NumberTitle','off', ...
            'Units','pixels', ...
            'Position',[30 p(4)-FigHeight-40 FigWidth FigHeight+Offset5], ...
            'Resize','off', ...
            'Tag','SRCTRLFig1');

        h1 = uicontrol('Parent',h0, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'Callback','', ...
            'Enable','On', ...
            'FontSize',10, ...
            'FontWeight','Bold', ...
            'Interruptible','Off', ...
            'HorizontalAlignment','Center', ...
            'Position',[6 3+8*(ButtonHeight+3)+19+19+8+Offset1  ButtonWidth 20+Offset5], ...
            'Style','text', ...
            'String','', ...
            'Tag','SRCTRLTitle');

        % Frame Box I
        h1 = uicontrol('Parent',h0, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'ListboxTop',0, ...
            'Position',[3 3+3*(ButtonHeight+3)+Offset1-3+Offset5 ButtonWidth+6 7*ButtonHeight+18], ...
            'Style','frame');

        h1 = uicontrol('Parent',h0, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'Callback','', ...
            'Enable','On', ...
            'FontSize',10, ...
            'Interruptible','Off', ...
            'HorizontalAlignment','Center', ...
            'Position',[6 3+9*(ButtonHeight+3)+Offset1  ButtonWidth 15+Offset5], ...
            'Style','text', ...
            'String','Lattice Setup Functions');

        h1 = uicontrol('Parent',h0, ...
            'Callback','srcontrol5(''CheckInputs'');srcontrol5(''Cycle'',get(findobj(gcbf,''Tag'',''SRCTRLRadioGaps''),''Value''),get(findobj(gcbf,''Tag'',''SRCTRLRadioBumps''),''Value''));', ...
            'Enable','On', ...
            'Interruptible','Off', ...
            'Position',[6 3+8*(ButtonHeight+3)+Offset1+Offset5 ButtonWidth ButtonHeight], ...
            'String','Cycle SR Lattice', ...
            'Tag','SRCTRLButton1');

        h1 = uicontrol('Parent',h0, ...
            'Callback','srcontrol5(''CheckInputs'');srcontrol5(''Injection'',get(findobj(gcbf,''Tag'',''SRCTRLRadioGaps''),''Value''),get(findobj(gcbf,''Tag'',''SRCTRLRadioBumps''),''Value''));', ...
            'Enable','On', ...
            'Interruptible','Off', ...
            'Position',[6 3+7*(ButtonHeight+3)+Offset1+Offset5 ButtonWidth ButtonHeight], ...
            'String','Injection', ...
            'Tag','SRCTRLButton2');

        h1 = uicontrol('Parent',h0, ...
            'Callback','srcontrol5(''CheckInputs'');srcontrol5(''Production'',get(findobj(gcbf,''Tag'',''SRCTRLRadioGaps''),''Value''),get(findobj(gcbf,''Tag'',''SRCTRLRadioBumps''),''Value''));', ...
            'Enable','On', ...
            'Interruptible','Off', ...
            'Position',[6 3+6*(ButtonHeight+3)+Offset1+Offset5 ButtonWidth ButtonHeight], ...
            'String',['Production'], ...
            'Tag','SRCTRLButton3');

        h1 = uicontrol('Parent',h0, ...
            'Callback',[...
            'fprintf(''\n'');' ...
            'disp([''   **********************************************'']);', ...
            'disp([''   **  Changing Storage Ring Operational Mode  **'']);', ...
            'disp([''   **********************************************'']);', ...
            'setoperationalmode;', ...
            'srcontrol5(''CheckInputs'');', ...
            'disp([''   ****************************'']);', ...
            'disp([''   **  Mode Change Complete  **'']);', ...
            'disp([''   ****************************'']);', ...
            'fprintf(''\n'');'], ...
            'Enable','On', ...
            'Interruptible','Off', ...
            'Position',[6 3+5*(ButtonHeight+3)+Offset1+Offset5 ButtonWidth ButtonHeight], ...
            'Value',1, ...
            'String','Change Operational Mode', ...
            'Tag','SRCTRLButtonChangeMode');

        h1 = uicontrol(...
            'Parent',h0, ...
            'Callback', [...
            'srcontrol5(''CheckInputs'');',...
            'srcontrol5(''SRState'');'], ...
            'Interruptible','Off', ...
            'Enable','On', ...
            'Position',[6 3+4*(ButtonHeight+3)+Offset1+Offset5 ButtonWidth ButtonHeight], ...
            'String','Check For Problems', ...
            'Tag','SRCTRLButtonSRState');

        h1 = uicontrol('Parent',h0, ...
            'Callback','srcontrol5(''CheckInputs''); goldenpage;', ...
            'Interruptible','Off', ...
            'Enable','On', ...
            'Position',[6 3+3*(ButtonHeight+3)+Offset1+Offset5 ButtonWidth ButtonHeight], ...
            'String','Golden Page', ...
            'Tag','SRCTRLButtonGoldenPage');


        % Frame Box II
        h1 = uicontrol('Parent',h0, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'ListboxTop',0, ...
            'Position',[3 3+9*(ButtonHeight+3)-29+Offset2+Offset5 ButtonWidth+6 2*ButtonHeight+15], ...
            'Style','frame');
        h1 = uicontrol('Parent',h0, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'FontSize',10, ...
            'ListboxTop',0, ...
            'Position',[6 3+10*(ButtonHeight+3)-10+Offset2 ButtonWidth .6*ButtonHeight+Offset5], ...
            'String','Global/Local Orbit Correction', ...
            'Style','text');
        h1 = uicontrol('Parent',h0, ...
            'Callback','srcontrol5(''OrbitCorrection'');', ...
            'Interruptible','Off', ...
            'Enable','On', ...
            'Position',[6 3+9*(ButtonHeight+3)-6+Offset2+Offset5 ButtonWidth ButtonHeight], ...
            'String','Correct Global Orbit w/ IDBPMs', ...
            'Tag','SRCTRLButtonOrbitCorrection');
        h1 = uicontrol('Parent',h0, ...
            'CreateFcn','srcontrol5(''OrbitCorrectionSetup'',1);', ...
            'callback','srcontrol5(''OrbitCorrectionSetup'',0);', ...
            'Enable','on', ...
            'Interruptible', 'off', ...
            'Position',[6 9*(ButtonHeight+3)-22+Offset2+Offset5 ButtonWidth .7*ButtonHeight], ...
            'String','Edit IDBPM, CM, & Local Bump Lists', ...
            'Style','PushButton', ...
            'Value',0,...
            'Tag','SRCTRLButtonOrbitCorrectionSetup');


        % Frame Box III
        h1 = uicontrol('Parent',h0, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'ListboxTop',0, ...
            'Position',[3 1*(ButtonHeight)+Offset3+Offset5-38 ButtonWidth+6 8*ButtonHeight+61], ...
            'Style','frame');
        h1 = uicontrol('Parent',h0, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'FontSize',10, ...
            'ListboxTop',0, ...
            'Position',[6 3+9*(ButtonHeight+3)+Offset3-25 ButtonWidth .55*ButtonHeight+Offset5], ...
            'String','Orbit Feedback', ...
            'Style','text');

        h1 = uicontrol('Parent',h0, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'Enable','on', ...
            'Interruptible', 'on', ...
            'Position',[26 3+8*(ButtonHeight+3)+Offset3-18+Offset5 ButtonWidth-32 .8*ButtonHeight], ...
            'String','Slow Orbit Correction', ...
            'Style','checkbox', ...
            'Value',1,...
            'Tag','SRCTRLCheckboxSOFB');
        h1 = uicontrol('Parent',h0, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'Enable','on', ...
            'Interruptible', 'on', ...
            'Position',[26 3+7*(ButtonHeight+3)+Offset3-9+Offset5 ButtonWidth-32 .8*ButtonHeight], ...
            'String','Fast Orbit Correction', ...
            'Style','checkbox', ...
            'Value',FOFBcheckboxVal,...
            'Tag','SRCTRLCheckboxFOFB');

        h1 = uicontrol('Parent',h0, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'Enable','on', ...
            'Interruptible', 'on', ...
            'Position',[26 3+6*(ButtonHeight+3)+Offset3+Offset5 ButtonWidth-32 .8*ButtonHeight], ...
            'String','Correct ID Tune Shift  ', ...
            'Style','checkbox', ...
            'Value',TUNEcheckboxVal,...
            'Tag','SRCTRLCheckboxTune');

        h1 = uicontrol('Parent',h0, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'Enable','on', ...
            'Interruptible', 'on', ...
            'Position',[26 3+5*(ButtonHeight+3)+Offset3+9+Offset5 ButtonWidth-32 .8*ButtonHeight], ...
            'String','Correct RF Frequency', ...
            'Style','checkbox', ...
            'Value',1,...
            'Tag','SRCTRLCheckboxRF');

        h1 = uicontrol('Parent',h0, ...
            'callback','srcontrol5(''Feedback'');', ...
            'Enable','on', ...
            'FontSize',12, ...
            'Interruptible', 'on', ...
            'ListboxTop',0, ...
            'Position',[8 3+5*(ButtonHeight+3)+3+Offset3-25+Offset5 .5*ButtonWidth-6 1.0*ButtonHeight], ...
            'String','Start FB', ...
            'Value',0, ...
            'Tag','SRCTRLPushbuttonStart');
        h1 = uicontrol('Parent',h0, ...
            'callback','srcontrol5(''StopOrbitFeedback'');pause(0);', ...
            'Enable','off', ...
            'FontSize',12, ...
            'Interruptible', 'on', ...
            'ListboxTop',0, ...
            'Position',[.5*FigWidth+3 3+5*(ButtonHeight+3)+3+Offset3-25+Offset5 .5*ButtonWidth-6 1.0*ButtonHeight], ...
            'String','Stop FB', ...
            'Value',0, ...
            'Tag','SRCTRLPushbuttonStop');

        h1 = uicontrol('Parent',h0, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'HorizontalAlignment','left', ...
            'ListboxTop',0, ...
            'Position',[14 4*(ButtonHeight)+Offset3+Offset5-3 ButtonWidth-14 .75*ButtonHeight], ...
            'String','Horizontal RMS = _____ mm', ...
            'Style','text', ...
            'Tag','SRCTRLStaticTextHorizontal');
        h1 = uicontrol('Parent',h0, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'HorizontalAlignment','left', ...
            'ListboxTop',0, ...
            'Position',[26 3+3.5*(ButtonHeight)+16+Offset3-25+Offset5 ButtonWidth-26 .75*ButtonHeight], ...
            'String','Vertical RMS = _____ mm', ...
            'Style','text', ...
            'Tag','SRCTRLStaticTextVertical');

        h1 = uicontrol('Parent',h0, ...
            'CreateFcn','srcontrol5(''FeedbackSetup'',1);', ...
            'callback','srcontrol5(''FeedbackSetup'',0);', ...
            'Enable','on', ...
            'Interruptible', 'off', ...
            'Position',[8 3+3.5*(ButtonHeight)+.5+Offset3-25+Offset5 ButtonWidth-5 .75*ButtonHeight], ...
            'String','Edit SOFB Setup', ...
            'Style','PushButton', ...
            'Value',0,...
            'Tag','SRCTRLButtonFeedbackSetup');

        h1 = uicontrol('Parent',h0, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'HorizontalAlignment','left', ...
            'ListboxTop',0, ...
            'Position',[7 4*(ButtonHeight)+Offset3-32 ButtonWidth-145 .75*ButtonHeight], ...
            'String','01 ____', ...
            'Style','text', ...
            'FontSize', 8,...
            'Tag','SRCTRLStaticTextFOFB01');

        h1 = uicontrol('Parent',h0, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'HorizontalAlignment','left', ...
            'ListboxTop',0, ...
            'Position',[55 4*(ButtonHeight)+Offset3-32 ButtonWidth-145 .75*ButtonHeight], ...
            'String','02 ____', ...
            'Style','text', ...
            'FontSize', 8,...
            'Tag','SRCTRLStaticTextFOFB02');

        h1 = uicontrol('Parent',h0, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'HorizontalAlignment','left', ...
            'ListboxTop',0, ...
            'Position',[103 4*(ButtonHeight)+Offset3-32 ButtonWidth-145 .75*ButtonHeight], ...
            'String','03 ____', ...
            'Style','text', ...
            'FontSize', 8,...
            'Tag','SRCTRLStaticTextFOFB03');

        h1 = uicontrol('Parent',h0, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'HorizontalAlignment','left', ...
            'ListboxTop',0, ...
            'Position',[151 4*(ButtonHeight)+Offset3-32 ButtonWidth-145 .75*ButtonHeight], ...
            'String','04 ____', ...
            'Style','text', ...
            'FontSize', 8,...
            'Tag','SRCTRLStaticTextFOFB04');

        h1 = uicontrol('Parent',h0, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'HorizontalAlignment','left', ...
            'ListboxTop',0, ...
            'Position',[7 4*(ButtonHeight)+Offset3-47 ButtonWidth-145 .75*ButtonHeight], ...
            'String','05 ____', ...
            'Style','text', ...
            'FontSize', 8,...
            'Tag','SRCTRLStaticTextFOFB05');

        h1 = uicontrol('Parent',h0, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'HorizontalAlignment','left', ...
            'ListboxTop',0, ...
            'Position',[55 4*(ButtonHeight)+Offset3-47 ButtonWidth-145 .75*ButtonHeight], ...
            'String','06 ____', ...
            'Style','text', ...
            'FontSize', 8,...
            'Tag','SRCTRLStaticTextFOFB06');

        h1 = uicontrol('Parent',h0, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'HorizontalAlignment','left', ...
            'ListboxTop',0, ...
            'Position',[103 4*(ButtonHeight)+Offset3-47 ButtonWidth-145 .75*ButtonHeight], ...
            'String','07 ____', ...
            'Style','text', ...
            'FontSize', 8,...
            'Tag','SRCTRLStaticTextFOFB07');

        h1 = uicontrol('Parent',h0, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'HorizontalAlignment','left', ...
            'ListboxTop',0, ...
            'Position',[151 4*(ButtonHeight)+Offset3-47 ButtonWidth-145 .75*ButtonHeight], ...
            'String','08 ____', ...
            'Style','text', ...
            'FontSize', 8,...
            'Tag','SRCTRLStaticTextFOFB08');

        h1 = uicontrol('Parent',h0, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'HorizontalAlignment','left', ...
            'ListboxTop',0, ...
            'Position',[7 4*(ButtonHeight)+Offset3-62 ButtonWidth-145 .75*ButtonHeight], ...
            'String','09 ____', ...
            'Style','text', ...
            'FontSize', 8,...
            'Tag','SRCTRLStaticTextFOFB09');

        h1 = uicontrol('Parent',h0, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'HorizontalAlignment','left', ...
            'ListboxTop',0, ...
            'Position',[55 4*(ButtonHeight)+Offset3-62 ButtonWidth-145 .75*ButtonHeight], ...
            'String','10 ____', ...
            'Style','text', ...
            'FontSize', 8,...
            'Tag','SRCTRLStaticTextFOFB10');

        h1 = uicontrol('Parent',h0, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'HorizontalAlignment','left', ...
            'ListboxTop',0, ...
            'Position',[103 4*(ButtonHeight)+Offset3-62 ButtonWidth-145 .75*ButtonHeight], ...
            'String','11 ____', ...
            'Style','text', ...
            'FontSize', 8,...
            'Tag','SRCTRLStaticTextFOFB11');

        h1 = uicontrol('Parent',h0, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'HorizontalAlignment','left', ...
            'ListboxTop',0, ...
            'Position',[151 4*(ButtonHeight)+Offset3-62 ButtonWidth-145 .75*ButtonHeight], ...
            'String','12 ____', ...
            'Style','text', ...
            'FontSize', 8,...
            'Tag','SRCTRLStaticTextFOFB12');

        h1 = uicontrol('Parent',h0, ...
            'CreateFcn','srcontrol5(''FastFeedbackSetup'',1);', ...
            'callback','srcontrol5(''FastFeedbackSetup'',0);', ...
            'Enable','on', ...
            'Interruptible', 'off', ...
            'Position',[8 1*(ButtonHeight)+Offset3-3 ButtonWidth-5 .75*ButtonHeight], ...
            'String','Edit FOFB Setup', ...
            'Style','PushButton', ...
            'Value',0,...
            'Tag','SRCTRLButtonFastFeedbackSetup');

        % Frame Box IV
        h1 = uicontrol('Parent',h0, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'ListboxTop',0, ...
            'Position',[3 3+ButtonHeight+Offset4-14+Offset5 ButtonWidth+6 ButtonHeight+12], ...
            'Style','frame');
        h1 = uicontrol('Parent',h0, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'HorizontalAlignment','center', ...
            'ListboxTop',0, ...
            'Position',[6 3+1.75*ButtonHeight+5+Offset4-21+Offset5 ButtonWidth .7*ButtonHeight], ...
            'String','Storage Ring State', ...
            'Style','text', ...
            'Tag','SRCTRLStaticTextHeader');
        h1 = uicontrol('Parent',h0, ...
            'CreateFcn','srcontrol5(''CheckInputs'');', ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'ForegroundColor','b', ...
            'HorizontalAlignment','center', ...
            'ListboxTop',0, ...
            'Position',[6 3+ButtonHeight+6+3+2+Offset4-22+Offset5 ButtonWidth .7*ButtonHeight], ...
            'String','   ', ...
            'Style','text', ...
            'Tag','SRCTRLStaticTextInformation');


        % Frame Box "Close"
        h1 = uicontrol('Parent',h0, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'ListboxTop',0, ...
            'Position',[3 8 ButtonWidth+6 ButtonHeight+8], ...
            'Style','frame');
        h1 = uicontrol('Parent',h0, ...
            'Callback','close(gcbf);', ...
            'Enable','On', ...
            'Interruptible','Off', ...
            'Position',[6 13 ButtonWidth ButtonHeight], ...
            'String','Close', ...
            'Tag','SRCTRLClose');


        % Update database channels
        setsrstatechannels;

        if nargout > 0
            fig = h0;
        end


    case 'Cycle'
        GapFlag = Input2;
        BumpMagnetFlag = Input3;

        fprintf('\n');
        disp('   **************************');
        disp('   **  Storage Ring Cycle  **');
        disp('   **************************');
        a = clock; fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));

        BSCFlag = questdlg(sprintf('Cycle Superbend Magnets?'),'SR Cycle','Yes','No','No');
        %if strcmp(BSCFlag,'No')
        %    disp(['   ** Superbends will not be cycled. **']);
        %else
        %    disp(['   ** Superbends will be cycled during the second mini-cycle only. **']);
        %end

        ChicSQFlag = questdlg(sprintf('Cycle chicanes and skew quads and home motor chicanes?'),'SR Cycle','Yes','No','No');
        %if strcmp(ChicSQFlag,'No')
        %    disp(['   ** Chicanes and skew quads will not be cycled; motor chicanes will not be homed. **']);
        %else
        %    disp(['   ** Chicanes and skew quads will be cycled; motor chicanes will be homed. **']);
        %end


        StartFlag = questdlg(sprintf('Start %.1f GeV Cycle?',SR_GEV),'SR Cycle','Yes','No','No');
        if strcmp(StartFlag,'No')
            disp(['   ***************************']);
            disp(['   **    Cycle  Canceled    **']);
            disp(['   ***************************']);
            fprintf('\n');
            return
        end

        try
            if GapFlag
                % Make sure that the gaps are open with FF off
                if any(getsp('IDpos') ~= maxsp('IDpos'))
                    % Set IDs at max velocity w/ velocity profile off
                    disp('   Insertion device gaps are not open.');
                    disp('   Opening all gaps at maximum speed.');
                    setff([], 1, 0);
                    disp('   Gap control disabled.');
                    disp('   Feed forward enabled.');
                    pause(1);
                    setid([], maxsp('IDpos'), maxsp('IDvel'), 1, 0, 1);
                    disp('   Gaps opened.');
                    disp('   Feed forward and gap control disabled.');
                    a = clock; fprintf('   %s %d:%d:%.0f\n',date, a(4), a(5), a(6));
                else
                    disp('   Feed forward and gap control disabled.');
                end
            else
                disp('   Feed forward and gap control disabled.');
            end

            setff([], 0, 0);
            pause(1);
            
            srcycle(BSCFlag, ChicSQFlag);

            % Load the injection lattice
            fprintf('   Loading the injection lattice   ...');
            setmachineconfig('Injection');
            a = clock; fprintf('   Completed %s %d:%d:%.0f\n', date, a(4), a(5), a(6));

            setpv('SR_STATE',1);

        catch
            fprintf('   %s \n',lasterr);
            fprintf('   Cycle failed due to error condition! \n\n');
            setpv('SR_STATE',-1);
        end

        date;
        a = clock;
        datestr1=date;
        fprintf('   %s %d:%d:%.0f\n', datestr1, a(4), a(5), a(6));
        set(0,'showhiddenhandles','on');
        [StateNumber, StateString] = getsrstate;
        if StateNumber >= 0
            set(findobj(gcbf,'Tag','SRCTRLStaticTextInformation'),'String',StateString,'ForegroundColor','b');
            disp('   **********************************************');
            disp('   **  SR Cycle complete, ready for injection  **');
            disp('   **********************************************'); fprintf('\n');
        else
            set(findobj(gcbf,'Tag','SRCTRLStaticTextInformation'),'String',StateString,'ForegroundColor','r');
            disp('   **********************************');
            disp('   **  Problem cycling SR lattice  **');
            disp('   **********************************'); fprintf('\n');
        end
        set(0,'showhiddenhandles','off');
        

    case 'Injection'
        AD = getad;
        GapFlag = Input2;
        BumpMagnetFlag = Input3;

        fprintf('\n');
        if abs(getenergy - getfamilydata('InjectionEnergy')) > 0.05
            fprintf('   ***************************************************\n');
            fprintf('   **  Setup For %.2f GeV Injection (with ramping)  **\n', getfamilydata('InjectionEnergy'));
            fprintf('   ***************************************************\n');
            set_alarmhandler_AHU_thresholds_inject;
            StartFlag = questdlg(sprintf('Start setup for injection, %.2f GeV?',getfamilydata('InjectionEnergy')),'Injection Setup','Ramp quickly','Ramp slowly','Cancel','Cancel');
        else
            fprintf('   *************************************************\n');
            fprintf('   **  Setup For On Energy Injection at %.2f GeV  **\n', getfamilydata('InjectionEnergy'));
            fprintf('   *************************************************\n');
            StartFlag = questdlg(sprintf('Start setup for injection, %.2f GeV?',getfamilydata('InjectionEnergy')),'Injection Setup','Yes','Cancel','Cancel');
        end
        a = clock; fprintf('   %s %d:%d:%.0f\n',date, a(4), a(5), a(6));
        if strcmp(StartFlag,'Cancel')
            disp(['   ********************************']);
            disp(['   **  Injection Setup Canceled  **']);
            disp(['   ********************************']);
            %set_alarmhandler_thresholds_new;
            fprintf('\n');
            return
        elseif strcmp(StartFlag,'Ramp quickly')
            setfamilydata(0.8, 'BSCRampRate');
        elseif strcmp(StartFlag,'Ramp slowly')
            setfamilydata(0.4, 'BSCRampRate');
        end

        try
            if GapFlag
                setff([],1,0);
                disp('   Gap control disabled');
                disp('   Feed forward enabled');
                pause(1);

                % Set IDs at max velocity w/ velocity profile off
                if any(getsp('IDpos') ~= maxsp('IDpos'))
                    disp('   Opening all gaps');
                    setid([], maxsp('IDpos'), maxsp('IDvel'), 1, 0, 1);
                end

                disp('   Gaps are open');
                disp('   Feed forward and gap control disabled');
                a = clock; fprintf('   %s %d:%d:%.0f\n',date, a(4), a(5), a(6));
            else
                disp('   Feed forward and gap control disabled');
            end

            setff([], 0, 0);
            pause(1);

            % Ramp if necessary
            if abs(getenergy - getfamilydata('InjectionEnergy')) > 0.05
                set(findobj(gcbf,'Tag','SRCTRLStaticTextInformation'),'String','Ramping Down','ForegroundColor','b');
                drawnow;
                ErrorFlag = srramp('Injection');
                if ErrorFlag
                    error('Superbends over temperature.');
                end
                pause(2);
            end

            % Load injection lattice
            srload('Injection');

            setpv('SR_STATE',2);

        catch
            fprintf('   %s \n',lasterr);
            fprintf('   Injection lattice setup failed due to error condition! \n\n');
            setpv('SR_STATE',-2);
        end


        date;
        a = clock;
        datestr1=date;
        fprintf('   %s %d:%d:%.0f\n', datestr1, a(4), a(5), a(6));
        set(0,'showhiddenhandles','on');
        [StateNumber, StateString] = getsrstate;
        if StateNumber >= 0
            set(findobj(gcbf,'Tag','SRCTRLStaticTextInformation'),'String',StateString,'ForegroundColor','b');
            if AD.Energy <= 1.5
                disp(['   *******************************************************************************']);
                disp(['   **  Function complete:  the storage ring is setup for injection at ',sprintf('%.2f',SR_GEV),' GeV  **']);
                disp(['   *******************************************************************************']); 
                fprintf('\n');
            else
                fprintf('   **********************************************************************************************\n');
                fprintf('   **  Function complete:  the storage ring is setup for injection at %.2f GeV (upper branch)  **\n', getfamilydata('InjectionEnergy'));
                fprintf('   **********************************************************************************************\n'); 
                fprintf('\n');
            end
        else
            set(findobj(gcbf,'Tag','SRCTRLStaticTextInformation'),'String',StateString,'ForegroundColor','r');
            disp(['   ************************************']);
            disp(['   **  Problem with injection setup  **']);
            disp(['   ************************************']); 
            fprintf('\n');
        end
        
        set(0,'showhiddenhandles','off');
        %soundchord;

        setfamilydata(0.8, 'BSCRampRate');


    case 'Production'
        GapFlag = Input2;
        BumpMagnetFlag = Input3;
        AD=getad;
        
        fprintf('\n');
        if abs(getenergy - getfamilydata('Energy')) > 0.05
            disp('   ********************************************************');
            disp(sprintf('   **  Setup For %.2f GeV User Operation (with ramping)  **',SR_GEV));
            disp('   ********************************************************');
            StartFlag = questdlg(sprintf('Start setup for users, %.1f GeV?',SR_GEV),'User Setup','Ramp quickly','Ramp slowly','Cancel','Cancel');
        else
            disp('   *****************************************');
            disp(sprintf('   **  Setup For %.2f GeV User Operation  **',SR_GEV));
            disp('   *****************************************');
            StartFlag = questdlg(sprintf('Start setup for users, %.1f GeV?',SR_GEV),'User Setup','Yes','Cancel','Cancel');
        end
        a = clock; fprintf('   %s %d:%d:%.0f\n',date, a(4), a(5), a(6));

        if strcmp(StartFlag,'Cancel')
            disp(['   ***************************']);
            disp(['   **  User Setup Canceled  **']);
            disp(['   ***************************']);
            fprintf('\n');
            return
        elseif strcmp(StartFlag,'Ramp quickly')
            setfamilydata(0.8, 'BSCRampRate');
        elseif strcmp(StartFlag,'Ramp slowly')
            setfamilydata(0.4, 'BSCRampRate');
        end

        try
            if GapFlag
                % Make sure that the gaps are open
                if any(getsp('IDpos') ~= maxsp('IDpos'))
                    % Set IDs at max velocity w/ velocity profile off
                    disp('   Insertion device gaps are not open');
                    disp('   Opening all gaps at maximum speed');
                    setff([], 1, 0);
                    disp('   Gap control disabled');
                    disp('   Feed forward enabled');
                    pause(1);
                    setid([], maxsp('IDpos'), maxsp('IDvel'), 1, 0, 1);
                    disp('   Gaps opened');
                    disp('   Feed forward and gap control disabled');
                    a = clock; fprintf('   %s %d:%d:%.0f\n',date, a(4), a(5), a(6));
                else
                    disp('   Feed forward and gap control disabled');
                end
            else
                disp('   Feed forward and gap control disabled');
            end

            setff([], 0, 0);
            pause(1);

            % Ramp if necessary
            if abs(getenergy - getfamilydata('Energy')) > 0.05
                set(findobj(gcbf,'Tag','SRCTRLStaticTextInformation'),'String','Ramping Up','ForegroundColor','b');
                drawnow;
                ErrorFlag = srramp('Production');
                if ErrorFlag
                    error('Superbends over temperature.');
                end
                pause(2);
            end

            % Load production lattice
            srload('Production');

            
            if GapFlag
                setff([], 1, 0);
                disp('   Gap control disabled');
                disp('   Feed forward enable');
                pause(.5);
                disp('   Insertion device velocity profile boolean control off');
                disp('   Closing all gaps at maximum speed');

                % Set IDs at max velocity w/ velocity profile off
                [Position, Velocity, RunFlag, UserGap] = getid;
                setid([], UserGap, maxsp('IDvel'), 1, 0, 1);

                % Turn velocity profile on
                disp('   Insertion device velocity profile boolean control is on');
                setid([], [], maxsp('IDvel'), 1, 1, 0);

                disp('   Gaps are closed');
                setff([4;7;8;9;10;12], 1, 1);
                setff(5, 1, 0);
                disp('   Gap control enabled (except sector 5 (W16))');
            end

            %set_alarmhandler_thresholds_new;
            setpv('SR_STATE',3);

        catch
            fprintf('   %s \n', lasterr);
            fprintf('   User lattice setup failed due to error condition! \n\n');
            setpv('SR_STATE',-3);
        end

        % Give JH scrapers a chance to move
        % pause(15);
        
        a = clock;
        datestr1 = date;
        fprintf('   %s %d:%d:%.0f\n', datestr1, a(4), a(5), a(6));
        set(0,'showhiddenhandles','on');
        [StateNumber, StateString] = getsrstate;
        if StateNumber >= 0
            set(findobj(gcbf,'Tag','SRCTRLStaticTextInformation'),'String',StateString,'ForegroundColor','b');
            disp(['   **************************************************************************']);
            disp(['   **  Function complete:  the storage ring is setup for users at ',sprintf('%.1f',SR_GEV),' GeV  **']);
            disp(['   **************************************************************************']); 
            fprintf('\n');
        else
            set(findobj(gcbf,'Tag','SRCTRLStaticTextInformation'),'String',StateString,'ForegroundColor','r');
            disp(['   *************************************']);
            disp(['   **  Problem with production setup  **']);
            disp(['   *************************************']); 
            fprintf('\n');
        end
        set(0,'showhiddenhandles','off');

        setfamilydata(0.8, 'BSCRampRate');

        % For BL6.0.x, set lower setpoint limit for IVID to 12.5mm until beamlines are surveyed below that value
        %try
        %    scaput('SR06U___GDS1PS_AC00.DRVL',12.5);
        %    disp('  Setting SR06U___GDS1PS_AC00.DRVL to 12.5mm (lower limit for IVID');
        %catch
        %    fprintf('   %s \n',lasterr);
        %    disp('  Trouble setting lower limit for IVID to 12.5mm!');
        %end

        
    case 'CheckInputs'

        SR_GEV = getfamilydata('Energy');
        AD=getad;
        setsrstatechannels; 

        set(0,'showhiddenhandles','on');

        if AD.Energy > 1.55 & AD.InjectionEnergy < 1.55
            set(findobj('Tag','SRCTRLButton2'),'String',['Setup For Injection (Ramp Down)']);
            set(findobj('Tag','SRCTRLButton3'),'String',['Setup For Users (Ramp Up)']);
        elseif AD.Energy < 1.45
            set(findobj('Tag','SRCTRLButton2'),'String',['Setup For Injection (Ramp Up+cycle)']);
            set(findobj('Tag','SRCTRLButton3'),'String',['Setup For Users, ',num2str(round(10*SR_GEV)/10),' GeV (Ramp Down)']);
        else
            set(findobj('Tag','SRCTRLButton2'),'String',['Setup For Injection']);
            set(findobj('Tag','SRCTRLButton3'),'String',['Setup For Users, ',num2str(round(10*SR_GEV)/10),' GeV']);
        end
        set(findobj('Tag','SRCTRLTitle'),'String',SR_Mode);

        [StateNumber, StateString] = getsrstate;
        if StateNumber >= 0
            set(findobj('Tag','SRCTRLStaticTextInformation'),'String',StateString,'ForegroundColor','b');
        else
            set(findobj('Tag','SRCTRLStaticTextInformation'),'String',StateString,'ForegroundColor','r');
        end

        set(0,'showhiddenhandles','off');


    case 'SRState'
        NumErrors = 0;
        fprintf('\n');
        disp('   ***********************************');
        disp('   **  Checking Storage Ring State  **');
        disp('   ***********************************');
        a = clock;
        fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));

        %       FileName = getpv('SR_LATTICE_FILE','String');   % Last srload file name (in OLD MIDDLE LAYER nomenclature!!)

        GeVnow = bend2gev;
        if GeVnow == getfamilydata('Energy')
            [ConfigSetpoint, ConfigMonitor, FileName] = getproductionlattice;
        elseif GeVnow == getfamilydata('InjectionEnergy')
            [ConfigSetpoint, ConfigMonitor, FileName] = getinjectionlattice;
        else
            FileName = '';
        end

        [StateNumber, StateString] = getsrstate;
        fprintf('   Storage ring operational mode: %s\n', SR_Mode);
        if StateNumber < 0
            fprintf('   Storage ring state error: %s\n', StateString);
            NumErrors = NumErrors + 1;
        else
            fprintf('   Storage ring state: %s\n', StateString);
        end
        if StateNumber==0
            % Storage ring state unknown
            NumErrors = NumErrors + 1;
        elseif abs(StateNumber)==1 || abs(StateNumber)==2
            FileNameGoal = [getfamilydata('Directory','OpsData') getfamilydata('OpsData','InjectionFile') '.mat'];
            if ~strcmp(FileName, FileNameGoal)
                fprintf('   Lattice file %s should be loaded but it appears that %s is loaded.\n', getfamilydata('OpsData','InjectionFile'), FileName);
                NumErrors = NumErrors + 1;
            end
        else
            FileNameGoal = [getfamilydata('Directory','OpsData') getfamilydata('OpsData','LatticeFile') '.mat'];
            if ~strcmp(FileName, FileNameGoal)
                fprintf('   Lattice file %s should be loaded but it appears that %s is loaded.\n', getfamilydata('OpsData','LatticeFile'), FileName);
                NumErrors = NumErrors + 1;
            end
        end


        % Check all SR magnets
        if isempty(FileName)
            fprintf('   Goal setpoints will not be checked since the last lattice load is unknown.\n');
            NumErrors1 = checksrmags('');
        else
            %NumErrors1 = checksrmags([getfamilydata('Directory','OpsData') FileName]);
            NumErrors1 = checksrmags(FileName);
        end
        if NumErrors1 == 0
            fprintf('   SR magnets power supplies are OK.\n');
        end
        NumErrors = NumErrors + NumErrors1;


        % Check RF frequency
        if isempty(FileName)
            fprintf('   RF frequency will not be checked since the last lattice load is unknown.\n');
        else
            %load([getfamilydata('Directory','OpsData'), FileName]);
            load(FileName);
            [tmp, RFHPCounterPresent] = getrf;
            if abs(RFHPCounterPresent-ConfigSetpoint.RF.Setpoint.Data) > .002
                NumErrors = NumErrors + 1;
                fprintf('   RF frequency should be %f, presently it is %f MHz (as measured by the HP counter).\n', ConfigSetpoint.RF.Setpoint.Data, RFHPCounterPresent);
            else
                fprintf('   RF frequency is OK (HP counter is %f MHz, at the time of the lattice save it was %f MHz).\n', RFHPCounterPresent, ConfigSetpoint.RF.Setpoint.Data);
            end
        end


        % Check for orbit problems
        if (StateNumber >= 3) && (getdcct > 2)   % Production lattice is loaded with beam in the machine
            Xtol = 0.070;
            Ytol = 0.010;
            NumErrors1 = checksrorbit([],Xtol,Ytol);
            if NumErrors1
                fprintf('   SR orbit in the ID straight sections or at Bergoz BPMs deviates more than allowed from the golden orbit.\n');
            else
                fprintf('   SR orbit in the ID straight sections and at Bergoz BPMs is OK.\n');
                fprintf('   The orbit is within %.3f mm horizontally and %.3f mm vertically', Xtol, Ytol);
            end
            NumErrors = NumErrors + NumErrors1;
        else
            fprintf('   Storage ring orbit was not checked.\n');
        end


        a = clock;
        datestr1=date;
        fprintf('   %s %d:%d:%.0f\n', datestr1, a(4), a(5), a(6));
        if NumErrors
            disp('   *********************************');
            disp('   **  Storage Ring Has Problems  **');
            disp('   *********************************');
        else
            disp('   **********************************');
            disp('   **  Storage Ring Lattice is OK  **');
            disp('   **********************************');
        end
        fprintf('   \n');

        set(0,'showhiddenhandles','on');
        [StateNumber, StateString] = getsrstate;
        if StateNumber >= 0
            set(findobj(gcbf,'Tag','SRCTRLStaticTextInformation'),'String',StateString,'ForegroundColor','b');
        else
            set(findobj(gcbf,'Tag','SRCTRLStaticTextInformation'),'String',StateString,'ForegroundColor','r');
        end
        set(0,'showhiddenhandles','off');


    case 'OrbitCorrection'
        fprintf('\n');
        fprintf('   *********************************\n');
        fprintf('   **  Starting Orbit Correction  **\n');
        fprintf('   *********************************\n');
        a = clock;
        fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));

        StartFlag = questdlg(sprintf('Start orbit correction, %.1f GeV?',SR_GEV),'Orbit Correction','Yes','No','No');
        if strcmp(StartFlag,'No')
            disp(['   ********************************']);
            disp(['   **  Orbit Correction Aborted  **']);
            disp(['   ********************************']);
            fprintf('\n');
            return
        end

        if getdcct < 2     % Don't correct the orbit if the current is too small
            fprintf('   Orbit not corrected due to small current.\n');
            return
        end

%         if abs(SR_GEV-bend2gev(getpv('BEND','Setpoint',[1 1])))>  0.05     % Don't use this routine for the injection lattice
%             fprintf('   This routine should only be used for the production energy: Correction aborted\n');
%             return
%         end

        SR_STATE_OLD = scaget('SR_STATE');
        set(0,'showhiddenhandles','on');
        setpv('SR_STATE',4);
        [StateNumber, StateString] = getsrstate;
        if StateNumber >= 0
            set(findobj(gcbf,'Tag','SRCTRLStaticTextInformation'),'String',StateString,'ForegroundColor','b');
        else
            set(findobj(gcbf,'Tag','SRCTRLStaticTextInformation'),'String',StateString,'ForegroundColor','r');
        end
        set(0,'showhiddenhandles','off');


        try
            % save current BPM timeconstant - will reset to this after correction
            BPMtimeconstantOC = getbpmtimeconstant;
            fprintf('   Current Bergoz BPM time constant is %.1fs\n', BPMtimeconstantOC);

            % 2 Hz update rate on IDBPMs
            disp('   Bergoz BPM time constant set to 0.5s.')
            setbpmtimeconstant(0.5)
            pause(2);


            % Turn off feed forward
            fprintf('   Turning feed forward off.\n');
            [FFEnableBM, FFEnableBC] = getff;
            setff([], 0);
            scasleep(.2);


            % Check whether bumps and kickers are on, pulsing, and at high enough currents to disturb the beam.
            % If so, warn to turn off and re-correct orbit.
            try
                if (getpv('SR01S___BUMP1__BC21')==1 && getpv('SR01S___BUMP1P_BC22')==1 && getpv('SR01S___BUMP1__AM00')>2500) ||...
                   (getpv('SR01S___SEK____BC21')==1 && getpv('SR01S___SEK_P__BC23')==1 && getpv('SR01S___SEK____AM02')>600) ||...
                   (getpv('SR01S___SEN____BC20')==1 && getpv('SR01S___SEN_P__BC22')==1 && getpv('SR01S___SEN____AM00')>800);
                    soundtada;
                    fprintf('   \n');
                    fprintf('   *****************************************************************\n');
                    fprintf('   ** One or more of the pulsed SR injection magnets is still on! **\n');
                    fprintf('   **      Please turn them off then re-correct the orbit...      **\n');
                    fprintf('   *****************************************************************\n');
                    fprintf('   \n');
                end
            catch
                disp('**Problem checking the state of the bumps and kickers - please check that they are not pulsing.');
            end


            % Get vectors
            FB = get(findobj(gcbf,'Tag','SRCTRLButtonOrbitCorrectionSetup'),'Userdata');
            LocalBumplist = FB.LocalBumplist;

        catch

            fprintf('   %s \n',lasterr);
            fprintf('   Orbit correction setup failed due to error condition! \n\n');
            setpv('SR_STATE',-4);
            set(0,'showhiddenhandles','on');
            [StateNumber, StateString] = getsrstate;
            if StateNumber >= 0
                set(findobj(gcbf,'Tag','SRCTRLStaticTextInformation'),'String',StateString,'ForegroundColor','b');
            else
                set(findobj(gcbf,'Tag','SRCTRLStaticTextInformation'),'String',StateString,'ForegroundColor','r');
            end
            set(0,'showhiddenhandles','off');

            % Reset BPM timeconstant to whatever it was before correction
            setbpmtimeconstant(BPMtimeconstantOC);
            fprintf('   Bergoz BPM time constant set back to %.1fs\n', BPMtimeconstantOC);
            return
        end

        iNotHCMChicane = find(FB.HCMlist1(:,2) < 10); %used by steppv's for setting correctors in loop
        iHCMChicane = find(FB.HCMlist1(:,2) == 10);
        iNotVCMChicane = find(FB.VCMlist1(:,2) < 10);
        iVCMChicane = find(FB.VCMlist1(:,2) == 10);

        fprintf('   Starting horizontal and vertical global orbit correction (SVD method).\n');

        for iloop = 1:3
            try
                % use the following to get corrector settings in OCS without setting them, so the values can be checked
                FB.OCSx = setorbit(FB.OCSx,'Nodisplay','Nosetsp');
                FB.OCSy = setorbit(FB.OCSy,'Nodisplay','Nosetsp');
                if any(abs(FB.OCSx.CM.Delta(iNotHCMChicane)) > 5)
                  disp('   Orbit Correction is changing some horizontal corrector(s) > 5A!!');
                end
                if any(abs(FB.OCSy.CM.Delta(iNotVCMChicane)) > 5)
                  disp('   Orbit Correction is changing some vertical corrector(s) > 5A!!');
                end
                if any(abs(FB.OCSx.CM.Delta(iHCMChicane)) > 10)
                  disp('   Orbit Correction is changing some horizontal chicane corrector(s) > 10A!!');
                end
                if any(abs(FB.OCSy.CM.Delta(iVCMChicane)) > 10)
                    disp('   Orbit Correction is changing some vertical chicane corrector(s) > 10A!!');
                end

                % Correct RF
                rf0=getrf;
                nRFsteps = 4*ceil(abs(FB.OCSx.DeltaRF/10e-6)); %added factor 4 to slow down change for laser-lock at BL11.0.1 - 3-14-08, T.Scarvie
                if nRFsteps > 100
                    nRFsteps = 100;
                end
                for loop = 1:nRFsteps
                    steprf(FB.OCSx.DeltaRF/nRFsteps,0);
                end
                fprintf('   %d. nRFsteps = %d, RF change = %.1f Hz\n',iloop, nRFsteps, FB.OCSx.DeltaRF*1e6);
%               fprintf('   %d. RF change = %.1f Hz, nRFsteps = %d, DelRF = %.1f Hz\n',iloop, (getrf-rf0)*1e6, nRFsteps, FB.OCSx.DeltaRF*1e6);

                % Correct horizontal and vertical orbits
                % calculate corrections
                FB.OCSx.CM.Data = FB.OCSx.CM.Data + FB.OCSx.CM.Delta;
                FB.OCSy.CM.Data = FB.OCSy.CM.Data + FB.OCSy.CM.Delta;
                % start vertical correctors moving
                setpv(FB.OCSy.CM,0);
                % Correct horizontal
                setpv(FB.OCSx.CM,-1);
                % Correct vertical
                setpv(FB.OCSy.CM,-2);

                % Check for current in machine - stop orbit correction if DCCT < 5mA
                if (getdcct < 2)
                    error('**There is less than 5mA in the machine! Stopping orbit correction.');
                end

                % Check state of gaps - stop orbit correction if any are moving
                GAPrunflag = getpv('ID','RunFlag');
                if any(GAPrunflag-round(GAPrunflag))
                    error('**One or more of the gaps are moving! Stopping orbit correction.');
                end

                x = FB.OCSx.GoalOrbit - getx(FB.OCSx.BPM.DeviceList);
                y = FB.OCSy.GoalOrbit - gety(FB.OCSy.BPM.DeviceList);
                fprintf('   %d. Horizontal RMS = %.3f mm\n', iloop, norm(x)/sqrt(length(x)));
                fprintf('   %d.   Vertical RMS = %.3f mm\n', iloop, norm(y)/sqrt(length(y)));

            catch
                fprintf('   %s \n',lasterr);
                fprintf('   Orbit correction failed due to error condition!\n  Fix the problem, reload the lattice (srload), and try again.  \n\n');
                setpv('SR_STATE',-4);
                set(0,'showhiddenhandles','on');
                [StateNumber, StateString] = getsrstate;
                if StateNumber >= 0
                    set(findobj(gcbf,'Tag','SRCTRLStaticTextInformation'),'String',StateString,'ForegroundColor','b');
                else
                    set(findobj(gcbf,'Tag','SRCTRLStaticTextInformation'),'String',StateString,'ForegroundColor','r');
                end
                set(0,'showhiddenhandles','off');

                % Reset BPM timeconstant to whatever it was before correction
                setbpmtimeconstant(BPMtimeconstantOC);
                fprintf('   Bergoz BPM time constant set back to %.1fs\n', BPMtimeconstantOC);
                return
            end
        end


        % Set user bumps w/o sextupole correctors
        try
            %turn up corrector speed here to quicken setting bumps
            HCMramprate = getpv('HCM', 'RampRate');
            VCMramprate = getpv('VCM', 'RampRate');
            setpv('HCM', 'RampRate', 10, [], 0);
            setpv('VCM', 'RampRate', 10, [], 0);
            
            if ~isempty(LocalBumplist)
                fprintf('   Setting local bumps in the straight sections.\n');
                for loop = 1:size(LocalBumplist,1)

                    % Check for current in machine - stop orbit correction if DCCT < 5mA
                    if (getdcct < 2)
                        error('** There is less than 5mA in the machine! Stopping local bumps.');
                    end

                    % Check state of gaps - stop setting bumps if any are moving
                    GAPrunflag = getpv('ID','RunFlag');
                    if any(GAPrunflag-round(GAPrunflag))
                        error('** One or more of the gaps are moving! Stopping local bumps.');
                    end

                    HCMoldsp = getsp('HCM', FB.HCMlist1);
                    VCMoldsp = getsp('VCM', FB.VCMlist1);

                    if any(LocalBumplist(loop,1) == [4 6 11])
                        if LocalBumplist(loop,2) == 0
                            % Upstream bump
                            [i,iRemove] = findrowindex([LocalBumplist(loop,1)-1 10;LocalBumplist(loop,1)-1 11;LocalBumplist(loop,1)-1 12;LocalBumplist(loop,1) 1],FB.OCSx.BPM.DeviceList);
                            if isempty(iRemove)
                                setbumps(LocalBumplist(loop,:), 1);
                            else
                                fprintf('\n   BPMs missing from Sector(%02d,%02d) - skipping local bump for that sector.\n\n', LocalBumplist(loop,:));
                            end
                        elseif LocalBumplist(loop,2) == 1
                            % Upstream bump
                            [i,iRemove] = findrowindex([LocalBumplist(loop,1)-1 10;LocalBumplist(loop,1)-1 11;],FB.OCSx.BPM.DeviceList);
                            if isempty(iRemove)
                                setbumps(LocalBumplist(loop,:), 1);
                            else
                                fprintf('\n   BPMs missing from Sector(%02d,%02d) - skipping local bump for that sector.\n\n', LocalBumplist(loop,:));
                            end
                        else
                            % Downstream bump
                            [i, iRemove] = findrowindex([LocalBumplist(loop,1)-1 12;LocalBumplist(loop,1) 1],FB.OCSx.BPM.DeviceList);
                            if isempty(iRemove)
                                setbumps(LocalBumplist(loop,:), 1);
                            else
                                fprintf('\n   BPMs missing from Sector(%02d,%02d) - skipping local bump for that sector.\n\n', LocalBumplist(loop,:));
                            end
                        end
                    else
                        [i,iRemove] = findrowindex([LocalBumplist(loop,1)-1 10;LocalBumplist(loop,1) 1],FB.OCSx.BPM.DeviceList);
                        if isempty(iRemove)
                            setbumps(LocalBumplist(loop,:), 1);
                        else
                            fprintf('\n   BPMs missing from Sector %02d - skipping local bump for that sector.\n\n', LocalBumplist(loop,1));
                        end
                    end
                    
                    HCMnewsp = getsp('HCM', FB.HCMlist1);
                    VCMnewsp = getsp('VCM', FB.VCMlist1);
                    % Remove center chicane trim from corrector check
                    if (max(abs(HCMoldsp(iNotHCMChicane)-HCMnewsp(iNotHCMChicane))) > 5) || (max(abs(VCMoldsp(iNotVCMChicane)-VCMnewsp(iNotVCMChicane))) > 10)
                        error('**Setbumps caused some corrector magnet currents to change by more than 5(Horiz)/10(Vert) A!');
                    end
                    % Now check center chicane trims
                    if (max(abs(HCMoldsp(iNotHCMChicane)-HCMnewsp(iNotHCMChicane))) > 10) || (max(abs(VCMoldsp(iNotVCMChicane)-VCMnewsp(iNotVCMChicane))) > 15)
                        error('**Setbumps caused some chicane trim magnet currents to change by more than 10(Horiz)/15(Vert) A!');
                    end
                end
            end

            %restore corrector speeds
            setpv('HCM', 'RampRate', HCMramprate, [], 0);
            setpv('VCM', 'RampRate', VCMramprate, [], 0);

        catch
            fprintf('   %s \n',lasterr);
            fprintf('   Setbumps failed due to error condition!  Fix the problem, reload the lattice (srload), and try again.\n\n');
            setpv('SR_STATE',-4);
            set(0,'showhiddenhandles','on');
            [StateNumber, StateString] = getsrstate;
            if StateNumber >= 0
                set(findobj(gcbf,'Tag','SRCTRLStaticTextInformation'),'String',StateString,'ForegroundColor','b');
            else
                set(findobj(gcbf,'Tag','SRCTRLStaticTextInformation'),'String',StateString,'ForegroundColor','r');
            end
            set(0,'showhiddenhandles','off');

            % Reset BPM timeconstant to whatever it was before correction
            setbpmtimeconstant(BPMtimeconstantOC);
            fprintf('   Bergoz BPM time constant set back to %.1fs\n', BPMtimeconstantOC);
            return
        end

        % Reset BPM timeconstant to whatever it was before correction
        setbpmtimeconstant(BPMtimeconstantOC);
        fprintf('   Bergoz BPM time constant set back to %.1fs\n', BPMtimeconstantOC);

        % Turn feed forward back to it's original state
        if any(FFEnableBC)
            fprintf('   Turning feed forward back on.\n');
            setff([], FFEnableBC);
        end


        a = clock;
        fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
        [StateNumber, StateString] = getsrstate;
        set(0,'showhiddenhandles','on');
        if StateNumber >= 0
            setpv('SR_STATE',4.1);
            [StateNumber, StateString] = getsrstate;
            set(findobj(gcbf,'Tag','SRCTRLStaticTextInformation'),'String',StateString,'ForegroundColor','b');
            fprintf('   *********************************\n');
            fprintf('   **  Orbit Correction Complete  **\n');
            fprintf('   *********************************\n\n');
        else
            set(findobj(gcbf,'Tag','SRCTRLStaticTextInformation'),'String',StateString,'ForegroundColor','r');
            fprintf('   *************************************\n');
            fprintf('   **  Problem With Orbit Correction  **\n');
            fprintf('   *************************************\n\n');
        end
        set(0,'showhiddenhandles','off');
        pause(0);


    case 'OrbitCorrectionSetup'
        InitFlag = Input2;           % Input #2: if InitFlag, then initialize variables

        if InitFlag
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % This setup is now done in ocsinit.m %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Setup feedback elements
            % disp('Orbit correction condition: InitFlag=1 -- debugging message');

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Edit the following lists to change default configuration of Orbit Correction %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             hlist=[];vlist=[];
%             for Sector =1:12
%                 if Sector == 1
%                     vlist = [vlist;Sector 2;Sector 4;Sector 5;Sector 8];
%                     hlist = [hlist;Sector 2;Sector 7];
%                 elseif Sector == 3
%                     vlist = [vlist;Sector 1;Sector 4;Sector 5;Sector 8;Sector 10];
%                     hlist = [hlist;Sector 2;Sector 7;Sector 10];
%                 elseif Sector == 5
%                     vlist = [vlist;Sector 1;Sector 4;Sector 5;Sector 8;Sector 10];
%                     hlist = [hlist;Sector 2;Sector 7;Sector 10];
% %                     vlist = [vlist;Sector 1;Sector 4;Sector 5;Sector 8]; %remove HCM and VCM(5,10) since corrector is not controlling starting 4-6-07
% %                     hlist = [hlist;Sector 2;Sector 7];
%                 elseif Sector == 10
%                     vlist = [vlist;Sector 1;Sector 4;Sector 5;Sector 8;Sector 10];
%                     hlist = [hlist;Sector 2;Sector 7;Sector 10];
%                 elseif Sector == 12
%                     vlist = [vlist;Sector 1;Sector 4;Sector 5;Sector 7];
%                     hlist = [hlist;Sector 2;Sector 7];
%                 else
%                     vlist = [vlist;Sector 1;Sector 4;Sector 5;Sector 8];
%                     hlist = [hlist;Sector 2;Sector 7];
%                 end
%             end
%             HCMlist1 = hlist;
%             VCMlist1 = vlist;
% 
%             BPMlist1 = [
%                 1 2
%                 1 5
%                 1 6
%                 1 10
%                 2 1
%                 2 5
%                 2 6
%                 2 9
%                 3 2
%                 3 5
%                 3 6
%                 3 10
%                 3 11
%                 3 12
%                 4 1
%                 4 5
%                 4 6
%                 4 10
%                 5 1
%                 5 5
%                 5 6
%                 5 10
%                 5 11
%                 5 12
%                 6 1
%                 6 5
%                 6 6
%                 6 10
%                 7 1
%                 7 5
%                 7 6
%                 7 10
%                 8 1
%                 8 5
%                 8 6
%                 8 10
%                 9 1
%                 9 5
%                 9 6
%                 9 10
%                 10 1
%                 10 5
%                 10 6
%                 10 10
%                 10 11
%                 10 12
%                 11 1
%                 11 5
%                 11 6
%                 11 10
%                 12 1
%                 12 5
%                 12 6
%                 12 9];
% 
%             % SVD orbit correction
%             Xivec = [1:28];
%             Yivec = [1:51];
% 
%             
%             % Look for bad status BPMs
%             iStatus = family2status('BPMx', BPMlist1);
%             iBad = find(~iStatus);
%             BPMlist1 = BPMlist1(find(iStatus),:);
%             if length(iBad)
%                 fprintf('   Global Orbit Correction: %d BPMs removed for bad status\n', length(iBad));
%                 Yivec = Yivec(1:end-length(iBad));
%             end
%             
%             iStatus = family2status('HCM', HCMlist1);
%             iBad = find(~iStatus);
%             HCMlist1 = HCMlist1(find(iStatus),:);
%             if length(iBad)
%                 fprintf('   Global Orbit Correction: %d HCMs removed for bad status\n', length(iBad));
%             end
%            
%             iStatus = family2status('VCM', VCMlist1);
%             iBad = find(~iStatus);
%             VCMlist1 = VCMlist1(find(iStatus),:);
%             if length(iBad)
%                 fprintf('   Global Orbit Correction: %d VCMs removed for bad status\n', length(iBad));
%             end

            % Initialize RFCorrFlag
            RFCorrFlag = 'Yes';

            % Get the device lists from oscsinit and convert to srcontrol variables
            [HBPM, VBPM, HCM, VCM, HSV, VSV] = ocsinit('TopOfFill');
            if strcmpi(RFCorrFlag, 'Yes')
                Xivec = 1:HSV+1;
            else
                Xivec = 1:HSV;
            end
            Yivec = 1:VSV;
            BPMlist1 = HBPM.DeviceList;
            HCMlist1 = HCM.DeviceList;
            VCMlist1 = VCM.DeviceList;
            
            
            LocalBumplist = [
              % 1 1
              % 2 1
              % 3 1
                4 1
              % 4 2
                5 1
              % 6 1
              % 6 2
                7 1
                8 1
                9 1
                10 1
                11 1
                11 2
                12 1
                ];
            %LocalBumplist = []
            

        else

            % Get vectors
            FB = get(findobj(gcbf,'Tag','SRCTRLButtonOrbitCorrectionSetup'),'Userdata');
            BPMlist1 = FB.BPMlist1;
            HCMlist1 = FB.HCMlist1;
            VCMlist1 = FB.VCMlist1;
            Xivec = FB.Xivec;
            Yivec = FB.Yivec;
            LocalBumplist = FB.LocalBumplist;
            Xgoal = FB.Xgoal;
            Ygoal = FB.Ygoal;
            RFCorrFlag = FB.RFCorrFlag;

            % Add button to change #ivectors, CMs, IDBPMs,
            EditFlag = 0;
            h_fig1 = figure;
            while EditFlag ~= 8

                % Sensitivity matrix
                Sx = getrespmat('BPMx', BPMlist1, 'HCM', HCMlist1, [], SR_GEV);
                Sy = getrespmat('BPMy', BPMlist1, 'VCM', VCMlist1, [], SR_GEV);
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Can the call below work for setting FOFB RF parameter? %
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                if strcmpi(RFCorrFlag, 'Yes')
                    Sx = [Sx getdisp('BPMx',BPMlist1)];
                end
                
                Sx(isnan(Sx)) = 0;
                Sy(isnan(Sy)) = 0;
                               
                [Ux, SVx, Vx] = svd(Sx);
                [Uy, SVy, Vy] = svd(Sy);


                % Remove singular values greater than the actual number of singular values
                i = find(Xivec>length(diag(SVx)));
                if ~isempty(i)
                    disp('   Horizontal E-vector scaled since there were more elements in the vector than singular values.');
                    pause(0);
                    Xivec(i) = [];
                end
                i = find(Yivec>length(diag(SVy)));
                if ~isempty(i)
                    disp('   Vertical E-vector scaled since there were more elements in the vector than singular values.');
                    pause(0);
                    Yivec(i) = [];
                end


                Ax = Sx*Vx(:,Xivec);
                Tx = inv(Ax'*Ax)*Ax';

                Ay = Sy*Vy(:,Yivec);
                Ty = inv(Ay'*Ay)*Ay';


                figure(h_fig1);
                subplot(2,1,1);
                semilogy(diag(SVx),'b');
                hold on;
                semilogy(diag(SVx(Xivec,Xivec)),'xr');
                ylabel('Horizontal');
                title('Response Matrix Singular Values');
                hold off;
                subplot(2,1,2);
                semilogy(diag(SVy),'b');
                hold on;
                semilogy(diag(SVy(Yivec,Yivec)),'xr');
                xlabel('Singular Value Number');
                ylabel('Vertical');
                hold off;
                drawnow;

                if strcmp(RFCorrFlag,'No')
                    RFCorrState = 'NOT CORRECTED';
                elseif strcmp(RFCorrFlag,'Yes')
                    RFCorrState = 'CORRECTED';
                else
                    RFCorrState = '???';
                end

                %         EditFlag = menu('Change Parameters?','Singular Values','HCM List','VCM List','HCM Chicane List','VCM Chicane List','IDBPM List','BBPM List','Change Golden Orbit',...
                %            'Local Bump List',sprintf('RF Frequency (currently %s)',RFCorrState),'Continue');
                EditFlag = menu('Change Parameters?','Singular Values','HCM List','VCM List','BPM List','Change Golden Orbit',...
                    'Local Bump List',sprintf('RF Frequency (currently %s)',RFCorrState),'Continue');

                if EditFlag == 1
                    prompt={'Enter the horizontal E-vector numbers (Matlab vector format):','Enter the vertical E-vector numbers (Matlab vector format):'};
                    def={sprintf('[%d:%d]',1,Xivec(end)),sprintf('[%d:%d]',1,Yivec(end))};
                    titlestr='SVD Orbit Feedback';
                    lineNo=1;
                    answer=inputdlg(prompt,titlestr,lineNo,def);
                    if ~isempty(answer)
                        XivecNew = fix(str2num(answer{1}));
                        if isempty(XivecNew)
                            disp('   Horizontal E-vector cannot be empty.  No change made.');
                        else
                            if any(XivecNew<=0) || max(XivecNew)>length(diag(SVx))
                                disp('   Error reading horizontal E-vector.  No change made.');
                            else
                                Xivec = XivecNew;
                            end
                        end
                        YivecNew = fix(str2num(answer{2}));
                        if isempty(YivecNew)
                            disp('   Vertical E-vector cannot be empty.  No change made.');
                        else
                            if any(YivecNew<=0) || max(YivecNew)>length(diag(SVy))
                                disp('   Error reading vertical E-vector.  No change made.');
                            else
                                Yivec = YivecNew;
                            end
                        end
                    end
                end

                if EditFlag == 2
                    List = getlist('HCM');
                    CheckList = zeros(size(List,1));
                    Elem = dev2elem('HCM', HCMlist1);
                    CheckList(Elem) = ones(size(Elem));
                    CheckList = CheckList(dev2elem('HCM',List));
                    newList = editlist(List, 'HCM', CheckList);
                    if isempty(newList)
                        fprintf('   Horizontal corrector magnet list cannot be empty.  No change made.\n');
                    else
                        HCMlist1 = newList;
                    end
                end

                if EditFlag == 3
                    List = getlist('VCM');
                    CheckList = zeros(size(List,1));
                    Elem = dev2elem('VCM', VCMlist1);
                    CheckList(Elem) = ones(size(Elem));
                    CheckList = CheckList(dev2elem('VCM',List));
                    newList = editlist(List, 'VCM', CheckList);
                    if isempty(newList)
                        fprintf('   Vertical corrector magnet cannot be empty.  No change made.\n');
                    else
                        VCMlist1 = newList;
                    end
                end

                if EditFlag == 4
                    ListOld = BPMlist1;
                    XgoalOld = Xgoal;
                    YgoalOld = Ygoal;

                    % Full BPM list
                    List = getbpmlist('Bergoz');
%                     List = [
%                         1 2
%                         1 5
%                         1 6
%                         1 10
%                         2 1
%                         2 5
%                         2 6
%                         2 9
%                         3 2
%                         3 5
%                         3 6
%                         3 10
%                         3 11
%                         3 12
%                         4 1
%                         4 5
%                         4 6
%                         4 10
%                         5 1
%                         5 5
%                         5 6
%                         5 10
%                         5 11
%                         5 12
%                         6 1
%                         6 5
%                         6 6
%                         6 10
%                         7 1
%                         7 5
%                         7 6
%                         7 10
%                         8 1
%                         8 5
%                         8 6
%                         8 10
%                         9 1
%                         9 5
%                         9 6
%                         9 10
%                         10 1
%                         10 5
%                         10 6
%                         10 10
%                         10 11
%                         10 12
%                         11 1
%                         11 5
%                         11 6
%                         11 10
%                         12 1
%                         12 5
%                         12 6
%                         12 9
%                         ];

                    CheckList = zeros(size(List,1),1);
                    if ~isempty(BPMlist1)
                        for i = 1:size(List,1)
                            k = find(List(i,1)==BPMlist1(:,1));
                            l = find(List(i,2)==BPMlist1(k,2));

                            if isempty(k) || isempty(l)
                                % Item not in list
                            else
                                CheckList(i) = 1;
                            end
                        end
                    end

                    newList = editlist(List, 'BPM', CheckList);
                    if isempty(newList)
                        fprintf('   BPM list cannot be empty.  No change made.\n');
                    else
                        BPMlist1 = newList;
                    end

                    % Set the goal orbit to the golden orbit
                    Xgoal = getgolden('BPMx', BPMlist1);
                    Ygoal = getgolden('BPMy', BPMlist1);


                    % If a new BPM is added, then set the goal orbit to the golden orbit
                    for i = 1:size(BPMlist1,1)

                        % Is it a new BPM?
                        k = find(BPMlist1(i,1)==ListOld(:,1));
                        l = find(BPMlist1(i,2)==ListOld(k,2));

                        if isempty(k) || isempty(l)
                            % New BPM
                        else
                            % Use the old value for old BPM
                            Xgoal(i) = XgoalOld(k(l));
                            Ygoal(i) = YgoalOld(k(l));
                        end
                    end
                end

                if EditFlag == 5

                    ChangeList = editlist(BPMlist1, 'Change BPM', zeros(size(BPMlist1,1),1));
                    for i = 1:size(ChangeList,1)

                        k = find(ChangeList(i,1)==BPMlist1(:,1));
                        l = find(ChangeList(i,2)==BPMlist1(k,2));

                        prompt = {sprintf('Enter the new horizontal goal orbit for BPMx(%d,%d):',BPMlist1(k(l),1),BPMlist1(k(l),2)),sprintf('Enter the new vertical goal orbit for BPMy(%d,%d):',BPMlist1(k(l),1),BPMlist1(k(l),2))};
                        def = {sprintf('%f',Xgoal(k(l))),sprintf('%f',Ygoal(k(l)))};
                        titlestr = 'CHANGE THE GOAL ORBIT';
                        lineNo = 1;
                        answer = inputdlg(prompt, titlestr, lineNo, def);

                        if isempty(answer)
                            % No change
                            fprintf('   No change was made to the golden orbit.\n');
                        else
                            Xgoalnew = str2num(answer{1});
                            if isempty(Xgoalnew)
                                fprintf('   No change was made to the horizontal golden orbit.\n');
                            else
                                Xgoal(k(l)) = Xgoalnew;
                            end

                            Ygoalnew = str2num(answer{2});
                            if isempty(Ygoalnew)
                                fprintf('   No change was made to the vertical golden orbit.\n');
                            else
                                Ygoal(k(l)) = Ygoalnew;
                            end
                        end
                    end
                    if ~isempty(ChangeList)
                        fprintf('   Note:  changing the goal orbit for "Orbit Correction" does not change the goal orbit for "Slow Orbit Feedback."\n');
                        fprintf('          Re-running srcontrol will restart the goal orbit to the golden orbit."\n');
                    end
                end

                if EditFlag == 6
                    List = [
                        1 1
                        2 1
                        3 1
                        4 1
                        4 2
                        5 1
                        6 1
                        6 2
                        7 1
                        8 1
                        9 1
                        10 1
                        11 1
                        11 2
                        12 1];
                    CheckList = zeros(size(List,1),1);
                    if ~isempty(LocalBumplist)
                        for i = 1:size(List,1)
                            k = find(List(i,1)==LocalBumplist(:,1));
                            l = find(List(i,2)==LocalBumplist(k,2));

                            if isempty(k) || isempty(l)
                                % Item not in list
                            else
                                CheckList(i) = 1;
                            end
                        end
                    end
                    LocalBumplist = editlist2(List, 'Sector', CheckList);
                end

                if EditFlag == 7
                    RFCorrFlag = questdlg(sprintf('Set RF Frequency during Orbit Correction?'),'RF Frequency','Yes','No', 'No');
                    if strcmp(RFCorrFlag,'No')
                        disp(['   RF Frequency will not be included in global orbit correction.']);
                    elseif strcmp(RFCorrFlag,'Yes')
                        disp(['   RF Frequency will be included in global orbit correction.']);
                    end

                end
            end
            close(h_fig1);
        end

        %  ORBIT CORRECTION STRUCTURE (OCS)
        %    OCS.BPM (data structure)
        %    OCS.CM  (data structure)
        %    OCS.GoalOrbit
        %    OCS.NIter
        %    OCS.SVDIndex
        %    OCS.IncrementalFlag = 'Yes'/'No'
        %    OCS.BPMWeight
        %    OCS.Flags = { 'FitRF' , etc. }
        OCSx.BPM = getx(BPMlist1, 'struct');
        OCSx.CM = getsp('HCM', HCMlist1, 'struct');
        OCSx.GoalOrbit = getgolden(OCSx.BPM, 'numeric');
        OCSx.NIter = 1;
        OCSx.SVDIndex = Xivec;
        OCSx.IncrementalFlag = 'No';
        OCSx.FitRF = 1;
        OCSy.BPM = gety(BPMlist1, 'struct');
        OCSy.CM = getsp('VCM', VCMlist1, 'struct');
        OCSy.GoalOrbit = getgolden(OCSy.BPM, 'numeric');
        OCSy.NIter = 1;
        OCSy.SVDIndex = Yivec;
        OCSy.IncrementalFlag = 'No';
        OCSy.FitRF = 0;

        % Save vectors
        FB.OCSx = OCSx;
        FB.OCSy = OCSy;

        FB.BPMlist1 = BPMlist1;
        FB.HCMlist1 = HCMlist1;
        FB.VCMlist1 = VCMlist1;
        FB.Xivec = Xivec;
        FB.Yivec = Yivec;
        FB.Xgoal = OCSx.GoalOrbit;
        FB.Ygoal = OCSy.GoalOrbit;
        FB.RFCorrFlag = RFCorrFlag;
        FB.LocalBumplist = LocalBumplist;
        set(findobj(gcbf,'Tag','SRCTRLButtonOrbitCorrectionSetup'),'Userdata',FB);
        
        
    case 'Feedback'

        FBloopIter = 1;
        if get(findobj(gcbf,'Tag','SRCTRLCheckboxFOFB'),'Value') == 1
            StartFOFBFlag = 1;
        else
            StartFOFBFlag = 0;
        end

        FEEDBACK_STOP_FLAG = 0;
        HWarnNum=0;
        VWarnNum=0;

        SR_GeV = getenergy;
        % Feedback loop setup
        PlotInfoFlag = 0;           % Plot micado stuff
        LoopDelay = 1.0;           % Period of feedback loop [seconds], make sure the BPM averaging is correct
        VCM_LSB = .00366211;
        VCMCHICANE_LSB = .002441;   % 80 max?,  Note: not fully implemented

        if strcmp(getfamilydata('OperationalMode'), '1.9 GeV, Two-Bunch')
            Xgain  = 0.2;
            Ygain  = 0.1;
        else
            Xgain  = 0.8; % raised 0.5->0.8 at 17:20, 3-2-05 to more quickly correct EPU4 fast switching orbit distortions
            Ygain  = 0.8;
        end

        % Load lattice set for tune feed forward
        ConfigSetpoint = getproductionlattice;
        %load([getfamilydata('Directory','OpsData') getfamilydata('OpsData','LatticeFile')]);
        QFsp = ConfigSetpoint.QF.Setpoint.Data;
        QDsp = ConfigSetpoint.QD.Setpoint.Data;
        TuneW16Min = gap2tune([5 1], 13.23, 1.8909);
        % Tune response matrix
        SR_TUNE_MATRIX = gettuneresp({'QF','QD'}, {[],[]}, getenergy('Production'));    % Approx. [0.1944 -0.0286;-0.1182 0.1526];
        %SR_TUNE_MATRIX = [0.1641 -0.0245
        %                 -0.1149 0.1477];
        
        SQSFsp = amp2k('SQSF','Setpoint',ConfigSetpoint.SQSF.Setpoint.Data);
        SQSDsp = amp2k('SQSD','Setpoint',ConfigSetpoint.SQSD.Setpoint.Data);

%         % tune FF for EPUs (data exist for 4 1 parallel, 11 1 parallel and antiparallel
%         load '/home/als/physdata/matlab/srdata/gaptrack/EPU4-1_tunecomp/after_shimming/nux_map_withgaps.mat'
%         dnux_epu_41_m0 = tunexmap(2:end,2:end)-tunexmap(2,12);      
%         [gap_epu_41,shift_epu_41]=meshgrid(tunexmap(2:end,1),tunexmap(1,2:end));
%         load '/home/als/physdata/matlab/srdata/gaptrack/EPU4-1_tunecomp/after_shimming/nuy_map_withgaps.mat'
%         dnuy_epu_41_m0 = tuneymap(2:end,2:end)-tuneymap(2,12);    
%         
%         load '/home/als/physdata/matlab/srdata/gaptrack/archive/epu11d1m0e19_2007-01-28.mat' tune_x tune_y Gaps GapsLongitudinal
%         dnux_epu_111_m0 = tune_x-tune_x(1,11);      
%         [gap_epu_111,shift_epu_111]=meshgrid(Gaps,GapsLongitudinal);
%         dnuy_epu_111_m0 = tune_y-tune_y(1,11);      
%         load '/home/als/physdata/matlab/srdata/gaptrack/archive/epu11d1m1e19_2007-01-28.mat' tune_x tune_y Gaps GapsLongitudinal
%         dnux_epu_111_m1 = tune_x-tune_x(1,11);      
%         dnuy_epu_111_m1 = tune_y-tune_y(1,11);      

        % tune FF for EPUs (data exist for 4 1 parallel, 11 1 parallel and antiparallel
        load '/home/als/physdata/matlab/srdata/epu/tuneshift_2d_tables/epu_tunetables_2d_20070723.mat'
        dnux41p = nux41p-nux41p(1,11);      
        dnuy41p = nuy41p-nuy41p(1,11);      
        dnux41a = nux41a-nux41a(1,11);      
        dnuy41a = nuy41a-nuy41a(1,11);      
        dnux111p = nux111p-nux111p(1,11);      
        dnuy111p = nuy111p-nuy111p(1,11);      
        dnux111a = nux111a-nux111a(1,11);      
        dnuy111a = nuy111a-nuy111a(1,11);      
        dnux112p = nux112p-nux112p(1,11);      
        dnuy112p = nuy112p-nuy112p(1,11);      
        dnux112a = nux112a-nux112a(1,11);      
        dnuy112a = nuy112a-nuy112a(1,11);      
        
        % ID tune compensation does not work in the injection lattice, so ...
        if abs(SR_GEV - bend2gev)>  0.05     % Don't use this routine for the injection lattice
            fprintf('   This routine should only be used for the production energy: Orbit feedback aborted\n');
            return
        end

        set(0,'showhiddenhandles','on');

        try
            fprintf('\n');
            fprintf('   *******************************\n');
            fprintf('   **  Starting Orbit Feedback  **\n');
            fprintf('   *******************************\n');
            a = clock;
            fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
            fprintf('   Note: the Matlab command window will be used to display status information.\n');
            fprintf('         It cannot be used to enter commands during slow orbit feedback.\n');


				% save current BPM timeconstant - will reset to this when feedback stops
				BPMtimeconstantOFB = getbpmtimeconstant;
				fprintf('   Current Bergoz BPM time constant is %.1fs\n', BPMtimeconstantOFB);
				
            % >= 2 Hz update rate on IDBPMs
            disp('   Bergoz BPM time constant set to 0.2s.')
            setbpmtimeconstant(0.2)
            pause(1.1);

            % Check whether bumps and kickers are on and warn to turn off before starting feedback if necessary
            try
                if (getsp('SR01S___BUMP1__BC21')==1 && getsp('SR01S___BUMP1P_BC22')==1) || (getsp('SR01S___SEK____BC21')==1 && getsp('SR01S___SEK_P__BC23')==1) || (getsp('SR01S___SEN____BC20')==1 && getsp('SR01S___SEN_P__BC22')==1)
                    soundtada;
                    fprintf('   \n');
                    fprintf('   *********************************************************************************\n');
                    fprintf('   ** One or more of the pulsed SR injection magnets is still on!  Turn them off! **\n');
                    fprintf('   *********************************************************************************\n');
                    fprintf('   \n');
                end
            catch
                fprintf('   %s \n',lasterr);
                disp('**Problem checking the state of the bumps and kickers - please check that they are not pulsing.');
            end

            % Get vectors

            FB = get(findobj(gcbf,'Tag','SRCTRLButtonFeedbackSetup'),'Userdata');

            BPMlist1 = FB.OCSx.BPM.DeviceList;
            % FOFB_BPMlist = 
            HCMlist1 = FB.HCMlist1;
            VCMlist1 = FB.VCMlist1;
            Xivec = FB.Xivec;
            Yivec = FB.Yivec;
            Xgoal = FB.OCSx.GoalOrbit;
            Ygoal = FB.OCSy.GoalOrbit;
            FFTypeFlag = FB.FFTypeFlag;   %local or global tune correction

            iNotHCMChicane = find(HCMlist1(:,2) < 10); %used by steppv's for setting correctors in loop
            iHCMChicane = find(HCMlist1(:,2) == 10);
            iNotVCMChicane = find(VCMlist1(:,2) < 10);
            iVCMChicane = find(VCMlist1(:,2) == 10);

            % Sensitivity matrix for setting fast feedback setpoints
            Sx1 = getrespmat('BPMx', BPMlist1, 'HCM', HCMlist1, [], SR_GEV);
            Sy1 = getrespmat('BPMy', BPMlist1, 'VCM', VCMlist1, [], SR_GEV);

        catch
            fprintf('\n  %s \n',lasterr);

            % Reset Bergoz BPM time constant to whatever it was before feedback started
            fprintf('   Bergoz BPM time constant set back to %.1f\n', BPMtimeconstantOFB);
            setbpmtimeconstant(BPMtimeconstantOFB);


            a = clock;
            fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
            fprintf('   *************************************************************\n');
            fprintf('   **  Orbit feedback could not start due to error condition  **\n');
            fprintf('   *************************************************************\n\n');
            set(0,'showhiddenhandles','off');
            pause(0);

            return
        end

        StartFlag = questdlg(strvcat('','Is it OK to start orbit feedback?'),'Orbit Feedback','Yes','No','No');
        if strcmp(StartFlag,'No')
            % Reset Bergoz BPM time constant to whatever it was before feedback started
            fprintf('   Bergoz BPM time constant set back to %.1f\n', BPMtimeconstantOFB);
            setbpmtimeconstant(BPMtimeconstantOFB);

            a = clock;
            fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
            fprintf('   ***************************\n');
            fprintf('   **  Orbit Feedback Exit  **\n');
            fprintf('   ***************************\n\n');
            pause(0);
            return
        end

        SR_STATE_OLD = scaget('SR_STATE');
        setpv('SR_STATE', 5);
        set(0,'showhiddenhandles','on');
        [StateNumber, StateString] = getsrstate;
        if StateNumber >= 0
            set(findobj(gcbf,'Tag','SRCTRLStaticTextInformation'),'String',StateString,'ForegroundColor','b');
        else
            set(findobj(gcbf,'Tag','SRCTRLStaticTextInformation'),'String',StateString,'ForegroundColor','r');
        end
        fprintf('   Using %d E-vectors horizontally.\n', length(Xivec));
        fprintf('   Using %d E-vectors vertically.\n',   length(Yivec));
        fprintf('   Starting slow orbit correction every %.1f seconds.\n', LoopDelay);
        %  fprintf('   Resetting SR11 chicane motors every 20 seconds to fix drift problem.\n');

        IDSector = getlist('ID');
        EPUlist = find((IDSector(:,1)==4) | (IDSector(:,1)==11));
        oldgap=210*ones(size(IDSector,1),1);
        oldShift=zeros(size(oldgap));
		  
        try
            
            % Get and display data
            x = FB.OCSx.GoalOrbit - getx(FB.OCSx.BPM.DeviceList);
            y = FB.OCSy.GoalOrbit - gety(FB.OCSy.BPM.DeviceList);
            STDx = norm(x)/sqrt(length(x));
            STDy = norm(y)/sqrt(length(y));
            set(findobj(gcbf,'Tag','SRCTRLStaticTextHorizontal'),'String',sprintf('Horizontal RMS = %.4f mm',STDx),'ForegroundColor',[0 0 0]);
            set(findobj(gcbf,'Tag','SRCTRLStaticTextVertical'),'String',sprintf('Vertical RMS = %.4f mm',STDy),'ForegroundColor',[0 0 0]);

            % write goldenorbit values to Fast Orbit Feedback
            try
                write_goldenorbit_ffb;
            catch
                fprintf('   %s \n',lasterr);
                disp('write_goldenorbit_ffb did not work!');
            end
            setpv('SR01____FFBON__BC00',2);
            %pause(0);

            %display state of FOFB system
            FOFBStatus = [getpv('SR01____FFBON__BM00') getpv('SR02____FFBON__BM00') getpv('SR03____FFBON__BM00')...
                getpv('SR04____FFBON__BM00') getpv('SR05____FFBON__BM00') getpv('SR06____FFBON__BM00')...
                getpv('SR07____FFBON__BM00') getpv('SR08____FFBON__BM00') getpv('SR09____FFBON__BM00')...
                getpv('SR10____FFBON__BM00') getpv('SR11____FFBON__BM00') getpv('SR12____FFBON__BM00')];
            FOFBStatusStr = ['    ';'    ';'    ';'    ';'    ';'    ';'    ';'    ';'    ';'    ';'    ';'    '];
            for loop = 1:size(FOFBStatus,2)
                if FOFBStatus(loop)==0
                    FOFBStatusStr(loop,:) = 'OFF ';
                elseif FOFBStatus(loop)==1
                    FOFBStatusStr(loop,:) = 'ON  ';
                elseif FOFBStatus(loop)==2
                    FOFBStatusStr(loop,:) = 'OPEN';
                else
                    FOFBStatusStr(loop,:) = 'BAD ';
                end
            end
            set(findobj(gcbf,'Tag','SRCTRLStaticTextFOFB01'),'String',sprintf('01 %s',FOFBStatusStr(1,:)),'ForegroundColor',[0 0 0]);
            set(findobj(gcbf,'Tag','SRCTRLStaticTextFOFB02'),'String',sprintf('02 %s',FOFBStatusStr(2,:)),'ForegroundColor',[0 0 0]);
            set(findobj(gcbf,'Tag','SRCTRLStaticTextFOFB03'),'String',sprintf('03 %s',FOFBStatusStr(3,:)),'ForegroundColor',[0 0 0]);
            set(findobj(gcbf,'Tag','SRCTRLStaticTextFOFB04'),'String',sprintf('04 %s',FOFBStatusStr(4,:)),'ForegroundColor',[0 0 0]);
            set(findobj(gcbf,'Tag','SRCTRLStaticTextFOFB05'),'String',sprintf('05 %s',FOFBStatusStr(5,:)),'ForegroundColor',[0 0 0]);
            set(findobj(gcbf,'Tag','SRCTRLStaticTextFOFB06'),'String',sprintf('06 %s',FOFBStatusStr(6,:)),'ForegroundColor',[0 0 0]);
            set(findobj(gcbf,'Tag','SRCTRLStaticTextFOFB07'),'String',sprintf('07 %s',FOFBStatusStr(7,:)),'ForegroundColor',[0 0 0]);
            set(findobj(gcbf,'Tag','SRCTRLStaticTextFOFB08'),'String',sprintf('08 %s',FOFBStatusStr(8,:)),'ForegroundColor',[0 0 0]);
            set(findobj(gcbf,'Tag','SRCTRLStaticTextFOFB09'),'String',sprintf('09 %s',FOFBStatusStr(9,:)),'ForegroundColor',[0 0 0]);
            set(findobj(gcbf,'Tag','SRCTRLStaticTextFOFB10'),'String',sprintf('10 %s',FOFBStatusStr(10,:)),'ForegroundColor',[0 0 0]);
            set(findobj(gcbf,'Tag','SRCTRLStaticTextFOFB11'),'String',sprintf('11 %s',FOFBStatusStr(11,:)),'ForegroundColor',[0 0 0]);
            set(findobj(gcbf,'Tag','SRCTRLStaticTextFOFB12'),'String',sprintf('12 %s',FOFBStatusStr(12,:)),'ForegroundColor',[0 0 0]);

        catch

            fprintf('\n  %s \n',lasterr);

            % Reset Bergoz BPM time constant to whatever it was before feedback started
            fprintf('   Bergoz BPM time constant set back to %.1f\n', BPMtimeconstantOFB);
            setbpmtimeconstant(BPMtimeconstantOFB);


            a = clock;
            fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
            fprintf('   *************************************************************\n');
            fprintf('   **  Orbit feedback could not start due to error condition  **\n');
            fprintf('   *************************************************************\n\n');

            setpv('SR_STATE',SR_STATE_OLD);
            [StateNumber, StateString] = getsrstate;
            if StateNumber >= 0
                set(findobj(gcbf,'Tag','SRCTRLStaticTextInformation'),'String',StateString,'ForegroundColor','b');
            else
                set(findobj(gcbf,'Tag','SRCTRLStaticTextInformation'),'String',StateString,'ForegroundColor','r');
            end
            set(0,'showhiddenhandles','off');
            pause(0);

            return

        end


        % Disable buttons
        set(0,'showhiddenhandles','on');
        set(findobj(gcbf,'Tag','SRCTRLPushbuttonStart'),'Enable','off');
        set(findobj(gcbf,'Tag','SRCTRLPushbuttonStop'),'Enable','on');
        set(findobj(gcbf,'Tag','SRCTRLButton1'),'Enable','off');
        set(findobj(gcbf,'Tag','SRCTRLButton2'),'Enable','off');
        set(findobj(gcbf,'Tag','SRCTRLButton3'),'Enable','off');
        set(findobj(gcbf,'Tag','SRCTRLButtonChangeMode'),'Enable','off');
        set(findobj(gcbf,'Tag','SRCTRLButtonSRState'),'Enable','off');
        set(findobj(gcbf,'Tag','SRCTRLButtonGoldenPage'),'Enable','off');
        set(findobj(gcbf,'Tag','SRCTRLButtonOrbitCorrection'),'Enable','off');
        set(findobj(gcbf,'Tag','SRCTRLButtonOrbitCorrectionSetup'),'Enable','off');
        set(findobj(gcbf,'Tag','SRCTRLButtonFeedbackSetup'),'Enable','off');
        set(findobj(gcbf,'Tag','SRCTRLButtonFastFeedbackSetup'),'Enable','off');
        set(findobj(gcbf,'Tag','SRCTRLClose'),'Enable','off');
        pause(0);


        % Initialize feedback loop
        StartTime = gettime;
        StartErrorTime = gettime;
        Xold = getx(FB.OCSx.BPM.DeviceList);
        Yold = gety(FB.OCSy.BPM.DeviceList);
        HQMOFM_stalenum = 0;
        pause(LoopDelay);

        N_HCM = size(HCMlist1,1);
        N_VCM = size(VCMlist1,1);

        N_RFMO = 1;

        if get(findobj(gcbf,'Tag','SRCTRLCheckboxRF'),'Value') == 1
            [FB.OCSx, RF, OCSx0] = setorbit(FB.OCSx,'SetRF','Nodisplay','Nosetsp');
        else
            [FB.OCSx, RF, OCSx0] = setorbit(FB.OCSx,'Nodisplay','Nosetsp');
        end
        [FB.OCSx, Smatx, Sx, Ux, Vx] = orbitcorrectionmethods(FB.OCSx);

        [FB.OCSy, junk, OCSy0] = setorbit(FB.OCSy,'Nodisplay','Nosetsp');
        [FB.OCSy, Smaty, Sy, Uy, Vy] = orbitcorrectionmethods(FB.OCSy);


        %%%%%%%%%%%%%%%%%%%%%%%
        % Start feedback loop %
        %%%%%%%%%%%%%%%%%%%%%%%

        % chicaneloop=1;  % loop variable for resetting drifting chicanes (see a few lines below)
        % fftest=figure;

        setpv('SR01____FFBON__BC00',2); % put FOFB in open loop so beamnoise gets recorded even if FOFB is not enabled

        while 1
            try
                t00 = gettime;

                %          if chicaneloop==20 % reset SR11 motor chicane setpoints every 20s due to drifting positions
                %             setsp('HCMCHICANEM',HCMCHICANEMsp(6),[11 1],0);
                %             setsp('HCMCHICANEM',HCMCHICANEMsp(7),[11 2],0);
                %             chicaneloop = 1;
                %          else
                %             chicaneloop = chicaneloop + 1;
                %          end

                % Check if GUI has been closed
                if isempty(gcbf)
                    FEEDBACK_STOP_FLAG = 1;
                    lasterr('SRCONTROL GUI DISAPPEARED!');
                    error('SRCONTROL GUI DISAPPEARED!');
                end

                %%%%%%%%%%%%%%%%%%%%%%%
                % Fast orbit feedback %
                %%%%%%%%%%%%%%%%%%%%%%%
                if StartFOFBFlag == 1 && FBloopIter > 3
                    setpv('SR01____FFBON__BC00',2);
                    pause(0.5);
                    setpv('SR01____FFBON__BC00',1);
                    StartFOFBFlag = 0;
                    pause(1);
                    FOFBOnStatus = [getpv('SR01____FFBON__BM00') getpv('SR02____FFBON__BM00') getpv('SR03____FFBON__BM00')...
                        getpv('SR04____FFBON__BM00') getpv('SR05____FFBON__BM00') getpv('SR06____FFBON__BM00')...
                        getpv('SR07____FFBON__BM00') getpv('SR08____FFBON__BM00') getpv('SR09____FFBON__BM00')...
                        getpv('SR10____FFBON__BM00') getpv('SR11____FFBON__BM00') getpv('SR12____FFBON__BM00')];
                    if any(FOFBOnStatus==0) || any(FOFBOnStatus==2)
                        setpv('SR01____FFBON__BC00',2); % open FOFB loop
                        disp('************************************************************************************************************');
                        disp('** Problem turning on Fast Orbit Feedback system...                                                       **');
                        disp('** Check status of ffbsecXX crates - but remember that a crate reboot will turn off Quads in that sector! **');
                        disp('** Suggest disabling the "Fast Orbit Correction" checkbox and starting Orbit Feedback again.              **');
                        disp('************************************************************************************************************');
                    else
                        fprintf('   Starting Fast Orbit Feedback at %.0f Hz.\n', getpv('SR01____FFBFREQAM00'));
                    end
                end


                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Horizontal plane "feedback" %
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                if get(findobj(gcbf,'Tag','SRCTRLCheckboxSOFB'),'Value') == 1

                    % Get orbit and check that the BPMs are different from the last update
                    Xnew = getx(FB.OCSx.BPM.DeviceList);

                    % Don't feedback if the current is too small
                    if getdcct < 2
                        FEEDBACK_STOP_FLAG = 1;
                        fprintf('%s         Orbit feedback stopped due to low beam current (<5mA)\n',datestr(now));
                        break;
                    end

                    x = Xgoal - Xnew;
                    STDx = norm(x)/sqrt(length(x));

                    if any(Xold == Xnew)
                        a = clock;
                        N_Stale_Data_Points = find((Xold==Xnew)==1);
                        for loop = N_Stale_Data_Points'
                            fprintf('   Stale data: BPMx(%2d,%d), feedback step skipped (%s %d:%d:%.0f). \n', FB.OCSx.BPM.DeviceList(loop,1), FB.OCSx.BPM.DeviceList(loop,2), date, a(4), a(5), a(6));
                        end
                    else
                        % Compute horizontal correction
                        %%%OCSx0 = FB.OCSx;
                        FB.OCSx.BPM.Data = Xnew;
                        FB.OCSx = orbitcorrectionmethods(FB.OCSx, Smatx, Sx, Ux, Vx);

                        %%%[FB.OCSx, RF, OCSx0] = setorbit(FB.OCSx,'Nodisplay','Nosetsp');

                        % reduced feedback gain (implemented by Greg Portmann, December 2000)
                        % reduced to 0.1, C. Steier, 2001-09-04, IDBPMs are noisy at the moment
                        % increased back to 0.8 C. Steier, 2001-09-29, IDBPMs filtering + direct DAC read/write + all SVDs (no arc BPMs)
                        % increased to 1.0, C. Steier, 2002-05-04, trim DACs
								%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
								% should probably actively allocate X's size to prevent possible memory leak %
								%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        X = [Xgain .* FB.OCSx.CM.Delta; 0.3*FB.OCSx.DeltaRF/4.988e-3*10];
                        
                        %%%X = Xgain .* (FB.OCSx.CM.Data - OCSx0.CM.Data);

                        % check corrector trim values + next step values, warn or stop FB as necessary
                        HCMtrimSP=getpv('HCM','Trim',HCMlist1);
                        HCMtrimSP_next = HCMtrimSP + X(1:N_HCM);
                        if max(abs(HCMtrimSP_next)) > 4
                            HCMtrimnum=find(abs(HCMtrimSP_next) > 4);

                            % print message to screen
                            fprintf('\n');
                            fprintf('***One or more of the horizontal correctors is at its maximum!! Stopping orbit feedback. \n');
                            fprintf('   %s\n',datestr(now));
                            for loop = HCMtrimnum'
                                fprintf('***%s is one of the problem correctors.\n',getname('HCM','Trim',HCMlist1(loop,:)));
                            end

                            % send alphapage to operator pager
                            !/usr/ucb/Mail 5108120447@mmode.com < /home/als/physbase/machine/ALS/StorageRing/SOFBstoppedmessage.txt
                            FEEDBACK_STOP_FLAG = 1;

                            setpv('SR_STATE', -5);
                            [StateNumber, StateString] = getsrstate;
                            if StateNumber >= 0
                                set(findobj(gcbf,'Tag','SRCTRLStaticTextInformation'),'String',StateString,'ForegroundColor','b');
                            else
                                set(findobj(gcbf,'Tag','SRCTRLStaticTextInformation'),'String',StateString,'ForegroundColor','r');
                            end
                        end

                        % check chicane trim coil values + next step values, warn or stop FB as necessary
                        HCMCHICANEtrimSP=getpv('HCM','Setpoint',HCMlist1(iHCMChicane,:));
                        HCMCHICANEtrimSP_next = HCMCHICANEtrimSP + X(iHCMChicane);
                        if max(abs(HCMCHICANEtrimSP_next)) > 19.9
                            HCMCHICANEtrimnum=find(abs(HCMCHICANEtrimSP_next) > 19.9);

                            % print message to screen
                            fprintf('\n');
                            fprintf('***One or more of the horizontal chicane trim coil correctors is at its maximum!! Stopping orbit feedback. \n');
                            fprintf('   %s\n',datestr(now));
                            for loop = HCMCHICANEtrimnum'
                                fprintf('***%s is one of the problem correctors.\n',getname('HCM','Setpoint',HCMlist1(iHCMChicane(loop,:),:)));
                            end
                            %fprintf('***Maybe try resetting the setpoints of the motor chicanes in case they are drifting...\n');

                            % send alphapage to operator pager
                            !/usr/ucb/Mail 5108120447@mmode.com < /home/als/physbase/machine/ALS/StorageRing/SOFBstoppedmessage.txt
                            FEEDBACK_STOP_FLAG = 1;

                            setpv('SR_STATE', -5);
                            [StateNumber, StateString] = getsrstate;
                            if StateNumber >= 0
                                set(findobj(gcbf,'Tag','SRCTRLStaticTextInformation'),'String',StateString,'ForegroundColor','b');
                            else
                                set(findobj(gcbf,'Tag','SRCTRLStaticTextInformation'),'String',StateString,'ForegroundColor','r');
                            end
                        end

                        if FEEDBACK_STOP_FLAG == 1
                            % turn off then open FOFB loop (turn off to transfer correctors, then open to enable logging
                            if getpv('SR01____FFBON__BC00')==1
                                disp('   Stopping Fast Orbit Feedback.');
                            end
                            setpv('SR01____FFBON__BC00',0);
                            pause(0.5);
                            setpv('SR01____FFBON__BC00',2);
                            break;
                        end

                        %fprintf('End of feedback loop: %f \n\n',gettime-t00);
                        pause(0);

                        if max(abs(HCMtrimSP_next) > 3)
                            HCMtrimnum=find(abs(HCMtrimSP_next) > 3);
                            HWarnNum=HWarnNum+1;
                            if (HWarnNum==1 || rem(HWarnNum,120)==0)

                                % print message to screen every two minutes
                                fprintf('\n');
                                fprintf('***One or more of the horizontal corrector trims is above 3A or below -3A! \n');
                                fprintf('   %s\n',datestr(now));
                                for loop = HCMtrimnum'
                                    fprintf('***%s is one of the problem correctors.\n',getname('HCM','Trim',HCMlist1(loop,:)));
                                end
                                fprintf('***The orbit feedback is still working but this problem should be investigated. \n');

                                %send alphapage to operator pager the first time then at 10 minutes
                                if (HWarnNum==1 || HWarnNum==600)
                                    !/usr/ucb/Mail 5108120447@mmode.com < /home/als/physbase/machine/ALS/StorageRing/SOFBwarningmessageHCM.txt
                                end
                            end
                        elseif max(abs(HCMCHICANEtrimSP_next) > 15)
                            HCMCHICANEtrimnum=find(abs(HCMCHICANEtrimSP_next) > 15);
                            HWarnNum=HWarnNum+1;
                            if (HWarnNum==1 || rem(HWarnNum,120)==0)

                                % print message to screen every two minutes
                                fprintf('\n');
                                fprintf('***One or more of the horizontal chicane corrector trim coils is above 15A or below -15A! \n');
                                fprintf('   %s\n',datestr(now));
                                for loop = HCMCHICANEtrimnum'
                                    fprintf('***%s is one of the problem correctors.\n',getname('HCM','Setpoint',HCMlist1(iHCMChicane(loop,:),:)));
                                end
                                fprintf('***The orbit feedback is still working but this problem should be investigated. \n');
                                
% All motor chicanes have harmonic drives now, so slipping should be impossible - 6-4-08 - T.Scarvie
%                                 %reset motor chicanes in case they are drifting
%                                 try
%                                     %                                     if HCMCHICANEtrimnum(1)==1
%                                     %                                         if HCMCHICANEtrimSP_next(1)>15
%                                     %                                             steppv('HCMCHICANEM',-0.5,[4 1;4 2]);
%                                     %                                         elseif HCMCHICANEtrimSP_next(1)<(-15)
%                                     %                                             steppv('HCMCHICANEM',0.5,[4 1;4 2]);
%                                     %                                         end
%                                     %                                     end
%                                     fprintf('   Resetting the setpoints of the motor chicanes in case they are drifting...\n');
%                                     setpv('HCMCHICANEM','Setpoint',ConfigSetpoint.HCMCHICANEM.Setpoint.Data,[],0);
%                                 catch
%                                     fprintf('   %s \n',lasterr);
%                                 end

                                %send alphapage to operator pager the first time then at 10 minutes
                                if (HWarnNum==1 || HWarnNum==600)
                                    !/usr/ucb/Mail 5108120447@mmode.com < /home/als/physbase/machine/ALS/StorageRing/SOFBwarningmessageHCMCHICANE.txt
                                end
                            end
                        else
                            HWarnNum=0;
                        end

                        % Don't feedback if the current is too small
                        if getdcct < 2
                            FEEDBACK_STOP_FLAG = 1;
                            fprintf('%s         Orbit feedback stopped due to low beam current (<5mA)\n',datestr(now));
                            !/usr/ucb/Mail 5108120447@mmode.com < /home/als/physbase/machine/ALS/StorageRing/beamisoff.txt
                            break;
                        end

                        if N_HCM > 0
                            steppv('HCM','Trim', X(iNotHCMChicane), HCMlist1(iNotHCMChicane,:), 0);
                            steppv('HCM','Setpoint', X(iHCMChicane), HCMlist1(iHCMChicane,:), 0);
                        end

                        % write fast orbit feedback setpoints
                        if 1
                            %write_goldenorbit_ffb_2planes(1, Xnew(1:size(BPMlist1,1))+Sx1*X(1:N_HCM)+Sx3*X(length(X))/20, BPMlist1);
                            % should be corrected to include result of next frequency step ...
                            write_goldenorbit_ffb_2planes(1,Xnew(1:size(BPMlist1,1))+Sx1*X(1:N_HCM),BPMlist1);
                        end

                        %fprintf('Horizontal Done: %f \n',gettime-t00);

                        % RF feedback
                        HQMOFMsp_last = getpv('EG______HQMOFM_AC01');

                        if get(findobj(gcbf,'Tag','SRCTRLCheckboxRF'),'Value') == 1
                            if N_RFMO > 0
                                if abs(X(end)) < .01
                                    % if abs(FB.OCSx.DeltaRF/3) < .01
                                    steppv('EG______HQMOFM_AC01', X(end));
                                else
                                    steppv('EG______HQMOFM_AC01', 0.01*sign(X(end)));
                                end
                            end

                            HQMOFMsp_now = getpv('EG______HQMOFM_AC01');

                            % Check for stale RF feedback
                            if HQMOFMsp_last == HQMOFMsp_now
                                HQMOFM_stalenum = HQMOFM_stalenum + 1;
                                if HQMOFM_stalenum == 30 % warn and message to pager if stale for 30 secs
                                    fprintf('\n');
                                    fprintf('***The RF is not responding to orbit feedback changes! \n');
                                    fprintf('   %s\n',datestr(now));
                                    fprintf('***The orbit feedback is still working but this problem should be investigated. \n');
                                    fprintf('***ILC 73 controls the EG______HQMOFM_AC01 channel, which sets the RF frequency. \n');
                                    !/usr/ucb/Mail 5108120447@mmode.com < /home/als/physbase/machine/ALS/StorageRing/SOFBstaleRFmessage.txt
                                end
                                if rem(HQMOFM_stalenum,120)==0 % message to screen every 2 minutes
                                    fprintf('\n');
                                    fprintf('***The RF is not responding to orbit feedback changes! (%s)\n',datestr(now));
                                end
                            else
                                HQMOFM_stalenum = 0;
                            end

                        end

                        %fprintf('RF Done: %f \n',gettime-t00);

                        Xold = Xnew;
                    end % End horizontal correction


                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    % Vertical plane "feedback" %
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                    % Get orbit and check that the BPMs are different from the last update
                    Ynew = gety(FB.OCSy.BPM.DeviceList);

                    % Don't feedback if the current is too small
                    if getdcct < 2
                        FEEDBACK_STOP_FLAG = 1;
                        fprintf('%s         Orbit feedback stopped due to low beam current (<5mA)\n',datestr(now));
                        break;
                    end

                    y = Ygoal - Ynew;
                    STDy = norm(y)/sqrt(length(y));

                    if any(Yold == Ynew)
                        a = clock;
                        N_Stale_Data_Points = find((Yold==Ynew)==1);
                        for loop = N_Stale_Data_Points'
                            fprintf('   Stale data: BPMy(%2d,%d), feedback step skipped (%s %d:%d:%.0f). \n', FB.OCSy.BPM.DeviceList(loop,1), FB.OCSy.BPM.DeviceList(loop,2), date, a(4), a(5), a(6));
                        end

                    else

                        % Compute vertical correction
                        %%%OCSy0 = FB.OCSy;
                        FB.OCSy.BPM.Data = Ynew;
                        FB.OCSy = orbitcorrectionmethods(FB.OCSy, Smaty, Sy, Uy, Vy);

                        %%%[FB.OCSy, RF, OCSy0] = setorbit(FB.OCSy,'Nodisplay','Nosetsp');

                        % reduced feedback gain, C. Steier, 2001-03-25
                        % reduced to 0.1, C. Steier, 2001-09-04, IDBPMs are noisy at the moment
                        % increased back to 0.8, C. Steier, 2001-09-29, IDBPMs filtering + direct DAC read/write + all SVDs (no arc BPMs)
                        % set to unity gain, C. Steier, 2002-05-04, trim DACs
                        Y = Ygain .* FB.OCSy.CM.Delta;
                        %%%Y = Ygain .* (FB.OCSy.CM.Data - OCSy0.CM.Data);

                        % Just SVD correction
                        % warning('Not using "micado" correction in the vertical plane.');

                        % check for trim values+next step values, warn or stop FB as necessary
                        VCMtrimSP = getpv('VCM','Trim',VCMlist1);
                        VCMtrimSP_next = VCMtrimSP + Y(1:N_VCM);
                        if max(abs(VCMtrimSP_next)) > 12
                            VCMtrimnum=find(abs(VCMtrimSP_next) > 12);

                            % print message to screen
                            fprintf('\n');
                            fprintf('***One or more of the vertical correctors is at its maximum!! Stopping orbit feedback. \n');
                            fprintf('   %s\n',datestr(now));
                            for loop = VCMtrimnum'
                                fprintf('***%s is one of the problem correctors.\n',getname('VCM','Trim',VCMlist1(loop,:)));
                            end

                            % send alphapage to operator pager
                            !/usr/ucb/Mail 5108120447@mmode.com < /home/als/physbase/machine/ALS/StorageRing/SOFBstoppedmessage.txt
                            FEEDBACK_STOP_FLAG = 1;

                            setpv('SR_STATE', -5);
                            [StateNumber, StateString] = getsrstate;
                            if StateNumber >= 0
                                set(findobj(gcbf,'Tag','SRCTRLStaticTextInformation'),'String',StateString,'ForegroundColor','b');
                            else
                                set(findobj(gcbf,'Tag','SRCTRLStaticTextInformation'),'String',StateString,'ForegroundColor','r');
                            end
                        end

                        % check chicane trim coil values + next step values, warn or stop FB as necessary
                        VCMCHICANEtrimSP=getpv('VCM','Setpoint',VCMlist1(iVCMChicane,:));
                        VCMCHICANEtrimSP_next = VCMCHICANEtrimSP + Y(iVCMChicane);
                        if max(abs(VCMCHICANEtrimSP_next)) > 19.9
                            VCMCHICANEtrimnum=find(abs(VCMCHICANEtrimSP_next) > 19.9);

                            % print message to screen
                            fprintf('\n');
                            fprintf('***One or more of the vertical chicane trim coil correctors is at its maximum!! Stopping orbit feedback. \n');
                            fprintf('   %s\n',datestr(now));
                            for loop = VCMCHICANEtrimnum'
                                fprintf('***%s is one of the problem correctors.\n',getname('VCM','Setpoint',VCMlist1(iVCMChicane(loop,:),:)));
                            end
                            %fprintf('***Maybe try resetting the setpoints of the motor chicanes in case they are drifting...\n');

                            % send alphapage to operator pager
                            !/usr/ucb/Mail 5108120447@mmode.com < /home/als/physbase/machine/ALS/StorageRing/SOFBstoppedmessage.txt
                            FEEDBACK_STOP_FLAG = 1;

                            setpv('SR_STATE', -5);
                            [StateNumber, StateString] = getsrstate;
                            if StateNumber >= 0
                                set(findobj(gcbf,'Tag','SRCTRLStaticTextInformation'),'String',StateString,'ForegroundColor','b');
                            else
                                set(findobj(gcbf,'Tag','SRCTRLStaticTextInformation'),'String',StateString,'ForegroundColor','r');
                            end
                        end

                        if FEEDBACK_STOP_FLAG == 1
                            % turn off then open FOFB loop (turn off to transfer correctors, then open to enable logging
                            if getpv('SR01____FFBON__BC00')==1
                                disp('   Stopping Fast Orbit Feedback.');
                            end
                            setpv('SR01____FFBON__BC00',0);
                            pause(0.5);
                            setpv('SR01____FFBON__BC00',2);
                            break;
                        end

                        %fprintf('End of feedback loop: %f \n\n',gettime-t00);
                        % pause(0);

                        if max(abs(VCMtrimSP_next) > 8) % changed from 6A ~12/1/07 since orbit FB is going past 6A
                            VCMtrimnum=find(abs(VCMtrimSP_next) > 8);
                            VWarnNum=VWarnNum+1;
                            if (VWarnNum==1 || rem(VWarnNum,120)==0)

                                % print message to screen every two minutes
                                fprintf('\n');
                                fprintf('***One or more of the vertical corrector trims is above 8A or below -8A! \n');
                                fprintf('   %s\n',datestr(now));
                                for loop = VCMtrimnum'
                                    fprintf('***%s is one of the problem correctors.\n',getname('VCM','Trim',VCMlist1(loop,:)));
                                end
                                fprintf('***The orbit feedback is still working but this problem should be investigated. \n');

                                %send alphapage to operator pager the first time then at 10 minutes
                                if (VWarnNum==1 || VWarnNum==600)
                                    !/usr/ucb/Mail 5108120447@mmode.com < /home/als/physbase/machine/ALS/StorageRing/SOFBwarningmessageVCM.txt
                                end
                            end
                        elseif max(abs(VCMCHICANEtrimSP_next) > 15)
                            VCMCHICANEtrimnum=find(abs(VCMCHICANEtrimSP_next) > 15);
                            VWarnNum=VWarnNum+1;
                            if (VWarnNum==1 || rem(VWarnNum,120)==0)

                                % print message to screen every two minutes
                                fprintf('\n');
                                fprintf('***One or more of the vertical chicane corrector trim coils is above 15A or below -15A! \n');
                                fprintf('   %s\n',datestr(now));
                                for loop = VCMCHICANEtrimnum'
                                    fprintf('***%s is one of the problem correctors.\n',getname('VCM','Setpoint',VCMlist1(iVCMChicane(loop,:),:)));
                                end
                                fprintf('***The orbit feedback is still working but this problem should be investigated. \n');

% All motor chicanes have harmonic drives now, so slipping should be impossible - 6-4-08 - T.Scarvie
%                                 %reset motor chicanes in case they are drifting
%                                 try
%                                 		fprintf('  Resetting the setpoints of the motor chicanes in case they are drifting...\n');
%                                     	setpv('HCMCHICANEM','Setpoint',ConfigSetpoint.HCMCHICANEM.Setpoint.Data,[],0);
%                                 catch
%                                       fprintf('   %s \n',lasterr);
%                                 end

                                %send alphapage to operator pager the first time then at 10 minutes
                                if (VWarnNum==1 || VWarnNum==600)
                                    !/usr/ucb/Mail 5108120447@mmode.com < /home/als/physbase/machine/ALS/StorageRing/SOFBwarningmessageVCMCHICANE.txt
                                end
                            end
                        else
                            VWarnNum=0;
                        end

                        % Don't feedback if the current is too small
                        if getdcct < 2
                            FEEDBACK_STOP_FLAG = 1;
                            fprintf('%s         Orbit feedback stopped due to low beam current (<5mA)\n',datestr(now));
                            !/usr/ucb/Mail 5108120447@mmode.com < /home/als/physbase/machine/ALS/StorageRing/beamisoff.txt
                            break;
                        end

                        if N_VCM > 0
                            steppv('VCM','Trim', Y(iNotVCMChicane), VCMlist1(iNotVCMChicane,:), 0);
                            steppv('VCM','Setpoint', Y(iVCMChicane), VCMlist1(iVCMChicane,:), 0);
                        end

                        % write fast orbit feedback setpoints
                        if 1
                            write_goldenorbit_ffb_2planes(2,Ynew(1:size(BPMlist1,1))+Sy1*Y(1:N_VCM),BPMlist1);
                        end

                    end

                    Yold = Ynew;

                    %fprintf('Vertical Done: %f \n',gettime-t00);
                end % End vertical correction


                %%%%%%%%%%%%%%%%%%%%%
                % Tune feed forward %
                %%%%%%%%%%%%%%%%%%%%%
                % We should do a Sector limit check

                tic;
                if get(findobj(gcbf,'Tag','SRCTRLCheckboxTune'),'Value') == 1

                    if strcmp(SR_Mode, '1.9 GeV, High Tune') || strcmp(SR_Mode, '1.9 GeV, Inject at 1.23') || strcmp(SR_Mode, '1.9 GeV, Inject at 1.353') ||...
                        strcmp(SR_Mode, '1.9 GeV, Two-Bunch')  || strcmp(SR_Mode, '1.5 GeV, Inject at 1.353')  || strcmp(SR_Mode, '1.9 GeV, TopOff')  || strcmp(SR_Mode, '1.5 GeV, High Tune')

                        addQFsp = zeros(24,1);
                        addQDsp = zeros(24,1);

                        if strcmp(FFTypeFlag,'Local')
                            disp('  No local tune compensation available - global is the default now.');
                        elseif strcmp(FFTypeFlag,'Global')

                            % The vectorized gets were put outside of loop for speed reasons
                            %
                            % should also set up QFfac, Quadelem, Quadlist structures outside loop
                            actualgap = getid(IDSector);
                            [gapmin,gapmax] = gaplimit(IDSector);
                            corrind = find(actualgap<(gapmin-1));
                            actualgap(corrind)=gapmax(corrind);
                            Shift=zeros(size(actualgap));
                            Shift(EPUlist)=getpv('EPU');

                            IDchangedList=find((abs(actualgap-oldgap)>0.005) | (abs(Shift-oldShift)>0.005));

                            if ~isempty(IDchangedList)

                                oldgap=actualgap;
                                oldShift=Shift;

                                % EPUs excite nux = .25 resonance in vertical linear polarization mode!
                                % therefore with EPU tune feedforward
                                % running, we want to move our nominal working point away (just below) the .25 resonance.
                                %
                                % The following tune correction moves nominal
                                % nu_x from .25 to .245 - this should be enough for well set up lattices.
                                %
                                % 24 QF+ 24 QD
                                DeltaAmps = inv(SR_TUNE_MATRIX) * [-0.005;0];    %  DelAmps =  [QF; QD];
                                addQFsp = addQFsp + DeltaAmps(1,:);
                                addQDsp = addQDsp + DeltaAmps(2,:);

                                for gapnum = 1:length(actualgap)

                                    % Change in tune and [QF;QD] from maximum gap

                                    if (IDSector(gapnum,1) == 4) || (IDSector(gapnum,1) == 11)
                                        if IDSector(gapnum,2) == 1
                                            modenamestr = sprintf('SR%02dU___ODS1M__DC00',IDSector(gapnum,1));
                                        else % if IDSector(gapnum,2) == 2
                                            modenamestr = sprintf('SR%02dU___ODS2M__DC00',IDSector(gapnum,1));
                                        end
                                        epumode = getpv(modenamestr);
                                        if (IDSector(gapnum,1) == 4) && (IDSector(gapnum,2) == 1) 
                                            if 1   % temporary fix as long as we do not have good tune FF table without shims (2008-02-15)
                                                if (epumode==0)
                                                    DeltaNuX = shift2tune(IDSector(gapnum,:),actualgap(gapnum),Shift(gapnum));
                                                    DeltaNuY = 0;
                                                else
                                                    DeltaNuX = 0;
                                                    DeltaNuY = 0;
                                                end
                                            elseif (epumode == 0)
%                                                 DeltaNuX = interp2(gap_epu_41,shift_epu_41,dnux_epu_41_m0',actualgap(gapnum),Shift(gapnum),'linear',0);
%                                                 DeltaNuY = interp2(gap_epu_41,shift_epu_41,dnuy_epu_41_m0',actualgap(gapnum),Shift(gapnum),'linear',0);
                                                DeltaNuX = interp2(gap41p',shift41p',dnux41p',actualgap(gapnum),Shift(gapnum),'linear',0);
                                                DeltaNuY = interp2(gap41p',shift41p',dnuy41p',actualgap(gapnum),Shift(gapnum),'linear',0);
                                            elseif (epumode == 1)
%                                                 DeltaNux = 0;
%                                                 DeltaNuY = gap2tune(IDSector(gapnum, :), actualgap(gapnum), SR_GeV);  
                                                DeltaNuX = interp2(gap41a',shift41a',dnux41a',actualgap(gapnum),Shift(gapnum),'linear',0);
                                                DeltaNuY = interp2(gap41a',shift41a',dnuy41a',actualgap(gapnum),Shift(gapnum),'linear',0);
                                            else
                                                DeltaNux = 0;
                                                DeltaNuY = gap2tune(IDSector(gapnum, :), actualgap(gapnum), SR_GeV);  
                                            end
                                        elseif (IDSector(gapnum,1) == 11) && (IDSector(gapnum,2) == 1) 
                                            if (epumode == 0)
%                                                 DeltaNuX = interp2(gap_epu_111,shift_epu_111,dnux_epu_111_m0',actualgap(gapnum),Shift(gapnum),'linear',0);
%                                                 DeltaNuY = interp2(gap_epu_111,shift_epu_111,dnuy_epu_111_m0',actualgap(gapnum),Shift(gapnum),'linear',0);
                                                DeltaNuX = interp2(gap111p',shift111p',dnux111p',actualgap(gapnum),Shift(gapnum),'linear',0);
                                                DeltaNuY = interp2(gap111p',shift111p',dnuy111p',actualgap(gapnum),Shift(gapnum),'linear',0);
                                            elseif (epumode == 1)
%                                                 DeltaNuX = interp2(gap_epu_111,shift_epu_111,dnux_epu_111_m1',actualgap(gapnum),Shift(gapnum),'linear',0);
%                                                 DeltaNuY = interp2(gap_epu_111,shift_epu_111,dnuy_epu_111_m1',actualgap(gapnum),Shift(gapnum),'linear',0);
                                                DeltaNuX = interp2(gap111a',shift111a',dnux111a',actualgap(gapnum),Shift(gapnum),'linear',0);
                                                DeltaNuY = interp2(gap111a',shift111a',dnuy111a',actualgap(gapnum),Shift(gapnum),'linear',0);
                                            else
                                                DeltaNuX = 0;
                                                DeltaNuY = gap2tune(IDSector(gapnum,:), actualgap(gapnum), SR_GeV);   % variation of vertical tune shift with phase is small for EPUs
                                            end
                                        elseif (IDSector(gapnum,1) == 11) && (IDSector(gapnum,2) == 2) 
                                            if (epumode == 0)
%                                                 DeltaNuX = interp2(gap_epu_111,shift_epu_111,dnux_epu_111_m0',actualgap(gapnum),Shift(gapnum),'linear',0);
%                                                 DeltaNuY = interp2(gap_epu_111,shift_epu_111,dnuy_epu_111_m0',actualgap(gapnum),Shift(gapnum),'linear',0);
                                                DeltaNuX = interp2(gap112p',shift112p',dnux112p',actualgap(gapnum),Shift(gapnum),'linear',0);
                                                DeltaNuY = interp2(gap112p',shift112p',dnuy112p',actualgap(gapnum),Shift(gapnum),'linear',0);
                                            elseif (epumode == 1)
%                                                 DeltaNuX = interp2(gap_epu_111,shift_epu_111,dnux_epu_111_m1',actualgap(gapnum),Shift(gapnum),'linear',0);
%                                                 DeltaNuY = interp2(gap_epu_111,shift_epu_111,dnuy_epu_111_m1',actualgap(gapnum),Shift(gapnum),'linear',0);
                                                DeltaNuX = interp2(gap112a',shift112a',dnux112a',actualgap(gapnum),Shift(gapnum),'linear',0);
                                                DeltaNuY = interp2(gap112a',shift112a',dnuy112a',actualgap(gapnum),Shift(gapnum),'linear',0);
                                            else
                                                DeltaNuX = 0;
                                                DeltaNuY = gap2tune(IDSector(gapnum,:), actualgap(gapnum), SR_GeV);   % variation of vertical tune shift with phase is small for EPUs
                                            end
                                        else
                                            DeltaNuX = 0;
                                            DeltaNuY = gap2tune(IDSector(gapnum,:), actualgap(gapnum), SR_GeV);   
                                        end

                                    else
                                        DeltaNuX = 0;
                                        DeltaNuY = gap2tune(IDSector(gapnum,:), actualgap(gapnum), SR_GeV);
                                    end

                                    DelQF = zeros(length(QFsp),1);
                                    DelQD = zeros(length(QFsp),1);

                                    fraccorr = 0.8*DeltaNuY ./ TuneW16Min;

                                    % Find which quads to change (local beta beating correction
                                    % (horizontal for EPU, vertical otherwise)
                                    QuadList = [IDSector(gapnum,1)-1 2; IDSector(gapnum,1) 1];
                                    QuadElem = dev2elem('QF',QuadList); % in reality use QF and QD ...

                                    % global vertical tune correction
                                    % 24 QF+ 24 QD
                                    DeltaAmps = inv(SR_TUNE_MATRIX) * [(fraccorr*6.23e-4); fraccorr*(-0.05301)];    %  DelAmps =  [QF; QD];
                                    DelQF = DelQF + DeltaAmps(1,:);
                                    DelQD = DelQD + DeltaAmps(2,:);

                                    % local horizontal tune correction (is also nearly a beta beating correction) only nonzero for EPUs!
                                    % 2 QF + 2 QD
                                    DeltaAmpsLocal = 12*inv(SR_TUNE_MATRIX) * [-DeltaNuX;0];                       %  DelAmps =  [QF; QD];
                                    DelQF(QuadElem) = DelQF(QuadElem)+DeltaAmpsLocal(1,1);
                                    DelQD(QuadElem) = DelQD(QuadElem)+DeltaAmpsLocal(2,1);

                                    % local vertical beta beating correction (should be used together with above global tune correction)
                                    % set to zero for EPUs, since their vertical tune shift is small
                                    % 2 QF + 2QD
                                    if (IDSector(gapnum,1)==6) || (IDSector(gapnum,1)==7) || (IDSector(gapnum,1)==10) || (IDSector(gapnum,1)==11)
                                        QFfac = ([2.243127/2.237111; 2.243127/2.237111]-1) * fraccorr;
                                        QDfac = ([2.556392/2.511045; 2.556392/2.511045]-1) * fraccorr;
                                    elseif (IDSector(gapnum,1)==5) || (IDSector(gapnum,1)==9)
                                        QFfac = ([2.225965/2.219784; 2.243096/2.237111]-1) * fraccorr;
                                        QDfac = ([2.528950/2.483259; 2.556345/2.511045]-1) * fraccorr;
                                    elseif (IDSector(gapnum,1)==4) || (IDSector(gapnum,1)==8) || (IDSector(gapnum,1)==12)
                                        QFfac = ([2.243096/2.237111; 2.225965/2.219784]-1) * fraccorr;
                                        QDfac = ([2.556345/2.511045; 2.528950/2.483259]-1) * fraccorr;
                                    else
                                        QFfac = zeros(2,1);
                                        QDfac = zeros(2,1);
                                    end

                                    DelQF(QuadElem,:) = DelQF(QuadElem,:) + QFfac.*QFsp(QuadElem,:);
                                    DelQD(QuadElem,:) = DelQD(QuadElem,:) + QDfac.*QDsp(QuadElem,:);

                                    % add all tune and beta beating corrections for this one ID to the summed up correction vectors for all IDs
                                    addQFsp = addQFsp+DelQF;
                                    addQDsp = addQDsp+DelQD;
                                    
                                    
                                    % Skew FF for IVID
                                    if (IDSector(gapnum,1)==6)
                                        scale=(gap2tune([6 1])/0.005)^(3/4)*0.16;
                                        [SQSFincr, SQSDincr] = set_etaywave_nuy9_20skews_skewFF(scale);
                                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                        % should add a limit check here %
                                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                        setpv('SQSF', 'Setpoint', SQSFsp+SQSFincr, [], 0, 'Physics');
                                        setpv('SQSD', 'Setpoint', SQSDsp+SQSDincr, [], 0, 'Physics');
                                    end

                                end

                                % Set quadrupoles using main setpoint channels
                                setpv('QF', QFsp+addQFsp,[], 0);
                                setpv('QD', QDsp+addQDsp,[], 0);
                                % % Set quadrupoles using FF setpoint channels
                                % setpv('QF', 'FF', addQFsp, [], 0);
                                % setpv('QD', 'FF', addQDsp, [], 0);
                                
                            end

                        else
                            error('Unknown type selected for tune FF');
                        end

                    else
                        disp('  No tune FF algorithm for non-production modes yet...');
                    end
                end

                ffdeltaquad_delay = toc;
                %fprintf('tune FF delay = %.1f seconds\n',ffdeltaquad_delay);
                % fprintf('Tune Done: %f \n',gettime-t00);

                % Output info to screen
                set(findobj(gcbf,'Tag','SRCTRLStaticTextHorizontal'),'String',sprintf('Horizontal RMS = %.4f mm',STDx),'ForegroundColor',[0 0 0]);
                set(findobj(gcbf,'Tag','SRCTRLStaticTextVertical'),'String',sprintf('Vertical RMS = %.4f mm',STDy),'ForegroundColor',[0 0 0]);
                %pause(0);

                FOFBStatus = [getpv('SR01____FFBON__BM00') getpv('SR02____FFBON__BM00') getpv('SR03____FFBON__BM00')...
                    getpv('SR04____FFBON__BM00') getpv('SR05____FFBON__BM00') getpv('SR06____FFBON__BM00')...
                    getpv('SR07____FFBON__BM00') getpv('SR08____FFBON__BM00') getpv('SR09____FFBON__BM00')...
                    getpv('SR10____FFBON__BM00') getpv('SR11____FFBON__BM00') getpv('SR12____FFBON__BM00')];
                for loop = 1:size(FOFBStatus,2)
                    if FOFBStatus(loop)==0
                        FOFBStatusStr(loop,:) = 'OFF ';
                    elseif FOFBStatus(loop)==1
                        FOFBStatusStr(loop,:) = 'ON  ';
                    elseif FOFBStatus(loop)==2
                        FOFBStatusStr(loop,:) = 'OPEN';
                    else
                        FOFBStatusStr(loop,:) = 'BAD ';
                    end
                end
                set(findobj(gcbf,'Tag','SRCTRLStaticTextFOFB01'),'String',sprintf('01 %s',FOFBStatusStr(1,:)),'ForegroundColor',[0 0 0]);
                set(findobj(gcbf,'Tag','SRCTRLStaticTextFOFB02'),'String',sprintf('02 %s',FOFBStatusStr(2,:)),'ForegroundColor',[0 0 0]);
                set(findobj(gcbf,'Tag','SRCTRLStaticTextFOFB03'),'String',sprintf('03 %s',FOFBStatusStr(3,:)),'ForegroundColor',[0 0 0]);
                set(findobj(gcbf,'Tag','SRCTRLStaticTextFOFB04'),'String',sprintf('04 %s',FOFBStatusStr(4,:)),'ForegroundColor',[0 0 0]);
                set(findobj(gcbf,'Tag','SRCTRLStaticTextFOFB05'),'String',sprintf('05 %s',FOFBStatusStr(5,:)),'ForegroundColor',[0 0 0]);
                set(findobj(gcbf,'Tag','SRCTRLStaticTextFOFB06'),'String',sprintf('06 %s',FOFBStatusStr(6,:)),'ForegroundColor',[0 0 0]);
                set(findobj(gcbf,'Tag','SRCTRLStaticTextFOFB07'),'String',sprintf('07 %s',FOFBStatusStr(7,:)),'ForegroundColor',[0 0 0]);
                set(findobj(gcbf,'Tag','SRCTRLStaticTextFOFB08'),'String',sprintf('08 %s',FOFBStatusStr(8,:)),'ForegroundColor',[0 0 0]);
                set(findobj(gcbf,'Tag','SRCTRLStaticTextFOFB09'),'String',sprintf('09 %s',FOFBStatusStr(9,:)),'ForegroundColor',[0 0 0]);
                set(findobj(gcbf,'Tag','SRCTRLStaticTextFOFB10'),'String',sprintf('10 %s',FOFBStatusStr(10,:)),'ForegroundColor',[0 0 0]);
                set(findobj(gcbf,'Tag','SRCTRLStaticTextFOFB11'),'String',sprintf('11 %s',FOFBStatusStr(11,:)),'ForegroundColor',[0 0 0]);
                set(findobj(gcbf,'Tag','SRCTRLStaticTextFOFB12'),'String',sprintf('12 %s',FOFBStatusStr(12,:)),'ForegroundColor',[0 0 0]);


                %fprintf('End of feedback operations: %f \n\n',gettime-t00);

                % Wait for next update time or stop request
                while (gettime-t00) < LoopDelay
                    %disp('interval could be shorter')
                    pause(.05);
                    % Check if GUI has been closed
                    if isempty(gcbf)
                        FEEDBACK_STOP_FLAG = 1;
                        lasterr('SRCONTROL GUI DISAPPEARED!');
                        error('SRCONTROL GUI DISAPPEARED!');
                    end

                    % Check if Stop button was pressed
                    if FEEDBACK_STOP_FLAG == 1
                        % turn off then open FOFB loop (turn off to transfer correctors, then open to enable logging
                        if getpv('SR01____FFBON__BC00')==1
                            disp('   Stopping Fast Orbit Feedback.');
                        end
                        setpv('SR01____FFBON__BC00',0);
                        pause(0.5);
                        setpv('SR01____FFBON__BC00',2);
                        break;
                    end
                end


                if FEEDBACK_STOP_FLAG == 1
                    % turn off then open FOFB loop (turn off to transfer correctors, then open to enable logging
                    if getpv('SR01____FFBON__BC00')==1
                        disp('   Stopping Fast Orbit Feedback.');
                    end
                    setpv('SR01____FFBON__BC00',0);
                    pause(0.5);
                    setpv('SR01____FFBON__BC00',2);
                    break;
                end

                StartErrorTime = gettime;

            catch

                fprintf('\n  %s \n',lasterr);

                % Quit if error exists for more than 20 seconds
                if gettime-StartErrorTime>20 || FEEDBACK_STOP_FLAG==1
                    fprintf('%s  Orbit feedback stopped due to error condition. \n\n',datestr(now));

                    %send alphapage to operator pager
                    !/usr/ucb/Mail 5108120447@mmode.com < /home/als/physbase/machine/ALS/StorageRing/SOFBstoppedmessage.txt
                    FEEDBACK_STOP_FLAG = 1;

                    setpv('SR_STATE', -5);
                    [StateNumber, StateString] = getsrstate;
                    if StateNumber >= 0
                        set(findobj(gcbf,'Tag','SRCTRLStaticTextInformation'),'String',StateString,'ForegroundColor','b');
                    else
                        set(findobj(gcbf,'Tag','SRCTRLStaticTextInformation'),'String',StateString,'ForegroundColor','r');
                    end
                else
                    a = clock;
                    fprintf('   Orbit feedback was paused due to error condition (%s %d:%d:%.0f). \n', date, a(4), a(5), a(6));
                    fprintf('   Orbit feedback has automatically restarted and is running. \n\n');
                end

            end

            if FEEDBACK_STOP_FLAG == 1
                % turn off then open FOFB loop (turn off to transfer correctors, then open to enable logging
                if getpv('SR01____FFBON__BC00')==1
                    disp('   Stopping Fast Orbit Feedback.');
                end
                setpv('SR01____FFBON__BC00',0);
                pause(0.5);
                setpv('SR01____FFBON__BC00',2);
                break;
            end

            %fprintf('End of feedback loop: %f \n\n',gettime-t00);

            %pause(0);

            % this loop delays turn on of Fast Feedback system
            if FBloopIter < 5
                FBloopIter = FBloopIter + 1;
            end

        end  % End of feedback loop


        % End feedback, reset all parameters
        try

            % Enable buttons
            set(findobj(gcbf,'Tag','SRCTRLPushbuttonStart'),'Enable','on');
            set(findobj(gcbf,'Tag','SRCTRLPushbuttonStop'),'Enable','off');
            set(findobj(gcbf,'Tag','SRCTRLButton1'),'Enable','on');
            set(findobj(gcbf,'Tag','SRCTRLButton2'),'Enable','on');
            set(findobj(gcbf,'Tag','SRCTRLButton3'),'Enable','on');
            set(findobj(gcbf,'Tag','SRCTRLButtonChangeMode'),'Enable','on');
            set(findobj(gcbf,'Tag','SRCTRLButtonSRState'),'Enable','on');
            set(findobj(gcbf,'Tag','SRCTRLButtonGoldenPage'),'Enable','on');
            set(findobj(gcbf,'Tag','SRCTRLButtonOrbitCorrection'),'Enable','on');
            set(findobj(gcbf,'Tag','SRCTRLButtonOrbitCorrectionSetup'),'Enable','on');
            set(findobj(gcbf,'Tag','SRCTRLButtonFeedbackSetup'),'Enable','on');
            set(findobj(gcbf,'Tag','SRCTRLButtonFastFeedbackSetup'),'Enable','on');
            set(findobj(gcbf,'Tag','SRCTRLClose'),'Enable','on');

            set(findobj(gcbf,'Tag','SRCTRLStaticTextHorizontal'),'String',sprintf('Horizontal RMS = _____ mm'),'ForegroundColor',[0 0 0]);
            set(findobj(gcbf,'Tag','SRCTRLStaticTextVertical'),'String',sprintf('Vertical RMS = _____ mm'),'ForegroundColor',[0 0 0]);

            set(findobj(gcbf,'Tag','SRCTRLStaticTextFOFB01'),'String',sprintf('01 ____'),'ForegroundColor',[0 0 0]);
            set(findobj(gcbf,'Tag','SRCTRLStaticTextFOFB02'),'String',sprintf('02 ____'),'ForegroundColor',[0 0 0]);
            set(findobj(gcbf,'Tag','SRCTRLStaticTextFOFB03'),'String',sprintf('03 ____'),'ForegroundColor',[0 0 0]);
            set(findobj(gcbf,'Tag','SRCTRLStaticTextFOFB04'),'String',sprintf('04 ____'),'ForegroundColor',[0 0 0]);
            set(findobj(gcbf,'Tag','SRCTRLStaticTextFOFB05'),'String',sprintf('05 ____'),'ForegroundColor',[0 0 0]);
            set(findobj(gcbf,'Tag','SRCTRLStaticTextFOFB06'),'String',sprintf('06 ____'),'ForegroundColor',[0 0 0]);
            set(findobj(gcbf,'Tag','SRCTRLStaticTextFOFB07'),'String',sprintf('07 ____'),'ForegroundColor',[0 0 0]);
            set(findobj(gcbf,'Tag','SRCTRLStaticTextFOFB08'),'String',sprintf('08 ____'),'ForegroundColor',[0 0 0]);
            set(findobj(gcbf,'Tag','SRCTRLStaticTextFOFB09'),'String',sprintf('09 ____'),'ForegroundColor',[0 0 0]);
            set(findobj(gcbf,'Tag','SRCTRLStaticTextFOFB10'),'String',sprintf('10 ____'),'ForegroundColor',[0 0 0]);
            set(findobj(gcbf,'Tag','SRCTRLStaticTextFOFB11'),'String',sprintf('11 ____'),'ForegroundColor',[0 0 0]);
            set(findobj(gcbf,'Tag','SRCTRLStaticTextFOFB12'),'String',sprintf('12 ____'),'ForegroundColor',[0 0 0]);

            %pause(0);

        catch
            fprintf('   %s \n',lasterr);
            % GUI must have been closed

        end


        % Reset Bergoz BPM time constant to whatever it was before feedback started
        fprintf('   Bergoz BPM time constant set back to %.1f\n', BPMtimeconstantOFB);
        setbpmtimeconstant(BPMtimeconstantOFB);


        a = clock;
        fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
        [StateNumber, StateString] = getsrstate;
        if StateNumber >= 0
            setpv('SR_STATE',5.1);
            [StateNumber, StateString] = getsrstate;
            set(findobj(gcbf,'Tag','SRCTRLStaticTextInformation'),'String',StateString,'ForegroundColor','b');
            fprintf('   ******************************\n');
            fprintf('   **  Orbit Feedback Stopped  **\n');
            fprintf('   ******************************\n\n');
        else
            [StateNumber, StateString] = getsrstate;
            set(findobj(gcbf,'Tag','SRCTRLStaticTextInformation'),'String',StateString,'ForegroundColor','r');
            fprintf('   ****************************************\n');
            fprintf('   **  Problem With Slow Orbit Feedback  **\n');
            fprintf('   ****************************************\n\n');
        end
        set(0,'showhiddenhandles','off');
        pause(0);


    case 'FeedbackSetup'
        InitFlag = Input2;           % Input #2: if InitFlag, then initialize variables

        if InitFlag
            
           
            % Get the device lists from oscsinit and convert to srcontrol variables
            [HBPM, VBPM, HCM, VCM, HSV, VSV] = ocsinit('SOFB');
            Xivec = 1:HSV;
            Yivec = 1:VSV;
            BPMlist1 = HBPM.DeviceList;
            HCMlist1 = HCM.DeviceList;
            VCMlist1 = VCM.DeviceList;           
            
            
            OCSx.BPM = getx(BPMlist1, 'struct');
            OCSx.CM = getsp('HCM', HCMlist1, 'struct');
            OCSx.GoalOrbit = getgolden(OCSx.BPM, 'numeric');
            OCSx.NIter = 1;
            OCSx.SVDIndex = Xivec;
            OCSx.IncrementalFlag = 'No';
            OCSx.BPMWeight = {[]};
            OCSx.FitRF = 0;
            OCSy.BPM = gety(BPMlist1, 'struct');
            OCSy.CM = getsp('VCM', VCMlist1, 'struct');
            OCSy.GoalOrbit = getgolden(OCSy.BPM, 'numeric');
            OCSy.NIter = 1;
            OCSy.SVDIndex = Yivec;
            OCSy.IncrementalFlag = 'No';
            OCSy.BPMWeight = {[]};
            OCSy.FitRF = 0;
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % do we need these Smat calls? %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            SXmat = getrespmat(OCSx.BPM, OCSx.CM, 'numeric', SR_GEV);
            SYmat = getrespmat(OCSy.BPM, OCSy.CM, 'numeric', SR_GEV);
            % [OCSx, Sx, Ux, Vx] = orbitcorrectionmethods(OCSx, SXmat);
            % [OCSy, Sy, Uy, Vy] = orbitcorrectionmethods(OCSy, SYmat);

            % initialize FFTypeFlag
            FFTypeFlag = 'Global';

            % Fit decision comes from check box
            if get(findobj(gcbf,'Tag','SRCTRLCheckboxRF'),'Value') == 1
                OCSx.FitRF = 1;
                Xivec = 1:HSV+1;
            end
        
        else

            % Get vectors
            FB = get(findobj(gcbf,'Tag','SRCTRLButtonFeedbackSetup'),'Userdata');
            % the two lines below seem to fix BPMlist editing problem
            OCSx = FB.OCSx;
            OCSy = FB.OCSy;
            BPMlist1 = FB.BPMlist1;
            HCMlist1 = FB.HCMlist1;
            VCMlist1 = FB.VCMlist1;
            Xivec = FB.Xivec;
            Yivec = FB.Yivec;
            Xgoal = FB.OCSx.GoalOrbit;
            OCSx.GoalOrbit = Xgoal;
            Ygoal = FB.OCSy.GoalOrbit;
            OCSy.GoalOrbit = Ygoal;
            FFTypeFlag = FB.FFTypeFlag;


            % FF corrector magnet list - only channels which are blocked when FF is running should be
            % listed
            ListFF = [
                4     2
                4     8
                5     1
                5     7
%               5     8 % IVID is using digital FF, i.e. FF algorithm does not block
%               6     1 % other access to PVs
                6     8
                7     1
                7     8
                8     1
                8     8
                9     1
                9     8
                10    1
                11    8
                12    1];
            ElemFF = dev2elem('HCM',ListFF);


            % Add button to change #ivectors, cm, IDBPMs,
            EditFlag = 0;
            h_fig1 = figure;
            while EditFlag ~= 6

                Sx = getrespmat('BPMx', BPMlist1, 'HCM', HCMlist1, [], SR_GEV);
                Sy = getrespmat('BPMy', BPMlist1, 'VCM', VCMlist1, [], SR_GEV);
                
                if get(findobj(gcbf,'Tag','SRCTRLCheckboxRF'),'Value') == 1
                    DispOrbit = getdisp('BPMx', BPMlist1);
                    Sx = [Sx DispOrbit];
                end
                
                Sx(isnan(Sx)) = 0;
                Sy(isnan(Sy)) = 0;
                
                [Ux, SVx, Vx] = svd(Sx);
                [Uy, SVy, Vy] = svd(Sy);

                
                % Remove singular values greater than the actual number of singular values
                i = find(Xivec>length(diag(SVx)));
                if ~isempty(i)
                    disp('   Horizontal E-vector scaled since there were more elements in the vector than singular values.');
                    pause(0);
                    Xivec(i) = [];
                end
                i = find(Yivec>length(diag(SVy)));
                if ~isempty(i)
                    disp('   Vertical E-vector scaled since there were more elements in the vector than singular values.');
                    pause(0);
                    Yivec(i) = [];
                end


                Ax = Sx*Vx(:,Xivec);
                Tx = inv(Ax'*Ax)*Ax';

                Ay = Sy*Vy(:,Yivec);
                Ty = inv(Ay'*Ay)*Ay';

                figure(h_fig1);
                subplot(2,1,1);
                semilogy(diag(SVx),'b');
                hold on;
                semilogy(diag(SVx(Xivec,Xivec)),'xr');
                ylabel('Horizontal');
                title('Response Matrix Singular Values');
                hold off;
                subplot(2,1,2);
                semilogy(diag(SVy),'b');
                hold on;
                semilogy(diag(SVy(Yivec,Yivec)),'xr');
                xlabel('Singular Value Number');
                ylabel('Vertical');
                hold off;
                drawnow;

                EditFlag = menu('Change Parameters?','Singular Values','HCM List','VCM List', ...
                    'BPM List','Change the Goal Orbit','Continue');

                if EditFlag == 1
                    prompt={'Enter the horizontal E-vector numbers (Matlab vector format):','Enter the vertical E-vector numbers (Matlab vector format):'};
                    def={sprintf('[%d:%d]',1,Xivec(end)),sprintf('[%d:%d]',1,Yivec(end))};
                    titlestr='SVD Orbit Feedback';
                    lineNo=1;
                    answer=inputdlg(prompt,titlestr,lineNo,def);
                    if ~isempty(answer)
                        XivecNew = fix(str2num(answer{1}));
                        if isempty(XivecNew)
                            disp('   Horizontal E-vector cannot be empty.  No change made.');
                        else
                            if any(XivecNew<=0) || max(XivecNew)>length(diag(SVx))
                                disp('   Error reading horizontal E-vector.  No change made.');
                            else
                                Xivec = XivecNew;
                            end
                        end
                        YivecNew = fix(str2num(answer{2}));
                        if isempty(YivecNew)
                            disp('   Vertical E-vector cannot be empty.  No change made.');
                        else
                            if any(YivecNew<=0) || max(YivecNew)>length(diag(SVy))
                                disp('   Error reading vertical E-vector.  No change made.');
                            else
                                Yivec = YivecNew;
                            end
                        end
                    end
                end

                if EditFlag == 2
                    List= getlist('HCM','Trim');
                    CheckList = zeros(96,1);
                    Elem = dev2elem('HCM', HCMlist1);
                    CheckList(Elem) = ones(size(Elem));
                    CheckList = CheckList(dev2elem('HCM',List));

                    % Remove FF corrrectors
                    %           Elem = dev2elem('HCM',List);
                    %           for j = length(ElemFF):-1:1
                    %              i = find(Elem==ElemFF(j));
                    %              Elem(i,:) = [];
                    %              List(i,:) = [];
                    %              CheckList(i,:) = [];
                    %           end

                    newList = editlist(List, 'HCMtrim', CheckList);

                    if isempty(newList)
                        fprintf('   WARNING: Horizontal corrector magnet list is empty!\n');
                        HCMlist1 = newList;
                    else
                        HCMlist1 = newList;
                    end
                    OCSx.CM.DeviceList = HCMlist1;
                end

                if EditFlag == 3
                    List = getlist('VCM','Trim');
                    CheckList = zeros(96,1);
                    Elem = dev2elem('VCM', VCMlist1);
                    CheckList(Elem) = ones(size(Elem));
                    CheckList = CheckList(dev2elem('VCM',List));

                    % Remove FF corrrectors
                    %           Elem = dev2elem('VCM',List);
                    %           for j = length(ElemFF):-1:1
                    %              i = find(Elem==ElemFF(j));
                    %              Elem(i,:) = [];
                    %              List(i,:) = [];
                    %              CheckList(i,:) = [];
                    %           end

                    newList = editlist(List, 'VCMtrim', CheckList);

                    if isempty(newList)
                        fprintf('   WARNING: Vertical corrector magnet list is empty!\n');
                        VCMlist1 = newList;
                    else
                        VCMlist1 = newList;
                    end
                    OCSy.CM.DeviceList = VCMlist1;
                end

                if EditFlag == 4
                    ListOld = BPMlist1;
                    XgoalOld = Xgoal;
                    YgoalOld = Ygoal;

                    % Full BPM list
                    List = getbpmlist('Bergoz');

                    CheckList = zeros(size(List,1),1);
                    if ~isempty(BPMlist1)
                        for i = 1:size(List,1)
                            k = find(List(i,1)==BPMlist1(:,1));
                            l = find(List(i,2)==BPMlist1(k,2));

                            if isempty(k) || isempty(l)
                                % Item not in list
                            else
                                CheckList(i) = 1;
                            end
                        end
                    end

                    newList = editlist(List, 'BPM', CheckList);
                    if isempty(newList)
                        fprintf('   BPM list cannot be empty.  No change made.\n');
                    else
                        BPMlist1 = newList;
                    end

                    % Set the goal orbit to the golden orbit
                    Xgoal = getgolden('BPMx', BPMlist1);
                    Ygoal = getgolden('BPMy', BPMlist1);


                    % If a new BPM is added, then set the goal orbit to the golden orbit
                    for i = 1:size(BPMlist1,1)

                        % Is it a new BPM?
                        k = find(BPMlist1(i,1)==ListOld(:,1));
                        l = find(BPMlist1(i,2)==ListOld(k,2));

                        if isempty(k) || isempty(l)
                            % New BPM
                        else
                            % Use the old value for old BPM
                            Xgoal(i) = XgoalOld(k(l));
                            Ygoal(i) = YgoalOld(k(l));
                        end
                    end
                    OCSx.BPM.DeviceList = BPMlist1;
                    OCSy.BPM.DeviceList = BPMlist1;
                    OCSx.GoalOrbit = Xgoal;
                    OCSy.GoalOrbit = Ygoal;
                end

                if EditFlag == 5
                    ChangeList = editlist2(BPMlist1, 'Change BPM', zeros(size(BPMlist1,1),1));

                    for i = 1:size(ChangeList,1)

                        k = find(ChangeList(i,1)==BPMlist1(:,1));
                        l = find(ChangeList(i,2)==BPMlist1(k,2));

                        prompt={sprintf('Enter the new horizontal goal orbit for BPMx(%d,%d):',BPMlist1(k(l),1),BPMlist1(k(l),2)),sprintf('Enter the new vertical goal orbit for BPMy(%d,%d):',BPMlist1(k(l),1),BPMlist1(k(l),2))};
                        def={sprintf('%f',Xgoal(k(l))),sprintf('%f',Ygoal(k(l)))};
                        titlestr='CHANGE THE GOAL ORBIT';
                        lineNo=1;
                        answer = inputdlg(prompt, titlestr, lineNo, def);

                        if isempty(answer)
                            % No change
                            fprintf('   No change was made to the golden orbit.\n');
                        else
                            Xgoalnew = str2num(answer{1});
                            if isempty(Xgoalnew)
                                fprintf('   No change was made to the horizontal golden orbit.\n');
                            else
                                Xgoal(k(l)) = Xgoalnew;
                            end

                            Ygoalnew = str2num(answer{2});
                            if isempty(Ygoalnew)
                                fprintf('   No change was made to the vertical golden orbit.\n');
                            else
                                Ygoal(k(l)) = Ygoalnew;
                            end
                        end
                    end
                    if ~isempty(ChangeList)
                        fprintf('   Note:  Changing the goal orbit for "Slow Orbit Feedback" does not change the goal orbit for "Orbit Correction."\n');
                        fprintf('          Re-running srcontrol will restart the goal orbit to the golden orbit."\n');
                    end
                    OCSx.GoalOrbit = Xgoal;
                    OCSy.GoalOrbit = Ygoal;
                end

%                 if EditFlag == 6
%                     FFTypeFlag = questdlg(sprintf('Do you want to use a fully local or a combined local/global compensation of IDs? (nuy=9.2 only)'),'Tune FF','Local','Global', 'Global');
%                     if strcmp(FFTypeFlag,'Local')
%                         disp(['   The tune FF will use 8 local quadrupoles to compensate beta beating and tune shift']);
%                         disp(['   from each ID.']);
%                     elseif strcmp(FFTypeFlag,'Global')
%                         disp(['   The tune FF will use 4 local quadrupoles to compensate beta beating and all QF+QD']);
%                         disp(['   to compensate tune shift from each ID.']);
%                     end
%                 end

            end
            close(h_fig1);
        end

        % Save vectors
        FB.Xivec = Xivec;
        FB.Yivec = Yivec;
        FB.HCMlist1 = HCMlist1;
        FB.VCMlist1 = VCMlist1;
        FB.BPMlist1 = BPMlist1;

        OCSx.SVDIndex = Xivec;
        OCSy.SVDIndex = Yivec;
        FB.OCSx = OCSx;
        FB.OCSy = OCSy;

        FB.FFTypeFlag = FFTypeFlag;
        set(findobj(gcbf,'Tag','SRCTRLButtonFeedbackSetup'),'Userdata',FB);


    case 'FastFeedbackSetup'

        InitFlag = Input2;

        if InitFlag
            FOFBFreq = 1000;
            % user operations 9/14-10/17/04: P=0.5, I=120, D=0.0015 (for both planes)
            % below are known good values for user ops as of 8-1-05
            HorP = 2;
            HorI = 300;
            HorD = 0.002;
            VertP = 1;
            VertI = 100;
            VertD = 0.0015;

            % this initial set is now done in hwinit.m because it's not a good idea to set anything when srcontrol is launched
            % try
            %     setsp('SR01____FFBFREQAC00', FOFBFreq); % set freq
            %     write_pid_ffb2_patch(HorP, HorI, HorD, VertP, VertI, VertD);
            % catch
            %     fprintf('   %s \n',lasterr);
            %     disp('   Trouble setting Fast Orbit Feedback parameters!');
            % end

        else
            % Get vectors
            FOFB = get(findobj(gcbf,'Tag','SRCTRLButtonFastFeedbackSetup'),'Userdata');
            FOFBFreq = FOFB.FOFBFreq;
            HorP  = FOFB.HorP;
            HorI  = FOFB.HorI;
            HorD  = FOFB.HorD;
            VertP = FOFB.VertP;
            VertI = FOFB.VertI;
            VertD = FOFB.VertD;

            % Add button to change #ivectors, CMs, IDBPMs,
            EditFlag = 0;
            %h_fig1 = figure;
            while EditFlag ~= 3

                %EditFlag = menu('Change Parameters?', 'Fast Feedback Frequency', 'PID Values', 'HCM List', 'VCM List', ...
                %   'IDBPM List', 'BBPM List', 'Continue');
                % Use menu below until other FFB config routines work (then also uncomment options 3,4,5,6 below)
                EditFlag = menu('Change Parameters?', 'Fast Feedback Frequency', 'PID Values', 'Continue');

                if EditFlag == 1
                    % change rate

                    prompt={'Enter the desired Fast Feedback Frequency (1-1000 Hz)'};
                    def={num2str(FOFBFreq)};
                    titlestr='Fast Feedback Setup';
                    lineNo=1;
                    answer=inputdlg(prompt,titlestr,lineNo,def);
                    if ~isempty(answer)
                        FOFBFreq = fix(str2num(answer{1}));
                        if isempty(FOFBFreq)
                            disp('   Frequency value cannot be empty.  No change made.');
                            FOFBFreq = getsp('SR01____FFBFREQAC00');
                        else
                            if FOFBFreq < 1 || FOFBFreq > 1000
                                disp('   Frequency must be between 1 and 1000 Hz.  No change made.');
                                FOFBFreq = getsp('SR01____FFBFREQAC00');
                            end
                        end
                        setsp('SR01____FFBFREQAC00',FOFBFreq   ); % change freq
                        pause(0.5);
                        fprintf('   Fast orbit feedback frequency is running at %.0f Hz.\n', getpv('SR01____FFBFREQAM00'));
                    else
                        FOFBFreq = getsp('SR01____FFBFREQAC00');
                    end
                end

                if EditFlag == 2
                    % edit  PIDs
                    % User defaults are HorP=2, HorI=300, HorD=0.002, VertP=1, VertI=100, VertD=0.0015
                    prompt={'P horizontal', 'I horizontal', 'D horizontal', 'P vertical', 'I vertical', 'D vertical'};
                    def={num2str(HorP), num2str(HorI), num2str(HorD), num2str(VertP), num2str(VertI), num2str(VertD)};
                    titlestr='Fast Feedback PID Setup';
                    lineNo=1;
                    answer=inputdlg(prompt,titlestr,lineNo,def);
                    if ~isempty(answer)
                        HorPnewnum = str2num(answer{1});
                        if isempty(HorPnewnum)
                            disp('   HorP value cannot be empty.  No change made.');
                        else
                            HorP = HorPnewnum;
                        end
                        HorInewnum = str2num(answer{2});
                        if isempty(HorInewnum)
                            disp('   HorI value cannot be empty.  No change made.');
                        else
                            HorI = HorInewnum;
                        end
                        HorDnewnum = str2num(answer{3});
                        if isempty(HorDnewnum)
                            disp('   HorD value cannot be empty.  No change made.');
                        else
                            HorD = HorDnewnum;
                        end
                        VertPnewnum = str2num(answer{4});
                        if isempty(VertPnewnum)
                            disp('   VertP value cannot be empty.  No change made.');
                        else
                            VertP = VertPnewnum;
                        end
                        VertInewnum = str2num(answer{5});
                        if isempty(VertInewnum)
                            disp('   VertI value cannot be empty.  No change made.');
                        else
                            VertI = VertInewnum;
                        end
                        VertDnewnum = str2num(answer{6});
                        if isempty(VertDnewnum)
                            disp('   VertD value cannot be empty.  No change made.');
                        else
                            VertD = VertDnewnum;
                        end

                        try
                            write_pid_ffb2_patch(HorP, HorI, HorD, VertP, VertI, VertD);
                            fprintf('   Setting FFB gains to Horizontal P=%.2f, I=%.1f, D=%.4f;  Vertical P=%.2f, I=%.1f, D=%.4f\n', HorP, HorI, HorD, VertP, VertI, VertD);
                        catch
                            fprintf('   %s \n',lasterr);
                            disp('   Trouble setting Fast Orbit Feedback parameters!');
                        end
                    end
                end

                %if EditFlag == 3
                %   disp('   This function not yet available.');
                %   % change HCM List
                %end
                %
                %if EditFlag == 4
                %   disp('   This function not yet available.');
                %   % change VCM List
                %end
                %
                %if EditFlag == 5
                %   disp('   This function not yet available.');
                %   % change IDBPM List
                %end
                %
                %if EditFlag == 6
                %   disp('   This function not yet available.');
                %   % change BBPM List
                %end

            end
            %close(h_fig1);
        end

        % Save vectors
        FOFB.FOFBFreq = FOFBFreq;
        FOFB.HorP = HorP;
        FOFB.HorI = HorI;
        FOFB.HorD = HorD;
        FOFB.VertP = VertP;
        FOFB.VertI = VertI;
        FOFB.VertD = VertD;
        set(findobj(gcbf,'Tag','SRCTRLButtonFastFeedbackSetup'),'Userdata',FOFB);

    otherwise
        fprintf('   No action for %s.\n', action);
end   % end case