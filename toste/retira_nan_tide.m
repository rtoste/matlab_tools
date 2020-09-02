function retira_nan_tide(arq)
% RETIRA_NAN_TIDE(arq)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Retira nan do arquivo de mare e substitui pelo valor mais próximo
% 
% Raquel Toste - 12 de maio de 2016
% Modificado em  18 de maio de 2016
% Modificado em  23 de maio de 2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



var = {'tide_Ephase' 'tide_Eamp' 'tide_Cphase' 'tide_Cangle' 'tide_Cmin' 'tide_Cmax'};

vars = length(var);


for vv = 1:vars;
    
    aa = ncread(arq,var{vv});
    

    if (ndims(aa)==3),
        
        for kk = 1:size(aa,3);

            variavel(:,:,kk) = inpaint_nans(aa(:,:,kk),4);

        end
        
    elseif (ndims(aa)==4),
        
        for kk = 1:size(aa,3);
            
            for ll = 1:size(aa,4);

            variavel(:,:,kk,ll) = inpaint_nans(aa(:,:,kk,ll),4);
            
            end

        end
        
    else
        
        variavel = inpaint_nans(aa,4);
        
    end

    [status] = nc_write(arq,var{vv},variavel);
    
    clear aa variavel
    
end
return
