function retira_nan_bry(arq,West,East,South,North)
% RETIRA_NAN_BRY(arq,W,E,S,N)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Retira zero do arquivo de contorno (temp e sal) e substitui pelo valor
% mais próximo
% 
% Raquel Toste - 11 de julho de 2017
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


S.boundary(1) = West;           % process western  boundary segment (0=no)
S.boundary(2) = East;           % process eastern  boundary segment (0=no)
S.boundary(3) = South;           % process southern boundary segment (0=no)
S.boundary(4) = North;           % process northern boundary segment (0=no)

for bb = 1:4;
    
    if (bb == 1),

        if (S.boundary(1)),
           var = {'temp_west' 'salt_west'};
        end,
        
    elseif (bb == 2),
        
        if (S.boundary(2)),
           var = {'temp_east' 'salt_east'};
        end,
        
    elseif (bb == 3),

        if (S.boundary(3)),
           var = {'temp_south' 'salt_south'};
        end,
        
    elseif (bb == 4),

        if (S.boundary(4)),
            var = {'temp_north' 'salt_north'};
        end,
    end
    
    
    
    
    if (S.boundary(bb)),
        
    vars = length(var);


    for vv = 1:vars;

        aa = ncread(arq,var{vv});
        aa = double(aa);
        prov = find(aa == 0);
        aa(prov)=nan;


        if (ndims(aa)==3),

            for kk = 1:size(aa,3);

                variavel(:,:,kk) = inpaint_nans(aa(:,:,kk),4);

            end

        else

            variavel = inpaint_nans(aa,4);

        end

        [status] = nc_write(arq,var{vv},variavel);
        
        clear aa variavel

    end
    
    end
end
return
