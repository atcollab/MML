function ticklecorroff( corrName, setPt )
% function ticklecorroff( corrName, setPt )
% ticklecorroff turns off the corrector tickle and restores it
%  to a static current
%
% corrName  corrector name
% setPt     dc current value

% halt tickle
lcaPut( [corrName, ':ControlState'], 0 );
lcaPut( {[corrName, ':CurrSetpt'];[corrName, ':ControlState']}, ...
    [setPt(1); 3] );
