function measurements = round_99_parser(TTC_path, type, file_no_1, file_no_2)
    % This function locates and parses TTC testing data analysis
    %
    % Arguments:
    %   TTC_path            : Path to location of TTC data 
    %   type                : Cornering or DriveBrake
    %   file_no_1           : First data file
    %   file_no_2           : Second data file
    %   file_no_3           : Third data file
    %
    % Returns:
    %   concat_mat : Appened mat files 

    % Initialisation
    round_99_id = 'Z9999';
    parser = tydex.parsers.FSAETTC_SI_ISO_Mat();

    % Load and append
    file_1 = load(strcat(TTC_path, '\round_99\RunData_', type, '_Matlab_SI_Round99\', round_99_id, 'run', file_no_1, '.mat'));
    file_2 = load(strcat(TTC_path, '\round_99\RunData_', type, '_Matlab_SI_Round99\', round_99_id, 'run', file_no_2, '.mat'));
    data_append = concat_dotmat(file_1, file_2);
    append_file = strcat(pwd, '/temp/', type, '_appended.mat');
    save(append_file,'-struct','data_append') %Save combined .mat file to temp folder

    % Parse
    measurements = parser.run(append_file);
end


