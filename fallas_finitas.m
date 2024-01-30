filename = ('finite_fault_will.txt');
delimiterIn = ' ';
headerlinesIn = 1;
datos=importdata(filename,delimiterIn,headerlinesIn);

ff_will=datos.data;

lat_will=ff_will(:,2);
lon_will=ff_will(:,3);
dep_will=ff_will(:,4);
dip_will=ff_will(:,5);
str_will=ff_will(:,6);
rak_will=ff_will(:,7);
sli_will=ff_will(:,8);
%{
ff_neic=load('finite_fault_neic.txt');
lat_neic=ff_neic(:,1);
lon_neic=ff_neic(:,2);
dep_neic=ff_neic(:,3);
sli_neic=ff_neic(:,4);
rak_neic=ff_neic(:,5);
str_neic=ff_neic(:,6);
tru_neic=ff_neic(:,7);
tri_neic=ff_neic(:,8);
tfa_neic=ff_neic(:,9);
mo_neic=ff_neic(:,10);
%}

n_will=length(ff_will(:,1));
%n_neic=length(ff_neic(:,1));

lat2_will=zeros(n_will);
lon2_will=zeros(n_will);
dep2_will=zeros(n_will);
L_will= 25000;
W_will= 25000;

%{
lat2_neic=zeros(n_neic);
lon2_neic=zeros(n_neic);
dep2_will=zeros(n_neic);
L_will= 0.12;
W_will= 0.08;
%}

lon0= -73.674;
lat0= -31.573;
ff2_will=ff_will;
vecE=zeros(n_will);
vecN=zeros(n_will);
xs=zeros(n_will,1);
for i = 1:n_will
    [x,y]=geo_to_utm(lon_will(i),lat_will(i),lon0,lat0);
    xs(i)=x;
    z=dep_will(i)*1000;
    strike=str_will(i)*pi/180;
    dip=dip_will(i)*pi/180;
    L=L_will;
    W=W_will;
    dy=L/2.*cos(dip).*sin(strike) - W/2.*cos(strike);
    dx=-L/2.*cos(dip).*cos(strike) - W/2.*sin(strike);
    dz=-L/2.*sin(dip);
    x_new=x+dx;
    y_new=y+dy;
    z_new=(z+dz)/1000;
    [lon_new,lat_new]=utm_to_geo(x_new,y_new,lon0,lat0);
    vecE(i)=lon_will(i)-lon_new;
    vecN(i)=lat_will(i)-lat_new;
    ff2_will(i,2)=lat_new;
    ff2_will(i,3)=lon_new;
    ff2_will(i,4)=z_new;
end


figure(1)
hold on
plot(ff_will(:,3),ff_will(:,2),'.b',ff2_will(:,3),ff2_will(:,2),'.r')
%plot(ff2_will(:,3),ff2_will(:,2),'.b')
legend('Puntos centro', 'Puntos esquina')
hold off




%{
for j in 1:n_neic:
    strike=str_neic(j);
    dip=dip_neic(j);
    L=L_neic;
    W=W_neic;
    dx=L/2.*sin(dip).*sin(strike) - W/2.*cos(strike);
    dy=L/2.*sin(dip).*cos(strike) - W/2.*sin(strike);
    dz=L/2.*cos(dip);
    lat2_neic(j)=lat_neic(j)+dx;
    lon2_neic(j)=lat_neic(j)+dy;
    dep2_neic(j)=lat_neic(j)+dz;
end



ff2=fopen('finite_fault_will2.txt','w');
fprintf(ff2,ff2_will);
fclose(ff2);
type finite_fault_will2.txt
%}