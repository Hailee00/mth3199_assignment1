%Root finding function via secant method
%INPUTS:
% fun: the function we are computing the root of
% x0: first guess for secant method
% x1: second guess for secant method
% dxtol: termination threshold (stop when interval abs(x_{i+1}-x_i) < dxtol)
% ftol: termination threshold (stop when abs(f(x_{i}))<ftol
% max_iter: maximum iteration limit
% dxmax: threshold for checking for a divide by zero error:
% terminate when abs(x_{i+1}-x_i) > dxmax, where dxmax is a very large number
%OUTPUTS
% x: estimate for root of fun

function x = secant_solver(fun,x0, x1, max_iter, ftol, dxtol, dxmax)


   fun_x1 = fun(x1); %n-1
   fun_x0 = fun(x0); %n-2

   for N = 1:max_iter
       if (abs(fun_x1 - fun_x0) < ftol)
            break
        end
    
       frac = (x1 - x0) / (fun_x1 - fun_x0);
       x_n = x1 - fun_x1 * frac;
       fun_xn = fun(x_n);
    
       if (abs(fun_xn) < ftol)
           break
       end
        if (abs(x_n - x1) < dxtol)
            break
        end
        if (abs(x_n - x1) > dxmax)
            break
        end

       x0 = x1;
       fun_x0 = fun_x1;
       x1 = x_n;
       fun_x1 = fun_xn;

   end

   x = x1;
  
end
