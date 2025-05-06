function [bc_dofs, free_dofs] = apply_boundary_conditions(nodes, width)
% Apply boundary conditions for the problem
% Inputs:
%   nodes - nodal coordinates
%   width - width of the domain
% Outputs:
%   bc_dofs - constrained degrees of freedom
%   free_dofs - free degrees of freedom

    % Bottom edge (y=0): v=0 (roller support - free to move horizontally)
    bottom_nodes = find(abs(nodes(:,2)) < 1e-6);
    bc_dofs_bottom = 2*bottom_nodes;  % Constrain vertical displacement (v)
    
    % Right edge (x=width): u=0 (roller support - free to move vertically)
    right_nodes = find(abs(nodes(:,1) - width) < 1e-6);
    bc_dofs_right = 2*right_nodes - 1;  % Constrain horizontal displacement (u)
    
    % Combine all constrained DOFs
    bc_dofs = [bc_dofs_bottom(:); bc_dofs_right(:)];
    
    % Get free DOFs
    ndof = 2 * size(nodes, 1);
    free_dofs = setdiff(1:ndof, bc_dofs);
end