function EPBI = getepbichannelnames(Sector)
%GETEPBICHANNELNAMES - Returns a structure of EPBI arranged by heater
%

% Written by G. Portmann


% if ischar(Sector) && strcmpi(Sector, 'Initialize')
%     % One time initalization
%     [a,b,c] = xlsread('EPBI-II Settings.xls');
%     return
% end


if nargin < 1
    %error('Sector input required.');
    for Sector = [4 5 6 7 8 9 10 11 12]
        EPBI.(sprintf('Sector%d',Sector)) = getepbichannelnames(Sector);
    end
    return
end

% EPBI channel data rates
% throttle=1, 50 Hz, 20 msec
% else throttle * 20 msec
%setpv('SR11S___UP_throttle');
%setpv(sprintf('SR%02dS___UP_throttle', Sector), 5);
%setpv(sprintf('SR%02dS___DN_throttle', Sector), 5);

if Sector == 5
    SType = 'W';
else
    SType = 'S';
end

EPBI = [];
if any(Sector == [5 6 7 8 9 10 11 12])
    EPBI.Throttle = [
        sprintf('SR%02d%s___UP_throttle', Sector, SType)
        sprintf('SR%02d%s___DN_throttle', Sector, SType)
        ];
    
    EPBI.HeaterA0.TC = [
        sprintf('SR%02d%s___TCUP0__AM', Sector, SType)
        sprintf('SR%02d%s___TCUP1__AM', Sector, SType)
        sprintf('SR%02d%s___TCUP2__AM', Sector, SType)
        sprintf('SR%02d%s___TCUP3__AM', Sector, SType)
        sprintf('SR%02d%s___TCUP4__AM', Sector, SType)
        sprintf('SR%02d%s___TCUP5__AM', Sector, SType)
        sprintf('SR%02d%s___TCUP6__AM', Sector, SType)
        sprintf('SR%02d%s___TCUP7__AM', Sector, SType)
        sprintf('SR%02d%s___TCUP8__AM', Sector, SType)
        %sprintf('SR%02d%s___TCUP9__AM', Sector, SType)
        ];
    EPBI.HeaterA0.WF    = strcat(EPBI.HeaterA0.TC(:,1:end-3), 'WF', EPBI.HeaterA0.TC(:,end-2:end));
    EPBI.HeaterA0.Limit = strcat(EPBI.HeaterA0.TC(:,1:end-3), 'limit');
    
    EPBI.HeaterB0.TC = [
        sprintf('SR%02d%s___TCDN0__AM', Sector, SType)
        sprintf('SR%02d%s___TCDN1__AM', Sector, SType)
        sprintf('SR%02d%s___TCDN2__AM', Sector, SType)
        sprintf('SR%02d%s___TCDN3__AM', Sector, SType)
        sprintf('SR%02d%s___TCDN4__AM', Sector, SType)
        sprintf('SR%02d%s___TCDN5__AM', Sector, SType)
        sprintf('SR%02d%s___TCDN6__AM', Sector, SType)
        sprintf('SR%02d%s___TCDN7__AM', Sector, SType)
        sprintf('SR%02d%s___TCDN8__AM', Sector, SType)
        %sprintf('SR%02d%s___TCDN9__AM', Sector, SType)
        ];
    EPBI.HeaterB0.WF    = strcat(EPBI.HeaterB0.TC(:,1:end-3), 'WF', EPBI.HeaterB0.TC(:,end-2:end));
    EPBI.HeaterB0.Limit = strcat(EPBI.HeaterB0.TC(:,1:end-3), 'limit');
    
    EPBI.HeaterA0.OverTemp = [
        sprintf('SR%02d%s___TCUP0__BM', Sector, SType)
        sprintf('SR%02d%s___TCUP1__BM', Sector, SType)
        sprintf('SR%02d%s___TCUP2__BM', Sector, SType)
        sprintf('SR%02d%s___TCUP3__BM', Sector, SType)
        sprintf('SR%02d%s___TCUP4__BM', Sector, SType)
        sprintf('SR%02d%s___TCUP5__BM', Sector, SType)
        sprintf('SR%02d%s___TCUP6__BM', Sector, SType)
        sprintf('SR%02d%s___TCUP7__BM', Sector, SType)
        sprintf('SR%02d%s___TCUP8__BM', Sector, SType)
        %sprintf('SR%02d%s___TCUP9__BM', Sector, SType)
        ];
    
    EPBI.HeaterA0.IntlkSum = [
        sprintf('SR%02d%s___UP_OUT_BM', Sector, SType)
        sprintf('SR%02d%s___DN_OUT_BM', Sector, SType)];

    EPBI.HeaterA0.Intlk = [
        sprintf('SR%02d%s___TCUP0_L_BM', Sector, SType)
        sprintf('SR%02d%s___TCUP1_L_BM', Sector, SType)
        sprintf('SR%02d%s___TCUP2_L_BM', Sector, SType)
        sprintf('SR%02d%s___TCUP3_L_BM', Sector, SType)
        sprintf('SR%02d%s___TCUP4_L_BM', Sector, SType)
        sprintf('SR%02d%s___TCUP5_L_BM', Sector, SType)
        sprintf('SR%02d%s___TCUP6_L_BM', Sector, SType)
        sprintf('SR%02d%s___TCUP7_L_BM', Sector, SType)
        sprintf('SR%02d%s___TCUP8_L_BM', Sector, SType)
        %sprintf('SR%02d%s___TCUP9_L_BM', Sector, SType)
        ];

    EPBI.HeaterA0.Desc = {
        'TC0 Upper'
        'TC1 Upper'
        'TC2 Upper'
        'TC3 Upper'
        'TC4 Upper'
        'TC5 Upper'
        'TC6 Upper'
        'TC7 Upper'
        'TC8 Upper'
        };
    
    EPBI.HeaterB0.OverTemp = [
        sprintf('SR%02d%s___TCDN0__BM', Sector, SType)
        sprintf('SR%02d%s___TCDN1__BM', Sector, SType)
        sprintf('SR%02d%s___TCDN2__BM', Sector, SType)
        sprintf('SR%02d%s___TCDN3__BM', Sector, SType)
        sprintf('SR%02d%s___TCDN4__BM', Sector, SType)
        sprintf('SR%02d%s___TCDN5__BM', Sector, SType)
        sprintf('SR%02d%s___TCDN6__BM', Sector, SType)
        sprintf('SR%02d%s___TCDN7__BM', Sector, SType)
        sprintf('SR%02d%s___TCDN8__BM', Sector, SType)
        %sprintf('SR%02d%s___TCDN9__BM', Sector, SType)
        ];
    
    EPBI.HeaterB0.IntlkSum = [
        sprintf('SR%02d%s___UP_OUT_BM', Sector, SType)
        sprintf('SR%02d%s___DN_OUT_BM', Sector, SType)];

    EPBI.HeaterB0.Intlk = [
        sprintf('SR%02d%s___TCDN0_L_BM', Sector, SType)
        sprintf('SR%02d%s___TCDN1_L_BM', Sector, SType)
        sprintf('SR%02d%s___TCDN2_L_BM', Sector, SType)
        sprintf('SR%02d%s___TCDN3_L_BM', Sector, SType)
        sprintf('SR%02d%s___TCDN4_L_BM', Sector, SType)
        sprintf('SR%02d%s___TCDN5_L_BM', Sector, SType)
        sprintf('SR%02d%s___TCDN6_L_BM', Sector, SType)
        sprintf('SR%02d%s___TCDN7_L_BM', Sector, SType)
        sprintf('SR%02d%s___TCDN8_L_BM', Sector, SType)
        %sprintf('SR%02d%s___TCDN9_L_BM', Sector, SType)
        ];

    EPBI.HeaterB0.Desc = {
        'TC0 Lower'
        'TC1 Lower'
        'TC2 Lower'
        'TC3 Lower'
        'TC4 Lower'
        'TC5 Lower'
        'TC6 Lower'
        'TC7 Lower'
        'TC8 Lower'
        };
    
    EPBI.HeaterA0.HeaterDesc     = 'Unit A, Heater 0, Upper TCs';
    EPBI.HeaterA0.HeaterActivate = sprintf('SR%02d%s___UPHEAT_AT0',  Sector, SType);
    EPBI.HeaterA0.HeaterCancel   = sprintf('SR%02d%s___UPHEAT_RST0', Sector, SType);
    EPBI.HeaterA0.HeaterTimer    = sprintf('SR%02d%s___UPHEAT_AC0',  Sector, SType);
    
    EPBI.HeaterB0.HeaterDesc     = 'Unit B, Heater 0, Lower TCs';
    EPBI.HeaterB0.HeaterActivate = sprintf('SR%02d%s___DNHEAT_AT0',  Sector, SType);
    EPBI.HeaterB0.HeaterCancel   = sprintf('SR%02d%s___DNHEAT_RST0', Sector, SType);
    EPBI.HeaterB0.HeaterTimer    = sprintf('SR%02d%s___DNHEAT_AC0',  Sector, SType);
    
    %EPBI.HeaterB1.HeaterDesc     = 'Unit B, Heater 1';
    %EPBI.HeaterB1.HeaterActivate = sprintf('SR%02d%s___DNHEAT_AT1',  Sector, SType);
    %EPBI.HeaterB1.HeaterCancel   = sprintf('SR%02d%s___DNHEAT_RST1', Sector, SType);
    
