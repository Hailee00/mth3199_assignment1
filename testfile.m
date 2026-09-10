
x0_ref = 0.5;
x0_list = linspace(x0_ref-2,x0_ref+2,1000);
x1_list = x0_list + .05; % Secant
filter_list = [1e-15, 1e-2, 1e-14, 1e-2, 2];


convergence_analysis(4, @test_func01, x0_ref, x0_list, 0, filter_list)

