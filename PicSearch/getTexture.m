%**************************************************************************
%                   图像检索——纹理特征
%基于共生矩阵纹理特征提取，d=1,θ=0°,45°,90°,135°共四个矩阵
%所用图像灰度级均为256
%参考《基于颜色空间和纹理特征的图像检索》
%function : T=Texture(Image) 
%Image    : 输入图像数据
%T        : 返回八维纹理特征行向量
%**************************************************************************
function T = getTexture(Image)
[M,N,O] = size(Image);
%--------------------------------------------------------------------------
%1.将各颜色分量转化为灰度
%--------------------------------------------------------------------------
Gray = rgb2gray(image);

%--------------------------------------------------------------------------
%2.为了减少计算量，对原始图像灰度级压缩，将Gray量化成16级
%--------------------------------------------------------------------------
for i = 1:M
    for j = 1:N
        for n = 1:256/16
            if (n-1)*16<=Gray(i,j)&Gray(i,j)<=(n-1)*16+15
                Gray(i,j) = n-1;
            end
        end
    end
end

%--------------------------------------------------------------------------
%3.计算四个共生矩阵P,取距离为1，角度分别为0,45,90,135
%--------------------------------------------------------------------------
P = zeros(16,16,4);
for m = 1:16
    for n = 1:16
        for i = 1:M
            for j = 1:N
                if j<N&Gray(i,j)==m-1&Gray(i,j+1)==n-1
                    P(m,n,1) = P(m,n,1)+1;
                    P(n,m,1) = P(m,n,1);
                end
                if i>1&j<N&Gray(i,j)==m-1&Gray(i-1,j+1)==n-1
                    P(m,n,2) = P(m,n,2)+1;
                    P(n,m,2) = P(m,n,2);
                end
                if i<M&Gray(i,j)==m-1&Gray(i+1,j)==n-1
                    P(m,n,3) = P(m,n,3)+1;
                    P(n,m,3) = P(m,n,3);
                end
                if i<M&j<N&Gray(i,j)==m-1&Gray(i+1,j+1)==n-1
                    P(m,n,4) = P(m,n,4)+1;
                    P(n,m,4) = P(m,n,4);
                end
            end
        end
        if m==n
            P(m,n,:) = P(m,n,:)*2;
        end
    end
end

%%---------------------------------------------------------
% 对共生矩阵归一化
%%---------------------------------------------------------
for n = 1:4
    P(:,:,n) = P(:,:,n)/sum(sum(P(:,:,n)));
end

%--------------------------------------------------------------------------
%4.对共生矩阵计算能量、熵、惯性矩、相关4个纹理参数
%--------------------------------------------------------------------------
H = zeros(1,4);
I = H;
Ux = H;      Uy = H;
deltaX= H;  deltaY = H;
C =H;
for n = 1:4
    E(n) = sum(sum(P(:,:,n).^2)); %%能量
    for i = 1:16
        for j = 1:16
            if P(i,j,n)~=0
                H(n) = -P(i,j,n)*log(P(i,j,n))+H(n); %%熵
            end
            I(n) = (i-j)^2*P(i,j,n)+I(n);  %%惯性矩
           
            Ux(n) = i*P(i,j,n)+Ux(n); %相关性中μx
            Uy(n) = j*P(i,j,n)+Uy(n); %相关性中μy
        end
    end
end
for n = 1:4
    for i = 1:16
        for j = 1:16
            deltaX(n) = (i-Ux(n))^2*P(i,j,n)+deltaX(n); %相关性中σx
            deltaY(n) = (j-Uy(n))^2*P(i,j,n)+deltaY(n); %相关性中σy
            C(n) = i*j*P(i,j,n)+C(n);             
        end
    end
    C(n) = (C(n)-Ux(n)*Uy(n))/deltaX(n)/deltaY(n); %相关性   
end

%--------------------------------------------------------------------------
%求能量、熵、惯性矩、相关的均值和标准差作为最终8维纹理特征
%--------------------------------------------------------------------------
T(1) = mean(E);   T(2) = sqrt(cov(E));
T(3) = mean(H);   T(4) = sqrt(cov(H));
T(5) = mean(I);   T(6) = sqrt(cov(I));
T(7) = mean(C);   T(8) = sqrt(cov(C));

