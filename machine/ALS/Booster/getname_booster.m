function ChannelNames = getname_booster(Family, Field)


if strcmpi(Family, 'BPMx') && strcmpi(Field, 'Monitor')
    ChannelNames = [
        'BR1_____BPM1_X_AM00'
        'BR1_____BPM2_X_AM00'
        'BR1_____BPM3_X_AM00'
        'BR1_____BPM4_X_AM00'
        'BR1_____BPM5_X_AM00'
        'BR1_____BPM6_X_AM00'
        'BR1_____BPM7_X_AM00'
        'BR1_____BPM8_X_AM00'
        'BR2_____BPM1_X_AM00'
        'BR2_____BPM2_X_AM00'
        'BR2_____BPM3_X_AM00'
        'BR2_____BPM4_X_AM00'
        'BR2_____BPM5_X_AM00'
        'BR2_____BPM6_X_AM00'
        'BR2_____BPM7_X_AM00'
        'BR2_____BPM8_X_AM00'    
        'BR3_____BPM1_X_AM00'
        'BR3_____BPM2_X_AM00'
        'BR3_____BPM3_X_AM00'
        'BR3_____BPM4_X_AM00'
        'BR3_____BPM5_X_AM00'
        'BR3_____BPM6_X_AM00'
        'BR3_____BPM7_X_AM00'
        'BR3_____BPM8_X_AM00'
        'BR4_____BPM1_X_AM00'
        'BR4_____BPM2_X_AM00'
        'BR4_____BPM3_X_AM00'
        'BR4_____BPM4_X_AM00'
        'BR4_____BPM5_X_AM00'
        'BR4_____BPM6_X_AM00'
        'BR4_____BPM7_X_AM00'
        'BR4_____BPM8_X_AM00'
        ];
elseif strcmpi(Family, 'BPMy') && strcmpi(Field, 'Monitor')
    ChannelNames = [
        'BR1_____BPM1_Y_AM01'
        'BR1_____BPM2_Y_AM01'
        'BR1_____BPM3_Y_AM01'
        'BR1_____BPM4_Y_AM01'
        'BR1_____BPM5_Y_AM01'
        'BR1_____BPM6_Y_AM01'
        'BR1_____BPM7_Y_AM01'
        'BR1_____BPM8_Y_AM01'
        'BR2_____BPM1_Y_AM01'
        'BR2_____BPM2_Y_AM01'
        'BR2_____BPM3_Y_AM01'
        'BR2_____BPM4_Y_AM01'
        'BR2_____BPM5_Y_AM01'
        'BR2_____BPM6_Y_AM01'
        'BR2_____BPM7_Y_AM01'
        'BR2_____BPM8_Y_AM01'    
        'BR3_____BPM1_Y_AM01'
        'BR3_____BPM2_Y_AM01'
        'BR3_____BPM3_Y_AM01'
        'BR3_____BPM4_Y_AM01'
        'BR3_____BPM5_Y_AM01'
        'BR3_____BPM6_Y_AM01'
        'BR3_____BPM7_Y_AM01'
        'BR3_____BPM8_Y_AM01'
        'BR4_____BPM1_Y_AM01'
        'BR4_____BPM2_Y_AM01'
        'BR4_____BPM3_Y_AM01'
        'BR4_____BPM4_Y_AM01'
        'BR4_____BPM5_Y_AM01'
        'BR4_____BPM6_Y_AM01'
        'BR4_____BPM7_Y_AM01'
        'BR4_____BPM8_Y_AM01'
        ];

elseif strcmpi(Family, 'HCM') && strcmpi(Field, 'Monitor')
    ChannelNames = [
        'BR1_____HCM1___AM00'
        'BR1_____HCM2___AM03'
        'BR1_____HCM3___AM00'
        'BR1_____HCM4___AM03'
        'BR2_____HCM1___AM00'
        'BR2_____HCM2___AM03'
        'BR2_____HCM3___AM00'
        'BR2_____HCM4___AM03'
        'BR3_____HCM1___AM00'
        'BR3_____HCM2___AM03'
        'BR3_____HCM3___AM00'
        'BR3_____HCM4___AM03'
        'BR4_____HCM1___AM00'
        'BR4_____HCM2___AM03'
        'BR4_____HCM3___AM00'
        'BR4_____HCM4___AM03'
        ];

elseif strcmpi(Family, 'HCM') && strcmpi(Field, 'Setpoint')
    ChannelNames = [
        'BR1_____HCM1___AC00'
        'BR1_____HCM2___AC01'
        'BR1_____HCM3___AC00'
        'BR1_____HCM4___AC01'
        'BR2_____HCM1___AC00'
        'BR2_____HCM2___AC01'
        'BR2_____HCM3___AC00'
        'BR2_____HCM4___AC01'
        'BR3_____HCM1___AC00'
        'BR3_____HCM2___AC01'
        'BR3_____HCM3___AC00'
        'BR3_____HCM4___AC01'
        'BR4_____HCM1___AC00'
        'BR4_____HCM2___AC01'
        'BR4_____HCM3___AC00'
        'BR4_____HCM4___AC01'
        ];

