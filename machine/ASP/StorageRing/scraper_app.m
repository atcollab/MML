function scraper_app(choice,lifemeas)

%funtion is given choice of UPPER or LOWER
%function returns the lifetime and current at each of a number of scraper positions


% 24/5/2007  curerntly runs both upper and lower scraper in. Will need to
% edit again to use only one scrper at a time.
% 04/07/2011 ET updated so single and double move of the scraper blades is
% possible. filename changes as well so data plots will not be compatible
% to previous files. Data saved is exactly the same will use the filename
% as the timestamp.

% +-0.15 is a calibration factor to account for the offset of the
% scraper relative to the beam center.
switch lower(choice)
    case 'upper'
        data(1,:) = [8:0.25:10 10.1:0.1:11 11.05:0.05:12.5 12.6:.1:14];
%         data(1,:) = [8 10 11 11.5 12 12.5 13 13.5 14 14.01 14.02 14.03 14.04 14.05 14.06 14.07 14.08 14.09 14.1 14.11 14.12 ...
%             14.13 14.14 14.15 14.16 14.17 14.18 14.19 14.2 14.21 14.22 14.23 14.24 14.25 14.26 14.27 14.28 14.29 14.3 14.31 ...
%             14.32 14.34 14.35 14.36 14.37 14.38 14.39 14.4 14.41 14.42 14.43 14.44 14.45 14.46 14.47 14.48 14.49 ...
%             14.5 14.51 14.52 14.53 14.54 14.55 14.56 14.57 14.58 14.59 14.6 14.61 14.62 14.63 14.64 14.65 14.66 ...
%             14.67 14.68 14.69 14.7 14.71  14.72 14.73 14.74 14.75 14.76 14.77 14.78 14.79 14.8 14.81 14.82 14.83 ...
%             14.84 14.85 14.86 14.87 14.88 14.89 14.9 14.91 14.92 14.93 14.94 14.95 14.96 14.97 14.98 14.99 15 ];
%     data(1,:) = [8 10 11 11.25 11.5 11.75 12 12.25 12.5 12.75 13 13.25 13.5 13.75 14 14.05 14.1 14.15 14.2 14.25 14.3 14.35 ...
%         14.4 14.45 14.5 14.55 14.6 14.65 14.7 14.75 14.8 14.81 14.82 14.83 14.85 14.9 14.95 15 15.01 15.02 15.03 15.04 15.05 ...
%         15.06 15.07 15.08 15.09 15.1 15.11 15.12 15.13 15.14 15.15 15.16 15.17 15.18 15.19 15.2 15.21 15.22 15.23 15.24 15.25 ...
%         15.26 15.27 15.28 15.29 15.3 15.31 15.32 15.33 15.34 15.35 15.36 15.37 15.38 15.39 15.4 15.41 15.42 15.43 15.44 15.45 ...
%         15.46 15.47 15.48 15.49 15.5 15.51 15.52 15.53 15.54 15.55 15.56 15.57 15.58 15.59 15.6 15.61 15.62 15.63 15.64 15.65 ...
%         15.66 15.67 15.68 15.69 15.7 15.71 15.72 15.73 15.74 15.75 15.76 15.77 15.78 15.79 15.8 15.81 15.82 15.83 15.84 15.85 ...
%         15.86 15.87 15.88 15.89 15.9 15.91 15.92 15.93 15.94 15.95 15.96 15.97 15.98 15.99 16];


        pospv = {'SR11SCR01:UPPER_POSITION_SP'};
        enablepv = {'SR11SCR01:UPPER_ENABLE_CMD'};

    case 'lower'
        data(1,:) = [8:0.25:10 10.1:0.1:11 11.05:0.05:12.5 12.6:.1:14];
