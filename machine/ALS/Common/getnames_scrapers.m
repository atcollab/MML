function ScraperTable = getnames_scrapers(Location, Direction)
% Location - 'BTS' or 'SR'
% Direction - 'Right', 'Left', 'Top', 'Bottom'
%
% 1. DeviceList
% 2. T/B/R/L
% 3. positive limit
% 4. negative limit 
% 5. home_status 
% 6. moving status 
% 7. readback value 
% 8. home command 
% 9. move to position command

ScraperTable{1} = [
    1 1
    1 1
    1 2
    1 2
    1 1
    1 1
    2 1
    2 6
    2 6
    3 1
    3 1
    3 1
    12 6
    ];

ScraperTable{2} = [
'left  '
'right '
'left  '
'right '
'top   '
'bottom'
'top   '
'bottom'
'top   '
'top   '
'bottom'
'right '
'top   '
];

% ScraperTable{3} = [
% 'BTS_____SCRAP1LAC01.HLS'
% 'BTS_____SCRAP1RAC01.HLS'
% 'BTS_____SCRAP2LAC01.HLS'
% 'BTS_____SCRAP2RAC01.HLS'
% 'SR01C___SCRAP1TAC01.HLS'
% 'SR01C___SCRAP1BAC01.HLS'
% 'SR02C___SCRAP1TAC01.HLS'
% 'SR02C___SCRAP1BAC01.HLS'
% 'SR02C___SCRAP6TAC01.HLS'
% 'SR03S___SCRAPT_AC01.HLS'
% 'SR03S___SCRAPB_AC02.HLS'
% 'SR03S___SCRAPH_AC00.HLS'
% 'SR12C___SCRAP6TAC01.HLS'
% ];
ScraperTable{3} = [
'BTS_____SCRAP1LAC01.HLS'
'BTS_____SCRAP1RAC01.HLS'
'BTS_____SCRAP2LAC01.HLS'
'BTS_____SCRAP2RAC01.HLS'
'SR01C___SCRAP1TAC01.HLS'
'SR01C___SCRAP1BAC01.HLS'
'SR02C___SCRAP1TAC01.HLS'
'SR02C___SCRAP1BAC01.HLS'
'SR02C___SCRAP6TAC01.HLS'
'SR03S___SCRAPT_AC01.CW '
'SR03S___SCRAPB_AC02.CW '
'SR03S___SCRAPH_AC00.CW '
'SR12C___SCRAP6TAC01.HLS'
];

% ScraperTable{4} = [
% 'BTS_____SCRAP1LAC01.LLS'
% 'BTS_____SCRAP1RAC01.LLS'
% 'BTS_____SCRAP2LAC01.LLS'
% 'BTS_____SCRAP2RAC01.LLS'
% 'SR01C___SCRAP1TAC01.LLS'
% 'SR01C___SCRAP1BAC01.LLS'
% 'SR02C___SCRAP1TAC01.LLS'
% 'SR02C___SCRAP1BAC01.LLS'
% 'SR02C___SCRAP6TAC01.LLS'
% 'SR03S___SCRAPT_AC01.LLS'
% 'SR03S___SCRAPB_AC02.LLS'
% 'SR03S___SCRAPH_AC00.LLS'
% 'SR12C___SCRAP6TAC01.LLS'
% ];
ScraperTable{4} = [
'BTS_____SCRAP1LAC01.LLS'
'BTS_____SCRAP1RAC01.LLS'
'BTS_____SCRAP2LAC01.LLS'
'BTS_____SCRAP2RAC01.LLS'
'SR01C___SCRAP1TAC01.LLS'
'SR01C___SCRAP1BAC01.LLS'
'SR02C___SCRAP1TAC01.LLS'
'SR02C___SCRAP1BAC01.LLS'
'SR02C___SCRAP6TAC01.LLS'
'SR03S___SCRAPT_AC01.CCW'
'SR03S___SCRAPB_AC02.CCW'
'SR03S___SCRAPH_AC00.CCW'
'SR12C___SCRAP6TAC01.LLS'
];

% ScraperTable{5} = [
% 'BTS_____SCRAP1LAC01_hchk'
% 'BTS_____SCRAP1RAC01_hchk'
% 'BTS_____SCRAP2LAC01_hchk'
% 'BTS_____SCRAP2RAC01_hchk'
% 'SR01C___SCRAP1TAC01_hchk'
% 'SR01C___SCRAP1BAC01_hchk'
% 'SR02C___SCRAP1TAC01_hchk'
% 'SR02C___SCRAP1BAC01_hchk'
% 'SR02C___SCRAP6TAC01_hchk'
% 'SR03S___SCRAPT_AC01_hchk'
% 'SR03S___SCRAPB_AC01_hchk'
% 'SR03S___SCRAPH_AC01_hchk'
% 'SR12C___SCRAP6TAC01_hchk'
% ];
ScraperTable{5} = [
'BTS_____SCRAP1LAC01_hchk'
'BTS_____SCRAP1RAC01_hchk'
'BTS_____SCRAP2LAC01_hchk'
'BTS_____SCRAP2RAC01_hchk'
'SR01C___SCRAP1TAC01_hchk'
'SR01C___SCRAP1BAC01_hchk'
'SR02C___SCRAP1TAC01_hchk'
'SR02C___SCRAP1BAC01_hchk'
'SR02C___SCRAP6TAC01_hchk'
'SR03S___SCRAPT_BM10     '
'SR03S___SCRAPB_BM11     '
'SR03S___SCRAPH_BM12     '
'SR12C___SCRAP6TAC01_hchk'
];