elseif strcmpi(Family, 'HCM') && strcmpi(Field, 'Gain')
    ChannelNames = [
        'BR1_____HCM1_GNAC00'
        'BR1_____HCM2_GNAC01'
        'BR1_____HCM3_GNAC00'
        'BR1_____HCM4_GNAC01'
        'BR2_____HCM1_GNAC00'
        'BR2_____HCM2_GNAC01'
        'BR2_____HCM3_GNAC00'
        'BR2_____HCM4_GNAC01'
        'BR3_____HCM1_GNAC00'
        'BR3_____HCM2_GNAC01'
        'BR3_____HCM3_GNAC00'
        'BR3_____HCM4_GNAC01'
        'BR4_____HCM1_GNAC00'
        'BR4_____HCM2_GNAC01'
        'BR4_____HCM3_GNAC00'
        'BR4_____HCM4_GNAC01'
        ];

elseif strcmpi(Family, 'HCM') && strcmpi(Field, 'On')
    ChannelNames = [
        'BR1_____HCM1___BM01'
        'BR1_____HCM2___BM03'
        'BR1_____HCM3___BM01'
        'BR1_____HCM4___BM03'
        'BR2_____HCM1___BM01'
        'BR2_____HCM2___BM03'
        'BR2_____HCM3___BM01'
        'BR2_____HCM4___BM03'
        'BR3_____HCM1___BM01'
        'BR3_____HCM2___BM03'
        'BR3_____HCM3___BM01'
        'BR3_____HCM4___BM03'
        'BR4_____HCM1___BM01'
        'BR4_____HCM2___BM03'
        'BR4_____HCM3___BM01'
        'BR4_____HCM4___BM03'
        ];

elseif strcmpi(Family, 'HCM') && strcmpi(Field, 'OnControl')
    ChannelNames = [
        'BR1_____HCM1___BC22'
        'BR1_____HCM2___BC23'
        'BR1_____HCM3___BC22'
        'BR1_____HCM4___BC23'
        'BR2_____HCM1___BC22'
        'BR2_____HCM2___BC23'
        'BR2_____HCM3___BC22'
        'BR2_____HCM4___BC23'
        'BR3_____HCM1___BC22'
        'BR3_____HCM2___BC23'
        'BR3_____HCM3___BC22'
        'BR3_____HCM4___BC23'
        'BR4_____HCM1___BC22'
        'BR4_____HCM2___BC23'
        'BR4_____HCM3___BC22'
        'BR4_____HCM4___BC23'
        ];

elseif strcmpi(Family, 'HCM') && strcmpi(Field, 'EnableDAC')
    ChannelNames = [
        'BR1_____HCM1_REBC00'
        'BR1_____HCM2_REBC01'
        'BR1_____HCM3_REBC00'
        'BR1_____HCM4_REBC01'
        'BR2_____HCM1_REBC00'
        'BR2_____HCM2_REBC01'
        'BR2_____HCM3_REBC00'
        'BR2_____HCM4_REBC01'
        'BR3_____HCM1_REBC00'
        'BR3_____HCM2_REBC01'
        'BR3_____HCM3_REBC00'
        'BR3_____HCM4_REBC01'
        'BR4_____HCM1_REBC00'
        'BR4_____HCM2_REBC01'
        'BR4_____HCM3_REBC00'
        'BR4_____HCM4_REBC01'
        ];

    elseif strcmpi(Family, 'HCM') && strcmpi(Field, 'EnableDACRB')
    ChannelNames = [
        'BR1_____HCM1_REBM00'
        'BR1_____HCM2_REBM01'
        'BR1_____HCM3_REBM00'
        'BR1_____HCM4_REBM01'
        'BR2_____HCM1_REBM00'
        'BR2_____HCM2_REBM01'
        'BR2_____HCM3_REBM00'
        'BR2_____HCM4_REBM01'
        'BR3_____HCM1_REBM00'
        'BR3_____HCM2_REBM01'
        'BR3_____HCM3_REBM00'
        'BR3_____HCM4_REBM01'
        'BR4_____HCM1_REBM00'
        'BR4_____HCM2_REBM01'
        'BR4_____HCM3_REBM00'
        'BR4_____HCM4_REBM01'
        ];

