function plotLoadDisplacementGraph(nodeDisplacement,stressHistory)
% Plot load-displacement graph

figure;
plot(nodeDisplacement,stressHistory)
xlabel('Displacement (m)')
ylabel('Load (N)')

end 