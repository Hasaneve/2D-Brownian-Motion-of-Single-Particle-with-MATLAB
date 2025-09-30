# 2D Brownian Motion Simulation - Complete Guide

## Table of Contents
1. [Background](#background)
2. [Theory](#theory)
3. [Simulation Method](#simulation-method)
4. [Program Structure](#program-structure)
5. [How to Run](#how-to-run)
6. [Understanding the Results](#understanding-the-results)
7. [Parameters](#parameters)
8. [Troubleshooting](#troubleshooting)
9. [Lab Questions](#lab-questions)
10. [References](#references)

---

## Background

### What is Brownian Motion?

Brownian motion is the random movement of microscopic particles suspended in a fluid, caused by constant bombardment from fluid molecules. First observed by botanist Robert Brown in 1827, it provided crucial evidence for the atomic nature of matter.

**Modern Applications:**
- Drug delivery systems
- Single-molecule tracking
- Financial modeling
- Nanoscale transport

---

## Theory

### Einstein's Diffusion Equation

For 2D Brownian motion, the Mean Square Displacement (MSD) grows linearly with time:

```
MSD(t) = ⟨r²(t)⟩ = 4Dt
```

Where:
- **D** = Diffusion coefficient (m²/s)
- **t** = Time elapsed (s)
- **r²** = x² + y² (squared distance from origin)

### Stokes-Einstein Relation

```
D = kᵦT / (3πηd)
```

Where:
- **kᵦ** = Boltzmann's constant (1.38 × 10⁻²³ J/K)
- **T** = Temperature (K)
- **η** = Fluid viscosity (Pa·s)
- **d** = Particle diameter (m)

---

## Simulation Method

### Algorithm Steps

1. Calculate diffusion coefficient D from physical parameters
2. Compute scaling factor: k = √(2Dτ)
3. Generate random displacements: dx = k × randn(N,1), dy = k × randn(N,1)
4. Convert to positions: x = cumsum(dx), y = cumsum(dy)
5. Calculate MSD: r²(t) = x²(t) + y²(t)
6. Compare with theory: MSD_theory = 4Dt

### Why k = √(2Dτ)?

For 2D motion: ⟨(dx)² + (dy)²⟩ = 4Dτ

Since dx and dy are independent with variance σ²:
⟨(dx)² + (dy)²⟩ = 2σ²

Setting 2σ² = 4Dτ gives σ = √(2Dτ) = k

---

## Program Structure

```
Main Components:
├── Parameter Setup (N, τ, d, η, T)
├── Calculate D and k
├── Generate Random Walk
│   ├── dx, dy (displacements)
│   └── x, y (positions via cumsum)
├── Calculate MSD
├── Statistical Analysis
└── Visualization (6 plots)
```

### Key Variables

| Variable | Description | Units |
|----------|-------------|-------|
| N | Number of time steps | - |
| tau | Time interval | s |
| D | Diffusion coefficient | m²/s |
| k | Scaling factor | m |
| dx, dy | Step displacements | m |
| x, y | Positions | m |
| squaredDisplacement | MSD from origin | m² |
| msd_theoretical | Theory prediction | m² |

---

## How to Run

1. Save code as `brownian_motion_2d.m`
2. Open MATLAB and navigate to file location
3. Run: `brownian_motion_2d` or press Run button
4. View two figure windows with 6 plots total

### Modify Parameters

Edit these at the top of the code:
```matlab
N = 2000;        % Try: 500, 5000, 10000
tau = 0.01;      % Try: 0.001, 0.1
d = 1.0e-6;      % Try: 0.5e-6, 2.0e-6
T = 293;         % Try: 273, 310, 373
```

---

## Understanding the Results

### Figure 1

**Plot 1: Particle Trajectory**
- Shows 2D random walk path
- Green circle = start, Red square = end
- Should look irregular and "tangled"
- No preferred direction

**Plot 2: Displacement Distribution**
- Histogram of dx values
- Should be bell-shaped (Gaussian)
- Centered at zero
- Symmetric

**Plot 3: MSD vs Time**
- Black line = theoretical (smooth, linear)
- Blue line = simulated (noisy, fluctuating)
- Blue should fluctuate around black
- Noise is NORMAL for single particle

### Figure 2

**Plot 4: Position vs Time**
- Blue = X position, Red = Y position
- Both should wander randomly
- No systematic drift
- Independent of each other

**Plot 5: Step Displacement Distribution**
- Right-skewed distribution
- Chi-squared with 2 degrees of freedom
- Peak near zero, long tail

**Plot 6: Autocorrelation**
- Single sharp peak at lag = 0
- All other values near zero
- Confirms statistical independence
- Validates Markov property

---

## Parameters

### N (Number of Steps)
- Default: 2000
- More steps = longer trajectory, better statistics
- Recommended range: 500-10000

### tau (Time Step)
- Default: 0.01 s
- Smaller = finer resolution
- Larger = coarser resolution
- Typical range: 0.001-0.1 s

### d (Particle Diameter)
- Default: 1.0 × 10⁻⁶ m (1 micron)
- Larger particles diffuse slower (D ∝ 1/d)
- Typical range: 0.5-10 microns

### T (Temperature)
- Default: 293 K (20°C)
- Higher T = faster diffusion (D ∝ T)
- Typical values: 273K (ice), 310K (body), 373K (boiling)

### eta (Viscosity)
- Default: 1.0 × 10⁻³ Pa·s (water at 20°C)
- Higher η = slower diffusion (D ∝ 1/η)
- Water at 37°C: 0.7 × 10⁻³ Pa·s

---

## Troubleshooting

### MSD doesn't match theory closely
- **Normal for single particle!** Fluctuations are expected
- Try N = 5000 for smoother curves
- Run multiple times to see variability

### Estimated D differs from theoretical D
- Check units (d in meters, not microns)
- Verify k = sqrt(2*D*tau), not sqrt(4*D*tau)
- Increase N for better statistics

### Trajectory looks unrealistic
- Ensure using new random numbers each step
- Check that D is not zero
- Verify k is reasonable (~10⁻⁸ m)

### Autocorrelation shows broad peak
- If using unmodified code: shouldn't happen
- If modified: may have introduced correlations
- Each step must use NEW randn() call

---

## Lab Questions

### Q1: Does theoretical line match simulated displacement?

**Answer:** Yes, approximately. The simulated MSD (blue curve) fluctuates around the theoretical line (black). Significant deviations (±50%) are normal for a single particle. The general trend and average slope should match. This is expected statistical behavior, not an error.

### Q2: Is the estimated D reliable?

**Answer:** Moderately reliable for single particle. Typical relative error: 2-10% for N=2000. Standard error is usually 1-3% of D. Reliability increases with:
- More samples (larger N)
- Ensemble averaging (multiple particles)

For single particle, this level of agreement is acceptable and demonstrates correct simulation.

### Q3: Effect of bulk flow on trajectory and D estimation?

**Answer:** With bulk flow added (constant drift):
- Trajectory shows systematic displacement in drift direction
- Still shows random fluctuations superimposed
- Estimated D is overestimated (flow adds to MSD)
- MSD curve shows quadratic component (v²t²)
- With large flow: no longer looks like pure Brownian motion

### Q4: Ensemble averaging vs single particle?

**Answer:** YES, ensemble averaging gives better D estimates:
- Single particle (N=2000): ~3% standard error, 10-20% deviation
- 10 particles: ~1% standard error, ~5% deviation
- 100 particles: ~0.3% standard error, ~2% deviation
- Improvement factor: 1/√(number of particles)

### Q5: Judging Brownian motion from autocorrelation?

**True Brownian Motion:**
- Single sharp peak at lag = 0
- All other values near zero (|r| < 0.2)
- Symmetric about zero
- No systematic pattern

**Non-Brownian Motion:**
- Broad peak → correlated motion (inertia)
- Multiple peaks → periodic motion (trap)
- Asymmetric → time-dependent drift
- Gradual decay → memory effects (viscoelastic)

**Criterion:** If |correlation| < 0.2 for all lags except 0, motion is consistent with Brownian motion.

---

## Calculating MSD for Your Report

Your code already calculates MSD automatically in the variable `squaredDisplacement`. For your report, you should:

### 1. Present the Plot
Show Plot 3 (MSD vs Time) with both simulated and theoretical curves.

### 2. Report Key Values
Add this code to extract values at specific times:

```matlab
fprintf('\n========================================\n');
fprintf('  MSD AT KEY TIME POINTS\n');
fprintf('========================================\n');
fprintf('Time(s)  MSD_sim(m²)      MSD_theory(m²)   Ratio\n');
fprintf('------------------------------------------------------\n');
time_points = [1, 5, 10, 15, 20];
for t = time_points
    idx = round(t/tau);
    if idx <= N
        ratio = squaredDisplacement(idx) / msd_theoretical(idx);
        fprintf('%6.1f   %.4e    %.4e    %.2f\n', ...
                t, squaredDisplacement(idx), msd_theoretical(idx), ratio);
    end
end
```

### 3. Include in Report
- The calculation formula: MSD(t) = x²(t) + y²(t)
- A table of values at key time points
- Final MSD value and comparison with theory
- Brief discussion of agreement/disagreement

---

## Tips for Lab Report

### Structure

1. **Introduction:** Background, objectives, theory
2. **Methods:** Simulation parameters and algorithm
3. **Results:** Plots, tables, numerical values
4. **Analysis:** Distributions, autocorrelation, error analysis
5. **Discussion:** Agreement with theory, physical interpretation
6. **Conclusions:** Summary and validation

### Key Statements

- "The trajectory exhibits random walk behavior consistent with Brownian motion"
- "Displacement distribution is Gaussian with mean zero"
- "MSD increases linearly with time, confirming Einstein's equation"
- "Autocorrelation shows no correlation between successive steps"
- "Estimated D = [value] agrees with theory within [X]% error"

### Common Mistakes to Avoid

- ❌ Expecting exact match between simulated and theoretical MSD
- ❌ Thinking smooth trajectories are better
- ❌ Believing large fluctuations indicate errors
- ✅ Understanding that single-particle noise is physically correct

---

## Further Experiments

Try these variations:

```matlab
% Temperature effect
T = 273; T = 310; T = 373;

% Particle size effect  
d = 0.5e-6; d = 2.0e-6; d = 10e-6;

% Viscosity effect
eta = 0.7e-3; eta = 1.8e-3; eta = 10e-3;

% Longer simulation
N = 10000;

% Different time resolution
tau = 0.001; tau = 0.1;
```

---

## Mathematical Details

### Step Size Derivation

Starting from MSD = 4Dt for 2D:
```
⟨Δr²⟩ = 4Dτ (for time step τ)
⟨(Δx)² + (Δy)²⟩ = 4Dτ
Since ⟨(Δx)²⟩ = ⟨(Δy)²⟩ = σ²
2σ² = 4Dτ
σ = √(2Dτ) = k
```

### Chi-Squared Distribution

When X ~ N(0,σ²) and Y ~ N(0,σ²) are independent:
```
Z = X² + Y² ~ χ²(2)
E[Z] = 2σ² = 4Dτ
```

This validates that mean(dSquaredDisplacement) = 4Dτ.

---

## References

### Essential Papers
1. Einstein, A. (1905). "Investigations on the Theory of Brownian Movement." *Annalen der Physik*, 17, 549-560.
2. Perrin, J. (1909). "Brownian Movement and Molecular Reality." Nobel Prize 1926.

### Textbooks
3. Berg, H.C. (1993). *Random Walks in Biology.* Princeton University Press.
4. Reif, F. (2009). *Fundamentals of Statistical and Thermal Physics.* Waveland Press.
5. Van Kampen, N.G. (2007). *Stochastic Processes in Physics and Chemistry.* Elsevier.

### Online Resources
- MATLAB Documentation: mathworks.com/help/matlab
- MIT OpenCourseWare: Statistical Mechanics
- Wolfram MathWorld: Random Walk articles

---

## Glossary

**Brownian Motion:** Random motion of particles in fluid from molecular collisions

**Diffusion Coefficient (D):** Rate of particle spreading, units m²/s

**MSD:** Mean Square Displacement, ⟨r²(t)⟩

**Autocorrelation:** Measure of correlation between variable and its past values

**Markov Process:** Future depends only on present, not past

**Chi-squared Distribution:** Distribution of sum of squared normal variables

**Isotropic:** Same properties in all directions

**Overdamped:** Regime where friction dominates over inertia

---

## Final Notes

**Remember:**
- Brownian motion is fundamentally random
- Single particle trajectories are highly variable
- Fluctuations around theory are expected and correct
- The beauty is that chaos follows predictable statistical laws

**Your simulation successfully demonstrates that:**
- Random molecular collisions create predictable diffusion
- Statistical mechanics works at the microscopic scale
- Einstein's 1905 theory accurately describes reality

Good luck with your assignment!

---

*Complete README - Version 1.0*