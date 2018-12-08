function plotLoadDisplacementGraph(nodedisplacement,stresshistory)
% Plot load-displacement graph

figure;
plot(nodedisplacement,stresshistory)
xlabel('Displacement (m)')
ylabel('Load (N)')

end 