# Decoupled Rocker Suspension Optimization Tool

A MATLAB tool for optimizing rocker motion ratios in decoupled heave and roll suspension systems for Formula SAE vehicles.

## Overview

This tool optimizes rocker tab lengths and angles to achieve target motion ratios for both heave (vertical) and roll modes in a decoupled suspension system. 

**Analyzes: FRONT SUSPENSION ONLY (one corner)**

The system features:
- **Single rocker tube** with three connection points: pushrod input, heave shock, and anti-roll shock
- **Heave shock**: Activates during symmetric wheel motion (both front wheels bump/droop together)
- **Anti-roll shock**: Activates during asymmetric wheel motion (one wheel bump, other droop)
- **2D planar analysis** in the front view for efficient calculation
- **Symmetric design**: Analyze one front corner (e.g., front-right), mirror for the other side

## Quick Start

### 1. Enter Your Suspension Geometry

Open `suspension_geometry_input.m` and replace the placeholder values with your **front corner** suspension pickup points:

```matlab
function geom = suspension_geometry_input()
    
    %% FRONT CORNER GEOMETRY (e.g., front-right)
    %% All coordinates in front view, units in inches
    
    %% UPPER A-ARM PICKUP POINTS
    geom.UA_chassis_front = [x, y];  % Front chassis pickup
    geom.UA_chassis_rear = [x, y];   % Rear chassis pickup
    geom.UA_wheel = [x, y];          % Wheel-side pickup at ride height
    
    %% LOWER A-ARM PICKUP POINTS
    geom.LA_chassis_front = [x, y];  % Front chassis pickup
    geom.LA_chassis_rear = [x, y];   % Rear chassis pickup
    geom.LA_wheel = [x, y];          % Wheel-side pickup at ride height
    
    %% PUSHROD CONNECTION
    geom.pushrod_LA = [x, y];        % Connection point on lower A-arm
    
    %% ROCKER PIVOT LOCATION
    geom.rocker_pivot = [x, y];      % Rocker pivot point (recommend [0,0])
    
    %% TARGET MOTION RATIOS
    geom.target_heave_MR = 1.1;      % Target heave MR (wheel:shock)
    geom.target_roll_MR = 1.0;       % Target roll MR (wheel:shock)
    
    %% SUSPENSION TRAVEL RANGE
    geom.wheel_travel = linspace(-2, 2, 50);  % inches (negative = droop)
end
```

### 2. Run the Optimization

Execute the main optimization script:

```matlab
optimize_rocker_geometry
```

Or try the example first:

```matlab
example_run
```

### 3. View Results

The tool will display:
- **Optimal rocker design**: tab lengths and angles
- **Achieved motion ratios** compared to targets
- **Plots** showing geometry, motion ratio curves, and kinematics
- **Results saved** to `rocker_optimization_results.mat`

## Coordinate System

**Front View** (looking at the car from the front) - **FRONT-RIGHT CORNER**

```
        Y (Vertical)
        ↑
        |
        |  [Analyzing right side of car]
        └────→ X (Lateral, outboard)
```

- **X-axis**: Lateral direction (positive = outboard/right)
- **Y-axis**: Vertical direction (positive = up)
- **Origin**: Can be placed at the rocker pivot for convenience
- **Units**: Inches
- **Note**: Due to symmetry, front-left corner is a mirror image

## Input Parameters Explained

### A-Arm Pickup Points (Front Corner Only)

Define all pickup points for **one front corner** (e.g., front-right) in the front view (2D):

- **Chassis-side pickups**: Where the A-arms attach to the chassis
  - `UA_chassis_front` and `UA_chassis_rear`: Upper A-arm chassis mounts
  - `LA_chassis_front` and `LA_chassis_rear`: Lower A-arm chassis mounts

- **Wheel-side pickups**: Where the A-arms connect to the upright (at ride height)
  - `UA_wheel`: Upper A-arm ball joint location
  - `LA_wheel`: Lower A-arm ball joint location

- **Pushrod connection**: Where the pushrod attaches to the lower A-arm
  - `pushrod_LA`: Pushrod pickup point on lower A-arm

**Note**: You only need to define one front corner. The opposite front corner will be a mirror image.

### Rocker Geometry

- **Rocker pivot**: The fixed pivot point of the rocker tube
  - Tip: Set this as the origin `[0, 0]` to simplify calculations

### Target Motion Ratios

- **Heave MR**: Ratio of wheel displacement to heave shock displacement during pure heave (both wheels move together)
  - Example: `1.1` means 1.1 inches of wheel travel = 1 inch of shock travel

- **Roll MR**: Ratio of wheel displacement to anti-roll shock displacement during pure roll (one wheel bump, one droop)
  - Example: `1.0` means 1.0 inches of wheel travel = 1 inch of shock travel

## Design Variables (Optimized Automatically)

The tool finds optimal values for:

| Variable | Description | Range |
|----------|-------------|-------|
| **L_pushrod** | Pushrod tab length from pivot | 2-8 inches |
| **θ_pushrod** | Pushrod tab angle from horizontal | -60° to 90° |
| **L_heave** | Heave shock tab length from pivot | 2-8 inches |
| **θ_heave** | Heave shock tab angle from horizontal | -90° to 0° |
| **L_roll** | Anti-roll shock tab length from pivot | 2-8 inches |
| **θ_roll** | Anti-roll shock tab angle from horizontal | 30° to 150° |

