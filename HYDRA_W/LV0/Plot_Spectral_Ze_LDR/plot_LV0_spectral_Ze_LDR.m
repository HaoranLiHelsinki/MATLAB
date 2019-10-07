function  plot_LV0_spectral_Ze_LDR(data_correct , range, specN,  range_offsets,ylim_range,xlim_range);
 
% ylim_range = [0 3000];
% xlim_range = [-10 0.5];
ze_range = [-40 15];
ldr_range = [-30 -10];

y_tick_num = [0:100:20000];
x_tick_num = [-20:1:20];


close all

figure

set(gcf, 'Position' , [20 20 1000 600] )

h1 = subplot(1 ,2, 1)
Num_chirp = 1 ;% chirp 1
pcolor( data_correct.v1 , range(range_offsets(Num_chirp)+1:range_offsets(Num_chirp+1) ) , ...
    data_correct.current_spec_V_db(range_offsets(Num_chirp)+1:range_offsets(Num_chirp+1),:) )
hold on
Num_chirp = 2 ;% chirp 2
pcolor( data_correct.v2 , range(range_offsets(Num_chirp)+1:range_offsets(Num_chirp+1) ) , ...
    data_correct.current_spec_V_db(range_offsets(Num_chirp)+1:range_offsets(Num_chirp+1), 1:specN(Num_chirp) ) )
hold on
Num_chirp = 3 ;% chirp 3
pcolor( data_correct.v3 , range( range_offsets(Num_chirp)+1: length(range) ) , ...
    data_correct.current_spec_V_db( range_offsets(Num_chirp)+1: length(range) ,1:specN(Num_chirp)))
hold on
shading flat
grid on
caxis(ze_range)
ylim([ylim_range])
xlim([xlim_range])

yticks(y_tick_num)
xticks(x_tick_num)

ylabel('Height [m]')
xlabel('Velocity [m/s]')

colormap(jet(15))
cb = colorbar;
ylabel(cb , 'Spectral Ze [dB]')
title( datestr(data_correct.time ,'yyyymmdd-HHMMSS' ) )

set(gca,'FontSize' , 13)



h2 = subplot(1 ,2, 2)
Num_chirp = 1 ;% chirp 1
pcolor( data_correct.v1 , range(range_offsets(Num_chirp)+1:range_offsets(Num_chirp+1) ) , ...
    data_correct.current_spec_ldr(range_offsets(Num_chirp)+1:range_offsets(Num_chirp+1),:) )
hold on
Num_chirp = 2 ;% chirp 2
pcolor( data_correct.v2 , range(range_offsets(Num_chirp)+1:range_offsets(Num_chirp+1) ) , ...
    data_correct.current_spec_ldr(range_offsets(Num_chirp)+1:range_offsets(Num_chirp+1), 1:specN(Num_chirp) ) )
hold on
Num_chirp = 3 ;% chirp 3
pcolor( data_correct.v3 , range( range_offsets(Num_chirp)+1: length(range) ) , ...
    data_correct.current_spec_ldr( range_offsets(Num_chirp)+1: length(range) ,1:specN(Num_chirp)))
hold on
shading flat
grid on
caxis(ldr_range)
ylim([ylim_range])
xlim([xlim_range])

yticklabels([])

yticks(y_tick_num)
xticks(x_tick_num)

xlabel('Velocity [m/s]')

colormap(jet(15))
cb = colorbar;
ylabel(cb , 'Spectral LDR [dB]')
title( datestr(data_correct.time ,'yyyymmdd-HHMMSS' ) )

set(gca,'FontSize' , 13)


%----------------- compact plot
p1 = get(h1,'Position');
p2 = get(h2,'Position');
p1(1) = 0.07 ; 
p2(1)= 0.54;

p1(3) = 0.36;
p2(3) = p1(3);


set(h1,'Position',p1)
set(h2,'Position',p2)

