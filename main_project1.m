% main_project1.m
% Main script for Project 1: Stress singularities analysis
clc; clear; close all;

% Add paths to subdirectories
addpath('mesh_generation');
addpath('element_routines');
addpath('analysis');
addpath('visualization');

% Problem parameters
params.width = 2;
params.height = 6;
params.E = 70000;      % Young's modulus
params.nu = 0.33;      % Poisson's ratio
params.t = 0.3;        % thickness
params.F = 20;         % Applied force at upper right corner

% Material matrix for plane stress
params.D = (params.E/(1-params.nu^2)) * [1 params.nu 0; params.nu 1 0; 0 0 (1-params.nu)/2];

% Mesh sizes to test
mesh_sizes = [1, 0.5, 0.25, 0.125];

% Analysis options
options.elementTypes = {'Q4', 'Q8'};  % Element types to analyze

% Arrays to store all results
results = struct();

%% Run analysis for both element types
for et = 1:length(options.elementTypes)
    elementType = options.elementTypes{et};
    fprintf('\n====== Running %s Element Analysis ======\n', elementType);
    
    % Initialize storage for this element type
    results.(elementType).sigma_yy_at_x2 = cell(length(mesh_sizes), 1);
    results.(elementType).y_coords_at_x2 = cell(length(mesh_sizes), 1);
    results.(elementType).cpu_times = zeros(length(mesh_sizes), 1);
    results.(elementType).num_elements = zeros(length(mesh_sizes), 1);
    results.(elementType).stress_at_y6 = zeros(length(mesh_sizes), 1);
    
    % Run analysis for each mesh size
    for i = 1:length(mesh_sizes)
        h = mesh_sizes(i);
        fprintf('\nAnalyzing mesh size h = %.3f...\n', h);
        
        % Start timing
        tic;
        
        % Generate mesh
        meshData = generate_mesh(params.width, params.height, h, elementType);
        meshData.h = h; % Add h to meshData for convenience
        
        % Run FEA analysis
        [solution, stresses] = run_fea_analysis(meshData, params, elementType);
        
        % Extract results along x=2 (using robust extraction)
        [y_coords, sigma_yy] = extract_stress_along_x_robust(meshData, stresses, params.width);
        
        % Extract stress at y=6 (near the point load)
        stress_at_y6 = extract_stress_at_y6(meshData, stresses);
        
        % Stop timing
        cpu_time = toc;
        
        % Store results
        results.(elementType).sigma_yy_at_x2{i} = sigma_yy;
        results.(elementType).y_coords_at_x2{i} = y_coords;
        results.(elementType).cpu_times(i) = cpu_time;
        results.(elementType).num_elements(i) = meshData.numElems;
        results.(elementType).stress_at_y6(i) = stress_at_y6;
        
        % Part a: Plot mesh
        figure;
        visualize_mesh(meshData, elementType, h);
        title(sprintf('%s Mesh with h = %.3f', elementType, h));
        
        % Part b: Plot sigma_yy field
        visualize_stress_field(meshData, stresses, elementType, h);
        
        % Debug: Visualize element centers
        visualize_element_centers(meshData, stresses);
        
        fprintf('CPU time: %.3f seconds\n', cpu_time);
        fprintf('Number of elements: %d\n', meshData.numElems);
        fprintf('Max stress at y=6: %.3f\n', stress_at_y6);
    end
end

%% Part c: Plot sigma_yy vs y at x=2 for all mesh sizes
figure;
hold on;
colors = {'r', 'g', 'b', 'k'};
markers = {'o', 's', '^', 'd'};

for et = 1:length(options.elementTypes)
    elementType = options.elementTypes{et};
    
    for i = 1:length(mesh_sizes)
        if ~isempty(results.(elementType).sigma_yy_at_x2{i})
            if strcmp(elementType, 'Q4')
                lstyle = '-';
            else
                lstyle = '--';
            end
            
            plot(results.(elementType).y_coords_at_x2{i}, ...
                 results.(elementType).sigma_yy_at_x2{i}, ...
                 [lstyle markers{i}], ...
                 'Color', colors{i}, ...
                 'LineWidth', 1.5, ...
                 'MarkerFaceColor', colors{i}, ...
                 'DisplayName', sprintf('%s, h=%.3f', elementType, mesh_sizes(i)));
        end
    end
