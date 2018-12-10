function [fail,disp,stretch,nodeDisplacement,timeStepTracker]=timeintegration(BONDLIST,COORDINATES,UNDEFORMEDLENGTH,BONDTYPE,BFMULTIPLIER,BONDSTIFFNESS,VOLUMECORRECTIONFACTORS,BODYFORCE,DENSITY,CONSTRAINTFLAG)
% Time integration using a Forward Difference (FD) Backward Difference (BD) scheme (FD_BD)

%% Constants
datamaterialproperties
datageometry
dataPDparameters
datasimulationparameters

nBONDS=size(BONDLIST,1);
nNODES=size(COORDINATES,1);

%% Initialise 
fail=zeros(nBONDS,1)+1;                      
stretch=zeros(nBONDS,1);
deformedLength=zeros(nBONDS,1);
nodalForce=zeros(nNODES,NOD);                   % Total peridynamic force acting on a material point (Node)
disp=zeros(nNODES,NOD);                         % Displacement of a material point
dispForward=zeros(nNODES,NOD);
v=zeros(nNODES,NOD);                            % Velocity of a material point
vForward=zeros(nNODES,NOD);
a=zeros(nNODES,NOD);                            % Acceleration of a material point
nodeDisplacement=zeros(NT,1);                   % History of displacement at selected node                          
deformedX=zeros(nBONDS,1);
deformedY=zeros(nBONDS,1);
deformedZ=zeros(nBONDS,1);

%% Main body of timeintegration
tic

for tt=timeStepTracker:NT
  
    timeStepTracker=tt+1; % If a checkpoint file is loaded, the simulation needs to start on the next iteration(tt+1)
         
    %% Calculate Bond Forces and perform time integration - Forward Difference and Backward Difference scheme
        
    nodalForce(:,:)=0;  % Nodal force - initialise for every time step
    
    % Calculate deformed length of every bond
    [deformedLength,deformedX,deformedY,deformedZ,stretch]=calculatedeformedlength(COORDINATES,disp,nBONDS,BONDLIST,deformedX,deformedY,deformedZ,UNDEFORMEDLENGTH,deformedLength);
    
    % Calculate bond force for every bond
    [nodalForce,fail]=calculatebondforces(nBONDS,fail,BONDTYPE,stretch,CRITICAL_STRETCH_CONCRETE,CRITICAL_STRETCH_STEEL,BFMULTIPLIER,BONDSTIFFNESS,VOLUME,VOLUMECORRECTIONFACTORS,deformedX,deformedY,deformedZ,deformedLength,BONDLIST,nodalForce,BODYFORCE,MAXBODYFORCE);
    
    a(:,:)=(nodalForce(:,:)-DAMPING*v(:,:))./DENSITY(:,:);     % Acceleration for time:-   tt
    a(CONSTRAINTFLAG==0)=0;                                    % Apply constraints
    vForward(:,:)=v(:,:)+(a(:,:)*DT);                          % Velocity for time:-       tt + 1dt
    dispForward(:,:)=disp(:,:) + (vForward(:,:)*DT);           % Displacement for time:-   tt + 1dt
    v(:,:)=vForward(:,:);                                      % Update
    disp(:,:)=dispForward(:,:);                                % Update    
    
    %% Save and output results
    
    percProgress=(tt/NT)*100; fprintf('Completed %.3f%% of time integration \n', percProgress)  % Calculate and output the percentage of progress of time integration
    
    nodeDisplacement(tt,1)=disp(1500,3);          % Save displacement of defined node for plot of Displacement vs Time   

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