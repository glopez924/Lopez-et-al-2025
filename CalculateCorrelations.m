% Caculate dff vs velocity correlations
% Define folder path containing the data files
folderPath = uigetdir();
if folderPath == 0
    disp('No folder selected. Aborting operation.');
    return;  % Exit if no folder is selected
end
% folderPath = 'C:\path\to\your\folder'; % Change to your actual folder path
fileList = dir(fullfile(folderPath, '*.mat')); % Get all .mat files in the folder

numFiles = length(fileList); % Number of files to process
correlationResults = nan(numFiles, 1); % Preallocate array for correlation values
fileNames = strings(numFiles, 1); % Store filenames for reference

samplingRate = 1017.25; % Define sampling rate

for i = 1:numFiles
    % Load the current file
    fileName = fullfile(folderPath, fileList(i).name);
    data = load(fileName); 
    
    % Store filename without path
    fileNames(i) = fileList(i).name;
    
    % Ensure the required structures and fields exist
    if ~isfield(data, 'dff') || ~isfield(data, 'Velocity') || ~isfield(data, 'TimeCorrection')
        warning('Skipping file %s: Missing required structures.', fileName);
        continue;
    end

    if ~isfield(data.dff, 'dataA') || ~isfield(data.Velocity, 'dataB') || ~isfield(data.TimeCorrection, 'dataTime')
        warning('Skipping file %s: Missing required fields inside structures.', fileName);
        continue;
    end

    % Extract data from structures
    dataA = data.dff.dataA;
    dataB = data.Velocity.dataB;
    dataTime = data.TimeCorrection.dataTime;

    % Calculate zero index
    correctionTime = dataTime(1);
    zero_index = round(-correctionTime * samplingRate);

    % Determine velocity stop index
    dataBEnd_index = find(~isnan(dataB), 1, 'last');
    velstoptime = dataTime(dataBEnd_index);
    velstoptime_index = find(dataTime == velstoptime);

    % Trim data
    dataA = dataA(zero_index:velstoptime_index);
    dataB = dataB(zero_index:velstoptime_index);

    % Remove NaN values
    nanIndices = isnan(dataA) | isnan(dataB);
    x = dataA(~nanIndices);
    y = dataB(~nanIndices);

    % Compute correlation
    if ~isempty(x) && ~isempty(y)
        R = corrcoef(x, y);
        correlationResults(i) = R(1,2); % Store correlation value
    else
        warning('Skipping file %s: Not enough valid data for correlation.', fileName);
    end
end

% Save results to a CSV file
outputFile = fullfile(folderPath, 'correlation_results.csv');
resultsTable = table(fileNames, correlationResults, 'VariableNames', {'FileName', 'Correlation'});
writetable(resultsTable, outputFile);

disp(['Correlation results saved to: ', outputFile]);

%% Calculate Avoid DA vs Avoid Velocity correlations
% % Define folder path containing the data files
% folderPath = uigetdir();
% if folderPath == 0
%     disp('No folder selected. Aborting operation.');
%     return;  % Exit if no folder is selected
% end
% % folderPath = 'C:\path\to\your\folder'; % Change to your actual folder path
% fileList = dir(fullfile(folderPath, '*.mat')); % Get all .mat files in the folder
% 
% numFiles = length(fileList); % Number of files to process
% correlationResults = nan(numFiles, 1); % Preallocate array for correlation values
% fileNames = strings(numFiles, 1); % Store filenames for reference
% 
% for i = 1:numFiles
%     % Load the current file
%     fileName = fullfile(folderPath, fileList(i).name);
%     data = load(fileName); 
%     
%     % Store filename without path
%     fileNames(i) = fileList(i).name;
%     
%     % Ensure the required structures and fields exist
%     if ~isfield(data, 'Avoid') || ~isfield(data, 'Velocity')
%         warning('Skipping file %s: Missing required structures.', fileName);
%         continue;
%     end
% 
%     if ~isfield(data.Avoid, 'newMeanPsthA') || ~isfield(data.Velocity, 'newAvoidPsthA')
%         warning('Skipping file %s: Missing required fields inside structures.', fileName);
%         continue;
%     end
% 
%     % Extract data from structures
%     dataA = data.Avoid.newMeanPsthA;
%     dataB = data.Velocity.newAvoidPsthA;
% 
%     x = dataA;
%     y = dataB;
% 
%     % Compute correlation
%     if ~isempty(x) && ~isempty(y)
%         R = corrcoef(x, y);
%         correlationResults(i) = R(1,2); % Store correlation value
%     else
%         warning('Skipping file %s: Not enough valid data for correlation.', fileName);
%     end
% end
% 
% % Save results to a CSV file
% outputFile = fullfile(folderPath, 'correlation_results.csv');
% resultsTable = table(fileNames, correlationResults, 'VariableNames', {'FileName', 'Correlation'});
% writetable(resultsTable, outputFile);
% 
% disp(['Correlation results saved to: ', outputFile]);

