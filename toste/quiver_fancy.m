function quiver_fancy(x,y,u,v,veccol,varargin)
% QUIVER_FANCY(X,Y,U,V,COR,TAMANHO_SETA,BASE_SETA,TIPO)
% x = eixo x
% y = eixo y
% u = componente u
% v = componente v
% cor = cor da seta; RGB ou letras reconhecidas pelo matlab
% tamanho_seta = proporção da seta (0 a 1, default = 0.4)
% base_seta = seta centrada no meio (1, default) ou na base (0)
% tipo = tipo de base de cabeça da seta, se é com base reta (0) ou formando
% angulo com a ponta da seta (1, default)
% 
% Raquel Toste - baseado em ncquiverref.m

if size(x,1) == 1 | size(x,2) == 1
scalelength=0.5;  
else
x1=abs(x(1,1)-x(2,1));
y1=abs(y(1,1)-y(1,2));
scalelength=mean([x1,y1]);
end



% remove masked grid points from the input by filling coordinates with NaN;
x(isnan(u))=NaN;
y(isnan(u))=NaN;

% Remove NaN values that will not be plotted
% and turn points into a row of coordinates
u=u(~isnan(x))';
v=v(~isnan(x))';
y=y(~isnan(x))';
x=x(~isnan(x))';

% Set arrow size (1= full length of vector)
if length(varargin)>=1
    
    arrow = varargin{1};
%     if size(x,1) | size(x,2) == 1
%     scalelength = arrow;
%     end
else
   
    arrow=0.40;
    arrow=1;
end

[th,z1] = cart2pol(u,v);

  % Center vectors over grid points
%   [u,v] = pol2cart(th,scalelength);
  
%   if length(varargin)>=2
%       base_seta = varargin{2};
%       disp(base_seta)
%   else
%       base_seta = 1;
%   end
          
%   if base_seta == 1
%       
%       xstart=x-0.5*u;
%       xend=x+0.5*u;
%       ystart=y-0.5*v;
%       yend=y+0.5*v;
%       
%   elseif base_seta == 0
%       
%       xstart=x;
%       xend=x+0.5*u;
%       ystart=y;
%       yend=y+0.5*v;
%   end   

  
  % cabeca seta
  if length(varargin)>=3
      tipo = varargin{3};
  else
      tipo = 1;
  end
  
  if tipo == 1
      kk = 1/3;
  elseif tipo == 0
      kk = 1/3;
  end
  
  
%   Get x coordinates of each vector plotted
%   lx = [xstart; ...
%        xstart+(1-arrow*kk)*(xend-xstart); ...
%        xend-arrow*kk*(u*kk+arrow*v); ...
%        xend; ...
%        xend-arrow*(u-arrow*v); ...
%        xstart+(1-arrow*kk)*(xend-xstart); ...
%        repmat(NaN,size(xstart))];
% 
%   % Get y coordinates of each vector plotted
%   ly = [ystart; ...
%        ystart+(1-arrow*kk)*(yend-ystart); ...
%        yend-arrow*(v-arrow*u); ...
%        yend; ...
%        yend-arrow*kk*(v*kk+arrow*u); ...
%        ystart+(1-arrow*kk)*(yend-ystart); ...
%        repmat(NaN,size(ystart))];

lx = [x;x+u*(1-kk);repmat(NaN,size(u))];
ly = [y;y+v*(1-kk);repmat(NaN,size(u))];

 line(lx,ly,'Color',veccol);
 hold on

% lx = [x+u;x+u-kk*(u+kk*(v+eps));x+u; ...
%             x+u-kk*(u-kk*(v+eps));repmat(NaN,size(u))];
% ly = [y+v;y+v-kk*(v-kk*(u+eps));y+v; ...
%             y+v-kk*(v+kk*(u+eps));repmat(NaN,size(v))];

lx = [x+u;x+u-kk*(u+kk*(v+eps)); ...
            x+u-kk*(u-kk*(v+eps));x+u];
ly = [y+v;y+v-kk*(v-kk*(u+eps)); ...
            y+v-kk*(v+kk*(u+eps));y+v];


  % Plot the vectors
%   line(lx,ly,'Color',veccol);

  fill(lx,ly,veccol);
end 