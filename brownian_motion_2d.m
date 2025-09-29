% 2D Brownian Motion Simulation - Single Particle
% Simulates random walk of ONE particle and calculates MSD

clear; clc; close all;

%% Simulation Parameters
n_steps = 2000;         % Number of time steps
dt = 0.01;              % Time step (s)
D = 1.0;                % Diffusion coefficient (μm²/s)

% Calculate step size based on diffusion coefficient
% For 2D: <Δr²> = 4*D*dt
step_size = sqrt(4*D*dt);

%% Initialize particle position
x = zeros(n_steps, 1);  % X positions
y = zeros(n_steps, 1);  % Y positions

% Start at origin
x(1) = 0;
y(1) = 0;

%% Simulate Brownian motion
fprintf('Simulating 2D Brownian motion...\n');

for t = 2:n_steps
    % Random angle for isotropic motion
    theta = 2*pi*rand();
    
    % Displacement in x and y directions
    dx = step_size * cos(theta);
    dy = step_size * sin(theta);
    
    % Update position
    x(t) = x(t-1) + dx;
    y(t) = y(t-1) + dy;
end

%% Calculate Mean Square Displacement (MSD)
time_array = (0:n_steps-1) * dt;
msd = zeros(n_steps, 1);

for t = 1:n_steps
    % Squared displacement from origin
    msd(t) = x(t)^2 + y(t)^2;
end

%% Theoretical MSD for comparison
% For 2D Brownian motion: MSD = 4*D*t
msd_theoretical = 4*D*time_array';

%% Plotting
figure('Position', [100, 100, 1400, 500]);

% Plot 1: Particle Trajectory
subplot(1, 3, 1);
plot(x, y, 'b-', 'LineWidth', 1.5);
hold on;
plot(x(1), y(1), 'go', 'MarkerSize', 12, 'MarkerFaceColor', 'g', ...
     'LineWidth', 2, 'DisplayName', 'Start');
plot(x(end), y(end), 'rs', 'MarkerSize', 12, 'MarkerFaceColor', 'r', ...
     'LineWidth', 2, 'DisplayName', 'End');
hold off;
grid on;
xlabel('X Position (μm)', 'FontSize', 12);
ylabel('Y Position (μm)', 'FontSize', 12);
title('2D Brownian Motion Trajectory', 'FontSize', 14, 'FontWeight', 'bold');
legend('Location', 'best');
axis equal;

% Plot 2: Position vs Time (both X and Y)
subplot(1, 3, 2);
plot(time_array, x, 'b-', 'LineWidth', 1.5, 'DisplayName', 'X position');
hold on;
plot(time_array, y, 'r-', 'LineWidth', 1.5, 'DisplayName', 'Y position');
hold off;
grid on;
xlabel('Time (s)', 'FontSize', 12);
ylabel('Position (μm)', 'FontSize', 12);
title('Position Components vs Time', 'FontSize', 14, 'FontWeight', 'bold');
legend('Location', 'best');

% Plot 3: Mean Square Displacement vs Time
subplot(1, 3, 3);
plot(time_array, msd, 'b-', 'LineWidth', 2, 'DisplayName', 'Simulated MSD');
hold on;
plot(time_array, msd_theoretical, 'r--', 'LineWidth', 2, 'DisplayName', 'Theoretical MSD (4Dt)');
hold off;
grid on;
xlabel('Time (s)', 'FontSize', 12);
ylabel('Mean Square Displacement (μm²)', 'FontSize', 12);
title('MSD vs Time', 'FontSize', 14, 'FontWeight', 'bold');
legend('Location', 'northwest', 'FontSize', 10);

%% Display Results
fprintf('\n=== Simulation Results ===\n');
fprintf('Number of steps: %d\n', n_steps);
fprintf('Time step: %.4f s\n', dt);
fprintf('Total simulation time: %.2f s\n', n_steps*dt);
fprintf('Diffusion coefficient: %.3f μm²/s\n', D);
fprintf('\nFinal position: (%.3f, %.3f) μm\n', x(end), y(end));
fprintf('Final distance from origin: %.3f μm\n', sqrt(x(end)^2 + y(end)^2));
fprintf('Final MSD: %.3f μm²\n', msd(end));
fprintf('Theoretical MSD at final time: %.3f μm²\n', msd_theoretical(end));

%% Note about single particle MSD
fprintf('\n=== Important Note ===\n');
fprintf('For a SINGLE particle, the MSD curve will be noisy and may deviate\n');
fprintf('significantly from the theoretical prediction. This is expected!\n');
fprintf('Run the simulation multiple times to see different trajectories.\n');
fprintf('For smoother MSD curves, use ensemble averaging with multiple particles.\n');