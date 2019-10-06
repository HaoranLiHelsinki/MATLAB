 function write_W_LV1_2_nc(data , header ,outfile, config)
 

% netcdf.close(ncid);

% this function writes joyrad94 data into netcdf4

%% ################## Create a netCDF file.

ncid = netcdf.create(outfile,'NETCDF4'); 


%% ################# Define dimensions

%did_time = netcdf.defDim(ncid,'time',data.totsamp);
%Changed by J.A. Bravo-Aranda
did_time = netcdf.defDim(ncid,'time', length(data.ObsTime) );
did_range = netcdf.defDim(ncid,'range', header.NumbGates);
did_no_seq = netcdf.defDim(ncid,'chirp_sequences', header.SequN);
did_scalar = netcdf.defDim(ncid,'scalar', 1 );


%% ################ get variable ids and add attributes

%%%%%%%%%% scalar variables

% id_AntiAlias = netcdf.defVar(ncid,'AntiAlias','nc_byte',did_scalar);
% netcdf.putAtt(ncid,id_AntiAlias,'long_name','Flag for dealiasing.');
% netcdf.putAtt(ncid,id_AntiAlias,'comment',...
%     '0 = no dealiasing applied, 1 = dealiasing by RPG, 2 = dealiasing in process_joyrad94_data.m');

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


id_Ze = netcdf.defVar(ncid,'Ze','nc_float',[did_range,did_time]);
netcdf.putAtt(ncid,id_Ze,'long_name','Equivalent radar reflectivity factor Ze');
netcdf.putAtt(ncid,id_Ze,'units','mm^6/m^3');

if isfield(data, 'Ze_label') % Ze corrected, adding note
    netcdf.putAtt(ncid,id_Ze,'comment',data.Ze_label);
    netcdf.putAtt(ncid,id_Ze,'corretion_dB',data.Ze_corr);
end

id_vm = netcdf.defVar(ncid,'V','nc_float',[did_range,did_time]);
netcdf.putAtt(ncid,id_vm,'long_name','Mean Doppler velocity');
netcdf.putAtt(ncid,id_vm,'units','m/s');
netcdf.putAtt(ncid,id_vm,'comment','negative values indicate falling particles towards the radar')

id_SW = netcdf.defVar(ncid,'SW','nc_float',[did_range,did_time]);
netcdf.putAtt(ncid,id_SW,'long_name','Spectral width of Doppler velocity spectrum');
netcdf.putAtt(ncid,id_SW,'units','m/s');

id_skew = netcdf.defVar(ncid,'skew','nc_float',[did_range,did_time]);
netcdf.putAtt(ncid,id_skew,'long_name','Skewness');

% id_QualFlag = netcdf.defVar(ncid,'QualityFlag','nc_float',[did_range,did_time]);
% netcdf.putAtt(ncid,id_QualFlag,'long_name','Quality flag, added in the additional data processing to alert for known issues');
% netcdf.putAtt(ncid,id_QualFlag,'comment', ...
%     ['This variable contains information on anything that might impact the quality ', ...
%     'of the data at each pixel. Must be converted into three bit binary string. ', ...
% 	'If 0, i.e. dec2bin(QualityFlag,3) = 000, none of the included issues were ', ...
%     'found. The definitions of each bit are given in the definition attribute.']);
% netcdf.putAtt(ncid,id_QualFlag,'definition', ...
%     ['If 2^0 bit is 1: this range gate is known to have aritifical spikes occurring', ...
%      'If 2^1 bit is 1: aircraft or other known flying non-meteorological object', ...
%      'If 2^2 bit is 1: wet-radome (was a problem for mirac-a for a time period when coating missing)' ...
%      ]);

id_Kurt = netcdf.defVar(ncid,'Kurt','nc_byte',[did_range,did_time]);
netcdf.putAtt(ncid,id_Kurt,'long_name','Kurtosis');

id_LDR = netcdf.defVar(ncid,'LDR','nc_float',[did_range,did_time]);
netcdf.putAtt(ncid,id_LDR,'long_name','Linear depolarization ratio');