%% Calculate Escape DA vs Escape Velocity correlations
% % Define folder path containing the data files
% folderPath = uigetdir();
% if folderPath == 0
%     disp('No folder selected. Aborting operation.');
%     return;  % Exit if no folder is selected
% end
% % folderPath = 'C:\path\to\your\folder'; % Change to your actual folder path
% fileList = dir(fullfile(folderPath, '*.mat')); % Get all .mat files in the folder
% 
% numFiles = length(fileList); % Number of files to process
% correlationResults = nan(numFiles, 1); % Preallocate array for correlation values
% fileNames = strings(numFiles, 1); % Store filenames for reference
% 
% for i = 1:numFiles
%     % Load the current file
%     fileName = fullfile(folderPath, fileList(i).name);
%     data = load(fileName); 
%     
%     % Store filename without path
%     fileNames(i) = fileList(i).name;
%     
%     % Ensure the required structures and fields exist
%     if ~isfield(data, 'Escape') || ~isfield(data, 'Velocity')
%         warning('Skipping file %s: Missing required structures.', fileName);
%         continue;
%     end
% 
%     if ~isfield(data.Escape, 'newMeanPsthA') || ~isfield(data.Velocity, 'newEscapePsthA')
%         warning('Skipping file %s: Missing required fields inside structures.', fileName);
%         continue;
%     end
% 
%     % Extract data from structures
%     dataA = data.Escape.newMeanPsthA;
%     dataB = data.Velocity.newEscapePsthA;
% 
%     x = dataA;
%     y = dataB;
% 
%     % Compute correlation
%     if ~isempty(x) && ~isempty(y)
%         R = corrcoef(x, y);
%         correlationResults(i) = R(1,2); % Store correlation value
%     else
%         warning('Skipping file %s: Not enough valid data for correlation.', fileName);
%     end
% end
% 
% % Save results to a CSV file
% outputFile = fullfile(folderPath, 'correlation_results.csv');
% resultsTable = table(fileNames, correlationResults, 'VariableNames', {'FileName', 'Correlation'});
% writetable(resultsTable, outputFile);
% 
% disp(['Correlation results saved to: ', outputFile]);

%% Calculate Cross ITI DA vs Cross ITI Velocity correlations
% % Define folder path containing the data files
% folderPath = uigetdir();
% if folderPath == 0
%     disp('No folder selected. Aborting operation.');
%     return;  % Exit if no folder is selected
% end
% % folderPath = 'C:\path\to\your\folder'; % Change to your actual folder path
% fileList = dir(fullfile(folderPath, '*.mat')); % Get all .mat files in the folder
% 
% numFiles = length(fileList); % Number of files to process
% correlationResults = nan(numFiles, 1); % Preallocate array for correlation values
% fileNames = strings(numFiles, 1); % Store filenames for reference
% 
% for i = 1:numFiles
%     % Load the current file
%     fileName = fullfile(folderPath, fileList(i).name);
%     data = load(fileName); 
%     
%     % Store filename without path
%     fileNames(i) = fileList(i).name;
%     
%     % Ensure the required structures and fields exist
%     if ~isfield(data, 'Cross_ITI') || ~isfield(data, 'Velocity')
%         warning('Skipping file %s: Missing required structures.', fileName);
%         continue;
%     end
% 
%     if ~isfield(data.Cross_ITI, 'newMeanPsthA') || ~isfield(data.Velocity, 'newCross_ITIPsthA')
%         warning('Skipping file %s: Missing required fields inside structures.', fileName);
%         continue;
%     end
% 
%     % Extract data from structures
%     dataA = data.Cross_ITI.newMeanPsthA;
%     dataB = data.Velocity.newCross_ITIPsthA;
% 
%     x = dataA;
%     y = dataB;
% 
%     % Compute correlation
%     if ~isempty(x) && ~isempty(y)
%         R = corrcoef(x, y);
%         correlationResults(i) = R(1,2); % Store correlation value
%     else
%         warning('Skipping file %s: Not enough valid data for correlation.', fileName);
%     end
% end
% 
% % Save results to a CSV file
% outputFile = fullfile(folderPath, 'correlation_results.csv');
% resultsTable = table(fileNames, correlationResults, 'VariableNames', {'FileName', 'Correlation'});
% writetable(resultsTable, outputFile);
% 
% disp(['Correlation results saved to: ', outputFile]);
