function [FY_max, SA_at_FYmax, CS, CS_max] = SA_deriv_params(FY, SA)
    % Returns parameters that are determined from FY, MZ SA at which they occur 
    %
    % Arugments:
    %   FY              : Vector of all FY points 
    %   SA              : Vector of all SAs corresponding to each FY
    %         
    %
    % Output:
    %   FY_max          : Maximum FY at any SA
    %   SA_at_FYmax     : SA at which maximum FY occurs
    %   CS              : Cornering stiffness (dFy/dSA)
    %   CS_max          : Maximum cornerning stiffness value 

    FY_max = max(abs(FY));
    i = find(FY_max == FY);
    SA_at_FYmax = rad2deg(SA(i));
    CS = -1 * (gradient(FY(:)) ./ gradient(SA(:)));
    CS_max = max(abs(CS));
end