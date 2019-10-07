clc
clear
close all

% Number of points exceeding the Nyquist velocity
% e.g., N_FFT = 1024, V_max = 10.2494; 
% if  Vraindrop = 10.4294 > V_max, velocity folding happens
% 1 point will be folded to another side.
% Personally, I set the number of points as 100,
% it could be > 100, Please check spectra figs and use a proper value
len_alias = 200; 

% Path of raw data 
path_folder = 'F:\W_band_LDR\raw_spectra\D18\';
list_nc = dir([path_folder '*.nc']);
indx_nc = 1;
path_file = fullfile( list_nc(indx_nc).folder ,list_nc(indx_nc).name );

% basic file information, load data
ncinfo = ncinfo(path_file);

range = ncread(path_file , 'range');
time = ncread(path_file , 'time');
specN = single(ncread(path_file , 'SpecN'));
maxVel = ncread(path_file ,'maxVel');

spec_V = ncread(path_file , 'spec_V'); spec_V_db = 10*log10(spec_V);
spec_HV = ncread(path_file , 'spec_HV');

range_offsets = ncread(path_file , 'range_offsets');
AliasMask = ncread(path_file ,'AliasMask');
MinVel = ncread(path_file ,'MinVel');

%% do time loop 
for indx_time  = 655
    current_spec_db(:,:) = spec_V_db(indx_time , : ,:);
    
    % unfolding velocity
    [current_spec_db_new, velocity] = ...
        read_nc_LV0__VelocityFold(current_spec_db, range_offsets, len_alias, specN ,range  ,maxVel  );
    
    data_correct.current_spec_db = current_spec_db_new;
    data_correct.v1  = velocity.v1;data_correct.v2  = velocity.v2;data_correct.v3  = velocity.v3;
    
    % do height loop 
    for indx_height = 1 : length(range)
        idx_chirp = int32(find(range_offsets(2:end) - indx_height+1 > 0,1,'first'));
        if isempty(idx_chirp) % then indx_height  is within last chirp
            idx_chirp = length(range_offsets);
        end
        
        if isnan(MinVel(indx_time,indx_height)) || MinVel(indx_time,indx_height) == -maxVel(idx_chirp)
            continue;
        else % if minimum velocity changes; This is not common, but RPG has such setting. 
            dv =  maxVel(idx_chirp) +  MinVel(indx_time,indx_height);
            d_v_resolution = maxVel(idx_chirp)*2/ specN(idx_chirp);
            shift_pixel = single( int32(dv / d_v_resolution) );
           
            data_correct.current_spec_db(indx_height,:) = ...
                 read_nc_LV0__VelocityAlias(    data_correct.current_spec_db , indx_height, shift_pixel, idx_chirp, specN   );
            
        end
    
    end

end




