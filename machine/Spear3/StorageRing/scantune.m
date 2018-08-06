% RASTER SCAN PROGRAM
% 
% DelNu		-	2 column vector, desired change in tunes from the starting tunes
% iNuX		-	integer, x tune counter
% iNuY		-	integer, y tune counter
% DelX		-	real, delta x tune changes
% DelY		-	real, delta y tune changes
% InitCurrent	-	2 column vector, Initial Currents
%
% Amps		-	2 column matrix with each column having
%			a length of NoTune, the settings for QF
%			and QD for each tune
% ThTune	-	2 column matrix with each column having
%			a length of NoTune, theoretical value of 
%			the tunes for each quadrupole setting
% DCCT		-	vector, value of the DCCT at each tune
% Counts	-	vector, number of counts per second
% Tunes         -	[data point number, tune]
% InitQFsp	-	vector, initial QF current setpoints before experiment
% InitQDsp	-	vector, initial QD current setpoints before experiment
% output.dat	-	file to which the data is printed 


  % Initialize
  TuneDelay = 15;

  if isempty(GeV)
    alspara;
  end


  Counts=[]; DCCT=[]; Amps=[]; ThTune=[]; Tunes=[]; DelTune=[0 0]; BPMxy=[];
  figure(1);

  disp(['  The delay before a tune measurement is set to ',num2str(TuneDelay), ' seconds.']);
  disp(['  If this is not enough (or too much), edit tunescan.m.']);
  disp(['  ']);

  fn = input('  File name (no extension!) = ','s');   disp(['  ']);
  fid2 = fopen([fn,'.dat'], 'wt+');   % Output data file


  % Print time/data to data file
  time=clock; 
  fprintf(fid2,'%% %s   %d:%d:%2.0f \n', date, time(4),time(5),time(6));
  fprintf(fid2,'%% Output file format  (BPM is sector10 #8)\n');
  fprintf(fid2,'%% data point #, QF [amps], QD [amps], ThTuneX, ThTuneY, Gamma Counts, DCCT, BPMx, BPMy\n\n');
  fprintf(fid2,'Data=[\n');


  % Initialize variables
  NumX = 30;					% Number of x tunes
  NumY = 16;					% Number of y tunes
  DelX = 0.005;					% Delta x steps
  DelY =-0.005;					% Delta y steps

  %Amps(1,1) = 74.3 + 0.186862;			% QF current
  %Amps(1,2) = 77.0 + 0.147173;			% QD current

  ThTune(1,1) = 0.3089;			% X tune
  ThTune(1,2) = 0.1687;			% Y tune

  DelAmps(1,:)=[0 0];
  DelNu = [0 ; 0];				% Delta Nu
  DelNuX = 0;					% Raster direction offset
  DirNuX = -1;					% Horizontal direction


  % Get raster scan arrays
  Num = 1;							% Tune counter number
  for iNuY = 0:(NumY-1)
    for iNuX = 0:(NumX-1)
      DelNu(1,1) = ((DirNuX)^(iNuY))*iNuX*DelX + DelNuX;
      DelNu(2,1) = iNuY*DelY;
      if ((iNuY == 0) & (iNuX == 0))
        %fprintf(fid,'%g  %g  %g  %g  %g \n', NumX*NumY, InitCurrent(1,1), InitCurrent(2,1),InitTune(1,1),InitTune(2,1));        
      else
        DelCur = inv(Mtune)*DelNu;
        %fprintf(fid,'%g  %g  %g  %g  %g \n', Num, DelCur(1,1), DelCur(2,1),DelNu(1,1),DelNu(2,1));
        DelAmps(Num,1) = DelCur(1,1);				% QF current
        DelAmps(Num,2) = DelCur(2,1);				% QD current
        ThTune(Num,1) = ThTune(1,1) + DelNu(1,1);		% Theoretical NuX
        ThTune(Num,2) = ThTune(1,2) + DelNu(2,1);		% Theoretical NuY
      end;
      Num = Num + 1;
    end;
    if (DirNuX)^(iNuY) > 0
      DelNuX = DelNu(1,1);
    else
      DelNuX = 0;
    end;
  end;


  % Store initial value of the quadrupole setpoints (return to these values at the end)
  InitQF = getsp('QF');          % save original QF setpoint
  InitQD = getsp('QD');          % save original QD setpoint

