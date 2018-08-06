function moveFOFBlogs

% This routine watches for the Fast Orbit Feedback system to go off.
% If the turnoff is due to a trip, new log files will be written.
% This script waits for the log files to be written, then moves the
% log files into a different, date&time stamped directory for
% preservation and later FOFB troubleshooting

% Change to fast orbit feedback directory
cd /home/physdata/matlab/srdata/orbitfeedback_fast/log

while 1
    FOFBOnStatus = [getam('SR01____FFBON__BM00') getam('SR02____FFBON__BM00') getam('SR03____FFBON__BM00')...
        getam('SR04____FFBON__BM00') getam('SR05____FFBON__BM00') getam('SR06____FFBON__BM00')...
        getam('SR07____FFBON__BM00') getam('SR08____FFBON__BM00') getam('SR09____FFBON__BM00')...
        getam('SR10____FFBON__BM00') getam('SR11____FFBON__BM00') getam('SR12____FFBON__BM00')];

    if any(FOFBOnStatus==0)
        
        pause(5); % make sure that new log file has been created
        
        D = dir('SR01bpm.log');
       
        if ~strncmp(D.date,datestr(now),17)
            pause(120) % wait for logs files to be written
            
            % Get time and date
            tmp = clock;
            year   = tmp(1);
            month  = tmp(2);
            day    = tmp(3);
            hour   = tmp(4);
            minute = tmp(5);
            seconds= tmp(6);

            % Create date and time stamped directory
            Directory = sprintf('trip_%d-%02d-%02d_%02d:%02d:%.0f', year, month, day, hour, minute, seconds);
            mkdir(sprintf('%s', Directory));
            copyfile('./*.log', Directory);
        end
    end
end


