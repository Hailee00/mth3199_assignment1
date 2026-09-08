%Root finding function via bisection algorithm
%INPUTS:
% fun: the function we are computing the root of
% x_left: left guess
% x_right: right guess
% note that f(x_left) and f(x_right) should have different signs
% dxtol: termination threshold (stop when interval x_right-x_left < dxtol)
% ftol: termination threshold (stop when abs(f(x_guess))<ftol
% max_iter: maximum iteration limit
%OUTPUTS
% x: estimate for root of fun

function x = bisection_solver(fun, x_left, x_right, max_iter, ftol, dxtol)
    fun_left = fun(x_left);
    fun_right = fun(x_right);


    for N = 1:max_iter
     
        m_n = (x_left + x_right) / 2;
        fun_mn = fun(m_n);
    
        if ( ((fun_left > 0) && (0 > fun_mn)) || ((fun_left < 0) && (0 < fun_mn)) )
            x_right = m_n;
            fun_right = fun_mn;
        end
        if ( ((fun_mn > 0) && (0 > fun_right)) || ((fun_mn < 0) && (0 < fun_right)) )
            x_left = m_n;
            fun_left = fun_mn;
        end

        if abs(fun_mn)<ftol
            break
        end
        if (abs(x_right-x_left) < dxtol)
            break
        end
    end
    
    x = m_n;
        
end