%Runge-Kutta Method

function [position, velocity] = rk4(position,velocity,delta_t,n_steps,global_force,local_force,friction)
    for n=i:n_steps
        %compute k1
        positions1 = position;
        velocities1 = velocity;
        [k1_vel,k1_acc]=compute_vel_acc(positions1,velocities1,global_force,local_force,friction);

        %compute k2
        positions2 = position+k1_vel.*delta_t/2;
        velocities2 = velocity+k1_acc.*delta_t/2;
        [k2_vel,k2_acc]=compute_vel_acc(positions2,velocities2,global_force,local_force,friction);

        %compute k3
        positions3 = position+k2_vel.*delta_t/2;
        velocities3 = velocity+k2_acc.*delta_t/2;
        [k3_vel,k3_acc]=compute_vel_acc(positions3,velocities3,global_force,local_force,friction);

        %compute k4
        positions4 = position+k3_vel.*delta_t;
        velocities4 = velocity+k3_acc.*delta_t;
        [k4_vel,k4_acc]=compute_vel_acc(positions4,velocities4,global_force,local_force,friction);

        %compute next position and velocity
        position = position + delta_t./6.*(k1_vel+2.*k2_vel+2.*k3_vel+k4_vel);
        velocity = velocity + delta_t./6.*(k1_acc+2.*k2_acc+2.*k3_acc+k4_acc);
    end

end
