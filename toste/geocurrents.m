function [u_g,v_g] = geocurrents(latG,SSH)

% This function takes the SSH field as input
% and returns Geostrophic currents. This implements safe
% equator-crossing calculations and safe f-plane calculations using a
% hybrid of the models of Pond and Pickard and Lagerloef et al.
%
% CALLING THE FUNCTION
% ====================
% 
% latG = latitude matrix in decimal degrees
% SSH  = sea surface height in metres
%===========================
% Raquel Toste - 2019-11-08
% Adapted from currents.m from ramzi.mirshak@noaa.gov
%===========================

% a = isnan(SSH);
% SSH2 = davefilt2(SSH,5,5,'median');
% SSH2(a) = NaN;
SSH2 = SSH;
%===========================
% Determind the SSH gradient
resol=latG(2,2)-latG(1,1);
i = sqrt(-1);
[FY, FX] = gradient(SSH2,resol,resol);
Z = FX + i * FY;

% convert dimensions of Z from cm/deg to m/m
% Z = Z * (1 deg / 111.1175 km) * (1 m / 100 cm)
Z = Z / (deg2km(1)*1000);

%==========================================================
%Use SSH gradient (Z) to determine the geostrophic currents

om = 7.29e-5; % angular frequency of earth's rotation [rad/s]
g = 9.8; 	  % gravitational acceleration [m/s^2]

f = 2 * om * sin(deg2rad(latG)); 		% f [rad/s]

beta = 2 * om/111000  * cos(deg2rad(latG)); % beta [1/m/s]

% coefficients a1 and b1 for f-plane and beta plane components of
% flow.
warning off % There is a divide by zero at the equator for f and at the poles for beta
a1 = (1 - exp(-(latG/2.2).^2)) .* (g ./ f);
a1(latG==0) = 0;

b1 = (exp(-(latG/2.2).^2)) .* (i * g ./ beta);
b1(beta==0) = 0;
warning on % The divide by zero is finished.

% Geostrophic Current :: f-plane and beta-plane


Uf =  i * a1 .* Z;
Ub = (b1(2:end,:)) .* (Z(2:end,:)-Z(1:end-1,:)) ...
    ./ (deg2km(resol)*1000);

% Ub(2:end,:) = Ub;
Ub(end+1,:) = 0;
u_g = -(real(Uf) + real(Ub));
v_g = -(imag(Uf) + imag(Ub));
return

