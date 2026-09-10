%Example template for analysis function
%INPUTS:
%solver_flag: an integer from 1-4 indicating which solver to use
% 1->Bisection 2-> Newton 3->Secant 4->fzero
%fun: the mathematical function that we are using the
% solver to compute the root of
%x_guess0: the initial guess used to compute x_root
%guess_list1: a list of initial guesses for each trial
%guess_list2: a second list of initial guesses for each trial
% if guess_list2 is not needed, then set to zero in input
%filter_list: a list of constants used to filter the collected data
function convergence_analysis(solver_flag, fun, ...
    x_guess0, guess_list1, guess_list2, filter_list)

    target_root = fzero(fun,x_guess0);

    %Create an instance of the input_recorder
    my_recorder = input_recorder();
    
    %Use input_recorder to generate a version of the test function
    %that records the input after every iteration
    %Since test_fun is defined using function keyword
    f_record = my_recorder.generate_recorder_fun(fun);

    %number of trials we would like to perform
    num_iter = 1000;

    %solver parameters
    dxtol = 1e-12;
    ftol = 1e-12;
    max_iter = 200;
    dxmax = 1e10;

    %list of estimate at current iteration (x_{n})
    %compiled across all trials
    x_current_list = [];
    
    %list of estimate at next iteration (x_{n+1})
    %compiled across all trials
    x_next_list = [];
    
    %keeps track of which iteration (n) in a trial 
    %each data point was collected from
    index_list = [];
    
    %loop through each trial
    for n = 1:num_iter
        %pull out the left and right guess for the trial
        x0 = guess_list1(n);
        my_recorder.clear_input_list();
        
        switch solver_flag
            case 1
                [x_left,x_right] = bisection_range(fun,x0,max_iter,ftol,dxtol);
                x_root = bisection_solver(f_record, x_left, x_right, max_iter, ftol, dxtol);

            case 2
                x_root = newton_solver(f_record, x0, max_iter, ftol, dxtol, dxmax);
           
            case 3
                x1 = guess_list2(n);
                x_root = secant_solver(f_record, x0, x1, max_iter, ftol, dxtol, dxmax);

            case 4
                x_root = fzero(f_record, x0);
        end

        %See what input values were used when f_record was called:
        input_list = my_recorder.get_input_list();
    
        %at this point, input_list will be populated with the values that
        %the solver called at each iteration.
        %In other words, it is now [x_1,x_2,...x_n-1,x_n]
    
        %append the collected data to the compilation
        x_current_list = [x_current_list,input_list(1:end-1)];
        x_next_list = [x_next_list,input_list(2:end)];
        index_list = [index_list,1:length(input_list)-1];
    end

    %At this point, x_current_list corresponds to many many
    %measurements of x_{n} across many trials
    %and x_next_list corresponds to many many measurements of
    %the corresponding value of x_{n+1} across many trials
    %this is the data the you want to clean and analaze

    %compute the absolute value of the error for current/next iteration
    abs_error_current = abs(x_current_list-target_root);
    abs_error_next = abs(x_next_list-target_root);

    %data points to be used in the regression
    x_regression = []; % e_n
    y_regression = []; % e_{n+1}

    for n=1:length(index_list)
    %if the error is not too big or too small
    %and it was enough iterations into the trial...
        if abs_error_current(n)>filter_list(1) && abs_error_current(n)<filter_list(2) && ...
        abs_error_next(n)>filter_list(3) && abs_error_next(n)<filter_list(4) && ...
        index_list(n)>filter_list(5)
            %then add it to the set of points for regression
            x_regression(end+1) = abs_error_current(n);
            y_regression(end+1) = abs_error_next(n);
        end
    end

    [p, k] = generate_error_fit(x_regression,y_regression);
    %example for how to plot fit line
    %generate x data on a logarithmic range
    fit_line_x = 10.^[-16:.01:1];
    %compute the corresponding y values
    fit_line_y = k*fit_line_x.^p;

    %generate a loglog plot
    loglog(abs_error_current,abs_error_next,...
        'ro','markerfacecolor','r','markersize',2);
    % plot filtered data
    hold on
    loglog(x_regression, y_regression,...
        'bo','markerfacecolor','b','markersize',4);
     %plot on a loglog plot.
    loglog(fit_line_x,fit_line_y,'k-','linewidth',2);

    %window limits
    axis([1e-18 1e2 1e-18 1e2])
    %axis labels
    xlabel('$\epsilon_{n}$ (-)','Interpreter','latex', 'FontSize', 24 )
    ylabel('$\epsilon_{n+1}$ (-)','Interpreter','latex', 'FontSize', 24 )
    legend('Raw Data', 'Filtered Data', 'Fit Line', 'Location', 'northwest')

    switch solver_flag
        case 1
            title('Bisection Method - Error Data with Fit', 'FontSize', 16)

            disp("Bisection Method")
            disp('Predicted p = 1')
            disp(['Measured p = ', num2str(p)])
            disp('Predicted k = 0.5')
            disp(['Measured k = ', num2str(k)])

        case 2
            title('Netwon''s Method - Error Data with Fit', 'FontSize', 16)

            [dfdx,d2fdx2] = approximate_derivative(@test_func01, target_root);
            k_predict = abs(.5*(d2fdx2 / dfdx));

            disp("Newton's Method")
            disp(['Predicted k = ', num2str(k_predict)])
            disp(['Measured k = ', num2str(k)])
            disp('Predicted p = 2')
            disp(['Measured p = ', num2str(p)])

        case 3
            title('Secant Method - Error Data with Fit', 'FontSize', 16)

            disp("Secant Method")
            disp('Predicted p = 1.618')
            disp(['Measured p = ', num2str(p)])
            disp(['Measured k = ', num2str(k)])

        case 4
            title('Fzero - Error Data with Fit', 'FontSize', 16)

            disp("Fzero Method")
            disp(['Measured p = ', num2str(p)])
            disp(['Measured k = ', num2str(k)])

    end
