function [POSX, POSY, TINDEX] = euleriano2lagrange(lat_rho,lon_rho,lat,lon,time_ref,time_mod,time_uni,periodo)
% [POSX,POSY,TINDEX] = EULERIANO2LAGRANGE(lat_rho,lon_rho,lat,lon,time_ref,time_mod,time_uni,periodo);
% lat_rho = matriz de latitude
% lon_rho = matriz de longitude
% lat = vetor ou valor de latitude a ser encontrado na matriz
% lon = vetor ou valor de longitude a ser encontrado na matriz
% time_ref = tempo de referencia do modelo (string)
% time_mod = vetor ou valor de tempo do modelo
% time_uni = unidade de tempo do time_mod(string: 's','m' ou 'd')
% periodo = tempo para ser buscado no tempo do modelo (string)
%
% Raquel Toste - 15/07/2015

minimo = zeros;
pos_y = zeros;

% Acha latitude do trajeto na matriz do modelo
for ii = 1: size(lat,1); 


    minimo(ii) = min(min(abs(lat_rho (1,:) - lat(ii))));
   

        [fi,fj] = find(lat_rho == (lat(ii) + minimo(ii)));


        if (isempty(fj)==0),

            pos_y(ii) = fj(1);

        elseif (isempty(fj)==1),

           [fi,fj] = find(lat_rho == (lat(ii) - minimo(ii)));
            pos_y(ii) = fj(1);

        end

 end


clear minimo i j fi fj

% Acha longitude do trajeto na matriz do modelo


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

% Encontra tempo do glider nos resultados do modelo
time_ref = datenum(time_ref);

if time_uni == 's';
    unity = 24*3600;
elseif time_uni == 'm';
    unity = 24*60;
elseif time_uni == 'd';
    unity = 1;
end
periodo = datenum(periodo);    
periodo = (periodo-time_ref)*unity;

for ii = 1: size(periodo,1);



  minimo(ii) = min(min(abs(time_mod(:,1) - periodo(ii))));


  [fi,fj] = find(time_mod == (periodo(ii) + minimo(ii)));


        if (isempty(fi)==0),


              tindex(ii) = fi(1);

        elseif (isempty(fi)==1),


            [fi,fj] = find(time_mod == (periodo(ii) - minimo(ii)));

            tindex(ii) = fi(1);

        end
end

TINDEX = tindex;
POSX = pos_x(1,:);
POSY = pos_y(1,:);
return

     