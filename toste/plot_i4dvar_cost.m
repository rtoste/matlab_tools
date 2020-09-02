function plot_i4dvar_cost(Inp,PRINT,nome1,nome2)
% PLOT_I4DVAR_COST:  Plot I4D-Var cost function
%
addpath(genpath('/home/numa5/projetos/tools/arango_tools'))
% svn $Id$
%===========================================================================%
%  Copyright (c) 2002-2017 The ROMS/TOMS Group                              %
%    Licensed under a MIT/X style license                                   %
%    See License_ROMS.txt                                                   %
%===========================================================================%

if (PRINT),
    
   if nargin < 4,
   nome1 ='funcao_j.png';
   nome2 ='funcao_j_norm.png';
   end
   
   
end,

% PRINT=0;                               % switch to save figure as PNG

% Set input NetCDF files.

% Inp='../I4DVAR/wc13_mod.nc';           % ROMS 4D-Var file

% Read in cost function variables.

Jo =nc_read(Inp,'TLcost_function');    % observation cost function
Jb =nc_read(Inp,'back_function');      % background  cost function
JNL=nc_read(Inp,'NLcost_function');    % nonlinar model misfit

J=Jo+Jb;                               % total cost function

Niter=length(Jo);                      % number of 4D-Var iterations

% Compute theoretical minimum cost function value (Nobs/2).  Find number
% of bounded 4D-Var observations by counting nonzero values of the
% screening flag (obs_scale).

obs_scale=nc_read(Inp,'obs_scale');
Nobs=length(nonzeros(obs_scale));

Jmin=Nobs/2;

% Plot cost functions.

figure;

plot(log10(J),'k','LineWidth',2);
hold on;
plot(log10(Jo),'b','LineWidth',2);
plot(log10(Jb),'r','LineWidth',2);
line([1 Niter],[log10(Jmin) log10(Jmin)], ...
     'LineStyle','--','Color',[0 0 0],'LineWidth',2);
plot(Niter,log10(JNL(1,end)+Jb(end)),'rx','LineWidth',2,'MarkerSize',10);
grid on
axis([1 Niter 0 max(log10(J))]);

ylabel('log_{10}(J)')
xlabel('Iteration number')

legend('J','J_o','J_b','J_{min}','J_{NL}','Location','Southeast')

title('I4D-Var Cost Function')

if (PRINT),
    snam = '0_histo';
    s = hgexport('readstyle',snam);
    s.Format = 'png';
    hgexport(gcf,nome1,s)  
    close
end

figure;
Jmin2 = (Jmin)/(J(1));
plot(J/J(1),'k','LineWidth',2);
hold on;
plot(Jo/J(1),'b','LineWidth',2);
% plot(Jb,'r','LineWidth',2);
% line([1 Niter],[Jmin2 Jmin2], ...
%      'LineStyle','--','Color',[0 0 0],'LineWidth',2);

axis([1 Niter 0 1]);
grid on
ylabel('Normalized J')
xlabel('Iteration number')

legend('J','J_o','Location','Southeast')

title('I4D-Var Cost Function')

if (PRINT),
    snam = '0_histo';
    s = hgexport('readstyle',snam);
    s.Format = 'png';
    hgexport(gcf,nome2,s) 
    close
end


return
