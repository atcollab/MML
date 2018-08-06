function scraper_app(choice)

%funtion is given choice of UPPER or LOWER
%function returns the lifetime and current at each of a number of scraper positions

steps = 23; %21;

if strcmp(choice,'UPPER') || strcmp(choice,'LOWER')
    data = zeros(4,steps);
    data(1,:) = [6 7 8 9 10 11 11.1 11.2 11.3 11.4 11.5 11.6 11.7 11.8 11.9 12 12.1 12.2 12.3 12.4 12.5 13 13.5 ];
elseif strcmp(choice,'INNER')       
    data = zeros(3,21);
    data(1,:) = [6 8 10 12 12.5 13 13.5 14 14.5 14.8 15 15.1 15.2 15.3 15.4 15.5 15.6 15.7 15.8 15.9 16];
elseif strcmp(choice,'OUTER')
    data = zeros(3,21);
    data(1,:) = [6 8 10 12 12.5 13 13.5 14 14.5 14.8 15 15.1 15.2 15.3 15.4 15.5 15.6 15.7 15.8 15.9 16];
end

time = clock;
filesave = ['/asp/usr/commissioning/scraperscan/ScraperScan' date '-' num2str(time(4)) '-' num2str(time(5)) '-' num2str(fix(time(6)))];
fprintf('Data saved to: %s\n',filesave);

    
scrape = ['SR11SCR01:' num2str(choice) '_POSITION_SP'];

for(i=1:steps)
    
    if getpv('SR11BCM01:CURRENT_MONITOR')<=5
        disp('ERROR: CURRENT IS LOW!');
        setpv(scrape,0);
        return
    end   
        
    setpv(scrape,data(1,i));
    pause(3);
    disp('gathering lifetime data')
    data(2,i) = lifetime(45);
    data(3,i) = getpv('SR11BCM01:CURRENT_MONITOR')    
    data(4,i) = data(2,i) * (data(3,i)/data(3,1)); 
    
    save(filesave, 'data');
    
end

setpv(scrape,0);
save(filesave, 'data');

figure(47)
plot(data(1,:),data(4,:))
temp = [choice ' SCRAPER DATA'];
title(temp)
xlabel('Scraper position (mm)')
ylabel('Normalised lifetime (h)')





    
    
    
    