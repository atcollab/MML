function ChannelNames = getname_gtb(Family, Field)


% LTB_BPM3 is in the FC line
if strcmpi(Family, 'BPMx') && strcmpi(Field, 'CommonNames')
    ChannelNames = [
        'GTL_BPM1_X'
        'GTL_BPM2_X'
        'LN__BPM1_X'
        'LN__BPM2_X'
        'LTB_BPM1_X'
        'LTB_BPM2_X'
       %'LTB_BPM3_X'
        'LTB_BPM4_X'
        'LTB_BPM5_X'
        'LTB_BPM6_X'
        'LTB_BPM7_X'
        ];

elseif strcmpi(Family, 'BPMx') && strcmpi(Field, 'Monitor')
    ChannelNames = [
        'GTL_____BPM1_X_AM00'
        'GTL_____BPM2_X_AM00'
        'LN______BPM1_X_AM00'
        'LN______BPM2_X_AM00'
        'LTB_____BPM1_X_AM00'
        'LTB_____BPM2_X_AM00'
       %'LTB_____BPM3_X_AM00'
        'LTB_____BPM4_X_AM00'
        'LTB_____BPM5_X_AM00'
        'LTB_____BPM6_X_AM00'
        'LTB_____BPM7_X_AM00'
        ];
    
elseif (strcmpi(Family, 'BPMx') || strcmpi(Family, 'BPMy')) && strcmpi(Field, 'GainControl')
    ChannelNames = [
        'GTL_____BPM1GN_AC00'
        'GTL_____BPM2GN_AC00'
        'LN______BPM1GN_AC00'
        'LN______BPM2GN_AC00'
        'LTB_____BPM1GN_AC00'
        'LTB_____BPM2GN_AC00'
       %'LTB_____BPM3GN_AC00'
        'LTB_____BPM4GN_AC00'
        'LTB_____BPM5GN_AC00'
        'LTB_____BPM6GN_AC00'
        'LTB_____BPM7GN_AC00'
        ];

elseif (strcmpi(Family, 'BPMx') || strcmpi(Family, 'BPMy')) && strcmpi(Field, 'HeartBeat')
    ChannelNames = [
        'GTL_____BPM1CNTAM00'
        'GTL_____BPM2CNTAM00'
        'LN______BPM1CNTAM00'
        'LN______BPM2CNTAM00'
        'LTB_____BPM1CNTAM00'
        'LTB_____BPM2CNTAM00'
       %'LTB_____BPM3CNTAM00'
        'LTB_____BPM4CNTAM00'
        'LTB_____BPM5CNTAM00'
        'LTB_____BPM6CNTAM00'
        'LTB_____BPM7CNTAM00'
        ];

elseif (strcmpi(Family, 'BPMx') || strcmpi(Family, 'BPMy')) && strcmpi(Field, 'Button1')
    ChannelNames = [
        'GTL_____BPM1RAWAM00'
        'GTL_____BPM2RAWAM00'
        'LN______BPM1RAWAM00'
        'LN______BPM2RAWAM00'
        'LTB_____BPM1RAWAM00'
        'LTB_____BPM2RAWAM00'
       %'LTB_____BPM3RAWAM00'
        'LTB_____BPM4RAWAM00'
        'LTB_____BPM5RAWAM00'
        'LTB_____BPM6RAWAM00'
        'LTB_____BPM7RAWAM00'
        ];

elseif (strcmpi(Family, 'BPMx') || strcmpi(Family, 'BPMy')) && strcmpi(Field, 'Button2')
    ChannelNames = [
        'GTL_____BPM1RAWAM01'
        'GTL_____BPM2RAWAM01'
        'LN______BPM1RAWAM01'
        'LN______BPM2RAWAM01'
        'LTB_____BPM1RAWAM01'
        'LTB_____BPM2RAWAM01'
       %'LTB_____BPM3RAWAM01'
        'LTB_____BPM4RAWAM01'
        'LTB_____BPM5RAWAM01'
        'LTB_____BPM6RAWAM01'
        'LTB_____BPM7RAWAM01'
        ];

    elseif (strcmpi(Family, 'BPMx') || strcmpi(Family, 'BPMy')) && strcmpi(Field, 'Button3')
    ChannelNames = [
        'GTL_____BPM1RAWAM02'
        'GTL_____BPM2RAWAM02'
        'LN______BPM1RAWAM02'
        'LN______BPM2RAWAM02'
        'LTB_____BPM1RAWAM02'
        'LTB_____BPM2RAWAM02'
       %'LTB_____BPM3RAWAM02'
        'LTB_____BPM4RAWAM02'
        'LTB_____BPM5RAWAM02'
        'LTB_____BPM6RAWAM02'
        'LTB_____BPM7RAWAM02'
        ];

    elseif (strcmpi(Family, 'BPMx') || strcmpi(Family, 'BPMy')) && strcmpi(Field, 'Button4')
    ChannelNames = [
        'GTL_____BPM1RAWAM03'
        'GTL_____BPM2RAWAM03'
        'LN______BPM1RAWAM03'
        'LN______BPM2RAWAM03'
        'LTB_____BPM1RAWAM03'
        'LTB_____BPM2RAWAM03'
       %'LTB_____BPM3RAWAM03'
        'LTB_____BPM4RAWAM03'
        'LTB_____BPM5RAWAM03'
        'LTB_____BPM6RAWAM03'
        'LTB_____BPM7RAWAM03'
        ];

elseif strcmpi(Family, 'BPMy') && strcmpi(Field, 'CommonNames')
    ChannelNames = [
        'GTL_BPM1_Y'
        'GTL_BPM2_Y'
        'LN__BPM1_Y'
        'LN__BPM2_Y'
        'LTB_BPM1_Y'
        'LTB_BPM2_Y'
       %'LTB_BPM3_Y'
        'LTB_BPM4_Y'
        'LTB_BPM5_Y'
        'LTB_BPM6_Y'
        'LTB_BPM7_Y'
        ];

