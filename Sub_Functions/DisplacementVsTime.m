% Plot displacement vs time

function DisplacementVsTime(nt,Displacement_node)

% Plot y displacement of bottom node at the free end - node 200
%Displacement_node=-squeeze(Displacement(200,2,:));

Time(:,1)=1:nt;

figure(4)
plot(Time,-Displacement_node)
xlabel('Time step') 
ylabel('Displacement (m)')

end 