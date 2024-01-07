% Define the payoff matrix for the game
A = [0, 3, 1;
    3, 0, 1;
    1, 1, 1];

% Define the average fitness based on the above payoff matrix
avg = @(x,y,z) ((x*((x*A(1,1))+(y*A(1,2))+(z*A(1,3))))+(y*((x*A(2,1))+ ...
    (y*A(2,2))+(z*A(2,3))))+(z*((x*A(3,1))+(y*A(3,2))+(z*A(3,3)))));

% Derive the replicator equations based on the payoff matrix. We take
% the three probabilities x, y, and z such that x + y + z = 1
dxdt = @(t, x, y, z) (x*(((x*A(1,1))+(y*A(1,2))+(z*A(1,3))-avg(x, y, z))));
dydt = @(t, x, y, z) (y*(((x*A(2,1))+(y*A(2,2))+(z*A(2,3))-avg(x, y, z))));
dzdt = @(t, x, y, z) (z*(((x*A(3,1))+(y*A(3,2))+(z*A(3,3))-avg(x, y, z))));

% Set the number of trajectories
num_trajectories = 10;

% Generate random initial conditions for multiple trajectories such that
% they add up to 1
initial_conditions = zeros(num_trajectories, 3);
for i = 1:num_trajectories
    a = rand();
    b = rand() * (1 - a);
    c = 1 - a - b;
    initial_conditions(i, :) = [a, b, c];
end

% Iterate through each set of initial conditions
for i = 1:num_trajectories

    % Solve the set of replicator equations
    options = odeset('RelTol', 1e-10, 'AbsTol', 1e-10);
    [t, result] = ode45(@(t, f) [dxdt(t, f(1), f(2), f(3)); dydt(t, f(1), f(2), f(3));...
        dzdt(t, f(1), f(2), f(3))], [1, 100], initial_conditions(i, :), options);
    
    % Convert the obtained 3D coordinates (solutions of the ODEs) into ternary coordinates
    tern_coords = zeros(length(result), 2);
    for j = 1:length(result)
        tern_coords(j, :) = ternary(result(j, 1), result(j, 2), result(j, 3));
    end
    
    % Plot the trajectories for the ternary coordinates obtained
    plot(tern_coords(:, 1), tern_coords(:, 2));
    hold on;
end

% Plot the equilateral triangle denoting the simplex
vertices = [0, 0; 1, 0; 1/2, (sqrt(3)/2); 0, 0]; % plotting a closed curve
plot(vertices(:, 1), vertices(:, 2), 'k-');
axis equal;
title('Strategy Simplex for Rock Paper Scissors Game');

function [r] = ternary(x,y,z)
    % This function returns the ternary coordinates (in 2D) corresponding
    % to the input 3D coordinates. We will be representing them in an equilateral
    % triangle. Here R is a vector containing 3D coordinates and r contains
    % 2D coordinates
    a = [1/2,(sqrt(3)/2)];
    b = [1,0];
    c = [0,0];
    r = x*a + y*b + z*c;
end
