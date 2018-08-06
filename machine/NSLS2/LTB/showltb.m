

Family = 'BEND';
SP = getpv(Family);
Name = family2channel(Family);
for i = 1:length(SP)
    fprintf('   %s   %f\n', Name(i,:), SP(i));
end
fprintf('\n');

Family = 'Q';
SP = getpv(Family);
Name = family2channel(Family);
for i = 1:length(SP)
    fprintf('   %s   %f\n', Name(i,:), SP(i));
end
fprintf('\n');

Family = 'HCM';
SP = getpv(Family);
Name = family2channel(Family);
for i = 1:length(SP)
    fprintf('   %s   %f\n', Name(i,:), SP(i));
end
fprintf('\n');

Family = 'VCM';
SP = getpv(Family);
Name = family2channel(Family);
for i = 1:length(SP)
    fprintf('   %s   %f\n', Name(i,:), SP(i));
end
fprintf('\n');