elseif strcmpi(Family, 'HCM') && strcmpi(Field, 'EnableRamp')
    ChannelNames = [
    'B0101-1:ENABLE_RAMP'
    'B0101-1:ENABLE_RAMP'
    'B0101-1:ENABLE_RAMP'
    'B0101-1:ENABLE_RAMP'
    'B0201-1:ENABLE_RAMP'
    'B0201-1:ENABLE_RAMP'
    'B0201-1:ENABLE_RAMP'
    'B0201-1:ENABLE_RAMP'
    'B0301-1:ENABLE_RAMP'
    'B0301-1:ENABLE_RAMP'
    'B0301-1:ENABLE_RAMP'
    'B0301-1:ENABLE_RAMP'
    'B0401-1:ENABLE_RAMP'
    'B0401-1:ENABLE_RAMP'
    'B0401-1:ENABLE_RAMP'
    'B0401-1:ENABLE_RAMP'
    ];

elseif strcmpi(Family, 'HCM') && strcmpi(Field, 'Ready')
    ChannelNames = [
        'BR1_____HCM1___BM00'
        'BR1_____HCM2___BM02'
        'BR1_____HCM3___BM01'
        'BR1_____HCM4___BM02'
        'BR2_____HCM1___BM00'
        'BR2_____HCM2___BM02'
        'BR2_____HCM3___BM01'
        'BR2_____HCM4___BM02'
        'BR3_____HCM1___BM00'
        'BR3_____HCM2___BM02'
        'BR3_____HCM3___BM01'
        'BR3_____HCM4___BM02'
        'BR4_____HCM1___BM00'
        'BR4_____HCM2___BM02'
        'BR4_____HCM3___BM01'
        'BR4_____HCM4___BM02'
        ];


elseif strcmpi(Family, 'VCM') && strcmpi(Field, 'Monitor')
    ChannelNames = [
        'BR1_____VCM1___AM00'
        'BR1_____VCM2___AM03'
        'BR1_____VCM3___AM00'
        'BR1_____VCM4___AM03'
        'BR2_____VCM1___AM00'
        'BR2_____VCM2___AM03'
        'BR2_____VCM3___AM00'
        'BR2_____VCM4___AM03'
        'BR3_____VCM1___AM00'
        'BR3_____VCM2___AM03'
        'BR3_____VCM3___AM00'
        'BR3_____VCM4___AM03'
        'BR4_____VCM1___AM00'
        'BR4_____VCM2___AM03'
        'BR4_____VCM3___AM00'
        'BR4_____VCM4___AM03'
        ];

elseif strcmpi(Family, 'VCM') && strcmpi(Field, 'Setpoint')
    ChannelNames = [
        'BR1_____VCM1___AC00'
        'BR1_____VCM2___AC01'
        'BR1_____VCM3___AC00'
        'BR1_____VCM4___AC01'
        'BR2_____VCM1___AC00'
        'BR2_____VCM2___AC01'
        'BR2_____VCM3___AC00'
        'BR2_____VCM4___AC01'
        'BR3_____VCM1___AC00'
        'BR3_____VCM2___AC01'
        'BR3_____VCM3___AC00'
        'BR3_____VCM4___AC01'
        'BR4_____VCM1___AC00'
        'BR4_____VCM2___AC01'
        'BR4_____VCM3___AC00'
        'BR4_____VCM4___AC01'
        ];

elseif strcmpi(Family, 'VCM') && strcmpi(Field, 'Gain')
    ChannelNames = [
        'BR1_____VCM1_GNAC00'
        'BR1_____VCM2_GNAC01'
        'BR1_____VCM3_GNAC00'
        'BR1_____VCM4_GNAC01'
        'BR2_____VCM1_GNAC00'
        'BR2_____VCM2_GNAC01'
        'BR2_____VCM3_GNAC00'
        'BR2_____VCM4_GNAC01'
        'BR3_____VCM1_GNAC00'
        'BR3_____VCM2_GNAC01'
        'BR3_____VCM3_GNAC00'
        'BR3_____VCM4_GNAC01'
        'BR4_____VCM1_GNAC00'
        'BR4_____VCM2_GNAC01'
        'BR4_____VCM3_GNAC00'
        'BR4_____VCM4_GNAC01'
        ];

elseif strcmpi(Family, 'VCM') && strcmpi(Field, 'On')
    ChannelNames = [
        'BR1_____VCM1___BM01'
        'BR1_____VCM2___BM03'
        'BR1_____VCM3___BM01'
        'BR1_____VCM4___BM03'
        'BR2_____VCM1___BM01'
        'BR2_____VCM2___BM03'
        'BR2_____VCM3___BM01'
        'BR2_____VCM4___BM03'
        'BR3_____VCM1___BM01'
        'BR3_____VCM2___BM03'
        'BR3_____VCM3___BM01'
        'BR3_____VCM4___BM03'
        'BR4_____VCM1___BM01'
        'BR4_____VCM2___BM03'
        'BR4_____VCM3___BM01'
        'BR4_____VCM4___BM03'
        ];

