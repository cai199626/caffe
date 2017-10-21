function plotMetrics            = plot_the_curves(alg_params_notexist, Metrics, alg_params_exist, savedir, Dataset)

totalNum                        = size(alg_params_notexist,1) + size(alg_params_exist,1);

%% colors
% if totalNum >11 && totalNum <= 22
%     method_colors               = {
%                                     [56,97,146],[149,57,55],[118,145,64],[97,74,127],...
%                                     [53,132,154],[193,114,48],[69,117,175],[178,70,67],...
%                                     [142,173,78],[116,89,149],[65,159,184],[230,136,59],...
%                                     [121,151,197],[200,121,120],[170,196,126],[151,133,176],...
%                                     [119,183,205],[246,168,115],[176,191,216],[217,177,176],...
%                                     [200,215,179],[190,182,204]
%                                   }';
% elseif totalNum <= 11                            
%     method_colors               = {
%                                     [0,255,0],[128 128 128],[136 0 21],[255 127 39], ...
%                                     [255,0,0],[0 162 232],[163 73 164],[255 0 255], ...
%                                     [0 255 255],[0 0 0],[255 255 0]
%                                   };
% else
%     fprintf('Too many algorithms! (more than 22)\n');
%     fprintf('Please define more kinds of colors or reduce the number!\n');
%     plotMetrics                 = {};
%     return;
% end
 
method_colors = linspecer(9);
method_colors_ = linspecer(totalNum);
%% gather the results
plotMetrics                 = gather_the_results(totalNum, alg_params_notexist, ...
                                        savedir,Metrics,alg_params_exist);
    
%% plot the PR curves
figure(1);
hold on;
grid on;
axis([0 1 0 1]);
title(Dataset);
xlabel('Recall');
ylabel('Precision');

for i = 1 : length(plotMetrics.Alg_names)
    if floor((i-1)/9) == 0
        plot(plotMetrics.Recall(:,i), plotMetrics.Pre(:,i), 'LineWidth', 2, ...
                                                        'Color', method_colors(i,:));
    elseif floor((i-1)/9) == 1
        plot(plotMetrics.Recall(:,i), plotMetrics.Pre(:,i),'--', 'LineWidth', 2, ...
                                                        'Color', method_colors(i-9,:));
    elseif floor((i-1)/9) == 2
        plot(plotMetrics.Recall(:,i), plotMetrics.Pre(:,i),'-.', 'LineWidth', 2, ...
                                                        'Color', method_colors(i-18,:));
    end
end
legend(plotMetrics.Alg_names);
set(gcf,'position',[0 600 560 420]);

%% plot the ROC curves
figure(2);
hold on;
grid on;
axis([0 1 0 1]);
title(Dataset);
xlabel('FPR');
ylabel('TPR');

for i = 1 : length(plotMetrics.Alg_names)
    if floor((i-1)/9) == 0
        plot(plotMetrics.FPR(:,i), plotMetrics.TPR(:,i), 'LineWidth', 2, ...
                                                        'Color', method_colors(i,:));
    elseif floor((i-1)/9) == 1
        plot(plotMetrics.FPR(:,i), plotMetrics.TPR(:,i),'--', 'LineWidth', 2, ...
                                                        'Color', method_colors(i-9,:));
    elseif floor((i-1)/9) == 2
        plot(plotMetrics.FPR(:,i), plotMetrics.TPR(:,i),'-.', 'LineWidth', 2, ...
                                                        'Color', method_colors(i-18,:));
    end
end
legend(plotMetrics.Alg_names);
set(gcf,'position',[580 600 560 420]);

%% plot the F-measure curves
figure(3);
hold on;
grid on;
axis([0 255 0 1]);
title(Dataset);
xlabel('Threshold');
ylabel('F-measure');
x = [255:-1:0]';
for i = 1 : length(plotMetrics.Alg_names)
    if floor((i-1)/9) == 0
        plot(x, plotMetrics.Fmeasure_Curve(:,i), 'LineWidth', 2, ...
                                                            'Color', method_colors(i,:));
    elseif floor((i-1)/9) == 1
        plot(x, plotMetrics.Fmeasure_Curve(:,i), '--' ,'LineWidth', 2, ...
                                                            'Color', method_colors(i-9,:));
    elseif floor((i-1)/9) == 2
        plot(x, plotMetrics.Fmeasure_Curve(:,i), '-.' ,'LineWidth', 2, ...
                                                            'Color', method_colors(i-18,:)); 
    end
