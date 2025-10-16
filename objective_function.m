function cost = objective_function(x, geom)
% objective_function.m
% Calculates the cost function for rocker optimization
% Minimizes error from target motion ratios

    % Calculate motion ratios for current design
    [heave_MR, roll_MR, ~] = analyze_rocker_design(x, geom);
    
    % Cost function: weighted sum of squared errors
    % Weight can be adjusted based on priority
    w_heave = 1.0;  % Weight for heave motion ratio error
    w_roll = 1.0;   % Weight for roll motion ratio error
    
    % Normalized errors
    error_heave = (heave_MR - geom.target_heave_MR) / geom.target_heave_MR;
    error_roll = (roll_MR - geom.target_roll_MR) / geom.target_roll_MR;
    
    % Total cost
    cost = w_heave * error_heave^2 + w_roll * error_roll^2;
    
    % Penalty for unrealistic geometries (optional)
    % Add penalty if tabs interfere or have bad angles
    penalty = 0;
    
    % Check if pushrod and heave shock tabs are too close (potential interference)
    angle_diff = abs(x(2) - x(4));
    if angle_diff < 20
        penalty = penalty + (20 - angle_diff)^2 * 0.1;
    end
    
    cost = cost + penalty;
end