elseif strcmpi(Family, 'VCM') && strcmpi(Field, 'OnControl')
    ChannelNames = [
        'BR1_____VCM1___BC22'
        'BR1_____VCM2___BC23'
        'BR1_____VCM3___BC22'
        'BR1_____VCM4___BC23'
        'BR2_____VCM1___BC22'
        'BR2_____VCM2___BC23'
        'BR2_____VCM3___BC22'
        'BR2_____VCM4___BC23'
        'BR3_____VCM1___BC22'
        'BR3_____VCM2___BC23'
        'BR3_____VCM3___BC22'
        'BR3_____VCM4___BC23'
        'BR4_____VCM1___BC22'
        'BR4_____VCM2___BC23'
        'BR4_____VCM3___BC22'
        'BR4_____VCM4___BC23'
        ];

elseif strcmpi(Family, 'VCM') && strcmpi(Field, 'EnableDAC')
    ChannelNames = [
        'BR1_____VCM1_REBC00'
        'BR1_____VCM2_REBC01'
        'BR1_____VCM3_REBC00'
        'BR1_____VCM4_REBC01'
        'BR2_____VCM1_REBC00'
        'BR2_____VCM2_REBC01'
        'BR2_____VCM3_REBC00'
        'BR2_____VCM4_REBC01'
        'BR3_____VCM1_REBC00'
        'BR3_____VCM2_REBC01'
        'BR3_____VCM3_REBC00'
        'BR3_____VCM4_REBC01'
        'BR4_____VCM1_REBC00'
        'BR4_____VCM2_REBC01'
        'BR4_____VCM3_REBC00'
        'BR4_____VCM4_REBC01'
        ];
elseif strcmpi(Family, 'VCM') && strcmpi(Field, 'EnableDACRB')
    ChannelNames = [
        'BR1_____VCM1_REBM00'
        'BR1_____VCM2_REBM01'
        'BR1_____VCM3_REBM00'
        'BR1_____VCM4_REBM01'
        'BR2_____VCM1_REBM00'
        'BR2_____VCM2_REBM01'
        'BR2_____VCM3_REBM00'
        'BR2_____VCM4_REBM01'
        'BR3_____VCM1_REBM00'
        'BR3_____VCM2_REBM01'
        'BR3_____VCM3_REBM00'
        'BR3_____VCM4_REBM01'
        'BR4_____VCM1_REBM00'
        'BR4_____VCM2_REBM01'
        'BR4_____VCM3_REBM00'
        'BR4_____VCM4_REBM01'
        ];
    
elseif strcmpi(Family, 'VCM') && strcmpi(Field, 'EnableRamp')
    ChannelNames = [
    'B0102-1:ENABLE_RAMP'
    'B0102-1:ENABLE_RAMP'
    'B0102-1:ENABLE_RAMP'
    'B0102-1:ENABLE_RAMP'
    'B0202-1:ENABLE_RAMP'
    'B0202-1:ENABLE_RAMP'
    'B0202-1:ENABLE_RAMP'
    'B0202-1:ENABLE_RAMP'
    'B0302-1:ENABLE_RAMP'
    'B0302-1:ENABLE_RAMP'
    'B0302-1:ENABLE_RAMP'
    'B0302-1:ENABLE_RAMP'
    'B0402-1:ENABLE_RAMP'
    'B0402-1:ENABLE_RAMP'
    'B0402-1:ENABLE_RAMP'
    'B0402-1:ENABLE_RAMP'
    ];

elseif strcmpi(Family, 'VCM') && strcmpi(Field, 'Ready')
    ChannelNames = [
        'BR1_____VCM1___BM00'
        'BR1_____VCM2___BM02'
        'BR1_____VCM3___BM01'
        'BR1_____VCM4___BM02'
        'BR2_____VCM1___BM00'
        'BR2_____VCM2___BM02'
        'BR2_____VCM3___BM01'
        'BR2_____VCM4___BM02'
        'BR3_____VCM1___BM00'
        'BR3_____VCM2___BM02'
        'BR3_____VCM3___BM01'
        'BR3_____VCM4___BM02'
        'BR4_____VCM1___BM00'
        'BR4_____VCM2___BM02'
        'BR4_____VCM3___BM01'
        'BR4_____VCM4___BM02'
        ];

elseif strcmpi(Family, 'QF') && strcmpi(Field, 'Monitor')
    ChannelNames = [];
    for i = 1:32
       %ChannelNames = [ChannelNames; 'BR1_____QF_REF_AM01'];
        ChannelNames = [ChannelNames; 'BR1_____QFIE___AM01'];
    end

elseif strcmpi(Family, 'QF') && strcmpi(Field, 'Setpoint')
    ChannelNames = [];
    for i = 1:32
       %ChannelNames = [ChannelNames; 'BR1_____QF_REF_AC00'];
        ChannelNames = [ChannelNames; 'BR1_____QFIE___AC01'];
    end

