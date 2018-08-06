function UserGap = getusergap(varargin)
%GETUSERGAP - Returns the insertion device user requested gap
%
%  UserGap = getusergap(Sector)
%
%  See also getid, getff, gap2tune, shift2tune

UserGap = getpv('ID', 'UserGap', varargin{:});

