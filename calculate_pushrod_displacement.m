function pushrod_disp = calculate_pushrod_displacement(wheel_travel, geom)
% calculate_pushrod_displacement.m
% Calculates pushrod displacement for a given wheel travel
% Uses simplified double wishbone kinematics in 2D (front view)
%
% Inputs:
%   wheel_travel = vertical wheel displacement (inches), positive = bump
%   geom = suspension geometry structure
% Output:
%   pushrod_disp = pushrod displacement (inches), positive = compression

    %% Extract geometry
    % Lower A-arm (primary constraint for pushrod)
    LA_cf = geom.LA_chassis_front;
    LA_cr = geom.LA_chassis_rear;
    LA_w0 = geom.LA_wheel;  % At ride height
    
    % Pushrod connection on lower A-arm
    PR_LA0 = geom.pushrod_LA;
    
    % Rocker pivot
    rocker_pivot = geom.rocker_pivot;
    
    %% Calculate instant center (IC) for lower A-arm
    % IC is the intersection point of lines through chassis pickups
    IC_lower = line_intersection(LA_cf, LA_cr, LA_w0, LA_w0 + [1, 0]);
    
    %% Calculate new lower A-arm position
    % Lower A-arm rotates about its instant center
    % Length from IC to wheel point remains constant
    L_LA = norm(LA_w0 - IC_lower);
    
    % Angle from IC to wheel at ride height
    theta0 = atan2(LA_w0(2) - IC_lower(2), LA_w0(1) - IC_lower(1));
    
    % Approximate new angle (assuming vertical wheel motion)
    % This is a simplification - for exact solution, would need full kinematics
    % Small angle approximation: delta_theta ≈ wheel_travel / horizontal_distance
    horiz_dist = abs(LA_w0(1) - IC_lower(1));
    if horiz_dist > 0.1  % Avoid division by zero
        delta_theta = wheel_travel / horiz_dist;
    else
        delta_theta = 0;
    end
    
    theta_new = theta0 + delta_theta;
    
    %% Calculate pushrod connection position on lower A-arm
    % Pushrod connection is fixed relative to A-arm (rigid body motion)
    
    % Angle from IC to pushrod connection at ride height
    L_PR_arm = norm(PR_LA0 - IC_lower);
    theta_PR0 = atan2(PR_LA0(2) - IC_lower(2), PR_LA0(1) - IC_lower(1));
    
    % Rotate by same amount as A-arm
    theta_PR_new = theta_PR0 + delta_theta;
    
    % New pushrod connection position
    PR_LA_new = IC_lower + L_PR_arm * [cos(theta_PR_new), sin(theta_PR_new)];
    
    %% Calculate pushrod displacement
    % Pushrod length change
    PR_length0 = norm(PR_LA0 - rocker_pivot);
    PR_length_new = norm(PR_LA_new - rocker_pivot);
    
    pushrod_disp = PR_length0 - PR_length_new;  % Positive = compression
end

function IC = line_intersection(p1, p2, p3, p4)
    % Find intersection of two lines
    % Line 1: through p1 and p2
    % Line 2: through p3 and p4
    
    x1 = p1(1); y1 = p1(2);
    x2 = p2(1); y2 = p2(2);
    x3 = p3(1); y3 = p3(2);
    x4 = p4(1); y4 = p4(2);
    
    denom = (x1-x2)*(y3-y4) - (y1-y2)*(x3-x4);
    
    if abs(denom) < 1e-10
        % Lines are parallel - return far point
        IC = [1e6, 1e6];
    else
        t = ((x1-x3)*(y3-y4) - (y1-y3)*(x3-x4)) / denom;
        IC = [x1 + t*(x2-x1), y1 + t*(y2-y1)];
    end
end

