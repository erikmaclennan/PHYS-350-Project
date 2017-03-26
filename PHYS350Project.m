N = 10000000; %total time steps
iterative_steps = 1;
delta_t = 0.0001;
n = 100; %number of particles

filename = 'testdata.csv';
outputfilename = 'test.csv';

[current_position, current_velocity] = load_initial_conditions(filename);
   
csvwrite(outputfilename,[current_position, current_velocity]);

global_potential = @(r) -1./r;
local_potential = @(r) 25./r - 1.*r;

method = @simple_euler;
%method = @rk4;
%method = @backward_euler;
%method = @simplectic;


for time = 1:N
   
    [currentposition, currentvelocity] = method(positions, velocities, delta_t, iterative_steps, global_potential, local_potential);
    append_to_csv(outputfilename, time, currentposition, currentvelocity);
    
    if mod(time,100) == 0
        scatter3(positions(1,:), positions(2,:), positions(3,:));
        axis([-10,10,-10,10,-10,10]);
        pause(0.001);
    end
    
end