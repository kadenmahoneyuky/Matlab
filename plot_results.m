function plot_results(x_opt, geom, kinematics)
% plot_results.m
% Visualizes the optimized rocker design and motion ratios

    %% Extract design variables
    L_pr = x_opt(1);
    theta_pr = x_opt(2);
    L_h = x_opt(3);
    theta_h = x_opt(4);
    L_ar = x_opt(5);
    theta_ar = x_opt(6);
    
    %% Create figure with subplots
    figure('Position', [100, 100, 1400, 900]);
    
    %% Subplot 1: Rocker Geometry
    subplot(2, 3, 1);
    hold on; grid on; axis equal;
    
    % Rocker pivot at origin
    plot(0, 0, 'ko', 'MarkerSize', 10, 'MarkerFaceColor', 'k');
    
    % Pushrod tab
    pr_pos = [L_pr * cosd(theta_pr), L_pr * sind(theta_pr)];
    plot([0, pr_pos(1)], [0, pr_pos(2)], 'r-', 'LineWidth', 3);
    plot(pr_pos(1), pr_pos(2), 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
    text(pr_pos(1)*1.1, pr_pos(2)*1.1, 'Pushrod', 'FontSize', 10);
    
    % Heave shock tab
    h_pos = [L_h * cosd(theta_h), L_h * sind(theta_h)];
    plot([0, h_pos(1)], [0, h_pos(2)], 'b-', 'LineWidth', 3);
    plot(h_pos(1), h_pos(2), 'bo', 'MarkerSize', 8, 'MarkerFaceColor', 'b');
    text(h_pos(1)*1.1, h_pos(2)*1.1, 'Heave', 'FontSize', 10);
    
    % Anti-roll shock tab
    ar_pos = [L_ar * cosd(theta_ar), L_ar * sind(theta_ar)];
    plot([0, ar_pos(1)], [0, ar_pos(2)], 'g-', 'LineWidth', 3);
    plot(ar_pos(1), ar_pos(2), 'go', 'MarkerSize', 8, 'MarkerFaceColor', 'g');
    text(ar_pos(1)*1.1, ar_pos(2)*1.1, 'Anti-Roll', 'FontSize', 10);
    
    xlabel('Lateral Distance (in)');
    ylabel('Vertical Distance (in)');
    title('Rocker Geometry (Front View)');
    legend('Pivot', 'Pushrod Tab', '', 'Heave Tab', '', 'Anti-Roll Tab', 'Location', 'best');
    
    %% Subplot 2: Motion Ratio vs Wheel Travel
    subplot(2, 3, 2);
    hold on; grid on;
    
    plot(kinematics.wheel_travel, kinematics.heave_MR_curve, 'b-', 'LineWidth', 2);
    plot(kinematics.wheel_travel, kinematics.roll_MR_curve, 'g-', 'LineWidth', 2);
    yline(geom.target_heave_MR, 'b--', 'Target Heave', 'LineWidth', 1.5);
    yline(geom.target_roll_MR, 'g--', 'Target Roll', 'LineWidth', 1.5);
    
    xlabel('Wheel Travel (in)');
    ylabel('Motion Ratio (wheel:shock)');
    title('Motion Ratio vs Wheel Travel');
    legend('Heave MR', 'Roll MR', 'Target Heave', 'Target Roll', 'Location', 'best');
    xlim([min(kinematics.wheel_travel), max(kinematics.wheel_travel)]);
    
    %% Subplot 3: Rocker Angle vs Wheel Travel
    subplot(2, 3, 3);
    hold on; grid on;
    
    plot(kinematics.wheel_travel, kinematics.rocker_angle, 'k-', 'LineWidth', 2);
    xlabel('Wheel Travel (in)');
    ylabel('Rocker Angle (deg)');
    title('Rocker Rotation vs Wheel Travel');
    grid on;
    
    %% Subplot 4: Pushrod Displacement
    subplot(2, 3, 4);
    hold on; grid on;
    
    plot(kinematics.wheel_travel, kinematics.pushrod_disp, 'r-', 'LineWidth', 2);
    xlabel('Wheel Travel (in)');
    ylabel('Pushrod Displacement (in)');
    title('Pushrod Displacement vs Wheel Travel');
    grid on;
    
    %% Subplot 5: Shock Displacements
    subplot(2, 3, 5);
    hold on; grid on;
    
    plot(kinematics.wheel_travel, kinematics.heave_shock_disp, 'b-', 'LineWidth', 2);
    plot(kinematics.wheel_travel, kinematics.roll_shock_disp, 'g-', 'LineWidth', 2);
    xlabel('Wheel Travel (in)');
    ylabel('Shock Displacement (in)');
    title('Shock Displacements vs Wheel Travel');
    legend('Heave Shock', 'Anti-Roll Shock', 'Location', 'best');
    grid on;
    
    %% Subplot 6: Design Summary Table
    subplot(2, 3, 6);
    axis off;
    
    % Create text summary
    summary_text = {
        'OPTIMIZED ROCKER DESIGN',
        '================================',
        '',
        'Pushrod Tab:',
        sprintf('  Length: %.3f in', L_pr),
        sprintf('  Angle: %.2f deg', theta_pr),
        '',
        'Heave Shock Tab:',
        sprintf('  Length: %.3f in', L_h),
        sprintf('  Angle: %.2f deg', theta_h),
        '',
        'Anti-Roll Shock Tab:',
        sprintf('  Length: %.3f in', L_ar),
        sprintf('  Angle: %.2f deg', theta_ar),
        '',
        '================================',
        'Motion Ratios at Ride Height:',
        sprintf('  Heave: %.3f:1', kinematics.heave_MR_curve(ceil(end/2))),
        sprintf('  Roll: %.3f:1', kinematics.roll_MR_curve(ceil(end/2))),
    };
    
    text(0.1, 0.9, summary_text, 'FontSize', 10, 'VerticalAlignment', 'top', ...
         'FontName', 'Courier New');
    
    %% Overall figure title
    sgtitle('Front Suspension - Decoupled Rocker Optimization Results', 'FontSize', 14, 'FontWeight', 'bold');
end

