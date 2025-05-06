% analysis/extract_stress_at_y6.m
function max_stress = extract_stress_at_y6(meshData, stresses)
% Extract maximum stress near y=6
% Inputs:
%   meshData - mesh data structure
%   stresses - stress data structure
% Output:
%   max_stress - maximum sigma_yy near y=6

    centers = stresses.centers;
    sigma_yy_all = stresses.sigma_yy;
    
    % Find elements near y=6
    tolerance = 0.5; % Adjust based on mesh size
    near_y6 = find(abs(centers(:,2) - 6) < tolerance);
    
    if ~isempty(near_y6)
        stress_values = sigma_yy_all(near_y6);
        max_stress = max(abs(stress_values));
        fprintf('Found %d elements near y=6, max stress = %.3f\n', length(near_y6), max_stress);
    else
        warning('No elements found near y=6');
        max_stress = 0;
    end
end