% element_routines/compute_B_matrix.m
function [B, detJ] = compute_B_matrix(xy, xi, eta, elementType)
% Compute B matrix and Jacobian determinant
% Inputs:
%   xy - nodal coordinates of element
%   xi, eta - natural coordinates
%   elementType - 'Q4' or 'Q8'
% Outputs:
%   B - strain-displacement matrix
%   detJ - Jacobian determinant

    % Get shape function derivatives
    [~, dNdxi, dNdeta] = shape_functions(xi, eta, elementType);
    
    % Compute Jacobian
    J = [dNdxi'; dNdeta'] * xy;
    detJ = det(J);
    
    if detJ <= 0
        warning('Negative Jacobian detected');
    end
    
    % Compute derivatives in physical coordinates
    dNdxy = J \ [dNdxi'; dNdeta'];
    
    % Get number of nodes
    if strcmp(elementType, 'Q4')
        numNodes = 4;
    else
        numNodes = 8;
    end
    
    % Assemble B matrix
    B = zeros(3, 2*numNodes);
    for i = 1:numNodes
        B(1, 2*i-1) = dNdxy(1, i);  % du/dx
        B(2, 2*i)   = dNdxy(2, i);  % dv/dy
        B(3, 2*i-1) = dNdxy(2, i);  % du/dy
        B(3, 2*i)   = dNdxy(1, i);  % dv/dx
    end
end