end

xlabel('y');
ylabel('\sigma_{yy}');
title('\sigma_{yy} along x = 2 for different mesh sizes');
legend('Location', 'best');
grid on;

%% Part e: Plot CPU time vs number of elements
figure;
loglog(results.Q4.num_elements, results.Q4.cpu_times, 'bo-', ...
       'LineWidth', 2, 'MarkerSize', 8, 'DisplayName', 'Q4 Elements');
hold on;
if isfield(results, 'Q8')
    loglog(results.Q8.num_elements, results.Q8.cpu_times, 'rs-', ...
           'LineWidth', 2, 'MarkerSize', 8, 'DisplayName', 'Q8 Elements');
end

xlabel('Number of Elements');
ylabel('CPU Time (seconds)');
title('Computational Time vs Number of Elements');
legend('Location', 'northwest');
grid on;

%% Part f: Analyze stress at y=6
figure;
semilogx(mesh_sizes, results.Q4.stress_at_y6, 'bo-', 'LineWidth', 2, 'DisplayName', 'Q4');
hold on;
if isfield(results, 'Q8')
    semilogx(mesh_sizes, results.Q8.stress_at_y6, 'rs-', 'LineWidth', 2, 'DisplayName', 'Q8');
end
xlabel('Mesh Size h');
ylabel('Maximum \sigma_{yy} at y=6');
title('Stress Singularity Effect: Max Stress at y=6 vs Mesh Size');
legend('Location', 'northeast');
grid on;

%% Display summary and comments
fprintf('\n=== Summary Statistics ===\n');
fprintf('Mesh Size\tQ4 Elements\tQ4 Time(s)\tQ4 Max Stress');
if isfield(results, 'Q8')
    fprintf('\tQ8 Elements\tQ8 Time(s)\tQ8 Max Stress');
end
fprintf('\n');
fprintf('--------------------------------------------------------------------------------\n');
for i = 1:length(mesh_sizes)
    fprintf('%.3f\t\t%d\t\t%.3f\t\t%.3f', ...
        mesh_sizes(i), ...
        results.Q4.num_elements(i), results.Q4.cpu_times(i), results.Q4.stress_at_y6(i));
    if isfield(results, 'Q8')
        fprintf('\t\t%d\t\t%.3f\t\t%.3f', ...
            results.Q8.num_elements(i), results.Q8.cpu_times(i), results.Q8.stress_at_y6(i));
    end
    fprintf('\n');
end

fprintf('\n=== Part f: Comments about stress singularity ===\n');
fprintf('As the mesh is refined (h decreases), the stress at y=6 increases.\n');
fprintf('This is characteristic of a stress singularity at the point load.\n');
fprintf('The stress theoretically approaches infinity as h approaches zero.\n');
fprintf('The effect of the point load dissipates as we move away from the corner.\n');

fprintf('\n=== Part g: General lessons ===\n');
fprintf('1. Point loads create stress singularities - theoretical infinite stress.\n');
fprintf('2. Mesh refinement leads to increasing stress values near singularities.\n');
fprintf('3. This model is sufficient for studying global behavior away from the singularity.\n');
fprintf('4. It is insufficient for accurate stress analysis near the point load.\n');

fprintf('\n=== Part h: Alternative loading strategy ===\n');
fprintf('To avoid stress singularity, distribute the load over a small area:\n');
fprintf('1. Apply load over several nodes near the corner\n');
fprintf('2. Use a pressure load over a small region\n');
fprintf('3. Model the actual contact area of the loading mechanism\n');

fprintf('\nAnalysis completed successfully!\n');