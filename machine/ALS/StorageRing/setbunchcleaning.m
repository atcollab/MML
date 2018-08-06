function setbunchcleaning(InputCommand)
%SETBUNCHCLEANING - Set the bunch cleaning system On or Off
% 

%  To turn on:  setbunchcleaning('On')
%  Sends:       ALS_BUNCHCLEAN0 1 1
%  Returns:     Command#11 Delay:20 CommandType:1 Val:1
% 
%  To turn on:  setbunchcleaning('Off')
%  Sends:       ALS_BUNCHCLEAN0 1 0
%  Returns:     Command#11 Delay:20 CommandType:1 Val:0
%

%  Written by Greg Portmann


if nargin < 1
    InputCommand = 'On';
end


if strcmpi(InputCommand, 'On')
    % Turn on (if it's not already on)
    if ~getpv('bcleanEnable')
        setpv('bcleanEnable', 1);
        fprintf('   Bunch cleaning turn on\n');
        
        % Turn off
        pause(1.0);
        setpv('bcleanEnable', 0);
        fprintf('   Bunch cleaning turn off\n');
    end  
else
    % Turn off
    setpv('bcleanEnable', 0);
    fprintf('   Bunch cleaning turn off\n');
end


%function [Out, con, tcp] = setbunchcleaning(InputCommand)
% 
% if nargin < 1
%     InputCommand = 'On';
% end
% 
% % On TCP/IP based code
% 
% %persistent con
% %persistent tcp
% 
% %  Access 131.243.71.141 at port 80
% %  was '131.243.71.141' on port 7
% %hostname = '131.243.71.141';
% hostname = '131.243.93.160';
% port = 7;
% 
% %if isempty(con)
% %tic
% con = pnet('tcpconnect', hostname, port);
% if con < 0
%     error('tcpconnect failed');
% end
% 
% tcp = pnet('tcpsocket', port);
% if tcp < 0
%     pnet(con, 'close');
%     error('tcpsocket failed');
% end
% %toc
% %end
% 
% %stat = pnet(con,'status')
% 
% if strcmpi(InputCommand, 'On')
%     % Turn on
%     %tic
%     pnet(con, 'write', 'ALS_BUNCHCLEAN0 1 1');
%     %toc
%     pause(.4);
%     Out = pnet(con, 'read');  % Should return 'Command#11 Delay:20 CommandType:1 Val:1'
%     fprintf('   Bunch cleaning turn on  (%s)\n', Out(1:end-2));   % 2 extra linefeeds
%     
%     % Turn off
%     pause(.3);
%     pnet(con, 'write', 'ALS_BUNCHCLEAN0 1 0');
%     pause(.4);
%     Out = pnet(con, 'read');  % Should return 'Command#11 Delay:20 CommandType:1 Val:0'
%     fprintf('   Bunch cleaning turn off (%s)\n', Out(1:end-2));    % 2 extra linefeeds
%     
% else
%     % Turn off
%     pnet(con, 'write', 'ALS_BUNCHCLEAN0 1 0');
%     pause(.5);
%     Out = pnet(con, 'read');  % Should return 'Command#11 Delay:20 CommandType:1 Val:0'
%     
%     fprintf('   Bunch cleaning turn off\n');
% end
% 
% pnet(tcp, 'close');
% pnet(con, 'close');



%     for i = 1:20
%         Out = pnet(con, 'read');  % Should return 'Command#11 Delay:20 CommandType:1 Val:1'
%         if ~isempty(Out)
%             Out
%             toc
%         end
%         pause(.1);
%     end



%con = pnet(tcp, 'tcplisten')

%tcplisten = pnet(tcp, 'tcplisten')

%pnet_putvar(con, '5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 2750000 2 4000 1 1 0 0 0')
%pnet_putvar(con, 'Command 2 2750000 2 4000 1 1 0 0')

% data = pnet(con,'read' [,size] [,datatype] [,swapping] [,'view'] [,'noblock'])
%data = pnet(con, 'read')
%data = pnet_getvar(con)


% 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5
%  2750000 2 4000 1 1 0 0 0
% 
% Command 2 2750000 2 4000 1 1 0 0




% tcp_bunchcleaning_demo
% con =
%      2
% tcp =
%      3
% stat =
%     11
% data =
% Command 14 2750000 2 4000 1 1 0 0
% 
% 
% tcp_bunchcleaning_demo
% con =
%      2
% tcp =
%      3
% stat =
%     11
% data =
% Command 15 2750000 2 4000 1 1 0 0

