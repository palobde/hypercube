function [L C]=identifyBase(Base)
[r, k] = size(Base);
L=prod(sum(Base(2:r,:),2)); % Produit de la somme des elements sur chaque ligne
C=prod(sum(Base)); % Produit de la somme des elements sur chaque ligne
if C==0
    c_sum = sum(Base);
    for i=1:length(c_sum)
        if c_sum(i)==0
            c_sum(i)=k;
        end
    end
    C=prod(c_sum);
end


