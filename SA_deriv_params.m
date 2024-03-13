function [FY_max, SA_at_FYmax, CS, CS_max, MZ_max] = SA_deriv_params(FY, MZ, SA)
    % Returns parameters that are determined from FY, MZ SA at which they occur 
    %
    % Arugments:
    %   FY              : Vector of all FY points 
    %   MZ              : Vector of all MZ points
    %   SA              : Vector of all SA points equally spaced in a range
    % 
    %         
    %
    % Output:
    %   FY_max          : Maximum FY at any SA
    %   SA_at_FYmax     : SA at which maximum FY occurs
    %   CS              : Cornering stiffness (dFy/dSA)
    %   CS_max          : Maximum cornerning 65stiffness value 

    FY_max = max(abs(FY));
    i = find(FY_max == FY);
    SA_at_FYmax = rad2deg(SA(i));
    CS = -1 * (gradient(FY(:)) ./ gradient(SA(:)));
    CS_max = max(abs(CS));
    MZ_max = max(abs(MZ));

end