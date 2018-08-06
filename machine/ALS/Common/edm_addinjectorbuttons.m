function edm_addinjectorbuttons(x, y, FileName)


% Add push buttons for other applications

% Defaults
FontSize = 18;
FontWeight = 'bold';  % 'medium', 'bold'
%FontName = 'helvetica';
ButtonLabel = '';
Width  = 200;
Height = 35;


if ischar(FileName)
    fid = fopen(FileName, 'r+', 'b');
else
    fid = FileName;
end

status = fseek(fid, 0, 'eof');

% Electron Gun
Width  = 125;
ButtonLabel = 'EG & Heater';
Command = '/home/als/physbase/hlc/GTB/RF/runEG.sh';
EDMWidget = EDMShellCommand(Command, x, y, ...
    'FontSize', FontSize, ...
    'FontWeight', FontWeight, ...
    'ButtonLabel', ButtonLabel, ...
    'Width', Width, ...
    'Height', Height);
WriteEDMFile(fid, EDMWidget);
x = x + Width + 5;

% Modulators
Width  = 75;
ButtonLabel = 'MOD 1';
Command = '/home/als/physbase/hlc/GTB/RF/runModulator1.sh';
EDMWidget = EDMShellCommand(Command, x, y, ...
    'FontSize', FontSize, ...
    'FontWeight', FontWeight, ...
    'ButtonLabel', ButtonLabel, ...
    'Width', Width, ...
    'Height', Height);
WriteEDMFile(fid, EDMWidget);
x = x + Width + 5;
ButtonLabel = 'MOD 2';
Command = '/home/als/physbase/hlc/GTB/RF/runModulator2.sh';
EDMWidget = EDMShellCommand(Command, x, y, ...
    'FontSize', FontSize, ...
    'FontWeight', FontWeight, ...
    'ButtonLabel', ButtonLabel, ...
    'Width', Width, ...
    'Height', Height);
WriteEDMFile(fid, EDMWidget);
x = x + Width + 5;


% GTB - Power supplies
Width  = 200;
ButtonLabel = 'GTB Power Supplies';
%Command = '/home/als/physbase/hlc/GTB/runGTB_MPS.sh';
Command = 'runGTB_MPS.sh';
EDMWidget = EDMShellCommand(Command, x, y, ...
    'FontSize', FontSize, ...
    'FontWeight', FontWeight, ...
    'ButtonLabel', ButtonLabel, ...
    'Width', Width, ...
    'Height', Height);
WriteEDMFile(fid, EDMWidget);
x = x + Width + 5;


% BTS - Power supplies
ButtonLabel = 'BTS Power Supplies';
%Command = '/home/als/physbase/hlc/BTS/runBTS_MPS.sh';
Command = 'runBTS_MPS.sh';
EDMWidget = EDMShellCommand(Command, x, y, ...
    'FontSize', FontSize, ...
    'FontWeight', FontWeight, ...
    'ButtonLabel', ButtonLabel, ...
    'Width', Width, ...
    'Height', Height);
WriteEDMFile(fid, EDMWidget);
x = x + Width + 5;


% Timing
Width  = 150;
ButtonLabel = 'Timing System';
Command = 'runTiming_Injector.sh';
EDMWidget = EDMShellCommand(Command, x, y, ...
    'FontSize', FontSize, ...
    'FontWeight', FontWeight, ...
    'ButtonLabel', ButtonLabel, ...
    'Width', Width, ...
    'Height', Height);
WriteEDMFile(fid, EDMWidget);
x = x + Width + 5;


% Pulsed magnets
Width  = 165;
ButtonLabel = 'Pulsed Magnets';
Command = '/home/als/physbase/hlc/BTS/runPulsedMagnets.sh';
EDMWidget = EDMShellCommand(Command, x, y, ...
    'FontSize', FontSize, ...
    'FontWeight', FontWeight, ...
    'ButtonLabel', ButtonLabel, ...
    'Width', Width, ...
    'Height', Height);
WriteEDMFile(fid, EDMWidget);
x = x + Width + 5;


if ischar(FileName)
    fclose(fid);
end



function WriteEDMFile(fid, EDMWidget)

for i = 1:length(EDMWidget)
    fprintf(fid, '%s\n', EDMWidget{i});
end
fprintf(fid, '\n');