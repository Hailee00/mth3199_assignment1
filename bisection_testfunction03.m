func = @test_function03;

%solver parameters
dxtol = 1e-12;
ftol = 1e-12;
max_iter = 200;
dxmax = 1e10;

tolerance = 1e-04;
value_range = [1 50];
left_x = linspace(value_range(1), value_range(2), 500);
right_x = linspace(value_range(1), value_range(2), 500);
x_guess0 = 25;
filter_list = [1e-15, 1e-2, 1e-14, 1e-2, 2];

[x_l,x_r] = meshgrid(left_x, right_x);
x_valid = zeros(size(x_l));

x_root = fzero(func, 25);



for i = 1:numel(x_l)

    x_vals = bisection_solver(func, x_l(i), x_r(i), max_iter, ftol, dxtol);
    x_valid(i) = abs(x_vals - x_root) < tolerance;
end

valid = x_valid == 1;
invalid = x_valid == 0;

plot(x_l(valid), x_r(valid), '.','Color', [0.1 0.5 0.1], 'MarkerSize', 5)
hold on

set(gca, 'FontSize', 16)
plot(x_l(invalid), x_r(invalid), 'r.','Color', [0.6 0.1 0.1],'MarkerSize', 5)
plot(x_root, x_root, 'c.', 'MarkerSize', 20)
yline(x_root, 'k--', 'LineWidth', 3)
xline(x_root, 'k--', 'LineWidth', 3)
title('Bisection Method Sigmoid Function Initial Guess Convergence', 'Interpreter', 'latex', 'FontSize', 20)
xlabel('Initial left guess (-)', 'Interpreter', 'latex', 'Fontsize', 18)
ylabel('Initial right guess (-)', 'Interpreter', 'latex', 'FontSize', 18)
legend('Successful Guess', 'Failed Guess', 'Function Root','Interpreter', 'latex','FontSize', 14)
axis([1 50 1 50])
