function buildalarmhandler 

fid = fopen('/home/als/physbase/hlc/AlarmHandlers/test.alhConfig','w');


setpathals('StorageRing');
 
fprintf(fid,'GROUP    NULL                            ALS_MAGNETS \n');
fprintf(fid,'GROUP    ALS_MAGNETS                     STORAGE_RING \n');

fprintf(fid,'GROUP    STORAGE_RING                    MAINS \n');
FamilyNameList = {'BEND','SF','SD','QFA'};
for j = 1:length(FamilyNameList)
    FamilyName = FamilyNameList{j};
    fprintf(fid,'GROUP    MAINS                        %s \n', FamilyName);
    Dev = family2dev(FamilyName, 'On', 1, 1);
    pv  = family2channel(FamilyName, 'On', Dev);    
    AM =  family2channel(FamilyName, 'Monitor', Dev);    
    if iscell(pv)
        pv = cell2mat(pv);
    end
    cn  = family2common(FamilyName, Dev);
    
    fprintf(fid,'GROUP    %s                      On/Off \n', FamilyName);
    for i = 1:size(pv,1)
        if ~isempty(deblank(pv(i,:)))
            fprintf(fid,'CHANNEL  %s  %s\n', 'On/Off', deblank(pv(i,:)));
            fprintf(fid,'$ALIAS   %s(%d,%d) On/Off\n', FamilyName, Dev(i,:));
            fprintf(fid,'$GUIDANCE\n');
            fprintf(fid,'%s\n', deblank(pv(i,:)));
            fprintf(fid,'$END\n');
        end
    end
    fprintf(fid,'GROUP    %s         Monitor (Tolerance) \n', FamilyName);
    for i = 1:size(AM,1)
        if ~isempty(deblank(AM(i,:)))
            fprintf(fid,'CHANNEL  %s  %s\n', 'Monitor', deblank(AM(i,:)));
            fprintf(fid,'$ALIAS   %s(%d,%d) Monitor (Tolerance)\n', FamilyName, Dev(i,:));
            fprintf(fid,'$GUIDANCE\n');
            fprintf(fid,'%s\n', deblank(AM(i,:)));
            fprintf(fid,'$END\n');
        end
    end
end

fprintf(fid,'GROUP    STORAGE_RING                    HARMONIC_SEXT \n');
FamilyNameList = {'SHF','SHD'};
for j = 1:length(FamilyNameList)
    FamilyName = FamilyNameList{j};
    fprintf(fid,'GROUP    HARMONIC_SEXT                %s \n', FamilyName);
    Dev = family2dev(FamilyName, 'On', 1, 1);
    pv  = family2channel(FamilyName, 'On', Dev);    
    if iscell(pv)
        pv = cell2mat(pv);
    end
    cn  = family2common(FamilyName, Dev);
    
    for i = 1:size(pv,1)
        if ~isempty(deblank(pv(i,:)))
            fprintf(fid,'CHANNEL  %s  %s\n', FamilyName, deblank(pv(i,:)));
            fprintf(fid,'$ALIAS   %s(%d,%d) On/Off\n', FamilyName, Dev(i,:));
            fprintf(fid,'$GUIDANCE\n');
            fprintf(fid,'%s\n', deblank(pv(i,:)));
            fprintf(fid,'$END\n');
        end
    end
end