elseif strcmpi(Family, 'QF') && strcmpi(Field, 'On')
    ChannelNames = [];
    for i = 1:32
        ChannelNames = [ChannelNames; 'BR1_____QF_PS__BM19'];
    end

elseif strcmpi(Family, 'QF') && strcmpi(Field, 'OnControl')
    ChannelNames = [];
    for i = 1:32
        ChannelNames = [ChannelNames; 'BR1_____QF_PS__BC23'];
    end

elseif strcmpi(Family, 'QF') && strcmpi(Field, 'EnableDAC')
    ChannelNames = [];
    for i = 1:32
        ChannelNames = [ChannelNames; 'BR1_____QFIE_REBC01'];
    end
    
elseif strcmpi(Family, 'QF') && strcmpi(Field, 'EnableRamp')
    ChannelNames = [];
    for i = 1:32
        %ChannelNames = [ChannelNames; 'BE0101-1:ENABLE_RAMP'];
        ChannelNames = [ChannelNames; 'BR1_____QF_PSREBC00'];
    end
    
elseif strcmpi(Family, 'QF') && strcmpi(Field, 'Gain')
    ChannelNames = [];
    for i = 1:32
        % Old channel, but "forwards" to the new channel as well 
        % ChannelNames = [ChannelNames; 'BR1_____QFIE_GNAC01'];
        
        % New
        ChannelNames = [ChannelNames; 'BR1_____QF_PSGNAC00'];
    end

elseif strcmpi(Family, 'QF') && strcmpi(Field, 'Offset')
    ChannelNames = [];
    for i = 1:32
        ChannelNames = [ChannelNames; 'BR1_____QF_PSOFAC00'];
    end
    
elseif strcmpi(Family, 'QF') && strcmpi(Field, 'Enable')
    ChannelNames = [];
    for i = 1:32
        ChannelNames = [ChannelNames; 'BR1_____QF_??'];
    end
    
  
elseif strcmpi(Family, 'QF') && strcmpi(Field, 'Ready')
    ChannelNames = [];
    for i = 1:32
        ChannelNames = [ChannelNames;  'BR1_____QF_PS__BM18'];
    end

    
elseif strcmpi(Family, 'QD') && strcmpi(Field, 'Monitor')
    ChannelNames = [];
    for i = 1:32
        %ChannelNames = [ChannelNames; 'BR1_____QD_REF_AM01'];
        ChannelNames = [ChannelNames; 'BR1_____QDIE___AM01'];
    end

elseif strcmpi(Family, 'QD') && strcmpi(Field, 'Setpoint')
    ChannelNames = [];
    for i = 1:32
        %ChannelNames = [ChannelNames; 'BR1_____QD_REF_AC00'];
        ChannelNames = [ChannelNames; 'BR1_____QDIE___AC02'];
    end

elseif strcmpi(Family, 'QD') && strcmpi(Field, 'On')
    ChannelNames = [];
    for i = 1:32
        ChannelNames = [ChannelNames; 'BR1_____QD_PS__BM19'];
    end

elseif strcmpi(Family, 'QD') && strcmpi(Field, 'OnControl')
    ChannelNames = [];
    for i = 1:32
        ChannelNames = [ChannelNames; 'BR1_____QD_PS__BC23'];
    end

elseif strcmpi(Family, 'QD') && strcmpi(Field, 'EnableDAC')
    ChannelNames = [];
    for i = 1:32
        ChannelNames = [ChannelNames; 'BR1_____QDIE_REBC02'];
    end
    
elseif strcmpi(Family, 'QD') && strcmpi(Field, 'EnableRamp')
    ChannelNames = [];
    for i = 1:32
        % ChannelNames = [ChannelNames; 'BE0101-1:ENABLE_RAMP'];
        ChannelNames = [ChannelNames; 'BR1_____QD_PSREBC00'];
    end
    
elseif strcmpi(Family, 'QD') && strcmpi(Field, 'Gain')
    ChannelNames = [];
    for i = 1:32
%        ChannelNames = [ChannelNames; 'BR1_____QDIE_GNAC02'];
        % New
        ChannelNames = [ChannelNames; 'BR1_____QD_PSGNAC00'];
    end
    
elseif strcmpi(Family, 'QD') && strcmpi(Field, 'Offset')
    ChannelNames = [];
    for i = 1:32
        ChannelNames = [ChannelNames; 'BR1_____QD_PSOFAC00'];
    end
    
elseif strcmpi(Family, 'QD') && strcmpi(Field, 'Enable')
    ChannelNames = [];
    for i = 1:32
        ChannelNames = [ChannelNames; 'BR1_____QD_??'];
    end

elseif strcmpi(Family, 'QD') && strcmpi(Field, 'Ready')
    ChannelNames = [];
    for i = 1:32
        ChannelNames = [ChannelNames; 'BR1_____QD_PS__BM18'];
    end

    
