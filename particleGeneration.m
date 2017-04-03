
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
[n, x,y,z, dx,dy,dz, vx,vy,vz, dvx,dvy,dvz, lmag,lx,ly,lz]
 1  2 3 4   5  6  7   8  9 10   11  12  13    14 15 16 17
%}

fileName = 'Gtest5.csv';

specification = [ 10, 0,0,0, 2,2,2, 0,0,0, 1,1,1, .2, 0,0,1];
              %    10, -5,0,0, 2,2,2, 0,-5,0, 1,1,1, .2, 0,0,-1];

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
    deviationVelocity = specification(cluster, 11:13);
    angularVelocityMagnitude = specification(cluster, 14);
    angularVelocityDirection = specification(cluster,15:17)./norm(specification(cluster,15:17));
    
    % Generate nromaly distributed positions and velocities for particles
    % in cluster
    positions = normrnd(repmat(averagePosition, particleCount, 1), repmat(deviationPosition, particleCount, 1));
    velocities = normrnd(repmat(averageVelocity, particleCount, 1), repmat(deviationVelocity, particleCount, 1));
    
    % Adjust for angular momentum of cluster
    
    centreOfMass = mean(positions);
    
    relativePosition = positions - centreOfMass;
    
    angularVelocities = cross(relativePosition, velocities);
    averageAngularVelcocity = mean(angularVelocities)
    
    angularVelocityCorrection = angularVelocityMagnitude * angularVelocityDirection - averageAngularVelcocity;
    
    relativePositionsMagnitude = sum(relativePosition.*relativePosition,2);
    velocityCorrection = min(cross(repmat(angularVelocityCorrection, particleCount, 1), relativePosition)./relativePositionsMagnitude,1);
    velocities = velocities + velocityCorrection;
    
    wTest = cross(relativePosition, velocities);
    wTestMean = mean(wTest);
    wTestMag = norm(wTestMean)
    
    allPositions(index:index+particleCount-1,:) = positions; 
    allVelocities(index:index+particleCount-1,:) = velocities;
    index = index + particleCount;
end

% rescale velocities to ensure there is no drift in the system
averageVelocity = mean(allVelocities);
allVelocities = averageVelocity - allVelocities;

%scatter3(allPositions(:,1),allPositions(:,2),allPositions(:,3))
%title('positions')
%figure
scatter3(allVelocities(:,1),allVelocities(:,2),allVelocities(:,3))
title('velocities')
append_to_csv(fileName, 0, allPositions, allVelocities);
