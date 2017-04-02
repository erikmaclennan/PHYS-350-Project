%% PHYS 350 Project - Team Shutech
% Nolan Heim, Curtis Huebner, Morten Kals, Erik MacLennan
% 2017

%% Initial parameters
N = 10000000; %total time steps
iterative_steps = 1; 
delta_t = 0.0001;
write_step = 10;
activate_write = false;

viewing_bound = 10;


filename = 'spinningFour.csv';
outputfilename = 'test7.csv';

[current_position, current_velocity] = load_initial_conditions(filename);


%% Potential functions

%csvwrite(outputfilename,[current_position, current_velocity]);
syms r;
sym_global_potential = 100/r
sym_local_potential = 100/r
global_potential = matlabFunction(sym_global_potential);
local_potential = matlabFunction(sym_local_potential);
global_force = matlabFunction(diff(sym_global_potential))
local_force = matlabFunction(diff(sym_local_potential))


%% Iterative method
%method = @simple_euler;
method = @rk4;
%method = @backward_euler;
%method = @simplectic;


for time = 1:N
    energy = current_velocity.^2;
    energy = sum(energy,2);

    [current_position, current_velocity] = method(current_position, current_velocity, delta_t, iterative_steps, global_force, local_force);

    if mod(time, write_step) == 0 && activate_write
        append_to_csv(outputfilename, time, current_position, current_velocity);
    end 
    
    if mod(time,1000) == 0
        subplot(2,1,1);
        histogram(energy);
        subplot(2,1,2);
        scatter3(current_position(:,1), current_position(:,2), current_position(:,3));
        axis([-viewing_bound,viewing_bound,-viewing_bound,viewing_bound,-viewing_bound,viewing_bound]);
        pause(0.0001);
    end
    
end