% suspension_geometry_input.m
% Define your FRONT SUSPENSION double wishbone geometry (one corner only)
% All coordinates in inches, front view (X = lateral/outboard, Y = vertical)
% Origin can be placed at rocker pivot for convenience
% 
% ANALYZES: FRONT CORNER ONLY (e.g., front-right)
% Due to symmetry, opposite side (front-left) will be a mirror image

function geom = suspension_geometry_input()
    
    %% ========== REPLACE THESE WITH YOUR ACTUAL FRONT CORNER PICKUP POINTS ==========
    
    % Upper A-arm pickup points (front corner)
    geom.UA_chassis_front = [0, 0];  % Front chassis pickup [x, y]
    geom.UA_chassis_rear = [0, 0];   % Rear chassis pickup [x, y]
    geom.UA_wheel = [0, 0];          % Wheel-side pickup (at ride height) [x, y]
    
    % Lower A-arm pickup points (front corner)
    geom.LA_chassis_front = [0, 0];  % Front chassis pickup [x, y]
    geom.LA_chassis_rear = [0, 0];   % Rear chassis pickup [x, y]
    geom.LA_wheel = [0, 0];          % Wheel-side pickup (at ride height) [x, y]
    
    % Pushrod connection on lower A-arm (front corner)
    geom.pushrod_LA = [0, 0];        % Pushrod connection point [x, y]
    
    % Rocker pivot location (front corner)
    geom.rocker_pivot = [0, 0];      % Rocker pivot point [x, y] - recommend [0,0]
    
    %% Suspension travel range
    geom.wheel_travel = linspace(-2, 2, 50);  % Wheel travel range (inches), negative = droop
    
    %% Target motion ratios
    geom.target_heave_MR = 1.1;      % Target heave motion ratio (wheel:shock)
    geom.target_roll_MR = 1.0;       % Target roll motion ratio (will need clarification)
    
    %% Wheel and tire parameters
    geom.wheel_radius = 10;          % Wheel radius (inches) - adjust as needed
    geom.tire_rate = 200;            % Tire rate (lb/in) - optional for now
    
end

