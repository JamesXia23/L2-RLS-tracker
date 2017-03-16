%*************************************************************
%% Copyright (C) Wei Zhong.
%% All rights reserved.
%% Thanks to Wei Zhong for the codes.  

%%**************************************************************
temp      = importdata([ '.\Data\' title '\' 'dataInfo.txt' ]);
imageSize = [ temp(2) temp(1) ];

trackResult     = load([ title '_OriginalRs.mat']);
frameNum  = size(trackResult.result, 1);

figure('position',[ 100 100 imageSize(2) imageSize(1) ]); 
set(gcf,'DoubleBuffer','on','MenuBar','none');


for num = 1:frameNum
    framePath = [ '.\Data\' title '\'  int2str(num) '.jpg'];
    imageRGB  = imread(framePath);
    axes(axes('position', [0 0 1.0 1.0]));
    imshow(imageRGB);
    hold on; 
    numStr = sprintf('#%03d', num);
    text(10,20,numStr,'Color','r', 'FontWeight','bold', 'FontSize',20);

    if  num<=size(trackResult.result,1)
        color = [ 1 0 0 ];
        est = trackResult.result(num,:);
        [ center corners ] = drawbox2([32 32], est, 'Color', color, 'LineWidth', 2.5);
    end
    
    axis off;
    hold off;
    drawnow;
    savePath = sprintf(['Results/%s/RS_%04d.jpg'], opt.title,num);
    if ~isdir(['Results/',title,'/'])
        mkdir(['Results/',title,'/'])
    end 
    imwrite(frame2im(getframe(gcf)),savePath);
    clf;
end