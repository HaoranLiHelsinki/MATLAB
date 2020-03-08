function [lon, lat] = read_lon_lat( file_grid );

 Nl=2748*2;
Nc=2748;

fid = fopen( file_grid , 'r' );
I = fread(fid, Nl*Nc, 'double');
Z=reshape(I,Nl,Nc);

for indx = 1 :2748
    lat(indx,:) = Z(indx*2-1,:);
    lon(indx,:) = Z(indx*2,:);
end

lat(lat>1000) = nan;
lon(lon>1000) = nan;
