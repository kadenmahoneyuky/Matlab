function [heave_MR, roll_MR, kinematics] = analyze_rocker_design(x, geom)
% analyze_rocker_design.m
% Analyzes the rocker design and calculates motion ratios
% Inputs:
%   x = [L_pushrod, theta_pushrod, L_heave, theta_heave, L_roll, theta_roll]
%   geom = suspension geometry structure
% Outputs:
%   heave_MR = heave motion ratio at ride height
%   roll_MR = roll motion ratio at ride height
%   kinematics = structure with full kinematic data

    % Extract design variables
    L_pr = x(1);      % Pushrod tab length (inches)
    theta_pr = x(2);  % Pushrod tab angle (degrees)
    L_h = x(3);       % Heave shock tab length (inches)
    theta_h = x(4);   % Heave shock tab angle (degrees)
    L_ar = x(5);      % Anti-roll shock tab length (inches)
    theta_ar = x(6);  % Anti-roll shock tab angle (degrees)
    
    %% Calculate suspension kinematics through wheel travel
    wheel_travel = geom.wheel_travel;
    n_points = length(wheel_travel);
    
    % Initialize arrays
    pushrod_disp = zeros(1, n_points);
    rocker_angle = zeros(1, n_points);
    heave_shock_disp = zeros(1, n_points);
    roll_shock_disp_left = zeros(1, n_points);
    
    % Calculate for each wheel position
    for i = 1:n_points
        wt = wheel_travel(i);
        
        % Calculate pushrod displacement for this wheel travel
        pushrod_disp(i) = calculate_pushrod_displacement(wt, geom);
        
        % Calculate rocker angle from pushrod displacement
        rocker_angle(i) = calculate_rocker_angle(pushrod_disp(i), L_pr, theta_pr);
        
        % Calculate shock displacements from rocker angle
        heave_shock_disp(i) = calculate_shock_displacement(rocker_angle(i), L_h, theta_h);
        roll_shock_disp_left(i) = calculate_shock_displacement(rocker_angle(i), L_ar, theta_ar);
        
        % Right side has mirrored anti-roll tab (horizontally mirrored)
        % When left rocker rotates CCW (+angle), right rocker rotates CW (-angle)
        % But we need to analyze both sides
    end
    
    %% Calculate motion ratios at ride height (center of travel)
    ride_idx = find(abs(wheel_travel) < 0.01, 1);
    if isempty(ride_idx)
        ride_idx = ceil(n_points/2);
    end
    
    % Use numerical derivatives at ride height for motion ratio
    % MR = d(wheel)/d(shock)
    
    % Heave mode: both wheels move together (bump)
    % In heave, both rockers rotate the same amount, both compress heave shock
    if ride_idx > 1 && ride_idx < n_points
        d_wheel = wheel_travel(ride_idx+1) - wheel_travel(ride_idx-1);
        d_heave_shock = heave_shock_disp(ride_idx+1) - heave_shock_disp(ride_idx-1);
        heave_MR = abs(d_wheel / d_heave_shock);
    else
        heave_MR = abs(wheel_travel(2) - wheel_travel(1)) / ...
                   abs(heave_shock_disp(2) - heave_shock_disp(1));
    end
    
    % Roll mode: one wheel bump, one wheel droop (opposite motion)
    % Left rocker rotates one way, right rocker rotates opposite way
    % Anti-roll shock sees displacement from both rockers
    % Since tabs are mirrored horizontally, both rockers compress/extend the AR shock
    if ride_idx > 1 && ride_idx < n_points
        d_wheel = wheel_travel(ride_idx+1) - wheel_travel(ride_idx-1);
        d_roll_shock = roll_shock_disp_left(ride_idx+1) - roll_shock_disp_left(ride_idx-1);
        % In roll, the shock sees 2x the displacement (left and right contribute)
        roll_MR = abs(d_wheel / (2 * d_roll_shock));
    else
        d_roll_shock = roll_shock_disp_left(2) - roll_shock_disp_left(1);
        roll_MR = abs(wheel_travel(2) - wheel_travel(1)) / (2 * abs(d_roll_shock));
    end
    
    %% Store kinematics data
    kinematics.wheel_travel = wheel_travel;
    kinematics.pushrod_disp = pushrod_disp;
    kinematics.rocker_angle = rocker_angle;
    kinematics.heave_shock_disp = heave_shock_disp;
    kinematics.roll_shock_disp = roll_shock_disp_left;
    
    % Calculate instantaneous motion ratios through travel
    kinematics.heave_MR_curve = gradient(wheel_travel) ./ gradient(heave_shock_disp);
    kinematics.roll_MR_curve = gradient(wheel_travel) ./ (2 * gradient(roll_shock_disp_left));
end

