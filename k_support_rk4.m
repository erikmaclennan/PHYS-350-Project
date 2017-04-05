function [dist, abs_dist, x_hat, y_hat, z_hat, abs_x_hat, abs_y_hat, abs_z_hat] = k_support_rk4(position,n,k_factor)
I = eye(n);
x_pos = zeros(n,n) + position(:,1) + k_factor(:,1);
x_dist = x_pos-x_pos';
y_pos = zeros(n,n) + position(:,2) + k_factor(:,2);
y_dist = y_pos-y_pos';
z_pos = zeros(n,n) + position(:,3) + k_factor(:,3);
z_dist = z_pos-z_pos';

dist = (x_dist.^2+y_dist.^2+z_dist.^2).^0.5+I;

abs_dist = (position(:,1).^2+position(:,2).^2+position(:,3).^2).^0.5;

x_hat = x_dist./dist;
y_hat = y_dist./dist;
z_hat = z_dist./dist;
    
abs_x_hat = position(:,1)./abs_dist;
abs_y_hat = position(:,2)./abs_dist;
abs_z_hat = position(:,3)./abs_dist;

end