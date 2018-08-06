function bpm4karchive
% function bpm4karchive
% bpm4karchive saves the last second of 4khz data
%  after an orbit interlock trip

% setup labca path
setpathspear3('LabCA');
pause(1);
lcaSetTimeout(0.05);
lcaSetRetryCount(40);
pause(1);
% if not armed read in two bpm data sets
rArm = lcaGet({'116-BPM:postMortem.RARM';'132-BPM:postMortem.RARM'});
fprintf(1,'RARM for 116 = %d; RARM for 132 = %d\n', rArm(1), rArm(2));
if ( (rArm(1) == 0) &&  (rArm(2) == 0) ),
    [bpm116, timeStamp116] = lcaGet('116-BPM:postMortem');
    [bpm132, timeStamp132] = lcaGet('132-BPM:postMortem');
    bpm116 = reshape(bpm116, 4, 56, 4000);
    bpm132 = reshape(bpm132, 4, 56, 4000);
    bpm = [bpm132(:,31:56,:)  bpm116(:,1:end,:) bpm132(:,1:30,:)];

    % BPM(12,4) and BPM(12,5) got swapped (change back 2-11-2004) Greg Portmann commented the next line on March 15, 2004
    %bpm(:,[73 74],:) = bpm(:,[74 73],:);

    % create filename
    dStr = datestr(now);
    ind = find((dStr == '-') | (dStr == ' ') | (dStr == ':'));
    dStr(ind) = '_';

    dirName = 'Q:\Groups\Accel\Controls\matlab\Shifts\sebek\orbitInterlockDumps';
    save( fullfile(dirName, ['bpmDump', dStr]), 'bpm', 'timeStamp116', 'timeStamp132' );
else
    fprintf(1,'bpm buffers were not armed; no event saved\n');
    pause(5);
end % if ( (rArm(1) == 0) &&  (rArm(2) == 0) ),

% if not rearmed, rearm buffers for next cycle
if ( (rArm(1) ~= 4007) ||  (rArm(2) ~= 4007) ),
    fprintf(1,'setting RARM to 4007\n');
    lcaPutNoWait({'116-BPM:postMortem.RARM';'132-BPM:postMortem.RARM'}, [4007; 4007]);
    % insert command to force channel access to complete lcaPutNoWait in
    % previous line
    lcaDelay(0.001);
end % if ( (rArm(1) ~= 4007) ||  (rArm(2) ~= 4007) ),

exit;
return