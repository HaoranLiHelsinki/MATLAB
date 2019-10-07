function [data_x] = read_radar_kasacr_vpt(file_list_x)

time_all = [];
ze_all = [];
v_all = [];
ldr_all = [];
p_s_all = [];

for indx_file = 1:length(file_list_x)

path_file = [file_list_x(indx_file).folder...
         '\' file_list_x(indx_file).name] ;
     info = ncinfo(path_file);
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
ldr = ncread(path_file,'linear_depolarization_ratio');

% phase change
p_s =  ncread(path_file , 'cross_polar_differential_phase');

% velocity
v =  ncread(path_file ,'mean_doppler_velocity');


% Ze
ze = ncread(path_file,'reflectivity');

time_all = [time_all; time];
ze_all = [ze_all ze];
v_all = [v_all  v];
ldr_all = [ldr_all  ldr];
p_s_all = [p_s_all p_s];
end

data_x.ze = ze_all;
data_x.time = time_all;
data_x.height = range;
data_x.v = v_all;
data_x.ldr = ldr_all;
data_x.ps = p_s_all;