fprintf(fid,'GROUP    STORAGE_RING                    QF_QD_QDA \n');
FamilyNameList = {'QF','QD','QDA'};
for j = 1:length(FamilyNameList)
    FamilyName = FamilyNameList{j};
    fprintf(fid,'GROUP    QF_QD_QDA                    %s \n', FamilyName);
    Dev = family2dev(FamilyName, 'On', 1, 1);
    pv  = family2channel(FamilyName, 'On', Dev);    
    AM =  family2channel(FamilyName, 'Monitor', Dev);    
    if iscell(pv)
        pv = cell2mat(pv);
    end
    cn  = family2common(FamilyName, Dev);
    
    fprintf(fid,'GROUP    %s                      On/Off \n', FamilyName);
    for i = 1:size(pv,1)
        if ~isempty(deblank(pv(i,:)))
            fprintf(fid,'CHANNEL  %s  %s\n', 'On/Off', deblank(pv(i,:)));
            fprintf(fid,'$ALIAS   %s(%d,%d) On/Off\n', FamilyName, Dev(i,:));
            fprintf(fid,'$GUIDANCE\n');
            fprintf(fid,'%s\n', deblank(pv(i,:)));
            fprintf(fid,'$END\n');
        end
    end
    fprintf(fid,'GROUP    %s         Monitor (Tolerance) \n', FamilyName);
    for i = 1:size(AM,1)
        if ~isempty(deblank(AM(i,:)))
            fprintf(fid,'CHANNEL  %s  %s\n', 'Monitor', deblank(AM(i,:)));
            fprintf(fid,'$ALIAS   %s(%d,%d) Monitor (Tolerance)\n', FamilyName, Dev(i,:));
            fprintf(fid,'$GUIDANCE\n');
            fprintf(fid,'%s\n', deblank(AM(i,:)));
            fprintf(fid,'$END\n');
        end
    end
end

fprintf(fid,'GROUP    STORAGE_RING                    SKEWS \n');
FamilyNameList = {'SQSHF','SQSF','SQSD'};
for j = 1:length(FamilyNameList)
    FamilyName = FamilyNameList{j};
    fprintf(fid,'GROUP    SKEWS                        %s \n', FamilyName);
    Dev = family2dev(FamilyName, 'On', 1, 1);
    pv  = family2channel(FamilyName, 'On', Dev);    
    if iscell(pv)
        pv = cell2mat(pv);
    end
    cn  = family2common(FamilyName, Dev);
    
    for i = 1:size(pv,1)
        if ~isempty(deblank(pv(i,:)))
            fprintf(fid,'CHANNEL  %s  %s\n', FamilyName, deblank(pv(i,:)));
            fprintf(fid,'$ALIAS   %s(%d,%d) On/Off\n', FamilyName, Dev(i,:));
            fprintf(fid,'$GUIDANCE\n');
            fprintf(fid,'%s\n', deblank(pv(i,:)));
            fprintf(fid,'$END\n');
        end
    end
end


fprintf(fid,'GROUP    STORAGE_RING                    CORRECTORS \n');
FamilyNameList = {'HCM','VCM','HCMCHICANE'};
for j = 1:length(FamilyNameList)
    FamilyName = FamilyNameList{j};
    fprintf(fid,'GROUP    CORRECTORS                   %s \n', FamilyName);
    Dev = family2dev(FamilyName, 'On', 1, 1);
    pv  = family2channel(FamilyName, 'On', Dev);    
    if iscell(pv)
        pv = cell2mat(pv);
    end
    cn  = family2common(FamilyName, Dev);
    
    for i = 1:size(pv,1)
        if ~isempty(deblank(pv(i,:)))
            fprintf(fid,'CHANNEL  %s  %s\n', FamilyName, deblank(pv(i,:)));
            fprintf(fid,'$ALIAS   %s(%d,%d) On/Off\n', FamilyName, Dev(i,:));
            fprintf(fid,'$GUIDANCE\n');
            fprintf(fid,'%s\n', deblank(pv(i,:)));
            fprintf(fid,'$END\n');
        end
    end
end



setpathals('BTS');
 
fprintf(fid,'GROUP    ALS_MAGNETS                     BTS \n');

fprintf(fid,'GROUP    BTS                    MAINS \n');
FamilyNameList = {'BEND','Q'};
for j = 1:length(FamilyNameList)
    FamilyName = FamilyNameList{j};
    fprintf(fid,'GROUP    MAINS                        %s \n', FamilyName);
    Dev = family2dev(FamilyName, 'On', 1, 1);
    pv  = family2channel(FamilyName, 'On', Dev);    
    if iscell(pv)
        pv = cell2mat(pv);
    end
    cn  = family2common(FamilyName, Dev);
    
    for i = 1:size(pv,1)
        if ~isempty(deblank(pv(i,:)))
            fprintf(fid,'CHANNEL  %s  %s\n', FamilyName, deblank(pv(i,:)));
            %fprintf(fid,'$ALIAS   %s(%d,%d) On/Off\n', FamilyName, Dev(i,:));
            if iscell(cn)
                fprintf(fid,'$ALIAS   %s On/Off\n', cn{i});
            else
                fprintf(fid,'$ALIAS   %s On/Off\n', deblank(cn(i,:)));
            end
            fprintf(fid,'$GUIDANCE\n');
            fprintf(fid,'%s\n', deblank(pv(i,:)));
            fprintf(fid,'$END\n');
        end
    end