end


%Definition of the test function and its derivative (as a single function):
%This definition uses the function keyword
%when passing this function as an argument to a solver,
%you'll need to use the handle operator
%ex. solver(@test_func01,x_guess)
function [fval,dfdx] = test_func01(x)
    fval = (x.^3)/100 - (x.^2)/8 + 2*x + 6*sin(x/2+6) -.7 - exp(x/6);
    dfdx = 3*(x.^2)/100 - 2*x/8 + 2 +(6/2)*cos(x/2+6) - exp(x/6)/6;
end

%example for how to compute the fit line
%data points to be used in the regression
%x_regression -> e_n
%y_regression -> e_{n+1}
%p and k are the output coefficients
function [p,k] = generate_error_fit(x_regression,y_regression)
    %generate Y, X1, and X2
    %note that I use the transpose operator (')
    %to convert the result from a row vector to a column
    %If you are copy-pasting, the ' character may not work correctly
    Y = log(y_regression)';
    X1 = log(x_regression)';
    X2 = ones(length(X1),1);
    %run the regression
    coeff_vec = regress(Y,[X1,X2]);
    %pull out the coefficients from the fit
    p = coeff_vec(1);
    k = exp(coeff_vec(2));
end


%example of how to implement finite difference approximation
%for the first and second derivative of a function
%INPUTS:
%fun: the mathetmatical function we want to differentiate
%x: the input value of fun that we want to compute the derivative at
%OUTPUTS:
%dfdx: approximation of fun'(x)
%d2fdx2: approximation of fun''(x)
function [dfdx,d2fdx2] = approximate_derivative(fun,x)
    %set the step size to be tiny
    delta_x = 1e-6;
    %compute the function at different points near x
    f_left = fun(x-delta_x);
    f_0 = fun(x);
    f_right = fun(x+delta_x);
    %approximate the first derivative
    dfdx = (f_right-f_left)/(2*delta_x);
    %approximate the second derivative
    d2fdx2 = (f_right-2*f_0+f_left)/(delta_x^2);
end
