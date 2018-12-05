
function [c,BondType,BFmultiplier]=determineBondType(bondlist,NumFamMembVector,MaterialFlag)

% Determine the bond type and stiffness connecting node pairs (e.g. is it a concrete or
% steel bond?)

%% Constants
dataMaterialProperties
dataGeometry
dataPDparameters
TOTALBONDS=size(bondlist,1);

%% Main body of determineBondType

c=zeros(TOTALBONDS,1);              % Initialise bond stiffness vector
BondType=zeros(TOTALBONDS,1);       % Initialise bond type vector
BFmultiplier=zeros(TOTALBONDS,1);   % Initialise bond force multiplier vector


for i=1:TOTALBONDS
        
    nodei=bondlist(i,1);
    nodej=bondlist(i,2);
        
 
    % Concrete to concrete - if materialflag i=0 and j=0 then c=concrete
    if MaterialFlag(nodei,1)==0 && MaterialFlag(nodej,1)==0
        ctemp=C_CONCRETE;
        BondType(i)=0;
    % Concrete to steel - if materialflag i=0 and j=1 then c=concrete   
    elseif MaterialFlag(nodei,1)==0 && MaterialFlag(nodej,1)==1
        ctemp=C_CONCRETE;
        BondType(i)=1;
    % Concrete to steel - if materialflag i=1 and j=0 then c=concrete     
    elseif MaterialFlag(nodei,1)==1 && MaterialFlag(nodej,1)==0
        ctemp=C_CONCRETE;
        BondType(i)=1;
    % Steel to steel - if materialflag i=1 and j=1 the c=steel   
    elseif MaterialFlag(nodei,1)==1 && MaterialFlag(nodej,1)==1
        ctemp=C_STEEL;
        BondType(i)=2;
    end


    % Calculate stiffening factor - surface corrections for 3D problem
    NeighbourhoodVolume_i=NumFamMembVector(nodei)*VOLUME;                                             % Neighbourhood area for Node 'i'
    NeighbourhoodVolume_cnode=NumFamMembVector(nodej)*VOLUME;                                         % Neighbourhood area for Node 'j'
    StiffeningFactor=(2*NEIGHBOURHOODVOLUME)/(NeighbourhoodVolume_i+NeighbourhoodVolume_cnode);
    c(i)=StiffeningFactor*ctemp;                                                                      % Correct the bond stiffness

end

% Bond force multiplier
BFmultiplier(BondType==1)=3;
BFmultiplier(BondType==0 | BondType==2)=1;

end