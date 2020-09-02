function [LON,LAT] = coast2polygon(lon,lat)
% [LON,LAT] = COAST2POLYGON(lon,lat)
% Trabsforma em polígonos, a linha de costa separada por NaN

isn = find(isnan(lon)==1);

if ~isempty(isn)
    
    siz = length(lon);
    isn_f = find(isn == siz);
    
    if isempty(isn_f)
        isn = cat(1,isn,siz);
    end
    
end


if isempty(isn)
    disp('Error: Linha de costa não está separada por NaN')
else
    
    for ii = 1:size(isn,1)-1;
        
        lon_n = [lon(isn(ii):isn(ii+1)-1);lon(isn(ii)+1)];
        lat_n = [lat(isn(ii):isn(ii+1)-1);lat(isn(ii)+1)];
        
        if ii == 1
            
            LON = lon_n;
            LAT = lat_n;
            
        else
            
            LON = cat(1,LON,lon_n);
            LAT = cat(1,LAT,lat_n);
            
        end
    end
end

return
        
        
        