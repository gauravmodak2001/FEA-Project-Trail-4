% element_routines/shape_functions.m
function [N, dNdxi, dNdeta] = shape_functions(xi, eta, elementType)
% Compute shape functions and derivatives for quad elements
% Inputs:
%   xi, eta - natural coordinates
%   elementType - 'Q4' or 'Q8'
% Outputs:
%   N - shape functions
%   dNdxi, dNdeta - derivatives of shape functions

    switch elementType
        case 'Q4'
            % Shape functions for 4-node quadrilateral
            N = [(1-xi)*(1-eta)/4;
                 (1+xi)*(1-eta)/4;
                 (1+xi)*(1+eta)/4;
                 (1-xi)*(1+eta)/4];
            
            % Derivatives with respect to xi
            dNdxi = [-(1-eta)/4;
                      (1-eta)/4;
                      (1+eta)/4;
                     -(1+eta)/4];
            
            % Derivatives with respect to eta
            dNdeta = [-(1-xi)/4;
                      -(1+xi)/4;
                       (1+xi)/4;
                       (1-xi)/4];
            
        case 'Q8'
            % Shape functions for 8-node quadrilateral
            % Corner nodes
            N(1) = 0.25 * (1-xi) * (1-eta) * (-xi-eta-1);
            N(2) = 0.25 * (1+xi) * (1-eta) * (xi-eta-1);
            N(3) = 0.25 * (1+xi) * (1+eta) * (xi+eta-1);
            N(4) = 0.25 * (1-xi) * (1+eta) * (-xi+eta-1);
            
            % Midside nodes
            N(5) = 0.5 * (1-xi^2) * (1-eta);
            N(6) = 0.5 * (1+xi) * (1-eta^2);
            N(7) = 0.5 * (1-xi^2) * (1+eta);
            N(8) = 0.5 * (1-xi) * (1-eta^2);
            
            % Derivatives with respect to xi
            dNdxi(1) = 0.25 * (1-eta) * (2*xi+eta);
            dNdxi(2) = 0.25 * (1-eta) * (2*xi-eta);
            dNdxi(3) = 0.25 * (1+eta) * (2*xi+eta);
            dNdxi(4) = 0.25 * (1+eta) * (2*xi-eta);
            dNdxi(5) = -xi * (1-eta);
            dNdxi(6) = 0.5 * (1-eta^2);
            dNdxi(7) = -xi * (1+eta);
            dNdxi(8) = -0.5 * (1-eta^2);
            
            % Derivatives with respect to eta
            dNdeta(1) = 0.25 * (1-xi) * (xi+2*eta);
            dNdeta(2) = 0.25 * (1+xi) * (-xi+2*eta);
            dNdeta(3) = 0.25 * (1+xi) * (xi+2*eta);
            dNdeta(4) = 0.25 * (1-xi) * (-xi+2*eta);
            dNdeta(5) = -0.5 * (1-xi^2);
            dNdeta(6) = -eta * (1+xi);
            dNdeta(7) = 0.5 * (1-xi^2);
            dNdeta(8) = -eta * (1-xi);
            
            % Convert to column vectors for consistency
            N = N(:);
            dNdxi = dNdxi(:);
            dNdeta = dNdeta(:);
            
        otherwise
            error('Unknown element type: %s', elementType);
    end
end