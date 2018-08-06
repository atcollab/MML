k=1;
for i= 1:14
    for j=1:2
        stepsp('SFA',5,[i j]);
        pause(10);
        a='import -silent -window ''ASP, Plot Family Data (Online)'' /asp/usr/screenshots/2007-03-02/sext_shunt/SFA';
        num=num2str(k);
        up='.gif';
        string = strcat(a,num,up);
        k=k+1;
        system(string);
        stepsp('SFA',-10,[i j]);
        pause(10);
        num=num2str(k);
        up='.gif';
        string = strcat(a,num,up);
        fprintf('%d ',k);
        k=k+1;
        system(string);
        stepsp('SFA',5,[i j]);
        pause(10);

    end
end
fprintf('SFA''s Done.\n ');

k=1;
for i= 1:14
    stepsp('SFB',5,[i 1]);
    pause(10);
    a='import -silent -window ''ASP, Plot Family Data (Online)'' /asp/usr/screenshots/2007-03-02/sext_shunt/SFB';
    num=num2str(k);
    up='.gif';
    string = strcat(a,num,up);
    k=k+1;
    system(string);
    stepsp('SFB',-10,[i 1]);
    pause(10);
    num=num2str(k);
    up='.gif';
    string = strcat(a,num,up);
    fprintf('%d ',k);
    k=k+1;
    system(string);
    stepsp('SFB',5,[i 1]);
    pause(10);
end
fprintf('SFB''s Done.\n ');

k=1;
for i= 1:14
    for j=1:2
        stepsp('SDA',5,[i j]);
        pause(10);
        a='import -silent -window ''ASP, Plot Family Data (Online)'' /asp/usr/screenshots/2007-03-02/sext_shunt/SDA';
        num=num2str(k);
        up='.gif';
        string = strcat(a,num,up);
        k=k+1;
        system(string);
        stepsp('SDA',-10,[i j]);
        pause(10);
        num=num2str(k);
        up='.gif';
        string = strcat(a,num,up);
        fprintf('%d ',k);
        k=k+1;
        system(string);
        stepsp('SDA',5,[i j]);
        pause(10);

    end
end
fprintf('SDA''s Done.\n ');


k=1;
for i= 1:14
    for j=1:2
        stepsp('SDB',5,[i j]);
        pause(10);
        a='import -silent -window ''ASP, Plot Family Data (Online)'' /asp/usr/screenshots/2007-03-02/sext_shunt/SDB';
        num=num2str(k);
        up='.gif';
        string = strcat(a,num,up);
        k=k+1;
        system(string);
        stepsp('SDB',-10,[i j]);
        pause(10);
        num=num2str(k);
        up='.gif';
        string = strcat(a,num,up);
        fprintf('%d ',k);
        k=k+1;
        system(string);
        stepsp('SDB',5,[i j]);
        pause(10);

    end
end
fprintf('SDB''s Done.\n ');