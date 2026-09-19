egg_params = struct();
egg_params.a = 3; egg_params.b = 2; egg_params.c = .15;
y_ground = 0;
x_wall = 40;

[t_ground, t_wall] = collision_func(@egg_trajectory01, egg_params, y_ground, x_wall);
t_end = min(t_ground, t_wall);

egg_video(@egg_trajectory01, egg_params, t_end, t_ground, t_wall, y_ground, x_wall)

function egg_video(traj_fun, egg_params, t_end, t_ground, t_wall, y_ground, x_wall)
    disp(['Saving video to: ', pwd])

    writerObj = VideoWriter('egg.avi');
    open(writerObj);

    fig1 = figure(1);
    hold on; axis equal
    axis([0,40,0,40])

    ground = plot([0,40],[y_ground,y_ground],'Color', [0.6, 0.8, 0.95], 'linewidth', 2);
    wall = plot([x_wall,x_wall],[0,40], 'Color', [0.1, 0.6, 1],'linewidth', 2);

    s_val = linspace(0, 1, 100);
    egg = plot(0, 0, 'k', 'linewidth', 2);
    box_ = plot(0, 0, 'r--', 'linewidth', 1.25);
    
    contact = plot(nan, nan, 'r.', 'markersize', 20, 'linewidth', 2);
    legend([egg, box_, ground, wall, contact], {'Egg', 'Bounding Box', 'Ground', 'Wall', 'Point of Contact'}, 'Location', 'northeast', 'Interpreter','latex', 'FontSize', 12);

    title("Egg Animation", 'Interpreter','latex', 'FontSize', 25)

    t_vals = 0:0.01:t_end;
    if t_vals(end) < t_end
        t_vals(end+1) = t_end;
    end

    for t = t_vals
        [x0, y0, theta] = traj_fun(t);
        [V, ~] = egg_func(s_val, x0, y0, theta, egg_params);
        set(egg, 'xdata', V(1,:), 'ydata', V(2,:));

        [x_range, y_range] = compute_bounding_box(x0, y0, theta, egg_params);
        box_x = [x_range(1), x_range(2), x_range(2), x_range(1), x_range(1)];
        box_y = [y_range(1), y_range(1), y_range(2), y_range(2), y_range(1)];
        set(box_, 'xdata', box_x, 'ydata', box_y);

        drawnow;
        writeVideo(writerObj, getframe(fig1));
    end

    [x0, y0, theta] = traj_fun(t_end);
    [x_range, y_range] = compute_bounding_box(x0, y0, theta, egg_params);

    if t_ground <= t_wall
        contact_x = x0;          
        contact_y = y_range(1);
    else
        contact_x = x_range(2);  
        contact_y = y0;
    end

    contact = plot(contact_x, contact_y, 'r.', 'markersize', 20, 'linewidth', 2);
    legend([egg, box_, ground, wall, contact], {'Egg', 'Bounding Box', 'Ground', 'Wall', 'Point of Contact'}, 'Location', 'northeast', 'Interpreter','latex', 'FontSize', 12);

    title("Egg Animation", 'Interpreter','latex', 'FontSize', 25)

    for freeze = 1:50
        drawnow;
        writeVideo(writerObj, getframe(fig1));
    end

    
    close(writerObj);
end