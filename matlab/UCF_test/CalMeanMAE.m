function mae = CalMeanMAE(SRC, srcSuffix, GT, gtSuffix,method)
% Code Author: Wangjiang Zhu
% Email: wangjiang88119@gmail.com
% Date: 3/24/2014
% files = dir(fullfile(SRC, strcat('*', srcSuffix)));
files = dir(fullfile(GT, strcat('*', gtSuffix)));
if isempty(files)
    error('No saliency maps are found: %s\n', fullfile(SRC, strcat('*', srcSuffix)));
end

MAE = zeros(length(files), 1);
parfor k = 1:length(files)
%for k = 1:length(files)
    srcName = [files(k).name(1:end-4) srcSuffix];
    srcImg = imread(fullfile(SRC, srcName));
    
    gtName = strrep(srcName, srcSuffix, gtSuffix);
    gtImg = imread(fullfile(GT, gtName));
    if size(srcImg,1)~=size(gtImg,1)||size(srcImg,2)~=size(gtImg,2)
       srcImg = imresize(srcImg,[size(gtImg,1) size(gtImg,2)]); 
    end
    MAE(k) = CalMAE(srcImg, gtImg);
end

mae = mean(MAE);
fprintf('MAE for %s: %f\n', method, mae);