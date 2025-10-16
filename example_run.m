%% example_run.m
% Example script demonstrating the rocker optimization tool
% with sample suspension geometry
%
% Run this script to see how the tool works before inputting your actual data

clear; close all; clc;

fprintf('========================================\n');
fprintf('FRONT ROCKER OPTIMIZATION EXAMPLE\n');
fprintf('========================================\n\n');

fprintf('This example uses sample FRONT CORNER suspension geometry.\n');
fprintf('Analyzes: Front corner only (one side)\n');
fprintf('To use your own geometry, edit suspension_geometry_input.m\n\n');

%% Create example geometry
geom.target_heave_MR = 1.1;
geom.target_roll_MR = 1.0;
geom.wheel_travel = linspace(-2, 2, 50);

% Place rocker pivot at origin
geom.rocker_pivot = [0, 0];

% Example double wishbone geometry (front view)
% Upper A-arm
geom.UA_chassis_front = [-3, 8];
geom.UA_chassis_rear = [-5, 8];
geom.UA_wheel = [12, 6];

% Lower A-arm
geom.LA_chassis_front = [-2, 2];
geom.LA_chassis_rear = [-4, 2];
geom.LA_wheel = [13, 3];

% Pushrod connection on lower A-arm
geom.pushrod_LA = [6, 3.5];

% Wheel parameters
geom.wheel_radius = 10;
geom.tire_rate = 200;

%% Initial guess for design variables
x0 = [4, 45, 5, -45, 4.5, 90];

% Bounds
lb = [2, 0, 2, -90, 2, 45];
ub = [8, 90, 8, 0, 8, 135];

%% Run optimization
options = optimoptions('fmincon', ...
    'Display', 'iter-detailed', ...
    'MaxIterations', 300, ...
    'MaxFunctionEvaluations', 2000, ...
    'OptimalityTolerance', 1e-6, ...
    'Algorithm', 'interior-point');

fprintf('Starting optimization...\n\n');

[x_opt, fval, exitflag, output] = fmincon(@(x) objective_function(x, geom), ...
    x0, [], [], [], [], lb, ub, [], options);

%% Display results
fprintf('\n========================================\n');
fprintf('OPTIMIZATION COMPLETE\n');
fprintf('========================================\n');
fprintf('Exit flag: %d\n', exitflag);
fprintf('Iterations: %d\n', output.iterations);
fprintf('Final cost: %.6f\n\n', fval);

fprintf('Optimal Rocker Design:\n');
fprintf('  Pushrod Tab:     L = %.3f in,  θ = %.2f deg\n', x_opt(1), x_opt(2));
fprintf('  Heave Shock:     L = %.3f in,  θ = %.2f deg\n', x_opt(3), x_opt(4));
fprintf('  Anti-Roll Shock: L = %.3f in,  θ = %.2f deg\n', x_opt(5), x_opt(6));

%% Analyze final design
[heave_MR, roll_MR, kinematics] = analyze_rocker_design(x_opt, geom);

fprintf('\nAchieved Motion Ratios:\n');
fprintf('  Heave MR: %.3f:1  (Target: %.3f:1)\n', heave_MR, geom.target_heave_MR);
fprintf('  Roll MR:  %.3f:1  (Target: %.3f:1)\n', roll_MR, geom.target_roll_MR);

%% Plot results
plot_results(x_opt, geom, kinematics);

%% Additional analysis plot - Rocker geometry at different positions
figure('Position', [150, 150, 1200, 500]);

% Show rocker at bump, ride, and droop
positions = [1, ceil(length(geom.wheel_travel)/2), length(geom.wheel_travel)];
position_names = {'Full Droop', 'Ride Height', 'Full Bump'};

for i = 1:3
    subplot(1, 3, i);
    hold on; grid on; axis equal;
    
    idx = positions(i);
    angle = kinematics.rocker_angle(idx);
    
    % Rocker pivot
    plot(0, 0, 'ko', 'MarkerSize', 10, 'MarkerFaceColor', 'k');
    
    % Rotate tabs
    L_pr = x_opt(1); theta_pr = x_opt(2) + angle;
    L_h = x_opt(3); theta_h = x_opt(4) + angle;
    L_ar = x_opt(5); theta_ar = x_opt(6) + angle;
    
    % Pushrod tab
    pr_pos = [L_pr * cosd(theta_pr), L_pr * sind(theta_pr)];
    plot([0, pr_pos(1)], [0, pr_pos(2)], 'r-', 'LineWidth', 3);
    plot(pr_pos(1), pr_pos(2), 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
    
    % Heave shock tab
    h_pos = [L_h * cosd(theta_h), L_h * sind(theta_h)];
    plot([0, h_pos(1)], [0, h_pos(2)], 'b-', 'LineWidth', 3);
    plot(h_pos(1), h_pos(2), 'bo', 'MarkerSize', 8, 'MarkerFaceColor', 'b');
    
    % Anti-roll shock tab
    ar_pos = [L_ar * cosd(theta_ar), L_ar * sind(theta_ar)];
    plot([0, ar_pos(1)], [0, ar_pos(2)], 'g-', 'LineWidth', 3);
    plot(ar_pos(1), ar_pos(2), 'go', 'MarkerSize', 8, 'MarkerFaceColor', 'g');
    
    xlabel('Lateral (in)');
    ylabel('Vertical (in)');
    title(sprintf('%s (%.2f in, %.1f deg)', position_names{i}, ...
          geom.wheel_travel(idx), angle));
    
    if i == 1
        legend('Pivot', 'Pushrod', '', 'Heave', '', 'Anti-Roll', 'Location', 'best');
    end
end

sgtitle('Rocker Position Through Suspension Travel', 'FontSize', 14, 'FontWeight', 'bold');

fprintf('\nExample complete! Check the plots for visualization.\n');
fprintf('Edit suspension_geometry_input.m to use your actual geometry.\n');