elseif Sector == 4
    
    EPBI.Throttle = [
        sprintf('SR%02dS___UP_throttle', Sector)
        sprintf('SR%02dS___DN_throttle', Sector)
        ];

    EPBI.HeaterA0.TC = [
        'SR04S___TCMUR__AM' % 17'
        'SR04S___TCMUL__AM' % 16'
        'SR04S___TCMLR__AM' % 18'
        'SR04S___TCMLL__AM' % 19'
        ];
    EPBI.HeaterA0.WF    = strcat(EPBI.HeaterA0.TC(:,1:end-3), 'WF', EPBI.HeaterA0.TC(:,end-2:end));
    EPBI.HeaterA0.Limit = strcat(EPBI.HeaterA0.TC(:,1:end-3), 'limit');

    EPBI.HeaterA0.OverTemp = [
        'SR04S___TCMUR__BM'
        'SR04S___TCMUL__BM'
        'SR04S___TCMLR__BM'
        'SR04S___TCMLL__BM'
        ];
    
    EPBI.HeaterA0.IntlkSum = [
        sprintf('SR%02d%s___UP_OUT_BM', Sector, SType)
        sprintf('SR%02d%s___DN_OUT_BM', Sector, SType)];

    EPBI.HeaterA0.Intlk = [
        'SR04S___TCMUR_L_BM'
        'SR04S___TCMUL_L_BM'
        'SR04S___TCMLR_L_BM'
        'SR04S___TCMLL_L_BM'
        ];

    EPBI.HeaterA0.Desc = {
        'Mask Upper Right'
        'Mask Upper Left'
        'Mask Lower Right'
        'Mask Lower Left'
        };
    
    EPBI.HeaterB0.TC = [
        'SR04S___TCUL___AM' % 00'
        'SR04S___TCUR___AM' % 02'
        'SR04S___TCLL___AM' % 01'
        'SR04S___TCLR___AM' % 03'
        ];
    EPBI.HeaterB0.WF    = strcat(EPBI.HeaterB0.TC(:,1:end-3), 'WF', EPBI.HeaterB0.TC(:,end-2:end));
    EPBI.HeaterB0.Limit = strcat(EPBI.HeaterB0.TC(:,1:end-3), 'limit');

    EPBI.HeaterB0.OverTemp = [
        'SR04S___TCUL___BM'
        'SR04S___TCUR___BM'
        'SR04S___TCLL___BM'
        'SR04S___TCLR___BM'
        ];
    
    EPBI.HeaterB0.IntlkSum = [
        sprintf('SR%02d%s___UP_OUT_BM', Sector, SType)
        sprintf('SR%02d%s___DN_OUT_BM', Sector, SType)];

    EPBI.HeaterB0.IntlkSum = [
        sprintf('SR%02d%s___UP_OUT_BM', Sector, SType)
        sprintf('SR%02d%s___DN_OUT_BM', Sector, SType)];

    EPBI.HeaterB0.Intlk = [
        'SR04S___TCUL__L_BM'
        'SR04S___TCUR__L_BM'
        'SR04S___TCLL__L_BM'
        'SR04S___TCLR__L_BM'
        ];

    EPBI.HeaterB0.Desc = {
        'Up L 4.0 Exit Port'
        'Up R 4.0 Exit Port'
        'Low L 4.0 Exit Port'
        'Low R 4.0 Exit Port'
        };
    
    % Just a placeholder
    EPBI.HeaterA1 = [];
    
    % Note: other TC not interlocked
    % SR04S___TCMUM__AM20
    % SR04S___TCMUC__AM21
    % SR04S___TCMLM__AM23
    % Up Mask Ext
    % Up Vac Chamb
    % Low Mask Ext
    
    EPBI.HeaterB1.TC = [
        'SR04S___TCLB1__AM' % 25'
        'SR04S___TCLB2__AM' % 05'
        'SR04S___TCLQ___AM' % 07'
        'SR04S___TCLSD__AM' % 09'
        'SR04S___TCUB1__AM' % 24'
        'SR04S___TCUB2__AM' % 04'
        'SR04S___TCUQ___AM' % 06'
        'SR04S___TCUSD__AM' % 08'
        ];
    EPBI.HeaterB1.WF    = strcat(EPBI.HeaterB1.TC(:,1:end-3), 'WF', EPBI.HeaterB1.TC(:,end-2:end));
    EPBI.HeaterB1.Limit = strcat(EPBI.HeaterB1.TC(:,1:end-3), 'limit');
 
    EPBI.HeaterB1.OverTemp = [
        'SR04S___TCLB1__BM'
        'SR04S___TCLB2__BM'
        'SR04S___TCLQ___BM'
        'SR04S___TCLSD__BM'
        'SR04S___TCUB1__BM'
        'SR04S___TCUB2__BM'
        'SR04S___TCUQ___BM'
        'SR04S___TCUSD__BM'
        ];
    
    EPBI.HeaterB1.Intlk = [
        'SR04S___TCLB1_L_BM'
        'SR04S___TCLB2_L_BM'
        'SR04S___TCLQ__L_BM'
        'SR04S___TCLSD_L_BM'
        'SR04S___TCUB1_L_BM'
        'SR04S___TCUB2_L_BM'
        'SR04S___TCUQ__L_BM'
        'SR04S___TCUSD_L_BM'
        ];
    
    EPBI.HeaterB1.Desc = {
        'B1-1 Low'
        'B1-2 Low'
        'QFA Low'
        'SF Low'
        'B1-1 Up'
        'B1-2 UP'
        'QFA Up'
        'SF Up'
        };
    
    EPBI.HeaterA0.HeaterDesc     = 'Unit A, Heater 0, Mask';
    EPBI.HeaterA0.HeaterActivate = sprintf('SR%02dS___UPHEAT_AT0',  Sector);
    EPBI.HeaterA0.HeaterCancel   = sprintf('SR%02dS___UPHEAT_RST0', Sector);
    EPBI.HeaterA0.HeaterTimer    = sprintf('SR%02dS___UPHEAT_AC0',  Sector);

    EPBI.HeaterB0.HeaterDesc     = 'Unit B, Heater 0, Exit Port';
    EPBI.HeaterB0.HeaterActivate = sprintf('SR%02dS___DNHEAT_AT0',  Sector);
    EPBI.HeaterB0.HeaterCancel   = sprintf('SR%02dS___DNHEAT_RST0', Sector);
    EPBI.HeaterB0.HeaterTimer    = sprintf('SR%02dS___DNHEAT_AC0',  Sector);
    
    EPBI.HeaterB1.HeaterDesc     = 'Unit B, Heater 1, Merlin';
    EPBI.HeaterB1.HeaterActivate = sprintf('SR%02dS___DNHEAT_AT1',  Sector);
    EPBI.HeaterB1.HeaterCancel   = sprintf('SR%02dS___DNHEAT_RST1', Sector);
    EPBI.HeaterB1.HeaterTimer    = sprintf('SR%02dS___DNHEAT_AC1',  Sector);
