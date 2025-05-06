% visualization/plot_timing_comparison.m
function plot_timing_comparison(results, mesh_sizes)
% Plot timing comparison between Q4 and Q8 elements
% Inputs:
%   results - results structure
%   mesh_sizes - array of mesh sizes

    % CPU time vs number of elements
    figure('Position', [100, 100, 800, 600]);
    
    loglog(results.Q4.num_elements, results.Q4.cpu_times, 'bo-', ...
           'LineWidth', 2, 'MarkerSize', 8, 'DisplayName', 'Q4 Elements');
    hold on;
    
    if isfield(results, 'Q8')
        loglog(results.Q8.num_elements, results.Q8.cpu_times, 'rs-', ...
               'LineWidth', 2, 'MarkerSize', 8, 'DisplayName', 'Q8 Elements');
    end
    
    xlabel('Number of Elements');
    ylabel('CPU Time (seconds)');
    title('Computational Time vs Number of Elements');
    legend('Location', 'northwest');
    grid on;
    
    % Add mesh size annotations
    for i = 1:length(mesh_sizes)
        text(results.Q4.num_elements(i), results.Q4.cpu_times(i)*0.8, ...
             sprintf('h=%.3f', mesh_sizes(i)), ...
             'HorizontalAlignment', 'center', 'Color', 'blue');
        
        if isfield(results, 'Q8')
            text(results.Q8.num_elements(i), results.Q8.cpu_times(i)*1.2, ...
                 sprintf('h=%.3f', mesh_sizes(i)), ...
                 'HorizontalAlignment', 'center', 'Color', 'red');
        end
    end
    
    % CPU time per element
    figure('Position', [150, 150, 800, 600]);
    
    time_per_element_Q4 = results.Q4.cpu_times ./ results.Q4.num_elements;
    
    if isfield(results, 'Q8')
        time_per_element_Q8 = results.Q8.cpu_times ./ results.Q8.num_elements;
        bar_data = [time_per_element_Q4, time_per_element_Q8];
    else
        bar_data = time_per_element_Q4;
    end
    
    X = categorical(cellstr(num2str(mesh_sizes')));
    
    b = bar(X, bar_data);
    b(1).FaceColor = 'blue';
    if length(b) > 1
        b(2).FaceColor = 'red';
    end
    
    ylabel('CPU Time per Element (seconds)');
    xlabel('Mesh Size (h)');
    title('Computational Time per Element');
    
    if isfield(results, 'Q8')
        legend('Q4 Elements', 'Q8 Elements', 'Location', 'northwest');
    else
        legend('Q4 Elements', 'Location', 'northwest');
    end
    grid on;
    
    % Add values on top of bars
    for i = 1:length(mesh_sizes)
        text(i-0.15, time_per_element_Q4(i), sprintf('%.2e', time_per_element_Q4(i)), ...
            'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
        
        if isfield(results, 'Q8')
            text(i+0.15, time_per_element_Q8(i), sprintf('%.2e', time_per_element_Q8(i)), ...
                'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
        end
    end
end