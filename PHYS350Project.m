%% PHYS 350 Project - Team Shutech
% Nolan Heim, Curtis Huebner, Morten Kals, Erik MacLennan
% 2017

%% Initial parameters
N = 10000000; %total time steps
iterative_steps = 1; 
delta_t = 0.0001;

filename = 'spinningFour.csv';
outputfilename = 'test6.csv';

[current_position, current_velocity] = load_initial_conditions(filename);

%% Potential functions
global_potential = @(r) 0;
local_potential = @(r) -7./r;

%% Iterative method
method = @simple_euler;
%method = @rk4;
%method = @backward_euler;
%method = @simplectic;


for time = 1:N
   
    [current_position, current_velocity] = method(current_position, current_velocity, delta_t, iterative_steps, global_potential, local_potential);
    energy = current_velocity.^2;
    energy = sum(energy,2);
    
    append_to_csv(outputfilename, time, current_position, current_velocity);
    
    if mod(time,1000) == 0
        subplot(2,1,1);
        histogram(energy);
        subplot(2,1,2);
        scatter3(current_position(:,1), current_position(:,2), current_position(:,3));
        axis([-20,20,-20,20,-20,20]);
        pause(0.0001);
    end
    
end