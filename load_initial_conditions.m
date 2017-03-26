function [ positions, velocities ] = load_initial_conditions( filename )
%loadInitialConditions Loads initial conditions for simulation from last
%line of 

data = csvread(filename);

[lastRow, columns] = size(data);
% columns is delta t + pos + vel

particle_count = (columns-1)/6;

positions = zeros(particle_count, 3);
velocities = zeros(particle_count, 3);

last_data = data(lastRow, 2:columns);

for column = 0 : columns-2
    row = fix(column/6)+1;
    col = mod(column-3,3)+1;
    if column < (columns-1)/2
        positions(row, col) = last_data(column+1);
    else
        velocities(row, col) = last_data(column+1);
    end
end

end
