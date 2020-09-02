function tidefrc(frcname,tidename,grdname,time_ref)
% tidefrc(FRCNAME,TIDENAME,GRDNAME,[YEAR,MONTH,DAY])
% Function to create ROMS forcing file using TPXO model
% frcname = forcing file name to be created
% tidename = TPXO file name
% grdname = grid file
% time_ref = time reference for the forcing file in the format
% [year,month,day]
% 
% This function has been adapted from make_tides and romstools_param codes
% from Patrick Marchesiello and Pierrick Penven
%
% Raquel Toste --- 27-Apr-2016


% General parameters ------------------------------------------------------

% Objective analysis decorrelation scale [m]
% (if Roa=0: simple extrapolation method; crude but much less costly)

Roa = 0;

% Number of tides component to process

Ntides = 10;

% Chose order from the rank in the TPXO file :
% "M2 S2 N2 K2 K1 O1 P1 Q1 Mf Mm"
% " 1  2  3  4  5  6  7  8  9 10"
tidalrank = [1 2 3 4 5 6 7 8 9 10];


% Get start time of simulation in fractional mjd for nodal correction

date_mjd = mjd(time_ref(1),time_ref(2),time_ref(3));
[pf,pu,t0,phase_mkB] = egbert_correc(date_mjd,0,0,0);
deg = 180.0/pi;

% Add a phase correction to be consistent with the 'Yorig' time

t0=t0-24*date_mjd;

%  Read in ROMS grid ------------------------------------------------------

disp('Reading ROMS grid parameters ...');
nc = netcdf(grdname);
lonr    = nc{'lon_rho'}(:);
latr    = nc{'lat_rho'}(:);
lonu    = nc{'lon_u'}(:);
latu    = nc{'lat_u'}(:);
lonv    = nc{'lon_v'}(:);
latv    = nc{'lat_v'}(:);
rangle  = nc{'angle'}(:); 
h       = nc{'h'}(:);
rmask   = nc{'mask_rho'}(:);
Lp      = length(nc('xi_psi'))  + 1;
Mp      = length(nc('eta_psi')) + 1;
close(nc)

% Read in TPX file --------------------------------------------------------

nctides = netcdf(tidename);
periods = nctides{'periods'}(:);
cmpt    = nctides.components(:);
close(nctides)

Nmax    = length(periods);
Ntides  = min([Nmax Ntides]);

% Creating the forcing file -----------------------------------------------

for ii = 1:Ntides
    components(3*ii-2:3*ii)=[cmpt(3*tidalrank(ii)-2:3*tidalrank(ii)-1),' '];
end
disp(['Tidal components : ',components])

nc = netcdf(frcname,'clobber');
redef(nc)

nc('xi_rho')        = Lp;
nc('eta_rho')       = Mp;
nc('tide_period')   = Ntides;

nc{'tide_period'} = ncdouble('tide_period');
nc{'tide_period'}.long_name = ncchar('Tide angular period');
nc{'tide_period'}.long_name = 'Tide angular period';
nc{'tide_period'}.units = ncchar('Hours');
nc{'tide_period'}.units = 'Hours';

nc{'tide_Ephase'} = ncdouble('tide_period', 'eta_rho', 'xi_rho');
nc{'tide_Ephase'}.long_name = ncchar('Tidal elevation phase angle');
nc{'tide_Ephase'}.long_name = 'Tidal elevation phase angle';
nc{'tide_Ephase'}.units = ncchar('Degrees');
nc{'tide_Ephase'}.units = 'Degrees';

nc{'tide_Eamp'} = ncdouble('tide_period', 'eta_rho', 'xi_rho');
nc{'tide_Eamp'}.long_name = ncchar('Tidal elevation amplitude');
nc{'tide_Eamp'}.long_name = 'Tidal elevation amplitude';
nc{'tide_Eamp'}.units = ncchar('Meter');
nc{'tide_Eamp'}.units = 'Meter';

