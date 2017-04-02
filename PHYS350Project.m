%% PHYS 350 Project - Team Shutech
% Nolan Heim, Curtis Huebner, Morten Kals, Erik MacLennan
% 2017

%% Initial parameters
N = 10000000; %total time steps
iterative_steps = 1; 
delta_t = 0.01;
write_step = 10;
activate_write = false;
particle_mass = 1;
viewing_bound = 10;


filename = 'spinningFour.csv';
outputfilename = 'nolanTest.csv';

[current_position, current_velocity] = load_initial_conditions(filename);
[particles, ~] = size(current_position);

%% Potential functions

%csvwrite(outputfilename,[current_position, current_velocity]);
syms r;
sym_global_potential = 100/r
sym_local_potential = 100/r
global_potential = matlabFunction(sym_global_potential);
local_potential =matlabFunction(sym_local_potential);
global_force = matlabFunction(diff(sym_global_potential))
local_force = matlabFunction(diff(sym_local_potential))


%% Iterative method
%method = @simple_euler;
method = @rk4;
%method = @backward_euler;
%method = @simplectic;


for time = 1:N
    kinetic_energies = current_velocity.^2./2;
    kinetic_energies = particle_mass * sum(kinetic_energies,2);
    global_potential_energies = global_potential(sqrt(sum(current_position.^2,2)));
    
    [n , ~] = size(current_position);
    x_pos = zeros(n) + current_position(:,1);
    x_dist = x_pos-x_pos';
    y_pos = zeros(n) + current_position(:,2);
    y_dist = y_pos-y_pos';
    z_pos = zeros(n) + current_position(:,3);
    z_dist = z_pos-z_pos';
    dist = (x_dist.^2+y_dist.^2+z_dist.^2).^0.5+eye(n);
    local_potential_energies = local_potential(dist);
    local_potential_energies(logical(eye(n))) = 0;
    local_potential_energies=sum(local_potential_energies,2);
    
    potential_energies = global_potential_energies + local_potential_energies;
    
    total_energies = kinetic_energies + potential_energies;
    [current_position, current_velocity] = method(current_position, current_velocity, delta_t, iterative_steps, global_force, local_force);

    if mod(time, write_step) == 0 && activate_write
        append_to_csv(outputfilename, time, current_position, current_velocity);
    end 
    
    if mod(time,10) == 0
        subplot(2,1,1);
        histogram(kinetic_energies);
        hold on;
        histogram(potential_energies);
        hold on;
        histogram(total_energies);
        legend('show')
        hold off;
        
        potential_energies
        
        subplot(2,1,2);
        scatter3(current_position(:,1), current_position(:,2), current_position(:,3));
        axis([-viewing_bound,viewing_bound,-viewing_bound,viewing_bound,-viewing_bound,viewing_bound]);
        pause(0.0001);
    end
    
end