function [ initial_conditions ] = load_initial_conditions( filename )
%loadInitialConditions Loads initial conditions for simulation from last
%line of 

data = csvread(filename);

[lastRow, ~] = size(data);

initial_conditions = data(lastRow, :);
    
end

