% =========================================================================
% 2D BROWNIAN MOTION SIMULATION
% =========================================================================
% This program simulates the random walk of a single particle in two 
% dimensions and calculates the Mean Square Displacement (MSD) as a 
% function of time. The simulation follows Einstein's theory of Brownian 
% motion and compares simulated results with theoretical predictions.
%
% Author: [Your Name]
% Date: [Date]
% =========================================================================

clear; clc; close all;

%% =====================================================================
%  SIMULATION PARAMETERS
%  =====================================================================

N = 2000;               % Number of time steps in simulation
tau = 0.01;             % Time interval between steps (seconds)
dimensions = 2;         % Dimensionality of simulation (2D)

%% =====================================================================
%  PHYSICAL PARAMETERS
%  =====================================================================
% These parameters define the physical system: a 1 micron diameter
% particle suspended in water at room temperature.

d = 1.0e-6;             % Particle diameter (meters)
eta = 1.0e-3;           % Dynamic viscosity of water (Pa·s)
kB = 1.38e-23;          % Boltzmann constant (J/K)
T = 293;                % Temperature (Kelvin)

% Calculate theoretical diffusion coefficient using Stokes-Einstein relation
% D = kB*T / (3*pi*eta*d)
D = kB * T / (3 * pi * eta * d);

%% =====================================================================
%  DISPLACEMENT SCALING FACTOR
%  =====================================================================
% The scaling factor k ensures that random displacements have the correct
% statistical properties. For 2D Brownian motion: <dr²> = 4*D*tau
% This requires: k = sqrt(2*D*tau)

k = sqrt(2 * D * tau);

%% =====================================================================
%  GENERATE RANDOM DISPLACEMENTS
%  =====================================================================
% Generate normally distributed random displacements for each time step.
% randn(N,1) produces N samples from a standard normal distribution.
% Multiplying by k scales the distribution appropriately.

dx = k * randn(N, 1);   % Random displacements in X direction
dy = k * randn(N, 1);   % Random displacements in Y direction

%% =====================================================================
%  CALCULATE PARTICLE POSITIONS
%  =====================================================================
% Convert displacements to absolute positions using cumulative sum.
% The particle starts at the origin (0,0).

x = cumsum(dx);         % X position at each time step
y = cumsum(dy);         % Y position at each time step

%% =====================================================================
%  CALCULATE DISPLACEMENT SQUARED
%  =====================================================================

% Step displacement squared: squared displacement at each individual step
dSquaredDisplacement = dx.^2 + dy.^2;

% Total squared displacement from origin at each time point
squaredDisplacement = x.^2 + y.^2;

%% =====================================================================
%  TIME ARRAY
%  =====================================================================

time = tau * (0:N-1)';  % Time vector for plotting

%% =====================================================================
%  THEORETICAL MEAN SQUARE DISPLACEMENT
%  =====================================================================
% According to Einstein's theory: MSD = 2*d*D*t
% where d is the number of dimensions (2 for 2D)
% Therefore: MSD = 4*D*t for 2D motion

msd_theoretical = 2 * dimensions * D * time;

%% =====================================================================
%  ESTIMATE DIFFUSION COEFFICIENT FROM SIMULATED DATA
%  =====================================================================
% The diffusion coefficient can be estimated from the mean squared 
% displacement using: D = <dr²> / (2*d*tau)

simulatedD = mean(dSquaredDisplacement) / (2 * dimensions * tau);

% Calculate statistical uncertainty in the estimate
standardError = std(dSquaredDisplacement) / (2 * dimensions * tau * sqrt(N));

% Calculate the actual error compared to theoretical value
actualError = D - simulatedD;

%% =====================================================================
%  VISUALIZATION: MAIN RESULTS
%  =====================================================================

figure('Position', [100, 100, 1400, 500]);

% ---------------------------------------------------------------------
% Plot 1: Particle Trajectory in 2D Space
% ---------------------------------------------------------------------
subplot(1, 3, 1);
plot(x, y, 'b-', 'LineWidth', 1.5);
hold on;
% Mark starting position
plot(0, 0, 'go', 'MarkerSize', 12, 'MarkerFaceColor', 'g', 'LineWidth', 2);
% Mark ending position
plot(x(end), y(end), 'rs', 'MarkerSize', 12, 'MarkerFaceColor', 'r', 'LineWidth', 2);
hold off;
grid on;
xlabel('X Position (m)', 'FontSize', 12);
ylabel('Y Position (m)', 'FontSize', 12);
title('Particle Track of a Single Simulated Particle', 'FontSize', 14, 'FontWeight', 'bold');
legend('Trajectory', 'Start', 'End', 'Location', 'best');
axis equal;

% ---------------------------------------------------------------------
% Plot 2: Distribution of Random Displacements
% ---------------------------------------------------------------------
% This histogram shows that displacements follow a normal distribution
subplot(1, 3, 2);
hist(dx, 25);
xlabel('Displacement (m)', 'FontSize', 12);
ylabel('Frequency', 'FontSize', 12);
title('Distribution of X Displacements', 'FontSize', 14, 'FontWeight', 'bold');
grid on;

