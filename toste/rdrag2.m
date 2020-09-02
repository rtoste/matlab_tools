%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Routine to compute quadratic bottom drag coefficient (rdrag2) to be used
% in ROMS
% It is based on Chezy coefficient.
% Roughness lengths (ep) are based on Abbot and Basco (1989).
% where:
% Sediment bed
%         - with sediment transport           from 0.007 to 0.050 (m)
%         - with vegetation                   from 0.050 to 0.150 (m)
%         - with obstacles (eg. rocks,trees)  from 0.150 to 0.400 (m)
% 
% ABBOT MB, BASCO R (1989) Computational Fluid Mechanics: An Introduction
% for Engeneering, Longman Group, UK Limited.
% 
% Raquel Toste - 29 September 2016
% rtoste@gmail.com
%         
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear,clc
addpath(genpath('/home/numa5/Documents/MATLAB/toste'))
% Input files ---------------------------------------------------------------
grd = '/home/numa5/ROMS/Projects/bg_exp1_m1/grade/bg_grd_m1.nc';
cst = '/home/numa5/ROMS/Projects/rio_exp1_r2/grade/originais/COSTA_BG_elisa.mat';
% -------------------------------------------------------------------------
% User definitions
% Specify regions
reg1 = 5; % lower limit for sand 
reg2 = 0; % lower limit for mud
reg3 = 0.4; % limit for soft vegetation
reg4 = 0.5; % minimal depth of tidal and river channels

load(cst)

h = ncread(grd,'h'); % bathymetry
lonr = ncread(grd,'lon_rho'); 
latr = ncread(grd,'lat_rho'); 
g = 9.8; % m/s^2


% Define if points are over land  -----------------------------------------

inland = inpolygon(lonr,latr,lon,lat);

% Define ep
ep = nan(size(h));

for ii = 1:size(ep,1)
    for jj = 1:size(ep,2)
        
        if      (h(ii,jj)>=reg1 & inland(ii,jj)==0)
            ep(ii,jj) = 0.03;
        elseif  (h(ii,jj)<reg1 & h(ii,jj)>=reg2 & inland(ii,jj)==0)
            ep(ii,jj) = 0.015;
        elseif  (h(ii,jj)<reg2 & inland(ii,jj)==0)
            ep(ii,jj) = 0.4;    
        elseif  (h(ii,jj)>=reg4 & inland(ii,jj)==1)
            ep(ii,jj) = 0.02;
        elseif  (h(ii,jj)>=reg3 & h(ii,jj)<reg4 & inland(ii,jj)==1)
            ep(ii,jj) = 0.1;
        elseif  (h(ii,jj)<reg3 & inland(ii,jj)==1)
            ep(ii,jj) = 0.3;
        end
    end
end

figure,pcolor(ep'),shading flat,colorbar

clear reg* l* ii jj
% If there are negative values corresponding to topography, modify the
% bathymetry to 0.1 m
idx = h<=0.1;
h(idx) = 0.1;
clear idx

% Chezy coefficient
cff=18*log((6*h)./ep);

% Drag coefficient
rdrag=g./(cff.*cff);

figure,pcolor(rdrag'),shading flat,colorbar

nccreate(grd,'rdrag2','Dimensions',{'xi_rho' size(rdrag,1) 'eta_rho' size(rdrag,2)})
ncwrite(grd,'rdrag2',rdrag)
ncwriteatt(grd,'rdrag2','long_name','quadratic bottom drag coefficient')
ncwriteatt(grd,'rdrag2','coordinates','lon_rho lat_rho')       