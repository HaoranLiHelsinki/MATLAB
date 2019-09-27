% clc
% clear

% fname = '/home/lihaoran/data/W/spectra/2018/M02/D02/180202_060000_P01_ZEN.LV0';
% [header, offset] = reading_Wband_header(fname)

function [data] = reading_Wband_spectra(fname, header, offset)


BaseTime = datenum(2001,1,1, 0,0,0);
fid = fopen(fname, 'r');
fseek(fid,offset,'bof');

data.TotSamp = fread(fid,1,'int32');

%--------------------------------------------   Initiation
if header.CompEna == 0 

    data.spec(1:data.TotSamp, 1:header.NumbGates,1:max(header.SpecN)) = NaN; % spectra
    if header.DualPol > 0
        data.spec_hv(1:data.TotSamp, 1:header.NumbGates,1:max(header.SpecN)) = NaN; % spectra 
        data.spec_covRe(1:data.TotSamp, 1:header.NumbGates,1:max(header.SpecN)) = NaN; % spectra 
        data.spec_covIm(1:data.TotSamp, 1:header.NumbGates,1:max(header.SpecN)) = NaN; % spectra 
    end

else %  header.CompEna > 0 
  
        try
            data.spec(1:data.TotSamp, 1:header.NumbGates,1:max(header.SpecN)) = NaN;
        catch
             if feof(fid)
                endoffileerrormessage
                return
             end
        end

        if header.DualPol > 0
            try
                data.spec_hv(1:data.TotSamp, 1:header.NumbGates,1:max(header.SpecN)) = NaN;
                data.spec_covRe(1:data.TotSamp, 1:header.NumbGates,1:max(header.SpecN)) = NaN;
                data.spec_covIm(1:data.TotSamp, 1:header.NumbGates,1:max(header.SpecN)) = NaN;
            catch
                disp('nanwhat?')
                if feof(fid)
                    endoffileerrormessage
                    return
                end
            end

        end

        if header.CompEna == 2
            data.d_spec(1:data.TotSamp, 1:header.NumbGates,1:max(header.SpecN)) = NaN;
            data.CorrCoeff(1:data.TotSamp, 1:header.NumbGates,1:max(header.SpecN)) = NaN;
            data.DiffPh(1:data.TotSamp, 1:header.NumbGates,1:max(header.SpecN)) =  NaN;

            if header.DualPol == 2
                data.SLDR(1:data.TotSamp, 1:header.NumbGates,1:max(header.SpecN)) = NaN ;
                data.SCorrCoeff(1:data.TotSamp, 1:header.NumbGates,1:max(header.SpecN)) = NaN;
            end 
        end 

    if header.DualPol == 2 && header.CompEna == 2
        data.KDP(1:data.TotSamp, 1:header.NumbGates) = NaN;
        data.DiffAtt(1:data.TotSamp, 1:header.NumbGates) = NaN;
    end

    data.VNoisePow_mean(1:data.TotSamp, 1:header.NumbGates) = NaN;
    if header.DualPol > 0
        data.HNoisePow_mean(1:data.TotSamp, 1:header.NumbGates) = NaN;
    end

    if header.AntiAlias == 1
        data.Aliasmask(1:data.TotSamp, 1:header.NumbGates) = NaN;
        data.MinVel(1:data.TotSamp, 1:header.NumbGates) =NaN;
    end

end % header.CompEna == 0
        
        
        






%----------------------------------------------------------- Read data
for indx =  1: data.TotSamp
    if mod(indx,100) == 1
        fprintf('%s ', num2str(indx))
    end
    data.SampBytes(indx)   = fread(fid,1,'int32');
    offset1 = ftell(fid);
    Time                   = datenum(BaseTime + double(fread(fid,1,'uint32'))/(24*60*60));
    Time_usec              = double(fread(fid,1,'int32'));
    data.ObsTime(indx)     = Time + 1e-3*Time_usec/(24*60*60);
    data.QF(indx)          = fread(fid,1,'char');
    data.RR(indx)          = fread(fid,1,'float32');
    data.RH(indx)          = fread(fid,1,'float32');
    data.T(indx)           = fread(fid,1,'float32');
    data.P(indx)           = fread(fid,1,'float32'); 
    data.WS(indx)          = fread(fid,1,'float32');
    data.WD(indx)          = fread(fid,1,'float32');
    data.DD_V(indx)        = fread(fid,1,'float32');
    data.Tb(indx)          = fread(fid,1,'float32');
    data.LWP(indx)         = fread(fid,1,'float32');
    data.PowIF(indx)       = fread(fid,1,'float32');
    data.El(indx)          = fread(fid,1,'float32');
    data.Az(indx)          = fread(fid,1,'float32');
    data.BlwStatus(indx)   = fread(fid,1,'float32');
    data.TransPow(indx)    = fread(fid,1,'float32');
    data.TransT(indx)      = fread(fid,1,'float32');
    data.RecT(indx)        = fread(fid,1,'float32');
    data.PCT(indx)         = fread(fid,1,'float32');
    Res                    = fread(fid,3,'float32');
    
        
    if header.NumbLayersT>0
        data.T_Prof(indx,:)        = fread(fid,header.NumbLayersT,'float32');
        data.AbsHumid_Prof(indx,:) = fread(fid,header.NumbLayersH,'float32');
        data.RH_Prof(indx,:)       = fread(fid,header.NumbLayersH,'float32');
    end
    
    data.PNv(indx,1:header.NumbGates) = fread(fid,[1, header.NumbGates],'single');
    if header.DualPol > 0
        data.PNh(indx,1:header.NumbGates) = fread(fid,[1, header.NumbGates],'single');
    end
  
    data.Sensit_v(indx,:)      = fread(fid,header.NumbGates,'float32');
    if header.DualPol > 0
        data.Sensit_h(indx,:)      = fread(fid,header.NumbGates,'float32');
    end
    data.PrMsk(indx,:)         = fread(fid,header.NumbGates,'char');
    
    for indxR = 1 : header.NumbGates
                    
        chirp_idx = int32(find(header.RngOffs(2:end) - indxR +1 > 0,1,'first'));
        if isempty(chirp_idx) % then j is within last chirp
                chirp_idx = header.SequN;
        end
        
        if data.PrMsk(indx,indxR) == 1            
            
        data.SpecBytes(indx, indxR) =  fread(fid,1,'int32');
                        
                if header.CompEna == 0 

                    data.spec(indx, indxR,1:data.DoppLen(chirp_idx)) = fread(fid,[1,data.DoppLen(chirp_idx)],'single'); % spectra
                    if data.DualPol > 0
                        data.spec_hv(indx, indxR,1:data.DoppLen(chirp_idx)) = fread(fid,[1,data.DoppLen(chirp_idx)],'single'); % spectra 
                        data.spec_covRe(indx, indxR,1:data.DoppLen(chirp_idx)) = fread(fid,[1,data.DoppLen(chirp_idx)],'single'); % spectra 
                        data.spec_covIm(indx, indxR,1:data.DoppLen(chirp_idx)) = fread(fid,[1,data.DoppLen(chirp_idx)],'single'); % spectra 
                    end


                else %  data.CompEna > 0 

                    Nblocks = int16(fread(fid,1,'char*1')); % number of blocks in spectra
                    MinBkIdx = fread(fid,[1, Nblocks],'int16') +1; % minimum indexes of blocks
                    MaxBkIdx = fread(fid,[1, Nblocks],'int16') +1; % maximum indexes of blocks