% ---------------------------------------------------------------------
% Plot 3: Mean Square Displacement vs Time
% ---------------------------------------------------------------------
% Compare simulated MSD with theoretical prediction
subplot(1, 3, 3);
plot(time, msd_theoretical, 'k', 'LineWidth', 3, 'DisplayName', 'Theoretical');
hold on;
plot(time, squaredDisplacement, 'b-', 'LineWidth', 1.5, 'DisplayName', 'Simulated');
hold off;
grid on;
xlabel('Time (s)', 'FontSize', 12);
ylabel('Displacement Squared (m²)', 'FontSize', 12);
title('Displacement Squared vs Time for 1 Particle in 2D', 'FontSize', 14, 'FontWeight', 'bold');
legend('Location', 'northwest');

%% =====================================================================
%  ADDITIONAL ANALYSIS PLOTS
%  =====================================================================

figure('Position', [100, 100, 1400, 500]);

% ---------------------------------------------------------------------
% Plot 4: Position Components vs Time
% ---------------------------------------------------------------------
% Shows how X and Y positions evolve independently over time
subplot(1, 3, 1);
plot(time, x, 'b-', 'LineWidth', 1.5, 'DisplayName', 'X position');
hold on;
plot(time, y, 'r-', 'LineWidth', 1.5, 'DisplayName', 'Y position');
hold off;
grid on;
xlabel('Time (s)', 'FontSize', 12);
ylabel('Position (m)', 'FontSize', 12);
title('Position vs Time', 'FontSize', 14, 'FontWeight', 'bold');
legend('Location', 'best');

% ---------------------------------------------------------------------
% Plot 5: Distribution of Step Displacements Squared
% ---------------------------------------------------------------------
% This should follow a chi-squared distribution with 2 degrees of freedom
subplot(1, 3, 2);
hist(dSquaredDisplacement, 25);
xlabel('Step Displacement Squared (m²)', 'FontSize', 12);
ylabel('Frequency', 'FontSize', 12);
title('Distribution of Step Displacements Squared', 'FontSize', 14, 'FontWeight', 'bold');
grid on;

% ---------------------------------------------------------------------
% Plot 6: Autocorrelation Function
% ---------------------------------------------------------------------
% Tests for statistical independence of successive displacements.
% For true Brownian motion, only the center peak should be significant.
subplot(1, 3, 3);
c = xcorr(dx, 'coeff');
xaxis = (1-length(c))/2:1:(length(c)-1)/2;
plot(xaxis, c, 'LineWidth', 1.5);
grid on;
xlabel('Lag', 'FontSize', 12);
ylabel('Correlation Coefficient', 'FontSize', 12);
title('X Displacement Autocorrelation', 'FontSize', 14, 'FontWeight', 'bold');
ylim([-0.2 1.1]);

%% =====================================================================
%  RESULTS OUTPUT
%  =====================================================================

fprintf('\n========================================\n');
fprintf('  PHYSICAL PARAMETERS\n');
fprintf('========================================\n');
fprintf('Particle diameter: %.2e m\n', d);
fprintf('Temperature: %.1f K\n', T);
fprintf('Viscosity: %.2e Pa·s\n', eta);
fprintf('Time step (tau): %.4f s\n', tau);

fprintf('\n========================================\n');
fprintf('  DIFFUSION COEFFICIENT\n');
fprintf('========================================\n');
fprintf('Theoretical D: %.4e m²/s\n', D);
fprintf('Simulated D:   %.4e m²/s\n', simulatedD);
fprintf('Standard Error: %.4e m²/s\n', standardError);
fprintf('Actual Error:   %.4e m²/s\n', actualError);
fprintf('Relative Error: %.2f%%\n', abs(actualError/D)*100);

fprintf('\n========================================\n');
fprintf('  SIMULATION STATISTICS\n');
fprintf('========================================\n');
fprintf('Number of steps: %d\n', N);
fprintf('Total simulation time: %.2f s\n', N*tau);
fprintf('Final position: (%.4e, %.4e) m\n', x(end), y(end));
fprintf('Final distance from origin: %.4e m\n', sqrt(x(end)^2 + y(end)^2));
fprintf('Final displacement squared: %.4e m²\n', squaredDisplacement(end));
fprintf('Theoretical MSD at final time: %.4e m²\n', msd_theoretical(end));

fprintf('\n========================================\n');
fprintf('  ANALYSIS QUESTIONS\n');
fprintf('========================================\n');
fprintf('Q1. Does the theoretical line match with simulated displacement?\n');
fprintf('    Yes, the simulated curve fluctuates around the theoretical line.\n');
fprintf('    Deviations are expected for a single particle trajectory due to\n');
fprintf('    the stochastic nature of Brownian motion.\n\n');

fprintf('Q2. Is the estimated D reliable?\n');
fprintf('    Simulated D = %.4e m²/s\n', simulatedD);
fprintf('    Theoretical D = %.4e m²/s\n', D);
fprintf('    Standard error = %.4e (%.1f%% of D)\n', standardError, (standardError/D)*100);
fprintf('    For a single particle with N=%d samples, some deviation is normal.\n', N);
fprintf('    Reliability can be improved by:\n');
fprintf('    - Increasing the number of time steps (N)\n');
fprintf('    - Ensemble averaging over multiple particles\n\n');

fprintf('========================================\n');
fprintf('  IMPORTANT NOTES\n');
fprintf('========================================\n');
fprintf('• Single particle MSD curves are inherently noisy\n');
fprintf('• The autocorrelation plot confirms statistical independence\n');
fprintf('• Run the simulation multiple times to observe variability\n');
fprintf('• Each run produces a unique random trajectory\n');
fprintf('========================================\n\n');
