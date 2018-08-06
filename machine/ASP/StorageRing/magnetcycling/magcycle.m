function out = magcycle(varargin)
%
% MAGCYCLE - FUNCTION WITH NO MORE THEN 3 ARGUMENTS
%
% magcycle is a function that cycles magnets in the Storage Ring(SR), Booster to Storage(BTS) and
% Linac to Booster(LTB)
%
% 1) ARGUMENTS -magcycle takes between 1 and 3 arguments, chosen from ltb,
% LTB, BTS, bts, SR and sr. It does not matter which order the inputs are entered provided they are
% all in either upper or lower case, each is in 'single quotations' and each argument is
% separated by a comma. For example, magcycle('bts','sr') will cycle the
% bts then the storage ring.
%
% 2) ERRORS - The errors will be due to either inputing a system that
% doesn't exist or from inputing the same system more then once.
%
% 3) LTB - Currently (19/01/2007) it is not possible to cycle the LTB above 89A. If this does happen then
% the one of the dipoles, normally PS-B-A-1-2 oscillates for ~5min then
% shuts itself off. If this does occur and 89A hasn't been exceeded then
% turn back on and lower ltbba12max for that particular dipole.
%
%

v1 = varargin{1};

if nargin == 1
    v1 = varargin{1};

    switch lower(v1)

        case {'sr', 'SR'}
            simplecyclesr;
%         case {'ltb', 'LTB'}
%             simplecycleltb;
%         case {'bts', 'BTS'}
%             simplecyclebts;
        otherwise
            error('Magnets not found.');
    end

end

if nargin == 2
    v2 = varargin{2};

    switch lower(v1)

        case {'sr', 'SR'}
            simplecyclesr;
%             switch lower(v2)
%                 case {'ltb', 'LTB'}
%                     simplecycleltb;
%                 case {'bts', 'BTS'}
%                     simplecyclebts;
                otherwise
                    error('Magnets not found.');
            end;

%         case {'ltb', 'LTB'}
%             simplecycleltb;
%             switch lower(v2)
%                 case {'sr','SR'}
%                     simplecyclesr;
%                 case {'bts', 'BTS'}
%                     simplecyclebts;
%                 otherwise
%                     error('Magnets not found.');
%             end;

%         case {'bts', 'BTS'}
%             simplecyclebts;
%             switch lower(v2)
%                 case {'sr', 'SR'}
%                     simplecyclesr;
%                 case {'ltb', 'LTB'}
%                     simplecycleltb;
%                 otherwise
%                     error('Magnets not found.');
%             end;
    end;
end;

if nargin == 3
    v2 = varargin{2};
    v3 = varargin{3};

    switch lower(v1)

        case {'sr', 'SR'}
            simplecyclesr;
%             switch lower(v2)
%                 case {'ltb', 'LTB'}
%                     simplecycleltb;
%                     switch lower(v3)
%                         case {'bts','BTS'}
%                             simplecyclebts;
%                         otherwise
%                             error('Magnets not found.');
%                     end
%                 case {'bts', 'BTS'}
%                     simplecyclebts;
%                     switch lower(v3)
%                         case {'ltb','LTB'}
%                             simplecycleltb;
%                         otherwise
%                             error('Magnets not found.');
%                     end
%                 otherwise
%                     error('Magnets not found');
%             end;

%         case {'ltb', 'LTB'}
%             simplecycleltb;
%             switch lower(v2)
%                 case {'sr', 'SR'}
%                     simplecyclesr;
%                     switch lower(v3)
%                         case {'bts','BTS'}
%                             simplecyclebts;
%                         otherwise
%                             error('Magnets not found.');
%                     end
%                 case {'bts', 'BTS'}
%                     simplecyclebts;
%                     switch lower(v3)
%                         case {'sr','SR'}
%                             simplecycle;
%                         otherwise
%                             error('Magnets not found.');
%                     end;
%                 otherwise
%                     error('Magnets not found');
%             end;
% 
%         case {'bts', 'BTS'}
%             simplecyclebts;
%             switch lower(v2)
%                 case {'sr', 'SR'}
%                     simplecyclesr;
%                     switch lower(v3)
%                         case {'ltb','LTB'}
%                             simplecycleltb;
%                         otherwise
%                             error('Magnets not found');
%                     end;
%                 case {'ltb', 'LTB'}
%                     simplecycleltb;
%                     switch lower(v3)
%                         case {'sr','SR'}
%                             simplecycle;
%                         otherwise
%                             error('Magnets not found.');
%                     end;
%                 otherwise
%                     error('Magnets not found.');
%             end;
    end;
end;

if nargin > 3
    error('Too many variables');
end;