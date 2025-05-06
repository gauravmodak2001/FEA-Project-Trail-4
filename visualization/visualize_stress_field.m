function visualize_stress_field(meshData, stresses, elementType, h)
% Visualize stress field (sigma_yy)
% Inputs:
%   meshData - mesh data structure
%   stresses - stress data structure
%   elementType - 'Q4' or 'Q8'
%   h - mesh size

    figure;
    scatter(stresses.centers(:,1), stresses.centers(:,2), 50, stresses.sigma_yy, 'filled');
    colorbar;
    colormap('jet');
    axis equal;
    title(sprintf('\\sigma_{yy} field for %s elements, h = %.3f', elementType, h));
    xlabel('x'); ylabel('y');
    xlim([0, max(stresses.centers(:,1))+0.1]);
    ylim([0, max(stresses.centers(:,2))+0.1]);
    
    % Add annotation for boundary conditions
    text(0.1, 0.1, 'Bottom: v=0 (roller)', 'FontSize', 10);
    text(1.5, 3, 'Right: u=0 (roller)', 'FontSize', 10, 'Rotation', 90);
    
    % Mark load location
    hold on;
    plot(2, 6, 'rv', 'MarkerSize', 12, 'MarkerFaceColor', 'r');
    text(2.1, 6, 'F=20', 'FontSize', 12, 'Color', 'r');
end