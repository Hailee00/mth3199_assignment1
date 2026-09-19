%Function that computes the collision time for a thrown egg
%INPUTS:
%traj_fun: a function that describes the [x,y,theta] trajectory
% of the egg (takes time t as input)
%egg_params: a struct describing the hyperparameters of the oval
%y_ground: height of the ground
%x_wall: position of the wall
%OUTPUTS:
%t_ground: time that the egg would hit the ground
%t_wall: time that the egg would hit the wall
function [t_ground,t_wall] = collision_func(traj_fun, egg_params, y_ground, x_wall)

    dxtol = 1e-12;
    ftol = 1e-12;
    max_iter = 200;
    dxmax = 1e10;
    % ground

    dt = 0.05;

    difference = @(t) wall_ground_diff(t, traj_fun, egg_params, y_ground, x_wall);
    
    t_0 = 0;
    [~, y_0] = difference(t_0);
    t_1 = dt;
    [~, y_1] = difference(t_1);

    while sign(y_0) == sign(y_1) 
        t_0 = t_1;
        [~,y_0] = difference(t_0);
        t_1 = dt + t_1;
        [~, y_1] = difference(t_1);
    end
    
    t_ground = bisection_solver(difference, t_0, t_1, max_iter, ftol, dxtol);

    t_0 = 0;
    [x_0, ~] = difference(t_0);
    t_1 = dt;
    [x_1, ~] = difference(t_1);

    while sign(x_0) == sign(x_1) 
        t_0 = t_1;
        [x_0,~] = difference(t_0);
        t_1 = dt + t_1;
        [x_1, ~] = difference(t_1);
    end

    t_wall = bisection_solver(difference, t_0, t_1, max_iter, ftol, dxtol);


end


function [x_diff, y_diff] = wall_ground_diff(t, traj_fun, egg_params, y_ground, x_wall)
    [x0,y0,theta] = traj_fun(t);
    [x_range, y_range] = compute_bounding_box(x0,y0,theta,egg_params);
    y_diff = y_range(1) - y_ground;
    x_diff = x_range(2) - x_wall;
end


