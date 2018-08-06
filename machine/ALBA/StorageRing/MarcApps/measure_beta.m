%a25_Symplectic;
global THERING;
global refOptic;
quadlist=findmemberof('QUAD');
nfam= size(quadlist,1);
dK=0.001;
noiseBPM=1E-3;
n_steps = 10;
%%
the_index=1;
clear m_beta;
m_beta = ...
    struct('name',{},'magnet', {}, 'index',{}, 'lenght',{}, ...
    'K',{},'s',{}, 'bx',{}, 'by',{}) ;
for i=1:nfam,
    magnetlist=findcells(THERING, 'FamName', cell2mat(quadlist(i)));
    nmag=size(magnetlist,2);
    for j=1:nmag,
        k0=getsp(cell2mat(quadlist(i)),j);
        L=THERING{magnetlist(j)}.Length;
        q=[0 0]';
        q0=q;
        for l=1:n_steps,    
            q0=q0+gettune.*((1-noiseBPM/2)+noiseBPM*rand(2,1)) ;
        end
            setsp (cell2mat(quadlist(i)), k0+dK, j);
        for l=1:n_steps ,   
            q=q+gettune.*((1-noiseBPM/2)+noiseBPM*rand(2,1));
        end    
            setsp (cell2mat(quadlist(i)), k0, j);
        dq=(q-q0)/n_steps;
        b=abs(4*pi*dq/(dK*L));
        m_beta{the_index}.name=cell2mat(quadlist(i));
        m_beta{the_index}.magnet=j;
        m_beta{the_index}.index=magnetlist(j);
        m_beta{the_index}.lenght=L;
        m_beta{the_index}.K=k0;
        m_beta{the_index}.s=refOptic.twiss.s(magnetlist(j));
        m_beta{the_index}.bx=b(1);
        m_beta{the_index}.by=b(2);
        the_index=the_index+1
    end
end
%%
for i=1:size(m_beta,2),
    s(i)=m_beta{i}.s;
    bx(i)=m_beta{i}.bx;
    by(i)=m_beta{i}.by;
end
figure(657)
subplot(2,1,1)
plot(s,bx_ref,'+r')
hold on
plot(refOptic.twiss.s,refOptic.twiss.betax,'m');
plot(s, bx_er, '*y')
plot(s, bx, 'sg')
legend('Measured','Theoretical','Error BPM','Averaged BPM');
subplot(2,1,2)
plot(s,by_ref,'+b')
hold on
plot(refOptic.twiss.s,refOptic.twiss.betay,'c');
plot(s, by_er, '*y')
plot(s, bx, 'sg')
legend('Measured','Theoretical','Error BPM','Averaged BPM');
hold off
    