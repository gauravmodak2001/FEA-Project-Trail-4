% visualization/display_summary.m
function display_summary(results, mesh_sizes)
% Display summary statistics
% Inputs:
%   results - results structure
%   mesh_sizes - array of mesh sizes

    fprintf('\n=== Summary Statistics ===\n');
    
    elementTypes = fieldnames(results);
    
    % Create comparison table
    fprintf('\nMesh Size\t');
    for et = 1:length(elementTypes)
        fprintf('%s Elements\t%s Time(s)\t', elementTypes{et}, elementTypes{et});
    end
    if length(elementTypes) > 1
        fprintf('Time Ratio (Q8/Q4)');
    end
    fprintf('\n');
    
    fprintf('-------------------------------------------------------------');
    fprintf('-------------------------------------------------------------\n');
    
    for i = 1:length(mesh_sizes)
        fprintf('%.3f\t\t', mesh_sizes(i));
        
        for et = 1:length(elementTypes)
            elementType = elementTypes{et};
            fprintf('%d\t\t%.3f\t\t', ...
                results.(elementType).num_elements(i), ...
                results.(elementType).cpu_times(i));
        end
        
        if length(elementTypes) > 1 && isfield(results, 'Q8') && isfield(results, 'Q4')
            fprintf('%.2f', results.Q8.cpu_times(i)/results.Q4.cpu_times(i));
        end
        fprintf('\n');
    end
end