elseif strcmpi(Family, 'BPMy') && strcmpi(Field, 'Monitor')
    ChannelNames = [
        'GTL_____BPM1_Y_AM01'
        'GTL_____BPM2_Y_AM01'
        'LN______BPM1_Y_AM01'
        'LN______BPM2_Y_AM01'
        'LTB_____BPM1_Y_AM01'
        'LTB_____BPM2_Y_AM01'
       %'LTB_____BPM3_Y_AM01'
        'LTB_____BPM4_Y_AM01'
        'LTB_____BPM5_Y_AM01'
        'LTB_____BPM6_Y_AM01'
        'LTB_____BPM7_Y_AM01'
        ];
    
elseif strcmpi(Family, 'HCM') && strcmpi(Field, 'CommonNames')
    ChannelNames = [
        'GTL_HC1'
        'GTL_HC2'
        'GTL_HC3'
        'GTL_HC4'
        'LN_HC1 '
        'LN_HC2 '
        'LTB_HC1'
        'LTB_HC2'
        %'LTB_HC7'
        ];

elseif strcmpi(Family, 'HCM') && strcmpi(Field, 'Monitor')
    ChannelNames = [
        'GTL_____HC1____AM03'	% CH2_ADC_+
        'GTL_____HC2____AM01'	% CH2_ADC_+
        'GTL_____HC3____AM03'	% CH2_ADC_+
        'GTL_____HC4____AM01'	% CH2_ADC_+
        'LN______HC1____AM01'	% CH2_ADC_+
        'LN______HC2____AM03'	% CH2_ADC_+
        'LTB_____HC1____AM02'
        'LTB_____HC2____AM03'
        %'LTB_____HC7____AM03'
        ];

elseif strcmpi(Family, 'HCM') && strcmpi(Field, 'Setpoint')
    ChannelNames = [
        'GTL_____HC1____AC03'	% CH2_DAC_+
        'GTL_____HC2____AC01'	% CH2_DAC_+
        'GTL_____HC3____AC03'	% CH2_DAC_+
        'GTL_____HC4____AC01'	% CH2_DAC_+
        'LN______HC1____AC01'	% CH2_DAC_+
        'LN______HC2____AC03'	% CH2_DAC_+
        'LTB_____HC1____AC02'	% PS_CURRENT_CNTRL
        'LTB_____HC2____AC03'	% PS_CURRENT_CNTRL
        %'LTB_____HC7____AC03'	% PS_CURRENT_CNTRL
        ];

elseif strcmpi(Family, 'HCM') && strcmpi(Field, 'On')
    ChannelNames = [
        'GTL_____HC1____BM06'	% PS_ON
        'GTL_____HC2____BM14'	% PS_ON
        'GTL_____HC3____BM06'	% PS_ON
        'GTL_____HC4____BM14'	% PS_ON
        'LN______HC1____BM14'	% PS_ON
        'LN______HC2____BM06'	% PS_ON
        'LTB_____HC1____BM05'	% PS_ON_OFF
        'LTB_____HC2____BM07'	% PS_ON_OFF
        %'LTB_____HC7____BM07'	% PS_ON_MON
        ];

elseif strcmpi(Family, 'HCM') && strcmpi(Field, 'OnControl')
    ChannelNames = [
        'GTL_____HC1____BC22'	% PS_ON_2
        'GTL_____HC2____BC23'	% PS_ON_1
        'GTL_____HC3____BC22'	% PS_ON_2
        'GTL_____HC4____BC23'	% PS_ON_1
        'LN______HC1____BC23'	% PS_ON_1
        'LN______HC2____BC22'	% PS_ON_2
        'LTB_____HC1____BC22'
        'LTB_____HC2____BC23'
        %'LTB_____HC7____BC23'
        ];

elseif strcmpi(Family, 'HCM') && strcmpi(Field, 'Reset')
    ChannelNames = [
        'GTL_____HC1__R_BC01'	% PS_ON_2
        'GTL_____HC2__R_BC01'	% PS_ON_1
        'GTL_____HC3__R_BC01'	% PS_ON_2
        'GTL_____HC4__R_BC01'	% PS_ON_1
        'LN______HC1__R_BC01'	% PS_ON_1
        'LN______HC2__R_BC01'	% PS_ON_2
        'LTB_____HC1__R_BC01'
        'LTB_____HC2__R_BC01'
        %'LTB_____HC7__R_BC01'
        ];

elseif strcmpi(Family, 'HCM') && strcmpi(Field, 'Ready')
    ChannelNames = [
        'GTL_____HC1____BM07'	% PS_READY
        'GTL_____HC2____BM15'	% PS_READY
        'GTL_____HC3____BM07'	% PS_READY
        'GTL_____HC4____BM15'	% PS_READY
        'LN______HC1____BM15'	% PS_READY
        'LN______HC2____BM07'	% PS_READY
        'LTB_____HC1____BM04'	% PS_READY_MON
        'LTB_____HC2____BM06'	% PS_READY_MON
        %'LTB_____HC7____BM06'	% PS_READY_MON
        ];

elseif strcmpi(Family, 'VCM') && strcmpi(Field, 'CommonNames')
    ChannelNames = [
        'GTL_VC1'
        'GTL_VC2'
        'GTL_VC3'
        'GTL_VC4'
        'LN_VC1 '
        'LN_VC2 '
        'LTB_VC1'
        'LTB_VC2'
        'LTB_VC3'
        'LTB_VC4'
        'LTB_VC5'
        'LTB_VC6'
        'LTB_VC7'
        ];

