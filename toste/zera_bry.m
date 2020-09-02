function zera_bry(arq,West,East,South,North)
% ZERA_BRY(arq,W,E,S,N)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Zera contorno radiacional
% 
% Raquel Toste - 10 de agosto de 2018
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


S.boundary(1) = West;           % process western  boundary segment (0=no)
S.boundary(2) = East;           % process eastern  boundary segment (0=no)
S.boundary(3) = South;           % process southern boundary segment (0=no)
S.boundary(4) = North;           % process northern boundary segment (0=no)

for bb = 1:4;
    
    if (bb == 1),

        if (S.boundary(1)),
           var = {'zeta_west' 'ubar_west' 'vbar_west' 'u_west' 'v_west' 'temp_west' 'salt_west'};
        end,
        
    elseif (bb == 2),
        
        if (S.boundary(2)),
           var = {'zeta_east' 'ubar_east' 'vbar_east' 'u_east' 'v_east' 'temp_east' 'salt_east'};
        end,
        
    elseif (bb == 3),

        if (S.boundary(3)),
           var = {'zeta_south' 'ubar_south' 'vbar_south' 'u_south' 'v_south' 'temp_south' 'salt_south'};
        end,
        
    elseif (bb == 4),

        if (S.boundary(4)),
            var = {'zeta_north' 'ubar_north' 'vbar_north' 'u_north' 'v_north' 'temp_north' 'salt_north'};
        end,
    end
    
    
    
    
    if (S.boundary(bb)),
        
    vars = length(var);


    for vv = 1:vars;

        aa = ncread(arq,var{vv});
        aa = double(aa);


        variavel = aa*0;

        [status] = nc_write(arq,var{vv},variavel);
        
        clear aa variavel

    end
    
    end
end
return
