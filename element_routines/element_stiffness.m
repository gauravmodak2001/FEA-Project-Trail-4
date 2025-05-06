% element_routines/element_stiffness.m
function Ke = element_stiffness(xy, D, t, elementType)
% Calculate element stiffness matrix
% Inputs:
%   xy - nodal coordinates of element
%   D - material matrix
%   t - thickness
%   elementType - 'Q4' or 'Q8'
% Output:
%   Ke - element stiffness matrix

    % Get Gauss quadrature rule
    [gauss_points, gauss_weights] = get_gauss_points(elementType);
    ngp = length(gauss_points);
    
    % Get element size
    if strcmp(elementType, 'Q4')
        nDOF = 8;
    else
        nDOF = 16;
    end
    
    % Initialize element stiffness matrix
    Ke = zeros(nDOF, nDOF);
    
    % Numerical integration
    for i = 1:ngp
        for j = 1:ngp
            xi = gauss_points(i);
            eta = gauss_points(j);
            weight = gauss_weights(i) * gauss_weights(j);
            
            % Compute B matrix and Jacobian determinant
            [B, detJ] = compute_B_matrix(xy, xi, eta, elementType);
            
            % Add contribution to element stiffness matrix
            Ke = Ke + B' * D * B * detJ * weight * t;
        end
    end
end