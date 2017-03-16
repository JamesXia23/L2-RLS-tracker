function [param,opt] = L2_Tracker(frm, tmpl, param, opt,Dic,B)


%%Sampling Number
n = opt.numsample;
%%Data Dimension
sz = size(tmpl.mean);
N = sz(1)*sz(2);
%%Affine Parameter Sampling
param.param = repmat(affparam2geom(param.est(:)), [1,n]);
randMatrix = randn(6,n);
param.param = param.param + randMatrix.*repmat(opt.affsig(:),[1,n]);
%%Extract or Warp Samples which are related to above affine parameters
wimgs = warpimg(frm, affparam2mat(param.param), sz);
%%Remove the average vector or Centralizing
diff = repmat(tmpl.mean(:),[1,n]) - reshape(wimgs,[N,n]);
%threshold of update
errThreshold=0.05;
P=Dic;
  

if  (size(tmpl.basis,2) > 0)
    if  (size(tmpl.basis,2) == opt.maxbasis)
        alpha = zeros(size(P,1),n);
        alpha= P*diff; 
        coeff = alpha(1:size(tmpl.basis,2),:);      %The coefficients of PCA Basis
        alphaOcc= alpha(size(tmpl.basis,2)+1:end,:);    %The coefficients of Trivial Templates
        err=B*alphaOcc(1:size(B,2),:);              % Error estimation
        diff = diff-tmpl.basis*coeff-err;           %Reconstruction           
        diff = diff.*(abs(err)<errThreshold);  
     param.conf = exp(-(sum(diff.^2)+0.05*sum(abs(err)))./0.1)';
    else
        coef = tmpl.basis'*diff;
        diff = diff - tmpl.basis*coef;
        param.conf = exp(-sum(diff.^2)./opt.condenssig)';
    end
else
    param.conf = exp(-sum(diff.^2)./opt.condenssig)';
end

%%MAP or Particle Filter
param.conf = param.conf ./ sum(param.conf);
[maxprob,maxidx] = max(param.conf);
param.est = affparam2mat(param.param(:,maxidx));


%%update according to the error ratio
if  (size(tmpl.basis,2) == opt.maxbasis)
    alphaOcc= abs(alpha(size(tmpl.basis,2)+1:end,maxidx)); 
    Occ=B*alphaOcc(1:size(B,2));
    Occ=255*abs(Occ);
 
    errRatio = sum(Occ>errThreshold*255)/length(Occ);
    opt.OccMatrix=[opt.OccMatrix, Occ];
    opt.errRatio = [ opt.errRatio, errRatio ];

    wimg = wimgs(:,:,maxidx);
    
    %%Reconstrution
    coeff = alpha(1:size(tmpl.basis,2),maxidx);     
    rec   = tmpl.basis*coeff;
    rec   = reshape(rec,size(wimg));
    rec   = rec + tmpl.mean;

    if  (errRatio < opt.threshold.low)
        param.wimg = wimg;
        return;
    end
    
    if  (errRatio > opt.threshold.high)
        param.wimg =zeros(opt.tmplsize(1),opt.tmplsize(2));
        return;
    end
    
    if  ((errRatio>opt.threshold.low) && (errRatio<opt.threshold.high))
        param.wimg = (1-(Occ>errThreshold*255)).*wimg(:) + (Occ>errThreshold*255).*tmpl.mean(:);
        param.wimg = reshape(param.wimg,size(wimg));
    end  
else
    param.wimg = wimgs(:,:,maxidx);
end
