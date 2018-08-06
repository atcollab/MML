function soundquestion
%SOUNDQUESTION - Makes a "question" sound
%
%  See also soundchord, soundtada, sounderror


File = 'UtopiaQuestion.wav';

VersionStr = version;
if strcmp(VersionStr(1),'4')
    % No sound
    return
elseif exist('wavread','file') == 2
    [y, fs, bits] = wavread(File);
    %sound(y, fs, bits);
    sound(y, fs);
    %sound(y(1:2:end));
elseif exist('audioread','file') == 2
    [y, fs] = audioread(File);
    sound(y, fs);
end

%sound(y, fs, bits);
%sound(y(1:2:end));

