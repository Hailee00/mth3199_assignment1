%Note that fun(x) should output [f,dfdx], where dfdx is the derivative of f
%Root finding function via Newton's method
%INPUTS:
% fun: the function we are computing the root of
% Note that fun(x) should output [f,dfdx], where dfdx is the derivative of f
% (see test_func01 below for example)
% x0: initial guess for Newton's method
% dxtol: termination threshold (stop when interval abs(x_{i+1}-x_i) < dxtol)
% ftol: termination threshold (stop when abs(f(x_{i}))<ftol
% max_iter: maximum iteration limit
% dxmax: threshold for checking for a divide by zero error:
% terminate when abs(x_{i+1}-x_i) > dxmax, where dxmax is a very large number
%OUTPUTS
% x: estimate for root of fun

function x = newton_solver(fun,x0, max_iter, ftol, dxtol, dxmax)

    for N = 1:max_iter
        
        [fun_x0, dif_fun_x0] = fun(x0);

        x_next = x0 - (fun_x0 / dif_fun_x0);

        if (abs(fun_x0) < ftol)
            break
        end
        if (abs(x_next - x0) < dxtol)
            break
        end
        if (abs(x_next - x0) > dxmax)
            break
        end

        x0 = x_next;

    end 
    
    x = x0;

end