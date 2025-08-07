clear all;

% === LOAD DATA ===
tbr = readtable('calc_tbr.csv');
demo = readtable('data_demo.csv');
cshq = readtable('data_cshq.csv');
cgi = readtable('data_cgi_i.csv');

% === FILTER SESSIONS ===
tbr = tbr(tbr.session == -2 | tbr.session == -1, :);
cshq = cshq(cshq.session == 0, :);

% === FILTER VALID SUBJECTS ===
valid_subs = unique(cgi.subnum);
tbr = tbr(ismember(tbr.subnum, valid_subs), :);
demo = demo(ismember(demo.subnum, valid_subs), :);
cshq = cshq(ismember(cshq.subnum, valid_subs), :);

% === AGGREGATE TBR DATA ===
tbr_agg = varfun(@mean, tbr, ...
    'InputVariables', {'cz_numerator', 'cz_denominator', 'cz_overall_calc'}, ...
    'GroupingVariables', 'subnum');
tbr_agg.Properties.VariableNames = {'subnum', 'GroupCount', ...
    'Theta_power_cz', ...
    'Beta_power_cz', ...
    'Theta_Beta_Ratio_cz'};
tbr_agg.GroupCount = [];

% === AGGREGATE CSHQ DATA ===
cshq_agg = varfun(@mean, cshq, ...
    'InputVariables', {'sleep_minutes', 'bt2_20_mins'}, ...
    'GroupingVariables', 'subnum');
cshq_agg.Properties.VariableNames = {'subnum', 'GroupCount', ...
    'Sleep_duration_minutes', ...
    'Sleep_onset_delay'};
cshq_agg.GroupCount = [];

% === REDUCE AND RENAME DEMO COLUMNS ===
demo_sub = demo(:, {'subnum', 'age', 'q2a_sex', 'q6_adult_home', 'q14_school_grade'});
demo_sub.Properties.VariableNames = {'subnum', ...
    'Age_years', ...
    'Sex', ...
    'Handedness', ...
    'School_grade'};

% === MERGE ===
merged1 = innerjoin(tbr_agg, demo_sub, 'Keys', 'subnum');
final_data = innerjoin(merged1, cshq_agg, 'Keys', 'subnum');

% === EXPORT ===
writetable(final_data, 'final_10_column_dataset.csv');