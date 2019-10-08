clc
clear
close all

folder_kasacr = 'E:\A_ML_saggy\data\';
list_kasacr = dir([folder_kasacr , '*xsacr*.nc']);

for indx_nc = 1:1
%     try
        
    file_list_current = list_kasacr(indx_nc);
    [data_kasacr]   = read_radar_x_vpt(file_list_current)
   plot_XSACR_Ze_RHO(data_kasacr)
%     catch
%         continue;
%     end
end