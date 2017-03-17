
%% Copyright (C) Ziyang Xiao.
%% All rights reserved.

clc;
clear;

addpath('./Basis Functions');     
addpath('./Evaluation');    
%%******All the sequences you wish to run******%%
fileName_cell{1} = 'boy'; 
fileName_cell{2} = 'car4';  
fileName_cell{3} = 'car11';     
fileName_cell{4} = 'caviar2';     
fileName_cell{5} = 'davidoutdoor'; 
fileName_cell{6} = 'deer';  
fileName_cell{7} = 'face';       
fileName_cell{8} = 'football'; 
fileName_cell{9} = 'jumping'; 
fileName_cell{10} = 'occlusion1'; 
%%******All the sequences you wish to run******%%

%for vNum=1:10; 
for vNum=1;
title=fileName_cell{vNum};
SetParameters;                     %%set affine parameters
dataPath = ['.\Data\' title '\'];

%%******************** initialize variables*****************************************************
if ~exist('opt','var')        opt = [];  end
if ~isfield(opt,'tmplsize')   opt.tmplsize = [32,32];  end                  %%size of image patch
if ~isfield(opt,'numsample')  opt.numsample = 600;  end                     %%sample number
if ~isfield(opt,'affsig')     opt.affsig = [4,4,.02,.02,.005,.001];  end    %%motion model
if ~isfield(opt,'condenssig') opt.condenssig = 0.01;  end                   %%variance
if ~isfield(opt,'maxbasis')   opt.maxbasis = 16;  end                       %%the maximum number of PCA basis
if ~isfield(opt,'batchsize')  opt.batchsize = 5;  end                       %%the number of accumlated patches
if ~isfield(opt,'ff')         opt.ff = 1.0;  end                            %%forgetting factor
if ~isfield(opt,'title')      opt.title = title;    end                     %%Title
if ~isfield(opt,'errRatio')   opt.errRatio = [];    end                     %%error Ratio
if ~isfield(opt,'OccMatrix')  opt.OccMatrix= [];    end 

if ~isfield(opt,'blockSizeSmall') opt.blockSizeSmall=[2,2]; end             %%size of square template 
if ~isfield(opt,'blockNumSmall') opt.blockNumSmall=256; end                 %%number of square template 

%%threshold of update
%%the occluded ratio is higher than opt.threshold.high => not update
%%the occluded ratio is lower than opt.threshold.low  => direct update
%%the occluded ratio is between opt.threshold.high and opt.threshold.low=> partial update
if  ~isfield(opt,'threshold') 
    opt.threshold.high = 0.6;
    opt.threshold.low  = 0.1;
end
%%*************************************************************************

%%**************************initial affine parameters*****************************%%
rand('state',0);  randn('state',0); 
temp = importdata([dataPath 'datainfo.txt']);
LoopNum = temp(3);%number of frames
frame = imread([dataPath '1.jpg']);
if  size(frame,3) == 3
    framegray = double(rgb2gray(frame))/255;
else
    framegray = double(frame)/255;
end
%%  p = [px, py, sx, sy, theta];  
param0 = [p(1), p(2), p(3) /opt.tmplsize(1), p(5), p(4)/p(3), 0];      
param0 = affparam2mat(param0);
%%**************************initial affine parameters*****************************%%

%%************************** tracking ********************************%%
%% extract image patch of the target from the first frame
tmpl.mean = warpimg(framegray, param0, opt.tmplsize);   %%mean    
tmpl.basis = [];                                        %%basis
tmpl.eigval = [];                                       %%eigen value
tmpl.numsample = 0;                                     %%sample number
sz = size(tmpl.mean);  
N = sz(1)*sz(2);                                        %%feature demension
param = [];
param.est = param0;                                     %%affine parameters estimation
param.wimg = tmpl.mean;                                 %%storage of the 


% draw initial track window    
drawopt = drawtrackresult([], 0, frame, tmpl, param);

wimgs = [ ];

% track the sequence from frame 2 onward
duration = 0; 
tic;
result = [];
P=[];
lambda=5e-6;
B=randblock(sz,opt.blockSizeSmall,opt.blockNumSmall);%% generate squre templates
for f = 1:LoopNum
    CurrentFrame=f
    frame = imread([dataPath int2str(f) '.jpg']);
    if  size(frame,3) == 3
        framegray = double(rgb2gray(frame))/255;
    else
        framegray = double(frame)/255;
    end
    
    %% do tracking
    opt.frameNum = f;
    [param,opt] = L2_Tracker(framegray, tmpl, param, opt,P,B);
    result = [ result; param.est' ];
    if param.wimg~=zeros(opt.tmplsize(1),opt.tmplsize(2));
       wimgs= [wimgs, param.wimg(:)];   
    end
  
    %%Update Model
    if  (size(wimgs,2) >= opt.batchsize)  
        %%(1)Incremental SVD
        [tmpl.basis, tmpl.eigval, tmpl.mean, tmpl.numsample] = ...
        sklm(wimgs, tmpl.basis, tmpl.eigval, tmpl.mean, tmpl.numsample, opt.ff);  
        %%(2)Clear Data Buffer
        wimgs = [];     
        %%(3)Keep "opt.maxbasis" Number Basis Vectors
        if  (size(tmpl.basis,2) > opt.maxbasis)          
            tmpl.basis  = tmpl.basis(:,1:opt.maxbasis);   
            tmpl.eigval = tmpl.eigval(1:opt.maxbasis);    
            W=tmpl.basis;
            Mu=tmpl.mean;
        end

        D=[tmpl.basis,B]; %dictionay 
        P=inv(D'*D+lambda*eye(size(D,2)))*D';% project matrix
    end
end
duration = duration + toc;
fprintf('%d frames took %.3f seconds : %.3ffps\n',f,duration,f/duration);
fps =f/duration;
save([ title '_OriginalRs.mat'], 'result');

%% 
TotalFrameNum=LoopNum;
L2RLSCenterAll  = cell(1,TotalFrameNum);      
L2RLSCornersAll = cell(1,TotalFrameNum);
for num = 1:TotalFrameNum
    if  num <= size(result,1)
        est = result(num,:);
        [ center corners ] = p_to_box([32 32], est);
    end
    L2RLSCenterAll{num}  = center;      
    L2RLSCornersAll{num} = corners;
end
%%*************************3.STD Results*****************************%%
load([dataPath,title '_gt.mat']);
[ overlapRate ] = overlapEvaluationQuad(L2RLSCornersAll, gtCornersAll, frameIndex);
mOverlapRate = mean(overlapRate)
mSuccessRate = sum(overlapRate>0.5)/length(overlapRate)
[ centerError ] = centerErrorEvaluation(L2RLSCenterAll, gtCenterAll, frameIndex);
mCenterError = mean(centerError)
save([ title '_L2RLS.mat'],'L2RLSCenterAll', 'L2RLSCornersAll', 'fps','mCenterError','mOverlapRate','mSuccessRate');

displayRs;
end
