function resetudferrors


% if 0
% 
%     % Set all the UDF fields for all the families in the AO
%     % Doing this has problems because not all channel seem to have .UDF fields
%     [FamilyCell, AO] = getfamilylist('Cell');
%     for i = 1:length(FamilyCell)
%         FieldCell = fieldnames(AO.(FamilyCell{i}));
%         for j = 1:length(FieldCell)
%             Names = family2channel(FamilyCell{i}, FieldCell{j});
%             if ~isempty(deblank(Names)) && ~any(strfind(Names(:)','.'))
%                 try
%                     setpv(Names, 'UDF', 0);
%                 catch
%                     for k = 1:size(Names, 1)
%                         try
%                             Name = deblank(Names(k,:));
%                             if ~isempty(Name)
%                                 setpv(Name, 'UDF', 0);
%                             end
%                         catch
%                             fprintf('   Could not set %s.UDF\n', Name);
%                         end
%                     end
%                 end
%             end
%         end
%     end
% 
% else
% 
%     Families = {'HCM','VCM','SQSF','SQSD','QF','QD','QFA','QDA','SF','SD','BEND'};
%     for i = 1:length(Families)
%         setpv(family2channel(Families{i}, 'Setpoint'),     'UDF', 0);
%        %setpv(family2channel(Families{i}, 'Monitor'),      'UDF', 0);
%         setpv(family2channel(Families{i}, 'RampRate'),     'UDF', 0);
%         setpv(family2channel(Families{i}, 'TimeConstant'), 'UDF', 0);
%         setpv(family2channel(Families{i}, 'OnControl'),    'UDF', 0);
%        %setpv(family2channel(Families{i}, 'Ready'),        'UDF', 0);
%         setpv(family2channel(Families{i}, 'Reset'),        'UDF', 0);
%     end
% 
%     % Feed forward channels
%     setpv(family2channel('HCM', 'FF1'), 'UDF', 0);
%     setpv(family2channel('HCM', 'FF2'), 'UDF', 0);
%     setpv(family2channel('VCM', 'FF1'), 'UDF', 0);
%     setpv(family2channel('VCM', 'FF2'), 'UDF', 0);
% 
%     setpv(family2channel('QF', 'FF'), 'UDF', 0);
%     setpv(family2channel('QD', 'FF'), 'UDF', 0);
%  
%     % RF
%     setpv('EG______HQMOFM_AC01.UDF', 0);
%     %setpv('SR01C___FREQB__AM00.UDF', 0);
%     %setpv('SR01C___FREQB__AC00.UDF', 0);
%     setpv('SR01____FFBFREQAM00.UDF', 0);
%     
%     % Tune
%     setpv('SR01C___TUNE_X_AC00.UDF', 0);
%     setpv('SR01C___TUNE_Y_AC00.UDF', 0);
%     setpv('SR01C___TUNE_H_AC00.UDF', 0);
%   
%     % BPMs
%     setpv(family2channel('BPMx', 'NumberOfAverages'), 'UDF', 0);
%     setpv(family2channel('BPMx', 'TimeConstant'),     'UDF', 0);
%     setpv(family2channel('BPMx', 'GoldenSetpoint'),   'UDF', 0);
% 
%     % ID
%     setpv(family2channel('ID', 'Setpoint'),         'UDF', 0);
%     setpv(family2channel('ID', 'VelocityControl'),  'UDF', 0);
%     setpv(family2channel('ID', 'VelocityProfile'),  'UDF', 0);
%     setpv(family2channel('ID', 'UserGap'),          'UDF', 0);
%     setpv(family2channel('ID', 'GapEnableControl'), 'UDF', 0);
% end
% 
% 
% % SRCONTROL
% setpv('SR_STATE.UDF', 0);
% %setpv('SR_LATTICE_FILE.UDF', 0);
% 
% 
% % Physics channels
% setpv('Physics1.UDF',  0);
% setpv('Physics2.UDF',  0);
% setpv('Physics3.UDF',  0);
% setpv('Physics4.UDF',  0);
% setpv('Physics5.UDF',  0);
% setpv('Physics6.UDF',  0);
% setpv('Physics7.UDF',  0);
% setpv('Physics8.UDF',  0);
% setpv('Physics9.UDF',  0);
% setpv('Physics10.UDF', 0);


