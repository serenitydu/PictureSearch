%Image descriptor based on Histogram of Orientated Gradients for gray-level images. This code 
%was developed for the work: O. Ludwig, D. Delgado, V. Goncalves, and U. Nunes, 'Trainable 
%Classifier-Fusion Schemes: An Application To Pedestrian Detection,' In: 12th International IEEE 
%Conference On Intelligent Transportation Systems, 2009, St. Louis, 2009. V. 1. P. 432-437. In 
%case of publication with this code, please cite the paper above.

function H=HOG(Im)
nwin_x=3;
nwin_y=3;
%����cell����Ŀ��nwin_xΪx����Ĵ�����Ŀ��nwin_yΪy����Ĵ�����Ŀ
B=9;
%�����ݶȷ���ͳ�����ݶȷ��򱻻��ֵ�ά�ȵ���ĿB
[L,C]=size(Im); % L num of lines ; C num of columns
H=zeros(nwin_x*nwin_y*B,1); 
%HΪ���յõ���ͼ�����������
m=sqrt(L/2);
if C==1 % if num of columns==1
    Im=im_recover(Im,m,2*m);%verify the size of image, e.g. 25x50
    L=2*m;
    C=m;
end
%������Ϊ������������Ϊ�˴���һЩ����ģ���һά����洢��ͼ��
Im=double(Im);
step_x=floor(C/(nwin_x+1));
step_y=floor(L/(nwin_y+1));
%����ÿ��cell��x��������ظ���step_x��y����ͬ��
cont=0;
hx = [-1,0,1];
hy = -hx';
%����ռ��������������hx��hy
grad_xr = imfilter(double(Im),hx);
grad_yu = imfilter(double(Im),hy);
%�õ�x�����ݶ�grad_xr,y�����ݶ�grad_yr
angles=atan2(grad_yu,grad_xr);
magnit=((grad_yu.^2)+(grad_xr.^2)).^.5;
%�����ݶȷ�ֵmagnit���ݶȷ���angles
%�·����뿪ʼ����ÿ��cell��Bά��������
for n=0:nwin_y-1
    for m=0:nwin_x-1
        cont=cont+1;
        angles2=angles(n*step_y+1:(n+2)*step_y,m*step_x+1:(m+2)*step_x); 
        magnit2=magnit(n*step_y+1:(n+2)*step_y,m*step_x+1:(m+2)*step_x);
        %angles2�е�ǰcell�и����ص��ݶȷ���magnit2�д洢�ݶȷ�ֵ
        v_angles=angles2(:);    
        v_magnit=magnit2(:);
        K=max(size(v_angles));
        %��angles2��magnit2��������һά������ʽ�洢��v_angles��v_magnit������ȡ�ܵ����ص���K����������ٶȣ�
        bin=0;
        H2=zeros(B,1);
        %bin��Ϊÿ��ά�ȵ�����
        %�·�ѭ������ÿ��ά�ȵ�����ֵ
        for ang_lim=-pi+2*pi/B:2*pi/B:pi
            bin=bin+1;
            %�·�ѭ�������ݶȷ���
            for k=1:K
                if v_angles(k)<ang_lim
                    v_angles(k)=100;
                    %��ֹ�ظ�ͳ��
                    H2(bin)=H2(bin)+v_magnit(k);
                end
            end
        end
                
        H2=H2/(norm(H2)+0.01); 
        %�������������б�׼������
        H((cont-1)*B+1:cont*B,1)=H2;
        %������cell�����������ϲ����õ�����ͼ�����������
    end
end