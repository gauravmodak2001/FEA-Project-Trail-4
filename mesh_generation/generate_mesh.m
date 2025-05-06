% mesh_generation/generate_mesh.m
function meshData = generate_mesh(width, height, h, elementType)
% Generate structured mesh for Q4 or Q8 elements
% Inputs:
%   width, height - domain dimensions
%   h - element size
%   elementType - 'Q4' or 'Q8'
% Output:
%   meshData - struct containing nodes, elements, and mesh info

    meshData = struct();
    
    % Number of elements in each direction
    nx = round(width/h);
    ny = round(height/h);
    
    switch elementType
        case 'Q4'
            % Generate nodes for Q4 elements
            [X, Y] = meshgrid(0:h:width, 0:h:height);
            meshData.nodes = [X(:), Y(:)];
            
            % Generate elements
            meshData.elements = [];
            node_pattern = reshape(1:size(meshData.nodes,1), ny+1, nx+1);
            
            for iy = 1:ny
                for ix = 1:nx
                    n1 = node_pattern(iy,   ix);     % bottom-left
                    n2 = node_pattern(iy,   ix+1);   % bottom-right
                    n3 = node_pattern(iy+1, ix+1);   % top-right
                    n4 = node_pattern(iy+1, ix);     % top-left
                    meshData.elements = [meshData.elements; n1 n2 n3 n4];
                end
            end
            
            meshData.nodesPerElement = 4;
            
        case 'Q8'
            % Generate nodes for Q8 elements (including midside nodes)
            h_half = h/2;
            nodes = [];
            node_index = 0;
            
            % Create a 2D array to store node indices
            node_grid = zeros(2*ny+1, 2*nx+1);
            
            % Generate nodes row by row
            for row = 0:2*ny
                for col = 0:2*nx
                    node_index = node_index + 1;
                    x = col * h_half;
                    y = row * h_half;
                    nodes = [nodes; x, y];
                    node_grid(row+1, col+1) = node_index;
                end
            end
            
            meshData.nodes = nodes;
            
            % Generate elements (8-noded quadrilaterals)
            meshData.elements = [];
            for iy = 1:ny
                for ix = 1:nx
                    row_base = 2*(iy-1) + 1;
                    col_base = 2*(ix-1) + 1;
                    
                    n1 = node_grid(row_base, col_base);         % bottom-left corner
                    n2 = node_grid(row_base, col_base+2);       % bottom-right corner
                    n3 = node_grid(row_base+2, col_base+2);     % top-right corner
                    n4 = node_grid(row_base+2, col_base);       % top-left corner
                    n5 = node_grid(row_base, col_base+1);       % bottom-middle
                    n6 = node_grid(row_base+1, col_base+2);     % right-middle
                    n7 = node_grid(row_base+2, col_base+1);     % top-middle
                    n8 = node_grid(row_base+1, col_base);       % left-middle
                    
                    meshData.elements = [meshData.elements; n1 n2 n3 n4 n5 n6 n7 n8];
                end
            end
            
            meshData.nodesPerElement = 8;
            
        otherwise
            error('Unknown element type: %s', elementType);
    end
    
    % Store mesh information
    meshData.numNodes = size(meshData.nodes, 1);
    meshData.numElems = size(meshData.elements, 1);
    meshData.elementType = elementType;
    meshData.nx = nx;
    meshData.ny = ny;
    meshData.h = h;
end