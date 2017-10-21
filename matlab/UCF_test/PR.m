clear;
clc;
%########### Calculate PR for Eeach Dataset ############
%% load GT mask
gt_dir = { 'ECSSD', '/home/zpp/caffe-sal/matlab/datasets/ECSSD/ECSSD-Mask/',[],[] 'png'};
%% save mat files
basedir = '/home/zpp/caffe-sal/matlab/results/ECSSD-mat/';
%% load results of testing algorithm
mkdir(basedir);
alg_dir = ...                                           
{
{'Ours', '/home/zpp/caffe-sal/matlab/results/ECSSD-maps/Amulet/', [],'' 'png'};
};
alg_dir_FF = candidateAlgStructure( alg_dir );  
dataset = datasetStructure( gt_dir(1), gt_dir(2) );
[ Pre, Recall, Fmeasure, HitRate , FalseAlarm, AUC ] = performCalcu(dataset,alg_dir_FF); 
save( [ basedir 'Amulet'], 'Pre', 'Recall', 'Fmeasure', 'HitRate', 'FalseAlarm', 'AUC' );