if header.DualPol == 2
    id_xcorr = netcdf.defVar(ncid,'xcorr','nc_float',[did_range,did_time]);
    netcdf.putAtt(ncid,id_xcorr,'long_name','co-cross-channel correlation coefficient');

    id_difphase = netcdf.defVar(ncid,'difphase','nc_float',[did_range,did_time]);
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
netcdf.defVarDeflate(ncid,id_Ze,true,true,9);
netcdf.defVarDeflate(ncid,id_vm,true,true,9);
netcdf.defVarDeflate(ncid,id_SW,true,true,9);
netcdf.defVarDeflate(ncid,id_skew,true,true,9);
% netcdf.defVarDeflate(ncid,id_QualFlag,true,true,9);
netcdf.defVarDeflate(ncid,id_Kurt,true,true,9);

if header.DualPol > 0
    netcdf.defVarDeflate(ncid,id_LDR,true,true,9); %JABA    
end 
    
if header.DualPol == 2
    netcdf.defVarDeflate(ncid,id_difphase,true,true,9); %JABA    
    netcdf.defVarDeflate(ncid,id_xcorr,true,true,9); %JABA  
end

netcdf.endDef(ncid);


%% ####################### put variables into file

% scalars
% netcdf.putVar(ncid,id_AntiAlias,0,header.AntiAlias);
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
netcdf.putVar(ncid,id_time,0,length(data.ObsTime),data.ObsTime);
netcdf.putVar(ncid,id_RR,0,length(data.ObsTime),data.RR);
netcdf.putVar(ncid,id_rh,0,length(data.ObsTime),data.RH);
netcdf.putVar(ncid,id_T,0,length(data.ObsTime),data.T);
netcdf.putVar(ncid,id_P,0,length(data.ObsTime),data.P);
netcdf.putVar(ncid,id_WS,0,length(data.ObsTime),data.WS);
netcdf.putVar(ncid,id_WD,0,length(data.ObsTime),data.WD);
netcdf.putVar(ncid,id_Tb,0,length(data.ObsTime),data.Tb);
netcdf.putVar(ncid,id_LWP,0,length(data.ObsTime),data.LWP);
netcdf.putVar(ncid,id_status,0,length(data.ObsTime),data.BlwStatus);
netcdf.putVar(ncid,id_TransPow,0,length(data.ObsTime),data.TransPow);
netcdf.putVar(ncid,id_TransT,0,length(data.ObsTime),data.TransT);
netcdf.putVar(ncid,id_RecT,0,length(data.ObsTime),data.RecT);
netcdf.putVar(ncid,id_PCT,0,length(data.ObsTime),data.PCT);
netcdf.putVar(ncid,id_QF,0,length(data.ObsTime),data.QF);


% multidimensional variables
netcdf.putVar(ncid,id_Ze,[0,0],[header.NumbGates,length(data.ObsTime)],data.Ze');
netcdf.putVar(ncid,id_vm,[0,0],[header.NumbGates,length(data.ObsTime)],data.V');
netcdf.putVar(ncid,id_SW,[0,0],[header.NumbGates,length(data.ObsTime)],data.SW');
netcdf.putVar(ncid,id_skew,[0,0],[header.NumbGates,length(data.ObsTime)],data.Skew');
netcdf.putVar(ncid,id_Kurt,[0,0],[header.NumbGates,length(data.ObsTime)],data.Kurt');

if header.DualPol > 0    
    netcdf.putVar(ncid,id_LDR,[0,0],[header.NumbGates,length(data.ObsTime)],data.LDR'); %JABA
end

if header.DualPol == 2
    netcdf.putVar(ncid,id_xcorr,[0,0],[header.NumbGates,length(data.ObsTime)],data.xcorr'); %JABA
    netcdf.putVar(ncid,id_difphase,[0,0],[header.NumbGates,length(data.ObsTime)],data.difphase'); %JABA
    
end

netcdf.close(ncid);

% end
