% visualization/visualize_element_connectivity.m
function visualize_element_connectivity()
% Visualize element connectivity patterns for Q4 and Q8 elements

    % Q8 Element connectivity diagram
    figure('Position', [50, 50, 600, 500]);
    hold on;
    
    % Define a single Q8 element for demonstration
    demo_nodes = [0 0; 2 0; 2 2; 0 2; 1 0; 2 1; 1 2; 0 1];
    node_labels = {'1', '2', '3', '4', '5', '6', '7', '8'};
    
    % Plot the element with all connections
    % Corner nodes
    plot(demo_nodes(1:4,1), demo_nodes(1:4,2), 'ro', 'MarkerSize', 12, 'MarkerFaceColor', 'r');
    % Midside nodes  
    plot(demo_nodes(5:8,1), demo_nodes(5:8,2), 'bs', 'MarkerSize', 10, 'MarkerFaceColor', 'b');
    
    % Draw element edges
    edges = [1 5 2; 2 6 3; 3 7 4; 4 8 1];
    for i = 1:4
        plot(demo_nodes(edges(i,:),1), demo_nodes(edges(i,:),2), 'k-', 'LineWidth', 2);
    end
    
    % Add node labels
    for i = 1:8
        text(demo_nodes(i,1)+0.1, demo_nodes(i,2)+0.1, node_labels{i}, ...
             'FontSize', 14, 'FontWeight', 'bold');
    end
    
    % Add annotations
    text(1, -0.5, 'Q8 Element Node Numbering', 'HorizontalAlignment', 'center', ...
         'FontSize', 16, 'FontWeight', 'bold');
    text(1, -0.8, 'Corner nodes: 1-4 (red)', 'HorizontalAlignment', 'center', ...
         'FontSize', 12, 'Color', 'r');
    text(1, -1.1, 'Midside nodes: 5-8 (blue)', 'HorizontalAlignment', 'center', ...
         'FontSize', 12, 'Color', 'b');
    
    axis equal;
    xlim([-0.5, 2.5]);
    ylim([-1.5, 2.5]);
    grid on;
    title('Q8 Element Connectivity Pattern');
    
    % Q4 Element connectivity diagram
    figure('Position', [700, 50, 600, 500]);
    hold on;
    
    % Define a single Q4 element for demonstration
    demo_nodes_q4 = [0 0; 2 0; 2 2; 0 2];
    node_labels_q4 = {'1', '2', '3', '4'};
    
    % Plot the element with all connections
    plot(demo_nodes_q4(:,1), demo_nodes_q4(:,2), 'ro', 'MarkerSize', 12, 'MarkerFaceColor', 'r');
    
    % Draw element edges
    plot(demo_nodes_q4([1:end,1],1), demo_nodes_q4([1:end,1],2), 'k-', 'LineWidth', 2);
    
    % Add node labels
    for i = 1:4
        text(demo_nodes_q4(i,1)+0.1, demo_nodes_q4(i,2)+0.1, node_labels_q4{i}, ...
             'FontSize', 14, 'FontWeight', 'bold');
    end
    
    % Add annotations
    text(1, -0.5, 'Q4 Element Node Numbering', 'HorizontalAlignment', 'center', ...
         'FontSize', 16, 'FontWeight', 'bold');
    text(1, -0.8, 'Corner nodes: 1-4', 'HorizontalAlignment', 'center', ...
         'FontSize', 12);
    
    axis equal;
    xlim([-0.5, 2.5]);
    ylim([-1.2, 2.5]);
    grid on;
    title('Q4 Element Connectivity Pattern');
end