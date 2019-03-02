function coord = coordPoint(Base, Point)
[r k] = size(Base);
coord = 9999*ones(1,r);
for i=1:1:r
    coord(1,i) = sum(abs(Base(i,:) - Point));
end
