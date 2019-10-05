function write_W_data_2_nc_LV0(data , header ,outfile, config)
% NOTE: this script is for LDR mode of Hyytiala W-band radar 

% netcdf.close(ncid);

% this function writes joyrad94 data into netcdf4

%% ################## Create a netCDF file.

ncid = netcdf.create(outfile,'NETCDF4'); 


%% ################# Define dimensions

%did_time = netcdf.defDim(ncid,'time',data.totsamp);
%Changed by J.A. Bravo-Aranda
did_time = netcdf.defDim(ncid,'time', data.TotSamp );
did_range = netcdf.defDim(ncid,'range', header.NumbGates);
did_no_seq = netcdf.defDim(ncid,'chirp_sequences', header.SequN);
did_scalar = netcdf.defDim(ncid,'scalar', 1 );
did_len_spec = netcdf.defDim(ncid,'len_spec', 1024 );

%% ################ get variable ids and add attributes

%%%%%%%%%% scalar variables

id_lat = netcdf.defVar(ncid,'Lat','nc_float',did_scalar);
netcdf.putAtt(ncid,id_lat,'long_name','Latitude in degrees north [-90,90]');
netcdf.putAtt(ncid,id_lat,'units','degrees');

id_lon = netcdf.defVar(ncid,'Lon','nc_float',did_scalar);
netcdf.putAtt(ncid,id_lon,'long_name','Longitude in degrees east [-180,180]');
netcdf.putAtt(ncid,id_lon,'units','degrees');

id_MSL = netcdf.defVar(ncid,'MSL','nc_float',did_scalar);
netcdf.putAtt(ncid,id_MSL,'long_name','Height above mean sea level');
netcdf.putAtt(ncid,id_MSL,'units','m');

id_freq = netcdf.defVar(ncid,'freq','nc_float',did_scalar);
netcdf.putAtt(ncid,id_freq,'long_name','Transmission frequency');
netcdf.putAtt(ncid,id_freq,'units','GHz');

%%%%%%% range variables
id_range = netcdf.defVar(ncid,'range','nc_float',did_range);
netcdf.putAtt(ncid,id_range,'long_name','Range from antenna to the center of each range gate');
netcdf.putAtt(ncid,id_range,'units','m');

%%%%%%%% chirp_seq_dependent variables

id_ChirpReps = netcdf.defVar(ncid,'ChirpReps','nc_int',did_no_seq);
netcdf.putAtt(ncid,id_ChirpReps,'long_name','Number of averaged chirps in each chirp sequence');

id_SeqIntTime = netcdf.defVar(ncid,'SeqIntTime','nc_float',did_no_seq);
netcdf.putAtt(ncid,id_SeqIntTime,'long_name','Integration time of each chirp sequence');
netcdf.putAtt(ncid,id_SeqIntTime,'units','seconds');

id_SpecN = netcdf.defVar(ncid,'SpecN','nc_int',did_no_seq);
netcdf.putAtt(ncid,id_SpecN,'long_name','Number of samples in Dopppler spectra of each chirp sequence. Needed to calculate the Doppler resolution: DoppRes = 2*DoppMax/SpecN');

id_maxVel = netcdf.defVar(ncid,'maxVel','nc_float',did_no_seq);
netcdf.putAtt(ncid,id_maxVel,'long_name','Max. unambigious Doppler velocity for each chirp sequence. Needed to calculate the Doppler resolution: DoppRes = 2*maxVel/SpecN');
netcdf.putAtt(ncid,id_maxVel,'units','m/s');

id_nAvg = netcdf.defVar(ncid,'nAvg','nc_int',did_no_seq);
netcdf.putAtt(ncid,id_nAvg,'long_name','Number of spectra averaged');
netcdf.putAtt(ncid,id_nAvg,'comment','nAvg = ChirpReps/SpecN')


id_range_offsets = netcdf.defVar(ncid,'range_offsets','nc_int',did_no_seq);
netcdf.putAtt(ncid,id_range_offsets,'long_name','Chirp sequence start index array in range array');
netcdf.putAtt(ncid,id_range_offsets,'comment',...
    'The command range(range_offsets) will give you the range where a new chirp sequence starts. range_offsets counts from 1 to n_levels.');

%%%%%%%% time dependend variables

id_time = netcdf.defVar(ncid,'time','nc_uint',did_time);
netcdf.putAtt(ncid,id_time,'long_name','Time in MATLAB format');
netcdf.putAtt(ncid,id_time,'units','seconds UTC');
netcdf.putAtt(ncid,id_time,'comment','Use datestr in MATLAB');

