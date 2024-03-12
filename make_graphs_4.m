function make_graphs_4(ID, graph_options)
    % Returns tire selection parameters as determined by the script. Can
    % additionally plot grpahs
    %
    % Arugments:
    %   ID              : ID respresenting data of target tye
    %   graph_options   : Four space vector corresponding to graphing
    %                       [graphFYSA,
    %                       graphCSSA, 
    %                       graphMZS,
    %                       graphFXSR]
    %                     1 == plot, 0 == no plot
    %         
    %
    % Output:
    %   corner_no_1   : No. of first cornering test
    %   corner_no_2   : No. of second cornering test
    %   drive_no_1    : No. of first drivebrake test
    %   drive_no_2    : No. of first drivebrake test
    
    % Hardcode function input params
    % ID = 6;
    % graph_options = [0,0,0,0];
    
    % Read model
    [tyre_model_name, a, b, c, drive_no_1] = read_tyre_from_metadata(ID);
    target_model = char(tyre_model_name);
    file = strcat(pwd, '\tyre_models\', target_model);
    tyre = MagicFormulaTyre(file);
    
    % Do not read curve if FX data missing
    if drive_no_1 == 'ND';
        has_FX = 0;
    else
        has_FX = 1;
    end

    
    % Vehicle parameters
    FZ_design = 240 * 9.8 * 0.25; %2024 Design Mass = 240kg
    LLT = 100; %Currently estimated LLT
    FZ_LLT = FZ_design - LLT;
    
    % Graphing selection, 1 == plot, 0 == don't plot
    graphFYSA = graph_options(1);
    graphCSSA = graph_options(2);
    graphMZSA = graph_options(3); % Currently producing funny results
    graphFXSR = graph_options(4);

    % 16 inch tyres dont have FXSR data, initialising data to reflect
    % accordingly
    FX_design_max = 'ND';
    SR_at_FX_max = 'ND';
    FX_max_with_LLT = 'ND';
    SR_at_FX_max_with_LLT = 'ND';
    
    % General form magic formula
    %[FX,FY,MZ,MY,MX] = magicformula(tyre, SR, SA, FZ);
    
    % Determine Fy with swept slip angle
    SA = linspace(deg2rad(-15), deg2rad(15));
    SA_deg = rad2deg(SA);
    SR = 0;
    
    [FX_ignore, FY_design, MZ_design] = magicformula(tyre, SR, SA,  FZ_design);    
    FY_max = max(abs(FY_design));
    i = find(FY_design == FY_max);
    SA_at_FY_max = rad2deg(SA(i));
    CS_design = -1 * (gradient(FY_design(:)) ./ gradient(SA(:)));
    CS_design_max = max(abs(CS_design));
    
    [FX_ignore, FY_LLT, MZ_LLT] = magicformula(tyre, SR, SA, FZ_LLT);
    FY_max_with_LLT = max(abs(FY_LLT));
    i = find(FY_LLT == FY_max_with_LLT);
    SA_at_FY_max_with_LLT = rad2deg(SA(i));
    CS_LLT = -1 * (gradient(FY_LLT(:)) ./ gradient(SA(:)));
    CS_LLT_max = max(abs(CS_LLT));

    FY
    
    % FYvsSA graphing
    if graphFYSA == 1   
        figure(); grid on; hold on
        plot(SA_deg, FY_design, 'LineWidth', 2, 'DisplayName', num2str(FZ_design))
        plot(SA_deg, FY_LLT, 'LineWidth', 2, 'DisplayName', num2str(FZ_LLT))
        lgd = legend('Location', 'best'); xlabel('SA [deg]'); ylabel('FY [N]')
        lgd.Title.String = 'FZ'; lgd.Title.FontSize = 8;
    end
    
    % CSvsSA graphing
    if graphCSSA == 1
        figure(); grid on; hold on
        plot(SA_deg, CS_design, 'LineWidth', 2, 'DisplayName', num2str(FZ_design))
        plot(SA_deg, CS_LLT, 'LineWidth', 2, 'DisplayName', num2str(FZ_LLT))
        lgd = legend('Location', 'best'); xlabel('SA [deg]'); ylabel('CS [dFY/dSA]')
        lgd.Title.String = 'FZ'; lgd.Title.FontSize = 8;
    end
    
    % MZvsSA graphing
    if graphMZSA == 1
        figure(); grid on; hold on
        plot(SA_deg, MZ_design, 'LineWidth', 2, 'DisplayName', num2str(FZ_design))
        plot(SA_deg, MZ_LLT, 'LineWidth', 2, 'DisplayName', num2str(FZ_LLT))
        lgd = legend('Location', 'best'); xlabel('SA [deg]'); ylabel('MZ [Nm]')
        lgd.Title.String = 'FZ'; lgd.Title.FontSize = 8;
    end
    
    if has_FX == 1
        % SR calculations
        SR = linspace(deg2rad(-15), deg2rad(15));
        SA = 0;
        
        [FX_design] = magicformula(tyre, SR, SA,  FZ_design);
        FX_design_max = max(abs(FX_design));
        i = find(FX_design_max == FX_design);
        SR_at_FX_max = rad2deg(SR(i));
        
        [FX_LLT] = magicformula(tyre, SR, SA,  FZ_LLT);
        FX_max_with_LLT = max(abs(FX_LLT));
        i = find(FX_max_with_LLT == FX_LLT);
        SR_at_FX_max_with_LLT = rad2deg(SR(i));
        
        % FXvsSA graphing
        if graphFXSR == 1;
            figure(); grid on; hold on
            plot(SR, FX_design, 'LineWidth', 2, 'DisplayName', num2str(FZ_design))
            plot(SR, FX_LLT, 'LineWidth', 2, 'DisplayName', num2str(FZ_LLT))
            lgd = legend('Location', 'best'); xlabel('SX [-]'); ylabel('FX [N]');
            lgd.Title.String = 'FZ'; lgd.Title.FontSize = 8;
        end
    end
    
    % Compile tyre selection parameters
    outputs = {'ID', ID;
        'tyre', target_model;
        'SA_at_FY_max', SA_at_FY_max
        'FY_design_max', FY_max;
        'SA_at_FY_max_with_LLT', SA_at_FY_max_with_LLT;
        'FY_max_with_LLT', FY_max_with_LLT;
        'CS_design_max', CS_design_max;
        'CS_LLT_max', CS_LLT_max;
        'load_sensitive', 1;
        'MZ_max', 1;
        'SA_at_max_MZ', 1;
        'FX_design_max', FX_design_max;
        'SR_at_FX_max', SR_at_FX_max;
        'FX_max_with_LLT', FX_max_with_LLT
        'SR_at_FX_max_with_LLT', SR_at_FX_max_with_LLT;};
    
    % Format and save tyre selection parameters 
    tyre_selection_params = transpose(outputs);
    t = tyre_selection_params(2, :);
    filename = strcat(pwd, '/model_outputs/tyre_ranking.xlsx');   
    
    % Determine location to write
    start_cell = strcat('A', string(ID+1))
    writecell(t, filename,'Sheet',1,'Range', start_cell)

end