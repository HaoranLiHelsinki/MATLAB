function [current_spec_lin_new, velocity] = read_nc_LV0__VelocityFold_Ze_normalize(current_spec_lin, range_offsets, Ratio_alias, specN ,range ,maxVel  )

% 1) Observed linear Ze to Normalized linear Ze; 2) Unfold velocity when the velocity exceeds Nyquist velocity (maxV)    

    Num_chirp = 1 ;% chirp 1
    len_alias = specN(Num_chirp)*Ratio_alias;
    factor_ze = (0.5 * specN(Num_chirp)/maxVel(Num_chirp));
    temp = current_spec_lin(range_offsets(Num_chirp)+1:range_offsets(Num_chirp+1)   , ...
        specN(Num_chirp)-len_alias+1:specN(Num_chirp) ) ;  
    current_spec_lin_new1 = factor_ze * [temp  current_spec_lin(range_offsets(Num_chirp)+1:range_offsets(Num_chirp+1)  ,  ...
        1: specN(Num_chirp)-len_alias)] ;    
    
    tempv = -maxVel(Num_chirp) : maxVel(Num_chirp)*2/single(specN(Num_chirp)-1) :maxVel(Num_chirp);
    d_v = tempv(2) - tempv(1) ;
    velocity.v1 = tempv - d_v *  len_alias;
    
    Num_chirp = 2 ;  % chirp2
    len_alias = specN(Num_chirp)*Ratio_alias;
    factor_ze = (0.5 * specN(Num_chirp)/maxVel(Num_chirp));
    temp = current_spec_lin(range_offsets(Num_chirp)+1:range_offsets(Num_chirp+1), ...
        specN(Num_chirp)-len_alias+1:specN(Num_chirp) ) ;   
    current_spec_lin_new2 =  factor_ze * [temp  current_spec_lin(range_offsets(Num_chirp)+1:range_offsets(Num_chirp+1), ...
        1: specN(Num_chirp)-len_alias ) ] ;
    if specN(Num_chirp) < specN(1) % patch nan to make the same length
        current_spec_lin_new2(:,specN(Num_chirp)+1:specN(1)) = nan;
    end
    tempv = -maxVel(Num_chirp) : maxVel(Num_chirp)*2/single(specN(Num_chirp)-1) :maxVel(Num_chirp);
    d_v = tempv(2) - tempv(1) ;
    velocity.v2 = tempv - d_v *  len_alias;
    
    Num_chirp = 3 ; % chirp 3
    len_alias = specN(Num_chirp)*Ratio_alias;
    factor_ze = (0.5 * specN(Num_chirp)/maxVel(Num_chirp));
    temp = current_spec_lin(range_offsets(Num_chirp)+1: length(range), ...
        specN(Num_chirp)-len_alias+1:specN(Num_chirp) ) ; 
    current_spec_lin_new3 =  factor_ze * [temp  current_spec_lin(range_offsets(Num_chirp)+1: length(range),   ...
        1: specN(Num_chirp)-len_alias)] ;   
    if specN(Num_chirp) < specN(1) % patch nan to make the same length
        current_spec_lin_new3(:,specN(Num_chirp)+1:specN(1)) = nan;
    end
    tempv = -maxVel(Num_chirp) : maxVel(Num_chirp)*2/single(specN(Num_chirp)-1) :maxVel(Num_chirp);
    d_v = tempv(2) - tempv(1) ;
    velocity.v3 = tempv - d_v *  len_alias;
    
    
    current_spec_lin_new = [ current_spec_lin_new1;  current_spec_lin_new2;  current_spec_lin_new3];
    