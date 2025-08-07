clear all; close all; clc;

K_values = [3, 6, 7, 8, 9];
cluster_counter = 0;
summary = table();

% === Load all side data ===
cgi = readtable('data_cgi_i.csv');
cgi = cgi(:, {'subnum', 'cgi_i'});

assign = readtable('drv_eeg_session_live.csv');
assign = assign(:, {'subnum', 'Control'});  % 0 = sham, 1 = real

% === Define clusters you want to inspect in detail ===
best_clusters = [13, 20, 26, 28];

% === Loop over all cluster files ===
for k = K_values
    filename = sprintf('clustered_output_K%d.csv', k);
    clustered = readtable(filename);

    merged = innerjoin(clustered, cgi, 'Keys', 'subnum');
    merged = innerjoin(merged, assign, 'Keys', 'subnum');

    % Add globally unique cluster index
    merged.GlobalClusterID = merged.Cluster + cluster_counter;

    clusters = unique(merged.GlobalClusterID);
    
    for i = 1:length(clusters)
        cid = clusters(i);
        group = merged(merged.GlobalClusterID == cid, :);
        
        sham = group(group.Control == 0, :).cgi_i;
        real = group(group.Control == 1, :).cgi_i;

        sham_mean = mean(sham, 'omitnan');
        real_mean = mean(real, 'omitnan');
        improvement_pct = 100 * (sham_mean - real_mean) / sham_mean;

        n_total = numel(unique(group.subnum));
        n_sham = numel(unique(group(group.Control == 0, :).subnum));
        n_real = numel(unique(group(group.Control == 1, :).subnum));

        summary = [summary; {
            k, cid, n_total, n_sham, n_real, real_mean, sham_mean, improvement_pct
        }];

        % === Detailed breakdown if this is a best cluster ===
        if ismember(cid, best_clusters)
            fprintf('\nDetails for BEST cluster %d:\n', cid);
            % Loop over all original numeric features
            feature_names = clustered.Properties.VariableNames;
            feature_names = feature_names(~ismember(feature_names, {'subnum','Cluster'}));

            features_only = clustered(:, feature_names);
            original_group = clustered(clustered.Cluster == (cid - cluster_counter), :);
            
            for f = 1:width(features_only)
                values = original_group{:, feature_names{f}};
                fprintf('  %s: mean = %.2f, min = %.2f, max = %.2f\n', ...
                    feature_names{f}, mean(values, 'omitnan'), ...
                    min(values), max(values));
            end
        end
    end

    cluster_counter = cluster_counter + k;
end

% === Final column names ===
summary.Properties.VariableNames = {
    'K', 'ClusterID', 'NumSubjects', ...
    'NumSham', 'NumReal', 'CGI_Real', ...
    'CGI_Sham', 'ImprovementPercent'
};

disp(summary);
writetable(summary, 'clustering_summary_10cols.csv');

% === Show min/max for each numeric parameter across all data ===
all_data = readtable('final_10_column_dataset.csv');
features = all_data(:, varfun(@isnumeric, all_data, 'OutputFormat', 'uniform'));
fnames = features.Properties.VariableNames;

fprintf('\n=== Overall Feature Ranges (10-column dataset) ===\n');
for i = 1:length(fnames)
    vals = features{:, fnames{i}};
    fprintf('%s: min = %.2f, max = %.2f\n', fnames{i}, min(vals), max(vals));
end