elseif strcmpi(Family, 'VCM') && strcmpi(Field, 'Monitor')
    ChannelNames = [
        'GTL_____VC1____AM02'	% CH1_ADC_+
        'GTL_____VC2____AM00'	% CH1_ADC_+
        'GTL_____VC3____AM02'	% CH1_ADC_+
        'GTL_____VC4____AM00'	% CH1_ADC_+
        'LN______VC1____AM00'	% CH1_ADC_+
        'LN______VC2____AM02'	% CH1_ADC_+
        'LTB_____VC1____AM02'
        'LTB_____VC2____AM03'
        'LTB_____VC3____AM00'
        'LTB_____VC4____AM01'
        'LTB_____VC5____AM00'
        'LTB_____VC6____AM01'
        'LTB_____VC7____AM02'
        ];

elseif strcmpi(Family, 'VCM') && strcmpi(Field, 'Setpoint')
    ChannelNames = [
        'GTL_____VC1____AC02'	% CH1_DAC_+
        'GTL_____VC2____AC00'	% CH1_DAC_+
        'GTL_____VC3____AC02'	% CH1_DAC_+
        'GTL_____VC4____AC00'	% CH1_DAC_+
        'LN______VC1____AC00'	% CH1_DAC_+
        'LN______VC2____AC02'	% CH1_DAC_+
        'LTB_____VC1____AC02'
        'LTB_____VC2____AC03'
        'LTB_____VC3____AC00'
        'LTB_____VC4____AC01'
        'LTB_____VC5____AC00'
        'LTB_____VC6____AC01'
        'LTB_____VC7____AC02'
        ];

elseif strcmpi(Family, 'VCM') && strcmpi(Field, 'On')
    ChannelNames = [
        'GTL_____VC1____BM06'	% PS_ON
        'GTL_____VC2____BM14'	% PS_ON
        'GTL_____VC3____BM06'	% PS_ON
        'GTL_____VC4____BM14'	% PS_ON
        'LN______VC1____BM14'	% PS_ON
        'LN______VC2____BM06'	% PS_ON
        'LTB_____VC1____BM05'
        'LTB_____VC2____BM07'
        'LTB_____VC3____BM01'
        'LTB_____VC4____BM03'
        'LTB_____VC5____BM01'
        'LTB_____VC6____BM03'
        'LTB_____VC7____BM05'
        ];

elseif strcmpi(Family, 'VCM') && strcmpi(Field, 'OnControl')
    ChannelNames = [
        'GTL_____VC1____BC22'	% PS_ON_2
        'GTL_____VC2____BC23'	% PS_ON_1
        'GTL_____VC3____BC22'	% PS_ON_2
        'GTL_____VC4____BC23'	% PS_ON_1
        'LN______VC1____BC23'	% PS_ON_1
        'LN______VC2____BC22'	% PS_ON_2
        'LTB_____VC1____BC22'
        'LTB_____VC2____BC23'
        'LTB_____VC3____BC20'
        'LTB_____VC4____BC21'
        'LTB_____VC5____BC20'
        'LTB_____VC6____BC21'
        'LTB_____VC7____BC22'
        ];

elseif strcmpi(Family, 'VCM') && strcmpi(Field, 'Reset')
    ChannelNames = [
        'GTL_____VC1__R_BC01'
        'GTL_____VC2__R_BC01'
        'GTL_____VC3__R_BC01'
        'GTL_____VC4__R_BC01'
        'LN______VC1__R_BC01'
        'LN______VC2__R_BC01'
        'LTB_____VC1__R_BC01'
        'LTB_____VC2__R_BC01'
        'LTB_____VC3__R_BC01'
        'LTB_____VC4__R_BC01'
        'LTB_____VC5__R_BC01'
        'LTB_____VC6__R_BC01'
        'LTB_____VC7__R_BC01'
        ];

elseif strcmpi(Family, 'VCM') && strcmpi(Field, 'Ready')
    ChannelNames = [
        'GTL_____VC1____BM07'	% PS_READY
        'GTL_____VC2____BM15'	% PS_READY
        'GTL_____VC3____BM07'	% PS_READY
        'GTL_____VC4____BM15'	% PS_READY
        'LN______VC1____BM15'	% PS_READY
        'LN______VC2____BM07'	% PS_READY
        'LTB_____VC1____BM04'	% PS_READY_MON
        'LTB_____VC2____BM06'	% PS_READY_MON
        'LTB_____VC3____BM00'	% PS_READY_MON
        'LTB_____VC4____BM02'	% PS_READY_MON
        'LTB_____VC5____BM00'	% PS_READY_MON
        'LTB_____VC6____BM02'	% PS_READY_MON
        'LTB_____VC7____BM04'	% PS_READY_MON
        ];

elseif strcmpi(Family, 'Q') && strcmpi(Field, 'CommonNames')
    ChannelNames = [
        'LN_Q1,1 '
        'LN_Q1,2 '
        'LN_Q1,3 '
        'LTB_Q1,1'
        'LTB_Q1,2'
        'LTB_Q1,3'
        'LTB_Q2  '
        'LTB_Q3,1'
        'LTB_Q3,2'
        'LTB_Q4,1'
        'LTB_Q4,2'
        'LTB_Q5  '
        'LTB_Q6  '
        ];

elseif strcmpi(Family, 'Q') && strcmpi(Field, 'Monitor')
    ChannelNames = [
        'LN______Q1,1___AM00'
        'LN______Q1,2___AM01'
        'LN______Q1,1___AM00'
        'LTB_____Q1,1___AM00'
        'LTB_____Q1,2___AM01'
        'LTB_____Q1,1___AM00'
        'LTB_____Q2_____AM03'
        'LTB_____Q3,1___AM00'
        'LTB_____Q3,2___AM01'
        'LTB_____Q4,1___AM01'
        'LTB_____Q4,2___AM02'
        'LTB_____Q5_____AM03'
        'LTB_____Q6_____AM00'
        ];