elseif strcmpi(Family, 'SF') && strcmpi(Field, 'Monitor')
    ChannelNames = [
        'BR1_____SF_____AM00'
        'BR1_____SF_____AM00'
        'BR2_____SF_____AM00'
        'BR2_____SF_____AM00'
        'BR3_____SF_____AM00'
        'BR3_____SF_____AM00'
        'BR4_____SF_____AM00'
        'BR4_____SF_____AM00'
        ];

elseif strcmpi(Family, 'SF') && strcmpi(Field, 'Setpoint')
    ChannelNames = [
        'BR1_____SF_____AC00'
        'BR1_____SF_____AC00'
        'BR2_____SF_____AC00'
        'BR2_____SF_____AC00'
        'BR3_____SF_____AC00'
        'BR3_____SF_____AC00'
        'BR4_____SF_____AC00'
        'BR4_____SF_____AC00'
        ];

elseif strcmpi(Family, 'SF') && strcmpi(Field, 'On')
    ChannelNames = [
        'BR1_____SF_____BM01'
        'BR1_____SF_____BM01'
        'BR2_____SF_____BM01'
        'BR2_____SF_____BM01'
        'BR3_____SF_____BM01'
        'BR3_____SF_____BM01'
        'BR4_____SF_____BM01'
        'BR4_____SF_____BM01'
        ];

elseif strcmpi(Family, 'SF') && strcmpi(Field, 'OnControl')
    ChannelNames = [
        'BR1_____SF_____BC22'
        'BR1_____SF_____BC22'
        'BR2_____SF_____BC22'
        'BR2_____SF_____BC22'
        'BR3_____SF_____BC22'
        'BR3_____SF_____BC22'
        'BR4_____SF_____BC22'
        'BR4_____SF_____BC22'
        ];

elseif strcmpi(Family, 'SF') && strcmpi(Field, 'EnableDAC')
    ChannelNames = [
        'BR1_____SF___REBM00'
        'BR1_____SF___REBM00'
        'BR2_____SF___REBM00'
        'BR2_____SF___REBM00'
        'BR3_____SF___REBM00'
        'BR3_____SF___REBM00'
        'BR4_____SF___REBM00'
        'BR4_____SF___REBM00'
        ];

elseif strcmpi(Family, 'SF') && strcmpi(Field, 'EnableRamp')
    ChannelNames = [
        'B0102-5:ENABLE_RAMP'
        'B0102-5:ENABLE_RAMP'
        'B0202-5:ENABLE_RAMP'
        'B0202-5:ENABLE_RAMP'
        'B0302-5:ENABLE_RAMP'
        'B0302-5:ENABLE_RAMP'
        'B0402-5:ENABLE_RAMP'
        'B0402-5:ENABLE_RAMP'
        ];

elseif strcmpi(Family, 'SF') && strcmpi(Field, 'Gain')
    ChannelNames = [
        'BR1_____SF___GNAC00'
        'BR1_____SF___GNAC00'
        'BR2_____SF___GNAC00'
        'BR2_____SF___GNAC00'
        'BR3_____SF___GNAC00'
        'BR3_____SF___GNAC00'
        'BR4_____SF___GNAC00'
        'BR4_____SF___GNAC00'
        ];

elseif strcmpi(Family, 'SF') && strcmpi(Field, 'Ready')
    ChannelNames = [
        'BR1_____SF_____BM00'
        'BR1_____SF_____BM00'
        'BR2_____SF_____BM00'
        'BR2_____SF_____BM00'
        'BR3_____SF_____BM00'
        'BR3_____SF_____BM00'
        'BR4_____SF_____BM00'
        'BR4_____SF_____BM00'
        ];

    
elseif strcmpi(Family, 'SD') && strcmpi(Field, 'Monitor')
    ChannelNames = [
        'BR1_____SD_____AM03'
        'BR1_____SD_____AM03'
        'BR1_____SD_____AM03'
        'BR2_____SD_____AM03'
        'BR2_____SD_____AM03'
        'BR2_____SD_____AM03'
        'BR3_____SD_____AM03'
        'BR3_____SD_____AM03'
        'BR3_____SD_____AM03'
        'BR4_____SD_____AM03'
        'BR4_____SD_____AM03'
        'BR4_____SD_____AM03'
        ];

elseif strcmpi(Family, 'SD') && strcmpi(Field, 'Setpoint')
    ChannelNames = [
        'BR1_____SD_____AC01'
        'BR1_____SD_____AC01'
        'BR1_____SD_____AC01'
        'BR2_____SD_____AC01'
        'BR2_____SD_____AC01'
        'BR2_____SD_____AC01'
        'BR3_____SD_____AC01'
        'BR3_____SD_____AC01'
        'BR3_____SD_____AC01'
        'BR4_____SD_____AC01'
        'BR4_____SD_____AC01'
        'BR4_____SD_____AC01'        ];