id_RR = netcdf.defVar(ncid,'RR','nc_float',did_time);
netcdf.putAtt(ncid,id_RR,'long_name','Rain rate of meteo-station');
netcdf.putAtt(ncid,id_RR,'units','mm/h');


id_rh = netcdf.defVar(ncid,'rh','nc_float',did_time);
netcdf.putAtt(ncid,id_rh,'long_name','Relative humidity of meteo-station');
netcdf.putAtt(ncid,id_rh,'units','%');

id_T = netcdf.defVar(ncid,'T','nc_float',did_time);
netcdf.putAtt(ncid,id_T,'long_name','Environmental temperature of meteo-station');
netcdf.putAtt(ncid,id_T,'units','K');

id_P= netcdf.defVar(ncid,'P','nc_float',did_time);
netcdf.putAtt(ncid,id_P,'long_name','Environmental pressure of meteo-station');
netcdf.putAtt(ncid,id_P,'units','hPa');

id_WS = netcdf.defVar(ncid,'WS','nc_float',did_time);
netcdf.putAtt(ncid,id_WS,'long_name','Wind speed of meteo-station');
netcdf.putAtt(ncid,id_WS,'units','km/h');

id_WD = netcdf.defVar(ncid,'WD','nc_float',did_time);
netcdf.putAtt(ncid,id_WD,'long_name','Wind direction of meteo-station');
netcdf.putAtt(ncid,id_WD,'units','degrees');

id_Tb = netcdf.defVar(ncid,'Tb','nc_float',did_time);
netcdf.putAtt(ncid,id_Tb,'long_name','brightness temperature direct detection channel');
netcdf.putAtt(ncid,id_Tb,'units','K');

id_LWP = netcdf.defVar(ncid,'LWP','nc_float',did_time);
netcdf.putAtt(ncid,id_LWP,'long_name','Liquid water path calculated by RPG software');
netcdf.putAtt(ncid,id_LWP,'units','g/m^2');

id_status = netcdf.defVar(ncid,'status','nc_float',did_time);
netcdf.putAtt(ncid,id_status,'long_name','status flag: 0/1 = heater on/off; 0/10 = blower on/off');

id_TransPow = netcdf.defVar(ncid,'TransPow','nc_float',did_time);
netcdf.putAtt(ncid,id_TransPow,'long_name','Transmitted power');
netcdf.putAtt(ncid,id_TransPow,'units','W');

id_TransT = netcdf.defVar(ncid,'TransT','nc_float',did_time);
netcdf.putAtt(ncid,id_TransT,'long_name','Transmitter temperature');
netcdf.putAtt(ncid,id_TransT,'units','K');

id_RecT = netcdf.defVar(ncid,'RecT','nc_float',did_time);
netcdf.putAtt(ncid,id_RecT,'long_name','Receiver temperature');
netcdf.putAtt(ncid,id_RecT,'units','K');

id_PCT = netcdf.defVar(ncid,'PCT','nc_float',did_time);
netcdf.putAtt(ncid,id_PCT,'long_name','PC temperature');
netcdf.putAtt(ncid,id_PCT,'units','K');

id_QF = netcdf.defVar(ncid,'QF','nc_byte',did_time);
netcdf.putAtt(ncid,id_QF,'long_name','Quality flag given by radar');
netcdf.putAtt(ncid,id_QF,'comment', ...
    ['To get the bit entries, one has to convert the integer into a 4 bit binary. '...
    'bit4 = ADC saturation, bit3 = spectral width too high, bit2 = no transmitter power leveling.' ...
    'Note that in the above convention holds: bit1 = 2^3, bit2 = 2^2, bit3 = 2^1, bit4 = 2^0'])




%%%%%%%% multi-D variables


id_AntiAlias = netcdf.defVar(ncid,'AntiAlias','nc_byte',[did_time,did_range]);
netcdf.putAtt(ncid,id_AntiAlias,'long_name','Flag for dealiasing.');
netcdf.putAtt(ncid,id_AntiAlias,'comment',...
    '0 = no dealiasing applied, 1 = dealiasing by RPG, 2 = dealiasing in process_joyrad94_data.m');


id_spec_V = netcdf.defVar(ncid,'spec_V','nc_float',[did_time,did_range,did_len_spec]);
netcdf.putAtt(ncid,id_spec_V,'long_name','Spectrum');
netcdf.putAtt(ncid,id_spec_V,'units','Vertical pol. Doppler spectrum (incl. noise), mm^6/m^3');

id_noise_V = netcdf.defVar(ncid,'noise_V','nc_float',[did_time,did_range]);
netcdf.putAtt(ncid,id_noise_V,'long_name','Spectrum');
netcdf.putAtt(ncid,id_noise_V,'units','Integrated noise of full spectrum at vertical pol. , mm^6/m^3');

