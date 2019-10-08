function [data_x] = read_radar_x_vpt(file_list_x)

time_all = [];
ze_all = [];
v_all = [];
total_sw = [];
rho_toal = [];


for indx_file = 1:length(file_list_x)

path_file = [file_list_x(indx_file).folder...
         '\' file_list_x(indx_file).name] ;
     
info_file = ncinfo(path_file);
noise = ncread(path_file,'r_calib_noise_source_power_v' );
% time
time_read_var = ncread(path_file,'time_offset');
time_read_att = ncreadatt(path_file,'time_offset','units');

time_base_str = time_read_att(15:end-5);
time_base_vec = datevec(time_base_str, 'yyyy-mm-dd HH:MM:SS');
time_base_num = datenum(time_base_vec);

time = time_base_num + time_read_var/3600.0/24.0;

% range
range = ncread(path_file, 'range');

% linear_depolarization_ratio
rho = ncread(path_file,'copol_correlation_coeff');

%v
v = ncread(path_file, 'mean_doppler_velocity' );

%
rho_hv = ncread(path_file, 'copol_correlation_coeff' );
rho_hv(1:10 , :) = 1;

% spectral width

sw = ncread(path_file,'spectral_width' );

% Ze

ze = ncread(path_file,'reflectivity');

time_all = [time_all; time];
ze_all = [ze_all ze];
v_all = [v_all v];
total_sw = [total_sw  sw];
rho_toal = [rho_toal rho_hv];
end

data_x.ze = ze_all;
data_x.time = time_all;
data_x.height = range;
data_x.v = v_all;
data_x.rho = rho_toal ;
data_x.rho(data_x.rho>1) = 1;

data_x.sw = total_sw;

% figure
% pcolor(data_x.time, data_x.height, data_x.ze )
% shading flat
% axis tight
%  datetick()