elseif strcmpi(Family, 'Q') && strcmpi(Field, 'Setpoint')
    ChannelNames = [
        'LN______Q1,1___AC00'
        'LN______Q1,2___AC01'
        'LN______Q1,1___AC00'
        'LTB_____Q1,1___AC00'
        'LTB_____Q1,2___AC01'
        'LTB_____Q1,1___AC00'
        'LTB_____Q2_____AC03'
        'LTB_____Q3,1___AC00'
        'LTB_____Q3,2___AC01'
        'LTB_____Q4,1___AC01'
        'LTB_____Q4,2___AC02'
        'LTB_____Q5_____AC03'
        'LTB_____Q6_____AC00'
        ];

elseif strcmpi(Family, 'Q') && strcmpi(Field, 'On')
    ChannelNames = [
        'LN______Q1,1___BM14'
        'LN______Q1,2___BM12'
        'LN______Q1,1___BM14'
        'LTB_____Q1,1___BM01'
        'LTB_____Q1,2___BM03'
        'LTB_____Q1,1___BM01'
        'LTB_____Q2_____BM07'
        'LTB_____Q3,1___BM01'
        'LTB_____Q3,2___BM03'
        'LTB_____Q4,1___BM06'
        'LTB_____Q4,2___BM08'
        'LTB_____Q5_____BM10'
        'LTB_____Q6_____BM01'
        ];

elseif strcmpi(Family, 'Q') && strcmpi(Field, 'OnControl')
    ChannelNames = [
        'LN______Q1,1___BC23'
        'LN______Q1,2___BC22'
        'LN______Q1,1___BC23'
        'LTB_____Q1,1___BC20'
        'LTB_____Q1,2___BC21'
        'LTB_____Q1,1___BC20'
        'LTB_____Q2_____BC23'
        'LTB_____Q3,1___BC20'
        'LTB_____Q3,2___BC21'
        'LTB_____Q4,1___BC21'
        'LTB_____Q4,2___BC22'
        'LTB_____Q5_____BC23'
        'LTB_____Q6_____BC20'
        ];

elseif strcmpi(Family, 'Q') && strcmpi(Field, 'Reset')
    ChannelNames = [
        'LN______Q1,1_R_BC01'
        'LN______Q1,1_R_BC01'
        'LN______Q1,1_R_BC01'
        'LTB_____Q1,1_R_BC01'
        'LTB_____Q1,2_R_BC01'
        'LTB_____Q1,1_R_BC01'
        'LTB_____Q2___R_BC01'
        'LTB_____Q3,1_R_BC01'
        'LTB_____Q3,2_R_BC01'
        'LTB_____Q4,1_R_BC01'
        'LTB_____Q4,2_R_BC01'
        'LTB_____Q5___R_BC01'
        'LTB_____Q6___R_BC01'
        ];

elseif strcmpi(Family, 'Q') && strcmpi(Field, 'Ready')
    ChannelNames = [
        'LN______Q1,1___BM15'	% READY
        'LN______Q1,2___BM13'	% READY
        'LN______Q1,1___BM15'	% READY
        'LTB_____Q1,1___BM00'	% PS_READY_MON
        'LTB_____Q1,2___BM02'	% PS_READY_MON
        'LTB_____Q1,1___BM00'	% PS_READY_MON
        'LTB_____Q2_____BM06'	% PS_READY_MON
        'LTB_____Q3,1___BM00'	% PS_READY_MON
        'LTB_____Q3,2___BM02'	% PS_READY_MON
        'LTB_____Q4,1___BM05'	% PS_READY_MON
        'LTB_____Q4,2___BM07'	% PS_READY_MON
        'LTB_____Q5_____BM09'	% PS_READY_MON
        'LTB_____Q6_____BM00'	% PS_READY_MON
        ];


elseif strcmpi(Family, 'BEND') && strcmpi(Field, 'CommonNames')
    ChannelNames = [
        'LTB_BS'
        'LTB_B1'
        'LTB_B2'
        'LTB_B3'
        ];

elseif strcmpi(Family, 'BEND') && strcmpi(Field, 'Monitor')
    ChannelNames = [
        'LTB_____BS_____AM01'
        'LTB_____B1_____AM02'
        'LTB_____B2_____AM00'
        'LTB_____B3_____AM03'
        ];

elseif strcmpi(Family, 'BEND') && strcmpi(Field, 'Setpoint')
    ChannelNames = [
        'LTB_____BS_____AC00'	% PS_CURRENT_CNTRL
        'LTB_____B1_____AC02'	% PS_CURRENT_CNTRL
        'LTB_____B2_____AC00'	% PS_CURRENT_CNTRL
        'LTB_____B3_____AC03'	% PS_CURRENT_CNTRL
        ];

elseif strcmpi(Family, 'BEND') && strcmpi(Field, 'On')
    ChannelNames = [
        'LTB_____BS_____BM04' % PS_ON_MON
        'LTB_____B1_____BM09' % PS_ON_MON
        'LTB_____B2_____BM04' % PS_ON_MON
        'LTB_____B3_____BM07' % PS_ON_MON
        ];
    
elseif strcmpi(Family, 'BEND') && strcmpi(Field, 'OnControl')
    ChannelNames = [
        'LTB_____BS_____BC20'	% PS_ON/OFF_CNTRL
        'LTB_____B1_____BC21'	% PS_ON/OFF_CNTRL
        'LTB_____B2_____BC20'	% PS_ON/OFF_CNTRL
        'LTB_____B3_____BC23'	% PS_ON/OFF_CNTRL
        ];

    elseif strcmpi(Family, 'BEND') && strcmpi(Field, 'RampRate')
        ChannelNames = [
            'irm:023:SlewRate0'  % LTB_BS
            'irm:023:SlewRate2'  % LTB_B1
            'irm:024:SlewRate0'  % LTB_B2
            'LTB:B3:SlewRate  '  % LTB_B3
        ];
    
