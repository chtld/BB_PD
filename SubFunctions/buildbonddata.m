
function [BONDSTIFFNESS,BONDTYPE,BFMULTIPLIER]=buildbonddata(BONDLIST,nFAMILYMEMBERS,MATERIALFLAG)

% Build bond data - determine the bond type and stiffness connecting node
% pairs (e.g. is it a concrete or steel bond?)

%% Constants
datamaterialproperties
datageometry
dataPDparameters
nBONDS=size(BONDLIST,1);

%% Main body of build bond data

BONDSTIFFNESS=zeros(nBONDS,1);  % Initialise bond stiffness vector
BONDTYPE=zeros(nBONDS,1);       % Initialise bond type vector
BFMULTIPLIER=zeros(nBONDS,1);   % Initialise bond force multiplier vector


for kBond=1:nBONDS
        
    nodei=BONDLIST(kBond,1);
    nodej=BONDLIST(kBond,2);
        
 
    % Concrete to concrete - if materialflag i=0 and j=0 then bond is concrete
    if MATERIALFLAG(nodei,1)==0 && MATERIALFLAG(nodej,1)==0
        bondStiffnessTemp=C_CONCRETE;
        BONDTYPE(kBond)=0;
    % Concrete to steel - if materialflag i=0 and j=1 then bond is concrete   
    elseif MATERIALFLAG(nodei,1)==0 && MATERIALFLAG(nodej,1)==1
        bondStiffnessTemp=C_CONCRETE;
        BONDTYPE(kBond)=1;
    % Steel to concrete - if materialflag i=1 and j=0 then bond is concrete  
    elseif MATERIALFLAG(nodei,1)==1 && MATERIALFLAG(nodej,1)==0
        bondStiffnessTemp=C_CONCRETE;
        BONDTYPE(kBond)=1;
    % Steel to steel - if materialflag i=1 and j=1 then bond is steel
    elseif MATERIALFLAG(nodei,1)==1 && MATERIALFLAG(nodej,1)==1
        bondStiffnessTemp=C_STEEL;
        BONDTYPE(kBond)=2;
    end


    % Calculate stiffening factor - surface corrections for 3D problem
    nodeiNeighbourhoodVolume=nFAMILYMEMBERS(nodei)*VOLUME;                                              % Neighbourhood area for Node 'i'
    nodejNeighbourhoodVolume=nFAMILYMEMBERS(nodej)*VOLUME;                                              % Neighbourhood area for Node 'j'
    stiffeningFactor=(2*NEIGHBOURHOODVOLUME)/(nodeiNeighbourhoodVolume+nodejNeighbourhoodVolume);       % Calculate stiffening correction factor
    BONDSTIFFNESS(kBond)=stiffeningFactor*bondStiffnessTemp;                                            % Correct the bond stiffness

end

% Bond force multiplier
BFMULTIPLIER(BONDTYPE==1)=3;
BFMULTIPLIER(BONDTYPE==0 | BONDTYPE==2)=1;

end