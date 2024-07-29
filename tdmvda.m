function [M_ij,S_jr_2D,D_jr_2D] = tdmvda(c,v,s_r,s_c,tr_nij,AV)

tr_ni = zeros(c,1);
for i = 1 : c
    tr_ni(i) = tr_nij(i) * v;
end
tr_n = sum(tr_ni);

%Mean Calculation
M_ij = zeros(s_r,s_c,c,v);
for i = 1 : c
    for j = 1 : v
        for k = 1 : tr_nij(i)
            M_ij(:,:,i,j) = M_ij(:,:,i,j) + AV(:,:,i,j,k);
        end
        M_ij(:,:,i,j) = M_ij(:,:,i,j) / tr_nij(i);
    end
end

%Within-class Scatter Matrix
Temp2 = zeros(s_r,s_r);
S_jr = zeros(s_r,s_r,v,v);

for j = 1 : v
    for r = 1 : v
        for i = 1 : c
            Temp = ((tr_nij(i)*tr_nij(i)) / tr_ni(i)) * (M_ij(:,:,i,j) * M_ij(:,:,i,r).');
            Temp1 = zeros(s_r,s_r);
            if j == r
                for k = 1 : tr_nij(i)
                    Temp1 = Temp1 + (AV(:,:,i,j,k) * AV(:,:,i,j,k).');
                end
            end
            Temp2 = Temp2 + (Temp1 - Temp);
        end
        S_jr(:,:,j,r) = Temp2;
    end
end

%Between-class Scatter Matrix
D_jr = zeros(s_r,s_r,v,v);
for j = 1 : v
    for r = 1 : v
        Temp = zeros(s_r,s_r);
        Temp1 = zeros(s_r,s_c);
        Temp2 = zeros(s_r,s_c);
        for i = 1 : c
            Temp = Temp + ((tr_nij(i)*tr_nij(i))/tr_ni(i)) * (M_ij(:,:,i,j) * M_ij(:,:,i,r).');
            Temp1 = Temp1 + tr_nij(i) * M_ij(:,:,i,j);
            Temp2 = Temp2 + tr_nij(i) * M_ij(:,:,i,r);
        end
        D_jr(:,:,j,r) = Temp - ((Temp1 * Temp2.') / tr_n);
    end
end
clear Temp Temp1 Temp2;

%Convert 4D matrices S_jr and D_jr into 2-D matrices S_jr_2D and D_jr_2D respectively
nv = s_r * v;
S_jr_2D = zeros(nv,nv);
D_jr_2D = zeros(nv,nv);
temp_r = 1;
temp_c = 1;

for j = 1 : v
    for r = 1 : v
        S_jr_2D(temp_r:(temp_r+s_r-1) , temp_c:(temp_c+s_r-1)) = S_jr(:,:,j,r);
        D_jr_2D(temp_r:(temp_r+s_r-1) , temp_c:(temp_c+s_r-1)) = D_jr(:,:,j,r);
        temp_c = temp_c + s_r;
    end
    temp_c = 1;
    temp_r = temp_r + s_r;
end
clear S_jr D_jr;
