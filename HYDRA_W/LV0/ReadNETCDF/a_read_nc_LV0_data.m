clc
clear
close all

path_folder = 'F:\W_band_LDR\raw_spectra\D18\';

list_nc = dir([path_folder '*.nc']);

indx_nc = 1;
path_file = fullfile( list_nc(indx_nc).folder ,list_nc(indx_nc).name );
ncinfo = ncinfo(path_file);

range = ncread(path_file , 'range');
time = ncread(path_file , 'time');
specN = ncread(path_file , 'SpecN');
maxVel = ncread(path_file ,'maxVel');

spec_V = ncread(path_file , 'spec_V'); spec_V_db = 10*log10(spec_V);
spec_HV = ncread(path_file , 'spec_HV');

range_offsets = ncread(path_file , 'range_offsets');
AliasMask = ncread(path_file ,'AliasMask');
MinVel = ncread(path_file ,'MinVel');

%%
for indx_time  = 655
    current_spec_db(:,:) = spec_V_db(indx_time , : ,:);
    
    len_alias = 100;
        
    [current_spec_db_new, velocity] = ...
        read_nc_LV0__VelocityFold(current_spec_db, range_offsets, len_alias, specN ,range  ,maxVel  );
    
    data_correct.current_spec_db = current_spec_db_new;
    data_correct.v1  = velocity.v1;data_correct.v2  = velocity.v2;data_correct.v3  = velocity.v3;
    
    for indx_height = 1 : length(range)
        idx_chirp = int32(find(range_offsets(2:end) - indx_height+1 > 0,1,'first'));
        if isempty(idx_chirp) % then indx_height  is within last chirp
            idx_chirp = length(range_offsets);
        end
        
        if isnan(MinVel(indx_time,indx_height)) || MinVel(indx_time,indx_height) == -maxVel(idx_chirp)
            continue;
        else
            dv =  maxVel(idx_chirp) +  MinVel(indx_time,indx_height);
            d_v_resolution = maxVel(idx_chirp)*2/1024;
            shift_pixel = int32(dv / d_v_resolution);
           
                data_correct.current_spec_db(indx_height,:) = ...
                 read_nc_LV0__VelocityAlias(    data_correct.current_spec_db , indx_height, shift_pixel, idx_chirp, specN , len_alias   );
            
        end
    
    end

end




