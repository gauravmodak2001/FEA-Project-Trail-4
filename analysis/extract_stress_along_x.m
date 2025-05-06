```matlab
function [y_coords, sigma_yy] = extract_stress_along_x(meshData, stresses, x_location)
% Extract stress along a vertical line at specified x location
% Inputs:
%   meshData - mesh data structure
%   stresses - stress data structure
%   x_location - x coordinate for extraction
% Outputs:
%   y_coords - y coordinates
%   sigma_yy - sigma_yy values

    centers = stresses.centers;
    sigma_yy_all = stresses.sigma_yy;
    
    % Find all elements near x=2 (with appropriate tolerance)
    tolerance = 0.1; % Adjust tolerance based on element size
    near_x2 = find(abs(centers(:,1) - x_location) < tolerance);
    
    fprintf('Looking for elements near x=%.3f with tolerance=%.3f\n', x_location, tolerance);
    fprintf('Found %d elements\n', length(near_x2));
    
    if isempty(near_x2)
        % If no elements found with current tolerance, find closest elements
        distances = abs(centers(:,1) - x_location);
        [sorted_dist, idx] = sort(distances);
        
        % Take elements within reasonable distance
        reasonable_dist = min(meshData.h, 0.5);
        near_x2 = idx(sorted_dist < reasonable_dist);
        
        fprintf('No elements found with initial tolerance. Using %d closest elements within distance %.3f\n', ...
                length(near_x2), reasonable_dist);
    end
    
    if ~isempty(near_x2)
        y_vals = centers(near_x2, 2);
        sigma_vals = sigma_yy_all(near_x2);
        
        % Sort by y coordinate
        [y_coords, sort_idx] = sort(y_vals);
        sigma_yy = sigma_vals(sort_idx);
        
        % For debugging
        fprintf('Y-coordinates range: [%.3f, %.3f]\n', min(y_coords), max(y_coords));
        fprintf('Sigma_yy range: [%.3f, %.3f]\n', min(sigma_yy), max(sigma_yy));
    else
        warning('No elements found near x=%.3f', x_location);
        y_coords = [];
        sigma_yy = [];
    end
    
    % Plot the extracted data for verification
    if ~isempty(y_coords)
        figure;
        plot(y_coords, sigma_yy, 'o-', 'LineWidth', 2);
        xlabel('y');
        ylabel('\sigma_{yy}');
        title(sprintf('Stress along x=%.3f (h=%.3f)', x_location, meshData.h));
        grid on;
    end
end
```