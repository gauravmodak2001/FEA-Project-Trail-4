function visualize_element_centers(meshData, stresses)
% Visualize element centers for debugging
% Inputs:
%   meshData - mesh data structure
%   stresses - stress data structure

    figure;
    hold on;
    
    % Plot mesh
    nodes = meshData.nodes;
    elements = meshData.elements;
    
    % Get domain dimensions from nodes
    max_y = max(nodes(:,2));
    
    for e = 1:size(elements, 1)
        elem_nodes = elements(e, :);
        if strcmp(meshData.elementType, 'Q4')
            plot_order = [1 2 3 4 1];
        else
            plot_order = [1 5 2 6 3 7 4 8 1];
        end
        
        x_elem = nodes(elem_nodes(plot_order), 1);
        y_elem = nodes(elem_nodes(plot_order), 2);
        plot(x_elem, y_elem, 'b-', 'LineWidth', 1);
    end
    
    % Plot element centers
    scatter(stresses.centers(:,1), stresses.centers(:,2), 50, 'r', 'filled');
    
    % Highlight elements near x=2
    tolerance = 0.1;
    near_x2 = find(abs(stresses.centers(:,1) - 2) < tolerance);
    
    if ~isempty(near_x2)
        scatter(stresses.centers(near_x2,1), stresses.centers(near_x2,2), 100, 'g', 'filled');
    end
    
    % Draw vertical line at x=2
    plot([2 2], [0 max_y], 'r--', 'LineWidth', 2);
    
    axis equal;
    grid on;
    title(sprintf('Element Centers - %s (h=%.3f)', meshData.elementType, meshData.h));
    xlabel('x'); ylabel('y');
    legend('Mesh', 'All Centers', 'Centers near x=2', 'x=2 line', 'Location', 'best');
end