elseif strcmpi(Family, 'BEND') && strcmpi(Field, 'Reset')
    ChannelNames = [
        ' '
        ' '
        ' '
        ' '
        ];

elseif strcmpi(Family, 'BEND') && strcmpi(Field, 'Ready')
    ChannelNames = [
        'LTB_____BS_____BM03' % PS_READY_MON
        'LTB_____B1_____BM08' % PS_READY_MON
        'LTB_____B2_____BM03' % PS_READY_MON
        'LTB_____B3_____BM06' % PS_READY_MON
        ];
    
elseif strcmpi(Family, 'BEND') && strcmpi(Field, 'CtrlPower')
    ChannelNames = [
        'LTB_____BS_____BM00' % BS_PS_CNTRL_PWR_MON
        'LTB_____B1_____BM05' % B1_PS_CNTRL_PWR_MON
        'LTB_____B2_____BM00' % B2_PS_CNTRL_PWR_MON
        '                   '
        ];

elseif strcmpi(Family, 'BEND') && strcmpi(Field, 'OverTemperature')
    ChannelNames = [
        'LTB_____B1_____BM06' % B1_PS_OVER_TEMP
        'LTB_____B2_____BM01' % B2_PS_OVER_TEMP
        '                   '
        '                   '
        ];
    
elseif strcmpi(Family, 'BEND') && strcmpi(Field, 'HallProbe')
    ChannelNames = [
        'LTB_____HALL1__AM00'
        '                   '
        '                   '
        '                   '
        ];

elseif strcmpi(Family, 'BEND') && strcmpi(Field, 'Shunt')
    ChannelNames = [
        'LTB_____BS_SHNTAM00'
        'LTB_____B1_SHNTAM03'
        '                   '
        '                   '
        ];

    % 'LTB_____BS_____BM02' % BS_SAFETY_CHAIN
    % 'LTB_____BS_____BM01' % BS_MAG_INTLK    
    % 'LTB_____B1_____BM07' % B1_MAG_INTLK    
    % 'LTB_____B2_____BM02' % B2_PS_WATER_FLO
    
    
elseif strcmpi(Family, 'TV') && strcmpi(Field, 'CommonNames')
    ChannelNames = [
        'GTL_TV1'
        'GTL_TV2'
        'LN_TV1 '
        'LN_TV2 '
        'LTB_TV1'
       %'LTB_TV2'
        'LTB_TV3'
        'LTB_TV4'
        'LTB_TV5'
        'LTB_TV6'
        ];
    
elseif strcmpi(Family, 'TV') && (strcmpi(Field, 'Monitor') || strcmpi(Field, 'In'))
    ChannelNames = [
        'GTL_____TV1____BM10'	% GLT TV1 IN
        'GTL_____TV2____BM04'	% GLT TV2 IN
        'LN______TV1____BM10'	% LN TV1 IN
        'LN______TV2____BM04'	% LN TV2 IN
        'LTB_____TV1____BM00' % 1 PAD MON IN
       %'LTB_____TV2____BM06' % 2 PAD MON IN
        'LTB_____TV3____BM00' % 3 PAD MON IN
        'LTB_____TV4____BM06' % 4 PAD MON IN
        'LTB_____TV5____BM00' % 5 PAD MON IN
        'LTB_____TV6____BM08' % 6 PAD MON IN
        ];

elseif strcmpi(Family, 'TV') && strcmpi(Field, 'InControl')
    ChannelNames = [
        'GTL_____TV1____BC23'	% GLT TV1 IN/OUT
        'GTL_____TV2____BC21'	% GLT TV2 IN/OUT
        'LN______TV1____BC23'
        'LN______TV2____BC21'
        'LTB_____TV1____BC16'   % TV1 PAD IN/OUT
       %'LTB_____TV2____BC18'	% TV2 PAD IN/OUT
        'LTB_____TV3____BC16'	% TV3 PAD IN/OUT
        'LTB_____TV4____BC18'	% TV4 PAD IN/OUT
        'LTB_____TV5____BC16'	% TV5 PAD IN/OUT
        'LTB_____TV6____BC19'	% TV6 PAD IN/OUT
        ];

elseif strcmpi(Family, 'TV') && strcmpi(Field, 'Video')
    ChannelNames = [
        'GTL TV1'
        'GTL TV2'
        'LN TV1 '
        'LN TV2 '
        'LTB TV1'
       %'LTB TV2'
        'LTB TV3'
        'LTB TV4'
        'LTB TV5'
        'LTB TV6'
        ];

elseif strcmpi(Family, 'TV') && strcmpi(Field, 'Out')
    ChannelNames = [
        'GTL_____TV1____BM11'	% GLT TV1 OUT
        'GTL_____TV2____BM05'	% GLT TV2 OUT
        'LN______TV1____BM11'	% LN TV1 OUT
        'LN______TV2____BM05'	% LN TV2 OUT
        'LTB_____TV1____BM01' % 1 PAD MON OUT
       %'LTB_____TV2____BM07' % 2 PAD MON OUT
        'LTB_____TV3____BM01' % 3 PAD MON OUT
        'LTB_____TV4____BM07' % 4 PAD MON OUT
        'LTB_____TV5____BM01' % 5 PAD MON OUT
        'LTB_____TV6____BM09' % 6 PAD MON OUT
        ];

