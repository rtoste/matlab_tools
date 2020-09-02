function [IDX,COORD] = bifurcacao(x,y,u,v,orientacao,varargin)
% ,orientacao,coord_min,coord_max,prof);



%-------------------------------------------------------------------------
% orientacao = varargin{5}
if nargin >5
    coord_min  = varargin{1};
    coord_max  = varargin{2};
    if nargin >7
        batimetria = varargin{3};
        prof_min   = varargin{4};
        prof_max   = varargin{5};
        
    end
end
%-------------------------------------------------------------------------
% rotacional e divergente

% cav = curl(u,v);
div = divergence(u,v);

%-------------------------------------------------------------------------
% define area possivel de bifurcação

if nargin >5
    
% lat_min = -25;
% lat_max = -7;
% prof_max = 2000;

    div_pos = div;

    if strmatch(orientacao,'lat')
        a = y<coord_min | y>coord_max;
    elseif strmatch(orientacao,'lon')
        a = x<coord_min | x>coord_max;
    end       
        
    div_pos(a) = nan;

    if nargin>8
        a = batimetria>prof_max | batimetria<prof_min;
        div_pos(a) = nan;
    end
    div = div_pos;
end

%-------------------------------------------------------------------------
% acha divergencia positiva

IDX = find(div==max(max(div)));
if      strmatch(orientacao,'lat')
    COORD = y(IDX);
elseif  strmatch(orientacao,'lon')
    COORD = x(IDX);
end

return