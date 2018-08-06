function varargout = concatenaterings(NRings)

global THERING


% Number of ALS's to concatenate
if nargin < 1
    NRings = input('   How many rings to concatenate? ');
end


[CavityState, PassMethod, ATCavityIndex, RF, HarmonicNumber] = getcavity(THERING);

if ~isempty(ATCavityIndex)
    for i = 1:length(ATCavityIndex)
        THERING{ATCavityIndex(i)}.HarmNumber = NRings * THERING{ATCavityIndex(i)}.HarmNumber;
    end
end


THERING1 = THERING;
for i = 1:NRings-1
    THERING = [THERING THERING1];
end


L = getfamilydata('Circumference');
if ~isempty(L)
    setfamilydata(NRings * L, 'Circumference');
end