%         data(1,:) =  [8 10 11 11.5 12 12.5 13 13.5 14 14.01 14.02 14.03 14.04 14.05 14.06 14.07 14.08 14.09 14.1 14.11 14.12 ...
%             14.13 14.14 14.15 14.16 14.17 14.18 14.19 14.2 14.21 14.22 14.23 14.24 14.25 14.26 14.27 14.28 14.29 14.3 14.31 ...
%             14.32 14.34 14.35 14.36 14.37 14.38 14.39 14.4 14.41 14.42 14.43 14.44 14.45 14.46 14.47 14.48 14.49 ...
%             14.5 14.51 14.52 14.53 14.54 14.55 14.56 14.57 14.58 14.59 14.6 14.61 14.62 14.63 14.64 14.65 14.66 ...
%             14.67 14.68 14.69 14.7 14.71  14.72 14.73 14.74 14.75 14.76 14.77 14.78 14.79 14.8 14.81 14.82 14.83 ...
%             14.84 14.85 14.86 14.87 14.88 14.89 14.9 14.91 14.92 14.93 14.94 14.95 14.96 14.97 14.98 14.99 15 ];
        pospv = {'SR11SCR01:LOWER_POSITION_SP'};
        enablepv = {'SR11SCR01:LOWER_ENABLE_CMD'};

    case 'inner'
        data(1,:) = [6 8 10 12 12.25, ...
            12.5 12.75 13 13.5 14 14.5 14.8 15 15.1 15.2 15.3 15.4 15.5 15.6 15.7 15.8 15.9 16];
        pospv = {'SR11SCR01:INNER_POSITION_SP'};
        enablepv = {'SR11SCR01:INNER_ENABLE_CMD'};
    case 'outer'
        data(1,:) = [6 8 10 12 12.5 13 13.5 14 14.5 14.8 15 15.1 15.2 15.3 15.4 15.5 15.6 15.7 15.8 15.9 16];
        pospv = {'SR11SCR01:OUTER_POSITION_SP'};
        enablepv = {'SR11SCR01:OUTER_ENABLE_CMD'};
        
    case 'both'
        data(1,:) = [8:0.25:10 10.1:0.1:11 11.05:0.05:12.5 12.6:.1:14];
        pospv = {'SR11SCR01:UPPER_POSITION_SP','SR11SCR01:LOWER_POSITION_SP'};
        enablepv = {'SR11SCR01:UPPER_ENABLE_CMD','SR11SCR01:LOWER_ENABLE_CMD'};
end

steps = size(data,2);
    

time = clock;
filesave = ['/asp/usr/measurements/scrapers/' appendtimestamp('ScraperScan')];
fprintf('Data saved to: %s\n',filesave);

for i=1:steps

    % if there is too little current then stop gathering data, save and
    % return may have dumped beam.
    if getpv('SR11BCM01:CURRENT_MONITOR')<=0.1
        disp('ERROR: CURRENT IS LOW!');
        % open up the scrapers
        setpv(pospv,repmat({0},size(pospv)));

        save(filesave, 'data');

        figure(47)
        plot(data(1,:),data(4,:))
        temp = ['UPPER & LOWER SCRAPER DATA'];
        title(temp)
        xlabel('Scraper position (mm)')
        ylabel('Normalised lifetime (h)')
        beep;
        return
    end

    setpv(enablepv,repmat({1},size(pospv)));
    pause(0.3);
    if strcmpi(choice,'both')
        setpv(pospv,{data(1,i)+0.15,data(1,i)-0.15});
    else
        setpv(pospv,{data(1,i)});
    end
    pause(3);
    
    % disable to improve lifetime measurements
    setpv(enablepv,repmat({0},size(pospv)));
    pause(0.3)
    disp('gathering lifetime data')
    if i > 1 && data(2,i-1) < data(2,1)/2
        % attempt to decrease the time required for a lifetime measurement
        % if the previous results show that the lifetime has already
        % decreased by 1/3 of the initial lifetime.
        data(2,i) = lifetime(lifemeas/2);
    else
        data(2,i) = lifetime(lifemeas);
    end
    data(3,i) = getpv('SR11BCM01:CURRENT_MONITOR');
    data(4,i) = data(2,i) * (data(3,i)/data(3,1));


    save(filesave, 'data');

end

setpv(enablepv,repmat({1},size(pospv)));
setpv(pospv,repmat({0},size(pospv)));
pause(6);
setpv(enablepv,repmat({0},size(pospv)));
    
save(filesave, 'data');

figure(47)
plot(data(1,:),data(4,:))

xlabel('Scraper position (mm)')
ylabel('Normalised lifetime (h)')

beep;
return


%%
time = clock;
filesave = ['/asp/usr/measurements/scrapers/ScraperScan' date '-' num2str(time(4)) '-' num2str(time(5)) '-' num2str(fix(time(6)))];
fprintf('Data saved to: %s\n',filesave);

scrape = ['SR11SCR01:' num2str(choice) '_POSITION_SP'];

for(j=1:steps)

    if getpv('SR11BCM01:CURRENT_MONITOR')<=5
        disp('ERROR: CURRENT IS LOW!');
        setpv(scrape,0);

        save(filesave, 'data');

        figure(47)
        plot(data(1,:),data(4,:))
        temp = [choice 'SCRAPER DATA'];
        title(temp)
        xlabel('Scraper position (mm)')
        ylabel('Normalised lifetime (h)')
        beep;
        return
    end

    setpv(scrape,data(1,j));
    pause(3);
    disp('gathering lifetime data')
    data(2,j) = lifetime(10);
    data(3,j) = getpv('SR11BCM01:CURRENT_MONITOR')
    data(4,j) = data(2,j) * (data(3,j)/data(3,j));

    save(filesave, 'data');

end

setpv(scrape,0);
save(filesave, 'data');

figure(47)
plot(data(1,:),data(4,:))
temp = [choice 'SCRAPER DATA'];
title(temp)
xlabel('Scraper position (mm)')
ylabel('Normalised lifetime (h)')

beep