elseif strcmpi(Family, 'TV') && strcmpi(Field, 'LampControl')
    ChannelNames = [
        'GTL_____TV1LIT_BC22'
        'GTL_____TV2LIT_BC20'
        'LN______TV1LIT_BC22'
        'LN______TV2LIT_BC20'
        'LTB_____TV1LIT_BC17'   % TV1 LAMP ON/OFF
       %'LTB_____TV2LIT_BC19'	% TV2 LAMP ON/OFF
        'LTB_____TV3LIT_BC17'	% TV3 LAMP ON/OFF
        'LTB_____TV4LIT_BC19'	% TV4 LAMP ON/OFF
        'LTB_____TV5LIT_BC17'	% TV5 LAMP ON/OFF
        'LTB_____TV6LIT_BC20'	% TV6 LAMP ON/OFF
        ];

elseif strcmpi(Family, 'TV') && strcmpi(Field, 'Lamp')
    ChannelNames = [
        'GTL_____TV1LIT_BM12'
        'GTL_____TV2LIT_BM06'	% LIGHT ON
        'LN______TV1LIT_BM12'	% LIGHT ON
        'LN______TV2LIT_BM06'	% LIGHT ON
        'LTB_____TV1LIT_BM05' % 1 LAMP ON
       %'LTB_____TV2LIT_BM11' % 2 LAMP ON
        'LTB_____TV3LIT_BM05' % 3 LAMP ON
        'LTB_____TV4LIT_BM11' % 4 LAMP ON
        'LTB_____TV5LIT_BM05' % 5 LAMP ON
        'LTB_____TV6LIT_BM13' % 6 LAMP ON
        ];
        
elseif strcmpi(Family, 'TV') && strcmpi(Field, 'ATTN')
    ChannelNames = [
        'GTL_____TV1ATN_AM00' % TV1 ATTN MON
        'GTL_____TV2ATN_AM01' % TV2 ATTN MON 
        'LN______TV1ATN_AM00' % TV1 ATTN MON 
        'LN______TV2ATN_AM01' % TV2 ATTN MON 
        'LTB_____TV1ATN_AM00' % TV1 PLRZR MON
       %'LTB_____TV2ATN_AM01' % TV2 PLRZR MON
        'LTB_____TV3ATN_AM00' % TV3 PLRZR MON
        'LTB_____TV4ATN_AM01' % TV4 PLRZR MON
        'LTB_____TV5ATN_AM00' % TV5 PLRZR MON
        'LTB_____TV6ATN_AM01' % TV6 PLRZR MON
        ];

elseif strcmpi(Family, 'TV') && strcmpi(Field, 'ATTNControl')
    ChannelNames = [
        'GTL_____TV1ATN_AC00'	% TV1 ATTN REF
        'GTL_____TV2ATN_AC01'	% TV2 ATTN REF
        '                   '
        '                   '
        'LTB_____TV1ATN_AC00'	% TV1 PLRZR CNTRL
       %'LTB_____TV2ATN_AC01'	% TV2 PLRZR CNTRL
        'LTB_____TV3ATN_AC00'	% TV3 PLRZR CNTRL
        'LTB_____TV4ATN_AC01'	% TV4 PLRZR CNTRL
        'LTB_____TV5ATN_AC00'	% TV5 PLRZR CNTRL
        'LTB_____TV6ATN_AC01'	% TV6 PLRZR CNTRL
        ];
    
    
elseif strcmpi(Family, 'VVR') && strcmpi(Field, 'CommonNames')
    ChannelNames = [
        'GTL_VVR1'
        'LN_VVR1 '
        'LTB_VVR1'
        'LTB_VVR2'
        ];

elseif strcmpi(Family, 'VVR') && strcmpi(Field, 'OpenControl')
    ChannelNames = [
        'GTL_____VVR1___BC23' % OPEN/CLS CONTROL
        'LN______VVR1___BC22' % OPEN/CLS CONTROL
        'LTB_____VVR1___BC23' % OPEN/CLS CONTROL
        'LTB_____VVR2___BC22' % OPEN/CLS CONTROL
        ];
elseif strcmpi(Family, 'VVR') && strcmpi(Field, 'Open')
    ChannelNames = [
        'GTL_____VVR1___BM12' % VALVE OPEN
        'LN______VVR1___BM04' % VALVE OPEN
        'LTB_____VVR1___BM11' % VVR OPEN
        'LTB_____VVR2___BM05' % VVR OPEN
        ];
    
elseif strcmpi(Family, 'VVR') && strcmpi(Field, 'Closed')
    ChannelNames = [
        'GTL_____VVR1___BM13' % VVR CLOSED
        'LN______VVR1___BM05' % VVR CLOSED
        'LTB_____VVR1___BM10' % VVR CLOSED
        'LTB_____VVR2___BM04' % VVR CLOSED
        ];
    
elseif strcmpi(Family, 'VVR') && strcmpi(Field, 'UpStream')
    ChannelNames = [
        'LN______VVR1___BM09' % UPSTREAM VAC OK
        'GTL_____VVR1___BM18' % UPSTREAM VAC OK
        'LTB_____VVR1___BM14' % UPSTREAM VAC OK
        'LTB_____VVR2___BM08' % UPSTREAM VAC OK
        ];
    
elseif strcmpi(Family, 'VVR') && strcmpi(Field, 'DownStream')
    ChannelNames = [
        'GTL_____VVR1___BM17' % DOWNSTREAM VAC OK
        'LN______VVR1___BM08' % DOWNSTREAM VAC OK
        'LTB_____VVR1___BM13' % DOWNSTREAM VAC OK
        'LTB_____VVR2___BM07' % DOWNSTREAM VAC OK
        ];
    
elseif strcmpi(Family, 'VVR') && strcmpi(Field, 'Ready')
    ChannelNames = [
        'GTL_____VVR1___BM14' % VVR1 READY
        'LN______VVR1___BM06' % VVR1 READY
        'LTB_____VVR1___BM12' % VVR2 READY
        'LTB_____VVR2___BM06' % VVR2 READY
        ];
    
