function analorb(SectorList)
%  analorb(Sector)
%

% 2002-05, T.Scarvie
% Updated to draw IDBPMs in proper ring order (IDBPM(1,1) is at 194m) so graphs look right

%alsglobe
global Xgolden Ygolden
global BPMlist BPMlist1278
global BPMs BPMelem BPMelem1278
global elem18 elem27 elem36 elem45
global IDBPMlist IDBPMelem IDBPMs
global Xoffset Yoffset
global IDXoffset IDYoffset IDXgolden IDYgolden
global VCMs VCMelem VCMlist CMelem1278
global HCMs HCMelem HCMlist CMlist1278



if nargin < 1
  SectorList = [0;1;2;3;4;5;6;7;8;9;10;11;12];
end

[spos, svec] = sort(IDBPMs); % [2:24 1]; % used to sort data so that IDBPM(1,1) is shown at 194.4094m, where it should be (it is upstream from injection)

% Main

for i = 1:length(SectorList)
   Sector = SectorList(i);
   if Sector == 0
      
      x = getx;
      y = gety;
      Xerr = x-Xgolden;
      Yerr = y-Ygolden;
           
      subplot(2,2,1);
      plot(BPMs, Xerr);
      xlabel('BPM Position [meters]');
      ylabel('Horizontal [mm]');
      title('SR Orbit: Difference from the Golden Orbit');
      subplot(2,2,3);
      plot(BPMs, Yerr);
      xlabel('BPM Position [meters]');
      ylabel('Vertical [mm]');
      
      fprintf('  BPM Orbit:\n');
      fprintf('  Horizontal RMS Error from the golden orbit, all BPMs = %6.3f mm\n', std(Xerr));
      fprintf('  Horizontal RMS Error from the golden orbit, BPM 1278 = %6.3f mm\n', std(Xerr(BPMelem1278)));
      fprintf('  Horizontal RMS Error from the golden orbit, BPM 3456 = %6.3f mm\n', std(Xerr([elem36;elem45])));
      fprintf('  Vertical   RMS Error from the golden orbit, all BPMs = %6.3f mm\n', std(Yerr));
      fprintf('  Vertical   RMS Error from the golden orbit, BPM 1278 = %6.3f mm\n', std(Yerr(BPMelem1278)));
      fprintf('  Vertical   RMS Error from the golden orbit, BPM 3456 = %6.3f mm\n', std(Yerr([elem36;elem45])));
      
      x = getidx;
      sortx = x(svec);
      y = getidy;
      sorty = y(svec);
      Xerr = sortx-IDXgolden(IDBPMelem(svec));
      Yerr = sorty-IDYgolden(IDBPMelem(svec));
      subplot(2,2,2);
      plot(IDBPMs(IDBPMelem(svec)), Xerr,'o-');
      xlabel('IDBPM Position [meters]');
      ylabel('Horizontal [mm]');
      title('SR Orbit: Difference from the Golden Orbit');
      subplot(2,2,4);
      plot(IDBPMs(IDBPMelem(svec)), Yerr,'o-');
      xlabel('IDBPM Position [meters]');
      ylabel('Vertical [mm]');
      
      fprintf('  IDBPM Orbit:\n');
      fprintf('  Horizontal RMS Error from the golden orbit = %6.3f mm\n', std(Xerr));
      fprintf('  Vertical   RMS Error from the golden orbit = %6.3f mm\n', std(Yerr));

      pause(0);
      
   elseif ~isempty(find(Sector==[1 2 3 5 6 7 8 10 12]))
      
      % Using IDBPMs only 
      IDBPMgoalx = IDXgolden(dev2elem('IDBPMx',getlist('IDBPMx',Sector)));
      IDBPMgoaly = IDYgolden(dev2elem('IDBPMy',getlist('IDBPMy',Sector)));
         
      % Find the IDBPMs in the sector where the ID is located.
      ii=find(IDBPMlist(:,1)==Sector);
      IDxGoal = getidx;
      IDxGoal(ii) = IDBPMgoalx;

      IDyGoal = getidy;
      IDyGoal(ii) = IDBPMgoaly;
      
      IDBPMfinalx = getidbpm('x', 1, [Sector 1; Sector 2]);
      IDBPMfinaly = getidbpm('y', 1, [Sector 1; Sector 2]); 
      
      fprintf('                Present  Golden    Error\n');
      fprintf('  IDBPMx(%2d,1): %6.3f   %6.3f   %6.3f  [mm]\n', Sector, IDBPMfinalx(1), IDBPMgoalx(1), IDBPMfinalx(1)-IDBPMgoalx(1));
      fprintf('  IDBPMx(%2d,2): %6.3f   %6.3f   %6.3f  [mm]\n', Sector, IDBPMfinalx(2), IDBPMgoalx(2), IDBPMfinalx(2)-IDBPMgoalx(2));
      fprintf('  IDBPMy(%2d,1): %6.3f   %6.3f   %6.3f  [mm]\n', Sector, IDBPMfinaly(1), IDBPMgoaly(1), IDBPMfinaly(1)-IDBPMgoaly(1));
      fprintf('  IDBPMy(%2d,2): %6.3f   %6.3f   %6.3f  [mm]\n', Sector, IDBPMfinaly(2), IDBPMgoaly(2), IDBPMfinaly(2)-IDBPMgoaly(2));
      pause(0);
      
   elseif ~isempty(find(Sector==[4])) | ~isempty(find(Sector==[11]))
      
      % Using IDBPMs only 
      IDBPMgoalx = getgoldenorbit('IDBPMx',[Sector 1;Sector 3;Sector 4;Sector 2]);
      IDBPMgoaly = getgoldenorbit('IDBPMy',[Sector 1;Sector 3;Sector 4;Sector 2]);
               
      IDBPMfinalx = getidbpm('x', 1, [Sector 1;Sector 3;Sector 4;Sector 2]);
      IDBPMfinaly = getidbpm('y', 1, [Sector 1;Sector 3;Sector 4;Sector 2]); 
      
      fprintf('                Present  Golden    Error\n');
      fprintf('  IDBPMx(%2d,1): %6.3f   %6.3f   %6.3f  [mm]\n', Sector, IDBPMfinalx(1), IDBPMgoalx(1), IDBPMfinalx(1)-IDBPMgoalx(1));
      fprintf('  IDBPMx(%2d,3): %6.3f   %6.3f   %6.3f  [mm]\n', Sector, IDBPMfinalx(2), IDBPMgoalx(2), IDBPMfinalx(2)-IDBPMgoalx(2));
      fprintf('  IDBPMx(%2d,4): %6.3f   %6.3f   %6.3f  [mm]\n', Sector, IDBPMfinalx(3), IDBPMgoalx(3), IDBPMfinalx(3)-IDBPMgoalx(3));
      fprintf('  IDBPMx(%2d,2): %6.3f   %6.3f   %6.3f  [mm]\n', Sector, IDBPMfinalx(4), IDBPMgoalx(4), IDBPMfinalx(4)-IDBPMgoalx(4));
      fprintf('  IDBPMy(%2d,1): %6.3f   %6.3f   %6.3f  [mm]\n', Sector, IDBPMfinaly(1), IDBPMgoaly(1), IDBPMfinaly(1)-IDBPMgoaly(1));
      fprintf('  IDBPMy(%2d,3): %6.3f   %6.3f   %6.3f  [mm]\n', Sector, IDBPMfinaly(2), IDBPMgoaly(2), IDBPMfinaly(2)-IDBPMgoaly(2));
      fprintf('  IDBPMy(%2d,4): %6.3f   %6.3f   %6.3f  [mm]\n', Sector, IDBPMfinaly(3), IDBPMgoaly(3), IDBPMfinaly(3)-IDBPMgoaly(3));
      fprintf('  IDBPMy(%2d,2): %6.3f   %6.3f   %6.3f  [mm]\n', Sector, IDBPMfinaly(4), IDBPMgoaly(4), IDBPMfinaly(4)-IDBPMgoaly(4));
      pause(0);

      
   elseif ~isempty(find(Sector==[9]))
      
      
    	% Using IDBPMs only 
       
       
      	% below is the original code
    	%IDBPMgoalx = getgoldenorbit('IDBPMx',[9 1;9 2;9 4;9 5]);
      	%IDBPMgoaly = getgoldenorbit('IDBPMy',[9 1;9 2;9 4;9 5]);
            
      	%IDBPMfinalx = getidbpm('x', 1, [9 1;9 2;9 4;9 5]);
      	%IDBPMfinaly = getidbpm('y', 1, [9 1;9 2;9 4;9 5]); 
      
     	%fprintf('                Present  Golden    Error\n');
      	%fprintf('  IDBPMx(%2d,1): %6.3f   %6.3f   %6.3f  [mm]\n', Sector, IDBPMfinalx(1), IDBPMgoalx(1), IDBPMfinalx(1)-IDBPMgoalx(1));
      	%fprintf('  IDBPMx(%2d,2): %6.3f   %6.3f   %6.3f  [mm]\n', Sector, IDBPMfinalx(2), IDBPMgoalx(2), IDBPMfinalx(2)-IDBPMgoalx(2));
      	%fprintf('  IDBPMx(%2d,4): %6.3f   %6.3f   %6.3f  [mm]\n', Sector, IDBPMfinalx(3), IDBPMgoalx(3), IDBPMfinalx(3)-IDBPMgoalx(3));
      	%fprintf('  IDBPMx(%2d,5): %6.3f   %6.3f   %6.3f  [mm]\n', Sector, IDBPMfinalx(4), IDBPMgoalx(4), IDBPMfinalx(4)-IDBPMgoalx(4));
      	%fprintf('  IDBPMy(%2d,1): %6.3f   %6.3f   %6.3f  [mm]\n', Sector, IDBPMfinaly(1), IDBPMgoaly(1), IDBPMfinaly(1)-IDBPMgoaly(1));
      	%fprintf('  IDBPMy(%2d,2): %6.3f   %6.3f   %6.3f  [mm]\n', Sector, IDBPMfinaly(2), IDBPMgoaly(2), IDBPMfinaly(2)-IDBPMgoaly(2));
      	%fprintf('  IDBPMy(%2d,4): %6.3f   %6.3f   %6.3f  [mm]\n', Sector, IDBPMfinaly(3), IDBPMgoaly(3), IDBPMfinaly(3)-IDBPMgoaly(3));
      	%fprintf('  IDBPMy(%2d,5): %6.3f   %6.3f   %6.3f  [mm]\n', Sector, IDBPMfinaly(4), IDBPMgoaly(4), IDBPMfinaly(4)-IDBPMgoaly(4));
      	%pause(0);
         
         
      	%below includes work-around for the BBPMs
      	%IDBPMgoalx = getgoldenorbit('IDBPMx',[9 1;9 2]);
      	%IDBPMgoaly = getgoldenorbit('IDBPMy',[9 1;9 2]);
     	%BBPMgoalx = getgoldenorbit('BBPMx',[9 4;9 5])       
      	%BBPMgoaly = getgoldenorbit('BBPMy',[9 4;9 5])   
        
      	%IDBPMfinalx = getidbpm('x', 1, [9 1;9 2]);
      	%IDBPMfinaly = getidbpm('y', 1, [9 1;9 2]); 
      	%BBPMfinalx = getam('BBPMx', [9 4;9 5]); 
      	%BBPMfinaly = getam('BBPMy', [9 4;9 5]); 
      	
     	%fprintf('                Present  Golden    Error\n');
      	%fprintf('  IDBPMx(%2d,1): %6.3f   %6.3f   %6.3f  [mm]\n', Sector, IDBPMfinalx(1), IDBPMgoalx(1), IDBPMfinalx(1)-IDBPMgoalx(1));
      	%fprintf('  IDBPMx(%2d,2): %6.3f   %6.3f   %6.3f  [mm]\n', Sector, IDBPMfinalx(2), IDBPMgoalx(2), IDBPMfinalx(2)-IDBPMgoalx(2));
      	%fprintf('  BBPMx(%2d,4): %6.3f   %6.3f   %6.3f  [mm]\n', Sector, BBPMfinalx(1), BBPMgoalx(1), BBPMfinalx(1)-BBPMgoalx(1));
      	%fprintf('  BBPMx(%2d,5): %6.3f   %6.3f   %6.3f  [mm]\n', Sector, BBPMfinalx(2), BBPMgoalx(2), BBPMfinalx(2)-BBPMgoalx(2));
      	%fprintf('  IDBPMy(%2d,1): %6.3f   %6.3f   %6.3f  [mm]\n', Sector, IDBPMfinaly(1), IDBPMgoaly(1), IDBPMfinaly(1)-IDBPMgoaly(1));
      	%fprintf('  IDBPMy(%2d,2): %6.3f   %6.3f   %6.3f  [mm]\n', Sector, IDBPMfinaly(2), IDBPMgoaly(2), IDBPMfinaly(2)-IDBPMgoaly(2));
      	%fprintf('  BBPMy(%2d,4): %6.3f   %6.3f   %6.3f  [mm]\n', Sector, BBPMfinaly(1), BBPMgoaly(1), BBPMfinaly(1)-BBPMgoaly(1));
      	%fprintf('  BBPMy(%2d,5): %6.3f   %6.3f   %6.3f  [mm]\n', Sector, BBPMfinaly(2), BBPMgoaly(2), BBPMfinaly(2)-BBPMgoaly(2));
      	%pause(0);
      

      
      	% below has 9,4 9,5 removed so setbumps (and thus srcontrol4 orbit correction) works
     	IDBPMgoalx = getgoldenorbit('IDBPMx',[9 1;9 2]);
   		IDBPMgoaly = getgoldenorbit('IDBPMy',[9 1;9 2]);
               
      	IDBPMfinalx = getidbpm('x', 1, [9 1;9 2]);
      	IDBPMfinaly = getidbpm('y', 1, [9 1;9 2]); 
      
      	fprintf('                Present  Golden    Error\n');
      	fprintf('  IDBPMx(%2d,1): %6.3f   %6.3f   %6.3f  [mm]\n', Sector, IDBPMfinalx(1), IDBPMgoalx(1), IDBPMfinalx(1)-IDBPMgoalx(1));
      	fprintf('  IDBPMx(%2d,2): %6.3f   %6.3f   %6.3f  [mm]\n', Sector, IDBPMfinalx(2), IDBPMgoalx(2), IDBPMfinalx(2)-IDBPMgoalx(2));
      	fprintf('  IDBPMy(%2d,1): %6.3f   %6.3f   %6.3f  [mm]\n', Sector, IDBPMfinaly(1), IDBPMgoaly(1), IDBPMfinaly(1)-IDBPMgoaly(1));
      	fprintf('  IDBPMy(%2d,2): %6.3f   %6.3f   %6.3f  [mm]\n', Sector, IDBPMfinaly(2), IDBPMgoaly(2), IDBPMfinaly(2)-IDBPMgoaly(2));
      	pause(0);


   else
      disp(['  Sector ',num2str(Sector),' IDBPMs in question.']);   
   end
end



