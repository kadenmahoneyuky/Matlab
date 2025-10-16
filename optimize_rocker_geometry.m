% optimize_rocker_geometry.m
% Main script to optimize rocker tab lengths and angles for target motion ratios
% Decoupled heave and roll suspension system

clear; close all; clc;

%% Load suspension geometry
geom = suspension_geometry_input();

%% Design variables to optimize
% x = [L_pushrod, theta_pushrod, L_heave, theta_heave, L_roll, theta_roll]
% L = tab length from pivot (inches)
% theta = angle from horizontal (degrees), positive = counterclockwise

% Initial guess
x0 = [4, 30, 5, -30, 4.5, 90];  % [L_pr, θ_pr, L_h, θ_h, L_ar, θ_ar]

% Bounds
lb = [2, -60, 2, -90, 2, 30];    % Lower bounds
ub = [8, 90, 8, 0, 8, 150];      % Upper bounds

%% Optimization options
options = optimoptions('fmincon', ...
    'Display', 'iter', ...
    'MaxIterations', 500, ...
    'MaxFunctionEvaluations', 3000, ...
    'OptimalityTolerance', 1e-6, ...
    'StepTolerance', 1e-8, ...
    'Algorithm', 'interior-point');

%% Run optimization
fprintf('========================================\n');
fprintf('FRONT SUSPENSION ROCKER OPTIMIZATION\n');
fprintf('========================================\n');
fprintf('Analyzing: Front corner (one side)\n');
fprintf('Target Heave MR: %.2f:1\n', geom.target_heave_MR);
fprintf('Target Roll MR: %.2f:1\n\n', geom.target_roll_MR);

[x_opt, fval, exitflag, output] = fmincon(@(x) objective_function(x, geom), ...
    x0, [], [], [], [], lb, ub, [], options);

%% Display results
fprintf('\n========================================\n');
fprintf('OPTIMIZATION RESULTS\n');
fprintf('========================================\n');
fprintf('Exit flag: %d\n', exitflag);
fprintf('Iterations: %d\n', output.iterations);
fprintf('Objective value: %.6f\n\n', fval);

fprintf('Optimal Rocker Design:\n');
fprintf('  Pushrod Tab:    Length = %.3f in,  Angle = %.2f deg\n', x_opt(1), x_opt(2));
fprintf('  Heave Shock:    Length = %.3f in,  Angle = %.2f deg\n', x_opt(3), x_opt(4));
fprintf('  Anti-Roll Shock: Length = %.3f in,  Angle = %.2f deg\n', x_opt(5), x_opt(6));

%% Analyze final design
[heave_MR, roll_MR, kinematics] = analyze_rocker_design(x_opt, geom);

fprintf('\nAchieved Motion Ratios (at ride height):\n');
fprintf('  Heave MR:  %.3f:1  (Target: %.3f:1, Error: %.2f%%)\n', ...
    heave_MR, geom.target_heave_MR, abs(heave_MR - geom.target_heave_MR)/geom.target_heave_MR*100);
fprintf('  Roll MR:   %.3f:1  (Target: %.3f:1, Error: %.2f%%)\n', ...
    roll_MR, geom.target_roll_MR, abs(roll_MR - geom.target_roll_MR)/geom.target_roll_MR*100);

%% Plot results
plot_results(x_opt, geom, kinematics);

%% Save results
results.optimal_design = x_opt;
results.heave_MR = heave_MR;
results.roll_MR = roll_MR;
results.kinematics = kinematics;
results.geometry = geom;
save('rocker_optimization_results.mat', 'results');
fprintf('\nResults saved to rocker_optimization_results.mat\n');