elseif strcmpi(Family, 'VVR') && strcmpi(Field, 'Interlock')
    ChannelNames = [
        'GTL_____VVR1___BM15' % VVR NOT INTRLK
        'LN______VVR1___BM07' % VVR NOT INTRLK
        '                   '
        '                   '
        ];
    
elseif strcmpi(Family, 'VVR') && strcmpi(Field, 'DC_24V_OK')
    ChannelNames = [
        '                   '
        '                   '
        'LTB_____VVR1___BM15' % 24V CNTRL POWER
        'LTB_____VVR2___BM09' % 24V CNTRL POWER
        ];
    
elseif strcmpi(Family, 'VVR') && strcmpi(Field, 'Local')
    ChannelNames = [
        'GTL_____VVR1___BM11' % VVR1 IN LOCAL
        'LN______VVR1___BM03' % VVR1 IN LOCAL
        '                   '
        '                   '
        ];
    
elseif strcmpi(Family, 'VVR') && strcmpi(Field, 'Air')
    ChannelNames = [
        'GTL_____VVR1___BM19' % VVR1 AIR OK
        'LN______VVR1___BM10' % VVR1 AIR OK
        '                   '
        '                   '
        ];
    
elseif strcmpi(Family, 'VVR') && strcmpi(Field, 'Cathode')
    ChannelNames = [
        'GTL_____VVR1___BM16' % IN CATHODE TEST
        '                   '
        '                   '
        '                   '
        ];

else
    ChannelNames = '';
end


% 'GTL_____INM1___BC23'  % GTL INM1 IN/OUT
% 'GTL_____INM1LITBC22'  % LIGHT ON/OFF

% 'GTL_____PP1____BC21'  % GTL PP1 IN/OUT
% 'GTL_____PP1LIT_BC20'  % GTL PP1LT ON/OFF

% 'GTL_____TV1LIT_BC22'  % GRATICULE ON/OFF
% 'GTL_____TV2LIT_BC20'  % LIGHT ON/OFF
% 'LN______TV1LIT_BC22'  % LIGHT ON/OFF
% 'LN______TV2LIT_BC20'  % LIGHT ON/OFF
% 'LN______TV1____BC23'  % LN TV1 IN/OUT
% 'LN______TV2____BC21'  % LN TV2 IN/OUT

% 'LTB_____TV1LIT_BC17	TV1 LAMP ON/OFF
% 'LTB_____TV2LIT_BC19	TV2 LAMP ON/OFF
% 'LTB_____TV3LIT_BC17	TV3 LAMP ON/OFF
% 'LTB_____TV4LIT_BC19	TV4 LAMP ON/OFF
% 'LTB_____TV5LIT_BC17	TV5 LAMP ON/OFF
% 'LTB_____TV6LIT_BC20	TV6 LAMP ON/OFF
% 
% 'LTB_____TV1ATN_BM02' % 1 PLRZR CW LIM
% 'LTB_____TV2ATN_BM08' % 2 PLRZR CW LIM
% 'LTB_____TV3ATN_BM02' % 3 PLRZR CW LIM
% 'LTB_____TV4ATN_BM08' % 4 PLRZR CW LIM
% 'LTB_____TV5ATN_BM02' % 5 PLRZR CW LIM
% 'LTB_____TV6ATN_BM10' % 6 PLRZR CW LIM
% 
% 'LTB_____TV1ATN_BM03' % 1 PLRZR CCW LM
% 'LTB_____TV2ATN_BM09' % 2 PLRZR CCW LM
% 'LTB_____TV3ATN_BM03' % 3 PLRZR CCW LM
% 'LTB_____TV4ATN_BM09' % 4 PLRZR CCW LM
% 'LTB_____TV5ATN_BM03' % 5 PLRZR CCW LM
% 'LTB_____TV6ATN_BM11' % 6 PLRZR CCW LM
%
% 'GTL_____TV1____BM14'
% 'GTL_____TV2____BM08'
% 'LN______TV1____BM14' % LN TV1 RDY
% 'LN______TV2____BM08' % LN TV2 RDY
% 'LTB_____TV1____BM04' % 1 24V READY
% 'LTB_____TV3____BM04' % 3 24V READY
% 'LTB_____TV2____BM10' % 2 24V READY
% 'LTB_____TV4____BM10' % 4 24V READY
% 'LTB_____TV5____BM04' % 5 24V READY
% 'LTB_____TV6____BM12' % 6 24V READY
% 
% 'LN______TV1LIT_BM13' % LIGHT RDY
% 'LN______TV2LIT_BM07' % LIGHT RDY
% 'LTB_____TV1LIT_BM04' % 1 24V READY
% 'LTB_____TV2LIT_BM10' % 2 24V READY
% 'LTB_____TV3LIT_BM04' % 3 24V READY
% 'LTB_____TV4LIT_BM10' % 4 24V READY
% 'LTB_____TV5LIT_BM04' % 5 24V READY
% 'LTB_____TV6LIT_BM12' % 6 24V READY

% 'LN______TV1____BM15' % LN TV1 AIR OK
% 'LN______TV2____BM09' % LN TV2 AIR OK
% 
% 'LTB_____TV1____BC16	TV1 PAD IN/OUT
% 'LTB_____TV2____BC18	TV2 PAD IN/OUT
% 'LTB_____TV3____BC16	TV3 PAD IN/OUT
% 'LTB_____TV4____BC18	TV4 PAD IN/OUT
% 'LTB_____TV5____BC16	TV5 PAD IN/OUT
% 'LTB_____TV6____BC19	TV6 PAD IN/OUT

