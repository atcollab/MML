function [fnMeasMain, fnMeasBkgr] = idAuxReadReadElecBeamData(idName, gap, corName)

if strncmp(idName, 'U20', 3)
    
elseif strncmp(idName, 'HU80', 4)
    if strcmp(idName, 'HU80_TEMPO')
        if (gap == 15.5)
            if strcmp(corName, 'CHE')
                fnMeasMain = cellstr(['C2G15_5_he-10_ve0_hs0_vs0_2006-10-01_13-23-59'; 
                                      'C2G15_5_he-5_ve0_hs0_vs0_2006-10-01_13-25-02 '; 
                                      'C2G15_5_he0_ve0_hs0_vs0_2006-10-01_13-26-04  '; 
                                      'C2G15_5_he5_ve0_hs0_vs0_2006-10-01_13-27-04  '; 
                                      'C2G15_5_he10_ve0_hs0_vs0_2006-10-01_13-28-07 ']);
                fnMeasBkgr = cellstr(['C2G15_5_he0_ve0_hs0_vs0_2006-10-01_13-22-52  '; 
                                      'C2G15_5_he0_ve0_hs0_vs0_2006-10-01_13-22-52  '; 
                                      'C2G15_5_he0_ve0_hs0_vs0_2006-10-01_13-26-04  '; 
                                      'C2G15_5_he0_ve0_hs0_vs0_2006-10-01_13-26-04  '; 
                                      'C2G15_5_he0_ve0_hs0_vs0_2006-10-01_13-26-04  ']);
            elseif strcmp(corName, 'CVE')
                fnMeasMain = cellstr(['C2G15_5_he0_ve-10_hs0_vs0_2006-10-01_13-30-20'; 
                                      'C2G15_5_he0_ve-5_hs0_vs0_2006-10-01_13-31-23 '; 
                                      'C2G15_5_he0_ve0_hs0_vs0_2006-10-01_13-32-25  '; 
                                      'C2G15_5_he0_ve5_hs0_vs0_2006-10-01_13-33-29  '; 
                                      'C2G15_5_he0_ve10_hs0_vs0_2006-10-01_13-34-31 ']);
                fnMeasBkgr = cellstr(['C2G15_5_he0_ve0_hs0_vs0_2006-10-01_13-32-25'; 
                                      'C2G15_5_he0_ve0_hs0_vs0_2006-10-01_13-32-25'; 
                                      'C2G15_5_he0_ve0_hs0_vs0_2006-10-01_13-32-25'; 
                                      'C2G15_5_he0_ve0_hs0_vs0_2006-10-01_13-32-25'; 
                                      'C2G15_5_he0_ve0_hs0_vs0_2006-10-01_13-32-25']);
            elseif strcmp(corName, 'CHS')
                fnMeasMain = cellstr(['C2G15_5_he0_ve0_hs-10_vs0_2006-10-01_13-36-42'; 
                                      'C2G15_5_he0_ve0_hs-5_vs0_2006-10-01_13-37-37 '; 
                                      'C2G15_5_he0_ve0_hs0_vs0_2006-10-01_13-38-33  '; 
                                      'C2G15_5_he0_ve0_hs5_vs0_2006-10-01_13-39-27  '; 
                                      'C2G15_5_he0_ve0_hs10_vs0_2006-10-01_13-40-23 ']);
                fnMeasBkgr = cellstr(['C2G15_5_he0_ve0_hs0_vs0_2006-10-01_13-38-33'; 
                                      'C2G15_5_he0_ve0_hs0_vs0_2006-10-01_13-38-33'; 
                                      'C2G15_5_he0_ve0_hs0_vs0_2006-10-01_13-38-33'; 
                                      'C2G15_5_he0_ve0_hs0_vs0_2006-10-01_13-38-33'; 
                                      'C2G15_5_he0_ve0_hs0_vs0_2006-10-01_13-38-33']);
            elseif strcmp(corName, 'CVS')
                fnMeasMain = cellstr(['C2G15_5_he0_ve0_hs0_vs-10_2006-10-01_13-42-36'; 
                                      'C2G15_5_he0_ve0_hs0_vs-5_2006-10-01_13-43-30 '; 
                                      'C2G15_5_he0_ve0_hs0_vs0_2006-10-01_13-44-25  '; 
                                      'C2G15_5_he0_ve0_hs0_vs5_2006-10-01_13-45-23  '; 
                                      'C2G15_5_he0_ve0_hs0_vs10_2006-10-01_13-46-18 ']);
                fnMeasBkgr = cellstr(['C2G15_5_he0_ve0_hs0_vs0_2006-10-01_13-44-25'; 
                                      'C2G15_5_he0_ve0_hs0_vs0_2006-10-01_13-44-25'; 
                                      'C2G15_5_he0_ve0_hs0_vs0_2006-10-01_13-44-25'; 
                                      'C2G15_5_he0_ve0_hs0_vs0_2006-10-01_13-44-25'; 
                                      'C2G15_5_he0_ve0_hs0_vs0_2006-10-01_13-44-25']);
            end
        elseif (gap == 20)
            if strcmp(corName, 'CHE')
                fnMeasMain = cellstr(['C2G20_he-10_ve0_hs0_vs0_2006-10-01_13-58-32'; 
                                      'C2G20_he-5_ve0_hs0_vs0_2006-10-01_13-59-36 '; 
                                      'C2G20_he0_ve0_hs0_vs0_2006-10-01_14-00-40  '; 
                                      'C2G20_he5_ve0_hs0_vs0_2006-10-01_14-01-42  '; 
                                      'C2G20_he10_ve0_hs0_vs0_2006-10-01_14-02-45 ']);
                fnMeasBkgr = cellstr(['C2G20_he0_ve0_hs0_vs0_2006-10-01_14-00-40'; 
                                      'C2G20_he0_ve0_hs0_vs0_2006-10-01_14-00-40'; 
                                      'C2G20_he0_ve0_hs0_vs0_2006-10-01_14-00-40'; 
                                      'C2G20_he0_ve0_hs0_vs0_2006-10-01_14-00-40'; 
                                      'C2G20_he0_ve0_hs0_vs0_2006-10-01_14-00-40']);
            elseif strcmp(corName, 'CVE')
                fnMeasMain = cellstr(['C2G20_he0_ve-10_hs0_vs0_2006-10-01_14-04-58'; 
                                      'C2G20_he0_ve-5_hs0_vs0_2006-10-01_14-06-01 '; 
                                      'C2G20_he0_ve0_hs0_vs0_2006-10-01_14-07-02  '; 
                                      'C2G20_he0_ve5_hs0_vs0_2006-10-01_14-08-06  '; 
                                      'C2G20_he0_ve10_hs0_vs0_2006-10-01_14-09-11 ']);
                fnMeasBkgr = cellstr(['C2G20_he0_ve0_hs0_vs0_2006-10-01_14-07-02'; 
                                      'C2G20_he0_ve0_hs0_vs0_2006-10-01_14-07-02'; 
                                      'C2G20_he0_ve0_hs0_vs0_2006-10-01_14-07-02'; 
                                      'C2G20_he0_ve0_hs0_vs0_2006-10-01_14-07-02'; 
                                      'C2G20_he0_ve0_hs0_vs0_2006-10-01_14-07-02']);
            elseif strcmp(corName, 'CHS')
                fnMeasMain = cellstr(['C2G20_he0_ve0_hs-10_vs0_2006-10-01_14-11-25'; 
                                      'C2G20_he0_ve0_hs-5_vs0_2006-10-01_14-12-18 '; 
                                      'C2G20_he0_ve0_hs0_vs0_2006-10-01_14-13-12  '; 
                                      'C2G20_he0_ve0_hs5_vs0_2006-10-01_14-14-10  '; 
                                      'C2G20_he0_ve0_hs10_vs0_2006-10-01_14-15-03 ']);
                fnMeasBkgr = cellstr(['C2G20_he0_ve0_hs0_vs0_2006-10-01_14-13-12'; 
                                      'C2G20_he0_ve0_hs0_vs0_2006-10-01_14-13-12'; 
                                      'C2G20_he0_ve0_hs0_vs0_2006-10-01_14-13-12'; 
                                      'C2G20_he0_ve0_hs0_vs0_2006-10-01_14-13-12'; 
                                      'C2G20_he0_ve0_hs0_vs0_2006-10-01_14-13-12']);
            elseif strcmp(corName, 'CVS')
                fnMeasMain = cellstr(['C2G20_he0_ve0_hs0_vs-10_2006-10-01_14-17-13'; 
                                      'C2G20_he0_ve0_hs0_vs-5_2006-10-01_14-18-06 '; 
                                      'C2G20_he0_ve0_hs0_vs0_2006-10-01_14-19-00  '; 
                                      'C2G20_he0_ve0_hs0_vs5_2006-10-01_14-19-55  '; 
                                      'C2G20_he0_ve0_hs0_vs10_2006-10-01_14-20-50 ']);
                fnMeasBkgr = cellstr(['C2G20_he0_ve0_hs0_vs0_2006-10-01_14-19-00'; 
                                      'C2G20_he0_ve0_hs0_vs0_2006-10-01_14-19-00'; 
                                      'C2G20_he0_ve0_hs0_vs0_2006-10-01_14-19-00'; 
                                      'C2G20_he0_ve0_hs0_vs0_2006-10-01_14-19-00'; 
                                      'C2G20_he0_ve0_hs0_vs0_2006-10-01_14-19-00']);
            end
        elseif (gap == 25)
            if strcmp(corName, 'CHE')
                fnMeasMain = cellstr(['C2G25_he-10_ve0_hs0_vs0_2006-10-01_14-24-13'; 
                                      'C2G25_he-5_ve0_hs0_vs0_2006-10-01_14-25-16 '; 
                                      'C2G25_he0_ve0_hs0_vs0_2006-10-01_14-26-19  '; 
                                      'C2G25_he5_ve0_hs0_vs0_2006-10-01_14-27-21  '; 
                                      'C2G25_he10_ve0_hs0_vs0_2006-10-01_14-28-22 ']);
                fnMeasBkgr = cellstr(['C2G25_he0_ve0_hs0_vs0_2006-10-01_14-26-19'; 
                                      'C2G25_he0_ve0_hs0_vs0_2006-10-01_14-26-19'; 
                                      'C2G25_he0_ve0_hs0_vs0_2006-10-01_14-26-19'; 
                                      'C2G25_he0_ve0_hs0_vs0_2006-10-01_14-26-19'; 
                                      'C2G25_he0_ve0_hs0_vs0_2006-10-01_14-26-19']);
            elseif strcmp(corName, 'CVE')
                fnMeasMain = cellstr(['C2G25_he0_ve-10_hs0_vs0_2006-10-01_14-30-36'; 
                                      'C2G25_he0_ve-5_hs0_vs0_2006-10-01_14-31-39 '; 
                                      'C2G25_he0_ve0_hs0_vs0_2006-10-01_14-32-42  '; 
                                      'C2G25_he0_ve5_hs0_vs0_2006-10-01_14-33-45  '; 
                                      'C2G25_he0_ve10_hs0_vs0_2006-10-01_14-34-47 ']);
                fnMeasBkgr = cellstr(['C2G25_he0_ve0_hs0_vs0_2006-10-01_14-32-42'; 
                                      'C2G25_he0_ve0_hs0_vs0_2006-10-01_14-32-42'; 
                                      'C2G25_he0_ve0_hs0_vs0_2006-10-01_14-32-42'; 
                                      'C2G25_he0_ve0_hs0_vs0_2006-10-01_14-32-42'; 
                                      'C2G25_he0_ve0_hs0_vs0_2006-10-01_14-32-42']);
            elseif strcmp(corName, 'CHS')
                fnMeasMain = cellstr(['C2G25_he0_ve0_hs-10_vs0_2006-10-01_14-36-56'; 
                                      'C2G25_he0_ve0_hs-5_vs0_2006-10-01_14-37-52 '; 
                                      'C2G25_he0_ve0_hs0_vs0_2006-10-01_14-38-46  '; 
                                      'C2G25_he0_ve0_hs5_vs0_2006-10-01_14-39-43  '; 
                                      'C2G25_he0_ve0_hs10_vs0_2006-10-01_14-40-39 ']);
                fnMeasBkgr = cellstr(['C2G25_he0_ve0_hs0_vs0_2006-10-01_14-38-46'; 
                                      'C2G25_he0_ve0_hs0_vs0_2006-10-01_14-38-46'; 
                                      'C2G25_he0_ve0_hs0_vs0_2006-10-01_14-38-46'; 
                                      'C2G25_he0_ve0_hs0_vs0_2006-10-01_14-38-46'; 
                                      'C2G25_he0_ve0_hs0_vs0_2006-10-01_14-38-46']);
            elseif strcmp(corName, 'CVS')
                fnMeasMain = cellstr(['C2G25_he0_ve0_hs0_vs-10_2006-10-01_14-42-52'; 
                                      'C2G25_he0_ve0_hs0_vs-5_2006-10-01_14-43-47 '; 
                                      'C2G25_he0_ve0_hs0_vs0_2006-10-01_14-44-41  '; 
                                      'C2G25_he0_ve0_hs0_vs5_2006-10-01_14-45-33  '; 
                                      'C2G25_he0_ve0_hs0_vs10_2006-10-01_14-46-27 ']);
                fnMeasBkgr = cellstr(['C2G25_he0_ve0_hs0_vs0_2006-10-01_14-44-41'; 
                                      'C2G25_he0_ve0_hs0_vs0_2006-10-01_14-44-41'; 
                                      'C2G25_he0_ve0_hs0_vs0_2006-10-01_14-44-41'; 
                                      'C2G25_he0_ve0_hs0_vs0_2006-10-01_14-44-41'; 
                                      'C2G25_he0_ve0_hs0_vs0_2006-10-01_14-44-41']);
            end
        elseif (gap == 30)
            if strcmp(corName, 'CHE')
                fnMeasMain = cellstr(['C2G30_he-10_ve0_hs0_vs0_2006-10-01_14-49-26'; 
                                      'C2G30_he-5_ve0_hs0_vs0_2006-10-01_14-50-29 '; 
                                      'C2G30_he0_ve0_hs0_vs0_2006-10-01_14-51-32  '; 
                                      'C2G30_he5_ve0_hs0_vs0_2006-10-01_14-52-36  '; 
                                      'C2G30_he10_ve0_hs0_vs0_2006-10-01_14-53-40 ']);
                fnMeasBkgr = cellstr(['C2G30_he0_ve0_hs0_vs0_2006-10-01_14-51-32'; 
                                      'C2G30_he0_ve0_hs0_vs0_2006-10-01_14-51-32'; 
                                      'C2G30_he0_ve0_hs0_vs0_2006-10-01_14-51-32'; 
                                      'C2G30_he0_ve0_hs0_vs0_2006-10-01_14-51-32'; 
                                      'C2G30_he0_ve0_hs0_vs0_2006-10-01_14-51-32']);
            elseif strcmp(corName, 'CVE')
                fnMeasMain = cellstr(['C2G30_he0_ve-10_hs0_vs0_2006-10-01_14-55-58'; 
                                      'C2G30_he0_ve-5_hs0_vs0_2006-10-01_14-57-02 '; 
                                      'C2G30_he0_ve0_hs0_vs0_2006-10-01_14-58-04  '; 
                                      'C2G30_he0_ve5_hs0_vs0_2006-10-01_14-59-08  '; 
                                      'C2G30_he0_ve10_hs0_vs0_2006-10-01_15-00-11 ']);
                fnMeasBkgr = cellstr(['C2G30_he0_ve0_hs0_vs0_2006-10-01_14-58-04'; 
                                      'C2G30_he0_ve0_hs0_vs0_2006-10-01_14-58-04'; 
                                      'C2G30_he0_ve0_hs0_vs0_2006-10-01_14-58-04'; 
                                      'C2G30_he0_ve0_hs0_vs0_2006-10-01_14-58-04'; 
                                      'C2G30_he0_ve0_hs0_vs0_2006-10-01_15-01-17']); %'C2G30_he0_ve0_hs0_vs0_2006-10-01_14-58-04']);
            elseif strcmp(corName, 'CHS')
                fnMeasMain = cellstr(['C2G30_he0_ve0_hs-10_vs0_2006-10-01_15-02-20'; 
                                      'C2G30_he0_ve0_hs-5_vs0_2006-10-01_15-03-13 '; 
                                      'C2G30_he0_ve0_hs0_vs0_2006-10-01_15-04-09  '; 
                                      'C2G30_he0_ve0_hs5_vs0_2006-10-01_15-05-07  '; 
                                      'C2G30_he0_ve0_hs10_vs0_2006-10-01_15-06-02 ']);
                fnMeasBkgr = cellstr(['C2G30_he0_ve0_hs0_vs0_2006-10-01_15-04-09'; 
                                      'C2G30_he0_ve0_hs0_vs0_2006-10-01_15-04-09'; 
                                      'C2G30_he0_ve0_hs0_vs0_2006-10-01_15-04-09'; 
                                      'C2G30_he0_ve0_hs0_vs0_2006-10-01_15-04-09'; 
                                      'C2G30_he0_ve0_hs0_vs0_2006-10-01_15-04-09']);
            elseif strcmp(corName, 'CVS')
                fnMeasMain = cellstr(['C2G30_he0_ve0_hs0_vs-10_2006-10-01_15-08-12'; 
                                      'C2G30_he0_ve0_hs0_vs-5_2006-10-01_15-09-08 '; 
                                      'C2G30_he0_ve0_hs0_vs0_2006-10-01_15-10-02  '; 
                                      'C2G30_he0_ve0_hs0_vs5_2006-10-01_15-10-55  '; 
                                      'C2G30_he0_ve0_hs0_vs10_2006-10-01_15-11-48 ']);
                fnMeasBkgr = cellstr(['C2G30_he0_ve0_hs0_vs0_2006-10-01_15-10-02'; 
                                      'C2G30_he0_ve0_hs0_vs0_2006-10-01_15-10-02'; 
                                      'C2G30_he0_ve0_hs0_vs0_2006-10-01_15-10-02'; 
                                      'C2G30_he0_ve0_hs0_vs0_2006-10-01_15-10-02'; 
                                      'C2G30_he0_ve0_hs0_vs0_2006-10-01_15-10-02']);
            end
        elseif (gap == 40)
            
        elseif (gap == 50)
            
        elseif (gap == 60)

        elseif (gap == 80)

        elseif (gap == 110)

        end
    end %if strcmp(corName, 'HU80_TEMPO')
    
        
end %if strncmp(corName, 'HU80', 4)