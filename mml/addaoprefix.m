function addAOprefix(prefix)
%ADDAOPREFIX - Add a prefix to all AcceleratorObjects PV names

AO = getao;

t=findstr(prefix,':');                        %make sure prefix has ':'
if ~isempty(t) prefix=prefix(1:t-1); end
prefix=[prefix ':'];

AOfields=fieldnames(AO);
for ii=1:size(AOfields,1)
     if isfield(AO.(AOfields{ii}),'Monitor')
         if isfield(AO.(AOfields{ii}).Monitor,'SpecialFunction')
            AO.(AOfields{ii}).Monitor.Mode ='Special';
        else
            AO.(AOfields{ii}).Monitor.Mode ='ONLINE';
            if isfield(AO.(AOfields{ii}).Monitor,'ChannelNames')
               nchannel=size(AO.(AOfields{ii}).Monitor.ChannelNames,1);
               pfx=prefix;
               for jj=1:nchannel-1 pfx=[pfx; prefix]; end
               AO.(AOfields{ii}).Monitor.ChannelNames=[pfx AO.(AOfields{ii}).Monitor.ChannelNames];
            end
        end
     end
     if isfield(AO.(AOfields{ii}),'Setpoint')
        if isfield(AO.(AOfields{ii}).Setpoint,'SpecialFunction')
            AO.(AOfields{ii}).Setpoint.Mode ='Special';
        else
            AO.(AOfields{ii}).Setpoint.Mode ='ONLINE';
            if isfield(AO.(AOfields{ii}).Setpoint,'ChannelNames')
               nchannel=size(AO.(AOfields{ii}).Setpoint.ChannelNames,1);
               pfx=prefix;
               for jj=1:nchannel-1 pfx=[pfx; prefix]; end
               AO.(AOfields{ii}).Setpoint.ChannelNames=[pfx AO.(AOfields{ii}).Setpoint.ChannelNames];
            end
        end
    end
end

setao(AO);

disp(' ');
disp([   '==> finished adding PV prefix     ' prefix '       to Middle Layer Families']);
disp(' ')