
function [bondDamage]=calculatedamage(TOTALNODES,bondlist,fail,NumFamMembVector)

% calculateDamage - Calculate the damage (percentage of bonds broken) for every node
% TODO should it be bondDamage or nodeDamage?

% Initialise
bondDamage=zeros(TOTALNODES,1);
unbrokenBonds=zeros(TOTALNODES,1);

nBonds=size(bondlist,1);

for i=1:nBonds
    
    nodei=bondlist(i,1);
    nodej=bondlist(i,2);
    
    % Calculate the number of unbroken bonds attached to every node
    unbrokenBonds(nodei,1)=unbrokenBonds(nodei,1)+fail(i);
    unbrokenBonds(nodej,1)=unbrokenBonds(nodej,1)+fail(i);

end

bondDamage(:,1)=1-(unbrokenBonds./NumFamMembVector(:,1)); % Calculate percentage of broken bonds attached to node i (1 would indicate that all bonds have broken)

end 