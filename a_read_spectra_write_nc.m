clc
clear
close all
 
folder_LV0 = 'F:\W_band_LDR\raw_spectra\D18\'
list_LV0 = dir([folder_LV0 '*.LV0']);


for indx_LV0 = 1  : length(list_LV0)

    
    fname = fullfile(list_LV0(indx_LV0).folder ,list_LV0(indx_LV0).name);
    fprintf('\n %s',  fname)
    [header, offset] = reading_Wband_header(fname);
    header.MSL = 181; % height above the mean sea level. [m]
    
    [data] = reading_Wband_spectra(fname, header, offset);

    datestr(data.ObsTime(1));
    
    outfile = [fname(1:end-4) '.nc'];
    config.contactperson = 'Haoran Li (U. Helsinki); haoran.li@helsinki.fi';
    config.processing_script = 'LDR mode for HYYTIALA W-band radar - 20191005 - v0';
    
    fprintf('\n %s', '    Saving .nc ')
    
    write_W_data_2_nc_LV0(data , header ,outfile, config);

end