end


fprintf(fid,'GROUP    BTS                    CORRECTORS \n');
FamilyNameList = {'HCM','VCM'};
for j = 1:length(FamilyNameList)
    FamilyName = FamilyNameList{j};
    fprintf(fid,'GROUP    CORRECTORS                   %s \n', FamilyName);
    Dev = family2dev(FamilyName, 'On', 1, 1);
    pv  = family2channel(FamilyName, 'On', Dev);    
    if iscell(pv)
        pv = cell2mat(pv);
    end
    cn  = family2common(FamilyName, Dev);
    
    for i = 1:size(pv,1)
        if ~isempty(deblank(pv(i,:)))
            fprintf(fid,'CHANNEL  %s  %s\n', FamilyName, deblank(pv(i,:)));
            %fprintf(fid,'$ALIAS   %s(%d,%d) On/Off\n', FamilyName, Dev(i,:));
            if iscell(cn)
                fprintf(fid,'$ALIAS   %s On/Off\n', cn{i});
            else
                fprintf(fid,'$ALIAS   %s On/Off\n', deblank(cn(i,:)));
            end
            fprintf(fid,'$GUIDANCE\n');
            fprintf(fid,'%s\n', deblank(pv(i,:)));
            fprintf(fid,'$END\n');
        end
    end
end



setpathals('GTB');
 
fprintf(fid,'GROUP    ALS_MAGNETS                     GTB \n');

fprintf(fid,'GROUP    GTB                    MAINS \n');
FamilyNameList = {'BEND','Q','SOL','BuckingCoil'};
for j = 1:length(FamilyNameList)
    FamilyName = FamilyNameList{j};
    fprintf(fid,'GROUP    MAINS                        %s \n', FamilyName);
    Dev = family2dev(FamilyName, 'On', 1, 1);
    pv  = family2channel(FamilyName, 'On', Dev);    
    if iscell(pv)
        pv = cell2mat(pv);
    end
    cn  = family2common(FamilyName, Dev);
    
    for i = 1:size(pv,1)
        if ~isempty(deblank(pv(i,:)))
            fprintf(fid,'CHANNEL  %s  %s\n', FamilyName, deblank(pv(i,:)));
            %fprintf(fid,'$ALIAS   %s(%d,%d) On/Off\n', FamilyName, Dev(i,:));
            if iscell(cn)
                fprintf(fid,'$ALIAS   %s On/Off\n', cn{i});
            else
                fprintf(fid,'$ALIAS   %s On/Off\n', deblank(cn(i,:)));
            end
            fprintf(fid,'$GUIDANCE\n');
            fprintf(fid,'%s\n', deblank(pv(i,:)));
            fprintf(fid,'$END\n');
        end
    end
end


fprintf(fid,'GROUP    GTB                    CORRECTORS \n');
FamilyNameList = {'HCM','VCM'};
for j = 1:length(FamilyNameList)
    FamilyName = FamilyNameList{j};
    fprintf(fid,'GROUP    CORRECTORS                   %s \n', FamilyName);
    Dev = family2dev(FamilyName, 'On', 1, 1);
    pv  = family2channel(FamilyName, 'On', Dev);    
    if iscell(pv)
        pv = cell2mat(pv);
    end
    cn  = family2common(FamilyName, Dev);
    
    for i = 1:size(pv,1)
        if ~isempty(deblank(pv(i,:)))
            fprintf(fid,'CHANNEL  %s  %s\n', FamilyName, deblank(pv(i,:)));
            %fprintf(fid,'$ALIAS   %s(%d,%d) On/Off\n', FamilyName, Dev(i,:));
            if iscell(cn)
                fprintf(fid,'$ALIAS   %s On/Off\n', cn{i});
            else
                fprintf(fid,'$ALIAS   %s On/Off\n', deblank(cn(i,:)));
            end
            fprintf(fid,'$GUIDANCE\n');
            fprintf(fid,'%s\n', deblank(pv(i,:)));
            fprintf(fid,'$END\n');
        end
    end
