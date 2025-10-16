function rocker_angle = calculate_rocker_angle(pushrod_disp, L_pushrod, theta_pushrod)
% calculate_rocker_angle.m
% Calculates rocker rotation angle from pushrod displacement
%
% Inputs:
%   pushrod_disp = pushrod displacement (inches), positive = compression
%   L_pushrod = pushrod tab length from pivot (inches)
%   theta_pushrod = initial pushrod tab angle from horizontal (degrees)
% Output:
%   rocker_angle = rocker rotation angle (degrees), positive = CCW

    % Convert initial angle to radians
    theta0 = deg2rad(theta_pushrod);
    
    % Calculate rocker rotation from pushrod displacement
    % The pushrod tab rotates about the rocker pivot
    % 
    % For a rocker with tab at distance L_pushrod and angle theta0,
    % rotation by angle delta_theta causes the tab to move
    % 
    % The effective lever arm depends on the pushrod orientation
    % Using small angle approximation:
    % pushrod_disp ≈ L_pushrod * cos(theta0) * delta_theta
    %
    % More generally, the component of tab motion in the direction
    % perpendicular to the initial tab position equals:
    % displacement = L_pushrod * delta_theta
    %
    % Assuming the pushrod is roughly vertical or horizontal,
    % we can use the cosine or sine component
    
    % Calculate delta theta based on dominant component
    if abs(cos(theta0)) > abs(sin(theta0))
        % Pushrod tab is more horizontal - use cosine component
        delta_theta = pushrod_disp / (L_pushrod * cos(theta0));
    else
        % Pushrod tab is more vertical - use sine component
        delta_theta = pushrod_disp / (L_pushrod * sin(theta0));
    end
    
    % Convert to degrees
    rocker_angle = rad2deg(delta_theta);
end