%  disp('Hit return when scraper is OUT'); pause;	
%  % Loop through raster scan to set hysteresis
%  for i=1:NumY
%    % Set Magnets
%    stepquad(DelAmps(i*NumX,1), DelAmps(i*NumX,2));
%
%    if (i*NumX+1<NumX*NumY)
%      stepquad(DelAmps(i*NumX,1), DelAmps(i*NumX,2));
%    end
%  end
%  % Return to start point
%  setquad(InitQF, InitQD);
%  disp('Hit return when scraper is IN'); pause;	

  % Loop through all the tunes measuring the current
  for i=1:NumX*NumY

    stepquad(DelAmps(i,1), DelAmps(i,2));
    sleep(1);
    Counts(i) = getgamma;
    DCCT(i) = getdcct;                            % measure current
    BPMxy(i,:) = [getx(1,[10 8]) gety(1,[10 8])]; % BPM sector 10, number 8

    if (i==1 | i==round(NumX/2) | i==NumX | i==NumX*NumY-NumX+1 | i==NumX*NumY-round(NumX/2)+1 | i==NumX*NumY),
      disp(['  Sleeping ',num2str(TuneDelay), ' seconds for tune measurement.']); sleep(TuneDelay); 		
      Tunes = [Tunes;
               gettune' i];
      if (i==1)
        DelTune =  Tunes(1,1:2) - ThTune(1,:);
      end
    end
    ThTune(i,:) = ThTune(i,:) + DelTune;


    % plot results
    if (rem(i,30)==0)
      plot3(ThTune(1:i,1), ThTune(1:i,2), Counts(1:i)); drawnow;
    end


    % Print out results
    %fprintf(     '%g  %g  %g  %g  %g  %g  %g  %g  %g\n', i, DelAmps(i,1), DelAmps(i,2), ThTune(i,1),ThTune(i,2), Counts(i), DCCT(i), BPMxy(i,1), BPMxy(i,2));
    fprintf(fid2,'%g  %g  %g  %g  %g  %g  %g  %g  %g\n', i, DelAmps(i,1), DelAmps(i,2), ThTune(i,1),ThTune(i,2), Counts(i), DCCT(i), BPMxy(i,1), BPMxy(i,2));


    % Break out of the program if the current drops below a .5 mA or Counts>6000
    if (DCCT(i) < .5), disp(' Beam current dropped to zero'); break; end; 
    if (Counts(i)>6000), disp(' Counts > 6000'); Counts(i); break; end;

  end


  fprintf(fid2,'];\n\n');
  fprintf(fid2,'Tunes=[\n');
  for i=1:size(Tunes,1)
    fprintf(fid2,'%g  %g  %g \n', Tunes(i,1), Tunes(i,2), Tunes(i,3));
  end 
  fprintf(fid2,'];\n');


  % Reset quads
  setquad(InitQF, InitQD);


  % Close file
  status = fclose(fid2); 
  eval(['save ', fn]);

  % Plot results
  figure(1);hold off;                           % set up figure
  plot(ThTune(:,1),ThTune(:,2),'r.');           % print theoretical tunes	
  hold on; 
  for i=1:size(Tunes,1)
    plot(Tunes(i,1),Tunes(i,2),'og');
    plot(ThTune(Tunes(i,3),1),ThTune(Tunes(i,3),2),'xr');
  end
  hold off;

  figure(2);
  N = max(size(Counts));
  plot3(ThTune(1:N,1), ThTune(1:N,2), Counts); 


