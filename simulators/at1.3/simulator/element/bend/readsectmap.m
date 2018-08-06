function sectmap = readsectmap(mapfile)
%read the output of "sectormap" command of MAD to obtain 
%the sector map (6D)
%across each element or range, there is a R (6x6) matrix or the usual transfer
%matrix and a T (6x36) matrix, which is the second order TRANSPORT matrix. 
%If we rearrange each row of T to a 6x6 matrix, e.g.
%>> a = reshape(map.Tmat(5,:), 6,6)
%it is a symmetric matrix
%Note:
%the variables in MAD are in the order (x, x', y, y', c dt, delta)
%

try
	fid = fopen(mapfile,'r');
catch
	disp('file cannot be opened')
	return;
end

fgetl(fid);
fgetl(fid);

cnt = 0;
while ~feof(fid)
	sline = fgetl(fid);
	if length(sline) < 5
		break
	end
	s = sscanf(sline,'%f',1);
	name = sline(25:end);
	fgetl(fid); %skip the kick vector line
	for ii=1:6
		sline = fgetl(fid);
		tmp = sscanf(sline,'%f',6);
		a(ii,:) = tmp';
	end
% 	for ii=1:6 %T(:,ii,:)
%         for jj=1:6 %T(:,ii,jj)
%             sline = fgetl(fid);
%             tmp = sscanf(sline,'%f',6);
%             Tijk(:,ii,jj) = tmp';
%         end
% 	end
    for ii=1:36
        sline = fgetl(fid);
        tmp = sscanf(sline,'%f',6);
        Tmat(ii,:) = tmp;
    end
	cnt = cnt + 1;
	node.s = s;
	node.name = name;
	node.map = a';
    node.Tmat = Tmat';
	
	sectmap(cnt) = node;
end
fclose(fid);

