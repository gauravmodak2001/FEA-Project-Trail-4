% analysis/calculate_stresses.m
function stresses = calculate_stresses(meshData, params, solution, elementType)
% Calculate stresses at element centers
% Inputs:
%   meshData - mesh data structure
%   params - problem parameters
%   solution - displacement solution
%   elementType - 'Q4' or 'Q8'
% Output:
%   stresses - structure containing stress data

    nodes = meshData.nodes;
    elements = meshData.elements;
    numElems = meshData.numElems;
    u = solution.displacements;
    
    % Initialize storage
    stresses.sigma_xx = zeros(numElems, 1);
    stresses.sigma_yy = zeros(numElems, 1);
    stresses.sigma_xy = zeros(numElems, 1);
    stresses.centers = zeros(numElems, 2);
    
    % Calculate stresses at element centers
    for e = 1:numElems
        elem_nodes = elements(e, :);
        xy = nodes(elem_nodes, :);
        
        % Get element displacements
        npe = meshData.nodesPerElement;
        elem_dof = zeros(1, 2*npe);
        for n = 1:npe
            elem_dof(2*n-1:2*n) = [2*elem_nodes(n)-1, 2*elem_nodes(n)];
        end
        u_elem = u(elem_dof);
        
        % Calculate stress at element center (xi=0, eta=0)
        xi = 0; eta = 0;
        
        % Compute B matrix
        [B, ~] = compute_B_matrix(xy, xi, eta, elementType);
        
        % Calculate strain and stress
        strain = B * u_elem;
        stress = params.D * strain;
        
        % Store stresses
        stresses.sigma_xx(e) = stress(1);
        stresses.sigma_yy(e) = stress(2);
        stresses.sigma_xy(e) = stress(3);
        
        % Calculate element center in physical coordinates
        [N, ~, ~] = shape_functions(xi, eta, elementType);
        stresses.centers(e, :) = xy' * N;
    end
end