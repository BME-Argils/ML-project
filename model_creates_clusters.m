clear all; close all; clc;

% === Step 1: Load the dataset ===
filename = 'final_10_column_dataset.csv';
data_raw = readtable(filename);

% === Step 2: Preprocess (keep numeric columns only) ===
X = data_raw(:, varfun(@isnumeric, data_raw, 'OutputFormat', 'uniform'));
X = table2array(X);

% === Step 3: Loop over different K values ===
K_values = [3, 6, 7, 8, 9];
for k = K_values
    fprintf('Running K-means with K = %d...\n', k);

    [idx, C] = kmeans(X, k, 'Replicates', 10);

    data = data_raw;  % fresh copy
    data.Cluster = idx;

    outname = sprintf('clustered_output_K%d.csv', k);
    writetable(data, outname);
end
