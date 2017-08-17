% if exist('HOGLSH.mat','file')
%     load HOGLSH;
%     load FeaturesColor;
%     load PicStore;
%     load FeaturesTexture;
%     load FeaturesHOG;
% else
%     load FeaturesHOG;
%     load FeaturesColor;
% %     load FeaturesTexture;
%     load PicStore;
%     
%     FeaturesHOG = FeaturesHOG*255;
%     HOGLSH = lsh('lsh',20,40,size(FeaturesHOG,1),FeaturesHOG,'range',255);
%     
%     FeaturesColor = FeaturesColor*10000;
%     ColorLSH = lsh('lsh',40,200,size(FeaturesColor,1),FeaturesColor,'range',10000)
% end

% save PicStore Pictures;
% save PicLSH PicLSH;
% save FeaturePatches FeaturePatches;

currentPic = imread('crayfish1.jpg');
currentHOGFeature = HOG(currentPic)*255;
currentColorFeature = getcolorMom(currentPic)*10000;
% currentTextureFeature = getTexture(currentPic);

tic;
[nnlshHOG,numcandHOG]=lshlookup(currentHOGFeature,FeaturesHOG,HOGLSH,'k',100,'distfun','lpnorm','distargs',{1});
[nnlshColor,numcandColor]=lshlookup(currentColorFeature,FeaturesColor,ColorLSH,'k',100,'distfun','lpnorm','distargs',{1});
toc;

nnlsh = intersect(nnlshHOG,nnlshColor);
n = max(size(nnlsh));

PointNum = zeros(2,n);
for i = 1:n
    PointNum(1,i) = match(Pictures{nnlsh(i)}, currentPic);
    PointNum(2,i) = nnlsh(i);
%     disp(PointNum(1,i));
end

for i = 1:n
    maxIndex = PointNum(2,i);
    maxNum = PointNum(1,i);
    position = i;
    
    for j = i:n
        if PointNum(1,j) > maxNum
            maxIndex = PointNum(2,j);
            maxNum = PointNum(1,j);
            position = j;
        end
    end
    
%     disp(i);
%     disp(maxNum);
    tmpI = PointNum(2,i);
    PointNum(2,i) = maxIndex;
    PointNum(2,position) = tmpI;
    
    tmpN = PointNum(1,i);
    PointNum(1,i) = maxNum;
    PointNum(1,position) = tmpN;
end
% currentTextureFeature = currentTextureFeature*100;
% FeaturesTexture = FeaturesTexture*100;
% 
% for i = 1:n
% %     minIndex = i;
% %     tmpTextures = FeaturesTexture(:,nnlsh(i))';
% %     minDistance = EulerCalculate(currentTextureFeature,tmpTextures);
% %     
% %     for j = i:n
% %         tmpTextures = FeaturesTexture(:,nnlsh(j))';
% %         if EulerCalculate(currentTextureFeature,tmpTextures) < minDistance
% %             minIndex = j;
% %             minDistance = EulerCalculate(currentTextureFeature',tmpTextures);
% %         end
% %     end
% %     
% %     tmp = nnlsh(i);
% %     nnlsh(i) = nnlsh(minIndex);
% %     nnlsh(minIndex) = tmp;
%     minIndex = i;
%     tmpTextures = FeaturesTexture(:,nnlsh(i));
%     minDistance = currentTextureFeature(1) - tmpTextures;
%     
%     for j = i:n
%         tmpTextures = FeaturesTexture(1,nnlsh(j));
%         if currentTextureFeature(1) - tmpTextures < minDistance
%             minIndex = j;
%             minDistance = currentTextureFeature(1) - tmpTextures;
%         end
%     end
%     
%     tmp = nnlsh(i);
%     nnlsh(i) = nnlsh(minIndex);
%     nnlsh(minIndex) = tmp;
% end

% if n > 10
%     n = 10;
% end

for k = 1:n
    figure(k);
    imshow(Pictures{PointNum(2,k)});
%     disp(nnlsh(k));
end

% figure(1);
% clf;
% for k=1:10, subplot(2,5,k);imshow(Pictures(k)); colormap gray;axis image; end