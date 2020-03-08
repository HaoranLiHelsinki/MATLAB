clear
clc
% This is an example of reading FY-4 fulldisk netcdf data. 
% Geocoordinates are created by reading a '.raw' file (~70 Mb).
% This file can be dowloaded from CMA website.
% Cloud top height is plotted.

% Contact: Haoran Li;  haoran.li@helsinki.fi


% Read netcdf file
filename = 'FY4A-_AGRI--_N_DISK_1047E_L2-_CTH-_MULT_NOM_20200217000000_20200217001459_4000M_V0001.NC';

nc_info = ncinfo(filename);

CTH  = ncread(filename, 'CTH');
DQF=ncread(filename, 'DQF');
Observing_Type = ncread(filename, 'OBIType');

geospatial_lat_lon_extent = ncread(filename,'geospatial_lat_lon_extent');

geospatial_lat_lon_lat = ncread(filename,'nominal_satellite_subpoint_lat');
geospatial_lat_lon_lon = ncread(filename,'nominal_satellite_subpoint_lon');

geospatial_lat_lon_lon = double(geospatial_lat_lon_lon);

CTH(CTH > 65530) = nan;
CTH(CTH < 0) = nan;

% Read Lat and Lon from 'FullMask_Grid_4000.raw'  
[lon, lat] = read_lon_lat('FullMask_Grid_4000.raw' );

%%

worldmap([-80 80],[geospatial_lat_lon_lon-90 geospatial_lat_lon_lon+90])
setm(gca,'mapprojection','ortho')
hold on
pcolorm(lat, lon, CTH)
caxis([0 15000])

colormap(hsv)
cb = colorbar;
ylabel(cb, 'Cloud top Height [m]')
load coastlines 
plotm(coastlat,coastlon,'k')

title('FY-4 Fulldisk Cloud Top Height')
