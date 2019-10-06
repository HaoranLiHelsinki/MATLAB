clc
clear
close all
 

pname = 'F:\W_band_LDR\raw_LV1\';
fname = '*.LV1';

DateVector = [2018, 04, 18, 18,0,0];
stDate = datenum(DateVector);
DateVector = [2018, 04, 18, 19,0,0];
enDate = datenum(DateVector);


fprintf('\n %s',  datestr(stDate ) )

[data, header] = Reading_HYDRA_W_data(pname, stDate, enDate, fname);


list_LV1 = dir([pname fname]);
indx_LV1 = 1;
path_LV0_file = fullfile( list_LV1(indx_LV1).folder, list_LV1(indx_LV1).name);

outfile = [path_LV0_file(1:end-4) '_LV1.nc'];
config.contactperson = 'Haoran Li (U. Helsinki); haoran.li@helsinki.fi';
config.processing_script = 'LV1 product, LDR mode, HYDRA_W  - 20191006 ';

fprintf('\n %s', '    Saving .nc ... ')

write_W_LV1_2_nc(data , header ,outfile, config);

fprintf(' %s', '    Please find .nc in the raw data folder.')




