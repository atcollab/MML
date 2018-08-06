function RF_cell_power_watchdog

while 1
%     fprintf('Monitoring the SR RF Cell Powers: will turn off RF if one gets above 50kW...\n')
    disp(['Monitoring the SR RF Cell Powers: will turn off RF if one gets above 50kW... ', datestr(now)]);
try
        cell1_pwr = getpv('SR03S___C1CELL_AM03');
    catch
        disp('Trouble reading Cell 1 Power');
    end
    try
        cell2_pwr = getpv('SR03S___C2CELL_AM03');
    catch
        disp('Trouble reading Cell 2 Power');
    end

    if (cell1_pwr>50) || (cell2_pwr>50)
        disp('One of the RF Cell Powers is TOO HIGH (above 50kW)!');
        try
            setpv('SR03S___RFCONT_BC23',0);
        catch
            disp('Trouble turning off the RF! PLEASE TURN IT OFF MANUALLY');
        end
        break;
    end
    pause(1)
end

        