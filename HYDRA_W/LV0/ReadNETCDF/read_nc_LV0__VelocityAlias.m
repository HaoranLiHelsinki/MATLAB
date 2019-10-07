function [temp] = read_nc_LV0__VelocityAlias(current_spec_db_new , indx_height, shift_pixel, idx_chirp, specN   );
% This function is to correct velocity alias
if shift_pixel >=0
    temp = nan(1,1024);
    temp( (1+shift_pixel) : (specN(idx_chirp)) ) = ...
        current_spec_db_new(indx_height , (1) : specN(idx_chirp)- shift_pixel  );
else
    temp = nan(1,1024);
    temp( (1) : (specN(idx_chirp)+shift_pixel) ) = ...
        current_spec_db_new(indx_height , (1-shift_pixel) : specN(idx_chirp) );
end