if header.DualPol ==1
    id_spec_HV = netcdf.defVar(ncid,'spec_HV','nc_float',[did_time,did_range,did_len_spec]);
    netcdf.putAtt(ncid,id_spec_HV,'long_name','Spectrum');
    netcdf.putAtt(ncid,id_spec_HV,'units','Horizontal pol. Doppler spectrum (incl. noise), mm^6/m^3');

    id_noise_HV = netcdf.defVar(ncid,'noise_HV','nc_float',[did_time,did_range]);
    netcdf.putAtt(ncid,id_noise_HV,'long_name','Spectrum');
    netcdf.putAtt(ncid,id_noise_HV,'units','Integrated noise of full spectrum at horizontal pol. , mm^6/m^3');
end

id_Vmin = netcdf.defVar(ncid,'v_shift','nc_float',[did_time,did_range]);
netcdf.putAtt(ncid,id_Vmin,'long_name','Minimum velocity in spectrum.');
netcdf.putAtt(ncid,id_Vmin,'units','m/s');
netcdf.putAtt(ncid,id_Vmin,'comment','Indicates how minimum velocity changes when Aliasmask == 1')


id_QualFlag = netcdf.defVar(ncid,'QualityFlag','nc_float',[did_time,did_range]);
netcdf.putAtt(ncid,id_QualFlag,'long_name','Quality flag, added in the additional data processing to alert for known issues');
netcdf.putAtt(ncid,id_QualFlag,'comment', ...
    ['This variable contains information on anything that might impact the quality ', ...
    'of the data at each pixel. Must be converted into three bit binary string. ', ...
	'If 0, i.e. dec2bin(QualityFlag,3) = 000, none of the included issues were ', ...
    'found. The definitions of each bit are given in the definition attribute.']);
netcdf.putAtt(ncid,id_QualFlag,'definition', ...
    ['If 2^0 bit is 1: this range gate is known to have aritifical spikes occurring', ...
     'If 2^1 bit is 1: aircraft or other known flying non-meteorological object', ...
     'If 2^2 bit is 1: wet-radome (was a problem for mirac-a for a time period when coating missing)' ...
     ]);

id_Aliasmask = netcdf.defVar(ncid,'AliasMask','nc_byte',[did_time,did_range]);
netcdf.putAtt(ncid,id_Aliasmask,'long_name','Mask array indicating in which bin dealiasing was applied. If AnitAlias = 1, then dealiasing was applied by RPG software: 0 = not applied; 1 = applied; If AntiAlias = 2, then dealiasing was applied in post-processing: 0 = no aliasing detected, 1 = aliasing detected; if any bin equals 1 (while AntiAlias = 2) then the full column was dealiased.');
 

if header.DualPol == 2
    id_xcorr = netcdf.defVar(ncid,'xcorr','nc_float',[did_time,did_range]);
    netcdf.putAtt(ncid,id_xcorr,'long_name','co-cross-channel correlation coefficient');

    id_difphase = netcdf.defVar(ncid,'difphase','nc_float',[did_time,did_range]);
    netcdf.putAtt(ncid,id_difphase,'long_name','co-cross-channel differential phase');
    
end

%% ######################## add global attributes
glob = netcdf.getConstant('NC_GLOBAL');
netcdf.putAtt(ncid,glob,'FillValue','NaN');
netcdf.putAtt(ncid,glob,'program_name', header.CGProg);
if header.ModelNo == 0
    model = '94 GHz single pol.';
else
    model = '94 GHz dual pol.';
end
netcdf.putAtt(ncid,glob,'model_type',model);
netcdf.putAtt(ncid,glob,'contact',config.contactperson);
netcdf.putAtt(ncid,glob,'processing script',config.processing_script);


