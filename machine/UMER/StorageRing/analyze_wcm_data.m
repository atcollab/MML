% analyze_wcm_data.m
function current_per_turn = analyze_wcm_data(scope_data)

scope_mV = scope_data(:,2);

time_div = 2; % ns/pt
trise = 115; % ns
window = 60; % ns

turn_bg = floor((trise-15-window)/time_div):floor((trise-15)/time_div);
turn = ceil((trise+50-window/2)/time_div):ceil((trise+50+window/2)/time_div);
turn_time = floor(197/time_div);

%%
nturns = 10;
%hold off; plot(scope_mV)
current_per_turn = zeros(nturns,1);
for i=1:nturns
    %hold on
    %plot(turn_bg+(i-1)*turn_time,scope_mV(turn_bg+(i-1)*turn_time),'r')
    %plot(turn+(i-1)*turn_time,scope_mV(turn+(i-1)*turn_time),'g')
    
    current_in_turn = mean(scope_mV(turn+(i-1)*turn_time))-mean(scope_mV(turn_bg+(i-1)*turn_time));
    current_per_turn(i) = current_in_turn;
end
end
