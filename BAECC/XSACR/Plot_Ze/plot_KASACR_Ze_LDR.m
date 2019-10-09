    
function  plot_KASACR_Ze_LDR(data_kasacr)
 
ylim_range = [500 3000];
ze_range = [-20 30];
ldr_range = [-30 -10];

y_tick_num = [0:100:20000];
x_tick_num = fix(data_kasacr.time(1)) +[0:1/24/60*2:1];


close all
figure

set(gcf, 'Position' , [20 20 1400 600] )

h1 = subplot(1 ,2, 1);
pcolor( data_kasacr.time ,  data_kasacr.height,data_kasacr.ze )
shading flat
grid on
caxis(ze_range)
ylim([ylim_range])
xlim( [ data_kasacr.time(1) data_kasacr.time(end)] )

yticks(y_tick_num)
xticks(x_tick_num)

ylabel('Height [m]')
xlabel('Time [UTC]')
datetick('x' ,'MM' ,'keepticks' ,'keeplimits')

colormap(jet(15))
cb = colorbar;
ylabel(cb , 'Ze [dB]')

title(datestr(data_kasacr.time(1) ,'yyyymmdd-HHMMSS'))

set(gca,'FontSize' , 13)
set(gca,'TickDir','out')


h2 = subplot(1 ,2, 2);
pcolor( data_kasacr.time ,  data_kasacr.height,data_kasacr.ldr )
shading flat
grid on
caxis(ldr_range)
ylim([ylim_range])
xlim( [ data_kasacr.time(1) data_kasacr.time(end)] )

yticks(y_tick_num)
yticklabels([])
xticks(x_tick_num)

datetick('x' ,'MM' ,'keepticks' ,'keeplimits')
title(datestr(data_kasacr.time(1) ,'yyyymmdd-HHMMSS'))

xlabel('Time [UTC]')
colormap(jet(15))
cb = colorbar;
ylabel(cb , 'LDR [dB]')
set(gca,'FontSize' , 13)
set(gca,'TickDir','out')


%----------------- compact plot
p1 = get(h1,'Position');
p2 = get(h2,'Position');
p1(1) = 0.055 ; 
p2(1)= 0.53;

p1(3) = 0.4;
p2(3) = p1(3);


set(h1,'Position',p1)
set(h2,'Position',p2)

saveas(gcf, [datestr(data_kasacr.time(1) ,'yyyymmdd-HHMMSS') '.jpg'] )
close all
