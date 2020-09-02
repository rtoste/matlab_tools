function [visc]=viscmax(dx,dt)
% Determina a viscosidade maxima (VISC2) a ser usada no ROMS 
% dx é a resolução da grade em metros
% dt é o passo de tempo do modelo
% Raquel Toste 14 de julho de 2017
disp('coef de visc tem que ser menor que')
visc = ((dx/pi)^2)/dt;
return