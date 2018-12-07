
function plotDisplacementTimeGraph(NT,nodedisplacement)
% Plot Displacement-Time graph for selected node
time(:,1)=1:NT;

figure;
plot(time,-nodedisplacement)
xlabel('Time step') 
ylabel('Displacement (m)')

end 