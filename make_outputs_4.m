function make_outputs_4(ID, graph_options, write_xlsx)
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
    %   write_xlsx      : Write output file parameters to excel file 
    %         
    %
    % Output:
    %   corner_no_1   : No. of first cornering test
    %   corner_no_2   : No. of second cornering test
    %   drive_no_1    : No. of first drivebrake test
    %   drive_no_2    : No. of first drivebrake test
    
    % Hardcode function input params
    ID = 29;
    graph_options = [1,1,1,1];
    write_xlsx = 1;
    
    % Read model
    [tyre_model_name, ~, ~, ~, drive_no_1, ~, ~, unsprung_mass] = read_tyre_from_metadata(ID);
    target_model = char(tyre_model_name);
    file = strcat(pwd, '\tyre_models\', target_model);
    tyre = MagicFormulaTyre(file);
    
    % Do not read curve if FX data missing
    if drive_no_1 == 'ND'
        has_FX = 0;
    else
        has_FX = 1;
    end

    
    % Vehicle parameters
    FZstat = 240 * 9.8 * 0.25;          %2024 Design Mass = 240kg
    LLT = 100;                          %Currently estimated LLT
    DF = 300 / 4;                       %2024s downforce target at FY limit (skidpad)
    FZLLTDF = FZstat - LLT + DF;
    
    % Graphing selection, 1 == plot, 0 == don't plot
    graphFYSA = graph_options(1);
    graphCSSA = graph_options(2);
    graphMZSA = graph_options(3); % Currently producing funny results
    graphFXSR = graph_options(4);

    % General form magic formula
    %[FX,FY,MZ,MY,MX] = magicformula(tyre, SR, SA, FZ);
    
    % Determine Fy with swept slip angle
    SA = linspace(deg2rad(-15), deg2rad(15));
    SA_deg = rad2deg(SA);
    SR = 0;

        % Solve models for FZ and MZ at slipt swept angles, additionally
        % derive representative parameters of the tyres

    [~, FY_FZstat, MZ_FZstat] = magicformula(tyre, SR, SA, FZstat);
    [FY_max_FZstat, SA_at_FYmax_FZstat, CS_FZstat, CS_max_FZstat, MZ_max_FZstat] = SA_deriv_params(FY_FZstat, MZ_FZstat, SA);
    
    [~, FY_FZLLTDF, MZ_FZLLTDF] = magicformula(tyre, SR, SA, FZLLTDF);
    [FY_max_FZLLTDF, SA_at_FYmax_FZLLTDF, CS_FZLLTDF, CS_max_FZLLTDF, MZ_max_FZLLTDF] = SA_deriv_params(FY_FZLLTDF, MZ_FZstat, SA);
    
    
    % FYvsSA graphing
    if graphFYSA == 1   
        figure(); grid on; hold on
        plot(SA_deg, FY_FZstat, 'LineWidth', 2, 'DisplayName', num2str(FZstat))
        %plot(SA_deg, FY_FZLLTDF, 'LineWidth', 2, 'DisplayName', num2str(FZLLTDF))
        lgd = legend('Location', 'best'); xlabel('SA [deg]'); ylabel('FY [N]')
        lgd.Title.String = 'FZ'; lgd.Title.FontSize = 8;
    end
    
    % CSvsSA graphing
    if graphCSSA == 1
        figure(); grid on; hold on
        plot(SA_deg, CS_FZstat, 'LineWidth', 2, 'DisplayName', num2str(FZstat))
        %plot(SA_deg, CS_FZLLTDF, 'LineWidth', 2, 'DisplayName', num2str(FZLLTDF))
        lgd = legend('Location', 'best'); xlabel('SA [deg]'); ylabel('CS [dFY/dSA]')
        lgd.Title.String = 'FZ'; lgd.Title.FontSize = 8;
    end
    
    % MZvsSA graphing
    if graphMZSA == 1
        figure(); grid on; hold on
        plot(SA_deg, MZ_FZstat, 'LineWidth', 2, 'DisplayName', num2str(FZstat))
        %plot(SA_deg, MZ_FZLLTDF, 'LineWidth', 2, 'DisplayName', num2str(FZLLTDF))
        lgd = legend('Location', 'best'); xlabel('SA [deg]'); ylabel('MZ [Nm]')
        lgd.Title.String = 'FZ'; lgd.Title.FontSize = 8;
    end
    

    % Some tyres do not have testing data for FX if so allocate output
    % variables as 'No data'
    FX_max_FZstatic = 'ND';
    SR_at_FXmax_FZstatic = 'ND';
    FX_max_FZLLTDF  = 'ND';
    SR_at_FXmax_FZLLTDF  = 'ND';
    
    
    if has_FX == 1
        % SR calculations
        SR = linspace(deg2rad(-15), deg2rad(15));
        SA = 0;
        
        [FX_FZstatic] = magicformula(tyre, SR, SA,  FZstat);
        [FX_max_FZstatic, SR_at_FXmax_FZstatic] = SR_deriv_params(FX_FZstatic, SR);
        
        [FX_FZLLTDF] = magicformula(tyre, SR, SA,  FZLLTDF);
        [FX_max_FZLLTDF, SR_at_FXmax_FZLLTDF] = SR_deriv_params(FX_FZLLTDF, SR);
        
        % FXvsSA graphing
        if graphFXSR == 1
            figure(); grid on; hold on
            plot(SR, FX_FZstatic, 'LineWidth', 2, 'DisplayName', num2str(FZstat))
            %plot(SR, FX_FZLLTDF, 'LineWidth', 2, 'DisplayName', num2str(FZLLTDF))
            lgd = legend('Location', 'best'); xlabel('SR [-]'); ylabel('FX [N]');
            lgd.Title.String = 'FZ'; lgd.Title.FontSize = 8;
        end
    end
    
    % Compile tyre selection parameters
    outputs = {'ID', ID;
        'tyre', target_model;
        'unsprung_mass', unsprung_mass;
        'SA_at_FYmax_FZstat', SA_at_FYmax_FZstat;
        'FY_max_FZstat', FY_max_FZstat;
        'SA_at_FYmax_FZLLTDF', SA_at_FYmax_FZLLTDF;
        'FY_max_FZLLTDF', FY_max_FZLLTDF;
        'CS_max_FZstat', CS_max_FZstat;
        'load_sensitive', 1;
        'MZ_max_FZstat', MZ_max_FZstat;
        'MZ_max_FZLLTDF', MZ_max_FZLLTDF
        'FX_max_FZstatic', FX_max_FZstatic;
        'SR_at_FXmax_FZstatic', SR_at_FXmax_FZstatic;
        'FX_max_FZLLTDF', FX_max_FZLLTDF;
        'SR_at_FXmax_FZLLTDF', SR_at_FXmax_FZLLTDF};
    
    % Format and save tyre selection parameters 
    tyre_selection_params = transpose(outputs);
    t = tyre_selection_params(2, :);
    filename = strcat(pwd, '/model_outputs/tyre_ranking.xlsx'); 
    
    
    % Determine location to write
    if write_xlsx == 1
        start_cell = strcat('A', string(ID+1))
        writecell(t, filename,'Sheet',1,'Range', start_cell)
    end

end