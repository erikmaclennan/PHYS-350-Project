%% PHYS 350 Project - Team Shutech
% Nolan Heim, Curtis Huebner, Morten Kals, Erik MacLennan
% 2017

%% Initial parameters
N = 10000000; %total time steps
iterative_steps = 1; 
delta_t = 0.001;
write_step = 10;

activate_write = false;

viewing_bound = 10;

filename = 'spinningFour.csv';

outputfilename = 'nolanTest4.csv';

[current_position, current_velocity] = load_initial_conditions(filename);
[particles, ~] = size(current_position);

%% Potential functions

syms r;
sym_global_potential = r^2
sym_local_potential = -20e-65/(r+.2)
global_potential = matlabFunction(sym_global_potential);
local_potential = matlabFunction(sym_local_potential);
global_force = matlabFunction(-diff(sym_global_potential));
local_force = matlabFunction(-diff(sym_local_potential));



%% Iterative method
method = @simple_euler;
%method = @rk4;
%method = @backward_euler;
%method = @simplectic;


times = [];
tot = [];
kin = [];
pot = [];

for time = 1:N
    kinetic_energies = current_velocity.^2/2;
    kinetic_energies = sum(kinetic_energies,2);
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
    
    times = [times, time];
    tot = [tot, sum(total_energies)];
    kin = [kin, sum(kinetic_energies)];
    pot = [pot, sum(potential_energies)];
    
    if mod(time,100) == 0
        subplot(2,1,1);
        plot(times,tot,'LineWidth',3);
        hold on;
        plot(times,kin,'LineWidth',2);
        hold on;
        plot(times,pot,'LineWidth',2);
        legend('show')
        legend('total energy', 'kinetic energy', 'potential energy')
        grid minor
        grid on
        hold off;
        
        %total_energies
        
        subplot(2,1,2);
        scatter3(current_position(:,1), current_position(:,2), current_position(:,3),100,'filled');
        axis([-viewing_bound,viewing_bound,-viewing_bound,viewing_bound,-viewing_bound,viewing_bound]);
        pause(0.0001);
    end
    
end