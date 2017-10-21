function [scores, maxlabel] = classification_demo(im, use_gpu)
% [scores, maxlabel] = classification_demo(im, use_gpu)
%
% Image classification demo using BVLC CaffeNet.
%
% IMPORTANT: before you run this demo, you should download BVLC CaffeNet
% from Model Zoo (http://caffe.berkeleyvision.org/model_zoo.html)
%
% ****************************************************************************
% For detailed documentation and usage on Caffe's Matlab interface, please
% refer to Caffe Interface Tutorial at
% http://caffe.berkeleyvision.org/tutorial/interfaces.html#matlab
% ****************************************************************************
%
% input
%   im       color image as uint8 HxWx3
%   use_gpu  1 to use the GPU, 0 to use the CPU
%
% output
%   scores   1000-dimensional ILSVRC score vector
%   maxlabel the label of the highest score
%
% You may need to do the following before you start matlab:
%  $ export LD_LIBRARY_PATH=/opt/intel/mkl/lib/intel64:/usr/local/cuda-5.5/lib64
%  $ export LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libstdc++.so.6
% Or the equivalent based on where things are installed on your system
%
% Usage:
%  im = imread('../../examples/images/cat.jpg');
%  scores = classification_demo(im, 1);
%  [score, class] = max(scores);
% Five things to be aware of:
%   caffe uses row-major order
%   matlab uses column-major order
%   caffe uses BGR color channel order
%   matlab uses RGB color channel order
%   images need to have the data mean subtracted

% Data coming in from matlab needs to be in the order
%   [width, height, channels, images]
% where width is the fastest dimension.
% Here is the rough matlab for putting image data into the correct
% format in W x H x C with BGR channels:
%   % permute channels from RGB to BGR
%   im_data = im(:, :, [3, 2, 1]);
%   % flip width and height to make width the fastest dimension
%   im_data = permute(im_data, [2, 1, 3]);
%   % convert from uint8 to single
%   im_data = single(im_data);
%   % reshape to a fixed size (e.g., 227x227).
%   im_data = imresize(im_data, [IMAGE_DIM IMAGE_DIM], 'bilinear');
%   % subtract mean_data (already in W x H x C with BGR channels)
%   im_data = im_data - mean_data;

% If you have multiple images, cat them with cat(4, ...)

% Add caffe/matlab to you Matlab search PATH to use matcaffe
if exist('../+caffe', 'dir')
  addpath('..');
else
  error('Please run this demo from caffe/matlab/demo');
end

% Set caffe mode
if exist('use_gpu', 'var') && use_gpu
  caffe.set_mode_gpu();
  gpu_id = 1;  % we will use the first gpu in this demo
  caffe.set_device(gpu_id);
else
  caffe.set_mode_cpu();
end

% Initialize the network using BVLC CaffeNet for image classification
% Weights (parameter) file needs to be downloaded from Model Zoo.
% net_model = '/home/zpp/caffe-segnet/models/REG/deploy.prototxt';
% net_weights = '/home/zpp/caffe-segnet/models/REG/IIAU_regnet_iter_6000.caffemodel';
%   net_model = '/home/zpp/caffe-segnet/models/comnet/deploy.prototxt';
%   net_weights = '/home/zpp/caffe-segnet/models/comnet/comnet_saliency_iter_5000.caffemodel';
%   net_model = '/home/zpp/caffe-segnet/models/comnet/deploy_fly.prototxt';
%   net_weights = '/home/zpp/caffe-segnet/models/comnet/comnet_fly_saliency_iter_32000.caffemodel';
%   net_model = '/home/zpp/caffe-segnet/models/comnet/deploy_deconv.prototxt';
%   net_weights = '/home/zpp/caffe-segnet/models/comnet/comnet_deconv_saliency_iter_15000.caffemodel';
%   net_model = '/home/zpp/caffe-segnet/models/comnet/deploy_minifly.prototxt';
%   net_weights = '/home/zpp/caffe-segnet/models/comnet/comnet_minifly_saliency_iter_34000.caffemodel';
%   net_model = '/home/zpp/caffe-segnet/models/comnet/deploy_tiny.prototxt';
%   net_weights = '/home/zpp/caffe-segnet/models/comnet/comnet_tiny_saliency_iter_5000.caffemodel';
%   net_model = '/home/zpp/caffe-segnet/models/INT_fix/deploy.prototxt';
%   net_weights = '/home/zpp/caffe-segnet/models/INT_fix/IntNet_fix_iter_13000.caffemodel';
  net_model = '/home/zpp/caffe-segnet/models/INT_fix/deploy_gauss.prototxt';
  net_weights = '/home/zpp/caffe-segnet/models/INT_fix/IntNet_fix_gauss_iter_1000.caffemodel';
phase = 'test'; % run with phase test (so that dropout isn't applied)
if ~exist(net_weights, 'file')
  error('Please download CaffeNet from Model Zoo before you run this demo');
end

% Initialize a network
net = caffe.Net(net_model, net_weights, phase);

if nargin < 1
  % For demo purposes we will use the cat image
  %fprintf('using caffe/examples/images/cat.jpg as input image\n');
  %im = imread('../../examples/images/cat.jpg');
  %im = imread('/home/zpp/caffe-segnet/matlab/cvpr17/datasets/ECSSD/ECSSD-Image/0798.jpg');
  im = imread('/home/zpp/caffe-future/data/salicon/images/train2014/COCO_train2014_000000442089.jpg');
  im_gt = imread('/home/zpp/caffe-future/data/salicon/groudtruth/train_gt/gauss/COCO_train2014_000000442089.png');
%   im = imread('/home/zpp/caffe-future/data/salicon/images/train2014/COCO_train2014_000000104454.jpg');
%   im_gt = imread('/home/zpp/caffe-future/data/salicon/groudtruth/train_gt/gauss/COCO_train2014_000000104454.png');
  %COCO_train2014_000000104454.jpg
  %COCO_train2014_000000246723.jpg
  %COCO_train2014_000000480991.jpg
  %COCO_train2014_000000559366.jpg
  %COCO_train2014_000000045071.jpg
  %
%   im = imread('/home/zpp/caffe-future/data/salicon/images/val2014/COCO_val2014_000000279769.jpg');
%   im_gt = imread('/home/zpp/caffe-future/data/salicon/groudtruth/val_gt/gauss/COCO_val2014_000000279769.png');
  %im = imread('/home/zpp/caffe-future/data/THUS/THUS-Image/0_101.jpg');
end
% prepare oversampled input
% input_data is Height x Width x Channel x Num
tic;
input_data = {prepare_image(im)};
toc;

% do forward pass to get scores
% scores are now Channels x Num, where Channels == 1000
tic;
% The net forward function. It takes in a cell array of N-D arrays
% (where N == 4 here) containing data of input blob(s) and outputs a cell
% array containing data from output blob(s)
res = net.forward(input_data);
toc;

%% display
% figure(100)
% for i=1:size(res{1},3)   
%     subplot(1,3,i)
%     imagesc(permute(res{1}(:,:,i),[2 1 3]));
%     subplot(1,3,3)
%     imshow(im)
% end
%% display
 salmap = 255*imresize(permute(res{1}(:,:,1),[2 1 3]),[size(im,1) size(im,2)]);
 sal_overlay = 0.8*double(cat(3,salmap,salmap,salmap)) + 0.2*double(im);
 overlay = 0.8*double(cat(3,im_gt,im_gt,im_gt)) + 0.2*double(im);
figure(100)
subplot(2,2,1)
imshow(im)
subplot(2,2,2)
imagesc(uint8(salmap));
subplot(2,2,3)
imagesc(uint8(overlay))
subplot(2,2,4)
imagesc(uint8(sal_overlay))
% %% display
% figure(200)
% for i=1:size(res{1},3)
%     subplot(4,8,i)
%     imagesc(permute(res{2}(:,:,i),[2 1 3]));
% end
% call caffe.reset_all() to reset caffe
caffe.reset_all();
end
% ------------------------------------------------------------------------
function images = prepare_image(im)
% ------------------------------------------------------------------------
%IMAGE_DIM = 224;
%IMAGE_DIM = 256;
%IMAGE_DIM = 512;
% resize to fixed input size
im = single(im);
%im = imresize(im, [IMAGE_DIM IMAGE_DIM], 'bilinear');
im = imresize(im, [480 640], 'bilinear');
% permute from RGB to BGR (IMAGE_MEAN is already BGR)
%im = 0.00390625*im(:,:,[3 2 1]);
im = im(:,:,[3 2 1]);
im(:,:,1) = im(:,:,1) -104 ;  % subtract mean_data (already in W x H x C, BGR)
im(:,:,2) = im(:,:,2) -117 ;
im(:,:,3) = im(:,:,3) -123 ;
images = permute(im,[2 1 3]);
% ------------------------------------------------------------------------
end