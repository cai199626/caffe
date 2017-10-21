% ################# Plot PR Figure ################
% X-axis: Recall
% Y-axis: Precision
% ###################################################
clc;
clear;
basedir = '/home/zpp/caffe-segnet/matlab/results/ECSSD-mat/';
dirpath=dir([basedir '*.mat']);
str=['r','r','r','g','g','g','b','b','b','c','c','c','m','m','m','y','y','y','k','k','k','g','g','b','b','m','m','k','k','r','r','b','b','c','c','m','m'];
rr=[];
for i=1:length(dirpath)
  %  load([path num2str(aa(i)) '-filter.mat']);
  load([basedir dirpath(i).name]);
  if mod(i,3)==0
    plot(Recall,Pre,[str(i) ':'],'linewidth',2.5);
  elseif mod(i,3)==1
    plot(Recall,Pre,[str(i) '-'],'linewidth',2.5);
  elseif mod(i,3)==2
    plot(Recall,Pre,[str(i) '--'],'linewidth',2.5);
  end
    hold on;
   display([dirpath(i).name(1:end-4)])% '----' num2str(a)]);
   aa(i)= AUC;
   rr=[rr;Recall;Pre];
  %  dirpath(i).name
 %  display(num2str(max(pM)));
end
%title('ECSSD');
%title('PASCAL-S');
%title('DUT-OMRON');
%title('SOD');
%title('SED1');
%title('SED2');
%title('HKU-IS');
xlabel('Recall');
ylabel('Precision');

legend(dirpath(1).name(1:end-4),dirpath(2).name(1:end-4),dirpath(3).name(1:end-4),dirpath(4).name(1:end-4),...
    dirpath(5).name(1:end-4),dirpath(6).name(1:end-4),dirpath(7).name(1:end-4),dirpath(8).name(1:end-4),...
    dirpath(9).name(1:end-4),dirpath(10).name(1:end-4),dirpath(11).name(1:end-4));
grid
set( gca , 'fontsize', 24 );
save pr AUC;
