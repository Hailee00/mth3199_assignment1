

%set the oval hyper-parameters
egg_params = struct();
egg_params.a = 3; egg_params.b = 2; egg_params.c = .15;
%specify the position and orientation of the egg
x0 = 5; y0 = 5; theta = pi/6;
%wrapper function that calls egg_wrapper1
%but only takes s as an input (other inputs are fixed)
%(single input)
egg_wrapper3 = @(s) egg_wrapper1(s,x0,y0,theta,egg_params);


%max_iter, ftol, dxtol, dxmax
dxtol = 1e-12;
ftol = 1e-12;
max_iter = 200;
dxmax = 1e10;

%% x val 

% initial guesses - 0, .25, .5, .75
guesses = [0, .25, .5, .75];
s_list = zeros(1, length(guesses));


for i = 1:length(guesses)
    s_root = secant_solver(egg_wrapper3, guesses(i), guesses(i)+.01, max_iter, ftol, dxtol, dxmax);
    s_list(i) = s_root
end
s_list = mod(s_list, 1)
s_sorted = sort(s_list)
x_vals = [min(s_list), max(s_list)]
%% y val
egg_wrapper4 = @(s) egg_wrapper2(s,x0,y0,theta,egg_params);
guesses = [0, .25, .5, .6];
s_list2 = zeros(1, length(guesses));


for i = 1:length(guesses)
    s_root = secant_solver(egg_wrapper4, guesses(i), guesses(i)+ .01, max_iter, ftol, dxtol, dxmax);
    s_list2(i) = s_root
end
%% plot egg 

egg_params = struct();
egg_params.a = 3; egg_params.b = 2; egg_params.c = .15;

x0 = 5; y0 = 5; theta = pi/6;