elseif strcmpi(Family, 'SD') && strcmpi(Field, 'On')
    ChannelNames = [
        'BR1_____SD_____BM03'
        'BR1_____SD_____BM03'
        'BR1_____SD_____BM03'
        'BR2_____SD_____BM03'
        'BR2_____SD_____BM03'
        'BR2_____SD_____BM03'
        'BR3_____SD_____BM03'
        'BR3_____SD_____BM03'
        'BR3_____SD_____BM03'
        'BR4_____SD_____BM03'
        'BR4_____SD_____BM03'
        'BR4_____SD_____BM03'
        ];

elseif strcmpi(Family, 'SD') && strcmpi(Field, 'OnControl')
    ChannelNames = [
        'BR1_____SD_____BC23'
        'BR1_____SD_____BC23'
        'BR1_____SD_____BC23'
        'BR2_____SD_____BC23'
        'BR2_____SD_____BC23'
        'BR2_____SD_____BC23'
        'BR3_____SD_____BC23'
        'BR3_____SD_____BC23'
        'BR3_____SD_____BC23'
        'BR4_____SD_____BC23'
        'BR4_____SD_____BC23'
        'BR4_____SD_____BC23'
        ];

elseif strcmpi(Family, 'SD') && strcmpi(Field, 'EnableDAC')
    ChannelNames = [
        'BR1_____SD___REBC01'
        'BR1_____SD___REBC01'
        'BR1_____SD___REBC01'
        'BR2_____SD___REBC01'
        'BR2_____SD___REBC01'
        'BR2_____SD___REBC01'
        'BR3_____SD___REBC01'
        'BR3_____SD___REBC01'
        'BR3_____SD___REBC01'
        'BR4_____SD___REBC01'
        'BR4_____SD___REBC01'
        'BR4_____SD___REBC01'
        ];

elseif strcmpi(Family, 'SD') && strcmpi(Field, 'EnableRamp')
    ChannelNames = [
        'B0102-5:ENABLE_RAMP'
        'B0102-5:ENABLE_RAMP'
        'B0102-5:ENABLE_RAMP'
        'B0202-5:ENABLE_RAMP'
        'B0202-5:ENABLE_RAMP'
        'B0202-5:ENABLE_RAMP'
        'B0302-5:ENABLE_RAMP'
        'B0302-5:ENABLE_RAMP'
        'B0302-5:ENABLE_RAMP'
        'B0402-5:ENABLE_RAMP'
        'B0402-5:ENABLE_RAMP'
        'B0402-5:ENABLE_RAMP'
        ];

elseif strcmpi(Family, 'SD') && strcmpi(Field, 'Gain')
    ChannelNames = [
        'BR1_____SD___GNAC01'
        'BR1_____SD___GNAC01'
        'BR1_____SD___GNAC01'
        'BR2_____SD___GNAC01'
        'BR2_____SD___GNAC01'
        'BR2_____SD___GNAC01'
        'BR3_____SD___GNAC01'
        'BR3_____SD___GNAC01'
        'BR3_____SD___GNAC01'
        'BR4_____SD___GNAC01'
        'BR4_____SD___GNAC01'
        'BR4_____SD___GNAC01'
        ];

elseif strcmpi(Family, 'SD') && strcmpi(Field, 'Ready')
    ChannelNames = [
        'BR1_____SD_____BM02'
        'BR1_____SD_____BM02'
        'BR1_____SD_____BM02'
        'BR2_____SD_____BM02'
        'BR2_____SD_____BM02'
        'BR2_____SD_____BM02'
        'BR3_____SD_____BM02'
        'BR3_____SD_____BM02'
        'BR3_____SD_____BM02'
        'BR4_____SD_____BM02'
        'BR4_____SD_____BM02'
        'BR4_____SD_____BM02'
        ];

    
elseif strcmpi(Family, 'BEND') && strcmpi(Field, 'Monitor')
    ChannelNames = [];
    for i = 1:24
        %ChannelNames = [ChannelNames; 'BR1_____B_TST__AM00'];
        ChannelNames = [ChannelNames; 'BR1_____B_IE___AM00'];
    end

elseif strcmpi(Family, 'BEND') && strcmpi(Field, 'Setpoint')
    ChannelNames = [];
    for i = 1:24
        %ChannelNames = [ChannelNames; 'BR1_____B_PS___AC00'];
        ChannelNames = [ChannelNames; 'BR1_____B_IE___AC00'];
    end

elseif strcmpi(Family, 'BEND') && strcmpi(Field, 'On')
    ChannelNames = [];
    for i = 1:24
        %ChannelNames = [ChannelNames; 'BR1_____B_TST__BM13'];
        %ChannelNames = [ChannelNames; 'BR1_____B_IE___BM01'];
        ChannelNames = [ChannelNames; 'BR1_____B__PS__BM01'];
    end

