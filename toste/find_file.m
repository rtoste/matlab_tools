function find_file(tempo,pasta,arquivos,tref)
% FIND_FILE(TEMPO,PASTA,ARQUIVOS,TREF)
% Encontra o arquivo no qual o tempo escolhido está inserido, onde: 
% TEMPO = tempo que precisa ser identificado nos arquivos (vetor); em dia
% juliano.
% PASTA = pasta onde estão os arquivos que precisam ser identificados;
% ARQUIVOS = identificador do arquivo para filtrar busca na pasta, p. ex.:
% buscar a data 2003-1-1 entre os arquivos arq_1.nc, arq_2.nc e arq_3.nc e
% não em arqteste_1.nc, usar ARQUIVOS = 'arq_*.nc' ou 'arq_*'
% tref = tempo de referencia do modelo, em dia juliano
% 
% Raquel Toste - Criado em: 30/08/2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for jj = 1:length(tempo);
    
ini = tempo(jj);

c = pasta;
d = dir(fullfile(c,arquivos));

for ii = 1:size(d,1)
    
    a = fullfile(c,d(ii).name);
    
    
    Tk = (ncread(a,'ocean_time'))/86400 + tref;
    
    b = find(Tk == ini);
    
    if ~isempty(b)
        
        disp(a)
        disp(b)
        break
    end
    
end

end

return