% 'GTL_____TV1____BM15	% GLT TV1 AIR OK
% 'GTL_____TV1____BM14	% GLT TV1 RDY
% 'GTL_____TV1LIT_BM12	% GRATICULE ON
% 'GTL_____TV1LIT_BM13	% GRATICULE RDY
% 'GTL_____TV2____BM08	% GLT TV2 RDY
% 'GTL_____TV2____BM09	% GLT TV2 AIR OK
%
% 'LN______TV1____BM14	% LN TV1 RDY
% 'LN______TV2____BM08	% LN TV2 RDY

% 'LN______TV1____BM15	% LN TV1 AIR OK
% 'LN______TV2____BM09	% LN TV2 AIR OK

% 'GTL_____TV2LIT_BM07	% LIGHT RDY
% 'LN______TV1LIT_BM13	% LIGHT RDY
% 'LN______TV2LIT_BM07	% LIGHT RDY

% 'BR1_____TV1____BC18 % TV1 BR PADIN/OUT
% 'BR1_____TV1____BM06 % TV1 PAD MON IN
% 'BR1_____TV1____BM07 % TV1 PAD MON OUT
% 'BR1_____TV1____BM12 % TV1 24V READY
    


% 'GTL_____IG1____BM02	over pressure
% 'GTL_____IG2____BM02	over pressure
% 'LN______IG1____BM02	over pressure
% 'LTB_____IG1____BM02	OVER PRESSURE
% 'LTB_____IG2____BM05	OVER PRESSURE

% 'GTL_____IG1____BM00	ion gauge ready
% 'GTL_____IG2____BM00	ion gauge ready
% 'LN______IG1____BM00	ion gauge ready
% 'LTB_____IG1____BM00	ION GAUGE1 READY
% 'LTB_____IG2____BM03	ION GAUGE2 READY

% 'GTL_____IG2____BM01	ion gauge on
% 'GTL_____IG1____BM01	ion gauge on
% 'LN______IG1____BM01	ion gauge on
% 'LTB_____IG1____BM01	ION GAUGE1 ON
% 'LTB_____IG2____BM04	ION GAUGE2 ON

% 'GTL_____IG1____BC00	ion gauge on/off
% 'GTL_____IG2____BC00	ion gauge on/off
% 'LN______IG1____BC00	Ion Gauge On/Off
% 'LTB_____IG1____BC00	Ion Gauge On/Off
% 'LTB_____IG2____BC04	Ion Gauge On/Off

% 'GTL_____IG1____AM00	ION GAUGE
% 'GTL_____IG2____AM00	ION GAUGE
% 'LN______IG1____AM00	ION GAUGE
% 'LTB_____IG1____AM00	PRESSURE MONITOR
% 'LTB_____IG2____AM05	PRESSURE MONITOR

% 'GTL_____IG1____AM01	CONVECTRON GAUGE
% 'GTL_____IG2____AM01	CONVECTRON GAUGE
% 'LN______IG1____AM01	CONVECTRON GAUGE
% 'LTB_____IG1____AM01	CONVECTRON GAUGE
% 'LTB_____IG2____AM06	CONVECTRON GAUGE


% 'GTL_____IP1____AM01	% GLT IP1 PRESSURE
% 'GTL_____IP2____AM02	% GLT IP2 PRESSURE
% 'LN______IP1____AM00	% LN IP1 PRESSURE
% 'LN______IP2____AM01	% LN IP2 PRESSURE
% 'LN______IP3____AM02	% LN IP3 PRESSURE
% 'LN______IP4____AM00	% LN IP4 PRESSURE
% 'LN______IP5____AM01	% LN IP5 PRESSURE

% 'GTL_____IP1____BM14	NOT OPERATING
% 'GTL_____IP2____BM10	NOT OPERATING
% 'LN______IP1____BM15	NOT OPERATING
% 'LN______IP2____BM11	NOT OPERATING
% 'LN______IP3____BM07	NOT OPERATING
% 'LN______IP4____BM15	NOT OPERATING
% 'LN______IP5____BM11	NOT OPERATING

% 'GTL_____IP1____BM12	RUN CONDITION
% 'GTL_____IP2____BM08	RUN CONDITION
% 'LN______IP1____BM13	RUN CONDITION
% 'LN______IP2____BM09	RUN CONDITION
% 'LN______IP3____BM05	RUN CONDITION
% 'LN______IP4____BM13	RUN CONDITION
% 'LN______IP5____BM09	RUN CONDITION

% 'GTL_____IP1____BM13	START CONDITION
% 'GTL_____IP2____BM09	START CONDITION
% 'LN______IP1____BM14	START CONDITION
% 'LN______IP2____BM10	START CONDITION
% 'LN______IP3____BM06	START CONDITION
% 'LN______IP4____BM14	START CONDITION
% 'LN______IP5____BM10	START CONDITION

% 'GTL_____IP1____BM11	H.V. ON
% 'GTL_____IP2____BM07	H.V. ON
% 'LN______IP1____BM12	H.V. ON
% 'LN______IP2____BM08	H.V. ON
% 'LN______IP3____BM04	H.V. ON
% 'LN______IP4____BM12	H.V. ON
% 'LN______IP5____BM08	H.V. ON


% 'LTB_____IP1____AM02	PRESSURE MONITOR
% 'LTB_____IP2____AM03	PRESSURE MONITOR
% 'LTB_____IP3____AM04	PRESSURE MONITOR

% 'LTB_____IP1____BM04	ON/OFF MONITOR
% 'LTB_____IP2____BM07	ON/OFF MONITOR
% 'LTB_____IP3____BM09	ON/OFF MONITOR

% 'LTB_____IP1____BM03	READY MONITOR
% 'LTB_____IP2____BM06	READY MONITOR
% 'LTB_____IP3____BM08	READY MONITOR

% 'LTB_____IP1____BC01	IP ON/OFF
% 'LTB_____IP2____BC02	IP ON/OFF
% 'LTB_____IP3____BC03	IP ON/OFF


% 'EG______IP1____BM15	IP TRIPPED

