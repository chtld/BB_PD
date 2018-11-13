% Plot Force vs Displacement

function ForceVsDisplacement(Displacement_node,ForceHistory)

% Plot vertical y displacement of bottom node at the free end against Force

figure(4)
plot(-Displacement_node,-ForceHistory)
ylim([0 20e7])
xlabel('Displacement (m)')
ylabel('Force (N)')

end 