end



% IG TC uses unit A heater 1"
if any(Sector == [4 5 6 7 8 9 10 11 12])
    EPBI.HeaterA1.TC             = sprintf('SR%02d%s___TCUP9__AM',   Sector, SType);
    EPBI.HeaterA1.WF             = sprintf('SR%02d%s___TCUP9_WF_AM', Sector, SType);
    EPBI.HeaterA1.Limit          = sprintf('SR%02d%s___TCUP9_limit', Sector, SType);
    EPBI.HeaterA1.OverTemp       = sprintf('SR%02d%s___TCUP9__BM',   Sector, SType);
    EPBI.HeaterA1.IntlkSum       = sprintf('SR%02d%s___UP_OUT_BM',   Sector, SType);
    EPBI.HeaterA1.Intlk          = sprintf('SR%02d%s___TCUP9_L_BM',  Sector, SType);
    EPBI.HeaterA1.Desc           = {'IG1 Aperture'};
    EPBI.HeaterA1.HeaterDesc     = 'Unit A, Heater 1, IG';
    EPBI.HeaterA1.HeaterActivate = sprintf('SR%02d%s___UPHEAT_AT1',  Sector, SType);
    EPBI.HeaterA1.HeaterCancel   = sprintf('SR%02d%s___UPHEAT_RST1', Sector, SType);
    EPBI.HeaterA1.HeaterTimer    = sprintf('SR%02d%s___UPHEAT_AC1',  Sector, SType);
    EPBI.HeaterA1.Relay          = sprintf('SR%02d%s___UP_OUT_BM',   Sector, SType);
