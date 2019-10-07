clc
clear
close all

folder_kasacr = 'E:\A_ML_saggy\kasacr\';
list_kasacr = dir([folder_kasacr , '*.nc']);

for indx_nc = 1:58
    try
        
    file_list_current = list_kasacr(indx_nc);
    [data_kasacr]   = read_radar_kasacr_vpt(file_list_current)
   plot_KASACR_Ze_LDR(data_kasacr)
    catch
        continue;
    end
end