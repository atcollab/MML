function measure_JHscraper_lifetime

checkforao;

start_half_gap = 4.0;

try
    disp('Opening JHscrapers to starting halfgap.');
    disp(' ');
    set_jh_settings_nux16(start_half_gap)
    disp('my_setscrap finished - all scrapers are full open');
    disp(' ');
catch
    disp('my_setscrap timed out... running it again');
    disp(' ');
end

try
    set_jh_settings_nux16(start_half_gap)
    disp('my_setscrap finished - all scrapers are full open');
    disp(' ');
catch
    disp('my_setscrap timed out... running it again');
    disp(' ');
end

try
    set_jh_settings_nux16(start_half_gap)
    disp('my_setscrap finished - all scrapers are full open');
    disp(' ');
catch
    disp('my_setscrap timed out... running it again');
    disp(' ');
end

i=1;

for halfgap = [4.0:-.05:3.4]%[4.0:-.05:3.4]
    %fprintf('Enter %.2f next\n', halfgap);
    set_jh_settings_nux16(halfgap);
    jhsetting(i) = halfgap;
    dcct(i) = getdcct;
    pause(2)
    halfgap
    life(i) = getlife2(0.01);
    i = i+1;
end

gotodata
cd Scraper

Directory = getfamilydata('Directory','DataRoot');
save([Directory 'Scraper\jhscraper_lifetime_' datestr(now,30) '.mat'])

soundtada