end


% Unit C
if Sector == 5    
    EPBI.Throttle = [EPBI.Throttle
        sprintf('SR%02d%s___03_throttle', Sector, SType)
        ];
    EPBI.HeaterC0.TC = [
        'SR05W___TCIUP0__AM' % 00'
        'SR05W___TCIUP1__AM' % 01'
        'SR05W___TCIUP2__AM' % 02'
        'SR05W___TCIDN0__AM' % 03'
        'SR05W___TCIDN1__AM' % 04'
        'SR05W___TCIDN2__AM' % 05'
        ];
    EPBI.HeaterC0.WF    = strcat(EPBI.HeaterC0.TC(:,1:end-3), 'WF', EPBI.HeaterC0.TC(:,end-2:end));
    EPBI.HeaterC0.Limit = strcat(EPBI.HeaterC0.TC(:,1:end-3), 'limit');

    EPBI.HeaterC0.OverTemp = [
        'SR05W___TCIUP0__BM'
        'SR05W___TCIUP1__BM'
        'SR05W___TCIUP2__BM'
        'SR05W___TCIDN0__BM'
        'SR05W___TCIDN1__BM'
        'SR05W___TCIDN2__BM'
        ];
    
    EPBI.HeaterC0.IntlkSum = sprintf('SR%02d%s___03_OUT_BM', Sector, SType);

    EPBI.HeaterC0.Intlk = [
        'SR05W___TCIUP0_L_BM'
        'SR05W___TCIUP1_L_BM'
        'SR05W___TCIUP2_L_BM'
        'SR05W___TCIDN0_L_BM'
        'SR05W___TCIDN1_L_BM'
        'SR05W___TCIDN2_L_BM'
        ];
    EPBI.HeaterC0.Desc = {
        'ID Upper Upstream'
        'ID Upper Middle'
        'ID Upper Downstream'
        'ID Lower Upstream'
        'ID Lower Middle'
        'ID Lower Downstream'
        };    
    EPBI.HeaterC1.TC = [
        'SR05W___TCEFL0__AM' % 06'
        'SR05W___TCEFL1__AM' % 07'
        ];
    EPBI.HeaterC1.WF    = strcat(EPBI.HeaterC1.TC(:,1:end-3), 'WF', EPBI.HeaterC1.TC(:,end-2:end));
    EPBI.HeaterC1.Limit = strcat(EPBI.HeaterC1.TC(:,1:end-3), 'limit');

    EPBI.HeaterC1.OverTemp = [
        'SR05W___TCEFL0__BM'
        'SR05W___TCEFL1__BM'
        ];
    
    EPBI.HeaterC1.IntlkSum = sprintf('SR%02d%s___03_OUT_BM', Sector, SType);

    EPBI.HeaterC1.Intlk = [
        'SR05W___TCEFL0_L_BM'
        'SR05W___TCEFL1_L_BM'
        ];
    EPBI.HeaterC1.Desc = {
        'Exit Flange Upper'
        'Exit Flange Lower'
        };
    
    EPBI.HeaterC0.HeaterDesc     = 'Unit C, Heater 0, ID Chamber';
    EPBI.HeaterC0.HeaterActivate = 'SR05W___03HEAT_AT0';
    EPBI.HeaterC0.HeaterCancel   = 'SR05W___03HEAT_RST0';
    EPBI.HeaterC0.HeaterTimer    = 'SR05W___03HEAT_AC0';
    
    EPBI.HeaterC1.HeaterDesc     = 'Unit C, Heater 1, Exit Flange';
    EPBI.HeaterC1.HeaterActivate = 'SR05W___03HEAT_AT1';
    EPBI.HeaterC1.HeaterCancel   = 'SR05W___03HEAT_RST1';
    EPBI.HeaterC1.HeaterTimer    = 'SR05W___03HEAT_AC1';

    EPBI.HeaterC0.Relay = 'SR05W___UP_OUT_BM';  %???
    EPBI.HeaterC1.Relay = 'SR05W___UP_OUT_BM';
    
