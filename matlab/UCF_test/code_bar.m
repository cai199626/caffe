 % ################# Plot Bar Figure ################
% Include : Precision, Recall, F-meature, AUC
% ###################################################
  clc;
  clear;
path = '/home/zpp/caffe-sal/matlab/results/ECSSD-mat/';
dirpath=dir([path '*.mat']);
rr=[];
aFmeasure=[]; 
aAUC=[];
method2 = cell(length(dirpath),1);
for i=1:length(dirpath)
  load([path dirpath(i).name]);
  aFmeasure=[aFmeasure,Fmeasure];
  aAUC=[aAUC,AUC];
  method2{i}=dirpath(i).name(1:end-4);
end
        figure(5);
        barMsra = [aFmeasure' aAUC'];
        bar( barMsra );
        set( gca, 'xtick', 1:1:length(dirpath) ),
        grid on;
        set( gca ,'xticklabels',  method2 , 'fontsize', 24 );
        %title('ECSSD');
        %title('PASCAL-S');
        %title('DUT-OMRON');
        %title('SED1');
        %title('SED2');
        %title('HKU-IS');
        %title('SOD');
        legend('Precision','Recall','Fmeasure','AUC');
grid
