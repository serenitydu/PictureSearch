function distance = EulerCalculate(T1,T2)
distance = 0;
for i = 1:8
    distance = distance + T1(i)^8 - T2(i)^8;
end
distance = distance^(1/8);
end