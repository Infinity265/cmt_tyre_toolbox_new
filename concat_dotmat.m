function concat_mat = concat_dotmat(file_1, file_2)
    % concat_mat is some clever code I found online that combines .mat
    % files with the same variables (as is the case for TTC data)
    %
    % Arguments:
    %   file_1     : First loaded .mat file 
    %   file_2     : Second loaded .mat file 
    %
    % Returns:
    %   concat_mat : Appened mat files 

    % Load data from two MAT-files
    x = file_1;
    y = file_2;
    
    % Check to see that both files contain the same variables
    vrs = fieldnames(x);
    if ~isequal(vrs,fieldnames(y))
        error('Different variables in these MAT-files')
    end
    
    % Concatenate data
    for k = 1:length(vrs)
        concat_mat.(vrs{k}) = [x.(vrs{k});y.(vrs{k})];
    end