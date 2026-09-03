%template for testing your basic root finding implementations
function basic_solver_with_tests_template()
    xvals = linspace(-50,50,201);
    [yvals,~] = test_func01(xvals);

    hold on
    axis([-15,40,-50,80]);
    plot(xvals,yvals,'r','linewidth',2);
    plot(xvals,0*xvals,'k--','linewidth',1);
    xlabel('x'); ylabel('y'); title('Test Function 1');

    % % %Newton's method example test
    % x0_guess = 2;
    % plot(x0_guess,test_func01(x0_guess),'bo','markerfacecolor','b','markersize',5);
    % 
    % x_sol = newton_solver(@test_func01,x0_guess);
    % plot(x_sol,test_func01(x_sol),'go','markerfacecolor','g','markersize',5);
    % % 

    % %Secant method example test
    % x0_guess = -5;
    % x1_guess = 2;
    % plot(x0_guess,test_func01(x0_guess),'bo','markerfacecolor','b','markersize',5);
    % plot(x1_guess,test_func01(x1_guess),'ko','markerfacecolor','k','markersize',5);
    % 
    % x_sol = secant_solver(@test_func01,x0_guess,x1_guess);
    % plot(x_sol,test_func01(x_sol),'go','markerfacecolor','g','markersize',5);

    
    % Bisection method example test
    x_left = -5;
    x_right = 2;
    plot(x_left,test_func01(x_left),'bo','markerfacecolor','b','markersize',5);
    plot(x_right,test_func01(x_right),'ko','markerfacecolor','k','markersize',5);

    x_sol = bisection_solver(@test_func01,x_left,x_right);
    plot(x_sol,test_func01(x_sol),'go','markerfacecolor','g','markersize',5);
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


function x = bisection_solver(fun,x_left,x_right)

    n = 100;

    for N = 1:n

        fun_left = fun(x_left);
        fun_right = fun(x_right);
        m_n = (x_left + x_right) / 2;
        fun_mn = fun(m_n);

        if ~((fun_left < 0 && 0 < fun_right) || (fun_left > 0 && 0 > fun_right)) 
            break
        end 

        if ( ((fun_left > 0) && (0 > fun_mn)) || ((fun_left < 0) && (0 < fun_mn)) )
            if abs(m_n-x_right) < 10e-14
                break
            end 
            x_right = m_n;
        end
    
        if ( ((fun_mn > 0) && (0 > fun_right)) || ((fun_mn < 0) && (0 < fun_right)) )
             if abs(m_n-x_left) < 10e-14
                break
            end 
            x_left = m_n;
        end

        if (abs(fun_mn) < 1e-14)
            break
        end

    end
    
    x = m_n;
        
end

%Note that fun(x) should output [f,dfdx], where dfdx is the derivative of f
function x = newton_solver(fun,x0)

    n = 100;
    for N = 1:n
        
        [fun_x0, dif_fun_x0] = fun(x0);

        x_next = x0 - (fun_x0 / dif_fun_x0);
        
        if dif_fun_x0 == 0
            break
        end 

        if abs(x_next - x0) < 10e-14
            break
        end
       
        x0 = x_next;

        if (abs(fun(x0)) < 10e-14)
            break
        end
    end 
    
    x = x0;

end

function x = secant_solver(fun,x0, x1)
    
   n = 100;
   for N = 1:n

       fun_x1 = fun(x1); %n-1
       fun_x0 = fun(x0); %n-2

       frac = (x1 - x0) / (fun_x1 - fun_x0)

       if (abs(fun_x1 - fun_x0) <  1e-3)
           break
       end
    
       x_n = x1 - fun_x1 * frac;
    
       if abs(x_n - x1) < 10e-14
           break
       end

       x0 = x1;
       x1 = x_n;

       if (abs(fun(x_n)) < 1e-14)
           break
       end

   end

   x = x1
   fun(x)
  
end




