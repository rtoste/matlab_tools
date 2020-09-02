addpath(genpath('/home/numa5/projetos/tools/matlab_toolbox/mexcdf_2013/'))

g ='/home/numa5/ROMS/Projects/dispersao_catedral/catedral_20m/grade/originais/catedral_grd_rev.nc';
a = '/home/numa5/ROMS/Projects/dispersao_catedral/catedral_20m/input/catedral_river_uv_W.nc';
n = 1; % numero de rios

x = 118; % posicao do rio em x
y = 60; % posicao do rio em y
d = 0; % direcao do rio (0 = na direcao u; 1 = na direcao v;)
N = 10; % numero de niveis verticais do modelo
v_N = zeros(1,N);v_N(N)=1;
% v_N = ones(1,N)*1/N; % distribuicao da vazao ao longo da coluna dagua (total = 1);
t = [244:1/24:248]; % instantes de tempo
nn = [1:n];
tt = length(t);

vaz = zeros(size(t)); vaz(3)=-0.5833;
% vaz = -[0 0.5833 0.5833 0 0]; % vazao ao longo do tempo
sal = zeros(1,N,tt);sal(1,10,3)=0;
tem = zeros(1,N,tt);tem(1,10,3)=25;
dye = zeros(1,N,tt);dye(1,10,3)=100;


nc_create_empty(a)

nccreate(a,'river','Dimensions',{'river' n})
ncwrite(a,'river',nn)
ncwriteatt(a,'river','long_name','river runoff identification number')
ncwriteatt(a,'river','units','nondimensional')
ncwriteatt(a,'river','field','river, scalar')

nccreate(a,'river_Xposition','Dimensions',{'river' n})
ncwrite(a,'river_Xposition',x)
ncwriteatt(a,'river_Xposition','long_name','river XI-position at RHO-points')
ncwriteatt(a,'river_Xposition','units','nondimensional')
ncwriteatt(a,'river_Xposition','field','river_Xposition, scalar')

nccreate(a,'river_Eposition','Dimensions',{'river' n})
ncwrite(a,'river_Eposition',y)
ncwriteatt(a,'river_Eposition','long_name','river ETA-position at RHO-points')
ncwriteatt(a,'river_Eposition','units','nondimensional')
ncwriteatt(a,'river_Eposition','field','river_Eposition, scalar')

nccreate(a,'river_direction','Dimensions',{'river' n})
ncwrite(a,'river_direction',d)
ncwriteatt(a,'river_direction','long_name','river runoff direction')
ncwriteatt(a,'river_direction','units','nondimensional')
ncwriteatt(a,'river_direction','field','river_direction, scalar')

nccreate(a,'river_Vshape','Dimensions',{'river' n 's_rho' N})
ncwrite(a,'river_Vshape',v_N)
ncwriteatt(a,'river_Vshape','long_name','river runoff mass transport vertical profile')
ncwriteatt(a,'river_Vshape','units','nondimensional')
ncwriteatt(a,'river_Vshape','field','river_Vshape, scalar')

nccreate(a,'river_time','Dimensions',{'time' tt})
ncwrite(a,'river_time',t)
ncwriteatt(a,'river_time','long_name','river runoff time')
ncwriteatt(a,'river_time','units','days since 2016-01-01 00:00:00')
ncwriteatt(a,'river_time','field','river_time, scalar, series')

nccreate(a,'river_transport','Dimensions',{'river' n 'time' tt})
ncwrite(a,'river_transport',vaz)
ncwriteatt(a,'river_transport','long_name','river runoff vertically integrated mass transport')
ncwriteatt(a,'river_transport','units','meter3 second-1')
ncwriteatt(a,'river_transport','field','river_transport, scalar, series')
ncwriteatt(a,'river_transport','time','river_time')

nccreate(a,'river_salt','Dimensions',{'river' n 's_rho' N 'time' tt})
ncwrite(a,'river_salt',sal)
ncwriteatt(a,'river_salt','long_name','river runoff salinity')
ncwriteatt(a,'river_salt','units','PSU')
ncwriteatt(a,'river_salt','field','river_salt, scalar, series')
ncwriteatt(a,'river_salt','time','river_time')

nccreate(a,'river_temp','Dimensions',{'river' n 's_rho' N 'time' tt})
ncwrite(a,'river_temp',tem)
ncwriteatt(a,'river_temp','long_name','river runoff temperature')
ncwriteatt(a,'river_temp','units','Celsius')
ncwriteatt(a,'river_temp','field','river_temp, scalar, series')
ncwriteatt(a,'river_temp','time','river_time')

nccreate(a,'river_dye_01','Dimensions',{'river' n 's_rho' N 'time' tt})
ncwrite(a,'river_dye_01',dye)
ncwriteatt(a,'river_dye_01','long_name','river runoff dye concentration')
ncwriteatt(a,'river_dye_01','units','nondimensional')
ncwriteatt(a,'river_dye_01','field','river_dye, scalar, series')
ncwriteatt(a,'river_dye_01','time','river_time')


addpath(genpath('/home/numa5/projetos/tools/Roms_tools/mexcdf/'))
map_rivers(g,a)





