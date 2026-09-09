function [x_left,x_right] = bisection_range(fun,x0,max_iter,ftol,dxtol)

    step = 5;
    x_left = x0 - step;
    x_right = x0 + step;

    for n = 1:max_iter
        f_left = fun(x_left);
        f_right = fun(x_right);

        if abs(f_left) < ftol
            return
        end
        if abs(f_right) < ftol
            return
        end

        if f_left * f_right < 0
            return
        end

        step = step + 0.1;
        x_left = x0 - step;
        x_right = x0 + step;

        if abs(x_right - x_left) < dxtol
            return
        end
    end

    x_left = NaN;
    x_right = NaN;

end