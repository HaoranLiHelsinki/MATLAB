function [Radar, header] = Reading_HYDRA_W_data(pname, stDate, enDate, fname)

%%% Reading W-band radar  LVL1 data version 3.5
%%% [Radar] = Reading_HYDRA_W_data(pname, stDate, enDate, fname)
%%% pname - path to the data files
%%% stDate and enDate are starting and end dates of the event in the
%%% Matlab datenum format
%%% fname - something like '180319*.LV1'

flist  = dir(fullfile(pname, fname));
count = 0;

for findx = 1:length(flist)
    
    filename        = flist(findx,1).name;
    
    FileTime = datenum(['20', filename(1:2), '-', filename(3:4),'-',...
                            filename(5:6), ' ', filename(8:9),':',...
                            filename(10:11), ':', filename(12:13)]);
                        
    if FileTime>=stDate && FileTime<=enDate
        
        [header, offset] = reading_Wband_header([pname,filename]);
        [data]           = reading_Wband_data([pname,filename], header, offset);

        header.MSL = 181; % height above the mean sea level. [m]
        
        if count == 0
            Radar.ObsTime     = data.ObsTime;
            
            Radar.R           = header.RAlts;
            Radar.Ze          = double(data.Zv);
            Radar.LDR         = double(data.LDR);
            Radar.CorrC       = double(data.CorrC);
            Radar.PhiX        = double(data.PhiX);
            Radar.SW          = double(data.SW);
            Radar.Skew        = double(data.Skew);
            Radar.Kurt        = double(data.Kurt);
            Radar.V           = double(data.Vel);
            
            
            Radar.LWP         = double(data.LWP);
            Radar.T           = double(data.T);
            Radar.RH          = double(data.RH);
            Radar.TransPow    = double(data.TransPow);
            
            %------------ Added by Haoran Li
            Radar.RR           = data.RR;
            Radar.QF           = data.QF;
            Radar.P           = data.P;
            Radar.WS          = data.WS;
            Radar.WD          = data.WD;
            Radar.DD_V        = data.DD_V; 
            Radar.Tb          = data.Tb;
            Radar.PowIF       = data.PowIF;
            Radar.El          = data.El  ;
            Radar.Az          =  data.Az; 
            Radar.BlwStatus   = data.BlwStatus; 
            Radar.TransT      = data.TransT     ;
            Radar.RecT        = data.RecT  ;
            Radar.PCT         = data.PCT  ;
             
            %------------                  
            
            Radar.name        = 'HYDRA-W';
            
            count = count + 1;
        else
            
            Radar.ObsTime     = cat(2, Radar.ObsTime,  data.ObsTime); 
            Radar.LWP         = cat(2, Radar.LWP,      data.LWP); 
            Radar.T           = cat(2, Radar.T,        data.T); 
            Radar.RH          = cat(2, Radar.RH,       data.RH); 
            Radar.TransPow    = cat(2, Radar.TransPow, data.TransPow); 
            
             %------------ Added by Haoran Li
            Radar.RR           = cat(2, Radar.RR,  data.RR);  
            Radar.QF           = cat(2, Radar.QF,  data.QF);  
            Radar.P           = cat(2, Radar.P,  data.P);  
            Radar.WS          = cat(2, Radar.WS,  data.WS);  
            Radar.WD          = cat(2, Radar.WD,  data.WD);  
            Radar.DD_V        = cat(2, Radar.DD_V,  data.DD_V);  
            Radar.Tb          = cat(2, Radar.Tb,  data.Tb);  
            Radar.PowIF       = cat(2, Radar.PowIF,  data.PowIF);  
            Radar.El          = cat(2, Radar.EI,  data.EI);  
            Radar.Az          =  cat(2, Radar.Az,  data.Az);  
            Radar.BlwStatus   = cat(2, Radar.BlwStatus,  data.BlwStatus);  
            Radar.TransT      = cat(2, Radar.TransT,  data.TransT);  
            Radar.RecT        = cat(2, Radar.RecT,  data.RecT);  
            Radar.PCT         = cat(2, Radar.PCT,  data.PCT);  
            
            %------------                  
            
            Radar.Ze          = cat(1, Radar.Ze,      double(data.Zv));
            Radar.V           = cat(1, Radar.V,       double(data.Vel));
            Radar.LDR         = cat(1, Radar.LDR,     double(data.LDR));
            Radar.CorrC       = cat(1, Radar.CorrC,   double(data.CorrC));
            Radar.PhiX        = cat(1, Radar.PhiX,    double(data.PhiX));
            Radar.SW          = cat(1, Radar.SW,      double(data.SW));
            
            Radar.Skew        = cat(1, Radar.Skew,    double(data.Skew));
            Radar.Kurt        = cat(1, Radar.Kurt,    double(data.Kurt)); 
            count = count + 1;
            
        end
        
    end
    
end

