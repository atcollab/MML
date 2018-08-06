initialisations = 'global THERING; dipind = findcells(THERING,''FamName'',''BEND'');';

varget = {'getcellstruct(THERING,''EntranceAngle'',dipind)';...
          'getcellstruct(THERING,''PolynomB'',dipind,2)'};
      
varset = {'THERING = setcellstruct(THERING,''EntranceAngle'',dipind,variable); THERING = setcellstruct(THERING,''ExitAngle'',dipind,variable);';...
          'THERING = setcellstruct(THERING,''PolynomB'',dipind,variable,2);'};  
      
paramget = {'modelxtune';...
            'modelytune'};
        
goalparam = [13.29 5.216];

linearfit(varget,varset,paramget,goalparam,initialisations);