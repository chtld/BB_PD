function [fail,disp,Stretch,ReactionForce,nodedisplacement,timesteptracker]=timeintegration(bondlist,UndeformedLength,BondType,c,BFmultiplier,coordinates,fac,BODYFORCE,DENSITY,MATERIALFLAG,CONSTRAINTFLAG,NumFamMembVector,nodefamily,nfpointer)
% Time integration using a Forward Difference (FD) Backward Difference (BD) scheme (FD_BD)

%% Constants
dataMaterialProperties
dataGeometry
dataPDparameters
dataSimulationParameters

TOTALBONDS=size(bondlist,1);
TOTALNODES=size(coordinates,1);

%% Initialise 
fail=zeros(TOTALBONDS,1)+1;                      
Stretch=zeros(TOTALBONDS,1);
DeformedLength=zeros(TOTALBONDS,1);
Nforce=zeros(TOTALNODES,NOD);                       % Total peridynamic force acting on a material point (Node)
disp=zeros(TOTALNODES,NOD);                         % Displacement of a material point
disp_forward=zeros(TOTALNODES,NOD);
v=zeros(TOTALNODES,NOD);                            % Velocity of a material point
v_forward=zeros(TOTALNODES,NOD);
a=zeros(TOTALNODES,NOD);                            % Acceleration of a material point
nodedisplacement=zeros(NT,1);                       % History of displacement at selected node
%ForceHistory=zeros(NT,1);                           % History of applied force
ReactionForce=zeros(NT,1);                          
Xdeformed=zeros(TOTALBONDS,1);
Ydeformed=zeros(TOTALBONDS,1);
Zdeformed=zeros(TOTALBONDS,1);

%% Main body of timeintegration
tic

for tt=timesteptracker:NT
  
    timesteptracker=tt+1; % If a checkpoint file is loaded, the simulation needs to start on the next iteration
         
    %% Calculate Bond Forces and perform time integration - Forward Difference and Backward Difference scheme
        
    Nforce(:,:)=0;  % Nodal force - initialise for every time step
    
    [DeformedLength,Xdeformed,Ydeformed,Zdeformed,Stretch]=calculatedeformedlength(TOTALBONDS,bondlist,UndeformedLength,DeformedLength,coordinates,disp,Xdeformed,Ydeformed,Zdeformed);
    [Nforce,fail]=calculatebondforces(Nforce,TOTALBONDS,fail,BondType,Stretch,CRITICAL_TS_CONCRETE,CRITICAL_TS_STEEL,c,VOLUME,fac,DeformedLength,Xdeformed,Ydeformed,Zdeformed,BODYFORCE,MAXBODYFORCE,bondlist,BFmultiplier);
       
    a(:,:)=(Nforce(:,:)-DAMPING*v(:,:))./DENSITY(:,:);     % Acceleration for time:-   tt
    a(CONSTRAINTFLAG==0)=0;                                % Apply constraints
    v_forward(:,:)=v(:,:)+(a(:,:)*DT);                     % Velocity for time:-       tt + 1dt
    disp_forward(:,:)=disp(:,:) + (v_forward(:,:)*DT);     % Displacement for time:-   tt + 1dt
    v(:,:)=v_forward(:,:);                                 % Update
    disp(:,:)=disp_forward(:,:);                           % Update
    
    
    % Calculating the percentage of progress of time integration
    percProgress=(tt/NT)*100;
    fprintf('Completed %.3f%% of time integration \n', percProgress)
    
    
    %% Save results
  
    nodedisplacement(tt,1)=disp(1500,3);          % Save displacement of defined node for plot of Displacement vs Time   
    
    % ForceHistory(tt,1)=Force;                   % Force 

%     if mod(tt,2500)==0
%        save(['D:\PhD\2 Code\BB_PD\Output\Workspace_snapshot_',num2str(tt),'.mat']); % Save workspace to local computer every 2500 time steps
%     end
    
end


end


%% Extra code     
%     if perc_progress==1
%         onepercent=toc;
%         fprintf('1 percent of time integration complete in %fs \n', onepercent)
%         pause
%     end