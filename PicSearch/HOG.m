%Image descriptor based on Histogram of Orientated Gradients for gray-level images. This code 
%was developed for the work: O. Ludwig, D. Delgado, V. Goncalves, and U. Nunes, 'Trainable 
%Classifier-Fusion Schemes: An Application To Pedestrian Detection,' In: 12th International IEEE 
%Conference On Intelligent Transportation Systems, 2009, St. Louis, 2009. V. 1. P. 432-437. In 
%case of publication with this code, please cite the paper above.

function H=HOG(Im)
nwin_x=3;
nwin_y=3;
%设置cell的数目，nwin_x为x方向的窗口数目，nwin_y为y方向的窗口数目
B=9;
%设置梯度方向统计中梯度方向被划分的维度的数目B
[L,C]=size(Im); % L num of lines ; C num of columns
H=zeros(nwin_x*nwin_y*B,1); 
%H为最终得到的图像的特征向量
m=sqrt(L/2);
if C==1 % if num of columns==1
    Im=im_recover(Im,m,2*m);%verify the size of image, e.g. 25x50
    L=2*m;
    C=m;
end
%我们认为，上述代码是为了处理一些特殊的，用一维数组存储的图像
Im=double(Im);
step_x=floor(C/(nwin_x+1));
step_y=floor(L/(nwin_y+1));
%计算每个cell中x方向的像素个数step_x（y方向同理）
cont=0;
hx = [-1,0,1];
hy = -hx';
%定义空间域卷积运算的算子hx，hy
grad_xr = imfilter(double(Im),hx);
grad_yu = imfilter(double(Im),hy);
%得到x方向梯度grad_xr,y方向梯度grad_yr
angles=atan2(grad_yu,grad_xr);
magnit=((grad_yu.^2)+(grad_xr.^2)).^.5;
%计算梯度幅值magnit，梯度方向angles
%下方代码开始计算每个cell的B维特征向量
for n=0:nwin_y-1
    for m=0:nwin_x-1
        cont=cont+1;
        angles2=angles(n*step_y+1:(n+2)*step_y,m*step_x+1:(m+2)*step_x); 
        magnit2=magnit(n*step_y+1:(n+2)*step_y,m*step_x+1:(m+2)*step_x);
        %angles2中当前cell中各像素点梯度方向，magnit2中存储梯度幅值
        v_angles=angles2(:);    
        v_magnit=magnit2(:);
        K=max(size(v_angles));
        %将angles2和magnit2中数据以一维数组形式存储在v_angles，v_magnit，并获取总的像素点数K（提高运算速度）
        bin=0;
        H2=zeros(B,1);
        %bin作为每个维度的索引
        %下方循环计算每个维度的特征值
        for ang_lim=-pi+2*pi/B:2*pi/B:pi
            bin=bin+1;
            %下方循环遍历梯度方向
            for k=1:K
                if v_angles(k)<ang_lim
                    v_angles(k)=100;
                    %防止重复统计
                    H2(bin)=H2(bin)+v_magnit(k);
                end
            end
        end
                
        H2=H2/(norm(H2)+0.01); 
        %对特征向量进行标准化处理
        H((cont-1)*B+1:cont*B,1)=H2;
        %将所有cell的特征向量合并，得到整个图像的特征向量
    end
end