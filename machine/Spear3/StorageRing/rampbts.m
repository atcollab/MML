function ramp(PERCENTSTEPVECTOR)
% RAMP BTS configuration
% RAMPBTS(PERCENTSTEPVECTOR)
%  examples: 
%  1. rampbts(0.1:0.1:2);     - ramp to +2% in steps of .1%
%  2. rampbts((-0.1:-0.1:-2); - ramp down
try
    savebts
catch
end
B7H = mcacheckopen('BTS-B7H:CurrSetpt');

B8V = mcacheckopen('BTS-B8V:CurrSetpt');

C8H = mcacheckopen('BTS-C8H:CurrSetpt');

B9V = mcacheckopen('BTS-B9V:CurrSetpt');

Q8 = mcacheckopen('BTS-Q8:CurrSetpt');

Q9 = mcacheckopen('BTS-Q9:CurrSetpt');

handles = [B7H B8V C8H B9V Q8 Q9];

values0 = mcaget(handles);

for i = PERCENTSTEPVECTOR
    values = values0*(1+i*.01);
    mcaput(handles, values);
    fprintf('   Step to %f %% complete\n', i);
    fprintf('   Hit return to continue (Ctrl-C to stop)\n\n');
    pause

end
