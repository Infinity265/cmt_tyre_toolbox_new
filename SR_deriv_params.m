function [FX_max, SR_at_FYmax, CS, CS_max] = SR_deriv_params(FX, SR)
    % Returns parameters that are determined from FX and SR    
    %
    % Arugments:
    %   FX              : Vector of all FX points 
    %   SR              : Vector of all SAs corresponding to each FY
    %         
    %
    % Output:
    %   FX_max          : Maximum FX at any SR
    %   SR_at_FXmax     : SR at which maximum FX occurs

    FX_max = max(abs(FX));
    i = find(FX_max == FX);
    SR_at_FYmax = rad2deg(SR(i));
end