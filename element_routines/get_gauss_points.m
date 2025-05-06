% element_routines/get_gauss_points.m
function [gauss_points, gauss_weights] = get_gauss_points(elementType)
% Get Gauss quadrature points and weights
% Input:
%   elementType - 'Q4' or 'Q8'
% Outputs:
%   gauss_points - Gauss points
%   gauss_weights - Gauss weights

    switch elementType
        case 'Q4'
            % 2x2 Gauss quadrature for Q4
            gp = 1/sqrt(3);
            gauss_points = [-gp, gp];
            gauss_weights = [1, 1];
            
        case 'Q8'
            % 3x3 Gauss quadrature for Q8
            gauss_points = [-sqrt(3/5), 0, sqrt(3/5)];
            gauss_weights = [5/9, 8/9, 5/9];
            
        otherwise
            error('Unknown element type: %s', elementType);
    end
end