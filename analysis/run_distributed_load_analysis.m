% analysis/run_distributed_load_analysis.m
function [solution, stresses] = run_distributed_load_analysis(meshData, params, F_distributed)
% Run FEA analysis with distributed load
% Inputs:
%   meshData - mesh data structure
%   params - problem parameters
%   F_distributed - distributed force vector
% Outputs:
%   solution - displacement solution
%   stresses - element stresses

    % Extract mesh data
    nodes = meshData.nodes;
    elements = meshData.elements;
    numNodes = meshData.numNodes;
    numElems = meshData.numElems;
    ndof = 2 * numNodes;
    elementType = meshData.elementType;
    
    % Initialize global matrices
    K = sparse(ndof, ndof);
    
    fprintf('Assembling global stiffness matrix for distributed load analysis...\n');
    
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
    
    % Apply boundary conditions
    [bc_dofs, free_dofs] = apply_boundary_conditions(nodes, params.width);
    
    % Solve system
    fprintf('Solving system of equations...\n');
    u = zeros(ndof, 1);
    u(free_dofs) = K(free_dofs, free_dofs) \ F_distributed(free_dofs);
    
    % Store solution
    solution.displacements = u;
    solution.nodalDisp = reshape(u, 2, numNodes)';
    
    % Calculate stresses at element centers
    fprintf('Calculating stresses...\n');
    stresses = calculate_stresses(meshData, params, solution, elementType);
end