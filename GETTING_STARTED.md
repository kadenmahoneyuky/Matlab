# Getting Started - Quick Guide

**Analyzes: FRONT SUSPENSION ONLY (one corner)**

## Step-by-Step Instructions

### Step 1: Define Your Front Corner Suspension Geometry

1. Open `suspension_geometry_input.m`
2. Enter your **front corner** (e.g., front-right) suspension pickup points in the front view (2D coordinates)
3. Set your target motion ratios

**Note**: You only need one front corner - the other side is a mirror image.

**Example:**
```matlab
% Set rocker pivot at origin for convenience
geom.rocker_pivot = [0, 0];

% FRONT CORNER - Upper A-arm pickup points (inches)
geom.UA_chassis_front = [-3, 8];
geom.UA_chassis_rear = [-5, 8];
geom.UA_wheel = [12, 6];

% FRONT CORNER - Lower A-arm pickup points (inches)
geom.LA_chassis_front = [-2, 2];
geom.LA_chassis_rear = [-4, 2];
geom.LA_wheel = [13, 3];

% FRONT CORNER - Pushrod connection on lower A-arm
geom.pushrod_LA = [6, 3.5];

% Target motion ratios
geom.target_heave_MR = 1.1;  % 1.1:1 wheel:shock
geom.target_roll_MR = 1.0;   % 1.0:1 wheel:shock
```

### Step 2: Run the Optimization

In MATLAB, execute:
```matlab
optimize_rocker_geometry
```

Or try the example first:
```matlab
example_run
```

### Step 3: Review Results

The tool will output:
- ✅ Optimal tab lengths (inches)
- ✅ Optimal tab angles (degrees)
- ✅ Achieved motion ratios
- ✅ Multiple plots showing the design
- ✅ Saved results file

## What You'll Get

### Console Output
```
Optimal Rocker Design:
  Pushrod Tab:     Length = 4.235 in,  Angle = 45.23 deg
  Heave Shock:     Length = 5.124 in,  Angle = -42.15 deg
  Anti-Roll Shock: Length = 4.876 in,  Angle = 87.34 deg

Achieved Motion Ratios:
  Heave MR: 1.098:1  (Target: 1.100:1, Error: 0.18%)
  Roll MR:  1.002:1  (Target: 1.000:1, Error: 0.20%)
```

### Plots
1. **Rocker Geometry** - Visual layout of all tabs
2. **Motion Ratio Curves** - How MR varies through travel
3. **Kinematics** - Displacements and angles

### Saved Data
`rocker_optimization_results.mat` contains all design parameters and kinematic data.

## Coordinate System Reminder

```
Front View (looking at car from front) - FRONT-RIGHT CORNER

        ↑ Y (up)
        |
        |  [Analyzing right side]
        └──→ X (outboard/right)
```

- Origin at rocker pivot: `[0, 0]` (recommended)
- All measurements in **inches**
- Angles in **degrees** (positive = counterclockwise)
- **Front corner only** - opposite side is mirrored

## Need Help?

See `README.md` for detailed documentation.

## Files You Need to Edit

✏️ **ONLY ONE FILE**: `suspension_geometry_input.m`

All other files are the calculation engine - don't modify unless you want to customize the optimization.

