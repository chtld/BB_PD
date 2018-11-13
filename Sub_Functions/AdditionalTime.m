% Add additional time to simulation
% Pre-allocate more memory to vectors Displacement_node and ForceHistory

function [Displacement_node,nt]=Additional_Time(Displacement_node,nt,countmin)

%[Displacement_node,ForceHistory,nt]=Additional_Time(Displacement_node,ForceHistory,nt,countmin)

prompt='Enter additional number of time steps required ';
nt_plus=input(prompt)

nt=nt+nt_plus;

% Expand Displacement_node vector
Displacement_node_Temp=zeros(nt,1);
Displacement_node_Temp(1:countmin-1,1)=Displacement_node;
Displacement_node=Displacement_node_Temp;

% Expand ForceHistory vector
% ForceHistory_Temp=zeros(1,nt);
% ForceHistory_Temp(1,1:countmin-1)=ForceHistory;
% ForceHistory=ForceHistory_Temp;

end