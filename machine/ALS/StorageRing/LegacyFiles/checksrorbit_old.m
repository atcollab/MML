function ErrorNums = checksrorbit(SectorList, IDBPMxtol,IDBPMytol)
%  ErrorNums =checksrorbit(Sector, IDBPMxtolerance [.015 mm], [IDBPMytolerance [.015 mm]])
%
% All input arguments are optional. If only two input arguments are provided, the same
% tolerance is used for both planes.

global elem36 elem45 BPMelem1278 BPMs

if nargin < 1
  SectorList = getlist('ID');
  SectorList = SectorList(:,1);
end
if isempty(SectorList)
  SectorList = getlist('ID');
  SectorList = SectorList(:,1);
end

if nargin < 2
  IDBPMxtol = .015;
  IDBPMytol = .015;
end

if nargin < 3
  IDBPMytol = IDBPMxtol;
end

if nargin > 3
   error('checksrorbit needs 0 to 3 input arguments');
end

if isempty(IDBPMxtol)
  IDBPMxtol = .015;
end
if isempty(IDBPMytol)
  IDBPMytol = .015;
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
	  	  
	  List = [Sector 1; Sector 2];
	  
	  % Using IDBPMs only 
	  IDBPMgoalx = getgolden('IDBPMx', List);
	  IDBPMgoaly = getgolden('IDBPMy', List);
	  
	  IDBPMfinalx = getidbpm('x', 1, List);
	  IDBPMfinaly = getidbpm('y', 1, List); 
	  
	  if any(abs(IDBPMfinalx-IDBPMgoalx)>IDBPMxtol) | any(abs(IDBPMfinaly-IDBPMgoaly)>IDBPMytol)
		  fprintf('                Present  Golden    Error\n');
		  fprintf('  IDBPMx(%2d,%d): %6.3f   %6.3f   %6.3f  [mm]\n', List(1,1), List(1,2), IDBPMfinalx(1), IDBPMgoalx(1), IDBPMfinalx(1)-IDBPMgoalx(1));
		  fprintf('  IDBPMx(%2d,%d): %6.3f   %6.3f   %6.3f  [mm]\n', List(2,1), List(2,2), IDBPMfinalx(2), IDBPMgoalx(2), IDBPMfinalx(2)-IDBPMgoalx(2));
		  fprintf('  IDBPMy(%2d,%d): %6.3f   %6.3f   %6.3f  [mm]\n', List(1,1), List(1,2), IDBPMfinaly(1), IDBPMgoaly(1), IDBPMfinaly(1)-IDBPMgoaly(1));
		  fprintf('  IDBPMy(%2d,%d): %6.3f   %6.3f   %6.3f  [mm]\n\n', List(2,1), List(2,2), IDBPMfinaly(2), IDBPMgoaly(2), IDBPMfinaly(2)-IDBPMgoaly(2));
		  pause(0);
		  ErrorNums = ErrorNums + 1;
	  end
	  
	  if Sector == 4
		  List = [Sector 3; Sector 4];
		  
		  % Using IDBPMs only 
		  IDBPMgoalx = getgolden('IDBPMx', List);
		  IDBPMgoaly = getgolden('IDBPMy', List);
		  
		  IDBPMfinalx = getidbpm('x', 1, List);
		  IDBPMfinaly = getidbpm('y', 1, List); 
		  
		  if any(abs(IDBPMfinalx-IDBPMgoalx)>IDBPMxtol) | any(abs(IDBPMfinaly-IDBPMgoaly)>IDBPMytol)
			  fprintf('                Present  Golden    Error\n');
			  fprintf('  IDBPMx(%2d,%d): %6.3f   %6.3f   %6.3f  [mm]\n', List(1,1), List(1,2), IDBPMfinalx(1), IDBPMgoalx(1), IDBPMfinalx(1)-IDBPMgoalx(1));
			  fprintf('  IDBPMx(%2d,%d): %6.3f   %6.3f   %6.3f  [mm]\n', List(2,1), List(2,2), IDBPMfinalx(2), IDBPMgoalx(2), IDBPMfinalx(2)-IDBPMgoalx(2));
			  fprintf('  IDBPMy(%2d,%d): %6.3f   %6.3f   %6.3f  [mm]\n', List(1,1), List(1,2), IDBPMfinaly(1), IDBPMgoaly(1), IDBPMfinaly(1)-IDBPMgoaly(1));
			  fprintf('  IDBPMy(%2d,%d): %6.3f   %6.3f   %6.3f  [mm]\n\n', List(2,1), List(2,2), IDBPMfinaly(2), IDBPMgoaly(2), IDBPMfinaly(2)-IDBPMgoaly(2));
			  pause(0);
			  ErrorNums = ErrorNums + 1;
		  end
	  end
	  
%	  if (Sector == 1 | Sector == 2 | Sector == 3 | Sector == 4 | Sector == 5 | Sector == 6 | Sector == 7 | Sector == 8 | Sector == 9 | Sector == 10 | Sector == 11 | Sector == 12)

	  List = [Sector 4; Sector 5];
	  
	  % Using IDBPMs only 
	  BBPMgoalx = getgolden('BBPMx', List);
	  BBPMgoaly = getgolden('BBPMy', List);
	  
	  BBPMfinalx = getbbpm('x', 1, List);
	  BBPMfinaly = getbbpm('y', 1, List); 
	  
	  if any(abs(BBPMfinalx-BBPMgoalx)>IDBPMxtol) | any(abs(BBPMfinaly-BBPMgoaly)>IDBPMytol)
		  fprintf('                Present  Golden    Error\n');
		  fprintf('  BBPMx(%2d,%d): %6.3f   %6.3f   %6.3f  [mm]\n', List(1,1), List(1,2), BBPMfinalx(1), BBPMgoalx(1), BBPMfinalx(1)-BBPMgoalx(1));
		  fprintf('  BBPMx(%2d,%d): %6.3f   %6.3f   %6.3f  [mm]\n', List(2,1), List(2,2), BBPMfinalx(2), BBPMgoalx(2), BBPMfinalx(2)-BBPMgoalx(2));
		  fprintf('  BBPMy(%2d,%d): %6.3f   %6.3f   %6.3f  [mm]\n', List(1,1), List(1,2), BBPMfinaly(1), BBPMgoaly(1), BBPMfinaly(1)-BBPMgoaly(1));
		  fprintf('  BBPMy(%2d,%d): %6.3f   %6.3f   %6.3f  [mm]\n\n', List(2,1), List(2,2), BBPMfinaly(2), BBPMgoaly(2), BBPMfinaly(2)-BBPMgoaly(2));
		  pause(0);
		  ErrorNums = ErrorNums + 1;
	  end
%	  end
	  
  else
	  
	  disp(['  Sector ',num2str(Sector),' does not have IDBPMs.']);
	  
  end
  
end