%% ###################### initialize compression of all floats:
netcdf.defVarDeflate(ncid,id_RR,true,true,9);
netcdf.defVarDeflate(ncid,id_rh,true,true,9);
netcdf.defVarDeflate(ncid,id_T,true,true,9);
netcdf.defVarDeflate(ncid,id_P,true,true,9);
netcdf.defVarDeflate(ncid,id_WS,true,true,9);
netcdf.defVarDeflate(ncid,id_WD,true,true,9);
netcdf.defVarDeflate(ncid,id_Tb,true,true,9);
netcdf.defVarDeflate(ncid,id_LWP,true,true,9);
netcdf.defVarDeflate(ncid,id_status,true,true,9);
netcdf.defVarDeflate(ncid,id_TransPow,true,true,9);
netcdf.defVarDeflate(ncid,id_TransT,true,true,9);
netcdf.defVarDeflate(ncid,id_RecT,true,true,9);
netcdf.defVarDeflate(ncid,id_PCT,true,true,9);
netcdf.defVarDeflate(ncid,id_QF,true,true,9);
netcdf.defVarDeflate(ncid,id_spec_V,true,true,9);
netcdf.defVarDeflate(ncid,id_noise_V,true,true,9);
netcdf.defVarDeflate(ncid,id_Vmin,true,true,9);
% netcdf.defVarDeflate(ncid,id_sigma,true,true,9);
% netcdf.defVarDeflate(ncid,id_skew,true,true,9);
netcdf.defVarDeflate(ncid,id_QualFlag,true,true,9);
netcdf.defVarDeflate(ncid,id_Aliasmask,true,true,9);

if header.DualPol > 0
    netcdf.defVarDeflate(ncid,id_spec_HV,true,true,9);
    netcdf.defVarDeflate(ncid,id_noise_HV,true,true,9);
end 
    
% if header.DualPol == 2
%     netcdf.defVarDeflate(ncid,id_difphase,true,true,9); %JABA    
%     netcdf.defVarDeflate(ncid,id_xcorr,true,true,9); %JABA  
% end

netcdf.endDef(ncid);



%% ####################### put variables into file

% scalars
netcdf.putVar(ncid,id_freq,0,header.Freq);
netcdf.putVar(ncid,id_lon,0,header.GPSLong);
netcdf.putVar(ncid,id_lat,0,header.GPSLat);
netcdf.putVar(ncid,id_MSL,0,header.MSL);

% range dependet
netcdf.putVar(ncid,id_range,0,header.NumbGates, header.RAlts);


% chrip seq dependent variables
netcdf.putVar(ncid,id_range_offsets,0, header.SequN, header.RngOffs);
netcdf.putVar(ncid,id_ChirpReps,0,header.SequN,header.ChirpReps);
netcdf.putVar(ncid,id_SeqIntTime,0,header.SequN,header.SeqIntTime);
netcdf.putVar(ncid,id_maxVel,0,header.SequN,header.maxVel);
netcdf.putVar(ncid,id_SpecN,0,header.SequN,header.SpecN);
netcdf.putVar(ncid,id_nAvg,0,header.SequN,header.ChirpReps./header.SpecN);


% time dependent variables
netcdf.putVar(ncid,id_time,0,data.TotSamp,data.ObsTime);
netcdf.putVar(ncid,id_RR,0,data.TotSamp,data.RR);
netcdf.putVar(ncid,id_rh,0,data.TotSamp,data.RH);
netcdf.putVar(ncid,id_T,0,data.TotSamp,data.T);
netcdf.putVar(ncid,id_P,0,data.TotSamp,data.P);
netcdf.putVar(ncid,id_WS,0,data.TotSamp,data.WS);
netcdf.putVar(ncid,id_WD,0,data.TotSamp,data.WD);
netcdf.putVar(ncid,id_Tb,0,data.TotSamp,data.Tb);
netcdf.putVar(ncid,id_LWP,0,data.TotSamp,data.LWP);
netcdf.putVar(ncid,id_status,0,data.TotSamp,data.BlwStatus);
netcdf.putVar(ncid,id_TransPow,0,data.TotSamp,data.TransPow);
netcdf.putVar(ncid,id_TransT,0,data.TotSamp,data.TransT);
netcdf.putVar(ncid,id_RecT,0,data.TotSamp,data.RecT);
netcdf.putVar(ncid,id_PCT,0,data.TotSamp,data.PCT);
netcdf.putVar(ncid,id_QF,0,data.TotSamp,data.QF);

% multidimensional variables

netcdf.putVar(ncid,id_AntiAlias,[0,0],[data.TotSamp,header.NumbGates],data.Aliasmask);
netcdf.putVar(ncid,id_Vmin,[0,0],[data.TotSamp,header.NumbGates],data.MinVel);

netcdf.putVar(ncid,id_spec_V,[0,0,0],[data.TotSamp,header.NumbGates , 1024],data.spec);
netcdf.putVar(ncid,id_noise_V,[0,0],[data.TotSamp,header.NumbGates],data.VNoisePow_mean);

if header.DualPol > 0    
    netcdf.putVar(ncid,id_spec_HV,[0,0,0],[data.TotSamp,header.NumbGates, 1024],data.spec_hv);
    netcdf.putVar(ncid,id_noise_HV,[0,0],[data.TotSamp,header.NumbGates],data.HNoisePow_mean);
end
 
netcdf.close(ncid);

% end
