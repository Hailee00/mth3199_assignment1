
func = @test_function03;

dxtol = 1e-12;
ftol = 1e-12;
max_iter = 200;
dxmax = 1e10;

x_root = fzero(func, 25); 
x_range = [0, 50];

tolerance = 1e-04;


% Newton's Method 

x_list = linspace(x_range(1), x_range(2), 500);
x_valid = zeros(size(x_list));

for i = 1:length(x_list)

    x_vals = newton_solver(func, x_list(i), max_iter, ftol, dxtol, dxmax);
    x_valid(i) = abs(x_vals - x_root) < tolerance;

end 

fval = func(x_list);

valid = x_valid == 1;
invalid = x_valid == 0;

figure;
scatter(x_list(valid), fval(valid), 10, 'g', 'filled')
hold on;
scatter(x_list(invalid), fval(invalid), 10, 'r', 'filled')
plot(x_root, 0, 'b.', 'MarkerSize', 15)
yline(0, 'k--')
legend('Successful', 'Unsuccessful', 'Root', 'Location','northwest', 'Interpreter', 'latex', 'FontSize', 14 );
xlabel('Initial guess, $x_0$ (-)', 'Interpreter', 'latex', 'FontSize', 16);
ylabel('Sigmoid Function, $f(x_0)$ (-)', 'Interpreter', 'latex', 'FontSize', 16)

title("Newton's Method Sigmoid Function Initial Guess Convergence",'Interpreter', 'latex', 'FontSize', 18)
axis([0 50 -4 6])



% Fzero Method

x_valid = zeros(size(x_list));

for i = 1:length(x_list)

    x_vals = fzero(func, x_list(i));
    x_valid(i) = abs(x_vals - x_root) < tolerance;

end 

fval = func(x_list);

valid = x_valid == 1;
invalid = x_valid == 0;

figure;
scatter(x_list(valid), fval(valid), 10, 'g', 'filled')
hold on;
scatter(x_list(invalid), fval(invalid), 10, 'r', 'filled')
plot(x_root, 0, 'b.', 'MarkerSize', 15)
yline(0, 'k--')
legend('Successful', 'Unsuccessful', 'Root', 'Location','northwest', 'Interpreter', 'latex', 'FontSize', 16 );
xlabel('Initial guess, $x0$ (-)', 'Interpreter', 'latex', 'FontSize', 16);
ylabel('Sigmoid Function, $f(x0)$ (-)', 'Interpreter', 'latex', 'FontSize', 16)


title("Fzero Method Sigmoid Function Initial Guess Convergence", 'Interpreter', 'latex', 'FontSize', 18)
axis([0 50 -4 6])


% Secant Method

x0_list = linspace(x_range(1), x_range(2), 500);
x1_list = linspace(x_range(1), x_range(2), 500);
[X0, X1] = meshgrid(x0_list, x1_list);

x_valid = zeros(size(X1));

for i = 1:numel(X0)
   x_vals = secant_solver(func, X0(i), X1(i), max_iter, ftol, dxtol, dxmax);
   x_valid(i) = abs(x_vals - x_root) < tolerance;

end

valid = x_valid == 1;
invalid = x_valid == 0;

figure;
plot(X0(valid), X1(valid), 'g.')
hold on;
plot(X0(invalid), X1(invalid), 'r.')
plot(x_root, x_root, 'b.', 'MarkerSize', 20)
yline(x_root, 'k--', 'LineWidth', 2)
xline(x_root, 'k--', 'LineWidth', 2)


legend('Successful Guess', 'Failed Guess', 'Function Root', 'Interpreter', 'latex', 'Fontsize', 14);


ax = gca;
ax.YDir = 'normal';
xlabel('Initial guess, $x_0$ (-)', 'Interpreter', 'latex', 'FontSize', 16);
ylabel('Sigmoid Function, $f(x_0)$ (-)', 'Interpreter', 'latex', 'FontSize', 16)
title("Secant Method Sigmoid Function Initial Guess Convergence", 'Interpreter', 'latex', 'FontSize', 18)






