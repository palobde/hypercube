function rm = rminfunction(k)
if k==0
    rm=0;
elseif k<=4
    rm=k;
elseif k<=13
    rm=4;
elseif k<=20
    rm=5;
elseif k<=27
    rm=6;
else
    rm=7;
end