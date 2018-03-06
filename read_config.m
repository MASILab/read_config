function config = read_config(config_path)
    % Reads "names" from "config" file. Config file must have format:
    %   % comment
    %   name =
    %   array
    %   name = num
    %   name = string
    %   ...
    % It returns everything as a struct with members corresponding to the 
    % name(s). If multiple names are found, then struct member will be a 
    % cell array. 
    %  
    % Inputs:
    %   config_path - string; path to config file to read from.
    %
    % Outputs:
    %   config - struct;
                
    % Check to make sure config file exists
    if exist(config_path,'file') == 0
        error(['Config file: ' config_path ' does not exist.']);
    end
    
    % Initialize
    config = struct();
    
    % Go through line by line; treat all names as cell arrays for now (for
    % simplicity) and "uncell" names with single entries afterwards.
    f = fopen(config_path);
    line = fgetl(f);
    line_num = 1;
    in_array = false; % Gets set to true for lines in array
    while ischar(line)
        % Trim leading and trailing white spaces
        line = strtrim(line);        
        % Make sure line isn't blank or a comment
        if ~isempty(line) && line(1) ~= '%'     
            % Find location(s) of equal sign(s)
            idx_equal = strfind(line,'=');
            if isempty(idx_equal)
                % We must be "in" an array for this to be the case.
                if in_array
                    % Use name from previous iteration; attempt to 
                    % concatenate array row.
                    try
                        config.(name){end} = vertcat(config.(name){end},str2num(line)); %#ok<ST2NM>
                    catch e
                        error(['Failed to concatenate line: ' ...
                                num2str(line_num) ' for array with ' ...
                               'name: "' name '". Are you sure ' ...
                               'this is a valid matrix? ' getReport(e)]);
                    end
                else
                    error(['Unknown line: ' num2str(line_num) ' ' ...
                           'following name: "' name '". A line without ' ...
                           'an "=" is only valid for an array.']);
                end
            else
                % This is a name; initialize cell if name doesn't exist
                name = strtrim(line(1:idx_equal(1)-1));
                if ~isfield(config,name)
                    config.(name) = {};
                end             
                
                % Test if name is a num, string, or array    
                param = strtrim(line(idx_equal(1)+1:end));
                if ~isempty(param)                
                    % This is either a num or string
                    if isempty(str2num(param)) %#ok<ST2NM>
                        % string
                        config.(name){end+1} = param;
                    else
                        % number
                        config.(name){end+1} = str2num(param); %#ok<ST2NM>
                    end                    
                    % We are definitely no longer in an array
                    in_array = false;
                else
                    % This is an array; initialize it
                    config.(name){end+1} = [];
                    in_array = true;
                end
            end
        end
        
        % Get next line
        line = fgetl(f);
        line_num = line_num+1;
    end
    fclose(f);
    
    % "Uncell" names with single entries.
    config_fields = fields(config);
    for i = 1:length(config_fields)
        if length(config.(config_fields{i})) == 1
            config.(config_fields{i}) = config.(config_fields{i}){1};
        end
    end
end