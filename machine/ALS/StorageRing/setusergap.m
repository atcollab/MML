function setusergap(Sector, NewPos);
% setusergap(Sector, Position)
%
%           Sector = Sector Number
%         Position = User gap position [mm]
%
% 2005-02-23, C. Steier, modified to allow Sector to be devicelist

if nargin ~= 2
	error('Requires 2 inputs.')
end

if size(Sector,2)==2
    Device = Sector(:,2);
    Sector = Sector(:,1);
else
    Device = zeros(size(Sector));
    for loop = 1:length(Sector)
        if Sector(loop) == 11
            Device(loop,1) = 2;
        else
            Device(loop,1) = 1;
        end
    end
end

if isempty(Sector)
    tmp = getlist('IDpos');
    Sector = tmp(:,1);
    Device = tmp(:,2);
end

if isempty(NewPos)
	error('Input 2 (Position) is empty.')
end



if size(NewPos) == [1 1]
	NewPos = NewPos*ones(size(Sector,1),1);
elseif size(NewPos) == [size(Sector,1) 1]
	% input OK 
else
	error('Size of NewPos must be equal to the Sector or a scalar!');
end	


for i = 1:length(Sector)
   if Sector(i) == 11
      ChanName = sprintf('sr%du%d:bl_input', Sector(i), Device(i));
   elseif Sector(i) == 4 && Device(i) == 2
      ChanName = sprintf('sr%02du%d:bl_input', Sector(i), Device(i));
   else
      ChanName = sprintf('cmm:ID%d_bl_input', Sector(i));
   end
   setsp(ChanName, NewPos(i));
end



