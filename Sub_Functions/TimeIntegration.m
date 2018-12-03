function [fail,disp,Stretch,Displacement_node,ReactionForce,countmin,StressHistory]=TimeIntegration(Bonds,Nodes,PDparameters,Discretisation,Geometry,SimParameters,MaterialProperties)
% Time integration using a Forward Difference (FD) Backward Difference (BD) scheme (FD_BD)

%% Unpack structured array data
Totalbonds=Bonds.Totalbonds;
bondlist=Bonds.bondlist;
UndeformedLength=Bonds.UndeformedLength;
BondType=Bonds.BondType;
c=Bonds.c;
BFmultiplier=Bonds.BFmultiplier;

Totalnodes=Nodes.Totalnodes;
coordinates=Nodes.coordinates;
fac=Nodes.fac;
bodyforce=Nodes.bodyforce;
dens=Nodes.dens;
MaterialFlag=Nodes.MaterialFlag;
ConstraintFlag=Nodes.ConstraintFlag;

Critical_ts_conc=PDparameters.Critical_ts_conc;
Critical_ts_steel=PDparameters.Critical_ts_steel;

Volume=Discretisation.Volume;

Nod=Geometry.Nod;

nt=SimParameters.nt;
countmin=SimParameters.countmin;
Max_Force=SimParameters.Max_Force;
damping=SimParameters.damping;
dt=SimParameters.dt;

%% Initialise 
fail=zeros(Totalbonds,1)+1;                      
Stretch=zeros(Totalbonds,1);
DeformedLength=zeros(Totalbonds,1);
Nforce=zeros(Totalnodes,Nod);                       % Total peridynamic force acting on a material point (node)
disp=zeros(Totalnodes,Nod);                         % Displacement of a material point
disp_forward=zeros(Totalnodes,Nod);
v=zeros(Totalnodes,Nod);                            % Velocity of a material point
v_forward=zeros(Totalnodes,Nod);
a=zeros(Totalnodes,Nod);                            % Acceleration of a material point
%Displacement_node=zeros(nt,1);                      % History of displacement at selected node
ForceHistory=zeros(nt,1);                           % History of applied force
ReactionForce=zeros(nt,1);                          
Xdeformed=zeros(Totalbonds,1);
Ydeformed=zeros(Totalbonds,1);
Zdeformed=zeros(Totalbonds,1);

%% Main body of TimeIntergation
tic
counter=0;

for tt=countmin:nt
  
    countmin=tt+1; % If a checkpoint file is loaded, the simulation needs to start on the next iteration
         
    %% Calculate Bond Forces and perform time integration - Forward Difference and Backward Difference scheme
        
    Nforce(:,:)=0;  % Nodal force - initialise for every time step
    
    [DeformedLength,Xdeformed,Ydeformed,Zdeformed,Stretch]=DeformedLengthfunc(Totalbonds,bondlist,UndeformedLength,DeformedLength,coordinates,disp,Xdeformed,Ydeformed,Zdeformed);
    [Nforce,fail]=BondForces(Nforce,Totalbonds,fail,BondType,Stretch,Critical_ts_conc,Critical_ts_steel,c,Volume,fac,DeformedLength,Xdeformed,Ydeformed,Zdeformed,bodyforce,Max_Force,bondlist,BFmultiplier);
       
    a(:,:)=(Nforce(:,:)-damping*v(:,:))./dens(:,:);        % Acceleration for time:-   tt
    a(ConstraintFlag==0)=0;                                % Apply constraints
    v_forward(:,:)=v(:,:)+(a(:,:)*dt);                     % Velocity for time:-       tt + 1dt
    disp_forward(:,:)=disp(:,:) + (v_forward(:,:)*dt);     % Displacement for time:-   tt + 1dt
    v(:,:)=v_forward(:,:);                                 % Update
    disp(:,:)=disp_forward(:,:);                           % Update
    
    % Calculating the percentage of progress of time integration
    perc_progress=(tt/nt)*100;
    fprintf('Completed %.3f%% of time integration \n', perc_progress)
    
    if perc_progress==1
        onepercent=toc;
        fprintf('1 percent of time integration complete in %fs \n', onepercent)
        pause
    end

    %% Save results
    
    
%     if mod(tt,1)==0
%         counter=counter+1;
%         Displacement_node(counter,1)=disp(66321,3);          % Save displacement of defined node for plot of Displacement vs Time
% 
%         [StrainTensor]=Strainfunc(coordinates,disp,Totalbonds,bondlist,NumFamMembVector,nodefamily,nfpointer);
%         [StressTensor]=Stressfunc(Totalnodes,Nod,MaterialProperties,coordinates,disp,StrainTensor,MaterialFlag);
% 
%         StressHistory(counter,1)=StressTensor(66321,1,1);
%     end
%     
    
    % ForceHistory(tt,1)=Force;                   % Force
    NforceTemp=Nforce;
    NforceTemp(ConstraintFlag==1)=0;
    ReactionForce(tt,1)=sum(NforceTemp(:,3)); 

%     if mod(tt,2500)==0
%        save(['D:\PhD\2 Code\BB_PD\Output\Workspace_snapshot_',num2str(tt),'.mat']); % Save workspace to local computer every 2500 time steps
%     end
    
end

%% Pack data into structured array
% fail
% disp
% Stretch
% Displacement_node
% ReactionForce
% countmin
% StressHistory

end
