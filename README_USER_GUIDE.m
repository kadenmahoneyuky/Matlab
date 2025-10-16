%% DECOUPLED ROCKER SUSPENSION OPTIMIZATION TOOL
% User Guide and Instructions
%
% This tool optimizes rocker tab lengths and angles for a decoupled heave
% and roll suspension system used in Formula SAE cars.
%
% ANALYZES: FRONT SUSPENSION ONLY (one corner)
% Due to symmetry, opposite front corner is a mirror image
%
%% QUICK START GUIDE
%
% 1. EDIT YOUR GEOMETRY DATA
%    Open 'suspension_geometry_input.m' and enter your suspension geometry:
%    - Upper and lower A-arm pickup points
%    - Pushrod connection point on lower A-arm
%    - Rocker pivot location
%    - Target motion ratios
%
% 2. RUN OPTIMIZATION
%    Execute: optimize_rocker_geometry
%    This will find the optimal rocker tab lengths and angles
%
% 3. VIEW RESULTS
%    - Plots will show the optimized geometry and motion ratio curves
%    - Results are saved to 'rocker_optimization_results.mat'
%
%% COORDINATE SYSTEM
%
% Front View (looking at car from front) - FRONT-RIGHT CORNER:
%   X-axis: Lateral (positive = outboard/right side of car)
%   Y-axis: Vertical (positive = up)
%   Origin: Can be placed at rocker pivot for convenience
%
% Units: inches
% Note: Analyzes one front corner only - opposite side is mirrored
%
%% INPUT PARAMETERS TO DEFINE
%
% In suspension_geometry_input.m:
%
% 1. Upper A-arm geometry:
%    UA_chassis_front = [x, y];  % Front chassis pickup point
%    UA_chassis_rear = [x, y];   % Rear chassis pickup point
%    UA_wheel = [x, y];          % Wheel-side pickup at ride height
%
% 2. Lower A-arm geometry:
%    LA_chassis_front = [x, y];  % Front chassis pickup point
%    LA_chassis_rear = [x, y];   % Rear chassis pickup point
%    LA_wheel = [x, y];          % Wheel-side pickup at ride height
%
% 3. Pushrod:
%    pushrod_LA = [x, y];        % Connection point on lower A-arm
%
% 4. Rocker:
%    rocker_pivot = [x, y];      % Rocker pivot location
%
% 5. Targets:
%    target_heave_MR = 1.1;      % Heave motion ratio (wheel:shock)
%    target_roll_MR = 1.0;       % Roll motion ratio
%
%% DESIGN VARIABLES (OPTIMIZED BY TOOL)
%
% The tool will find optimal values for:
%   - Pushrod tab length (distance from pivot)
%   - Pushrod tab angle (from horizontal)
%   - Heave shock tab length
%   - Heave shock tab angle
%   - Anti-roll shock tab length
%   - Anti-roll shock tab angle
%
%% UNDERSTANDING THE OUTPUTS
%
% Motion Ratios:
%   - Heave MR: In pure heave (both wheels bump), ratio of wheel travel
%               to heave shock compression
%   - Roll MR: In pure roll (one wheel bump, one droop), ratio of wheel
%              travel to anti-roll shock compression
%
% Plots Generated:
%   1. Rocker geometry showing all tab positions and angles
%   2. Motion ratio curves through suspension travel
%   3. Rocker angle vs wheel travel
%   4. Pushrod displacement
%   5. Shock displacements
%   6. Design summary table
%
%% EXAMPLE GEOMETRY (TEMPLATE)
%
% Here's a sample geometry setup (modify with your actual values):
%
%   % Place rocker pivot at origin for convenience
%   rocker_pivot = [0, 0];
%
%   % Upper A-arm (example values)
%   UA_chassis_front = [-3, 2];
%   UA_chassis_rear = [-5, 2];
%   UA_wheel = [10, 1];
%
%   % Lower A-arm (example values)
%   LA_chassis_front = [-2, -3];
%   LA_chassis_rear = [-4, -3];
%   LA_wheel = [11, -2];
%
%   % Pushrod connection on lower A-arm
%   pushrod_LA = [5, -1];
%
%   % Target motion ratios
%   target_heave_MR = 1.1;
%   target_roll_MR = 1.0;
%
%% TROUBLESHOOTING
%
% If optimization fails to converge:
%   1. Check that your suspension geometry is realistic
%   2. Adjust initial guess in optimize_rocker_geometry.m
%   3. Adjust bounds (lb and ub) to allow more design space
%   4. Check for geometric interference or unrealistic linkages
%
% If motion ratios are far from target:
%   1. Your target may not be achievable with given geometry
%   2. Try adjusting rocker pivot location
%   3. Relax bounds on tab lengths and angles
%
%% ADVANCED OPTIONS
%
% Modify weights in objective_function.m:
%   w_heave = 1.0;  % Weight for heave error
%   w_roll = 1.0;   % Weight for roll error
%
% Adjust optimization parameters in optimize_rocker_geometry.m:
%   - MaxIterations
%   - OptimalityTolerance
%   - Algorithm
%
%% CONTACT / SUPPORT
%
% For issues or questions, refer to the Madrid and Shandong papers
% in the 'Relevant Papers' folder for theoretical background.
%
% Good luck with your FSAE suspension design!

%% END OF USER GUIDE

