%Function that computes the bounding box of an oval
%INPUTS:
%theta: rotation of the oval. theta is a number from 0 to 2*pi.
%x0: horizontal offset of the oval
%y0: vertical offset of the oval
%egg_params: a struct describing the hyperparameters of the oval
%OUTPUTS:
%x_range: the x limits of the bounding box in the form [x_min,x_max]
%y_range: the y limits of the bounding box in the form [y_min,y_max]
function [x_range,y_range] = compute_bounding_box(x0,y0,theta,egg_params)
    %max_iter, ftol, dxtol, dxmax
    dxtol = 1e-12;
    ftol = 1e-12;
    max_iter = 200;
    dxmax = 1e10;

    egg_wrapper3 = @(s) egg_wrapper1(s,x0,y0,theta,egg_params);
    

    
end