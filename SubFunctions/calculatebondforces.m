function [Nforce,fail]=calculatebondforces(Nforce,Totalbonds,fail,BondType,Stretch,Critical_ts_conc,Critical_ts_steel,c,Volume,fac,DeformedLength,Xdeformed,Ydeformed,Zdeformed,bodyforce,Max_Force,bondlist,BFmultiplier)
% Calculate bond forces, make use of logical indexing

% Initialise bond force to zero for every time step
BforceX=zeros(Totalbonds,1); 
BforceY=zeros(Totalbonds,1);
BforceZ=zeros(Totalbonds,1);

fail(fail==1 & BondType==0 & Stretch>Critical_ts_conc)=0;     % Deactivate bond if stretch exceeds critical stretch   Failed = 0 
fail(fail==1 & BondType==1 & Stretch>3*Critical_ts_conc)=0;   % EMU user manual recommends that the critical stretch and bond force are multiplied by a factor of 3 for concrete to steel bonds 
fail(fail==1 & BondType==2 & Stretch>Critical_ts_steel)=0;    
% Bond remains active = 1

% Calculate X,Y,Z component of bond force
BforceX=BFmultiplier.*fail.*c.*Stretch*Volume.*fac.*(Xdeformed./DeformedLength);
BforceY=BFmultiplier.*fail.*c.*Stretch*Volume.*fac.*(Ydeformed./DeformedLength);
BforceZ=BFmultiplier.*fail.*c.*Stretch*Volume.*fac.*(Zdeformed./DeformedLength);

% DeformedLength will be 0 intially and divison leads to 'Not-a-Number'. If Bforce = 'NaN', set to 0 
BforceX(isnan(BforceX))=0; 
BforceY(isnan(BforceY))=0;
BforceZ(isnan(BforceZ))=0;

% Calculate the nodal force for every node, iterate over the bond list
for i=1:Totalbonds
    
    nodei=bondlist(i,1); % Node i
    nodej=bondlist(i,2); % Node j
    
    % X-component
    Nforce(nodei,1)=Nforce(nodei,1)+BforceX(i); % Bond force is positive on Node i 
    Nforce(nodej,1)=Nforce(nodej,1)-BforceX(i); % Bond force is negative on Node j
    
    % Y-component
    Nforce(nodei,2)=Nforce(nodei,2)+BforceY(i);
    Nforce(nodej,2)=Nforce(nodej,2)-BforceY(i);
    
    % Z-component
    Nforce(nodei,3)=Nforce(nodei,3)+BforceZ(i);
    Nforce(nodej,3)=Nforce(nodej,3)-BforceZ(i);
        
end
                                          
% Add body force
Nforce(:,:)=Nforce(:,:)+(bodyforce(:,:)*Max_Force);

end
