function [FFEnableBM, FFEnableBC, GapEnableBM, GapEnableBC, Sector] = getff(Sector)
%GETFF - Get the state of insertion device feed forward and user gap contr5ol 
%  [FFEnableBM, FFEnableBC, GapEnableBM, GapEnableBC, Sector] = getff(Sector)
%
%  See also getid, getusergap, gap2tune, shift2tune

% 2005-02-23, C. Steier, modified to allow Sector to be devicelist


% 'sr07u:FFActiveCnt:ai'
% 'sr08u:FFActiveCnt:ai'  
% 'sr04u2:FFActiveCnt:ai'
% 'sr04u:FFActiveCnt:ai'
% 'sr05w:FFActiveCnt:ai'
% 'sr06u:FFActiveCnt:ai'
% 'sr09u:FFActiveCnt:ai'
% 'sr11u1:FFActiveCnt:ai'
% 'sr11u2:FFActiveCnt:ai'
% 'sr10u:FFActiveCnt:ai'
% 'sr12u:FFActiveCnt:ai'
   


if nargin < 1
    tmp = getlist('ID');
    Sector = tmp(:,1);
    Device = tmp(:,2);
else
    if size(Sector,2)==2
        Device = Sector(:,2);
        Sector = Sector(:,1);
    else
        Device = zeros(size(Sector));
        for loop = 1:length(Sector)
            if Sector(loop) == 11
                Device(loop,1) = 2;
            else
                Device(loop,1) = 1;
            end
        end
    end
end

    
Mode = getmode('HCM');
if strcmpi(Mode,'Simulator')

    FFEnableBM = zeros(size(Sector,1));
    FFEnableBC = zeros(size(Sector,1));
    GapEnableBM = zeros(size(Sector,1));
    GapEnableBC = zeros(size(Sector,1));

else

    if isempty(Sector)
        tmp = getlist('ID');
        Sector = tmp(:,1);
        Device = tmp(:,2);
    end


    for i = 1:length(Sector)       
        if Sector(i) == 5
            IDName = 'w';
        else
            IDName = 'u';
        end

        % EPICs Only Channels
        if (Sector(i) == 11) | (Sector(i) == 7)
            ChanName = sprintf('sr%02d%c%1i:FFEnable:bo', Sector(i), IDName, Device(i));
        else
            ChanName = sprintf('sr%02d%c:FFEnable:bo', Sector(i), IDName);
        end
        FFEnableBC(i,1) = getam(ChanName);

        if Sector(i) == 11 | (Sector(i) == 7)
            ChanName = sprintf('sr%02d%c%1i:FFEnable:bi', Sector(i), IDName, Device(i));
        else
            ChanName = sprintf('sr%02d%c:FFEnable:bi', Sector(i), IDName);
        end
        FFEnableBM(i,1) = getam(ChanName);

        if Sector(i) == 11 | (Sector(i) == 7)
            ChanName = sprintf('sr%02d%c%1i:opr_grant', Sector(i), IDName, Device(i));
        else
            ChanName = sprintf('cmm:ID%d_opr_grant', Sector(i));
        end
        %ChanName = sprintf('sr%02d%c:GapEnable:bo', Sector(i), IDName);
        GapEnableBC(i,1) = getam(ChanName);

        if Sector(i) == 11 | (Sector(i) == 7)
            ChanName = sprintf('sr%02d%c%1i:GapEnable:bi', Sector(i), IDName, Device(i));
        else
            ChanName = sprintf('sr%02d%c:GapEnable:bi', Sector(i), IDName);
        end
        GapEnableBM(i,1) = getam(ChanName);

    end

end