end
legend(plotMetrics.Alg_names);
set(gcf,'position',[1160 600 560 420]);
%% plot the MAE scores
% figure(3);
% hold on;
% grid on;
% title(Dataset);
% xlabel('Models');
% ylabel('MAE');
% axis([0 length(plotMetrics.Alg_names)+1 0 max(plotMetrics.MAE)+0.05]);
% data    = diag(plotMetrics.MAE);
% for i = 1 : length(plotMetrics.Alg_names)
%     x   = bar(data(:,i));
%     set(x, 'FaceColor', method_colors_(i,:));
%     set(x, 'EdgeColor', method_colors_(i,:));
% end
% set(gca,'xtick',[0:length(plotMetrics.Alg_names)+1]');
% set(gca,'xticklabel',{' ', plotMetrics.Alg_names{:}, ' '});
% set(gcf,'position',[1160 600 560 420]);

%% plot the Fmeasure scores
figure(4);
hold on;
grid minor;
title(Dataset);
xlabel('Models');
ylabel('Scores');
if length(plotMetrics.Alg_names) >1
    axis([0 length(plotMetrics.Alg_names)+1 0 1]);
    b = bar([plotMetrics.Fmeasure' plotMetrics.AUC' plotMetrics.MAE']);
    set(b(1),'FaceColor',method_colors(1,:));
    set(b(1),'EdgeColor',method_colors(1,:));
    set(b(2),'FaceColor',method_colors(3,:));
    set(b(2),'EdgeColor',method_colors(3,:));
    set(b(3),'FaceColor',method_colors(5,:));
    set(b(3),'EdgeColor',method_colors(5,:));
    set(b(4),'FaceColor',method_colors(7,:));
    set(b(4),'EdgeColor',method_colors(7,:));
    set(b(5),'FaceColor',method_colors(9,:));
    set(b(5),'EdgeColor',method_colors(9,:));
    
    set(gca,'xtick',[0:length(plotMetrics.Alg_names)+1]');
    set(gca,'xticklabel',{' ', plotMetrics.Alg_names{:}, ' '});
    legend('Precision','Recall','F-measure','AUC','MAE');
else
    axis([0 length(plotMetrics.Alg_names)+1 0 1]);
    b = bar([[plotMetrics.Fmeasure; plotMetrics.AUC; plotMetrics.MAE],[0;0;0;0;0]]');
    set(b(1),'FaceColor',method_colors(1,:));
    set(b(1),'EdgeColor',method_colors(1,:));
    set(b(2),'FaceColor',method_colors(3,:));
    set(b(2),'EdgeColor',method_colors(3,:));
    set(b(3),'FaceColor',method_colors(5,:));
    set(b(3),'EdgeColor',method_colors(5,:));
    set(b(4),'FaceColor',method_colors(7,:));
    set(b(4),'EdgeColor',method_colors(7,:));
    set(b(5),'FaceColor',method_colors(9,:));
    set(b(5),'EdgeColor',method_colors(9,:));

    set(gca,'xtick',[0:length(plotMetrics.Alg_names)+1]');
    set(gca,'xticklabel',{' ', plotMetrics.Alg_names{:}, ' '});
    legend('Precision','Recall','F-measure','AUC','MAE');
end
set(gcf,'position',[0 0 560 420]);


function plotMetrics     = gather_the_results(totalNum, alg_params_notexist, savedir,Metrics,alg_params_exist)

alg_names                                   = cell(totalNum,1); 
thrNum                                      = 256;
plotMetrics.TPR                             = zeros(thrNum,totalNum);
plotMetrics.FPR                             = zeros(thrNum,totalNum);
plotMetrics.Pre                             = zeros(thrNum,totalNum);
plotMetrics.Recall                          = zeros(thrNum,totalNum);
plotMetrics.Fmeasure                        = zeros(3,totalNum);
plotMetrics.HitRate                         = zeros(thrNum,totalNum);
plotMetrics.FalseAlarm                      = zeros(thrNum,totalNum);
plotMetrics.AUC                             = zeros(1,totalNum);
plotMetrics.MAE                             = zeros(1,totalNum);

% gather the new results
for i = 1 : size(alg_params_notexist,1)
    alg_names{i}                            = alg_params_notexist{i,1};
    plotMetrics.TPR(:,i)                    = Metrics.TPR(:,i);
    plotMetrics.FPR(:,i)                    = Metrics.FPR(:,i);
    plotMetrics.Pre(:,i)                    = Metrics.Pre(:,i);
    plotMetrics.Recall(:,i)                 = Metrics.Recall(:,i);
    plotMetrics.Fmeasure(:,i)               = Metrics.Fmeasure(:,i);
    plotMetrics.HitRate(:,i)                = Metrics.HitRate(:,i);
    plotMetrics.FalseAlarm(:,i)             = Metrics.FalseAlarm(:,i);
    plotMetrics.AUC(:,i)                    = Metrics.AUC(:,i);
    plotMetrics.MAE(:,i)                    = Metrics.MAE(i);    
end

% gather the existing results
for i = size(alg_params_notexist,1)+1 : totalNum
    alg_names{i}                            = alg_params_exist{i-size(alg_params_notexist,1),1};
    Metrics                                 = load([savedir,alg_names{i},'.mat']);
    plotMetrics.TPR(:,i)                    = Metrics.TPR;
    plotMetrics.FPR(:,i)                    = Metrics.FPR;
    plotMetrics.Pre(:,i)                    = Metrics.Pre;
    plotMetrics.Recall(:,i)                 = Metrics.Recall;
    plotMetrics.Fmeasure(:,i)               = Metrics.Fmeasure;
    plotMetrics.HitRate(:,i)                = Metrics.HitRate;
    plotMetrics.FalseAlarm(:,i)             = Metrics.FalseAlarm;
    plotMetrics.AUC(:,i)                    = Metrics.AUC;
    plotMetrics.MAE(:,i)                    = Metrics.MAE;
end
    plotMetrics.Fmeasure_Curve              = (1+0.3).*plotMetrics.Pre.*plotMetrics.Recall./...
                                                (0.3*plotMetrics.Pre+plotMetrics.Recall);
    plotMetrics.Alg_names                   = alg_names;