function run_curvefit_2(ID)
    % Create and save model based on ID
    %
    % Arugments:
    %   ID          : ID respresenting data of target tye
    %
    % Output:
    %   tyre_model  : Saves .tir model with appropriate name

% Select tyre for analysis
ID = 29             %internal_tyre_ID used in excel file

% Options  1 == yes, 0 == no
fit_model = 1; %Can turn off model fitting for trouble shooting 

% Read in tyre metadata
[tyre_model_name, round, corner_no_1, corner_no_2, drive_no_1, drive_no_2, tyre_unloaded_radius] = read_tyre_from_metadata(ID)

% Specifying path to testing data
    %data_folder = 'J:\SAE\CMT\5. Vehicle Dynamics\Tyres\TTC_downloaded_data'; %Change if access to J-drive isn't available
data_folder = 'C:\Users\matth\Desktop\TTC_downloaded_data';
parser = tydex.parsers.FSAETTC_SI_ISO_Mat();
    
% Prepare measurements for fitting
if round == 9
    if drive_no_1 == 'ND';
        measurementsCornering = round_9_parser(data_folder, 'Cornering', corner_no_1, corner_no_2);
    else
        measurementsCornering = round_9_parser(data_folder, 'Cornering', corner_no_1, corner_no_2);
        measurementsDriveBrake = round_9_parser(data_folder, 'DriveBrake', drive_no_1, drive_no_2);
    end
elseif round == 8
    if drive_no_1 == 'ND';
        measurementsCornering = round_8_parser(data_folder, 'Cornering', corner_no_1, corner_no_2);
    else
        measurementsCornering = round_8_parser(data_folder, 'Cornering', corner_no_1, corner_no_2);
        measurementsDriveBrake = round_8_parser(data_folder, 'DriveBrake', drive_no_1, drive_no_2);
    end
elseif round == 7
    if drive_no_1 == 'ND';
        measurementsCornering = round_7_parser(data_folder, 'Cornering', corner_no_1, corner_no_2);
    else
        measurementsCornering = round_7_parser(data_folder, 'Cornering', corner_no_1, corner_no_2);
        measurementsDriveBrake = round_7_parser(data_folder, 'DriveBrake', drive_no_1, drive_no_2);
    end
elseif round == 99
    if drive_no_1 == 'ND';
        measurementsCornering = round_99_parser(data_folder, 'Cornering', corner_no_1, corner_no_2);
    else
        measurementsCornering = round_99_parser(data_folder, 'Cornering', corner_no_1, corner_no_2);
        measurementsDriveBrake = round_99_parser(data_folder, 'DriveBrake', drive_no_1, drive_no_2);
    end
end

% Downsample to speed up curve fitting 
if drive_no_1 == 'ND';
    measurements = [measurementsCornering]; %When drive brake isn't available  
else
    measurements = [measurementsCornering measurementsDriveBrake];
end
measurementsDownsampled = measurements.downsample(20); % (dt = 0.01s --> 0.2s)

% Select fitmodes
if drive_no_1 == 'ND';
    fitmodes = {'Fy0','Mz0'}; %Fitting when drive brake isn't available  
else
    fitmodes = {'Fx0','Fy0','Mz0','Fx','Fy','Mz','Mx'};
end

% Create tyre model
tyre = MagicFormulaTyre();

% Determine general model params
tyre.Parameters.NOMPRES.Value = max([measurements.NOMPRES]);
tyre.Parameters.FNOMIN.Value = max([measurements.FNOMIN]);
tyre.Parameters.UNLOADED_RADIUS.Value = tyre_unloaded_radius;

% Set other constraints of your choosing:
    %tyre.Parameters.PCY1.Value = 2;
    %tyre.Parameters.PCY1.Fixed = true;

% Fit model
if fit_model == 1
    options = optimset('fmincon');
    options.UseParallel = true;
    options.Display = 'none';
    options.DiffMinChange = 1E-3;
    tyre.fit(measurementsDownsampled, fitmodes, options)
end

% Export as Tyre Property File (.tir)
file = strcat(pwd, '\tyre_models\', tyre_model_name);
tyre.saveTIR(file, 'DisplayConsole', false);


