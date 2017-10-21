% Evaluation of MAE
clear all;clc
%% ECSSD
gtpath = '/home/zpp/caffe-sal/matlab/datasets/ECSSD/ECSSD-Mask/';
gtsuffix = '.png';
fprintf('ECSSD\n');
salpath = '/home/zpp/caffe-sal/matlab/results/ECSSD-maps/';
filename = {'16','32','48','64','80','96','BL','BSCA','DCL','DHS','DRFI','DS','DSR','EDFCN','ELD','HDCT','LEGS','MDF','RFCN'};
suffix = {'.png','.png','.png','.png','.png','.png','.png','.png','.png','.png','.png','.png','.png','.png','.png','.png','.png','.png','.jpg'};
for ii = 1 : length(filename)
    mapdir = fullfile([salpath filename{ii}]);    
    mae = CalMeanMAE(mapdir, suffix{ii}, gtpath, gtsuffix,filename{ii});  
end
