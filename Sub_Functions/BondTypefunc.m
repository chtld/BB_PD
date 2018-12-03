
function [Bonds]=BondTypefunc(Bonds,Nodes,Discretisation,PDparameters)

% Determine the bond type and stiffness connecting node pairs (e.g. is it a concrete or
% steel bond?)

%% Unpack structured array data
Totalbonds=Bonds.Totalbonds;
bondlist=Bonds.bondlist;
NumFamMembVector=Nodes.NumFamMembVector;
MaterialFlag=Nodes.MaterialFlag;
c_concrete=PDparameters.c_concrete;
c_steel=PDparameters.c_steel;
Volume=Discretisation.Volume;
NeighbourhoodVolume=PDparameters.NeighbourhoodVolume;

%% Main body of BondTypefunc

c=zeros(Totalbonds,1);              % Initialise bond stiffness vector
BondType=zeros(Totalbonds,1);       % Initialise bond type vector
BFmultiplier=zeros(Totalbonds,1);   % Initialise bond force multiplier vector


for i=1:Totalbonds
        
    nodei=bondlist(i,1);
    nodej=bondlist(i,2);
        
 
    % Concrete to concrete - if materialflag i=0 and j=0 then c=concrete
    if MaterialFlag(nodei,1)==0 && MaterialFlag(nodej,1)==0
        ctemp=c_concrete;
        BondType(i)=0;
    % Concrete to steel - if materialflag i=0 and j=1 then c=concrete   
    elseif MaterialFlag(nodei,1)==0 && MaterialFlag(nodej,1)==1
        ctemp=c_concrete;
        BondType(i)=1;
    % Concrete to steel - if materialflag i=1 and j=0 then c=concrete     
    elseif MaterialFlag(nodei,1)==1 && MaterialFlag(nodej,1)==0
        ctemp=c_concrete;
        BondType(i)=1;
    % Steel to steel - if materialflag i=1 and j=1 the c=steel   
    elseif MaterialFlag(nodei,1)==1 && MaterialFlag(nodej,1)==1
        ctemp=c_steel;
        BondType(i)=2;
    end


    % Calculate stiffening factor - surface corrections for 3D problem
    NeighbourhoodVolume_i=NumFamMembVector(nodei)*Volume;                                             % Neighbourhood area for Node 'i'
    NeighbourhoodVolume_cnode=NumFamMembVector(nodej)*Volume;                                         % Neighbourhood area for Node 'j'
    StiffeningFactor=(2*NeighbourhoodVolume)/(NeighbourhoodVolume_i+NeighbourhoodVolume_cnode);
    c(i)=StiffeningFactor*ctemp;                                                                      % Correct the bond stiffness

end

% Bond force multiplier
BFmultiplier(BondType==1)=3;
BFmultiplier(BondType==0 | BondType==2)=1;

%% Pack data into structured array
Bonds.c=c;
Bonds.BondType=BondType;
Bonds.BFmultiplier=BFmultiplier;
end