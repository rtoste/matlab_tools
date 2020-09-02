% Matlab function to calculate the refined index of agreement
%       function dr=d_r(o,p,c)
%
%   Willmott, C. J., S. M. Robeson, and K. Matsuura (2011) "A refined 
%   index of model performance," International Journal of Climatology, DOI:
%   10.1002/joc.2419
%
% Inputs:  
%   o is vector of observed values
%   p is vector of predicted or modeled values
%   c is the scaling of the deviations-to-errors ratio
%   (c=2 is recommended)
%
% Output:
%   dr is the refined index of agreement
% 
% S. Robeson, Department of Geography, Indiana University
%             e-mail: srobeson@indiana.edu
 
function dr=d_r(o,p,c)

first=sum(abs(p-o));
second=c*sum(abs(o-mean(o)));

if first <= second
    dr=1-first/second;
else
    dr=second/first - 1;
end
