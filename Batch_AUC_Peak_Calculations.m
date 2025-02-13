% Allow user to select a folder interactively
folder = uigetdir();
if folder == 0
    disp('No folder selected. Aborting operation.');
    return;  % Exit if no folder is selected
end

% List files in the selected folder
files = dir(fullfile(folder, '*.mat'));  % List of .mat files in the folder

% Check if there are any files to process
if isempty(files)
    disp('No .mat files found in the selected folder.');
    return;
end

% Preallocate arrays to store results
num_files = length(files);
MaxBefore5secs_neg_values = NaN(num_files, 1);  % Initialize array for MaxBefore5secs_neg
BeforeEsp_values = NaN(num_files, 1);          % Initialize array for BeforeEsp

% Loop through each file in the folder
for i = 1:num_files
    filename = fullfile(folder, files(i).name);
    data = load(filename);  % Load existing data from the file
    
    % Calculate necessary variables from the loaded data
    x = data.timeAxis;
    %y = data.meanPsthA;
    %y = data.CueAvoidPSTHA;
    %y = data.CueEscapePSTHA;
    y = data.GroupEscapePsthA;
    %y = data.GroupMeanPsthA;

    % Select specific time ranges
    range1 = x >= 0 & x <= 5;
    range2 = x >= 10 & x <= 15;
    
    x1 = x(range1);
    x2 = x(range2);
    y1 = y(range1);
    y2 = y(range2);

    % Calculate required values (example calculations from your code)
    area_1 = trapz(x1, y1);
    y_posa = y1; y_posa(y1<0) = 0;  % focus on area above x-axis
    res1a = trapz(x1, y_posa);
    BeforeEsp = area_1;
    PosAreaBefore = res1a;
    
    [pksBeforeEsp, locsBeforeEsp] = findpeaks(-y1);
    MaxBefore5secs_neg = -max(pksBeforeEsp);

    % Post-Cross
    area_2 = trapz(x2, y2);
    y_posb = y2; y_posb(y2<0) = 0;  % focus on area above x-axis
    res1b = trapz(x2, y_posb);
    AfterEsp = area_2;
    PosAreaAfter = res1b;

    [pksAfterCross, locsAfterEsp] = findpeaks(y2);
    MaxAfter5secs_pos = max(pksAfterCross);

    % Store Cue results in arrays
    MaxBefore5secs_neg_values(i) = MaxBefore5secs_neg;
    BeforeCross_AUCvalues(i) = BeforeEsp;
    twist_CueAUC = BeforeCross_AUCvalues';

    % Store Post Cross results in arrays
    MaxAfter5secs_pos_values(i) = MaxAfter5secs_pos;
    twistPeak =  MaxAfter5secs_pos_values';
    AfterCross_AUCvalues(i) = AfterEsp;
    twistAfterCrossAUC = AfterCross_AUCvalues';
   

end