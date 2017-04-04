
%{ 
Generate clusters of particles.
Spesification matrix:
- number of particles, 
- centre of cluster (x,y,z)
- standard deviation in position (x,y,z)
- average velocity of clusters (x,y,z)
- standard deviation of velocity (x,y,z)
- magnitude of angular momentum
- dirction of angular momentum

Format per row:
[n, x,y,z, dx,dy,dz, vx,vy,vz, lmag,dv, lx,ly,lz]
 1  2 3 4   5  6  7   8  9 10    11 12  13 14 15
%}

fileName = 'Gtest01.csv';

specification = [ 10, 0,0,0, 2,2,2, 0,0,0, 20,.1, 0,0,1];
              %    10, -5,0,0, 2,2,2, 0,-5,0, .2, 0,0,-1];

totalParticleCount = sum(specification(:,1));

[clusters, ~] = size(specification);

allPositions = zeros(totalParticleCount, 3);
allVelocities = zeros(totalParticleCount, 3);
index = 1;

for cluster = 1:clusters
    
    % Extract information for current cluster from spesification matrix
    particleCount = specification(cluster, 1);
    averagePosition = specification(cluster, 2:4);
    deviationPosition = specification(cluster, 5:7);
    averageVelocity = specification(cluster, 8:10);
    angularVelocityMagnitude = specification(cluster, 11)/particleCount;
    deviationMagnitude = specification(cluster, 12);
    angularVelocityDirection = specification(cluster,13:15)./norm(specification(cluster,13:15));
    
    % Generate normaly distributed positions for particles in cluster
    positions = normrnd(repmat(averagePosition, particleCount, 1), repmat(deviationPosition, particleCount, 1));
    centreOfMass = mean(positions);
    relativePosition = positions - centreOfMass;
    
    % Generate velocities forparticles that have spesified
    %  - total angular momentum about cluster centre
    %  - average velocity
    
    velocities = cross(repmat(angularVelocityDirection, particleCount, 1), relativePosition);
    
    velocities = normrnd(velocities, deviationMagnitude);
    
    velocities = velocities + averageVelocity;
    
    allPositions(index:index+particleCount-1,:) = positions; 
    allVelocities(index:index+particleCount-1,:) = velocities;
    index = index + particleCount;
end

% Rescale velocities to ensure there is no drift in the system
averageVelocity = mean(allVelocities);
allVelocities = averageVelocity - allVelocities;


% Plot result
scatter3(allPositions(:,1),allPositions(:,2),allPositions(:,3))
title('positions')
figure
scatter3(allVelocities(:,1),allVelocities(:,2),allVelocities(:,3))
title('velocities')
append_to_csv(fileName, 0, allPositions, allVelocities);
