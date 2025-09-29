# 2D Brownian Motion Simulation of Single Particle in MATLAB - Complete Guide
Development of a MATLAB program to simulate the Brownian motion of a particle in two-dimensional space, trajectory plot, and calculated mean square displacement (MSD) as a function of time.

## Table of Contents
1. [Background](#background)
2. [Theory](#theory)
3. [Simulation Method](#simulation-method)
4. [Program Structure](#program-structure)
5. [How to Run](#how-to-run)
6. [Understanding the Results](#understanding-the-results)
7. [Parameters Explained](#parameters-explained)
8. [Expected Output](#expected-output)
9. [Troubleshooting](#troubleshooting)

---

## Background

### What is Brownian Motion?

Brownian motion is the random, erratic movement of microscopic particles suspended in a fluid (liquid or gas). This phenomenon was first observed by botanist Robert Brown in 1827 when he noticed pollen grains moving randomly in water under a microscope.

**Physical Origin:**
- Particles are constantly bombarded by molecules of the surrounding fluid
- Each collision imparts a tiny momentum change
- These collisions occur from all directions randomly
- The net effect is a "random walk" trajectory

**Historical Significance:**
- Provided early evidence for the atomic nature of matter
- Albert Einstein's 1905 mathematical theory of Brownian motion helped prove atoms exist
- Foundation for understanding diffusion, molecular transport, and stochastic processes

**Modern Applications:**
- Drug delivery in biological systems
- Particle tracking in cells
- Financial modeling (stock price movements)
- Polymer physics
- Colloidal suspension studies

---

## Theory

### Random Walk Model

Brownian motion can be modeled as a **random walk**:
- At each time step, the particle moves a random distance in a random direction
- The displacement has no memory of previous steps (Markov process)
- All directions are equally probable (isotropic)

### Mean Square Displacement (MSD)

The **Mean Square Displacement** is the average of the squared distance from the starting position:

```
MSD(t) = âŸ¨rÂ²(t)âŸ© = âŸ¨[x(t) - x(0)]Â² + [y(t) - y(0)]Â²âŸ©
```

For our simulation starting at the origin (xâ‚€ = 0, yâ‚€ = 0):

```
MSD(t) = âŸ¨xÂ²(t) + yÂ²(t)âŸ©
```

### Einstein's Diffusion Equation

Einstein showed that for Brownian motion in **2D**, the MSD grows linearly with time:

```
âŸ¨rÂ²(t)âŸ© = 4Dt
```

Where:
- **D** = Diffusion coefficient (units: lengthÂ²/time, e.g., Î¼mÂ²/s)
- **t** = Time elapsed
- **4** = Dimensionality factor (2D: factor is 4, 3D: factor is 6, 1D: factor is 2)

The diffusion coefficient depends on:
- **Temperature (T)**: Higher temperature â†’ faster motion
- **Particle size (r)**: Larger particles â†’ slower motion  
- **Fluid viscosity (Î·)**: More viscous fluid â†’ slower motion

Einstein-Stokes relation: **D = káµ¦T/(6Ï€Î·r)**

### Why MSD Instead of Mean Displacement?

The **mean displacement** âŸ¨r(t)âŸ© = 0 because the particle moves randomly in all directions (positive and negative displacements cancel out). The **MSD** captures the spread of the distribution and quantifies how far the particle diffuses.

---

## Simulation Method

### Algorithm Overview

Our simulation implements a **discrete random walk** approximation:

1. **Initialize**: Start particle at origin (0, 0)

2. **Time Loop**: For each time step:
   - Generate random angle Î¸ uniformly from [0, 2Ï€]
   - Calculate step: Î”x = ÏƒÂ·cos(Î¸), Î”y = ÏƒÂ·sin(Î¸)
   - Update position: x(t) = x(t-1) + Î”x, y(t) = y(t-1) + Î”y
   
3. **Calculate MSD**: For each time point, compute rÂ²(t) = xÂ²(t) + yÂ²(t)

4. **Compare**: Plot simulated MSD against theoretical prediction

### Step Size Calculation

The step size Ïƒ (step_size in code) is derived from the diffusion coefficient:

For 2D Brownian motion, the variance of displacement in time Î”t is:
```
âŸ¨Î”rÂ²âŸ© = 4DÂ·Î”t
```

Therefore, the standard deviation (step size) is:
```
Ïƒ = âˆš(4DÂ·Î”t)
```

This ensures our discrete random walk has the correct diffusion properties.

### Isotropy (Direction Independence)

By choosing a random angle Î¸ uniformly from [0, 2Ï€]:
- All directions are equally likely
- No preferred direction of motion
- Models true Brownian motion in an isotropic medium

---

## Program Structure

### Main Components

```matlab
1. Parameter Setup
   â”œâ”€â”€ n_steps: Number of time steps in simulation
   â”œâ”€â”€ dt: Time increment per step
   â”œâ”€â”€ D: Diffusion coefficient
   â””â”€â”€ step_size: Calculated from âˆš(4DÂ·dt)

2. Position Arrays
   â”œâ”€â”€ x(t): X-coordinates over time
   â””â”€â”€ y(t): Y-coordinates over time

3. Simulation Loop
   â”œâ”€â”€ Generate random angle
   â”œâ”€â”€ Calculate displacement
   â””â”€â”€ Update position

4. MSD Calculation
   â””â”€â”€ rÂ²(t) = xÂ²(t) + yÂ²(t) for each time

5. Visualization
   â”œâ”€â”€ Trajectory plot (x vs y)
   â”œâ”€â”€ Position components (x,y vs time)
   â””â”€â”€ MSD vs time (with theoretical comparison)

6. Results Output
   â””â”€â”€ Statistical summary
```

### Key Variables

| Variable | Description | Units |
|----------|-------------|-------|
| `n_steps` | Total number of time steps | dimensionless |
| `dt` | Time interval between steps | seconds |
| `D` | Diffusion coefficient | Î¼mÂ²/s |
| `step_size` | RMS displacement per step | Î¼m |
| `x, y` | Position arrays | Î¼m |
| `msd` | Mean square displacement | Î¼mÂ² |
| `theta` | Random angle | radians |

---

## How to Run

### Prerequisites
- MATLAB (any recent version, R2016a or later recommended)
- No additional toolboxes required

### Running the Simulation

1. **Save the code** as `brownian_motion_2d.m`

2. **Open MATLAB** and navigate to the directory containing the file

3. **Run the script**:
   ```matlab
   brownian_motion_2d
   ```
   Or click the "Run" button in MATLAB editor

4. **View results**:
   - Figure window with 3 plots will appear
   - Console output shows numerical results

### Modifying Parameters

You can easily modify the simulation by changing parameters at the top of the code:

```matlab
n_steps = 2000;     % Try 5000 for longer simulation
dt = 0.01;          % Try 0.001 for finer time resolution  
D = 1.0;            % Try 0.5 or 2.0 for different diffusion rates
```

**Note**: After changing parameters, save and re-run the script.

---

## Understanding the Results

### Plot 1: Trajectory (X vs Y)

**What it shows:**
- The actual path taken by the particle in 2D space
- Green circle: Starting position (origin)
- Red square: Final position
- Blue line: Complete trajectory

**What to look for:**
- Random, irregular path (not smooth)
- No preferred direction
- The particle may wander far from origin
- Each run produces a different trajectory

**Physical Interpretation:**
- Mimics how a real microscopic particle would move
- The "jittery" path reflects molecular collisions

### Plot 2: Position Components vs Time

**What it shows:**
- X-position (blue) and Y-position (red) as functions of time
- How far the particle has moved in each direction

**What to look for:**
- Both curves fluctuate randomly
- No systematic drift up or down (average is zero)
- X and Y are independent (uncorrelated)
- Variance increases with time

**Physical Interpretation:**
- Shows the random nature of each coordinate
- Demonstrates that displacement in X doesn't affect Y

### Plot 3: MSD vs Time

**What it shows:**
- Blue solid line: Simulated MSD from our particle
- Red dashed line: Theoretical prediction (MSD = 4Dt)

**What to look for:**
- MSD increases over time (particle spreads out)
- Simulated curve fluctuates around theoretical line
- **Important**: Single particle MSD is noisy!
- General trend should follow linear growth

**Why the Noise?**
- Single particle = one realization of random process
- Like flipping a coin 10 times might give 7 heads instead of expected 5
- Averaging many particles would smooth the curve
- The noise is physically realistic!

**Physical Interpretation:**
- Linear growth confirms diffusive behavior
- Slope = 4D (can estimate diffusion coefficient)
- Steeper slope = faster diffusion

---

## Parameters Explained

### Number of Steps (n_steps)

**Default**: 2000

**Effect:**
- More steps = longer simulation time
- More steps = better statistics for MSD
- Longer trajectories show diffusive behavior more clearly

**Recommendations:**
- Minimum: 500 steps
- For smoother MSD: 5000-10000 steps
- Very large values (>50000) may slow down plotting

### Time Step (dt)

**Default**: 0.01 seconds

**Effect:**
- Smaller dt = finer time resolution
- Must be small enough that particle moves only a small distance per step
- Total time = n_steps Ã— dt

**Recommendations:**
- Typical range: 0.001 to 0.1 seconds
- Should be much smaller than timescale of interest
- If step_size becomes too large, reduce dt

### Diffusion Coefficient (D)

**Default**: 1.0 Î¼mÂ²/s

**Effect:**
- Larger D = faster diffusion = larger displacements
- Controls how quickly particle spreads out
- Affects step_size directly

**Physical Context:**
- Small molecule in water: ~1000 Î¼mÂ²/s
- Protein in water: ~50 Î¼mÂ²/s
- Virus particle: ~5 Î¼mÂ²/s
- 1 Î¼m bead in water: ~0.4 Î¼mÂ²/s

**Recommendations:**
- Try D = 0.5, 1.0, 2.0 to see effect on trajectories
- Adjust D to match your system of interest

---

## Expected Output

### Console Output Example

```
Simulating 2D Brownian motion...

=== Simulation Results ===
Number of steps: 2000
Time step: 0.0100 s
Total simulation time: 20.00 s
Diffusion coefficient: 1.000 Î¼mÂ²/s

Final position: (3.472, -5.891) Î¼m
Final distance from origin: 6.846 Î¼m
Final MSD: 46.868 Î¼mÂ²
Theoretical MSD at final time: 80.000 Î¼mÂ²

=== Important Note ===
For a SINGLE particle, the MSD curve will be noisy and may deviate
significantly from the theoretical prediction. This is expected!
Run the simulation multiple times to see different trajectories.
For smoother MSD curves, use ensemble averaging with multiple particles.
```

### Interpretation

- **Final position**: Where the particle ended up (random each run)
- **Final distance**: How far from origin (âˆš(xÂ² + yÂ²))
- **Final MSD**: The actual squared distance at end time
- **Theoretical MSD**: What Einstein's equation predicts (4Dt)

**Note**: These values change every time you run the simulation due to randomness!

---

## Troubleshooting

### Issue: MSD doesn't match theory well

**Cause**: Single particle trajectories are inherently noisy

**Solutions:**
- This is expected! Run simulation multiple times
- Use more steps (n_steps = 5000 or more)
- For smoother curves, average multiple independent runs
- Or use ensemble averaging (multiple particles)

### Issue: Particle moves too fast or too slow

**Solution**: Adjust diffusion coefficient D
- Decrease D for slower diffusion
- Increase D for faster diffusion

### Issue: Plots are too crowded or hard to read

**Solutions:**
- Reduce n_steps for simpler trajectories
- Adjust figure size in code
- Zoom in on specific regions of plots

### Issue: Code runs slowly

**Solutions:**
- Reduce n_steps (try 1000 or 500)
- Close other figures before running
- Ensure MATLAB has sufficient memory

### Issue: Error messages

**Common errors:**
- "Index exceeds array dimensions": Check n_steps is positive integer
- "Out of memory": Reduce n_steps
- Make sure all parameters are defined before simulation loop

---

## Further Exploration

### Experiments to Try

1. **Effect of Diffusion Coefficient:**
   - Run with D = 0.5, 1.0, 2.0
   - Compare trajectory sizes
   - Notice MSD slopes change

2. **Time Resolution:**
   - Keep n_steps Ã— dt constant
   - Try different (n_steps, dt) combinations
   - Compare smoothness of trajectories

3. **Long-time Behavior:**
   - Use n_steps = 10000
   - Verify MSD remains linear even at long times

4. **Multiple Independent Runs:**
   - Run simulation 5-10 times manually
   - Observe different trajectories
   - Notice MSD varies but averages near theory

### Extensions (Advanced)

- Add drift velocity (biased random walk)
- Implement confined diffusion (boundaries)
- Add anomalous diffusion (MSD âˆ t^Î±, Î± â‰  1)
- 3D Brownian motion
- Ensemble averaging with multiple particles
- Time-dependent diffusion coefficient

---

## References

### Key Papers
1. Einstein, A. (1905). "On the motion of small particles suspended in liquids at rest required by the molecular-kinetic theory of heat." *Annalen der Physik*, 17, 549-560.

2. Perrin, J. (1909). "Brownian movement and molecular reality." *Annalen der Physik*, 18, 5-114.

### Textbooks
- Berg, H.C. (1993). *Random Walks in Biology*. Princeton University Press.
- Reif, F. (2009). *Fundamentals of Statistical and Thermal Physics*. Waveland Press.
- Van Kampen, N.G. (2007). *Stochastic Processes in Physics and Chemistry*. Elsevier.

### Online Resources
- Einstein's original paper (English translation): [available at various archives]
- MIT OpenCourseWare: Statistical Mechanics lectures
- Wolfram MathWorld: Random Walk and Brownian Motion

---

## Summary

This simulation demonstrates:
âœ“ Random walk in 2D space  
âœ“ Calculation of mean square displacement  
âœ“ Verification of Einstein's diffusion equation  
âœ“ Visualization of stochastic particle motion  
âœ“ Understanding of statistical fluctuations  

**Key Takeaway**: Even though a single particle's motion is completely random, statistical properties (like MSD) follow predictable laws. This is the essence of statistical mechanics!

---

*README created for educational purposes. Feel free to modify and experiment with the code!*
