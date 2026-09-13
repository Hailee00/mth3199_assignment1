
funct = @test_function02;
x0_ref = 37.879;

x0_list = linspace(x0_ref-2, x0_ref+2, 1000);
x1_list = x0_list + 0.4;   

filter_list = [1e-15, 1e-2, 1e-14, 1e-2, 2];


% Newton's Method 
figure(1);
convergence_analysis(2, funct, x0_ref, x0_list, 0, filter_list)

% Secant Method 
figure(2);
convergence_analysis(3, funct, x0_ref, x0_list, x1_list, filter_list);









