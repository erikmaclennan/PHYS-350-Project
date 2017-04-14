function [vel,acc]=compute_vel_acc(positions,velocities,global_force,local_force,friction)
    [n, ~] = size(positions);
    I = eye(n);
    positions = positions';
    velocities = velocities';
    
    x_pos = zeros(n) + positions(1,:);
    x_dist = x_pos-x_pos';
    y_pos = zeros(n) + positions(2,:);
    y_dist = y_pos-y_pos';
    z_pos = zeros(n) + positions(3,:);
    z_dist = z_pos-z_pos';

    dist = (x_dist.^2+y_dist.^2+z_dist.^2).^0.5+I;

    abs_dist = (positions(1,:).^2+positions(2,:).^2+positions(3,:).^2).^0.5;
    abs_force_mag = global_force(abs_dist);

    x_hat = x_dist./dist;
    y_hat = y_dist./dist;
    z_hat = z_dist./dist;

    abs_x_hat = positions(1,:)./abs_dist;
    abs_y_hat = positions(2,:)./abs_dist;
    abs_z_hat = positions(3,:)./abs_dist;

    force_mag = local_force(dist);

    force_mag(logical(I)) = 0;

    x_vel = zeros(n) + velocities(1,:);
    x_rel_vel = x_vel-x_vel';
    y_vel = zeros(n) + velocities(2,:);
    y_rel_vel = y_vel-y_vel';
    z_vel = zeros(n) + velocities(3,:);
    z_rel_vel = z_vel-z_vel';
        
    proj_v_rel_and_r_rel = x_rel_vel.*x_hat+y_rel_vel.*y_hat+z_rel_vel.*z_hat;

    acc = zeros(size(velocities));
    vel = zeros(size(positions));

    acc(1,:) = acc(1,:) + sum(proj_v_rel_and_r_rel*-1*friction.*x_hat);
    acc(2,:) = acc(2,:) + sum(proj_v_rel_and_r_rel*-1*friction.*y_hat);
    acc(3,:) = acc(3,:) + sum(proj_v_rel_and_r_rel*-1*friction.*z_hat);

    acc(1,:) = acc(1,:) + sum(force_mag.*x_hat);
    acc(2,:) = acc(2,:) + sum(force_mag.*y_hat);
    acc(3,:) = acc(3,:) + sum(force_mag.*z_hat);

    acc(1,:) = acc(1,:) + abs_force_mag.*abs_x_hat;
    acc(2,:) = acc(2,:) + abs_force_mag.*abs_y_hat;
    acc(3,:) = acc(3,:) + abs_force_mag.*abs_z_hat;

    vel = velocities;
    
    vel = vel';
    acc = acc';
end
