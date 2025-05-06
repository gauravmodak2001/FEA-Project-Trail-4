% analysis/demonstrate_distributed_load.m
function demonstrate_distributed_load(params)
% Demonstrate distributed load approach to avoid stress singularity
% Input:
%   params - problem parameters

    % Generate fine mesh for demonstration
    h = 0.125;
    elementType = 'Q4';
    
    % Generate mesh
    meshData = generate_mesh(params.width, params.height, h, elementType);
    
    % Create distributed load
    nodes = meshData.nodes;
    ndof = 2 * size(nodes, 1);
    F_distributed = zeros(ndof, 1);
    
    % Find nodes near upper right corner
    corner_x = params.width;
    corner_y = params.height;
    load_radius = 0.25; % Distribute load over this radius
    
    near_corner = find(sqrt((nodes(:,1) - corner_x).^2 + ...
                           (nodes(:,2) - corner_y).^2) < load_radius);
    
    if isempty(near_corner)
        % If no nodes within radius, use closest nodes
        distances = sqrt((nodes(:,1) - corner_x).^2 + (nodes(:,2) - corner_y).^2);
        [~, sorted_idx] = sort(distances);
        near_corner = sorted_idx(1:min(4, length(sorted_idx)));
    end
    
    % Distribute force equally among selected nodes
    num_load_nodes = length(near_corner);
    force_per_node = -params.F / num_load_nodes;
    
    for n = near_corner'
        F_distributed(2*n) = force_per_node;
    end
    
    % Run analysis with distributed load
    [solution_dist, stresses_dist] = run_distributed_load_analysis(meshData, params, F_distributed);
    
    % Run analysis with point load for comparison
    [solution_point, stresses_point] = run_fea_analysis(meshData, params, elementType);
    
    % Compare results
    figure;
    subplot(1,2,1);
    scatter(stresses_point.centers(:,1), stresses_point.centers(:,2), ...
            50, stresses_point.sigma_yy, 'filled');
    colorbar;
    colormap('jet');
    axis equal;
    title('Point Load - \sigma_{yy}');
    xlabel('x'); ylabel('y');
    caxis_limits = caxis;
    
    subplot(1,2,2);
    scatter(stresses_dist.centers(:,1), stresses_dist.centers(:,2), ...
            50, stresses_dist.sigma_yy, 'filled');
    colorbar;
    colormap('jet');
    axis equal;
    title('Distributed Load - \sigma_{yy}');
    xlabel('x'); ylabel('y');
    caxis(caxis_limits);
    
    % Extract max stress near corner for both cases
    max_stress_point = extract_stress_at_y6(meshData, stresses_point);
    max_stress_dist = extract_stress_at_y6(meshData, stresses_dist);
    
    fprintf('\n=== Distributed Load Comparison ===\n');
    fprintf('Point load max stress near corner: %.3f\n', max_stress_point);
    fprintf('Distributed load max stress near corner: %.3f\n', max_stress_dist);
    fprintf('Stress reduction factor: %.3f\n', max_stress_point/max_stress_dist);
    fprintf('Number of nodes sharing load: %d\n', num_load_nodes);
end