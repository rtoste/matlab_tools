clear, close all
addpath(genpath('/home/numa5/projetos/tools/Roms_tools/Preprocessing_tools/'))

Gname = '/home/numa5/ROMS/Projects/rio_exp1_r2/grade/originais/r2_grd_REV.nc';
Gout  = '/home/numa5/ROMS/Projects/rio_exp1_r2/grade/r2_grd_REV1.nc';

rfactor = 0.75;

copyfile(Gname,Gout)
h = ncread(Gname,'h');
hh = h;
hmax = 60;%ceil(max(max(h)));
hmin = 0.1;%(min(min(h)));
hmax_costa=0.1;%(min(min(h)));

figure
pcolor(h'),colorbar,shading flat
caxis([hmin hmax])

h(h>hmax)=hmax;
h(h<hmin)=hmin;

mask_rho = ncread(Gname,'mask_rho');

h=smoothgrid(h,mask_rho,hmin,hmax_costa,hmax,rfactor,1,10);

figure
pcolor(h'),colorbar,shading flat
caxis([hmin hmax])

figure
pcolor((abs(hh-h))'),colorbar,shading flat

%
%  Write it down
%
disp(' ')
disp(' Write it down...')

h = h;
ncwrite(Gout,'h',h);

rmpath(genpath('/home/numa5/projetos/tools/Roms_tools/Preprocessing_tools/'))