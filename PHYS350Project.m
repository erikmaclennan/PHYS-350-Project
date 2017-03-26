N = 10000000; %total time steps
iterative_steps = 5;
delta_t = 0.0001;

filename = 'spinningFour.csv';
outputfilename = 'test4.csv';

[current_position, current_velocity] = load_initial_conditions(filename);
   
%csvwrite(outputfilename,[current_position, current_velocity]);

global_potential = @(r) 0;
local_potential = @(r) -7./r;

method = @simple_euler;
%method = @rk4;
%method = @backward_euler;
%method = @simplectic;


for time = 1:N
   
    [current_position, current_velocity] = method(current_position, current_velocity, delta_t, iterative_steps, global_potential, local_potential);
    
    %append_to_csv(outputfilename, time, current_position, current_velocity);
    
    if mod(time,1000) == 0
        scatter3(current_position(:,1), current_position(:,2), current_position(:,3));
        axis([-20,20,-20,20,-20,20]);
        pause(0.0001);
    end
    
end