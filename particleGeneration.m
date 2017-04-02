
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

filename = 'testFile.csv';

spesification = [ 10, 2,3,4, 1,2,3, 1,2,3, 4,5,6, 4, 4,5,6;
                  4, -2,-3,-4, 1,2,3, .1,3,.1, 4,5,6, 4, 4,5,6];

totalParticleCount = sum(spesification(:,1));

[clusters, ~] = size(spesification);

allPositions = zeros(totalParticleCount, 3);
allVelocities = zeros(totalParticleCount, 3);
index = 1;

for cluster = 1:clusters
    
    % Extract information for current cluster from spesification matrix
    particleCount = spesification(cluster, 1);
    averagePosition = spesification(cluster, 2:4);
    deviationPosition = spesification(cluster, 5:7);
    averageVelocity = spesification(cluster, 8:10);
    deviationVelocity = spesification(cluster, 11:13);
    angularVelocityMagnitude = spesification(cluster, 14);
    angularVelocityDirection = spesification(cluster,15:17)./norm(spesification(cluster,15:17));
    
    % Generate nromaly distributed positions and velocities for particles
    % in cluster
    positions = zeros(particleCount, 3) + normrnd(repmat(averagePosition, particleCount, 1), repmat(deviationPosition, particleCount, 1));
    velocities = zeros(particleCount, 3) + normrnd(repmat(averageVelocity, particleCount, 1), repmat(deviationVelocity, particleCount, 1));
    
    % Adjust for angular momentum of cluster
    
    centreOfMass = mean(positions);
    
    relativePosition = positions - centreOfMass;
    
    angularVelocities = cross(relativePosition, velocities);
    averageAngularVelcocity = mean(angularVelocities);
    
    angularVelocityCorrection = mean(angularVelocities) - angularVelocityMagnitude * angularVelocityDirection;
    velocityCorrection = cross(repmat(angularVelocityCorrection, particleCount, 1), relativePosition).*abs(relativePosition).^-2;
    
    velocities = velocities + velocityCorrection;
    
    allPositions(index:index+particleCount-1,:) = positions; 
    allVelocities(index:index+particleCount-1,:) = velocities;
    index = index + particleCount;
end

append_to_csv(fileName, 0, allPositions, allVelocities);
