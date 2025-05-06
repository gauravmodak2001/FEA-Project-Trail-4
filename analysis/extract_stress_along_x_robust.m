function [y_coords, sigma_yy] = extract_stress_along_x_robust(meshData, stresses, x_location)
% Extract stress along a vertical line at specified x location (robust version)
% Inputs:
%   meshData - mesh data structure
%   stresses - stress data structure
%   x_location - x coordinate for extraction
% Outputs:
%   y_coords - y coordinates
%   sigma_yy - sigma_yy values

    centers = stresses.centers;
    sigma_yy_all = stresses.sigma_yy;
    
    % Find the rightmost column of element centers
    x_values = centers(:,1);
    x_max = max(x_values);
    
    fprintf('Requested x location: %.3f\n', x_location);
    fprintf('Actual maximum x of element centers: %.3f\n', x_max);
    
    % Find all x-coordinates of element centers
    unique_x = unique(round(x_values, 3));
    fprintf('Unique x-coordinates of element centers: ');
    fprintf('%.3f ', unique_x);
    fprintf('\n');
    
    % Find the x-coordinate closest to the requested location
    [~, idx] = min(abs(unique_x - x_location));
    actual_x = unique_x(idx);
    
    fprintf('Using x = %.3f for extraction\n', actual_x);
    
    % Find all elements at this x-coordinate
    tolerance = 0.01; % Small tolerance for numerical precision
    near_x = find(abs(centers(:,1) - actual_x) < tolerance);
    
    if isempty(near_x)
        % If still no elements found, use the rightmost column
        near_x = find(abs(centers(:,1) - x_max) < tolerance);
        fprintf('Using rightmost column at x = %.3f\n', x_max);
    end
    
    if ~isempty(near_x)
        y_vals = centers(near_x, 2);
        sigma_vals = sigma_yy_all(near_x);
        
        % Sort by y coordinate
        [y_coords, sort_idx] = sort(y_vals);
        sigma_yy = sigma_vals(sort_idx);
        
        fprintf('Found %d elements for extraction\n', length(near_x));
        fprintf('Y-coordinates range: [%.3f, %.3f]\n', min(y_coords), max(y_coords));
        fprintf('Sigma_yy range: [%.3f, %.3f]\n', min(sigma_yy), max(sigma_yy));
    else
        warning('No elements found for extraction');
        y_coords = [];
        sigma_yy = [];
    end
end