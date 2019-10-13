function [current_spec_db_new, velocity] = read_nc_LV0__VelocityFold(current_spec_db, range_offsets, len_alias, specN ,range ,maxVel  )

% This function is to mitigate the velocity folding when the velocity exceeds Nyquist velocity (maxV)    

    Num_chirp = 1 ;% chirp 1

    temp = current_spec_db(range_offsets(Num_chirp)+1:range_offsets(Num_chirp+1)   , ...
        specN(Num_chirp)-len_alias+1:specN(Num_chirp) ) ;  
    current_spec_db_new1 = [temp  current_spec_db(range_offsets(Num_chirp)+1:range_offsets(Num_chirp+1)  ,  ...
        1: specN(Num_chirp)-len_alias)] ;    
    
    tempv = -maxVel(Num_chirp) : maxVel(Num_chirp)*2/single(specN(Num_chirp)-1) :maxVel(Num_chirp);
    d_v = tempv(2) - tempv(1) ;
    velocity.v1 = tempv - d_v *  len_alias;
    
    Num_chirp = 2 ;  % chirp2
    temp = current_spec_db(range_offsets(Num_chirp)+1:range_offsets(Num_chirp+1), ...
        specN(Num_chirp)-len_alias+1:specN(Num_chirp) ) ;   
    current_spec_db_new2 = [temp  current_spec_db(range_offsets(Num_chirp)+1:range_offsets(Num_chirp+1), ...
        1: specN(Num_chirp)-len_alias ) ] ;
    if specN(Num_chirp) < 1024 % patch nan to make the same length
        current_spec_db_new2(:,specN(Num_chirp)+1:1024) = nan;
    end
    tempv = -maxVel(Num_chirp) : maxVel(Num_chirp)*2/single(specN(Num_chirp)-1) :maxVel(Num_chirp);
    d_v = tempv(2) - tempv(1) ;
    velocity.v2 = tempv - d_v *  len_alias;
    
    Num_chirp = 3 ; % chirp 3
    temp = current_spec_db(range_offsets(Num_chirp)+1: length(range), ...
        specN(Num_chirp)-len_alias+1:specN(Num_chirp) ) ; 
    current_spec_db_new3 = [temp  current_spec_db(range_offsets(Num_chirp)+1: length(range),   ...
        1: specN(Num_chirp)-len_alias)] ;   
    if specN(Num_chirp) < 1024 % patch nan to make the same length
        current_spec_db_new3(:,specN(Num_chirp)+1:1024) = nan;
    end
    tempv = -maxVel(Num_chirp) : maxVel(Num_chirp)*2/single(specN(Num_chirp)-1) :maxVel(Num_chirp);
    d_v = tempv(2) - tempv(1) ;
    velocity.v3 = tempv - d_v *  len_alias;
    
    
    current_spec_db_new = [ current_spec_db_new1;  current_spec_db_new2;  current_spec_db_new3];
    