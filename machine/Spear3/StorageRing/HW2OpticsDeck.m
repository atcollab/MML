function HW2OpticsDeck(SkeletonFile,varargin)
% HW2OpticsDeck(SkeletonFile)
% e.g. HW2OpticsDeck(AD.Deck.MADSkeleton_Group)
%
% Save DIMAD deck or MAD deck or AT deck or with physics units
% skeletonfiletype = name of the skeleton file
%
% J. Corbett  April 12, 2003
% see HW2OpticsDeck.doc

[varargin,monitorflag]=findkeyword(varargin,'monitor');
if ~monitorflag; monitorflag='setpoint'; 
else
    monitorflag='monitor';
end   %default to setpoint readbacks

[varargin,mode]=findkeyword(varargin,'model');
if ~mode; mode='online'; 
else
    mode='model';
end   %default to online

%find type of skeleton deck
if      findstr(SkeletonFile,'DIMAD')
    filetype='DIMAD';
elseif  findstr(SkeletonFile,'MAD')
    filetype='MAD';
elseif  findstr(SkeletonFile,'AT')
    filetype='AT';
end

ad=getad;

%open skeleton deck
SkeletonFile=[ad.Directory.Lattice SkeletonFile];
[skelfid,message]=fopen(SkeletonFile,'r');
if skelfid==-1
  disp(['   WARNING: Unable to open file :' SkeletonFile]);
  disp(message);
  return
end
disp(['   Skeleton file name: ' SkeletonFile]);

%open save deck
%FileName = appendtimestamp(filetype, clock);
% Append date_Time to FileName
FileName = sprintf('%s_%s', filetype, datestr(clock,31));
FileName(end-2) = '_';
FileName(end-5) = '_';
FileName(end-8) = '_';
FileName(end-11) = '_';
FileName(end-14) = '_';


SaveFile=[ad.Directory.ConfigData  FileName '.m'];
[savefid,message]=fopen(SaveFile,'w');
if savefid==-1
  disp(['   WARNING: Unable to open file :' SaveFile]);
  disp(message);
  return
end

fprintf(savefid,'%s\n',['%Saving online File: ' SaveFile]);
fprintf(savefid,'%s\n',['%Timestamp: ' datestr(now,0)]);
disp(['   Loading machine configuration data (readback = ' monitorflag ')']);
disp(['   Data acquisition mode is: ', mode]);
disp(['   Save file name: ' SaveFile]);

if strcmpi(monitorflag,'monitor')
  [ConfigSetpoint, ConfigMonitor]=getmachineconfig('physics',mode);
  config=ConfigMonitor;
else
  config=getmachineconfig('physics',mode);
end

%read skeleton deck, write lines to save deck
eof=0;
while eof==0
textline=fgetl(skelfid);
if isempty(textline)
  fprintf(savefid,'%s\n',' ');
end

if ~isempty(textline)
   if     strfind(upper(textline),upper( 'Write Grouped Standard Cell Dipoles'))
          WriteKValue(savefid,filetype,config,  'Write Grouped Standard Cell Dipoles');
          
   elseif strfind(upper(textline),upper( 'Write Grouped Match Cell Dipoles'))
          WriteKValue(savefid,filetype,config,  'Write Grouped Match Cell Dipoles');
          
   elseif strfind(upper(textline),upper( 'Write Grouped Standard Cell Quadrupoles'))
          WriteKValue(savefid,filetype,config,  'Write Grouped Standard Cell Quadrupoles');
          
   elseif strfind(upper(textline),upper( 'Write Grouped Match Cell Quadrupoles'))
          WriteKValue(savefid,filetype,config,  'Write Grouped Match Cell Quadrupoles');
                    
   elseif strfind(upper(textline),upper( 'Write Grouped Standard Cell Sextupoles'))
          WriteKValue(savefid,filetype,config,  'Write Grouped Standard Cell Sextupoles');
          
   elseif strfind(upper(textline),upper( 'Write Grouped Match Cell Sextupoles'))
          WriteKValue(savefid,filetype,config,  'Write Grouped Match Cell Sextupoles');
          
 else   fprintf(savefid,'%s\n',textline);
   end
end

eof=feof(skelfid);
end
fclose(skelfid);
fclose(savefid);


%==========================================
function WriteKValue(fid,filetype,config,command)
%==========================================
%fid is file id
%filetype is AT, MAD, DIMAD, etc
%config contains lattice parameters
%command indicates type of parameter to output

if     strcmpi(filetype,'DIMAD') | strcmpi(filetype,'AT')
    eq='=';
elseif strcmpi(filetype,'MAD')
    eq='=:';
end

if     strcmpi(filetype,'MAD') | strcmpi(filetype,'AT')
    filetype='MADAT';
end


