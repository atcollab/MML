function setlabcadefaults(RetryCountNew, TimeoutNew)


% Change defaults for LabCA if using it
try
    if exist('lcaSetSeverityWarnLevel','file')
        % read dummy pv to initialize labca
        % ChannelName = family2channel('BPMx');
        % lcaGet(family2channel(ChannelName(1,:));
        
        % Retry count
        if nargin < 1 || isempty(RetryCountNew)
            if ispc
                RetryCountNew = 40;  % 60 had trouble in the past, 599-old labca, 149-labca_2_1_beta
            else
                RetryCountNew = 20;  % 599-old labca, 149-labca_2_1_beta
            end
        end
        RetryCount = lcaGetRetryCount;
        lcaSetRetryCount(RetryCountNew);
        if RetryCount ~= RetryCountNew
            fprintf('   Setting LabCA retry count to %d (was %d) (LabCA)\n', RetryCountNew, RetryCount);
        end
        
        % Timeout
        if nargin < 2 || isempty(TimeoutNew)
            TimeoutNew = .5;  %changed from 0.1s on 4-18-13 to try to avoid lca timeouts - T.Scarvie % Old defaults: .05 very old labca, .1-labca_2_1_beta
        end
        Timeout = lcaGetTimeout;
        lcaSetTimeout(TimeoutNew);
        if abs(Timeout - TimeoutNew) > 1e-5
            fprintf('   Setting LabCA TimeOut to %f (was %f) (LabCA)\n', TimeoutNew, Timeout);
        end
        %fprintf('   LabCA TimeOut = %f\n', Timeout);

        
        % Two calls are needed to for the SeverityWarnLevel (one less than 10, one greater)
        %  3 - Errors on UDF {Default}
        %  4 - Warning for the INVALID UDF (undefined) is turned off
        % 13 - NaN returned if INVALID UDF
        % 14 - A value is still returned on INVALID UDF
        lcaSetSeverityWarnLevel( 4);
        lcaSetSeverityWarnLevel(14);
        fprintf('   Set SeverityWarnLevel to 4 & 14 to avoid annoying UDF warnings/errors (LabCA).\n');
    end
catch
    fprintf('   Error setting LabCA defaults (setlabcadefaults)\n');
    %fprintf('   LabCA Timeout not set, need to run lcaSetRetryCount(20), lcaSetTimeout(.1).\n');
end