elseif strcmpi(Family, 'BEND') && strcmpi(Field, 'OnControl')
    ChannelNames = [];
    for i = 1:24
        %ChannelNames = [ChannelNames; 'BR1_____B_PS___BC22'];
        ChannelNames = [ChannelNames; 'BR1_____B_IE___BC20'];
    end

elseif strcmpi(Family, 'BEND') && strcmpi(Field, 'EnableDAC')
    ChannelNames = [];
    for i = 1:24
        ChannelNames = [ChannelNames; 'BR1_____B_IE_REBC00'];
    end
    
elseif strcmpi(Family, 'BEND') && strcmpi(Field, 'EnableRamp')
    ChannelNames = [];
    for i = 1:24
        %ChannelNames = [ChannelNames; 'BE0101-1:ENABLE_RAMP'];
        ChannelNames = [ChannelNames; 'BR1_____B__PSREBC00'];
    end
        
elseif strcmpi(Family, 'BEND') && strcmpi(Field, 'Gain')
    ChannelNames = [];
    for i = 1:24
        %ChannelNames = [ChannelNames; 'BR1_____B_IE_GNAC00'];
        ChannelNames = [ChannelNames; 'BR1_____B__PSGNAC00'];
    end

elseif strcmpi(Family, 'BEND') && strcmpi(Field, 'Offset')
    ChannelNames = [];
    for i = 1:24
        ChannelNames = [ChannelNames; 'BR1_____B__PSOFAC00'];
    end
    
elseif strcmpi(Family, 'BEND') && strcmpi(Field, 'Enable')
    ChannelNames = [];
    for i = 1:24
        %ChannelNames = [ChannelNames; 'BR1_____B_PS_R_BC23'];
        ChannelNames = [ChannelNames; ''];
    end

elseif strcmpi(Family, 'BEND') && strcmpi(Field, 'Ready')
    ChannelNames = [];
    for i = 1:24
        %ChannelNames = [ChannelNames; 'BR1_____B_TST__BM12'];
        ChannelNames = [ChannelNames; 'BR1_____B_IE___BM00'];
    end
    
elseif strcmpi(Family, 'BEND') && strcmpi(Field, 'Reset')
    ChannelNames = [];
    for i = 1:24
        %ChannelNames = [ChannelNames; 'BR1_____B_PS___BC23'];
        ChannelNames = [ChannelNames; ''];
    end

% BR1_____B_IE_REBM00	DAC Ramp Enable Readback
% BR1_____B_IE_NMSM00	Current ramp table name
% BR1_____B1_____BM00	BR1 B1 OVER-TEMP
% BR1_____B2_____BM01	BR1 B2 OVER-TEMP
% BR1_____B3_____BM02	BR1 B3 OVER-TEMP
% BR1_____B4_____BM03	BR1 B4 OVER-TEMP
% BR1_____B5_____BM04	BR1 B5 OVER-TEMP
% BR1_____B6_____BM05	BR1 B6 OVER-TEMP


elseif strcmpi(Family, 'TV') && (strcmpi(Field, 'Setpoint') || strcmpi(Field, 'InControl'))
    ChannelNames = [
        'BR1_____TV1____BC16'
        'BR1_____TV2____BC18'
        'BR1_____TV3____BC18'
        'BR1_____TV4____BC16'
        'BR1_____TV5____BC18'
        'BR1_____TV6____BC20'
        ];

elseif strcmpi(Family, 'TV') && strcmpi(Field, 'Video')
    ChannelNames = [
        'BR1 TV1'
        'BR1 TV2'
        'BR1 TV3'
        'BR1 TV4'
        'BR1 TV5'
        'BR1 TV6'
    ];

elseif strcmpi(Family, 'TV') && strcmpi(Field, 'Lamp')
    ChannelNames = [
        'BR1_____TV1LIT_BC17'
        'BR1_____TV2LIT_BC19'
        'BR1_____TV3LIT_BC19'
        'BR1_____TV4LIT_BC17'
        'BR1_____TV5LIT_BC19'
        'BR1_____TV6LIT_BC21'
    ];

elseif strcmpi(Family, 'TV') && (strcmpi(Field, 'Monitor') || strcmpi(Field, 'In'))
    ChannelNames = [
        'BR1_____TV1____BM00'
        'BR1_____TV2____BM06'
        'BR1_____TV3____BM06'
        'BR1_____TV4____BM00'
        'BR1_____TV5____BM06'
        'BR1_____TV6____BM00'
    ];

elseif strcmpi(Family, 'TV') && strcmpi(Field, 'Out')
    ChannelNames = [
        'BR1_____TV1____BM01'
        'BR1_____TV2____BM07'
        'BR1_____TV3____BM07'
        'BR1_____TV4____BM01'
        'BR1_____TV5____BM07'
        'BR1_____TV6____BM01'
    ];

else
    ChannelNames = '';
end
