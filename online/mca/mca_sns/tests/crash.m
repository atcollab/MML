% With an R4.14.8.2 softIoc running demo.db,
% this would sometimes crash the IOC
% in camessage.c write_notify_reply(),
% final epicsEventSignal ( pClient->blockSem ):
p1 = mcaopen('set1');
p2 = mcaopen('set2');
%mcainfo(p1)
%mcainfo(p2)
r1=mcaput(p1, 42);
r2=mcaput(p2, 43);
mcaclose(p2);
mcaclose(p1);
r1
r2