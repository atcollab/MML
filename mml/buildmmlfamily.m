function Output = buildmmlfamily(Family, DeviceList)

MemberOf = {};

N = size(DeviceList,1);

Output.FamilyName  = Family;
Output.MemberOf    = MemberOf;
Output.Status      = ones(N,1);
Output.DeviceList  = DeviceList;  %[ones(N,1) (1:N)'];
Output.ElementList = (1:N)';


%HWUnits = '';
%PhysicsUnits = '';
%ChannelNames = {};
%Output.Mode             = 'Online';     % 'Online' 'Simulator', 'Manual' or 'Special'
%Output.DataType         = 'Scalar';
%Output.ChannelNames     = ChannelNames;
%Output.HW2PhysicsParams = HW2PhysicsParams;
%Output.Physics2HWParams = Physics2HWParams;
%Output.Units            = 'Hardware';
%Output.HWUnits          = HWUnits;
%Output.PhysicsUnits     = PhysicsUnits;
