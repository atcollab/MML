function id_startup_test

IDlist = getlist('ID');
% IDlist=[7 1
%     8 1
%     9 1
%     10 1
%     11 1
%     11 2
%     12 1];
EPUZlist = [4 1;4 2;6 2;11 1;11 2];

for IDnum = 1:size(IDlist,1)
    try
        if (IDlist(IDnum,1)==6 && IDlist(IDnum,2)==1)
            setid(IDlist(IDnum,:), 37);
            setid(IDlist(IDnum,:), 38);
            %disp('  Not changing ID6 - it is locked out.');
        elseif IDlist(IDnum)==4 || (IDlist(IDnum,1)==6 && IDlist(IDnum,2)==2) || IDlist(IDnum)==11
            setid(IDlist(IDnum,:), 100);
            setid(IDlist(IDnum,:), 101);
            setepu(IDlist(IDnum,:), 5);
            setepu(IDlist(IDnum,:), -5);
            setepu(IDlist(IDnum,:), 0);
        else
            setid(IDlist(IDnum,:), 100);
            setid(IDlist(IDnum,:), 101);
        end
        fprintf('ID [%s] is working.\n', num2str(IDlist(IDnum,:)));
    catch
        try
            if (IDlist(IDnum,1)==6 && IDlist(IDnum,2)==1)
                setid(IDlist(IDnum,:), 38);
                %disp('  Not changing ID6 - it is locked out.');
            elseif IDlist(IDnum)==4 || (IDlist(IDnum,1)==6 && IDlist(IDnum,2)==2) || IDlist(IDnum)==11
                setid(IDlist(IDnum,:), 101);
                setepu(IDlist(IDnum,:), 0);
            else
                setid(IDlist(IDnum,:), 101);
            end
        catch
            fprintf('ID [%s] is not moving!\n', num2str(IDlist(IDnum,:)));
        end
    end
end