end


% Haris added Booster magnets

setpathals('Booster');
 
fprintf(fid,'GROUP    ALS_MAGNETS                     Booster \n');

fprintf(fid,'GROUP    Booster                    MAINS \n');
FamilyNameList = {'BEND','SF','SD'};
for j = 1:length(FamilyNameList)
    FamilyName = FamilyNameList{j};
    fprintf(fid,'GROUP    MAINS                        %s \n', FamilyName);
    Dev = family2dev(FamilyName, 'On', 1, 1);
    pv  = family2channel(FamilyName, 'On', Dev);    
    if iscell(pv)
        pv = cell2mat(pv);
    end
    cn  = family2common(FamilyName, Dev);
    
    for i = 1:size(pv,1)
        if ~isempty(deblank(pv(i,:)))
            fprintf(fid,'CHANNEL  %s  %s\n', FamilyName, deblank(pv(i,:)));
            %fprintf(fid,'$ALIAS   %s(%d,%d) On/Off\n', FamilyName, Dev(i,:));
            if iscell(cn)
                fprintf(fid,'$ALIAS   %s On/Off\n', cn{i});
            else
                fprintf(fid,'$ALIAS   %s On/Off\n', deblank(cn(i,:)));
            end
            fprintf(fid,'$GUIDANCE\n');
            fprintf(fid,'%s\n', deblank(pv(i,:)));
            fprintf(fid,'$END\n');
        end
    end
end


%fprintf(fid,'GROUP    Booster                    CORRECTORS \n');
%FamilyNameList = {'HCM','VCM'};
%for j = 1:length(FamilyNameList)
 %   FamilyName = FamilyNameList{j};
  %  fprintf(fid,'GROUP    CORRECTORS                   %s \n', FamilyName);
   % Dev = family2dev(FamilyName, 'On', 1, 1);
    %pv  = family2channel(FamilyName, 'On', Dev);    
    %if iscell(pv)
    %    pv = cell2mat(pv);
    %end
    %cn  = family2common(FamilyName, Dev);
    
    %for i = 1:size(pv,1)
     %   if ~isempty(deblank(pv(i,:)))
      %      fprintf(fid,'CHANNEL  %s  %s\n', FamilyName, deblank(pv(i,:)));
            %fprintf(fid,'$ALIAS   %s(%d,%d) On/Off\n', FamilyName, Dev(i,:));
       %     if iscell(cn)
       %         fprintf(fid,'$ALIAS   %s On/Off\n', cn{i});
        %    else
        %        fprintf(fid,'$ALIAS   %s On/Off\n', deblank(cn(i,:)));
         %   end
         %   fprintf(fid,'$GUIDANCE\n');
          %  fprintf(fid,'%s\n', deblank(pv(i,:)));
          %  fprintf(fid,'$END\n');
        %end
   % end
%end
% Haris Finished editing 

fclose(fid);


fprintf(2, '\n\n         Wait.  You''re not done!!!!\n');
fprintf(2, '         This program creates test.alhConfig, you needed to save it to ALSMagnets.alhConfig for it to be the default!!!!!\n');
fprintf(2, '         Directory:    /home/als/physbase/hlc/AlarmHandlers \n');
fprintf(2, '         Directions:\n');
fprintf(2, '             Open an X-terminal\n');
fprintf(2, '             cd /home/als/physbase/hlc/AlarmHandlers \n');
fprintf(2, '             ./runALHTest.sh & \n');
fprintf(2, '             It will unfortunately error, but open test.alhConfig and "Save as" to ALSMagnets.alhConfig\n');
fprintf(2, '\n\n');


