%Runge-Kutta Method

function [positions, velocities] = rk4(position,velocity,delta_t,n_steps,global_potential,local_potential,friction)
%Number of particles
[n, ~] = size(position);
positions = zeros(n,3,n_steps);
velocities = zeros(n,3,n_steps);

k_factor = zeros(n,3);
[dist, abs_dist, x_hat, y_hat, z_hat, abs_x_hat, abs_y_hat, abs_z_hat] = k_support_rk4(position,n,k_factor);

k1 = zeros(n,3);
k1(:,1) = (-1)*sum(local_potential(dist).*x_hat)' + global_potential(abs_dist).*abs_x_hat; 
k1(:,2) = (-1)*sum(local_potential(dist).*y_hat)' + global_potential(abs_dist).*abs_y_hat;  
k1(:,3) =  (-1)*sum(local_potential(dist).*z_hat)' + global_potential(abs_dist).*abs_z_hat; 

%%
%Calculate k2
k_factor(:,1) = (delta_t/2).*k1(:,1); 
k_factor(:,2) = (delta_t/2).*k1(:,2);
k_factor(:,3) = (delta_t/2).*k1(:,3);
[dist, abs_dist, x_hat, y_hat, z_hat, abs_x_hat, abs_y_hat, abs_z_hat] = k_support_rk4(position,n,k_factor);

k2 = zeros(n,3);
k2(:,1) = (-1)*sum(local_potential(dist).*x_hat)' + global_potential(abs_dist).*abs_x_hat; 
k2(:,2) = (-1)*sum(local_potential(dist).*y_hat)' + global_potential(abs_dist).*abs_y_hat;  
k2(:,3) =  (-1)*sum(local_potential(dist).*z_hat)' + global_potential(abs_dist).*abs_z_hat; 

%%
%Calculate k3
k_factor(:,1) = (delta_t/2).*k2(:,1); 
k_factor(:,2) = (delta_t/2).*k2(:,2);
k_factor(:,3) = (delta_t/2).*k2(:,3);
[dist, abs_dist, x_hat, y_hat, z_hat, abs_x_hat, abs_y_hat, abs_z_hat] = k_support_rk4(position,n,k_factor);

k3 = zeros(n,3);
k3(:,1) = (-1)*sum(local_potential(dist).*x_hat)' + global_potential(abs_dist).*abs_x_hat; 
k3(:,2) = (-1)*sum(local_potential(dist).*y_hat)' + global_potential(abs_dist).*abs_y_hat;  
k3(:,3) =  (-1)*sum(local_potential(dist).*z_hat)' + global_potential(abs_dist).*abs_z_hat; 
%%
%Calculate k4
k_factor(:,1) = (delta_t)*k3(:,1); 
k_factor(:,2) = (delta_t)*k3(:,2);
k_factor(:,3) = (delta_t)*k3(:,3);
[dist, abs_dist, x_hat, y_hat, z_hat, abs_x_hat, abs_y_hat, abs_z_hat] = k_support_rk4(position,n,k_factor);

k4 = zeros(n,3);
k4(:,1) = (-1)*sum(local_potential(dist).*x_hat)' + global_potential(abs_dist).*abs_x_hat; 
k4(:,2) = (-1)*sum(local_potential(dist).*y_hat)' + global_potential(abs_dist).*abs_y_hat;  
k4(:,3) =  (-1)*sum(local_potential(dist).*z_hat)' + global_potential(abs_dist).*abs_z_hat; 

%%
%Compute next time step
positions(:,:,1) = position + ((velocity*delta_t)/6)*(6 + 3*delta_t + (delta_t)^2 + ((delta_t^3)/4));
velocities(:,:,1) = velocity + (delta_t/6)*(k1 + 2*k2 + 2*k3 + k4);

%%
    if (n_steps > 1)
        for i = 2:(n_steps)
        %Compute k Factors
        %k1
        k_factor = zeros(n,3);
        [dist, abs_dist, x_hat, y_hat, z_hat, abs_x_hat, abs_y_hat, abs_z_hat] = k_support_rk4(positions(:,:,i-1),n,k_factor);

        k1 = zeros(n,3);
        k1(:,1) = (-1)*sum(local_potential(dist).*x_hat)' + global_potential(abs_dist).*abs_x_hat; 
        k1(:,2) = (-1)*sum(local_potential(dist).*y_hat)' + global_potential(abs_dist).*abs_y_hat;
        k1(:,3) =  (-1)*sum(local_potential(dist).*z_hat)' + global_potential(abs_dist).*abs_z_hat; 

        k_factor(:,1) = (delta_t/2)*k1(:,1);
        k_factor(:,2) = (delta_t/2)*k1(:,2);
        k_factor(:,3) = (delta_t/2)*k1(:,3);
        [dist, abs_dist, x_hat, y_hat, z_hat, abs_x_hat, abs_y_hat, abs_z_hat] = k_support_rk4(positions(:,:,i-1),n,k_factor);
        %k2
        k2 = zeros(n,3);
        k2(:,1) = (-1)*sum(local_potential(dist).*x_hat)' + global_potential(abs_dist).*abs_x_hat; 
        k2(:,2) = (-1)*sum(local_potential(dist).*y_hat)' + global_potential(abs_dist).*abs_y_hat;  
        k2(:,3) =  (-1)*sum(local_potential(dist).*z_hat)' + global_potential(abs_dist).*abs_z_hat; 

        k_factor(:,1) = (delta_t/2)*k2(:,1); 
        k_factor(:,2) = (delta_t/2)*k2(:,2);
        k_factor(:,3) = (delta_t/2)*k2(:,3);
        [dist, abs_dist, x_hat, y_hat, z_hat, abs_x_hat, abs_y_hat, abs_z_hat] = k_support_rk4(positions(:,:,i-1),n,k_factor);
        %k3
        k3 = zeros(n,3);
        k3(:,1) = (-1)*sum(local_potential(dist).*x_hat)' + global_potential(abs_dist).*abs_x_hat; 
        k3(:,2) = (-1)*sum(local_potential(dist).*y_hat)' + global_potential(abs_dist).*abs_y_hat;  
        k3(:,3) =  (-1)*sum(local_potential(dist).*z_hat)' + global_potential(abs_dist).*abs_z_hat; 
    
        k_factor(:,1) = (delta_t)*k3(:,1); 
        k_factor(:,2) = (delta_t)*k3(:,2);
        k_factor(:,3) = (delta_t)*k3(:,3);
        [dist, abs_dist, x_hat, y_hat, z_hat, abs_x_hat, abs_y_hat, abs_z_hat] = k_support_rk4(positions(:,:,i-1),n,k_factor);
        %k4
        k4 = zeros(n,3);
        k4(:,1) = (-1)*sum(local_potential(dist).*x_hat)' + global_potential(abs_dist).*abs_x_hat; 
        k4(:,2) = (-1)*sum(local_potential(dist).*y_hat)' + global_potential(abs_dist).*abs_y_hat;  
        k4(:,3) =  (-1)*sum(local_potential(dist).*z_hat)' + global_potential(abs_dist).*abs_z_hat; 
        
        %Compute the next time step
        positions(:, :,i) = positions(:,:,i-1) + ((velocities(:,:,i-1)*delta_t)/6)*(6 + 3*delta_t + (delta_t)^2 + ((delta_t^3)/4));
        velocities(:,:,i) =  velocities(:,:,i-1) + (delta_t/6)*(k1 + 2*k2 + 2*k3 + k4);
        end
    end
end