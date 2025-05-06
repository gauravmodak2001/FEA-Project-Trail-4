% visualization/visualize_mesh.m
function visualize_mesh(meshData, elementType, h)
% Visualize the mesh
% Inputs:
%   meshData - mesh data structure
%   elementType - 'Q4' or 'Q8'
%   h - mesh size

    nodes = meshData.nodes;
    elements = meshData.elements;
    
    figure;
    hold on;
    
    % Plot elements
    for e = 1:size(elements, 1)
        elem_nodes = elements(e, :);
        
        if strcmp(elementType, 'Q4')
            % For Q4, plot the boundary
            plot_order = [1 2 3 4 1];
        else
            % For Q8, plot through all nodes
            plot_order = [1 5 2 6 3 7 4 8 1];
        end
        
        x_elem = nodes(elem_nodes(plot_order), 1);
        y_elem = nodes(elem_nodes(plot_order), 2);
        plot(x_elem, y_elem, 'b-', 'LineWidth', 1);
    end
    
    % Plot nodes
    if strcmp(elementType, 'Q4')
        plot(nodes(:,1), nodes(:,2), 'ro', 'MarkerSize', 6, 'MarkerFaceColor', 'r');
    else
        % For Q8, distinguish corner and midside nodes
        all_corner_nodes = unique(elements(:, 1:4));
        all_midside_nodes = unique(elements(:, 5:8));
        
        plot(nodes(all_corner_nodes,1), nodes(all_corner_nodes,2), 'ro', 'MarkerSize', 6, 'MarkerFaceColor', 'r');
        plot(nodes(all_midside_nodes,1), nodes(all_midside_nodes,2), 'bs', 'MarkerSize', 4, 'MarkerFaceColor', 'b');
    end
    
    % Add element numbers for coarse meshes
    if h >= 0.5
        for e = 1:size(elements, 1)
            elem_nodes = elements(e, :);
            center = mean(nodes(elem_nodes(1:4), :));  % Use corner nodes for center
            text(center(1), center(2), num2str(e), ...
                 'HorizontalAlignment', 'center', ...
                 'FontSize', 10, 'FontWeight', 'bold', ...
                 'BackgroundColor', 'w');
        end
    end
    
    axis equal;
    grid on;
    title(sprintf('%s Mesh (h=%.3f) - %d elements, %d nodes', ...
          elementType, h, size(elements,1), size(nodes,1)));
    xlabel('x'); ylabel('y');
    xlim([-0.5, max(nodes(:,1))+0.5]);
    ylim([-0.5, max(nodes(:,2))+0.5]);
    
    if strcmp(elementType, 'Q8')
        legend('Corner nodes', 'Midside nodes', 'Location', 'northeast');
    end
end