function [solution, stresses] = run_fea_analysis(meshData, params, elementType)
% Run FEA analysis
% Inputs:
%   meshData - mesh data structure
%   params - problem parameters
%   elementType - 'Q4' or 'Q8'
% Outputs:
%   solution - displacement solution
%   stresses - element stresses

    % Extract mesh data
    nodes = meshData.nodes;
    elements = meshData.elements;
    numNodes = meshData.numNodes;
    numElems = meshData.numElems;
    ndof = 2 * numNodes;
    
    % Initialize global matrices
    K = sparse(ndof, ndof);
    F_global = zeros(ndof, 1);
    
    fprintf('Assembling global stiffness matrix...\n');
    
    % Assemble global stiffness matrix
    for e = 1:numElems
        elem_nodes = elements(e, :);
        xy = nodes(elem_nodes, :);
        
        % Calculate element stiffness matrix
        Ke = element_stiffness(xy, params.D, params.t, elementType);
        
        % DOF mapping
        npe = meshData.nodesPerElement;
        dof = zeros(1, 2*npe);
        for n = 1:npe
            dof(2*n-1:2*n) = [2*elem_nodes(n)-1, 2*elem_nodes(n)];
        end
        
        % Assemble
        K(dof, dof) = K(dof, dof) + Ke;
    end
    
    % Apply point load at upper right corner (x=2, y=6)
    upper_right_node = find(abs(nodes(:,1) - params.width) < 1e-6 & ...
                           abs(nodes(:,2) - params.height) < 1e-6);
    
    if isempty(upper_right_node)
        error('Upper right corner node not found!');
    end
    
    % Apply downward force F=20 at upper right corner
    F_global(2*upper_right_node) = -params.F;  % Negative for downward
    
    % Apply boundary conditions
    [bc_dofs, free_dofs] = apply_boundary_conditions(nodes, params.width);
    
    % Solve system
    fprintf('Solving system of equations...\n');
    u = zeros(ndof, 1);
    u(free_dofs) = K(free_dofs, free_dofs) \ F_global(free_dofs);
    
    % Store solution
    solution.displacements = u;
    solution.nodalDisp = reshape(u, 2, numNodes)';
    
    % Calculate stresses at element centers
    fprintf('Calculating stresses...\n');
    stresses = calculate_stresses(meshData, params, solution, elementType);
end