elseif Sector == 10

    EPBI.Throttle = [EPBI.Throttle
        sprintf('SR%02d%s___03_throttle', Sector, SType)
        ];
    EPBI.HeaterC1.TC = [
        'SR10S___TCUL__AM' % 00'
        'SR10S___TCLL__AM' % 01'
        'SR10S___TCUR__AM' % 02'
        'SR10S___TCLR__AM' % 03'
        ];
    EPBI.HeaterC1.WF    = strcat(EPBI.HeaterC1.TC(:,1:end-3), 'WF', EPBI.HeaterC1.TC(:,end-2:end));
    EPBI.HeaterC1.Limit = strcat(EPBI.HeaterC1.TC(:,1:end-3), 'limit');
    EPBI.HeaterC1.OverTemp = [
        'SR10S___TCUL__BM'
        'SR10S___TCLL__BM'
        'SR10S___TCUR__BM'
        'SR10S___TCLR__BM'
        ];
    EPBI.HeaterC1.Intlk = [
        'SR10S___TCUL_L_BM'
        'SR10S___TCLL_L_BM'
        'SR10S___TCUR_L_BM'
        'SR10S___TCLR_L_BM'
        ];
    EPBI.HeaterC1.Desc = {
        'TC Upper Left'
        'TC Lower Left'
        'TC Upper Right'
        'TC Lower Right'
        };
    
    EPBI.HeaterC1.HeaterDesc     = 'Unit C, Heater 0, ID';
    EPBI.HeaterC1.HeaterActivate = 'SR10S___03HEAT_AT0';
    EPBI.HeaterC1.HeaterCancel   = 'SR10S___03HEAT_RST0';
    EPBI.HeaterC1.HeaterTimer    = 'SR10S___03HEAT_AC0';
    EPBI.HeaterC1.Relay          = 'SR10S___UP_OUT_BM';  % ???
    
    