You can modify these bounds in `optimize_rocker_geometry.m` if needed.

## Output Files

### Console Output
- Exit flag and iteration count
- Optimal tab lengths and angles
- Achieved vs. target motion ratios
- Error percentages

### Plots
1. **Rocker Geometry**: Visual representation of tab positions
2. **Motion Ratio Curves**: MR vs. wheel travel
3. **Rocker Angle**: Rocker rotation through travel
4. **Pushrod Displacement**: Input motion from suspension
5. **Shock Displacements**: Output motion to shocks
6. **Design Summary**: Table of optimal parameters

### Data File
`rocker_optimization_results.mat` contains:
- `results.optimal_design`: Optimized design variables [L_pr, θ_pr, L_h, θ_h, L_ar, θ_ar]
- `results.heave_MR`: Achieved heave motion ratio
- `results.roll_MR`: Achieved roll motion ratio
- `results.kinematics`: Full kinematic data through travel
- `results.geometry`: Input suspension geometry

## Files Description

| File | Purpose |
|------|---------|
| `suspension_geometry_input.m` | **⭐ EDIT THIS**: Define your suspension geometry and targets |
| `optimize_rocker_geometry.m` | Main optimization script - run this |
| `example_run.m` | Example with sample geometry |
| `analyze_rocker_design.m` | Analyzes rocker kinematics and calculates motion ratios |
| `calculate_pushrod_displacement.m` | Computes pushrod motion from wheel travel |
| `calculate_rocker_angle.m` | Converts pushrod displacement to rocker rotation |
| `calculate_shock_displacement.m` | Converts rocker rotation to shock displacement |
| `objective_function.m` | Cost function for optimization |
| `plot_results.m` | Generates visualization plots |
| `README_USER_GUIDE.m` | Additional help in MATLAB format |

## Customization

### Adjust Optimization Weights

Edit `objective_function.m` to prioritize heave vs. roll:

```matlab
w_heave = 1.0;  % Weight for heave motion ratio error
w_roll = 1.0;   % Weight for roll motion ratio error
```

### Change Initial Guess

Edit `optimize_rocker_geometry.m`:

```matlab
x0 = [4, 30, 5, -30, 4.5, 90];  % [L_pr, θ_pr, L_h, θ_h, L_ar, θ_ar]
```

### Modify Bounds

Edit `optimize_rocker_geometry.m`:

```matlab
lb = [2, -60, 2, -90, 2, 30];    % Lower bounds
ub = [8, 90, 8, 0, 8, 150];      % Upper bounds
```

## Troubleshooting

### Optimization Doesn't Converge

**Possible causes:**
- Unrealistic suspension geometry
- Target motion ratios not achievable with current geometry
- Poor initial guess

**Solutions:**
1. Check that all pickup points are entered correctly
2. Verify units (all in inches)
3. Try different initial guess in `optimize_rocker_geometry.m`
4. Widen bounds (lb and ub arrays)
5. Adjust rocker pivot location

### Motion Ratios Far From Target

**Possible causes:**
- Geometric constraints prevent achieving targets
- Rocker pivot poorly located
- Tab length/angle bounds too restrictive

**Solutions:**
1. Try moving the rocker pivot location
2. Relax bounds on tab lengths and angles
3. Adjust target motion ratios to more achievable values
4. Check weight distribution in `objective_function.m`

### Plots Look Strange

**Possible causes:**
- Coordinate system mismatch
- Unrealistic geometry

**Solutions:**
1. Verify coordinate system (front view, X=lateral, Y=vertical)
2. Check that origin is appropriate (recommend using rocker pivot)
3. Ensure all points are in consistent units (inches)

## Theory Background

The tool is based on methods discussed in the included research papers:

- **Madrid Thesis.pdf**: Detailed suspension kinematics analysis
- **Other Madrid Thesis.pdf**: Advanced decoupled suspension design
- **Shandong Paper.pdf**: Motion ratio optimization techniques

See the `Relevant Papers` folder for theoretical background.

## Example Workflow

1. **Measure your suspension** in CAD or on the physical car
2. **Set coordinate origin** at rocker pivot: `[0, 0]`
3. **Record all pickup points** relative to this origin
4. **Enter data** in `suspension_geometry_input.m`
5. **Set target motion ratios** based on your spring/damper selection
6. **Run** `optimize_rocker_geometry`
7. **Review results** in console and plots
8. **Iterate** if needed by adjusting rocker pivot location or bounds
9. **Export results** for CAD implementation

## Requirements

- MATLAB R2016b or later
- Optimization Toolbox

## Notes

- The tool uses simplified 2D kinematics assuming small suspension motions
- For large suspension travels, results are approximations
- Anti-roll shock tabs are mirrored horizontally between left and right rockers
- Positive rocker angle = counterclockwise rotation in front view
- Positive shock displacement = compression

## Support

For questions about the theoretical background, refer to the papers in the `Relevant Papers` folder.

For MATLAB-specific issues, ensure you have the Optimization Toolbox installed:
```matlab
ver('optim')
```

---

**Good luck with your FSAE suspension design!** 🏎️