%                     if max(MaxBkIdx) == 1024
%                         'asdfsdf'
%                     end
                    
                    for jj = 1 : Nblocks
                %         try
                            data.spec(indx, indxR, MinBkIdx(jj):MaxBkIdx(jj)) = fread(fid,[1,MaxBkIdx(jj)-MinBkIdx(jj)+1],'single');
                               
%                             if indx ==50 &&  indxR ==37 
%                                    a = MaxBkIdx ;
%                                    b = MinBkIdx;
%                             end
                
                            %         catch
                %              if feof(fid)
                %                 endoffileerrormessage
                %                 return
                %              end
                %         end
                    end
                    if header.DualPol > 0
                        for jj = 1: Nblocks
                            data.spec_hv(indx, indxR,MinBkIdx(jj):MaxBkIdx(jj)) = fread(fid,[1,MaxBkIdx(jj)-MinBkIdx(jj)+1],'single');
                        end
                        for jj = 1: Nblocks
                            data.spec_covRe(indx, indxR,MinBkIdx(jj):MaxBkIdx(jj)) = fread(fid,[1,MaxBkIdx(jj)-MinBkIdx(jj)+1],'single');
                        end
                        for jj = 1: Nblocks
                            data.spec_covIm(indx, indxR,MinBkIdx(jj):MaxBkIdx(jj)) = fread(fid,[1,MaxBkIdx(jj)-MinBkIdx(jj)+1],'single');
                        end
                    end
                        
                    
                    
                    
                    for jj = 1: Nblocks
                        

                        if header.CompEna == 2
                            data.d_spec(indx, indxR,MinBkIdx(jj):MaxBkIdx(jj)) = fread(fid,[1,MaxBkIdx(jj)-MinBkIdx(jj)+1],'single');
                            data.CorrCoeff(indx, indxR,MinBkIdx(jj):MaxBkIdx(jj)) = fread(fid,[1,MaxBkIdx(jj)-MinBkIdx(jj)+1],'single');
                            data.DiffPh(indx, indxR,MinBkIdx(jj):MaxBkIdx(jj)) = fread(fid,[1,MaxBkIdx(jj)-MinBkIdx(jj)+1],'single');

                            if data.DualPol == 2
                                data.SLDR(indx, indxR,MinBkIdx(jj):MaxBkIdx(jj)) = fread(fid,[1,MaxBkIdx(jj)-MinBkIdx(jj)+1],'single');
                                data.SCorrCoeff(indx, indxR,MinBkIdx(jj):MaxBkIdx(jj)) = fread(fid,[1,MaxBkIdx(jj)-MinBkIdx(jj)+1],'single');
                            end 
                        end

                    end % jj

                    if header.DualPol == 2 && header.CompEna == 2
                        % SLDR
                        %SCorrCoeff
                        data.KDP(indx, indxR) = fread(fid,1,'single');
                        data.DiffAtt(indx, indxR) = fread(fid,1,'single');
                    end

                    data.VNoisePow_mean(indx, indxR) = fread(fid,1,'single');
                    if header.DualPol > 0
                        data.HNoisePow_mean(indx, indxR) = fread(fid,1,'single');
                    end

                    if header.AntiAlias == 1
                        data.Aliasmask(indx, indxR) = int8(fread(fid,1,'char*1'));
                        data.MinVel(indx, indxR) = fread(fid,1,'single');
                    end

                end % header.CompEna == 0

 
              
        end
        
    end
    
%     offset2 = ftell(fid);
%     diff_offset =(offset2-offset1); % checking the actual sample size
%     
%     if (data.SampBytes(indx)-diff_offset) ~= 0
%         disp('Something is wrong. The sample size is not right.');
%         fread(fid,data.SampBytes(indx)-diff_offset, 'char');
%     end
    
end
fclose(fid);