% elseif Sector == 11
%     
%     EPBI.Throttle = [EPBI.Throttle
%         sprintf('SR%02d%s___03_throttle', Sector, SType)
%         ];
%     EPBI.HeaterC0.TC = [
%         'SR11S___TCMUL__AM' % 04'
%         'SR11S___TCMUR__AM' % 05'
%         'SR11S___TCMLR__AM' % 06'
%         'SR11S___TCMLL__AM' % 07'
%         ];
%     EPBI.HeaterC0.WF    = strcat(EPBI.HeaterC0.TC(:,1:end-3), 'WF', EPBI.HeaterC0.TC(:,end-2:end));
%     EPBI.HeaterC0.Limit = strcat(EPBI.HeaterC0.TC(:,1:end-3), 'limit');
%     EPBI.HeaterC0.OverTemp = [
%         'SR11S___TCMUL__BM'
%         'SR11S___TCMUR__BM'
%         'SR11S___TCMLR__BM'
%         'SR11S___TCMLL__BM'
%         ];
%     EPBI.HeaterC0.Intlk = [
%         'SR11S___TCMUL_L_BM'
%         'SR11S___TCMUR_L_BM'
%         'SR11S___TCMLR_L_BM'
%         'SR11S___TCMLL_L_BM'
%         ];    
%     EPBI.HeaterC0.Desc = {
%         'ID Upper Upstream'
%         'ID Upper Middle'
%         'ID Upper Downstream'
%         'ID Lower Upstream'
%         };
%     
%     EPBI.HeaterC0.HeaterDesc     = 'Unit C, Heater 0, ID Chamber';
%     EPBI.HeaterC0.HeaterActivate = 'SR11S___03HEAT_AT0';
%     EPBI.HeaterC0.HeaterCancel   = 'SR11S___03HEAT_RST0';
%     EPBI.HeaterC0.HeaterTimer    = 'SR11S___03HEAT_AC0';
%     EPBI.HeaterC0.Relay          = 'SR11S___UP_OUT_BM';  % ???
end


