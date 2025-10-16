function shock_disp = calculate_shock_displacement(rocker_angle, L_shock, theta_shock)
% calculate_shock_displacement.m
% Calculates shock displacement from rocker rotation
%
% Inputs:
%   rocker_angle = rocker rotation angle (degrees), positive = CCW
%   L_shock = shock tab length from pivot (inches)
%   theta_shock = initial shock tab angle from horizontal (degrees)
% Output:
%   shock_disp = shock displacement (inches), positive = compression

    % Convert angles to radians
    theta0 = deg2rad(theta_shock);
    delta_theta = deg2rad(rocker_angle);
    
    % Initial shock tab position (in rocker frame, pivot at origin)
    shock_tab0 = [L_shock * cos(theta0), L_shock * sin(theta0)];
    
    % New shock tab position after rocker rotation
    theta_new = theta0 + delta_theta;
    shock_tab_new = [L_shock * cos(theta_new), L_shock * sin(theta_new)];
    
    % Shock displacement is the change in distance
    % Assuming shock is initially at some length and we measure the change
    % We need the component of motion in the shock direction
    
    % For a rocker, if shock is approximately vertical:
    % shock_disp = change in vertical position of tab
    
    % More generally, shock displacement is the change in distance
    % from chassis mount to tab position
    % We'll assume shock is vertical (chassis mount directly above/below tab)
    
    % Vertical component of tab motion (primary direction for shock displacement)
    dy = shock_tab_new(2) - shock_tab0(2);
    
    % Shock displacement is the negative of vertical motion
    % (positive rocker angle typically reduces shock length)
    shock_disp = -dy;
    
    % Note: This assumes vertical shock mounting (common configuration)
    % For angled shock mounts, would need to project onto shock axis
end

