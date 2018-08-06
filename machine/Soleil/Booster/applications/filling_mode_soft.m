% mettre synchro OFF
n=1    ;
% les 4 tours (2 coups par tours)
dt=[13 13 13 -39];
%dt=[26 -26 26 -26 26 -26 26 -26 26 -26];
%dt=[13 13 -26];
%dt=[13  -13];
%dt=[50  -11  -2   -11    -2    -11    -2   -11  ];

%dt=[50  -11  -2   -37 ];

% le meme tour 8 fois - reiterer 'run' pour changer de quart
% dt=[13 0 0 0];

% writeattribute('BOO/AE/dipole/current',545);
% writeattribute('BOO/AE/QF/current',201.7677);
% writeattribute('BOO/AE/QD/current',162.611);
% pause(5)
 
for kt=1:1
    for i=1:1

    %     for j=1:10
    %         tango_command_inout('ANS/SY/CENTRAL','FireSoftEvent');
    %         pause(0.6)
    %     end

        jump=dt(i);

        temp=tango_read_attribute2('ANS/SY/CENTRAL', 'TPcStepDelay');
        clk=temp.value(n)+jump;
        tango_write_attribute2('ANS/SY/CENTRAL', 'TPcStepDelay',clk);

        temp=tango_read_attribute2('ANS/SY/CENTRAL', 'TSoftStepDelay');
        clk=temp.value(n)+jump;
        tango_write_attribute2('ANS/SY/CENTRAL', 'TSoftStepDelay',clk);


    end
end

fprintf('*********************************\n')


