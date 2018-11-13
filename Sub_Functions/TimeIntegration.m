
% Time integration

function [fail,disp,Stretch,Displacement_node,ReactionForce,countmin]=TimeIntegration(Totalnodes,Totalbonds,bondlist,Nod,countmin,nt,Build_up,Max_Force,NumFamMembVector,nodefamily,nfpointer,UndeformedLength,coordinates,BondType,Critical_ts_conc,Critical_ts_steel,c,fac,Volume,damping,dens,dt,ConstraintFlag,bodyforce)

fail=zeros(Totalbonds,1)+1;                      
Stretch=zeros(Totalbonds,1);
DeformedLength=zeros(Totalbonds,1);
Nforce=zeros(Totalnodes,Nod);                       % Total peridynamic force acting on a material point (node)
disp=zeros(Totalnodes,Nod);                         % Displacement of a material point
disp_forward=zeros(Totalnodes,Nod);
v=zeros(Totalnodes,Nod);                            % Velocity of a material point
v_forward=zeros(Totalnodes,Nod);
a=zeros(Totalnodes,Nod);                            % Acceleration of a material point
Displacement_node=zeros(nt,1);                      % History of displacement at selected node
ForceHistory=zeros(nt,1);                           % History of applied force
ReactionForce=zeros(nt,1);                          

Xdeformed=zeros(Totalbonds,1);
Ydeformed=zeros(Totalbonds,1);
Zdeformed=zeros(Totalbonds,1);

tic
for tt=countmin:nt
    
    %% Application of boundary conditions
    countmin=tt+1; % If a checkpoint file is loaded, the simulation needs to start on the next iteration
%     
%     % Build load up over defined number of time steps
%     if (1<=tt) && (tt<=Build_up)
%         Force=(Max_Force/Build_up)*tt;
%     elseif tt>Build_up
%         Force=Max_Force;
%     end
     
    % Application of force
    % Application of fixed conditions
         
    %% Calculate Bond Forces and perform time integration - Forward Difference and Backward Difference scheme
    % Calculate bond and nodal forces:-    tt
    Nforce(:,:)=0;  % Nodal force - initialise for every time step
    
    [DeformedLength,Xdeformed,Ydeformed,Zdeformed,Stretch]=DeformedLengthfunc(Totalbonds,bondlist,UndeformedLength,DeformedLength,coordinates,disp,Xdeformed,Ydeformed,Zdeformed);
    [Nforce,fail]=BondForces(Nforce,Totalbonds,fail,BondType,Stretch,Critical_ts_conc,Critical_ts_steel,c,Volume,fac,DeformedLength,Xdeformed,Ydeformed,Zdeformed,bodyforce,Max_Force,bondlist);
       
    a(:,:)=(Nforce(:,:)-damping*v(:,:))./dens(:,:);        % Acceleration for time:-   tt
    a(ConstraintFlag==0)=0;
    v_forward(:,:)=v(:,:)+(a(:,:)*dt);                     % Velocity for time:-       tt + 1dt
    disp_forward(:,:)=disp(:,:) + (v_forward(:,:)*dt);     % Displacement for time:-   tt + 1dt
    v(:,:)=v_forward(:,:);                                 % Update
    disp(:,:)=disp_forward(:,:);                           % Update
    
    % Calculating the percentage of progress of time integration
    perc_progress=(tt/nt)*100;
    fprintf('Completed %.3f%% of time integration \n', perc_progress)
%     if perc_progress==1
%         onepercent=toc;
%         fprintf('1 percent of time integration complete in %fs \n', onepercent)
%         pause
%     end

    %% Save results
    
    Displacement_node(tt,1)=disp(150,3);         % Displacement
    % ForceHistory(tt,1)=Force;                   % Force
    NforceTemp=Nforce;
    NforceTemp(ConstraintFlag==1)=0;
    ReactionForce(tt,1)=sum(NforceTemp(:,3)); 
    
    if tt==nt
        Displacement(:,:)=disp;
        NodalForce(:,:)=Nforce;
    end
    
    if mod(tt,2500)==0
       save(['D:\PhD\Workspace_snapshot_',num2str(tt),'.mat']); % Save workspace to local computer every 2500 time steps
    end
    
end

end
