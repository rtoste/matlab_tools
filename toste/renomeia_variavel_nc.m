arq = 'arquivo.nc';
posicao = 4; %posicao da variavel no arquivo
nomenovo = 'lwrad_down';

ncid = netcdf.open(arq,'NC_WRITE');

netcdf.reDef(ncid)

[varname, xtype, varDimIDs, varAtts] = netcdf.inqVar(ncid,posicao);

%verifica se é a variavel que deseja mudar o nome; se nao for, mudar a
%posicao
varname

% renomeia
netcdf.renameVar(ncid,posicao,nomenovo)

%verifica se está com nome novo
[varname, xtype, varDimIDs, varAtts] = netcdf.inqVar(ncid,posicao);

netcdf.close(ncid)
