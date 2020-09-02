%%%%%%%
% Pelos coleguinhas: Raquel e Anderson
% 14/05/2019

% r = abs(rand(200,1))+1;
r=[1:1:30];
dire = r+110;

[u,v]=intdir2uv(r,dire);
% z = -201:50:200;
z=[-30:1:-1];
cor = colormap(jet(length(z)));

figure
hold on
for ii = 1:length(z)
x  =[-r(ii):0.01:r(ii)];
yy = sqrt(r(ii).^2 - x.^2);
xx = [x,[r(ii):-0.01:-r(ii)]];
y = [yy,-yy];

h = fill3(xx,y,ones(size(xx)).*z(ii),'k');
set(h,'facecolor',cor(ii,:))
set(h,'edgecolor','none')
set(h,'facealpha',0.4)

quiver3(0,0,z(ii),u(ii),v(ii),0,'k')

end
view(60,8)
grid on