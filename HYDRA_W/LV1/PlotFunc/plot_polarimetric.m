function [hours] = plot_polarimetric( Radar )



figure(1)
set(gcf,'pos',[0 0 1400 700])
fontsizenum = 14;

Radar.LDR(Radar.Ze<-30)=nan;
Radar.V(isnan(Radar.LDR))=nan;

h1 = subplot(3,1,1); %----------------------- 1

imagesc(Radar.ObsTime, Radar.R , 10*log10(Radar.Ze'/10) );                           % ploting function 
caxis([-40 10])

axis xy
hours = 0:1/24:1;

xticknum = double( fix(Radar.ObsTime(1)) ) + hours;
set(gca,'xtick', xticknum)
datetick('x','HH','keepticks')

temp1 = colormap(gca,jet(21));                                                      % using colour map "jet"
temp1(1,:)=[1 1 1];
colormap(h1,temp1);

hc = colorbar;
clab1 = get(hc,'ylabel') ;                                                   % labeling the color bar
set(clab1,'String','Reflectivity [dB]', 'FontSize', fontsizenum) ;                                  % labeling the color bar
grid on                          % names the y-axis
ylabel('Height [m] ', 'FontSize',  fontsizenum) ;  

ylim([0 6000])

set(gca,'fontsize',fontsizenum)

hold on
yyaxis right
plot(Radar.ObsTime , (Radar.T-273), 'k' )





h2 = subplot(3,1,2);%----------------------- 2

imagesc(Radar.ObsTime, Radar.R , Radar.LDR') ;                           % ploting function 
caxis([-37 -10])

axis xy
hours = 0:1/24:1;

xticknum = double( fix(Radar.ObsTime(1)) ) + hours;
set(gca,'xtick', xticknum)
datetick('x','HH','keepticks')

temp = colormap(gca,jet(21));                                                      % using colour map "jet"
temp(1,:)=[1 1 1];
colormap(h2,temp);  

h = colorbar;
clab = get(h,'ylabel') ;                                                   % labeling the color bar
set(clab,'String','LDR [dB]', 'FontSize', fontsizenum) ;                                  % labeling the color bar
                          % names the y-axis
ylabel('Height [m] ', 'FontSize',  fontsizenum) ;  
grid on
ylim([0 6000])
set(gca,'fontsize',fontsizenum)





h3 = subplot(3,1,3);%----------------------- 3

imagesc(Radar.ObsTime, Radar.R , Radar.V') ;                           % ploting function 
caxis([-3.5 0.5])

axis xy
hours = 0:1/24:1;

xticknum = double( fix(Radar.ObsTime(1)) ) + hours;
set(gca,'xtick', xticknum)
datetick('x','HH','keepticks')

temp = colormap(gca ,hsv(21));                                                      % using colour map "jet"
temp(1,:)=[1 1 1];

h = colorbar;
clab = get(h,'ylabel') ;                                                   % labeling the color bar
set(clab,'String','V [m/s]', 'FontSize', fontsizenum) ;                                  % labeling the color bar
colormap(h3,temp);

xlabel('Time', 'FontSize',  fontsizenum) ;                                  % names the y-axis
ylabel('Height [m] ', 'FontSize',  fontsizenum) ;  
grid on
ylim([0 6000])

set(gca,'fontsize',fontsizenum)

p1 = get(h1,'Position');p1(4)=p1(4)*1.25;
p2 = get(h2,'Position');p2(4)=p2(4)*1.25;
p3 = get(h3,'Position');p3(4)=p3(4)*1.25;

p1(3) = p2(3);

p3(2) = p3(2) - 0.03;

p2(2) = p2(4) + p3(2)+0.04;
p1(2) = p1(4) + p2(2)+0.04;

set(h1,'Position',p1)
set(h2,'Position',p2)
set(h3,'Position',p3)

 