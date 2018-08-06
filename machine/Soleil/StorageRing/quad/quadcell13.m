function quadcell13(command)

%%
dev=family2tangodev('QC13');
for k = 1:10, 
    rep = tango_command_inout2(dev{k},command); 
    switch command
        case {'Status', 'State'}
            if ischar(rep)
                fprintf('Device: %s, State: %s \n',dev{k},rep);
            end
        otherwise
            % does nothing
    end
end;