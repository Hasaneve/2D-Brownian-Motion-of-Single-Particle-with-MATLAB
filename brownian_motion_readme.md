# 2D Brownian Motion Simulation - Complete Guide

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
10. [Questions and Answers](#questions-and-answers)

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
- Jean Perrin's 1909 experimental verification earned him the Nobel Prize
- Foundation for understanding diffusion, molecular transport, and stochastic processes

**Modern Applications:**
- Drug delivery in biological systems
- Single-molecule tracking in cells
- Financial modeling (stock price movements)
- Polymer physics and rheology
- Colloidal suspension studies
- Nanoscale transport phenomena

---

## Theory

### Random Walk Model

Brownian motion can be modeled as a **random walk**:
- At each time step, the particle moves a random distance in a random direction
- The displacement has no memory of previous steps (Markov process)
- All directions are equally probable (isotropic)
- Each displacement is drawn from a normal (Gaussian) distribution

### Mean Square Displacement (MSD)

The **Mean Square Displacement** is the average of the squared distance from the starting position:

```
MSD(t) = ⟨r²(t)⟩ = ⟨[x(t) - x(0)]² + [y(t) - y(0)]²⟩
```

For our simulation starting at the origin (x₀ = 0, y₀ = 0):

```
MSD(t) = ⟨x²(t) + y²(t)⟩
```

### Einstein's Diffusion Equation

Einstein showed that for Brownian motion in **d dimensions**, the MSD grows linearly with time:

```
⟨r²(t)⟩ = 2dDt
```

Where:
- **d** = Number of dimensions (2 for 2D)
- **D** = Diffusion coefficient (units: length²/time, e.g., m²/s)
- **t** = Time elapsed

**For 2D motion:** `MSD = 4Dt`

### Stokes-Einstein Relation

The diffusion coefficient for a spherical particle is given by:

```
D = kᵦT / (3πηd)
```

Where:
- **kᵦ** = Boltzmann's constant (1.38 × 10⁻²³ J/K)
- **T** = Absolute temperature (K)
- **η** = Dynamic viscosity of the fluid (Pa·s)
- **d** = Particle diameter (m)

This shows that diffusion depends on:
- **Temperature**: Higher T → faster diffusion
- **Particle size**: Larger d → slower diffusion
- **Fluid viscosity**: Higher η → slower diffusion

### Why MSD Instead of Mean Displacement?

The **mean displacement** ⟨r(t)⟩ = 0 because the particle moves randomly in all directions (positive and negative displacements cancel out). The **MSD** captures the spread of the particle distribution and quantifies how far the particle diffuses from its starting point.

---

## Simulation Method

### Algorithm Overview

Our simulation implements a **discrete random walk** using the following steps:

1. **Define Physical System**: Specify particle size, temperature, fluid properties

2. **Calculate Diffusion Coefficient**: Use Stokes-Einstein relation

3. **Calculate Scaling Factor**: `k = √(2Dτ)` where τ is the time step

4. **Generate Random Displacements**:
   - Draw dx from normal distribution: `dx = k × randn(N,1)`
   - Draw dy from normal distribution: `dy = k × randn(N,1)`

5. **Convert to Positions**: Use cumulative sum
   - `x = cumsum(dx)`
   - `y = cumsum(dy)`

6. **Calculate MSD**: `r²(t) = x²(t) + y²(t)` at each time point

7. **Compare with Theory**: Plot simulated MSD vs theoretical prediction

### Mathematical Foundation

#### Why k = √(2Dτ)?

For each time step τ, we want:
```
⟨(dx)² + (dy)²⟩ = 4Dτ  (for 2D)
```

Since dx and dy are independent normal distributions with standard deviation σ:
```
⟨(dx)²⟩ = σ² and ⟨(dy)²⟩ = σ²
⟨(dx)² + (dy)²⟩ = 2σ²
```

Setting 2σ² = 4Dτ gives:
```
σ = √(2Dτ) = k
```

#### Normal Distribution

The function `randn(N,1)` generates N samples from a **standard normal distribution**:
- Mean = 0
- Standard deviation = 1
- Multiplying by k scales the standard deviation to σ = k

### Isotropy (Direction Independence)

By using independent random variables for dx and dy:
- All directions are equally likely
- No preferred direction of motion
- Models true Brownian motion in an isotropic (uniform) medium

---

## Program Structure

### Main Components

```
Program Flow:
│
├── 1. Parameter Setup
│   ├── Simulation parameters (N, τ, dimensions)
│   ├── Physical parameters (d, η, T)
│   ├── Calculate D (diffusion coefficient)
│   └── Calculate k (scaling factor)
│
├── 2. Generate Random Walk
│   ├── Create random displacements (dx, dy)
│   ├── Convert to positions (x, y)
│   └── Calculate displacement squared
│
├── 3. Theoretical Predictions
│   ├── Calculate theoretical MSD = 4Dt
│   └── Estimate D from simulated data
│
├── 4. Statistical Analysis
│   ├── Calculate standard error
│   ├── Compute autocorrelation
│   └── Analyze distributions
│
└── 5. Visualization
    ├── Trajectory plot
    ├── Displacement distributions
    ├── MSD vs time
    ├── Position vs time
    └── Autocorrelation function
```

### Key Variables

| Variable | Description | Units | Type |
|----------|-------------|-------|------|
| `N` | Number of time steps | - | Integer |
| `tau` | Time interval | s | Float |
| `dimensions` | Spatial dimensions | - | Integer (2) |
| `d` | Particle diameter | m | Float |
| `eta` | Fluid viscosity | Pa·s | Float |
| `kB` | Boltzmann constant | J/K | Constant |
| `T` | Temperature | K | Float |
| `D` | Diffusion coefficient | m²/s | Float |
| `k` | Scaling factor | m | Float |
| `dx, dy` | Step displacements | m | Arrays (N×1) |
| `x, y` | Cumulative positions | m | Arrays (N×1) |
| `dSquaredDisplacement` | Step MSD | m² | Array (N×1) |
| `squaredDisplacement` | Total MSD from origin | m² | Array (N×1) |
| `msd_theoretical` | Theoretical MSD | m² | Array (N×1) |

---

## How to Run

### Prerequisites
- MATLAB (R2016a or later recommended)
- No additional toolboxes required
- Basic understanding of MATLAB syntax helpful but not required

### Step-by-Step Instructions

1. **Save the code**
   - Save as `brownian_motion_2d.m` in your working directory

2. **Open MATLAB**
   - Launch MATLAB application
   - Navigate to the directory containing your file

3. **Run the simulation**
   ```matlab
   brownian_motion_2d
   ```
   Or simply press the **Run** button (green triangle) in the MATLAB editor

4. **View results**
   - Two figure windows will appear with 6 plots total
   - Console output displays numerical results and analysis

### Modifying Parameters

You can experiment with different conditions by editing these parameters at the top of the code:

```matlab
N = 2000;               % Try: 500, 5000, 10000
tau = 0.01;             % Try: 0.001, 0.1
d = 1.0e-6;             % Try: 0.5e-6, 2.0e-6 (particle size)
T = 293;                % Try: 273, 310, 373 (temperature)
```

**After making changes:**
1. Save the file (Ctrl+S or Cmd+S)
2. Run the script again

---

## Understanding the Results

### Figure 1: Main Analysis

#### Plot 1: Particle Trajectory (X vs Y)

**What it shows:**
- The actual 2D path taken by the particle
- Green circle: Starting position (origin)
- Red square: Final position after N steps
- Blue line: Complete random walk trajectory

**What to look for:**
- Irregular, "jagged" path (not smooth curves)
- No systematic drift or preferred direction
- Random excursions from origin
- Each simulation run produces a completely different path

**Physical Interpretation:**
- This is what a real microscopic particle's path looks like
- The "jittery" nature reflects constant molecular bombardment
- Over time, the particle can wander far from its starting point

**Common Observations:**
- Sometimes the particle returns near the origin
- Sometimes it drifts far away
- The path may loop back on itself
- No two trajectories are ever the same

---

#### Plot 2: Distribution of X Displacements

**What it shows:**
- Histogram of all dx values (displacement steps in x-direction)
- Should approximate a bell curve (normal/Gaussian distribution)

**What to look for:**
- Symmetric distribution centered near zero
- Bell-shaped curve
- Most displacements near zero
- Few very large displacements at tails

**Physical Interpretation:**
- Small steps are more common than large steps
- Equal probability of moving left or right
- This is the signature of thermal fluctuations

**Why it matters:**
- Confirms that `randn()` is working correctly
- Validates the statistical model
- With more samples (larger N), the distribution becomes smoother

---

#### Plot 3: Displacement Squared vs Time

**What it shows:**
- Blue line: Simulated MSD (actual particle trajectory)
- Black line: Theoretical prediction (MSD = 4Dt)

**What to look for:**
- Overall upward trend (MSD increases with time)
- Blue line fluctuates around black line
- **Important**: Significant deviations are normal for single particle!
- General slope should match theoretical line

**Physical Interpretation:**
- Linear growth confirms diffusive behavior
- Fluctuations reflect the stochastic (random) nature
- Slope = 4D (can be used to measure diffusion coefficient)
- Steeper slope means faster diffusion

**Why the noise?**
- Single particle = one realization of a random process
- Like flipping coins: 10 flips might give 7 heads (not 5)
- Averaging many particles would smooth the curve
- This noise is physically realistic and expected!

**Common misunderstandings:**
- ❌ "The curve should exactly match theory" - No! Single particles are noisy
- ✅ "The average trend should follow theory" - Yes, correct interpretation

---

### Figure 2: Additional Analysis

#### Plot 4: Position Components vs Time

**What it shows:**
- Blue: X-position over time
- Red: Y-position over time

**What to look for:**
- Both curves wander randomly up and down
- No systematic increase or decrease (no drift)
- X and Y are independent (no correlation)
- Variance increases with time (spread increases)

**Physical Interpretation:**
- Shows that motion in X doesn't affect motion in Y
- Both directions have equal mobility
- The particle diffuses equally in all directions

---

#### Plot 5: Distribution of Step Displacements Squared

**What it shows:**
- Histogram of dr² = dx² + dy² for each step

**What to look for:**
- Right-skewed distribution (not symmetric)
- Peak near zero, long tail to the right
- This is a **chi-squared distribution** with 2 degrees of freedom

**Physical Interpretation:**
- Adding squares of two normal variables creates this distribution
- Small squared displacements are most common
- Large squared displacements are rare but possible

**Statistical significance:**
- Mean should equal 2k² = 4Dτ
- This validates the simulation methodology

---

#### Plot 6: Autocorrelation Function

**What it shows:**
- Correlation between displacement at one time and displacements at other times
- Center peak at lag = 0 (displacement always correlates with itself)

**What to look for:**
- Sharp peak at zero lag
- All other values should be near zero (between -0.2 and +0.2)
- No systematic pattern away from center

**Physical Interpretation:**
- **Sharp peak only at center** = True Brownian motion (no memory)
- Each step is independent of all previous steps
- This confirms the Markov property

**What if it looks different?**
- Broad peak: Displacements are correlated (not true Brownian motion)
- Multiple peaks: Periodic motion (not random)
- Systematic pattern: Some physical coupling between steps

**This is a quality check**: Our simulation should show only the center peak.

---

## Parameters Explained

### Number of Steps (N)

**Default**: 2000

**Physical meaning:**
- Number of observations taken
- Duration of experiment = N × τ

**Effect on simulation:**
- **Larger N**: 
  - Longer trajectory
  - Better statistics for estimating D
  - Smoother average behavior
  - More computation time
- **Smaller N**:
  - Shorter trajectory
  - More statistical uncertainty
  - Faster computation

**Recommendations:**
- Minimum: 500 steps (for basic visualization)
- Standard: 1000-2000 steps (good balance)
- High precision: 5000-10000 steps (better statistics)
- Very large: >50000 (may be slow, diminishing returns)

**Physical analogy:**
- Like watching a particle under microscope for longer time
- Real experiments: ~50-500 frames (limited by photobleaching, drift)

---

### Time Step (tau, τ)

**Default**: 0.01 seconds

**Physical meaning:**
- Time interval between successive observations
- Frame rate = 1/τ (e.g., τ = 0.1s → 10 fps)

**Effect on simulation:**
- **Smaller τ**:
  - Finer time resolution
  - More samples per unit time
  - Smaller displacements per step
  - Better for fast processes
- **Larger τ**:
  - Coarser time resolution
  - Fewer samples per unit time
  - Larger displacements per step
  - Better for slow processes

**Important constraint:**
- Must satisfy: τ << characteristic timescale
- For diffusion: τ should be small enough that particle doesn't move too far

**Recommendations:**
- Fast diffusion (small particles): τ = 0.001 - 0.01 s
- Standard conditions: τ = 0.01 - 0.1 s
- Slow diffusion (large particles): τ = 0.1 - 1.0 s

**Trade-off:**
- Smaller τ → more precision but longer simulation
- Keep N × τ constant to maintain total observation time

---

### Particle Diameter (d)

**Default**: 1.0 × 10⁻⁶ m (1 micron)

**Physical meaning:**
- Size of the diffusing particle
- Directly affects diffusion rate via Stokes drag

**Effect on simulation:**
- **Larger particles** (↑d):
  - Slower diffusion (D ∝ 1/d)
  - Smaller displacements
  - Easier to track experimentally
- **Smaller particles** (↓d):
  - Faster diffusion
  - Larger displacements
  - Harder to track experimentally

**Typical values:**
- Small molecules: ~10⁻⁹ m (1 nm)
- Proteins: ~10⁻⁸ m (10 nm)
- Viruses: ~10⁻⁷ m (100 nm)
- Bacteria: ~10⁻⁶ m (1 μm)
- Synthetic beads: 0.5-10 × 10⁻⁶ m

**Example:**
```matlab
d = 0.5e-6;  % 0.5 micron → D will be 2× larger → faster motion
d = 2.0e-6;  % 2 micron → D will be 2× smaller → slower motion
```

---

### Temperature (T)

**Default**: 293 K (20°C, room temperature)

**Physical meaning:**
- Absolute temperature of the system
- Measure of thermal energy (kᵦT)

**Effect on simulation:**
- **Higher T**:
  - More thermal energy
  - Faster molecular motion
  - Larger diffusion coefficient (D ∝ T)
  - Larger displacements
- **Lower T**:
  - Less thermal energy
  - Slower motion
  - Smaller diffusion coefficient

**Typical values:**
- Ice water: 273 K (0°C)
- Room temperature: 293 K (20°C)
- Body temperature: 310 K (37°C)
- Hot water: 373 K (100°C)

**Physical insight:**
- D increases linearly with T
- At 310K vs 293K: D is ~6% larger
- Brownian motion stops at absolute zero (T = 0K)

---

### Viscosity (eta, η)

**Default**: 1.0 × 10⁻³ Pa·s (water at 20°C)

**Physical meaning:**
- Resistance of fluid to flow
- "Thickness" of the fluid

**Effect on simulation:**
- **Higher η** (thicker fluid):
  - More drag on particle
  - Slower diffusion (D ∝ 1/η)
  - Smaller displacements
- **Lower η** (thinner fluid):
  - Less drag
  - Faster diffusion
  - Larger displacements

**Typical values:**
- Air: 1.8 × 10⁻⁵ Pa·s
- Water (20°C): 1.0 × 10⁻³ Pa·s
- Water (37°C): 0.7 × 10⁻³ Pa·s
- Blood plasma: 1.2 × 10⁻³ Pa·s
- Olive oil: 0.08 Pa·s
- Honey: 10 Pa·s
- Glycerol: 1.4 Pa·s

**Temperature dependence:**
- Viscosity decreases with temperature
- Hot water is less viscous than cold water

---

## Expected Output

### Console Output

```
========================================
  PHYSICAL PARAMETERS
========================================
Particle diameter: 1.00e-06 m
Temperature: 293.0 K
Viscosity: 1.00e-03 Pa·s
Time step (tau): 0.0100 s

========================================
  DIFFUSION COEFFICIENT
========================================
Theoretical D: 4.2902e-13 m²/s
Simulated D:   4.1834e-13 m²/s
Standard Error: 1.3421e-14 m²/s
Actual Error:   1.0680e-14 m²/s
Relative Error: 2.49%

========================================
  SIMULATION STATISTICS
========================================
Number of steps: 2000
Total simulation time: 20.00 s
Final position: (3.472e-06, -5.891e-06) m
Final distance from origin: 6.846e-06 m
Final displacement squared: 4.687e-11 m²
Theoretical MSD at final time: 3.432e-11 m²

========================================
  ANALYSIS QUESTIONS
========================================
Q1. Does the theoretical line match with simulated displacement?
    Yes, the simulated curve fluctuates around the theoretical line.
    Deviations are expected for a single particle trajectory due to
    the stochastic nature of Brownian motion.

Q2. Is the estimated D reliable?
    Simulated D = 4.1834e-13 m²/s
    Theoretical D = 4.2902e-13 m²/s
    Standard error = 1.3421e-14 (3.1% of D)
    For a single particle with N=2000 samples, some deviation is normal.
    Reliability can be improved by:
    - Increasing the number of time steps (N)
    - Ensemble averaging over multiple particles

========================================
  IMPORTANT NOTES
========================================
• Single particle MSD curves are inherently noisy
• The autocorrelation plot confirms statistical independence
• Run the simulation multiple times to observe variability
• Each run produces a unique random trajectory
========================================
```

### Interpretation Guide

**Numbers will vary each run!** This is correct - Brownian motion is random.

**Typical ranges:**
- Relative error: 1-10% is excellent for single particle
- Standard error: Usually 1-5% of D
- Final position: Completely random, anywhere within several microns
- MSD comparison: Simulated should be within factor of 2 of theoretical

**Red flags (something might be wrong):**
- Relative error > 50%
- MSD that doesn't increase with time
- All displacements exactly the same
- Autocorrelation with multiple peaks

---

## Troubleshooting

### Issue: MSD doesn't follow theoretical line closely

**Symptom:** Blue curve in Plot 3 deviates significantly from black line

**Diagnosis:** This is NORMAL for single particle!

**Solutions:**
- ✅ This is expected behavior - don't "fix" it
- Run simulation multiple times to see variability
- Use N = 5000 or more for smoother curves
- Understand that single trajectories are inherently noisy

**When to worry:**
- If simulated MSD is >5× or <0.2× theoretical → check parameters
- If MSD decreases with time → bug in code
- If curve is perfectly smooth → random number generator not working

---

### Issue: Estimated D differs significantly from theoretical D

**Symptom:** Relative error > 20-30%

**Possible causes:**
1. Too few samples (N too small)
2. Wrong units in parameters
3. Incorrect formula for k

**Solutions:**
```matlab
% Increase sample size
N = 5000;  % Instead of 500

% Check units
d = 1.0e-6;   % Must be in meters, not microns
eta = 1.0e-3; % Must be in Pa·s
T = 293;      % Must be in Kelvin, not Celsius

% Verify k formula
k = sqrt(2*D*tau);  % Correct for 2D
% NOT: k = sqrt(4*D*tau)  % This is wrong!
```

---

### Issue: Trajectory looks unrealistic

**Symptom 1:** Particle moves in straight line or circle

**Cause:** Random number generator not being called correctly

**Solution:**
```matlab
% Make sure you're using:
dx = k * randn(N,1);  % New random numbers each step

% NOT:
r = randn(1,1);
dx = k * r * ones(N,1);  % This reuses same random number!
```

**Symptom 2:** Particle doesn't move at all

**Cause:** k = 0 or very small

**Solution:**
```matlab
% Check that D is not zero
fprintf('D = %.4e\n', D);  % Should be ~10^-13 for 1 micron particle

% Check that k is reasonable
fprintf('k = %.4e\n', k);  % Should be ~10^-8 m for typical parameters
```

---

### Issue: Plots are empty or show errors

**Cause 1:** Variables not defined

**Solution:** Run entire script from beginning (don't run sections individually)

**Cause 2:** Figure windows closed prematurely

**Solution:** 
```matlab
% Re-run the script
brownian_motion_2d
```

---

### Issue: Code runs very slowly

**Symptom:** Takes more than a few seconds to run

**Causes & Solutions:**

```matlab
% 1. N is too large
N = 100000;  % This will be slow!
% Solution: Use N = 2000 for normal use

% 2. Multiple figure windows open
% Solution: Close extra figures
close all;

% 3. Computer low on memory
% Solution: Clear workspace
clear; clc;
```

---

### Issue: Autocorrelation plot shows broad peak or multiple peaks

**Symptom:** Plot 6 doesn't show sharp single peak at center

**Diagnosis:** This suggests displacements are correlated (non-Markovian)

**What this means:**
- If using our code as written: Shouldn't happen (likely plotting error)
- If you modified the code: You may have introduced correlations

**Check:**
```matlab
% Make sure each step uses NEW random numbers:
dx = k * randn(N,1);  % Generates N independent random numbers

% Make sure you're not doing:
dx(1) = k * randn();
for i = 2:N
    dx(i) = 0.9*dx(i-1) + 0.1*k*randn();  % This creates correlation!
end
```

---

### Issue: "Index exceeds array dimensions" error

**Cause:** N is not defined or is wrong type

**Solution:**
```matlab
% Make sure N is positive integer
N = 2000;          % Correct
% NOT:
N = 2000.5;        % Wrong: must be integer
N = -100;          % Wrong: must be positive
```

---

### Issue: "Out of memory" error

**Cause:** Arrays too large for available RAM

**Solutions:**
```matlab
% Reduce N
N = 1000;  % Instead of 100000

% Clear workspace first
clear; clc;

% Close figures
close all;
```

---

## Questions and Answers

Based on the lab guide questions:

### Q1: Does the theoretical line match approximately with your simulated displacement?

**Answer:**

Yes and no - it depends on what you mean by "match":

**Expected behavior:**
- The simulated MSD (blue curve) **fluctuates around** the theoretical line (black)
- The general **trend** matches (both increase linearly with time)
- The **average slope** should be similar

**Why exact matching is impossible:**
- Single particle trajectories are inherently random
- Significant deviations (±50% or more) are normal
- Sometimes simulated MSD is above theory, sometimes below
- Only the long-term average approaches theory

**Analogy:**
- Like predicting a coin flip average: Theory says 50% heads
- After 10 flips, you might get 7 heads (70%) - doesn't mean theory is wrong
- After 1000 flips, you'll be closer to 50%
- Same principle applies to Brownian motion

**Conclusion:** The match is approximate, with expected statistical fluctuations.

---

### Q2: Is this value enough reliable? Why or why not? Compare it with the theoretical one.

**Answer:**

The reliability depends on several factors:

**Quantitative assessment:**
```
Standard Error: ~1-3% of D (for N=2000)
Relative Error: ~2-10% typically
```

**Reliability increases with:**
1. **More samples (larger N)**
   - N = 500: Error ~10-20%
   - N = 2000: Error ~2-10%
   - N = 10000: Error ~1-3%

2. **Ensemble averaging**
   - Single particle: High variability
   - Average of 10 particles: Much better
   - Average of 100 particles: Very reliable

**Why single particle has limited reliability:**
- Random fluctuations are large
- One trajectory = one random realization
- Standard error ∝ 1/√N (uncertainty decreases slowly)

**Comparison with theory:**
- Typical difference: 2-10% for N=2000
- This is **acceptable** for single particle
- Shows simulation is working correctly

**Conclusion:** Moderately reliable for single particle. Excellent reliability requires either more samples or ensemble averaging.

---

### Q3: Try to enhance the magnitude of the bulk flow. Does the trajectory still look like Brownian motion? Is the estimated diffusion coefficient still significant?

**Note:** Our current code doesn't include bulk flow, but here's how to add it and what to expect:

**How to add bulk flow:**
```matlab
% After generating dx and dy, add constant drift
vx = 0.5 * k;  % Drift velocity in x
vy = 0.1 * k;  % Drift velocity in y

dx = dx + vx;
dy = dy + vy;
```

**Expected observations:**

**Trajectory:**
- No longer centered at origin
- Systematic drift in direction of flow
- Still shows random fluctuations superimposed on drift
- With large flow: Looks more like biased random walk than pure Brownian motion

**Diffusion coefficient estimate:**
- Will be **overestimated**
- Bulk flow adds to MSD: MSD = 4Dt + v²t²
- Quadratic term (v²t²) dominates at long times
- Estimated D increases with flow velocity

**Physical interpretation:**
- Common experimental artifact
- Can be caused by: convection, evaporation, temperature gradients
- Minimized by: short observation times, temperature control

---

### Q4: Does this value correspond better to the theoretical D than the one obtained with single simulation?

**Note:** Our current code shows single particle only, but if you simulate multiple particles:

**Expected answer: YES**

**Why ensemble averaging is better:**

**Single particle (N=2000):**
- Standard error: ~3% of D
- Can deviate 10-20% from theory
- High variability between runs

**10 particles averaged:**
- Standard error: ~1% of D
- Usually within 5% of theory
- Much more consistent

**100 particles averaged:**
- Standard error: ~0.3% of D
- Usually within 2% of theory
- Very stable estimate

**Mathematical reason:**
- Standard error ∝ 1/√(number of particles)
- 10 particles → √10 ≈ 3× improvement
- 100 particles → 10× improvement

**Conclusion:** Ensemble averaging dramatically improves reliability. This is why real experiments track many particles, not just one.

---

### Q5: How do you judge a motion Brownian or not using the correlation function?

**Answer:**

The **autocorrelation function** is a powerful diagnostic tool:

**True Brownian Motion (What to expect):**
- **Single sharp peak** at lag = 0
- All other values near zero (|correlation| < 0.2)
- Symmetric about zero lag
- No systematic pattern

**Physical interpretation:**
- Peak at lag=0: Displacement correlates with itself (trivial)
- Zero elsewhere: Each step is independent of all others
- This is the **Markov property** - no memory

**Non-Brownian Motion (Warning signs):**

1. **Broad peak** (spreads beyond lag=0)
   - Indicates: Correlated motion
   - Cause: Particle has inertia/momentum
   - Not in overdamped regime

2. **Multiple peaks**
   - Indicates: Periodic motion
   - Cause: Harmonic trap, directed transport
   - Not free diffusion

3. **Asymmetric pattern**
   - Indicates: Time-