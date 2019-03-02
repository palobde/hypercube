function dfact = matDist(Base) 
% fonction qui calcule la matrice interdistance et qui y affcie un facteur

[r, k] = size(Base);

dfact=0;
dmat = zeros(r,r);

for i=1:r
    for j=1:r
        if i==j
        else
            dmat(i,j) = sum(abs(Base(i,:) - Base(j,:)));
        end
    end
end

dfact=sum(sum(dmat))*0.5*1E-5;