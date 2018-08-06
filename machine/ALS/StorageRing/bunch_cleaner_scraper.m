function bunch_cleaner_scraper

bclean_offset_start = getpv('bcleanPatternOffset');

b = zeros(1,328);
b(298:318) =  1;
setpv('bcleanSetPattern', b);

disp('Setting a wider bunch cleaning pattern for pseudo-scraping');
disp('Turn on bunch cleaner manually to remove bunches')

while 1
    sprintf('DCCT = %.1d\n',getdcct);
    bclean_offset = getpv('bcleanPatternOffset');
    sprintf('Bunch Cleaner Offset is %i\n\n', bclean_offset);
    
    buttonname = questdlg('Step the bunch cleaner offset down 10 units?','Step Bunch Cleaner','Yes','No','No');
    switch buttonname
        case 'Yes'
            setpv('bcleanPatternOffset', bclean_offset-10);
        case('No')
            buttonname2 = questdlg('Reset the bunch cleaner pattern and offset?','Step Bunch Cleaner','Yes','No','Yes');
            switch buttonname2
                case 'Yes'
                    setpv('bcleanPatternOffset', 177);
                    b = zeros(1,328);
                    b(298:302) =  1;
                    b(310:314) = -1;
                    setpv('bcleanSetPattern', b);
                case('No')
            end
            break
    end
end