switch filetype
  case 'DIMAD'
   if     strfind(upper(command),upper('Write Grouped Standard Cell Dipoles'))
          fprintf(fid,'%s\n',['KBND'   eq  num2str(mean(config.BND.Data),'%18.13f') ]);
          
   elseif strfind(upper(command),upper('Write Grouped Match Cell Dipoles'))
          fprintf(fid,'%s\n',['KB34'   eq  num2str(mean(config.B34.Data),'%18.13f') ]);
         
   elseif strfind(upper(command),upper('Write Grouped Standard Cell Quadrupoles'))
          fprintf(fid,'%s\n',['KQF '   eq  num2str(mean(config.QF.Data),  '%18.13f') ]);
          fprintf(fid,'%s\n',['KQD '   eq  num2str(mean(config.QD.Data),  '%18.13f') ]);
          fprintf(fid,'%s\n',['KQFC '  eq  num2str(mean(config.QFC.Data), '%18.13f') ]);
          
   elseif strfind(upper(command),upper('Write Grouped Match Cell Quadrupoles'))
          fprintf(fid,'%s\n',['KQDX '   eq  num2str(mean(config.QDX.Data),  '%18.13f') ]);
          fprintf(fid,'%s\n',['KQFX '   eq  num2str(mean(config.QFX.Data),  '%18.13f') ]);
          fprintf(fid,'%s\n',['KQDY '   eq  num2str(mean(config.QDY.Data),  '%18.13f') ]);
          fprintf(fid,'%s\n',['KQFY '   eq  num2str(mean(config.QFY.Data),  '%18.13f') ]);
          fprintf(fid,'%s\n',['KQDZ '   eq  num2str(mean(config.QDZ.Data),  '%18.13f') ]);
          fprintf(fid,'%s\n',['KQFZ '   eq  num2str(mean(config.QFZ.Data),  '%18.13f') ]);
  
   elseif strfind(upper(command),upper('Write Grouped Standard Cell Sextupoles'))
          fprintf(fid,'%s\n',['KSF '  eq  num2str(mean(config.SF.Data),  '%18.13f') ]);
          fprintf(fid,'%s\n',['KSD '  eq  num2str(mean(config.SD.Data),  '%18.13f') ]);
          
   elseif strfind(upper(command),upper('Write Grouped Match Cell Sextupoles'))
          fprintf(fid,'%s\n',['KSFI '  eq  num2str(mean(config.SFI.Data),  '%18.13f') ]);
          fprintf(fid,'%s\n',['KSDI '  eq  num2str(mean(config.SDI.Data),  '%18.13f') ]);
       
   else disp(['Warning: supply values not written: ', command]);

   end
   
  case 'MADAT'
   if     strfind(upper(command),upper('Write Grouped Standard Cell Dipoles'))
          fprintf(fid,'%s\n',['KBND'   eq  num2str(mean(config.BND.Data),'%18.13f'),';']);
          
   elseif strfind(upper(command),upper('Write Grouped Match Cell Dipoles'))
          fprintf(fid,'%s\n',['KB34'   eq  num2str(mean(config.B34.Data),'%18.13f'),';']);
         
   elseif strfind(upper(command),upper('Write Grouped Standard Cell Quadrupoles'))
          fprintf(fid,'%s\n',['KQF '   eq  num2str(mean(config.QF.Data),  '%18.13f'),';']);
          fprintf(fid,'%s\n',['KQD '   eq  num2str(mean(config.QD.Data),  '%18.13f'),';']);
          fprintf(fid,'%s\n',['KQFC '  eq  num2str(mean(config.QFC.Data), '%18.13f'),';']);
          
   elseif strfind(upper(command),upper('Write Grouped Match Cell Quadrupoles'))
          fprintf(fid,'%s\n',['KQDX '   eq  num2str(mean(config.QDX.Data),  '%18.13f'),';']);
          fprintf(fid,'%s\n',['KQFX '   eq  num2str(mean(config.QFX.Data),  '%18.13f'),';']);
          fprintf(fid,'%s\n',['KQDY '   eq  num2str(mean(config.QDY.Data),  '%18.13f'),';']);
          fprintf(fid,'%s\n',['KQFY '   eq  num2str(mean(config.QFY.Data),  '%18.13f'),';']);
          fprintf(fid,'%s\n',['KQDZ '   eq  num2str(mean(config.QDZ.Data),  '%18.13f'),';']);
          fprintf(fid,'%s\n',['KQFZ '   eq  num2str(mean(config.QFZ.Data),  '%18.13f'),';']);
  
   elseif strfind(upper(command),upper('Write Grouped Standard Cell Sextupoles'))
          fprintf(fid,'%s\n',['KSF '  eq  num2str(mean(config.SF.Data),  '%18.13f'),';']);
          fprintf(fid,'%s\n',['KSD '  eq  num2str(mean(config.SD.Data),  '%18.13f'),';']);
          
   elseif strfind(upper(command),upper('Write Grouped Match Cell Sextupoles'))
          fprintf(fid,'%s\n',['KSFI '  eq  num2str(mean(config.SFI.Data),  '%18.13f'),';']);
          fprintf(fid,'%s\n',['KSDI '  eq  num2str(mean(config.SDI.Data),  '%18.13f'),';']);
       
   else disp(['Warning: supply values not written: ', command]);

   end


end    %end AT/MAD/DIMAD switchyard
         
   



