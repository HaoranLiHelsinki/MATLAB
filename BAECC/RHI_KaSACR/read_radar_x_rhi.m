function [data_x] = read_radar_x_rhi(file_list_x)

time_all = [];
ze_all = [];

for indx_file = 1  :length(file_list_x)

path_file = [file_list_x(indx_file).folder...
         '\' file_list_x(indx_file).name] ;
     
info_file = ncinfo(path_file);
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
% rho = ncread(path_file,'copol_correlation_coeff');

% Ze

elevation = ncread( path_file , 'elevation' );
reflectivity =ncread( path_file , 'reflectivity' );
range = ncread( path_file , 'range' );

num  = find( abs(elevation-90) < 0.5 );
time_new = time(num);
reflectivity_new = reflectivity(:,num);



time_all = [time_all; time_new];
ze_all = [ze_all reflectivity_new];

end

data_x.ze = ze_all;
data_x.time = time_all;
data_x.height = range;

% figure
% pcolor(data_x.time, data_x.height, data_x.ze )
% shading flat
% axis tight
%  datetick()