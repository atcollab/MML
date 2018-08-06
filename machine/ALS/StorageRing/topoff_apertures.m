function BL = topoff_apertures(BLNumber, ExtremeRay, LineColorInput, LineWidth, DimFlag, PhaseSpaceFlag)
%TOPOFF_APERTURES - Phase space information on the BL Dot-3 ports
%  BL = topoff_apertures(BLNumber, ExtremeRay, LineColor, LineWidth, DimFlag, PhaseSpaceFlag)
%
%  INPUTS
%  1. BLNumber - Beamline number
%                For scalar BLNumber, only the middle port number is compared.
%                For 2 element vector, sector and middle port number are compared.
%                For 3 element vector, sector, middle port, sub-port numbers are compared.
%                Empty to plot all beamlines
%                Special case strings: 'BL0', 'BL1', 'BL2', 'BL3', 'SB_BL2', 'SB_BL3'
%
%                For instance,
%                1. BLNumber = [6 3 2] for sector 6, dot-3, dot 2
%                2. BLNumber = 2 is all dot-2 ports
%                3. BLNumber = [6 2] is all sector 6, dot-2 ports
%  2. ExtremeRay - error in mm for the beamline apertures
%                  0 for nominal (no errors)
%                  2 is the default
%  3. LineColor - Line color if plotting only 1 beamline
%  4. LineWidth - Line width if plotting only 1 beamline
%  5. DimFlag - choose 3 to have aperture lines plot on top of phase space plots
%  6. PhaseSpaceFlag - normally 2 to use 2mm as extreme rays
%
%  OUTPUTS
%  1. BL - Structure array for all the beamlines
%          (plots data if no output exists)
%
%  EXAMPLES
%  1.  Data = topoff_plottrackingfile;
%      hold on
%      topoff_apertures([],2,'k',1,3);
%      xaxis([.23 .415]);
%      yaxis([.16 .29]);
%
%  2. 3.3.2 area of concern
%     xaxis([.295 .32]);
%     yaxis([.175 .205]);
%
%  3. Output for Mike
%     BL = topoff_apertures;
%     for i = 1:length(Data)
%         fprintf('  %s\n', BL(i).Title);
%         fprintf('       Nominal                2mm                  5 mm\n');
%         fprintf('  %f %f    %f %f    %f %f\n', [BL(i).Data0', BL(i).Data', BL(i).Data1']')
%         fprintf('\n');
%     end
%
%  See also topoff_plottrackingfile, topoff_readtrackingfile, topoff_fieldprofiles


% Example: Compare survey to original
% BL = [3 3 1];
% topoff_apertures(BL, 2, 'b', 2, 1, 0);
% hold on
% topoff_apertures(BL, 2, 'g', 2, 1, 2);
% legend('Original','Survey');


% Which phase space to use?
%  0 -> Original BL (based on drawings)
%  1 -> modified / proposed BL (if it exists, otherwise use 0)
%  2 -> survey data            (if it exists, otherwise use 1)
if nargin < 6
    PhaseSpaceFlag = 2;
end

fprintf('PhaseSpaceFlag = %d \n',PhaseSpaceFlag);

% Get all BL apertures
BL = getblapertures(PhaseSpaceFlag);


if nargin < 2
    ExtremeRay = 2;
end


if nargin < 1
    BLNumber = [];
end
if any(strcmpi(BLNumber, {'SB_BL2'}))
    for i = length(BL):-1:1
        if BL(i).Number(2) ~= 2 || any(BL(i).Number(1)==[1 2 3 5 6 7 9 10 11])
            BL(i) = [];
        end
    end
elseif any(strcmpi(BLNumber, {'SB_BL3'}))
    for i = length(BL):-1:1
        if BL(i).Number(2) ~= 3 || any(BL(i).Number(1)==[1 2 3 5 6 7 9 10 11])
            BL(i) = [];
        end
    end
elseif any(strcmpi(BLNumber, {'BL0'}))
    for i = length(BL):-1:1
        if BL(i).Number(2) ~= 0
            BL(i) = [];
        end
    end
elseif any(strcmpi(BLNumber, {'BL1'}))
    for i = length(BL):-1:1
        if BL(i).Number(2) ~= 1
            BL(i) = [];
        end
    end
elseif any(strcmpi(BLNumber, {'BL2'}))
    for i = length(BL):-1:1
        if BL(i).Number(2) ~= 2 || any(BL(i).Number(1)==[4 8 12])
            BL(i) = [];
        end
    end
elseif any(strcmpi(BLNumber, {'BL3'}))
    for i = length(BL):-1:1
        if BL(i).Number(2) ~= 3 || any(BL(i).Number(1)==[4 8 12])
            BL(i) = [];
        end
    end
else
    % Find the set of beamlines based on BLNumber input
    if ~isempty(BLNumber)
        j = 0;
        for i = 1:length(BL)
            if length(BLNumber) == 1
                if BLNumber == BL(i).Number(2)
                    j = j + 1;
                    BLnew(1,j) = BL(i);
                end
            else
                if all(BLNumber == BL(i).Number(1:size(BLNumber,2)))
                    j = j + 1;
                    BLnew(1,j) = BL(i);
                end
            end
        end
        if exist('BLnew', 'var')
            BL = BLnew;
        else
            BL = [];
        end
    end
end


% Interpolate to the requested error level
for i = 1:length(BL)
    if all(BL(i).Number == [9 3 1])
        % BL 9.3.1 data is only valid at the 2 mm extreme ray.
        if ExtremeRay ~= BL(i).ExtremeRay1
            error('BL 9.3.1 data is only valid at the 2 mm extreme ray');
        end
    else
        BL(i).Data(1,:) = interp1([0; BL(i).ExtremeRay1], [BL(i).Data0(1,:); BL(i).Data1(1,:)], ExtremeRay, 'linear', 'extrap');
        BL(i).Data(2,:) = interp1([0; BL(i).ExtremeRay1], [BL(i).Data0(2,:); BL(i).Data1(2,:)], ExtremeRay, 'linear', 'extrap');
        BL(i).ExtremeRay = ExtremeRay;
    end
end


if nargout == 0
    if nargin < 3
        LineColorInput = [];
    end
    
    if nargin < 4
        LineWidth = 3;
    end
    %LineWidth = 2;
    
    if nargin < 5
        if length(axis)==6
            DimFlag = 3;
        else
            DimFlag = 2;
        end
    end
    
    % For B&W plots
    BWFlag = 0;
    Markers = {'.','o','x','*','s','d','v','p','^','x','<','h','>'};
    
    %clf reset
    NextPlot = get(gca,'NextPlot');
    for i = 1:length(BL)
        LegendCell{i} = BL(i).Title;
        if nargin < 3 || isempty(LineColorInput)
            [LineColor, LineStyle] = nextline(i);
        else
            LineColor = LineColorInput;
            %LineColor = 'k'; %[0 0 .5];
            LineStyle = '-';
        end
        if BWFlag
            h(i) = plotphase1(BL(i), 'k', LineWidth, DimFlag);
            %set(h(i), 'Marker', Markers{i});
        else
            h(i) = plotphase1(BL(i), LineColor, LineWidth, DimFlag);
            set(h(i), 'LineStyle', LineStyle);
        end
        hold on
    end
    %hold off;
    set(gca,'NextPlot', NextPlot);
    
    %       xaxis([.23 .415]);
    %       yaxis([.16 .29]);
    
    % h(1) = plotphase1(BL(1), [0 0 1]);
    % hold on
    % h(2) = plotphase1(BL(2), [0 .8 0]);
    % h(3) = plotphase1(BL(3), [1 0 0]);
    % h(4) = plotphase1(BL(4), [1 1 0]);
    % h(5) = plotphase1(BL(5), [0 1 1]);
    % h(6) = plotphase1(BL(6), [.2 .2 .2]);
    % h(7)  = plotphase1(BL(7),  [1 0 1]);
    % h(8)  = plotphase1(BL(8),  [.4 0 0]);
    % h(9)  = plotphase1(BL(9),  [.4 .1 .5]);
    % h(10) = plotphase1(BL(10), [0 .5 .5]);
    % h(11) = plotphase1(BL(11), [0 .5 .5]);
    % h(12) = plotphase1(BL(12), [0 .5 .5]);
    % hold off;
    
    if (nargin < 3 || isempty(LineColorInput)) && ~isempty(BL)
        %title('Dot-3 Beamline Phase Space');
        xlabel('Meters');
        ylabel('Radians');
        legend(LegendCell, 0);
    end
end


function h = plotphase1(BL, LineColor, LineWidth, DimFlag)

if nargin < 2
    LineColor = [0 0 1];
end
if nargin < 3
    LineWidth = 3;
end
if nargin < 4
    if length(axis)==6
        DimFlag = 3;
    else
        DimFlag = 2;
    end
end

BL.Data

if DimFlag == 3
    h = plot3([BL.Data(1,:) BL.Data(1,1)], [BL.Data(2,:) BL.Data(2,1)],200*ones(1,length(BL.Data(1,:))+1), 'Color', LineColor, 'LineWidth',LineWidth, 'EraseMode', 'Background');
    %h = plot3([BL.Data(1,:) BL.Data(1,1)], [BL.Data(2,:) BL.Data(2,1)],25*ones(1,5), 'Color', LineColor, 'LineWidth',LineWidth);
else
    h = plot([BL.Data(1,:) BL.Data(1,1)], [BL.Data(2,:) BL.Data(2,1)],'Color', LineColor, 'LineWidth',LineWidth);
    
    if 0
        % Marker at corners (usually for debuging)
        hold on
        plot(BL.Data(1,1), BL.Data(2,1),'Color', LineColor, 'Marker','o');
        plot(BL.Data(1,2), BL.Data(2,2),'Color', LineColor, 'Marker','square');
        plot(BL.Data(1,3), BL.Data(2,3),'Color', LineColor, 'Marker','>');
        %plot(BL.Data(1,4), BL.Data(2,4),'Color', LineColor, 'Marker','x');
        hold off
    end
    if 0
        % Plot the nominal and extreme (usually for debuging)
        hold on
        plot([BL.Data0(1,:) BL.Data0(1,1)], [BL.Data0(2,:) BL.Data0(2,1)],':', 'Color', LineColor, 'LineWidth',1);
        plot([BL.Data1(1,:) BL.Data1(1,1)], [BL.Data1(2,:) BL.Data1(2,1)],':', 'Color', LineColor, 'LineWidth',1);
        hold off
    end
end
%text(BL.Data(1,1), BL.Data(2,1), BL.Title);


% h = patch(BL.Data(1,:), BL.Data(2,:), LineColor);
% set(h, 'EraseMode', 'XOR');


function BL = getblapertures(PhaseSpaceFlag)

i = 0;

% BL 2.0 - Nominal Rays for final GEMINI design
% Data from M.Kritscher 6-6-17
i = i + 1;
BL(i).Title = 'BL 2.0';
BL(i).Number = [2 0 0];
BL(i).Data0 = [
    0.427267, 0.17950
    0.434131, 0.17265
    0.441777, 0.16957
    0.434928, 0.17642
    ]';

% Extreme Rays 2mm
BL(i).Data1 = [
    0.422484, 0.18224
    0.432099, 0.17265
    0.446539, 0.16683
    0.436959, 0.17642

    ]';
BL(i).ExtremeRay1 = 2;  % mm

% % BL 2.0 - Nominal Rays for final GEMINI design
% % Data from M.Kritscher 12-4-15
% i = i + 1;
% BL(i).Title = 'BL 2.0';
% BL(i).Number = [2 0 0];
% BL(i).Data0 = [
%     0.428469, 0.1783
%     0.432929, 0.17385
%     0.440579, 0.17077
%     0.436128, 0.17522
%     ]';
% 
% % Extreme Rays 2mm
% BL(i).Data1 = [
%     0.423688, 0.18104
%     0.430899, 0.17385
%     0.445343, 0.16803
%     0.438159, 0.17522
%     ]';
% BL(i).ExtremeRay1 = 2;  % mm

% % BL 2.0 - Nominal Rays
% % Data from M.Kritscher 4-1-15
% i = i + 1;
% BL(i).Title = 'BL 2.0';
% BL(i).Number = [2 0 0];
% BL(i).Data0 = [
%     0.422685, 0.18403
%     0.429874, 0.18143
%     0.446326, 0.16498
%     0.439167, 0.16758
%     ]';
% 
% % Extreme Rays 2mm
% BL(i).Data1 = [
%     0.418323, 0.18635
%     0.431907, 0.18143
%     0.450657, 0.16267
%     0.437138, 0.16758
%     ]';
% BL(i).ExtremeRay1 = 2;  % mm


if PhaseSpaceFlag == 0
    % Present data
    % BL 2.1 - Nominal Rays
    i = i + 1;
    BL(i).Title = 'BL 2.1';
    BL(i).Number = [2 1 1];
    BL(i).Data0 = [
        0.27540, 0.23729
        0.28955, 0.23469
        0.31292, 0.21901
        0.29884, 0.22161
        ]';
    
    % Extreme Rays 5mm
    BL(i).Data1 = [
        0.26634, 0.23990
        0.29481, 0.23467
        0.32190, 0.21641
        0.29372, 0.22161
        ]';
    BL(i).ExtremeRay1 = 5;  % mm
else
    % BL 2.1 - Nominal Rays
    % Old data
    % i = i + 1;
    % BL(i).Title = 'BL 2.1';
    % BL(i).Number = [2 1 1];
    % BL(i).Data0 = [
    %     0.27625, 0.23908
    %     0.29051, 0.23647
    %     0.31527, 0.21998
    %     0.30109, 0.22259
    %     ]';
    %
    % % Extreme Rays 5mm
    % BL(i).Data1 = [
    %     0.26716, 0.24168
    %     0.29565, 0.23647
    %     0.32427, 0.21739
    %     0.29596, 0.22259
    %     ]';
    % BL(i).ExtremeRay1 = 5;  % mm
    
    % BL 2.1 - Nominal Rays
    % New data based on beamline survey as of 2008-04-04 plus proposed aperture
    % i = i + 1;
    % BL(i).Title = 'BL 2.1';
    % BL(i).Number = [2 1 1];
    % BL(i).Data0 = [
    %     0.27425, 0.23806
    %     0.28855, 0.23536
    %     0.30584, 0.22377
    %     0.29159, 0.22647
    %     ]';
    %
    % % Extreme Rays 5mm
    % BL(i).Data1 = [
    %     0.26503, 0.24077
    %     0.29369, 0.23536
    %     0.31499, 0.22106
    %     0.28646, 0.22647
    %     ]';
    % BL(i).ExtremeRay1 = 5;  % mm
    
    % BL 2.1 - Nominal Rays
    % New data based on beamline survey as of 2008-04-30 plus proposed aperture
    i = i + 1;
    BL(i).Title = 'BL 2.1';
    BL(i).Number = [2 1 1];
    BL(i).Data0 = [
        0.27539, 0.23730
        0.28969, 0.23459
        0.30584, 0.22377
        0.29159, 0.22647
        ]';
    
    % Extreme Rays 5mm
    BL(i).Data1 = [
        0.26618, 0.24001
        0.29483, 0.23459
        0.31500, 0.22106
        0.28646, 0.22647
        ]';
    BL(i).ExtremeRay1 = 5;  % mm
end


if PhaseSpaceFlag == 0 || PhaseSpaceFlag == 1
    % Original data based on Mike Kritscher Drawing
    % BL 3.2.1 - Nominal Rays
    i = i + 1;
    BL(i).Title = 'BL 3.2.1';
    BL(i).Number = [3 2 1];
    BL(i).Data0 = [
        0.61737,0.33184;
        0.6536,0.32133;
        0.65845,0.29775;
        0.62252,0.30813;
        ]';
    
    % Extreme Rays 5mm
    BL(i).Data1 = [
        0.61135,0.33511;
        0.65887,0.32134;
        0.66432,0.29454;
        0.61727,0.30814;
        ]';
    BL(i).ExtremeRay1 = 5;  % mm
else
    % Temporary Data using survey results based on Alexis spreadsheet from
    % 20080926
    % Entered by Christoph Steier, 20080928
    
    % BL 3.2.1 - Nominal Rays
    i = i + 1;
    BL(i).Title = 'BL 3.2.1';
    BL(i).Number = [3 2 1];
    BL(i).Data0 = [
        0.617280	0.332229
        0.653519	0.321724
        0.658366	0.298136
        0.622439	0.308520
        ]';
    
    % Extreme Rays 2mm
    BL(i).Data1 = [
        0.614877	0.333540
        0.655627	0.321726
        0.660719	0.296853
        0.620339	0.308522
        ]';
    BL(i).ExtremeRay1 = 2;  % NEW DATA from ALEXIS IS FOR 2 mm CASE!!!!!
end

% BL 3.2.2 - Nominal Rays (Unsafe, Not in use)
i = i + 1;
BL(i).Title = 'BL 3.2.2';
BL(i).Number = [3 2 2];
BL(i).Data0 = [
    0.52454,0.30824;
    0.55619,0.2993;
    0.56156,0.27636;
    0.53018,0.28518;
    ]';

% Extreme Rays 5mm
BL(i).Data1 = [
    0.5185,0.31143;
    0.56142,0.29931;
    0.56784,0.27324;
    0.52497,0.28519;
    ]';
BL(i).ExtremeRay1 = 5;  % mm


if PhaseSpaceFlag == 0 || PhaseSpaceFlag == 1
    % Original data based on Mike Kritscher Drawing
    % BL 3.3.1 - Nominal Rays
    i = i + 1;
    BL(i).Title = 'BL 3.3.1';
    BL(i).Number = [3 3 1];
    BL(i).Data0 = [
        0.3414  0.24668;
        0.37655 0.23674;
        0.39185 0.21499;
        0.357   0.22481;
        ]';
    
    % Extreme Rays 5mm
    BL(i).Data1 = [
        0.33378 0.25031
        0.38186,0.2367;
        0.39963,0.21137;
        0.35203,0.22477;
        ]';
    BL(i).ExtremeRay1 = 5;  % mm
else
    % New nominal case based on modified beam defining aperture, provided
    % by Mike Kritscher on 2015-03-05
    % Entered by Tom Scarvie, 20150422

    % BL 3.3.1 - Nominal Rays
    i = i + 1;
    BL(i).Title = 'BL 3.3.1';
    BL(i).Number = [3 3 1];
    BL(i).Data0 = [
        0.34128, 0.24703
        0.37647, 0.23703
        0.39187, 0.21514
        0.35697, 0.22501
        ]';
    
    % Extreme Rays 2mm
    BL(i).Data1 = [
        0.33816, 0.24850
        0.37853, 0.23703
        0.39492, 0.21370
        0.35492, 0.22502
        ]';
    BL(i).ExtremeRay1 = 2;  % DATA from Mike IS FOR 2 mm CASE

% Case below based on modified beam defining aperture, provided
% by Mike Kritscher on 2014-12-15
% Entered by Christoph Steier, 20150115
%
%     % BL 3.3.1 - Nominal Rays
%     i = i + 1;
%     BL(i).Title = 'BL 3.3.1';
%     BL(i).Number = [3 3 1];
%     BL(i).Data0 = [
%         0.34147, 0.24674
%         0.37667, 0.23674
%         0.39205, 0.21487
%         0.35716, 0.22474
%         ]';
%     
%     % Extreme Rays 2mm
%     BL(i).Data1 = [
%         0.33835, 0.24822
%         0.37872, 0.23674
%         0.39511, 0.21343
%         0.35511, 0.22474
%         ]';
%     BL(i).ExtremeRay1 = 2;  % DATA from Mike IS FOR 2 mm CASE
    
%     % Temporary Data using survey results based on Alexis spreadsheet from
%     % 20080926
%     % Entered by Christoph Steier, 20080928
%     
%     % BL 3.3.1 - Nominal Rays
%     i = i + 1;
%     BL(i).Title = 'BL 3.3.1';
%     BL(i).Number = [3 3 1];
%     BL(i).Data0 = [
%         0.339028	0.247635
%         0.374180	0.237696
%         0.389467	0.215946
%         0.354616	0.225756
%         ]';
%     
%     % Extreme Rays 2mm
%     BL(i).Data1 = [
%         0.335915	0.249102
%         0.376235	0.237699
%         0.392515	0.214515
%         0.352562	0.225758
%         ]';
%     BL(i).ExtremeRay1 = 2;  % NEW DATA from ALEXIS IS FOR 2 mm CASE!!!!!
end


if PhaseSpaceFlag == 0 || PhaseSpaceFlag == 1
    % BL 3.3.2 - Nominal Rays (Unsafe, Not in use)
    i = i + 1;
    BL(i).Title = 'BL 3.3.2';
    BL(i).Number = [3 3 2];
    BL(i).Data0 = [
        0.25642 0.22422
        0.29051 0.21486;
        0.3056  0.19388;
        0.2718  0.20312;
        ]';
    
    % Extreme Rays 5mm
    BL(i).Data1 = [
        0.24887 0.22772
        0.29579 0.21482
        0.31332 0.19039
        0.26685 0.20308
        ]';
    BL(i).ExtremeRay1 = 5;  % mm
else
    % New nominal case based on modified beam defining aperture, provided
    % by Mike Kritscher on 2015-03-05
    % Entered by Tom Scarvie, 20150422
    
    i = i + 1;
    BL(i).Title = 'BL 3.3.2';
    BL(i).Number = [3 3 2];
    BL(i).Data0 = [
        0.28089, 0.20010
        0.28262, 0.21652
        0.29781, 0.19545
        0.26556, 0.22123
        ]';
    
    % Extreme Rays 2mm
    BL(i).Data1 = [
        0.26247, 0.22265
        0.28466, 0.21652
        0.30084, 0.19406
        0.27885, 0.20010
        ]';
    BL(i).ExtremeRay1 = 2;  % New data from Mike is for 2 mm case
    
% Case below based on modified beam defining aperture, provided
% by Mike Kritscher on 2014-12-15
% Entered by Christoph Steier, 20150115
%     
%     i = i + 1;
%     BL(i).Title = 'BL 3.3.2';
%     BL(i).Number = [3 3 2];
%     BL(i).Data0 = [
%         0.26505, 0.22193
%         0.28211, 0.21722
%         0.29735, 0.19609
%         0.28043, 0.20073
%         ]';
%     
%     % Extreme Rays 2mm
%     BL(i).Data1 = [
%         0.26196, 0.22335
%         0.28415, 0.21722
%         0.30039, 0.19470
%         0.27839, 0.20074
%         ]';
%     BL(i).ExtremeRay1 = 2;  % New data from Mike is for 2 mm case
%     
end

% New data for baseline (no survey) from Alexis spreadsheet 20080926,
% old data from Mike was incorrect.
% Entered by Christoph Steier, 20080928
%
% Beamline is now within survey tolerance, therefore deleted data for
% PhaseSpaceFlag = 2, Christoph Steier, 20081005
i = i + 1;
BL(i).Title = 'BL 4.0';
BL(i).Number = [4 0 0];
BL(i).Data0 = [
    0.388984	0.202206
    0.437281	0.183071
    0.471437	0.150153
    0.423536	0.169290
    ]';

% Extreme Rays 2mm
BL(i).Data1 = [
    0.384022	0.204969
    0.439315	0.183071
    0.476309	0.147389
    0.421507	0.169290
    ]';
BL(i).ExtremeRay1 = 2;  % New data is for 2 mm case !!!


if PhaseSpaceFlag == 0
    % Current state of 4.2.2
    % 4.2.2
    i = i + 1;
    BL(i).Title = 'BL 4.2.2';
    BL(i).Number = [4 2 2];
    BL(i).Data0 = [
        0.54609, 0.30302
        0.55744, 0.29980
        0.57096, 0.28246
        0.55967, 0.28568
        ]';
    
    % Extreme Rays 5mm
    BL(i).Data1 = [
        0.53783, 0.30684
        0.56268, 0.29980
        0.57911, 0.27865
        0.55446, 0.28568
        ]';
    BL(i).ExtremeRay1 = 5;  % mm
    
elseif PhaseSpaceFlag == 1
    % New state with proposed Mc Kean Aperture - 20080922
    % added by Christoph Steier, 20080923
    % 4.2.2
    i = i + 1;
    BL(i).Title = 'BL 4.2.2';
    BL(i).Number = [4 2 2];
    BL(i).Data0 = [
        %0.54341, 0.30641 % 20080922
        %0.55479, 0.30319
        %0.56678, 0.28784
        %0.55548, 0.29106
        
        0.54478, 0.30468 % 2009-01-16
        0.55613, 0.30149
        0.56675, 0.28789
        0.55546, 0.29108
        ]';
    
    % Extreme Rays 2mm
    BL(i).Data1 = [
        %0.54011, 0.30794 % 20080922
        %0.55688, 0.30319
        %0.57005, 0.28631
        %0.55339, 0.29106
        
        0.54149, 0.30620 % 2009-01-16
        0.55822, 0.30149
        0.57001, 0.28637
        0.55337, 0.29108
        
        ]';
    BL(i).ExtremeRay1 = 2;  % Mike Kritscher now switched to 2 mm as well!
    
else
    
    % New D-shaped aperture was out of alignment tolerance - check
    % for rebaselining
    % Data by Mike Kritscher, 20090116, entered by Christoph Steier
    % 20090119
    % BEamline is safe -> rebaselined
    %
    % 4.2.2
    i = i + 1;
    BL(i).Title = 'BL 4.2.2';
    BL(i).Number = [4 2 2];
    BL(i).Data0 = [
        0.54478, 0.30468
        0.55613, 0.30149
        0.56675, 0.28789
        0.55546, 0.29108
        ]';
    
    % Extreme Rays 2mm
    BL(i).Data1 = [
        0.54149, 0.30620
        0.55822, 0.30149
        0.57001, 0.28637
        0.55337, 0.29108
        ]';
    BL(i).ExtremeRay1 = 2;  % Mike Kritscher now switched to 2 mm as well!
end

% Data received from Mike Kritscher on 20081020
% Entered by Christoph Steier shortly thereafter
% BL 5.0.0 - Beryllium Window Mask,  Nominal Rays
i = i + 1;
BL(i).Title = 'BL 5.0';
BL(i).Number = [5 0 0];
BL(i).Data0 = [
    0.36742, 0.26431
    0.46364, 0.17827
    0.48653, 0.09681
    0.40546, 0.17084
    ]';

% Beryllium Window Mask Rays 2mm
BL(i).Data1 = [
    0.36299, 0.26999
    0.46567, 0.17827
    0.48991, 0.09185
    0.40343, 0.17084
    ]';
BL(i).ExtremeRay1 = 2;  % mm

% The mirror mask was considered at one point, but is not actually used
% (since it was not fiducialized). Therefore I commented this section out.
% Christoph Steier, 20090109
%
%     % BL 5.0.0 - Mirror Mask,  Nominal Rays
%     i = i + 1;
%     BL(i).Title = 'BL 5.0';
%     BL(i).Number = [5 0 0];
%     BL(i).Data0 = [
%         0.39020, 0.20880
%         0.46347, 0.17886
%         0.47384, 0.14220
%         0.40569, 0.17026
%         ]';
%
%     % Mirror Mask Rays 2mm
%     BL(i).Data1 = [
%         0.38735, 0.21078
%         0.46550, 0.17886
%         0.47639, 0.14031
%         0.40366, 0.17026
%         ]';
%     BL(i).ExtremeRay1 = 2;  % mm

% % Extreme Rays 5mm
% BL(i).Data1 = [
%     0.38788, 0.20191
%     0.46846, 0.17916
%     0.47721, 0.14817
%     0.40077, 0.16988
%     ]';
% BL(i).ExtremeRay1 = 5;  % mm


% New Data from Alexis, 20090826 - old Data from Mike contained error!
% Entered by Christoph Steier, 20080928
%
% Data below should be for nominal case, not for as surveyed position ...
%
% BL 5.3.1 - Nominal Rays
i = i + 1;
BL(i).Title = 'BL 5.3.1';
BL(i).Number = [5 3 1];
BL(i).Data0 = [
    0.347385	0.244944
    0.376648	0.236662
    0.391943	0.214916
    0.362930	0.223089
    ]';

% Extreme Rays 5mm
BL(i).Data1 = [
    0.339605	0.248611
    0.381785	0.236669
    0.399557	0.211340
    0.357798	0.223097
    ]';
BL(i).ExtremeRay1 = 5;  % This data appears to be for 5 mm case!!!


% New Data from Alexis, 20091002 - old Data from Mike contained error!
% Entered by Christoph Steier, 20081005
%
% Data below should be for nominal case, not for as surveyed position ...
%
% BL 5.3.2 - Nominal Rays
i = i + 1;
BL(i).Title = 'BL 5.3.2';
BL(i).Number = [5 3 2];
BL(i).Data0 = [
    0.259543	0.223320
    0.279393	0.217868
    0.294573	0.196849
    0.274888	0.202227
    ]';

% Extreme Rays 2 mm
BL(i).Data1 = [
    0.256458	0.224735
    0.281438	0.217872
    0.297604	0.195467
    0.272844	0.202230
    ]';
BL(i).ExtremeRay1 = 2;  % New data is for 2 mm case


if PhaseSpaceFlag == 0 || PhaseSpaceFlag == 1
    % New baseline data (pre survey) from Alexis spreadsheet 20080926. Old
    % data from Mike was incorrect.
    % Entered by Christoph Steier, 20080928
    
    % BL 6.0 - Nominal Rays
    i = i + 1;
    BL(i).Title = 'BL 6.0';
    BL(i).Number = [6 0 0];
    BL(i).Data0 = [
        0.387780	0.209592
        0.439771	0.186068
        0.490077	0.135166
        0.438760	0.158685
        ]';
    
    % Extreme Rays 2mm
    BL(i).Data1 = [
        0.382315	0.212971
        0.441806	0.186068
        0.495404	0.131788
        0.436735	0.158685
        ]';
    BL(i).ExtremeRay1 = 2;  % New data is for 2 mm case !!!
else
    % Proposed rebuild of beamline 6.0 for new mirrors
    % data sent by Mike Kritscher 5-26-11, entered by Tom Scarvie
    
    % BL 6.0 - Nominal Rays
    i = i + 1;
    BL(i).Title = 'BL 6.0';
    BL(i).Number = [6 0 0];
    BL(i).Data0 = [
        0.38223, 0.22509
        0.44254, 0.18913
        0.49993, 0.11543
        0.44076, 0.15137
        ]';
    
    % Extreme Rays 2mm
    BL(i).Data1 = [
        0.37644, 0.22972
        0.44458, 0.18913
        0.50550, 0.11080
        0.43874, 0.15137
        ]';
    BL(i).ExtremeRay1 = 2;
    %     % Temporary Data using survey results based on Alexis spreadsheet from
    %     % 20080926
    %     % Entered by Christoph Steier, 20080928
    %
    %     % BL 6.0 - Nominal Rays
    %     i = i + 1;
    %     BL(i).Title = 'BL 6.0';
    %     BL(i).Number = [6 0 0];
    %     BL(i).Data0 = [
    %         0.389107	0.208279
    %         0.441084	0.184751
    %         0.491372	0.133845
    %         0.440069	0.157365
    %         ]';
    %
    %     % Extreme Rays 2mm
    %     BL(i).Data1 = [
    %         0.383644	0.211659
    %         0.443118	0.184751
    %         0.496697	0.130467
    %         0.438045	0.157365
    %         ]';
    %     BL(i).ExtremeRay1 = 2;  % ALEXIS NEW DATA IS FOR 2 mm CASE!!!
end

if PhaseSpaceFlag == 0 || PhaseSpaceFlag == 1
    % Nominal case without additional aperture (based on Mike Kritscher drawing)
    % BL 6.1.2 - Nominal Rays
    i = i + 1;
    BL(i).Title = 'BL 6.1.2';
    BL(i).Number = [6 1 2];
    BL(i).Data0 = [
        0.27874, 0.23418
        0.29224, 0.23205
        0.30751, 0.22143
        0.29407, 0.22355
        ]';
    
    % Extreme Rays 5mm
    BL(i).Data1 = [
        0.27056, 0.23628
        0.29737, 0.23206
        0.31562, 0.21935
        0.28894, 0.22355
        ]';
    BL(i).ExtremeRay1 = 5;  % mm
    
else
    % Temporary Data using survey results based on Alexis spreadsheet from 20080926
    % Entered by Christoph Steier, 20080928
    
    % BL 6.1.2 - Nominal Rays
    i = i + 1;
    BL(i).Title = 'BL 6.1.2';
    BL(i).Number = [6 1 2];
    BL(i).Data0 = [
        0.277929	0.234740
        0.291432	0.232613
        0.306715	0.221992
        0.293268	0.224109
        ]';
    
    % Extreme Rays 2mm
    BL(i).Data1 = [
        0.274657	0.235579
        0.293486	0.232614
        0.309961	0.221159
        0.291216	0.224110
        ]';
    BL(i).ExtremeRay1 = 2;  % ALEXIS NEW DATA IS FOR 2 mm CASE!!!
end


if PhaseSpaceFlag == 0 || PhaseSpaceFlag == 1
    % New Data from Alexis spreadsheet 20081002
    % Old data from Mike had mix of points inside and outside of walls.
    % Entered by Christoph Steier, 20081005
    % BL 6.3.1 Nominal Rays
    i = i + 1;
    BL(i).Title = 'BL 6.3.1';
    BL(i).Number = [6 3 1];
    BL(i).Data0 = [
        0.352349	0.241905
        0.370225	0.236850
        0.408765	0.208565
        0.391168	0.213532
        ]';
    
    % Extreme Rays 5mm
    BL(i).Data1 = [
        0.340595	0.246691
        0.375353	0.236860
        0.420145	0.203926
        0.386018	0.213556
        ]';
    BL(i).ExtremeRay1 = 5;  % mm
else
    % Temporary Data using survey results based on Alexis spreadsheet from
    % 20081002
    % Entered by Christoph Steier, 20081005
    
    % BL 6.3.1 Nominal Rays
    i = i + 1;
    BL(i).Title = 'BL 6.3.1';
    BL(i).Number = [6 3 1];
    BL(i).Data0 = [
        0.353403	0.240578
        0.371251	0.235527
        0.409628	0.207294
        0.392057	0.212256
        ]';
    
    % Extreme Rays 2mm
    BL(i).Data1 = [
        0.348718	0.242488
        0.373303	0.235531
        0.414176	0.205439
        0.389997	0.212267
        ]';
    BL(i).ExtremeRay1 = 2;  % NEW DATA FROM ALEXIS IS FOR 2 mm CASE!!!
end


if PhaseSpaceFlag == 0 || PhaseSpaceFlag == 1
    % New Data from Alexis spreadsheet 20081002
    % Old data from Mike had mix of points inside and outside of walls.
    % Entered by Christoph Steier, 20081005
    % BL 6.3.2 Nominal Rays
    i = i + 1;
    BL(i).Title = 'BL 6.3.2';
    BL(i).Number = [6 3 2];
    BL(i).Data0 = [
        0.253562	0.220312
        0.270697	0.215619
        0.294316	0.198526
        0.277340	0.203167
        ]';
    
    % Extreme Rays 5mm
    BL(i).Data1 = [
        0.242085	0.224867
        0.275801	0.215629
        0.305543	0.194068
        0.272226	0.203174
        ]';
    BL(i).ExtremeRay1 = 5;  % mm
else
    % Temporary Data using survey results based on Alexis spreadsheet from
    % 20081002
    % Entered by Christoph Steier, 20081005
    
    % BL 6.3.2 Nominal Rays
    i = i + 1;
    BL(i).Title = 'BL 6.3.2';
    BL(i).Number = [6 3 2];
    BL(i).Data0 = [
        0.253495	0.219767
        0.270610	0.215078
        0.294150	0.198007
        0.277195	0.202644
        ]';
    
    % Extreme Rays 2mm
    BL(i).Data1 = [
        0.248918	0.221585
        0.272651	0.215082
        0.298638	0.196224
        0.275150	0.202647
        ]';
    BL(i).ExtremeRay1 = 2;  % NEW DATA FROM ALEXIS IS FOR 2 mm CASE!!!
end


if PhaseSpaceFlag == 0
    % Original BL
    % New (corrected) data for 7.0 and 8.0 received my Mike Kritscher on 4/24/2008
    % CAS - should still be doublechecked by somebody else
    
    % BL 7.0 Nominal Rays
    i = i + 1;
    BL(i).Title = 'BL 7.0';
    BL(i).Number = [7 0 0];
    BL(i).Data0 = [
        0.38972, 0.22001
        0.48811, 0.18282
        0.47850, 0.12911
        0.38098, 0.16630
        ]';
    
    % Extreme Rays 5mm
    BL(i).Data1 = [
        0.38519, 0.22363
        0.49319, 0.18282
        0.48290, 0.12549
        0.37591, 0.16630
        ]';
    BL(i).ExtremeRay1 = 5;  % mm
    
elseif PhaseSpaceFlag == 2 % proposed new beamline layout for upgrade (Maestro)
    
    % proposal from 2012-02-07 by Mike Kritscher
    % email says: 'The location of the horizontal beam defining aperture is
    % further upstream then in the previous data
    
%     % BL 7.0 Nominal Rays
%     i = i + 1;
%     BL(i).Title = 'BL 7.0';
%     BL(i).Number = [7 0 0];
%     BL(i).Data0 = [
%         0.40181, 0.19474
%         0.44288, 0.17960
%         0.46206, 0.15616
%         0.42121, 0.17131
%         ]';
%     
%     % BL 07-0 Extreme Rays 2mm.
%     BL(i).Data1 = [
%         0.39798, 0.19690
%         0.44491, 0.17960
%         0.46584, 0.15401
%         0.41918, 0.17131
%         ]';
%     BL(i).ExtremeRay1 = 2;  % mm
    % BL 7.0 Nominal Rays
    i = i + 1;
    BL(i).Title = 'BL 7.0';
    BL(i).Number = [7 0 0];
    BL(i).Data0 = [
        0.40166, 0.19480
        0.44284, 0.17962
        0.46220, 0.15611
        0.42123, 0.17130
        ]';
    
    % BL 07-0 Extreme Rays 2mm.
    BL(i).Data1 = [
        0.39781, 0.19696
        0.44488, 0.17962
        0.46599, 0.15395
        0.41920, 0.17130
        ]';
    BL(i).ExtremeRay1 = 2;  % mm
    
elseif PhaseSpaceFlag == 98 % proposed new beamline layout for upgrade (Maestro)
    
    % Original Proposal (6-14-11)
    % BL 7.0 Nominal Rays
    i = i + 1;
    BL(i).Title = 'BL 7.0';
    BL(i).Number = [7 0 0];
    BL(i).Data0 = [
        0.39519, 0.19718
        0.44123, 0.18021
        0.46800, 0.15395
        0.42226, 0.17092
        ]';
    
    % BL 07-0 Extreme Rays 5mm.
    BL(i).Data1 = [
        0.39064, 0.19959
        0.44326, 0.18021
        0.47248, 0.15154
        0.42023, 0.17092
        ]';
    BL(i).ExtremeRay1 = 5;  % mm
    
else
    % New data for 7.0 and 8.0 including the added aperture downstream
    % of PS assmebly received from Mike Kritscher on 6/3/2008
    % CAS, April 2008 - should still be doublechecked by somebody else
    % New 7.0 and 8.0 data doublechecked by T.Scarvie, 7/15/08
    
    % New baseline data (no survey) from Alexis spreadsheet 20080926
    % Entered by Christoph Steier, 20080928
    
    % BL 7.0 Nominal Rays
    i = i + 1;
    BL(i).Title = 'BL 7.0';
    BL(i).Number = [7 0 0];
    BL(i).Data0 = [
        0.387387	0.205786
        0.485550	0.168604
        0.481032	0.143326
        0.383277	0.180508
        ]';
    
    % Extreme Rays 2 mm
    BL(i).Data1 = [
        0.385581	0.207233
        0.487579	0.168604
        0.482793	0.141879
        0.381244	0.180508
        ]';
    BL(i).ExtremeRay1 = 2;  % New Data is 2 mm case!!!
    
    %     % New data for 7.0 and 8.0 including the added aperture downstream
    %     % of PS assmebly received from Mike Kritscher on 6/3/2008
    %     % CAS, April 2008 - should still be doublechecked by somebody else
    %     % New 7.0 and 8.0 data doublechecked by T.Scarvie, 7/15/08
    %
    %     % BL 7.0 Nominal Rays
    %     i = i + 1;
    %     BL(i).Title = 'BL 7.0';
    %     BL(i).Number = [7 0 0];
    %     BL(i).Data0 = [
    %         0.38735, 0.20553
    %         0.48555, 0.16861
    %         0.48106, 0.14351
    %         0.38326, 0.18043
    %         ]';
    %
    %     % Extreme Rays 5mm
    %     BL(i).Data1 = [
    %         0.38282, 0.20912
    %         0.49062, 0.16861
    %         0.48547, 0.13992
    %         0.37818, 0.18043
    %         ]';
    %     BL(i).ExtremeRay1 = 5;  % mm
end


if PhaseSpaceFlag == 0
    % Original BL
    % Intersection - This is not perfect but it's close
    % BL 7.3.1 Nominal Rays
    i = i + 1;
    BL(i).Title = 'BL 7.3.1';
    BL(i).Number = [7 3 1];
    BL(i).Data0 = [
        .3318  .2469
        .3469  .2427
        .3968  .1918
        0.39925, 0.18447
        0.39112, 0.18674
        ]';
    
    % Extreme Rays 5mm
    BL(i).Data1 = [
        0.3226   0.251
        0.352    0.2427
        0.4019   0.1918
        0.40534, 0.18139
        0.38599, 0.18678
        ]';
    BL(i).ExtremeRay1 = 5;  % mm
    
    
    % BL 7.3.3 Nominal Rays
    i = i + 1;
    BL(i).Title = 'BL 7.3.3';
    BL(i).Number = [7 3 3];
    BL(i).Data0 = [
        0.2705   0.2641
        0.2927   0.2579
        0.35306, 0.19732
        0.33157, 0.20327
        ]';
    
    % Extreme Rays 5mm
    BL(i).Data1 = [
        0.2612   0.2682
        0.2979   0.2579
        0.36195, 0.19346
        0.32645, 0.20329
        ]';
    BL(i).ExtremeRay1 = 5;  % mm
    
    % % Original BL with multiple aperturs on 7.3.3
    % % BL 7.3.1 Nominal Rays
    % i = i + 1;
    % BL(i).Title = 'BL 7.3.1';
    % BL(i).Number = [7 3 1];
    % BL(i).Data0 = [
    %     0.24053, 0.27253
    %     0.38339, 0.23243
    %     0.39925, 0.18447
    %     0.25851, 0.22340
    %     ]';
    %
    % % Extreme Rays 5mm
    % BL(i).Data1 = [
    %     0.23413, 0.27580
    %     0.38852, 0.23244
    %     0.40534, 0.18139
    %     0.25338, 0.22340
    %     ]';
    % BL(i).ExtremeRay1 = 5;  % mm
    %
    %
    % % BL 7.3.2a Nominal Rays
    % i = i + 1;
    % BL(i).Title = 'BL 7.3.3a';
    % BL(i).Number = [7 3 3.1];
    % BL(i).Data0 = [
    %     0.27043, 0.26421
    %     0.33157, 0.20327
    %     0.35306, 0.19732
    %     0.29254, 0.25803
    %     ]';
    %
    % % Extreme Rays 5mm
    % BL(i).Data1 = [
    %     0.26107, 0.26831
    %     0.32645, 0.20329
    %     0.36195, 0.19346
    %     0.29765, 0.25808
    %     ]';
    % BL(i).ExtremeRay1 = 5;  % mm
    %
    % % BL 7.3.2b Nominal Rays
    % i = i + 1;
    % BL(i).Title = 'BL 7.3.3b';
    % BL(i).Number = [7 3 3.2];
    % BL(i).Data0 = [
    %     0.33167, 0.24704
    %     0.39112, 0.18674
    %     0.40584, 0.18264
    %     0.34680, 0.24278
    %     ]';
    %
    % % Extreme Rays 5mm
    % BL(i).Data1 = [
    %     0.32243, 0.25112
    %     0.38599, 0.18678
    %     0.41463, 0.17880
    %     0.35192, 0.24281
    %     ]';
    % BL(i).ExtremeRay1 = 5;  % mm
else
    % Modified beamline has multiple apertures, not just at sides, but some
    % between the two branchlines. Therefore the usual phase space approach
    % does not work. Refer to photon_track_7_3_newaper_corrected_20081010.m,
    % or check with Christoph Steier or Weishi Wan.
    
    % I took the output of photon_track_7_3_newaper_corrected_20081010 and came
    % up the a hopefully slightly conservative bound on the phase space.  [GJP]
    
    % BL 7.3.1 Nominal Rays
    i = i + 1;
    BL(i).Title = 'BL 7.3.1';
    BL(i).Number = [7 3 1];
    BL(i).Data0 = [
        .3365 .2424
        .3518 .2381
        .3859 .2033
        .3543 .2242
        ]';
    
    % Extreme Rays 2mm
    BL(i).Data1 = [
        .3327 .2439
        .3536 .23818
        .3955 .1955
        .3524 .2238 ]';
    BL(i).ExtremeRay1 = 2;  % mm
    
    
    % BL 7.3.3 Nominal Rays
    i = i + 1;
    BL(i).Title = 'BL 7.3.3';
    BL(i).Number = [7 3 3];
    BL(i).Data0 = [
        .2794 .2554
        .3249 .2261
        .3395 .2111
        .3175 .2173
        ]';
    
    % Extreme Rays 2mm
    BL(i).Data1 = [
        .2702 .2625
        .3271 .2260
        .3433 .2094
        .3155 .2173
        ]';
    BL(i).ExtremeRay1 = 2;  % mm
end


if PhaseSpaceFlag == 0
    % Original BL
    % New (corrected) data for 7.0 and 8.0 received my Mike Kritscher on 4/24/2008
    % CAS, April 2008 - should still be doublechecked by somebody else
    
    % BL 8.0 Nominal Rays
    i = i + 1;
    BL(i).Title = 'BL 8.0';
    BL(i).Number = [8 0 0];
    BL(i).Data0 = [
        0.38972, 0.22001
        0.48811, 0.18282
        0.47850, 0.12911
        0.38098, 0.16630
        ]';
    
    % Extreme Rays 5mm
    BL(i).Data1 = [
        0.38519, 0.22363
        0.49319, 0.18282
        0.48290, 0.12549
        0.37591, 0.16630
        ]';
    BL(i).ExtremeRay1 = 5;  % mm
else
    % New data for 7.0 and 8.0 including the added aperture downstream
    % of PS assmebly received from Mike Kritscher on 6/3/2008
    % CAS, April 2008 - should still be doublechecked by somebody else
    % New 7.0 and 8.0 data doublechecked by T.Scarvie, 7/15/08
    %
    % New baseline data (no survey) from Alexis spreadsheet 20080926
    % Eneter by Christoph Steier, 20080928
    
    % BL 8.0 Nominal Rays
    i = i + 1;
    BL(i).Title = 'BL 8.0';
    BL(i).Number = [8 0 0];
    BL(i).Data0 = [
        0.387387	0.205786
        0.485550	0.168604
        0.481032	0.143326
        0.383277	0.180508
        ]';
    
    % Extreme Rays 2 mm
    BL(i).Data1 = [
        0.385581	0.207233
        0.487579	0.168604
        0.482793	0.141879
        0.381244	0.180508
        ]';
    BL(i).ExtremeRay1 = 2;  % New Data is 2 mm case!!!
    
    %     % BL 8.0 Nominal Rays
    %     i = i + 1;
    %     BL(i).Title = 'BL 8.0';
    %     BL(i).Number = [8 0 0];
    %     BL(i).Data0 = [
    %         0.38735, 0.20553
    %         0.48555, 0.16861
    %         0.48106, 0.14351
    %         0.38326, 0.18043
    %         ]';
    %
    %     % Extreme Rays 5mm
    %     BL(i).Data1 = [
    %         0.38282, 0.20912
    %         0.49062, 0.16861
    %         0.48547, 0.13992
    %         0.37818, 0.18043
    %         ]';
    %     BL(i).ExtremeRay1 = 5;  % mm
end


% % There was an error in the old ideals. New ideal data based on
% % spreadsheet from Alexis from 20081008
% % Entered by Christoph Steier, 20081009
%
% % BL 8.2.1 Nominal Rays
% i = i + 1;
% BL(i).Title = 'BL 8.2.1';
% BL(i).Number = [8 2 1];
% BL(i).Data0 = [
%     0.639191	0.320800
%     0.652595	0.314900
%     0.659272	0.306056
%     0.645918	0.311957
%     ]';
%
% % Extreme Rays 2 mm
% BL(i).Data1 = [
%     0.634955	0.323585
%     0.654698	0.314900
%     0.663462	0.303271
%     0.643816	0.311957
%     ]';
% BL(i).ExtremeRay1 = 2;  % New data is for 2 mm case !!!
%

% Proposed rebuild of beamline 8.2.1, data provided by Mike Kritscher
% 20110210
% Entered by Christoph Steier, 20110221
% BL 8.2.1 Nominal Rays
i = i + 1;
BL(i).Title = 'BL 8.2.1';
BL(i).Number = [8 2 1];
BL(i).Data0 = [
    0.63814, 0.32217
    0.65164, 0.31615
    0.65845, 0.30715
    0.64499, 0.31317
    ]';

% Extreme Rays 2 mm
BL(i).Data1 = [
    0.63386, 0.32501
    0.65375, 0.31615
    0.66268, 0.30431
    0.64289, 0.31317
    ]';
BL(i).ExtremeRay1 = 2;  % New data is for 2 mm case !!!

% if PhaseSpaceFlag == 0
%     % There was an error in the old ideals. New ideal data based on
%     % spreadsheet from Alexis from 20081008
%     % Entered by Christoph Steier, 20081009
%
%     % BL 8.2.2 Nominal Rays
%     i = i + 1;
%     BL(i).Title = 'BL 8.2.2';
%     BL(i).Number = [8 2 2];
%     BL(i).Data0 = [
%         0.550119	0.298619
%         0.563441	0.292858
%         0.569873	0.284588
%         0.556597	0.290348
%         ]';
%
%     % Extreme Rays 2mm
%     BL(i).Data1 = [
%         0.545877	0.301352
%         0.565529	0.292858
%         0.574073	0.281855
%         0.554510	0.290348
%         ]';
%     BL(i).ExtremeRay1 = 2;  % New data is for 2 mm case !!!
%
% else
%     % There was an error in the old ideals. New ideal data based on
%     % spreadsheet from Alexis from 20081010
%     %
%     % Below is Option 2 from Alexis spreadsheet, Mirror mask in surveyed
%     % position, PS in ideal position.
%     %
%     % Entered by Christoph Steier, 20081015
%
%     % BL 8.2.2 Nominal Rays
%     i = i + 1;
%     BL(i).Title = 'BL 8.2.2';
%     BL(i).Number = [8 2 2];
%     BL(i).Data0 = [
%         0.549522	0.299379
%         0.562847	0.293619
%         0.569280	0.285351
%         0.556001	0.291110
%         ]';
%
%     % Extreme Rays 2mm
%     BL(i).Data1 = [
%         0.545279	0.302111
%         0.564936	0.293619
%         0.573481	0.282619
%         0.553914	0.291110
%         ]';
%     BL(i).ExtremeRay1 = 2;  % New data is for 2 mm case !!!
% end

% Proposed rebuild of beamline 8.2.2, data provided by Mike Kritscher
% 20110222
% Entered by Christoph Steier, 20110222

% BL 8.2.2 Nominal Rays
i = i + 1;
BL(i).Title = 'BL 8.2.2';
BL(i).Number = [8 2 2];
BL(i).Data0 = [
    0.54998, 0.29880
    0.56339, 0.29292
    0.56882, 0.28594
    0.55544, 0.29182
    ]';

% Extreme Rays 2mm
BL(i).Data1 = [
    0.54569, 0.30158
    0.56548, 0.29292
    0.57306, 0.28316
    0.55336, 0.29182
    ]';
BL(i).ExtremeRay1 = 2;  % New data is for 2 mm case !!!


if PhaseSpaceFlag == 0
    
    % BL 8.3.1 Nominal Rays (07-31-2008)
    i = i + 1;
    BL(i).Title = 'BL 8.3.1';
    BL(i).Number = [8 3 1];
    BL(i).Data0 = [
        0.37356, 0.23602
        0.38421, 0.23103
        0.38893, 0.22422
        0.37830, 0.22921
        ]';
    
    % Extreme Rays 5mm
    BL(i).Data1 = [
        0.36341, 0.24317
        0.38935, 0.23103
        0.39899, 0.21707
        0.37317, 0.22921
        ]';
    BL(i).ExtremeRay1 = 5;  % mm
    
elseif PhaseSpaceFlag == 2  % leff, 8 kG, 5cm, 5mm, i.e. worst case
    % check for rebaseline - data from Alexis 20090113 - data from Weishi
    % 20090114
    % case is safe - rebaselined with this case
    
    % BL 8.3.1 Nominal Rays
    i = i + 1;
    BL(i).Title = 'BL 8.3.1';
    BL(i).Number = [8 3 1];
    BL(i).Data0 = [
        0.359817, 0.255620
        0.368839, 0.253053
        0.383574, 0.231949
        0.374628, 0.234483
        ]';
    
    % Extreme Rays 2mm
    BL(i).Data1 = [
        0.356792, 0.256979
        0.370981, 0.252943
        0.386553, 0.230617
        0.372491, 0.234598
        ]';
    BL(i).ExtremeRay1 = 2;  % mm
    
elseif PhaseSpaceFlag == 3  % leff, 8 kG, 20081219
    
    % BL 8.3.1 Nominal Rays
    i = i + 1;
    BL(i).Title = 'BL 8.3.1';
    BL(i).Number = [8 3 1];
    BL(i).Data0 = [
        0.35870, 0.25720
        0.36773, 0.25464
        0.38248, 0.23352
        0.37353, 0.23606
        ]';
    
    % Extreme Rays 2mm
    BL(i).Data1 = [
        0.35171, 0.25978
        0.37366, 0.25354
        0.38937, 0.23099
        0.36762, 0.23715
        ]';
    BL(i).ExtremeRay1 = 2;  % mm
    
elseif PhaseSpaceFlag == 4  % leff, 8 kG, 5cm downstream, 20081219
    
    % BL 8.3.1 Nominal Rays
    i = i + 1;
    BL(i).Title = 'BL 8.3.1';
    BL(i).Number = [8 3 1];
    BL(i).Data0 = [
        0.35892, 0.25689
        0.36795, 0.25432
        0.38269, 0.23322
        0.37374, 0.23575
        ]';
    
    % Extreme Rays 2mm
    BL(i).Data1 = [
        0.35193, 0.25947
        0.37388, 0.25322
        0.38959, 0.23069
        0.36784, 0.23684
        ]';
    BL(i).ExtremeRay1 = 2;  % mm
    
elseif PhaseSpaceFlag == 5  % leff, 8 kG, 5cm upstream, 20081219
    
    % BL 8.3.1 Nominal Rays (07-31-2008)
    i = i + 1;
    BL(i).Title = 'BL 8.3.1';
    BL(i).Number = [8 3 1];
    BL(i).Data0 = [
        0.35848, 0.25752
        0.36751, 0.25495
        0.38227, 0.23383
        0.37332, 0.23636
        ]';
    
    % Extreme Rays 2mm
    BL(i).Data1 = [
        0.35149, 0.26009
        0.37344, 0.25385
        0.38916, 0.23130
        0.36741, 0.23746
        ]';
    BL(i).ExtremeRay1 = 2;  % mm
    
elseif PhaseSpaceFlag == 6  % leff, 9.9 kG, 20081219
    
    % BL 8.3.1 Nominal Rays
    i = i + 1;
    BL(i).Title = 'BL 8.3.1';
    BL(i).Number = [8 3 1];
    BL(i).Data0 = [
        0.35622, 0.26071
        0.36526, 0.25814
        0.38004, 0.23704
        0.37108, 0.23957
        ]';
    
    % Extreme Rays 2mm
    BL(i).Data1 = [
        0.34923, 0.26329
        0.37120, 0.25704
        0.38694, 0.23451
        0.36516, 0.24067
        ]';
    BL(i).ExtremeRay1 = 2;  % mm
    
elseif PhaseSpaceFlag == 7  % leff, 8.0 kG, 5 cm donstrem, 8mm offset, 20081222
    
    % BL 8.3.1 Nominal Rays
    i = i + 1;
    BL(i).Title = 'BL 8.3.1';
    BL(i).Number = [8 3 1];
    BL(i).Data0 = [
        0.36023, 0.25504
        0.36925, 0.25247
        0.38398, 0.23136
        0.37504, 0.23389
        ]';
    
    % Extreme Rays 2mm
    BL(i).Data1 = [
        0.35324, 0.25761
        0.37518, 0.25137
        0.39087, 0.22883
        0.36914, 0.23498
        ]';
    BL(i).ExtremeRay1 = 2;  % mm
    
elseif PhaseSpaceFlag == 8  % leff, 8.0 kG, 5 cm donstrem, 5mm offset, 20081222
    
    % BL 8.3.1 Nominal Rays
    i = i + 1;
    BL(i).Title = 'BL 8.3.1';
    BL(i).Number = [8 3 1];
    BL(i).Data0 = [
        0.35941, 0.25620
        0.36843, 0.25363
        0.38318, 0.23252
        0.37423, 0.23505
        ]';
    
    % Extreme Rays 2mm
    BL(i).Data1 = [
        0.35242, 0.25877
        0.37437, 0.25253
        0.39007, 0.22999
        0.36832, 0.23615
        ]';
    BL(i).ExtremeRay1 = 2;  % mm
    
else
    
    % BL 8.3.1 Nominal Rays
    % with permanent magnets (0.8 T), without D-shaped aperture
    % data by Weishi Wan, 2008-12-02
    % entered by Christoph Steier 2008-12-02
    
    i = i + 1;
    BL(i).Title = 'BL 8.3.1';
    BL(i).Number = [8 3 1];
    BL(i).Data0 = [
        0.35844, 0.25757
        0.36747, 0.25500
        0.38222, 0.23389
        0.37327, 0.23642
        ]';
    
    % Extreme Rays 2mm
    BL(i).Data1 = [
        0.35145, 0.26015
        0.37340, 0.25390
        0.38912, 0.23136
        0.36736, 0.23752
        ]';
    BL(i).ExtremeRay1 = 2;  % mm
    
end

if PhaseSpaceFlag == 0
    
    % No correct data exists for this case!
    % Christoph Steier, 20081015
    
else
    
    
    % There was an error in the old ideals. New ideal data based on
    % spreadsheet from Alexis from 20081008
    % Entered by Christoph Steier, 20081009
    
    %BL 8.3.2 Nominal Rays
    i = i + 1;
    BL(i).Title = 'BL 8.3.2';
    BL(i).Number = [8 3 2];
    BL(i).Data0 = [
        0.277883	0.221404
        0.289912	0.217867
        0.300333	0.203212
        0.288352	0.206749
        ]';
    
    % Extreme Rays 2mm
    BL(i).Data1 = [
        0.274739	0.222930
        0.291961	0.217867
        0.303456	0.201686
        0.286308	0.206749
        ]';
    BL(i).ExtremeRay1 = 2;  % New data is for 2 mm case !!!
    
end



% BL 9.0 Nominal Rays (02-12-08)
i = i + 1;
BL(i).Title = 'BL 9.0';
BL(i).Number = [9 0 0];
BL(i).Data0 = [
    0.36965, 0.21898
    0.50588, 0.17122
    0.49837, 0.12996
    0.36306, 0.17764
    ]';

% Extreme Rays 5mm
BL(i).Data1 = [
    0.36507, 0.22234
    0.51096, 0.17122
    0.50280, 0.12661
    0.35798, 0.17764
    ]';
BL(i).ExtremeRay1 = 5;  % mm


% BL 9.3
if PhaseSpaceFlag == 0
    % Present BL 2007 - Intersection Data - This is not perfect but it's very close for now
    
    % 9.3 Nominal Rays
    i = i + 1;
    BL(i).Title = 'BL 9.3.x';
    BL(i).Number = [9 3 1];
    BL(i).Data0 = [
        0.2624  0.2846
        0.3546  0.2463
        0.3606  0.2438
        0.385   0.2254
        0.38401, 0.16636
        0.34578, 0.18293
        0.262    0.2421
        ]';
    
    % Extreme Rays 5mm
    BL(i).Data1 = [
        0.2572   0.2887
        0.3604   0.246
        0.3664   0.2435
        0.3902   0.2256
        0.38899, 0.16200
        0.34069, 0.18293
        0.2567   0.242
        ]';
    BL(i).ExtremeRay1 = 5;  % mm
    
    % % Original BL - multiple apertures
    % % BL 9-3 AP1 Nominal Rays
    % i = i + 1;
    % BL(i).Title = 'BL 9.3 AP1';
    % BL(i).Number = [9 3 1];
    % BL(i).Data0 = [
    %     0.11560, 0.34556
    %     0.36043, 0.24391
    %     0.57666, 0.08163
    %     0.34578, 0.18293
    %     ]';
    %
    % % Extreme Rays 5mm
    % BL(i).Data1 = [
    %     0.09464, 0.35606
    %     0.36614, 0.24367
    %     0.59522, 0.07118
    %     0.34069, 0.18293
    %     ]';
    % BL(i).ExtremeRay1 = 5;  % mm
    %
    %
    % % 9.3 AP2 Nominal Rays
    % i = i + 1;
    % BL(i).Title = 'BL 9.3 AP2';
    % BL(i).Number = [9 3 2];
    % BL(i).Data0 = [
    %     0.26238, 0.28563
    %     0.38520, 0.23329
    %     0.38401, 0.16636
    %     0.26174, 0.21871
    %     ]';
    %
    % % Extreme Rays 5mm
    % BL(i).Data1 = [
    %     0.25726, 0.28999
    %     0.39034, 0.23329
    %     0.38899, 0.16200
    %     0.25650, 0.21871
    %     ]';
    % BL(i).ExtremeRay1 = 5;  % mm
    %
    % else
    %     % Proposed modifications: with M1 mirror aperture
    %     % 9.3 Nominal Rays
    %     i = i + 1;
    %     BL(i).Title = 'BL 9.3.x';
    %     BL(i).Number = [9 3 1];
    %
    %     if 1
    %         % 2008-01-11 data
    %         BL(i).Data0 = [
    %             0.11560, 0.34556
    %             0.36043, 0.24391
    %             0.46405, 0.16724
    %             0.30253, 0.21453
    %             ]';
    %
    %         % BL 9-3 Extreme Rays 5mm.
    %         BL(i).Data1 = [
    %             0.09464, 0.35606
    %             0.36614, 0.24367
    %             0.47567, 0.16230
    %             0.29741, 0.21453
    %             ]';
    %         BL(i).ExtremeRay1 = 5;  % mm
    %     else
    %         % 2008-01-10 data
    %         BL(i).Data0 = [
    %             0.11560, 0.34556
    %             0.36043, 0.24391
    %             0.47061, 0.16230
    %             0.30933, 0.20958
    %             ]';
    %
    %         % BL 9-3 Extreme Rays 5mm.
    %         BL(i).Data1 = [
    %             0.09464, 0.35606
    %             0.36614, 0.24367
    %             0.48222, 0.15737
    %             0.30422, 0.20958
    %             ]';
    %         BL(i).ExtremeRay1 = 5;  % mm
    %     end
    % end
else
    % Ray tracing data
    % 9.3 Nominal Rays
    i = i + 1;
    BL(i).Title = 'BL 9.3.x';
    BL(i).Number = [9 3 1];
    BL(i).Data = [
        NaN NaN
        .3443 .2320
        .3870 .2190
        .3866 .1991
        .3449 .2287
        .3443 .2320
        NaN   NaN
        .350005 .206075
        .36245 .1972
        .35127 .20023
        .350005 .206075
        NaN NaN
        .2600 .2575
        .2892 .2492
        .3283 .2215
        .33183 .2055
        .3018 .2135
        .2602 .2429
        .2600 .2575
        NaN NaN
        ]';
    BL(i).ExtremeRay1 = 2;  % mm
end



% New Data from Alexis spreadsheet (baseline, i.e. not based on survey)
% 20080926. Old data from Mike was wrong.
% Entered by Christoph Steier, 20080928

% BL 10.0
i = i + 1;
BL(i).Title = 'BL 10.0';
BL(i).Number = [10 0 0];
BL(i).Data0 = [
    0.408261	0.195820
    0.426000	0.188586
    0.460666	0.153221
    0.443082	0.160455
    ]';

% Extreme Rays 2mm
BL(i).Data1 = [
    0.403462	0.198603
    0.428036	0.188586
    0.465400	0.150438
    0.441056	0.160455
    ]';
BL(i).ExtremeRay1 = 2;  % 2 mm according to spreadsheet

%     % Old data based on Mike Kritscher drawing
%     % Incorrect according to Alexis spreadsheet - 20080926
%     % BL 10.0.0 - Nominal Rays (02-21-08)
%     i = i + 1;
%     BL(i).Title = 'BL 10.0';
%     BL(i).Number = [10 0 0];
%     BL(i).Data0 = [
%         0.38305, 0.20481
%         0.48941, 0.16629
%         0.48547, 0.14428
%         0.37949, 0.18277
%         ]';
%
%     % Extreme Rays 5mm
%     BL(i).Data1 = [
%         0.37850, 0.20828
%         0.49447, 0.16629
%         0.48990, 0.14082
%         0.37441, 0.18277
%         ]';
%     BL(i).ExtremeRay1 = 5;  % mm
%
%
% BL 10.0.0 - using AP2 - which is an existing aperture
% i = i + 1;
% BL(i).Title = 'BL 10.0';
% BL(i).Number = [10 0 0];
% BL(i).Data0 = [
%     0.42307, 0.18978
%     0.46113, 0.15303
%     0.44593, 0.15929
%     0.40773, 0.19604
%     ]';
%
% % Extreme Rays 5mm
% BL(i).Data1 = [
%     0.42816, 0.18987
%     0.47361, 0.14580
%     0.44086, 0.15929
%     0.39505, 0.20327
%     ]';
% BL(i).ExtremeRay1 = 5;  % mm


% BL 10.3
% Original Data BL
% i = i + 1;
% BL(i).Title = 'BL 10.3.1';
% BL(i).Number = [10 3 1];
% BL(i).Data0 = [
%     0.34113, 0.24714
%     0.37629, 0.23719
%     0.39242, 0.21426
%     0.35758, 0.22407
%     ]';
%
% % Extreme Rays 5mm
% BL(i).Data1 = [
%     0.33334, 0.25081
%     0.38143, 0.23720
%     0.40004, 0.21068
%     0.35245, 0.22407
%     ]';
% BL(i).ExtremeRay1 = 5;  % mm
%
%
% % BL 10.3.2 Nominal Rays
% i = i + 1;
% BL(i).Title = 'BL 10.3.2';
% BL(i).Number = [10 3 2];
% BL(i).Data0 = [
%     0.25616, 0.22466
%     0.29025, 0.21529
%     0.30617, 0.19317
%     0.27237, 0.20240
%     ]';
%
% % Extreme Rays 5mm
% BL(i).Data1 = [
%     0.24844, 0.22821
%     0.29537, 0.21530
%     0.31372, 0.18972
%     0.26727, 0.20241
%     ]';
% BL(i).ExtremeRay1 = 5;  % mm


if PhaseSpaceFlag == 0 || PhaseSpaceFlag == 1
    % BL 10.3.1
    % Old data based on Mike Kritscher drawing (01-25-2008)
    i = i + 1;
    BL(i).Title = 'BL 10.3.1';
    BL(i).Number = [10 3 1];
    BL(i).Data0 = [
        0.34941, 0.24404
        0.36734, 0.23896
        0.39204, 0.22088
        0.37429, 0.22591
        ]';
    
    % Extreme Rays 5mm
    BL(i).Data1 = [
        0.33761, 0.24886
        0.37247, 0.23897
        0.40357, 0.21616
        0.36915, 0.22592
        ]';
    BL(i).ExtremeRay1 = 5;  % mm
else
    % Temporary Data using survey results based on Alexis spreadsheet from
    % 20080926
    % Entered by Christoph Steier, 20080928
    
    % BL 10.3.1
    i = i + 1;
    BL(i).Title = 'BL 10.3.1';
    BL(i).Number = [10 3 1];
    BL(i).Data0 = [
        0.348674	0.244254
        0.366565	0.239178
        0.391135	0.221137
        0.373423	0.226159
        ]';
    
    % Extreme Rays 2mm
    BL(i).Data1 = [
        0.343972	0.246176
        0.368617	0.239182
        0.395739	0.219253
        0.371366	0.226162
        ]';
    BL(i).ExtremeRay1 = 2;  % NEW DATA FROM ALEXIS IS FOR 2 mm CASE!!!
end

if PhaseSpaceFlag == 0 || PhaseSpaceFlag == 1
    % BL 10.3.2 Nominal Rays
    i = i + 1;
    BL(i).Title = 'BL 10.3.2';
    BL(i).Number = [10 3 2];
    BL(i).Data0 = [
        0.25509, 0.21912
        0.27225, 0.21440
        0.29594, 0.19724
        0.27895, 0.20190
        ]';
    
    % Extreme Rays 5mm
    BL(i).Data1 = [
        0.24360, 0.22369
        0.27735, 0.21441
        0.30718, 0.19276
        0.27383, 0.20191
        ]';
    BL(i).ExtremeRay1 = 5;  % mm
else
    % Temporary Data using survey results based on Alexis spreadsheet from
    % 20080926
    % Entered by Christoph Steier, 20080928
    
    % BL 10.3.2
    i = i + 1;
    BL(i).Title = 'BL 10.3.2';
    BL(i).Number = [10 3 2];
    BL(i).Data0 = [
        0.254179	0.219367
        0.271302	0.214662
        0.294876	0.197531
        0.277914	0.202183
        ]';
    
    % Extreme Rays 2mm
    BL(i).Data1 = [
        0.249600	0.221190
        0.273343	0.214666
        0.299366	0.195743
        0.275869	0.202186
        ]';
    BL(i).ExtremeRay1 = 2;  % NEW DATA FROM ALEXIS IS FOR 2 mm CASE!!!
end


% New baseline data (no survey) from Alexis spreadsheet 20080926. Old dara
% from Mike was wrong. Entered by Christoph Steier, 20080928.

% BL 11.0.0 - Nominal Rays
i = i + 1;
BL(i).Title = 'BL 11.0';
BL(i).Number = [11 0 0];
BL(i).Data0 = [
    0.379563	0.207266
    0.429074	0.188354
    0.471203	0.148595
    0.422178	0.167512
    ]';

% Extreme Rays 2mm
BL(i).Data1 = [
    0.374666	0.209905
    0.431110	0.188354
    0.476002	0.145954
    0.420150	0.167512
    ]';
BL(i).ExtremeRay1 = 2;  % New data is 2 mm case !!!

% % BL 11.0.0 - Nominal Rays
% i = i + 1;
% BL(i).Title = 'BL 11.0';
% BL(i).Number = [11 0 0];
% BL(i).Data0 = [
%     0.383346, 0.2058
%     0.432325, 0.18708
%     0.474283, 0.14738
%     0.425767, 0.16611
%     ]';
%
% % Extreme Rays 5mm
% BL(i).Data1 = [
%     0.371113, 0.2124
%     0.437413, 0.18708
%     0.486243, 0.14079
%     0.420701, 0.16611
%     ]';
% BL(i).ExtremeRay1 = 5;  % mm
%

if PhaseSpaceFlag == 0
    % Nominal case without additional aperture
    
    % BL 11.3.1 Nominal Rays
    i = i + 1;
    BL(i).Title = 'BL 11.3.1';
    BL(i).Number = [11 3 1];
    BL(i).Data0 = [
        0.34391, 0.25126
        0.36444, 0.24545
        0.38878, 0.21094
        0.36853, 0.21663
        ]';
    
    % Extreme Rays 5mm
    BL(i).Data1 = [
        0.33610, 0.25494
        0.36958, 0.24546
        0.39638, 0.20738
        0.36340, 0.21665
        ]';
    BL(i).ExtremeRay1 = 5;  % mm
    
    
    % BL 11.3.2 Nominal Rays
    i = i + 1;
    BL(i).Title = 'BL 11.3.2';
    BL(i).Number = [11 3 2];
    BL(i).Data0 = [
        0.25633, 0.22474
        0.29042, 0.21537
        0.30633, 0.19324
        0.27254, 0.20247
        ]';
    
    % Extreme Rays 5mm
    BL(i).Data1 = [
        0.24860, 0.22828
        0.29553, 0.21537
        0.31389, 0.18979
        0.26743, 0.20248
        ]';
    BL(i).ExtremeRay1 = 5;  % mm
    
else
    % BL 11.3.1 modifications 2008-04-22
    % BL 11.3.1 Nominal Rays
    % i = i + 1;
    % BL(i).Title = 'BL 11.3.1';
    % BL(i).Number = [11 3 1];
    % BL(i).Data0 = [
    %     0.34391, 0.25074
    %     0.36444, 0.24488
    %     0.38767, 0.21168
    %     0.36743, 0.21737
    %     ]';
    %
    % % Extreme Rays 5mm
    % BL(i).Data1 = [
    %     0.33595, 0.25442
    %     0.36940, 0.24494
    %     0.39527, 0.20812
    %     0.36231, 0.21738
    %     ]';
    % BL(i).ExtremeRay1 = 5;  % mm
    
    
    % BL 11.3.1 modifications 2008-04-30
    % BL 11.3.1 Nominal Rays
    % i = i + 1;
    % BL(i).Title = 'BL 11.3.1';
    % BL(i).Number = [11 3 1];
    % BL(i).Data0 = [
    %     0.34404, 0.25033
    %     0.36456, 0.24450
    %     0.38730, 0.21221
    %     0.36703, 0.21794
    %     ]';
    %
    % % Extreme Rays 5mm
    % BL(i).Data1 = [
    %     0.33623, 0.25403
    %     0.36970, 0.24451
    %     0.39491, 0.20863
    %     0.36190, 0.21795
    %     ]';
    % BL(i).ExtremeRay1 = 5;  % mm
    
    
    % BL 11.3.1 modifications 05-16-2008
    % BL 11.3.1 Nominal Rays
    i = i + 1;
    BL(i).Title = 'BL 11.3.1';
    BL(i).Number = [11 3 1];
    BL(i).Data0 = [
        0.34467, 0.25015
        0.36519, 0.24432
        0.38792, 0.21204
        0.36766, 0.21776
        ]';
    
    % Extreme Rays 5mm
    BL(i).Data1 = [
        0.33686, 0.25385
        0.37032, 0.24433
        0.39554, 0.20846
        0.36253, 0.21777
        ]';
    BL(i).ExtremeRay1 = 5;  % mm
    
    
    % % BL 11.3.2 modifications 2008-1-15
    % % BL 11.3.2 Nominal Rays
    % i = i + 1;
    % BL(i).Title = 'BL 11.3.2';
    % BL(i).Number = [11 3 2];
    % BL(i).Data0 = [
    %     0.256327, 0.22485
    %     0.290417, 0.21540
    %     0.304546, 0.19573
    %     0.270587, 0.20517
    %     ]';
    %
    % % Extreme Rays 5mm
    % BL(i).Data1 = [
    %     0.248519, 0.22839
    %     0.295503, 0.21541
    %     0.312176, 0.19219
    %     0.26548, 0.20517
    %     ]';
    % BL(i).ExtremeRay1 = 5;  % mm
    
    % BL 11.3.2 modifications 2008-04-22
    % BL 11.3.2 Nominal Rays
    % i = i + 1;
    % BL(i).Title = 'BL 11.3.2';
    % BL(i).Number = [11 3 2];
    % BL(i).Data0 = [
    %     0.25519, 0.22551
    %     0.28960, 0.21569
    %     0.30427, 0.19527
    %     0.27005, 0.20508
    %     ]';
    %
    % % Extreme Rays 5mm
    % BL(i).Data1 = [
    %     0.24766, 0.22879
    %     0.29501, 0.21528
    %     0.31199, 0.19158
    %     0.26494, 0.20508
    %     ]';
    % BL(i).ExtremeRay1 = 5;  % mm
    
    % BL 11.3.2 modifications 2008-04-30
    % BL 11.3.2 Nominal Rays
    % i = i + 1;
    % BL(i).Title = 'BL 11.3.2';
    % BL(i).Number = [11 3 2];
    % BL(i).Data0 = [
    %     0.25544, 0.22518
    %     0.28984, 0.21536
    %     0.30421, 0.19535
    %     0.26999, 0.20516
    %     ]';
    %
    % % Extreme Rays 5mm
    % BL(i).Data1 = [
    %     0.24761, 0.22886
    %     0.29496, 0.21536
    %     0.31194, 0.19166
    %     0.26488, 0.20516
    %     ]';
    % BL(i).ExtremeRay1 = 5;  % mm
    
    % BL 11-3 Option 1.5mm Data 05-05-08
    % BL 11.3.2 Nominal Rays
    % i = i + 1;
    % BL(i).Title = 'BL 11.3.2';
    % BL(i).Number = [11 3 2];
    % BL(i).Data0 = [
    %     0.25544, 0.22518
    %     0.28984, 0.21536
    %     0.30408, 0.19553
    %     0.26986, 0.20535
    %     ]';
    %
    % % Extreme Rays 5mm
    % BL(i).Data1 = [
    %     0.24761, 0.22886
    %     0.29496, 0.21536
    %     0.31181, 0.19184
    %     0.26475, 0.20535
    %     ]';
    % BL(i).ExtremeRay1 = 5;  % mm
    
    if 1
        % BL 11.3.2 modifications 05-16-2008
        % 1.5 mm clearance to the photon beam
        % BL 11.3.2 Nominal Rays
        i = i + 1;
        BL(i).Title = 'BL 11.3.2';
        BL(i).Number = [11 3 2];
        BL(i).Data0 = [
            0.25595, 0.22517
            0.29034, 0.21533
            0.30449, 0.19564
            0.27027, 0.20545
            ]';
        
        % Extreme Rays 5mm
        BL(i).Data1 = [
            0.24813, 0.22886
            0.29546, 0.21536
            0.31221, 0.19195
            0.26516, 0.20545
            ]';
        BL(i).ExtremeRay1 = 5;  % mm
    else
        % BL 11.3.2 modifications 05-16-2008
        % 2.0 mm clearance to the photon beam
        % BL 11.3.2 Nominal Rays
        i = i + 1;
        BL(i).Title = 'BL 11.3.2';
        %BL(i).Title = 'BL 11.3.2  2 mm';
        BL(i).Number = [11 3 2];
        BL(i).Data0 = [
            0.25609, 0.22499
            0.29048, 0.21517
            0.30462, 0.19546
            0.27040, 0.20527
            ]';
        
        % Extreme Rays 5mm
        BL(i).Data1 = [
            0.24827, 0.22867
            0.29559, 0.21517
            0.31234, 0.19177
            0.26530, 0.20527
            ]';
        BL(i).ExtremeRay1 = 5;  % mm
    end
end

if PhaseSpaceFlag == 0 || PhaseSpaceFlag == 1
    % Original data based on Mike Kritscher drawing
    % Somebody should doublecheck numbers CAS, April 2008
    % BL 12.0 Nominal Rays
    i = i + 1;
    BL(i).Title = 'BL 12.0';
    BL(i).Number = [12 0 0];
    BL(i).Data0 = [
        0.38668, 0.20132
        0.48551, 0.16819
        0.48185, 0.14771
        0.38336, 0.18084
        ]';
    
    % Extreme Rays 5mm
    BL(i).Data1 = [
        0.38210, 0.20455
        0.49058, 0.16819
        0.48633, 0.14449
        0.37828, 0.18084
        ]';
    BL(i).ExtremeRay1 = 5;  % mm
else
    % Temporary Data using survey results based on Alexis spreadsheet from
    % 20080922
    % Entered by Christoph Steier, 20080923
    
    % BL 12.0 Nominal Rays
    i = i + 1;
    BL(i).Title = 'BL 12.0';
    BL(i).Number = [12 0 0];
    BL(i).Data0 = [
        0.386619	0.200931
        0.485431	0.167769
        0.481770	0.147271
        0.383295	0.180433
        ]';
    
    % Extreme Rays 2mm
    BL(i).Data1 = [
        0.384789	0.202222
        0.487459	0.167769
        0.483561	0.145981
        0.381262	0.180433
        ]';
    BL(i).ExtremeRay1 = 2;  % NEW DATA FROM ALEXIS IS FOR 2 mm CASE!!!
end


if PhaseSpaceFlag == 0
% 12.2.1 (12.7 mm) Nominal Rays
% Data from re-baseline of 12.2.1 and 12.2.2 - Mike Kritscher drawing (10-24-2017)
    i = i + 1;
    BL(i).Title = 'BL 12.2.1 (12.7mm)';
    BL(i).Number = [12 2 1];
    BL(i).Data0 = [
        0.63766, 0.32167
        0.65240, 0.31511
        0.65919, 0.30612
        0.64451, 0.31268
        ]';
    
    % Extreme Rays 5mm
    BL(i).Data1 = [
        0.62696, 0.32875
        0.65766, 0.31511
        0.66975, 0.29904
        0.63926, 0.31268
        ]';
    BL(i).ExtremeRay1 = 5;  % mm
% BL 12.2.1 - New branchline - data from Mike Kritscher (9-10-2013)
elseif PhaseSpaceFlag == 1
% 12.2.1 (12.7 mm) Nominal Rays
% Data from design of 12.2.1 and redesign of 12.2.2 - Mike Kritscher drawing (09-10-2013)
    i = i + 1;
    BL(i).Title = 'BL 12.2.1 (12.7mm)';
    BL(i).Number = [12 2 1];
    BL(i).Data0 = [
        0.63714, 0.32235
        0.65188, 0.31580
        0.65868, 0.30681
        0.64399, 0.31336
        ]';
    
    % Extreme Rays 5mm
    BL(i).Data1 = [
        0.62644, 0.32943
        0.65714, 0.31580
        0.66923, 0.29973
        0.63872, 0.31337
        ]';
    BL(i).ExtremeRay1 = 5;  % mm
elseif PhaseSpaceFlag == 2
    % 12.2.1 (10 mm) Nominal Rays
    % Data from design of new 12.2.1 and redesign of 12.2.2 - Mike Kritscher drawing (09-10-2013)
    i = i + 1;
    BL(i).Title = 'BL 12.2.1 (10 mm)';
    BL(i).Number = [12 2 1];
    BL(i).Data0 = [
        0.63787, 0.32140
        0.65261, 0.31484
        0.65796, 0.30776
        0.64326, 0.31432
        ]';
    
    % Extreme Rays 5mm
    BL(i).Data1 = [
        0.62717, 0.32847
        0.65787, 0.31484
        0.66851, 0.30068
        0.63801, 0.31432
        ]';
    BL(i).ExtremeRay1 = 5;  % mm
else
    fprintf('No phase space data for existing 12.2.1 since beamline does not exist!');
end


if PhaseSpaceFlag == 0
    % 12.2.2 (12.1 mm) Nominal Rays
    % Data from re-baseline of 12.2.1 and 12.2.2 - Mike Kritscher drawing (10-24-2017)
    i = i + 1;
    BL(i).Title = 'BL 12.2.2';
    BL(i).Number = [12 2 2];
    BL(i).Data0 = [
        0.54820, 0.29998
        0.56275, 0.29369
        0.56918, 0.28543
        0.55469, 0.29171
        ]';
    
    % Extreme Rays 5mm
    BL(i).Data1 = [
        0.53757, 0.30681
        0.56797, 0.29369
        0.57967, 0.27860
        0.54946, 0.29171
        ]';
    BL(i).ExtremeRay1 = 5;  % mm
elseif PhaseSpaceFlag == 1
    % 12.2.2 Nominal Rays
    % Original data based on Mike Kritscher drawing (07-22-2008)
    i = i + 1;
    BL(i).Title = 'BL 12.2.2';
    BL(i).Number = [12 2 2];
    BL(i).Data0 = [
        0.54816, 0.30003
        0.56271, 0.29374
        0.56915, 0.28547
        0.55465, 0.29176
        ]';
    
    % Extreme Rays 5mm
    BL(i).Data1 = [
        0.53753, 0.30686
        0.56794, 0.29374
        0.57965, 0.27863
        0.54943, 0.29176
        ]';
    BL(i).ExtremeRay1 = 5;  % mm
elseif PhaseSpaceFlag == 2
    % 12.2.2 (10 mm) Nominal Rays
    % Data from design of new 12.2.1 and redesign of 12.2.2 - Mike Kritscher drawing (09-10-2013)
    i = i + 1;
    BL(i).Title = 'BL 12.2.2 Redesign (10 mm)';
    BL(i).Number = [12 2 2];
    BL(i).Data0 = [
        0.54873, 0.29931
        0.56328, 0.29302
        0.56859, 0.28619
        0.55409, 0.29247
        ]';
    
    % Extreme Rays 5mm
    BL(i).Data1 = [
        0.53810, 0.30614
        0.56850, 0.29302
        0.57909, 0.27935
        0.54887, 0.29247
        ]';
    BL(i).ExtremeRay1 = 5;  % mm
end


if PhaseSpaceFlag == 0
    % BL 12.3.1 Nominal Rays
    % surveyed PS location and the McKean D-aperture (2008-11-03)
    i = i + 1;
    BL(i).Title = 'BL 12.3.1';
    BL(i).Number = [12 3 1];
    BL(i).Data0 = [
        0.36432, 0.24336
        0.37939, 0.23897
        0.38950, 0.22437
        0.37449, 0.22877
        ]';
    
    % Extreme Rays 2mm
    BL(i).Data1 = [
        0.36120, 0.24487
        0.38145, 0.23897
        0.39260, 0.22286
        0.37244, 0.22877
        ]';
    BL(i).ExtremeRay1 = 2;  % mm
elseif PhaseSpaceFlag == 1
    % Taking credit for permanent magnets, Data provided by Weishi Wan,
    % 2008-11-08, based on geometry data by Mike Kritscher of 2008-11-07,
    % entered by Christoph Steier, 2008-11-10
    %
    % BL 12.3.1 Nominal Rays
    i = i + 1;
    BL(i).Title = 'BL 12.3.1';
    BL(i).Number = [12 3 1];
    BL(i).Data0 = [
        0.35439, 0.25751
        0.36953, 0.25310
        0.37971, 0.23851
        0.36463, 0.24293
        ]';
    
    % Extreme Rays 2mm
    BL(i).Data1 = [
        0.35125, 0.25903
        0.37159, 0.25310
        0.38281, 0.23700
        0.36256, 0.24293
        ]';
    BL(i).ExtremeRay1 = 2;  % mm
    
elseif PhaseSpaceFlag == 2  % leff, 8 kG, 5cm, 5mm, i.e. worst case
    % check for rebaseline - data from Alexis 20090114 - data from Weishi
    % 20090117
    % case is safe - rebaselined with this case
    
    % BL 12.3.1 Nominal Rays
    i = i + 1;
    BL(i).Title = 'BL 12.3.1';
    BL(i).Number = [12 3 1];
    BL(i).Data0 = [
        0.354692, 0.257789
        0.369573, 0.253752
        0.384748, 0.232024
        0.369991, 0.236008
        ]';
    
    % Extreme Rays 2mm
    BL(i).Data1 = [
        0.351640, 0.259178
        0.371631, 0.253754
        0.387737, 0.230669
        0.367923, 0.236018
        ]';
    BL(i).ExtremeRay1 = 2;  % mm
    
elseif PhaseSpaceFlag == 3  % leff, 8 kG, 20081219
    
    % BL 12.3.1 Nominal Rays
    i = i + 1;
    BL(i).Title = 'BL 12.3.1';
    BL(i).Number = [12 3 1];
    BL(i).Data0 = [
        0.35338, 0.25895
        0.36826, 0.25491
        0.38340, 0.23319
        0.36865, 0.23717
        ]';
    
    % Extreme Rays 2mm
    BL(i).Data1 = [
        0.35033, 0.26034
        0.37032, 0.25492
        0.38639, 0.23184
        0.36658, 0.23718
        ]';
    BL(i).ExtremeRay1 = 2;  % mm
    
elseif PhaseSpaceFlag == 4  % leff, 8 kG, 5cm downstream, 20081219
    
    % BL 12.3.1 Nominal Rays
    i = i + 1;
    BL(i).Title = 'BL 12.3.1';
    BL(i).Number = [12 3 1];
    BL(i).Data0 = [
        0.35359, 0.25866
        0.36846, 0.25462
        0.38360, 0.23290
        0.36885, 0.23689
        ]';
    
    % Extreme Rays 2mm
    BL(i).Data1 = [
        0.35054, 0.26004
        0.37052, 0.25462
        0.38659, 0.23155
        0.36678, 0.23690
        ]';
    BL(i).ExtremeRay1 = 2;  % mm
    
elseif PhaseSpaceFlag == 5  % leff, 8 kG, 5cm upstream, 20081219
    
    % BL 12.3.1 Nominal Rays
    i = i + 1;
    BL(i).Title = 'BL 12.3.1';
    BL(i).Number = [12 3 1];
    BL(i).Data0 = [
        0.35317, 0.25924
        0.36805, 0.25521
        0.38320, 0.23348
        0.36845, 0.23746
        ]';
    
    % Extreme Rays 2mm
    BL(i).Data1 = [
        0.35012, 0.26063
        0.37011, 0.25521
        0.38619, 0.23213
        0.36638, 0.23747
        ]';
    BL(i).ExtremeRay1 = 2;  % mm
    
elseif PhaseSpaceFlag == 6  % leff, 9.9 kG, 20081219
    
    % BL 12.3.1 Nominal Rays (07-31-2008)
    i = i + 1;
    BL(i).Title = 'BL 12.3.1';
    BL(i).Number = [12 3 1];
    BL(i).Data0 = [
        0.35089, 0.26248
        0.36578, 0.25844
        0.38095, 0.23673
        0.36618, 0.24071
        ]';
    
    % Extreme Rays 2mm
    BL(i).Data1 = [
        0.34783, 0.26387
        0.36784, 0.25844
        0.38394, 0.23537
        0.36411, 0.24072
        ]';
    BL(i).ExtremeRay1 = 2;  % mm
    
elseif PhaseSpaceFlag == 7  % leff, 8.0 kG, 5 cm donstrem, 8mm offset, 20081222
    
    % BL 12.3.1 Nominal Rays
    i = i + 1;
    BL(i).Title = 'BL 12.3.1';
    BL(i).Number = [12 3 1];
    BL(i).Data0 = [
        0.35490, 0.25679
        0.36977, 0.25275
        0.38490, 0.23103
        0.37016, 0.23501
        ]';
    
    % Extreme Rays 2mm
    BL(i).Data1 = [
        0.35185, 0.25817
        0.37183, 0.25275
        0.38789, 0.22968
        0.36809, 0.23502
        ]';
    BL(i).ExtremeRay1 = 2;  % mm
    
elseif PhaseSpaceFlag == 8  % leff, 8.0 kG, 5 cm donstrem, 5mm offset, 20081222
    
    % BL 12.3.1 Nominal Rays
    i = i + 1;
    BL(i).Title = 'BL 12.3.1';
    BL(i).Number = [12 3 1];
    BL(i).Data0 = [
        0.35408, 0.25796
        0.36895, 0.25392
        0.38409, 0.23220
        0.36934, 0.23618
        ]';
    
    % Extreme Rays 2mm
    BL(i).Data1 = [
        0.35103, 0.25934
        0.37101, 0.25392
        0.38708, 0.23085
        0.36727, 0.23619
        ]';
    BL(i).ExtremeRay1 = 2;  % mm
    
else
    % Taking credit for permanent magnets (0.8 T), Data provided by Weishi Wan,
    % 2008-12-02, based on geometry data by Mike Kritscher of 2008-12-02,
    % entered by Christoph Steier, 2008-12-02
    %
    % BL 12.3.1 Nominal Rays
    i = i + 1;
    BL(i).Title = 'BL 12.3.1';
    BL(i).Number = [12 3 1];
    BL(i).Data0 = [
        0.35312, 0.25932
        0.36800, 0.25528
        0.38315, 0.23356
        0.36839, 0.23755
        ]';
    
    % Extreme Rays 2mm
    BL(i).Data1 = [
        0.35007, 0.26071
        0.37006, 0.25529
        0.38613, 0.23221
        0.36632, 0.23756
        ]';
    BL(i).ExtremeRay1 = 2;  % mm
end


if PhaseSpaceFlag == 0
    
    % No correct data exists for the unmodified case!
    % Christoph Steier, 20081015
    
else
    
    % There was an error in the old ideals. New ideal data based on
    % spreadsheet from Alexis from 20081103
    % Entered by Christoph Steier, 20081103
    
    % BL 12.3.2 Nominal Rays
    i = i + 1;
    BL(i).Title = 'BL 12.3.2';
    BL(i).Number = [12 3 2];
    BL(i).Data0 = [
        0.275560	0.221389
        0.290547	0.217020
        0.301268	0.201928
        0.286339	0.206297
        ]';
    
    % Extreme Rays 2mm
    BL(i).Data1 = [
        0.272428	0.222897
        0.292595	0.217020
        0.304376	0.200420
        0.284296	0.206297
        ]';
    BL(i).ExtremeRay1 = 2;  % New data is for 2 mm case !!!
    
    %     % There was an error in the old ideals. New ideal data based on
    %     % spreadsheet from Alexis from 20081008
    %     % Entered by Christoph Steier, 20081009
    %
    %     % BL 12.3.2 Nominal Rays
    %     i = i + 1;
    %     BL(i).Title = 'BL 12.3.2';
    %     BL(i).Number = [12 3 2];
    %     BL(i).Data0 = [
    %         0.275393	0.221622
    %         0.290381	0.217253
    %         0.301103	0.202161
    %         0.286174	0.206529
    %         ]';
    %
    %     % Extreme Rays 2mm
    %     BL(i).Data1 = [
    %         0.272260	0.223130
    %         0.292430	0.217253
    %         0.304212	0.200652
    %         0.284130	0.206529
    %         ]';
    %     BL(i).ExtremeRay1 = 2;  % New data is for 2 mm case !!!
    
end


