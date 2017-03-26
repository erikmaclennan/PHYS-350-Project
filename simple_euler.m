function [positions,velocities]=simple_euler(...
    positions,velocities,delta_t,n_steps,global_potential,local_potential)
    [n, ~] = size(positions);
    I = eye(n);
    positions = positions';
    velocities = velocities';
    
    for i= 1:n_steps
        x_pos = zeros(n) + positions(1,:);
        x_dist = x_pos-x_pos';
        y_pos = zeros(n) + positions(2,:);
        y_dist = y_pos-y_pos';
        z_pos = zeros(n) + positions(3,:);
        z_dist = z_pos-z_pos';
        dist = (x_dist.^2+y_dist.^2+z_dist.^2).^0.5+I;

        abs_dist = (x_pos.^2+y_pos.^2+z_pos.^2).^0.5;
        abs_force_mag = global_potential(abs_dist);

        x_hat = x_dist./dist;
        y_hat = y_dist./dist;
        z_hat = z_dist./dist;

        abs_x_hat = x_pos./abs_dist;
        abs_y_hat = y_pos./abs_dist;
        abs_z_hat = z_pos./abs_dist;

        force_mag = local_potential(dist);

        force_mag(logical(I)) = 0;

        velocities(1,:) = velocities(1,:) + delta_t.*sum(force_mag.*x_hat);
        velocities(2,:) = velocities(2,:) + delta_t.*sum(force_mag.*y_hat);
        velocities(3,:) = velocities(3,:) + delta_t.*sum(force_mag.*z_hat);

        velocities(1,:) = velocities(1,:) + delta_t.*sum(abs_force_mag.*abs_x_hat);
        velocities(2,:) = velocities(2,:) + delta_t.*sum(abs_force_mag.*abs_y_hat);
        velocities(3,:) = velocities(3,:) + delta_t.*sum(abs_force_mag.*abs_z_hat);

        positions = (positions+velocities.*delta_t);
    end
    
    positions = positions';
    velocities = velocities';
end