function eumat = eucDist(Base)

[r k] = size(Base);

dmat = zeros(r,r);

for i=1:r
    for j=1:r
        if i==j
        else
            eumat(i,j) = (sum((Base(i,:) - Base(j,:)).^2)).^0.5;
        end
    end
end