nc{'tide_Cmin'} = ncdouble('tide_period', 'eta_rho', 'xi_rho');
nc{'tide_Cmin'}.long_name = ncchar('Tidal current ellipse semi-minor axis');
nc{'tide_Cmin'}.long_name = 'Tidal current ellipse semi-minor axis';
nc{'tide_Cmin'}.units = ncchar('Meter second-1');
nc{'tide_Cmin'}.units = 'Meter second-1';

nc{'tide_Cmax'} = ncdouble('tide_period', 'eta_rho', 'xi_rho');
nc{'tide_Cmax'}.long_name = ncchar('Tidal current, ellipse semi-major axis');
nc{'tide_Cmax'}.long_name = 'Tidal current, ellipse semi-major axis';
nc{'tide_Cmax'}.units = ncchar('Meter second-1');
nc{'tide_Cmax'}.units = 'Meter second-1';

nc{'tide_Cangle'} = ncdouble('tide_period', 'eta_rho', 'xi_rho');
nc{'tide_Cangle'}.long_name = ncchar('Tidal current inclination angle');
nc{'tide_Cangle'}.long_name = 'Tidal current inclination angle';
nc{'tide_Cangle'}.units = ncchar('Degrees between semi-major axis and East');
nc{'tide_Cangle'}.units = 'Degrees between semi-major axis and East';

nc{'tide_Cphase'} = ncdouble('tide_period', 'eta_rho', 'xi_rho');
nc{'tide_Cphase'}.long_name = ncchar('Tidal current phase angle');
nc{'tide_Cphase'}.long_name = 'Tidal current phase angle';
nc{'tide_Cphase'}.units = ncchar('Degrees');
nc{'tide_Cphase'}.units = 'Degrees';

endef(nc)

nc.creation_date = ncchar(date);
nc.creation_date = date;
nc.start_tide_mjd=date_mjd;
nc.components = ncchar(components);
nc.components = components;

close(nc)

ncfrc = netcdf(frcname,'write');

% Loop on periods ---------------------------------------------------------

for itide = 1:Ntides
  
  it = tidalrank(itide);
  disp(['Processing tide : ',num2str(itide),' of ',num2str(Ntides)])
  ncfrc{'tide_period'}(it) = periods(itide);

% Get the phase corrections

  correc_amp = pf(itide);
  correc_phase = -phase_mkB(itide)-pu(itide)+360.*t0./periods(itide);	   

% Process the surface elevation
  disp('  ssh...')
  ur = ext_data_tpxo(tidename,'ssh_r',itide,lonr,latr,'r',Roa);
  ui = ext_data_tpxo(tidename,'ssh_i',itide,lonr,latr,'r',Roa);
  ei = complex(ur,ui);
  ncfrc{'tide_Ephase'}(it,:,:) = mod(-deg*angle(ei)+correc_phase,360.0);     
  ncfrc{'tide_Eamp'  }(it,:,:) = abs(ei)*correc_amp;

% Process U
  disp('  u...')
  ur = ext_data_tpxo(tidename,'u_r',itide,lonr,latr,'u',Roa);
  ui = ext_data_tpxo(tidename,'u_i',itide,lonr,latr,'u',Roa);
  ei = complex(ur,ui);
  upha = mod(-deg*angle(ei)+correc_phase,360.0); 
  uamp = abs(ei)*correc_amp;

% Process V
  disp('  v...')
  ur = ext_data_tpxo(tidename,'v_r',itide,lonr,latr,'v',Roa);
  ui = ext_data_tpxo(tidename,'v_i',itide,lonr,latr,'v',Roa);
  ei = complex(ur,ui);
  vpha = mod(-deg*angle(ei)+correc_phase,360.0); 
  vamp = abs(ei)*correc_amp;

% Convert to tidal ellipses
  disp('  Convert to tidal ellipse parameters...')
  [major,eccentricity,inclination,phase] = ap2ep(uamp,upha,vamp,vpha);
  ncfrc{'tide_Cmin'  }(it,:,:) = major.*eccentricity;
  ncfrc{'tide_Cmax'  }(it,:,:) = major;
  ncfrc{'tide_Cangle'}(it,:,:) = inclination;
  ncfrc{'tide_Cphase'}(it,:,:) = phase;

end

close(ncfrc)
return
