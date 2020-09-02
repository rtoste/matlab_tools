function [px,py,ang] = find_radiais(grd,varargin)
% [px,py]=find_radiais(grd,p_reta,x1,x2,y1,y2);

% Raquel Toste - 2019/11/25
% Adaptado de: calcula_vazao (Anderson Soares)

lon = ncread(grd,'lon_rho');
lat = ncread(grd,'lat_rho');
h   = ncread(grd,'h');
m   = ncread(grd,'mask_rho');
m(m==0)=nan;


if nargin > 1
    p_reta = varargin{1}-1;
else
    p_reta = 30;
end

if nargin>2
    x1 = varargin{2};
    x2 = varargin{3};
    y1 = varargin{4};
    y2 = varargin{5};
    tracar = 0;
else
    tracar = 1;
end
   
    
if tracar==1
    
    fig = figure;
    pcolor(lon,lat,h.*m);shading flat
    title({'Ative "data cursor" e selecione o primeiro ponto.',...
        'Aperte: shift + click para selecionar o segundo ponto.',...
        'Aperte Enter para finalizar'})
    dcm_obj = datacursormode(fig);
    set(dcm_obj,'DisplayStyle','datatip',...
        'SnapToDataVertex','off','Enable','on')
    pause()
    
    c_info = getCursorInfo(dcm_obj);
    
    p1 = c_info(1,1);
    p2 = c_info(1,2);
    
    x1 = p1.Position(1,1);
    y1 = p1.Position(1,2);
    x2 = p2.Position(1,1);
    y2 = p2.Position(1,2);
    close(fig)
end

% ==============================================
% Traça uma reta entre os dois pontos
% ==============================================

coef = polyfit([x1;x2], [y1;y2], 1);

a = coef(1);
b = coef(2);

if x1~=x2    
    deltax=abs((x1-x2)/p_reta);
    if x2>x1
        x = [x1:deltax:x2];
    else
        x = [x2:deltax:x1];
    end
    y = a*x+b;
  
else
    deltay=abs((y1-y2)/p_reta);
    if y2>y1
        y = [y1:deltay:y2];
    else
        y = [y2:deltay:y1];
    end
    x = ones(size(y))*x1;

end

% ==============================================
% Procura os pontos da reta na grade
% ==============================================

[px,py] = find_position(lon,lat,x(:),y(:));
% ==============================================
% Remove pontos repetidos
% ==============================================
distancia = nan(size(px));
for ii = 2:length(px)
    distancia(ii) = distance(py(ii-1),px(ii-1),py(ii),px(ii));
end
idx = find(distancia==0);
px(idx)=[];
py(idx)=[];

% ==============================================
% Plota pontos escolhidos
% ==============================================

% figure
% pcolor(lon,lat,h.*m),shading flat
% title({'Se os pontos não estiverem corretos:',...
%      'Ajustar parâmetro p\_reta'})
% hold on
% 
% for ii = 1:length(px)
%     hold on
%     plot(lon(px(ii),py(ii)),lat(px(ii),py(ii)),'ok')
% 
% end
% 
% plot(x,y,'-m')
% pause()
% close
ang = atand(a);
return


