function courant(grd,dx,dy,varargin)
% COURANT(grd,dx,dy,v(optional),g(optional))
% Calculo do passo de tempo
% grd = arquivo de grade
% dx  = espaçamento medio longitudinal, em metros
% dy  = espaçamento medio transversal, em metros
% v   = modulo da velocidade da corrente, m/s (opcional)
% g   = aceleracao da gravidade, m/s2 (opcional)

clc

h = ncread(grd,'h');

if nargin<3
    error(message('Not enough inputs'))
end

if ~isempty(varargin) 
    
    if nargin>3 && isnumeric(varargin{1})
        v = varargin{1};
        
        if nargin == 4 && isnumeric(varargin{2})
            g = varargin{2};
        else
            error(message('Input must be numeric'))
        end
        
    else
        error(message('Input must be numeric'))
    end
    
else
    v = 1;
    g = 10;
end

hm = mean(mean(h)); % profundidade media local


% para numero de courant entre 3 e 8 (segundo Rosman)

disp ('O passo de tempo deve estar entre')

k = sqrt((1/(dx*dx))+(1/(dy*dy)));
j = sqrt(g*hm);

cr = 3;
dt1 = cr/(k*(v+j));
cr = 8;
dt2 = cr/(k*(v+j));

disp([num2str(dt1),'  e  ',num2str(dt2)])


% para numero de Courant menor que 1
cr = 1;
dt3 = cr/(k*(v+j));

disp(['ou ser menor que  ',num2str(dt3)])

return