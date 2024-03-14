function [tyre_model_name, round, corner_no_1, corner_no_2, drive_no_1, drive_no_2, tyre_unloaded_radius, unsprung_mass] = read_tyre_from_metadata(ID)
    % Returns corresponding data files, unloaded radius and tyre name read
    % from a modelling_metadata xlsx file.
    %
    % Arugments:
    %   ID      : ID respresenting data of target tye
    %
    % Output:
    %   corner_no_1   : No. of first cornering test
    %   corner_no_2   : No. of second cornering test
    %   drive_no_1    : No. of first drivebrake test
    %   drive_no_2    : No. of first drivebrake test

    modelling_metadata = readcell(strcat(pwd, '/tyre_models/modelling_metadata.xlsx'));
    tyre_OD_cell = modelling_metadata(ID+1,4); 
    tyre_OD = tyre_OD_cell{1};
    testing_round_cell = modelling_metadata(ID+1,7);
    round = testing_round_cell{1};
    
    
    cornering_no = char(modelling_metadata(ID+1,8));
    a = split(cornering_no, {','});
    corner_no_1 = a{1};
    corner_no_2 = a{2};
    
    drive_brake_no = convertCharsToStrings(modelling_metadata(ID+1,9));
    if drive_brake_no == 'ND'
       disp('No DriveBrake data')
       drive_no_1 = 'ND';
       drive_no_2 = 'ND';
    else
        b = split(drive_brake_no, {','});
        drive_no_1 = b{1};
        drive_no_2 = b{2};
    end
   
    tyre_model_name = modelling_metadata(ID+1,10);
    tyre_unloaded_radius = tyre_OD * 0.0254 * 0.5; % D (in inches) * 0.0254 (convert in. to m) * 0.5 (determine rad from dia)
    
    unsprung_mass_cell = modelling_metadata(ID+1,11);
    unsprung_mass = unsprung_mass_cell{1};

end


