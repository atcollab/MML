function clsLoadQuadCenterData
% ----------------------------------------------------------------------------------------------
% $Header: MatlabApplications/acceleratorcontrol/cls/clsLoadQcenterData.m 1.2 2007/06/29 04:34:35CST Tasha Summers (summert) Exp  $
% ----------------------------------------------------------------------------------------------
% get all of the quadcenter filenames
% upadated to automatically read QMS data from directory with 'USE'
% appended to front - TS Feb 2007
% ----------------------------------------------------------------------------------------------


StartDir = pwd;

try
    AD = getad;
    DirectoryName = AD.Directory.DataRoot;
    cd (DirectoryName);
    cd QMS;
    qmsdir=ls;
    numqmsdir=size(qmsdir);
    count=1;
    flag=0;
    for nn=1:numqmsdir(1)
        testqmsdir=qmsdir(nn,:);
        if testqmsdir(1:3)=='USE'
            DirName=testqmsdir;
            flag=1;
        end
        count=count+1;
    end
    if flag == 1
        cd(DirName);
        FileNames=ls;
    else
        fprintf('Cannot load QMS data. Make sure that the QMS directory \n');
        fprintf('you want to load has "USE" at the start of the name. \n');
        fprintf('Then, click "Load Quad Centers" button on SRmaster. \n');
        return;
    end
    S=load(FileNames(6,:));
    if(~isfield(S,'QMS'))
        fprintf('Directory does not contain Quad center data \n');
        return;
    end
    ao = getao;
    Xindex = 1;
    Yindex = 1;
    QnamesX = {};
    QnamesY = {};
    S=[];
    for i = 1:12
        QnamesX{Xindex}.qname = sprintf('s%dQFA1h1*.mat', i);Xindex = Xindex + 1;
        QnamesY{Yindex}.qname = sprintf('s%dQFA1v1*.mat', i);Yindex = Yindex + 1;
        QnamesX{Xindex}.qname = sprintf('s%dQFC1h1*.mat', i);Xindex = Xindex + 1;
        QnamesY{Yindex}.qname = sprintf('s%dQFC1v1*.mat', i);Yindex = Yindex + 1;
        QnamesX{Xindex}.qname = sprintf('s%dQFC2h1*.mat', i);Xindex = Xindex + 1;
        QnamesY{Yindex}.qname = sprintf('s%dQFC2v1*.mat', i);Yindex = Yindex + 1;
        QnamesX{Xindex}.qname = sprintf('s%dQFA2h1*.mat', i);Xindex = Xindex + 1;
        QnamesY{Yindex}.qname = sprintf('s%dQFA2v1*.mat', i);Yindex = Yindex + 1;
    end
    for i=1:48
        f=dir(QnamesX{i}.qname);
        S=load(f.name);
        ao.BPMx.Offset(i) = S.QMS.Center;
    end
    for i=1:48
        f=dir(QnamesY{i}.qname);
        S=load(f.name);
        ao.BPMy.Offset(i) = S.QMS.Center;
    end
    setao(ao);
    curdir = pwd;
    fprintf('   Quad centers loaded into the AO\n');
    ChangeDir = AD.Directory.AccCont;
    cd(ChangeDir);
catch
    fprintf('   There was an error loading the quadrupole centers (BPM offsets)!!!!!!\n');
    cd(StartDir);
end


% ----------------------------------------------------------------------------------------------
% $Log: MatlabApplications/acceleratorcontrol/cls/clsLoadQcenterData.m  $
% Revision 1.2 2007/06/29 04:34:35CST Tasha Summers (summert)
%
% Revision 1.6 2007/04/24 13:54:56CST summert
%
% Revision 1.5 2007/03/02 09:03:00CST matiase
% Added header/log
% ----------------------------------------------------------------------------------------------
