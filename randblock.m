function B=randblock(imageSize,blockSize,blockNum)
%% this function generates square templates

temp=imageSize(1)/blockSize(1);
blockTotal=prod(imageSize)/prod(blockSize); 
blockIndex=randperm(blockTotal);
blockIndex=blockIndex(:,1:blockNum);
zeroMetric=zeros(imageSize);
for i=1:blockNum
    r=floor(blockIndex(i)/temp);
    c=blockIndex(i)-r*temp;
    if c==0
         zeroMetric(blockSize(1)*(r-1)+1:blockSize(1)*r,imageSize(2)-blockSize(1)+1:imageSize(2))=1;
    else
         zeroMetric(blockSize(1)*r+1:blockSize(1)*(r+1),blockSize(1)*(c-1)+1:blockSize(1)*c)=1;
    end
    B(:,i)=reshape(zeroMetric,prod(imageSize),1);
    zeroMetric=zeros(imageSize);
end
    