% ScraperTable{6} = [
% 'BTS_____SCRAP1LAC01.MIP'
% 'BTS_____SCRAP1RAC01.MIP'
% 'BTS_____SCRAP2LAC01.MIP'
% 'BTS_____SCRAP2RAC01.MIP'
% 'SR01C___SCRAP1TAC01.MIP'
% 'SR01C___SCRAP1BAC01.MIP'
% 'SR02C___SCRAP1TAC01.MIP'
% 'SR02C___SCRAP1BAC01.MIP'
% 'SR02C___SCRAP6TAC01.MIP'
% 'SR03S___SCRAPT_AC01.MIP'
% 'SR03S___SCRAPB_AC01.MIP'
% 'SR03S___SCRAPH_AC01.MIP'
% 'SR12C___SCRAP6TAC01.MIP'
% ];
ScraperTable{6} = [
'BTS_____SCRAP1LAC01.MIP '
'BTS_____SCRAP1RAC01.MIP '
'BTS_____SCRAP2LAC01.MIP '
'BTS_____SCRAP2RAC01.MIP '
'SR01C___SCRAP1TAC01.MIP '
'SR01C___SCRAP1BAC01.MIP '
'SR02C___SCRAP1TAC01.MIP '
'SR02C___SCRAP1BAC01.MIP '
'SR02C___SCRAP6TAC01.MIP '
'SR03S___SCRAPT_AC01.MOVN'
'SR03S___SCRAPB_AC02.MOVN'
'SR03S___SCRAPH_AC00.MOVN'
'SR12C___SCRAP6TAC01.MIP '
];

ScraperTable{7} = [
'BTS_____SCRAP1LAC01.RBV'
'BTS_____SCRAP1RAC01.RBV'
'BTS_____SCRAP2LAC01.RBV'
'BTS_____SCRAP2RAC01.RBV'
'SR01C___SCRAP1TAC01.RBV'
'SR01C___SCRAP1BAC01.RBV'
'SR02C___SCRAP1TAC01.RBV'
'SR02C___SCRAP1BAC01.RBV'
'SR02C___SCRAP6TAC01.RBV'
'SR03S___SCRAPT_AC01.RBV'
'SR03S___SCRAPB_AC02.RBV'
'SR03S___SCRAPH_AC00.RBV'
'SR12C___SCRAP6TAC01.RBV'
];

% ScraperTable{8} = [
% 'BTS_____SCRAP1LAC01_ctrl'
% 'BTS_____SCRAP1RAC01_ctrl'
% 'BTS_____SCRAP2LAC01_ctrl'
% 'BTS_____SCRAP2RAC01_ctrl'
% 'SR01C___SCRAP1TAC01_ctrl'
% 'SR01C___SCRAP1BAC01_ctrl'
% 'SR02C___SCRAP1TAC01_ctrl'
% 'SR02C___SCRAP1BAC01_ctrl'
% 'SR02C___SCRAP6TAC01_ctrl'
% 'SR03S___SCRAPT_AC01_ctrl'
% 'SR03S___SCRAPB_AC01_ctrl'
% 'SR03S___SCRAPH_AC01_ctrl'
% 'SR12C___SCRAP6TAC01_ctrl'
% ];
ScraperTable{8} = [
'BTS_____SCRAP1LAC01_ctrl'
'BTS_____SCRAP1RAC01_ctrl'
'BTS_____SCRAP2LAC01_ctrl'
'BTS_____SCRAP2RAC01_ctrl'
'SR01C___SCRAP1TAC01_ctrl'
'SR01C___SCRAP1BAC01_ctrl'
'SR02C___SCRAP1TAC01_ctrl'
'SR02C___SCRAP1BAC01_ctrl'
'SR02C___SCRAP6TAC01_ctrl'
'SR03S___SCRAPT_BC17     '
'SR03S___SCRAPB_BC18     '
'SR03S___SCRAPH_BC16     '
'SR12C___SCRAP6TAC01_ctrl'
];

ScraperTable{9} = [
'BTS_____SCRAP1LAC01'
'BTS_____SCRAP1RAC01'
'BTS_____SCRAP2LAC01'
'BTS_____SCRAP2RAC01'
'SR01C___SCRAP1TAC01'
'SR01C___SCRAP1BAC01'
'SR02C___SCRAP1TAC01'
'SR02C___SCRAP1BAC01'
'SR02C___SCRAP6TAC01'
'SR03S___SCRAPT_AC01'
'SR03S___SCRAPB_AC02'
'SR03S___SCRAPH_AC00'
'SR12C___SCRAP6TAC01'
];


if nargin >= 1
    if strcmpi(Location, 'BTS')
         ii = 1:4;
    elseif  strcmpi(Location, 'SR')
        ii = 5:13;
    end
    
    for i = 1:length(ScraperTable)
        ScraperTable{i} = ScraperTable{i}(ii,:);
    end
    
    for i = 2:length(ScraperTable)
        ScraperTable{i} = deblank(ScraperTable{i});
    end
end


if nargin >= 2
    if strcmpi(Direction, 'Right')
         SF = 'right';
    elseif  strcmpi(Direction, 'Left')
         SF = 'left';
    elseif  strcmpi(Direction, 'Top')
         SF = 'top';
    elseif  strcmpi(Direction, 'Bottom')
         SF = 'bottom';
    elseif  strcmpi(Direction, 'Horizontal')
         SF = 'right';
    end
    
    for i = 3:length(ScraperTable)
        for j = size(ScraperTable{i},1):-1:1
            if ~strcmpi(deblank(ScraperTable{2}(j,:)), SF)
                ScraperTable{i}(j,:) = [];
            end
        end
    end
end

