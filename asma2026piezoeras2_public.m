%% PIEZO1 & AEROSPACE: REPRODUCIBLE RESEARCH TREND ANALYSIS
% Analysis of Global Research Velocity vs. Aerospace Medicine Adoption
% Author: T. AKI
% Repository: github.com/YourUsername/Piezo1-Aerospace-Bibliometry

clear; clc; close all;

%% 1. DYNAMIC DATA LOADING (PORTABLE VERSION)
% Identifies the folder where this script is saved to find data files
[scriptPath, ~, ~] = fileparts(mfilename('fullpath'));

% Define file names (CSVs must be in the same folder as this script)
masterFileName = 'PUBMED_Piezo1_titleabstract.csv';
spaceFileName  = 'PUBMED_Space.csv';

% Construct full paths dynamically
masterPath = fullfile(scriptPath, masterFileName);
spacePath  = fullfile(scriptPath, spaceFileName);

try
    T = readtable(masterPath, 'VariableNamingRule', 'preserve');
    Space_T = readtable(spacePath, 'VariableNamingRule', 'preserve');
catch
    error('Data files not found. Ensure %s and %s are in the script folder.', ...
        masterFileName, spaceFileName);
end

% Standardize year column
if ismember('Publication Year', T.Properties.VariableNames)
    T.Year = str2double(string(T{:, 'Publication Year'}));
else
    year_cols = T.Properties.VariableNames(contains(lower(T.Properties.VariableNames), 'year'));
    T.Year = str2double(string(T{:, year_cols{1}}));
end

% Filter range
T = T(~isnan(T.Year) & T.Year >= 2010 & T.Year <= 2026, :);

%% 2. AEROSPACE CLASSIFICATION (PMID CROSS-REFERENCE)
% Matches master records against targeted aerospace search results
T.IsSpace = ismember(string(T.PMID), string(Space_T.PMID));
fprintf('✅ Identified %d true aerospace papers!\n', sum(T.IsSpace));

%% 3. PUBLICATION VOLUME & CHANGE POINT ANALYSIS
unique_years = (min(T.Year):max(T.Year))';
total_counts = zeros(size(unique_years));
space_counts = zeros(size(unique_years));

for i = 1:length(unique_years)
    total_counts(i) = sum(T.Year == unique_years(i));
    space_counts(i) = sum(T.Year == unique_years(i) & T.IsSpace);
end

% Algorithmic detection of structural shifts in research velocity
ipt = findchangepts(total_counts, 'MaxNumChanges', 3, 'Statistic', 'mean');
change_years = unique_years(ipt);

%% 4. VISUALIZATION: DUAL-AXIS TIMELINE
fig = figure('Position', [100, 100, 1400, 700], 'Color', 'white');

% --- LEFT AXIS: Global PIEZO1 Research ---
yyaxis left
hBar = bar(unique_years, total_counts, 'FaceColor', [0.85 0.85 0.85], 'EdgeColor', 'none');
ylabel('Global PIEZO1 Publications (Total Volume)', 'FontWeight', 'bold', 'FontSize', 12);
set(gca, 'ycolor', [0.4 0.4 0.4]); 
ylim([0, max(total_counts)*1.15]); 

% Add global count labels
for i = 1:length(unique_years)
    if total_counts(i) > 0
        text(unique_years(i), total_counts(i) + max(total_counts)*0.02, ...
            num2str(total_counts(i)), 'HorizontalAlignment', 'center', ...
            'FontSize', 9, 'Color', [0.3 0.3 0.3], 'FontWeight', 'bold');
    end
end

% --- RIGHT AXIS: Aerospace PIEZO1 Research ---
yyaxis right
hLine = plot(unique_years, space_counts, '-o', 'LineWidth', 4, 'MarkerSize', 10, ...
    'Color', [0.5 0.2 0.8], 'MarkerFaceColor', [0.5 0.2 0.8]);
ylabel('Aerospace Publications', 'FontWeight', 'bold', 'FontSize', 12);
set(gca, 'ycolor', [0.5 0.2 0.8]); 

if max(space_counts) > 0
    y_max_right = max(space_counts) + 2.5; 
    ylim([0, y_max_right]);
    yticks(0:1:y_max_right); 
else
    y_max_right = 5;
    ylim([0, y_max_right]); 
end

% Purple Labels (Drawn with white background for clarity)
for i = 1:length(unique_years)
    if space_counts(i) > 0
        text(unique_years(i), space_counts(i) - (y_max_right * 0.06), ...
            num2str(space_counts(i)), 'HorizontalAlignment', 'center', ...
            'FontSize', 11, 'Color', [0.5 0.2 0.8], 'FontWeight', 'bold', ...
            'BackgroundColor', 'w', 'Margin', 1.5, 'EdgeColor', [0.5 0.2 0.8]);
    end
end

% --- DRAW ALGORITHMIC ERAS ---
hold on;
for i = 1:length(change_years)
    xline(change_years(i), 'k--', 'LineWidth', 1.5, 'Alpha', 0.5);
    text(change_years(i) - 0.2, y_max_right * 0.80, sprintf('Phase Shift (%d)', change_years(i)), ...
        'Rotation', 90, 'FontSize', 11, 'FontWeight', 'bold', 'Color', [0.2 0.2 0.2], ...
        'HorizontalAlignment', 'right'); 
end

% --- NOBEL ANNOTATION ---
if ismember(2021, unique_years)
    idx_2021 = find(unique_years == 2021);
    nobel_y = y_max_right * 0.88; 
    plot([2021, 2021], [space_counts(idx_2021), nobel_y], 'k:', 'LineWidth', 1.5, 'HandleVisibility', 'off');
    plot(2021, space_counts(idx_2021), 'k*', 'MarkerSize', 12, 'HandleVisibility', 'off');
    text(2020.7, nobel_y, '2021 Nobel Prize (Patapoutian, PIEZO1 discoverer) \rightarrow ', ...
        'HorizontalAlignment', 'right', 'FontSize', 11, 'FontWeight', 'bold', 'Color', 'k');
end
hold off;

% Formatting
set(gca, 'Layer', 'top'); 
xlabel('Publication Year', 'FontWeight', 'bold', 'FontSize', 12);
title('PIEZO1 Evolution: Global Research Velocity vs. Aerospace Adoption', 'FontSize', 18, 'FontWeight', 'bold');
grid on;
legend({'Global Trend (Left Axis)', 'Aerospace Trend (Right Axis)', 'Algorithmic Phase Shifts'}, ...
    'Location', 'northwest', 'FontSize', 11);

% Final Image Export
exportgraphics(gcf, 'ASMA_DualAxis_Timeline.png', 'Resolution', 300);

%% 5. STATISTICAL SUMMARY
era_starts = [unique_years(1); change_years];
era_ends = [change_years - 1; unique_years(end)];
fprintf('\n📊 --- PHASE SHIFT METRICS --- 📊\n');
for i = 1:length(era_starts)
    idx = unique_years >= era_starts(i) & unique_years <= era_ends(i);
    era_data = total_counts(idx);
    fprintf('Era %d (%d-%d): Mean = %.1f pubs/yr\n', i, era_starts(i), era_ends(i), mean(era_data));
end