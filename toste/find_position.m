function [POSX, POSY] = find_position(lon_rho,lat_rho,lon,lat)
% [POSX,POSY] = find_position(lon_rho,lat_rho,lon,lat);
% lat_rho = matriz de latitude
% lon_rho = matriz de longitude
% lat = vetor ou valor de latitude a ser encontrado na matriz
% lon = vetor ou valor de longitude a ser encontrado na matriz

%
% Raquel Toste - 19/12/2017
% Modificado: 22/10/2018

minimo = zeros;
pos_y = zeros;

% Acha latitude  na matriz do modelo
for ii = 1: size(lat,1); 
    

    minimo(ii) = min(min(abs(lat_rho (:,:) - lat(ii))));
   

        [fi,fj] = find(lat_rho == (lat(ii) + minimo(ii)));


        if (isempty(fj)==0),

            pos_y(ii) = fj(1);

        elseif (isempty(fj)==1),

           [fi,fj] = find(lat_rho == (lat(ii) - minimo(ii)));
            pos_y(ii) = fj(1);

        end

 end


clear minimo i j fi fj

% Acha longitude na matriz do modelo


minimo = zeros;
pos_x = zeros;


for ii = 1: size(lon,1); 


    minimo(ii) = min(min(abs(lon_rho (:,1) - lon(ii))));


        [fi,fj] = find(lon_rho == (lon(ii) + minimo(ii)));


        if (isempty(fi)==0),

            pos_x(ii) = fi(1);

        elseif (isempty(fi)==1),

           [fi,fj] = find(lon_rho == (lon(ii) - minimo(ii)));
            pos_x(ii) = fi(1);

        end


end

        
clear fi fj 
clear minimo ii


POSX = pos_x(1,:);
POSY = pos_y(1,:);
return

     