% visualization/plot_stress_comparison.m
function plot_stress_comparison(results, mesh_sizes)
% Plot stress comparison along x=2 for different mesh sizes
% Inputs:
%   results - results structure
%   mesh_sizes - array of mesh sizes

    figure;
    hold on;
    colors = {'r', 'g', 'b', 'k'};
    markers = {'o', 's', '^', 'd'};
    lineStyles = {'-', '--'};
    
    elementTypes = fieldnames(results);
    for et = 1:length(elementTypes)
        elementType = elementTypes{et};
        
        for i = 1:length(mesh_sizes)
            if ~isempty(results.(elementType).sigma_yy_at_x2{i})
                lstyle = lineStyles{mod(et-1,2)+1};
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
    title('\sigma_{yy} along x = 2 for different mesh sizes and element types');
    legend('Location', 'best');
    grid on;
end