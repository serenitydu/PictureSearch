% Readimage('images/*.jpg','images/');

load PicStore;

num = (numel(Pictures)/2)+100;

imgTmp = Pictures{1};

tmpHOG = HOG(imgTmp);
[l w] = size(tmpHOG);

FeaturesHOG = zeros(l,num);
FeaturesHOG(:,1) = tmpHOG;

tmpColor = getcolorMom(imgTmp);

FeaturesColor = zeros(225,num);
FeaturesColor(:,1) = tmpColor;

% tmpTexture = getTexture(imgTmp);
% FeaturesTexture = zeros(8,num);
% FeaturesTexture(:,1) = tmpTexture';

for i = 2:num
    imgTmp = Pictures{i};
    
    tmpHOG = HOG(imgTmp);
    FeaturesHOG(:,i) = tmpHOG;
    
    tmpColor = getcolorMom(imgTmp);
    FeaturesColor(:,i) = tmpColor;
    
%     tmpTexture = getTexture(imgTmp);
%     FeaturesTexture(:,i) = tmpTexture';
    
    disp(i);
end

% save PicStore Pictures;
save FeaturesHOG FeaturesHOG;
save FeaturesColor FeaturesColor;
% save FeaturesTexture FeaturesTexture;