function ErrorNums = checksrorbit(SectorList, BPMxtol,BPMytol)
%  ErrorNums =checksrorbit(Sector, BPMxtolerance [.015 mm], [BPMytolerance [.015 mm]])
%
% All input arguments are optional. If only two input arguments are provided, the same
% tolerance is used for both planes.

if nargin < 1
    SectorList = getlist('ID');
    SectorList = SectorList(:,1);
end
if isempty(SectorList)
    SectorList = getlist('ID');
    SectorList = SectorList(:,1);
end

if nargin < 2
    BPMxtol = .015;
    BPMytol = .015;
end

if nargin < 3
    BPMytol = BPMxtol;
end

if nargin > 3
    error('checksrorbit needs 0 to 3 input arguments');
end

if isempty(BPMxtol)
    BPMxtol = .015;
end
if isempty(BPMytol)
    BPMytol = .015;
end

ErrorNums = 0;

for i = 1:length(SectorList)

    Sector = SectorList(i);
    if Sector == 0
        x = getx;
        y = gety;

        Xgolden = getgolden('BPMx');
        Ygolden = getgolden('BPMy');

        Xerr = x-Xgolden;
        Yerr = y-Ygolden;

        subplot(2,1,1);
        plot(BPMs, Xerr);
        xlabel('BPM Position [meters]');
        ylabel('Horizontal [mm]');
        title('SR Orbit: Difference from the Golden Orbit');
        subplot(2,1,2);
        plot(BPMs, Yerr);
        xlabel('BPM Position [meters]');
        ylabel('Vertical [mm]');

        fprintf('  BPM Orbit:\n');
        fprintf('  Horizontal RMS Error from the golden orbit, all BPMs = %6.3f mm\n', std(Xerr));
        fprintf('  Horizontal RMS Error from the golden orbit, BPM 1278 = %6.3f mm\n', std(Xerr(BPMelem1278)));
        fprintf('  Horizontal RMS Error from the golden orbit, BPM 3456 = %6.3f mm\n', std(Xerr([elem36;elem45])));
        fprintf('  \n');
        fprintf('  Vertical   RMS Error from the golden orbit, all BPMs = %6.3f mm\n', std(Yerr));
        fprintf('  Vertical   RMS Error from the golden orbit, BPM 1278 = %6.3f mm\n', std(Yerr(BPMelem1278)));
        fprintf('  Vertical   RMS Error from the golden orbit, BPM 3456 = %6.3f mm\n', std(Yerr([elem36;elem45])));
        pause(0);

        %plot(BPMs, x-Xgolden,'r', BPMs, x-Xoffset,'b');
        %xlabel('BPM Position [meters]');
        %ylabel('Horizontal [mm]');
        %title('Difference orbits: red-Golden, blue-Offset');
        %subplot(2,1,2);
        %plot(BPMs, y-Ygolden,'r', BPMs, y-Yoffset,'b');
        %xlabel('BPM Position [meters]');
        %ylabel('Vertical [mm]');

    elseif ~isempty(find(Sector==[1 2 3 4 5 6 7 8 9 10 11 12]))

        if (Sector==4 | Sector==6 | Sector==11)
            List = [Sector-1 10; Sector-1 11; Sector-1 12; Sector 1];
            OldMLList = [Sector 1; Sector 3; Sector 4; Sector 2];
        else
            List = [Sector-1 10; Sector 1];
            OldMLList = [Sector 1; Sector 2];
        end

        % Using BPMs only
        BPMgoalx = getgolden('BPMx', List);
        BPMgoaly = getgolden('BPMy', List);

        BPMfinalx = getpv('BPMx', List);
        BPMfinaly = getpv('BPMy', List);

        if any(abs(BPMfinalx-BPMgoalx)>BPMxtol) | any(abs(BPMfinaly-BPMgoaly)>BPMytol)
            if (Sector==4 | Sector==6 | Sector==11)
                fprintf('                Present  Golden    Error\n');
                fprintf('  BPMx(%2d,%2d): %6.3f   %6.3f   %6.3f  [mm]           - old IDBPMx(%2d,%2d)\n', List(1,1), List(1,2), BPMfinalx(1), BPMgoalx(1), BPMfinalx(1)-BPMgoalx(1), OldMLList(1,1), OldMLList(1,2));
                fprintf('  BPMx(%2d,%2d): %6.3f   %6.3f   %6.3f  [mm]           - old IDBPMx(%2d,%2d)\n', List(2,1), List(2,2), BPMfinalx(2), BPMgoalx(2), BPMfinalx(2)-BPMgoalx(2), OldMLList(2,1), OldMLList(2,2));
                fprintf('  BPMx(%2d,%2d): %6.3f   %6.3f   %6.3f  [mm]           - old IDBPMx(%2d,%2d)\n', List(3,1), List(3,2), BPMfinalx(3), BPMgoalx(3), BPMfinalx(3)-BPMgoalx(3), OldMLList(3,1), OldMLList(3,2));
                fprintf('  BPMx(%2d,%2d): %6.3f   %6.3f   %6.3f  [mm]           - old IDBPMx(%2d,%2d)\n', List(4,1), List(4,2), BPMfinalx(4), BPMgoalx(4), BPMfinalx(4)-BPMgoalx(4), OldMLList(4,1), OldMLList(4,2));
                fprintf('  BPMy(%2d,%2d): %6.3f   %6.3f   %6.3f  [mm]           - old IDBPMy(%2d,%2d)\n', List(1,1), List(1,2), BPMfinaly(1), BPMgoaly(1), BPMfinaly(1)-BPMgoaly(1), OldMLList(1,1), OldMLList(1,2));
                fprintf('  BPMy(%2d,%2d): %6.3f   %6.3f   %6.3f  [mm]           - old IDBPMy(%2d,%2d)\n', List(2,1), List(2,2), BPMfinaly(2), BPMgoaly(2), BPMfinaly(2)-BPMgoaly(2), OldMLList(2,1), OldMLList(2,2));
                fprintf('  BPMy(%2d,%2d): %6.3f   %6.3f   %6.3f  [mm]           - old IDBPMy(%2d,%2d)\n', List(3,1), List(3,2), BPMfinaly(3), BPMgoaly(3), BPMfinaly(3)-BPMgoaly(3), OldMLList(3,1), OldMLList(3,2));
                fprintf('  BPMy(%2d,%2d): %6.3f   %6.3f   %6.3f  [mm]           - old IDBPMy(%2d,%2d)\n', List(4,1), List(4,2), BPMfinaly(4), BPMgoaly(4), BPMfinaly(4)-BPMgoaly(4), OldMLList(4,1), OldMLList(4,2));
                pause(0);
                ErrorNums = ErrorNums + 1;
            else
                fprintf('                Present  Golden    Error\n');
                fprintf('  BPMx(%2d,%2d): %6.3f   %6.3f   %6.3f  [mm]           - old IDBPMx(%2d,%2d)\n', List(1,1), List(1,2), BPMfinalx(1), BPMgoalx(1), BPMfinalx(1)-BPMgoalx(1), OldMLList(1,1), OldMLList(1,2));
                fprintf('  BPMx(%2d,%2d): %6.3f   %6.3f   %6.3f  [mm]           - old IDBPMx(%2d,%2d)\n', List(2,1), List(2,2), BPMfinalx(2), BPMgoalx(2), BPMfinalx(2)-BPMgoalx(2), OldMLList(2,1), OldMLList(2,2));
                fprintf('  BPMy(%2d,%2d): %6.3f   %6.3f   %6.3f  [mm]           - old IDBPMy(%2d,%2d)\n', List(1,1), List(1,2), BPMfinaly(1), BPMgoaly(1), BPMfinaly(1)-BPMgoaly(1), OldMLList(1,1), OldMLList(1,2));
                fprintf('  BPMy(%2d,%2d): %6.3f   %6.3f   %6.3f  [mm]           - old IDBPMy(%2d,%2d)\n', List(2,1), List(2,2), BPMfinaly(2), BPMgoaly(2), BPMfinaly(2)-BPMgoaly(2), OldMLList(2,1), OldMLList(2,2));
                pause(0);
                ErrorNums = ErrorNums + 1;
            end
        end


        % arc sector BPMs
        List = [Sector 5; Sector 6];
        OldMLList = [Sector 4; Sector 5];

        % Using BPMs only
        BPMgoalx = getgolden('BPMx', List);
        BPMgoaly = getgolden('BPMy', List);

        BPMfinalx = getpv('BPMx', List);
        BPMfinaly = getpv('BPMy', List);

        if any(abs(BPMfinalx-BPMgoalx)>BPMxtol) | any(abs(BPMfinaly-BPMgoaly)>BPMytol)
            fprintf('                Present  Golden    Error\n');
            fprintf('  BPMx(%2d,%2d): %6.3f   %6.3f   %6.3f  [mm]           - old  BBPMx(%2d,%2d)\n', List(1,1), List(1,2), BPMfinalx(1), BPMgoalx(1), BPMfinalx(1)-BPMgoalx(1), OldMLList(1,1), OldMLList(1,2));
            fprintf('  BPMx(%2d,%2d): %6.3f   %6.3f   %6.3f  [mm]           - old  BBPMx(%2d,%2d)\n', List(2,1), List(2,2), BPMfinalx(2), BPMgoalx(2), BPMfinalx(2)-BPMgoalx(2), OldMLList(2,1), OldMLList(2,2));
            fprintf('  BPMy(%2d,%2d): %6.3f   %6.3f   %6.3f  [mm]           - old  BBPMy(%2d,%2d)\n', List(1,1), List(1,2), BPMfinaly(1), BPMgoaly(1), BPMfinaly(1)-BPMgoaly(1), OldMLList(1,1), OldMLList(1,2));
            fprintf('  BPMy(%2d,%2d): %6.3f   %6.3f   %6.3f  [mm]           - old  BBPMy(%2d,%2d)\n', List(2,1), List(2,2), BPMfinaly(2), BPMgoaly(2), BPMfinaly(2)-BPMgoaly(2), OldMLList(2,1), OldMLList(2,2));
            pause(0);
            ErrorNums = ErrorNums + 1;
        end

    else

        disp(['  Sector ',num2str(Sector),' does not have BPMs.']);

    end

end
