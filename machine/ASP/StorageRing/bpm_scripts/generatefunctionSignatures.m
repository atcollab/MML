fid = fopen('functionSignatures.json','w');

fprintf(fid,'{\n');     % open object

fprintf(fid,'"srbpm.getfield":\n');
fprintf(fid,'{\n');
fprintf(fid,'    "inputs":\n');
fprintf(fid,'    [\n');
fprintf(fid,'        {"name":"field", "kind":"required", "type":"choices={\n');

pvfid = fopen('tlibera_brilliance_bpm_form_20180720_155855.txt','r');
C = textscan(pvfid,'%s%s\n','CommentStyle','#','Whitespace',' \b\t:');
fclose(pvfid);
fprintf(fid,'''%s'',\n',string(C{2}));

addpvs = [
    "EVRX_PLL_LOCKED_STATUS"
    "EVRX_PLL_MAX_ERR_MONITOR"
    "EVRX_PLL_OS_UNLOCK_TIME_MONITOR"
    "SYNC_ST_M_STATUS"
    "GDX_SYNC_STATUS"
    "EVRX_RTC_MC_IN_MASK_MONITOR"
    "EVRX_RTC_MC_IN_FUNCTION_MONITOR"
    "EVRX_TRIGGERS_MC_SOURCE_STATUS"
    "EVRX_EVENTS_MC_COUNT_MONITOR"
    "EVRX_RTC_T0_IN_MASK_MONITOR"
    "EVRX_RTC_T0_IN_FUNCTION_MONITOR"
    "EVRX_TRIGGERS_T0_SOURCE_STATUS"
    "EVRX_EVENTS_T0_COUNT_MONITOR"
    "EVRX_RTC_T1_IN_MASK_MONITOR"
    "EVRX_RTC_T1_IN_FUNCTION_MONITOR"
    "EVRX_TRIGGERS_T1_SOURCE_STATUS"
    "EVRX_EVENTS_T1_COUNT_MONITOR"
    "EVRX_RTC_T2_IN_MASK_MONITOR"
    "EVRX_RTC_T2_IN_FUNCTION_MONITOR"
    "EVRX_TRIGGERS_T2_SOURCE_STATUS"
    "EVRX_EVENTS_T2_COUNT_MONITOR"
    ];
fprintf(fid,'''%s'',\n',addpvs);

fprintf(fid,'}"}\n');
fprintf(fid,'    ]\n');
fprintf(fid,'}\n');

fprintf(fid,',\n');

fprintf(fid,'"srbpm.setfield":\n');
fprintf(fid,'{\n');
fprintf(fid,'    "inputs":\n');
fprintf(fid,'    [\n');
fprintf(fid,'        {"name":"field", "kind":"required", "type":"choices={\n');

% Same as before but remove all monitors and status PVs as these cannot be
% set
fprintf(fid,'''%s'',\n',string(  C{2}( ~contains(C{2},'MONITOR') & ~contains(C{2},'STATUS') )  ));
fprintf(fid,'''%s'',\n',addpvs( ~contains(addpvs,'MONITOR') & ~contains(addpvs,'STATUS') ));

fprintf(fid,'}"}\n');
fprintf(fid,'    ]\n');
fprintf(fid,'}\n');



fprintf(fid,'}\n');   % Close object

fclose(fid);