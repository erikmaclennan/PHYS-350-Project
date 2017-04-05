
function [position, velocity] = backward_euler(position,velocity,delta_t,n_steps,global_force,local_force)
    [n, ~] = size(position);
    I = eye(n);
    position = position';
    velocity = velocity';
    
    FPUs = 1;
    
    for i = 1:n_steps
        pt_plus1 = position;
        vt_plus1 = velocity;
        for j = 1:FPUs
            x_pos = zeros(n) + pt_plus1(1,:);
            x_dist = x_pos-x_pos';
            y_pos = zeros(n) + pt_plus1(2,:);
            y_dist = y_pos-y_pos';
            z_pos = zeros(n) + pt_plus1(3,:);
            z_dist = z_pos-z_pos';
            dist = (x_dist.^2+y_dist.^2+z_dist.^2).^0.5+I;

            abs_dist = (pt_plus1(1,:).^2+pt_plus1(2,:).^2+pt_plus1(3,:).^2).^0.5;
            abs_force_mag = global_force(abs_dist);

            x_hat = x_dist./dist;
            y_hat = y_dist./dist;
            z_hat = z_dist./dist;

            abs_x_hat = pt_plus1(1,:)./abs_dist;
            abs_y_hat = pt_plus1(2,:)./abs_dist;
            abs_z_hat = pt_plus1(3,:)./abs_dist;

            force_mag = local_force(dist);

            force_mag(logical(I)) = 0;
            
            dvx = delta_t.*(sum(force_mag.*x_hat) + abs_force_mag.*abs_x_hat);
            dvy = delta_t.*(sum(force_mag.*y_hat) + abs_force_mag.*abs_y_hat);
            dvz = delta_t.*(sum(force_mag.*z_hat) + abs_force_mag.*abs_z_hat);

            vt_plus1(1,:) = velocity(1,:) + dvx;
            vt_plus1(2,:) = velocity(2,:) + dvy;
            vt_plus1(3,:) = velocity(3,:) + dvz;

        pt_plus1 = (position+vt_plus1.*delta_t);
        end
        position = pt_plus1;
        velocity = vt_plus1;
    end
    position = position';
    velocity = velocity';
end