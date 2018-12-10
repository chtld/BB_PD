function [nodalForce,fail]=calculatebondforces(nBONDS,fail,BONDTYPE,stretch,CRITICAL_STRETCH_CONCRETE,CRITICAL_STRETCH_STEEL,BFMULTIPLIER,BONDSTIFFNESS,VOLUME,VOLUMECORRECTIONFACTORS,deformedX,deformedY,deformedZ,deformedLength,BONDLIST,nodalForce,BODYFORCE,MAXBODYFORCE)
% Calculate bond forces, make use of logical indexing

% Initialise bond force to zero for every time step
bForceX=zeros(nBONDS,1); 
bForceY=zeros(nBONDS,1);
bForceZ=zeros(nBONDS,1);

fail(fail==1 & BONDTYPE==0 & stretch>CRITICAL_STRETCH_CONCRETE)=0;     % Deactivate bond if stretch exceeds critical stretch   Failed = 0 
fail(fail==1 & BONDTYPE==1 & stretch>3*CRITICAL_STRETCH_CONCRETE)=0;   % EMU user manual recommends that the critical stretch and bond force are multiplied by a factor of 3 for concrete to steel bonds 
fail(fail==1 & BONDTYPE==2 & stretch>CRITICAL_STRETCH_STEEL)=0;    
% Bond remains active = 1

% Calculate X,Y,Z component of bond force
bForceX=BFMULTIPLIER.*fail.*BONDSTIFFNESS.*stretch*VOLUME.*VOLUMECORRECTIONFACTORS.*(deformedX./deformedLength);
bForceY=BFMULTIPLIER.*fail.*BONDSTIFFNESS.*stretch*VOLUME.*VOLUMECORRECTIONFACTORS.*(deformedY./deformedLength);
bForceZ=BFMULTIPLIER.*fail.*BONDSTIFFNESS.*stretch*VOLUME.*VOLUMECORRECTIONFACTORS.*(deformedZ./deformedLength);

% DeformedLength will be 0 intially and divison leads to 'Not-a-Number'. If Bforce = 'NaN', set to 0 
bForceX(isnan(bForceX))=0; 
bForceY(isnan(bForceY))=0;
bForceZ(isnan(bForceZ))=0;

% Calculate the nodal force for every node, iterate over the bond list
for kBond=1:nBONDS
    
    nodei=BONDLIST(kBond,1); % Node i
    nodej=BONDLIST(kBond,2); % Node j
    
    % X-component
    nodalForce(nodei,1)=nodalForce(nodei,1)+bForceX(kBond); % Bond force is positive on Node i 
    nodalForce(nodej,1)=nodalForce(nodej,1)-bForceX(kBond); % Bond force is negative on Node j
    
    % Y-component
    nodalForce(nodei,2)=nodalForce(nodei,2)+bForceY(kBond);
    nodalForce(nodej,2)=nodalForce(nodej,2)-bForceY(kBond);
    
    % Z-component
    nodalForce(nodei,3)=nodalForce(nodei,3)+bForceZ(kBond);
    nodalForce(nodej,3)=nodalForce(nodej,3)-bForceZ(kBond);
        
end
                                          
% Add body force
nodalForce(:,:)=nodalForce(:,:)+(BODYFORCE(:,:)*MAXBODYFORCE);

end
