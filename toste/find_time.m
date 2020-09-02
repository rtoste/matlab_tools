function [TINDEX] = find_time(time_ref,time_mod,time_uni,periodo)
% [TINDEX] = FIND_TIME(time_ref,time_mod,time_uni,periodo);

% time_ref = tempo de referencia do modelo (string), se time_mod estiver em
% dias julianos, pode colocar como zero;
% time_mod = vetor de tempo do modelo
% time_uni = unidade de tempo do time_mod(string: 's','m' ou 'd')
% periodo  = vetor ou valor de tempo a ser buscado no modelo (string)
%
% Raquel Toste - 07/01/2016

minimo = zeros;


% Encontra tempo nos resultados do modelo
if ischar(time_ref)==1
    time_ref = datenum(time_ref);
end

if time_uni == 's';
    unity = 24*3600;
elseif time_uni == 'm';
    unity = 24*60;
elseif time_uni == 'd';
    unity = 1;
end

if ischar(periodo)==1
    periodo = datenum(periodo);    
end

periodo = (periodo-time_ref)*unity;

for ii = 1: size(periodo,1);



  minimo(ii) = min(min(abs(time_mod(:,1) - periodo(ii))));


  [fi,fj] = find(time_mod == (periodo(ii) + minimo(ii)));


        if (isempty(fi)==0),


              tindex(ii) = fi(1);

        elseif (isempty(fi)==1),


            [fi,fj] = find(time_mod == (periodo(ii) - minimo(ii)));

            tindex(ii) = fi;

        end
end

TINDEX = tindex;

return    